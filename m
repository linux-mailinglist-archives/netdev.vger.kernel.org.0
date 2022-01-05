Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D7B5484CCB
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 04:16:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237216AbiAEDQO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 22:16:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237208AbiAEDQN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 22:16:13 -0500
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8A0CC061761
        for <netdev@vger.kernel.org>; Tue,  4 Jan 2022 19:16:13 -0800 (PST)
Received: by mail-qt1-x82b.google.com with SMTP id m25so36173651qtq.13
        for <netdev@vger.kernel.org>; Tue, 04 Jan 2022 19:16:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HIpkXJbPDvdmjWxeyg9Tvklt18VI8wkPqdX0zVrTl5o=;
        b=hzGFZHfTI7p4Mmdz3uUs/MMFov5H2Vnm2GFhaB18qNTJPORahu853ZVIKxUePXNexQ
         4zzm8WwuTkDezXi5LyToSkEXFBJjRITVIYFQfdATA8+xq2w+e2hRyeXXWRbaXshomb0h
         Di05UWClJwBR7DMwLIt6FKqWp/hcmUtrn5K/cO6qhiwr5qaD7AOMasKiBBvoJdeB9dQD
         dO1M1B1HIodFPnsAT1dBJsyQ/C8BLshqAPsRZ7CuZJNNTiUVTgf8mHxUBdAe7HY9MeP0
         dLMED3uV08bUpKzbc2HikctY0L56Se0JBOG4ddsVBYRMXrXR65CnSpF+TEBa4fE0SmLY
         dosA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HIpkXJbPDvdmjWxeyg9Tvklt18VI8wkPqdX0zVrTl5o=;
        b=yKSyKTGs/uae/mUTW0gtcWuCEIXwc1J9cZ9ViuC+A08l9qfJiiuUi1dsFtvuiMnb4I
         inC8y0qvo1byRgoObjAm13/QVLzIalh3dJIVBl+LWtwF69cBPyJJ/V5NLeP13oR1X/cB
         xK24gn9ytFc3ld51N+nYY4v0Hr9no5ZKxRzImx718zaFe7YH5+/FHEWxOJECqxYxKq5A
         tyZrleaC/Wego/a8JCeign+Sj+5WGlzrmXMFdDgkLz8jmgPFp4qYOlwK2O74TBsBi+WB
         cVzSELsJs//gZ97TyaC7WygSeyAkaUynqlAeyk2K2kW9KI3xXevoz1hUbXHmOZvIiHMB
         DvPQ==
X-Gm-Message-State: AOAM532YIj39P8dt+U3DtbnstIq2VY4OK43CudnOBieXlgsmNJL7nkZU
        9wHFwU5Pbl8kkih/OjGOcn+SOw7oNevayjuV
X-Google-Smtp-Source: ABdhPJzFfP7gdppJCsaYLrRjqkK1fOsCtxesGFiJLWFzTfVx1W3U1/nuV9mJEm0md37Fy8Z/ty8m0g==
X-Received: by 2002:a05:622a:1a90:: with SMTP id s16mr44019089qtc.129.1641352572639;
        Tue, 04 Jan 2022 19:16:12 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br ([187.94.103.218])
        by smtp.gmail.com with ESMTPSA id t11sm32607629qkp.56.2022.01.04.19.16.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 19:16:12 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, alsi@bang-olufsen.dk,
        arinc.unal@arinc9.com, frank-w@public-files.de,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net-next v4 09/11] net: dsa: realtek: rtl8365mb: use DSA CPU port
Date:   Wed,  5 Jan 2022 00:15:13 -0300
Message-Id: <20220105031515.29276-10-luizluca@gmail.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20220105031515.29276-1-luizluca@gmail.com>
References: <20220105031515.29276-1-luizluca@gmail.com>
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
index b22f50a9d1ef..adc72f0844ae 100644
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
@@ -1806,6 +1805,8 @@ static int rtl8365mb_reset_chip(struct realtek_priv *priv)
 static int rtl8365mb_setup(struct dsa_switch *ds)
 {
 	struct realtek_priv *priv = ds->priv;
+	struct rtl8365mb_cpu cpu;
+	struct dsa_port *cpu_dp;
 	struct rtl8365mb *mb;
 	int ret;
 	int i;
@@ -1833,9 +1834,16 @@ static int rtl8365mb_setup(struct dsa_switch *ds)
 		dev_info(priv->dev, "no interrupt support\n");
 
 	/* Configure CPU tagging */
-	ret = rtl8365mb_cpu_config(priv);
-	if (ret)
-		goto out_teardown_irq;
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

