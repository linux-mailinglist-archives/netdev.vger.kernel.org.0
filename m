Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ADD02C55BC
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 14:36:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390029AbgKZNcz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 08:32:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390250AbgKZNcK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 08:32:10 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27904C061A47
        for <netdev@vger.kernel.org>; Thu, 26 Nov 2020 05:32:10 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id e7so2159641wrv.6
        for <netdev@vger.kernel.org>; Thu, 26 Nov 2020 05:32:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OAyFBnkzLiaZhl/JnY/CqxtoMQBIM48e3o5HHcfQRSE=;
        b=KvBj7vPRJZnSo5P9Vrpd05dp/jHgMi246Xu6fMSd4mmudD6p0ToaXtzaOArSdCtl7I
         oNtRfXDD9BJijpm3RhSAjFAWn3uJy82DW34dQGky/LUOHTMpPEg1V3z5rY415++HISJF
         mza8MsVES2/1YXkXRnZYGcPi7xEJq/0AtxmNoDMGoXn2E9iTkrKR1TVYqlcQVZvAw694
         E1OSTltME0XgOt4Zv1ETxpK6+CeSl0kMWVjJRyJUEE8Tg+XXs9mrLKTRmtm0YLRkMJn0
         DhDaAl0VgrIJ2tgvTx9eC0fvGx3TRIcrglvOo7j9jlHPI86XURijwXBDXqcT3uxkuFD5
         eqCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OAyFBnkzLiaZhl/JnY/CqxtoMQBIM48e3o5HHcfQRSE=;
        b=eqoIsJz65/xO1KQKwwWpUWNnecY28EcJC/3vlI7WKIMGeIRUGEUdjN+aix9OUaq2IG
         DfYTIo6bs3X4wRhGF/IQp9k0N/Tcua+LzmUIv7EWv0NkX3o2XP9wOo/DxMK41ShenNxh
         yV4sNSTx2ffML0pAst1983LYNJmr2azuzdqC/bfU8PDXSPThR5/9t19bEVSVp849eSqq
         nweVtD7Ckxwr5YP9DFEgNfhKOBIaafIPrv0atVDFedEXfFEkONVa4aj8JZ9FuAd7+kdE
         78yaTHQ/GmVEci8sFOHn9lRawX0oGySWPfGHem2o80mrKk/gqZ/kEDuijmYkl/CdGOZj
         XfPg==
X-Gm-Message-State: AOAM533ZIKiyNmqzw4Zizg3Og1MUq/umXGRjXWM62AU96Jyxo0zevjvL
        E6Lnw6aM0HVVV+n564Dk0c85rNv9dxg7lALW
X-Google-Smtp-Source: ABdhPJx4DWwdS4AQo1feaaXyk8LdNheDTjbG6QpSfvEBpKFfeL9xMvx2NQF9SO8N3aKOXvr8nvLBBw==
X-Received: by 2002:a5d:4701:: with SMTP id y1mr3868307wrq.33.1606397528852;
        Thu, 26 Nov 2020 05:32:08 -0800 (PST)
Received: from dell.default ([91.110.221.235])
        by smtp.gmail.com with ESMTPSA id n10sm8701001wrv.77.2020.11.26.05.32.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2020 05:32:08 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org, kvalo@codeaurora.org
Cc:     linux-kernel@vger.kernel.org,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 10/17] ath9k: ar5008_phy: Demote half completed function headers
Date:   Thu, 26 Nov 2020 13:31:45 +0000
Message-Id: <20201126133152.3211309-11-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201126133152.3211309-1-lee.jones@linaro.org>
References: <20201126133152.3211309-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/ath/ath9k/ar5008_phy.c:119: warning: Function parameter or member 'rfBuf' not described in 'ar5008_hw_phy_modify_rx_buffer'
 drivers/net/wireless/ath/ath9k/ar5008_phy.c:119: warning: Function parameter or member 'reg32' not described in 'ar5008_hw_phy_modify_rx_buffer'
 drivers/net/wireless/ath/ath9k/ar5008_phy.c:119: warning: Function parameter or member 'numBits' not described in 'ar5008_hw_phy_modify_rx_buffer'
 drivers/net/wireless/ath/ath9k/ar5008_phy.c:119: warning: Function parameter or member 'firstBit' not described in 'ar5008_hw_phy_modify_rx_buffer'

Cc: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/ath/ath9k/ar5008_phy.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar5008_phy.c b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
index 2fa30834a88db..6610d76131fa8 100644
--- a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
@@ -102,13 +102,8 @@ static void ar5008_write_bank6(struct ath_hw *ah, unsigned int *writecnt)
 	REGWRITE_BUFFER_FLUSH(ah);
 }
 
-/**
+/*
  * ar5008_hw_phy_modify_rx_buffer() - perform analog swizzling of parameters
- * @rfbuf:
- * @reg32:
- * @numBits:
- * @firstBit:
- * @column:
  *
  * Performs analog "swizzling" of parameters into their location.
  * Used on external AR2133/AR5133 radios.
@@ -198,10 +193,8 @@ static void ar5008_hw_force_bias(struct ath_hw *ah, u16 synth_freq)
 	ar5008_write_bank6(ah, &reg_writes);
 }
 
-/**
+/*
  * ar5008_hw_set_channel - tune to a channel on the external AR2133/AR5133 radios
- * @ah: atheros hardware structure
- * @chan:
  *
  * For the external AR2133/AR5133 radios, takes the MHz channel value and set
  * the channel value. Assumes writes enabled to analog bus and bank6 register
@@ -430,10 +423,8 @@ void ar5008_hw_cmn_spur_mitigate(struct ath_hw *ah,
 	REG_WRITE(ah, AR_PHY_MASK2_P_61_45, tmp_mask);
 }
 
-/**
+/*
  * ar5008_hw_spur_mitigate - convert baseband spur frequency for external radios
- * @ah: atheros hardware structure
- * @chan:
  *
  * For non single-chip solutions. Converts to baseband spur frequency given the
  * input channel frequency and compute register settings below.
-- 
2.25.1

