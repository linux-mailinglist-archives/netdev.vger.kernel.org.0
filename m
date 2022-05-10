Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78AC9520D6F
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 07:58:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236960AbiEJGCW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 02:02:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236911AbiEJGCQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 02:02:16 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2074.outbound.protection.outlook.com [40.107.93.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1C9928F1CA
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 22:58:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gxFzR/E4wLdDLQzXF9tTdKezy9KQFngO9872cpdgurOOcy55HL5wEU+Lac6svBjRxOPF26jLtWun3/psYKfHhjNiOewatgeLAVmiUcyzCjCQ4LvBX5wH630cLB52zs65UtZK12y0G2yZj/5bgXcD5A2tPJt1sKKIYlOz6jZj/dJC0YLXcpdpKKUCKCy8iZY/+bljC0KQYc395ajz/eJw9AmJDv0I+ihOvmIpp876vq5Vz0cavzDInnfkMohnM71QyV59JlXBE1IFyHdifQ0+c6LDrh14K7S0PN8l5HaEIuRnSFIjyDwn0zzo/Xr+DiKbYBCkrOW25zMKpc0GoMx2Nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tWjiqklsYafe4xpWjt5zr+wLCh5U/4VoRizkYdnZspI=;
 b=TGsz+0SPBXNORx4+JNysRn097fZWBWRxPLMWtnH3THS4hOgpLthlKrz8BIcSi6VJdvma4fqfbeikx4y/KQkcRx4gP9kxBBKGoWAN1T7KxHMXzxH00YjEK18m8tJHmXoej3PoX72dgSQNrmcTNCyL/0NEKop0TIdp9Qg6SbZzh2Xr9eVVkQOEUcGkx28DvGP1Ov7DoeRKah9y1JnUbH2myKYAJoVrQM0eXEE0nj7t2EZGxX8rk3CrpgCEw34v+cbdB7hmemMi8S/ea61wjtRUpzcvE9CYyieCW6Gtam4SgxWBGxru+k7q3C2ZSXWxSE9EFJ2rE4B+QYO1k+NfY4xAxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tWjiqklsYafe4xpWjt5zr+wLCh5U/4VoRizkYdnZspI=;
 b=fNFisQFpb0dsE3YECK+188Ki4umL+GMBGJe/4tbExrW1mczOrBf4odcDtFC4a36lNTrIHRPDUS3gRsGGQ35DAv21Y7IwkoikPxXwhtIJats8w1m8vm8pK9XwcOPNWVmgMAZHKNXWb4Wgtm8+CPQLJPrjXj+keqhmmAH5R+8CFRAfbJabzp4SlMAqLCjNjU7COOJz+qou5vmIWK9Zqxn5MAow0HVQfmrjI9+Bnm2xxSZKZ8XxrIrfq+M/6mqqMIUWZYQ3L9ZXU+7drunPVGkndUt1mbaAorhxwqdGGoFl459h1BB5zFIg9kSvWYbG7e9aPJwCSWB4M3ajqh6pO24rqA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by DM6PR12MB3882.namprd12.prod.outlook.com (2603:10b6:5:149::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Tue, 10 May
 2022 05:58:15 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca%4]) with mapi id 15.20.5227.023; Tue, 10 May 2022
 05:58:15 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 13/15] net/mlx5: Lag, refactor dmesg print
Date:   Mon,  9 May 2022 22:57:41 -0700
Message-Id: <20220510055743.118828-14-saeedm@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220510055743.118828-1-saeedm@nvidia.com>
References: <20220510055743.118828-1-saeedm@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR21CA0019.namprd21.prod.outlook.com
 (2603:10b6:a03:114::29) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eda7e922-a5a7-4564-2ddc-08da324a12d5
X-MS-TrafficTypeDiagnostic: DM6PR12MB3882:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB388278206663DA07A8DA57B3B3C99@DM6PR12MB3882.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VoAZMAICX3PDbriLwMp5wGmnJP3n0TYXCpbCdscZo3lnduEBJc6kjsd1EXHkeeth8xk2tR0BGz3obHPmjWLZHtdtMoY0kpnWIYPgBHw7ukGBo4oOoMiF6mo+Bd+ITU0H76FiXETRlYwO4Fz6Ebh8b1miWIAGA3ZCRFhNXdsG9pQ+v6/V7tVzLu7QxA0DCcEt7xkVmqc5P2JPRDUKmkevL7nN+ftMZ0uWRBdR2OpW0MFBPP4iBiHyqFePob7duQdzNfnCZ3+GlKWzLIuAYDMNCDSL345md7cPJ5WXbTDht+GqjwAyXNNvYetBwKXVuqGPrlHU29CgPLqeuYgo5nBYnPvzyseYlfv2IWst3CvGtOn7xu0AelRgoIoXySbJfRQwH4SHQNpMfKZ6bOnQDHEqYSi6y+QVBh4xfb8TNcNaAExdP/eqlm7KjjEauIe5ZC8tUGY+LvsqaBZ+/K0/gKz2FnKgpTO2pyB0i7dTXklBbcC1ZuV97fgLteFIB0R2yBLRgzVOCUXIB0rd5z3iEnSb0TkPoyOe4GTmIFt1tQ+KnT8fpZ9e2cCnSeOnFLq5lhuVkNh7tAaQ1nKVSIvCGz1qzI6OI+SLpEltk3SGjwuBDdY7PkHuX9yZqZC66K2PQIRHJfykHmTrYHRjCpfKrnZCNQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(2906002)(38100700002)(508600001)(36756003)(5660300002)(8676002)(186003)(83380400001)(66556008)(110136005)(8936002)(2616005)(316002)(107886003)(66946007)(4326008)(54906003)(66476007)(86362001)(1076003)(6666004)(6506007)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BsrHU+2nOWXRDfmeJmWszg9Lfts95PyAcrgQp096cn8dv3MArWlcaxuec0zw?=
 =?us-ascii?Q?eQ1alfB+c9GUUJagZgks7/9jndQnD8CrOWmmFbBNcv2eFzl6wZkUP1k6kjdr?=
 =?us-ascii?Q?S+bn73tUnM0zDEh2w0qM+2mz8qDk5mn+gjR5o/Vah5FcJeQHtRmGOzJNdXai?=
 =?us-ascii?Q?3sx5a5NyXWzLXvIXX4cQNKbJAQNYqse1S/hxWuitsDBE50LUqZBi8j1BPijc?=
 =?us-ascii?Q?zG7DsX8nbYnKazuyzq+Crh2//HoraIYAVzphTWS4RMESYV0LU8xyzIWE1lVL?=
 =?us-ascii?Q?EkvJH/2wB5yZ8gEAaCSR7wpzUwaXDDsKTW24Hp8u59mHlzMYaSu21Ww0KaDI?=
 =?us-ascii?Q?TMpXJ53uiSqJJ+0Tz6V1KYc7Rfcy/DPx6oDJOQTjdfaOKriTQ1u44JT3oUGA?=
 =?us-ascii?Q?ASzHij5zaL9BWPXXIKL9aJ2kKDN0clok94He8M8clGMp20PFVGvUNu6eskmX?=
 =?us-ascii?Q?vUuIbl6Fy9QUlEZ9AXu71gGgJ3B2NE+JVZpdBpQi9jy9KV2Av7qNJz5QA0TD?=
 =?us-ascii?Q?L3RIeXeyF/QxhwzIA3XoTk/6GbSuDYz4Zu8m9xLAAZWcQxzNgfz+6K7uRLqK?=
 =?us-ascii?Q?kRqynNaG9azTV4pDYfWuklnU51XXqdaBkv3CFUSWtw/93Yhb6QrA07CTCCVE?=
 =?us-ascii?Q?D/8QALTV1GHR34BJ5wo5xdx5OTpM5NyruYNJdtInSP9OdxLA9U13czRfdBSq?=
 =?us-ascii?Q?fRx+WfuNALUJ5Nz3OL10sVBdi5O54+N5Xo16wl1YANsmj41/WuzpkPUbwU9E?=
 =?us-ascii?Q?iAkAtuEgFVRG4M8AXfhfvsZqZcwBmWBsk3UfYsNQhmemXeq3sHA6tqD0snQ0?=
 =?us-ascii?Q?MpJEmM/7OkglS+/GCFiwT2r1UgqjO4gLpyPVV/1EEsMPQ6bm63yRqCmIbAGH?=
 =?us-ascii?Q?IqbG6g5HKWIjr5QB0spQ3geAatO62MdQFMnhxdlY/KQX0PD8EkI+FZdAYZ99?=
 =?us-ascii?Q?sMEnZFxEqIT7oPJ4dqdtGOTrf4to84cmJJxAtVrw8PNY+BfeRuWSSyM4wsD2?=
 =?us-ascii?Q?yEYrbz1sWyN1WdM5Bf27bHsp0VrzEqWN7QWKwr73Z7dOFZauP1hvHYDzfRUb?=
 =?us-ascii?Q?higPEDQ/CggfguvjvIg8vUNGyFwgtOPgf4ZgpewJarYJg9BDyKTEI8vDM+Tk?=
 =?us-ascii?Q?TkosWAJ1h99HRM6ltrrhIVQ3wvOnOSwzhICP6kjhxyJKlZCy7wtg/o3Lzz0z?=
 =?us-ascii?Q?r5d3kUVqCkMivYZFnyIEQvC88tHdbSo9KysKjTteov1sc1qMPSrXsxdRE2p1?=
 =?us-ascii?Q?TAg+l9Vdjm61i3n0qcOdQUTBB+0iccT00i6zQYslfpam3GQFlyXAtJI8ZcG/?=
 =?us-ascii?Q?l1Ee1IJmmLuem2ZFV+4A2xUyr1XdsWlPbRUKO7kMn7ekYoHVX/9ffIuvUW67?=
 =?us-ascii?Q?7Un+seG3vwQuBJGUjLACcXCGY0hhpjSQ5G+qhI9GEXRMzqLTMw536zHZiS2W?=
 =?us-ascii?Q?Cl6NEHcOmazLhfRmtDW0WBJMZL4X2EaHHaiJAUpvCbok9FAmN8IcvbxaGwNC?=
 =?us-ascii?Q?56lLsHd/pvlHI9Fw6SXZyhr2bkWSrrFnfuwdgtvS9KwGwl89pcwpshyBxDcz?=
 =?us-ascii?Q?eb08W9h+cA4ZyaugotDTMDiDbXPP1wDAiIL209q4f90DjTq2D5YGfyDlTn8T?=
 =?us-ascii?Q?zJQjDuR4ARxLe84gK60BJfpIclyeQ2bk+mf9KxfIb/qaF+rksPIsnncImTCx?=
 =?us-ascii?Q?dG9ZmeA5+Jslt18HjeYFpf55+nWFb44NuDLi6BkDdOaz+L56EHrB9FdaUZq0?=
 =?us-ascii?Q?p+MfFSAvqYbsSPgcM4dfRIpiaGGuhLh2CMuOyTGAvv4FaynFmxLI?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eda7e922-a5a7-4564-2ddc-08da324a12d5
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2022 05:58:15.2525
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4KRiOPp5KSh5CUTYWlnJulUUs19NYXac2tDkG8zGfGNt73zP82MP4bRwt0kN6gdYAaGF0lVTK7WezkSwxIe45w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3882
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Bloch <mbloch@nvidia.com>

Combine dmesg lag prints into a single function.

Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/lag/lag.c | 22 ++++++++++---------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index 716e073c80d4..90056a3ca89d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -107,6 +107,16 @@ int mlx5_cmd_destroy_vport_lag(struct mlx5_core_dev *dev)
 }
 EXPORT_SYMBOL(mlx5_cmd_destroy_vport_lag);
 
+static void mlx5_lag_print_mapping(struct mlx5_core_dev *dev,
+				   struct mlx5_lag *ldev)
+{
+	int i;
+
+	mlx5_core_info(dev, "lag map:\n");
+	for (i = 0; i < ldev->ports; i++)
+		mlx5_core_info(dev, "\tport %d:%d\n", i + 1, ldev->v2p_map[i]);
+}
+
 static int mlx5_lag_netdev_event(struct notifier_block *this,
 				 unsigned long event, void *ptr);
 static void mlx5_do_bond_work(struct work_struct *work);
@@ -311,7 +321,6 @@ void mlx5_modify_lag(struct mlx5_lag *ldev,
 	u8 ports[MLX5_MAX_PORTS] = {};
 	int err;
 	int i;
-	int j;
 
 	mlx5_infer_tx_affinity_mapping(tracker, ldev->ports, ports);
 
@@ -328,11 +337,7 @@ void mlx5_modify_lag(struct mlx5_lag *ldev,
 		memcpy(ldev->v2p_map, ports, sizeof(ports[0]) *
 		       ldev->ports);
 
-		mlx5_core_info(dev0, "modify lag map\n");
-		for (j = 0; j < ldev->ports; j++)
-			mlx5_core_info(dev0, "\tmap port %d:%d\n",
-				       j + 1,
-				       ldev->v2p_map[j]);
+		mlx5_lag_print_mapping(dev0, ldev);
 		break;
 	}
 
@@ -393,11 +398,8 @@ static int mlx5_create_lag(struct mlx5_lag *ldev,
 	struct mlx5_core_dev *dev1 = ldev->pf[MLX5_LAG_P2].dev;
 	u32 in[MLX5_ST_SZ_DW(destroy_lag_in)] = {};
 	int err;
-	int i;
 
-	mlx5_core_info(dev0, "lag map:\n");
-	for (i = 0; i < ldev->ports; i++)
-		mlx5_core_info(dev0, "\tport %d:%d\n", i + 1, ldev->v2p_map[i]);
+	mlx5_lag_print_mapping(dev0, ldev);
 	mlx5_core_info(dev0, "shared_fdb:%d mode:%s\n",
 		       shared_fdb, get_str_port_sel_mode(flags));
 
-- 
2.35.1

