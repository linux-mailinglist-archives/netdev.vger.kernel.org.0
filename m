Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AD91626812
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 09:17:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234833AbiKLIRe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Nov 2022 03:17:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234813AbiKLIR3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Nov 2022 03:17:29 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 655972529D
        for <netdev@vger.kernel.org>; Sat, 12 Nov 2022 00:17:28 -0800 (PST)
Received: from dggpemm500023.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4N8T2K0P15zRp4K;
        Sat, 12 Nov 2022 16:17:13 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 12 Nov 2022 16:17:26 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 12 Nov 2022 16:17:26 +0800
From:   Hao Lan <lanhao@huawei.com>
To:     <lanhao@huawei.com>, <lipeng321@huawei.com>,
        <shenjian15@huawei.com>, <linyunsheng@huawei.com>,
        <liuyonglong@huawei.com>, <chenhao418@huawei.com>,
        <wangjie125@huawei.com>, <huangguangbin2@huawei.com>,
        <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <xiaojiantao1@h-partners.com>
Subject: [PATCH net-next 1/2] net: hns3: fix hns3 driver header file not self-contained issue
Date:   Sat, 12 Nov 2022 16:17:48 +0800
Message-ID: <20221112081749.56229-2-lanhao@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20221112081749.56229-1-lanhao@huawei.com>
References: <20221112081749.56229-1-lanhao@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500005.china.huawei.com (7.185.36.74)
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
Signed-off-by: Hao Lan <lanhao@huawei.com>
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
2.30.0

