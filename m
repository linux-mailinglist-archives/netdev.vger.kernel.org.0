Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2E3442BBF5
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 11:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239150AbhJMJum (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 05:50:42 -0400
Received: from mail-bn7nam10on2079.outbound.protection.outlook.com ([40.107.92.79]:3739
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238054AbhJMJul (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 05:50:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VZMeezSSpNCqyLqtGHiyLB0+QPtvEd9laSJPRkwQay+u7xg9yrwOiGbs8fkHsDvsZWKY5EpexTLYmXRdelMcEEd12+ioBnsEelxEl9JyxtmzCpyFgb+8Etc+Q9DpFkEMnDhicl58KqzUztU54Dee38dciB9AmE8OuljMSjvv/Jo9h0bi4i/71a5jej6AxLnUOeEgGaMs27wy458lj/MUgiiOiW1W4LH6DI6lhU8Wq07dTvsT3aUExri4u21Zo3NwrD1fPASkLxhHWH0hSHExmJ63DMtT7CIeE3wLKmeqsff3edNDdm6GvQj10SeZ8cz+4S0dQZ/LAZY77T6o/TFMQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ATQOdGVF4dTjbvMJ1bmmazMNjFwWqMg4M5PKqHqf20k=;
 b=ENq/hsvIygegJGnDVqaf+qWYtYgHeAsAfs0e9NA9RsgSKBrahdbrjGFzVAVkLChi51FlbUDR+6rXTmYcqmIoRE+Eut+Ow2Gyfj1SfGdhXlnNUDGEYGb2f3qI1Wm5HqqA+150EqvIjKqQ3nz7sWrZvZNfCDpcumeBblthU6ZmeoMF/cRiUr4ut9VFDl8jr71ECMtfNApvLOjAsyxTTcEzGVVwP3sa35Zmk/BUuyggAFge+tK7mgvFrQJCaNoae7xfXEG4FoXYZxtlV1uggoEAPKe/bpHccXlsAlCHkpPX6/KO9Z9DsQJfIUoSXSRpVDk7uBr039rh9/7WUfmoCGyAAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ATQOdGVF4dTjbvMJ1bmmazMNjFwWqMg4M5PKqHqf20k=;
 b=RWuFkJW9nkvhZ5TZ+4sLkDIsjGq1yKHvWz2dwOhl2lcEfUtok7EGuw6bmfXFGjKCtSPdvIoODeMp/kwtDG893R7bLDjhMGD3sSo7vLENluc+5vfa84yoSUgF6aW9H/HOAtSzPdSEx9xEUvoxL3IUSP6mX6N7wNmIiQ28WB2c+FAgW0+unwygk3a5OpiUE7v3ez227XdioKUKBObG+x5WJWTGPC6vtAF/dYGVmKig02ME1dP4Q7k7yOF3nN/mxy7L71sFs70DmBWtTzMVwaZsbFPNV8wh0h8o8nCQshqH0bGk1nENW9phWdhQwD8lIKIgFTYJbmn3+NSOqOh6mbAJCQ==
Received: from MW4PR03CA0357.namprd03.prod.outlook.com (2603:10b6:303:dc::32)
 by DM6PR12MB4636.namprd12.prod.outlook.com (2603:10b6:5:161::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.22; Wed, 13 Oct
 2021 09:48:36 +0000
Received: from CO1NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:dc:cafe::b6) by MW4PR03CA0357.outlook.office365.com
 (2603:10b6:303:dc::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend
 Transport; Wed, 13 Oct 2021 09:48:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 CO1NAM11FT060.mail.protection.outlook.com (10.13.175.132) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4608.15 via Frontend Transport; Wed, 13 Oct 2021 09:48:35 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 13 Oct
 2021 09:48:33 +0000
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 13 Oct 2021 09:48:29 +0000
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V1 mlx5-next 03/13] net/mlx5: Disable SRIOV before PF removal
Date:   Wed, 13 Oct 2021 12:46:57 +0300
Message-ID: <20211013094707.163054-4-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20211013094707.163054-1-yishaih@nvidia.com>
References: <20211013094707.163054-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6eed1d71-9118-4a3a-73e2-08d98e2ea04d
X-MS-TrafficTypeDiagnostic: DM6PR12MB4636:
X-Microsoft-Antispam-PRVS: <DM6PR12MB4636BC03FA3AF9A58D70B97CC3B79@DM6PR12MB4636.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K/8WXcu5JMewWlP4zPze8NwceZczgO+EJT1AVwWlmh9dzATuFHCyqp3+/Ndoay1AQBJB449mDA74x6YafyhUUs86sU/1DaAPhucIlS7DHrOXVvwRdhj2MBYbtHZeoju3AGri8p6wTEhViEO7N7ARShByN29JfgRKFdf4WfFpoU9mKMnZ1KjFDv8cwx09TvQqzYSjiMkU8Mb0+g0Me8chpCK5JUti9E++6osbTVVnL7vKgB0tWvzFSYSJt7NxS91D+ME0LNx33HGaZkacwhML9wsUAcQcK5Flw8edH7W1TZRMVh+VPqFbD+NSYfIxiJGqAWzxAr8nc1lDtgpybog+VxxJ0nNpDDwA4X08wnRGWBmD0I1UARHYdJnvHCfvY/UXJ3b7PVcOYBQxkVOLXgmvVZTPaUSgL4g59ShtOBDoP06iz3WFkjFhj6QuOK0hgR0xEeSGCr6401KsakTb9Y3iIG3DqYY/4YcWpv/IUIS1vUP+X8AB4mEaSSAhtrkJ1TwQvM4+kcfQK060keBj4kW37U1LvDKULEzzqPJmbJxKM5DkJT3uT7MHdSbxIEVDm2UK36DHSmeFc8MCSHmVzW54HW3vIjVJx1DUEGuyEeiKOCBrcdONViUtNFpCqT6w8gJncm9soF8mVdsCTefMR2w/qWZgxfNjKkDo1yjob5vMr5KoIkAJlNazjjV1aQlgl+sr2x2hL6eQ8LcszpX/xxnrow==
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(82310400003)(36756003)(8936002)(426003)(36860700001)(83380400001)(54906003)(7636003)(356005)(4326008)(5660300002)(26005)(336012)(186003)(110136005)(86362001)(47076005)(70586007)(107886003)(70206006)(2906002)(6666004)(508600001)(7696005)(1076003)(2616005)(6636002)(316002)(8676002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2021 09:48:35.7553
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6eed1d71-9118-4a3a-73e2-08d98e2ea04d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4636
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Virtual functions depend on physical function for device access (for example
firmware host PAGE management), so make sure to disable SRIOV once PF is gone.

This will prevent also the below warning if PF has gone before disabling SRIOV.
"driver left SR-IOV enabled after remove"

Next patch from this series will rely on that when the VF may need to
access safely the PF 'driver data'.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c      | 1 +
 drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h | 1 +
 drivers/net/ethernet/mellanox/mlx5/core/sriov.c     | 2 +-
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 79482824c64f..0b9a911acfc1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1558,6 +1558,7 @@ static void remove_one(struct pci_dev *pdev)
 	struct mlx5_core_dev *dev  = pci_get_drvdata(pdev);
 	struct devlink *devlink = priv_to_devlink(dev);
 
+	mlx5_sriov_disable(pdev);
 	devlink_reload_disable(devlink);
 	mlx5_crdump_disable(dev);
 	mlx5_drain_health_wq(dev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index 230eab7e3bc9..f21d64416f7f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -140,6 +140,7 @@ void mlx5_sriov_cleanup(struct mlx5_core_dev *dev);
 int mlx5_sriov_attach(struct mlx5_core_dev *dev);
 void mlx5_sriov_detach(struct mlx5_core_dev *dev);
 int mlx5_core_sriov_configure(struct pci_dev *dev, int num_vfs);
+void mlx5_sriov_disable(struct pci_dev *pdev);
 int mlx5_core_sriov_set_msix_vec_count(struct pci_dev *vf, int msix_vec_count);
 int mlx5_core_enable_hca(struct mlx5_core_dev *dev, u16 func_id);
 int mlx5_core_disable_hca(struct mlx5_core_dev *dev, u16 func_id);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
index 24c4b4f05214..887ee0f729d1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
@@ -161,7 +161,7 @@ static int mlx5_sriov_enable(struct pci_dev *pdev, int num_vfs)
 	return err;
 }
 
-static void mlx5_sriov_disable(struct pci_dev *pdev)
+void mlx5_sriov_disable(struct pci_dev *pdev)
 {
 	struct mlx5_core_dev *dev  = pci_get_drvdata(pdev);
 	int num_vfs = pci_num_vf(dev->pdev);
-- 
2.18.1

