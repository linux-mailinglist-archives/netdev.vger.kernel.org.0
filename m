Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E32D3287155
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 11:20:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726692AbgJHJUD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 05:20:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725845AbgJHJUC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 05:20:02 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FCF0C061755
        for <netdev@vger.kernel.org>; Thu,  8 Oct 2020 02:20:02 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id j30so3275129lfp.4
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 02:20:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Aenfnq234FRChKgUT5OjT+xM8Qs4UZ2ucpQgqC/E35Q=;
        b=rgeyMVRX9RYd4809Xqlhja+7CILkO5kFanXMJKXPMtOUxDe8s268WOy1noM3NohtcR
         ogC71VpodaWcxfS4QRzCvMoZXf97J67Pb52UemGHCjzy1VmGH+3M+Uo+JfgpYxX5gmj7
         E2/+BTTUIXtvsNjy7UL1tsKJR35w7vIB3WenR1fiUzNbfI0LDz1v+gOnCfqexWJGRCNO
         BZt7YPQrGIuMN26bz4e4zHz4h7RGlS+P50Rc5278vjJAoArWXXdOcOZkzNj/cm4H5uKO
         AjE3hxgzC+WgbH0kuOQfJJhftSCe5QFfdgYtlMdLFkaN2CPlJZY4FV3aq+mx9PWMvxJ2
         xJAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Aenfnq234FRChKgUT5OjT+xM8Qs4UZ2ucpQgqC/E35Q=;
        b=e2YY0Fija3q9L0R8XzuJT0HmSbhTYRVgb8y/bVfIaYVkQZHEpIrGhFPL/KapFn2P4R
         BnZUVSzkCXj9PtUaMoNixA2QlaBI6cmi1uqvr/1GMJxtc+4XIKNRu4l5kuyBf6i/h+Ot
         jnEHvP7GkAFV0b2PFAYkoj2wzmMOvKvOlWgRk+77w9naBIOYQH2vXlP8zNVX6IHVuyTk
         coDAkDtec/UHris7LiUv6cM0LQuLQKrwbPis87hlu/QIVFwIREKQHoTi1zq98l7HPkDN
         6PUsLiVUOj580ESk4W4ns/eq/dk7QJVJhtH54G7w4WfZV9HtGxvgLV9m6ET1B+/gdF9B
         pdtA==
X-Gm-Message-State: AOAM532wL9Y+sxIWLOZe+hfClWaiGjQ5b/HyxdNCnNiez9OlvcV6xsKM
        ErBepHiKQhYV8dArU/EuX+p3HQ==
X-Google-Smtp-Source: ABdhPJyN7T9x5zuVBA5gqfFWl2XcJsskkye4PL0sC7YifB/NampW01WxEKQmdcd2QI86MPjajhtlpg==
X-Received: by 2002:ac2:4281:: with SMTP id m1mr2199992lfh.574.1602148799880;
        Thu, 08 Oct 2020 02:19:59 -0700 (PDT)
Received: from localhost.bredbandsbolaget (c-92d7225c.014-348-6c756e10.bbcust.telenor.se. [92.34.215.146])
        by smtp.gmail.com with ESMTPSA id b21sm773888lfb.52.2020.10.08.02.19.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 02:19:59 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Linus Walleij <linus.walleij@linaro.org>
Subject: [net-next PATCH v3] net: dsa: rtl8366rb: Roof MTU for switch
Date:   Thu,  8 Oct 2020 11:19:55 +0200
Message-Id: <20201008091955.44692-1-linus.walleij@linaro.org>
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
ChangeLog v2->v3:
- Fix the reverse-christmas-tree properly by also making it
  compile :/
ChangeLog v1->v2:
- Fix a reverse-christmas-tree variable order issue.
---
 drivers/net/dsa/realtek-smi-core.c |  3 ++-
 drivers/net/dsa/realtek-smi-core.h |  2 ++
 drivers/net/dsa/rtl8366rb.c        | 38 ++++++++++++++++++++++++++----
 3 files changed, 38 insertions(+), 5 deletions(-)

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
index 053bf5041f8d..28f510a580be 100644
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
@@ -712,6 +719,7 @@ static int rtl8366rb_setup(struct dsa_switch *ds)
 {
 	struct realtek_smi *smi = ds->priv;
 	const u16 *jam_table;
+	struct rtl8366rb *rb;
 	u32 chip_ver = 0;
 	u32 chip_id = 0;
 	int jam_size;
@@ -719,6 +727,8 @@ static int rtl8366rb_setup(struct dsa_switch *ds)
 	int ret;
 	int i;
 
+	rb = smi->chip_data;
+
 	ret = regmap_read(smi->map, RTL8366RB_CHIP_ID_REG, &chip_id);
 	if (ret) {
 		dev_err(smi->dev, "unable to read chip id\n");
@@ -871,6 +881,9 @@ static int rtl8366rb_setup(struct dsa_switch *ds)
 				 RTL8366RB_SGCR_MAX_LENGTH_1536);
 	if (ret)
 		return ret;
+	for (i = 0; i < RTL8366RB_NUM_PORTS; i++)
+		/* layer 2 size, see rtl8366rb_change_mtu() */
+		rb->max_mtu[i] = 1532;
 
 	/* Enable learning for all ports */
 	ret = regmap_write(smi->map, RTL8366RB_SSCR0, 0);
@@ -1112,20 +1125,36 @@ rtl8366rb_port_disable(struct dsa_switch *ds, int port)
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
@@ -1508,5 +1537,6 @@ const struct realtek_smi_variant rtl8366rb_variant = {
 	.clk_delay = 10,
 	.cmd_read = 0xa9,
 	.cmd_write = 0xa8,
+	.chip_data_sz = sizeof(struct rtl8366rb),
 };
 EXPORT_SYMBOL_GPL(rtl8366rb_variant);
-- 
2.26.2

