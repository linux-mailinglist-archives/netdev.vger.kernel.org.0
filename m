Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC4211C1A
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 17:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbfEBPDG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 11:03:06 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:39767 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726197AbfEBPDG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 May 2019 11:03:06 -0400
Received: by mail-ed1-f67.google.com with SMTP id e24so2408350edq.6;
        Thu, 02 May 2019 08:03:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TkF9Hp+nVZ6H1AjfuCnC+ng5EY02GRsXnvKx+KkYxQo=;
        b=Tq72OJ96OAc0q+hwdQt8AwjfNnkRAgsgXXrdf7XLuvTqDUQnWdQnS6+Kc1t9wv3dr7
         hBgTWwYVionGn1ZW/yOB7YYHJ2Ba+r2iz80JKNN0RVEJe2tfec7SQbcEnxqRaxs+K1dB
         cRugASuy2Lno6f/v/MhiheP8Sr7N/QMCll+3ZU02eUuJ5+4phLY2Kqo7ASque9H6FS8U
         3CbV25rE2+LhqRzm9FlMgWKSrnZlXTSoL91AbJ/yCF3m1/mM7xwU2xhrM50lEmmyvHiZ
         gEaMrPgIhzc9I7M7dyBQlz1ZEc641at3uRRo8+CjVYcLpjoDtLthxZIs11shbSjauNab
         Wa3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TkF9Hp+nVZ6H1AjfuCnC+ng5EY02GRsXnvKx+KkYxQo=;
        b=iS1lm8/ExioGps4mgiQDVJNS5nkwrI5snasC1OuPL0Ukw6kfKgBGM3B6DE1IYQ3z7X
         cYRV0D3Cc14C3XPq6M9kA3d1EAgGzM90qNRdZOjCYlOQKcLu22Kdl81xEJOEXMFjZ88m
         WrEmkVtv5k3rAOYxqOZ8ZIKIyx8vQriE6+a9nQew9mBSHSdJvTkqOaAd/bnJNn9YhIn1
         ZU/WgEWTVM/cebzZ4uxEADsrB9ZyfRmxEf2W5PlIasd/P5mi44q/M9D0JCcAxKu+JpyI
         guwa6NLLZHBWm+/FTvJ0kJI0cHG+9iP5Nj/HRdHBw7LwvZxmIuX7pGRCQOxsnc3hPrA5
         T5FA==
X-Gm-Message-State: APjAAAX8mDADEJqaydvYr7ZMC8c0pdeZ1oB1yVlMbMC4Bj+IG0CO7Qdd
        eEFpSG7oiDEYClC2BBXxG24=
X-Google-Smtp-Source: APXvYqxPK1tA48H7Ar4Sg5qBAablpNrcjB1TDiCPvPJRN12IfZH8s20HOQiU/dIQMS5rHkK6azQNRA==
X-Received: by 2002:a17:906:9519:: with SMTP id u25mr2110038ejx.34.1556809383965;
        Thu, 02 May 2019 08:03:03 -0700 (PDT)
Received: from localhost.localdomain ([2a01:4f9:2b:2b84::2])
        by smtp.gmail.com with ESMTPSA id d59sm7450726edc.34.2019.05.02.08.03.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 May 2019 08:03:02 -0700 (PDT)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH v2] rtw88: Make RA_MASK macros ULL
Date:   Thu,  2 May 2019 08:02:10 -0700
Message-Id: <20190502150209.4475-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502150022.4182-1-natechancellor@gmail.com>
References: <20190502150022.4182-1-natechancellor@gmail.com>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clang warns about the definitions of these macros (full warnings trimmed
for brevity):

drivers/net/wireless/realtek/rtw88/main.c:524:15: warning: signed shift
result (0x3FF00000000) requires 43 bits to represent, but 'int' only has
32 bits [-Wshift-overflow]
                        ra_mask &= RA_MASK_VHT_RATES | RA_MASK_OFDM_IN_VHT;
                                   ^~~~~~~~~~~~~~~~~
drivers/net/wireless/realtek/rtw88/main.c:527:15: warning: signed shift
result (0xFF0000000) requires 37 bits to represent, but 'int' only has
32 bits [-Wshift-overflow]
                        ra_mask &= RA_MASK_HT_RATES | RA_MASK_OFDM_IN_HT_5G;
                                   ^~~~~~~~~~~~~~~~

Given that these are all used with ra_mask, which is of type u64, we can
just declare the macros to be ULL as well.

Fixes: e3037485c68e ("rtw88: new Realtek 802.11ac driver")
Link: https://github.com/ClangBuiltLinux/linux/issues/467
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---

v1 -> v2:

* Fix commit message wording (made -> make)...

 drivers/net/wireless/realtek/rtw88/main.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index 9893e5e297e3..a14a5f1b4b6d 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -462,15 +462,15 @@ static u8 get_rate_id(u8 wireless_set, enum rtw_bandwidth bw_mode, u8 tx_num)
 
 #define RA_MASK_CCK_RATES	0x0000f
 #define RA_MASK_OFDM_RATES	0x00ff0
-#define RA_MASK_HT_RATES_1SS	(0xff000 << 0)
-#define RA_MASK_HT_RATES_2SS	(0xff000 << 8)
-#define RA_MASK_HT_RATES_3SS	(0xff000 << 16)
+#define RA_MASK_HT_RATES_1SS	(0xff000ULL << 0)
+#define RA_MASK_HT_RATES_2SS	(0xff000ULL << 8)
+#define RA_MASK_HT_RATES_3SS	(0xff000ULL << 16)
 #define RA_MASK_HT_RATES	(RA_MASK_HT_RATES_1SS | \
 				 RA_MASK_HT_RATES_2SS | \
 				 RA_MASK_HT_RATES_3SS)
-#define RA_MASK_VHT_RATES_1SS	(0x3ff000 << 0)
-#define RA_MASK_VHT_RATES_2SS	(0x3ff000 << 10)
-#define RA_MASK_VHT_RATES_3SS	(0x3ff000 << 20)
+#define RA_MASK_VHT_RATES_1SS	(0x3ff000ULL << 0)
+#define RA_MASK_VHT_RATES_2SS	(0x3ff000ULL << 10)
+#define RA_MASK_VHT_RATES_3SS	(0x3ff000ULL << 20)
 #define RA_MASK_VHT_RATES	(RA_MASK_VHT_RATES_1SS | \
 				 RA_MASK_VHT_RATES_2SS | \
 				 RA_MASK_VHT_RATES_3SS)
-- 
2.21.0

