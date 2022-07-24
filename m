Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9767657F3E7
	for <lists+netdev@lfdr.de>; Sun, 24 Jul 2022 10:05:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239302AbiGXIFh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 04:05:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239766AbiGXIF1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 04:05:27 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2046.outbound.protection.outlook.com [40.107.223.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30939E019
        for <netdev@vger.kernel.org>; Sun, 24 Jul 2022 01:05:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n6dPGhvp5v4BDRIYlfU2Ay7i1a4ADUz3Vl/NQj6L9tEQHytEKAdapwQHxP6cUjoxHwtYLdzIzEwHtpe314XP9ov7zC3Jduwc+9WOR8ElF6PQa4iOBUXTODhaXkjTJORfwfhwxVh7pBO8EZmlVilsTKRSGcgN27wLezGTg61/4gM+1n/YcvVZG2WnPkeZ8pqmrJINsqRxk5oKh8KTej6Av09hOPCo3Lf9qKgETpp+yHHmg5HTM5aDYZnIwqshs+gp6VK1tU9V+5PflnHA1mHdOiW1y8k7gFkk5dF2jYhJWBClhZALNfR+wnjWKH0FaB86DcU6LYH7rz2zKASgsssOgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EeCHOQE71+chX4w5m/TwpTxhbyCsLrDpB7WP7HygzjU=;
 b=ZZBkml25v3Do6Er7KcqVRkpcTe5BDVgqYDiKeJgNAEQd3SXDJE4FBTg6TtWlCadpEhyZWkTbtRbAnTNlAgrGJLBAVjE+xXlWNV4irU/jGS9TC94iBZSo6S7wB54Lix7Crqh7O1gbUJCpK1djxYJDBLDRpmuEIouStMmU2x2q1Fnysh4liGZ7gvfqxqaO7jgAMBSWEmRvPe0Iut1ZjssLKcpQkFZmuXNxyv2+D7VkkAMwzHo8QeFhaEPcOPrf5nvERr2rd8vrtqwM6lL/d8XPidPHaif8RpP7lFz1M7QdU05cTwN3ndlzkMFHhpyUQM3kpO/iHRowGqm+46s5k0XPLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EeCHOQE71+chX4w5m/TwpTxhbyCsLrDpB7WP7HygzjU=;
 b=YMv1HIvI+UzhmxA2ZDuzpHGlmXO1wu91/FYgZZSLvaKe/4nwk1xJNCPsfnp1Yta86f2hSr3AIFIS/iCs2WIDzV7OusLIOUmWroxNIDM8NpVMMqmbhVOn/CIFeKWwfp7NKpFuPjlVuFojW0tQ9lmPmOadR9F0fOwZIFzn6oUEV72AwxwLPSGzv8zpzSjRxrACKnNUh1QMgYkB5uxpzIQ3c7J48Pv4eImFcIsdgQPk7LYlxsWtrfa57HmTdwUTHtVe7FD3yXT4dSR+jFbx+xJD+89j+YcU1wHWmzl4jtfysztWAw7OLKLusvVL6YwqPk2JDpG+TYFOEJNwqS16nyogXg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM5PR12MB1915.namprd12.prod.outlook.com (2603:10b6:3:10c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.20; Sun, 24 Jul
 2022 08:05:24 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad%9]) with mapi id 15.20.5458.020; Sun, 24 Jul 2022
 08:05:24 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        danieller@nvidia.com, richardcochran@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 11/15] mlxsw: pci: Simplify FRC clock reading
Date:   Sun, 24 Jul 2022 11:03:25 +0300
Message-Id: <20220724080329.2613617-12-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220724080329.2613617-1-idosch@nvidia.com>
References: <20220724080329.2613617-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0037.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:61::25) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 91cedca9-c311-4e5f-cc75-08da6d4b42e2
X-MS-TrafficTypeDiagnostic: DM5PR12MB1915:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JKxr/A35Is6heiWD7Ql76SaP7RDDW1IsGiJSt/KamL+q20h5wa7eIaE/zwPLFv6frLaPrhGnQwUFWgSBqUx2oDZl3t4BkkKUNQf3AhfxrVyv3593rEfbtCdd4v/bYGDMSiAaCUJzFzAUy7LuokSgar0QfUTvgdKyfkJOnZOtfClfGdi+ezEEawMl9BhvSeYuk4BdS9DVIXtlVFjPaWlnf2IdY0qdsvm3WI2QsWjdqdKMVN8ClVNjV7WYz1Dz6CjRkbYn+lXdwbBl2sb5CGbzAMaqUlQLVzMecBf3zeAfJwBNWRSzyi46mkCtDmkZEHKReFT3fNKIJMoi7Xzk3mdY3m9MqvBqJNrhxbAcyzGmOKQRqTnSJ/1nrpiWghrnYArO2hE5FpJbWTnpq/QU5EPI5FTPFSzuLiif2NYaJzMMECyQNtLdIzhsXnGh6PVLaLIF66WWUUrmLexRy2ohxvnB0Wqhc2XbF0s97zSed0BHphKik47SyKKMDkxim4Qyn6vavWNiIayrLF2CfdgZp72N4dGOIngQJLbxcq+13mWHRlmuow8ogLlPuWp9t+3VDiF4CO81HbQ+/wAS5uu7Nx6S0tuGy+eBYora+qncUS89n/71J6SZZFZD9SQPDEzJ/0xOONf9BE/wd2iqc5jKoO8AZgWFzfyGQriOya5F7MrL2uC3y1RVZCbjBxihHgvbOnhDxy7t39nM85ent4DMQ3RSRD1v/F0IDrc/teWXN4WdwRErDQtVuPf0d1J1DPMfDN3g
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(366004)(396003)(136003)(346002)(316002)(36756003)(86362001)(478600001)(38100700002)(6486002)(6506007)(6916009)(2906002)(83380400001)(6512007)(8676002)(107886003)(186003)(66946007)(66556008)(4326008)(26005)(66476007)(8936002)(5660300002)(1076003)(2616005)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?e8SJt+MQgFZfiGsSJqweMmIV0GxM5sLiYRz6NPIwthYlNrMWDI3LD0ffmqju?=
 =?us-ascii?Q?asi29BNBoqI/G9nkCUInUouojgkFQnCpIRDAuGo6oVtv87RrT49dPPSmtUQp?=
 =?us-ascii?Q?2lqA9eRztjE0RwG+ET6elqmA+scttEkm5t9UAg3f1VSDH4hO5ZaaCpoXdx0w?=
 =?us-ascii?Q?gxlOD+/Uc3GBVK2dOe9z3Ctsb7Cpvp5AI0AVbZBBd28lXMlcgWYnXjldZbFt?=
 =?us-ascii?Q?u8JtSDzyWhYrSK75fx+ipGdOlREAeP7nc9VF9a13YLoVQ9Y38URGlMCRlxTA?=
 =?us-ascii?Q?jKOoPy7vP/r7qfo984+mCQNBJfG25xf6WjH7AA/dVKvObzUByE5K68cseRRH?=
 =?us-ascii?Q?qOZ+6rGuRpeepxkfpbG5WNjeHwlguYWVuI2lrRVvRGHIeuaHRw5yTjMbmNK0?=
 =?us-ascii?Q?XUUdVdC6vWdtfoja5ixM42uaqwbhbKdHt0/AF63lbqafSLqOOGTyHxhuOB74?=
 =?us-ascii?Q?3c900/q2kE3ttYDFcLQgv3VjW83lJms1tQRqA08QUGkjV3dERoMqVF3DiqNC?=
 =?us-ascii?Q?Eto8rnKAUfsfiyl41ceLMCmjihCLDkDp8MApz4UlBiuYCfFEP9BxbB11U5I1?=
 =?us-ascii?Q?uPzm8772DMmCFexSsbQRPDHAeeDvO5j58bTKCNi8IF4sapDzjpv1qeHH1zVV?=
 =?us-ascii?Q?h09pNKEYrW3q94PEt47tFN1OoHfefvicBLSeYfSmUWG26rthp/+yjiVC78r1?=
 =?us-ascii?Q?6ojm/M6utR7t68BZcKfTC2OtkFrFcClnooMlZwpvpSUFPCU/Wnnwcc01nZxu?=
 =?us-ascii?Q?dXlfXoqotikshm5c0UNYd6bBOmwN1W/nYdNir9C68fKuNLvnvLJaf/9CHkBj?=
 =?us-ascii?Q?NbQlSK32HMyo7I1lr5TtCp4WEmHeFTHTq1Hcc+cEmtuSskXaTQyiEZoWKVlO?=
 =?us-ascii?Q?/LF/R/LMjGRGJsbtQRhSBzFTMQKw79z9T6OZvnYFYXi3djYds1MtBrUxYLMn?=
 =?us-ascii?Q?F+m6rzkeoUz+36PeT+E+sqIKhs1Nwk0kfJlXGbj7joUn7JHvarGN40OFK7zZ?=
 =?us-ascii?Q?WG+upHJyNoBnd5yqi1aze/OG9u3gQJzst1UvL3p/iKU/hiJ0t40GgaXkcmd8?=
 =?us-ascii?Q?TGzTazsfiyDyqbUEjfpVHpK6ItWP8XyNSxLouNHZfnS8aQMGQf3yOXlTjs0m?=
 =?us-ascii?Q?aBHeg1Uahte/pfkneO5vw9lphKL9I97MwN63WQ832Hb6XD231gNXKx9gMapx?=
 =?us-ascii?Q?s7I+crAVZ8g5J+xn/wZgojVEbq/b0J0pXH+jKauTQv5+9Nd4giQOXiQSJGoM?=
 =?us-ascii?Q?+wy9XLDTD4kWO86ty+BPHmAWmWvmEou6yNAGoIM5qN6ZL11i8tRjGD2Kpgwf?=
 =?us-ascii?Q?QiMjSbDjQJdzKceR71/cHIDkM7MMQvi6ykhqbDR0P/lz1rLdKmiZMDq7NlgS?=
 =?us-ascii?Q?lVJa+Ufwd48c4JurLpz8kxFadFCzAb9Ijr6lK7n9Fs8DLj29nZzVxgt8VxSd?=
 =?us-ascii?Q?DsmzFPP2YnxptfCLiJ/kUGP80TPMP1JGUkJIe/El/+P3i38guZ72vtmfWF9U?=
 =?us-ascii?Q?3J0d2wzJ4UYwyv2iztqqXY8KfDiq4Y9L5HnEL7qyYKb6j3pAbHQ4FoR904rd?=
 =?us-ascii?Q?pd9Owa9lWEU26YsrzA2HSaJQ9MT3gvUE7zP2pIfk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91cedca9-c311-4e5f-cc75-08da6d4b42e2
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2022 08:05:24.0781
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KBsukagw2M4BYEhVS7Jv8NlrbhuXd2NKMr7/FLjrjKJtSHiOOJfDNq6uHWXQUQrr08q3q7Dew525WcAGXHdAJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1915
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Currently, the reading of FRC values (high and low) is done using macro
which calls to a function. In addition, to calculate the offset of FRC,
a simple macro is used. This code can be simplified by adding an helper
function and calculating the offset explicitly instead of using an
additional macro for that.

Add the helper function and convert the existing code. This helper will be
used later to read UTC clock.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/pci.c    | 18 ++++++++++++------
 drivers/net/ethernet/mellanox/mlxsw/pci_hw.h |  3 ---
 2 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci.c b/drivers/net/ethernet/mellanox/mlxsw/pci.c
index 0f452c8dabbd..83659fb0559a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/pci.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/pci.c
@@ -505,6 +505,12 @@ static void mlxsw_pci_cq_fini(struct mlxsw_pci *mlxsw_pci,
 	mlxsw_cmd_hw2sw_cq(mlxsw_pci->core, q->num);
 }
 
+static unsigned int mlxsw_pci_read32_off(struct mlxsw_pci *mlxsw_pci,
+					 ptrdiff_t off)
+{
+	return ioread32be(mlxsw_pci->hw_addr + off);
+}
+
 static void mlxsw_pci_cqe_sdq_handle(struct mlxsw_pci *mlxsw_pci,
 				     struct mlxsw_pci_queue *q,
 				     u16 consumer_counter_limit,
@@ -1809,19 +1815,19 @@ static int mlxsw_pci_cmd_exec(void *bus_priv, u16 opcode, u8 opcode_mod,
 static u32 mlxsw_pci_read_frc_h(void *bus_priv)
 {
 	struct mlxsw_pci *mlxsw_pci = bus_priv;
-	u64 frc_offset;
+	u64 frc_offset_h;
 
-	frc_offset = mlxsw_pci->free_running_clock_offset;
-	return mlxsw_pci_read32(mlxsw_pci, FREE_RUNNING_CLOCK_H(frc_offset));
+	frc_offset_h = mlxsw_pci->free_running_clock_offset;
+	return mlxsw_pci_read32_off(mlxsw_pci, frc_offset_h);
 }
 
 static u32 mlxsw_pci_read_frc_l(void *bus_priv)
 {
 	struct mlxsw_pci *mlxsw_pci = bus_priv;
-	u64 frc_offset;
+	u64 frc_offset_l;
 
-	frc_offset = mlxsw_pci->free_running_clock_offset;
-	return mlxsw_pci_read32(mlxsw_pci, FREE_RUNNING_CLOCK_L(frc_offset));
+	frc_offset_l = mlxsw_pci->free_running_clock_offset + 4;
+	return mlxsw_pci_read32_off(mlxsw_pci, frc_offset_l);
 }
 
 static const struct mlxsw_bus mlxsw_pci_bus = {
diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci_hw.h b/drivers/net/ethernet/mellanox/mlxsw/pci_hw.h
index 543eb8c8a983..48dbfea0a2a1 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/pci_hw.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/pci_hw.h
@@ -41,9 +41,6 @@
 #define MLXSW_PCI_DOORBELL(offset, type_offset, num)	\
 	((offset) + (type_offset) + (num) * 4)
 
-#define MLXSW_PCI_FREE_RUNNING_CLOCK_H(offset)	(offset)
-#define MLXSW_PCI_FREE_RUNNING_CLOCK_L(offset)	((offset) + 4)
-
 #define MLXSW_PCI_CQS_MAX	96
 #define MLXSW_PCI_EQS_COUNT	2
 #define MLXSW_PCI_EQ_ASYNC_NUM	0
-- 
2.36.1

