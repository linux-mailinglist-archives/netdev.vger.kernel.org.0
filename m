Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29679E4A00
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 13:32:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440121AbfJYLbI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 07:31:08 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42810 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727602AbfJYLbI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 07:31:08 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1iNxo1-0004N2-3o; Fri, 25 Oct 2019 11:30:57 +0000
From:   Colin King <colin.king@canonical.com>
To:     Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Chris Chiu <chiu@endlessm.com>,
        Tzu-En Huang <tehuang@realtek.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] rtw88: remove redundant null pointer check on arrays
Date:   Fri, 25 Oct 2019 12:30:56 +0100
Message-Id: <20191025113056.19167-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The checks to see if swing_table->n or swing_table->p are null are
redundant since n and p are arrays and can never be null if
swing_table is non-null.  I believe these are redundant checks
and can be safely removed, especially the checks implies that these
are not arrays which can lead to confusion.

Addresses-Coverity: ("Array compared against 0")
Fixes: c97ee3e0bea2 ("rtw88: add power tracking support")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/realtek/rtw88/phy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/phy.c b/drivers/net/wireless/realtek/rtw88/phy.c
index 69e7edb629f4..11893ec73376 100644
--- a/drivers/net/wireless/realtek/rtw88/phy.c
+++ b/drivers/net/wireless/realtek/rtw88/phy.c
@@ -2071,7 +2071,7 @@ s8 rtw_phy_pwrtrack_get_pwridx(struct rtw_dev *rtwdev,
 		return 0;
 	}
 
-	if (!swing_table || !swing_table->n || !swing_table->p) {
+	if (!swing_table) {
 		rtw_warn(rtwdev, "swing table not configured\n");
 		return 0;
 	}
-- 
2.20.1

