Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F2BA3ECCA0
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 04:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233139AbhHPCUC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Aug 2021 22:20:02 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:8021 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231513AbhHPCTt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Aug 2021 22:19:49 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GnyWz6sqdzYq1f;
        Mon, 16 Aug 2021 10:18:55 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 16 Aug 2021 10:19:15 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 16 Aug 2021 10:19:14 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <amitc@mellanox.com>,
        <idosch@idosch.org>, <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH RESEND V2 net-next 3/4] net: hns3: add header file hns3_ethtoo.h
Date:   Mon, 16 Aug 2021 10:15:28 +0800
Message-ID: <1629080129-46507-4-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1629080129-46507-1-git-send-email-huangguangbin2@huawei.com>
References: <1629080129-46507-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new file hns3_ethtool.h, and move struct type definitions from
hns3_ethtool.c to hns3_ethtool.h.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c | 16 +-------------
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.h | 25 ++++++++++++++++++++++
 2 files changed, 26 insertions(+), 15 deletions(-)
 create mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.h

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index c8f09b07185e..167721b647ad 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -7,21 +7,7 @@
 #include <linux/sfp.h>
 
 #include "hns3_enet.h"
-
-struct hns3_stats {
-	char stats_string[ETH_GSTRING_LEN];
-	int stats_offset;
-};
-
-struct hns3_sfp_type {
-	u8 type;
-	u8 ext_type;
-};
-
-struct hns3_pflag_desc {
-	char name[ETH_GSTRING_LEN];
-	void (*handler)(struct net_device *netdev, bool enable);
-};
+#include "hns3_ethtool.h"
 
 /* tqp related stats */
 #define HNS3_TQP_STAT(_string, _member)	{			\
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.h b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.h
new file mode 100644
index 000000000000..2f186607c6e0
--- /dev/null
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+// Copyright (c) 2021 Hisilicon Limited.
+
+#ifndef __HNS3_ETHTOOL_H
+#define __HNS3_ETHTOOL_H
+
+#include <linux/ethtool.h>
+#include <linux/netdevice.h>
+
+struct hns3_stats {
+	char stats_string[ETH_GSTRING_LEN];
+	int stats_offset;
+};
+
+struct hns3_sfp_type {
+	u8 type;
+	u8 ext_type;
+};
+
+struct hns3_pflag_desc {
+	char name[ETH_GSTRING_LEN];
+	void (*handler)(struct net_device *netdev, bool enable);
+};
+
+#endif
-- 
2.8.1

