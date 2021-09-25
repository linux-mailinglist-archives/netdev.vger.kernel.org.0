Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE208418515
	for <lists+netdev@lfdr.de>; Sun, 26 Sep 2021 01:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230189AbhIYXDa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 19:03:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbhIYXD3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Sep 2021 19:03:29 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B089C061570
        for <netdev@vger.kernel.org>; Sat, 25 Sep 2021 16:01:54 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id i4so57556253lfv.4
        for <netdev@vger.kernel.org>; Sat, 25 Sep 2021 16:01:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Am2nspigH+pLh8OOda+Rspcz6sX8DsgevaljawbRmuw=;
        b=zAGG3LJnUT375BrHUuZP4ngHaDe1tQJCk4GGTN/aSc9FLdjF+sD5colknALEbf0LEq
         R2d4JnODHSlUtH39uKBbd1oPNA43mZW4+B+MQCgF2Dlc0AjjsjvwU9wOHzGsABAkzcpg
         er7uztfF7+OvbrE0i1pFpRtjC44oKyXruIq082CvELDfNdllPB3j0eJZ+0DDeVrE59ap
         OwbnupjAK48GGLsy7V3mJdJAYEW6j+1QgDidijjRqN0xMVMVsA9hdQeEsFlK2pVzWMOz
         ceMyKgV7AbUrQtHWJzNsCBlT3yXDSY4ZAEiI1eXEkNo1PhtWDcoT7vVqjupZZPKtvTot
         UURg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Am2nspigH+pLh8OOda+Rspcz6sX8DsgevaljawbRmuw=;
        b=zc7PN0Aq1HfbxgA0tid7doWcP4+NoxeBZ8QmNUB7UbO3CxUttBkG/sTDf2Dhxip7ze
         Ka6FWHuoIDxxNNvjnBbubQRZCPS7yAQLU6FXZbYBxdYvFhQ/IYDfcrI8Jpi64XvHx5vF
         bIFD9yS634u4AOY6wrzuKzzOM/qsZekvNpgmo1nFihtJQX7RFPIXYyzymqu2T1G5jMP1
         lFfTTwzzQPvj0sn8uWMTbaRxbHZvVskPmwui3Qp9/KVIoltU4fRXy8Zifvdftfgo8hYY
         f3jMHOFrzW8N1RR3ulwA7PaevAyNfNhE5xEJvFIuFQJ5KVQHVLxAUirej1Yzo/682axb
         fNrw==
X-Gm-Message-State: AOAM531wUTX7C+Rfq3uMVjAFeaGZOjZ57oZuSZOenksVY5504tmzZlu4
        Q4C/5TUPCZEcniTQKAq5s6J20x1XJEQKCQ==
X-Google-Smtp-Source: ABdhPJxrhr34t9yAhfljrDq2YW+3ol5iF8LCzLNK7V5ShFDf5z+ocEr0UbZQrTbb1hd7SgZ6tYWqGA==
X-Received: by 2002:a05:6512:12d6:: with SMTP id p22mr16853515lfg.42.1632610911929;
        Sat, 25 Sep 2021 16:01:51 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id d27sm1448111ljo.119.2021.09.25.16.01.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Sep 2021 16:01:51 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Mauri Sandberg <sandberg@mailfence.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Subject: [PATCH net-next 2/6 v7] net: dsa: rtl8366: Drop custom VLAN set-up
Date:   Sun, 26 Sep 2021 00:59:25 +0200
Message-Id: <20210925225929.2082046-3-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210925225929.2082046-1-linus.walleij@linaro.org>
References: <20210925225929.2082046-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This hacky default VLAN setup was done in order to direct
packets to the right ports and provide port isolation, both
which we now support properly using custom tags and proper
bridge port isolation.

We can drop the custom VLAN code and leave all VLAN handling
alone, as users expect things to be. We can also drop
ds->configure_vlan_while_not_filtering = false; and let
the core deal with any VLANs it wants.

Cc: Mauri Sandberg <sandberg@mailfence.com>
Cc: DENG Qingfang <dqfext@gmail.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Alvin Šipraga <alsi@bang-olufsen.dk>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v6->v7:
- No changes just resending with the rest of the
  patches.
ChangeLog v5->v6:
- No changes just resending with the rest of the
  patches.
ChangeLog v4->v5:
- No changes just resending with the rest of the
  patches.
ChangeLog v3->v4:
- No changes
ChangeLog v2->v3:
- Collect a bunch of reviewed-by tags
ChangeLog v1->v2:
- No changes.
---
 drivers/net/dsa/realtek-smi-core.h |  1 -
 drivers/net/dsa/rtl8366.c          | 48 ------------------------------
 drivers/net/dsa/rtl8366rb.c        |  4 +--
 3 files changed, 1 insertion(+), 52 deletions(-)

diff --git a/drivers/net/dsa/realtek-smi-core.h b/drivers/net/dsa/realtek-smi-core.h
index fcf465f7f922..c8fbd7b9fd0b 100644
--- a/drivers/net/dsa/realtek-smi-core.h
+++ b/drivers/net/dsa/realtek-smi-core.h
@@ -129,7 +129,6 @@ int rtl8366_set_pvid(struct realtek_smi *smi, unsigned int port,
 int rtl8366_enable_vlan4k(struct realtek_smi *smi, bool enable);
 int rtl8366_enable_vlan(struct realtek_smi *smi, bool enable);
 int rtl8366_reset_vlan(struct realtek_smi *smi);
-int rtl8366_init_vlan(struct realtek_smi *smi);
 int rtl8366_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering,
 			   struct netlink_ext_ack *extack);
 int rtl8366_vlan_add(struct dsa_switch *ds, int port,
diff --git a/drivers/net/dsa/rtl8366.c b/drivers/net/dsa/rtl8366.c
index 75897a369096..59c5bc4f7b71 100644
--- a/drivers/net/dsa/rtl8366.c
+++ b/drivers/net/dsa/rtl8366.c
@@ -292,54 +292,6 @@ int rtl8366_reset_vlan(struct realtek_smi *smi)
 }
 EXPORT_SYMBOL_GPL(rtl8366_reset_vlan);
 
-int rtl8366_init_vlan(struct realtek_smi *smi)
-{
-	int port;
-	int ret;
-
-	ret = rtl8366_reset_vlan(smi);
-	if (ret)
-		return ret;
-
-	/* Loop over the available ports, for each port, associate
-	 * it with the VLAN (port+1)
-	 */
-	for (port = 0; port < smi->num_ports; port++) {
-		u32 mask;
-
-		if (port == smi->cpu_port)
-			/* For the CPU port, make all ports members of this
-			 * VLAN.
-			 */
-			mask = GENMASK((int)smi->num_ports - 1, 0);
-		else
-			/* For all other ports, enable itself plus the
-			 * CPU port.
-			 */
-			mask = BIT(port) | BIT(smi->cpu_port);
-
-		/* For each port, set the port as member of VLAN (port+1)
-		 * and untagged, except for the CPU port: the CPU port (5) is
-		 * member of VLAN 6 and so are ALL the other ports as well.
-		 * Use filter 0 (no filter).
-		 */
-		dev_info(smi->dev, "VLAN%d port mask for port %d, %08x\n",
-			 (port + 1), port, mask);
-		ret = rtl8366_set_vlan(smi, (port + 1), mask, mask, 0);
-		if (ret)
-			return ret;
-
-		dev_info(smi->dev, "VLAN%d port %d, PVID set to %d\n",
-			 (port + 1), port, (port + 1));
-		ret = rtl8366_set_pvid(smi, port, (port + 1));
-		if (ret)
-			return ret;
-	}
-
-	return rtl8366_enable_vlan(smi, true);
-}
-EXPORT_SYMBOL_GPL(rtl8366_init_vlan);
-
 int rtl8366_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering,
 			   struct netlink_ext_ack *extack)
 {
diff --git a/drivers/net/dsa/rtl8366rb.c b/drivers/net/dsa/rtl8366rb.c
index b930050cfd1b..a5b7d7ff8884 100644
--- a/drivers/net/dsa/rtl8366rb.c
+++ b/drivers/net/dsa/rtl8366rb.c
@@ -985,7 +985,7 @@ static int rtl8366rb_setup(struct dsa_switch *ds)
 			return ret;
 	}
 
-	ret = rtl8366_init_vlan(smi);
+	ret = rtl8366_reset_vlan(smi);
 	if (ret)
 		return ret;
 
@@ -999,8 +999,6 @@ static int rtl8366rb_setup(struct dsa_switch *ds)
 		return -ENODEV;
 	}
 
-	ds->configure_vlan_while_not_filtering = false;
-
 	return 0;
 }
 
-- 
2.31.1

