Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68F423FA80E
	for <lists+netdev@lfdr.de>; Sun, 29 Aug 2021 02:28:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233916AbhH2A30 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Aug 2021 20:29:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbhH2A3Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Aug 2021 20:29:25 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 421FDC061756
        for <netdev@vger.kernel.org>; Sat, 28 Aug 2021 17:28:34 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id l2so14810729lfp.2
        for <netdev@vger.kernel.org>; Sat, 28 Aug 2021 17:28:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uM0R/cBCnrgZPVD3L0/mTUcz7T2d55t/hwaN/NXkFKI=;
        b=cyDTrbXNw/FYoho+wCpMLr8ClTC+Ho9s0H3rzjc+w/ZCZmLx1JloCoRrIbLAe1zp5l
         d07RizKTkiLQfIsyNn+mBX2ivBclYo1yMgCOiKO4vCiB7wM76wjTF49n8Uhjeg9OJlGC
         tpacsyF8FGPPcWjHpeUAbpV/GI06fLUW+L4klISCBfLOPgZyssykd/bRtBYByOgR287c
         n5gYm9icTVdyGEVjod1W6TY2huS4OQpesx0JgSk1fW+pd8TKhKsb2+heHDUcFPfPTDec
         XXwxNXg+F4dWX+zbwHNrlNY6x9a658AJonxervvwZ7O1Qw1eK1f/ew7QPdA2FStdh8PW
         QoeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uM0R/cBCnrgZPVD3L0/mTUcz7T2d55t/hwaN/NXkFKI=;
        b=DewvE0B4KynwDnrekWxNk7RMkVaegm/GJPPGiHXlbP1yyhvgoXyqZhVxHiTwtKr7WP
         O4YNEC/K/Ry56L//Whc6tuDedAiJ9IDvQrAEyNuj7UiS3apTzKFjbgpmG99tMVX1yx4o
         BAnnN4dkP/PDmzuKX8CNBHfNkDWf7+jiRCgtCnUJMflOt+P2zxqrtaRUenKVLjDEIAXQ
         DODYwGOT4H5P7eAIWif9WkSgfCF0dSIKhqnqfV824vlRGMTG5OTBTxmLH/rqQdR9BxVu
         tXz/ZLTqHusC3KG0ZBSciRBv1zPU4eJvNAntbB8MwpkKznLxV9DYGYuSXTqwIvfOzu/u
         1MYw==
X-Gm-Message-State: AOAM533gwBCrm+fG4EPLE8j1DP719eOI26+tYxbcZ16UkWX8daCvfhm0
        OylQfWmVpOLx74E7E3yGJ1z1ig==
X-Google-Smtp-Source: ABdhPJwORCWvJzAXItETvmJOlNn8jCX8fA4teQe4G34uopMYqbYy02akP1F2f3xXrtHjuaMNsQGT+w==
X-Received: by 2002:a05:6512:2091:: with SMTP id t17mr12061566lfr.253.1630196912638;
        Sat, 28 Aug 2021 17:28:32 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id m14sm995522lfo.196.2021.08.28.17.28.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Aug 2021 17:28:32 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Mauri Sandberg <sandberg@mailfence.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: [PATCH net-next 2/2] net: dsa: rtl8366: Drop custom VLAN set-up
Date:   Sun, 29 Aug 2021 02:26:01 +0200
Message-Id: <20210829002601.282521-2-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210829002601.282521-1-linus.walleij@linaro.org>
References: <20210829002601.282521-1-linus.walleij@linaro.org>
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

Cc: Vladimir Oltean <olteanv@gmail.com>
Cc: Alvin Šipraga <alsi@bang-olufsen.dk>
Cc: Mauri Sandberg <sandberg@mailfence.com>
Cc: DENG Qingfang <dqfext@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
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
index 14939188c108..17bf8f3ecc7d 100644
--- a/drivers/net/dsa/rtl8366rb.c
+++ b/drivers/net/dsa/rtl8366rb.c
@@ -984,7 +984,7 @@ static int rtl8366rb_setup(struct dsa_switch *ds)
 			return ret;
 	}
 
-	ret = rtl8366_init_vlan(smi);
+	ret = rtl8366_reset_vlan(smi);
 	if (ret)
 		return ret;
 
@@ -998,8 +998,6 @@ static int rtl8366rb_setup(struct dsa_switch *ds)
 		return -ENODEV;
 	}
 
-	ds->configure_vlan_while_not_filtering = false;
-
 	return 0;
 }
 
-- 
2.31.1

