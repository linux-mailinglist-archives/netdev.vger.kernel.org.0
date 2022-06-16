Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F7E354DF58
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 12:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359830AbiFPKno (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 06:43:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376613AbiFPKni (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 06:43:38 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2060.outbound.protection.outlook.com [40.107.95.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93F352DD4F
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 03:43:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b2rz2dvb/VzMmuNLv0X4INwHibcFhmEIj7FWE/mzKBvEPL1RKhjxaU1SNz8QMY6hj5z5OlM2OUzi52inWcG7ZzJO93gxty3OI0ZP7q6zKD09RSSEzXQRkru/Go+7AEhXCYG4HHpKMeZ/HyAGJm2HLD8/Lzo0DUh17dF9pofRKz8UvMkb6bMJc8nfJ/3mTkoIOQAYririBQjrpFTacqDpaObfU6KkMb3cq/SBao7zL8jk9XhwGPVzTL4afVwDyrMoWMjwxB5bej3tmWw27HJBDd9MYRSltf5bQqukWQum5H9kr34o0mmCzh6L5MLhdxi4kZgl3c4bQCHK5pC0rYGQOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ll0/8PLj1N+rx9lLxxQolT5nGOirX16XQ/AgVvbbYiM=;
 b=SsOmvCOc9wYA8jsG16zQetap7UrnEITaMZ44LIko69yUWPgOsN6BqlSuBK6uHZYisCsLL+wMV1IC71XSepTI/IKZBQk5ffFihgmMna8I/LyIBA/qDfqtvLOS9POPcky1aKuzN78mEY8YVL+Btr11jVqDXtWx7VDVIdv1rv77/gVpI7GYRgh6H3mCZQ//+s92RFlm/QrBPfLF2alS1AfZngI6noOkonSPMVLqr+W4+E8/movl8Wx6qZQipylj+CfxWA3mva+iG774dP8JQJHOWteYS9p9HpX+JhyF1kquzQGvWoX0TKvpffIG5nzDJFKW0AAalAEzN8UvOn85/ZredA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ll0/8PLj1N+rx9lLxxQolT5nGOirX16XQ/AgVvbbYiM=;
 b=jKISi2grhJGXc9qBj2Xf42ayQHU0yGJ7vdRU75EkvF69uJM/0Esre0V8FP79l0kkvu9WLZMTjJA/FNj1alkJIDnY9DucZlt5pOSwsEDjLmZw7nrE6oMCPXSI2BrzxKPbNHZ5N+EejbivWUlyvETASLhm8Kz2HRaxNXCFIEcNeVImpfAMJK14JZo6nP2MkWhgIBIK6dRbvxyw3V0kQHU94TwDI7Ph5iASyTwY5cpXFq0L+NkhBBDQaHv4gV0olnGbtj2pY4ypmnaFjdeklsmC1dTry2tjBdAAUAPBcAAfOwew2Qejt5Rf+qmemEVDBQuMgqGLlnD+Z3yB76px0di5ag==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SN6PR12MB2670.namprd12.prod.outlook.com (2603:10b6:805:6b::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14; Thu, 16 Jun
 2022 10:43:36 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190%9]) with mapi id 15.20.5353.014; Thu, 16 Jun 2022
 10:43:36 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 02/11] mlxsw: Keep track of number of allocated RIFs
Date:   Thu, 16 Jun 2022 13:42:36 +0300
Message-Id: <20220616104245.2254936-3-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220616104245.2254936-1-idosch@nvidia.com>
References: <20220616104245.2254936-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR09CA0167.eurprd09.prod.outlook.com
 (2603:10a6:800:120::21) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c2ff01c4-18da-4db5-6aa6-08da4f8510de
X-MS-TrafficTypeDiagnostic: SN6PR12MB2670:EE_
X-Microsoft-Antispam-PRVS: <SN6PR12MB2670EA17099328AF447F050CB2AC9@SN6PR12MB2670.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /0SB04LAOg+r8tqVR/lK0BjIK4+YqpXz4BUWA4CiIZI25OZHslxfMFhHXS0Ja+DFJ+LzBfCHuPcS/tDIZ4ONDPd5oNRUU+W4r0zkJZqB7+CFp4pTAj7dBDo4NC+EbNU/LRWj5WPl+ObEuuXaisWTiAQHC48N1cQEadSZ1FnyjpWH7J4ciaWEXsG4RARfM9L+M6F/D91RFCtwOKWFeb83IhLApfV8/kgdNtNWCQ/gUZrTlGjj78QMsRf8GIUNP9Phjaut7z74RUE8+u9owcSrIP3JNRhycxx83tPSr+sYa+ZbarVyDiU6+SvF+7rk3yPnLgvmgyjKlyuxM6tyDic+pGGbhetirHxhOmNQ5vKlbtts4XuXNkq743g+JOwpThgwRGtEa+54UO8Lxx85g37ymeVtojTyT4jN7eeXOqNNtaKgw7UdJjwEl/G4cyhFm1FYgEP+XL+DhhPfXQVByuSMbeX5/q5HnkeRkgeFXS43Oq5vYW6hX6QPNZlKPzWngwYiqDfuqudMzKOSdjntKpI+dinYB6bnI1u/OOPKXi0Egr0Q/wH2lJOVrIbq6VxlDPxNkxEB6G/202GI3WSBcWnqmtoePtXYEW5jlsfB9kCRtTneLR6qISdNTQWU0bSu04ZQC2vSO7tXGLjYk65l2TuMEg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(4326008)(508600001)(8676002)(66556008)(86362001)(66476007)(66946007)(316002)(6916009)(83380400001)(6486002)(186003)(6506007)(1076003)(38100700002)(66574015)(26005)(6512007)(2906002)(36756003)(8936002)(5660300002)(107886003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9E7GFKBoxM6OaQg3louzDKv2xP1EpKEu5+DwNsei/+EtYCVhYB870/aeAuES?=
 =?us-ascii?Q?X0Qtj395jBMCdsjgVI4LPu6FONYnvpf6HM+babfsF+huobECgkCMGIHwJ4yU?=
 =?us-ascii?Q?z6b1YJPO5KsEdjs9gT7eDFwuDsiYPkoFg8o9TD7qUt+TfQyQGiRFR7UtPXIM?=
 =?us-ascii?Q?5CV1Btm4ispCRwPLPJgEPjO2I+ZbH691DOT2yeLxlHvWQL+s3Zy+xvatID0U?=
 =?us-ascii?Q?ycT3WUfp4bde8/OtNviseeC+lznEU4dD9TUYaFupWDYwDUkkp1GkCZJexmgR?=
 =?us-ascii?Q?4wyWvLxPKORomR8ce3+S29/QlYz36yMzqf2+IU3OYQVohCnOg0ywUlZZ9O46?=
 =?us-ascii?Q?SHJuY953eA5gfIDwWeigy6fXCXnNC6B7QDJaEbOmxBcgYIcTwRJ58QWJzT27?=
 =?us-ascii?Q?a3Bp6HqabLo1tySV8sSjci3XlJ+tiHW2ZFeym6KME7AzsK0Oj/Hx4elI+Lj/?=
 =?us-ascii?Q?u96cl361KhMRlkEktciMHBBmGM/hB7lYRuSvWwhG9js5SFRT38lGJ9CyksKW?=
 =?us-ascii?Q?5h/QkBaeVnDAyfoCeD3e77YAyYVr6XwIXbYs8qZLhXpxjkLStN/jwcTnKkjl?=
 =?us-ascii?Q?6uC/HuUSDPzZ/8qkKAEC1b04Yg0ntE4r86bcjRxC8rSsJNqJakA8MezuNUm8?=
 =?us-ascii?Q?foo8SHMJdiPb+eO9Ds9ebMYRvNnounVkJPGIlJHcT9ZsFH7uxhFAp8woWDk1?=
 =?us-ascii?Q?fbxWAhqQfZs2Ei69NI6k+RJoOapg7UwAa9RJN9R4L/J9Bk0NQwu9xqtyCsAi?=
 =?us-ascii?Q?6bYKMm7o5JmJwMovvYQf5gLgeEJ9pyKH+dhHLYsCx80ThSHIA7LnzMkjeTlS?=
 =?us-ascii?Q?aeUCRn+CQg1ZB3yuWqwJL/jaL7mYCs1wqtV45vO+95X8StNuRebWs/qh6Ftz?=
 =?us-ascii?Q?qeBX15k76Q6D3ImkUlvkoT92mEzlIB4oqqm9wipQnUu/Rr5O31LDParQ7ltH?=
 =?us-ascii?Q?8pXdN8619+DNwbCFFXbnXosJjfcQwJKtNtnFwP5J/AwAoFZWCJkmzFc5EeMG?=
 =?us-ascii?Q?19FEhXvZKxDUCjrhnmiiO6MhXUeUNJ9LV0qZ2UnWlXnle0z1N5VaOL/D2vkw?=
 =?us-ascii?Q?Y/WxejJvk/+AG5CuOIAuo8XQgkYpo5yg9Qoc+OkCD4kCLQ3Ov7NO8AXOt3uN?=
 =?us-ascii?Q?EaiXa/rzyCXjiTYiB04WaWj3agy9kf33+rkzoJLxGO1YnsU4J0Tkfs3GbH94?=
 =?us-ascii?Q?DfmQQUIFbd8iCzFBVaRUiQFR6cfSniaR+GX6yOu++2jh4vu3DCq2BoMEWJW0?=
 =?us-ascii?Q?W8GbbMqBrjYNnsrkMqEKO2Hmt+HGN7f/0r9Ht2eXQg5iBfgocPDTn+bwm7CY?=
 =?us-ascii?Q?OZ4DJ1UotDw3ScZRJszD0awTfzvWhqUv3vO8+UPBUjv58meAX98y7utBklbI?=
 =?us-ascii?Q?7dNbn0pM97VDd8tN9aEWRmS3vZrjFvI1aXL3J06sXac9mNKvbJIqywSS8Hpm?=
 =?us-ascii?Q?F6p2k19QUopYn7TRUL2HkQnsB49lFXlMU7QgRtKmVc8X0Gg+aoD5dIoKZm0c?=
 =?us-ascii?Q?ryMAPpturo/mrba/BwoQ1VYwViqEqywK+oP3q9jcqmzn4/uhGR9LU2qB57T2?=
 =?us-ascii?Q?y7Z42wIbmc8Y+RD8eXLDA9/Glr2gXtEYN+HSRpPKMQchCzMqNNWB1vAe5xB5?=
 =?us-ascii?Q?e+VQhPqtEM+hdydsTL57C2GbI7aMAb3KGv6jUbKbz7lUx9cmzNQR5c4y8EuJ?=
 =?us-ascii?Q?U4hkc7rv4oTksm+c6jn3FkG15Rs2vKsUl0eI1vsFNQoOAX8ySugvWMMV8481?=
 =?us-ascii?Q?hbYoHLGqOQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2ff01c4-18da-4db5-6aa6-08da4f8510de
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2022 10:43:36.0959
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YoiwUzOeReVV8kBTR+drMtvqc9HZbMsJlqQhBJ0jRN6IZRud4jv8PMuVH5a8WcOnx9MoFd4Dzi0f3qwwLHriYA==
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

From: Petr Machata <petrm@nvidia.com>

In order to expose number of RIFs as a resource, it is going to be handy
to have the number of currently-allocated RIFs as a single number.
Introduce such.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 6 ++++++
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h | 1 +
 2 files changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index e3f52019cbcb..07d7e244dfbd 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -8134,6 +8134,7 @@ mlxsw_sp_rif_create(struct mlxsw_sp *mlxsw_sp,
 		mlxsw_sp_rif_counters_alloc(rif);
 	}
 
+	atomic_inc(&mlxsw_sp->router->rifs_count);
 	return rif;
 
 err_stats_enable:
@@ -8163,6 +8164,7 @@ static void mlxsw_sp_rif_destroy(struct mlxsw_sp_rif *rif)
 	struct mlxsw_sp_vr *vr;
 	int i;
 
+	atomic_dec(&mlxsw_sp->router->rifs_count);
 	mlxsw_sp_router_rif_gone_sync(mlxsw_sp, rif);
 	vr = &mlxsw_sp->router->vrs[rif->vr_id];
 
@@ -9652,6 +9654,7 @@ mlxsw_sp_ul_rif_create(struct mlxsw_sp *mlxsw_sp, struct mlxsw_sp_vr *vr,
 	if (err)
 		goto ul_rif_op_err;
 
+	atomic_inc(&mlxsw_sp->router->rifs_count);
 	return ul_rif;
 
 ul_rif_op_err:
@@ -9664,6 +9667,7 @@ static void mlxsw_sp_ul_rif_destroy(struct mlxsw_sp_rif *ul_rif)
 {
 	struct mlxsw_sp *mlxsw_sp = ul_rif->mlxsw_sp;
 
+	atomic_dec(&mlxsw_sp->router->rifs_count);
 	mlxsw_sp_rif_ipip_lb_ul_rif_op(ul_rif, false);
 	mlxsw_sp->router->rifs[ul_rif->rif_index] = NULL;
 	kfree(ul_rif);
@@ -9819,6 +9823,7 @@ static int mlxsw_sp_rifs_init(struct mlxsw_sp *mlxsw_sp)
 
 	idr_init(&mlxsw_sp->router->rif_mac_profiles_idr);
 	atomic_set(&mlxsw_sp->router->rif_mac_profiles_count, 0);
+	atomic_set(&mlxsw_sp->router->rifs_count, 0);
 	devlink_resource_occ_get_register(devlink,
 					  MLXSW_SP_RESOURCE_RIF_MAC_PROFILES,
 					  mlxsw_sp_rif_mac_profiles_occ_get,
@@ -9832,6 +9837,7 @@ static void mlxsw_sp_rifs_fini(struct mlxsw_sp *mlxsw_sp)
 	struct devlink *devlink = priv_to_devlink(mlxsw_sp->core);
 	int i;
 
+	WARN_ON_ONCE(atomic_read(&mlxsw_sp->router->rifs_count));
 	for (i = 0; i < MLXSW_CORE_RES_GET(mlxsw_sp->core, MAX_RIFS); i++)
 		WARN_ON_ONCE(mlxsw_sp->router->rifs[i]);
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
index f7510be1cf2d..b5c83ec7a87f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
@@ -20,6 +20,7 @@ struct mlxsw_sp_router {
 	struct mlxsw_sp_rif **rifs;
 	struct idr rif_mac_profiles_idr;
 	atomic_t rif_mac_profiles_count;
+	atomic_t rifs_count;
 	u8 max_rif_mac_profile;
 	struct mlxsw_sp_vr *vrs;
 	struct rhashtable neigh_ht;
-- 
2.36.1

