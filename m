Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C58441B24F
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 16:44:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241395AbhI1Oqa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 10:46:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241311AbhI1Oq2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 10:46:28 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 674EBC061745
        for <netdev@vger.kernel.org>; Tue, 28 Sep 2021 07:44:48 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id y26so54384038lfa.11
        for <netdev@vger.kernel.org>; Tue, 28 Sep 2021 07:44:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EGWUMoEsyjYiDRxtjWnqInO7daZnJ0Nzrr+qkb1K+Z4=;
        b=WqDL445es2OpXn1RHcgcJaDoy3VIc8cleNtTBTr4QiMpi7KX6IhU75UFjXogVobFqr
         g7UZDSXw7iBhMBHJWtgIcJVOerx5Z8gsuPbIRc19c69bgSeL+41rmUUDuhqQrICcJ573
         47TX/WCR+cpnQ8kK1+LVp6fXkTelTcrYAv68alEEk6FVEZM/agNkmgXO0rdNwViEBbmY
         mbCHmIIeAl18hezdyjYKvjCAW3qQub73mX7mK6LYhH9MG0ZTjqtd3pNGTdkgYgHTXjDs
         dKQNKMZrtfuQXxRx+2ic9cXFPea0RS0zCQKAQSX4TGLvCf7q9lflD2F20I505li3/Qdn
         g4ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EGWUMoEsyjYiDRxtjWnqInO7daZnJ0Nzrr+qkb1K+Z4=;
        b=Kr2fkQvlm5lb0VwcJwvEcxBngFfMI8PnftYoL0nMwGRKM8mBhs9Q6lBtrOKkUbrBqw
         mSCSLM+GO5ty/AcLL4K1YiusPsEQl7cN/TI0cgYIZqwWGZ7WkjMKsMpdM8me4/mn1y4Q
         MAaey8EVLxYIyTe/oZoG/fGBfuQHE/zcc8Z/X+IfQdIokvw4B/he3pxBWoofFXNdVi+K
         nhJVk79MnlkOY9k/EIoEFPiTqnbXAxPTKNpMkfrwpKuuKdJ04Rs9Rz++Je1KXX0JrT/s
         t5+hKw8WOOMx4rDljP4BFqoZyBXpFx3nJfAyECnVCccxZdvK3rKjkA+ynsBjO2B9pAbU
         QioQ==
X-Gm-Message-State: AOAM5306x8SzibAZNRXO18KHV0f/OEqTlrSKQFOvvIH+KCIv65X1lXFp
        euIlEmxTqWEoTzy9LtSbtGJI8Q==
X-Google-Smtp-Source: ABdhPJw+3++WfC2VCTJuSeSCUy121lRjtLsCbaJTCDnWsulGKSA9/VnvvdBmb1Zo+5VzXmqeDa2iDA==
X-Received: by 2002:ac2:5e75:: with SMTP id a21mr6016381lfr.557.1632840285560;
        Tue, 28 Sep 2021 07:44:45 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id x23sm1933462lfd.136.2021.09.28.07.44.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Sep 2021 07:44:44 -0700 (PDT)
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
Subject: [PATCH net-next 2/6 v8] net: dsa: rtl8366: Drop custom VLAN set-up
Date:   Tue, 28 Sep 2021 16:41:45 +0200
Message-Id: <20210928144149.84612-3-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210928144149.84612-1-linus.walleij@linaro.org>
References: <20210928144149.84612-1-linus.walleij@linaro.org>
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
ChangeLog v7->v8:
- No changes just resending with the rest of the
  patches.
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

