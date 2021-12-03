Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B62B4673ED
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 10:25:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379618AbhLCJ3L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 04:29:11 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:15693 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379607AbhLCJ3L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 04:29:11 -0500
Received: from kwepemi500007.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4J56n16HDrzZdMP;
        Fri,  3 Dec 2021 17:23:01 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi500007.china.huawei.com (7.221.188.207) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 3 Dec 2021 17:25:45 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 3 Dec 2021 17:25:40 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next 03/11] net: hns3: add print vport id for failed message of vlan
Date:   Fri, 3 Dec 2021 17:20:51 +0800
Message-ID: <20211203092059.24947-4-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211203092059.24947-1-huangguangbin2@huawei.com>
References: <20211203092059.24947-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds print vport id when failed to get or set vlan
filter parameters.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 0d2ed05c4f50..2d12caa18b0b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -9746,8 +9746,8 @@ static int hclge_set_vlan_filter_ctrl(struct hclge_dev *hdev, u8 vlan_type,
 
 	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
 	if (ret) {
-		dev_err(&hdev->pdev->dev,
-			"failed to get vlan filter config, ret = %d.\n", ret);
+		dev_err(&hdev->pdev->dev, "failed to get vport%u vlan filter config, ret = %d.\n",
+			vf_id, ret);
 		return ret;
 	}
 
@@ -9758,8 +9758,8 @@ static int hclge_set_vlan_filter_ctrl(struct hclge_dev *hdev, u8 vlan_type,
 
 	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
 	if (ret)
-		dev_err(&hdev->pdev->dev, "failed to set vlan filter, ret = %d.\n",
-			ret);
+		dev_err(&hdev->pdev->dev, "failed to set vport%u vlan filter, ret = %d.\n",
+			vf_id, ret);
 
 	return ret;
 }
-- 
2.33.0

