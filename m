Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7AB424CEE0
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 09:19:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728298AbgHUHT1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 03:19:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728018AbgHUHSs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 03:18:48 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34DFBC0612FF
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 00:17:29 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id c15so981987wrs.11
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 00:17:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fN0qY5rtNX6i0CI/MnuefJhN/Bgnf0dv5EJHWFwf6vk=;
        b=ksj82a6HRu08E3bfyapKcejX0xtl5iGHFyfZcCUPMClXDUrNtHLDftoYae6HslD66s
         CPqDLCOrB6t/uErjPoZf9azbQEueDP0MGVnLI11OrzaX66+7AOaRsvGzAEEUPfPwRxcO
         Netet1O0ysiMGMMwfbaxQ8E/B/9unwQUMOnLluAxFS6eaz+MBB4s/E21O2Lko95EzPF1
         nR+8hU3uIRE2O7jfyIHaMeXnZ6zBRZ2DLpMM8iIbjPt99Ak9QWorIFPbjcVSBTvZdwIC
         XOFxSED4MIadSZAnWmZYVMbRzKufgZyfev/93XQB8bDRE9mefueuXUJdeS/CdCL8ONcy
         O5nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fN0qY5rtNX6i0CI/MnuefJhN/Bgnf0dv5EJHWFwf6vk=;
        b=GRWHrA/s+rhlIW36n0jMXcstrnCN+tbeqSS/oj6DvPQ3wSuRABdbbxCAOPZ2vFU2hX
         mLCWc7SfWZY+zyXya34pwDZVglI0YrtMu9l9TzjNFGyn+CAEkno3hwZyZ9b9y4G0MojY
         YYWvW5XBFHgdjnHtuTeuWW0sRyuSYpH/uz+tK7kuKDTJl+ne53M7N0bKMJ6S4TJwkr3+
         4yABHJ52ktplti9pc3J2Z/4lcB3UTlkxoHcLBLqpeizZydASkm+2fYTx8wlcJCaKkwbp
         yk0KcsH5r9HsL37SlQubjYEHKzObjWGsQ4cDsjTYR7WkjNZ2/KheA4J+4DYcJO7vpdgv
         T5qA==
X-Gm-Message-State: AOAM531Qy/4/3IsmjBdt4DmphQnYnGzznRvUonbZVsU/lv3I45+uZeHm
        d/jJ0R0cuAqMf/Ex28IndAdoIA==
X-Google-Smtp-Source: ABdhPJynDxAwG5fKz2IRqvyRd7zLwNoFXN9aqj2CVgzAFKbX1+LchaOsKkQO88FBaINsGVtF1ddAwA==
X-Received: by 2002:a5d:526d:: with SMTP id l13mr1325446wrc.279.1597994247818;
        Fri, 21 Aug 2020 00:17:27 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id y24sm2667957wmi.17.2020.08.21.00.17.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2020 00:17:27 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Stanislaw Gruszka <stf_xl@wp.pl>,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 32/32] wireless: mediatek: mt76x0: Move tables used only by init.c to their own header file
Date:   Fri, 21 Aug 2020 08:16:44 +0100
Message-Id: <20200821071644.109970-33-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200821071644.109970-1-lee.jones@linaro.org>
References: <20200821071644.109970-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Taking the same approach as initvals_phy.h.

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/mediatek/mt76/mt76x0/initvals.h:218:35: warning: ‘mt76x0_dcoc_tab’ defined but not used [-Wunused-const-variable=]
 218 | static const struct mt76_reg_pair mt76x0_dcoc_tab[] = {
 | ^~~~~~~~~~~~~~~
 drivers/net/wireless/mediatek/mt76/mt76x0/initvals.h:86:35: warning: ‘mt76x0_bbp_init_tab’ defined but not used [-Wunused-const-variable=]
 86 | static const struct mt76_reg_pair mt76x0_bbp_init_tab[] = {
 | ^~~~~~~~~~~~~~~~~~~
 drivers/net/wireless/mediatek/mt76/mt76x0/initvals.h:48:35: warning: ‘mt76x0_mac_reg_table’ defined but not used [-Wunused-const-variable=]
 48 | static const struct mt76_reg_pair mt76x0_mac_reg_table[] = {
 | ^~~~~~~~~~~~~~~~~~~~
 drivers/net/wireless/mediatek/mt76/mt76x0/initvals.h:14:35: warning: ‘common_mac_reg_table’ defined but not used [-Wunused-const-variable=]
 14 | static const struct mt76_reg_pair common_mac_reg_table[] = {
 | ^~~~~~~~~~~~~~~~~~~~

Cc: Felix Fietkau <nbd@nbd.name>
Cc: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Cc: Ryder Lee <ryder.lee@mediatek.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Stanislaw Gruszka <stf_xl@wp.pl>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: linux-mediatek@lists.infradead.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 .../net/wireless/mediatek/mt76/mt76x0/init.c  |   1 +
 .../wireless/mediatek/mt76/mt76x0/initvals.h  | 145 ----------------
 .../mediatek/mt76/mt76x0/initvals_init.h      | 159 ++++++++++++++++++
 3 files changed, 160 insertions(+), 145 deletions(-)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/initvals_init.h

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index dc8bf4c6969af..d78866bf41ba3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
@@ -10,6 +10,7 @@
 #include "eeprom.h"
 #include "mcu.h"
 #include "initvals.h"
+#include "initvals_init.h"
 #include "../mt76x02_phy.h"
 
 static void
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/initvals.h b/drivers/net/wireless/mediatek/mt76/mt76x0/initvals.h
index 3dcd9620a1266..99808ed0c6cb1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/initvals.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/initvals.h
@@ -11,139 +11,6 @@
 
 #include "phy.h"
 
-static const struct mt76_reg_pair common_mac_reg_table[] = {
-	{ MT_BCN_OFFSET(0),		0xf8f0e8e0 },
-	{ MT_BCN_OFFSET(1),		0x6f77d0c8 },
-	{ MT_LEGACY_BASIC_RATE,		0x0000013f },
-	{ MT_HT_BASIC_RATE,		0x00008003 },
-	{ MT_MAC_SYS_CTRL,		0x00000000 },
-	{ MT_RX_FILTR_CFG,		0x00017f97 },
-	{ MT_BKOFF_SLOT_CFG,		0x00000209 },
-	{ MT_TX_SW_CFG0,		0x00000000 },
-	{ MT_TX_SW_CFG1,		0x00080606 },
-	{ MT_TX_LINK_CFG,		0x00001020 },
-	{ MT_TX_TIMEOUT_CFG,		0x000a2090 },
-	{ MT_MAX_LEN_CFG,		0xa0fff | 0x00001000 },
-	{ MT_LED_CFG,			0x7f031e46 },
-	{ MT_PBF_TX_MAX_PCNT,		0x1fbf1f1f },
-	{ MT_PBF_RX_MAX_PCNT,		0x0000fe9f },
-	{ MT_TX_RETRY_CFG,		0x47d01f0f },
-	{ MT_AUTO_RSP_CFG,		0x00000013 },
-	{ MT_CCK_PROT_CFG,		0x07f40003 },
-	{ MT_OFDM_PROT_CFG,		0x07f42004 },
-	{ MT_PBF_CFG,			0x00f40006 },
-	{ MT_WPDMA_GLO_CFG,		0x00000030 },
-	{ MT_GF20_PROT_CFG,		0x01742004 },
-	{ MT_GF40_PROT_CFG,		0x03f42084 },
-	{ MT_MM20_PROT_CFG,		0x01742004 },
-	{ MT_MM40_PROT_CFG,		0x03f42084 },
-	{ MT_TXOP_CTRL_CFG,		0x0000583f },
-	{ MT_TX_RTS_CFG,		0x00ffff20 },
-	{ MT_EXP_ACK_TIME,		0x002400ca },
-	{ MT_TXOP_HLDR_ET,		0x00000002 },
-	{ MT_XIFS_TIME_CFG,		0x33a41010 },
-	{ MT_PWR_PIN_CFG,		0x00000000 },
-};
-
-static const struct mt76_reg_pair mt76x0_mac_reg_table[] = {
-	{ MT_IOCFG_6,			0xa0040080 },
-	{ MT_PBF_SYS_CTRL,		0x00080c00 },
-	{ MT_PBF_CFG,			0x77723c1f },
-	{ MT_FCE_PSE_CTRL,		0x00000001 },
-	{ MT_AMPDU_MAX_LEN_20M1S,	0xAAA99887 },
-	{ MT_TX_SW_CFG0,		0x00000601 },
-	{ MT_TX_SW_CFG1,		0x00040000 },
-	{ MT_TX_SW_CFG2,		0x00000000 },
-	{ 0xa44,			0x00000000 },
-	{ MT_HEADER_TRANS_CTRL_REG,	0x00000000 },
-	{ MT_TSO_CTRL,			0x00000000 },
-	{ MT_BB_PA_MODE_CFG1,		0x00500055 },
-	{ MT_RF_PA_MODE_CFG1,		0x00500055 },
-	{ MT_TX_ALC_CFG_0,		0x2F2F000C },
-	{ MT_TX0_BB_GAIN_ATTEN,		0x00000000 },
-	{ MT_TX_PWR_CFG_0,		0x3A3A3A3A },
-	{ MT_TX_PWR_CFG_1,		0x3A3A3A3A },
-	{ MT_TX_PWR_CFG_2,		0x3A3A3A3A },
-	{ MT_TX_PWR_CFG_3,		0x3A3A3A3A },
-	{ MT_TX_PWR_CFG_4,		0x3A3A3A3A },
-	{ MT_TX_PWR_CFG_7,		0x3A3A3A3A },
-	{ MT_TX_PWR_CFG_8,		0x0000003A },
-	{ MT_TX_PWR_CFG_9,		0x0000003A },
-	{ 0x150C,			0x00000002 },
-	{ 0x1238,			0x001700C8 },
-	{ MT_LDO_CTRL_0,		0x00A647B6 },
-	{ MT_LDO_CTRL_1,		0x6B006464 },
-	{ MT_HT_BASIC_RATE,		0x00004003 },
-	{ MT_HT_CTRL_CFG,		0x000001FF },
-	{ MT_TXOP_HLDR_ET,		0x00000000 },
-	{ MT_PN_PAD_MODE,		0x00000003 },
-	{ MT_TX_PROT_CFG6,		0xe3f42004 },
-	{ MT_TX_PROT_CFG7,		0xe3f42084 },
-	{ MT_TX_PROT_CFG8,		0xe3f42104 },
-	{ MT_VHT_HT_FBK_CFG1,		0xedcba980 },
-};
-
-static const struct mt76_reg_pair mt76x0_bbp_init_tab[] = {
-	{ MT_BBP(CORE, 1),	0x00000002 },
-	{ MT_BBP(CORE, 4),	0x00000000 },
-	{ MT_BBP(CORE, 24),	0x00000000 },
-	{ MT_BBP(CORE, 32),	0x4003000a },
-	{ MT_BBP(CORE, 42),	0x00000000 },
-	{ MT_BBP(CORE, 44),	0x00000000 },
-	{ MT_BBP(IBI, 11),	0x0FDE8081 },
-	{ MT_BBP(AGC, 0),	0x00021400 },
-	{ MT_BBP(AGC, 1),	0x00000003 },
-	{ MT_BBP(AGC, 2),	0x003A6464 },
-	{ MT_BBP(AGC, 15),	0x88A28CB8 },
-	{ MT_BBP(AGC, 22),	0x00001E21 },
-	{ MT_BBP(AGC, 23),	0x0000272C },
-	{ MT_BBP(AGC, 24),	0x00002F3A },
-	{ MT_BBP(AGC, 25),	0x8000005A },
-	{ MT_BBP(AGC, 26),	0x007C2005 },
-	{ MT_BBP(AGC, 33),	0x00003238 },
-	{ MT_BBP(AGC, 34),	0x000A0C0C },
-	{ MT_BBP(AGC, 37),	0x2121262C },
-	{ MT_BBP(AGC, 41),	0x38383E45 },
-	{ MT_BBP(AGC, 57),	0x00001010 },
-	{ MT_BBP(AGC, 59),	0xBAA20E96 },
-	{ MT_BBP(AGC, 63),	0x00000001 },
-	{ MT_BBP(TXC, 0),	0x00280403 },
-	{ MT_BBP(TXC, 1),	0x00000000 },
-	{ MT_BBP(RXC, 1),	0x00000012 },
-	{ MT_BBP(RXC, 2),	0x00000011 },
-	{ MT_BBP(RXC, 3),	0x00000005 },
-	{ MT_BBP(RXC, 4),	0x00000000 },
-	{ MT_BBP(RXC, 5),	0xF977C4EC },
-	{ MT_BBP(RXC, 7),	0x00000090 },
-	{ MT_BBP(TXO, 8),	0x00000000 },
-	{ MT_BBP(TXBE, 0),	0x00000000 },
-	{ MT_BBP(TXBE, 4),	0x00000004 },
-	{ MT_BBP(TXBE, 6),	0x00000000 },
-	{ MT_BBP(TXBE, 8),	0x00000014 },
-	{ MT_BBP(TXBE, 9),	0x20000000 },
-	{ MT_BBP(TXBE, 10),	0x00000000 },
-	{ MT_BBP(TXBE, 12),	0x00000000 },
-	{ MT_BBP(TXBE, 13),	0x00000000 },
-	{ MT_BBP(TXBE, 14),	0x00000000 },
-	{ MT_BBP(TXBE, 15),	0x00000000 },
-	{ MT_BBP(TXBE, 16),	0x00000000 },
-	{ MT_BBP(TXBE, 17),	0x00000000 },
-	{ MT_BBP(RXFE, 1),	0x00008800 },
-	{ MT_BBP(RXFE, 3),	0x00000000 },
-	{ MT_BBP(RXFE, 4),	0x00000000 },
-	{ MT_BBP(RXO, 13),	0x00000192 },
-	{ MT_BBP(RXO, 14),	0x00060612 },
-	{ MT_BBP(RXO, 15),	0xC8321B18 },
-	{ MT_BBP(RXO, 16),	0x0000001E },
-	{ MT_BBP(RXO, 17),	0x00000000 },
-	{ MT_BBP(RXO, 18),	0xCC00A993 },
-	{ MT_BBP(RXO, 19),	0xB9CB9CB9 },
-	{ MT_BBP(RXO, 20),	0x26c00057 },
-	{ MT_BBP(RXO, 21),	0x00000001 },
-	{ MT_BBP(RXO, 24),	0x00000006 },
-	{ MT_BBP(RXO, 28),	0x0000003F },
-};
-
 static const struct mt76x0_bbp_switch_item mt76x0_bbp_switch_tab[] = {
 	{ RF_G_BAND | RF_BW_20 | RF_BW_40,		{ MT_BBP(AGC, 4),	0x1FEDA049 } },
 	{ RF_A_BAND | RF_BW_20 | RF_BW_40 | RF_BW_80,	{ MT_BBP(AGC, 4),	0x1FECA054 } },
@@ -215,16 +82,4 @@ static const struct mt76x0_bbp_switch_item mt76x0_bbp_switch_tab[] = {
 	{ RF_A_BAND | RF_BW_20 | RF_BW_40 | RF_BW_80,	{ MT_BBP(RXFE, 0),	0x895000E0 } },
 };
 
-static const struct mt76_reg_pair mt76x0_dcoc_tab[] = {
-	{ MT_BBP(CAL, 47), 0x000010F0 },
-	{ MT_BBP(CAL, 48), 0x00008080 },
-	{ MT_BBP(CAL, 49), 0x00000F07 },
-	{ MT_BBP(CAL, 50), 0x00000040 },
-	{ MT_BBP(CAL, 51), 0x00000404 },
-	{ MT_BBP(CAL, 52), 0x00080803 },
-	{ MT_BBP(CAL, 53), 0x00000704 },
-	{ MT_BBP(CAL, 54), 0x00002828 },
-	{ MT_BBP(CAL, 55), 0x00005050 },
-};
-
 #endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/initvals_init.h b/drivers/net/wireless/mediatek/mt76/mt76x0/initvals_init.h
new file mode 100644
index 0000000000000..9e99ba75f4902
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/initvals_init.h
@@ -0,0 +1,159 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * (c) Copyright 2002-2010, Ralink Technology, Inc.
+ * Copyright (C) 2015 Jakub Kicinski <kubakici@wp.pl>
+ * Copyright (C) 2018 Stanislaw Gruszka <stf_xl@wp.pl>
+ * Copyright (C) 2018 Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
+ */
+
+#ifndef __MT76X0U_INITVALS_INIT_H
+#define __MT76X0U_INITVALS_INIT_H
+
+#include "phy.h"
+
+static const struct mt76_reg_pair common_mac_reg_table[] = {
+	{ MT_BCN_OFFSET(0),		0xf8f0e8e0 },
+	{ MT_BCN_OFFSET(1),		0x6f77d0c8 },
+	{ MT_LEGACY_BASIC_RATE,		0x0000013f },
+	{ MT_HT_BASIC_RATE,		0x00008003 },
+	{ MT_MAC_SYS_CTRL,		0x00000000 },
+	{ MT_RX_FILTR_CFG,		0x00017f97 },
+	{ MT_BKOFF_SLOT_CFG,		0x00000209 },
+	{ MT_TX_SW_CFG0,		0x00000000 },
+	{ MT_TX_SW_CFG1,		0x00080606 },
+	{ MT_TX_LINK_CFG,		0x00001020 },
+	{ MT_TX_TIMEOUT_CFG,		0x000a2090 },
+	{ MT_MAX_LEN_CFG,		0xa0fff | 0x00001000 },
+	{ MT_LED_CFG,			0x7f031e46 },
+	{ MT_PBF_TX_MAX_PCNT,		0x1fbf1f1f },
+	{ MT_PBF_RX_MAX_PCNT,		0x0000fe9f },
+	{ MT_TX_RETRY_CFG,		0x47d01f0f },
+	{ MT_AUTO_RSP_CFG,		0x00000013 },
+	{ MT_CCK_PROT_CFG,		0x07f40003 },
+	{ MT_OFDM_PROT_CFG,		0x07f42004 },
+	{ MT_PBF_CFG,			0x00f40006 },
+	{ MT_WPDMA_GLO_CFG,		0x00000030 },
+	{ MT_GF20_PROT_CFG,		0x01742004 },
+	{ MT_GF40_PROT_CFG,		0x03f42084 },
+	{ MT_MM20_PROT_CFG,		0x01742004 },
+	{ MT_MM40_PROT_CFG,		0x03f42084 },
+	{ MT_TXOP_CTRL_CFG,		0x0000583f },
+	{ MT_TX_RTS_CFG,		0x00ffff20 },
+	{ MT_EXP_ACK_TIME,		0x002400ca },
+	{ MT_TXOP_HLDR_ET,		0x00000002 },
+	{ MT_XIFS_TIME_CFG,		0x33a41010 },
+	{ MT_PWR_PIN_CFG,		0x00000000 },
+};
+
+static const struct mt76_reg_pair mt76x0_mac_reg_table[] = {
+	{ MT_IOCFG_6,			0xa0040080 },
+	{ MT_PBF_SYS_CTRL,		0x00080c00 },
+	{ MT_PBF_CFG,			0x77723c1f },
+	{ MT_FCE_PSE_CTRL,		0x00000001 },
+	{ MT_AMPDU_MAX_LEN_20M1S,	0xAAA99887 },
+	{ MT_TX_SW_CFG0,		0x00000601 },
+	{ MT_TX_SW_CFG1,		0x00040000 },
+	{ MT_TX_SW_CFG2,		0x00000000 },
+	{ 0xa44,			0x00000000 },
+	{ MT_HEADER_TRANS_CTRL_REG,	0x00000000 },
+	{ MT_TSO_CTRL,			0x00000000 },
+	{ MT_BB_PA_MODE_CFG1,		0x00500055 },
+	{ MT_RF_PA_MODE_CFG1,		0x00500055 },
+	{ MT_TX_ALC_CFG_0,		0x2F2F000C },
+	{ MT_TX0_BB_GAIN_ATTEN,		0x00000000 },
+	{ MT_TX_PWR_CFG_0,		0x3A3A3A3A },
+	{ MT_TX_PWR_CFG_1,		0x3A3A3A3A },
+	{ MT_TX_PWR_CFG_2,		0x3A3A3A3A },
+	{ MT_TX_PWR_CFG_3,		0x3A3A3A3A },
+	{ MT_TX_PWR_CFG_4,		0x3A3A3A3A },
+	{ MT_TX_PWR_CFG_7,		0x3A3A3A3A },
+	{ MT_TX_PWR_CFG_8,		0x0000003A },
+	{ MT_TX_PWR_CFG_9,		0x0000003A },
+	{ 0x150C,			0x00000002 },
+	{ 0x1238,			0x001700C8 },
+	{ MT_LDO_CTRL_0,		0x00A647B6 },
+	{ MT_LDO_CTRL_1,		0x6B006464 },
+	{ MT_HT_BASIC_RATE,		0x00004003 },
+	{ MT_HT_CTRL_CFG,		0x000001FF },
+	{ MT_TXOP_HLDR_ET,		0x00000000 },
+	{ MT_PN_PAD_MODE,		0x00000003 },
+	{ MT_TX_PROT_CFG6,		0xe3f42004 },
+	{ MT_TX_PROT_CFG7,		0xe3f42084 },
+	{ MT_TX_PROT_CFG8,		0xe3f42104 },
+	{ MT_VHT_HT_FBK_CFG1,		0xedcba980 },
+};
+
+static const struct mt76_reg_pair mt76x0_bbp_init_tab[] = {
+	{ MT_BBP(CORE, 1),	0x00000002 },
+	{ MT_BBP(CORE, 4),	0x00000000 },
+	{ MT_BBP(CORE, 24),	0x00000000 },
+	{ MT_BBP(CORE, 32),	0x4003000a },
+	{ MT_BBP(CORE, 42),	0x00000000 },
+	{ MT_BBP(CORE, 44),	0x00000000 },
+	{ MT_BBP(IBI, 11),	0x0FDE8081 },
+	{ MT_BBP(AGC, 0),	0x00021400 },
+	{ MT_BBP(AGC, 1),	0x00000003 },
+	{ MT_BBP(AGC, 2),	0x003A6464 },
+	{ MT_BBP(AGC, 15),	0x88A28CB8 },
+	{ MT_BBP(AGC, 22),	0x00001E21 },
+	{ MT_BBP(AGC, 23),	0x0000272C },
+	{ MT_BBP(AGC, 24),	0x00002F3A },
+	{ MT_BBP(AGC, 25),	0x8000005A },
+	{ MT_BBP(AGC, 26),	0x007C2005 },
+	{ MT_BBP(AGC, 33),	0x00003238 },
+	{ MT_BBP(AGC, 34),	0x000A0C0C },
+	{ MT_BBP(AGC, 37),	0x2121262C },
+	{ MT_BBP(AGC, 41),	0x38383E45 },
+	{ MT_BBP(AGC, 57),	0x00001010 },
+	{ MT_BBP(AGC, 59),	0xBAA20E96 },
+	{ MT_BBP(AGC, 63),	0x00000001 },
+	{ MT_BBP(TXC, 0),	0x00280403 },
+	{ MT_BBP(TXC, 1),	0x00000000 },
+	{ MT_BBP(RXC, 1),	0x00000012 },
+	{ MT_BBP(RXC, 2),	0x00000011 },
+	{ MT_BBP(RXC, 3),	0x00000005 },
+	{ MT_BBP(RXC, 4),	0x00000000 },
+	{ MT_BBP(RXC, 5),	0xF977C4EC },
+	{ MT_BBP(RXC, 7),	0x00000090 },
+	{ MT_BBP(TXO, 8),	0x00000000 },
+	{ MT_BBP(TXBE, 0),	0x00000000 },
+	{ MT_BBP(TXBE, 4),	0x00000004 },
+	{ MT_BBP(TXBE, 6),	0x00000000 },
+	{ MT_BBP(TXBE, 8),	0x00000014 },
+	{ MT_BBP(TXBE, 9),	0x20000000 },
+	{ MT_BBP(TXBE, 10),	0x00000000 },
+	{ MT_BBP(TXBE, 12),	0x00000000 },
+	{ MT_BBP(TXBE, 13),	0x00000000 },
+	{ MT_BBP(TXBE, 14),	0x00000000 },
+	{ MT_BBP(TXBE, 15),	0x00000000 },
+	{ MT_BBP(TXBE, 16),	0x00000000 },
+	{ MT_BBP(TXBE, 17),	0x00000000 },
+	{ MT_BBP(RXFE, 1),	0x00008800 },
+	{ MT_BBP(RXFE, 3),	0x00000000 },
+	{ MT_BBP(RXFE, 4),	0x00000000 },
+	{ MT_BBP(RXO, 13),	0x00000192 },
+	{ MT_BBP(RXO, 14),	0x00060612 },
+	{ MT_BBP(RXO, 15),	0xC8321B18 },
+	{ MT_BBP(RXO, 16),	0x0000001E },
+	{ MT_BBP(RXO, 17),	0x00000000 },
+	{ MT_BBP(RXO, 18),	0xCC00A993 },
+	{ MT_BBP(RXO, 19),	0xB9CB9CB9 },
+	{ MT_BBP(RXO, 20),	0x26c00057 },
+	{ MT_BBP(RXO, 21),	0x00000001 },
+	{ MT_BBP(RXO, 24),	0x00000006 },
+	{ MT_BBP(RXO, 28),	0x0000003F },
+};
+
+static const struct mt76_reg_pair mt76x0_dcoc_tab[] = {
+	{ MT_BBP(CAL, 47), 0x000010F0 },
+	{ MT_BBP(CAL, 48), 0x00008080 },
+	{ MT_BBP(CAL, 49), 0x00000F07 },
+	{ MT_BBP(CAL, 50), 0x00000040 },
+	{ MT_BBP(CAL, 51), 0x00000404 },
+	{ MT_BBP(CAL, 52), 0x00080803 },
+	{ MT_BBP(CAL, 53), 0x00000704 },
+	{ MT_BBP(CAL, 54), 0x00002828 },
+	{ MT_BBP(CAL, 55), 0x00005050 },
+};
+
+#endif
-- 
2.25.1

