Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 775623E3A58
	for <lists+netdev@lfdr.de>; Sun,  8 Aug 2021 15:14:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230354AbhHHNGk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 09:06:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbhHHNGk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Aug 2021 09:06:40 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 690CCC061760
        for <netdev@vger.kernel.org>; Sun,  8 Aug 2021 06:06:20 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id m28-20020a05600c3b1cb02902b5a8c22575so9290268wms.0
        for <netdev@vger.kernel.org>; Sun, 08 Aug 2021 06:06:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=wAjKS1vt9FTQkfUmOoQMRGLzVP3/rY0bv0rum+XWJAo=;
        b=WRZk6O5/svvKdSc0lE8vNq1+Vvek+9Vx285dR/dUli8bDfAKFT1Aq7qCrXNben8qSn
         QDYKmYIM6/ouFtLDgGM4OqDMB8RTW4n38mGHRisNn0g1x1yVLUS1xuwJxXtO4dyHHf8L
         cDpaNZzoWWHbfXnRDgC2ljiuMqxQNT8GjdvqSDQdwKQ5u08dmMEoJFhN62fItwXEsqoq
         Xyuw9WSxRIWloHmiaflJQXeuoNlCGhwDouvun7ZS18aKGdm7Kwpq21sSw4rVDpsApGFh
         /VALZE9c5QXBjxMAtA4aOkg5vLOd3zz50NpylPIiGB/xpUDvmaLNcQGS6UPOo8kXTteu
         Ld0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=wAjKS1vt9FTQkfUmOoQMRGLzVP3/rY0bv0rum+XWJAo=;
        b=idIIHVFTJMPAvSIkoEbF47E8m5EV1Bs/Ys8v/ZWTTsm+ibaSDAHPwt7VrOq4iHpgRe
         l89Tet+goZvnn/W/SvfAyhZNrtPLiUIe5P6+fjrQ/IYQMMmi6PG3vec/kNUjrlZuoN23
         kGndXrTlL8w97AvwnU+Em3C4/YEcLimZQmtlnQ+QstszY9UpSK/dZytObjChV52wo6uI
         D3J1hHmxHsNCVc7bRR5ZqozbS3k174bLVrpi/W+9KiOK4kw5G8z2mhjxX63WgNNWjJyl
         CzOlpYLWIiegr7G7p+YW4nwHVcW7OBMdgMFW+uiI2ni4AwyU/bPVrXIPbBx/L42GlnSy
         Ah+g==
X-Gm-Message-State: AOAM533EQUjjdNbclgubSBNwwN6eHGGCvlnWdRrSdMzmncuLE8mF3W49
        kSQxli4epFPwU89EjYM8pQ9y+qsY0NiuYA==
X-Google-Smtp-Source: ABdhPJz1qbrjr9G/i120rNO6wCgf2AIGIvUoO2uCOial7M4gO1E8mdDfepQEBX1oSIqG1lHr9WN3wA==
X-Received: by 2002:a7b:ce08:: with SMTP id m8mr29194505wmc.21.1628427977154;
        Sun, 08 Aug 2021 06:06:17 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f10:c200:7101:8b48:5eab:cb5f? (p200300ea8f10c20071018b485eabcb5f.dip0.t-ipconnect.de. [2003:ea:8f10:c200:7101:8b48:5eab:cb5f])
        by smtp.googlemail.com with ESMTPSA id k17sm18180890wmj.0.2021.08.08.06.06.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Aug 2021 06:06:16 -0700 (PDT)
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH net-next] r8169: rename rtl_csi_access_enable to
 rtl_set_aspm_entry_latency
Message-ID: <f25dc81e-7615-0b51-24cf-e1137f0f9969@gmail.com>
Date:   Sun, 8 Aug 2021 15:06:08 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rename the function to reflect what it's doing. Also add a description
of the register values as kindly provided by Realtek.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 2c643ec36..7a69b4685 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2598,7 +2598,7 @@ static u32 rtl_csi_read(struct rtl8169_private *tp, int addr)
 		RTL_R32(tp, CSIDR) : ~0;
 }
 
-static void rtl_csi_access_enable(struct rtl8169_private *tp, u8 val)
+static void rtl_set_aspm_entry_latency(struct rtl8169_private *tp, u8 val)
 {
 	struct pci_dev *pdev = tp->pci_dev;
 	u32 csi;
@@ -2606,6 +2606,8 @@ static void rtl_csi_access_enable(struct rtl8169_private *tp, u8 val)
 	/* According to Realtek the value at config space address 0x070f
 	 * controls the L0s/L1 entrance latency. We try standard ECAM access
 	 * first and if it fails fall back to CSI.
+	 * bit 0..2: L0: 0 = 1us, 1 = 2us .. 6 = 7us, 7 = 7us (no typo)
+	 * bit 3..5: L1: 0 = 1us, 1 = 2us .. 6 = 64us, 7 = 64us
 	 */
 	if (pdev->cfg_size > 0x070f &&
 	    pci_write_config_byte(pdev, 0x070f, val) == PCIBIOS_SUCCESSFUL)
@@ -2619,7 +2621,8 @@ static void rtl_csi_access_enable(struct rtl8169_private *tp, u8 val)
 
 static void rtl_set_def_aspm_entry_latency(struct rtl8169_private *tp)
 {
-	rtl_csi_access_enable(tp, 0x27);
+	/* L0 7us, L1 16us */
+	rtl_set_aspm_entry_latency(tp, 0x27);
 }
 
 struct ephy_info {
@@ -3502,8 +3505,8 @@ static void rtl_hw_start_8106(struct rtl8169_private *tp)
 	RTL_W8(tp, MCU, RTL_R8(tp, MCU) | EN_NDP | EN_OOB_RESET);
 	RTL_W8(tp, DLLPR, RTL_R8(tp, DLLPR) & ~PFM_EN);
 
-	/* The default value is 0x13. Change it to 0x2f */
-	rtl_csi_access_enable(tp, 0x2f);
+	/* L0 7us, L1 32us - needed to avoid issues with link-up detection */
+	rtl_set_aspm_entry_latency(tp, 0x2f);
 
 	rtl_eri_write(tp, 0x1d0, ERIAR_MASK_0011, 0x0000);
 
-- 
2.32.0

