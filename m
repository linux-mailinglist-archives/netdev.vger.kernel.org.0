Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A261F6B5D2D
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 16:08:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230302AbjCKPHd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 10:07:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230293AbjCKPHa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 10:07:30 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4E1011FFA5;
        Sat, 11 Mar 2023 07:07:28 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id y2so7999222pjg.3;
        Sat, 11 Mar 2023 07:07:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678547248;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BTYm5QGSmqNPaawCK164RDl98EMhzIVLGc5pEB+PM4Y=;
        b=iOoWgc7Ro33vRBji+0er3hEoOHjNICAgGXl66WRneGRajIhamEpxMwmY5UAvgOYpL8
         S4azH0ByIbZn5E2BUlOn2UdDi4RjH4iShWCk33bryJbBwEjHECmbr1CWo/j6wlxzVQqM
         Nm5XsVAOlrcEe72aZIhYxJmaETntzXuxgOoDWCdIPxsKHDjduX96aS0DEASqtWYBZTEt
         2eGvOu/XF6m37YUnRJ6ZkdQ7ZC18+3lgLgV8kZ84aGj97cAU5ejHSxGMmUrdycURJk1W
         ac+sSr9d0j/ZtJ+cjup34imfoZVaeF100AtDZwRWKIvQIVr/iQ3Nt/XZKXOaqHd9LPNJ
         MFhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678547248;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BTYm5QGSmqNPaawCK164RDl98EMhzIVLGc5pEB+PM4Y=;
        b=YGFwsH023mMm0Dg2PuZ7Kaf/bA6M/8DXDuJtZkAn/71YAOU53vI+9HqQ9a+pzw1IFf
         H9NpqLXhpXKpQYhwymGaKcQyYBxm5Z+bxKV2B7OrCBtGHRJ1MDV2dXY1lcxSc05LNvvF
         PDWjt0+cpwp8eew3xzMFITqf1cjqhcQx/VHPGTTuS1l4fhZC39lRKeShuGw4TKBb+C0o
         8n4VYBQqLVANk667hSHFAsFCSzB3IAXSt74e1//2PVIdTvcZj+99kYYLm3B5MZYaDp/9
         VVV20r1PE2ya1B8XDFCujj1JIHhUv7ZnYZiJT+QQmir8fwYImDW9niJFiwom93lGLxxQ
         B17Q==
X-Gm-Message-State: AO0yUKX2ELz5pOkIzbrEvSfzVX7UZSoNflgKz0IGr0nTyvveguUMgiiP
        muMeMrXt9QSgidU5hrkn33E=
X-Google-Smtp-Source: AK7set+0yKRcjc0Fp+jBIUP+MwPFuya0/0SZZ94Q0bijsCCf1hOR6ek44+DNgoUKd9oj9KSbs470xA==
X-Received: by 2002:a17:902:db11:b0:19d:7a4:4063 with SMTP id m17-20020a170902db1100b0019d07a44063mr33645410plx.46.1678547248097;
        Sat, 11 Mar 2023 07:07:28 -0800 (PST)
Received: from skynet-linux.local ([2a09:bac5:3b4c:11c3::1c5:3f])
        by smtp.googlemail.com with ESMTPSA id c10-20020a63d50a000000b00502fdc789c5sm1676470pgg.27.2023.03.11.07.07.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Mar 2023 07:07:27 -0800 (PST)
From:   Sireesh Kodali <sireeshkodali1@gmail.com>
To:     loic.poulain@linaro.org, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        ~postmarketos/upstreaming@lists.sr.ht, linux-kernel@vger.kernel.org
Cc:     Vladimir Lypak <vladimir.lypak@gmail.com>,
        Sireesh Kodali <sireeshkodali1@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 1/1] net: wireless: ath: wcn36xx: add support for pronto-v3
Date:   Sat, 11 Mar 2023 20:36:47 +0530
Message-Id: <20230311150647.22935-2-sireeshkodali1@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230311150647.22935-1-sireeshkodali1@gmail.com>
References: <20230311150647.22935-1-sireeshkodali1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Lypak <vladimir.lypak@gmail.com>

Pronto v3 has a different DXE address than prior Pronto versions. This
patch changes the macro to return the correct register address based on
the pronto version.

Signed-off-by: Vladimir Lypak <vladimir.lypak@gmail.com>
Signed-off-by: Sireesh Kodali <sireeshkodali1@gmail.com>
---
 drivers/net/wireless/ath/wcn36xx/dxe.c     | 23 +++++++++++-----------
 drivers/net/wireless/ath/wcn36xx/dxe.h     |  4 ++--
 drivers/net/wireless/ath/wcn36xx/main.c    |  1 +
 drivers/net/wireless/ath/wcn36xx/wcn36xx.h |  1 +
 4 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/dxe.c b/drivers/net/wireless/ath/wcn36xx/dxe.c
index 4e9e13941c8f..9013f056eecb 100644
--- a/drivers/net/wireless/ath/wcn36xx/dxe.c
+++ b/drivers/net/wireless/ath/wcn36xx/dxe.c
@@ -112,8 +112,8 @@ int wcn36xx_dxe_alloc_ctl_blks(struct wcn36xx *wcn)
 	wcn->dxe_rx_l_ch.desc_num = WCN36XX_DXE_CH_DESC_NUMB_RX_L;
 	wcn->dxe_rx_h_ch.desc_num = WCN36XX_DXE_CH_DESC_NUMB_RX_H;
 
-	wcn->dxe_tx_l_ch.dxe_wq =  WCN36XX_DXE_WQ_TX_L;
-	wcn->dxe_tx_h_ch.dxe_wq =  WCN36XX_DXE_WQ_TX_H;
+	wcn->dxe_tx_l_ch.dxe_wq =  WCN36XX_DXE_WQ_TX_L(wcn);
+	wcn->dxe_tx_h_ch.dxe_wq =  WCN36XX_DXE_WQ_TX_H(wcn);
 
 	wcn->dxe_tx_l_ch.ctrl_bd = WCN36XX_DXE_CTRL_TX_L_BD;
 	wcn->dxe_tx_h_ch.ctrl_bd = WCN36XX_DXE_CTRL_TX_H_BD;
@@ -165,8 +165,9 @@ void wcn36xx_dxe_free_ctl_blks(struct wcn36xx *wcn)
 	wcn36xx_dxe_free_ctl_block(&wcn->dxe_rx_h_ch);
 }
 
-static int wcn36xx_dxe_init_descs(struct device *dev, struct wcn36xx_dxe_ch *wcn_ch)
+static int wcn36xx_dxe_init_descs(struct wcn36xx *wcn, struct wcn36xx_dxe_ch *wcn_ch)
 {
+	struct device *dev = wcn->dev;
 	struct wcn36xx_dxe_desc *cur_dxe = NULL;
 	struct wcn36xx_dxe_desc *prev_dxe = NULL;
 	struct wcn36xx_dxe_ctl *cur_ctl = NULL;
@@ -190,11 +191,11 @@ static int wcn36xx_dxe_init_descs(struct device *dev, struct wcn36xx_dxe_ch *wcn
 		switch (wcn_ch->ch_type) {
 		case WCN36XX_DXE_CH_TX_L:
 			cur_dxe->ctrl = WCN36XX_DXE_CTRL_TX_L;
-			cur_dxe->dst_addr_l = WCN36XX_DXE_WQ_TX_L;
+			cur_dxe->dst_addr_l = WCN36XX_DXE_WQ_TX_L(wcn);
 			break;
 		case WCN36XX_DXE_CH_TX_H:
 			cur_dxe->ctrl = WCN36XX_DXE_CTRL_TX_H;
-			cur_dxe->dst_addr_l = WCN36XX_DXE_WQ_TX_H;
+			cur_dxe->dst_addr_l = WCN36XX_DXE_WQ_TX_H(wcn);
 			break;
 		case WCN36XX_DXE_CH_RX_L:
 			cur_dxe->ctrl = WCN36XX_DXE_CTRL_RX_L;
@@ -914,7 +915,7 @@ int wcn36xx_dxe_init(struct wcn36xx *wcn)
 	/***************************************/
 	/* Init descriptors for TX LOW channel */
 	/***************************************/
-	ret = wcn36xx_dxe_init_descs(wcn->dev, &wcn->dxe_tx_l_ch);
+	ret = wcn36xx_dxe_init_descs(wcn, &wcn->dxe_tx_l_ch);
 	if (ret) {
 		dev_err(wcn->dev, "Error allocating descriptor\n");
 		return ret;
@@ -928,14 +929,14 @@ int wcn36xx_dxe_init(struct wcn36xx *wcn)
 	/* Program DMA destination addr for TX LOW */
 	wcn36xx_dxe_write_register(wcn,
 		WCN36XX_DXE_CH_DEST_ADDR_TX_L,
-		WCN36XX_DXE_WQ_TX_L);
+		WCN36XX_DXE_WQ_TX_L(wcn));
 
 	wcn36xx_dxe_read_register(wcn, WCN36XX_DXE_REG_CH_EN, &reg_data);
 
 	/***************************************/
 	/* Init descriptors for TX HIGH channel */
 	/***************************************/
-	ret = wcn36xx_dxe_init_descs(wcn->dev, &wcn->dxe_tx_h_ch);
+	ret = wcn36xx_dxe_init_descs(wcn, &wcn->dxe_tx_h_ch);
 	if (ret) {
 		dev_err(wcn->dev, "Error allocating descriptor\n");
 		goto out_err_txh_ch;
@@ -950,14 +951,14 @@ int wcn36xx_dxe_init(struct wcn36xx *wcn)
 	/* Program DMA destination addr for TX HIGH */
 	wcn36xx_dxe_write_register(wcn,
 		WCN36XX_DXE_CH_DEST_ADDR_TX_H,
-		WCN36XX_DXE_WQ_TX_H);
+		WCN36XX_DXE_WQ_TX_H(wcn));
 
 	wcn36xx_dxe_read_register(wcn, WCN36XX_DXE_REG_CH_EN, &reg_data);
 
 	/***************************************/
 	/* Init descriptors for RX LOW channel */
 	/***************************************/
-	ret = wcn36xx_dxe_init_descs(wcn->dev, &wcn->dxe_rx_l_ch);
+	ret = wcn36xx_dxe_init_descs(wcn, &wcn->dxe_rx_l_ch);
 	if (ret) {
 		dev_err(wcn->dev, "Error allocating descriptor\n");
 		goto out_err_rxl_ch;
@@ -988,7 +989,7 @@ int wcn36xx_dxe_init(struct wcn36xx *wcn)
 	/***************************************/
 	/* Init descriptors for RX HIGH channel */
 	/***************************************/
-	ret = wcn36xx_dxe_init_descs(wcn->dev, &wcn->dxe_rx_h_ch);
+	ret = wcn36xx_dxe_init_descs(wcn, &wcn->dxe_rx_h_ch);
 	if (ret) {
 		dev_err(wcn->dev, "Error allocating descriptor\n");
 		goto out_err_rxh_ch;
diff --git a/drivers/net/wireless/ath/wcn36xx/dxe.h b/drivers/net/wireless/ath/wcn36xx/dxe.h
index 26a31edf52e9..dd8c684a3ba7 100644
--- a/drivers/net/wireless/ath/wcn36xx/dxe.h
+++ b/drivers/net/wireless/ath/wcn36xx/dxe.h
@@ -135,8 +135,8 @@ H2H_TEST_RX_TX = DMA2
 	WCN36xx_DXE_CTRL_ENDIANNESS)
 
 /* TODO This must calculated properly but not hardcoded */
-#define WCN36XX_DXE_WQ_TX_L			0x17
-#define WCN36XX_DXE_WQ_TX_H			0x17
+#define WCN36XX_DXE_WQ_TX_L(wcn)    ((wcn)->is_pronto_v3 ? 0x6 : 0x17)
+#define WCN36XX_DXE_WQ_TX_H(wcn)    ((wcn)->is_pronto_v3 ? 0x6 : 0x17)
 #define WCN36XX_DXE_WQ_RX_L			0xB
 #define WCN36XX_DXE_WQ_RX_H			0x4
 
diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
index 3b79cc1c7c5b..8dbd115a393c 100644
--- a/drivers/net/wireless/ath/wcn36xx/main.c
+++ b/drivers/net/wireless/ath/wcn36xx/main.c
@@ -1508,6 +1508,7 @@ static int wcn36xx_platform_get_resources(struct wcn36xx *wcn,
 	}
 
 	wcn->is_pronto = !!of_device_is_compatible(mmio_node, "qcom,pronto");
+	wcn->is_pronto_v3 = !!of_device_is_compatible(mmio_node, "qcom,pronto-v3-pil");
 
 	/* Map the CCU memory */
 	index = of_property_match_string(mmio_node, "reg-names", "ccu");
diff --git a/drivers/net/wireless/ath/wcn36xx/wcn36xx.h b/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
index 9aa08b636d08..ff4a8e5d7209 100644
--- a/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
+++ b/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
@@ -217,6 +217,7 @@ struct wcn36xx {
 	u8			fw_major;
 	u32			fw_feat_caps[WCN36XX_HAL_CAPS_SIZE];
 	bool			is_pronto;
+	bool			is_pronto_v3;
 
 	/* extra byte for the NULL termination */
 	u8			crm_version[WCN36XX_HAL_VERSION_LENGTH + 1];
-- 
2.39.2

