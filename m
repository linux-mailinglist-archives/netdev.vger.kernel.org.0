Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74A0E69BAAE
	for <lists+netdev@lfdr.de>; Sat, 18 Feb 2023 16:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbjBRPaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Feb 2023 10:30:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjBRPaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Feb 2023 10:30:20 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 826D216AC6;
        Sat, 18 Feb 2023 07:30:19 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id fd2so3567474edb.2;
        Sat, 18 Feb 2023 07:30:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j+7Oq4TPhe/bGdXGLEkYt4uVs6oTPzxKjeEpllAxDeY=;
        b=GeKzr6+bv66/KA8JqqQjWZleGr8Wsn7bojhQShZQDujWMkrSoG49hBMB8Cc43/I1mR
         fI/ZfboPrD/WdH968xbiCtyTLZIeWEHYcbhOVkYlr0L/7NYWxCSPz6BZTVOSXzU4WKBL
         +qZVx/5Z2HvQI8g6uhH/ch92XmFg2eAxfc+djrr4AMyw76t5OuMblDxAwDleDzYFsCUU
         T9BQ3rcwvkM3uEGq2TEme2HhkMvhN7OEUrWb+YFU+99QUVJ0xRKmzr4G4EO4vxAAfaCm
         d1Xir4Ubutkpzvnum8w6ToVpHdIECQWYcWGwHCcyzC1mPTotIaNNs+uUgy+u+nPdqRWZ
         Mnaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j+7Oq4TPhe/bGdXGLEkYt4uVs6oTPzxKjeEpllAxDeY=;
        b=32fEiSAq7AaWrCMJAOLRYM0UbP5Eg/F5O9tOIkaO5Hy7IlGwpNw7cPeueAibLRtg6X
         cpOMaopcvXJUybYvFbPhEq+LADwaU4afmy3Ef0tUdkc2VkOtVHaahC7e2TCpCZCcGAqs
         4KeNN5L6KeTYSBhWJscKtFD39aKPrKADAya+SQi/QRcj2A0AlknPheHXv5KToYDEJCDo
         Sv7lOjPzUHqqlbgz0RMuihd27JAQ0Jhe1zGNtjVYiJe6EG+kdoxj5Rlc3P/GZMkl+0WS
         9+VYdbCYD/cVWURMVOXj2iYE6ETg5q+Tjhs6Ngv4XCEuhiKeV19YrsaVnBF+0EtlXvXp
         cxiQ==
X-Gm-Message-State: AO0yUKWb9BXh6p/PMfTBKjjwjGVrb23cUM/4MByWUS6ezwM4WKIuqbH7
        DqRPfP9YKVWplaAhRksA3XQ4rDDGHNE=
X-Google-Smtp-Source: AK7set8up7sj90ZjCWw4rMHFUCaxQpyb4KV+9rGyRG766UFC94UPSb3v+bOSHyJEyWl0drcPcByHQQ==
X-Received: by 2002:aa7:cb53:0:b0:4ad:8fc5:3d2a with SMTP id w19-20020aa7cb53000000b004ad8fc53d2amr4914639edt.11.1676734217799;
        Sat, 18 Feb 2023 07:30:17 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a01-0c23-b8cf-1500-0000-0000-0000-0e63.c23.pool.telefonica.de. [2a01:c23:b8cf:1500::e63])
        by smtp.googlemail.com with ESMTPSA id a65-20020a509ec7000000b004acc5077026sm3742554edf.79.2023.02.18.07.30.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Feb 2023 07:30:17 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-wireless@vger.kernel.org
Cc:     tony0620emma@gmail.com, kvalo@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>, pkshih@realtek.com,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v2 3/5] wifi: rtw88: rtw8821c: Implement RTL8821CS (SDIO) efuse parsing
Date:   Sat, 18 Feb 2023 16:29:42 +0100
Message-Id: <20230218152944.48842-4-martin.blumenstingl@googlemail.com>
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

The efuse of the SDIO RTL8821CS chip has only one known member: the mac
address is at offset 0x11a. Add a struct rtw8821cs_efuse describing this
and use it for copying the mac address when the SDIO bus is used.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
changes from v1 -> v2:
- add the new function/union member/case statement last (after USB)


 drivers/net/wireless/realtek/rtw88/rtw8821c.c | 9 +++++++++
 drivers/net/wireless/realtek/rtw88/rtw8821c.h | 6 ++++++
 2 files changed, 15 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/rtw8821c.c b/drivers/net/wireless/realtek/rtw88/rtw8821c.c
index 17f800f6efbd..7ae0541d7b99 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8821c.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8821c.c
@@ -32,6 +32,12 @@ static void rtw8821cu_efuse_parsing(struct rtw_efuse *efuse,
 	ether_addr_copy(efuse->addr, map->u.mac_addr);
 }
 
+static void rtw8821cs_efuse_parsing(struct rtw_efuse *efuse,
+				    struct rtw8821c_efuse *map)
+{
+	ether_addr_copy(efuse->addr, map->s.mac_addr);
+}
+
 enum rtw8821ce_rf_set {
 	SWITCH_TO_BTG,
 	SWITCH_TO_WLG,
@@ -77,6 +83,9 @@ static int rtw8821c_read_efuse(struct rtw_dev *rtwdev, u8 *log_map)
 	case RTW_HCI_TYPE_USB:
 		rtw8821cu_efuse_parsing(efuse, map);
 		break;
+	case RTW_HCI_TYPE_SDIO:
+		rtw8821cs_efuse_parsing(efuse, map);
+		break;
 	default:
 		/* unsupported now */
 		return -ENOTSUPP;
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8821c.h b/drivers/net/wireless/realtek/rtw88/rtw8821c.h
index 1c81260f3a54..fcff31688c45 100644
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
@@ -94,6 +99,7 @@ struct rtw8821c_efuse {
 	union {
 		struct rtw8821ce_efuse e;
 		struct rtw8821cu_efuse u;
+		struct rtw8821cs_efuse s;
 	};
 };
 
-- 
2.39.2

