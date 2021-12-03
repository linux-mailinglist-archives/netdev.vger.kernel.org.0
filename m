Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33D0B4673F2
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 10:25:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379663AbhLCJ3P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 04:29:15 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:15694 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379612AbhLCJ3L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 04:29:11 -0500
Received: from kwepemi500007.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4J56n20RxXzZdKp;
        Fri,  3 Dec 2021 17:23:02 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi500007.china.huawei.com (7.221.188.207) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 3 Dec 2021 17:25:46 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 3 Dec 2021 17:25:40 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next 04/11] net: hns3: Align type of some variables with their print type
Date:   Fri, 3 Dec 2021 17:20:52 +0800
Message-ID: <20211203092059.24947-5-huangguangbin2@huawei.com>
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

From: Hao Chen <chenhao288@hisilicon.com>

The c language has a set of implicit type conversions, when
two variables perform bitwise or arithmetic operations.

For example, variable A (type u16/u8) -1, its output is int type variable.
u16/u8 will convert to int type implicitly before it does arithmetic
operations. So, change 1 to unsigned type.

Signed-off-by: Hao Chen <chenhao288@hisilicon.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 4 ++--
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c     | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index 65168125c42e..1d039e18dd72 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -99,7 +99,7 @@ static void hclge_dbg_fill_content(char *content, u16 len,
 static char *hclge_dbg_get_func_id_str(char *buf, u8 id)
 {
 	if (id)
-		sprintf(buf, "vf%u", id - 1);
+		sprintf(buf, "vf%u", id - 1U);
 	else
 		sprintf(buf, "pf");
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 2d12caa18b0b..e050e45cb9be 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -6806,7 +6806,7 @@ static int hclge_fd_parse_ring_cookie(struct hclge_dev *hdev, u64 ring_cookie,
 		if (vf > hdev->num_req_vfs) {
 			dev_err(&hdev->pdev->dev,
 				"Error: vf id (%u) should be less than %u\n",
-				vf - 1, hdev->num_req_vfs);
+				vf - 1U, hdev->num_req_vfs);
 			return -EINVAL;
 		}
 
@@ -6816,7 +6816,7 @@ static int hclge_fd_parse_ring_cookie(struct hclge_dev *hdev, u64 ring_cookie,
 		if (ring >= tqps) {
 			dev_err(&hdev->pdev->dev,
 				"Error: queue id (%u) > max tqp num (%u)\n",
-				ring, tqps - 1);
+				ring, tqps - 1U);
 			return -EINVAL;
 		}
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index c495df2e5953..8b3954b39147 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -181,7 +181,7 @@ static int hclge_get_ring_chain_from_mbx(
 		if (req->msg.param[i].tqp_index >= vport->nic.kinfo.rss_size) {
 			dev_err(&hdev->pdev->dev, "tqp index(%u) is out of range(0-%u)\n",
 				req->msg.param[i].tqp_index,
-				vport->nic.kinfo.rss_size - 1);
+				vport->nic.kinfo.rss_size - 1U);
 			return -EINVAL;
 		}
 	}
-- 
2.33.0

