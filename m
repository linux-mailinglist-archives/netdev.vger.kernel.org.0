Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C756444ECF
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 07:23:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbhKDG0H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 02:26:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbhKDG0G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 02:26:06 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78DD0C061714;
        Wed,  3 Nov 2021 23:23:29 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id m14so4847786pfc.9;
        Wed, 03 Nov 2021 23:23:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HUMW1cGjIPuXunjJMEEPF7szJpJIYVokEK7muhPqkK8=;
        b=dJjSSj4N8N1IXBF7t3zw0xHOd4LTebseW1fVICt0SxQvtZlg9uV0FvpDfTFZJKezQT
         maWPfNe+3Wto8OwYj3t4rkHnGtn7Lm+Cx3VMPcejSVPzFnswdAO9G3vIJL1qhk1Xg8Mz
         FIFJhn5pRgi0UD7wzNjLyJAgGI76zsYVz/0MKQDdArpurWbF2/1cCitrdr2Gxiaq7oWH
         5d2TwNO1HrGraNFpu66hBAfEhPNlgfWkw+KlUxLXMkBtdpbiCBx5gJ+o6F5V8DhllVif
         HvDALYMqdI26QdGfNIBbNhURxFfbb8gG51Vd8zg63YOusAtH740ozLuxFaK7FHykzfr3
         XVyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HUMW1cGjIPuXunjJMEEPF7szJpJIYVokEK7muhPqkK8=;
        b=Pyh33ipY4Fg6b8nmTgarTP0HYfZB5ookckMb8AkiXo17y4oKnY5SJsgSnAas2hEeDC
         3p+UKHAAMb6TcLMRNUHuot9Ghu8FtEICEY4FXOboECn+5z1O7ZsAhuze3F0n/IhAImtc
         w9mwQ/VlGTayvrAjOnLbIB/MUk+k0lGeDDAlSoZdBj+egZR7UWhVnTQA0t2F676GwSLT
         +GfXt19uYCl0W+gQ5t1oYTP/Zkq1bO0K7KyilR9JUsoVZukHlYatOP+iX2Yd3Ul9rHiH
         oPIxWUsH9XWG4DLHJbbnYgaHYZEqhjpSOUGpohd66K4+5y8DCbf/rY4amEm/B1CdLEc9
         W4pg==
X-Gm-Message-State: AOAM531Wae/k/wERpjiJblOl5A0hH9UtoJm6Z1AUPGJCwYyYKN8bIUMh
        ZaogGnzuI8naNe3ix2mbn/k=
X-Google-Smtp-Source: ABdhPJxDuRDqVcZGjmz8eHCE5U/kluVprOkKNubfN2s2ncZbYIA697E5Iiqp+pTIMFF1858E23eR7Q==
X-Received: by 2002:a63:cd47:: with SMTP id a7mr11895862pgj.1.1636007009146;
        Wed, 03 Nov 2021 23:23:29 -0700 (PDT)
Received: from debian11-dev-61.localdomain (192.243.120.180.16clouds.com. [192.243.120.180])
        by smtp.gmail.com with ESMTPSA id t38sm4403236pfg.61.2021.11.03.23.23.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 23:23:28 -0700 (PDT)
From:   davidcomponentone@gmail.com
X-Google-Original-From: yang.guang5@zte.com.cn
To:     jirislaby@kernel.org
Cc:     davidcomponentone@gmail.com, mickflemm@gmail.com,
        mcgrof@kernel.org, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Guang <yang.guang5@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] ath5k: use swap() to make code cleaner
Date:   Thu,  4 Nov 2021 14:23:17 +0800
Message-Id: <20211104062317.1506183-1-yang.guang5@zte.com.cn>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yang Guang <yang.guang5@zte.com.cn>

Use the macro 'swap()' defined in 'include/linux/minmax.h' to avoid
opencoding it.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Yang Guang <yang.guang5@zte.com.cn>
---
 drivers/net/wireless/ath/ath5k/phy.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index 00f9e347d414..08dc12611f8d 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -1562,16 +1562,13 @@ static s16
 ath5k_hw_get_median_noise_floor(struct ath5k_hw *ah)
 {
 	s16 sort[ATH5K_NF_CAL_HIST_MAX];
-	s16 tmp;
 	int i, j;
 
 	memcpy(sort, ah->ah_nfcal_hist.nfval, sizeof(sort));
 	for (i = 0; i < ATH5K_NF_CAL_HIST_MAX - 1; i++) {
 		for (j = 1; j < ATH5K_NF_CAL_HIST_MAX - i; j++) {
 			if (sort[j] > sort[j - 1]) {
-				tmp = sort[j];
-				sort[j] = sort[j - 1];
-				sort[j - 1] = tmp;
+				swap(sort[j], sort[j - 1]);
 			}
 		}
 	}
-- 
2.30.2

