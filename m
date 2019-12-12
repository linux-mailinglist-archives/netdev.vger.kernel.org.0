Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA66011D6DE
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 20:10:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730573AbfLLTKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 14:10:50 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:60870 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730355AbfLLTKt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 14:10:49 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1ifTrI-0000w1-HG; Thu, 12 Dec 2019 19:10:44 +0000
From:   Colin King <colin.king@canonical.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>,
        Ganesh Sesetti <gseset@codeaurora.org>,
        Karthikeyan Periyasamy <periyasa@codeaurora.org>,
        John Crispin <john@phrozen.org>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] ath11k: fix uninitialized variable radioup
Date:   Thu, 12 Dec 2019 19:10:44 +0000
Message-Id: <20191212191044.107544-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The variable radioup is not uninitalized so it may contain a garbage
value and hence the detection of a radio that is not up is buggy.
Fix this by initializing it to zero.

Addresses-Coverity: ("Uninitalized scalar variable")
Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/ath/ath11k/debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/debug.c b/drivers/net/wireless/ath/ath11k/debug.c
index c27fffd13a5d..34b960453edc 100644
--- a/drivers/net/wireless/ath/ath11k/debug.c
+++ b/drivers/net/wireless/ath/ath11k/debug.c
@@ -541,7 +541,7 @@ static ssize_t ath11k_write_simulate_fw_crash(struct file *file,
 	struct ath11k *ar = ab->pdevs[0].ar;
 	char buf[32] = {0};
 	ssize_t rc;
-	int i, ret, radioup;
+	int i, ret, radioup = 0;
 
 	for (i = 0; i < ab->num_radios; i++) {
 		pdev = &ab->pdevs[i];
-- 
2.24.0

