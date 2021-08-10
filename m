Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7DB03E5955
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 13:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240194AbhHJLrD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 07:47:03 -0400
Received: from mail-bn8nam11on2072.outbound.protection.outlook.com ([40.107.236.72]:58529
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233534AbhHJLrC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 07:47:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R01P5wlsde9vnR0QhItQPJyPvFLl2rlUFNfWtr47ZHR4j1ve3n0OjgTyhx1hNKb20T98D4VcsKko3IOw2nrx5yHxr/fsJc1tm5kCb8iGvX2EpNo730GCnBmUe+6HB/pkZDQ077RMAzCfEFOGy4eIfOkjdNOCZNrUwaXCqdeyAG3lGXpV5fZGEn7Va6A3zjwrqvYAPqDNUuKekw5gULRBvkekgyeX5Y5CPPp605PEtwCMnEya7TLF335un4iXggclX+NgbTmxzv0G48QUuc501n/2WX6CRLFQOLwlLtUU9mBupAFc0KO+gQ48NA4xav54Qc6M2MNXKMwKQvEeoRsF+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ucsQipBWhfn8p1v19fYk1ba8LLdehNnjXA23LrWumeY=;
 b=NK9pmOAUkvoMbd54ataIfu1ZSJJ47yZ6ETmLTBomnKKRkL5YMIwYfs2UW1SZM2h8uKkkWxzgrjkPZCE5O15cJoQkrIVGcc+xnwonEDapq8BmbqCwWq+bVlYW80KyPrvKM6U2d8sdeYRfqI4xJ4sk7JOjcB2coG8td7DoFU8n/Lx6Zio1CuvErn0nhm6DsB9WfL84iWJvL1Tgqky2gUvFxJ2wgFZCdmS1pY0/I+1OiG5vZFtxjBYSahhG1MxA8K2huCm0YCOnBo1KT+pmCxn1RBBFBqkKj5s4LAoD2vGK3CbEJcUok8xsz+KSGi0+Rb0Vn+4DKwYUTGKCc4iFQ9DWug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ucsQipBWhfn8p1v19fYk1ba8LLdehNnjXA23LrWumeY=;
 b=CaUsHP5dQI9FuzOXS2ReCVz7KHGUp6Y8uHL6knkO1QkO51uLSeimFHo6FinB234nETrBvfJkaV5ch7vKi79mcYuTSztaagOFBMHI0aDZI5XHjdaiNFqWej8ci5BMRQ8GGrl+mPGgA1j5ecV3TbKHzVsCJR/8dtddP4Retv9nr/v6jh0t9iM6LWBdKD4f/zX5pgrAYHpRrVp5GWrSTIW1A7T8jQepuLq+BvXyLL7PwPja3wGpq8CjxBsxoZKZIn17dvDJUKR6ysnT6GQFyYyKJ8vHvp/m+htzEgaVYZzVxIhn40VleLuGXpJBOWDKlF1TlpJ9vNAaAwIBga0erd2bDA==
Received: from BN9P222CA0012.NAMP222.PROD.OUTLOOK.COM (2603:10b6:408:10c::17)
 by BL0PR12MB4964.namprd12.prod.outlook.com (2603:10b6:208:1c7::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14; Tue, 10 Aug
 2021 11:46:39 +0000
Received: from BN8NAM11FT064.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10c:cafe::cd) by BN9P222CA0012.outlook.office365.com
 (2603:10b6:408:10c::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend
 Transport; Tue, 10 Aug 2021 11:46:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT064.mail.protection.outlook.com (10.13.176.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4394.16 via Frontend Transport; Tue, 10 Aug 2021 11:46:39 +0000
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 10 Aug
 2021 11:46:38 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        "Leon Romanovsky" <leonro@nvidia.com>
Subject: [PATCH net-next 01/10] devlink: Add new "enable_eth" generic device param
Date:   Tue, 10 Aug 2021 14:46:11 +0300
Message-ID: <20210810114620.8397-2-parav@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: 280cfcbe-edd1-4224-4d1b-08d95bf48429
X-MS-TrafficTypeDiagnostic: BL0PR12MB4964:
X-Microsoft-Antispam-PRVS: <BL0PR12MB4964812F22E2ABD7322CAED7DCF79@BL0PR12MB4964.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aXU/OAudK7UusV/kVACg7qJEiNoXSowsPrkYyxZY2F2/H2y9BfWNh0PAgGlq0ybw5AHu5A7do2zvgd6oVJEpXGN/XJWoSUCBT0HQgHZGvhrnWbwcSvPMolC3SfbJadXwQNpDiaP1SHO2vzHyRiIvnZRvse9jgFVRjGSTJaFxSQpIILlcrQ78Fe+wQEF2TP47SJ84R3QyiG3EXZIq8XqpLMW55t7CTp5WG4alPe0Orio7JkaCvMbfjqt0Q68C3n2sobs+FE0nD2STugy01uG5I1UF5RQh9LAEekFBuOjgMzqpCAN9jpnu+hejkKToQmsmiDMTTzP4ZjLO0YYaZAJ+I2C+aACWBnxt7fOSLp6DVMPOQ9lgeVK7oqivLRltNXexG9ki7Wy3npkmk4lihCpks65wSqye+zTdsSy7bFpgUC/AsdHzCvelFzCh5pgNIfZyb+r3aq3dczWy5KEowpBY2sbBW5WCG3Cymqkr6lLzbBlpQWSPZD5rUitaSZSR5OzkxoCx7tZqwS0t3yJYTrO0AF8YRh02KJ7vEgPH+mpM30B3qBIJUuIAhdwcQs6kIwg/zsuaXqgnziTaYxKS925o32mfwZs68X5B12pbHt3QitnO9FGdePabVlBS+YGVUt9T9QXM9EbuDrk4Lyl5+UpseW1kNu03Ch3H806V/QVZiTUVMUtIj9GThgwUikCUyofLlMGse36loQ3rh1FoASwKk9p6pv6hHEC9RbhuXsZ/Z40=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(346002)(376002)(136003)(39860400002)(36840700001)(46966006)(6666004)(336012)(36906005)(356005)(1076003)(54906003)(110136005)(316002)(7636003)(82740400003)(16526019)(8676002)(478600001)(186003)(26005)(8936002)(107886003)(36756003)(70206006)(83380400001)(5660300002)(36860700001)(70586007)(47076005)(2616005)(4326008)(426003)(82310400003)(2906002)(86362001)(41533002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 11:46:39.5064
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 280cfcbe-edd1-4224-4d1b-08d95bf48429
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT064.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4964
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add new device generic parameter to enable/disable creation of
Ethernet auxiliary device and associated device functionality
in the devlink instance.

User who prefers to disable such functionality can disable it using below
example.

$ devlink dev param set pci/0000:06:00.0 \
              name enable_eth value false cmode driverinit
$ devlink dev reload pci/0000:06:00.0

At this point devlink instance do not create auxiliary device for the
Ethernet functionality.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
---
 Documentation/networking/devlink/devlink-params.rst | 4 ++++
 include/net/devlink.h                               | 4 ++++
 net/core/devlink.c                                  | 5 +++++
 3 files changed, 13 insertions(+)

diff --git a/Documentation/networking/devlink/devlink-params.rst b/Documentation/networking/devlink/devlink-params.rst
index 54c9f107c4b0..219c1272f2d6 100644
--- a/Documentation/networking/devlink/devlink-params.rst
+++ b/Documentation/networking/devlink/devlink-params.rst
@@ -97,6 +97,10 @@ own name.
    * - ``enable_roce``
      - Boolean
      - Enable handling of RoCE traffic in the device.
+   * - ``enable_eth``
+     - Boolean
+     - When enabled, the device driver will instantiate Ethernet specific
+       auxiliary device of the devlink device.
    * - ``internal_err_reset``
      - Boolean
      - When enabled, the device driver will reset the device on internal
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 0236c77f2fd0..1e3e183bb2c2 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -519,6 +519,7 @@ enum devlink_param_generic_id {
 	DEVLINK_PARAM_GENERIC_ID_RESET_DEV_ON_DRV_PROBE,
 	DEVLINK_PARAM_GENERIC_ID_ENABLE_ROCE,
 	DEVLINK_PARAM_GENERIC_ID_ENABLE_REMOTE_DEV_RESET,
+	DEVLINK_PARAM_GENERIC_ID_ENABLE_ETH,
 
 	/* add new param generic ids above here*/
 	__DEVLINK_PARAM_GENERIC_ID_MAX,
@@ -559,6 +560,9 @@ enum devlink_param_generic_id {
 #define DEVLINK_PARAM_GENERIC_ENABLE_REMOTE_DEV_RESET_NAME "enable_remote_dev_reset"
 #define DEVLINK_PARAM_GENERIC_ENABLE_REMOTE_DEV_RESET_TYPE DEVLINK_PARAM_TYPE_BOOL
 
+#define DEVLINK_PARAM_GENERIC_ENABLE_ETH_NAME "enable_eth"
+#define DEVLINK_PARAM_GENERIC_ENABLE_ETH_TYPE DEVLINK_PARAM_TYPE_BOOL
+
 #define DEVLINK_PARAM_GENERIC(_id, _cmodes, _get, _set, _validate)	\
 {									\
 	.id = DEVLINK_PARAM_GENERIC_ID_##_id,				\
diff --git a/net/core/devlink.c b/net/core/devlink.c
index b02d54ab59ac..9a59f45c8bf9 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4277,6 +4277,11 @@ static const struct devlink_param devlink_param_generic[] = {
 		.name = DEVLINK_PARAM_GENERIC_ENABLE_REMOTE_DEV_RESET_NAME,
 		.type = DEVLINK_PARAM_GENERIC_ENABLE_REMOTE_DEV_RESET_TYPE,
 	},
+	{
+		.id = DEVLINK_PARAM_GENERIC_ID_ENABLE_ETH,
+		.name = DEVLINK_PARAM_GENERIC_ENABLE_ETH_NAME,
+		.type = DEVLINK_PARAM_GENERIC_ENABLE_ETH_TYPE,
+	},
 };
 
 static int devlink_param_generic_verify(const struct devlink_param *param)
-- 
2.26.2

