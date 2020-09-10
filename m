Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 627AF263E20
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 09:11:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730336AbgIJHKz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 03:10:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730190AbgIJHAy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 03:00:54 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDAAAC06136C
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 23:55:25 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id o5so5363619wrn.13
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 23:55:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=b0baAohHUTXp74ql/ottX2BRpMM66QSQWOVDthKtH1c=;
        b=HKVrT14haY/mNZj96mGTF/IUCFO6AmmnHLrg6BbCJj06DT9z3r3APc76S4/SRI5Pog
         AefDbMBOTenz8QMyYyPpVKmlpQJ6zZcLbKZWSjLdV691EswPxgcUIpujucAzma9WtqbJ
         rufxLGvV3DutfHDWZ/+WjNV7qado49VFvzPUI4xexCRCu3LjpZPoHLCBnbsRy1ZganI7
         NtTJPczGu+POYAc2gj/xSaQ+PXsF7hkLfRfPUp+PwI+TnkU7Q/gt2jsx3Ctp4R8fA01E
         dSkk/2pOg4241/gcbQsJHiKpWTttTDxQXD1IDtImVMosR6idtXD1+iE4bCNGK9wRey6P
         JPlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=b0baAohHUTXp74ql/ottX2BRpMM66QSQWOVDthKtH1c=;
        b=kuCHQWt9y14E00iqZ2p0HH5Ie7FGRS9LSzcHmn9LgJs5KOi/klgykV24gDDyaH3W1c
         NLeUku9z0jHeYWaDDbsYCe0ku72KeHRvJhB+kwvd2T0l7AhaVvhRcLwdA2Fa0wCfYLR1
         tDRN1+/3big+i4zY9hwRclFPh7uctQ6uRX5als0xTxM6R5lOSopvuela6kzZ81g/Rlw4
         tTW2MORtoE2lj3xHZkZsa979+QZdxW03uzSXX3Jt3EyyFuTJR59iKWjHVmPn8yBaakH5
         /4WFkoD3isiiZAgvwxjG/wSAxUpnjcNGs6zJ2Rn9u8TM02fhwVlNTCmnYJp1cb49qfM9
         RFwQ==
X-Gm-Message-State: AOAM533wV5IuusAmQWnUpHmofQC9qDvBHK0oa5GKDvVFucdjzBY9mKES
        oYSS5ejXUNDC+Sio24Ioq/d63w==
X-Google-Smtp-Source: ABdhPJy4mJ1ftuhVrY5gR5WIaVIX/PqrHAgdEjs2o2gbwEBOUUZ5DITKGHW/npXbNjRlNIgLNQNsDA==
X-Received: by 2002:adf:f58b:: with SMTP id f11mr7405676wro.250.1599720924532;
        Wed, 09 Sep 2020 23:55:24 -0700 (PDT)
Received: from dell.default ([91.110.221.246])
        by smtp.gmail.com with ESMTPSA id m3sm2444028wme.31.2020.09.09.23.55.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 23:55:24 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>
Subject: [PATCH 27/29] ath9k: ar5008_initvals: Move ar5416Bank{0,1,2,3,7} to where they are used
Date:   Thu, 10 Sep 2020 07:54:29 +0100
Message-Id: <20200910065431.657636-28-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200910065431.657636-1-lee.jones@linaro.org>
References: <20200910065431.657636-1-lee.jones@linaro.org>
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
index 0d34356baf73a..2fa30834a88db 100644
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

