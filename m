Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 806C64C2E35
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 15:23:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235409AbiBXOVo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 09:21:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235424AbiBXOVl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 09:21:41 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2046.outbound.protection.outlook.com [40.107.220.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BE5D14FFDC;
        Thu, 24 Feb 2022 06:21:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TdqoetbpoTNGLZTyb8X1PXtQFkCVOckhKbfr2Vq7EM3UnJl3dJ7W5V5TScZpYNKG7R1cyOR2y/64fbCODPXUmRuEQNMSgkYMlHv1CV/tL5LNbRHhqBlxYm7aIOZajHWgkFAZixEaEZ/0tro4fczaCtKVxCloceQBnO1castGRioAnWleRD87bEjHpOr+KjpLjvCLpwywBxJwjZmqzTyNAQ22We8t5PNYNv8atTUqVne19CxHyWOkHXnrVZuQWdsp3b5uGl5keTyVpKjm4VIm5ZpbxPepf78b4V5/7exdsrFvPTIiLxujuDiLLY2a5k0so8f8fGgWduDrNaUNuQPreQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q6yP+UcaESGvVDA99CJM19WVOqvMzB4Yg0hQqHcAhk4=;
 b=hWywjkzMDeM2VDWY2+ysxK9KH1V7F9LZD2FYhWZTyuZjS04RiTHmbeGZA7nUvGlGbl6q8foWv370f8VxfxYX2XvnRY/izoOqY7vTV2gdvqiZpXpt48qKXg0/aC5Ygfya5RYxg/KCP60gSEj2xxVzHCerdL6KbAmFb1LrGfM/edNvme7HAB2gXbEFMYywAH/dICCb1mUbJtTmPCaDHdCaFRIcLCx47elNwgZgETLhsaraDTcB3y6Z6vVIMmy4lfWzRewH/3E9JAeUc0ZOy47wxuyEsUUf8mO8mrmpGNDEUT4g+PH+1ErSxCz7qIETQw9Ek+MbdM1lxVFtG3rDWDDPWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q6yP+UcaESGvVDA99CJM19WVOqvMzB4Yg0hQqHcAhk4=;
 b=uKagNEVI/4EHkqNydDfZ9sufUUFYYksx/niT1n2Hcp9rDIoSIDRTri3zD4SOXYtHnWpaNip9prppXiwGsj7hfdtD3Zemp4z6yWK4QuOlT2tydh1f5zpWWXmfLs1/zS3R9F5We0LpRG1TDEySDg5UBXLSzeDP0Gz5JKR7fulc3DwD3UTfdTY88exB3KTTrlx3Eyw3NC+FJZ3MTNcn3JoVJHcDba+sSKP3oMIHO4Wa5fKJTKF0ir4nc057HyVMMEo8UUoaMlpK09YbVz20PS8MubcDwUeGdWiL5l53w6/JduxerOJFtEXAQklN/VPn+nWJ7KaDy7D6F9Zj7mpxpgNoBg==
Received: from MW4PR04CA0134.namprd04.prod.outlook.com (2603:10b6:303:84::19)
 by DM5PR12MB1227.namprd12.prod.outlook.com (2603:10b6:3:76::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.17; Thu, 24 Feb
 2022 14:21:06 +0000
Received: from CO1NAM11FT029.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:84:cafe::e5) by MW4PR04CA0134.outlook.office365.com
 (2603:10b6:303:84::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24 via Frontend
 Transport; Thu, 24 Feb 2022 14:21:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT029.mail.protection.outlook.com (10.13.174.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5017.22 via Frontend Transport; Thu, 24 Feb 2022 14:21:05 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 24 Feb
 2022 14:21:04 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Thu, 24 Feb 2022
 06:21:03 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Thu, 24 Feb
 2022 06:20:59 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>, <cohuck@redhat.com>,
        <ashok.raj@intel.com>, <kevin.tian@intel.com>,
        <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH V9 mlx5-next 03/15] net/mlx5: Disable SRIOV before PF removal
Date:   Thu, 24 Feb 2022 16:20:12 +0200
Message-ID: <20220224142024.147653-4-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220224142024.147653-1-yishaih@nvidia.com>
References: <20220224142024.147653-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f69e3862-ef51-4e83-834b-08d9f7a0e4f2
X-MS-TrafficTypeDiagnostic: DM5PR12MB1227:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB1227E60259B8F346F777F36CC33D9@DM5PR12MB1227.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t6S5AwvhrUcA7dQyi3RTmu2ZznwNawOOWilXdktBb+VFJ3JZdOE8A/GydHxr+9gFVviMolquEL7T9ozY3mJgJVlOIeoVzxEJlLMRY7VSu5ByfnWo46119uUHka2OnHVaVh2a026A9ak0biDDgn5oq328Smlg21jx0HybF3/vi6RdG7E7w02/WwWl9Lb3eCefTiKl56TJqYqNEG9XzqWlYJHhhWtY+bnbxrOzky2CQTvuDrOL71AqHTbxMS8asuvSgkTz88Hffba8bHYTGbSPmDyyTiWUJ7hyFZt3Oro02Xie/Sb/18LCh80Sfy28U384z1+DMp1jwpVO95Djdvs9cz0p3Eyn/xZcssRu7CrynXGnC/A3lxUkswPuE830aTWQ2kljQK1Qec8AsacDJ2dWZ1sh2ZrPNlTcPq0F9MOToX8moTfSItoO8N4n2r5f1N9n+VoYqQWC47Eia4CTeqKoF+rU6WtzRdEEoAJGJUqpxZFKdh5OXoBPwA/j33U2NToD35/X60a1NgBTKC4cnFUheO6j3hjawnf0y147zuzFHw6hTXUpszhsdE9stQeMDh1cqmfAAR+INwySreknvosjxZ79RAenX+6CyFgOXOviCVbdSHwKYkvp0m6qPEU45qCBaiE4XMS7UI3i2KvwgUiKO2LrZsw5rKZno2S9XcN2UEXFH6XhxcpZVShJeuweUOvph+yuTXAZNBe0YEpjAQ34Rw==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(7696005)(6666004)(186003)(26005)(336012)(47076005)(426003)(40460700003)(2906002)(36756003)(2616005)(83380400001)(81166007)(6636002)(8936002)(8676002)(508600001)(70586007)(70206006)(82310400004)(356005)(86362001)(36860700001)(1076003)(316002)(4326008)(7416002)(5660300002)(110136005)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 14:21:05.6312
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f69e3862-ef51-4e83-834b-08d9f7a0e4f2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT029.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1227
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
index 2c774f367199..5b8958186157 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1620,6 +1620,7 @@ static void remove_one(struct pci_dev *pdev)
 	struct devlink *devlink = priv_to_devlink(dev);
 
 	devlink_unregister(devlink);
+	mlx5_sriov_disable(pdev);
 	mlx5_crdump_disable(dev);
 	mlx5_drain_health_wq(dev);
 	mlx5_uninit_one(dev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index 6f8baa0f2a73..37b2805b3bf3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -164,6 +164,7 @@ void mlx5_sriov_cleanup(struct mlx5_core_dev *dev);
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

