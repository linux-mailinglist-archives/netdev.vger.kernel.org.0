Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69B0E232C00
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 08:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728779AbgG3Gmj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 02:42:39 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:43904 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725892AbgG3Gmi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 02:42:38 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 840B94D43BBC68A5832C;
        Thu, 30 Jul 2020 14:42:32 +0800 (CST)
Received: from huawei.com (10.175.104.57) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.487.0; Thu, 30 Jul 2020
 14:42:27 +0800
From:   Li Heng <liheng40@huawei.com>
To:     <michael.chan@broadcom.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] bnxt_en: Remove superfluous memset()
Date:   Thu, 30 Jul 2020 14:43:50 +0800
Message-ID: <1596091430-19486-1-git-send-email-liheng40@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.104.57]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes coccicheck warning:

./drivers/net/ethernet/broadcom/bnxt/bnxt.c:3730:19-37: WARNING:
dma_alloc_coherent use in stats -> hw_stats already zeroes out
memory,  so memset is not needed

dma_alloc_coherent use in status already zeroes out memory,
so memset is not needed

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Li Heng <liheng40@huawei.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 2622d3c..31fb5a2 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -3732,8 +3732,6 @@ static int bnxt_alloc_stats_mem(struct bnxt *bp, struct bnxt_stats_mem *stats,
 	if (!stats->hw_stats)
 		return -ENOMEM;
 
-	memset(stats->hw_stats, 0, stats->len);
-
 	stats->sw_stats = kzalloc(stats->len, GFP_KERNEL);
 	if (!stats->sw_stats)
 		goto stats_mem_err;
-- 
2.7.4

