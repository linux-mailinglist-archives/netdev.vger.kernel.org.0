Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1009C43D861
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 03:05:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbhJ1BHZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 21:07:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbhJ1BHZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 21:07:25 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44CD9C061570;
        Wed, 27 Oct 2021 18:04:59 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id m14so4357670pfc.9;
        Wed, 27 Oct 2021 18:04:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=A7pIyp/mzZcVdirChB9cDdj7yKUeOVUCz0p4mNMMkaY=;
        b=X/lAhn8GZOeQ4m+MrMA1zLpVLDgNZiaGlAM6S5UqJJtoeqiHdEYO0lhhTxRXyuMepx
         rq8g/zpQPifrMxb6pJF5EJ8OZIMuHc0tAjfNmnm/deHWhCV/o0mLZuQHy4ykn7ZanV7P
         31pmz9iGFEhd8s/0JanqyAv6vJVJa4WuZi1wxGHCU+m1Ooiuwg6U+Zm9ByFqy/6j2aZn
         LTKcHqhMaa3ERrQq6q1P9wZIN/9aomcJapWSRoBH2+nflHRBal/LfU6PT3CnUZcMRJIM
         cfeMIzWGHwh7nTGIgOCKp85Nd8T5Q30zHmO6YsbkKh1lQXf+JQAzCzURf4mHCtzLdCPO
         WM+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=A7pIyp/mzZcVdirChB9cDdj7yKUeOVUCz0p4mNMMkaY=;
        b=JIHpcCyuZ0cA4kxjCr67Dzelc5pULJBhChEk9/n1WgeJ1jRF0SPDvmmKn7/qp0ZxYH
         s8wGv43BIqdENYNVpkdKAXBLFaBPx5G36otUi6GtfBUgLffKFqX8NOgtyHPz5AA/yYcu
         aQs/Lk4GSKaC78m9o9srto74xKnn+6CABuAqbGibYzagssBoqVsmTxTbbn2Jr6Df+4LM
         UFcz1GMDZZY94N+vvsxOb2Ow/wjGfdvb3RQF3k1wHTHJHDhhs3otW4o6nimAPK4z8SEZ
         vSTRvh7xetJh7oYThUEsbJfIP1jaZJub67YlCQVQXxLHAJsggsvUZRVfltDtQO56JTpd
         TLRQ==
X-Gm-Message-State: AOAM5330G3KeGxKuHRfeLB20MhnJ6I5KpHKp9e94Fd2FtW/78NuKODXu
        jLcdR/yTV0XnKxOsL1+6uDA=
X-Google-Smtp-Source: ABdhPJxyOK2kyNeD+qfB2IEZulTqjHNqK34GcypMAMXxVhQufY29afKBJfPAneNDNzOdwimEQb2fkw==
X-Received: by 2002:aa7:8a0e:0:b0:47c:1116:3ce with SMTP id m14-20020aa78a0e000000b0047c111603cemr1109275pfa.76.1635383098866;
        Wed, 27 Oct 2021 18:04:58 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id mu11sm6851611pjb.20.2021.10.27.18.04.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Oct 2021 18:04:58 -0700 (PDT)
From:   Yang Guang <cgel.zte@gmail.com>
X-Google-Original-From: Yang Guang <yang.guang5@zte.com.cn>
To:     ath9k-devel@qca.qualcomm.com, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Yang Guang <yang.guang5@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ath9k_hw: use swap() to make code cleaner
Date:   Thu, 28 Oct 2021 01:04:51 +0000
Message-Id: <20211028010451.7754-1-yang.guang5@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Using swap() make it more readable.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Yang Guang <yang.guang5@zte.com.cn>
---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index 7e27a06e5df1..dc24da1ff00b 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -1005,24 +1005,20 @@ static void __ar955x_tx_iq_cal_sort(struct ath_hw *ah,
 				    int i, int nmeasurement)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
-	int im, ix, iy, temp;
+	int im, ix, iy;
 
 	for (im = 0; im < nmeasurement; im++) {
 		for (ix = 0; ix < MAXIQCAL - 1; ix++) {
 			for (iy = ix + 1; iy <= MAXIQCAL - 1; iy++) {
 				if (coeff->mag_coeff[i][im][iy] <
 				    coeff->mag_coeff[i][im][ix]) {
-					temp = coeff->mag_coeff[i][im][ix];
-					coeff->mag_coeff[i][im][ix] =
-						coeff->mag_coeff[i][im][iy];
-					coeff->mag_coeff[i][im][iy] = temp;
+					swap(coeff->mag_coeff[i][im][ix],
+					     coeff->mag_coeff[i][im][iy]);
 				}
 				if (coeff->phs_coeff[i][im][iy] <
 				    coeff->phs_coeff[i][im][ix]) {
-					temp = coeff->phs_coeff[i][im][ix];
-					coeff->phs_coeff[i][im][ix] =
-						coeff->phs_coeff[i][im][iy];
-					coeff->phs_coeff[i][im][iy] = temp;
+					swap(coeff->phs_coeff[i][im][ix],
+					     coeff->phs_coeff[i][im][iy]);
 				}
 			}
 		}
-- 
2.30.2

