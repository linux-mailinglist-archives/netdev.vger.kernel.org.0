Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51E4C46E657
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 11:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233508AbhLIKNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 05:13:40 -0500
Received: from mail-bn8nam11on2070.outbound.protection.outlook.com ([40.107.236.70]:2973
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233438AbhLIKNg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 05:13:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aVxGdEprVMllX1NG+DRWbPrFHSnV+Q87TrDQT19NZ2hZzZpuiLlQj+6a4Ji+uGSBjHg+R26nXOoVLKxYi5gJOyuKzyunmq8QtQz/yvPAPDjBggx9BR7w2SZ+5ATJxHiXGYMBqOiH8rJ1KRFJhYWaqU/U0i4AEcFUtkNcdqsj/LON4tOPzZ9tzDUTFa2HcihoaHahGj4SUdxQqe3ZmEQz+C29BcriNhYCaq8HTRrnf1BxGBcjYyXAGUCducMwygB4WoGNwgpv8YE6IMeTCVWZTTvdkcT24Jwgmlv2tpl/A9iP05Hj31IoE1TvReySMFhdTLpZqUgOuFefqomgI6DYmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fBlgrDTQ7dqnqNMoSVQAssmI+LEq8AF4WB5QjgpPCN0=;
 b=iIqCCf2oo3uHhUekqaSC/L1fWSG4LqPAm91x6qlVb+YTT0JgbVBjOSySRwVqWyLEIcmSZ0aRWW+E8hTJ1AMwwLsP+EYTLbaxiLDv4oF1YlvehOFEcxFkR3SKPVOcw2rmYuzZsK5sMYObu+kUtbVB8V7bmyp6MEHKj/KUOOVFvxsHSMQVXCxp8moBBhDz+qMWDGJPrSQ8kX8KmItNyVa9pRcWham1cjIID2jrgopT5SACTGLntPrO+qFbR6zmlBA+yKA03ekbYaanjCJYMvhh2E0nRT3YS2PT3mTNLonVoydhQ0lOZuFfs74jigrgDBAMqneO3edWZle24AQRkva8Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fBlgrDTQ7dqnqNMoSVQAssmI+LEq8AF4WB5QjgpPCN0=;
 b=TT3zL7sZDIvm+5fQIkjv1+RFKs5U6ePAqnFmOCXeKZ2/VH9QPahFu60fw/6QvWGbVFLE6JKUtqrFsWudJdESxbn3qHvcbNMpDofCZUnr1+sEzqNeNCg0DO7au16fxcPpgUGFPjV70vofoMtvkquUjulN2BXBqCcDyh1NyofcKC2Ki5bbbrvYtlmw0M4kTTL753M6z1awmq0+lBqPQLiObZnp1iWGOOQmG6FFLHBZnJxZpnYsDTxF3havZe4ozXIKFNuQSwCfkTNudHzBCtbnbEzo5aEwWvXBxfGMGfs7ka3c8CMi6aOIjSM0gxEIs8PxxIONeEFjQxRdDuSyebMbuA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5373.namprd12.prod.outlook.com (2603:10b6:5:39a::17)
 by DM4PR12MB5311.namprd12.prod.outlook.com (2603:10b6:5:39f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11; Thu, 9 Dec
 2021 10:10:00 +0000
Received: from DM4PR12MB5373.namprd12.prod.outlook.com
 ([fe80::10d0:8c16:3110:f8ac]) by DM4PR12MB5373.namprd12.prod.outlook.com
 ([fe80::10d0:8c16:3110:f8ac%7]) with mapi id 15.20.4755.022; Thu, 9 Dec 2021
 10:10:00 +0000
From:   Shay Drory <shayd@nvidia.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     jiri@nvidia.com, saeedm@nvidia.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Shay Drory <shayd@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH net-next v4 3/7] net/mlx5: Let user configure io_eq_size param
Date:   Thu,  9 Dec 2021 12:09:25 +0200
Message-Id: <20211209100929.28115-4-shayd@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20211209100929.28115-1-shayd@nvidia.com>
References: <20211209100929.28115-1-shayd@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6P193CA0076.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:209:88::17) To DM4PR12MB5373.namprd12.prod.outlook.com
 (2603:10b6:5:39a::17)
MIME-Version: 1.0
Received: from nps-server-23.mtl.labs.mlnx (94.188.199.18) by AM6P193CA0076.EURP193.PROD.OUTLOOK.COM (2603:10a6:209:88::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Thu, 9 Dec 2021 10:09:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 15eccf68-c18f-4a24-39e9-08d9bafc0f13
X-MS-TrafficTypeDiagnostic: DM4PR12MB5311:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB53115A724E75BB8D06535367CF709@DM4PR12MB5311.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J7Cb9C8U/Mjatkq0XKiQG54ndr+iGHtgXwSJJqMwO0ebWECCgVtlTCTbzF7QFFG2MZeVvXy1CvIyNR8X2qxGYAXb0uDTh3oI28BJEkvilZXd5UT5KqYBciAEhvIaS6/iIBDwPX5xHocS0TXwAqfsUvqsBvB+eAMNqfdUg2ddiDyfNleM/UIH1uxEnOdIQ3ONp6t3qG58giFc6LGFia6Xp1sRO8rmdfBLuKBjlo/WuifYvWLDHoKsqiuMkoDPAcyOXno39pT5uhvlqbSzKNYZh5imH0i1r4B4UfBQuHZjEY5q+UM4dY75W9cM5EPDtxpxpTG7zXzjiQ5vQiZNcYS8C7Yt52vgHdDkSb9mOx6SrMfRjMmN79UOD5NhQ0bhmi1LwQcGYT9ROX/AVImiGx67C2jAghw9tMi2t+uDKrqKLUaKuBk1lYLbZMHOtqco0MuhvChUbOYe0Kf6wjAUaoQXcJu8Js4fex8AQXkf7Q344HG9SLxeKWO2yP8FIcRYwLyfrGLhOQSjAOA/1MY/lCNj1I9QRqpcFBIExH83NACMbCJXDIecu1wFssrUjxxDfex6HizxPawEv9GBYfbJjsXrKE9qRRSXUhEaUSpwFcvHYEInmMy8ZJ+pNUS8RJSS60PoMNLI7Lfj99cbd9yiVsVG0oBJWQnn1zDZR5MtPAbCGaEPyNrItTRtMy2k8T7t+N3LsN1abprU0Lx7c2iIzqzQow==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5373.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(66476007)(66556008)(956004)(38100700002)(38350700002)(2616005)(508600001)(6666004)(26005)(6506007)(1076003)(4326008)(52116002)(5660300002)(316002)(8936002)(54906003)(110136005)(107886003)(2906002)(8676002)(186003)(6512007)(36756003)(6486002)(86362001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gq5yVg+eMzBdbbBqVzOZjCNF9x+0D9mqPSV5pinmZWiumeCjAso5HZjWFmYc?=
 =?us-ascii?Q?8tzn2WTWt5zmiw81xlM0U8gzS1TJQb3lACNKe0YZK0yQEAIORXg1IvyPcu+t?=
 =?us-ascii?Q?i+dXQl3zIlacOY+96+oozgcGgVlXjD+uLwfqNXoScXsSwtrsdNCWta2bvN2a?=
 =?us-ascii?Q?8edko9B9TFniEQSByClZ2w2nkOt5f0muTLJpniIpYxVIjLjzKdq9H/g4yxof?=
 =?us-ascii?Q?QvJxVj6AILlmP7pP62xQb+Bfc2Y9R7eilt6sPo/CqWCTPnSMrELG0rY32YHt?=
 =?us-ascii?Q?1ZlAkorv2nLKbYM6KVx/3Dk+zIYYxO7XdpxWs20KPcbVXn49hiUS5tcWUBD/?=
 =?us-ascii?Q?5ZeVnBV1TsO3dzvbwENyevDdZdgQMyULgu4bIbA3T9VfF3T58tdhN3p1hZE2?=
 =?us-ascii?Q?mlJo3msnzYCVycg4M353rQul3pLE3jRbXj4GH5z120GBqg2Kc3LZvDW2L7GK?=
 =?us-ascii?Q?jnOVnZWtSipjbUnTKua93zvd4sH3O22U4CvCEY9jc+k0y6Vm/bIHPYyoo4hG?=
 =?us-ascii?Q?LVkF8OJUzsao38uwOln+cPVF13sUT3Mt/qF/l4hNROCWeC+9acpmNtno7p/f?=
 =?us-ascii?Q?hDRO8G/i3/T2h5JPadN8W/kNmTovVBAL2pIjU7oUxFBetOipf+1zwCZsgNm2?=
 =?us-ascii?Q?AtlkjcLPVFDgLdACOE+5aSYQzEQ/0yid+i9uJMlnJqy93GUeMkC0XV+Ithv2?=
 =?us-ascii?Q?AJxBUnxHQvKLq1wjXpJA97hB3UNtg3eaoY5hiHxLWIgtY/C5huaIJaTTYjqM?=
 =?us-ascii?Q?1bXLvBL3z2N8ebzt8f16c/zdBdojDq4Z+tSptmEE5YjokEPrGMCDPPISNr4S?=
 =?us-ascii?Q?kf8fO5X1EbkPEPXj5pNOjFt3dzvABUSBqj7t/5DbwiNyJRqMjcC8mAQhC337?=
 =?us-ascii?Q?dq2NfI4N88AWFFgdAXAnb+WXusNqQOwpKZAOr2MbxdaywuM+v7AuxYxss/2q?=
 =?us-ascii?Q?1oYx5A7TzyW9hmGrA3fwpWPxxUsjoJfKvDuZtmrM9TzICS2HqK5CLwzRbPjL?=
 =?us-ascii?Q?o3eVEK4flH/lGntI/9NAiZxEkh1F1STFt0ZON9tBCs8Xy6TJJT/+ZtP0ufBs?=
 =?us-ascii?Q?lCp6az56MCyFWtEJ9KaUKBRIV1uCRUAopGkBd/lWrwL5WcWZ5NMZFi7EJYX0?=
 =?us-ascii?Q?4zgtNNOW+eIAGu7EvI2pQYU902ROvQNM8tHrg5cGK7U5s72PreHKb8SNgI+9?=
 =?us-ascii?Q?mHV612g0MWMW274E7DXtHCM63HBBdB9FHqXKAeqW8snigJjLezSqol30+A3U?=
 =?us-ascii?Q?mjJ2fXAW4QEyHVXUWLfgpoOU2eaj5im+pznXXi1HfyyfS0/vRMs56nDP7jI/?=
 =?us-ascii?Q?itaQqMMpnoe/r+WBwx0N8lr0FD9eaU9UzW/ddTJLbwgUh53X9pn/gc1OlmUl?=
 =?us-ascii?Q?e0GqcbtsfW2S1Pe1D0bxDT0QGbVQ6ZsBcUHuI5NbSptzJMq0FLwff7LBcpH/?=
 =?us-ascii?Q?zNL7bZrmdmVSoPHtpZkgvuwS9z8iOTPG07diCI87L/zDM81t/8rDmDgRQQVW?=
 =?us-ascii?Q?Kdt2/4Sg3kWZKV99WiPf19tjUc+JfNYqOHwtXBk4gjjabXKLg5rq9f6co8F4?=
 =?us-ascii?Q?aIjzoTyRMdFPWI8avEKYCvNbnIxIqmVMgGftXd3VBZsqZK38G6c9fS6qf4wh?=
 =?us-ascii?Q?BCaJC7GhE1O/yq41FLkFdvs=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15eccf68-c18f-4a24-39e9-08d9bafc0f13
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5373.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2021 10:09:59.8861
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ufed+p2OORwFwUNFkcgwJ29MpwTIYMqPWCyWg4dr+UsvaLrZp1V3gwtV6bfhu9I7TfG/iUqwprxuiYiy1xsZzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5311
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, each I/O EQ is taking 128KB of memory. This size
is not needed in all use cases, and is critical with large scale.
Hence, allow user to configure the size of I/O EQs.

For example, to reduce I/O EQ size to 64, execute:
$ devlink dev param set pci/0000:00:0b.0 name io_eq_size value 64 \
              cmode driverinit
$ devlink dev reload pci/0000:00:0b.0

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
---
 Documentation/networking/devlink/mlx5.rst      |  4 ++++
 .../net/ethernet/mellanox/mlx5/core/devlink.c  | 14 ++++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/eq.c   | 18 +++++++++++++++++-
 3 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/devlink/mlx5.rst b/Documentation/networking/devlink/mlx5.rst
index 4e4b97f7971a..291e7f63af73 100644
--- a/Documentation/networking/devlink/mlx5.rst
+++ b/Documentation/networking/devlink/mlx5.rst
@@ -14,8 +14,12 @@ Parameters
 
    * - Name
      - Mode
+     - Validation
    * - ``enable_roce``
      - driverinit
+   * - ``io_eq_size``
+     - driverinit
+     - The range is between 64 and 4096.
 
 The ``mlx5`` driver also implements the following driver-specific
 parameters.
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index 1c98652b244a..177c6e9159f8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -546,6 +546,13 @@ static int mlx5_devlink_enable_remote_dev_reset_get(struct devlink *devlink, u32
 	return 0;
 }
 
+static int mlx5_devlink_eq_depth_validate(struct devlink *devlink, u32 id,
+					  union devlink_param_value val,
+					  struct netlink_ext_ack *extack)
+{
+	return (val.vu16 >= 64 && val.vu16 <= 4096) ? 0 : -EINVAL;
+}
+
 static const struct devlink_param mlx5_devlink_params[] = {
 	DEVLINK_PARAM_DRIVER(MLX5_DEVLINK_PARAM_ID_FLOW_STEERING_MODE,
 			     "flow_steering_mode", DEVLINK_PARAM_TYPE_STRING,
@@ -570,6 +577,8 @@ static const struct devlink_param mlx5_devlink_params[] = {
 	DEVLINK_PARAM_GENERIC(ENABLE_REMOTE_DEV_RESET, BIT(DEVLINK_PARAM_CMODE_RUNTIME),
 			      mlx5_devlink_enable_remote_dev_reset_get,
 			      mlx5_devlink_enable_remote_dev_reset_set, NULL),
+	DEVLINK_PARAM_GENERIC(IO_EQ_SIZE, BIT(DEVLINK_PARAM_CMODE_DRIVERINIT),
+			      NULL, NULL, mlx5_devlink_eq_depth_validate),
 };
 
 static void mlx5_devlink_set_params_init_values(struct devlink *devlink)
@@ -608,6 +617,11 @@ static void mlx5_devlink_set_params_init_values(struct devlink *devlink)
 						   value);
 	}
 #endif
+
+	value.vu32 = MLX5_COMP_EQ_SIZE;
+	devlink_param_driverinit_value_set(devlink,
+					   DEVLINK_PARAM_GENERIC_ID_IO_EQ_SIZE,
+					   value);
 }
 
 static const struct devlink_param enable_eth_param =
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 792e0d6aa861..7686d7c9c824 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -19,6 +19,7 @@
 #include "lib/clock.h"
 #include "diag/fw_tracer.h"
 #include "mlx5_irq.h"
+#include "devlink.h"
 
 enum {
 	MLX5_EQE_OWNER_INIT_VAL	= 0x1,
@@ -796,6 +797,21 @@ static void destroy_comp_eqs(struct mlx5_core_dev *dev)
 	}
 }
 
+static u16 comp_eq_depth_devlink_param_get(struct mlx5_core_dev *dev)
+{
+	struct devlink *devlink = priv_to_devlink(dev);
+	union devlink_param_value val;
+	int err;
+
+	err = devlink_param_driverinit_value_get(devlink,
+						 DEVLINK_PARAM_GENERIC_ID_IO_EQ_SIZE,
+						 &val);
+	if (!err)
+		return val.vu32;
+	mlx5_core_dbg(dev, "Failed to get param. using default. err = %d\n", err);
+	return MLX5_COMP_EQ_SIZE;
+}
+
 static int create_comp_eqs(struct mlx5_core_dev *dev)
 {
 	struct mlx5_eq_table *table = dev->priv.eq_table;
@@ -807,7 +823,7 @@ static int create_comp_eqs(struct mlx5_core_dev *dev)
 
 	INIT_LIST_HEAD(&table->comp_eqs_list);
 	ncomp_eqs = table->num_comp_eqs;
-	nent = MLX5_COMP_EQ_SIZE;
+	nent = comp_eq_depth_devlink_param_get(dev);
 	for (i = 0; i < ncomp_eqs; i++) {
 		struct mlx5_eq_param param = {};
 		int vecidx = i;
-- 
2.21.3

