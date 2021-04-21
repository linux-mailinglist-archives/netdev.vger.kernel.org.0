Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97EFF366F74
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 17:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244108AbhDUPx6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 11:53:58 -0400
Received: from mail-bn8nam12on2041.outbound.protection.outlook.com ([40.107.237.41]:36320
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243720AbhDUPxt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 11:53:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TRg0dqZtL+y6neqiaUj8jxHlNi1XXqehENK1GixHEo/XX4eQmRnean5m2kYg31y17zfs8p5gpsx3Lof3AUUtWaHkPMhgkaFxF7pH5/z8og6Ex7HlxPKavQR+tU9HeknAeVOwTXlZR4qzWP0fOXqVFsbByGFUxQ40mm48oJgVBvjxF9W2QovhzrYlT7mgqfdioMWvrn+Z2f0NpPb4whzBg283GWbxoh7mIQOm1r1Jfis5BPe5eYTMknKiK149FCApgQCl7xES52YqrJInoPCr6ewX0nSpOaUHDamVSbds/5nuPr6iZXE6qFzUMfS8rhO9DqkX2rvfMOcgOhi9/GsbJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uRR3KKHr4sWyA9SIvxQ0UvsB1Ur5N2+g2WqlGIxyohI=;
 b=N98D9l/xsxz2S7up5aOIle9q6b83dma1TyP5Gkv2ihdxsMXeYVgAw8hDh+FZ8sci+hrJ+65wjSG/w5FhawrwbdUVfzYbniyLOvV+8I4jm77uMzh7rvlMDLOA2ofX95w8+bbMEZXp6bkslYhpJmc80LYmGOYrLy9nLEsEZbiU6I4IYHRipht5c9pkfUFPKU+HTJ/t1f4hdAgP3+/smuQzu5fokAAOG8obbiJPgCoLOkTwMzJHZ2htlb+JjidjSJOF8S+eyc74hOGhMxsXMhlpNtXe1CpB+0ZEsmPK3ouG3Q5qp/PZjXy4fOs9CA/3hcZ9laWlEKO9CKMk8zjW5nOeAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uRR3KKHr4sWyA9SIvxQ0UvsB1Ur5N2+g2WqlGIxyohI=;
 b=ASS2bvIf4uFTfYITdNMR5TPZIpOjNPAMnGxSF3aL8/Zf1hCSv7i0Gohv7XIDyVoaJcAdonDMUspxxneM29usNga8gF9FJt5JLlUabAYqcauHCDGKWVi2J/0pylZ0rO+nlKKY01pLxuAYLttStAc18FtEFsxrhSa2xGJ5SrptOxZ/cYNu/t8h2gIl5B7f5GJMG2SnRDSBgOQKA/SLoYHoNyiAOSDCrfNrT9al0Ymy8UhG7W+dVpzA5dx8LPxlgwwainIFztooAjvctQti+rHbrTvS894o5IiUl3xGNIqoy+vxr+RXFxSeH/j7YD9EehVCX508JHz0uXZWAVRA/TwlGA==
Received: from BN6PR1401CA0015.namprd14.prod.outlook.com
 (2603:10b6:405:4b::25) by BN6PR12MB1172.namprd12.prod.outlook.com
 (2603:10b6:404:1f::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20; Wed, 21 Apr
 2021 15:53:14 +0000
Received: from BN8NAM11FT063.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:4b:cafe::fa) by BN6PR1401CA0015.outlook.office365.com
 (2603:10b6:405:4b::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend
 Transport; Wed, 21 Apr 2021 15:53:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 BN8NAM11FT063.mail.protection.outlook.com (10.13.177.110) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4065.21 via Frontend Transport; Wed, 21 Apr 2021 15:53:14 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 21 Apr
 2021 15:53:13 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 21 Apr 2021 15:53:11 +0000
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <stephen@networkplumber.org>, <dsahern@gmail.com>,
        <vladbu@nvidia.com>, Dmytro Linkin <dlinkin@nvidia.com>
Subject: [PATCH RESEND-2 RFC net-next 02/18] netdevsim: Disable VFs on nsim_dev_reload_destroy() call
Date:   Wed, 21 Apr 2021 18:52:49 +0300
Message-ID: <1619020385-20220-3-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1619020385-20220-1-git-send-email-dlinkin@nvidia.com>
References: <1619020385-20220-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 34f48a0c-650f-4cce-9c19-08d904dd92bc
X-MS-TrafficTypeDiagnostic: BN6PR12MB1172:
X-Microsoft-Antispam-PRVS: <BN6PR12MB1172F8DED37E5B551BB728EBCB479@BN6PR12MB1172.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:469;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TbAs9DcgGklHZZlvTetZ/cfjLHGbEtg2Rokd4KNW3m02zr2bdysWSH1UtWJRqx+JmxjEkVNZJq6BpurkG0v+b4x4tU/1Z8mqb6BMQCSwP4EMCl30iSS2w8/mLqhpj+8k9FnwsM2E7B9fO5s75DVJFrep6C1wGZAFsIsuH1mrvVTiKrSw6LkBrZXduWAj/JJyJQDhvzjxmpg7VlDHFI5qmxD9NkcqqQAEAZAxFQJjK1Gcj/FWul1j7dvle5zAI8vPISoultaK4cf4QhvrrO8EkBnhpv0jizB/bqGK5Q6CQWckyC0s+uuRQn3AB84YQJBhjecTwShV0+9RJtRSoct1+IVnnF7kAfhFjTCL97bBattXrHFZHl6jXH2haXNeo4MhFxgvd072EjK0HJ4zc4nAkcVW5b998LrPRsk9hR/8w8q2KtetfY+wyFXZlsCycvi8Mct5XwyPDWq8VGUL4uzMubiaYQyt1Yu7tBLZHdFDfdKd4tr7Es3Nv5skj6D9j1fZa7PdQEafr8zPWvOpAJAoazKv5rSrTMed7DMEQypDIjPANhjai6iy87OIBBp/I/MLopZDXoQaCpRSwRJvwDv1No2y+NyBe4Udi3ZmFNBbgNjvC/qpBR7/eNlk/vOt0RjOd5uD5ExeHMoIFHmwZK4IOHkSzJodgAjs0FpM2b1RBAg=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(136003)(346002)(39860400002)(376002)(36840700001)(46966006)(2616005)(6666004)(107886003)(426003)(316002)(4326008)(36756003)(2876002)(70586007)(2906002)(26005)(186003)(8936002)(82740400003)(7636003)(86362001)(70206006)(36906005)(82310400003)(336012)(36860700001)(83380400001)(356005)(47076005)(5660300002)(54906003)(478600001)(8676002)(6916009)(7696005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2021 15:53:14.3754
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 34f48a0c-650f-4cce-9c19-08d904dd92bc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT063.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1172
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

