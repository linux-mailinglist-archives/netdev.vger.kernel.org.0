Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 119A64CB490
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 02:57:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231556AbiCCBxw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 20:53:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231538AbiCCBxr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 20:53:47 -0500
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F350410FCA
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 17:53:01 -0800 (PST)
Received: by mail-oi1-x232.google.com with SMTP id x193so3547964oix.0
        for <netdev@vger.kernel.org>; Wed, 02 Mar 2022 17:53:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AIdjF7WUvUHvNnU54Sb7r/I613K9pcz5Krr/RR6daH8=;
        b=SjZAREWnVz+gbcAKvwx0BUGL5j/DyufVsUk+XmtOG1y1Bs7NWXfkGB3KY3ci/dYe0+
         Cl5TTwKGL2oSNqKhdl0UVGc38g6gt7pgLAskBhyRDPwVqZJfDY2DF9xF8uAYyY+j6FZ2
         0pqLONGNedSu8kuaIHcvcyy5cmy2zfIph27FjqTLxpsWUT5B7ul4/XOZ+JscH1gpNDu9
         sxpP48vRncN0aHcj3j9F4lN6VCDjX7Oar+nZDfyonqBGgid2YOWyLiYD8Wf5rqY3Vs9r
         X0vXLD9VBIw7nzDZP6scOtq0ZxYxEt8JU2NfzeVNES0i9W3UzPsc/DIBgnWqcACFqfNF
         Bh2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AIdjF7WUvUHvNnU54Sb7r/I613K9pcz5Krr/RR6daH8=;
        b=MaULwpl0FX9qey/DPtucgzpH2TsDroiZVi8jPtTpT5AtV+3c+pKTxGBC8wLy+P7U1d
         YsAym79GUIg+pBgU9L4Ku8K7dueRdpDFMkEX+DIFoae6uAPsrXMc3Zbpw6hO1uLI0oPa
         0CKTjIAbf7av22HCTtHPhjaQifBmS2E7tP8UxbvAzLTUcoO0l3DE58JnPje4MTELA6xt
         oDyOefTGydqJGg2OAR5lp/bNVspnMpeo76d8fkwao76AVYM1wUa+CVb3p/KmNPiUxBFw
         wOuxnezquTW4pJv1EPpuu93H5ArkrNrrtd4rmP2HIbBLuWF5cd9ABahcNYX8M0Sqnpv9
         CQVQ==
X-Gm-Message-State: AOAM531ZD6awD6ntwbT6QnECyK5EVBaaR449gjoAvuAC5V6fXVyxJLQC
        QiIg4yJjvyEErZt8OyNxnDfae02R8l8=
X-Google-Smtp-Source: ABdhPJwICuAde2zpywg2tJZG7bHLUMx5zqN0IeTlILHCX3YGaQvDm9lQfvX6gXrMlAd9NzEdEWdkGQ==
X-Received: by 2002:a05:6808:300b:b0:2d0:a492:e489 with SMTP id ay11-20020a056808300b00b002d0a492e489mr2501794oib.171.1646272381121;
        Wed, 02 Mar 2022 17:53:01 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br (187-049-235-234.floripa.net.br. [187.49.235.234])
        by smtp.gmail.com with ESMTPSA id a10-20020a05687073ca00b000d128dfeebfsm446310oan.2.2022.03.02.17.52.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 17:53:00 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, alsi@bang-olufsen.dk, arinc.unal@arinc9.com,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net-next v5 3/3] net: dsa: realtek: rtl8365mb: add support for rtl8_4t
Date:   Wed,  2 Mar 2022 22:52:35 -0300
Message-Id: <20220303015235.18907-4-luizluca@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220303015235.18907-1-luizluca@gmail.com>
References: <20220303015235.18907-1-luizluca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
Reviewed-by: Alvin Šipraga <alsi@bang-olufsen.dk>
---
 drivers/net/dsa/realtek/rtl8365mb.c | 77 +++++++++++++++++++++++------
 1 file changed, 62 insertions(+), 15 deletions(-)

diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
index 2ed592147c20..3e373379ecaa 100644
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
 
@@ -1752,6 +1766,37 @@ static int rtl8365mb_cpu_config(struct realtek_priv *priv, const struct rtl8365m
 	return 0;
 }
 
+static int rtl8365mb_change_tag_protocol(struct dsa_switch *ds, int cpu_index,
+					 enum dsa_tag_protocol proto)
+{
+	struct realtek_priv *priv = ds->priv;
+	struct rtl8365mb_cpu *cpu;
+	struct rtl8365mb *mb;
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
+	return rtl8365mb_cpu_config(priv);
+}
+
 static int rtl8365mb_switch_init(struct realtek_priv *priv)
 {
 	struct rtl8365mb *mb = priv->chip_data;
@@ -1798,13 +1843,14 @@ static int rtl8365mb_reset_chip(struct realtek_priv *priv)
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
@@ -1827,21 +1873,14 @@ static int rtl8365mb_setup(struct dsa_switch *ds)
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
 
@@ -1853,7 +1892,7 @@ static int rtl8365mb_setup(struct dsa_switch *ds)
 			continue;
 
 		/* Forward only to the CPU */
-		ret = rtl8365mb_port_set_isolation(priv, i, cpu.mask);
+		ret = rtl8365mb_port_set_isolation(priv, i, cpu->mask);
 		if (ret)
 			goto out_teardown_irq;
 
@@ -1983,6 +2022,12 @@ static int rtl8365mb_detect(struct realtek_priv *priv)
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
@@ -1996,6 +2041,7 @@ static int rtl8365mb_detect(struct realtek_priv *priv)
 
 static const struct dsa_switch_ops rtl8365mb_switch_ops_smi = {
 	.get_tag_protocol = rtl8365mb_get_tag_protocol,
+	.change_tag_protocol = rtl8365mb_change_tag_protocol,
 	.setup = rtl8365mb_setup,
 	.teardown = rtl8365mb_teardown,
 	.phylink_get_caps = rtl8365mb_phylink_get_caps,
@@ -2014,6 +2060,7 @@ static const struct dsa_switch_ops rtl8365mb_switch_ops_smi = {
 
 static const struct dsa_switch_ops rtl8365mb_switch_ops_mdio = {
 	.get_tag_protocol = rtl8365mb_get_tag_protocol,
+	.change_tag_protocol = rtl8365mb_change_tag_protocol,
 	.setup = rtl8365mb_setup,
 	.teardown = rtl8365mb_teardown,
 	.phylink_get_caps = rtl8365mb_phylink_get_caps,
-- 
2.35.1

