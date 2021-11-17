Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C167F453E1D
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 03:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232734AbhKQCDN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 21:03:13 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:31876 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbhKQCDM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 21:03:12 -0500
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Hv5bp5K5jzcbPH;
        Wed, 17 Nov 2021 09:55:18 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 17 Nov 2021 10:00:05 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Wed, 17 Nov 2021 10:00:04 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <mkubecek@suse.cz>,
        <andrew@lunn.ch>, <amitc@mellanox.com>, <idosch@idosch.org>,
        <danieller@nvidia.com>, <jesse.brandeburg@intel.com>,
        <anthony.l.nguyen@intel.com>, <jdike@addtoit.com>,
        <richard@nod.at>, <anton.ivanov@cambridgegreys.com>,
        <netanel@amazon.com>, <akiyano@amazon.com>, <gtzalik@amazon.com>,
        <saeedb@amazon.com>, <chris.snook@gmail.com>,
        <ulli.kroll@googlemail.com>, <linus.walleij@linaro.org>,
        <jeroendb@google.com>, <csully@google.com>,
        <awogbemila@google.com>, <jdmason@kudzu.us>,
        <rain.1986.08.12@gmail.com>, <zyjzyj2000@gmail.com>,
        <kys@microsoft.com>, <haiyangz@microsoft.com>, <mst@redhat.com>,
        <jasowang@redhat.com>, <doshir@vmware.com>,
        <pv-drivers@vmware.com>, <jwi@linux.ibm.com>,
        <kgraul@linux.ibm.com>, <hca@linux.ibm.com>, <gor@linux.ibm.com>,
        <johannes@sipsolutions.net>
CC:     <netdev@vger.kernel.org>, <lipeng321@huawei.com>,
        <chenhao288@hisilicon.com>, <huangguangbin2@huawei.com>,
        <linux-s390@vger.kernel.org>
Subject: [RESEND PATCH V6 net-next 6/6] net: hns3: remove the way to set tx spare buf via module parameter
Date:   Wed, 17 Nov 2021 09:55:26 +0800
Message-ID: <20211117015526.27593-7-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211117015526.27593-1-huangguangbin2@huawei.com>
References: <20211117015526.27593-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hao Chen <chenhao288@hisilicon.com>

The way to set tx spare buf via module parameter is not such
convenient as the way to set it via ethtool.

So,remove the way to set tx spare buf via module parameter.

Signed-off-by: Hao Chen <chenhao288@hisilicon.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 031d73006a8e..3aba97504525 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -53,10 +53,6 @@ static int debug = -1;
 module_param(debug, int, 0);
 MODULE_PARM_DESC(debug, " Network interface message level setting");
 
-static unsigned int tx_spare_buf_size;
-module_param(tx_spare_buf_size, uint, 0400);
-MODULE_PARM_DESC(tx_spare_buf_size, "Size used to allocate tx spare buffer");
-
 static unsigned int tx_sgl = 1;
 module_param(tx_sgl, uint, 0600);
 MODULE_PARM_DESC(tx_sgl, "Minimum number of frags when using dma_map_sg() to optimize the IOMMU mapping");
@@ -1041,8 +1037,7 @@ static void hns3_init_tx_spare_buffer(struct hns3_enet_ring *ring)
 	dma_addr_t dma;
 	int order;
 
-	alloc_size = tx_spare_buf_size ? tx_spare_buf_size :
-		     ring->tqp->handle->kinfo.tx_spare_buf_size;
+	alloc_size = ring->tqp->handle->kinfo.tx_spare_buf_size;
 	if (!alloc_size)
 		return;
 
-- 
2.33.0

