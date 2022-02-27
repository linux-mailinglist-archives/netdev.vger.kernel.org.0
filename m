Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 605314C5937
	for <lists+netdev@lfdr.de>; Sun, 27 Feb 2022 05:00:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbiB0EAm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Feb 2022 23:00:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbiB0EAk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Feb 2022 23:00:40 -0500
Received: from mail-oo1-xc33.google.com (mail-oo1-xc33.google.com [IPv6:2607:f8b0:4864:20::c33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D3CB1DB3CF
        for <netdev@vger.kernel.org>; Sat, 26 Feb 2022 20:00:04 -0800 (PST)
Received: by mail-oo1-xc33.google.com with SMTP id x6-20020a4a4106000000b003193022319cso13376436ooa.4
        for <netdev@vger.kernel.org>; Sat, 26 Feb 2022 20:00:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fAAbfoWAkozh41TiashIE2Nh7bMINZLLFmcamMlDwks=;
        b=VBzKKa9MMb0ADJS3Sb4mb1k1/wLN6MbFmkmEUfZYPTfwlIoFu34M0w3deKICIyXv13
         Ogk2ZVk/ulN7+3Cxb2qATUtdB0BKKPn9dfAIXFKdtlHy2QxY+ky/KVN4v9FavI9Ti2/5
         zJsY0uzPmHX0YhkOuL5yi0Bu9sx5ahpjb8RW/bn9MZRlWESTGYIz1d5mcfcsBIIB7u3N
         3w9dntP53EdxN+mSxdIIppbEMwoJGZdTGEMQCgsliQsOHdQQMq4Fe3G9FBAW5ho5D0u9
         73HWSIyxClKl2ScH368OcKzRLJB/syQhEyYrwklQGOtrNQ6BiIX9Bb6r4L9wx76CKRZ1
         YrFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fAAbfoWAkozh41TiashIE2Nh7bMINZLLFmcamMlDwks=;
        b=BmPWc/1heMgXNcy/Br4Ic1RFgKa1v+RV0rvLTObMcskbjp6MOqxxkyMeOP9IuHUwVB
         SBmYeV0j/JtwFAvwNybzfrBobrt2dcsaZU/Dqw8aMZyltdr6K7GXMtftcQkAlr3sTTk8
         pVyI9BWdIYvOphBXhCCIrZ9i60JKK3oMM5zF5o1mmfOOOgPC8SdP0UknMp7TO4NNEd5R
         iDmiU5Sfjd576NyMpf5bMzQuK2N2c0QK1mY+90xNhO2nYS8PHg0pBfRL8YosDmW/QFor
         /1wMcH2tVjzbODiv/YksWoiNCD2/Lzem1EmfG868nMnxxWtAMM4Y+DjMHpX2RyMLxxBx
         BXww==
X-Gm-Message-State: AOAM530LocwcDE6VGU+w6T2f1GFUXz9TLxf5hkUjQ5hyKqE16s5ivI1O
        6zW7pijRaOvwp7Jkkg+YioeXAtWVdRN7xw==
X-Google-Smtp-Source: ABdhPJzHXuxF05U1xLb6c0oWq+GtDW+pqVz3FuhrnWDMiWBX5iDybvb9NPBlU6bn7O33EnPD50uQEg==
X-Received: by 2002:a05:6870:70a8:b0:d3:e21:8545 with SMTP id v40-20020a05687070a800b000d30e218545mr5082671oae.321.1645934403024;
        Sat, 26 Feb 2022 20:00:03 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br ([187.94.103.218])
        by smtp.gmail.com with ESMTPSA id t9-20020a056871054900b000c53354f98esm3010285oal.13.2022.02.26.20.00.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Feb 2022 20:00:02 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, alsi@bang-olufsen.dk, arinc.unal@arinc9.com,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net-next v4 3/3] net: dsa: realtek: rtl8365mb: add support for rtl8_4t
Date:   Sun, 27 Feb 2022 00:59:20 -0300
Message-Id: <20220227035920.19101-4-luizluca@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220227035920.19101-1-luizluca@gmail.com>
References: <20220227035920.19101-1-luizluca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FROM_FMBLA_NEWDOM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The trailing tag is also supported by this family. The default is still
rtl8_4 but now the switch supports changing the tag to rtl8_4t.

Reintroduce the dropped cpu in struct rtl8365mb (removed by 6147631).

Reviewed-by: Alvin Šipraga <alsi@bang-olufsen.dk>
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

