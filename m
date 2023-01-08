Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72AE7661A01
	for <lists+netdev@lfdr.de>; Sun,  8 Jan 2023 22:31:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235959AbjAHVbn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Jan 2023 16:31:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233656AbjAHVbm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Jan 2023 16:31:42 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01591BD2;
        Sun,  8 Jan 2023 13:31:40 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id fc4so15651078ejc.12;
        Sun, 08 Jan 2023 13:31:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=17ds/3tpasRi8RnIAMFZ0yeGk76Sd506Y/IMKaXpmhI=;
        b=fQ08vR5Swm6oSOCLOepmQLeSEcM4HXPkM7i1E/SnU/Oh/Ap1w6TYU7KvaPfyRvu4MG
         JXbLfK9f55kI0VK3ldz/m2ewNoRtT1WzW0LhwEQQYHexjdElXJbz6LzV7UcrYAmp13mF
         Ya0Dsh7swoEu8rfj1Xd6fsCqcKHhcR/IG8CV37ovoC2aHXt+Y7OjiDJCR0ApkT4zxfb4
         NvQgUXoM247JaYlFJJSj7Z6MgNAkIQ1feNa/dp2s3S/uUChUG7OtBdloCSHdZW4NhBNt
         1QsebvIYlCP9VWrfgfHcBHRk4R8FzrpOo8tmJfPtiTT2CMmRMcZXt+W6cariwJ6chHfb
         Eb1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=17ds/3tpasRi8RnIAMFZ0yeGk76Sd506Y/IMKaXpmhI=;
        b=snzXGUlvSDH/fBv08ubchH40sevbP6Dimj/F617WJzS2Po+EpxY6PqgcvUKz1rMJLn
         uWuvwJ5LAxVqAU7zdlyZYB+5YdzAwZkKZLquw1JJKl0N+wwdvoS1UUEnQ/aMLjEheDLa
         LAKP3TSXRg45LJn0sDg8zDTVjeK1eRadw2BLKWsr5byhbtLP6YXU9CvU3wgNGtJZi9NG
         1ZLqaUtNxjvZpNqCy5yJ2SQyhUCFu/UQUKWrNE+GNw/LlmxbheESQxFOjLRHz4bJTq5T
         aENbEwVNUdRzK0xTjCl/z5NrKW5osTUP1Mq6YZWX70cUCwjkyY4tUBhj0Bvx2tl+IKaY
         lDNQ==
X-Gm-Message-State: AFqh2kqF7C94zIZ689GAaDR7G8BKJo44+bvya8RqGKuZgwjoLVCcVqoM
        RPPOZhfpeGaRsrWkaVNmaszVT8Uxdig=
X-Google-Smtp-Source: AMrXdXuGDVxgSs0RwHD3OZpABzUzxKRzA+9vom+UpU0rCOYShpgl88byR1MlijIHPPt1okJ7Zfk8jw==
X-Received: by 2002:a17:907:c48d:b0:7c0:fe60:be12 with SMTP id tp13-20020a170907c48d00b007c0fe60be12mr49425430ejc.25.1673213498311;
        Sun, 08 Jan 2023 13:31:38 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a01-0c23-c485-2500-0000-0000-0000-0e63.c23.pool.telefonica.de. [2a01:c23:c485:2500::e63])
        by smtp.googlemail.com with ESMTPSA id f1-20020a17090631c100b007aea1dc1840sm2917620ejf.111.2023.01.08.13.31.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Jan 2023 13:31:37 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-wireless@vger.kernel.org
Cc:     tony0620emma@gmail.com, kvalo@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        David Laight <David.Laight@aculab.com>
Subject: [PATCH v1 RFC] wifi: rtw88: Validate the eFuse structs
Date:   Sun,  8 Jan 2023 22:31:14 +0100
Message-Id: <20230108213114.547135-1-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.39.0
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

Add static assertions for the PCIe/USB offsets inside the eFuse structs
to ensure that the compiler doesn't add padding anywhere (relevant)
inside the structs.

Suggested-by: Ping-Ke Shih <pkshih@realtek.com>
Suggested-by: David Laight <David.Laight@aculab.com>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
This is the continuation of my patch from [0] where initially I added
__packed attributes to the eFuse structs. David raised concerns that
this is the "sledgehammer" way of doing things and it can impact
performance.

So this implementation is my understanding of David's suggestion from
[1] (and Ping-Ke also suggested a similar approach for debugging a
size difference I've been seeing with / without __packed).


[0] https://lore.kernel.org/linux-wireless/20221228133547.633797-2-martin.blumenstingl@googlemail.com/
[1] https://lore.kernel.org/linux-wireless/4c4551c787ee4fc9ac40b34707d7365a@AcuMS.aculab.com/


 drivers/net/wireless/realtek/rtw88/rtw8723d.h | 5 +++++
 drivers/net/wireless/realtek/rtw88/rtw8821c.h | 5 +++++
 drivers/net/wireless/realtek/rtw88/rtw8822b.h | 5 +++++
 drivers/net/wireless/realtek/rtw88/rtw8822c.h | 5 +++++
 4 files changed, 20 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/rtw8723d.h b/drivers/net/wireless/realtek/rtw88/rtw8723d.h
index a356318a5c15..b1747a22135c 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8723d.h
+++ b/drivers/net/wireless/realtek/rtw88/rtw8723d.h
@@ -83,6 +83,11 @@ struct rtw8723d_efuse {
 	};
 };
 
+static_assert(offsetof(struct rtw8723d_efuse, e) == 0xd0);
+static_assert(sizeof(struct rtw8723de_efuse) == 14);
+static_assert(offsetof(struct rtw8723d_efuse, u) == 0xd0);
+static_assert(sizeof(struct rtw8723du_efuse) == 59);
+
 extern const struct rtw_chip_info rtw8723d_hw_spec;
 
 /* phy status page0 */
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8821c.h b/drivers/net/wireless/realtek/rtw88/rtw8821c.h
index 1c81260f3a54..70fdc7bf2b64 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8821c.h
+++ b/drivers/net/wireless/realtek/rtw88/rtw8821c.h
@@ -97,6 +97,11 @@ struct rtw8821c_efuse {
 	};
 };
 
+static_assert(offsetof(struct rtw8821c_efuse, e) == 0xd0);
+static_assert(sizeof(struct rtw8821ce_efuse) == 49);
+static_assert(offsetof(struct rtw8821c_efuse, u) == 0xd0);
+static_assert(sizeof(struct rtw8821cu_efuse) == 304);
+
 static inline void
 _rtw_write32s_mask(struct rtw_dev *rtwdev, u32 addr, u32 mask, u32 data)
 {
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822b.h b/drivers/net/wireless/realtek/rtw88/rtw8822b.h
index 01d3644e0c94..5d24ce7a8943 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822b.h
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822b.h
@@ -97,6 +97,11 @@ struct rtw8822b_efuse {
 	};
 };
 
+static_assert(offsetof(struct rtw8822b_efuse, e) == 0xd0);
+static_assert(sizeof(struct rtw8822be_efuse) == 49);
+static_assert(offsetof(struct rtw8822b_efuse, u) == 0xd0);
+static_assert(sizeof(struct rtw8822bu_efuse) == 304);
+
 static inline void
 _rtw_write32s_mask(struct rtw_dev *rtwdev, u32 addr, u32 mask, u32 data)
 {
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822c.h b/drivers/net/wireless/realtek/rtw88/rtw8822c.h
index 479d5d769c52..4c5402008387 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822c.h
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822c.h
@@ -96,6 +96,11 @@ struct rtw8822c_efuse {
 	};
 };
 
+static_assert(offsetof(struct rtw8822c_efuse, e) == 0x120);
+static_assert(sizeof(struct rtw8822ce_efuse) == 47);
+static_assert(offsetof(struct rtw8822c_efuse, u) == 0x120);
+static_assert(sizeof(struct rtw8822cu_efuse) == 122);
+
 enum rtw8822c_dpk_agc_phase {
 	RTW_DPK_GAIN_CHECK,
 	RTW_DPK_GAIN_LARGE,
-- 
2.39.0

