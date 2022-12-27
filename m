Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D97B65711F
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 00:31:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232573AbiL0XbB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 18:31:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232120AbiL0Xao (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 18:30:44 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F6A6272;
        Tue, 27 Dec 2022 15:30:42 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id b88so13594876edf.6;
        Tue, 27 Dec 2022 15:30:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sNWvI++owPQOhkWmIVtBzTJGEAJPDCSXNhp2rWrEL5E=;
        b=nnK0OOhJzlEX0vbgyycR/6mSAdx38bY4ctjiPkAFM/et3F9o33fqvbfQknun6/zKL6
         7wIzhdFmv9PkW14a/bmTB8upYCN3TOFiq9U8IBv9UT2Dkcu90IUNT1acTQSrvPjwz6/4
         fu8Yelrnas5yHDWvzILmx7uBXlV6ZgCNCExNGCWpWohlgkkRZZhlvLAGde0O6m5/FHUo
         TjRpVM7FS60jdQPyie5iMQSf3yWjlJER6icUBy4uXM1t2dRnKuSavtjcDNVh2wWcj69b
         AxtPjJBQErC0gI1C+mB0C9OtMKjGFcfpydzMi+hlIvkH8WE8iqzk/kB75aM4stCnh9aa
         YndA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sNWvI++owPQOhkWmIVtBzTJGEAJPDCSXNhp2rWrEL5E=;
        b=F698HlMHi1vCF+ockccMqJgKoJuSWe1LXvbsNmJtxSI2p16Llm7nWAyvV3/37YC4jN
         BZXieXg+vSBm3vE6aPm0OousIWPtIXomYoa4MHaynK0N/q5kvaAipfnmQh6KGDPwzely
         i2W97Zy4wZqE5p/pcxZawK/4qawqdUhHZn40m+FwI2J/mtc8R/DrijbvmQ6p6dijURXE
         u2PVgPacuI4I6Ql1H88qp1ZGH7367o0/x+xobATMv88egUWFXxoi8eu+mqWwhb73B2El
         VZ+TlAmFxZkfSryMGABKHR5qIxJ/l8AqXvQg2KJzMyZP3pHdWb+Mmak7sOyE8Scgj+SQ
         J1PQ==
X-Gm-Message-State: AFqh2koCrM7MvTBP6zQmnXZtJLUsEb/oKhMqLfJfxX/rdx96EpXw/3Tr
        srxGnaSH+DOZwcOTHxjzKCEjdT/Ka/8=
X-Google-Smtp-Source: AMrXdXsBqs+Vq4I04+NA9mmrJqZnpfOmTy9EWmu/hHEHZqKU0cVeCXeXtTioSKGs0UEMCFEUUIQ7Jw==
X-Received: by 2002:a05:6402:a55:b0:475:9918:37ce with SMTP id bt21-20020a0564020a5500b00475991837cemr19976275edb.13.1672183840839;
        Tue, 27 Dec 2022 15:30:40 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a01-0c23-c4cf-d900-0000-0000-0000-0e63.c23.pool.telefonica.de. [2a01:c23:c4cf:d900::e63])
        by smtp.googlemail.com with ESMTPSA id r7-20020aa7c147000000b0046cbcc86bdesm6489978edp.7.2022.12.27.15.30.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Dec 2022 15:30:40 -0800 (PST)
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
Subject: [RFC PATCH v1 06/19] rtw88: rtw8821c: Add support for parsing the RTL8821CS (SDIO) efuse
Date:   Wed, 28 Dec 2022 00:30:07 +0100
Message-Id: <20221227233020.284266-7-martin.blumenstingl@googlemail.com>
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

The efuse of the SDIO RTL8821CS chip has only one known member: the mac
address is at offset 0x11a. Add a struct rtw8821cs_efuse describing this
and use it for copying the mac address when the SDIO bus is used.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/net/wireless/realtek/rtw88/rtw8821c.c | 9 +++++++++
 drivers/net/wireless/realtek/rtw88/rtw8821c.h | 6 ++++++
 2 files changed, 15 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/rtw8821c.c b/drivers/net/wireless/realtek/rtw88/rtw8821c.c
index 17f800f6efbd..dd01b22f9770 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8821c.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8821c.c
@@ -26,6 +26,12 @@ static void rtw8821ce_efuse_parsing(struct rtw_efuse *efuse,
 	ether_addr_copy(efuse->addr, map->e.mac_addr);
 }
 
+static void rtw8821cs_efuse_parsing(struct rtw_efuse *efuse,
+				    struct rtw8821c_efuse *map)
+{
+	ether_addr_copy(efuse->addr, map->s.mac_addr);
+}
+
 static void rtw8821cu_efuse_parsing(struct rtw_efuse *efuse,
 				    struct rtw8821c_efuse *map)
 {
@@ -74,6 +80,9 @@ static int rtw8821c_read_efuse(struct rtw_dev *rtwdev, u8 *log_map)
 	case RTW_HCI_TYPE_PCIE:
 		rtw8821ce_efuse_parsing(efuse, map);
 		break;
+	case RTW_HCI_TYPE_SDIO:
+		rtw8821cs_efuse_parsing(efuse, map);
+		break;
 	case RTW_HCI_TYPE_USB:
 		rtw8821cu_efuse_parsing(efuse, map);
 		break;
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8821c.h b/drivers/net/wireless/realtek/rtw88/rtw8821c.h
index 1c81260f3a54..1deea54575b5 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8821c.h
+++ b/drivers/net/wireless/realtek/rtw88/rtw8821c.h
@@ -65,6 +65,11 @@ struct rtw8821ce_efuse {
 	u8 res7;
 };
 
+struct rtw8821cs_efuse {
+	u8 res4[0x4a];			/* 0xd0 */
+	u8 mac_addr[ETH_ALEN];		/* 0x11a */
+};
+
 struct rtw8821c_efuse {
 	__le16 rtl_id;
 	u8 res0[0x0e];
@@ -93,6 +98,7 @@ struct rtw8821c_efuse {
 	u8 res[3];
 	union {
 		struct rtw8821ce_efuse e;
+		struct rtw8821cs_efuse s;
 		struct rtw8821cu_efuse u;
 	};
 };
-- 
2.39.0

