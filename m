Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 222392EC6C2
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 00:19:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727912AbhAFXTR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 18:19:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727877AbhAFXTL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 18:19:11 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0F5CC06135A
        for <netdev@vger.kernel.org>; Wed,  6 Jan 2021 15:18:02 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id p22so5894236edu.11
        for <netdev@vger.kernel.org>; Wed, 06 Jan 2021 15:18:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=y4su5mRJeL7lcVdGeCkPLkZrBkKn3R8c9JM0amouMgI=;
        b=ZbTvy4Kti5LPSpUCLvxw2hoSy19aDWxANKc2wJetlptsxHeosbidQws7WaoI40QCQG
         71CO24+Go2/rNCo3mwme9COaDkZiGEHLXTg8rhQ+8+sWD04b33FXzXtuIp4IDowq3AlT
         5ALXjLyQ6FQnInowxw6jsnSra+eZqo8uGQT7jIVvsvUv/pn9p7L2gtQhkHJfstuRD9Fx
         NtPpaU54QGbRYSNvldlyK9iEqPLWo1McF4zxlQzujWN7PC69Q6l0kwzUE/536WnpKv0n
         b8aHzWUYGIpl3ozX8xCyDo//b+dHEIkC5Cf6smmD+eJZUDyriKHYGjhXyFute4XIaEPO
         eNSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y4su5mRJeL7lcVdGeCkPLkZrBkKn3R8c9JM0amouMgI=;
        b=YDTiguT5zHQL03W8sm215xd9egkzsVNZx50dNAjc4laVjVjlLEQj9iVJUKjGpWK13f
         DBovUepdAoJxpmBFgTpB+/5DDJcKGdvWxorO9EYepCGKHxO6gVSFNhuERLxPqyqn71F9
         DD/SuHcjUmSu6kO6FbmkfQNANMR3RYG4fGNmHfhm2ymLmKPqyYtcjyrayrBidv3lHPCo
         kbgrnqnsMotx3frd6qkZ77KG54ZRSVGnZjWhdpvLfPKghxmfOHUk3RTx+6ASWH84tkIE
         vkrCHM+ggZVKnoh/0XAk7liHVHJ7hkSIG14/iiM9tDPFAPMHQxdJntSniP7dseMxsURf
         PcmA==
X-Gm-Message-State: AOAM532mYeUBwZaQJ2Is/HLK3BqwpigOttnbXZmxViRmEUCyT45WABBY
        ucAv5jw3PRjf0dd2gB0H5Z8=
X-Google-Smtp-Source: ABdhPJxty743CmbAS73U2FlE40Vd7quB5PjtwrrSV9t/t7NjNcPCAp2S5AcKyfkrN/CJ8AyqpPr2cg==
X-Received: by 2002:a05:6402:1a2f:: with SMTP id be15mr5558544edb.209.1609975081647;
        Wed, 06 Jan 2021 15:18:01 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id a6sm1958263edv.74.2021.01.06.15.18.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 15:18:01 -0800 (PST)
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
Subject: [PATCH v3 net-next 09/11] net: dsa: remove obsolete comments about switchdev transactions
Date:   Thu,  7 Jan 2021 01:17:26 +0200
Message-Id: <20210106231728.1363126-10-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210106231728.1363126-1-olteanv@gmail.com>
References: <20210106231728.1363126-1-olteanv@gmail.com>
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
Changes in v3:
None.

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

