Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 459ED23569F
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 13:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728463AbgHBLQU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 07:16:20 -0400
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:59000 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727994AbgHBLPm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 07:15:42 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R621e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0U4T30Da_1596366937;
Received: from localhost(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0U4T30Da_1596366937)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 02 Aug 2020 19:15:38 +0800
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
To:     irusskikh@marvell.com, davem@davemloft.net, kuba@kernel.org,
        mstarovoitov@marvell.com, dbezrukov@marvell.com,
        ndanilov@marvell.com, tianjia.zhang@linux.alibaba.com,
        Pavel.Belous@aquantia.com, Alexander.Loktionov@aquantia.com,
        Dmitrii.Tarakanov@aquantia.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        tianjia.zhang@alibaba.com
Subject: [PATCH] net: ethernet: aquantia: Fix wrong return value
Date:   Sun,  2 Aug 2020 19:15:37 +0800
Message-Id: <20200802111537.5292-1-tianjia.zhang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In function hw_atl_a0_hw_multicast_list_set(), when an invalid
request is encountered, a negative error code should be returned.

Fixes: bab6de8fd180b ("net: ethernet: aquantia: Atlantic A0 and B0 specific functions")
Cc: David VomLehn <vomlehn@texas.net>
Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
---
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c
index a312864969af..6640fd35b29b 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c
@@ -782,7 +782,7 @@ static int hw_atl_a0_hw_multicast_list_set(struct aq_hw_s *self,
 	int err = 0;
 
 	if (count > (HW_ATL_A0_MAC_MAX - HW_ATL_A0_MAC_MIN)) {
-		err = EBADRQC;
+		err = -EBADRQC;
 		goto err_exit;
 	}
 	for (self->aq_nic_cfg->mc_list_count = 0U;
-- 
2.26.2

