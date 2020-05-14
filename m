Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D71931D301D
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 14:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727785AbgENMnS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 08:43:18 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:59348 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726067AbgENMnB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 May 2020 08:43:01 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 24A573C9E4C58D5F1E17;
        Thu, 14 May 2020 20:42:58 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.487.0; Thu, 14 May 2020 20:42:50 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 3/5] net: hns3: modify an incorrect error log in hclge_mbx_handler()
Date:   Thu, 14 May 2020 20:41:24 +0800
Message-ID: <1589460086-61130-4-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1589460086-61130-1-git-send-email-tanhuazhong@huawei.com>
References: <1589460086-61130-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When handling HCLGE_MBX_GET_LINK_STATUS, PF will return the link
status to the VF, so the error log of hclge_get_link_info() is
incorrect.

Reported-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index ac70faf..0874ae4 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -742,7 +742,7 @@ void hclge_mbx_handler(struct hclge_dev *hdev)
 			ret = hclge_get_link_info(vport, req);
 			if (ret)
 				dev_err(&hdev->pdev->dev,
-					"PF fail(%d) to get link stat for VF\n",
+					"failed to inform link stat to VF, ret = %d\n",
 					ret);
 			break;
 		case HCLGE_MBX_QUEUE_RESET:
-- 
2.7.4

