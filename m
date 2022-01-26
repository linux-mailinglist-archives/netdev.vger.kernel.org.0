Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD3D49C795
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 11:31:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239984AbiAZKbr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 05:31:47 -0500
Received: from mail-bn7nam10on2083.outbound.protection.outlook.com ([40.107.92.83]:13889
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239990AbiAZKbn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jan 2022 05:31:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HCOLYecvLvfZtGNEej+0oa61fAaTd0TyLQooec/yfXpzRzgKywk+nd2RvesPTkqNiZWS2ZAHbIgm9qGMzPA2HJh7G2TokD92dKYmVIAPiPADwj0eydubX0NEVb/NfzqRnGipz85+8gwX7zb4mmYBqJyOApx3fNFrJEdpmbcUDqvR85we0HhWJv25mdT5UA4fQz1O82Pq+NDiCiUXIB+FmThsLBsYqR4gF2YWupAtqOCifP64urkoZcr0bmV51oa3M98Io98VEKPi+1rrY9+Fp1tQycmVqPrWw6Yl+S6HlZBW8vCKKVzOxQzIBAH1iRtj+JGGw0/FUEMNpbALTU7gYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZaHYKwGzM/pG2wV+309vZEqN5PtH/SckifWdsHc9Mck=;
 b=CRQofiUVI6PS0d+ly+IjwuFbOB32DuhmvhPmmITX54XdCOPF/KPz/aNaf/CdO9LaxRQQ01npeKXC+ReWdSsSdixpGyir57BKlPe2N1zQtFV8/Qn7q0MTP8HVXnaooYY6vFYMJZGGho5/7CjgJV3ADiW6hOy8y1cuBumshpUesObfpiX7Wld+Fj5l4kTRuNajbWCcfvrEBCrb/QrVg+mK4WvW39ZN0X7fygWTe8/j6UxiBdOweHjLae35/GjT5ggIbv6IukD4ov/fD/q21+A/620Jnp/YSgs0/vwEEfnVYrWLty8h+avU24laVp8HeWfPeD7Svf62vsHG1/zmtEzyzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZaHYKwGzM/pG2wV+309vZEqN5PtH/SckifWdsHc9Mck=;
 b=BC6Ur176EK5V2k8R4U295qQkba/VUuVzf7aD2iO39Ez04DW5ZuZcTb890QEbUUx3iFC8RfenEDBcnx2Yqr51W4O6GnxEFcUNIgK/frtdAxsiPuh25hbFHwv47TJGzwO4NCFEdscHSxj+GUkMDUbakyY/2SvPVijiApSuTSlvQQhp+8P4KHE86nzGODFIK2pqVSYZbKuACKtFZHOAHBqZtsHy9bBeByA4GSmvPHTg8vGbh8Z65hagGKVZzRDGZ5rXpYH+5pxf1GwScJ639zR2p7R4rGJ/9QUU9ofB/qOmLTx2b/ORSVq4rBqtmE9jv1K5XOrRIkKXLTvXifIPjesRzQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3527.namprd12.prod.outlook.com (2603:10b6:a03:13c::12)
 by SA0PR12MB4461.namprd12.prod.outlook.com (2603:10b6:806:9c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.8; Wed, 26 Jan
 2022 10:31:42 +0000
Received: from BYAPR12MB3527.namprd12.prod.outlook.com
 ([fe80::3dfb:4df1:dcf1:4561]) by BYAPR12MB3527.namprd12.prod.outlook.com
 ([fe80::3dfb:4df1:dcf1:4561%5]) with mapi id 15.20.4909.017; Wed, 26 Jan 2022
 10:31:42 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        danieller@nvidia.com, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 4/9] mlxsw: spectrum_ethtool: Add support for two new link modes
Date:   Wed, 26 Jan 2022 12:30:32 +0200
Message-Id: <20220126103037.234986-5-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220126103037.234986-1-idosch@nvidia.com>
References: <20220126103037.234986-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VE1PR03CA0057.eurprd03.prod.outlook.com
 (2603:10a6:803:118::46) To BYAPR12MB3527.namprd12.prod.outlook.com
 (2603:10b6:a03:13c::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e2a7b3bc-a28c-4626-4a55-08d9e0b70b28
X-MS-TrafficTypeDiagnostic: SA0PR12MB4461:EE_
X-Microsoft-Antispam-PRVS: <SA0PR12MB446121754241043EC5541A9AB2209@SA0PR12MB4461.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: baUcaWOUPVzAgjiGndAO7owhTvJ9P0hUtpkJn4IObEmydcUCzcboZV0dTBDg6lb1s0la6VVcdWWLuQfiprd9khP53FgscZ2DPevmd81U1nvQOnAmajc6yA1OU4oPgvPLJDxcaRlARvT6KFQmxWc93/ntjO5SCFk5gtDstIIZt5ReQeihvE+h8M7+G96tJYiSPjtMBfIk3cLOl6oDWEssFAXKhqoXNUaBBO+9KraYJKH/e1CUvjHU0f7W1j7oSfMACCBs8gT8qK+1US/nhuqxHq0N1x21absWuu81lEJi+6rzJ97kFAIwzDrIlMXCvqZP41Zy3Am6Ci107cX117k6ccjbm1b4Yib7AVqGG0o55LxgbioTjy9JgKHGyxy6OjA5uXxXdrwja+RC2LVuwaxsscoDQ1sdyxxqSSnbUEkSi4VBQ/Z6ALvepLzOcfOVHCt46e9YKQ+h5o0AM+xhdj+JLVu9gDjWwmrpPKsWp1H2dkAluMCGMnDdcHhv8ZiVEYexoUob90hnhlmMM40nxBVK2bMcK67UPft+OZHxFrqshrGxIcxoD6pVhkxGcOT3dx3jMbvnErARxIWXuoygygT5RCtWekTdiH83z78HSp+yc73WvqWQ5jaTcn/NjYYWY+vFwDLEwgIRlFsfY3yGEyCTeg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3527.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(107886003)(86362001)(66476007)(508600001)(8676002)(66556008)(38100700002)(2616005)(5660300002)(8936002)(6666004)(4326008)(6916009)(186003)(6486002)(6512007)(6506007)(2906002)(316002)(26005)(36756003)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2yE6ved8s1awfNvWCqJimtO3y0V/zoPbybzgd1+vAzrB2AyB8+du9ih+X6lZ?=
 =?us-ascii?Q?lJ/AyIbrhQk1zXfzwWLIkYt/UI2zEOG0wCYt+vCLwc+ekkgJLDb9Q/eOQkYE?=
 =?us-ascii?Q?5tK1bbUMXSjyWL29VPjpwdgXIF72rfHSbXy3JvY7rgzPujNZtu40q7BRlBev?=
 =?us-ascii?Q?kQAEXRAhoX2KSt70TRNVrsvugquCPWNAYBHm9PFeh/3V47i5LkjjL6fLWUkU?=
 =?us-ascii?Q?z/bBOaTOSLY+1xayUusg+VOeZsHl2nKvGcGOBbuAgQUtHNpHdVZyJ312rfWw?=
 =?us-ascii?Q?5be4+3ANwGnKN69IuAksVW3MFWtpybPmo6Oo95pO4KFWoPNMw1XQLw09j4mX?=
 =?us-ascii?Q?spBstR+GAzZUDu1RPWsNI7/SupS8UhN0peaXeP2TNq4E/r4vVoCLbejoZ695?=
 =?us-ascii?Q?mRa+uq59Dly0L7qU0iuV18ottbLKToK1Bns8BG52BonFh0fu9FUJr+bEGs29?=
 =?us-ascii?Q?kalu0zAoA3s9OVXj0zf0SICBoOM1XE9mOp2YN+b1NOCBfLqm6n7F7zlqNgYk?=
 =?us-ascii?Q?i2oHklzbIcwsP1uxHpMJPDLp0J5Q2MTIJ3J+O4OFKw2YQPvTE0sH1RJpGi7b?=
 =?us-ascii?Q?GsCzHrpdZ28EFVCUipOBKuNRuur6xtGybmbDD/P7M+q4dDk7MQkULoJs8Tt8?=
 =?us-ascii?Q?C2Zo0hq3a3eL3L3vRqVEzqRVj/bfXQA1XOf43kY/MLLdU8wm2AHy5DIqTT7W?=
 =?us-ascii?Q?YBMF221O4ad5t0Wbc68Yfk8apmC2fN/qeZ4rBFGvk0W0aiIQTfbEsdyRi0lX?=
 =?us-ascii?Q?XynQElDzMvL1r9mUYkFkCI/Z9DzhPkedmzRsycPuAYhGTYqtdCrHEAtrpWJo?=
 =?us-ascii?Q?sECVb8/I04FgzRv8OVLUiT6ZsK76QFQ2Tnlc1xU8H0HyDh5+UNG95d7PHfnD?=
 =?us-ascii?Q?auuEQGNzs5lvr6xX0Ck0BaeT3KBsTwSTCSAZ/kmMtOBwkMmSMHTwkR7P1HIB?=
 =?us-ascii?Q?eOt/fT99HBHnCT4ja2dr401CdIfKqORVhY5iaa4eYunI5y5OAskmTORvQD5I?=
 =?us-ascii?Q?YqcZiv0QWes1sRGV6cBPTfZJpb250MaDvRbI+8bAKDnJWGcuwN5H5EiUrJzs?=
 =?us-ascii?Q?51UqZXZ0X3Q9mWjwvRrHb59FJSbEc2Na3yz6a+A3J/uX6VZOYdA+z9+CPdut?=
 =?us-ascii?Q?RAY55Nawha7mNMxrTIWBwx6PQdF/zgdus/+PI07BTps9tSwBe/hh/u4ze6N1?=
 =?us-ascii?Q?pHXPZ7Kwoa2GHPQK0j3YvqrhOKHgpQF8k8m9nOvc/ffNyalvM/fDr2Crhr95?=
 =?us-ascii?Q?Fbj/dcnGujZ2tRhqMxi7PsLRU4Ykx5LY4wZx56WvS4OFIlY6+bQ0Ni84sAuC?=
 =?us-ascii?Q?Z0GjY0Fa5DpKhJYvv5yIfhCpEaB5fnw32H6DXSQ9Q/PYET9rgnv6K6ROxrzG?=
 =?us-ascii?Q?Gj0mdetYJD/59mOKTVJkIzeKvmVr3RVQOU3n3RHP/kP0ZehkRDYoC370XBPt?=
 =?us-ascii?Q?f4+5l+N/gg1tXVVRyCeqgQCcgz+Lwz8zGbMbAZSYU5OtWoAj410ikK1KEf1+?=
 =?us-ascii?Q?SoHCgb4EiXYWV3E1/OZjederR8YaeIzZ93eOw/5DJDw5fL6xOHIe3wA/FUJ7?=
 =?us-ascii?Q?ODwDlhMx6FEwr0CNdawl4AZI7lL1USsqJSMCWObyPKxPHBMd8T3dgNehMDF4?=
 =?us-ascii?Q?gtgkAX6W4cDMG7vMUydyaSg=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2a7b3bc-a28c-4626-4a55-08d9e0b70b28
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3527.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2022 10:31:42.4212
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 40clMZKouRc1RTRd+ucs4ho3TO/sC79BQmzE/enSzZC27RIHHg8ra8u/Le9X7qdg87sQRasq2c9HlPcMRpCZag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4461
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

As part of a process for supporting a new system with RJ45 connectors,
100BaseT and 1000BaseT link modes need to be supported.

Add support for these two link modes by adding the two corresponding
bits in PTYS (Port Type and Speed) register.

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h              |  2 ++
 drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c | 10 ++++++++++
 2 files changed, 12 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 24cc65018b41..c7eb48f350e3 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -4482,6 +4482,8 @@ MLXSW_ITEM32(reg, ptys, ext_eth_proto_cap, 0x08, 0, 32);
 #define MLXSW_REG_PTYS_ETH_SPEED_100GBASE_SR4		BIT(21)
 #define MLXSW_REG_PTYS_ETH_SPEED_100GBASE_KR4		BIT(22)
 #define MLXSW_REG_PTYS_ETH_SPEED_100GBASE_LR4_ER4	BIT(23)
+#define MLXSW_REG_PTYS_ETH_SPEED_100BASE_T		BIT(24)
+#define MLXSW_REG_PTYS_ETH_SPEED_1000BASE_T		BIT(25)
 #define MLXSW_REG_PTYS_ETH_SPEED_25GBASE_CR		BIT(27)
 #define MLXSW_REG_PTYS_ETH_SPEED_25GBASE_KR		BIT(28)
 #define MLXSW_REG_PTYS_ETH_SPEED_25GBASE_SR		BIT(29)
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
index 055f857931b2..8b5d7f83b9b0 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
@@ -1266,12 +1266,22 @@ struct mlxsw_sp1_port_link_mode {
 };
 
 static const struct mlxsw_sp1_port_link_mode mlxsw_sp1_port_link_mode[] = {
+	{
+		.mask		= MLXSW_REG_PTYS_ETH_SPEED_100BASE_T,
+		.mask_ethtool	= ETHTOOL_LINK_MODE_100baseT_Full_BIT,
+		.speed		= SPEED_100,
+	},
 	{
 		.mask		= MLXSW_REG_PTYS_ETH_SPEED_SGMII |
 				  MLXSW_REG_PTYS_ETH_SPEED_1000BASE_KX,
 		.mask_ethtool	= ETHTOOL_LINK_MODE_1000baseKX_Full_BIT,
 		.speed		= SPEED_1000,
 	},
+	{
+		.mask		= MLXSW_REG_PTYS_ETH_SPEED_1000BASE_T,
+		.mask_ethtool   = ETHTOOL_LINK_MODE_1000baseT_Full_BIT,
+		.speed          = SPEED_1000,
+	},
 	{
 		.mask		= MLXSW_REG_PTYS_ETH_SPEED_10GBASE_CX4 |
 				  MLXSW_REG_PTYS_ETH_SPEED_10GBASE_KX4,
-- 
2.33.1

