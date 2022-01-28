Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09D5149F118
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 03:37:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345448AbiA1ChW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 21:37:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345445AbiA1ChS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 21:37:18 -0500
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E9DBC061749
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 18:37:18 -0800 (PST)
Received: by mail-oi1-x22d.google.com with SMTP id x193so9855512oix.0
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 18:37:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZcPk444npRRG+KFNp4EE5UZk1l131Jj0aq2G1jFQAPE=;
        b=cMMU4i/xeGVkjoj1Zm58inXR+rGW7MxV/3r7A1poLsaN4zm/9FdHOXHYCRrc21em22
         6ru2CgK9Kv+z1Akh1hH7IU4XUJbUHR73O8tm3gf7qie+qHYa+xO0AwhFq7kY1QPu6DBs
         3ZjBuB88XVp0aki6R3+h07Umujybc0FzVPoSN6RsQa14bDKR2jkoqXPVQpkYQxJH0h8m
         XISHtyiw1PacXrLhTMroTkYt7btLAAYgQGidtdnh/WIlyz1zh7+ss+WiSWf7MsWCWp52
         T0a7z2DpshN7Ei3S4jkyazIMoxPAaFsMVYPyYrXOjR3sV1dw0oC8ukt9QzWcOj1mazhM
         /B6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZcPk444npRRG+KFNp4EE5UZk1l131Jj0aq2G1jFQAPE=;
        b=BRNR80gtnkjADcwVz4LTmxeyI21r4UBi/JwVa9GIWnQYYkMp/hGF9OtwOKvy5hv+2J
         Bbo8/co95HKoTVsLGqDgB38B7wYARy89EzKCh8rfF/kITCVOzT88YGRQGW9/cgN5aWhg
         XqgjJuENBluDcZgrJTxftewdFa9/g17cGCc3772ICha7FaUUjC78GW8a9xXc4cESx8MJ
         gIm7XJt/stc+ySHTdHOXNgFAax5IKlKhLjzltvp/M7HVLfWndzP2qJ+6cRekLbM+tYO3
         +jPNkXiF675S0ggjGShbosAtKanJdlK7/Es6EQcdCt+YdQW1WJAtQqsFs7ZDGocohI//
         5Cog==
X-Gm-Message-State: AOAM530lTiJHIGotkL27iNuU1qPdxmbwfc7DCYTOZE23Eyc+W3nczkSI
        NzU+YLhmuDh4YNV5mWI4su+vd33mZhlJ7w==
X-Google-Smtp-Source: ABdhPJx6ra+etuvBhhg87wFlz/Y6U9/zVBGqDzPz9pFN+FY/I5ezxeu4tZWJ8jaPXLVXwSm1pvliRg==
X-Received: by 2002:a05:6808:2024:: with SMTP id q36mr8886595oiw.234.1643337437697;
        Thu, 27 Jan 2022 18:37:17 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br ([187.94.103.218])
        by smtp.gmail.com with ESMTPSA id p82sm2586920oib.25.2022.01.27.18.37.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 18:37:17 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, alsi@bang-olufsen.dk,
        arinc.unal@arinc9.com, frank-w@public-files.de,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net-next v5 09/11] net: dsa: realtek: rtl8365mb: use DSA CPU port
Date:   Thu, 27 Jan 2022 23:36:09 -0300
Message-Id: <20220128023611.2424-10-luizluca@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220128023611.2424-1-luizluca@gmail.com>
References: <20220128023611.2424-1-luizluca@gmail.com>
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
2.34.1

