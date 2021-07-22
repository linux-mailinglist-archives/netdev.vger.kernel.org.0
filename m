Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 911D63D226E
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 13:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231736AbhGVKYb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 06:24:31 -0400
Received: from mail-bn7nam10on2079.outbound.protection.outlook.com ([40.107.92.79]:31840
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231728AbhGVKYU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 06:24:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lQ9VnAcjc7Le7SVT3wP8L5PcvxTHvRMj9g6SQ3TR2wAFYHdr82Eso94U0v1Ro2vCWHHUWrl9wp3TWC7CbEWOJpm5fjBbTgI+LnqTMF4TVIyukwgUdDkPlMYV0XfhTiHCE1A55gQPeCwVnGL2rbmAl27XNrHHnrdytj13Ordnn5QW4dbZp/Jd7XCJWBeNC14vaSNW908nooc+PGCY1aM8GX781WJ2/MpaSF3/xsu6OVdJbhd3J52/WMWGM56BX3b1q4lu+J8sTcZYWc8IJR2tgIgDjivPopEW4H29xMu8RgHNnDMSvwex0NVFoD3RowYfyt3/WJ2LIFIRhNSQvHCM9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pOFQTho0/UFbIeyik9Lh2h8iIZLpT3ZqHVJkQmyPnjE=;
 b=njSUriBVG+cUBww/w6xZ8Q5uLXLlhnI675EA/TwkvDu4phxR/uQ3kClTzCx+FWwcbNhH+DUxQU3OCdPm60MKo8734kisAMh0I8BHNt1y/TK2hdKlEPHoPWKMJGgw5giQZ4eh8CA7Qfbc1gq/LMBvGIKNDehqmCDdAfqeeTYsYw1ry+LHgrRjlPsJIPZQeEYMT6Jn1R+w1E7q8gTHev8Rj4HuoF/7h4pUPQ+0DpZ6TUvvPjCh3573kynCYVdYU4dWZuNUspAODEuLGk1bQDkvay2dIg4Hvq9AVgrUBXZH+SVvE3WVzO1nDqWhrmjz5kAXyRKJWC8cQtCDw0nCZ6yF/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=marvell.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pOFQTho0/UFbIeyik9Lh2h8iIZLpT3ZqHVJkQmyPnjE=;
 b=O3CDVlCvlUeiwhE2loHhavwwoeEjwkZaFdmwvhi+qzqR14ApGjppYaFjhA96G++iAuCM2iMUHJjjjfhJgMK55E6BXvKSU4+jo50/aFopgQOdZZ4n6ENdwDoDVkeomNmoNM0loVaX7Psf7iHvnLrLRYj8LLhqto3d96bWRZ15zAJsBx16QCKAIkK65Z0liGtsao3JWuuoDZ0sNIXwoOUD1BeNecKoRlDNRzqzR447nJ2QqQA5oJLlxE62+rWmJX+B24Dr8Wm/nPGEyJGX2VXMm5YYr0NE6DfWw51AoCQMuFHuQETSiOqMk4oPkDJnwoqhvUV63NEpCFi/leiW5MYplQ==
Received: from DM6PR11CA0062.namprd11.prod.outlook.com (2603:10b6:5:14c::39)
 by MN2PR12MB3773.namprd12.prod.outlook.com (2603:10b6:208:164::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.26; Thu, 22 Jul
 2021 11:04:54 +0000
Received: from DM6NAM11FT030.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:14c:cafe::a8) by DM6PR11CA0062.outlook.office365.com
 (2603:10b6:5:14c::39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26 via Frontend
 Transport; Thu, 22 Jul 2021 11:04:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT030.mail.protection.outlook.com (10.13.172.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4352.24 via Frontend Transport; Thu, 22 Jul 2021 11:04:53 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 22 Jul
 2021 11:04:52 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 22 Jul 2021 11:04:48 +0000
From:   Boris Pismenny <borisp@nvidia.com>
To:     <dsahern@gmail.com>, <kuba@kernel.org>, <davem@davemloft.net>,
        <saeedm@nvidia.com>, <hch@lst.de>, <sagi@grimberg.me>,
        <axboe@fb.com>, <kbusch@kernel.org>, <viro@zeniv.linux.org.uk>,
        <edumazet@google.com>, <smalin@marvell.com>
CC:     <boris.pismenny@gmail.com>, <linux-nvme@lists.infradead.org>,
        <netdev@vger.kernel.org>, <benishay@nvidia.com>,
        <ogerlitz@nvidia.com>, <yorayz@nvidia.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Ben Ben-Ishay <benishay@mellanox.com>,
        Yoray Zack <yorayz@mellanox.com>
Subject: [PATCH v5 net-next 08/36] nvme-tcp: Deal with netdevice DOWN events
Date:   Thu, 22 Jul 2021 14:02:57 +0300
Message-ID: <20210722110325.371-9-borisp@nvidia.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210722110325.371-1-borisp@nvidia.com>
References: <20210722110325.371-1-borisp@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: de370a7b-bcab-4044-804e-08d94d0088b9
X-MS-TrafficTypeDiagnostic: MN2PR12MB3773:
X-Microsoft-Antispam-PRVS: <MN2PR12MB3773480215F562096D344F74BDE49@MN2PR12MB3773.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kNfDs4fpORv5TnLYYXtq3JJUpnBgCGyGRqg1X8fvpA/othpzbl6i8LYj1XcVdYIUI/gk9cKJ3xwZ7+dABvvPCjRUynmDRjSYcrmc/baEIm3ksSd0ifrGywOrQI5nLDmuN5j5C00eSKG79O/h37uAMTNF5f4XymTJpqW1fRNsIXJeIT/omh3DCyWj+qwwU6Q6e/M7heQnpdwzHCJMi2DngGvuKpnvPvBQTg+F9+XToXozCNqJFHepYHnTQnV3k15iU0DxgKJcYmDax4BMUPHiOQpAi0dHNbsiCUqBT8eu9hcseC+1EDpn4yl+kAqMi67SKTKDGyMW0oLLSCrAZx+IAHguPik76BtryPwVj1+vEPQ2HpErSIHkWbfL9yxwQtV+uPqRGtplAF9Q7QeMQVbLclAe0emtrv40GnWQUE98uoCOz9ZYybe4Ui+kaQH5g4jtLJCKjfyBQn1wyh2fYtXtUiXBOxAP5+YxN0Oose5o4qv94HZulI+oaGe9pQg/irsVNAgKAXFDY7P1R7uoCE4qLbHyh8cwA0rTBkWHTZLioU3gnfNIJSwHmqxqWO1oc+ZBY8pyqd3Tmvf6H/RtCFy8/ph5jm9OGP9RW5CZJZWiTxBwXRcCWjqWeVL03wrrsv6oF8zfcAddVgaWGDlQbSfzRLF2U9czgDcH3d7pD1fvETECI7yyRqAN3kVqpgtHDP2jGPuWy6NFwCVkGg7TNy3Drw==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(376002)(136003)(39860400002)(346002)(46966006)(36840700001)(86362001)(7696005)(26005)(921005)(2616005)(6666004)(2906002)(8936002)(5660300002)(36860700001)(426003)(82740400003)(70586007)(36906005)(70206006)(7636003)(110136005)(336012)(107886003)(478600001)(82310400003)(47076005)(83380400001)(316002)(186003)(36756003)(1076003)(54906003)(4326008)(7416002)(8676002)(356005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 11:04:53.7563
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: de370a7b-bcab-4044-804e-08d94d0088b9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT030.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3773
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Or Gerlitz <ogerlitz@mellanox.com>

For ddp setup/teardown and resync, the offloading logic
uses HW resources at the NIC driver such as SQ and CQ.

These resources are destroyed when the netdevice does down
and hence we must stop using them before the NIC driver
destroys them.

Use netdevice notifier for that matter -- offloaded connections
are stopped before the stack continues to call the NIC driver
close ndo.

We use the existing recovery flow which has the advantage
of resuming the offload once the connection is re-set.

This also buys us proper handling for the UNREGISTER event
b/c our offloading starts in the UP state, and down is always
there between up to unregister.

Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: Ben Ben-Ishay <benishay@mellanox.com>
Signed-off-by: Yoray Zack <yorayz@mellanox.com>
---
 drivers/nvme/host/tcp.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index b23fdbb4fd8b..b338cd2d9f65 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -147,6 +147,7 @@ struct nvme_tcp_ctrl {
 
 static LIST_HEAD(nvme_tcp_ctrl_list);
 static DEFINE_MUTEX(nvme_tcp_ctrl_mutex);
+static struct notifier_block nvme_tcp_netdevice_nb;
 static struct workqueue_struct *nvme_tcp_wq;
 static const struct blk_mq_ops nvme_tcp_mq_ops;
 static const struct blk_mq_ops nvme_tcp_admin_mq_ops;
@@ -2948,6 +2949,30 @@ static struct nvme_ctrl *nvme_tcp_create_ctrl(struct device *dev,
 	return ERR_PTR(ret);
 }
 
+static int nvme_tcp_netdev_event(struct notifier_block *this,
+				 unsigned long event, void *ptr)
+{
+	struct net_device *ndev = netdev_notifier_info_to_dev(ptr);
+	struct nvme_tcp_ctrl *ctrl;
+
+	switch (event) {
+	case NETDEV_GOING_DOWN:
+		mutex_lock(&nvme_tcp_ctrl_mutex);
+		list_for_each_entry(ctrl, &nvme_tcp_ctrl_list, list) {
+			if (ndev != ctrl->offloading_netdev)
+				continue;
+			nvme_tcp_error_recovery(&ctrl->ctrl);
+		}
+		mutex_unlock(&nvme_tcp_ctrl_mutex);
+		flush_workqueue(nvme_reset_wq);
+		/*
+		 * The associated controllers teardown has completed, ddp contexts
+		 * were also torn down so we should be safe to continue...
+		 */
+	}
+	return NOTIFY_DONE;
+}
+
 static struct nvmf_transport_ops nvme_tcp_transport = {
 	.name		= "tcp",
 	.module		= THIS_MODULE,
@@ -2962,13 +2987,26 @@ static struct nvmf_transport_ops nvme_tcp_transport = {
 
 static int __init nvme_tcp_init_module(void)
 {
+	int ret;
+
 	nvme_tcp_wq = alloc_workqueue("nvme_tcp_wq",
 			WQ_MEM_RECLAIM | WQ_HIGHPRI, 0);
 	if (!nvme_tcp_wq)
 		return -ENOMEM;
 
+	nvme_tcp_netdevice_nb.notifier_call = nvme_tcp_netdev_event;
+	ret = register_netdevice_notifier(&nvme_tcp_netdevice_nb);
+	if (ret) {
+		pr_err("failed to register netdev notifier\n");
+		goto out_err_reg_notifier;
+	}
+
 	nvmf_register_transport(&nvme_tcp_transport);
 	return 0;
+
+out_err_reg_notifier:
+	destroy_workqueue(nvme_tcp_wq);
+	return ret;
 }
 
 static void __exit nvme_tcp_cleanup_module(void)
@@ -2976,6 +3014,7 @@ static void __exit nvme_tcp_cleanup_module(void)
 	struct nvme_tcp_ctrl *ctrl;
 
 	nvmf_unregister_transport(&nvme_tcp_transport);
+	unregister_netdevice_notifier(&nvme_tcp_netdevice_nb);
 
 	mutex_lock(&nvme_tcp_ctrl_mutex);
 	list_for_each_entry(ctrl, &nvme_tcp_ctrl_list, list)
-- 
2.24.1

