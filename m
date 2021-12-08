Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7966746CE00
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 08:00:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244367AbhLHHET (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 02:04:19 -0500
Received: from mail-bn8nam11on2046.outbound.protection.outlook.com ([40.107.236.46]:39809
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244385AbhLHHEP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Dec 2021 02:04:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XFc9BJJpxmnrqosAueLj2c6Z4FwM8nS3SkjC/EcuqqoI7KirHcdoXdFVudXSWI983FCrCmX0nDlnKo0S38pTvjd5iPc2m7kpNQ2+Z3pN1zpiCOurAAtkCTkBt+jpYtjOJIXAvTGwLbBJZQam8mDb0VHhW4zLyPwhYNCga91mbv9sdF6zVDZM9y1wRJWq0D9u2HlMMWGC9ARdhAlzAToafzQqxJnNVtjYRytt7dvp9tqMgp9Sdf9twlt878SPkn066vfEmiiuFAATI7MWRJyPSAGdN74h+zNtEjCHs92m7zOuNtMrLfrZey1Pk4qZyItxSNSDfB3tOvhQxgR8Z+p+/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U41keckc4qw4/dBUqZGycfcApnmXn3HPWyp9DlJ0N/g=;
 b=K8qXsxFGXR6TymKEwDKFKkxt0oGYxozeb4+3vHsKLISQNk/EkrNMRZ+1Bh0MeMD2kwT/RKwP22vFgGNBT6sh3byyCFS+h+5LgQ2G2ytoD2SuDd/rLBcq4KfUuEgcgID1hChpGhqRVGORQk/G36UsUf1ip3Jjm0RtU4wzIO2Q6x/xt5Wy5iz14krAcV3TDCfLaP4y0HLnP5aVl4BNcjzGVjL5Gja124VKuEJqh4eR17EaCwamCkZD0aGla5tTVsHfRrLqYItyswE+sepIp9c6uDTSdAARisUatHbnFd2ajRB5TBxoXzXjNeM+TYivDRvWTot5D8F0xEo5oqiKFMinFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 203.18.50.14) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U41keckc4qw4/dBUqZGycfcApnmXn3HPWyp9DlJ0N/g=;
 b=XemEvXqSfDhZCTUIQehc98V0cD8KMMfHLwilRoD9uY+0BLOFPkWotEdVnsJ/gzdEH8tJTYxBPxW1+MQZdFjN+BlH+f4L0rVzX3c/2AMQ8INzlzNKCfGyMB2qXhVkgbe5NPcNo48A3blCfq3Z09BGvGCc/iqkAp6gSQtWYVSbPCv4/XJfpppS3VJxW99G5jzJnMRirTyUrfn6sqRzCCtNYiI9cg4mx216EsYdm59ytVgykEtrFE5D0AAY+GqqxFlIest3/l3/FaGEMmmCugNhi9v54GK1lVvjo/W1hp+oR8SAPOGWktPdPerFY2yz81CuMaigiUHrqvBK/FKLuMR7Pw==
Received: from DS7PR03CA0359.namprd03.prod.outlook.com (2603:10b6:8:55::35) by
 DM6PR12MB3483.namprd12.prod.outlook.com (2603:10b6:5:11f::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4755.16; Wed, 8 Dec 2021 07:00:42 +0000
Received: from DM6NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:55:cafe::d3) by DS7PR03CA0359.outlook.office365.com
 (2603:10b6:8:55::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend
 Transport; Wed, 8 Dec 2021 07:00:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 203.18.50.14)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 203.18.50.14 as permitted sender) receiver=protection.outlook.com;
 client-ip=203.18.50.14; helo=mail.nvidia.com;
Received: from mail.nvidia.com (203.18.50.14) by
 DM6NAM11FT060.mail.protection.outlook.com (10.13.173.63) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4755.13 via Frontend Transport; Wed, 8 Dec 2021 07:00:41 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by HKMAIL103.nvidia.com
 (10.18.16.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 8 Dec
 2021 07:00:31 +0000
Received: from nps-server-23.mtl.labs.mlnx (172.20.187.5) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9;
 Tue, 7 Dec 2021 23:00:27 -0800
From:   Shay Drory <shayd@nvidia.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <jiri@nvidia.com>, <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Shay Drory <shayd@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH net-next v2 4/6] net/mlx5: Let user configure event_eq_size param
Date:   Wed, 8 Dec 2021 09:00:04 +0200
Message-ID: <20211208070006.13100-5-shayd@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: f1abbf0a-aa76-4467-52e8-08d9ba187318
X-MS-TrafficTypeDiagnostic: DM6PR12MB3483:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB3483A5494731397039BFA72DCF6F9@DM6PR12MB3483.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /hvr3onln7EyPbwaWRFNPLu/1jVuw6PMhrev744G7pec4soeqoq8eaJ921gWEQgIhUYSEUd24EvXDeAGpHz/c988FKFeUSPfw+8uc2eHTViouSGYSEpbWEUQCBmZLMKzmvaTrlRHpuvV70ls6JDqs2OPysdkwZYvKqCDMjLaHz+UIHJR6PCoBbgTTG0j41DcKkY9ObCON/hb5pwAFQb63Wsa9PVuUixYtzeCC+vWTIKNwS1r8oqLh8JOEcdTLAIkpfIHcZxddf+lZeZiS/Fx8/ELxYc/IPghbX1m1tv3upUmoIr9L6BVv+8BlIfY2XfByueOBRxB57MUI/R9c+E9wGZcigfKRNB3LyAUcTquNLQLO7yWYChxs6GGme6opXrr/6nx9RdP/8fsXe+ar+sCxafWyC469mYfEBdENXfKrw2/bWHLvOXyQN7gwsU4i0ip6f/U3bgjeejlW/vEvy3c1YqgR4btIj2n5KtaHR2zkHoa90LAxVgWhJFCoiM7ej5CnBrkP1X3p+sT5PZh7bqwmUpIlg3A+0teuuXl/fRwbE80LKyF5VfAokZG05kwK1GCnuJE4U98juoHvVQzWlFa0JNZWTZM3nUpyiSLgjDC+PCCWpBoQCcmlqRPvyZ5GG85ohuyLhr0UC0gBtMsAXIvn+ESKqJxoGps/XTv/FC0Prd7wj3JMXxVgVfB2Je0jnDK4Q9mdFLR+pUCdTg43KF2R10ME8/mrqIte+TpKsvPSkWqcm7C4HczvmYQMay8EMFul1558RqCbGVgzQrm50wXSy51KbsMEIOVfqljXIumGKo=
X-Forefront-Antispam-Report: CIP:203.18.50.14;CTRY:HK;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:hkhybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700001)(6666004)(26005)(2906002)(36756003)(110136005)(40460700001)(70206006)(186003)(16526019)(70586007)(83380400001)(356005)(86362001)(2616005)(5660300002)(54906003)(1076003)(107886003)(4326008)(8936002)(336012)(7636003)(316002)(8676002)(36860700001)(82310400004)(508600001)(426003)(47076005)(34070700002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2021 07:00:41.8216
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f1abbf0a-aa76-4467-52e8-08d9ba187318
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[203.18.50.14];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3483
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Event EQ is an EQ which received the notification of almost all the
events generated by the NIC.
Currently, each event EQ is taking 512KB of memory. This size is not
needed in most use cases, and is critical with large scale. Hence,
allow user to configure the size of the event EQ.

For example to reduce event EQ size to 64, execute::
$ devlink dev param set pci/0000:00:0b.0 name event_eq_size value 64 \
              cmode driverinit
$ devlink dev reload pci/0000:00:0b.0

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
---
 Documentation/networking/devlink/mlx5.rst        |  3 +++
 .../net/ethernet/mellanox/mlx5/core/devlink.c    |  7 +++++++
 drivers/net/ethernet/mellanox/mlx5/core/eq.c     | 16 +++++++++++++++-
 3 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/devlink/mlx5.rst b/Documentation/networking/devlink/mlx5.rst
index 291e7f63af73..38089f0aefcf 100644
--- a/Documentation/networking/devlink/mlx5.rst
+++ b/Documentation/networking/devlink/mlx5.rst
@@ -20,6 +20,9 @@ Parameters
    * - ``io_eq_size``
      - driverinit
      - The range is between 64 and 4096.
+   * - ``event_eq_size``
+     - driverinit
+     - The range is between 64 and 4096.
 
 The ``mlx5`` driver also implements the following driver-specific
 parameters.
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index d8a705a94dcc..31bbbb30acae 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -579,6 +579,8 @@ static const struct devlink_param mlx5_devlink_params[] = {
 			      mlx5_devlink_enable_remote_dev_reset_set, NULL),
 	DEVLINK_PARAM_GENERIC(IO_EQ_SIZE, BIT(DEVLINK_PARAM_CMODE_DRIVERINIT),
 			      NULL, NULL, mlx5_devlink_eq_depth_validate),
+	DEVLINK_PARAM_GENERIC(EVENT_EQ_SIZE, BIT(DEVLINK_PARAM_CMODE_DRIVERINIT),
+			      NULL, NULL, mlx5_devlink_eq_depth_validate),
 };
 
 static void mlx5_devlink_set_params_init_values(struct devlink *devlink)
@@ -622,6 +624,11 @@ static void mlx5_devlink_set_params_init_values(struct devlink *devlink)
 	devlink_param_driverinit_value_set(devlink,
 					   DEVLINK_PARAM_GENERIC_ID_IO_EQ_SIZE,
 					   value);
+
+	value.vu16 = MLX5_NUM_ASYNC_EQE;
+	devlink_param_driverinit_value_set(devlink,
+					   DEVLINK_PARAM_GENERIC_ID_EVENT_EQ_SIZE,
+					   value);
 }
 
 static const struct devlink_param enable_eth_param =
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 230f62804b73..3ec140af66fd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -623,6 +623,20 @@ static void cleanup_async_eq(struct mlx5_core_dev *dev,
 			      name, err);
 }
 
+static u16 async_eq_depth_devlink_param_get(struct mlx5_core_dev *dev)
+{
+	struct devlink *devlink = priv_to_devlink(dev);
+	union devlink_param_value val;
+	int err;
+
+	err = devlink_param_driverinit_value_get(devlink,
+						 DEVLINK_PARAM_GENERIC_ID_EVENT_EQ_SIZE,
+						 &val);
+	if (!err)
+		return val.vu16;
+	mlx5_core_dbg(dev, "Failed to get param. using default. err = %d\n", err);
+	return MLX5_NUM_ASYNC_EQE;
+}
 static int create_async_eqs(struct mlx5_core_dev *dev)
 {
 	struct mlx5_eq_table *table = dev->priv.eq_table;
@@ -647,7 +661,7 @@ static int create_async_eqs(struct mlx5_core_dev *dev)
 
 	param = (struct mlx5_eq_param) {
 		.irq_index = MLX5_IRQ_EQ_CTRL,
-		.nent = MLX5_NUM_ASYNC_EQE,
+		.nent = async_eq_depth_devlink_param_get(dev),
 	};
 
 	gather_async_events_mask(dev, param.mask);
-- 
2.21.3

