Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B1485617A3
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 12:27:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234063AbiF3K1I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 06:27:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232214AbiF3K0u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 06:26:50 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2053.outbound.protection.outlook.com [40.107.223.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5A124F659;
        Thu, 30 Jun 2022 03:26:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DboyNN9744RTcjViW/zcHlMMCjVulJD4ob/+cCoi96jdrxIzVktOP+DVXLmyX8FXfXV3JrUm2T5GVuWlWo3SbEafVkCltKlzx/wJ3No6dlXWlPaRuqQ3CC0hoYVwrSacYJyNdh04Hdx3hwuFrWAxbMjR93FWtUk2Erp6Ujd82QOGCDw9MjazWPhTWZJNJ9JyykjqMunKWklOjD6qzO7H0NvsCNE+IqQAS61wJsIcftS7RUFdIfqHst+iBFlI+u7WmRtlhn8Pt/vUcKvjd75cWmkOpmcSzUcAPOEX0/j5ui38wyzE33bTqFtCt0wTE4kNhM/0aPAFzhHw1sNs74vonw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4FU0SF+R3sQDwmMMK0dPHFM1NO3T31njTmSiF9pYpZ4=;
 b=mU8ccG11daJxbuwmeKshwjJcB5Ofkk0WSntBFStvj9ZMeBc590uOLATY+qJg39/xXCxJziF+tBEEc3xl17VfuHvLEK4suZM8J7jhWkZagsVVU3iVH5QXZNXKvrC9oI/bxIPxq6FpeBYjSCZI5wzR6rgjDLUXEyirY9X5QllvOSGnOPRONhbqbm+nD3qW3fd1r75Z/cjAIjMD72fRgGaNz3J5DJQiC+3xswnrI4Y6iWTPHfbYj/jYuphQnOzuBOCTKm57Bz+tlOxfDmdrNLzmsQEoi83dM3MP2raezombdEX9NsGMt90UHp4Ca17V83zs2Q6yv+6CJFmDHG98h6GcTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4FU0SF+R3sQDwmMMK0dPHFM1NO3T31njTmSiF9pYpZ4=;
 b=V9WmU6UYP4Z0QGbLgXV5Tzes9tmGmztXvb0Sn28lO3l7Wy9rxSrie7J3XlYg3aJ4sVOxqbEoOIhSJPKiyFpz87OzwehA9bfIdF3Bs7ARJsbv5f1gBl+2HmxvlEtmr9RRhdTgBzQqiLQiqU+4uqsEnglBXbWZ5Cefq7ANNUN+NXlrOtpc9jKWinai7Pn3YoPLo3EgsL2FthtvZYbFykfnrWY3DniDzOLWckMsounMMTPDl12GViz0hWfTS0GptAJPgL0eB2WB86CJwleQfew2BhU1Xu38Ag8IWpiIJPCndB3EWbojA/cO5RQpQ22+KE9l0VZNy+OiD8Gt5SOdvSmFdQ==
Received: from DS7PR06CA0012.namprd06.prod.outlook.com (2603:10b6:8:2a::22) by
 BN8PR12MB4785.namprd12.prod.outlook.com (2603:10b6:408:a2::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5395.15; Thu, 30 Jun 2022 10:26:31 +0000
Received: from DM6NAM11FT053.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2a:cafe::e5) by DS7PR06CA0012.outlook.office365.com
 (2603:10b6:8:2a::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14 via Frontend
 Transport; Thu, 30 Jun 2022 10:26:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT053.mail.protection.outlook.com (10.13.173.74) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5395.14 via Frontend Transport; Thu, 30 Jun 2022 10:26:31 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL109.nvidia.com (10.27.9.19) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Thu, 30 Jun 2022 10:26:30 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Thu, 30 Jun 2022 03:26:29 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Thu, 30 Jun 2022 03:26:26 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: [PATCH vfio 01/13] vfio/mlx5: Protect mlx5vf_disable_fds() upon close device
Date:   Thu, 30 Jun 2022 13:25:33 +0300
Message-ID: <20220630102545.18005-2-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220630102545.18005-1-yishaih@nvidia.com>
References: <20220630102545.18005-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4f0be23c-3921-43d1-9ab7-08da5a830031
X-MS-TrafficTypeDiagnostic: BN8PR12MB4785:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: klLSOKXv5mLnpL11h5RugQvDO/doiJoYv41P/eRvyIl/17fzU7hF5zoS6/sL6xPvqy3u0CO/6L9lD5VB2hps6mrM1pc/e9QD30QMfwur/0vAjWN7x23VwMz6QbkBdywrauK/WA6Lkjh1Yqm4GvmBeBGKAfDgCAWP1g9sulRnz3fGE8JlymOrEENKBUcScgVQx5noFB0WdnerpCVZjj1cbde8w0rn6fBqDuOHlR7pMeRfRjV7mRRXDTfr2VS0bGbWysonCxjcYakrtZDxooFgxNiNm/UD4hdyPz/+z5OVor20qDAH0lon8vfsgbu7QBPRRa2vdqlk4ihFo0Aen3s9ZL3RKE+Ql/zxB5jVBMRlUuABCr5gPVgHFLNDPXCX12/u5W2mhxZaRzYWnBDRSUkksZWxiI75KSsYb7hux9tG5EQPzOWGa2pU6/jGr7dFOcGORlP2Gq5YFRrXeBhjhlJIE7cDJxsZFHlw52qVIQWoE9h39CtkREzuxbFJe3pRarMHS95n1a3lO3lffD+FZnepBiQPMxn942KMp6ajNCMYIF+kFih9TVceGCN6xFOiMX5hxN7X0PRF6l5XaOoln70h1/UKdmG4OyrX+pQ2eV//Fkw2RCkIya9VZMQP2S0REy3ymNeM8s3b85V0B6ba6b3PUMIAkHGPPjDbfeiBeNof71uNy9WDGb88vdqWa+ep1rfD2xmBAyooSMR9TE/MDskS96kX0Dj5GrV/+TSK4Vu3bJY7DhDxfySu1zXznx9utNd1uw29A6EkQNZRyilmTJ8L0SEcUqf8YV26r99qY57IzEKZa5RITVbfDDrrTU8FyNVVLyrF/48apKr5T/6n55pelDAUvZ+mKIBffIFsqPhm7zc=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(346002)(39860400002)(376002)(36840700001)(40470700004)(46966006)(70586007)(36860700001)(70206006)(8676002)(5660300002)(7696005)(186003)(86362001)(4326008)(82740400003)(1076003)(8936002)(478600001)(2616005)(356005)(6666004)(2906002)(81166007)(41300700001)(40480700001)(40460700003)(54906003)(6636002)(26005)(316002)(426003)(336012)(36756003)(83380400001)(82310400005)(47076005)(110136005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2022 10:26:31.5563
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f0be23c-3921-43d1-9ab7-08da5a830031
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT053.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB4785
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Protect mlx5vf_disable_fds() upon close device to be called under the
state mutex as done in all other places.

This will prevent a race with any other flow which calls
mlx5vf_disable_fds() as of health/recovery upon
MLX5_PF_NOTIFY_DISABLE_VF event.

Encapsulate this functionality in a separate function named
mlx5vf_cmd_close_migratable() to consider migration caps and for further
usage upon close device.

Fixes: 6fadb021266d ("vfio/mlx5: Implement vfio_pci driver for mlx5 devices")
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/mlx5/cmd.c  | 10 ++++++++++
 drivers/vfio/pci/mlx5/cmd.h  |  1 +
 drivers/vfio/pci/mlx5/main.c |  2 +-
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index 9b9f33ca270a..cdd0c667dc77 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -88,6 +88,16 @@ static int mlx5fv_vf_event(struct notifier_block *nb,
 	return 0;
 }
 
+void mlx5vf_cmd_close_migratable(struct mlx5vf_pci_core_device *mvdev)
+{
+	if (!mvdev->migrate_cap)
+		return;
+
+	mutex_lock(&mvdev->state_mutex);
+	mlx5vf_disable_fds(mvdev);
+	mlx5vf_state_mutex_unlock(mvdev);
+}
+
 void mlx5vf_cmd_remove_migratable(struct mlx5vf_pci_core_device *mvdev)
 {
 	if (!mvdev->migrate_cap)
diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
index 6c3112fdd8b1..aa692d9ce656 100644
--- a/drivers/vfio/pci/mlx5/cmd.h
+++ b/drivers/vfio/pci/mlx5/cmd.h
@@ -64,6 +64,7 @@ int mlx5vf_cmd_query_vhca_migration_state(struct mlx5vf_pci_core_device *mvdev,
 					  size_t *state_size);
 void mlx5vf_cmd_set_migratable(struct mlx5vf_pci_core_device *mvdev);
 void mlx5vf_cmd_remove_migratable(struct mlx5vf_pci_core_device *mvdev);
+void mlx5vf_cmd_close_migratable(struct mlx5vf_pci_core_device *mvdev);
 int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 			       struct mlx5_vf_migration_file *migf);
 int mlx5vf_cmd_load_vhca_state(struct mlx5vf_pci_core_device *mvdev,
diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index 0558d0649ddb..d754990f0662 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -570,7 +570,7 @@ static void mlx5vf_pci_close_device(struct vfio_device *core_vdev)
 	struct mlx5vf_pci_core_device *mvdev = container_of(
 		core_vdev, struct mlx5vf_pci_core_device, core_device.vdev);
 
-	mlx5vf_disable_fds(mvdev);
+	mlx5vf_cmd_close_migratable(mvdev);
 	vfio_pci_core_close_device(core_vdev);
 }
 
-- 
2.18.1

