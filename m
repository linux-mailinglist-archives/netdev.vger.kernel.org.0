Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7EFC477D30
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 21:15:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241263AbhLPUOu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 15:14:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241257AbhLPUOs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 15:14:48 -0500
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D20AEC061574
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 12:14:47 -0800 (PST)
Received: by mail-qt1-x835.google.com with SMTP id t11so444369qtw.3
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 12:14:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VyqmtVk4BF4S8fw2AGDQkytFyYmjt7Tp2U4twupOWd8=;
        b=d+esC13fmBAhrtGjf1SL/QxhNFK6qaC3kZs1snhkm9kFx7jw4mPKgd4OZ7Rx+1Nmi3
         aka/pU32kIiKrqNMkacNdJeS5ENn2V1yb1YUNoGs0OtFp2T4R9q28sHX50nrmNCvlkSN
         3aqWZsXPd878YEsqVPrMkolzWx/zc0HYQOOOGdThQaYSMpUqmD9e4swQkMA9j3+lqDj2
         d2+A9TDAyHSbpIcQ27AknkPtqvY9mGkO28u5xzfVnXJNDNnwXKApqe+s9bZqNki+24CS
         LxrVQmrmk+aFhBkmMwF8qUPO/N+vXdtysfjLV6UhTErVDcfcIizL2UW2OCPvURn+Waju
         KbfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VyqmtVk4BF4S8fw2AGDQkytFyYmjt7Tp2U4twupOWd8=;
        b=7uGBdQlSl9nQ5GRgQpWm6D9fTQ4wkCAM20ogRGcyaNAZbGtfBEz9vhTG8ewwOhNM6M
         bUGx9bnspACpWjdBLUOj09NPXG1GZ4Db/bXsDbTCmB9WKm0taXpNTG/+ydoymfwzCicI
         f1q5OdjlfdLW6AFoKcmT4l3WVsCzkuYAX0M6I3H/lziAwU+YAQ6+IdeNcF0/8CY0ohBF
         hvCc34YF954epqrh7fbGXttQyUQD5N01uipBLFZDqSdLHCIYw14u047OzJSYS6vqPE77
         2zdrS71qZdSQFyLbNlI8Sebd0/1msvuLjNE1noowLb3NP1tBszQS4qzhV8kIAvlT5cTe
         DaJA==
X-Gm-Message-State: AOAM531F5MQfO6gx7wQkhsBOtWT/5oOBpk9sv0vzpJ1Rtl8OIa8ObzjZ
        lM8Zi7cOyoGOavmwpx2h0oBbw/pDICC9Mw==
X-Google-Smtp-Source: ABdhPJwjnQjXHtaOazOrXspyv3eU/xCQk2CscIVycej92bWLcTAZACFZYv4yuFDyiZPB3cN8FBW1yA==
X-Received: by 2002:a05:622a:42:: with SMTP id y2mr19048449qtw.250.1639685686832;
        Thu, 16 Dec 2021 12:14:46 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br (187-049-235-234.floripa.net.br. [187.49.235.234])
        by smtp.gmail.com with ESMTPSA id a15sm5110266qtb.5.2021.12.16.12.14.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 12:14:46 -0800 (PST)
From:   luizluca@gmail.com
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, alsi@bang-olufsen.dk,
        arinc.unal@arinc9.com,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net-next 12/13] net: dsa: realtek: rtl8367c: use DSA CPU port
Date:   Thu, 16 Dec 2021 17:13:41 -0300
Message-Id: <20211216201342.25587-13-luizluca@gmail.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211216201342.25587-1-luizluca@gmail.com>
References: <20211216201342.25587-1-luizluca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luiz Angelo Daros de Luca <luizluca@gmail.com>

Instead of a fixed CPU port, assume that DSA is correct.

Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
---
 drivers/net/dsa/realtek/rtl8367c.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/net/dsa/realtek/rtl8367c.c b/drivers/net/dsa/realtek/rtl8367c.c
index f370ea948c59..a478ddc33a9e 100644
--- a/drivers/net/dsa/realtek/rtl8367c.c
+++ b/drivers/net/dsa/realtek/rtl8367c.c
@@ -91,7 +91,6 @@
 
 /* Chip-specific data and limits */
 #define RTL8367C_CHIP_ID_8365MB_VC		0x6367
-#define RTL8367C_CPU_PORT_NUM_8365MB_VC		6
 
 #define RTL8367C_LEARN_LIMIT_MAX	2112
 
@@ -99,7 +98,7 @@
 #define RTL8367C_PHYADDRMAX	7
 #define RTL8367C_NUM_PHYREGS	32
 #define RTL8367C_PHYREGMAX	(RTL8367C_NUM_PHYREGS - 1)
-#define RTL8367C_MAX_NUM_PORTS	(RTL8367C_CPU_PORT_NUM_8365MB_VC + 1)
+#define RTL8367C_MAX_NUM_PORTS  7
 
 /* Chip identification registers */
 #define RTL8367C_CHIP_ID_REG		0x1300
@@ -1816,9 +1815,18 @@ static int rtl8367c_setup(struct dsa_switch *ds)
 		dev_info(priv->dev, "no interrupt support\n");
 
 	/* Configure CPU tagging */
-	ret = rtl8367c_cpu_config(priv);
-	if (ret)
-		goto out_teardown_irq;
+	for (i = 0; i < priv->num_ports; i++) {
+		if (!(dsa_is_cpu_port(priv->ds, i)))
+			continue;
+		priv->cpu_port = i;
+		mb->cpu.mask = BIT(priv->cpu_port);
+		mb->cpu.trap_port = priv->cpu_port;
+		ret = rtl8367c_cpu_config(priv);
+		if (ret)
+			goto out_teardown_irq;
+
+		break;
+	}
 
 	/* Configure ports */
 	for (i = 0; i < priv->num_ports; i++) {
@@ -1949,8 +1957,7 @@ static int rtl8367c_detect(struct realtek_priv *priv)
 			"found an RTL8365MB-VC switch (ver=0x%04x)\n",
 			chip_ver);
 
-		priv->cpu_port = RTL8367C_CPU_PORT_NUM_8365MB_VC;
-		priv->num_ports = priv->cpu_port + 1;
+		priv->num_ports = RTL8367C_MAX_NUM_PORTS;
 
 		mb->priv = priv;
 		mb->chip_id = chip_id;
@@ -1961,8 +1968,6 @@ static int rtl8367c_detect(struct realtek_priv *priv)
 		mb->jam_size = ARRAY_SIZE(rtl8367c_init_jam_8367c);
 
 		mb->cpu.enable = 1;
-		mb->cpu.mask = BIT(priv->cpu_port);
-		mb->cpu.trap_port = priv->cpu_port;
 		mb->cpu.insert = RTL8367C_CPU_INSERT_TO_ALL;
 		mb->cpu.position = RTL8367C_CPU_POS_AFTER_SA;
 		mb->cpu.rx_length = RTL8367C_CPU_RXLEN_64BYTES;
-- 
2.34.0

