Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 946E54681CC
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 02:29:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383966AbhLDBc4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 20:32:56 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:32877 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237601AbhLDBcz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 20:32:55 -0500
Received: from kwepemi100004.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4J5XD034DLzcbmW;
        Sat,  4 Dec 2021 09:29:20 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi100004.china.huawei.com (7.221.188.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Sat, 4 Dec 2021 09:29:29 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Sat, 4 Dec 2021 09:29:28 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next] Revert "net: hns3: add void before function which don't receive ret"
Date:   Sat, 4 Dec 2021 09:24:48 +0800
Message-ID: <20211204012448.51360-1-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 5ac4f180bd07116c1e57858bc3f6741adbca3eb6.

Sorry for taking no notice that the function devlink_register() has been
already declared as void, so it is needs to revert this patch.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c   | 2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c
index 9c3199d3c8ee..4c441e6a5082 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c
@@ -120,7 +120,7 @@ int hclge_devlink_init(struct hclge_dev *hdev)
 	hdev->devlink = devlink;
 
 	devlink_set_features(devlink, DEVLINK_F_RELOAD);
-	(void)devlink_register(devlink);
+	devlink_register(devlink);
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c
index 75d2926729d3..fdc19868b818 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c
@@ -122,7 +122,7 @@ int hclgevf_devlink_init(struct hclgevf_dev *hdev)
 	hdev->devlink = devlink;
 
 	devlink_set_features(devlink, DEVLINK_F_RELOAD);
-	(void)devlink_register(devlink);
+	devlink_register(devlink);
 	return 0;
 }
 
-- 
2.33.0

