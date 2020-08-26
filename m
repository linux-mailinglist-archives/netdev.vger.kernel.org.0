Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75610252A2B
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 11:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728449AbgHZJfg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 05:35:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728357AbgHZJfV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 05:35:21 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 164FEC06135F
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 02:34:38 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id h15so1081736wrt.12
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 02:34:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7UKR3rYf74POYGl3zWTm2JLEunC4uofhzAPfhP0pocI=;
        b=AwyjC/u6v4PkRTDEUzW5YTwptUu33aZaKickGcM2cAwHsFaZSh3VUhKDX1bvVBJrSO
         4bz4KBORUASDwdQfqAKx3d88J5wrfhGzYxAKrmqBGECjC3c7CnDdGYkY9lBhDFCymUQj
         EDw6sSFzrbfef9cPsOW9n3jp+dy66uiSFPNf83D/FHYRlKG88XLNNq96ZivWt25TfrVT
         sdHCBVi+qgdfiq6w8seV/4/KZ/BtO3IBixxQ1EQOKk/to29iEE5l7cDQF8IjNQg4bB7S
         Rc3gzyrMcyijHr9sVaD/IuJGXpKovsNCxwzzB1BfVsNpF+pBAnlBEJs/Qp9ie+YpI0MZ
         o1lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7UKR3rYf74POYGl3zWTm2JLEunC4uofhzAPfhP0pocI=;
        b=lGAUhZIDfHdLwbI9R3BgZiuJErpVS/x/KQMFbhLRj8nhDNl8T23LGQFPk7pZf6PYXG
         qBN19OaymD2D5hezgVGSj02j7xci8FVTBZlFJ0ZvWk8Vevxvtl/L3tgh9Eg/YMSU3bI/
         suD3M5fxYPo4V3mZxaP0O/26s3Y6SvoqYBTRN1DC9tzmsXPXlDtUXxnbbmAiqV4gKse0
         985gryhfFpEyjXrs0+H3ml90JJFHsI+htTNkGU/mY4xwJeIs4mX5bIANz2lSxlcojSFX
         UcqhO3+QLTY18SCHpuNx+LaCPPKpEsOrBlLRhOKvUwzh2JFoPGCe+S12g8W8UXsWsecA
         qoJg==
X-Gm-Message-State: AOAM533KsZxZYOpgFIF1pBxGFc7cbplxrbCYTEGCPWokrXgxmlBhbVcp
        o3JQyfsYHM17siabjqCbJlL1Rg==
X-Google-Smtp-Source: ABdhPJx0+PGYRxM+X3LewS3JB02QeZrJW/r5M6uw0gn3QWnbZnHsBzFex7YLoQ9d6uScoAa3F2SEgA==
X-Received: by 2002:adf:fc02:: with SMTP id i2mr8811277wrr.165.1598434476657;
        Wed, 26 Aug 2020 02:34:36 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id u3sm3978759wml.44.2020.08.26.02.34.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2020 02:34:35 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>
Subject: [PATCH 26/30] wireless: ath: ath9k: ar5008_initvals: Move ar5416Bank{0,1,2,3,7} to where they are used
Date:   Wed, 26 Aug 2020 10:33:57 +0100
Message-Id: <20200826093401.1458456-27-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200826093401.1458456-1-lee.jones@linaro.org>
References: <20200826093401.1458456-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/ath/ath9k/ar5008_initvals.h:627:18: warning: ‘ar5416Bank7’ defined but not used [-Wunused-const-variable=]
 627 | static const u32 ar5416Bank7[][2] = {
 | ^~~~~~~~~~~
 drivers/net/wireless/ath/ath9k/ar5008_initvals.h:548:18: warning: ‘ar5416Bank3’ defined but not used [-Wunused-const-variable=]
 548 | static const u32 ar5416Bank3[][3] = {
 | ^~~~~~~~~~~
 drivers/net/wireless/ath/ath9k/ar5008_initvals.h:542:18: warning: ‘ar5416Bank2’ defined but not used [-Wunused-const-variable=]
 542 | static const u32 ar5416Bank2[][2] = {
 | ^~~~~~~~~~~
 drivers/net/wireless/ath/ath9k/ar5008_initvals.h:536:18: warning: ‘ar5416Bank1’ defined but not used [-Wunused-const-variable=]
 536 | static const u32 ar5416Bank1[][2] = {
 | ^~~~~~~~~~~
 drivers/net/wireless/ath/ath9k/ar5008_initvals.h:462:18: warning: ‘ar5416Bank0’ defined but not used [-Wunused-const-variable=]
 462 | static const u32 ar5416Bank0[][2] = {
 | ^~~~~~~~~~~

Cc: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 .../net/wireless/ath/ath9k/ar5008_initvals.h  | 31 -------------------
 drivers/net/wireless/ath/ath9k/ar5008_phy.c   | 31 ++++++++++++++++++-
 2 files changed, 30 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar5008_initvals.h b/drivers/net/wireless/ath/ath9k/ar5008_initvals.h
index 8d251600d8458..7da8365ae69a8 100644
--- a/drivers/net/wireless/ath/ath9k/ar5008_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar5008_initvals.h
@@ -459,12 +459,6 @@ static const u32 ar5416Common[][2] = {
 	{0x0000a3e0, 0x000001ce},
 };
 
-static const u32 ar5416Bank0[][2] = {
-	/* Addr      allmodes  */
-	{0x000098b0, 0x1e5795e5},
-	{0x000098e0, 0x02008020},
-};
-
 static const u32 ar5416BB_RfGain[][3] = {
 	/* Addr      5G          2G        */
 	{0x00009a00, 0x00000000, 0x00000000},
@@ -533,23 +527,6 @@ static const u32 ar5416BB_RfGain[][3] = {
 	{0x00009afc, 0x000000f9, 0x000000f9},
 };
 
-static const u32 ar5416Bank1[][2] = {
-	/* Addr      allmodes  */
-	{0x000098b0, 0x02108421},
-	{0x000098ec, 0x00000008},
-};
-
-static const u32 ar5416Bank2[][2] = {
-	/* Addr      allmodes  */
-	{0x000098b0, 0x0e73ff17},
-	{0x000098e0, 0x00000420},
-};
-
-static const u32 ar5416Bank3[][3] = {
-	/* Addr      5G          2G        */
-	{0x000098f0, 0x01400018, 0x01c00018},
-};
-
 static const u32 ar5416Bank6TPC[][3] = {
 	/* Addr      5G          2G        */
 	{0x0000989c, 0x00000000, 0x00000000},
@@ -587,13 +564,6 @@ static const u32 ar5416Bank6TPC[][3] = {
 	{0x000098d0, 0x0000000f, 0x0010000f},
 };
 
-static const u32 ar5416Bank7[][2] = {
-	/* Addr      allmodes  */
-	{0x0000989c, 0x00000500},
-	{0x0000989c, 0x00000800},
-	{0x000098cc, 0x0000000e},
-};
-
 static const u32 ar5416Addac[][2] = {
 	/* Addr      allmodes  */
 	{0x0000989c, 0x00000000},
@@ -634,4 +604,3 @@ static const u32 ar5416Addac[][2] = {
 	{0x0000989c, 0x00000000},
 	{0x000098c4, 0x00000000},
 };
-
diff --git a/drivers/net/wireless/ath/ath9k/ar5008_phy.c b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
index dae95402eb3a9..55b2d9aa080d5 100644
--- a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
@@ -18,7 +18,6 @@
 #include "hw-ops.h"
 #include "../regd.h"
 #include "ar9002_phy.h"
-#include "ar5008_initvals.h"
 
 /* All code below is for AR5008, AR9001, AR9002 */
 
@@ -51,6 +50,36 @@ static const int m2ThreshLowExt_off = 127;
 static const int m1ThreshExt_off = 127;
 static const int m2ThreshExt_off = 127;
 
+static const u32 ar5416Bank0[][2] = {
+	/* Addr      allmodes  */
+	{0x000098b0, 0x1e5795e5},
+	{0x000098e0, 0x02008020},
+};
+
+static const u32 ar5416Bank1[][2] = {
+	/* Addr      allmodes  */
+	{0x000098b0, 0x02108421},
+	{0x000098ec, 0x00000008},
+};
+
+static const u32 ar5416Bank2[][2] = {
+	/* Addr      allmodes  */
+	{0x000098b0, 0x0e73ff17},
+	{0x000098e0, 0x00000420},
+};
+
+static const u32 ar5416Bank3[][3] = {
+	/* Addr      5G          2G        */
+	{0x000098f0, 0x01400018, 0x01c00018},
+};
+
+static const u32 ar5416Bank7[][2] = {
+	/* Addr      allmodes  */
+	{0x0000989c, 0x00000500},
+	{0x0000989c, 0x00000800},
+	{0x000098cc, 0x0000000e},
+};
+
 static const struct ar5416IniArray bank0 = STATIC_INI_ARRAY(ar5416Bank0);
 static const struct ar5416IniArray bank1 = STATIC_INI_ARRAY(ar5416Bank1);
 static const struct ar5416IniArray bank2 = STATIC_INI_ARRAY(ar5416Bank2);
-- 
2.25.1

