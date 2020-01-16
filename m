Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EF0413E41B
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 18:06:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388859AbgAPRGL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 12:06:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:36032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388849AbgAPRGK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:06:10 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC62B217F4;
        Thu, 16 Jan 2020 17:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194369;
        bh=1x2w+RPyrf+ZZrsGYp6rPWeEaOjsIov9fvJqcD52Iv4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ob3+9ZdR78jq3N9zBghbo+1LqhDKocSHknHrfW0jJbVPVCBdztDYbn14x/PxcLAX3
         7FWMNCxH06rChXEEJI/8zcxsZ2zPvxsBvzyM9+U+HINxcarFGPkar3UhgT0UCoomgH
         Uy8QbdH27+YCM+kSEVKhPkKT1DZy+x4/sPxJUNBU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jian Shen <shenjian15@huawei.com>, Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 303/671] net: hns3: fix loop condition of hns3_get_tx_timeo_queue_info()
Date:   Thu, 16 Jan 2020 11:59:01 -0500
Message-Id: <20200116170509.12787-40-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

[ Upstream commit fa6c4084b98b82c98cada0f0d5c9f8577579f962 ]

In function hns3_get_tx_timeo_queue_info(), it should use
netdev->num_tx_queues, instead of netdve->real_num_tx_queues
as the loop limitation.

Fixes: 424eb834a9be ("net: hns3: Unified HNS3 {VF|PF} Ethernet Driver for hip08 SoC")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 10fa7f5df57e..3eb8b85f6afb 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1464,7 +1464,7 @@ static bool hns3_get_tx_timeo_queue_info(struct net_device *ndev)
 	int i;
 
 	/* Find the stopped queue the same way the stack does */
-	for (i = 0; i < ndev->real_num_tx_queues; i++) {
+	for (i = 0; i < ndev->num_tx_queues; i++) {
 		struct netdev_queue *q;
 		unsigned long trans_start;
 
-- 
2.20.1

