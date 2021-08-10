Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B17003E5B63
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 15:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241390AbhHJNZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 09:25:11 -0400
Received: from mail-bn8nam11on2067.outbound.protection.outlook.com ([40.107.236.67]:43478
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241338AbhHJNZF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 09:25:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JSAJHiBPHL+1hkZe5wTLgNpBXJLna4x+jJNgMdnuEOHE/W/8VedcsQPFVHCl3MHmu6l6FpgoctABVePFiZHYCXoaEEQ/MUmheuTz6jhTejrfKiLgBVONGnRvK5LjD66oamFGmD8+0BCD1v+24Uk2bAisTIiF94l6uZvX8TFDdg5gzNJ+nPFXL8fIn/IjVrQT/km9mdp6es4mng/LeF/fXc4XGyZkFc9m2hU6UULb8DE8em6HfGUFBkLtrANzQM74xUuMrD/vl7yC/hxeCslkw7uBsOwxHhcemol7gtYhuom5PaRmimbhYL+7vymj876pmtTKhaz+2JVz+Q/TOFoxOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w4/S67V7WOYwqMo9/yFokbt27R1+xYcr9QtOyrtDXIQ=;
 b=TsEAY44ZrMkDxg20KolzLaqf0FbaIPckdJgc1EqTaEdV85WaI8ppHQOU2R3lWpHvNWyfqNvUWXenGLf0rCA/nMeXfGk7L8puydrSb4wX1W51vFsmRsaanXseGp1wA9h7mPiR6AILvJa9H2Mwf039zTE5dKJxwgWGWc6zBiaSLiZbQWFq70lUVHZhJvTRnoo9ltOhrvd0DuVDJV/GupBvKS3Euh3MOYWeUQ4mpgIv0N6oQP45ZIsn8JibKeyvdSUTmbFCuxUPzv9sW08xRw16XGjmJZ0OYCcc7HJfS47UokoRmbwHp1MboURzzuQ2kBogK2p6H48VvvXygwlXGa60Gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w4/S67V7WOYwqMo9/yFokbt27R1+xYcr9QtOyrtDXIQ=;
 b=Cq/ToheyhhH5EEBx0gjhzE603391DHItPV3xj57veRkesYhuYjzkIlME5TxVSnS51ZR+AG2+3a7QHKIIS0lflnoT5tvdQS0c2E+H2271m8UjE5ZTxzCx/F3GhIRGQZkJy9/6uDPlGYfeg76tcozJNogmwfac3r1C+99yZghn4aMDHrD96zEDHpjbVEl6Uevpbdu0JLyV3MPJ+JIzWzvyEwk3iBWkknQRDWjroccq/v6KnISSyKxLH/2qSXzdW4SXUIoSpF9mCAbcfrxmAMrLLY1hm7PfyAa8qCqWukKcJlnBgzrVJmQ1bJnKnskGUJUh8reA5lHi8AV4kJq3EDY3Qw==
Received: from MW4PR03CA0017.namprd03.prod.outlook.com (2603:10b6:303:8f::22)
 by DM6PR12MB2796.namprd12.prod.outlook.com (2603:10b6:5:50::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.19; Tue, 10 Aug
 2021 13:24:40 +0000
Received: from CO1NAM11FT017.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8f:cafe::20) by MW4PR03CA0017.outlook.office365.com
 (2603:10b6:303:8f::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17 via Frontend
 Transport; Tue, 10 Aug 2021 13:24:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT017.mail.protection.outlook.com (10.13.175.108) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4394.16 via Frontend Transport; Tue, 10 Aug 2021 13:24:40 +0000
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 10 Aug
 2021 13:24:39 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <linux-rdma@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        "Leon Romanovsky" <leonro@nvidia.com>
Subject: [PATCH RESEND net-next 03/10] devlink: Add new "enable_vnet" generic device param
Date:   Tue, 10 Aug 2021 16:24:17 +0300
Message-ID: <20210810132424.9129-4-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210810132424.9129-1-parav@nvidia.com>
References: <20210810132424.9129-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8a75ade7-7867-419d-7170-08d95c023599
X-MS-TrafficTypeDiagnostic: DM6PR12MB2796:
X-Microsoft-Antispam-PRVS: <DM6PR12MB2796B0247F623B4695437882DCF79@DM6PR12MB2796.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yeZeYQdFxdGwJ1Q5bJN+1NL+kdPvgDYk8A6EoconSDw42hfl0Ty1drrgAdhZBFMuUUYdSGbxCODPnjWMVFeJRoHcRIgOi7+XNkIjkrulw0h0E3EqLbndoPNmUiTnZkAfcgQrE8feB2/lDVfplsma97pfZv4CyFgcSLdfTV5sCh6MGTmZWuN7UcSivRzyCTrcnsca9vEh4BBfcv0cSQqeIbF8ZXtlSFEFIjBCW97OFi173vfS0Anyc4Yzd8xYdDX1pPfU8SWQcVRAsAmdRgTI/yQemlLB5PcSgt4rSJmrQdB52UY0NufG+q0bTRsmdo8QVIft/GTzRlnwREOUVNNlpmfLijRl9O+sW68T32+MRmuCQyJeWm11fs2tq2vysY7pn/OAn+5vajKUTEYAoUxeA6GVR4Vg0WMSFYIks79w/H5MCGT0VCZkwFjt2GIu8m1RBF8jPqroxaWvDHM0GOQbJHoVA2ylxwjyZGVbCrmjUMHewQkX39GItmUsYYXlyFG9XpnIgYGEFL9y5l7GQhPJngR4wxV/Q+jfcWGmEG1UI2zSNdan77/halN5ylBIfCINIWTjHMdUzFMHKa9SbT+ibluyqpWJOihFq7iyMPiDMqfMGrrWMRiMLyRzcwWS8lsXGJdHnmlCcGnzS2WNbpAs7jr8DSnMhZWJar70eq4xZAt8A6BbCSs8QPCHYVImuw5YhnYqwjmEVBv0N7nF31f6Rw5pO1Ej0UdjujT9QQ/t2nU=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(346002)(376002)(39860400002)(136003)(46966006)(36840700001)(4326008)(478600001)(70206006)(2906002)(1076003)(426003)(70586007)(7636003)(8936002)(5660300002)(336012)(186003)(82310400003)(26005)(36756003)(356005)(16526019)(47076005)(82740400003)(6666004)(86362001)(110136005)(54906003)(8676002)(316002)(36860700001)(36906005)(107886003)(2616005)(83380400001)(41533002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 13:24:40.7464
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a75ade7-7867-419d-7170-08d95c023599
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT017.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2796
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add new device generic parameter to enable/disable creation of
VDPA net auxiliary device and associated device functionality
in the devlink instance.

User who prefers to disable such functionality can disable it using below
example.

$ devlink dev param set pci/0000:06:00.0 \
              name enable_vnet value false cmode driverinit
$ devlink dev reload pci/0000:06:00.0

At this point devlink instance do not create auxiliary device for the
VDPA net functionality.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
---
 Documentation/networking/devlink/devlink-params.rst | 4 ++++
 include/net/devlink.h                               | 4 ++++
 net/core/devlink.c                                  | 5 +++++
 3 files changed, 13 insertions(+)

diff --git a/Documentation/networking/devlink/devlink-params.rst b/Documentation/networking/devlink/devlink-params.rst
index a49da0b049b6..4878907e9232 100644
--- a/Documentation/networking/devlink/devlink-params.rst
+++ b/Documentation/networking/devlink/devlink-params.rst
@@ -105,6 +105,10 @@ own name.
      - Boolean
      - When enabled, the device driver will instantiate RDMA specific
        auxiliary device of the devlink device.
+   * - ``enable_vnet``
+     - Boolean
+     - When enabled, the device driver will instantiate VDPA networking
+       specific auxiliary device of the devlink device.
    * - ``internal_err_reset``
      - Boolean
      - When enabled, the device driver will reset the device on internal
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 6f4f0416e598..0a0becbcdc49 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -521,6 +521,7 @@ enum devlink_param_generic_id {
 	DEVLINK_PARAM_GENERIC_ID_ENABLE_REMOTE_DEV_RESET,
 	DEVLINK_PARAM_GENERIC_ID_ENABLE_ETH,
 	DEVLINK_PARAM_GENERIC_ID_ENABLE_RDMA,
+	DEVLINK_PARAM_GENERIC_ID_ENABLE_VNET,
 
 	/* add new param generic ids above here*/
 	__DEVLINK_PARAM_GENERIC_ID_MAX,
@@ -567,6 +568,9 @@ enum devlink_param_generic_id {
 #define DEVLINK_PARAM_GENERIC_ENABLE_RDMA_NAME "enable_rdma"
 #define DEVLINK_PARAM_GENERIC_ENABLE_RDMA_TYPE DEVLINK_PARAM_TYPE_BOOL
 
+#define DEVLINK_PARAM_GENERIC_ENABLE_VNET_NAME "enable_vnet"
+#define DEVLINK_PARAM_GENERIC_ENABLE_VNET_TYPE DEVLINK_PARAM_TYPE_BOOL
+
 #define DEVLINK_PARAM_GENERIC(_id, _cmodes, _get, _set, _validate)	\
 {									\
 	.id = DEVLINK_PARAM_GENERIC_ID_##_id,				\
diff --git a/net/core/devlink.c b/net/core/devlink.c
index b68d6921d34f..867ae7e39788 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4287,6 +4287,11 @@ static const struct devlink_param devlink_param_generic[] = {
 		.name = DEVLINK_PARAM_GENERIC_ENABLE_RDMA_NAME,
 		.type = DEVLINK_PARAM_GENERIC_ENABLE_RDMA_TYPE,
 	},
+	{
+		.id = DEVLINK_PARAM_GENERIC_ID_ENABLE_VNET,
+		.name = DEVLINK_PARAM_GENERIC_ENABLE_VNET_NAME,
+		.type = DEVLINK_PARAM_GENERIC_ENABLE_VNET_TYPE,
+	},
 };
 
 static int devlink_param_generic_verify(const struct devlink_param *param)
-- 
2.26.2

