Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F144658CDB
	for <lists+netdev@lfdr.de>; Thu, 29 Dec 2022 13:49:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233144AbiL2MtR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Dec 2022 07:49:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbiL2MtP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Dec 2022 07:49:15 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BC7313D50;
        Thu, 29 Dec 2022 04:49:14 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id s5so26545496edc.12;
        Thu, 29 Dec 2022 04:49:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oiGoLUnjOTf7e6Jl/lm1CqIHOz+PnhchazFWlsj2FA0=;
        b=qLQpmWfq4dgok0NDj5piPhut7qxDewoNVuh6k5Gy5XVvBR6aUIMPKcZvMot4wlnqJA
         cVkiGVJaMuGxjP00yujDRhuI4BhIc3Q+9VYsNNeEnsEnaeN8MpBe9JF2f092rJsCNzQz
         yavUZMnOk+XIn0vopyTt6VjcWVQBhIlNkRZL7KyBFu3YAszjRHXrIs+aYb2jRETA6iBS
         cRbH3Xdld+lcwzknB0TxM2YrMC55mIZsP0CmKTv0krOcksuPmrEa5QhncZmFnDGMrUnf
         xhtqf0E9I/vMSEUAbJ8H6oApAwjQdcLt7VB6U2rsx81ieqFn5vjFlon1oqdVHvWugmLa
         XU7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oiGoLUnjOTf7e6Jl/lm1CqIHOz+PnhchazFWlsj2FA0=;
        b=Y+4vjQ+fObTsVRS5kDkmKYFEyfzyIpJDktGQHjLOw4lIhfxPYCHLLMEgaeoJBnLieH
         xRFtX4UFFMfaNw4htSziz6gcu1PHp4GieQNep0yK8nS3ZVNe2kWJQ7T20w6yp/+zYyNe
         GTGDJLJAFkbkNDRZsJHdAGA4ABl2X+jJdow5E7kiiHw6QGBUl+nBc2TDwamlPR70tbKU
         6FCnt80lUHhCnXyoK6ERzmDA63QSTSv/Ah4vB/rR7YkDLiTPqGQu/WHe4hxi4dbKcgsz
         OOKJEI+yhDE8Yiko8y71n33a6zmj08xmzxwKfXxSm5YGLuDcoQjZyXlpf1wyYZ01QJ2L
         bgoQ==
X-Gm-Message-State: AFqh2koRoW7MpUlC0CHDd1JwHTdhO86SkfKiOb8S3Lu28JXtmodzf4c3
        IacqR0dfLOQftKmJj0RY59eJw8mjDto=
X-Google-Smtp-Source: AMrXdXvik6JDzwc7E2FlR4SlqauXFvJtS1c4X0ETKjtsBYqhpkqjrGAkjeUpVXnylA7tSAfJdF7d9A==
X-Received: by 2002:aa7:d448:0:b0:467:b851:6066 with SMTP id q8-20020aa7d448000000b00467b8516066mr31660784edr.6.1672318152146;
        Thu, 29 Dec 2022 04:49:12 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a01-0c22-7789-6e00-0000-0000-0000-0e63.c22.pool.telefonica.de. [2a01:c22:7789:6e00::e63])
        by smtp.googlemail.com with ESMTPSA id b12-20020aa7dc0c000000b0046892e493dcsm8166299edu.26.2022.12.29.04.49.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Dec 2022 04:49:11 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-wireless@vger.kernel.org
Cc:     tony0620emma@gmail.com, kvalo@kernel.org, pkshih@realtek.com,
        s.hauer@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 1/4] rtw88: Add packed attribute to the eFuse structs
Date:   Thu, 29 Dec 2022 13:48:42 +0100
Message-Id: <20221229124845.1155429-2-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221229124845.1155429-1-martin.blumenstingl@googlemail.com>
References: <20221229124845.1155429-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The eFuse definitions in the rtw88 are using structs to describe the
eFuse contents. Add the packed attribute to all structs used for the
eFuse description so the compiler doesn't add gaps or re-order
attributes.

Also split the res2 eFuse field (which for some reason has parts of it's
data in two separate u8 fields) to avoid the following warning, now that
their surrounding struct has the packed attribute:
  note: offset of packed bit-field 'res2' has changed in GCC 4.4

Fixes: e3037485c68e ("rtw88: new Realtek 802.11ac driver")
Fixes: ab0a031ecf29 ("rtw88: 8723d: Add read_efuse to recognize efuse info from map")
Fixes: 769a29ce2af4 ("rtw88: 8821c: add basic functions")
Fixes: 87caeef032fc ("wifi: rtw88: Add rtw8723du chipset support")
Fixes: aff5ffd718de ("wifi: rtw88: Add rtw8821cu chipset support")
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/net/wireless/realtek/rtw88/main.h     | 6 +++---
 drivers/net/wireless/realtek/rtw88/rtw8723d.h | 6 +++---
 drivers/net/wireless/realtek/rtw88/rtw8821c.h | 9 +++++----
 drivers/net/wireless/realtek/rtw88/rtw8822b.h | 9 +++++----
 drivers/net/wireless/realtek/rtw88/rtw8822c.h | 9 +++++----
 5 files changed, 21 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/main.h b/drivers/net/wireless/realtek/rtw88/main.h
index 165f299e8e1f..8441c26680ad 100644
--- a/drivers/net/wireless/realtek/rtw88/main.h
+++ b/drivers/net/wireless/realtek/rtw88/main.h
@@ -438,7 +438,7 @@ struct rtw_2g_txpwr_idx {
 	struct rtw_2g_ns_pwr_idx_diff ht_2s_diff;
 	struct rtw_2g_ns_pwr_idx_diff ht_3s_diff;
 	struct rtw_2g_ns_pwr_idx_diff ht_4s_diff;
-};
+} __packed;
 
 struct rtw_5g_ht_1s_pwr_idx_diff {
 #ifdef __LITTLE_ENDIAN
@@ -495,12 +495,12 @@ struct rtw_5g_txpwr_idx {
 	struct rtw_5g_vht_ns_pwr_idx_diff vht_2s_diff;
 	struct rtw_5g_vht_ns_pwr_idx_diff vht_3s_diff;
 	struct rtw_5g_vht_ns_pwr_idx_diff vht_4s_diff;
-};
+} __packed;
 
 struct rtw_txpwr_idx {
 	struct rtw_2g_txpwr_idx pwr_idx_2g;
 	struct rtw_5g_txpwr_idx pwr_idx_5g;
-};
+} __packed;
 
 struct rtw_timer_list {
 	struct timer_list timer;
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8723d.h b/drivers/net/wireless/realtek/rtw88/rtw8723d.h
index a356318a5c15..8160c4782457 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8723d.h
+++ b/drivers/net/wireless/realtek/rtw88/rtw8723d.h
@@ -39,7 +39,7 @@ struct rtw8723de_efuse {
 	u8 device_id[2];
 	u8 sub_vender_id[2];
 	u8 sub_device_id[2];
-};
+} __packed;
 
 struct rtw8723du_efuse {
 	u8 res4[48];                    /* 0xd0 */
@@ -47,7 +47,7 @@ struct rtw8723du_efuse {
 	u8 product_id[2];               /* 0x102 */
 	u8 usb_option;                  /* 0x104 */
 	u8 mac_addr[ETH_ALEN];          /* 0x107 */
-};
+} __packed;
 
 struct rtw8723d_efuse {
 	__le16 rtl_id;
@@ -81,7 +81,7 @@ struct rtw8723d_efuse {
 		struct rtw8723de_efuse e;
 		struct rtw8723du_efuse u;
 	};
-};
+} __packed;
 
 extern const struct rtw_chip_info rtw8723d_hw_spec;
 
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8821c.h b/drivers/net/wireless/realtek/rtw88/rtw8821c.h
index 1c81260f3a54..6ab16f56b5cd 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8821c.h
+++ b/drivers/net/wireless/realtek/rtw88/rtw8821c.h
@@ -27,7 +27,7 @@ struct rtw8821cu_efuse {
 	u8 res11[0xcf];
 	u8 package_type;		/* 0x1fb */
 	u8 res12[0x4];
-};
+} __packed;
 
 struct rtw8821ce_efuse {
 	u8 mac_addr[ETH_ALEN];		/* 0xd0 */
@@ -47,7 +47,8 @@ struct rtw8821ce_efuse {
 	u8 ltr_en:1;
 	u8 res1:2;
 	u8 obff:2;
-	u8 res2:3;
+	u8 res2_1:1;
+	u8 res2_2:2;
 	u8 obff_cap:2;
 	u8 res3:4;
 	u8 res4[3];
@@ -63,7 +64,7 @@ struct rtw8821ce_efuse {
 	u8 res6:1;
 	u8 port_t_power_on_value:5;
 	u8 res7;
-};
+} __packed;
 
 struct rtw8821c_efuse {
 	__le16 rtl_id;
@@ -95,7 +96,7 @@ struct rtw8821c_efuse {
 		struct rtw8821ce_efuse e;
 		struct rtw8821cu_efuse u;
 	};
-};
+} __packed;
 
 static inline void
 _rtw_write32s_mask(struct rtw_dev *rtwdev, u32 addr, u32 mask, u32 data)
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822b.h b/drivers/net/wireless/realtek/rtw88/rtw8822b.h
index 01d3644e0c94..35a937fc5162 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822b.h
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822b.h
@@ -27,7 +27,7 @@ struct rtw8822bu_efuse {
 	u8 res11[0xcf];
 	u8 package_type;		/* 0x1fb */
 	u8 res12[0x4];
-};
+} __packed;
 
 struct rtw8822be_efuse {
 	u8 mac_addr[ETH_ALEN];		/* 0xd0 */
@@ -47,7 +47,8 @@ struct rtw8822be_efuse {
 	u8 ltr_en:1;
 	u8 res1:2;
 	u8 obff:2;
-	u8 res2:3;
+	u8 res2_1:1;
+	u8 res2_2:2;
 	u8 obff_cap:2;
 	u8 res3:4;
 	u8 res4[3];
@@ -63,7 +64,7 @@ struct rtw8822be_efuse {
 	u8 res6:1;
 	u8 port_t_power_on_value:5;
 	u8 res7;
-};
+} __packed;
 
 struct rtw8822b_efuse {
 	__le16 rtl_id;
@@ -95,7 +96,7 @@ struct rtw8822b_efuse {
 		struct rtw8822bu_efuse u;
 		struct rtw8822be_efuse e;
 	};
-};
+} __packed;
 
 static inline void
 _rtw_write32s_mask(struct rtw_dev *rtwdev, u32 addr, u32 mask, u32 data)
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822c.h b/drivers/net/wireless/realtek/rtw88/rtw8822c.h
index 479d5d769c52..868c0e6825e5 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822c.h
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822c.h
@@ -14,7 +14,7 @@ struct rtw8822cu_efuse {
 	u8 res1[3];
 	u8 mac_addr[ETH_ALEN];		/* 0x157 */
 	u8 res2[0x3d];
-};
+} __packed;
 
 struct rtw8822ce_efuse {
 	u8 mac_addr[ETH_ALEN];		/* 0x120 */
@@ -34,7 +34,8 @@ struct rtw8822ce_efuse {
 	u8 ltr_en:1;
 	u8 res1:2;
 	u8 obff:2;
-	u8 res2:3;
+	u8 res2_1:1;
+	u8 res2_2:2;
 	u8 obff_cap:2;
 	u8 res3:4;
 	u8 class_code[3];
@@ -50,7 +51,7 @@ struct rtw8822ce_efuse {
 	u8 res6:1;
 	u8 port_t_power_on_value:5;
 	u8 res7;
-};
+} __packed;
 
 struct rtw8822c_efuse {
 	__le16 rtl_id;
@@ -94,7 +95,7 @@ struct rtw8822c_efuse {
 		struct rtw8822cu_efuse u;
 		struct rtw8822ce_efuse e;
 	};
-};
+} __packed;
 
 enum rtw8822c_dpk_agc_phase {
 	RTW_DPK_GAIN_CHECK,
-- 
2.39.0

