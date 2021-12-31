Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00E8A4821FF
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 05:35:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242697AbhLaEfF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 23:35:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242692AbhLaEfE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 23:35:04 -0500
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A630C061574
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 20:35:04 -0800 (PST)
Received: by mail-qt1-x82f.google.com with SMTP id m18so23002315qtk.3
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 20:35:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8gUpYjZB4WwGYlr9Bef9EgwemaUQ3FZbAYd9Rti6uP8=;
        b=HRMWOY3p1vBSBCfAiPR/aYdbhPkiUOUpHttf0KKvtObROaThj4BXtcoldTNsRi7fd8
         B1y+EgILblGdbY0j7zo7NQJDG8Lj2YebU/BQd1PQ2Mjcs/x0CMspQxYrnfOWZGXCgl7w
         YKWcztYqtEEGVSNCsilny33aR1M91BVdbJGq3+o4PlfXUWJwTGcp9KLAHl1JzuSLrQhx
         yEWjtCJb9nMK2xgZ5EnnSygfr1W0tntf1VrH2qhatigp0fv00uithOYNhMMCDIjhcxmq
         oBSpeFgADKBs1vm/xBkAuFEYCu+IUVTb+j2ua0J/N1P4CeajQJYTZ/e0y72qW75p1fNM
         jhCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8gUpYjZB4WwGYlr9Bef9EgwemaUQ3FZbAYd9Rti6uP8=;
        b=eY1+gO4neFH6DsBtH32SZ6ibU2WBhqAmrWPYe+QbI9mlFMSCSDLh9oaX26/zdHOcXl
         r1pHr0ubl23546P76B4rTJ4xiFVG4+3cRpQF82fzGCrtaQ+e2cnFdjItPe03eBHMubV5
         EppFAaJMTSnnHKy4cowm3ZMxp0nyC2RCzxmPA4rEJn7W3+FP6itThf95BIImOn+XKGLm
         /WbsmjXc3gNniZRekbol0FADRRDMZlQggg7romJiZwcoMlnla//nspjE5WAIuF4jks8j
         S3n4vTRx63LMMhhbmoFEmOEtHb4jVg40BHargGnPoRzC9wIAqrHwKcaW2jyYR+w+gxY6
         LxTw==
X-Gm-Message-State: AOAM530LSMbku0lDCoI+NLLlY8lL1LfLO/R4l8C9Clbjsw+CmJiKmdSK
        Unis/d4zrsW56vNJxn4d7p6PR6mZ9fphRTw5
X-Google-Smtp-Source: ABdhPJxmNEkspVFQSsf9reEmXtgQZ43P+RBTw32YsiQakfZQRORn1Fmpnpp+k8kWDr9pPrjnz+JePw==
X-Received: by 2002:a05:622a:613:: with SMTP id z19mr29490366qta.674.1640925303280;
        Thu, 30 Dec 2021 20:35:03 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br ([187.94.103.218])
        by smtp.gmail.com with ESMTPSA id i5sm8020030qti.27.2021.12.30.20.35.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Dec 2021 20:35:02 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, alsi@bang-olufsen.dk,
        arinc.unal@arinc9.com, frank-w@public-files.de,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net-next v3 11/11] net: dsa: realtek: rtl8365mb: multiple cpu ports, non cpu extint
Date:   Fri, 31 Dec 2021 01:33:06 -0300
Message-Id: <20211231043306.12322-12-luizluca@gmail.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211231043306.12322-1-luizluca@gmail.com>
References: <20211231043306.12322-1-luizluca@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now CPU port is not limited to a single port. Also, extint can be used
as non-cpu ports, as long as it defines relatek,ext-int. The last cpu
port will be used as trap_port.

The CPU information was dropped from chip data as it was not used
outside setup. The only other place it was used is when it wrongly
checks for CPU port when it should check for extint.

realtek_priv->cpu_port is now only used by rtl8366rb.c

Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
---
 drivers/net/dsa/realtek/rtl8365mb.c | 55 +++++++++++++++--------------
 1 file changed, 29 insertions(+), 26 deletions(-)

diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
index 8b6f729f843c..bf3d4b8cf23b 100644
--- a/drivers/net/dsa/realtek/rtl8365mb.c
+++ b/drivers/net/dsa/realtek/rtl8365mb.c
@@ -556,7 +556,6 @@ struct rtl8365mb_port {
  * @chip_ver: chip silicon revision
  * @port_mask: mask of all ports
  * @learn_limit_max: maximum number of L2 addresses the chip can learn
- * @cpu: CPU tagging and CPU port configuration for this chip
  * @mib_lock: prevent concurrent reads of MIB counters
  * @ports: per-port data
  * @jam_table: chip-specific initialization jam table
@@ -571,7 +570,6 @@ struct rtl8365mb {
 	u32 chip_ver;
 	u32 port_mask;
 	u32 learn_limit_max;
-	struct rtl8365mb_cpu cpu;
 	struct mutex mib_lock;
 	struct rtl8365mb_port ports[RTL8365MB_MAX_NUM_PORTS];
 	const struct rtl8365mb_jam_tbl_entry *jam_table;
@@ -769,17 +767,20 @@ static int rtl8365mb_ext_config_rgmii(struct realtek_priv *priv, int port,
 	u32 val;
 	int ret;
 
-	if (port != priv->cpu_port) {
-		dev_err(priv->dev, "only one EXT interface is currently supported\n");
+	mb = priv->chip_data;
+	p = &mb->ports[port];
+	ext_int = p->ext_int;
+
+	if (ext_int == RTL8365MB_NOT_EXT) {
+		dev_err(priv->dev,
+			"Port %d is not identified as extenal interface.\n",
+			port);
 		return -EINVAL;
 	}
 
 	dp = dsa_to_port(priv->ds, port);
 	dn = dp->dn;
 
-	mb = priv->chip_data;
-	p = &mb->ports[port];
-	ext_int = p->ext_int;
 
 	/* Set the RGMII TX/RX delay
 	 *
@@ -859,15 +860,17 @@ static int rtl8365mb_ext_config_forcemode(struct realtek_priv *priv, int port,
 	int val;
 	int ret;
 
-	if (port != priv->cpu_port) {
-		dev_err(priv->dev, "only one EXT interface is currently supported\n");
-		return -EINVAL;
-	}
-
 	mb = priv->chip_data;
 	p = &mb->ports[port];
 	ext_int = p->ext_int;
 
+	if (ext_int == RTL8365MB_NOT_EXT) {
+		dev_err(priv->dev,
+			"Port %d is not identified as extenal interface.\n",
+			port);
+		return -EINVAL;
+	}
+
 	if (link) {
 		/* Force the link up with the desired configuration */
 		r_link = 1;
@@ -1734,10 +1737,8 @@ static void rtl8365mb_irq_teardown(struct realtek_priv *priv)
 	}
 }
 
-static int rtl8365mb_cpu_config(struct realtek_priv *priv)
+static int rtl8365mb_cpu_config(struct realtek_priv *priv, struct rtl8365mb_cpu *cpu)
 {
-	struct rtl8365mb *mb = priv->chip_data;
-	struct rtl8365mb_cpu *cpu = &mb->cpu;
 	u32 val;
 	int ret;
 
@@ -1810,6 +1811,7 @@ static int rtl8365mb_reset_chip(struct realtek_priv *priv)
 static int rtl8365mb_setup(struct dsa_switch *ds)
 {
 	struct realtek_priv *priv = ds->priv;
+	struct rtl8365mb_cpu cpu;
 	struct rtl8365mb *mb;
 	int ret;
 	int i;
@@ -1837,13 +1839,20 @@ static int rtl8365mb_setup(struct dsa_switch *ds)
 		dev_info(priv->dev, "no interrupt support\n");
 
 	/* Configure CPU tagging */
+	cpu.mask = 0;
 	for (i = 0; i < priv->num_ports; i++) {
 		if (!(dsa_is_cpu_port(priv->ds, i)))
 			continue;
-		priv->cpu_port = i;
-		mb->cpu.mask = BIT(priv->cpu_port);
-		mb->cpu.trap_port = priv->cpu_port;
-		ret = rtl8365mb_cpu_config(priv);
+
+		cpu.enable = 1;
+		cpu.insert = RTL8365MB_CPU_INSERT_TO_ALL;
+		cpu.position = RTL8365MB_CPU_POS_AFTER_SA;
+		cpu.rx_length = RTL8365MB_CPU_RXLEN_64BYTES;
+		cpu.format = RTL8365MB_CPU_FORMAT_8BYTES;
+		cpu.trap_port = i;
+		cpu.mask |= BIT(i);
+
+		ret = rtl8365mb_cpu_config(priv, &cpu);
 		if (ret)
 			goto out_teardown_irq;
 
@@ -1862,7 +1871,7 @@ static int rtl8365mb_setup(struct dsa_switch *ds)
 		dn = dsa_to_port(priv->ds, i)->dn;
 
 		/* Forward only to the CPU */
-		ret = rtl8365mb_port_set_isolation(priv, i, BIT(priv->cpu_port));
+		ret = rtl8365mb_port_set_isolation(priv, i, cpu.mask);
 		if (ret)
 			goto out_teardown_irq;
 
@@ -2003,12 +2012,6 @@ static int rtl8365mb_detect(struct realtek_priv *priv)
 		mb->jam_table = rtl8365mb_init_jam_8365mb_vc;
 		mb->jam_size = ARRAY_SIZE(rtl8365mb_init_jam_8365mb_vc);
 
-		mb->cpu.enable = 1;
-		mb->cpu.insert = RTL8365MB_CPU_INSERT_TO_ALL;
-		mb->cpu.position = RTL8365MB_CPU_POS_AFTER_SA;
-		mb->cpu.rx_length = RTL8365MB_CPU_RXLEN_64BYTES;
-		mb->cpu.format = RTL8365MB_CPU_FORMAT_8BYTES;
-
 		break;
 	default:
 		dev_err(priv->dev,
-- 
2.34.0

