Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54A20268058
	for <lists+netdev@lfdr.de>; Sun, 13 Sep 2020 18:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725952AbgIMQ4M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Sep 2020 12:56:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725876AbgIMQ4H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Sep 2020 12:56:07 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1383C06174A;
        Sun, 13 Sep 2020 09:56:06 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id u4so16524738ljd.10;
        Sun, 13 Sep 2020 09:56:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=L0eLqlKO93Q0IXg+okhebgrwXe2Z20iX+sKZ/ZoSewk=;
        b=S9bBAsVm9Yg8f6RgCk7L0vCuD1Sotan68S1WXkbszzUcrwT9ALGdPhkB3twNnkKLfr
         g+Lf2n3/bRSMI2Hj0lYCtwYcfA61yqqpLe5CwHjul8xFM8wuYCL0v3pTsCex6XgvRlLD
         DaknPzEn5EKCMbQOxb0sqNyxvACYXaMZK9m7e8VG5/39kfQ20/YPSfFAuptmzBXdAA5J
         4LSEjPrDcC596xD/BJRHFn/yPwoVxOUcW0Ptay59b51tikRBtdfR8csE4zqwC3x+9q+C
         c9c8CX0zHGGRmHfN/Zjjr+OmZ+Jojs4WKf0F+lXnrHDMhOQfD+6P4MIfz7KsH5kCk31p
         tD7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=L0eLqlKO93Q0IXg+okhebgrwXe2Z20iX+sKZ/ZoSewk=;
        b=toQW/eUL091JpZY0BDWGzeC7elOP5f9xiWyI51bCdRrs3YLCIgznXIS4tuuBV206c4
         K0dAZxwjvlZa6aZ+RsVoH36/Cn27D0pxk0hae0W1hfFkRi14jxI++n/yH7klTj/NpWHO
         ba1LCigiO7sUkZgW4Yf5lrHCbDBi1BPe8WSFGScuGjvliaK7hULHJpqq1fdL/6HnuSzS
         skrjF8rPVrtw86p6Bic3Epir//ZzwJSXGtTV1swtyQ1qg6PO+DaREJFB1Mqcq5IAtb+r
         EJut2MYARsR45fEq6kkf6GkrF6bYDKOH9TYMEZM7RnQdP9Kpz8eFnMcsbb5arw93hO5w
         XU8g==
X-Gm-Message-State: AOAM530/m9kTF8zXLY+k0sa6e7XA7mAUUOg8b5f5cpxFkFsZLyMHMz5t
        iI6VnCIoCUd4kIUqAEvUbc6FalJ/4KI=
X-Google-Smtp-Source: ABdhPJz8q9e2x2Z6ZaqegYGVuWB5M0wfkwLWL4Set1izjm4v2if6gZcAhAZFSQL/qsgXuINm0tgJXA==
X-Received: by 2002:a2e:83c9:: with SMTP id s9mr3745106ljh.168.1600016165021;
        Sun, 13 Sep 2020 09:56:05 -0700 (PDT)
Received: from alpha (10.177.smarthome.spb.ru. [109.71.177.10])
        by smtp.gmail.com with ESMTPSA id f2sm2512685lfd.103.2020.09.13.09.56.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Sep 2020 09:56:04 -0700 (PDT)
Received: (nullmailer pid 419792 invoked by uid 1000);
        Sun, 13 Sep 2020 17:00:37 -0000
From:   Ivan Safonov <insafonov@gmail.com>
To:     Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ivan Safonov <insafonov@gmail.com>
Subject: [PATCH] wireless: rtw88: rtw8822c: eliminate code duplication, use native swap() function
Date:   Sun, 13 Sep 2020 19:59:59 +0300
Message-Id: <20200913165958.419744-1-insafonov@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

swap_u32() duplicate native swap(), so replace swap_u32() with swap().

Signed-off-by: Ivan Safonov <insafonov@gmail.com>
---
 drivers/net/wireless/realtek/rtw88/rtw8822c.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822c.c b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
index 426808413baa..e196d7939025 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822c.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
@@ -154,25 +154,16 @@ static void rtw8822c_rf_minmax_cmp(struct rtw_dev *rtwdev, u32 value,
 	}
 }
 
-static void swap_u32(u32 *v1, u32 *v2)
-{
-	u32 tmp;
-
-	tmp = *v1;
-	*v1 = *v2;
-	*v2 = tmp;
-}
-
 static void __rtw8822c_dac_iq_sort(struct rtw_dev *rtwdev, u32 *v1, u32 *v2)
 {
 	if (*v1 >= 0x200 && *v2 >= 0x200) {
 		if (*v1 > *v2)
-			swap_u32(v1, v2);
+			swap(*v1, *v2);
 	} else if (*v1 < 0x200 && *v2 < 0x200) {
 		if (*v1 > *v2)
-			swap_u32(v1, v2);
+			swap(*v1, *v2);
 	} else if (*v1 < 0x200 && *v2 >= 0x200) {
-		swap_u32(v1, v2);
+		swap(*v1, *v2);
 	}
 }
 
-- 
2.26.2

