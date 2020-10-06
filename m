Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED252285288
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 21:35:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727174AbgJFTfC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 15:35:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726981AbgJFTfB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 15:35:01 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04671C061755
        for <netdev@vger.kernel.org>; Tue,  6 Oct 2020 12:35:01 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id 184so7682338lfd.6
        for <netdev@vger.kernel.org>; Tue, 06 Oct 2020 12:35:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RAp6NXULqcZBZl2ucAPOO/xL0WlcAsx3cRcVC5ixQtM=;
        b=dPLV+M4A7l/Vi3WQpncf2mC6j01pymZXRU8V/dfY6EY0jcQupxDPaNuvfgAGGlcWt+
         nEA+k7GUE5zlDSlGFACmYAgq6qSrx4dzBUjNTA2946A2SLgZ6Hx52SEuXZXNRS5iVf1o
         Wo1SWtsS0HbH4w+7enIcbk2kO8ATBHbBsHBkxSoc2fXa24LaAuHxxK7z9cpvNX6fIHdx
         dcOembmTPTVTuAag8lzWWD5a0R5YFLyVhy6JsXWzlAqq0+g5lzXYhiTHJ1DPcP2olsGB
         Tjdz1lqXyh/CfosbJOhyBHec3yUfRndTz6xu8JlxVKrNd1H6z4RxaesECW7BYnnNBc+g
         uAvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RAp6NXULqcZBZl2ucAPOO/xL0WlcAsx3cRcVC5ixQtM=;
        b=j3N8dDiSZ9k5TP27UbRJCnrlBuaHytdnKYQf6ZGkJA3d1EA+5SoAaqpK5wkg16pqY5
         UY3smb6W47woPzOcQJkSfhXCTjK1VXjHKbdwGz/aXA9WxyVVtbYVc0QD3wtVLONTJrSj
         y4GYxsPE2vj2123DDMsWW8XYFJHHknFAIWc43zWspl4eGxtgJSD1dy0tm3K2WnPGBW2R
         Jbv5wKQY9vhEA4nroCh2K9mOfJm1hB6TJkbaMEHnF/+KcqXM693vyQSrEsFBNOOJdb/a
         Q8szpOCaQ58PcIrotb6YrdWUTTyuqj4COg7tj9lE+dC4hNFGliwoAXtBMTm5D1QC15mT
         prRQ==
X-Gm-Message-State: AOAM533ByWgjLVk40Mo8mfympRESkhVPE5kipKQ1N1PiyDoSIhRENvyR
        mGtpNjROh2GISNI58VMAg9/xrQ==
X-Google-Smtp-Source: ABdhPJxVT7ZxJYPRHjPMeHcUAiXMsEM23lFWHY/tHJKm+V9ClX7gkji508clbEBPqvIVFnWhQCD7Hg==
X-Received: by 2002:a19:8c03:: with SMTP id o3mr934355lfd.349.1602012897965;
        Tue, 06 Oct 2020 12:34:57 -0700 (PDT)
Received: from localhost.bredbandsbolaget (c-92d7225c.014-348-6c756e10.bbcust.telenor.se. [92.34.215.146])
        by smtp.gmail.com with ESMTPSA id q24sm715387lfo.149.2020.10.06.12.34.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2020 12:34:57 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Linus Walleij <linus.walleij@linaro.org>
Subject: [net-next PATCH v2] net: dsa: rtl8366rb: Roof MTU for switch
Date:   Tue,  6 Oct 2020 21:34:53 +0200
Message-Id: <20201006193453.4069-1-linus.walleij@linaro.org>
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
ChangeLog v1->v2:
- Fix a reverse-christmas-tree variable order issue.
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
index 053bf5041f8d..48f560c9850d 100644
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
@@ -710,6 +717,7 @@ static const u16 rtl8366rb_green_jam[][2] = {
 
 static int rtl8366rb_setup(struct dsa_switch *ds)
 {
+	struct rtl8366rb *rb = smi->chip_data;
 	struct realtek_smi *smi = ds->priv;
 	const u16 *jam_table;
 	u32 chip_ver = 0;
@@ -871,6 +879,9 @@ static int rtl8366rb_setup(struct dsa_switch *ds)
 				 RTL8366RB_SGCR_MAX_LENGTH_1536);
 	if (ret)
 		return ret;
+	for (i = 0; i < RTL8366RB_NUM_PORTS; i++)
+		/* layer 2 size, see rtl8366rb_change_mtu() */
+		rb->max_mtu[i] = 1532;
 
 	/* Enable learning for all ports */
 	ret = regmap_write(smi->map, RTL8366RB_SSCR0, 0);
@@ -1112,20 +1123,36 @@ rtl8366rb_port_disable(struct dsa_switch *ds, int port)
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
@@ -1508,5 +1535,6 @@ const struct realtek_smi_variant rtl8366rb_variant = {
 	.clk_delay = 10,
 	.cmd_read = 0xa9,
 	.cmd_write = 0xa8,
+	.chip_data_sz = sizeof(struct rtl8366rb),
 };
 EXPORT_SYMBOL_GPL(rtl8366rb_variant);
-- 
2.26.2

