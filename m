Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B8264D63FB
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 15:43:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241700AbiCKOor (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 09:44:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350081AbiCKOnp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 09:43:45 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2066.outbound.protection.outlook.com [40.107.93.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07D3A9EBA8
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 06:42:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VshLcfKKA8OS0tDkyZlBu5XRCpxOvqXmUt1f8qqfMGDvI/PCr03vaWlZkQbYSXS2fG7I4Y35myC88BjeljX2jKeKA/7KtGg/MJKXC31F4r4A4tA5w5HfyCjlBkTAWOajDgghM4zrFCOnUBrE4+qCbsLUPrzkID2eioAmOBUaaDxLVlVtOsggNjLSRhAqsH0Ri+TdbQZkb2keTJbrtp1X3NkQqeCQGTUqNDoa88votaaEEygnXk/RhGwwDXUtvBo65ERvjMLUsVV6wmnFj4CSWx1klIKVIqV/i8S5yoLsmemQNVoEqLjnLUOWl01bbYCWCgoRfTPBBtuDIaynOEq6qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lQ0hQGqcxNs2kEjZSALdVxNbysLYFXztGzRYDdshNh0=;
 b=FG9O2BntvXJgGmLjlgu9y9BWbvH4clKifXO91drZ1SDWSghWOrWeg0P4AWAHcu6gU3GH6nvfs3MauxNblZ5f1VWTGs62JNEd6o4oRdG0ozEbJ/g2LnHCF8liL6EY6QoJsIOEpKiQckb642GAG/mkuMYV9apmT9J6FzE/zjEnMi569EMJ4RoYgAysnRGPxLE9RSk+dMKxFTENt8Ff3nIeGJQErJWmMukugqSYCvdDm2A7uK4Mlvviz1O1qWOstgWQm6cuB/reFCCEi6FjMyB2iHwS/ueIUskWDvVTVXZx65v9rVPM1/r5mHnMG1TWyOKk6gqY5qowtEv/P/nmS1jTOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lQ0hQGqcxNs2kEjZSALdVxNbysLYFXztGzRYDdshNh0=;
 b=XugsB+ESUPY6/q2s+nQPJN6xXY4TYJK20gXcHKDXTpUHLb9EfbLCXBxspF6qNlsyAf6woJRjc189qRHX08iOc0yrWGutBydjKiuombyd+VBh/HOreq+gYsATBC+daAVdvF5Gd7MAz3OAFj+NUEFUwEVBAmVgVSdeyVrn3yLMUMBgr8aVaMxDi1BMLJ0aQ/bUCANDyxzZSkbkgToWlfrXyvGgTp6BkFVzuZetZt2cl0JNKPJ20548VjvPTj1533I2NeEBKHQSnuv8iumfa+Zq3hCNK5q1TqeMHiXWk9rcn1RhpTGRxoXhjfrrbrGjFfTwn47beNlr17Jhth9MpFqJTQ==
Received: from BN8PR03CA0027.namprd03.prod.outlook.com (2603:10b6:408:94::40)
 by CH2PR12MB4088.namprd12.prod.outlook.com (2603:10b6:610:a5::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Fri, 11 Mar
 2022 14:42:38 +0000
Received: from BN8NAM11FT039.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:94:cafe::5e) by BN8PR03CA0027.outlook.office365.com
 (2603:10b6:408:94::40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.22 via Frontend
 Transport; Fri, 11 Mar 2022 14:42:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT039.mail.protection.outlook.com (10.13.177.169) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5061.22 via Frontend Transport; Fri, 11 Mar 2022 14:42:37 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Fri, 11 Mar
 2022 14:42:35 +0000
Received: from localhost.localdomain (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Fri, 11 Mar
 2022 06:42:32 -0800
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH net-next v2 1/3] netdevsim: Introduce support for L3 offload xstats
Date:   Fri, 11 Mar 2022 15:41:22 +0100
Message-ID: <7480f1df343e383234e7f197d78c180eefe92e89.1647009587.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1647009587.git.petrm@nvidia.com>
References: <cover.1647009587.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3e05b40a-859b-42db-fddc-08da036d630a
X-MS-TrafficTypeDiagnostic: CH2PR12MB4088:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB408867CAB4D76F5D8808E2F5D60C9@CH2PR12MB4088.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EKMr0iN/iK/ZPuRYuGi3i8g9j4lcfRaZalp6OtDkUgncbO6PST9//hfUerJh4E6Fw9y64qRHC5UYXZJIKjR7QdNw59cBJ/vwaLr5CLVznCD0KCQNY31D2SzSrtTwD2XnWy4o8ZhApA8G9YH4mFSfz5sSf0Q8IMybRXdKJlU8oSbmYuAjPD0txnI5WB2cyH1mfvoGKphLNC//IVNfQDfrHyWX1Yj62zH4xSJxjKP+kv/512B+11XUN0PHQoG50F1z/QFTWZ8UrDxgYA380zXrVp2qDG+Yh8ynkxnwAzjoos/TPN147nCE54keKzBHt6bZ6CE2mmFMBzeuiFPZiMcBHv6Z86DZIjDMji2Wsli0ymm91j3pQ97CHxQtZZ/N57dRK6O91FiZIdcTh+DAPAI5aqSS/ANNPv1MMFafB01sqOAo0KyGnpt1t1fyiYwuLpG1oq2VEPp7V/6xS/bGeQo075LvbYRH1JMphWyNahIRo9QGvkMIRnKMaBX2pFHs6yJyl9aLsK+2NOu11Two7vTu6H4BI5TzU5vwJ93qO9trjnLbhC3RJU/xPEp2CuLTGLT2bI7AMxdIQbfhWiuGRNiKbzCDftF6q+/oTxA/rRt8rI3FHvdje1Q90qKEoKnIsb/tUDCPUFRue/4RWfZzn84zOUurmJ+xdUQUawxk5pafJfsaERLCBImGGjRSxyaeL9GRBM/t6gMpa3thlgNIZycSpg==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(30864003)(6916009)(36756003)(54906003)(26005)(16526019)(8676002)(47076005)(4326008)(107886003)(2616005)(81166007)(6666004)(83380400001)(186003)(5660300002)(356005)(316002)(426003)(82310400004)(2906002)(336012)(8936002)(86362001)(508600001)(70206006)(70586007)(36860700001)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2022 14:42:37.2611
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e05b40a-859b-42db-fddc-08da036d630a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT039.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4088
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for testing of HW stats support that was added recently, namely
the L3 stats support. L3 stats are provided for devices for which the L3
stats have been turned on, and that were enabled for netdevsim through a
debugfs toggle:

    # echo $ifindex > /sys/kernel/debug/netdevsim/$DEV/hwstats/l3/enable_ifindex

For fully enabled netdevices, netdevsim counts 10pps of ingress traffic and
20pps of egress traffic. Similarly, L3 stats can be disabled for a given
device, and netdevsim ceases pretending there is any HW traffic going on:

    # echo $ifindex > /sys/kernel/debug/netdevsim/$DEV/hwstats/l3/disable_ifindex

Besides this, there is a third toggle to mark a device for future failure:

    # echo $ifindex > /sys/kernel/debug/netdevsim/$DEV/hwstats/l3/fail_next_enable

A future request to enable L3 stats on such netdevice will be bounced by
netdevsim:

    # ip -j l sh dev d | jq '.[].ifindex'
    66
    # echo 66 > /sys/kernel/debug/netdevsim/netdevsim10/hwstats/l3/enable_ifindex
    # echo 66 > /sys/kernel/debug/netdevsim/netdevsim10/hwstats/l3/fail_next_enable
    # ip stats set dev d l3_stats on
    Error: netdevsim: Stats enablement set to fail.

Signed-off-by: Petr Machata <petrm@nvidia.com>
---

Notes:
    v2:
    - Embed fops into a structure that carries the necessary metadata
      together with the fops. Extract the data in the generic write
      handler to determine what debugfs file the op pertains to. This
      obviates the need to have a per-debugfs file helper wrapper.

 drivers/net/netdevsim/Makefile    |   2 +-
 drivers/net/netdevsim/dev.c       |  17 +-
 drivers/net/netdevsim/hwstats.c   | 485 ++++++++++++++++++++++++++++++
 drivers/net/netdevsim/netdevsim.h |  23 ++
 4 files changed, 524 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/netdevsim/hwstats.c

diff --git a/drivers/net/netdevsim/Makefile b/drivers/net/netdevsim/Makefile
index a1cbfa44a1e1..5735e5b1a2cb 100644
--- a/drivers/net/netdevsim/Makefile
+++ b/drivers/net/netdevsim/Makefile
@@ -3,7 +3,7 @@
 obj-$(CONFIG_NETDEVSIM) += netdevsim.o
 
 netdevsim-objs := \
-	netdev.o dev.o ethtool.o fib.o bus.o health.o udp_tunnels.o
+	netdev.o dev.o ethtool.o fib.o bus.o health.o hwstats.o udp_tunnels.o
 
 ifeq ($(CONFIG_BPF_SYSCALL),y)
 netdevsim-objs += \
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 08d7b465a0de..dbc8e88d2841 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -1498,10 +1498,14 @@ static int nsim_dev_reload_create(struct nsim_dev *nsim_dev,
 	if (err)
 		goto err_health_exit;
 
-	err = nsim_dev_port_add_all(nsim_dev, nsim_bus_dev->port_count);
+	err = nsim_dev_hwstats_init(nsim_dev);
 	if (err)
 		goto err_psample_exit;
 
+	err = nsim_dev_port_add_all(nsim_dev, nsim_bus_dev->port_count);
+	if (err)
+		goto err_hwstats_exit;
+
 	nsim_dev->take_snapshot = debugfs_create_file("take_snapshot",
 						      0200,
 						      nsim_dev->ddir,
@@ -1509,6 +1513,8 @@ static int nsim_dev_reload_create(struct nsim_dev *nsim_dev,
 						&nsim_dev_take_snapshot_fops);
 	return 0;
 
+err_hwstats_exit:
+	nsim_dev_hwstats_exit(nsim_dev);
 err_psample_exit:
 	nsim_dev_psample_exit(nsim_dev);
 err_health_exit:
@@ -1595,15 +1601,21 @@ int nsim_drv_probe(struct nsim_bus_dev *nsim_bus_dev)
 	if (err)
 		goto err_bpf_dev_exit;
 
-	err = nsim_dev_port_add_all(nsim_dev, nsim_bus_dev->port_count);
+	err = nsim_dev_hwstats_init(nsim_dev);
 	if (err)
 		goto err_psample_exit;
 
+	err = nsim_dev_port_add_all(nsim_dev, nsim_bus_dev->port_count);
+	if (err)
+		goto err_hwstats_exit;
+
 	nsim_dev->esw_mode = DEVLINK_ESWITCH_MODE_LEGACY;
 	devlink_set_features(devlink, DEVLINK_F_RELOAD);
 	devlink_register(devlink);
 	return 0;
 
+err_hwstats_exit:
+	nsim_dev_hwstats_exit(nsim_dev);
 err_psample_exit:
 	nsim_dev_psample_exit(nsim_dev);
 err_bpf_dev_exit:
@@ -1648,6 +1660,7 @@ static void nsim_dev_reload_destroy(struct nsim_dev *nsim_dev)
 	mutex_unlock(&nsim_dev->vfs_lock);
 
 	nsim_dev_port_del_all(nsim_dev);
+	nsim_dev_hwstats_exit(nsim_dev);
 	nsim_dev_psample_exit(nsim_dev);
 	nsim_dev_health_exit(nsim_dev);
 	nsim_fib_destroy(devlink, nsim_dev->fib_data);
diff --git a/drivers/net/netdevsim/hwstats.c b/drivers/net/netdevsim/hwstats.c
new file mode 100644
index 000000000000..451da191a17f
--- /dev/null
+++ b/drivers/net/netdevsim/hwstats.c
@@ -0,0 +1,485 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/debugfs.h>
+
+#include "netdevsim.h"
+
+#define NSIM_DEV_HWSTATS_TRAFFIC_MS	100
+
+static struct list_head *
+nsim_dev_hwstats_get_list_head(struct nsim_dev_hwstats *hwstats,
+			       enum netdev_offload_xstats_type type)
+{
+	switch (type) {
+	case NETDEV_OFFLOAD_XSTATS_TYPE_L3:
+		return &hwstats->l3_list;
+	}
+
+	WARN_ON_ONCE(1);
+	return NULL;
+}
+
+static void nsim_dev_hwstats_traffic_bump(struct nsim_dev_hwstats *hwstats,
+					  enum netdev_offload_xstats_type type)
+{
+	struct nsim_dev_hwstats_netdev *hwsdev;
+	struct list_head *hwsdev_list;
+
+	hwsdev_list = nsim_dev_hwstats_get_list_head(hwstats, type);
+	if (WARN_ON(!hwsdev_list))
+		return;
+
+	list_for_each_entry(hwsdev, hwsdev_list, list) {
+		if (hwsdev->enabled) {
+			hwsdev->stats.rx_packets += 1;
+			hwsdev->stats.tx_packets += 2;
+			hwsdev->stats.rx_bytes += 100;
+			hwsdev->stats.tx_bytes += 300;
+		}
+	}
+}
+
+static void nsim_dev_hwstats_traffic_work(struct work_struct *work)
+{
+	struct nsim_dev_hwstats *hwstats;
+
+	hwstats = container_of(work, struct nsim_dev_hwstats, traffic_dw.work);
+	mutex_lock(&hwstats->hwsdev_list_lock);
+	nsim_dev_hwstats_traffic_bump(hwstats, NETDEV_OFFLOAD_XSTATS_TYPE_L3);
+	mutex_unlock(&hwstats->hwsdev_list_lock);
+
+	schedule_delayed_work(&hwstats->traffic_dw,
+			      msecs_to_jiffies(NSIM_DEV_HWSTATS_TRAFFIC_MS));
+}
+
+static struct nsim_dev_hwstats_netdev *
+nsim_dev_hwslist_find_hwsdev(struct list_head *hwsdev_list,
+			     int ifindex)
+{
+	struct nsim_dev_hwstats_netdev *hwsdev;
+
+	list_for_each_entry(hwsdev, hwsdev_list, list) {
+		if (hwsdev->netdev->ifindex == ifindex)
+			return hwsdev;
+	}
+
+	return NULL;
+}
+
+static int nsim_dev_hwsdev_enable(struct nsim_dev_hwstats_netdev *hwsdev,
+				  struct netlink_ext_ack *extack)
+{
+	if (hwsdev->fail_enable) {
+		hwsdev->fail_enable = false;
+		NL_SET_ERR_MSG_MOD(extack, "Stats enablement set to fail");
+		return -ECANCELED;
+	}
+
+	hwsdev->enabled = true;
+	return 0;
+}
+
+static void nsim_dev_hwsdev_disable(struct nsim_dev_hwstats_netdev *hwsdev)
+{
+	hwsdev->enabled = false;
+	memset(&hwsdev->stats, 0, sizeof(hwsdev->stats));
+}
+
+static int
+nsim_dev_hwsdev_report_delta(struct nsim_dev_hwstats_netdev *hwsdev,
+			     struct netdev_notifier_offload_xstats_info *info)
+{
+	netdev_offload_xstats_report_delta(info->report_delta, &hwsdev->stats);
+	memset(&hwsdev->stats, 0, sizeof(hwsdev->stats));
+	return 0;
+}
+
+static void
+nsim_dev_hwsdev_report_used(struct nsim_dev_hwstats_netdev *hwsdev,
+			    struct netdev_notifier_offload_xstats_info *info)
+{
+	if (hwsdev->enabled)
+		netdev_offload_xstats_report_used(info->report_used);
+}
+
+static int nsim_dev_hwstats_event_off_xstats(struct nsim_dev_hwstats *hwstats,
+					     struct net_device *dev,
+					     unsigned long event, void *ptr)
+{
+	struct netdev_notifier_offload_xstats_info *info;
+	struct nsim_dev_hwstats_netdev *hwsdev;
+	struct list_head *hwsdev_list;
+	int err = 0;
+
+	info = ptr;
+	hwsdev_list = nsim_dev_hwstats_get_list_head(hwstats, info->type);
+	if (!hwsdev_list)
+		return 0;
+
+	mutex_lock(&hwstats->hwsdev_list_lock);
+
+	hwsdev = nsim_dev_hwslist_find_hwsdev(hwsdev_list, dev->ifindex);
+	if (!hwsdev)
+		goto out;
+
+	switch (event) {
+	case NETDEV_OFFLOAD_XSTATS_ENABLE:
+		err = nsim_dev_hwsdev_enable(hwsdev, info->info.extack);
+		break;
+	case NETDEV_OFFLOAD_XSTATS_DISABLE:
+		nsim_dev_hwsdev_disable(hwsdev);
+		break;
+	case NETDEV_OFFLOAD_XSTATS_REPORT_USED:
+		nsim_dev_hwsdev_report_used(hwsdev, info);
+		break;
+	case NETDEV_OFFLOAD_XSTATS_REPORT_DELTA:
+		err = nsim_dev_hwsdev_report_delta(hwsdev, info);
+		break;
+	}
+
+out:
+	mutex_unlock(&hwstats->hwsdev_list_lock);
+	return err;
+}
+
+static void nsim_dev_hwsdev_fini(struct nsim_dev_hwstats_netdev *hwsdev)
+{
+	dev_put(hwsdev->netdev);
+	kfree(hwsdev);
+}
+
+static void
+__nsim_dev_hwstats_event_unregister(struct nsim_dev_hwstats *hwstats,
+				    struct net_device *dev,
+				    enum netdev_offload_xstats_type type)
+{
+	struct nsim_dev_hwstats_netdev *hwsdev;
+	struct list_head *hwsdev_list;
+
+	hwsdev_list = nsim_dev_hwstats_get_list_head(hwstats, type);
+	if (WARN_ON(!hwsdev_list))
+		return;
+
+	hwsdev = nsim_dev_hwslist_find_hwsdev(hwsdev_list, dev->ifindex);
+	if (!hwsdev)
+		return;
+
+	list_del(&hwsdev->list);
+	nsim_dev_hwsdev_fini(hwsdev);
+}
+
+static void nsim_dev_hwstats_event_unregister(struct nsim_dev_hwstats *hwstats,
+					      struct net_device *dev)
+{
+	mutex_lock(&hwstats->hwsdev_list_lock);
+	__nsim_dev_hwstats_event_unregister(hwstats, dev,
+					    NETDEV_OFFLOAD_XSTATS_TYPE_L3);
+	mutex_unlock(&hwstats->hwsdev_list_lock);
+}
+
+static int nsim_dev_hwstats_event(struct nsim_dev_hwstats *hwstats,
+				  struct net_device *dev,
+				  unsigned long event, void *ptr)
+{
+	switch (event) {
+	case NETDEV_OFFLOAD_XSTATS_ENABLE:
+	case NETDEV_OFFLOAD_XSTATS_DISABLE:
+	case NETDEV_OFFLOAD_XSTATS_REPORT_USED:
+	case NETDEV_OFFLOAD_XSTATS_REPORT_DELTA:
+		return nsim_dev_hwstats_event_off_xstats(hwstats, dev,
+							 event, ptr);
+	case NETDEV_UNREGISTER:
+		nsim_dev_hwstats_event_unregister(hwstats, dev);
+		break;
+	}
+
+	return 0;
+}
+
+static int nsim_dev_netdevice_event(struct notifier_block *nb,
+				    unsigned long event, void *ptr)
+{
+	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
+	struct nsim_dev_hwstats *hwstats;
+	int err = 0;
+
+	hwstats = container_of(nb, struct nsim_dev_hwstats, netdevice_nb);
+	err = nsim_dev_hwstats_event(hwstats, dev, event, ptr);
+	if (err)
+		return notifier_from_errno(err);
+
+	return NOTIFY_OK;
+}
+
+static int
+nsim_dev_hwstats_enable_ifindex(struct nsim_dev_hwstats *hwstats,
+				int ifindex,
+				enum netdev_offload_xstats_type type,
+				struct list_head *hwsdev_list)
+{
+	struct nsim_dev_hwstats_netdev *hwsdev;
+	struct nsim_dev *nsim_dev;
+	struct net_device *netdev;
+	bool notify = false;
+	struct net *net;
+	int err = 0;
+
+	nsim_dev = container_of(hwstats, struct nsim_dev, hwstats);
+	net = nsim_dev_net(nsim_dev);
+
+	rtnl_lock();
+	mutex_lock(&hwstats->hwsdev_list_lock);
+	hwsdev = nsim_dev_hwslist_find_hwsdev(hwsdev_list, ifindex);
+	if (hwsdev)
+		goto out_unlock_list;
+
+	netdev = dev_get_by_index(net, ifindex);
+	if (!netdev) {
+		err = -ENODEV;
+		goto out_unlock_list;
+	}
+
+	hwsdev = kzalloc(sizeof(*hwsdev), GFP_KERNEL);
+	if (!hwsdev) {
+		err = -ENOMEM;
+		goto out_put_netdev;
+	}
+
+	hwsdev->netdev = netdev;
+	list_add_tail(&hwsdev->list, hwsdev_list);
+	mutex_unlock(&hwstats->hwsdev_list_lock);
+
+	if (netdev_offload_xstats_enabled(netdev, type)) {
+		nsim_dev_hwsdev_enable(hwsdev, NULL);
+		notify = true;
+	}
+
+	if (notify)
+		rtnl_offload_xstats_notify(netdev);
+	rtnl_unlock();
+	return err;
+
+out_put_netdev:
+	dev_put(netdev);
+out_unlock_list:
+	mutex_unlock(&hwstats->hwsdev_list_lock);
+	rtnl_unlock();
+	return err;
+}
+
+static int
+nsim_dev_hwstats_disable_ifindex(struct nsim_dev_hwstats *hwstats,
+				 int ifindex,
+				 enum netdev_offload_xstats_type type,
+				 struct list_head *hwsdev_list)
+{
+	struct nsim_dev_hwstats_netdev *hwsdev;
+	int err = 0;
+
+	rtnl_lock();
+	mutex_lock(&hwstats->hwsdev_list_lock);
+	hwsdev = nsim_dev_hwslist_find_hwsdev(hwsdev_list, ifindex);
+	if (hwsdev)
+		list_del(&hwsdev->list);
+	mutex_unlock(&hwstats->hwsdev_list_lock);
+
+	if (!hwsdev) {
+		err = -ENOENT;
+		goto unlock_out;
+	}
+
+	if (netdev_offload_xstats_enabled(hwsdev->netdev, type)) {
+		netdev_offload_xstats_push_delta(hwsdev->netdev, type,
+						 &hwsdev->stats);
+		rtnl_offload_xstats_notify(hwsdev->netdev);
+	}
+	nsim_dev_hwsdev_fini(hwsdev);
+
+unlock_out:
+	rtnl_unlock();
+	return err;
+}
+
+static int
+nsim_dev_hwstats_fail_ifindex(struct nsim_dev_hwstats *hwstats,
+			      int ifindex,
+			      enum netdev_offload_xstats_type type,
+			      struct list_head *hwsdev_list)
+{
+	struct nsim_dev_hwstats_netdev *hwsdev;
+	int err = 0;
+
+	mutex_lock(&hwstats->hwsdev_list_lock);
+
+	hwsdev = nsim_dev_hwslist_find_hwsdev(hwsdev_list, ifindex);
+	if (!hwsdev) {
+		err = -ENOENT;
+		goto err_hwsdev_list_unlock;
+	}
+
+	hwsdev->fail_enable = true;
+
+err_hwsdev_list_unlock:
+	mutex_unlock(&hwstats->hwsdev_list_lock);
+	return err;
+}
+
+enum nsim_dev_hwstats_do {
+	NSIM_DEV_HWSTATS_DO_DISABLE,
+	NSIM_DEV_HWSTATS_DO_ENABLE,
+	NSIM_DEV_HWSTATS_DO_FAIL,
+};
+
+struct nsim_dev_hwstats_fops {
+	const struct file_operations fops;
+	enum nsim_dev_hwstats_do action;
+	enum netdev_offload_xstats_type type;
+};
+
+static ssize_t
+nsim_dev_hwstats_do_write(struct file *file,
+			  const char __user *data,
+			  size_t count, loff_t *ppos)
+{
+	struct nsim_dev_hwstats *hwstats = file->private_data;
+	struct nsim_dev_hwstats_fops *hwsfops;
+	struct list_head *hwsdev_list;
+	int ifindex;
+	int err;
+
+	hwsfops = container_of(debugfs_real_fops(file),
+			       struct nsim_dev_hwstats_fops, fops);
+
+	err = kstrtoint_from_user(data, count, 0, &ifindex);
+	if (err)
+		return err;
+
+	hwsdev_list = nsim_dev_hwstats_get_list_head(hwstats, hwsfops->type);
+	if (WARN_ON(!hwsdev_list))
+		return -EINVAL;
+
+	switch (hwsfops->action) {
+	case NSIM_DEV_HWSTATS_DO_DISABLE:
+		err = nsim_dev_hwstats_disable_ifindex(hwstats, ifindex,
+						       hwsfops->type,
+						       hwsdev_list);
+		break;
+	case NSIM_DEV_HWSTATS_DO_ENABLE:
+		err = nsim_dev_hwstats_enable_ifindex(hwstats, ifindex,
+						      hwsfops->type,
+						      hwsdev_list);
+		break;
+	case NSIM_DEV_HWSTATS_DO_FAIL:
+		err = nsim_dev_hwstats_fail_ifindex(hwstats, ifindex,
+						    hwsfops->type,
+						    hwsdev_list);
+		break;
+	}
+	if (err)
+		return err;
+
+	return count;
+}
+
+static const struct file_operations nsim_dev_hwstats_generic_fops = {
+	.open = simple_open,
+	.write = nsim_dev_hwstats_do_write,
+	.llseek = generic_file_llseek,
+	.owner = THIS_MODULE,
+};
+
+static const struct nsim_dev_hwstats_fops nsim_dev_hwstats_l3_disable_fops = {
+	.fops = nsim_dev_hwstats_generic_fops,
+	.action = NSIM_DEV_HWSTATS_DO_DISABLE,
+	.type = NETDEV_OFFLOAD_XSTATS_TYPE_L3,
+};
+
+static const struct nsim_dev_hwstats_fops nsim_dev_hwstats_l3_enable_fops = {
+	.fops = nsim_dev_hwstats_generic_fops,
+	.action = NSIM_DEV_HWSTATS_DO_ENABLE,
+	.type = NETDEV_OFFLOAD_XSTATS_TYPE_L3,
+};
+
+static const struct nsim_dev_hwstats_fops nsim_dev_hwstats_l3_fail_fops = {
+	.fops = nsim_dev_hwstats_generic_fops,
+	.action = NSIM_DEV_HWSTATS_DO_FAIL,
+	.type = NETDEV_OFFLOAD_XSTATS_TYPE_L3,
+};
+
+int nsim_dev_hwstats_init(struct nsim_dev *nsim_dev)
+{
+	struct nsim_dev_hwstats *hwstats = &nsim_dev->hwstats;
+	struct net *net = nsim_dev_net(nsim_dev);
+	int err;
+
+	mutex_init(&hwstats->hwsdev_list_lock);
+	INIT_LIST_HEAD(&hwstats->l3_list);
+
+	hwstats->netdevice_nb.notifier_call = nsim_dev_netdevice_event;
+	err = register_netdevice_notifier_net(net, &hwstats->netdevice_nb);
+	if (err)
+		goto err_mutex_destroy;
+
+	hwstats->ddir = debugfs_create_dir("hwstats", nsim_dev->ddir);
+	if (IS_ERR(hwstats->ddir)) {
+		err = PTR_ERR(hwstats->ddir);
+		goto err_unregister_notifier;
+	}
+
+	hwstats->l3_ddir = debugfs_create_dir("l3", hwstats->ddir);
+	if (IS_ERR(hwstats->l3_ddir)) {
+		err = PTR_ERR(hwstats->l3_ddir);
+		goto err_remove_hwstats_recursive;
+	}
+
+	debugfs_create_file("enable_ifindex", 0600, hwstats->l3_ddir, hwstats,
+			    &nsim_dev_hwstats_l3_enable_fops.fops);
+	debugfs_create_file("disable_ifindex", 0600, hwstats->l3_ddir, hwstats,
+			    &nsim_dev_hwstats_l3_disable_fops.fops);
+	debugfs_create_file("fail_next_enable", 0600, hwstats->l3_ddir, hwstats,
+			    &nsim_dev_hwstats_l3_fail_fops.fops);
+
+	INIT_DELAYED_WORK(&hwstats->traffic_dw,
+			  &nsim_dev_hwstats_traffic_work);
+	schedule_delayed_work(&hwstats->traffic_dw,
+			      msecs_to_jiffies(NSIM_DEV_HWSTATS_TRAFFIC_MS));
+	return 0;
+
+err_remove_hwstats_recursive:
+	debugfs_remove_recursive(hwstats->ddir);
+err_unregister_notifier:
+	unregister_netdevice_notifier_net(net, &hwstats->netdevice_nb);
+err_mutex_destroy:
+	mutex_destroy(&hwstats->hwsdev_list_lock);
+	return err;
+}
+
+static void nsim_dev_hwsdev_list_wipe(struct nsim_dev_hwstats *hwstats,
+				      enum netdev_offload_xstats_type type)
+{
+	struct nsim_dev_hwstats_netdev *hwsdev, *tmp;
+	struct list_head *hwsdev_list;
+
+	hwsdev_list = nsim_dev_hwstats_get_list_head(hwstats, type);
+	if (WARN_ON(!hwsdev_list))
+		return;
+
+	mutex_lock(&hwstats->hwsdev_list_lock);
+	list_for_each_entry_safe(hwsdev, tmp, hwsdev_list, list) {
+		list_del(&hwsdev->list);
+		nsim_dev_hwsdev_fini(hwsdev);
+	}
+	mutex_unlock(&hwstats->hwsdev_list_lock);
+}
+
+void nsim_dev_hwstats_exit(struct nsim_dev *nsim_dev)
+{
+	struct nsim_dev_hwstats *hwstats = &nsim_dev->hwstats;
+	struct net *net = nsim_dev_net(nsim_dev);
+
+	cancel_delayed_work_sync(&hwstats->traffic_dw);
+	debugfs_remove_recursive(hwstats->ddir);
+	unregister_netdevice_notifier_net(net, &hwstats->netdevice_nb);
+	nsim_dev_hwsdev_list_wipe(hwstats, NETDEV_OFFLOAD_XSTATS_TYPE_L3);
+	mutex_destroy(&hwstats->hwsdev_list_lock);
+}
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index c49771f27f17..128f229d9b4d 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -184,6 +184,28 @@ struct nsim_dev_health {
 int nsim_dev_health_init(struct nsim_dev *nsim_dev, struct devlink *devlink);
 void nsim_dev_health_exit(struct nsim_dev *nsim_dev);
 
+struct nsim_dev_hwstats_netdev {
+	struct list_head list;
+	struct net_device *netdev;
+	struct rtnl_hw_stats64 stats;
+	bool enabled;
+	bool fail_enable;
+};
+
+struct nsim_dev_hwstats {
+	struct dentry *ddir;
+	struct dentry *l3_ddir;
+
+	struct mutex hwsdev_list_lock; /* protects hwsdev list(s) */
+	struct list_head l3_list;
+
+	struct notifier_block netdevice_nb;
+	struct delayed_work traffic_dw;
+};
+
+int nsim_dev_hwstats_init(struct nsim_dev *nsim_dev);
+void nsim_dev_hwstats_exit(struct nsim_dev *nsim_dev);
+
 #if IS_ENABLED(CONFIG_PSAMPLE)
 int nsim_dev_psample_init(struct nsim_dev *nsim_dev);
 void nsim_dev_psample_exit(struct nsim_dev *nsim_dev);
@@ -261,6 +283,7 @@ struct nsim_dev {
 	bool fail_reload;
 	struct devlink_region *dummy_region;
 	struct nsim_dev_health health;
+	struct nsim_dev_hwstats hwstats;
 	struct flow_action_cookie *fa_cookie;
 	spinlock_t fa_cookie_lock; /* protects fa_cookie */
 	bool fail_trap_group_set;
-- 
2.31.1

