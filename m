Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C103C4D865B
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 15:02:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233883AbiCNODS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 10:03:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242067AbiCNODN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 10:03:13 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2064.outbound.protection.outlook.com [40.107.94.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A15E73D4A4
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 07:02:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MX9xt5uDPchWQCBAoTOXqV1tD58ntr/VsFvAZ4szXzovMlGYtP1i7pny7yLIUerLcAu8fzYSGZgVnAwRoekUwpzY9FlQnw2w6QmWnVD7cmX4gRSgZwRhCG0rkDp82pSsL8C7VmFrLfhhFzzyCTLp4OGNfjflDUGlZqAnH+hTCDEszgLBqr8GdeBtg1eQ/iDII7P+L6mqZzY/GZsqXqbh6cQJe9x1abhqU3nqQIcbJ4CITACQbOjRRv04/BA9xhBtpuuZWoLbc02F6LgYagNW+V31q7LBHFN0Y7prOIZT2AzoyjKmxm30Ikq/2cddPWfS7JD39L3wyJRaGMlV+cPK8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i6xvBl2rIIVP9+o4vUs2g2iyr0bTrRzX0RhNO96ttPw=;
 b=RhPrRf/fKcUtJ6oSHpszwT0sYdypNv+LawMM2Zf2ZrzqrhCtx3y2qR1H6Lv4uAKcfMsI2Od3BDXzzTR9HeLjJqGea54KRYcV9LghPoK54radWyvqeNwh6J6iMATn6+YmWoGgMMIlNVJzTkbQtruoJfwtYzxsb/7kC3UsM0Pt7APpKxIH4fRM+Lz51cRH0GGSuSO3kvwbh+8mMKKkuHelFCosWkgcyTVnUsrNV6xvaXXq23jfe1LvOjXg2UCuISr091zc8GHxi+TYEf1AwTEPMZNaV4mTCNKV3UlVmgSQa3evzV+usMaaGvUsAHm8F8F/hmXtqaurLo21M1P+hiTY0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i6xvBl2rIIVP9+o4vUs2g2iyr0bTrRzX0RhNO96ttPw=;
 b=aOtwg9VLk/Hl7LmxwUcTNqzJ+MsKbpP1o0C85F3xhn/Gwi+8HhONZzh+ndkqC3oeR9ixvMWQjv6O6vJVKKuDizlLCGYceyyorjlvYGmTqy+B8lGHsAd6bU68s1X9STRsOyPzbBvJ2i/7Z9OlbeYFMzpAEnca9IR0s/HjgiRpdeMinMfEtiAIlihZyAA56oXkceTQIeTMtKkQMCASbHdh4DuqK+EIbhFjdffHIk/XaLYj1h65+IeDIUfpaGAS4Y+wOaVeIsUqMp8e6ulsXVTKWd124tcqK5RIetL4NWP/UPu+0/9t57FiXMLQ+SqHpFnFJbd9cgseYJmzOFO/YUtoyA==
Received: from DM5PR13CA0070.namprd13.prod.outlook.com (2603:10b6:3:117::32)
 by CH0PR12MB5044.namprd12.prod.outlook.com (2603:10b6:610:e3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.22; Mon, 14 Mar
 2022 14:02:00 +0000
Received: from DM6NAM11FT011.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:117:cafe::5a) by DM5PR13CA0070.outlook.office365.com
 (2603:10b6:3:117::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.7 via Frontend
 Transport; Mon, 14 Mar 2022 14:02:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT011.mail.protection.outlook.com (10.13.172.108) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5061.22 via Frontend Transport; Mon, 14 Mar 2022 14:02:00 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Mon, 14 Mar
 2022 14:01:42 +0000
Received: from localhost.localdomain (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Mon, 14 Mar
 2022 07:01:39 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH net-next v3 1/3] netdevsim: Introduce support for L3 offload xstats
Date:   Mon, 14 Mar 2022 15:01:15 +0100
Message-ID: <fa28d4ff7f55fec4928990850dc1abf8fac3eb45.1647265833.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1647265833.git.petrm@nvidia.com>
References: <cover.1647265833.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a20161d5-e5c0-4ee9-9a98-08da05c335c7
X-MS-TrafficTypeDiagnostic: CH0PR12MB5044:EE_
X-Microsoft-Antispam-PRVS: <CH0PR12MB5044DB70F6211F2B97F2A2C8D60F9@CH0PR12MB5044.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ctYbqkq5LdsMcCX0ZizQVrx4dx24kyBcVtCDgAa3dA4WoMNa4j8TY8D58ogbIp3ZRblDwsmxj8M8G3Jto8vXL5bOA9oa/FZ5ddM0fN/UYAxcEbmVFwHhU2mRD3PS+RoeyErJQbkx7PAwBAn6N1hkRPNYpAFUw2gK4anebhL6ZCQUK2dQraIAzZdaoeFpY1BntK850h2Kix2gWggKUhKYrd3V9f8RTdG6kbz09+kGKPGnqCc63nBy08auzjuavodDK5+3ov3jZAnJKb3B76Vh+zf1MzvH+qHuXfhUosQe6n2zwHpTnlXPhQKJ4TwylajeCl1erw5dwSd7Kom3qXzU1+h6dGkldvQjP/LLWpsw//LShMXnbRF5whL8Osm8g33gAqflRLurAorKUYlvoGRBtDZEy4FHBRb1gSCdd4U+1WCv8jV5ohkiq+J5UAWlLpScXErWdXA/aX/dwvPMzyxsO8Y54RS/VL8ju/Py4tDZFpLmoyG2Dtt6kTGcsZ0K25H8BZZ0DGM3+cWkUiYGeLfO62bajaFFB01gXsMe7IieU9vVIoB6r4QA2/MHTnKJ2wjitfzUcAYvsHg+W+iTvhORqSZn0Q951jPDN1iech15mxY/Fe0kn3iqNe48MMCR4PLfsBrRM1qeXo0zMyV26oM00gZ3LI68qbu7wO3y+BjyVHzxXUWgxI1Xni0xMJUaZPLlRlda+h3empcnuE/xuZXrxg==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(81166007)(356005)(82310400004)(107886003)(36860700001)(2616005)(316002)(426003)(336012)(508600001)(8676002)(4326008)(70586007)(70206006)(26005)(186003)(16526019)(83380400001)(36756003)(2906002)(30864003)(5660300002)(54906003)(47076005)(86362001)(40460700003)(8936002)(6916009)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2022 14:02:00.4131
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a20161d5-e5c0-4ee9-9a98-08da05c335c7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT011.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5044
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
    v3:
    - Rewrite the fops definitions as macros. clang didn't like the
      previous approach to reducing redundancy.
    
    v2:
    - Embed fops into a structure that carries the necessary metadata
      together with the fops. Extract the data in the generic write
      handler to determine what debugfs file the op pertains to. This
      obviates the need to have a per-debugfs file helper wrapper.

 drivers/net/netdevsim/Makefile    |   2 +-
 drivers/net/netdevsim/dev.c       |  17 +-
 drivers/net/netdevsim/hwstats.c   | 486 ++++++++++++++++++++++++++++++
 drivers/net/netdevsim/netdevsim.h |  23 ++
 4 files changed, 525 insertions(+), 3 deletions(-)
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
index 000000000000..605a38e16db0
--- /dev/null
+++ b/drivers/net/netdevsim/hwstats.c
@@ -0,0 +1,486 @@
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
+#define NSIM_DEV_HWSTATS_FOPS(ACTION, TYPE)			\
+	{							\
+		.fops = {					\
+			.open = simple_open,			\
+			.write = nsim_dev_hwstats_do_write,	\
+			.llseek = generic_file_llseek,		\
+			.owner = THIS_MODULE,			\
+		},						\
+		.action = ACTION,				\
+		.type = TYPE,					\
+	}
+
+static const struct nsim_dev_hwstats_fops nsim_dev_hwstats_l3_disable_fops =
+	NSIM_DEV_HWSTATS_FOPS(NSIM_DEV_HWSTATS_DO_DISABLE,
+			      NETDEV_OFFLOAD_XSTATS_TYPE_L3);
+
+static const struct nsim_dev_hwstats_fops nsim_dev_hwstats_l3_enable_fops =
+	NSIM_DEV_HWSTATS_FOPS(NSIM_DEV_HWSTATS_DO_ENABLE,
+			      NETDEV_OFFLOAD_XSTATS_TYPE_L3);
+
+static const struct nsim_dev_hwstats_fops nsim_dev_hwstats_l3_fail_fops =
+	NSIM_DEV_HWSTATS_FOPS(NSIM_DEV_HWSTATS_DO_FAIL,
+			      NETDEV_OFFLOAD_XSTATS_TYPE_L3);
+
+#undef NSIM_DEV_HWSTATS_FOPS
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

