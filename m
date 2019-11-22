Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67B5310612B
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 06:54:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728124AbfKVFyi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 00:54:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:59072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728770AbfKVFxF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 00:53:05 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4D382084D;
        Fri, 22 Nov 2019 05:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401984;
        bh=JHnrEWl6Z0m9Bakb+shtnvx+AphQFnb7BzQ8iNeoJ7U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EkIy4Fpgd1Snj9/lOKXx790329jNUa8aIrXUmzPfYLJjKn2/RfAvM3BIFCYbCL+cT
         raIb/Cz/C6mF3/PvayJ0ri2dxKA8cnp/RQLsOdtGah5ZjBoJbCwjN27vGRGdcYzTDb
         MMQAbLXQcXAIbmtJRvpNUSeCFs4eTMYDfOumTt3s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 203/219] net: hns3: fix an issue for hns3_update_new_int_gl
Date:   Fri, 22 Nov 2019 00:48:54 -0500
Message-Id: <20191122054911.1750-195-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

[ Upstream commit 6241e71e7207102ffc733991f7a00f74098d7da0 ]

HNS3 supports setting rx-usecs|tx-usecs as 0, but it will not
update dynamically when adaptive-tx or adaptive-rx is enable.
This patch removes the Redundant check.

Fixes: a95e1f8666e9 ("net: hns3: change the time interval of int_gl calculating")
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 0ccfa6a845353..0ea791e0ae0f5 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2377,7 +2377,7 @@ static bool hns3_get_new_int_gl(struct hns3_enet_ring_group *ring_group)
 	u32 time_passed_ms;
 	u16 new_int_gl;
 
-	if (!ring_group->coal.int_gl || !tqp_vector->last_jiffies)
+	if (!tqp_vector->last_jiffies)
 		return false;
 
 	if (ring_group->total_packets == 0) {
-- 
2.20.1

