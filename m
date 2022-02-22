Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF7F24C04DF
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 23:48:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236148AbiBVWtP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 17:49:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235034AbiBVWtO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 17:49:14 -0500
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8696C133967
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 14:48:47 -0800 (PST)
Received: by mail-oi1-x235.google.com with SMTP id p15so16285028oip.3
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 14:48:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OLodFo+EFLYoPsi+wdOHLLQ/vX3kieHkDvwNQ5bucUs=;
        b=BrvslKV5RYDh3QkIgW4Cs5WF4Df2MYSyH3w7sbXlyYzgXUCz23De/ApStJ1aTM8iSJ
         dHWr034VDXGWgUnLuArRXQUTn2emlDNfOUSAQxlJp5bA1/c1xumWJsGFoQJcdLJfneXv
         ebN8kyGDX6dgyGU0VS6Q+QBd8+Wtd/LGxgpV3kGwVEWBZ1Y/8ixisaK3mIPcARzqiUtB
         OnCKAGXVnFrio2ZAG/VRq6dbtMZoP2FSBgZ9ZwvUUcSz/F8Y8zBJbYheub/tCJVEKHg8
         z15NKZ0NHK95buPeGe0WMCCtGITE31owLPKTdTt83Y0z6RHLZnwHpLZipm0ILbWezi9I
         GoMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OLodFo+EFLYoPsi+wdOHLLQ/vX3kieHkDvwNQ5bucUs=;
        b=1/hldA4j6G8gEq/eAFZEqr+ayc/Homohtp959d+ACsOfRsg/irTDgF5xg+nkN5rKvr
         Lw1D5wnHBLzI4iC1R7WvhTO6i8yg0tSQ6ZmPJOgx7pizrhNUUorZsOF5P0Bo7KkMKg6K
         chesyNvkZk6qxfnmCmN/qw01LVapaQQZcTmQVKFJAoG+tWz56hpagHp56895UjLgdonW
         trpBB27ySP6/I8GBB4wNVuwrlnAOqC3XMvJi/hpk4IwilGzI11LchBuAfrHf/IH8zxcB
         zLpEYhx697/MHGwAehEMudj//jNJZvay/DH3GxNxeEipkguA+PaMVquqXiX1zw9nzRQE
         QprQ==
X-Gm-Message-State: AOAM5313GvpiBNoVntcc917aTQmpXTEvLMQP7ZSoMHpNEyZL93Qldzkc
        ga37r7c2KgoMyEwztji5BbqkenRNhts2iQ==
X-Google-Smtp-Source: ABdhPJxYv41stMfzseUim48CNHSoW3+prRKbrvc+A1dIrVo22+cY8wZl6oeQ4sHjnzKUBtYSiEv9Lw==
X-Received: by 2002:a05:6808:1892:b0:2d4:9241:dfad with SMTP id bi18-20020a056808189200b002d49241dfadmr3268766oib.106.1645570126610;
        Tue, 22 Feb 2022 14:48:46 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br ([187.94.103.218])
        by smtp.gmail.com with ESMTPSA id c9sm7033380otd.26.2022.02.22.14.48.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Feb 2022 14:48:46 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, alsi@bang-olufsen.dk, arinc.unal@arinc9.com,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net-next v3 2/2] net: dsa: realtek: rtl8365mb: add support for rtl8_4t
Date:   Tue, 22 Feb 2022 19:47:58 -0300
Message-Id: <20220222224758.11324-3-luizluca@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220222224758.11324-1-luizluca@gmail.com>
References: <20220222224758.11324-1-luizluca@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The trailing tag is also supported by this family. The default is still
rtl8_4 but now the switch supports changing the tag to rtl8_4t.

Reintroduce the dropped cpu in struct rtl8365mb (removed by 6147631).

Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
---
 drivers/net/dsa/realtek/rtl8365mb.c | 82 +++++++++++++++++++++++------
 1 file changed, 67 insertions(+), 15 deletions(-)

diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
index 2ed592147c20..ff865af65d55 100644
--- a/drivers/net/dsa/realtek/rtl8365mb.c
+++ b/drivers/net/dsa/realtek/rtl8365mb.c
@@ -566,6 +566,7 @@ struct rtl8365mb_port {
  * @chip_ver: chip silicon revision
  * @port_mask: mask of all ports
  * @learn_limit_max: maximum number of L2 addresses the chip can learn
+ * @cpu: CPU tagging and CPU port configuration for this chip
  * @mib_lock: prevent concurrent reads of MIB counters
  * @ports: per-port data
  * @jam_table: chip-specific initialization jam table
@@ -580,6 +581,7 @@ struct rtl8365mb {
 	u32 chip_ver;
 	u32 port_mask;
 	u32 learn_limit_max;
+	struct rtl8365mb_cpu cpu;
 	struct mutex mib_lock;
 	struct rtl8365mb_port ports[RTL8365MB_MAX_NUM_PORTS];
 	const struct rtl8365mb_jam_tbl_entry *jam_table;
@@ -770,6 +772,16 @@ static enum dsa_tag_protocol
 rtl8365mb_get_tag_protocol(struct dsa_switch *ds, int port,
 			   enum dsa_tag_protocol mp)
 {
+	struct realtek_priv *priv = ds->priv;
+	struct rtl8365mb_cpu *cpu;
+	struct rtl8365mb *mb;
+
+	mb = priv->chip_data;
+	cpu = &mb->cpu;
+
+	if (cpu->position == RTL8365MB_CPU_POS_BEFORE_CRC)
+		return DSA_TAG_PROTO_RTL8_4T;
+
 	return DSA_TAG_PROTO_RTL8_4;
 }
 
@@ -1725,8 +1737,10 @@ static void rtl8365mb_irq_teardown(struct realtek_priv *priv)
 	}
 }
 
-static int rtl8365mb_cpu_config(struct realtek_priv *priv, const struct rtl8365mb_cpu *cpu)
+static int rtl8365mb_cpu_config(struct realtek_priv *priv)
 {
+	struct rtl8365mb *mb = priv->chip_data;
+	struct rtl8365mb_cpu *cpu = &mb->cpu;
 	u32 val;
 	int ret;
 
@@ -1752,6 +1766,42 @@ static int rtl8365mb_cpu_config(struct realtek_priv *priv, const struct rtl8365m
 	return 0;
 }
 
+static int rtl8365mb_change_tag_protocol(struct dsa_switch *ds, int cpu_index,
+					 enum dsa_tag_protocol proto)
+{
+	struct realtek_priv *priv = ds->priv;
+	struct rtl8365mb_cpu *cpu;
+	struct rtl8365mb *mb;
+	int ret;
+
+	mb = priv->chip_data;
+	cpu = &mb->cpu;
+
+	switch (proto) {
+	case DSA_TAG_PROTO_RTL8_4:
+		cpu->format = RTL8365MB_CPU_FORMAT_8BYTES;
+		cpu->position = RTL8365MB_CPU_POS_AFTER_SA;
+		break;
+	case DSA_TAG_PROTO_RTL8_4T:
+		cpu->format = RTL8365MB_CPU_FORMAT_8BYTES;
+		cpu->position = RTL8365MB_CPU_POS_BEFORE_CRC;
+		break;
+	/* The switch also supports a 4-byte format, similar to rtl4a but with
+	 * the same 0x04 8-bit version and probably 8-bit port source/dest.
+	 * There is no public doc about it. Not supported yet and it will probably
+	 * never be.
+	 */
+	default:
+		return -EPROTONOSUPPORT;
+	}
+
+	ret = rtl8365mb_cpu_config(priv);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
 static int rtl8365mb_switch_init(struct realtek_priv *priv)
 {
 	struct rtl8365mb *mb = priv->chip_data;
@@ -1798,13 +1848,14 @@ static int rtl8365mb_reset_chip(struct realtek_priv *priv)
 static int rtl8365mb_setup(struct dsa_switch *ds)
 {
 	struct realtek_priv *priv = ds->priv;
-	struct rtl8365mb_cpu cpu = {0};
+	struct rtl8365mb_cpu *cpu;
 	struct dsa_port *cpu_dp;
 	struct rtl8365mb *mb;
 	int ret;
 	int i;
 
 	mb = priv->chip_data;
+	cpu = &mb->cpu;
 
 	ret = rtl8365mb_reset_chip(priv);
 	if (ret) {
@@ -1827,21 +1878,14 @@ static int rtl8365mb_setup(struct dsa_switch *ds)
 		dev_info(priv->dev, "no interrupt support\n");
 
 	/* Configure CPU tagging */
-	cpu.trap_port = RTL8365MB_MAX_NUM_PORTS;
 	dsa_switch_for_each_cpu_port(cpu_dp, priv->ds) {
-		cpu.mask |= BIT(cpu_dp->index);
+		cpu->mask |= BIT(cpu_dp->index);
 
-		if (cpu.trap_port == RTL8365MB_MAX_NUM_PORTS)
-			cpu.trap_port = cpu_dp->index;
+		if (cpu->trap_port == RTL8365MB_MAX_NUM_PORTS)
+			cpu->trap_port = cpu_dp->index;
 	}
-
-	cpu.enable = cpu.mask > 0;
-	cpu.insert = RTL8365MB_CPU_INSERT_TO_ALL;
-	cpu.position = RTL8365MB_CPU_POS_AFTER_SA;
-	cpu.rx_length = RTL8365MB_CPU_RXLEN_64BYTES;
-	cpu.format = RTL8365MB_CPU_FORMAT_8BYTES;
-
-	ret = rtl8365mb_cpu_config(priv, &cpu);
+	cpu->enable = cpu->mask > 0;
+	ret = rtl8365mb_cpu_config(priv);
 	if (ret)
 		goto out_teardown_irq;
 
@@ -1853,7 +1897,7 @@ static int rtl8365mb_setup(struct dsa_switch *ds)
 			continue;
 
 		/* Forward only to the CPU */
-		ret = rtl8365mb_port_set_isolation(priv, i, cpu.mask);
+		ret = rtl8365mb_port_set_isolation(priv, i, cpu->mask);
 		if (ret)
 			goto out_teardown_irq;
 
@@ -1983,6 +2027,12 @@ static int rtl8365mb_detect(struct realtek_priv *priv)
 		mb->jam_table = rtl8365mb_init_jam_8365mb_vc;
 		mb->jam_size = ARRAY_SIZE(rtl8365mb_init_jam_8365mb_vc);
 
+		mb->cpu.trap_port = RTL8365MB_MAX_NUM_PORTS;
+		mb->cpu.insert = RTL8365MB_CPU_INSERT_TO_ALL;
+		mb->cpu.position = RTL8365MB_CPU_POS_AFTER_SA;
+		mb->cpu.rx_length = RTL8365MB_CPU_RXLEN_64BYTES;
+		mb->cpu.format = RTL8365MB_CPU_FORMAT_8BYTES;
+
 		break;
 	default:
 		dev_err(priv->dev,
@@ -1996,6 +2046,7 @@ static int rtl8365mb_detect(struct realtek_priv *priv)
 
 static const struct dsa_switch_ops rtl8365mb_switch_ops_smi = {
 	.get_tag_protocol = rtl8365mb_get_tag_protocol,
+	.change_tag_protocol = rtl8365mb_change_tag_protocol,
 	.setup = rtl8365mb_setup,
 	.teardown = rtl8365mb_teardown,
 	.phylink_get_caps = rtl8365mb_phylink_get_caps,
@@ -2014,6 +2065,7 @@ static const struct dsa_switch_ops rtl8365mb_switch_ops_smi = {
 
 static const struct dsa_switch_ops rtl8365mb_switch_ops_mdio = {
 	.get_tag_protocol = rtl8365mb_get_tag_protocol,
+	.change_tag_protocol = rtl8365mb_change_tag_protocol,
 	.setup = rtl8365mb_setup,
 	.teardown = rtl8365mb_teardown,
 	.phylink_get_caps = rtl8365mb_phylink_get_caps,
-- 
2.35.1

