Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8C0C4799A1
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 09:15:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232373AbhLRIPc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 03:15:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232364AbhLRIP2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 03:15:28 -0500
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E079C061574
        for <netdev@vger.kernel.org>; Sat, 18 Dec 2021 00:15:27 -0800 (PST)
Received: by mail-qk1-x732.google.com with SMTP id 132so4507624qkj.11
        for <netdev@vger.kernel.org>; Sat, 18 Dec 2021 00:15:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9wMuZPFiUvo7VkO+sWGasvHhWQR02RIhkYImmn+advE=;
        b=m0dYMCq5eOl3HZ4XhPL+t+r19YGsabrSaXyA4or0uEqKcMvIb357QogRaJEk3ClVkp
         EfDw15sDadA9+8Kkt2VkSrocZ6awlN7izRRHvGvtwPuGb74uhJd2rdQ1gp5PyJ+j34Xv
         ZkO803ffe9oYSIAoxMQV37/q/7288zvJ6SMBdrIqcHkRMj7DJwDDF+QOYqPXLYRy0sTE
         KAW3inuVrKrCB/ONOUPvPbS61hpV158KhYXnn/+pxLBFvMUZ4U2Ng6/oax+c2qwCDnxy
         O98IdtbzHkgl6ZJUCslLs30F4oXHRshwZBMvQmAgKGKVdPhtRfUzXP94/erNr/dMN8EH
         XCyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9wMuZPFiUvo7VkO+sWGasvHhWQR02RIhkYImmn+advE=;
        b=LWgiSGKD0Wlc3ab+yW2LqD6Uvad3YLvsFNpHjSFijsv9pI91yV/0Fq+5RdI8Repmj2
         IDG1r8zSsspQRwXj2mCezvYIU6ZulUkkOr6KlroVF2rLxzgolVAxKCjKWoY9ipmIul9P
         yXiAqrm14LYHvCEmZ1jzSUEF3+fptMfioW7wdKQWMtyidMrJP4qxar4n/gToOtv93xqc
         2sD9Kx+ydvtoaxPmewp6lb/2+FLhED275vNVZawDBFSAyJXwypQ40A2d6RS6dy5t1ztL
         nFrk/sTMTfhl+OYdVnz6ymtyrNuQtbdPiq3DZr+CdEXfOE7QjrWOeO7f0nTcVSG3ukky
         1LVw==
X-Gm-Message-State: AOAM532aETykFm9Yd6sJwcVg8YUVlgYW42tJqev6CX35KgdSi3sIMzJp
        Gs4OIsB0BWsrO/4uoKCB+R6kFg2bIaCgjg==
X-Google-Smtp-Source: ABdhPJxGISkbGXyWjwxoyU3B+uEuQ2LnrDtHsBiRjVnBUI56Pn/JgnlZzRZ03TW/k3/hQnpP6X+USg==
X-Received: by 2002:a05:620a:d87:: with SMTP id q7mr4103669qkl.377.1639815326341;
        Sat, 18 Dec 2021 00:15:26 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br (187-049-235-234.floripa.net.br. [187.49.235.234])
        by smtp.gmail.com with ESMTPSA id f11sm6423357qko.84.2021.12.18.00.15.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Dec 2021 00:15:25 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, alsi@bang-olufsen.dk,
        arinc.unal@arinc9.com,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net-next v2 11/13] net: dsa: realtek: rtl8365mb: use DSA CPU port
Date:   Sat, 18 Dec 2021 05:14:23 -0300
Message-Id: <20211218081425.18722-12-luizluca@gmail.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211218081425.18722-1-luizluca@gmail.com>
References: <20211216201342.25587-1-luizluca@gmail.com>
 <20211218081425.18722-1-luizluca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of a fixed CPU port, assume that DSA is correct.

Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
---
 drivers/net/dsa/realtek/rtl8365mb.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
index a8f44538a87a..b79a4639b283 100644
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
@@ -1827,9 +1826,18 @@ static int rtl8365mb_setup(struct dsa_switch *ds)
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
@@ -1960,8 +1968,7 @@ static int rtl8365mb_detect(struct realtek_priv *priv)
 			 "found an RTL8365MB-VC switch (ver=0x%04x)\n",
 			 chip_ver);
 
-		priv->cpu_port = RTL8365MB_CPU_PORT_NUM_8365MB_VC;
-		priv->num_ports = priv->cpu_port + 1;
+		priv->num_ports = RTL8365MB_MAX_NUM_PORTS;
 
 		mb->priv = priv;
 		mb->chip_id = chip_id;
@@ -1972,8 +1979,6 @@ static int rtl8365mb_detect(struct realtek_priv *priv)
 		mb->jam_size = ARRAY_SIZE(rtl8365mb_init_jam_8365mb_vc);
 
 		mb->cpu.enable = 1;
-		mb->cpu.mask = BIT(priv->cpu_port);
-		mb->cpu.trap_port = priv->cpu_port;
 		mb->cpu.insert = RTL8365MB_CPU_INSERT_TO_ALL;
 		mb->cpu.position = RTL8365MB_CPU_POS_AFTER_SA;
 		mb->cpu.rx_length = RTL8365MB_CPU_RXLEN_64BYTES;
-- 
2.34.0

