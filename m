Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA9D12EFBFC
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 01:03:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbhAIADm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 19:03:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726443AbhAIADf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 19:03:35 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BEE1C061793
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 16:02:27 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id ga15so16821669ejb.4
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 16:02:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NPBHPuzaf/+nyn5ga7U5YD4f7nfe2EXeI8cs0L23BX4=;
        b=Vb8gM8jFFNKaJ7k6OOquPO2Un9dguVyxS+V2v5x88IE/47BM4C4pyAs++dLuBPhC3W
         AawfWExxS6dj/GahV8XX2011S6xLgIut/IXIzSwRSB2/idjnuyJokGVfo56NUpfVZe4l
         rbUBqmzqO3vF/TMOSNfX9Mm/5lAG3RUzMjosw3kxafLji5b3iEqiYlpOBW42/F/TmkKJ
         aM4VX8iWjmFLGDqVVbjE5xcPodk62sbpH/+lhMT9A60iy/7Wj+fkD4hUa8AZp4JNllTx
         lIbyE1jw6l1HpinePaWpslerI11S3DbFd2vGi7O1XheAIROsyhUZb7l59XiNyIfxf5Yv
         sTjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NPBHPuzaf/+nyn5ga7U5YD4f7nfe2EXeI8cs0L23BX4=;
        b=Ax6u6LZuYM8WyE5J7LDmTYHw/kcLAjUSGUjeKyhvtvc7bV4tm5RODUAB5cD+wN0MGi
         6ksfXirD4m1Oq/TiuqkLGhPSuhZ+rX6qye7HmeiHDZhsTcDSaUUK2hzxXiVIrvMP4hnt
         mC6PM0kLyHVZlQerR98pVa67pk0nDozvX1gREd3XNZX2frooZVESaVyvko8xYQG2u9RR
         EDPHiCh/loZgt/MywjIVhERKUBiXkXriWm0XpU5JuhTLZCqn2VYpsx+KhOwYXD7ngCm3
         Tza/PNHZuV4KT8E0AgeLPomnYezhvYPhrKa32mj0g7hqAHkJOSGRToVze5hzAeVEUJgC
         Jvpw==
X-Gm-Message-State: AOAM533gPQmxPbZbI6RfHyhf2XWUVRqwVK/rOOybzBwhS+a3Ik7bkurp
        LWFybFnlTNw0BGCp+Bv2xcg=
X-Google-Smtp-Source: ABdhPJyJt6Dr4mfyo2ZIHkiTCV+hrmxV0JeZVQsugDa+QY20WQ6Oxl3Ud4qSzR/GnWmq7KNW3Utptw==
X-Received: by 2002:a17:906:ec9:: with SMTP id u9mr4319667eji.400.1610150545983;
        Fri, 08 Jan 2021 16:02:25 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id dx7sm4045346ejb.120.2021.01.08.16.02.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 16:02:25 -0800 (PST)
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
        Ivan Vecera <ivecera@redhat.com>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH v4 net-next 09/11] net: dsa: remove obsolete comments about switchdev transactions
Date:   Sat,  9 Jan 2021 02:01:54 +0200
Message-Id: <20210109000156.1246735-10-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210109000156.1246735-1-olteanv@gmail.com>
References: <20210109000156.1246735-1-olteanv@gmail.com>
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
Changes in v4:
None.

Changes in v3:
None.

Changes in v2:
None.

 net/dsa/slave.c  | 5 -----
 net/dsa/switch.c | 4 ----
 2 files changed, 9 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index ca0be052af25..d84ddf889f3a 100644
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

