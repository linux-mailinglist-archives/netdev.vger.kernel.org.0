Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0104E2710CF
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 00:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726626AbgISWBc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 18:01:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726582AbgISWBc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Sep 2020 18:01:32 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB440C0613CE
        for <netdev@vger.kernel.org>; Sat, 19 Sep 2020 15:01:31 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id b12so9960126lfp.9
        for <netdev@vger.kernel.org>; Sat, 19 Sep 2020 15:01:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=a9C6qOAeDZHX9GxnChNuRNg4C9ROLPZTQkCDfXuqKmc=;
        b=HhrcvFJr9qWwQq3gkJBgr24kk9fVFcCjdbK8GV9J/b01Qwyt90+70mq47KOMcNmcNY
         2NaVmx/BvPojPqJA0xBwAZGSvOjKqkaN9CFEaGNB+YTYVXiX8Qt884GDspge7vs4xSau
         oVfp0c9vXE+1H18sb13itpHpKN+Okzua9XtHTQSoQpsMTbNPQAWPpIkYREuMO+rLsbfW
         Zovq9JgEQo9W41W3/erb48Nv2/ognZDqwrQszZMmusrDWGnifmKDkgFmrkRHUHkcqe3c
         AJJATmW31O4ylbrDtosk3NAIAOPOEIt3qlFsM/3sG5quIaaUT/uAoIE525bB7RmBWGpy
         ouHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=a9C6qOAeDZHX9GxnChNuRNg4C9ROLPZTQkCDfXuqKmc=;
        b=T55TLwKOMS9RdcAZaJZM60R1kJSSq2IEfC4H3+90Wgwun/NSsJbRJXnc2Xm82l2Pdq
         /ChskL9qH0oUExXnJenKYPEpR8GrWIe7zRljdvcGZ8C99RxE2c74IY4c1o25dfZDd4pE
         wKoPatawJgI+ejf4LPVLdKyIAIvoCpwzw2fSA8VFARYzNppqqaGhIVVi03XMXFAaUi+O
         n2ofmlClpDjv6xOc7+rSZxhsDXpsyfeVs8s4o0AR+LatVZzN6s3o9v395HiOuIuNyuNR
         gL0rQk8O2zndacp+f8jj7+yhfFzabjto4jScihtf4Kj/oVeOHegrKdutqV0TAdTNKomK
         H/8g==
X-Gm-Message-State: AOAM530OSFhUGb8vO61uXWyxU3H3MnEIog0pk6tB1gm7aetpIrImFKX+
        7VwxqX4cSw8c+VqaiD3c+elAyw==
X-Google-Smtp-Source: ABdhPJzNilPpxip7pUsQ8gWhUO5rmHwzkZc2NX/YI/2xIMJ2FfHi7WXcmYkc9tAGH4YbiDMwrVodZg==
X-Received: by 2002:ac2:46d1:: with SMTP id p17mr14578138lfo.216.1600552890125;
        Sat, 19 Sep 2020 15:01:30 -0700 (PDT)
Received: from localhost.bredbandsbolaget (c-92d7225c.014-348-6c756e10.bbcust.telenor.se. [92.34.215.146])
        by smtp.gmail.com with ESMTPSA id k14sm1467379lfm.90.2020.09.19.15.01.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2020 15:01:29 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] net: dsa: rtl8366rb: Roof MTU for switch
Date:   Sun, 20 Sep 2020 00:01:05 +0200
Message-Id: <20200919220105.311483-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MTU setting for this DSA switch is global so we need
to keep track of the MTU set for each port, then as soon
as any MTU changes, roof the MTU to the biggest common
denominator and poke that into the switch MTU setting.

To achieve this we need a per-chip-variant state container
for the RTL8366RB to use for the RTL8366RB-specific
stuff. Other SMI switches does seem to have per-port
MTU setting capabilities.

Fixes: 5f4a8ef384db ("net: dsa: rtl8366rb: Support setting MTU")
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/net/dsa/realtek-smi-core.c |  3 ++-
 drivers/net/dsa/realtek-smi-core.h |  2 ++
 drivers/net/dsa/rtl8366rb.c        | 36 ++++++++++++++++++++++++++----
 3 files changed, 36 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/realtek-smi-core.c b/drivers/net/dsa/realtek-smi-core.c
index fae188c60191..8e49d4f85d48 100644
--- a/drivers/net/dsa/realtek-smi-core.c
+++ b/drivers/net/dsa/realtek-smi-core.c
@@ -394,9 +394,10 @@ static int realtek_smi_probe(struct platform_device *pdev)
 	var = of_device_get_match_data(dev);
 	np = dev->of_node;
 
-	smi = devm_kzalloc(dev, sizeof(*smi), GFP_KERNEL);
+	smi = devm_kzalloc(dev, sizeof(*smi) + var->chip_data_sz, GFP_KERNEL);
 	if (!smi)
 		return -ENOMEM;
+	smi->chip_data = (void *)smi + sizeof(*smi);
 	smi->map = devm_regmap_init(dev, NULL, smi,
 				    &realtek_smi_mdio_regmap_config);
 	if (IS_ERR(smi->map)) {
diff --git a/drivers/net/dsa/realtek-smi-core.h b/drivers/net/dsa/realtek-smi-core.h
index 6f2dab7e33d6..bc7bd47fb037 100644
--- a/drivers/net/dsa/realtek-smi-core.h
+++ b/drivers/net/dsa/realtek-smi-core.h
@@ -71,6 +71,7 @@ struct realtek_smi {
 	int			vlan4k_enabled;
 
 	char			buf[4096];
+	void			*chip_data; /* Per-chip extra variant data */
 };
 
 /**
@@ -111,6 +112,7 @@ struct realtek_smi_variant {
 	unsigned int clk_delay;
 	u8 cmd_read;
 	u8 cmd_write;
+	size_t chip_data_sz;
 };
 
 /* SMI core calls */
diff --git a/drivers/net/dsa/rtl8366rb.c b/drivers/net/dsa/rtl8366rb.c
index ddc24f5e4123..1e79349922f4 100644
--- a/drivers/net/dsa/rtl8366rb.c
+++ b/drivers/net/dsa/rtl8366rb.c
@@ -311,6 +311,13 @@
 #define RTL8366RB_GREEN_FEATURE_TX	BIT(0)
 #define RTL8366RB_GREEN_FEATURE_RX	BIT(2)
 
+/**
+ * struct rtl8366rb - RTL8366RB-specific data
+ */
+struct rtl8366rb {
+	unsigned int max_mtu[RTL8366RB_NUM_PORTS];
+};
+
 static struct rtl8366_mib_counter rtl8366rb_mib_counters[] = {
 	{ 0,  0, 4, "IfInOctets"				},
 	{ 0,  4, 4, "EtherStatsOctets"				},
@@ -711,6 +718,7 @@ static const u16 rtl8366rb_green_jam[][2] = {
 static int rtl8366rb_setup(struct dsa_switch *ds)
 {
 	struct realtek_smi *smi = ds->priv;
+	struct rtl8366rb *rb = smi->chip_data;
 	const u16 *jam_table;
 	u32 chip_ver = 0;
 	u32 chip_id = 0;
@@ -868,6 +876,9 @@ static int rtl8366rb_setup(struct dsa_switch *ds)
 				 RTL8366RB_SGCR_MAX_LENGTH_1536);
 	if (ret)
 		return ret;
+	for (i = 0; i < RTL8366RB_NUM_PORTS; i++)
+		/* layer 2 size, see rtl8366rb_change_mtu() */
+		rb->max_mtu[i] = 1532;
 
 	/* Enable learning for all ports */
 	ret = regmap_write(smi->map, RTL8366RB_SSCR0, 0);
@@ -1109,20 +1120,36 @@ rtl8366rb_port_disable(struct dsa_switch *ds, int port)
 static int rtl8366rb_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
 {
 	struct realtek_smi *smi = ds->priv;
+	struct rtl8366rb *rb;
+	unsigned int max_mtu;
 	u32 len;
+	int i;
 
-	/* The first setting, 1522 bytes, is max IP packet 1500 bytes,
+	/* Cache the per-port MTU setting */
+	rb = smi->chip_data;
+	rb->max_mtu[port] = new_mtu;
+
+	/* Roof out the MTU for the entire switch to the greatest
+	 * common denominator: the biggest set for any one port will
+	 * be the biggest MTU for the switch.
+	 *
+	 * The first setting, 1522 bytes, is max IP packet 1500 bytes,
 	 * plus ethernet header, 1518 bytes, plus CPU tag, 4 bytes.
 	 * This function should consider the parameter an SDU, so the
 	 * MTU passed for this setting is 1518 bytes. The same logic
 	 * of subtracting the DSA tag of 4 bytes apply to the other
 	 * settings.
 	 */
-	if (new_mtu <= 1518)
+	max_mtu = 1518;
+	for (i = 0; i < RTL8366RB_NUM_PORTS; i++) {
+		if (rb->max_mtu[i] > max_mtu)
+			max_mtu = rb->max_mtu[i];
+	}
+	if (max_mtu <= 1518)
 		len = RTL8366RB_SGCR_MAX_LENGTH_1522;
-	else if (new_mtu > 1518 && new_mtu <= 1532)
+	else if (max_mtu > 1518 && max_mtu <= 1532)
 		len = RTL8366RB_SGCR_MAX_LENGTH_1536;
-	else if (new_mtu > 1532 && new_mtu <= 1548)
+	else if (max_mtu > 1532 && max_mtu <= 1548)
 		len = RTL8366RB_SGCR_MAX_LENGTH_1552;
 	else
 		len = RTL8366RB_SGCR_MAX_LENGTH_16000;
@@ -1505,5 +1532,6 @@ const struct realtek_smi_variant rtl8366rb_variant = {
 	.clk_delay = 10,
 	.cmd_read = 0xa9,
 	.cmd_write = 0xa8,
+	.chip_data_sz = sizeof(struct rtl8366rb),
 };
 EXPORT_SYMBOL_GPL(rtl8366rb_variant);
-- 
2.26.2

