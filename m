Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 172D911C12
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 17:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726400AbfEBPBZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 11:01:25 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:44835 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbfEBPBY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 May 2019 11:01:24 -0400
Received: by mail-ed1-f65.google.com with SMTP id b8so2381507edm.11;
        Thu, 02 May 2019 08:01:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=F4ystsakZfQavkq/1h2e8hRLzNto9oFi+KNjdeCmL64=;
        b=PCC0xq5ufyxEAa9KaVRkdQWnkVxx/kVb6SxM6C8v1f4VnXfLkIJvpS+U8VKy7KHfv5
         ji63O9XTc/P1fkA8UGQ330CURPKWxcV1UVg9cv8zY8+GClAWeyIjub9tSSWmOR/z/4If
         f11F4PM8T0FwHh1dR/WpPAPuAdDXLYbnydg1KcSjm1BoVE8FWkYcYTScPn7evoyZS4qd
         X7FwrsTSjb4YggILF3p+ZDTiNTWxmwEc/Yv94ChVdcKnlSrNBO8iKa6cPCz9XUsxy1AC
         Sn16cqVh3Dm42xBXsNjH8oCZZeEbKlKgA1uFCWCrVLsPOTqyRJhhTLtXk1Tvh8QNMDOC
         SQLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=F4ystsakZfQavkq/1h2e8hRLzNto9oFi+KNjdeCmL64=;
        b=tOBD9qX+zoAN59OQ6N6JIvTyXYrF99CWhr4nNj85A+zzcoluY3SZICZCUJLHB0ITcu
         eBVlr1dNgDRk9DSyYs/BqVysCr87yD/Wo2f9S6skDtUfJ5TGw3zrwZHOxiJHrf6XrlAD
         jgtuis2w5WpXJCo22kvCOncxmD/kOdTK3FxSMeCMvkXDFIKJk4WpwvS5myPRIXkQ0V31
         D1SICqf1IpA3awkABULwgR7R5zHjMs9cy1F3wDG1681+HYhsm5jqUS1xFgOjs/7X3f/Q
         ADhaNR6qeB+ZwkNnyqhWsY3k1VXoD2L5aeKArnIAqquZKHpyWPYic4XnVBoLopoeW90f
         BBTQ==
X-Gm-Message-State: APjAAAVfM8QazsorjNjkS+zqORqx6X9ow4OTa++kHeMBlIR6+7HGEVHm
        YQseG5p+98BeSHZF/Va/DA8=
X-Google-Smtp-Source: APXvYqx885g/yRDrtzqXx6mkE80l3zSptxcZjU6uKFdcZqN3zMHnJiaGnbk139arXon5BQo2eX0tgw==
X-Received: by 2002:aa7:c403:: with SMTP id j3mr2903456edq.144.1556809282579;
        Thu, 02 May 2019 08:01:22 -0700 (PDT)
Received: from localhost.localdomain ([2a01:4f9:2b:2b84::2])
        by smtp.gmail.com with ESMTPSA id f8sm3579312edd.15.2019.05.02.08.01.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 May 2019 08:01:21 -0700 (PDT)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH] rtw88: Made RA_MASK macros ULL
Date:   Thu,  2 May 2019 08:00:22 -0700
Message-Id: <20190502150022.4182-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.21.0
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

