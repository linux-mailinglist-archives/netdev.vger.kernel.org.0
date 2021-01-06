Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C47E02EBE51
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 14:11:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbhAFNLj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 08:11:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726439AbhAFNLi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 08:11:38 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A809C06135F
        for <netdev@vger.kernel.org>; Wed,  6 Jan 2021 05:10:31 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id y24so4292061edt.10
        for <netdev@vger.kernel.org>; Wed, 06 Jan 2021 05:10:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7y/AWARlC0SfYNtW9no7XIENGToj9zK6j7J53BXQxNM=;
        b=vgqBLloFpZEI+mEUA7MZXNQsMj4UZm23QFlpiS/yTAcN3oX2vSL0oG6336v3eRUHvJ
         4suvTC/T50FqSzgWjGRNDEjsd7k3hkf7Jn2Xp+OgRXug8tcAxZSL4f8x5JENYqCY/zqG
         svALDaFrNZNNBdyJ4Tl0YMIjQFXU17LhN//7P7uUuKMiiRqttZtbY0tkrxK51LXm5/aI
         9+KKflesWbW2qxsormM7tvIKQHZGdf0qUk0K+Uj6M9MS4h25wNuy1rJ19s3h7hgcvnWC
         I9BSIAtO43DP90HbPRy6C3/oJjh+LZdwInOn4KiYLLslfOE1q2lZBS24QtUA83JVsC9Z
         os5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7y/AWARlC0SfYNtW9no7XIENGToj9zK6j7J53BXQxNM=;
        b=uKzPEUXcOT0Mi3C60cGc8pZ8lDJWOcOTHUG0oCW4hHeF8kSzc7EIHXXwhNFbBf8GoQ
         DMQLLERCF0//D1bYn1TSAnQdE1JKPKZq04ja88q+zifNxGgZNBns6092swuh86veN3w0
         Tr2rPvmS5KzeEyDK8NLXyJTeaSq4nfUm4wN4cSeTMY/26RGIq7TZFiKAQr3s3Kx7iHkK
         HLVJEMzqpavJ92+QMEvYwAEti4z6isyZSA/2MIVhJkXNJjM91sUshstTQJwO96J0JsEK
         eTlRgAZhUKVxNpPyL1Pww+THQstKKhV3W99ddM2Y+LIY2JvkGPJ9kPqBZXfvIMON7NGp
         24Zw==
X-Gm-Message-State: AOAM532lYBqPUYZdz+tmWthrGXNvr2Lbs+JD6OVtyWGXHkYzSlldZl74
        lUuOgOR4moO6RE2wPlhc/YvzYpR77GoOqQ==
X-Google-Smtp-Source: ABdhPJxpmKnQ9I4InQ3nBSWeADTgJlnKF+7uL8yNR/bO8YTuFV9WwDwOzt/zBbzntp3bHzKLquhMlA==
X-Received: by 2002:a50:8e19:: with SMTP id 25mr3901447edw.263.1609938629991;
        Wed, 06 Jan 2021 05:10:29 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id p22sm1241858ejx.59.2021.01.06.05.10.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 05:10:29 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>
Subject: [PATCH v2 net-next 08/10] net: dsa: remove obsolete comments about switchdev transactions
Date:   Wed,  6 Jan 2021 15:10:04 +0200
Message-Id: <20210106131006.577312-9-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210106131006.577312-1-olteanv@gmail.com>
References: <20210106131006.577312-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Now that all port object notifiers were converted to be non-transactional,
we can remove the comments that say otherwise.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Jiri Pirko <jiri@nvidia.com>
---
Changes in v2:
None.

 net/dsa/slave.c  | 5 -----
 net/dsa/switch.c | 4 ----
 2 files changed, 9 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 4f0aae1192e5..963607547ab3 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -373,11 +373,6 @@ static int dsa_slave_port_obj_add(struct net_device *dev,
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	int err;
 
-	/* For the prepare phase, ensure the full set of changes is feasable in
-	 * one go in order to signal a failure properly. If an operation is not
-	 * supported, return -EOPNOTSUPP.
-	 */
-
 	switch (obj->id) {
 	case SWITCHDEV_OBJ_ID_PORT_MDB:
 		if (obj->orig_dev != dev)
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index f92eaacb17cf..21d2f842d068 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -298,10 +298,6 @@ static int dsa_switch_event(struct notifier_block *nb,
 		break;
 	}
 
-	/* Non-switchdev operations cannot be rolled back. If a DSA driver
-	 * returns an error during the chained call, switch chips may be in an
-	 * inconsistent state.
-	 */
 	if (err)
 		dev_dbg(ds->dev, "breaking chain for DSA event %lu (%d)\n",
 			event, err);
-- 
2.25.1

