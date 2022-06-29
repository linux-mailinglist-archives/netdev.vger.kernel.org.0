Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD72255FC45
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 11:43:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233006AbiF2Jle (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 05:41:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233016AbiF2Jlc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 05:41:32 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2070.outbound.protection.outlook.com [40.107.244.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3D1A3BA59
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 02:41:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kDkwFK22bGPg1Uy5+A+GV13k4yUwKmjuHf1HgLGod/w4G3dNg82cZmLpuCM4sowe1AYPgnskmi5PXmqk154rBYJ78KPkhsPzEue+yDo8Y9mX96zi3qFznnBZyBSe19lvXPpRp37kUctiHxbIBbr29pAG/3t+OpyKYZnMnRPcRk5HhLk+aH6enyNZD51ZR39pYernW9KVZgpnyZszk4DPKwgPMpkGl62eXpF1BxqUxKjRrvydSYwXkSQk1WCFfEUFCKUZF1qBkiyWinQmDlGWnR9e0ru6ska59nRsK5tw0qA8F4hx2kPHu/zDmq831aI27+++JCxxXm5pzcHdhTYTSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FjEM4CcIZVF2n4U/8uFBIXJmD4TrFTz+u3ie1scmIoc=;
 b=fSRXXDw1ZjYenHAeY+OD5vFAvZgh/fkW/mVgkBxTMrUEeLNP40Mh63ZEAbu8ChB+8ZnjqOgPz9BJYSCLLQf/MSl5TWKsAWKLW+2SNjL4dBJohEmRtLCWYGR+bo4BWMk98gQZpRsI9Z6lJ7k1drOkkyJ5c6m//7NFBAbHwqmFEqXEfJMAm3ALLtzdBECvEsN3y4lZuvj79cnBcvc8gjsEYYfZwiqabMoiuafgviYBQ5tAwhIp9uBsJVF01/elMPR5gf7FIX01G+zes+U+Xxj6LQPSmCk9mY+IXOxqjI3JLXxAiEfxJkRQg+CgOPLFKVwkw8mVkqTQC4dndC59bh4kiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FjEM4CcIZVF2n4U/8uFBIXJmD4TrFTz+u3ie1scmIoc=;
 b=n6eER4kTUMu+mNw2ilLLuXA9zdoqo9+T3PsMotH38RRu2oGEx8rOADY5elyUsE+/j1EGlyda68zC8rC9uA25P1r0JWimSJMH8ZuF2Dt/NwM3tKTOH3wgAN3f/QLneIJ/vkxkKuIkD8tunGMV0U2/jve1S5GcLGdE2zC7VBciLtsAOu00TiVkNkMwL6dMUrLcGmNU0t+BsnPp75sV0fLLYP8Dc3MGg6j5bURUuO0WR0nTuD9IK8VKflyrY7nzFGbgn+5ehOC0HVDB0IX9G0DUZsqApgoW8fD6zn7coOcuWETWT7K+doUGthoJnrvVz9Y/9+FLK3Tbgf7vedmx+5kUbQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM6PR12MB3850.namprd12.prod.outlook.com (2603:10b6:5:1c3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.16; Wed, 29 Jun
 2022 09:41:30 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34%5]) with mapi id 15.20.5395.014; Wed, 29 Jun 2022
 09:41:30 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 09/10] mlxsw: spectrum_switchdev: Flush port from MDB entries according to FID index
Date:   Wed, 29 Jun 2022 12:40:06 +0300
Message-Id: <20220629094007.827621-10-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220629094007.827621-1-idosch@nvidia.com>
References: <20220629094007.827621-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR06CA0157.eurprd06.prod.outlook.com
 (2603:10a6:803:c8::14) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dc835895-d5d4-4273-7325-08da59b38b75
X-MS-TrafficTypeDiagnostic: DM6PR12MB3850:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QepR4ZOWVLGzmLrPXOXw2GYBhSCasnWrRN3Wewr4Vy0lbEuebSHRI0QY6zIo5TfdCHlRG8fxTcs3U2PI4/uNfPWRQ8eCTtYjZMJK3YAn/CRRhntz3Z/DWSHyHff1sGziox9SWoixDyULRzjmwn/3Z1XjHa4qvVGy2ErNxUx77wvK8ZMb+I5UsTRmtSA74li3HdA6O92cJ9U3kOY42PwWxKk6xKGFrcqP94NUE+PBNeQfL2v1FmA2vtg7Lgb0AKq7mZL9DLcX0kDbw5RfsvSbNn/ws9jE7oqWcBluDH7hYFbrvgBD70y9S5fYUGiedHBXKLv7Yk2759+weB14ZvJrW3XzGuw0u/kvN9WrIvHD62UX5XLx6vZNccU5c58EDF6PDfcAchQgthwYV1eBgKv9E+MvKysPPXzpRgg7+3ST5VkoDtnLuwJEw9m8unsx/lafE2bbBw3raxP8dDvgP2fGmyqw2U5iAlBXZRz+C4PCkf7KyId3zVOEWhnDlGcrCl+ZXe3N/d79CAKzaZtB2j1bF9euHGk0iMgkIc35eJJDhnnQZH6fVxUqkbUaRPnYpIjWH4lkgmJGK/G5fnRoAPSL/D395V+3fjUSiyBivA8/FiX3GcAe5C3fxgZtNV2Je9N+mPzQlhsc+dFt/LQ+ejPCPpZ3up/ZCelWiZ3aGwsnW5PCdMzJVjIOIAksgbYe2TAGuSEIBuWxXMt4w5sMOeqGQIN/E1s48C1kJHslxrVJvUgKXFvDTUqKoDAH2nELqeRP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(366004)(396003)(346002)(136003)(6506007)(2906002)(6512007)(26005)(38100700002)(6666004)(186003)(1076003)(107886003)(6916009)(83380400001)(41300700001)(2616005)(66556008)(66476007)(8936002)(4326008)(8676002)(36756003)(6486002)(478600001)(66946007)(86362001)(5660300002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BSF8tQjMHZhhD4cGlRDoyk4HZQbG5VyMMzBO52tvcMkuzkd1+bAesGEn7HK3?=
 =?us-ascii?Q?6ouoJ+k29CKmnPez1pCSOtvkKvq/nkji9858wiLakGaAkrV8xqdDzMiH/BL/?=
 =?us-ascii?Q?C92khnxNaZ+71suSv1+2KDaJ4kyKqHkUdeHE3+rShdXOJL47BqCcucuhxM9a?=
 =?us-ascii?Q?DLSwuOJq7ZVkopVtCbLz9pSJl430FxSYQp4NZtT4Exb9aZfjaP2qYY4h+0a8?=
 =?us-ascii?Q?Jf206qP9lnbj4yOw8rQsbhDYHUO8n6QC2xXTrzOA57K00hYJoZDH8uRxpxIh?=
 =?us-ascii?Q?L2AEMIF1O/cxzF80EfPjI7HBiIMuemldN/fKs9SDUmiR282uAZH/LKwHHS4Q?=
 =?us-ascii?Q?y+c4u+q9uZc5XPFjKrEPz+1W0Z0wcv9AZFPorBQ0LRhGVQsH/H07Lq7PCzfw?=
 =?us-ascii?Q?frF8PadMyoKcs+cCVEvlJDopWZk7a4x6RtNzrWOVvizh8f4Ff+fOKgQdSxNm?=
 =?us-ascii?Q?xDPoatZwZs+7NZzKRgqd+WS2o/4jB5OA4DYtXZqCqRCVi3xzc4u8+EWCUMvh?=
 =?us-ascii?Q?/zKo29V6OBWTJV70kWQ41jhQClkiVa8O31HRs2cpD8X8q0xexwPzhFyXKgiy?=
 =?us-ascii?Q?rdwsjgn24cIZwnm3PWC7x7SrdPATgshjMTtD370BzxIKqvEO0Y8JB2anXJeh?=
 =?us-ascii?Q?i2muotlROqJ7Ln76QIr1L7lHUzjtGYZm0UJolU0bajUGVJiWK9LbaCgda8J9?=
 =?us-ascii?Q?HadwWqTQqoWY8fXGS/+8dRA9s1fxJzK03eeZOZ3+oB0aHY4WDQOeA/Gs+VuV?=
 =?us-ascii?Q?jrsisXmbEmqrIme0aAYHZYTuSIswzk5sRkAr6gNg5c4O+uz74KBfU4xc1t2D?=
 =?us-ascii?Q?iz2Eyhbnij9GpoDEAb0GBdiLlEs26d8efZGimlrwgcaNRltqlXkebc9Ae0sH?=
 =?us-ascii?Q?i2BV3IdBzZK4gUyJZNEc+6rrgOsIvUgJR2Pg6vCGnhpT3lnkFQGJifXlCp/P?=
 =?us-ascii?Q?Ut5KJvRBePtyO49v5mOByeFzlWgCJGXPLKFlReiUQRsmk2/nY0Tq3iS45w/b?=
 =?us-ascii?Q?iIAv7cbIl5CZ86aXG+c+xssi3E81uE0qz9S0X0/lUl3fI/tnV5KSUdjxIh+0?=
 =?us-ascii?Q?eACp26uS6otFrKd2QKS5rEQs4hllTF+yrSL+XDIVn6OJnvmajLf8cVf9DAtB?=
 =?us-ascii?Q?qi0oL2ooC6Qix+mL6K3TJwEkyKfjcLHsPUVNtF3X308BccfgmK3rjJ7EjzQ4?=
 =?us-ascii?Q?mDXxcKAJTACPkQeTRnZ8sAAhzr6c2vOy24QjZCB0d8fZ9kmDrgvt1HYJF2QL?=
 =?us-ascii?Q?pGDcnU2xp52dMsgu7qLJh/TQPMKwo7Z41v2rVESLyYcGc7sEkIbqEFlKGBXM?=
 =?us-ascii?Q?xpAdV0ebxj84pl6yw0grh/R4VUgZLz+63dkyd8ZNJHhE/WbToDC0Ret+8xdJ?=
 =?us-ascii?Q?u9CqMN0BcHk8kEQxBr+n9i+5Aa3BscpMYg4AfKFIG6oS3IYQpUyovAnLIYCl?=
 =?us-ascii?Q?3FPC8zqD/Z3vyTl+JmY0bBdY7o9J2uJE9PenqzL2bMrlPHF/NULCuckQ1zbj?=
 =?us-ascii?Q?QQD6ZXWYTfHrglZ3adBUQ3caHFfnfamed06H5P56WhrVlF8FSuhQwRxvsDig?=
 =?us-ascii?Q?KWBrww9uVerfoPL29hDG/M+jMRpqbP0BKh3GYP2v?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc835895-d5d4-4273-7325-08da59b38b75
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2022 09:41:30.1656
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fq7CSnn/Jlw3pvY14SIH1odyZoRQT/Qn1WKAXYk/8Yenpdz/aSwgCJzI3TGStHxjOlVAywPZ69libw8BQK5qBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3850
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Currently, flushing port from all MDB entries is done when the last VLAN
is removed. This behavior is inaccurate, as port can be removed while there
is another port which uses the same VLAN, in such case, this is not the
last port which uses this VLAN and removed, but this port is supposed to be
removed from the MDB entries.

Flush the port from MDB when it is removed, regardless the state of other
ports. Flush only the MDB entries which are relevant for the same FID
index.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../mellanox/mlxsw/spectrum_switchdev.c         | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index 5f8136a8db13..0cf442e0dce0 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -139,7 +139,8 @@ mlxsw_sp_bridge_port_fdb_flush(struct mlxsw_sp *mlxsw_sp,
 
 static void
 mlxsw_sp_bridge_port_mdb_flush(struct mlxsw_sp_port *mlxsw_sp_port,
-			       struct mlxsw_sp_bridge_port *bridge_port);
+			       struct mlxsw_sp_bridge_port *bridge_port,
+			       u16 fid_index);
 
 static int
 mlxsw_sp_bridge_mdb_mc_enable_sync(struct mlxsw_sp *mlxsw_sp,
@@ -1382,14 +1383,13 @@ mlxsw_sp_port_vlan_bridge_leave(struct mlxsw_sp_port_vlan *mlxsw_sp_port_vlan)
 	struct mlxsw_sp_bridge_vlan *bridge_vlan;
 	struct mlxsw_sp_bridge_port *bridge_port;
 	u16 vid = mlxsw_sp_port_vlan->vid;
-	bool last_port, last_vlan;
+	bool last_port;
 
 	if (WARN_ON(mlxsw_sp_fid_type(fid) != MLXSW_SP_FID_TYPE_8021Q &&
 		    mlxsw_sp_fid_type(fid) != MLXSW_SP_FID_TYPE_8021D))
 		return;
 
 	bridge_port = mlxsw_sp_port_vlan->bridge_port;
-	last_vlan = list_is_singular(&bridge_port->vlans_list);
 	bridge_vlan = mlxsw_sp_bridge_vlan_find(bridge_port, vid);
 	last_port = list_is_singular(&bridge_vlan->port_vlan_list);
 
@@ -1401,8 +1401,9 @@ mlxsw_sp_port_vlan_bridge_leave(struct mlxsw_sp_port_vlan *mlxsw_sp_port_vlan)
 		mlxsw_sp_bridge_port_fdb_flush(mlxsw_sp_port->mlxsw_sp,
 					       bridge_port,
 					       mlxsw_sp_fid_index(fid));
-	if (last_vlan)
-		mlxsw_sp_bridge_port_mdb_flush(mlxsw_sp_port, bridge_port);
+
+	mlxsw_sp_bridge_port_mdb_flush(mlxsw_sp_port, bridge_port,
+				       mlxsw_sp_fid_index(fid));
 
 	mlxsw_sp_port_vlan_fid_leave(mlxsw_sp_port_vlan);
 
@@ -2528,7 +2529,8 @@ static int mlxsw_sp_port_mdb_del(struct mlxsw_sp_port *mlxsw_sp_port,
 
 static void
 mlxsw_sp_bridge_port_mdb_flush(struct mlxsw_sp_port *mlxsw_sp_port,
-			       struct mlxsw_sp_bridge_port *bridge_port)
+			       struct mlxsw_sp_bridge_port *bridge_port,
+			       u16 fid_index)
 {
 	struct mlxsw_sp_bridge_device *bridge_device;
 	struct mlxsw_sp_mdb_entry *mdb_entry, *tmp;
@@ -2538,6 +2540,9 @@ mlxsw_sp_bridge_port_mdb_flush(struct mlxsw_sp_port *mlxsw_sp_port,
 
 	list_for_each_entry_safe(mdb_entry, tmp, &bridge_device->mdb_list,
 				 list) {
+		if (mdb_entry->key.fid != fid_index)
+			continue;
+
 		if (test_bit(local_port, mdb_entry->ports_in_mid)) {
 			__mlxsw_sp_port_mdb_del(mlxsw_sp_port, bridge_port,
 						mdb_entry);
-- 
2.36.1

