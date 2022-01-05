Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABFF548545A
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 15:26:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240714AbiAEOZ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 09:25:27 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:16687 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240677AbiAEOZU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 09:25:20 -0500
Received: from kwepemi100005.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4JTWrV3XR4zZdyt;
        Wed,  5 Jan 2022 22:21:46 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi100005.china.huawei.com (7.221.188.155) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 5 Jan 2022 22:25:13 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 5 Jan 2022 22:25:13 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next 01/15] net: hns3: create new rss common structure hclge_comm_rss_cfg
Date:   Wed, 5 Jan 2022 22:20:01 +0800
Message-ID: <20220105142015.51097-2-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220105142015.51097-1-huangguangbin2@huawei.com>
References: <20220105142015.51097-1-huangguangbin2@huawei.com>
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

From: Jie Wang <wangjie125@huawei.com>

Currently PF stores its rss parameters in vport structure. VF stores rss
configurations in hclgevf_rss_cfg structure. Actually hns3 rss parameters
are same beween PF and VF. The two set of rss parameters are redundent and
may add extra bugfix work.

So this patch creates new common rss parameter struct(hclge_comm_rss_cfg)
to unify PF and VF rss configurations.

These new structures will be used to unify rss configurations in PF and VF
rss APIs in next patches.

Signed-off-by: Jie Wang <wangjie125@huawei.com>
---
 .../hns3/hns3_common/hclge_comm_rss.h         | 34 +++++++++++++++++++
 1 file changed, 34 insertions(+)
 create mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_rss.h

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_rss.h b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_rss.h
new file mode 100644
index 000000000000..74bd30b2fcc9
--- /dev/null
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_rss.h
@@ -0,0 +1,34 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+// Copyright (c) 2021-2021 Hisilicon Limited.
+
+#ifndef __HCLGE_COMM_RSS_H
+#define __HCLGE_COMM_RSS_H
+#include <linux/types.h>
+
+#include "hnae3.h"
+
+struct hclge_comm_rss_tuple_cfg {
+	u8 ipv4_tcp_en;
+	u8 ipv4_udp_en;
+	u8 ipv4_sctp_en;
+	u8 ipv4_fragment_en;
+	u8 ipv6_tcp_en;
+	u8 ipv6_udp_en;
+	u8 ipv6_sctp_en;
+	u8 ipv6_fragment_en;
+};
+
+#define HCLGE_COMM_RSS_KEY_SIZE		40
+
+struct hclge_comm_rss_cfg {
+	u8 rss_hash_key[HCLGE_COMM_RSS_KEY_SIZE]; /* user configured hash keys */
+
+	/* shadow table */
+	u16 *rss_indirection_tbl;
+	u32 rss_algo;
+
+	struct hclge_comm_rss_tuple_cfg rss_tuple_sets;
+	u32 rss_size;
+};
+
+#endif
-- 
2.33.0

