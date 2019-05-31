Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BED930AEB
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 10:57:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727346AbfEaI5k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 04:57:40 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:39568 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727094AbfEaI4j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 04:56:39 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 42EE191FA8FD1AAE31DE;
        Fri, 31 May 2019 16:56:37 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.439.0; Fri, 31 May 2019 16:56:27 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Weihang Li <liweihang@hisilicon.com>,
        Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 08/12] net: hns3: remove setting bit of reset_requests when handling mac tunnel interrupts
Date:   Fri, 31 May 2019 16:54:54 +0800
Message-ID: <1559292898-64090-9-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1559292898-64090-1-git-send-email-tanhuazhong@huawei.com>
References: <1559292898-64090-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Weihang Li <liweihang@hisilicon.com>

We shouldn't set HNAE3_NONE_RESET bit of the variable that represents a
reset request during handling of MSI-X errors, or may cause issue when
trigger reset.

Signed-off-by: Weihang Li <liweihang@hisilicon.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
index 55c4a1b..83b07ce 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
@@ -1783,7 +1783,6 @@ int hclge_handle_hw_msix_error(struct hclge_dev *hdev,
 		ret = hclge_clear_mac_tnl_int(hdev);
 		if (ret)
 			dev_err(dev, "clear mac tnl int failed (%d)\n", ret);
-		set_bit(HNAE3_NONE_RESET, reset_requests);
 	}
 
 msi_error:
-- 
2.7.4

