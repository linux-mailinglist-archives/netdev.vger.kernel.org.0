Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF2042A2952
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 12:28:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728807AbgKBL1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 06:27:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728739AbgKBLYs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 06:24:48 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D453DC0617A6
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 03:24:47 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id w14so14117204wrs.9
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 03:24:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OAyFBnkzLiaZhl/JnY/CqxtoMQBIM48e3o5HHcfQRSE=;
        b=D6UrFCbNnbIMKjVgRasS/TVPF0VFgetQBPCgu22jy/5xPEaU/MeB37127gXhnJ2Q/v
         9B8Dc/D11Iuhl9l0wkkX0tPQE/JYuxjYpSYoGoy7jy2VuYHuxGBU+JKVU3ezNh0d6F5L
         XQRJruZlUj2caVSprleh4QEvkGtsM4Bbz4qxkpPkQYLZzrkOPep5NdtrCCyNb68pNkk0
         v/3Guv2tYwpyktPn0vilkm7u2eird8Zcx91kYjKNWNXW8efOmE9dlBCs97tfxwpsbZqm
         XR2EeJuKuB/yGHZiYgjMnQD14vwlRc9Z8sv/+5xPM2o6nUznn/MjCgolB3+x/LB5UcHM
         4tSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OAyFBnkzLiaZhl/JnY/CqxtoMQBIM48e3o5HHcfQRSE=;
        b=anADYNAtx84r7IfQHNsZDy/0RUfttEwL5zMX9ch4WACvcIWbhVV0NiC/XZ/Z2Y2hXz
         LQIV8OSteK4X8jG1MwRAhfdY+b/9VjZsGySdfZMFY0H8rJ9LE15WN4c6z7UMjwOz5ZwW
         rgOfaOU6Y3RLA4B2sOrFdB5CNUPQRPK0ncW7DfyQoGlViSyqvF9JZHSqhNossYdK+RgS
         orBWdjBHEHHRCPpBI9vPQpTwg58Ri1iLeB2BjFPs+uRne1xP0bVddLePy9RutK4fidPD
         LJwM9MObiiZCsTRW9NECIXLUEL003Z4UyemJ/773WsBA/SlQp6NnK4G0WKrz2r8G29i4
         FxDA==
X-Gm-Message-State: AOAM530CQtJDQe2lFZppjXC3VjeqbXhhGliK+ovghfSWpkaRKoq0RjyI
        cy+IU45FvugBqtSgCiDm9vVHUQ==
X-Google-Smtp-Source: ABdhPJz9zMcwVD2AX9EtfnH8vy23WmMsvpYeEmhm18hnzkcD7bKocVRmvzyBo2IqrL3PWlu2YTNv9w==
X-Received: by 2002:adf:aad0:: with SMTP id i16mr19166015wrc.270.1604316286561;
        Mon, 02 Nov 2020 03:24:46 -0800 (PST)
Received: from dell.default ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id m14sm21867354wro.43.2020.11.02.03.24.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 03:24:46 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org
Cc:     linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 20/41] ath9k: ar5008_phy: Demote half completed function headers
Date:   Mon,  2 Nov 2020 11:23:49 +0000
Message-Id: <20201102112410.1049272-21-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201102112410.1049272-1-lee.jones@linaro.org>
References: <20201102112410.1049272-1-lee.jones@linaro.org>
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

