Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73B0A69BAB4
	for <lists+netdev@lfdr.de>; Sat, 18 Feb 2023 16:30:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbjBRPah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Feb 2023 10:30:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbjBRPaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Feb 2023 10:30:21 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AEC416AC8;
        Sat, 18 Feb 2023 07:30:20 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id ec30so3549302edb.10;
        Sat, 18 Feb 2023 07:30:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oE7zFa3zY/saVOKDiXgo1nSrjJBFbOP4MGfXZYfHkSM=;
        b=d9hnyTd/NMz+BqGb3NBhRUtX7bo+aN98O/C6/oNOiA7nRJh+lptJyyYH92goCvFMeS
         pLD+9GXJA7F8z3sTcu8cjApn4Hss5jLFyYYyS2RHacGf5YIfaK/lUF5JBMCzGj68i97H
         rHpkFHIYgszhJmVtzNNfluKpB3Gt8SzOUPc6k/CC6Tgyp2KEPgBD/0Z3Rr8G6kEDJSz9
         OG2rsg5zJjd2L13EbTwCj97CdjAt61Nq7eAx4LJ160clohuktFiHslHqXep8FzqFOwQ6
         CldDwHhfdTs6QFqY5CSNd4JbvUKE9+jPtdvw2nQOCHkUdWbEuHZSdvPtVlVKWscU4rln
         m9Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oE7zFa3zY/saVOKDiXgo1nSrjJBFbOP4MGfXZYfHkSM=;
        b=QIknLSaxW3gVfrHzj0QktBa7fJgHDz2NsTwJQY94F0mLIzozCt8Y1xBxSBUxA1bxD4
         zOQoe3Whpyw0aMyeFMgfew829OSQ+tGuFAdNIAYCQQaOnPbWFpYEkaL/yiOpZg/+4c09
         yWqeGKlkwvQbAs5ptQ8V4Xt8otYRzzzPNljHphaJmy5Zo6pVy8Crbbul2OD9bwrqztL4
         NHZD0ClGyZLFa8LLcdjMyzun8jNewSgc97y1w274pjEtJvgKoRO++kdMF0Iz5sfLKaJJ
         6ToMDATDGABm8hioxAF2fQK3jNLfqhul1XlDuNNu+n479eJKVwG0ymAXhbdQUvbMSDx9
         SKdg==
X-Gm-Message-State: AO0yUKWWiHQ7FKJBZc5ylgzNnqLo5u764veKBAL8/+OtT0rb+9+3ppQs
        dTVb+bEhDYTGg9O+yZnbtZ5Stm8dqlA=
X-Google-Smtp-Source: AK7set9NPHs2R627B6yMhW/ilaSeJrppJP4lXzJ4lM++p8kDhMt9ssQkDdFOm0ED6EOTMZspSo0RMA==
X-Received: by 2002:a05:6402:3d8:b0:4ab:b0d5:6bb0 with SMTP id t24-20020a05640203d800b004abb0d56bb0mr4181332edw.18.1676734218668;
        Sat, 18 Feb 2023 07:30:18 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a01-0c23-b8cf-1500-0000-0000-0000-0e63.c23.pool.telefonica.de. [2a01:c23:b8cf:1500::e63])
        by smtp.googlemail.com with ESMTPSA id a65-20020a509ec7000000b004acc5077026sm3742554edf.79.2023.02.18.07.30.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Feb 2023 07:30:18 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-wireless@vger.kernel.org
Cc:     tony0620emma@gmail.com, kvalo@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>, pkshih@realtek.com,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v2 4/5] wifi: rtw88: rtw8822b: Implement RTL8822BS (SDIO) efuse parsing
Date:   Sat, 18 Feb 2023 16:29:43 +0100
Message-Id: <20230218152944.48842-5-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230218152944.48842-1-martin.blumenstingl@googlemail.com>
References: <20230218152944.48842-1-martin.blumenstingl@googlemail.com>
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
changes from v1 -> v2:
- remove extra newline which was added by accident in the USB function
- add the new function/union member/case statement last (after USB)
- while here, also sort the union members to be consistent with
  the switch case (PCIe first, USB second, SDIO last)


 drivers/net/wireless/realtek/rtw88/rtw8822b.c | 9 +++++++++
 drivers/net/wireless/realtek/rtw88/rtw8822b.h | 8 +++++++-
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822b.c b/drivers/net/wireless/realtek/rtw88/rtw8822b.c
index 74dfb89b2c94..531b67787e2e 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822b.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822b.c
@@ -32,6 +32,12 @@ static void rtw8822bu_efuse_parsing(struct rtw_efuse *efuse,
 	ether_addr_copy(efuse->addr, map->u.mac_addr);
 }
 
+static void rtw8822bs_efuse_parsing(struct rtw_efuse *efuse,
+				    struct rtw8822b_efuse *map)
+{
+	ether_addr_copy(efuse->addr, map->s.mac_addr);
+}
+
 static int rtw8822b_read_efuse(struct rtw_dev *rtwdev, u8 *log_map)
 {
 	struct rtw_efuse *efuse = &rtwdev->efuse;
@@ -65,6 +71,9 @@ static int rtw8822b_read_efuse(struct rtw_dev *rtwdev, u8 *log_map)
 	case RTW_HCI_TYPE_USB:
 		rtw8822bu_efuse_parsing(efuse, map);
 		break;
+	case RTW_HCI_TYPE_SDIO:
+		rtw8822bs_efuse_parsing(efuse, map);
+		break;
 	default:
 		/* unsupported now */
 		return -ENOTSUPP;
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822b.h b/drivers/net/wireless/realtek/rtw88/rtw8822b.h
index 01d3644e0c94..2dc3a6660f06 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822b.h
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822b.h
@@ -65,6 +65,11 @@ struct rtw8822be_efuse {
 	u8 res7;
 };
 
+struct rtw8822bs_efuse {
+	u8 res4[0x4a];			/* 0xd0 */
+	u8 mac_addr[ETH_ALEN];		/* 0x11a */
+} __packed;
+
 struct rtw8822b_efuse {
 	__le16 rtl_id;
 	u8 res0[0x0e];
@@ -92,8 +97,9 @@ struct rtw8822b_efuse {
 	u8 country_code[2];
 	u8 res[3];
 	union {
-		struct rtw8822bu_efuse u;
 		struct rtw8822be_efuse e;
+		struct rtw8822bu_efuse u;
+		struct rtw8822bs_efuse s;
 	};
 };
 
-- 
2.39.2

