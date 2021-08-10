Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0CC03E5957
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 13:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240260AbhHJLrH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 07:47:07 -0400
Received: from mail-sn1anam02on2069.outbound.protection.outlook.com ([40.107.96.69]:7770
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233534AbhHJLrE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 07:47:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CzGqcGtzcpN+uztyc2/+YUHljmQmwOpA47oqH8CiJueMW2AQABljQ783n02+rIu4P2Rtz79ie2JCWnnEKMMq2OnDuiBMGfwAwAvIrkbokuuvUjf7kQ+9Mf29bWGC7yd3R6PsADXlTXDkX7gEr4T9otZvR9WMhdigAq+kUVn/PFNh/d/4+PVDyMTZtuvwkDvrUSAaKLHa6FDIJ5a6xUKExqkxLPU9I9tryVevbb1jF8lpZcBERuQV3iwJlQny+IKSMjaOhIiCDhMPTUpA+IkVGNYKi+MsxvLhlRKKYe3aaBy0ZzQ2PzIpbELCORNVvqTcQWTq/sTgXeeoHpUz2WTvqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w4/S67V7WOYwqMo9/yFokbt27R1+xYcr9QtOyrtDXIQ=;
 b=EWHAwtRUC8RaDlUcYMKEgzZ21TKasU0T7LE14qTbVJB+lPaJS+4KuEuDA6scptZNzP4WYvOqaIozlZE47j9iTjvMmrPnr2nAVljcu3R9ZixaQMMJXsYKDCJenh9p2AyekUuB3ViMTdV5QsXbqOI7G0c6sUFjDf+ZJ/EKlF3CkwbAgrMrmQFepHh26QPTEF8fbR9yQzo0rJcXEowjtP9RYxIqUndp6bG+uqU197bUXhTSZeJa60mBWnvd8rZ9gaz80rtIjnrLvZwSd70UUsT7KSLXTNqJ2Av8g9CMI36amsuTNIdXLs5rO2iBzkIUd7hSNnbPDqF4UH73RE4CtliAfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w4/S67V7WOYwqMo9/yFokbt27R1+xYcr9QtOyrtDXIQ=;
 b=aWyVL2X+BsDAMqX8zzddJJMwHGifx+II4cqVf3c74ZjzKeTAxAsPBTodcnJ7L8LTAlPSjKOii8kpP9CkiMoEaCNCje750X/rNHGhG7iWqkpBlN0juvxdeSv9hNT70rlDmRXLITZ+vxll7m7SZccVCm4+1NDGKLB+2g/0V4i9UuvbrrVVBsiKV7ftRZTxETBt7FchlIF0lxc2pSnN2Fi3b7H7upBKVszEdW2h8WGhSXTFqnd+gtR+AIc+u2c9Nuz8Bc5BB6fbOX2pTRxTGoIBJgjFs/3Vo76kb/lcV2pLCA2MMTqjKZHbwJyv5QOy0dshhmN+uwklHFbGfdMRic9CdQ==
Received: from BN9P222CA0026.NAMP222.PROD.OUTLOOK.COM (2603:10b6:408:10c::31)
 by BYAPR12MB2998.namprd12.prod.outlook.com (2603:10b6:a03:dd::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15; Tue, 10 Aug
 2021 11:46:40 +0000
Received: from BN8NAM11FT064.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10c:cafe::28) by BN9P222CA0026.outlook.office365.com
 (2603:10b6:408:10c::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.16 via Frontend
 Transport; Tue, 10 Aug 2021 11:46:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT064.mail.protection.outlook.com (10.13.176.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4394.16 via Frontend Transport; Tue, 10 Aug 2021 11:46:40 +0000
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 10 Aug
 2021 11:46:39 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        "Leon Romanovsky" <leonro@nvidia.com>
Subject: [PATCH net-next 03/10] devlink: Add new "enable_vnet" generic device param
Date:   Tue, 10 Aug 2021 14:46:13 +0300
Message-ID: <20210810114620.8397-4-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210810114620.8397-1-parav@nvidia.com>
References: <20210810114620.8397-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 01e1cabc-e902-4fbf-1dce-08d95bf4849e
X-MS-TrafficTypeDiagnostic: BYAPR12MB2998:
X-Microsoft-Antispam-PRVS: <BYAPR12MB29981FC694378B837191C0D6DCF79@BYAPR12MB2998.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oxDvgfm/F3ez9H66l6yYwrilxb9TRNYv/VWqKAHM8piq4z8e9qesXk75vPWnlUwhSOJ4b2eO9SkhTG4rhCDk3KSomVkrCKtjNlFB6IHYWJmb1DheF6nS/5UuLcNKC7xDjyvSHvyWOA1uoFjg2IC5dRb21vpu/8OiLDpWexFF3AQMBsrcmTUO52bx6fkUVGX9lh+zqgjwZs78vD6qhT/ll8lSmElmT060cmkvUmlC559ZNhjPakk8gxqB6ZlXv6AvaZRzgbBZ9+khvIgFJcmKVRf7S/rAODMm/+i76M6u2ELXNdZ9uUOrSFHuilBjwkVcLdNUwxWphZcywvgbX/d6F4Yw1lJxn9XQDx1Xzdwr8WKzNnLQhFfV1MHCGd6hzB4MTt31Igt9HjrBXCOKWbon4BP4wvO76aVJNYrX4ICTfGD3IeP67LA4q54kN7yVJokwwvV2P4nrblR7kKCvMQFMlVQiSGr/pjTvp9zYDpQDv5hyCJzck/pXsgWA9RaxOiqNDLovX0N/gK3uLWIxBdfTZqsdHILOAddeaqy5OjaB/LxhHSEKDUdlNtc8jOdNPQ/7aTQ31M18xhu9U1b1UzSt0qnlDWlKFY3hOrLNfEqvl5ro60epYcicQ9wqJbEwBQkz5AR4jo43xGcD52Kq8cD1EGrAGSNSvT1XJjtpYZ1gvx8HIMoC59VZPpJGw+m6iEivOmUFGyNyXIOSiAoqaBNj3BW+tDkX3CS8uJCZiPyF7DQ=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(39860400002)(346002)(376002)(136003)(46966006)(36840700001)(36860700001)(86362001)(26005)(36756003)(8676002)(82740400003)(4326008)(336012)(8936002)(478600001)(7636003)(36906005)(1076003)(6666004)(16526019)(5660300002)(83380400001)(316002)(110136005)(54906003)(47076005)(2616005)(356005)(70206006)(186003)(426003)(70586007)(107886003)(2906002)(82310400003)(41533002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 11:46:40.3049
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 01e1cabc-e902-4fbf-1dce-08d95bf4849e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT064.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2998
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

