Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAD35696F4
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 17:08:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387405AbfGOOCH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 10:02:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:45050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730529AbfGOOCG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 10:02:06 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0CB620C01;
        Mon, 15 Jul 2019 14:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563199325;
        bh=IY/4Z3VZKH9tWX8hyzz9JLXe2h+wlpamdpXgSSjSkGE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J7K+2/Qf3oE9+v3WP+J3J4sWNB/Hw0bpOvB/yVSw2xxTxlQY9eSmIyKdGUU6LDGes
         4eSx/3S8M4+b8VvdjpZhaq5Omb+BQc+esIixb+j0WlLxVXC/T71FQO2kfKqceqJ5OD
         MLQ8nN1Nji5DSkxRoF8MIwwnZURu7go4Ecu90jS4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jian Shen <shenjian15@huawei.com>, Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 233/249] net: hns3: fix port capbility updating issue
Date:   Mon, 15 Jul 2019 09:46:38 -0400
Message-Id: <20190715134655.4076-233-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715134655.4076-1-sashal@kernel.org>
References: <20190715134655.4076-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

[ Upstream commit 49b1255603de5183c5e377200be3b3afe0dcdb86 ]

Currently, the driver queries the media port information, and
updates the port capability periodically. But it sets an error
mac->speed_type value, which stops update port capability.

Fixes: 88d10bd6f730 ("net: hns3: add support for multiple media type")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index bab04d2d674a..f2bffc05e902 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -2592,6 +2592,7 @@ static int hclge_get_sfp_info(struct hclge_dev *hdev, struct hclge_mac *mac)
 		mac->speed_ability = le32_to_cpu(resp->speed_ability);
 		mac->autoneg = resp->autoneg;
 		mac->support_autoneg = resp->autoneg_ability;
+		mac->speed_type = QUERY_ACTIVE_SPEED;
 		if (!resp->active_fec)
 			mac->fec_mode = 0;
 		else
-- 
2.20.1

