Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6086D657116
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 00:31:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232416AbiL0XbH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 18:31:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232272AbiL0Xar (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 18:30:47 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85D5F3BB;
        Tue, 27 Dec 2022 15:30:43 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id r26so15660428edc.5;
        Tue, 27 Dec 2022 15:30:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A522Jt6HhfnBCacJa8yLyhSRn9fiN5RDQFLQBl+szdU=;
        b=MJQ/XSgTkapv3EpIbAO8XLCrxJPt/iWc1zTsffUVfG6sA/ybEptpnXcuLak7XB3PIQ
         Ihdw5tH4+sscSaNDvtOvKul2WNmJrPasn5e6wzXj5Zuu0dy0ygDshPp7s0ID0F0veT+Y
         OiiKr1tzJB+kStlcwVFqJbgK1herJfnG0Q8d+wOBrPRXmYNzuSROK9gVhwdD32+2QFbj
         TgTYPhjgnFih9U7IrxdQttkH4vEvGLtK6Qb4NhvqEKx8r4QI80Ds1yNXTzBFdAG0GBIK
         7FaP28dkjw0mNSp/E00hk0fTjqtiZKPTPeJfHqMAXnOG7adcQIRwtAlQEEaGGGoxOAxW
         vjCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A522Jt6HhfnBCacJa8yLyhSRn9fiN5RDQFLQBl+szdU=;
        b=AsukRgtTPdznlbyyBZfa5HNwQ2SeRsEv7T5Y++hYWHazuj6CIp6RZ03w4Nw+NxAF23
         9knLQDK3bvCHNcHAyiXeZvGuRUf5gu0LVuXhxmu5Hqhw2lXTTNovh/Q955JAX/nQm+wl
         9IZILAlXkn+JK3XHIHss1CoYdbKr1XJZAuD81mqjom00qqiZtami9oAFyNdJnL3UA+lt
         aQNF0LfIH241/5crnLyvTmzQn6opVcCL6JgzGSKVbcCHtSaHBbb6AJ2L5/yiaiLs/7yN
         JNdqQH7iVWHRCqMpDHzRyniUn7i+mvPqrbT/elCwMpCCsFoA7SrLgR3B5uulruIOX8g6
         ZGng==
X-Gm-Message-State: AFqh2kouJA03nhjVEHVPi9iZEzgq+/Be1BG7i2EzgWyUKzEAGLIHIBGy
        i+TDvNOjjmkvFdC0TmBW2jsIXxJwbv0=
X-Google-Smtp-Source: AMrXdXvaPCVvWtHhAnIq7AgnnY4Rij/5C/GKq7b6fzjPX++szIm4uKWvqh3zdPh1eXYWl1fb8NEN7A==
X-Received: by 2002:a05:6402:48c:b0:483:d49f:e26c with SMTP id k12-20020a056402048c00b00483d49fe26cmr9760873edv.15.1672183841899;
        Tue, 27 Dec 2022 15:30:41 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a01-0c23-c4cf-d900-0000-0000-0000-0e63.c23.pool.telefonica.de. [2a01:c23:c4cf:d900::e63])
        by smtp.googlemail.com with ESMTPSA id r7-20020aa7c147000000b0046cbcc86bdesm6489978edp.7.2022.12.27.15.30.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Dec 2022 15:30:41 -0800 (PST)
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
Subject: [RFC PATCH v1 07/19] rtw88: rtw8822b: Add support for parsing the RTL8822BS (SDIO) efuse
Date:   Wed, 28 Dec 2022 00:30:08 +0100
Message-Id: <20221227233020.284266-8-martin.blumenstingl@googlemail.com>
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

The efuse of the SDIO RTL8822BS chip has only one known member: the mac
address is at offset 0x11a. Add a struct rtw8822bs_efuse describing this
and use it for copying the mac address when the SDIO bus is used.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/net/wireless/realtek/rtw88/rtw8822b.c | 10 ++++++++++
 drivers/net/wireless/realtek/rtw88/rtw8822b.h |  6 ++++++
 2 files changed, 16 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822b.c b/drivers/net/wireless/realtek/rtw88/rtw8822b.c
index 74dfb89b2c94..4ed5b98fab23 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822b.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822b.c
@@ -26,10 +26,17 @@ static void rtw8822be_efuse_parsing(struct rtw_efuse *efuse,
 	ether_addr_copy(efuse->addr, map->e.mac_addr);
 }
 
+static void rtw8822bs_efuse_parsing(struct rtw_efuse *efuse,
+				    struct rtw8822b_efuse *map)
+{
+	ether_addr_copy(efuse->addr, map->s.mac_addr);
+}
+
 static void rtw8822bu_efuse_parsing(struct rtw_efuse *efuse,
 				    struct rtw8822b_efuse *map)
 {
 	ether_addr_copy(efuse->addr, map->u.mac_addr);
+
 }
 
 static int rtw8822b_read_efuse(struct rtw_dev *rtwdev, u8 *log_map)
@@ -62,6 +69,9 @@ static int rtw8822b_read_efuse(struct rtw_dev *rtwdev, u8 *log_map)
 	case RTW_HCI_TYPE_PCIE:
 		rtw8822be_efuse_parsing(efuse, map);
 		break;
+	case RTW_HCI_TYPE_SDIO:
+		rtw8822bs_efuse_parsing(efuse, map);
+		break;
 	case RTW_HCI_TYPE_USB:
 		rtw8822bu_efuse_parsing(efuse, map);
 		break;
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822b.h b/drivers/net/wireless/realtek/rtw88/rtw8822b.h
index 01d3644e0c94..f84bfb6b0df9 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822b.h
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822b.h
@@ -65,6 +65,11 @@ struct rtw8822be_efuse {
 	u8 res7;
 };
 
+struct rtw8822bs_efuse {
+	u8 res4[0x4a];			/* 0xd0 */
+	u8 mac_addr[ETH_ALEN];		/* 0x11a */
+};
+
 struct rtw8822b_efuse {
 	__le16 rtl_id;
 	u8 res0[0x0e];
@@ -94,6 +99,7 @@ struct rtw8822b_efuse {
 	union {
 		struct rtw8822bu_efuse u;
 		struct rtw8822be_efuse e;
+		struct rtw8822bs_efuse s;
 	};
 };
 
-- 
2.39.0

