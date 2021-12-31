Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6298D4821FD
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 05:35:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242687AbhLaEe7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 23:34:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242707AbhLaEe6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 23:34:58 -0500
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE2A2C061574
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 20:34:57 -0800 (PST)
Received: by mail-qt1-x82f.google.com with SMTP id z9so23439453qtj.9
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 20:34:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eruuyziWa/zKl7K+Mr+HXOYkPiLo2t9fZcz0f1RKY+A=;
        b=VjP85KESXgcFmjAJ6fc8nwzxYZsgit3BjDb/kjflTFrXOWyFlLSmdjuZqwGqsl/whV
         QT0JAgJbUThbo3lZ8EhLhntjl/s+aYEyKmfTecSnF+Z0hUZLyCaLo/A8NCo1Uv9IAUNz
         GULTzXIINdrzVodV4V9jSh3pP/cVVvBCc2KY0nr4rUJ1yc5KVVsACiYO+ZJXB4wNu/pm
         CnSJf8jS11181JCd3D7kYcmmkyNFbNNexTOKj1n0sVvwnGau2LDxlrmcgX7tCIOC/pkI
         71OUoBlVD0XLBzP9KKOEChJk2HOmhaIvT9VJMfPiehF6SsSUvqdbf5brS/d4axFsjlHx
         MOQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eruuyziWa/zKl7K+Mr+HXOYkPiLo2t9fZcz0f1RKY+A=;
        b=06npeXMJ5IWmzmJEJv+vbrGky3pZykw83aO9dEsKyPG+pjeMr1+BErlifm9DYiaYb2
         YMEEKVFe4T9HD7TdjLCBqftU8ud0aX3BfSEEEHn6oU9VDevKktWEixH1+hQ46b5Bsq59
         az/pJscVu3L1LqIBRnKGE2IlO+PhyPAMiNOiPwCGiVe29aXJSKCUBS8ux/Zblbhw818Y
         4kBSBflc2eXK6z1nmWqW//W2OmXGToPmvsjpO+ESUtpFb98RitzFxUAMnIpbqRXB4QRj
         /tg9e81FUKkjE82cAjrCQKVITwse9rh5rPwp/GvQV+FVmjZI76L0HDeajl+4tiDyVrJE
         CbbQ==
X-Gm-Message-State: AOAM533sutzI/LZkdPh40jW/w1sKF795HqXdVoYN2vHW4tLn5aQtCS8L
        HDCyE9ifgLAOVHYoRDfk2BAFZ2BFp+lXOZUg
X-Google-Smtp-Source: ABdhPJzbvZN/XPU1enfMJpVaoVQZFwtp4rZ1/S/ht26ZmX1S0UvjvnE5h6SEtnjDi340oDADno+YOQ==
X-Received: by 2002:ac8:7dcd:: with SMTP id c13mr29115790qte.133.1640925296796;
        Thu, 30 Dec 2021 20:34:56 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br ([187.94.103.218])
        by smtp.gmail.com with ESMTPSA id i5sm8020030qti.27.2021.12.30.20.34.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Dec 2021 20:34:56 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, alsi@bang-olufsen.dk,
        arinc.unal@arinc9.com, frank-w@public-files.de,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net-next v3 09/11] net: dsa: realtek: rtl8365mb: use DSA CPU port
Date:   Fri, 31 Dec 2021 01:33:04 -0300
Message-Id: <20211231043306.12322-10-luizluca@gmail.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211231043306.12322-1-luizluca@gmail.com>
References: <20211231043306.12322-1-luizluca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of a fixed CPU port, assume that DSA is correct.

Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 drivers/net/dsa/realtek/rtl8365mb.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
index b22f50a9d1ef..168e857a4e34 100644
--- a/drivers/net/dsa/realtek/rtl8365mb.c
+++ b/drivers/net/dsa/realtek/rtl8365mb.c
@@ -103,14 +103,13 @@
 
 /* Chip-specific data and limits */
 #define RTL8365MB_CHIP_ID_8365MB_VC		0x6367
-#define RTL8365MB_CPU_PORT_NUM_8365MB_VC	6
 #define RTL8365MB_LEARN_LIMIT_MAX_8365MB_VC	2112
 
 /* Family-specific data and limits */
 #define RTL8365MB_PHYADDRMAX	7
 #define RTL8365MB_NUM_PHYREGS	32
 #define RTL8365MB_PHYREGMAX	(RTL8365MB_NUM_PHYREGS - 1)
-#define RTL8365MB_MAX_NUM_PORTS	(RTL8365MB_CPU_PORT_NUM_8365MB_VC + 1)
+#define RTL8365MB_MAX_NUM_PORTS  7
 
 /* Chip identification registers */
 #define RTL8365MB_CHIP_ID_REG		0x1300
@@ -1833,9 +1832,18 @@ static int rtl8365mb_setup(struct dsa_switch *ds)
 		dev_info(priv->dev, "no interrupt support\n");
 
 	/* Configure CPU tagging */
-	ret = rtl8365mb_cpu_config(priv);
-	if (ret)
-		goto out_teardown_irq;
+	for (i = 0; i < priv->num_ports; i++) {
+		if (!(dsa_is_cpu_port(priv->ds, i)))
+			continue;
+		priv->cpu_port = i;
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
@@ -1967,8 +1975,7 @@ static int rtl8365mb_detect(struct realtek_priv *priv)
 			 "found an RTL8365MB-VC switch (ver=0x%04x)\n",
 			 chip_ver);
 
-		priv->cpu_port = RTL8365MB_CPU_PORT_NUM_8365MB_VC;
-		priv->num_ports = priv->cpu_port + 1;
+		priv->num_ports = RTL8365MB_MAX_NUM_PORTS;
 
 		mb->priv = priv;
 		mb->chip_id = chip_id;
@@ -1979,8 +1986,6 @@ static int rtl8365mb_detect(struct realtek_priv *priv)
 		mb->jam_size = ARRAY_SIZE(rtl8365mb_init_jam_8365mb_vc);
 
 		mb->cpu.enable = 1;
-		mb->cpu.mask = BIT(priv->cpu_port);
-		mb->cpu.trap_port = priv->cpu_port;
 		mb->cpu.insert = RTL8365MB_CPU_INSERT_TO_ALL;
 		mb->cpu.position = RTL8365MB_CPU_POS_AFTER_SA;
 		mb->cpu.rx_length = RTL8365MB_CPU_RXLEN_64BYTES;
-- 
2.34.0

