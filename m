Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2CDF696F0A
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 22:15:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232613AbjBNVPL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 16:15:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232515AbjBNVPH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 16:15:07 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACF002DE41;
        Tue, 14 Feb 2023 13:14:34 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id qw12so43366020ejc.2;
        Tue, 14 Feb 2023 13:14:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/koSKoAghWBYGzOWWdzRawqtviMRFfn1Iz3iCEopgFg=;
        b=MTdHin4tmQuKcn/5Ie1YL09iyP0P3oTPaVj9j3tlYbpLmuEbQA6WMfwdXaXERjrVF9
         0UTK0X6WkqxujwgtpVlBKUOhlpWFX4+3vU6zstyyCfsyvehF2eabuyESSP+rMrkSeIB9
         nySEpWVeYegEoyMKby0dERGzhUh6KT2TM2S+ZlnuzqzWELcSU2qC9oCb7ne6GW0T93vJ
         dyFKaL9WnwXwoAdd666XGtlvKqVupFca77xkX/xu+OHNK7dQY1a5EDWt/wGDV5VHkZYC
         YKf0WAzKOICv5iMYE6ayqMDYy6h02Rdo+c1+16Z2j3sfzQUzNaeDtOxneHVhklxt/Y1D
         in/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/koSKoAghWBYGzOWWdzRawqtviMRFfn1Iz3iCEopgFg=;
        b=VoOcvRhoeUrvhU4rN87Ifbeq7/nUaBaHiDPsYR+L7S8wT3dIFIU2FfpTpMkVQnXoIp
         veTHaI2bPdQdpwZUa+f61XqF5ePmxlBSFGxKkg0aOBM2pu1kNUY/K7J8us0y975e8NB0
         HnGc+Xm6KN37hVL9wKWENeGSKYf4ojxYBKecycQbz677PLQQHxhAEaQlv3m5LSVbpeQ6
         OscqzkveJ454lRTMkiKABmufEtEhT2ru+iJt5Q7zGNU+bCEMrsEvvUT9i3dVIu3EW2Dc
         oThI6K2yeOouQiq5SXbv8xruJBb9IjuljxgV/mSmlgT0jIShxLr1s+0zPFiq6toqb2NY
         v+fg==
X-Gm-Message-State: AO0yUKW1Np6v/XrE58F3o0AoJkYbUzuK6MI57J3JQBCxDgEltEKUTO4u
        fpsFUWh2tVJGSlI7meAxhu5fePy1JZ4=
X-Google-Smtp-Source: AK7set9oqf7C8LWNURRSUPI57zSsvzDD+KClf8nfmUmxnjrEStJGjsjiJmMcKqgb/pTCU6NqjvcmjA==
X-Received: by 2002:a17:906:8396:b0:8b1:3002:bd6d with SMTP id p22-20020a170906839600b008b13002bd6dmr3198216ejx.31.1676409268487;
        Tue, 14 Feb 2023 13:14:28 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a01-0c22-768e-b000-0000-0000-0000-0e63.c22.pool.telefonica.de. [2a01:c22:768e:b000::e63])
        by smtp.googlemail.com with ESMTPSA id uz2-20020a170907118200b008b134555e9fsm949806ejb.42.2023.02.14.13.14.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 13:14:28 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-wireless@vger.kernel.org
Cc:     tony0620emma@gmail.com, kvalo@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>, pkshih@realtek.com,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v1 5/5] wifi: rtw88: rtw8822c: Implement RTL8822CS (SDIO) efuse parsing
Date:   Tue, 14 Feb 2023 22:14:21 +0100
Message-Id: <20230214211421.2290102-6-martin.blumenstingl@googlemail.com>
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
index 479d5d769c52..959d6537b2fe 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822c.h
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822c.h
@@ -16,6 +16,11 @@ struct rtw8822cu_efuse {
 	u8 res2[0x3d];
 };
 
+struct rtw8822cs_efuse {
+	u8 res0[0x4a];			/* 0x120 */
+	u8 mac_addr[ETH_ALEN];		/* 0x16a */
+} __packed;
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
2.39.1

