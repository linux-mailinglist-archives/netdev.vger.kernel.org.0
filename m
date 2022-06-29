Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1E3955F78A
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 09:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232984AbiF2HFq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 03:05:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232995AbiF2HFh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 03:05:37 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on20618.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e89::618])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB2E23BFB9
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 00:03:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bjt4I4xBKITun0tbbp/q0wW54L6Vm9pWfYhevHxrkxUE3CLM3nK8yH5FfONqap64X4qy8Z9FYAKs1Z2E1cgltM69wRRLYaYAP1SaHx+JkAXVu6ZRvDhfzEblNHsIYl4wpZE9kqCnP3QGXZhYkvnBdHH7oxCSo6zWR4o0MBQz3gvbwbXUG6kkxAKyYLI1wkHQ3cIcCDjSSKuH2y/w+EeXE5sNNCTKyGsXIjJcLvvLoK9cVMFe2vdFNVKJgRL5atXTWMjVcn2xsHOJfQQ3n/8MAlIkT/qYx/3Khc3DMYd/CTawDYX582qFiVWjTF+RiikF3r9zqAUAke9PTw0CalQRrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iySRDod76AeyniE9m4WZakVEjFxtmCbbk3/kHuqTvJ8=;
 b=CthI2bbA1+uNI80cS4VxFZVblHyh5mL3zlZ4YOoOteBf3oqeOVEiU272iQ4hrXVy0VoSipWYax9LSItRhXmE8DXAUbNI/AKdSCW0R60ugMxFm1FeX5jwO5+UquxZkRTjaoHGCoKgm+dXIVYZkIzLzVjjpWHeWK5r1eaPjwqSuli8bP/weW7gDwCoYK3ujPHIZGBakKPdqVxucKIu0OhVrpYVz+zQCaapwXIQAmL8tCgWCQIw9+3tm1Rjt5jnMG4X+SR69ckDsn3ZyRlkc3k0iB/eNZ8TCIpMnWP37TsilbsuzKn1o+VbGC6YB28/VEj1+/+O3MJ8ipeW8MtG8c9SyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iySRDod76AeyniE9m4WZakVEjFxtmCbbk3/kHuqTvJ8=;
 b=MycOPod9gXsB9rzMNFIVC8v+DnFlupFaf3yeM+rhfvwehSs+V3D3RTPDgYx1Wgjc+Oc3vLL3RW5+Gzauf+Au+EWvPSWOlRAqP9wth89SLmOKtnO940y0w1WvnUfv8z7MgyQ6xnM+O8750y+no5gETK38za05pAzqkW0nnZRPsUVgEbPxzmFh9QlFLq0JE8qXBloDrIlQBFdNolaA20XYBjPfRalaVcQfD734EcCotULjBxz3LFKLd+WhaAosHdMWLWPBRJ9vW2PSyexn8INYqPfth6yXyqtk7CM8DYAAnHYYuSOiz+wswDt0xj2kXT9dD/tB2LBsc6OCHO+UzZ5njw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA1PR12MB6163.namprd12.prod.outlook.com (2603:10b6:208:3e9::22)
 by CH0PR12MB5139.namprd12.prod.outlook.com (2603:10b6:610:be::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Wed, 29 Jun
 2022 07:02:31 +0000
Received: from IA1PR12MB6163.namprd12.prod.outlook.com
 ([fe80::6da4:ce53:39ae:8dbf]) by IA1PR12MB6163.namprd12.prod.outlook.com
 ([fe80::6da4:ce53:39ae:8dbf%7]) with mapi id 15.20.5373.018; Wed, 29 Jun 2022
 07:02:31 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net] mlxsw: spectrum_router: Fix rollback in tunnel next hop init
Date:   Wed, 29 Jun 2022 10:02:05 +0300
Message-Id: <20220629070205.803952-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0102CA0062.eurprd01.prod.exchangelabs.com
 (2603:10a6:803::39) To IA1PR12MB6163.namprd12.prod.outlook.com
 (2603:10b6:208:3e9::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aae6b422-c0f1-47bf-d742-08da599d55d0
X-MS-TrafficTypeDiagnostic: CH0PR12MB5139:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WBm+F5n2Ik3E5kkdIjnpjjW4JN5vjmE7bCAaY5LBmtXyflwOWxSKdIGbfSg6beNzA6uE0cSOen1nrO3RJHDe8japyfECCRvkygFN2r6m192xWh6bY8sMXiM4+49L1JKUwjdNTkYDLtbxs17GlRVWMa2d0JeoKYNfbhybETwQvcwuTEskbsDLDYyNbNM5A2vnsn3bZfrG677K4CoRqFiI1uME2KT4Q60CSF58sBpnA/CTZ6XDckZSVdEZwXL+YqUuwThhCk2OIw3ogyJ06oXOftI/2J/UFXoT6VS9zQcG+tnr9MfJJq8P0qTlztL8YRSuWXLndWhRgNPG4HKmvWtEcE2q99kbnf2LoI0OJkxYQ8PeAdAF9y/nwsNcH1Mdzorcr01g8rXYbl8t6VUygziYZOYfHLuy+MRq6ejHCP0MVqWaKl1Lv/NeqmuV9gA6cMiCisH2B4UFfgbM5FkcBG3Rmj74gekemH0zVzQIoB1IsEbC8VI61SiTz/l/ZKUNwYqlSBiEwrUyxFq6m+bypub8nNylkRMT/gfDqyS5/med0LlgOq69W1O5Lgg4Msn5HdRxmg9W4IWqyRXIdDF7ODM5TXN3uoBjK7itXXAa5AG+rZcpC954l+WzTZwVmiQ6UgPEImJ2LVhG0DDqqogSiuuk3XVU+2s27zoyjx/oEfVSnrJ/sNAL7oi0B8SWFOW01LhRCVi16ZYWdLKUQZFDajgFO+5GJpn7YkcyWodyITyPrcHfbhLpccPKuqOG++GfnDpy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6163.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(376002)(346002)(366004)(396003)(39860400002)(66946007)(6666004)(4326008)(66556008)(478600001)(316002)(66476007)(8676002)(186003)(6486002)(5660300002)(8936002)(6916009)(2906002)(83380400001)(36756003)(38100700002)(26005)(1076003)(2616005)(41300700001)(107886003)(6506007)(86362001)(66574015)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LNurz65SnbJlxcoZqsiOGezx6LtN3QPxGuuYETvTDj0MWMipU9j0qgbUa2Db?=
 =?us-ascii?Q?B5hr+uVzq9g3rIGwOjc8YbCdfTjmRMYTuKa000KHS3+y+GtuOWMNqgJPDczr?=
 =?us-ascii?Q?dHBBH2tooQU0jkMFUH4sSEqtCTl0CEEEcrymg5oA7/SlE7joJSdC788QhTJm?=
 =?us-ascii?Q?Qcvg8PIrkNQRkLQT8FyzfxDNVUrB94w2Judz6v2o6Y6Vqmg7X23X1KOhOf6n?=
 =?us-ascii?Q?DOGC08lo5NXCqL5+7bi59EbpvJisTCd8cfFS8bKsMRfhG4TUWN1f8TA8KfJc?=
 =?us-ascii?Q?PLYqu+ZgYzdzJrMIG3E5b80SAkh411qwmIOnVH4haQ+CpYSX4q7ZObUsE1w/?=
 =?us-ascii?Q?uLAfX3zxo89yDoEw+DPsc27n6tlRoTmfBPTqF+QFAdwgZaukTre+WKf0gvxT?=
 =?us-ascii?Q?Z1fMyq0Fu4/GGfrawFVeBXLMhPc2urty9WaN8h6lZJEOxO1CszdHvr1io/L0?=
 =?us-ascii?Q?HZnXu+zQZVlHF5VWWF4CKCcxUsPYpRiGtPFKnWw6s5re0yZ11d66feOrGRW+?=
 =?us-ascii?Q?uRCLUNi0/OIA9Xcv6xdsEOXqrdtqhiogQ3+X8C4iVX0iAFu/vFf3sjVrZeCX?=
 =?us-ascii?Q?A7vYEn6L+AwOYD9D8FV5G+yaJDiUrXOiJWmlby702VkTe6pzC1DzTzT3veGQ?=
 =?us-ascii?Q?NPRPLCBwFODg/fOtqRQqKZrrgCMRoyOmGuyAao8/E3iXCfkqkH1MrFi7HAkZ?=
 =?us-ascii?Q?0f9Aj1oBKISm4r6QtEdaHu1fxyjyeRCrduaqt5DSzNQKH/MkDM7ttKJaVBeR?=
 =?us-ascii?Q?9Kx50Oth4oFnYGnbtpCl23cDIu9zKkrfmEzHar5UpyAUlZ3dZJgi4tYAxGEm?=
 =?us-ascii?Q?5HL51sqCEiC0GL2aZk1TpCTDuWwyKISJaizk8PDTQnxm9o84RVISfLlUhRgC?=
 =?us-ascii?Q?RWudI5VnUcIUS3jM4dNStvoOiaPDZwCHrS4qjFtCkz+HlLoZCP9e9Edt8bng?=
 =?us-ascii?Q?6TunU4E5uXXz1kQDpwOzzjQczHJdfj4nfvq5cIfTjan050g2WaqxNee8Rbvv?=
 =?us-ascii?Q?5/OOlUfwBiD2S+4JOk9AxEnZdxUmAfEaS+nUImoYZVV3apTK4ty5siazCTHs?=
 =?us-ascii?Q?d44wB9fwD3IbclCufTcxNUfUx6XzjybSe2mw5hjdPYLJ1mC1UIJ8a4LrN5Iw?=
 =?us-ascii?Q?UF9qKcUJhfcxedon3h9pwt5J97rhHHfu6obkyUhJ+RQ0cyhHsDR0XzyvOSEu?=
 =?us-ascii?Q?LLd1rjR2WJK6+Q3/ypLZfBQJD106BZvSmxyDg5dmg0WB5vXjVwgzcm9RAUJm?=
 =?us-ascii?Q?zZN+kUUFwyMwnrZxgAkpi6hvqviL4uU5tubijxk4q5/Jf1WfQpjs3vBmBpqF?=
 =?us-ascii?Q?rrtQYDH9M+xyGZ+4HqrjapqlQ15wTN2I+I/JRQo2WFwsP6nZRlYI3EjOmwf1?=
 =?us-ascii?Q?84/ArMtqT0aDUkNpqiOlIUjTxnJWAxELMMR0xCLb7C6r5gkDNGBkwBk99pxP?=
 =?us-ascii?Q?TdOw9Y9YNSB8m29NXXUvMitw1zNrpXiomzFmldY68Wg5bUIvEg/Yfd5SNsbX?=
 =?us-ascii?Q?OhLgqIKyqRaJvGzkNdBh/Jc0czIaRjBUD8+mSGENcHMbCN3EilKWlmWEHMQs?=
 =?us-ascii?Q?K/0w68zQc6yRQZ/1Yx7A8SeEKFcRRar3v6ddkOYQ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aae6b422-c0f1-47bf-d742-08da599d55d0
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6163.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2022 07:02:31.2396
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RujDjFGOt0HpkABDd8Q5+eh55B78l/uHlf/ganKMXt0l7wqKQYjUj9SM5T6VfJT0tU+iSXlkcwo7aegPlw7q2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5139
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

In mlxsw_sp_nexthop6_init(), a next hop is always added to the router
linked list, and mlxsw_sp_nexthop_type_init() is invoked afterwards. When
that function results in an error, the next hop will not have been removed
from the linked list. As the error is propagated upwards and the caller
frees the next hop object, the linked list ends up holding an invalid
object.

A similar issue comes up with mlxsw_sp_nexthop4_init(), where rollback
block does exist, however does not include the linked list removal.

Both IPv6 and IPv4 next hops have a similar issue with next-hop counter
rollbacks. As these were introduced in the same patchset as the next hop
linked list, include the cleanup in this patch.

Fixes: dbe4598c1e92 ("mlxsw: spectrum_router: Keep nexthops in a linked list")
Fixes: a5390278a5eb ("mlxsw: spectrum: Add support for setting counters on nexthops")
Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c  | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 0b103fc68a1a..63652460c40d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -4323,6 +4323,8 @@ static int mlxsw_sp_nexthop4_init(struct mlxsw_sp *mlxsw_sp,
 	return 0;
 
 err_nexthop_neigh_init:
+	list_del(&nh->router_list_node);
+	mlxsw_sp_nexthop_counter_free(mlxsw_sp, nh);
 	mlxsw_sp_nexthop_remove(mlxsw_sp, nh);
 	return err;
 }
@@ -6498,6 +6500,7 @@ static int mlxsw_sp_nexthop6_init(struct mlxsw_sp *mlxsw_sp,
 				  const struct fib6_info *rt)
 {
 	struct net_device *dev = rt->fib6_nh->fib_nh_dev;
+	int err;
 
 	nh->nhgi = nh_grp->nhgi;
 	nh->nh_weight = rt->fib6_nh->fib_nh_weight;
@@ -6513,7 +6516,16 @@ static int mlxsw_sp_nexthop6_init(struct mlxsw_sp *mlxsw_sp,
 		return 0;
 	nh->ifindex = dev->ifindex;
 
-	return mlxsw_sp_nexthop_type_init(mlxsw_sp, nh, dev);
+	err = mlxsw_sp_nexthop_type_init(mlxsw_sp, nh, dev);
+	if (err)
+		goto err_nexthop_type_init;
+
+	return 0;
+
+err_nexthop_type_init:
+	list_del(&nh->router_list_node);
+	mlxsw_sp_nexthop_counter_free(mlxsw_sp, nh);
+	return err;
 }
 
 static void mlxsw_sp_nexthop6_fini(struct mlxsw_sp *mlxsw_sp,
-- 
2.36.1

