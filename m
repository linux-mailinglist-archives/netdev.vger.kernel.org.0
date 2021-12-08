Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA16346CDFE
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 08:00:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244386AbhLHHEP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 02:04:15 -0500
Received: from mail-bn1nam07on2065.outbound.protection.outlook.com ([40.107.212.65]:57766
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244379AbhLHHEM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Dec 2021 02:04:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D7aQaf6gM1b+vNPvC/+8Ibe2MknCV8/mPnuiRZR1Dci2hy+RECzH+BAK0NLABwI4D1ECh84QtXUElz9aDNjF5prs7BO+WKRjqlwXxMJnzW7M0S5fb68ToopqIyilHTYAXGxMkgiZKWqbuA8we33uV1GWEQmLlzMhL3PEsR8rEBZLjt32LLgNrwiJbC4xFDIsbj6jklFwjev/5qi4gbjX0l3hhojK05Ys3L/TvLj7Ab413vaB5bPbIHGpGJPwcT+PCkOqZ9kl85zY3+CbKjbJegZaOUA8JqLR8ebLbISzqr1dMYWnJCHlEcCYgX5Q9ludhOjzgMTnxzk8iHs1Yi3+3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2xvQj/XSKmsl7OVPJNCnGhhanzEZqU9Gl/4qPdCkZqc=;
 b=dnYX3AYB0QYWg8t1F1Fj3DVBZxF1UEGCp7v5ouG/MpLzV2eMcRzweW+RJu5844lRY1GZkmNvnDerTfXPc/E6xWRtEXXEJzxTpXJbF0vosJGfOnNnCxeSh8TRE3rf1VEUM/N+eKmCo3lI9eKPJtzCymibUfyqjr2W3v/ZjRTRJm0J1z33xh45tQ2K5kzxoG75kr1tfFFWLRlMBjqj+dGLkA+FO++NIwOiS5EVQTCZU8SttxSCvn24ZBS5oKInc4qomgWeG0B0lJEZWuuvtD1b1FuxFHMBidSWMzLXAAVKerb8o+yv3qlBFIHKHixMqhaUt6fe0/ySQnPV1nL7mO2CZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 203.18.50.13) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2xvQj/XSKmsl7OVPJNCnGhhanzEZqU9Gl/4qPdCkZqc=;
 b=gtNYad5nrzmgEpt5PSm1BEzghOc/YFAS/VDqVeXLSe15sic24wxuTQTQRM5C42xskDikhgkMkWKDyMVi+5g8Kq6kDhNTLU8kS0IBCWdzN+VALLe/LS8a7utSADufpcJDUgISA2M9WgM4eMOEhKVsiqXNPFkJCYJPr5SAbWjKiNFZvR73XG+Hk9n+4x3vG0rVmDB9E03Jw6Rkcoxryekk3NnQBQTXYaHZD9KSTx81ncM8Xpbasabk2HCbfhqq3ewFqVkXRSOkH0pOQhjPXTmT5g7yn7JSwUFAT9L4crRhe1gVNUDT7Jw8vWKxk8tJf+yXiZn2/NXIdwCpC7C7T3uGGQ==
Received: from DM6PR13CA0045.namprd13.prod.outlook.com (2603:10b6:5:134::22)
 by SA0PR12MB4464.namprd12.prod.outlook.com (2603:10b6:806:9f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.24; Wed, 8 Dec
 2021 07:00:39 +0000
Received: from DM6NAM11FT053.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:134:cafe::86) by DM6PR13CA0045.outlook.office365.com
 (2603:10b6:5:134::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.10 via Frontend
 Transport; Wed, 8 Dec 2021 07:00:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 203.18.50.13)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 203.18.50.13 as permitted sender) receiver=protection.outlook.com;
 client-ip=203.18.50.13; helo=mail.nvidia.com;
Received: from mail.nvidia.com (203.18.50.13) by
 DM6NAM11FT053.mail.protection.outlook.com (10.13.173.74) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4755.13 via Frontend Transport; Wed, 8 Dec 2021 07:00:38 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by HKMAIL102.nvidia.com
 (10.18.16.11) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 8 Dec
 2021 07:00:26 +0000
Received: from nps-server-23.mtl.labs.mlnx (172.20.187.5) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9;
 Tue, 7 Dec 2021 23:00:21 -0800
From:   Shay Drory <shayd@nvidia.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <jiri@nvidia.com>, <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Shay Drory <shayd@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH net-next v2 2/6] net/mlx5: Let user configure io_eq_size param
Date:   Wed, 8 Dec 2021 09:00:02 +0200
Message-ID: <20211208070006.13100-3-shayd@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20211208070006.13100-1-shayd@nvidia.com>
References: <20211208070006.13100-1-shayd@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ae2e64e5-2435-42d7-4569-08d9ba187161
X-MS-TrafficTypeDiagnostic: SA0PR12MB4464:EE_
X-Microsoft-Antispam-PRVS: <SA0PR12MB4464C94FAA3CF85885ED0BCBCF6F9@SA0PR12MB4464.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Je01/jwqqjwQ5sdvqBHeRon6gB/l/7RKJnlPh4Ig7PRkgOI7lA2C+wjillwmdmsoseslEabpZT5Qf5yJUMtbaEj1ouJje17YWtSc30x30GrnjRozpZ9+dp+hPTQExrVFxQq7FX9wrVbSTuf+sBXynQKahL9gp3tU5Wtusv+9hqxwsVBGzirw+Q2sJxAZp9tmOHj7Wkdy3K52OhYIho9oiUV+A+uDZQ/tG/uwFzwR/TBkjIIbuyNQUg9YC9Bc51hQ+zbBoFix5lU6fRkaoFvrm1dUzDEVMmTPonUhGVozT1/9qQbFwUWpf4wdmf8htDo6CjBvZgsXQrgRPidByKbscdMtG7eRHWffJ3jHcuGa+hyvjutnBmIvLwMihStJPjeDsJ5PYMGFfjHy2/PTmR8BHJuHAGxP1CV2AIByeeMBV8d6Kp303F651hdqrap6S0qmKhvcl95fRAzmRX9eL0t5nKSUOcvisAyfUDvwQHQIGamqMTYgefv7dk0eQZEPmRRtnql65i8ZQlGKz5N8xFgIcD+/CQZYN9mGeTasPkgyzYHCfuptG3TmSjU5suX3SZKtoL/7edzPThvV6wmg7UjNoZdkpVfQZhZlUUiQk4zub91c+wp+PeI1vTAyjKp4yTdwvp3pd0K5IMObwicgBTT1VBDBxNiDrKYe5lD7AVjxsT5h0/6vadXu7PT05IlPFK2OWzh5EsrLAU+zc0sFemh836oLxmFysOgW1YvW6VLwrK8uZEhHLkZoH3wl3VmiekIJOattpCGxFjtUoREyU6PzSvWSZeOaLpnqv4GDhDyU4VA=
X-Forefront-Antispam-Report: CIP:203.18.50.13;CTRY:HK;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:hkhybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700001)(426003)(1076003)(110136005)(356005)(4326008)(5660300002)(70586007)(8936002)(26005)(54906003)(40460700001)(2906002)(16526019)(86362001)(36860700001)(36756003)(47076005)(186003)(82310400004)(316002)(83380400001)(2616005)(70206006)(336012)(6666004)(7636003)(508600001)(8676002)(34070700002)(107886003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2021 07:00:38.9442
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ae2e64e5-2435-42d7-4569-08d9ba187161
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[203.18.50.13];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT053.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4464
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
index 1c98652b244a..d8a705a94dcc 100644
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
+	value.vu16 = MLX5_COMP_EQ_SIZE;
+	devlink_param_driverinit_value_set(devlink,
+					   DEVLINK_PARAM_GENERIC_ID_IO_EQ_SIZE,
+					   value);
 }
 
 static const struct devlink_param enable_eth_param =
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 792e0d6aa861..230f62804b73 100644
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
+		return val.vu16;
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

