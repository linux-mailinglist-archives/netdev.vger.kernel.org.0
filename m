Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8CE696F0F
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 22:15:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232482AbjBNVPR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 16:15:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232454AbjBNVPF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 16:15:05 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 520982FCDC;
        Tue, 14 Feb 2023 13:14:31 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id dr8so43232610ejc.12;
        Tue, 14 Feb 2023 13:14:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UuYUbOJgJkM7vBMQK3GiYLrn1dU8B5/xrGPzHJMu+oA=;
        b=jaZrEvoRIqb0h2WzR0sEksdJP7o9kOi4cg2gJGcipkxaKFRqaOTQcyC7KzpGWdS7Q6
         OhpIv1hPnBNnAQHJrT+2T/Bqymi1eivUpatpJd3raIXlFxNtc1SJDC2LNVXUB4a9ocz3
         nEBSR27X97GL8voLvI3qN9bhBg0egEyW/VwhLS7MCX+/ALoVr/OlKgc3cjjU9gF5iyrY
         gUZaTUDT65OrbSlBJEPoArLjUYFBv//Ab+0HYoTvQzdyto8j+TCf1rCYt08PQKGRQlUx
         L/1zwT28Prer80SWUG3mTAoOU5o+i+8gJ/jCfm4OebtnfeO9+TNCTyO2wOdfdH9CExgb
         7DUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UuYUbOJgJkM7vBMQK3GiYLrn1dU8B5/xrGPzHJMu+oA=;
        b=oTk9OPmiH6vJhFhyXzQCcgPDSAnRYWv2Xpz9iNX1ThnaTMlXqYKX8zYNUt2YRV3pQV
         zp5pUvnylXvYF9OYgdHkzGluaZMWdKF/sgiBIfnB2YkhVPVhIjocG62BPiNOnfdJwZCE
         S7PnzoHlrK7PrdfvZURcwmPakwWod2nkfGR3jFS951d+voZR04eNVHgME6wi4Dt5Op2i
         uL70+/m01BiEEFgPAh1fuqmFD5KVvQ/uj4ACh/gke6aHREGN+frqZ0bkNxZQLVhEdjci
         3Htly4OZFFH1RslozrCP/k9aazZ7ndxQavFDtVHqXickVWsuXTeq7RUEAAnJlkfFraYN
         OPYw==
X-Gm-Message-State: AO0yUKX9VXaXqTVjq5PQzCco+omeEC+u3ibRb+Biv9SZuFrZ6kY3aCWp
        BOwRvGPQguSahgbO27HyDUh8jOxor20=
X-Google-Smtp-Source: AK7set9Dl4jc93KPxEW+qkA3MsH55VgtB8c1cj91O/Ez7wYdbtS7uzCFfJErASL/6X60FHiDpNS2sA==
X-Received: by 2002:a17:906:6686:b0:878:7f6e:38a7 with SMTP id z6-20020a170906668600b008787f6e38a7mr4418573ejo.44.1676409266655;
        Tue, 14 Feb 2023 13:14:26 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a01-0c22-768e-b000-0000-0000-0000-0e63.c22.pool.telefonica.de. [2a01:c22:768e:b000::e63])
        by smtp.googlemail.com with ESMTPSA id uz2-20020a170907118200b008b134555e9fsm949806ejb.42.2023.02.14.13.14.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 13:14:26 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-wireless@vger.kernel.org
Cc:     tony0620emma@gmail.com, kvalo@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>, pkshih@realtek.com,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v1 3/5] wifi: rtw88: rtw8821c: Implement RTL8821CS (SDIO) efuse parsing
Date:   Tue, 14 Feb 2023 22:14:19 +0100
Message-Id: <20230214211421.2290102-4-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230214211421.2290102-1-martin.blumenstingl@googlemail.com>
References: <20230214211421.2290102-1-martin.blumenstingl@googlemail.com>
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
index 1c81260f3a54..1cc77a42be6f 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8821c.h
+++ b/drivers/net/wireless/realtek/rtw88/rtw8821c.h
@@ -65,6 +65,11 @@ struct rtw8821ce_efuse {
 	u8 res7;
 };
 
+struct rtw8821cs_efuse {
+	u8 res4[0x4a];			/* 0xd0 */
+	u8 mac_addr[ETH_ALEN];		/* 0x11a */
+} __packed;
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
2.39.1

