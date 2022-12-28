Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD64C657742
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 14:37:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232995AbiL1NhK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Dec 2022 08:37:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232892AbiL1Ngn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Dec 2022 08:36:43 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B08B25D6;
        Wed, 28 Dec 2022 05:36:41 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id qk9so38432654ejc.3;
        Wed, 28 Dec 2022 05:36:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lYZhKnZhGNvp8Xep7RsrgSJ8LUS+CmNkQDKEvWswvc8=;
        b=CQA6avDsiZEmJEhbFddEiEJMN4q2sWO1s5G3xMVHZsRmMokA8ru0VG3gtTEobjSRlO
         SbLC4pPXOWYmEHgu3ijRE+eR7odRbsmxk8na30IN1pkzGH0ylXeAnPlAYBNVgB5vVSfB
         t2gh06TKv9f1gtqLw5OFGz62GO/Qa5d/fDixsHFkeywRFaOfSTM64ycpDRuhrHpYC6Rg
         HnE3ZB/TeNByjKm1/HEFYl0fgzJqvsS/ZmUcOfzKTUFW3DHr38qwI9Jm4THQwxBLFBQ2
         9O75HTGEJrtW7baPvMSnG/r27TbP3m8xCamvP/vWC0MgEfhpM1FDOiOCCpjKmJzikIlh
         4W9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lYZhKnZhGNvp8Xep7RsrgSJ8LUS+CmNkQDKEvWswvc8=;
        b=AtNDFs6z+C8rjWy2DJCOk0syaYYHR02kB1IOOtDfyIzJoxHuUGatE9w+kV6iJzDVWh
         nNyDA4NoM1igO2Se9krmE+I7UO0f14D49uXG0uRx40OhUbqVLbmA3zTtnbsgCrmtuP2I
         rm8WlCcol8vFHA4T5W4GcyVn7ld9+uC1mywYIWJt1jpDmyYGSHeNiOFQAmqHsaWtt0/5
         O3+CIUK1TmmPldZx2jtMptDJip5cA54iChhiz7Gn2akPfvXAqwPP15ZmQZkP+hdB2mqu
         3HgqJxAJDNCVUr1ErycZH249PRfZOSUn/cZ+zL+5rgj01p3oD2Q6gn4XDzyJjWU+AEo8
         napQ==
X-Gm-Message-State: AFqh2kqpfJ8lsheVMRnw138zldI3foIslYVhBliMl+jSirCb3fuHKLKJ
        +kZ61juO4fJN9H9RMpl8DExRlKLl5xA=
X-Google-Smtp-Source: AMrXdXtbhpc7LmU4h0/mF5HOGMsX6Lvo91Ar908rhw1PEdNupB67Ewn0dciOsKdmQNY8eeeqo0PgtQ==
X-Received: by 2002:a17:906:94f:b0:7c1:4f7c:947f with SMTP id j15-20020a170906094f00b007c14f7c947fmr22135258ejd.72.1672234599669;
        Wed, 28 Dec 2022 05:36:39 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a01-0c23-b830-5100-f22f-74ff-fe21-0725.c23.pool.telefonica.de. [2a01:c23:b830:5100:f22f:74ff:fe21:725])
        by smtp.googlemail.com with ESMTPSA id g3-20020a170906538300b0082535e2da13sm7450475ejo.6.2022.12.28.05.36.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Dec 2022 05:36:39 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-wireless@vger.kernel.org
Cc:     tony0620emma@gmail.com, kvalo@kernel.org, pkshih@realtek.com,
        tehuang@realtek.com, s.hauer@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 1/4] rtw88: Add packed attribute to the eFuse structs
Date:   Wed, 28 Dec 2022 14:35:44 +0100
Message-Id: <20221228133547.633797-2-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228133547.633797-1-martin.blumenstingl@googlemail.com>
References: <20221228133547.633797-1-martin.blumenstingl@googlemail.com>
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

Also change the type of the res2..res3 eFuse fields to u16 to avoid the
following warning, now that their surrounding struct has the packed
attribute:
  note: offset of packed bit-field 'res2' has changed in GCC 4.4

Fixes: e3037485c68e ("rtw88: new Realtek 802.11ac driver")
Fixes: ab0a031ecf29 ("rtw88: 8723d: Add read_efuse to recognize efuse info from map")
Fixes: 769a29ce2af4 ("rtw88: 8821c: add basic functions")
Fixes: 87caeef032fc ("wifi: rtw88: Add rtw8723du chipset support")
Fixes: aff5ffd718de ("wifi: rtw88: Add rtw8821cu chipset support")
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/net/wireless/realtek/rtw88/main.h     |  6 +++---
 drivers/net/wireless/realtek/rtw88/rtw8723d.h |  6 +++---
 drivers/net/wireless/realtek/rtw88/rtw8821c.h | 20 +++++++++----------
 drivers/net/wireless/realtek/rtw88/rtw8822b.h | 20 +++++++++----------
 drivers/net/wireless/realtek/rtw88/rtw8822c.h | 20 +++++++++----------
 5 files changed, 36 insertions(+), 36 deletions(-)

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
index 1c81260f3a54..6ba0d4ee92bd 100644
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
@@ -43,13 +43,13 @@ struct rtw8821ce_efuse {
 	u8 link_cap[4];
 	u8 link_control[2];
 	u8 serial_number[8];
-	u8 res0:2;			/* 0xf4 */
-	u8 ltr_en:1;
-	u8 res1:2;
-	u8 obff:2;
-	u8 res2:3;
-	u8 obff_cap:2;
-	u8 res3:4;
+	u16 res0:2;			/* 0xf4 */
+	u16 ltr_en:1;
+	u16 res1:2;
+	u16 obff:2;
+	u16 res2:3;
+	u16 obff_cap:2;
+	u16 res3:4;
 	u8 res4[3];
 	u8 class_code[3];
 	u8 pci_pm_L1_2_supp:1;
@@ -63,7 +63,7 @@ struct rtw8821ce_efuse {
 	u8 res6:1;
 	u8 port_t_power_on_value:5;
 	u8 res7;
-};
+} __packed;
 
 struct rtw8821c_efuse {
 	__le16 rtl_id;
@@ -95,7 +95,7 @@ struct rtw8821c_efuse {
 		struct rtw8821ce_efuse e;
 		struct rtw8821cu_efuse u;
 	};
-};
+} __packed;
 
 static inline void
 _rtw_write32s_mask(struct rtw_dev *rtwdev, u32 addr, u32 mask, u32 data)
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822b.h b/drivers/net/wireless/realtek/rtw88/rtw8822b.h
index 01d3644e0c94..12a123436741 100644
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
@@ -43,13 +43,13 @@ struct rtw8822be_efuse {
 	u8 link_cap[4];
 	u8 link_control[2];
 	u8 serial_number[8];
-	u8 res0:2;			/* 0xf4 */
-	u8 ltr_en:1;
-	u8 res1:2;
-	u8 obff:2;
-	u8 res2:3;
-	u8 obff_cap:2;
-	u8 res3:4;
+	u16 res0:2;			/* 0xf4 */
+	u16 ltr_en:1;
+	u16 res1:2;
+	u16 obff:2;
+	u16 res2:3;
+	u16 obff_cap:2;
+	u16 res3:4;
 	u8 res4[3];
 	u8 class_code[3];
 	u8 pci_pm_L1_2_supp:1;
@@ -63,7 +63,7 @@ struct rtw8822be_efuse {
 	u8 res6:1;
 	u8 port_t_power_on_value:5;
 	u8 res7;
-};
+} __packed;
 
 struct rtw8822b_efuse {
 	__le16 rtl_id;
@@ -95,7 +95,7 @@ struct rtw8822b_efuse {
 		struct rtw8822bu_efuse u;
 		struct rtw8822be_efuse e;
 	};
-};
+} __packed;
 
 static inline void
 _rtw_write32s_mask(struct rtw_dev *rtwdev, u32 addr, u32 mask, u32 data)
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822c.h b/drivers/net/wireless/realtek/rtw88/rtw8822c.h
index 479d5d769c52..4ca7874fdc35 100644
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
@@ -30,13 +30,13 @@ struct rtw8822ce_efuse {
 	u8 link_cap[4];
 	u8 link_control[2];
 	u8 serial_number[8];
-	u8 res0:2;			/* 0x144 */
-	u8 ltr_en:1;
-	u8 res1:2;
-	u8 obff:2;
-	u8 res2:3;
-	u8 obff_cap:2;
-	u8 res3:4;
+	u16 res0:2;			/* 0x144 */
+	u16 ltr_en:1;
+	u16 res1:2;
+	u16 obff:2;
+	u16 res2:3;
+	u16 obff_cap:2;
+	u16 res3:4;
 	u8 class_code[3];
 	u8 res4;
 	u8 pci_pm_L1_2_supp:1;
@@ -50,7 +50,7 @@ struct rtw8822ce_efuse {
 	u8 res6:1;
 	u8 port_t_power_on_value:5;
 	u8 res7;
-};
+} __packed;
 
 struct rtw8822c_efuse {
 	__le16 rtl_id;
@@ -94,7 +94,7 @@ struct rtw8822c_efuse {
 		struct rtw8822cu_efuse u;
 		struct rtw8822ce_efuse e;
 	};
-};
+} __packed;
 
 enum rtw8822c_dpk_agc_phase {
 	RTW_DPK_GAIN_CHECK,
-- 
2.39.0

