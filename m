Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D36652C289
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 11:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727447AbfE1JEg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 05:04:36 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:57236 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727418AbfE1JEf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 05:04:35 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id A1990200D987D55876F3;
        Tue, 28 May 2019 17:04:31 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.439.0; Tue, 28 May 2019 17:04:25 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Jian Shen <shenjian15@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 01/12] net: hns3: fix compile warning without CONFIG_RFS_ACCEL
Date:   Tue, 28 May 2019 17:02:51 +0800
Message-ID: <1559034182-24737-2-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1559034182-24737-1-git-send-email-tanhuazhong@huawei.com>
References: <1559034182-24737-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

The ifdef condition of function hclge_add_fd_entry_by_arfs() is
unnecessary. It may cause compile warning when CONFIG_RFS_ACCEL
is not chosen. This patch fixes it by removing the ifdef condition.

Fixes: d93ed94fbeaf ("net: hns3: add aRFS support for PF")
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index a3fba7b..fb0dc18 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -5682,7 +5682,6 @@ static void hclge_fd_build_arfs_rule(const struct hclge_fd_rule_tuples *tuples,
 static int hclge_add_fd_entry_by_arfs(struct hnae3_handle *handle, u16 queue_id,
 				      u16 flow_id, struct flow_keys *fkeys)
 {
-#ifdef CONFIG_RFS_ACCEL
 	struct hclge_vport *vport = hclge_get_vport(handle);
 	struct hclge_fd_rule_tuples new_tuples;
 	struct hclge_dev *hdev = vport->back;
@@ -5758,7 +5757,6 @@ static int hclge_add_fd_entry_by_arfs(struct hnae3_handle *handle, u16 queue_id,
 	}
 
 	return rule->location;
-#endif
 }
 
 static void hclge_rfs_filter_expire(struct hclge_dev *hdev)
-- 
2.7.4

