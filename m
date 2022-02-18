Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B26B4BB1D4
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 07:11:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231229AbiBRGLU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 01:11:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231232AbiBRGLP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 01:11:15 -0500
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 540F61A80D
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 22:10:59 -0800 (PST)
Received: by mail-ot1-x32f.google.com with SMTP id j8-20020a056830014800b005ad00ef6d5dso1373137otp.0
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 22:10:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KLwD4U+ILJaAuaqeAkDQzVG21/WID9rNUh7zEBh/M2w=;
        b=OUmnh+l14tfm3axMjD+9IRnyyt+89cfzsEJ4/ybAXBEVtMgwTKxnHVXMX7IsbX8d5W
         5sUuysrhfTSUZA4WFSl1aKhl4Ec+AYkYxI8rb+ANccka4yMcOkN5ml3N5SIaM0U1Q01O
         cGacioJsBcEF8M1dpPrkbG2mpNft02l60Yr93ecGEBOasvTK3Dq/CkEMhNL7rDLdgvt7
         LatcuTVWM17xEFt0exHzyE9QZKcCVqqxeyUyjzIYnbKAIol3gEgwiLccQ1qe1oLeHnsX
         m/PiUcvkVTq7T50Z58pqk9bIBYoHCOxaoV3NwWGZ54gIv7nfzUtzV8BsHFr9IWsSn5yy
         rW2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KLwD4U+ILJaAuaqeAkDQzVG21/WID9rNUh7zEBh/M2w=;
        b=PPLos0hfrEjOMj58n8ASsNKtgKKod5/cszfOijMOl0WRcIl+pbHvnRU3/woqb1aWrt
         8QmyfsDLRBlIF4XtrOr/7HR949XiwuZ+Y9fzQxeFFmSft3AdCCkvPwlX1MxDEM+SAYJ0
         OweqUm8f6OVub+hzkIvGPfYT76+VQ7cnnwOpBKvrUu+croz3+cGJvZG5opE7Ig9/KEyc
         UuVAbfaVSqHxpZWELGEtVKRQVfqNzOAcVP5YpwDZ5hadSmAGICC8ZC0Yp/MLniEvD71x
         wOCQZjAAzA6Oh43lKgOkI94SHKGhInSvDNCMUfh6/ihdkpjHuh7o3iJD1Luj5YSJw//7
         6kMA==
X-Gm-Message-State: AOAM532PDBsrkzXa73NniL1icIFvPk3NQ9CMnbHeD4ciuumimdztDmG+
        F+ESqq95rEVK0p5eO7JFtAvOtT/wzqNd+g==
X-Google-Smtp-Source: ABdhPJwvDMUmXMNxrUfIrfcSFgrxwNFWG1H4yDNWBDzVoKM1LnE663UNu/iPi0zsXHvkISYwA5itug==
X-Received: by 2002:a9d:6b87:0:b0:5ab:e54d:4817 with SMTP id b7-20020a9d6b87000000b005abe54d4817mr2020562otq.300.1645164658313;
        Thu, 17 Feb 2022 22:10:58 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br (187-049-235-234.floripa.net.br. [187.49.235.234])
        by smtp.gmail.com with ESMTPSA id 9sm3125214oas.27.2022.02.17.22.10.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Feb 2022 22:10:57 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, alsi@bang-olufsen.dk, arinc.unal@arinc9.com,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net-next v2 2/2] net: dsa: realtek: rtl8365mb: add support for rtl8_4t
Date:   Fri, 18 Feb 2022 03:09:59 -0300
Message-Id: <20220218060959.6631-3-luizluca@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220218060959.6631-1-luizluca@gmail.com>
References: <20220218060959.6631-1-luizluca@gmail.com>
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

Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
---
 drivers/net/dsa/realtek/rtl8365mb.c | 78 ++++++++++++++++++++++++-----
 1 file changed, 66 insertions(+), 12 deletions(-)

diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
index 2ed592147c20..043cac34e906 100644
--- a/drivers/net/dsa/realtek/rtl8365mb.c
+++ b/drivers/net/dsa/realtek/rtl8365mb.c
@@ -524,9 +524,7 @@ enum rtl8365mb_cpu_rxlen {
  * @mask: port mask of ports that parse should parse CPU tags
  * @trap_port: forward trapped frames to this port
  * @insert: CPU tag insertion mode in switch->CPU frames
- * @position: position of CPU tag in frame
  * @rx_length: minimum CPU RX length
- * @format: CPU tag format
  *
  * Represents the CPU tagging and CPU port configuration of the switch. These
  * settings are configurable at runtime.
@@ -536,9 +534,7 @@ struct rtl8365mb_cpu {
 	u32 mask;
 	u32 trap_port;
 	enum rtl8365mb_cpu_insert insert;
-	enum rtl8365mb_cpu_position position;
 	enum rtl8365mb_cpu_rxlen rx_length;
-	enum rtl8365mb_cpu_format format;
 };
 
 /**
@@ -566,6 +562,7 @@ struct rtl8365mb_port {
  * @chip_ver: chip silicon revision
  * @port_mask: mask of all ports
  * @learn_limit_max: maximum number of L2 addresses the chip can learn
+ * @tag_protocol: current switch CPU tag protocol
  * @mib_lock: prevent concurrent reads of MIB counters
  * @ports: per-port data
  * @jam_table: chip-specific initialization jam table
@@ -580,6 +577,7 @@ struct rtl8365mb {
 	u32 chip_ver;
 	u32 port_mask;
 	u32 learn_limit_max;
+	enum dsa_tag_protocol tag_protocol;
 	struct mutex mib_lock;
 	struct rtl8365mb_port ports[RTL8365MB_MAX_NUM_PORTS];
 	const struct rtl8365mb_jam_tbl_entry *jam_table;
@@ -770,7 +768,54 @@ static enum dsa_tag_protocol
 rtl8365mb_get_tag_protocol(struct dsa_switch *ds, int port,
 			   enum dsa_tag_protocol mp)
 {
-	return DSA_TAG_PROTO_RTL8_4;
+	struct realtek_priv *priv = ds->priv;
+	struct rtl8365mb *chip_data;
+
+	chip_data = priv->chip_data;
+
+	return chip_data->tag_protocol;
+}
+
+static int rtl8365mb_change_tag_protocol(struct dsa_switch *ds, int cpu,
+					 enum dsa_tag_protocol proto)
+{
+	struct realtek_priv *priv = ds->priv;
+	struct rtl8365mb *chip_data;
+	int tag_position;
+	int tag_format;
+	int ret;
+
+	switch (proto) {
+	case DSA_TAG_PROTO_RTL8_4:
+		tag_format = RTL8365MB_CPU_FORMAT_8BYTES;
+		tag_position = RTL8365MB_CPU_POS_AFTER_SA;
+		break;
+	case DSA_TAG_PROTO_RTL8_4T:
+		tag_format = RTL8365MB_CPU_FORMAT_8BYTES;
+		tag_position = RTL8365MB_CPU_POS_BEFORE_CRC;
+		break;
+	/* The switch also supports a 4-byte format, similar to rtl4a but with
+	 * the same 0x04 8-bit version and probably 8-bit port source/dest.
+	 * There is no public doc about it. Not supported yet.
+	 */
+	default:
+		return -EPROTONOSUPPORT;
+	}
+
+	ret = regmap_update_bits(priv->map, RTL8365MB_CPU_CTRL_REG,
+				 RTL8365MB_CPU_CTRL_TAG_POSITION_MASK |
+				 RTL8365MB_CPU_CTRL_TAG_FORMAT_MASK,
+				 FIELD_PREP(RTL8365MB_CPU_CTRL_TAG_POSITION_MASK,
+					    tag_position) |
+				 FIELD_PREP(RTL8365MB_CPU_CTRL_TAG_FORMAT_MASK,
+					    tag_format));
+	if (ret)
+		return ret;
+
+	chip_data = priv->chip_data;
+	chip_data->tag_protocol = proto;
+
+	return 0;
 }
 
 static int rtl8365mb_ext_config_rgmii(struct realtek_priv *priv, int port,
@@ -1739,13 +1784,18 @@ static int rtl8365mb_cpu_config(struct realtek_priv *priv, const struct rtl8365m
 
 	val = FIELD_PREP(RTL8365MB_CPU_CTRL_EN_MASK, cpu->enable ? 1 : 0) |
 	      FIELD_PREP(RTL8365MB_CPU_CTRL_INSERTMODE_MASK, cpu->insert) |
-	      FIELD_PREP(RTL8365MB_CPU_CTRL_TAG_POSITION_MASK, cpu->position) |
 	      FIELD_PREP(RTL8365MB_CPU_CTRL_RXBYTECOUNT_MASK, cpu->rx_length) |
-	      FIELD_PREP(RTL8365MB_CPU_CTRL_TAG_FORMAT_MASK, cpu->format) |
 	      FIELD_PREP(RTL8365MB_CPU_CTRL_TRAP_PORT_MASK, cpu->trap_port & 0x7) |
 	      FIELD_PREP(RTL8365MB_CPU_CTRL_TRAP_PORT_EXT_MASK,
 			 cpu->trap_port >> 3 & 0x1);
-	ret = regmap_write(priv->map, RTL8365MB_CPU_CTRL_REG, val);
+
+	ret = regmap_update_bits(priv->map, RTL8365MB_CPU_CTRL_REG,
+				 RTL8365MB_CPU_CTRL_EN_MASK |
+				 RTL8365MB_CPU_CTRL_INSERTMODE_MASK |
+				 RTL8365MB_CPU_CTRL_RXBYTECOUNT_MASK |
+				 RTL8365MB_CPU_CTRL_TRAP_PORT_MASK |
+				 RTL8365MB_CPU_CTRL_TRAP_PORT_EXT_MASK,
+				 val);
 	if (ret)
 		return ret;
 
@@ -1827,6 +1877,11 @@ static int rtl8365mb_setup(struct dsa_switch *ds)
 		dev_info(priv->dev, "no interrupt support\n");
 
 	/* Configure CPU tagging */
+	ret = rtl8365mb_change_tag_protocol(priv->ds, -1, DSA_TAG_PROTO_RTL8_4);
+	if (ret) {
+		dev_err(priv->dev, "failed to set default tag protocol: %d\n", ret);
+		return ret;
+	}
 	cpu.trap_port = RTL8365MB_MAX_NUM_PORTS;
 	dsa_switch_for_each_cpu_port(cpu_dp, priv->ds) {
 		cpu.mask |= BIT(cpu_dp->index);
@@ -1834,13 +1889,9 @@ static int rtl8365mb_setup(struct dsa_switch *ds)
 		if (cpu.trap_port == RTL8365MB_MAX_NUM_PORTS)
 			cpu.trap_port = cpu_dp->index;
 	}
-
 	cpu.enable = cpu.mask > 0;
 	cpu.insert = RTL8365MB_CPU_INSERT_TO_ALL;
-	cpu.position = RTL8365MB_CPU_POS_AFTER_SA;
 	cpu.rx_length = RTL8365MB_CPU_RXLEN_64BYTES;
-	cpu.format = RTL8365MB_CPU_FORMAT_8BYTES;
-
 	ret = rtl8365mb_cpu_config(priv, &cpu);
 	if (ret)
 		goto out_teardown_irq;
@@ -1982,6 +2033,7 @@ static int rtl8365mb_detect(struct realtek_priv *priv)
 		mb->learn_limit_max = RTL8365MB_LEARN_LIMIT_MAX;
 		mb->jam_table = rtl8365mb_init_jam_8365mb_vc;
 		mb->jam_size = ARRAY_SIZE(rtl8365mb_init_jam_8365mb_vc);
+		mb->tag_protocol = DSA_TAG_PROTO_RTL8_4;
 
 		break;
 	default:
@@ -1996,6 +2048,7 @@ static int rtl8365mb_detect(struct realtek_priv *priv)
 
 static const struct dsa_switch_ops rtl8365mb_switch_ops_smi = {
 	.get_tag_protocol = rtl8365mb_get_tag_protocol,
+	.change_tag_protocol = rtl8365mb_change_tag_protocol,
 	.setup = rtl8365mb_setup,
 	.teardown = rtl8365mb_teardown,
 	.phylink_get_caps = rtl8365mb_phylink_get_caps,
@@ -2014,6 +2067,7 @@ static const struct dsa_switch_ops rtl8365mb_switch_ops_smi = {
 
 static const struct dsa_switch_ops rtl8365mb_switch_ops_mdio = {
 	.get_tag_protocol = rtl8365mb_get_tag_protocol,
+	.change_tag_protocol = rtl8365mb_change_tag_protocol,
 	.setup = rtl8365mb_setup,
 	.teardown = rtl8365mb_teardown,
 	.phylink_get_caps = rtl8365mb_phylink_get_caps,
-- 
2.35.1

