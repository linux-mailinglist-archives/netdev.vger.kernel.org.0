Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D81B6313147
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 12:48:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233134AbhBHLr2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 06:47:28 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:12594 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233247AbhBHLn7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 06:43:59 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DZ3vT2VSzz165PX;
        Mon,  8 Feb 2021 19:39:01 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.498.0; Mon, 8 Feb 2021 19:40:15 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 08/12] net: hns3: change hclge_query_bd_num() param type
Date:   Mon, 8 Feb 2021 19:39:38 +0800
Message-ID: <1612784382-27262-9-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1612784382-27262-1-git-send-email-tanhuazhong@huawei.com>
References: <1612784382-27262-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

The type of parameter mpf_bd_num and pf_bd_num in
hclge_query_bd_num() should be u32* instead of int*,
so change them.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
index 9ee55ee..0ca7f1b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
@@ -1073,7 +1073,7 @@ static int hclge_config_ssu_hw_err_int(struct hclge_dev *hdev, bool en)
  * This function querys number of mpf and pf buffer descriptors.
  */
 static int hclge_query_bd_num(struct hclge_dev *hdev, bool is_ras,
-			      int *mpf_bd_num, int *pf_bd_num)
+			      u32 *mpf_bd_num, u32 *pf_bd_num)
 {
 	struct device *dev = &hdev->pdev->dev;
 	u32 mpf_min_bd_num, pf_min_bd_num;
@@ -1102,7 +1102,7 @@ static int hclge_query_bd_num(struct hclge_dev *hdev, bool is_ras,
 	*mpf_bd_num = le32_to_cpu(desc_bd.data[0]);
 	*pf_bd_num = le32_to_cpu(desc_bd.data[1]);
 	if (*mpf_bd_num < mpf_min_bd_num || *pf_bd_num < pf_min_bd_num) {
-		dev_err(dev, "Invalid bd num: mpf(%d), pf(%d)\n",
+		dev_err(dev, "Invalid bd num: mpf(%u), pf(%u)\n",
 			*mpf_bd_num, *pf_bd_num);
 		return -EINVAL;
 	}
-- 
2.7.4

