Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFB8969BAB7
	for <lists+netdev@lfdr.de>; Sat, 18 Feb 2023 16:30:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbjBRPaq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Feb 2023 10:30:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbjBRPaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Feb 2023 10:30:22 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3731F1716B;
        Sat, 18 Feb 2023 07:30:21 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id eq13so3520835edb.11;
        Sat, 18 Feb 2023 07:30:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uCrLcBOXf45KI5NWv36Ke5ebNksAMkuWC8S0/ItarqA=;
        b=mj5XB9XrMP+HH8GYkBWTy0sm6rgNEb+SNqxnOsW+qfMsVUV27WE7/fo3dbNA9xP2k2
         W69tJrGcoGJYCqCOR+Pt8xMDI32JFn/eevCiCB2pGXQzb5QEd1FOHZ1NQYb/q1ITgYOr
         dNr1cc6ChRDEf3OmCvB/lO4E+38ZIOSMqWRidvpEbA+6GUWIVFBkk+uvdpn8sC1h/IeW
         DIV7DvJ/FM3f7JUakQakxt3hKe9sxguR7DeaYLlM2QggMYPc9rdOAQhdvQbBF37Yj5lq
         wyNMZB7fdtKeeg3Ycn9VBCSgGC0QmkcKQuzecjfMRQxCw7lQqLG9wzysHTxEw3Frl3z6
         UuHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uCrLcBOXf45KI5NWv36Ke5ebNksAMkuWC8S0/ItarqA=;
        b=WgQuyHl6uxpBNsU4jfG5MSzc7lcxeLnK7S1fmBNMlGms6DaNDu+qdVJY41hb80JgD6
         gMLfpa5P/VWyGNz5Na/fTpb14o5gvXyzlRF1K+12BIlXPCrz/JR0Tv03S2GtsKqjtmk1
         JdXNwD+/DIJSBdxpABetp4ToV3kDEz9s0m/iIRavXRPiio1lKxR3k7lmHlx0IrHTc2JO
         1BH2A0pm6epa7gqaFAlLt2ft0OKpi51tfHC5kw2IdY6gy6tyEVnE9+o9R4Hcn0guo4Ah
         mVmTvQqVX4vtfCiBMzkRRd8F7/hZAyVSU/2uj8v+qniFstUNlu7GJu5qKxZWH17aV0qM
         zLJA==
X-Gm-Message-State: AO0yUKUCCNrrGS5TnEly3D3uuPbx9NnS/KsJtI6hw276HjBmw8Nb0piq
        PX1CaIhaX6V+AGItAhgl/6myc2qZN4c=
X-Google-Smtp-Source: AK7set+ilpQBfm3cccbDG7nHfOrMlhLgZuuIrXXDNZUtdmZfizhCMdLNbZ2/OsUYSzdltGk+4xDKuA==
X-Received: by 2002:aa7:c0cc:0:b0:4ab:4d55:6f74 with SMTP id j12-20020aa7c0cc000000b004ab4d556f74mr4183444edp.13.1676734219443;
        Sat, 18 Feb 2023 07:30:19 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a01-0c23-b8cf-1500-0000-0000-0000-0e63.c23.pool.telefonica.de. [2a01:c23:b8cf:1500::e63])
        by smtp.googlemail.com with ESMTPSA id a65-20020a509ec7000000b004acc5077026sm3742554edf.79.2023.02.18.07.30.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Feb 2023 07:30:19 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-wireless@vger.kernel.org
Cc:     tony0620emma@gmail.com, kvalo@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>, pkshih@realtek.com,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v2 5/5] wifi: rtw88: rtw8822c: Implement RTL8822CS (SDIO) efuse parsing
Date:   Sat, 18 Feb 2023 16:29:44 +0100
Message-Id: <20230218152944.48842-6-martin.blumenstingl@googlemail.com>
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

The efuse of the SDIO RTL8822CS chip has only one known member: the mac
address is at offset 0x16a. Add a struct rtw8822cs_efuse describing this
and use it for copying the mac address when the SDIO bus is used.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
- add the new function/union member/case statement last (after USB)
- while here, also sort the union members to be consistent with
  the switch case (PCIe first, USB second, SDIO last)


 drivers/net/wireless/realtek/rtw88/rtw8822c.c | 9 +++++++++
 drivers/net/wireless/realtek/rtw88/rtw8822c.h | 8 +++++++-
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822c.c b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
index 964e27887fe2..5a2c004b12df 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822c.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
@@ -35,6 +35,12 @@ static void rtw8822cu_efuse_parsing(struct rtw_efuse *efuse,
 	ether_addr_copy(efuse->addr, map->u.mac_addr);
 }
 
+static void rtw8822cs_efuse_parsing(struct rtw_efuse *efuse,
+				    struct rtw8822c_efuse *map)
+{
+	ether_addr_copy(efuse->addr, map->s.mac_addr);
+}
+
 static int rtw8822c_read_efuse(struct rtw_dev *rtwdev, u8 *log_map)
 {
 	struct rtw_efuse *efuse = &rtwdev->efuse;
@@ -67,6 +73,9 @@ static int rtw8822c_read_efuse(struct rtw_dev *rtwdev, u8 *log_map)
 	case RTW_HCI_TYPE_USB:
 		rtw8822cu_efuse_parsing(efuse, map);
 		break;
+	case RTW_HCI_TYPE_SDIO:
+		rtw8822cs_efuse_parsing(efuse, map);
+		break;
 	default:
 		/* unsupported now */
 		return -ENOTSUPP;
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822c.h b/drivers/net/wireless/realtek/rtw88/rtw8822c.h
index 479d5d769c52..1bc0e7f5d6bb 100644
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
@@ -91,8 +96,9 @@ struct rtw8822c_efuse {
 	u8 res9;
 	u8 res10[0x42];
 	union {
-		struct rtw8822cu_efuse u;
 		struct rtw8822ce_efuse e;
+		struct rtw8822cu_efuse u;
+		struct rtw8822cs_efuse s;
 	};
 };
 
-- 
2.39.2

