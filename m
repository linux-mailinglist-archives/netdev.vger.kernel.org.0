Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45EA754DF5B
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 12:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231664AbiFPKnn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 06:43:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376600AbiFPKnc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 06:43:32 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2057.outbound.protection.outlook.com [40.107.236.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 902C9240AE
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 03:43:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lM2JmvAEL3P3Qp3CuAysqlN55NolWBBMsze0YjP4NAH36DBeThkZq6z3DvlKAjNrHxhNjAhpuHCyzr5ZW529o3THaQKBvICVaOLXDy7JiHpNkBRkdE8YsSbvhGiKh2HybKX8ZslTNI+fAcwc/z2LUztytGHceQNqyl1+S2K2/yNi+qyTVZe5eLjeoAo3zr1y7OSyXoKOAYUh93W8cEO5jX4XG5qVCZiV6OZVm1uGi2XGzPMBMJ4ZxtNY3k8lCYk0Wpa7/HGTPQ84vGokP6451cNa9Lw3SkYs//Pd4dcJh63oWtom2If4SlYeiaqurOp305BwnrZGyog2S0oCsCxDmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dooJP6ZnkiSvyMDYCSZ4qCOUK6oJOIg3zQx39P7UIMs=;
 b=iuv4f56M068l+TmfPqmIQzR17n/Hvvke9pq8PajkHj6CvxewxImnc7OIYwvHw7lnMkWzzUf7uaNAWJIF6VZ6i6UR4QCwHQaU/0hvsnbjFw+eaPvpxgLvS8zGcVWxIUNryhlOcst9xexxAC/r/UBhqmscJ8mu0pVnjNXyF8XIOuYAextC3f0af3LcnIxH7vOojOPD0q5J8LYAfYimUTR2Qm0CeOZG0+ELBAYq0HJMcGdmR1qNa3ChH15JN9Js1XlMqvT226nWwy/sgo/r58N8h9evGUpmyyDaG4oS0Z5aH5C4QTz3rzUzVwxxLROe7dUD8TqOhzJvqx5/ek309MXsrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dooJP6ZnkiSvyMDYCSZ4qCOUK6oJOIg3zQx39P7UIMs=;
 b=h3QdungsBbxQDb9+aPMIUn9lBcYmZmVa+AGy6pvAROKN4SypJTtQUachEo9RodXuQJC/x95mtYt/FWzUjc9Bd1lbmeIb/oeRHg+k06zTulwNr2Qb943g3Ad+sLsWl052z7b706KCjIDUuJxOhJiXEkG+Y3yMV1qTx6m/YM0owwVIfD3/swNTJSAeJoM9/Gwx2XMEZBLRVpVrjTWQkuE5B/3DytalJ3V/6NBXuaaX6PDrlc059ufqu8q0wnTfjYYLRZ3s4JlE4GD9sKuCGktrYheX10YJHZLX8zJsQUC3gCN1E8J0QVLKiO7qmbKxFyIjBacywoea+9OI2TdkuWAmMA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SN6PR12MB2670.namprd12.prod.outlook.com (2603:10b6:805:6b::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14; Thu, 16 Jun
 2022 10:43:29 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190%9]) with mapi id 15.20.5353.014; Thu, 16 Jun 2022
 10:43:29 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 01/11] mlxsw: Trap ARP packets at layer 3 instead of layer 2
Date:   Thu, 16 Jun 2022 13:42:35 +0300
Message-Id: <20220616104245.2254936-2-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220616104245.2254936-1-idosch@nvidia.com>
References: <20220616104245.2254936-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0701CA0046.eurprd07.prod.outlook.com
 (2603:10a6:800:90::32) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8d6777d0-efc5-41b2-9c8a-08da4f850d18
X-MS-TrafficTypeDiagnostic: SN6PR12MB2670:EE_
X-Microsoft-Antispam-PRVS: <SN6PR12MB2670524B5F3015893297766BB2AC9@SN6PR12MB2670.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S/OoYHSHs1e69fWUmnEWm+dMhUug4bOClrjdYnFVYvSwM4nlTKHazOcoGLyzeTQ8yN826sur9V6M9R0m7bi22+rboLSZPqPuS3oZMwLGRtlP9jTS6gUWUI4WaohyKm6NaLb3xhS4WLZ+lWgaqfCz8r/ru1z690eVO/Dls4AX4aZST4n+iTxN/wFcAr0gtFXe9asx1SrffW2LMJlTitXNrM7QGVvNxQRDl9ANhveMiRpjhi/ScZtwHC5ZPc6s8uzp4td2q6FxL9xD3PwIdjynpY6qnkhCinlwwslS7v6aManM8aluX6/HTO0UVGLgW54699x8y1RrhabAFtTRyMrSM3q4wydlX1nIKuAPaNib6ZhkGKTI+beLfIJDdHYc5qkUsRpsx2oWQhhrsypnyhJAmrz0TUDNigLHGyL/i+g5oPOMZSjbbyAmPM45M5Nezj0kyCSRAy5WK9ft/KHc/12/JoKfmO9uE1KRp+XsJJcCXXDUy/d80t0ALrjhbbylwaw0NItyk7drsNhjI2I/USAyfPx+R5k2LdmHJ1ELlXL6aY8ds/mdC4irNBcLboEQp69Tnx4XMIDrYdQKmbRMukn/tp7Q/G3J4WOrLVFF9c7TtOmVzFcfgqJx+f5uVgNf6s8c+vPv4e6JC1kAQItTKjuyjQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(4326008)(508600001)(8676002)(66556008)(86362001)(66476007)(66946007)(316002)(6916009)(83380400001)(6486002)(186003)(6506007)(1076003)(6666004)(38100700002)(66574015)(26005)(6512007)(2906002)(36756003)(8936002)(5660300002)(107886003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?T35MRqFXpheAAzBFmNOOuGUCt2fBKMtBHsZh0uBBrc5haPCt4fq8e1+UBcgm?=
 =?us-ascii?Q?ZtCcEJGWJPtindRh03kXKZnu2A2jrbjeNRJe7X2NBwV0cXMi/b95p/6Tygf0?=
 =?us-ascii?Q?lssmySM8jBW6RaDJU6xitBp7Z81L0ZYvegBwWuu6pIXjU7u4sQLdoD6ei0Pg?=
 =?us-ascii?Q?qnzc5SLL1YPVVr3ulxxuIsJhf6RGoZsFbaPdtNlAqCFZTUXmFNMkib3Fbllz?=
 =?us-ascii?Q?h71yf2DUlnBvatUEnwZ0yNDB96mUr1UFsFU5wEuowNiXqDRyEx0LlWOwC9w1?=
 =?us-ascii?Q?vsa0m6vVnm6eE1THu/y4UrmlnSGCt1GfwPUVy/oJzIw+LVOzZYB9flaebUFX?=
 =?us-ascii?Q?1douKgdq2cboqR5CgTV2NietdKV6qsDTLVlKifllyNToqzYxm0ViPUwmuMgv?=
 =?us-ascii?Q?WWfJPNkZk3Ra7VJsMBMInO8rumFcAgPdGS6goS6gvfLL4GoGXvQgH0SaAa4N?=
 =?us-ascii?Q?m4osU+1QUnl4ll2Z6eWeBRWxsAUVTQSKFtqspq1mgNGJIsfAWHiEgQVu3ckO?=
 =?us-ascii?Q?vyfdH9G2RcFT0BfMeRnn1jjbJB5wfbmickpUHTB7yoaViZGUeCNmv5cKr68c?=
 =?us-ascii?Q?ITQs/BxfrpaTUPB1ZqdcKEV4aNwOgutONkqtVK+1vAhn4P0K9buNPh/QtIMn?=
 =?us-ascii?Q?5UBk5RbOv70IYPEGF97p5bbyLePCpYwmv9jI/16bUNzhaY26eFTc0ZDLaeCi?=
 =?us-ascii?Q?I37Ikpl4fJRoQMQZCvHaT1o9ikluHsRqBsh6urj4nWWGZC8cCio/2CGKO5BD?=
 =?us-ascii?Q?nuh7o+eJKkafIfCK/+zNgmgSq9KiEWnU0ek39bkhLOS9jm8o6QDzWuwRtuok?=
 =?us-ascii?Q?WC7rn8cEeTltXVNb9TDlJAKrDRWd3vhohd7yim3lsbGdUnyXzjLWFx/FPsx6?=
 =?us-ascii?Q?bNEZbgy0aLrFNW1uzwlx9nXMx0QYcqiZJ7wGgb5WMcB4pH5wQIm+Z2087RNR?=
 =?us-ascii?Q?d0VH7KG7tsc07G1wuunscdxh43NvLwSsSOO90DsFpDpf4Up6G6IHq7NKBAQF?=
 =?us-ascii?Q?KM1mTjwIbMAn3xAZoGVd9CknJ7WAUUUaVGuSNwuEB19HnC7XuthhLs1M85eX?=
 =?us-ascii?Q?wNp3ObbNDVx3QtGEh7g6aaGWugxEeS5IsJUlqWYp7mKXE3EqO06wf7TD0qZM?=
 =?us-ascii?Q?15kP9gVvVU+/0HBgT/XWDFkcihoWiH0cQ1u1H5Spq2uHxo+14Ufv27/+Sanp?=
 =?us-ascii?Q?N1EYTapE9zvJTNR70nyj2yPncUpbeAHMmeIv4OuWT8gOO6AsLxl7hswuSQtn?=
 =?us-ascii?Q?fnPI8cHiwc6moXHe5k2k5eMguH7zmQ6Xt4UEbBxwUPlI5vqh23VPso4p7S1o?=
 =?us-ascii?Q?Ck0eYbQgDU3aKGjPtY16fUhAVekRjX3+k5EUnSa96XZMzG7bR2JTHcRtt3gg?=
 =?us-ascii?Q?zZg3aaWLI7e+gvkm8MBqiQnZ/YTOXUzEzfvuOBO26XD2WZzc/5T7ZiXgZeGz?=
 =?us-ascii?Q?nq3klowyJjeQ5tWeOZpMcunl47KsTi1kqJUoDe4rqhuNCrZMPpAL1r+Z2uBy?=
 =?us-ascii?Q?QaE6OJ29/OAbYjZD4ZzSea+XBSRX8qHeUdVKcrnyeYW3JVIJNuE5i6hwOy39?=
 =?us-ascii?Q?OARwpoufFP3meSQF/Zf0VcEusJ1HPG8+pDl12xQNIbW3FoOgEQ9GXFtFtBU6?=
 =?us-ascii?Q?QzV3eX4HTJTDPmtaG6r2akE7+f39D3XRb7OUcuW2nUAp4gbASwKfZu1GmLLB?=
 =?us-ascii?Q?pPA2ybIXW/wNwLMxjluWygRDjzwNrTlt9Ur/j5amKHZA7Jq42x0m0zuXCtpY?=
 =?us-ascii?Q?JJx0nCcIZA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d6777d0-efc5-41b2-9c8a-08da4f850d18
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2022 10:43:29.7182
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bofuwnzq8EhIt3/FFVtLwlGdrJhQm3uKzKnO2Vg0tGVA6hSOcPxBHWCLOiXEn6Q8hf1U8kQPuO2h0m8xRyj3yA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2670
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Currently, the traps 'ARP_REQUEST' and 'ARP_RESPONSE' occur at layer 2.
To allow the packets to be flooded, they are configured with the action
'MIRROR_TO_CPU' which means that the CPU receives a replica of the packet.

Today, Spectrum ASICs also support trapping ARP packets at layer 3. This
behavior is better, then the packets can just be trapped and there is no
need to mirror them. An additional motivation is that using the traps at
layer 2, the ARP packets are dropped in the router as they do not have an
IP header, then they are counted as error packets, which might confuse
users.

Add the relevant traps for layer 3 and use them instead of the existing
traps. There is no visible change to user space.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c | 8 ++++----
 drivers/net/ethernet/mellanox/mlxsw/trap.h          | 4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
index ed4d0d3448f3..d0baba38d2a3 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
@@ -953,16 +953,16 @@ static const struct mlxsw_sp_trap_item mlxsw_sp_trap_items_arr[] = {
 		.trap = MLXSW_SP_TRAP_CONTROL(ARP_REQUEST, NEIGH_DISCOVERY,
 					      MIRROR),
 		.listeners_arr = {
-			MLXSW_SP_RXL_MARK(ARPBC, NEIGH_DISCOVERY, MIRROR_TO_CPU,
-					  false),
+			MLXSW_SP_RXL_MARK(ROUTER_ARPBC, NEIGH_DISCOVERY,
+					  TRAP_TO_CPU, false),
 		},
 	},
 	{
 		.trap = MLXSW_SP_TRAP_CONTROL(ARP_RESPONSE, NEIGH_DISCOVERY,
 					      MIRROR),
 		.listeners_arr = {
-			MLXSW_SP_RXL_MARK(ARPUC, NEIGH_DISCOVERY, MIRROR_TO_CPU,
-					  false),
+			MLXSW_SP_RXL_MARK(ROUTER_ARPUC, NEIGH_DISCOVERY,
+					  TRAP_TO_CPU, false),
 		},
 	},
 	{
diff --git a/drivers/net/ethernet/mellanox/mlxsw/trap.h b/drivers/net/ethernet/mellanox/mlxsw/trap.h
index d888498aed33..8da169663bda 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/trap.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/trap.h
@@ -27,8 +27,6 @@ enum {
 	MLXSW_TRAP_ID_PKT_SAMPLE = 0x38,
 	MLXSW_TRAP_ID_FID_MISS = 0x3D,
 	MLXSW_TRAP_ID_DECAP_ECN0 = 0x40,
-	MLXSW_TRAP_ID_ARPBC = 0x50,
-	MLXSW_TRAP_ID_ARPUC = 0x51,
 	MLXSW_TRAP_ID_MTUERROR = 0x52,
 	MLXSW_TRAP_ID_TTLERROR = 0x53,
 	MLXSW_TRAP_ID_LBERROR = 0x54,
@@ -71,6 +69,8 @@ enum {
 	MLXSW_TRAP_ID_IPV6_BFD = 0xD1,
 	MLXSW_TRAP_ID_ROUTER_ALERT_IPV4 = 0xD6,
 	MLXSW_TRAP_ID_ROUTER_ALERT_IPV6 = 0xD7,
+	MLXSW_TRAP_ID_ROUTER_ARPBC = 0xE0,
+	MLXSW_TRAP_ID_ROUTER_ARPUC = 0xE1,
 	MLXSW_TRAP_ID_DISCARD_NON_ROUTABLE = 0x11A,
 	MLXSW_TRAP_ID_DISCARD_ROUTER2 = 0x130,
 	MLXSW_TRAP_ID_DISCARD_ROUTER3 = 0x131,
-- 
2.36.1

