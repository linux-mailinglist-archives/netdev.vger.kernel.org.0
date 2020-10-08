Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0974287D9B
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 23:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730903AbgJHVDz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 17:03:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729593AbgJHVDz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 17:03:55 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EF69C0613D2
        for <netdev@vger.kernel.org>; Thu,  8 Oct 2020 14:03:55 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id a15so7301150ljk.2
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 14:03:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vx0PoDgM/1hxV0npR0Jq9/O5aHSF5RZlAu8XemXmTok=;
        b=IlPhELQeOQFjhUIU6dKergzAIXvjr9jaNf6tnxNjLBkCaOUpL0IGA0OWza63yPAxA8
         SAU07KczT0Qf0KoT46dUTuqQVeEyvEKzC998NTFkxEwHRQWSq6dLWC8H0vJtQTz2U6fI
         FD52mSXXaHYfRFfuDIeAoibXyy1hw/LeN6HLVO4FfD/7yoJ1+cH9/TQUfKjFXRaT1HiQ
         6PqM2osBOCjcJAaeneJHD9FN/ag5joNTl1KRuvs1ptVhOV4cMuxWgWPvp9+QIoMFTJYd
         mq+hrUHbPTGhghirLB2kt0jj0t/taFwx2mebD3nrikp1JVNN5TQgMk+POiWsGP6KtYQd
         iePw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vx0PoDgM/1hxV0npR0Jq9/O5aHSF5RZlAu8XemXmTok=;
        b=sP6bYy9bF/S+b2/DlJr7hMYfNNAqH1m4zXVQObafx8WpdQRM/MXw4Eym8Dssvp2Hix
         zJOiAZC1362QKL2+9uz29a1w9upWJvTMY1Ko90V4534CdBNBnvbQqqnSkS75nOj4pDpv
         qr+J5pQKK1y4bsvhs6y0P5rXva+CBFLA+M9Ra+h+Qr/bcfcDnYIq2U1JrwDqrAoUMtwv
         bFw888kvRmBH7DoHN4CPnwcLtU32aIbzHH/f/gVIGt8a4UB0NE4kaeydq0Uqjrc0l9Rd
         66jYMi3eCWmU8URlhopwA6Q3r2ZoVrDhSdQFGmgeNE41WDEbFXkae3ZYfG/r5ljTpRih
         Ni0Q==
X-Gm-Message-State: AOAM530JF3okhHu6/axqA8M1VTrPAfltmLS6UpIg7HM2S5TNUSpdgVWY
        qftX7bf+071fsP0jzvyJ5zwnDA==
X-Google-Smtp-Source: ABdhPJyzTJeuhv7+Obu7QWbBViGL4EMXxilQ+7NlmAe/AyXCAGx4Q1/tgwU/g0V2K3HrZr/HmKmosw==
X-Received: by 2002:a2e:7216:: with SMTP id n22mr3753175ljc.106.1602191033489;
        Thu, 08 Oct 2020 14:03:53 -0700 (PDT)
Received: from localhost.bredbandsbolaget (c-92d7225c.014-348-6c756e10.bbcust.telenor.se. [92.34.215.146])
        by smtp.gmail.com with ESMTPSA id 71sm464358lfm.78.2020.10.08.14.03.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 14:03:52 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Linus Walleij <linus.walleij@linaro.org>
Subject: [net-next PATCH v4] net: dsa: rtl8366rb: Roof MTU for switch
Date:   Thu,  8 Oct 2020 23:03:40 +0200
Message-Id: <20201008210340.75133-1-linus.walleij@linaro.org>
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
ChangeLog v3->v4:
- Fix the missing kerneldoc.
ChangeLog v2->v3:
- Fix the reverse-christmas-tree properly by also making it
  compile :/
ChangeLog v1->v2:
- Fix a reverse-christmas-tree variable order issue.
---
 drivers/net/dsa/realtek-smi-core.c |  3 ++-
 drivers/net/dsa/realtek-smi-core.h |  2 ++
 drivers/net/dsa/rtl8366rb.c        | 39 +++++++++++++++++++++++++++---
 3 files changed, 39 insertions(+), 5 deletions(-)

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
index 053bf5041f8d..ea2a4f26d980 100644
--- a/drivers/net/dsa/rtl8366rb.c
+++ b/drivers/net/dsa/rtl8366rb.c
@@ -311,6 +311,14 @@
 #define RTL8366RB_GREEN_FEATURE_TX	BIT(0)
 #define RTL8366RB_GREEN_FEATURE_RX	BIT(2)
 
+/**
+ * struct rtl8366rb - RTL8366RB-specific data
+ * @max_mtu: per-port max MTU setting
+ */
+struct rtl8366rb {
+	unsigned int max_mtu[RTL8366RB_NUM_PORTS];
+};
+
 static struct rtl8366_mib_counter rtl8366rb_mib_counters[] = {
 	{ 0,  0, 4, "IfInOctets"				},
 	{ 0,  4, 4, "EtherStatsOctets"				},
@@ -712,6 +720,7 @@ static int rtl8366rb_setup(struct dsa_switch *ds)
 {
 	struct realtek_smi *smi = ds->priv;
 	const u16 *jam_table;
+	struct rtl8366rb *rb;
 	u32 chip_ver = 0;
 	u32 chip_id = 0;
 	int jam_size;
@@ -719,6 +728,8 @@ static int rtl8366rb_setup(struct dsa_switch *ds)
 	int ret;
 	int i;
 
+	rb = smi->chip_data;
+
 	ret = regmap_read(smi->map, RTL8366RB_CHIP_ID_REG, &chip_id);
 	if (ret) {
 		dev_err(smi->dev, "unable to read chip id\n");
@@ -871,6 +882,9 @@ static int rtl8366rb_setup(struct dsa_switch *ds)
 				 RTL8366RB_SGCR_MAX_LENGTH_1536);
 	if (ret)
 		return ret;
+	for (i = 0; i < RTL8366RB_NUM_PORTS; i++)
+		/* layer 2 size, see rtl8366rb_change_mtu() */
+		rb->max_mtu[i] = 1532;
 
 	/* Enable learning for all ports */
 	ret = regmap_write(smi->map, RTL8366RB_SSCR0, 0);
@@ -1112,20 +1126,36 @@ rtl8366rb_port_disable(struct dsa_switch *ds, int port)
 static int rtl8366rb_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
 {
 	struct realtek_smi *smi = ds->priv;
+	struct rtl8366rb *rb;
+	unsigned int max_mtu;
 	u32 len;
+	int i;
+
+	/* Cache the per-port MTU setting */
+	rb = smi->chip_data;
+	rb->max_mtu[port] = new_mtu;
 
-	/* The first setting, 1522 bytes, is max IP packet 1500 bytes,
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
@@ -1508,5 +1538,6 @@ const struct realtek_smi_variant rtl8366rb_variant = {
 	.clk_delay = 10,
 	.cmd_read = 0xa9,
 	.cmd_write = 0xa8,
+	.chip_data_sz = sizeof(struct rtl8366rb),
 };
 EXPORT_SYMBOL_GPL(rtl8366rb_variant);
-- 
2.26.2

