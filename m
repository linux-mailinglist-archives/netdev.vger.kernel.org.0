Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA015AA7C7
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 17:56:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389242AbfIEP44 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 11:56:56 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:6232 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730753AbfIEP4z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Sep 2019 11:56:55 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 9E58B8E3A8A51ACE7228;
        Thu,  5 Sep 2019 23:56:52 +0800 (CST)
Received: from linux-ibm.site (10.175.102.37) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.439.0; Thu, 5 Sep 2019 23:56:43 +0800
From:   zhong jiang <zhongjiang@huawei.com>
To:     <davem@davemloft.net>
CC:     <kstewart@linuxfoundation.org>, <gregkh@linuxfoundation.org>,
        <zhongjiang@huawei.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] ethernet: micrel: Use DIV_ROUND_CLOSEST directly to make it readable
Date:   Thu, 5 Sep 2019 23:53:48 +0800
Message-ID: <1567698828-26825-1-git-send-email-zhongjiang@huawei.com>
X-Mailer: git-send-email 1.7.12.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.102.37]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The kernel.h macro DIV_ROUND_CLOSEST performs the computation (x + d/2)/d
but is perhaps more readable.

Signed-off-by: zhong jiang <zhongjiang@huawei.com>
---
 drivers/net/ethernet/micrel/ksz884x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/micrel/ksz884x.c b/drivers/net/ethernet/micrel/ksz884x.c
index 3103446..e102e15 100644
--- a/drivers/net/ethernet/micrel/ksz884x.c
+++ b/drivers/net/ethernet/micrel/ksz884x.c
@@ -2166,7 +2166,7 @@ static void sw_get_broad_storm(struct ksz_hw *hw, u8 *percent)
 	num = (data & BROADCAST_STORM_RATE_HI);
 	num <<= 8;
 	num |= (data & BROADCAST_STORM_RATE_LO) >> 8;
-	num = (num * 100 + BROADCAST_STORM_VALUE / 2) / BROADCAST_STORM_VALUE;
+	num = DIV_ROUND_CLOSEST(num * 100, BROADCAST_STORM_VALUE);
 	*percent = (u8) num;
 }
 
-- 
1.7.12.4

