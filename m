Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 675D1B900A
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 14:54:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbfITMyU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 08:54:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48254 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726527AbfITMyU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Sep 2019 08:54:20 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1iBIQQ-0008PS-Q7; Fri, 20 Sep 2019 12:54:14 +0000
From:   Colin King <colin.king@canonical.com>
To:     Jakub Kicinski <kubakici@wp.pl>, Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mt7601u: phy: simplify zero check on val
Date:   Fri, 20 Sep 2019 14:54:14 +0200
Message-Id: <20190920125414.15507-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Currently the zero check on val to break out of a loop
is a little obscure.  Replace the val is zero and break check
with a loop while value is non-zero.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/mediatek/mt7601u/phy.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt7601u/phy.c b/drivers/net/wireless/mediatek/mt7601u/phy.c
index 06f5702ab4bd..4e0e473caae1 100644
--- a/drivers/net/wireless/mediatek/mt7601u/phy.c
+++ b/drivers/net/wireless/mediatek/mt7601u/phy.c
@@ -213,9 +213,7 @@ int mt7601u_wait_bbp_ready(struct mt7601u_dev *dev)
 
 	do {
 		val = mt7601u_bbp_rr(dev, MT_BBP_REG_VERSION);
-		if (val && ~val)
-			break;
-	} while (--i);
+	} while (val && --i);
 
 	if (!i) {
 		dev_err(dev->dev, "Error: BBP is not ready\n");
-- 
2.20.1

