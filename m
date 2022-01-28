Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2755E49F346
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 07:06:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346287AbiA1GGP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 01:06:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346292AbiA1GGL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 01:06:11 -0500
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03534C061714
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 22:06:11 -0800 (PST)
Received: by mail-ot1-x335.google.com with SMTP id w27-20020a9d5a9b000000b005a17d68ae89so4783340oth.12
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 22:06:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pBzQs0zXAle0lneLzeoZDqpUqUrL6+hUiWz8+cxxcvw=;
        b=m6l4Vj+cgrdVVxbgyRtILx1aZTFlxQBsF8uf1eRr2iJTcRxoGTschY1YP3AMdMZbFM
         talphOP5jZUKK/kN3Ve5Mer4VKD5wjZPATy5GoeTJzEeLpn0CnHZ9w0V+hic+wtlcvnz
         zgp8aZ/t4ITM3XR61GOUgmKvJ/tlKJX2jMvklJbtKhiodYD26RK8sTSjCobJsi2BGLGO
         H5k8cqF3HQ/5OeYoN0DcmyIy6WjjN1ejfN6g/kIaxSMqUbnDlJSMRfbGtNu9D1j8ok31
         /m4WSh7cqkLrogOYepmKBbsD7eSeLPMy3JJ4b4St9qHyAgNhccICbRM/14AMtoRfTbIS
         Ioag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pBzQs0zXAle0lneLzeoZDqpUqUrL6+hUiWz8+cxxcvw=;
        b=YZ5SFZhpJy1BF6DdEVrXKQ94qbnlWr+SCi3WrAIccbKxfhhYfAdosHhQP22n3EdFSS
         J246hCJbhm3XVQkvIjhWkphzXJtcs9h6KSDQpIKmJxIpJ3Mov4JSSns+p9fY746TU1PX
         aeD9pKLjTY7iZSS99In/WcciRYwH4tIhI+XUBgO35YpKY8zvqzKKOx+gC3l3HBsz4/dV
         gxrQHosADAW8F5gHcUZxzcvEF3RDoO0MVpqsK00GoOSAjkqOtAFzcErhMvc1UEFI6Rma
         gk8qyCFX+IO9MtzMVWB040lQYyTkXuODBLK4zZcwN+xhk1cWBBddJUp+srzUqJRcHs9y
         sztA==
X-Gm-Message-State: AOAM5331VJbZzNuIxvNOzOB4wuZd77B8pIe7s4DSDmC0xSTC15GPiIEM
        N1Gl2byVoEumQSR7GrwxVNVxm1ZiHndh6A==
X-Google-Smtp-Source: ABdhPJxt3/8N2VNFwVMQuOh8QTZW9hWhRCwDHHZjH8Oa/8NRQhKA8O4l0Al0K8zZeLlsxyN+bkotzg==
X-Received: by 2002:a9d:6e0f:: with SMTP id e15mr3983227otr.101.1643349970171;
        Thu, 27 Jan 2022 22:06:10 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br (187-049-235-234.floripa.net.br. [187.49.235.234])
        by smtp.gmail.com with ESMTPSA id m23sm9790229oos.6.2022.01.27.22.06.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 22:06:09 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, alsi@bang-olufsen.dk,
        arinc.unal@arinc9.com, frank-w@public-files.de,
        davem@davemloft.net, kuba@kernel.org,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net-next v6 09/13] net: dsa: realtek: rtl8365mb: use DSA CPU port
Date:   Fri, 28 Jan 2022 03:05:05 -0300
Message-Id: <20220128060509.13800-10-luizluca@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220128060509.13800-1-luizluca@gmail.com>
References: <20220128060509.13800-1-luizluca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of a fixed CPU port, assume that DSA is correct.

Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Reviewed-by: Alvin Šipraga <alsi@bang-olufsen.dk>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/realtek/rtl8365mb.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
index c2e6ec257a28..d580afc04b8d 100644
--- a/drivers/net/dsa/realtek/rtl8365mb.c
+++ b/drivers/net/dsa/realtek/rtl8365mb.c
@@ -103,7 +103,6 @@
 
 /* Chip-specific data and limits */
 #define RTL8365MB_CHIP_ID_8365MB_VC		0x6367
-#define RTL8365MB_CPU_PORT_NUM_8365MB_VC	6
 #define RTL8365MB_LEARN_LIMIT_MAX_8365MB_VC	2112
 static const int rtl8365mb_extint_port_map[] = { -1, -1, -1, -1, -1, -1, 1 };
 
@@ -111,7 +110,7 @@ static const int rtl8365mb_extint_port_map[] = { -1, -1, -1, -1, -1, -1, 1 };
 #define RTL8365MB_PHYADDRMAX	7
 #define RTL8365MB_NUM_PHYREGS	32
 #define RTL8365MB_PHYREGMAX	(RTL8365MB_NUM_PHYREGS - 1)
-#define RTL8365MB_MAX_NUM_PORTS	(RTL8365MB_CPU_PORT_NUM_8365MB_VC + 1)
+#define RTL8365MB_MAX_NUM_PORTS  7
 
 /* Chip identification registers */
 #define RTL8365MB_CHIP_ID_REG		0x1300
@@ -1821,6 +1820,7 @@ static int rtl8365mb_reset_chip(struct realtek_priv *priv)
 static int rtl8365mb_setup(struct dsa_switch *ds)
 {
 	struct realtek_priv *priv = ds->priv;
+	struct dsa_port *cpu_dp;
 	struct rtl8365mb *mb;
 	int ret;
 	int i;
@@ -1848,9 +1848,17 @@ static int rtl8365mb_setup(struct dsa_switch *ds)
 		dev_info(priv->dev, "no interrupt support\n");
 
 	/* Configure CPU tagging */
-	ret = rtl8365mb_cpu_config(priv);
-	if (ret)
-		goto out_teardown_irq;
+	/* Currently, only one CPU port is supported */
+	dsa_switch_for_each_cpu_port(cpu_dp, priv->ds) {
+		priv->cpu_port = cpu_dp->index;
+		mb->cpu.mask = BIT(priv->cpu_port);
+		mb->cpu.trap_port = priv->cpu_port;
+		ret = rtl8365mb_cpu_config(priv);
+		if (ret)
+			goto out_teardown_irq;
+
+		break;
+	}
 
 	/* Configure ports */
 	for (i = 0; i < priv->num_ports; i++) {
@@ -1962,8 +1970,7 @@ static int rtl8365mb_detect(struct realtek_priv *priv)
 			 "found an RTL8365MB-VC switch (ver=0x%04x)\n",
 			 chip_ver);
 
-		priv->cpu_port = RTL8365MB_CPU_PORT_NUM_8365MB_VC;
-		priv->num_ports = priv->cpu_port + 1;
+		priv->num_ports = RTL8365MB_MAX_NUM_PORTS;
 
 		mb->priv = priv;
 		mb->chip_id = chip_id;
@@ -1974,8 +1981,6 @@ static int rtl8365mb_detect(struct realtek_priv *priv)
 		mb->jam_size = ARRAY_SIZE(rtl8365mb_init_jam_8365mb_vc);
 
 		mb->cpu.enable = 1;
-		mb->cpu.mask = BIT(priv->cpu_port);
-		mb->cpu.trap_port = priv->cpu_port;
 		mb->cpu.insert = RTL8365MB_CPU_INSERT_TO_ALL;
 		mb->cpu.position = RTL8365MB_CPU_POS_AFTER_SA;
 		mb->cpu.rx_length = RTL8365MB_CPU_RXLEN_64BYTES;
-- 
2.34.1

