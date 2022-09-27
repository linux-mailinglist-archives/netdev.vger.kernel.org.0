Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3EE65EC0D3
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 13:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232026AbiI0LPh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 07:15:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231958AbiI0LPC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 07:15:02 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F2C74B4B7;
        Tue, 27 Sep 2022 04:14:58 -0700 (PDT)
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4McH353mhbzHtdQ;
        Tue, 27 Sep 2022 19:10:09 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 27 Sep 2022 19:14:56 +0800
Received: from localhost.localdomain (10.69.192.56) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 27 Sep 2022 19:14:55 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <huangguangbin2@huawei.com>, <shenjian15@huawei.com>,
        <lanhao@huawei.com>
Subject: [PATCH net-next 2/4] net: hns3: fix hns3 driver header file not self-contained issue
Date:   Tue, 27 Sep 2022 19:12:03 +0800
Message-ID: <20220927111205.18060-3-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220927111205.18060-1-huangguangbin2@huawei.com>
References: <20220927111205.18060-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hao Chen <chenhao418@huawei.com>

The hns3 driver header file uses the structure of other files, but does
not include corresponding file, which causes a check warning that the
header file is not self-contained.

Therefore, the required header file is included in the header file, and
the structure declaration is added to the header file to avoid cyclic
dependency of the header file.

Signed-off-by: Hao Chen <chenhao418@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h              | 4 +++-
 .../hisilicon/hns3/hns3_common/hclge_comm_tqp_stats.h        | 2 ++
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h              | 3 +++
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.h       | 5 ++++-
 4 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h b/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
index abcd7877f7d2..487216aeae50 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
@@ -7,6 +7,8 @@
 #include <linux/mutex.h>
 #include <linux/types.h>
 
+struct hclgevf_dev;
+
 enum HCLGE_MBX_OPCODE {
 	HCLGE_MBX_RESET = 0x01,		/* (VF -> PF) assert reset */
 	HCLGE_MBX_ASSERTING_RESET,	/* (PF -> VF) PF is asserting reset */
@@ -233,7 +235,7 @@ struct hclgevf_mbx_arq_ring {
 	__le16 msg_q[HCLGE_MBX_MAX_ARQ_MSG_NUM][HCLGE_MBX_MAX_ARQ_MSG_SIZE];
 };
 
-struct hclge_dev;
+struct hclge_vport;
 
 #define HCLGE_MBX_OPCODE_MAX 256
 struct hclge_mbx_ops_param {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_tqp_stats.h b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_tqp_stats.h
index a46350162ee8..7aff1a544cf4 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_tqp_stats.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_tqp_stats.h
@@ -7,6 +7,8 @@
 #include <linux/etherdevice.h>
 #include "hnae3.h"
 
+struct hclge_comm_hw;
+
 /* each tqp has TX & RX two queues */
 #define HCLGE_COMM_QUEUE_PAIR_SIZE 2
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index 133a054af6b7..557a5fa70d0a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -13,6 +13,9 @@
 
 struct iphdr;
 struct ipv6hdr;
+struct gre_base_hdr;
+struct tcphdr;
+struct udphdr;
 
 enum hns3_nic_state {
 	HNS3_NIC_STATE_TESTING,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.h
index bbee74cd8404..bceb61c791a1 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.h
@@ -8,8 +8,11 @@
 #include <linux/net_tstamp.h>
 #include <linux/types.h>
 
-struct hclge_dev;
 struct ifreq;
+struct ethtool_ts_info;
+
+struct hnae3_handle;
+struct hclge_dev;
 
 #define HCLGE_PTP_REG_OFFSET	0x29000
 
-- 
2.33.0

