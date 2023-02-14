Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55BAC696F09
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 22:15:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232597AbjBNVPJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 16:15:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232511AbjBNVPH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 16:15:07 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D56D2CFE6;
        Tue, 14 Feb 2023 13:14:34 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id dr8so43232683ejc.12;
        Tue, 14 Feb 2023 13:14:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LDCMFuAMkFIViBtxIzrrBhJMMUrvQzY9dO0YrEL2Ffw=;
        b=W4W7JIpC+UtJd9OTDkmJtkFAuqYRj1JTrusimew4lUsens7aEQ2AVWS9CqaBjbfMr/
         tv3vcq4xJNdsPOJwMavK7f52O21UVfHeLuOguA1PDENkVxLZCDM4Ti/asgvt0cOwr6f+
         jb5Bgc1ArdZ7hiOvrR+LzcrPSoSm5VFxWF+4+HLt8ZkHdlQn0+CpbP1MGdMHiFlg9tY/
         zwpkdtQBhYLKoQoDlY2+JAgzxPltDA1y0ogNWrZbbxkvCq3MaVmJS6ucUZLWYpV8iV9N
         TQQFfOq5r+KqDxXtZL7a8e3SkVI0cw61kfSEbBAWEHq19GL0M+LlLH/BXJZGlFHdo2x5
         Io0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LDCMFuAMkFIViBtxIzrrBhJMMUrvQzY9dO0YrEL2Ffw=;
        b=pYHmyGxgn29vA6r0RoSyDRN7rBSGxb/nS7Z/Za/sPewgd1ypdZWEyZ9LcUY7WToktI
         yreRrLXQG6Y241i5heanKnTKyfz0zv7vPOftCkzmeH5JuAUpsQadTQTjbs8Tj6G/KcY5
         Jua0Fk+pEjNZFdSQOYSkyaUE32fySl9cUVhB0/V5r7z/fhr1fpW/XoOAQFb/sxsBcqzL
         LKhcemK1WgtEA6yzbGE2pQGPB2Sg7bEPsEgfNCO5zppyKQ1wlBJPCDIxpNJr6+632p2K
         tojHHOa6++8w2F0PBeJMXDdcyCdMdTK70OCAMZ7MxfX/RbZFB0lzVkpaQQS7Me/ujR/a
         GmAw==
X-Gm-Message-State: AO0yUKXa885OBFJ+WJ2bpKRHGmwUkTNY/OR/H4KMzfpkrQ0HHMH+qnQt
        Vm3Lc+LBWlDNOQNfcaJQKaiFjT+Qc7w=
X-Google-Smtp-Source: AK7set8eFKMyYEHXAsV4oZNDpxb9+asF+mFop6BN6YNOeeQIktz52QKrlcTOH1lwZ4JQYE42A5lynQ==
X-Received: by 2002:a17:906:c40d:b0:8af:2a97:91d4 with SMTP id u13-20020a170906c40d00b008af2a9791d4mr4550092ejz.14.1676409267638;
        Tue, 14 Feb 2023 13:14:27 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a01-0c22-768e-b000-0000-0000-0000-0e63.c22.pool.telefonica.de. [2a01:c22:768e:b000::e63])
        by smtp.googlemail.com with ESMTPSA id uz2-20020a170907118200b008b134555e9fsm949806ejb.42.2023.02.14.13.14.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 13:14:27 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-wireless@vger.kernel.org
Cc:     tony0620emma@gmail.com, kvalo@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>, pkshih@realtek.com,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v1 4/5] wifi: rtw88: rtw8822b: Implement RTL8822BS (SDIO) efuse parsing
Date:   Tue, 14 Feb 2023 22:14:20 +0100
Message-Id: <20230214211421.2290102-5-martin.blumenstingl@googlemail.com>
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
index 01d3644e0c94..8d05805c046c 100644
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
@@ -94,6 +99,7 @@ struct rtw8822b_efuse {
 	union {
 		struct rtw8822bu_efuse u;
 		struct rtw8822be_efuse e;
+		struct rtw8822bs_efuse s;
 	};
 };
 
-- 
2.39.1

