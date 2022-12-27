Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1503D657115
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 00:31:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232336AbiL0XbM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 18:31:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232481AbiL0Xay (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 18:30:54 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63F0CC67;
        Tue, 27 Dec 2022 15:30:44 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id c34so14286300edf.0;
        Tue, 27 Dec 2022 15:30:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jtp+Q5wSGg2dbN7IB0CSpN39c6sHF9pt2C0cg9z9mH4=;
        b=XTfv8m/9UeiXT+Lnke3zrSb/yxTzSWi4OktNW0xgv112VbA2RKvgE/Qbf9plT1WrZY
         rTW28YU+AYw0fOXf56t/QpDbMx8UAjZe7uDhv/U0U/N9wGKHI9+6cS3y3bQi0T/QBBeq
         ejNPgiZKGY/tr3AAj1rf4yksSnWlLSPl0KwnsZ0pZo7xkPahOqLznG9qJw2NnWP6HpD5
         XQKR15QAlIDEjUc35iF6VreZpjJHe7KGwruDWjWWATc7k1aNtAagwuRnbniLlnxWuJJX
         usWaj/HI6Gutb8QXWjTI4dQwENH48dW68+zDg6PEfwVpsIFw73zl+c2IRnXfcgmWPA4M
         anbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jtp+Q5wSGg2dbN7IB0CSpN39c6sHF9pt2C0cg9z9mH4=;
        b=zm2Wrns3cc8/WQu3M+ghR27qTEBlyto1fUuMkIzVmOgNJGgp/PTW2N9SmOe/ZS9xrJ
         Bi0cTlcRi79g5J6AAGPUrZ9nGjITm/mYloILg4VgLMYqQ8TiCK4oRy3fNYSoKCBMkUEO
         arNjfgrJQMQp3xU9rqzmbBRyHqI2BgVVeiWOLeRRh2xzsDbiqqQRIPDQCql+8sOjzltK
         fnnKJIzHGdNarOkmjq60cY5mEtxzjpymZaTzKRH1O3SGw3zHJA6l49sCFcpN1p5hhnR5
         La1MkTRCUQajfrs9GT/6DAdGoirkmzQTc8leo9IDydU9gBIup771Llw6NQF4RRT2A/tq
         LFsw==
X-Gm-Message-State: AFqh2kpOnKRs/tQ24e/GeaDiJ+nG5r9hHdiUUkL4FPtsGBNOMECCbZyv
        oIoJhYsOb5PF48PHxfD2sCwutvgurBw=
X-Google-Smtp-Source: AMrXdXsEsGarnDTsLe6s+u0UA/QgLaIg4VNmdykpjVmDg1XqR/mGtl3dgpS6yzDCqBFDV4im8Cz0Cw==
X-Received: by 2002:a50:ec8b:0:b0:486:6d75:9a0c with SMTP id e11-20020a50ec8b000000b004866d759a0cmr4498140edr.12.1672183842746;
        Tue, 27 Dec 2022 15:30:42 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a01-0c23-c4cf-d900-0000-0000-0000-0e63.c23.pool.telefonica.de. [2a01:c23:c4cf:d900::e63])
        by smtp.googlemail.com with ESMTPSA id r7-20020aa7c147000000b0046cbcc86bdesm6489978edp.7.2022.12.27.15.30.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Dec 2022 15:30:42 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-wireless@vger.kernel.org
Cc:     Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-mmc@vger.kernel.org, Chris Morgan <macroalpha82@gmail.com>,
        Nitin Gupta <nitin.gupta981@gmail.com>,
        Neo Jou <neojou@gmail.com>, Pkshih <pkshih@realtek.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [RFC PATCH v1 08/19] rtw88: rtw8822c: Add support for parsing the RTL8822CS (SDIO) efuse
Date:   Wed, 28 Dec 2022 00:30:09 +0100
Message-Id: <20221227233020.284266-9-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221227233020.284266-1-martin.blumenstingl@googlemail.com>
References: <20221227233020.284266-1-martin.blumenstingl@googlemail.com>
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

The efuse of the SDIO RTL8822CS chip has only one known member: the mac
address is at offset 0x16a. Add a struct rtw8822cs_efuse describing this
and use it for copying the mac address when the SDIO bus is used.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/net/wireless/realtek/rtw88/rtw8822c.c | 9 +++++++++
 drivers/net/wireless/realtek/rtw88/rtw8822c.h | 6 ++++++
 2 files changed, 15 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822c.c b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
index 964e27887fe2..8ec779c7ab84 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822c.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
@@ -29,6 +29,12 @@ static void rtw8822ce_efuse_parsing(struct rtw_efuse *efuse,
 	ether_addr_copy(efuse->addr, map->e.mac_addr);
 }
 
+static void rtw8822cs_efuse_parsing(struct rtw_efuse *efuse,
+				    struct rtw8822c_efuse *map)
+{
+	ether_addr_copy(efuse->addr, map->s.mac_addr);
+}
+
 static void rtw8822cu_efuse_parsing(struct rtw_efuse *efuse,
 				    struct rtw8822c_efuse *map)
 {
@@ -64,6 +70,9 @@ static int rtw8822c_read_efuse(struct rtw_dev *rtwdev, u8 *log_map)
 	case RTW_HCI_TYPE_PCIE:
 		rtw8822ce_efuse_parsing(efuse, map);
 		break;
+	case RTW_HCI_TYPE_SDIO:
+		rtw8822cs_efuse_parsing(efuse, map);
+		break;
 	case RTW_HCI_TYPE_USB:
 		rtw8822cu_efuse_parsing(efuse, map);
 		break;
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822c.h b/drivers/net/wireless/realtek/rtw88/rtw8822c.h
index 479d5d769c52..eec2e3074087 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822c.h
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822c.h
@@ -16,6 +16,11 @@ struct rtw8822cu_efuse {
 	u8 res2[0x3d];
 };
 
+struct rtw8822cs_efuse {
+	u8 res0[0x4a];			/* 0x120 */
+	u8 mac_addr[ETH_ALEN];		/* 0x16a */
+};
+
 struct rtw8822ce_efuse {
 	u8 mac_addr[ETH_ALEN];		/* 0x120 */
 	u8 vender_id[2];
@@ -92,6 +97,7 @@ struct rtw8822c_efuse {
 	u8 res10[0x42];
 	union {
 		struct rtw8822cu_efuse u;
+		struct rtw8822cs_efuse s;
 		struct rtw8822ce_efuse e;
 	};
 };
-- 
2.39.0

