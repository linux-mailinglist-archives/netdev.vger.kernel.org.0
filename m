Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF403916EC
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 14:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232903AbhEZMCz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 08:02:55 -0400
Received: from mail-dm6nam11on2064.outbound.protection.outlook.com ([40.107.223.64]:22240
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232324AbhEZMCy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 08:02:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NXgdHpFWG0F4NmlIdBPyJtQEmpfbB+f7VfnRrbPlNEfYtDFDsrrtsURVrRmk9Mq/Kz4tvzcwMQlR9dZ+vBGhDWCu7WJj2ijNBPqY7h6eqZrgSJqRHlMYfUrX1NlwVaiNt2R59RdyKpnRtoZ0KcGK0N2y/VDceH256uLJo+vTba+1Z2Hc5qmpAAgrHplCCNJA+fxCqc/XmiPhyC6s97k74LzlZ/rwRO4eUdnUj0O20iGEEPHyjFEj2z/iTvUComjKCn4DebyxijMndD+33QauLbiKE5H/NDKDUGfwByGZ9y4jrIwlKNAr0yAODYosWBbM5lakGIaKepV5zf9jej5H9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uRR3KKHr4sWyA9SIvxQ0UvsB1Ur5N2+g2WqlGIxyohI=;
 b=XxkjD3Hu6VRpgzOOk5MK55Wkf2XjAUmQIZ4/87Jbe3xPYb3rDkEW/bI+jVEs+kVXsk7W34NQQW4EQ/uTyxab44Q6Q+kA8QqIhpzTv5yu1Qw/VE51RxP91/ZZlItJA95CLlS3bsASRpn6+JxbTvp23LpFBqpnIWaj/d6+60sO+KBRNLgozsQpbldJLRwcI3fj26sP0BQIj7F1Igt5L8hiufQTq6fu/97V/ku3DgJ4rn8VtKfsGSB7jlVmPQuGBQKJp1OC7r4FWTf1yB5UmQaOCvlcf53+Y3seVcq/4bda5rqcg+uAE7iLtqpMyXm045X95H/BdMxPdWgXu1uU11mYmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uRR3KKHr4sWyA9SIvxQ0UvsB1Ur5N2+g2WqlGIxyohI=;
 b=jfpEclS5gQ2ZmlDSDwz8annSvn6WmVmJHHQg/VIeYP000vnW5YYsvzYJAXNnpbcGU+1XPpi6/Y/Et1eAkNc/OMqYol9DlcR3VLYA4/fn7VufkFZKamP9L1VKSygy+CnFZB4bpvs1jJsZHGssg+v1aJ117bsnxrqZto9d/8/6dgfSG3MEn7gi5Hnkp4Omw7Es1m5xABSPtOg9h1nsOGMhgdKRHK7A+Rkm8r66AaEB7vsGKXnYKE62zfOWfdHSiswjD8TsIhbLHLRP4gsKNgcjMcxZO6lnZAip7rtF7SqVEdSaxKhYVFigX1FX0dJ28/VHY539qIyl1JIflN3Bb8jx1g==
Received: from MWHPR20CA0025.namprd20.prod.outlook.com (2603:10b6:300:ed::11)
 by CY4PR1201MB2534.namprd12.prod.outlook.com (2603:10b6:903:da::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26; Wed, 26 May
 2021 12:01:22 +0000
Received: from CO1NAM11FT030.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:ed:cafe::16) by MWHPR20CA0025.outlook.office365.com
 (2603:10b6:300:ed::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend
 Transport; Wed, 26 May 2021 12:01:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 CO1NAM11FT030.mail.protection.outlook.com (10.13.174.125) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Wed, 26 May 2021 12:01:21 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 26 May
 2021 05:01:20 -0700
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 26 May 2021 12:01:17 +0000
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <stephen@networkplumber.org>, <dsahern@gmail.com>,
        <vladbu@nvidia.com>, <parav@nvidia.com>, <huyn@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>
Subject: [PATCH RFC net-next v3 02/18] netdevsim: Disable VFs on nsim_dev_reload_destroy() call
Date:   Wed, 26 May 2021 15:00:54 +0300
Message-ID: <1622030470-21434-3-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1622030470-21434-1-git-send-email-dlinkin@nvidia.com>
References: <1622030470-21434-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d7ce88bf-c9e2-4109-4c3e-08d9203dfa89
X-MS-TrafficTypeDiagnostic: CY4PR1201MB2534:
X-Microsoft-Antispam-PRVS: <CY4PR1201MB2534A38EB2DB16807ADA0152CB249@CY4PR1201MB2534.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:469;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 42AlDP9TL4FY5JO2kfQ2Lt+uSQen9k+vHYXbKbKpEqrpPofQnM9Q9YutVoCVljE5NAvL+U+ZmwS/tLbkVtCfmAvMUDDdRB6rCfTHtWZiKHGehQqr37pP9ZB6AguA+cXj3LSwnOPZ7D9DgZJzdu5/gEV+Us6qMBx/J3XDzWtPC/KY9ePBkmMP1Srk0HFs89rpcNBYb3Q/ghaOUj2I1zE3isVtLWaJfGKtciPbCgNpLD6540fHUQ9BsjvPnSx7FcpHDfpgZiHQZ/mGOBQG18+hygkG+CRz4gLJInKrH7/tzOHlCQlvlgyicjFHyg51VrHKQR2lQ4DBcRGFnNQSzFLIct9R4qTudoRNmx4XR9g7m5gEXRHu5bm0X/HCGc3l5YRyvGT+Ovz4TyXO6tBFgphoEA/YVQk76FfrP6eU9w/QMWNe2YTgsUvzULBdfSrFN96ftSQ37nk0iP6EmaNOSwoJ1p5sypwsmKfNtpFvphioaNE/AFCkeJ4lPk3UDe6NIKfx1IOH3fccf7+M6fa3UUx433Z0rXGTnSIx8jdbAI8JZJmoYyEhsowEJbUAj28ZAxriS6nUBY9o4dZiDgfJ7+iN4tZFq2UsLWq6OsWhIsAsn+E/8nZ32cvtW4/ZmiDXhqDorJhfCMFKeMxskvv//mMeQvP/4lGyc4ph8hffLpjF9qQ=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(376002)(39860400002)(136003)(396003)(36840700001)(46966006)(70586007)(186003)(82310400003)(54906003)(7696005)(336012)(2616005)(6666004)(356005)(7636003)(316002)(4326008)(86362001)(36756003)(478600001)(26005)(83380400001)(8676002)(8936002)(47076005)(6916009)(107886003)(2906002)(82740400003)(2876002)(426003)(5660300002)(70206006)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2021 12:01:21.7052
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d7ce88bf-c9e2-4109-4c3e-08d9203dfa89
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT030.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB2534
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmytro Linkin <dlinkin@nvidia.com>

Move VFs disabling from device release() to nsim_dev_reload_destroy() to
make VFs disabling and ports removal simultaneous.
This is a requirement for VFs ports implemented in next patches.

Signed-off-by: Dmytro Linkin <dlinkin@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/netdevsim/bus.c       | 5 +----
 drivers/net/netdevsim/dev.c       | 6 ++++++
 drivers/net/netdevsim/netdevsim.h | 1 +
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/netdevsim/bus.c b/drivers/net/netdevsim/bus.c
index 4bd7ef3c..d5c547c 100644
--- a/drivers/net/netdevsim/bus.c
+++ b/drivers/net/netdevsim/bus.c
@@ -37,7 +37,7 @@ static int nsim_bus_dev_vfs_enable(struct nsim_bus_dev *nsim_bus_dev,
 	return 0;
 }
 
-static void nsim_bus_dev_vfs_disable(struct nsim_bus_dev *nsim_bus_dev)
+void nsim_bus_dev_vfs_disable(struct nsim_bus_dev *nsim_bus_dev)
 {
 	nsim_bus_dev->num_vfs = 0;
 }
@@ -233,9 +233,6 @@ ssize_t nsim_bus_dev_max_vfs_write(struct file *file,
 
 static void nsim_bus_dev_release(struct device *dev)
 {
-	struct nsim_bus_dev *nsim_bus_dev = to_nsim_bus_dev(dev);
-
-	nsim_bus_dev_vfs_disable(nsim_bus_dev);
 }
 
 static struct device_type nsim_bus_dev_type = {
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 12df93a..cd50c05 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -1182,6 +1182,12 @@ static void nsim_dev_reload_destroy(struct nsim_dev *nsim_dev)
 	if (devlink_is_reload_failed(devlink))
 		return;
 	debugfs_remove(nsim_dev->take_snapshot);
+
+	mutex_lock(&nsim_dev->nsim_bus_dev->vfs_lock);
+	if (nsim_dev->nsim_bus_dev->num_vfs)
+		nsim_bus_dev_vfs_disable(nsim_dev->nsim_bus_dev);
+	mutex_unlock(&nsim_dev->nsim_bus_dev->vfs_lock);
+
 	nsim_dev_port_del_all(nsim_dev);
 	nsim_dev_psample_exit(nsim_dev);
 	nsim_dev_health_exit(nsim_dev);
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index 12f56f2..a1b49c8 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -276,6 +276,7 @@ ssize_t nsim_bus_dev_max_vfs_read(struct file *file,
 ssize_t nsim_bus_dev_max_vfs_write(struct file *file,
 				   const char __user *data,
 				   size_t count, loff_t *ppos);
+void nsim_bus_dev_vfs_disable(struct nsim_bus_dev *nsim_bus_dev);
 
 #if IS_ENABLED(CONFIG_XFRM_OFFLOAD)
 void nsim_ipsec_init(struct netdevsim *ns);
-- 
1.8.3.1

