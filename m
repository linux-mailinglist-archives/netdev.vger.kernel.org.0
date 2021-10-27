Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFD3443C6FF
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 11:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241281AbhJ0KAc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 06:00:32 -0400
Received: from mail-mw2nam12on2058.outbound.protection.outlook.com ([40.107.244.58]:42159
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241290AbhJ0KA0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 06:00:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ewU+aT3VmqWGb3FecN9qzsrWotUW+liVVNKvxWitaqjob2jUI80/lS/jKkakhi5IiRQfeVzyAUXNtErXRC4pJLCTDYfFMB/PUhGCP4QgW/dHPqFsmYJxPtNVDuMC+Pd7jDR/x5MVZJr8HpqTHmgHVGpzTeFACzp9hY8+HWcsaeSmq/y3CxUOvzTIpJ2TAEOQ31Y9OTlnVSqlhPzq9IrNMdap3EFhexv8syuzBxuI1dYlUIAh0DGjerfi5ByvrwxYxuWJOo/8GcjjpAgOZaKyWu9tR7cBQ3Ula8d4o75A9ynVjU866CQUILcFcf8UhgLmJkcE0eOUPXnFoIUTvcGP0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eawxF+jFRBAH1P9hWq5BE145QVmYPfYNp1U9MJCuY0E=;
 b=geb+HRqcCZrN7WBiB0CYW1sKVTzUQ3zDvPJ8BPAGKYF/CouvIfPBdB0tQu3HLpoYnPZgB8E9ZqO3Queu/xT+rZpJcOpI5Em+Jz16j2CSWSLz5rHPvkEqwAhg0hEYpxtP61txSZ7jkH7KH2satmJT0xdbYqgBoLukIehrV1I1pwBtJIydp4vOIMfbuNk20WeUWht7r6AAZ5wImhkBOHnjcmFtVLF8ewybW/cgH8ktxGgBDYjj7h4VQ8HAYObuDtYtJ4big4rDbdMIelSZ0GWBHjZiZUB7cQsGAK2dDM/LIDoVsEF7V5QmQ9ssyVQHAvE7w1Z1O9nidRfOCsjx+OP/3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eawxF+jFRBAH1P9hWq5BE145QVmYPfYNp1U9MJCuY0E=;
 b=WQ/jpE5fU4wWQEHQ9gBoPDU+FpY7LWeVXvgajDpl/sksMi/TJJyXPMhiJjEOVcjlFOK8+8EujLbGH64az3vYhfq2lSVU66BadJbbX//a0eP6ZfRWBTToZZRbm0yuZfTcA9Ii9wKrhEiOAdmwmfrM0+HMqNnWG12pJg+NFFC4x53n6W+OUqMvoGQZGJnxCC3AupDxAzkXkmvGQDRyr+mSQIUuICPdggx5GhGhXhR+mstaZeTDCm9TRWQ7NRaKi8jfHiEbA0/P7UGKnWob+CgiGM/4eiLHVboOtUMwffzNsdoBLuuGEzlBUzOTis/s0x11kp+wKje1vU7MxA834OHHqg==
Received: from DM5PR07CA0156.namprd07.prod.outlook.com (2603:10b6:3:ee::22) by
 MW3PR12MB4571.namprd12.prod.outlook.com (2603:10b6:303:5c::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4649.15; Wed, 27 Oct 2021 09:58:00 +0000
Received: from DM6NAM11FT054.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:ee:cafe::f9) by DM5PR07CA0156.outlook.office365.com
 (2603:10b6:3:ee::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.13 via Frontend
 Transport; Wed, 27 Oct 2021 09:57:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT054.mail.protection.outlook.com (10.13.173.95) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4649.14 via Frontend Transport; Wed, 27 Oct 2021 09:57:59 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 27 Oct
 2021 09:57:57 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 27 Oct 2021 09:57:54 +0000
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V5 mlx5-next 02/13] net/mlx5: Reuse exported virtfn index function call
Date:   Wed, 27 Oct 2021 12:56:47 +0300
Message-ID: <20211027095658.144468-3-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20211027095658.144468-1-yishaih@nvidia.com>
References: <20211027095658.144468-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ef8d0f48-8ed3-4e25-1af6-08d9993041fa
X-MS-TrafficTypeDiagnostic: MW3PR12MB4571:
X-Microsoft-Antispam-PRVS: <MW3PR12MB4571A3AEBBD0E1212C75E475C3859@MW3PR12MB4571.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HKqrBflGYj/LmTzLsDKDJOOYJwbplTSWc/0Hkth35MRyUC0UjcjSaq7ttJW7e1MXky7eaujC3RkprFCIDg9zEMGarpk9TCN8/lgZiemK8TYyjiWCDF54CBBRRv+t88lmjDYe1xu/IwY9mqNEX0Y0lGWDLl8JH/m7SXtzu4BvpniEMWgu5jcLjIIZRdhnYWmNAeGbEFtUEnVTz1CeqlrpplHmYg8DHc89jI2h17na3widwML//N63Q03v/P/8+6I4NcrFuuWLuEcpf7wtutEXahMmnEJssQ6Dc7oHWIakrFpNljDP+KOAu8wCc8Rp9IvKCheNC+vJLDLO2RRiB8iwQLDPk1KF3heN0p+ASOOL00NP6IlLyT0lzzq449Gbyp4TG7KqVDx86U4VqyZm6a2bRAPde9mcbXA9Xt0pA+Bcmd995RshlJO2KooFF8NZ0Ii4XaKnpdnPL5T6por6nAHVvUgFnEFM78hZkb41gdIZryPwxJCt9Sk4Pl14udUCBtEJLEGHqid4x21eEmVsY1kL/YRFfm3L2VTFQhIU8FKRmONKixqaJ1bkhrU3RghrT1Y3TjH6kIYNR5eRY/pUZ4XbXJNhjUEmE7oiCHK3nOz7Bdh0g21KsxMhkfN+6PrZFnG2adM42Ew6xwrKH++zJOknUEKdZuVe+5ywo66NcAuUiq0iIEh2STdolprpFXZSheyF7b/Tl3cvY5WxHNiMEG6T4Q==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(8936002)(2906002)(5660300002)(6636002)(47076005)(70586007)(6666004)(70206006)(7696005)(316002)(8676002)(186003)(83380400001)(36756003)(4326008)(110136005)(54906003)(36860700001)(82310400003)(86362001)(7636003)(356005)(1076003)(336012)(508600001)(26005)(2616005)(107886003)(426003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2021 09:57:59.2936
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ef8d0f48-8ed3-4e25-1af6-08d9993041fa
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT054.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4571
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Instead open-code iteration to compare virtfn internal index, use newly
introduced pci_iov_vf_id() call.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/sriov.c | 15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
index e8185b69ac6c..24c4b4f05214 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
@@ -205,19 +205,8 @@ int mlx5_core_sriov_set_msix_vec_count(struct pci_dev *vf, int msix_vec_count)
 			mlx5_get_default_msix_vec_count(dev, pci_num_vf(pf));
 
 	sriov = &dev->priv.sriov;
-
-	/* Reversed translation of PCI VF function number to the internal
-	 * function_id, which exists in the name of virtfn symlink.
-	 */
-	for (id = 0; id < pci_num_vf(pf); id++) {
-		if (!sriov->vfs_ctx[id].enabled)
-			continue;
-
-		if (vf->devfn == pci_iov_virtfn_devfn(pf, id))
-			break;
-	}
-
-	if (id == pci_num_vf(pf) || !sriov->vfs_ctx[id].enabled)
+	id = pci_iov_vf_id(vf);
+	if (id < 0 || !sriov->vfs_ctx[id].enabled)
 		return -EINVAL;
 
 	return mlx5_set_msix_vec_count(dev, id + 1, msix_vec_count);
-- 
2.18.1

