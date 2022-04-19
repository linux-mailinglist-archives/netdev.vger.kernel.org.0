Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80D01506F2E
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 15:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352914AbiDSNzb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 09:55:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344219AbiDSNza (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 09:55:30 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2082.outbound.protection.outlook.com [40.107.94.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A7B126AE2
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 06:52:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=num4TOJBNK5jBV1XPmBtxRFRi9EZ9OIOM1LsAW6uKiqS86jH5y7xVGsbXoRLxvO5OGuRaYzhcqok/rfd3b/6RKiGVva9juDPNM957JUsJs9FGkdNCbMGdG1YZtn89WOZENsEZYHlo8BktEulusquXHM1TlqNLDhw20C/C3SNP0KIGkEfZ/miMe5JeIPTyk/yTJfnhECdkL6iiaEVEAmwsZKfaD5pIYA150w7LRBmn+D+MNlyJmPekYyJtlcZ6Y7ukcPdYrI1j7Hl/lT3kcA26UtuUm72cWIYq7tX+EpQS7OGQGcNjcUTvAtmiiZZvkkicza4vBzI/KKF414736pL4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AALzmQqSTvEY3zTNrSWLHySihE9uxIQJ5J97TAeLXRE=;
 b=nk5hfpgPk2uXP5xeSEYoVqQTGNkVs3HjSIG51Q7ceuY4ULMQR61DKe+fQ2sdCTx2IbrUp3OodghO5DfBaPkhOAz11Q5BlsdOkOSOplqzCiipYNJpsFfl3fBtFq23ntpH2aqxnKeV8RkrWsoFOPWuvELjDkJ02Eol0X/fc8eto4JzFSyaZ32pDEoUgcS0lJAYLiF35PpZTRDfeU9k8zqFciXXQKvakyWBIOrOzveMmotJ4gxQic3Nx2bqHI65sdz/8XxtLkhSVm+dpEg4pJfiiuaP3FooneOefO3+s08OEhP3Tl6NOEM+mlv6nX7uGloOJRdfLoeZEXIeh+q3BDsTFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AALzmQqSTvEY3zTNrSWLHySihE9uxIQJ5J97TAeLXRE=;
 b=Lfvb1uMEcDx4czaR/TOE158VQPprc2hHqd/Pmi9gLPvYSbypz25dqFLoNTEujd2sDi2HlYPWXnkjKMEDwfzk6xcPtO2xFTgiwPdmBrf6Xl2GBoLRndErMDWghDNCYHl5t/phZyGd+/RNpX1Rxu/eQdVbuY/NP+GAJu03YF/Fd3V66WLwKdDeNilPMiZ+EWpKOsSGsjlnvOdlWAJSTi3DyYNb8Z7NIgzpn0bHmzX5KdewXKEfewnEtvV3vlp2v2vOcEvfGPEoNp9X8oqSOObLwzk+0hPlNX9noaHC++k4sn8ELFO51/OWFFU80/M6BuqFjSOiAypELuMLy9fmk2FErw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MW3PR12MB4347.namprd12.prod.outlook.com (2603:10b6:303:2e::10)
 by BN8PR12MB3460.namprd12.prod.outlook.com (2603:10b6:408:48::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Tue, 19 Apr
 2022 13:52:44 +0000
Received: from MW3PR12MB4347.namprd12.prod.outlook.com
 ([fe80::9196:55b8:5355:f64d]) by MW3PR12MB4347.namprd12.prod.outlook.com
 ([fe80::9196:55b8:5355:f64d%2]) with mapi id 15.20.5186.013; Tue, 19 Apr 2022
 13:52:44 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        petrm@nvidia.com, amcohen@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net 2/2] selftests: mlxsw: vxlan_flooding_ipv6: Prevent flooding of unwanted packets
Date:   Tue, 19 Apr 2022 16:51:55 +0300
Message-Id: <20220419135155.2987141-3-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220419135155.2987141-1-idosch@nvidia.com>
References: <20220419135155.2987141-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0502CA0022.eurprd05.prod.outlook.com
 (2603:10a6:803:1::35) To MW3PR12MB4347.namprd12.prod.outlook.com
 (2603:10b6:303:2e::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 16048462-6c25-4adf-03d0-08da220be119
X-MS-TrafficTypeDiagnostic: BN8PR12MB3460:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB3460DD582174D5BA733656B9B2F29@BN8PR12MB3460.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lJOlmDbRblwxhI6BI+DMcX3cIPEse3dMeAALE4DGQnvQduzcex/b7oGtCJiW7YWhRtKsTNVliTzPxVrPa4M4B9GumlqrgbaXCPnOsH1as8jQ9uIoIylpquBkJh/M1WaGwwVmcnP6YZyrTpLPqX6wsewiLb426SQn5zOf9xTdHu6Ocxa8E4LGtJF5q+KYEP9r+5COyScZUlZP/nd8C1ujosVHVqaWj3UKLTRnT4t+0D1npZk/htUUStYGvBIP/lwRIgYwp/8ATjgqcwxqVPZXbVYwm4hGVbN0YzbtFrHCDyAj41gS577rmpvjYRmUKB8RD1PGLuvGeAOAZ2QXVZ8o2VJ/ndz3tr+li0icFMNgi7Iy0B1YVPhYgPpjsjTDRWXIVSaY50pNu9GAL9yqGs2N9px68Luo9+AkxryXXcdd2xChiwWUXg8psM0ef6JvlJEmGTLzvngC3jaQH6pyMV8OIpuixYshpISSkAsCXSwh+eEcbHkjX5Gn82TTrZ2Rpr17VYFNmkm0sUMCLg+pM6LjY1d6Y4rWjkgyJ6g6UPOloXUu3v9Pf6pjLn/p7MCVg/racMFEzGFW5z6MJUTArTd5EfTYnUmdP7tcIZqLqysgrCoD+r1mFp0aHn7hGEk/d4w0QUkHo/NndcPEqqvmfqgoS/j8/WeQsWTNUbAVmYW8XJ9RKS4N28+ZOAF16C0pOGr/+Xw/DjSmx1WvurofY4S/uw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4347.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(6486002)(66476007)(38100700002)(508600001)(66946007)(6666004)(2616005)(26005)(1076003)(8676002)(4326008)(316002)(6916009)(66556008)(6512007)(107886003)(6506007)(186003)(8936002)(2906002)(5660300002)(36756003)(26123001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wgQkLL2sFfFwfiF3+MsP4f6nFNqz8QgiJVFp5mGO+HPSFzEw8cMqkz3//Hm5?=
 =?us-ascii?Q?P4gHUMHoAQ4LTJiR1HjcdGUHiGGgXXRc5lkyjwGC0Tfz5bU8sNVAKIFtUfiy?=
 =?us-ascii?Q?xxj9rAWjE2DGjRH626+e7Gq3EqNc8n0sRhVyphaSD4dGHUV/5HZ1rAGZk3zd?=
 =?us-ascii?Q?zWtK6D5bFWeYX7KwAYSndrejyaEPnmZOIfWKIdtF2tfbN7RTkOT+Yv9e3MxV?=
 =?us-ascii?Q?+F11oSOkOesv8CKr+gz4teYt01hHY3fkR19Vf0Vy5JYBFK5pMJ5Hv2c3AQ/7?=
 =?us-ascii?Q?WJ2t4AKizmN2/vC+7adzr9ITPIjSMxdHc9Rd8zZCVdrFSZWpBMxsMjtcUvl/?=
 =?us-ascii?Q?9usj9fvqdEQGZAPmJBBCAyBvFtzxqrCH7HjGAvcm3Fqs6NxA0Bz3hWRG/j8h?=
 =?us-ascii?Q?uKbn4jXBdmYrbsAGgFmVSPVdqvIPxsQ6M+PXv4Sy1VFhBryx7eCcUbia+IPY?=
 =?us-ascii?Q?L0zK1T/NyLs8ugb7gynO2f0eOp31m7obL0n7bTAF1ldYjIsFdDc5I7bL0N7R?=
 =?us-ascii?Q?tLe81t3gvRNy1UN5RgOyCZTWWXcxKq7odGO4t5ptoCzS4znhKAAvxjCED5xv?=
 =?us-ascii?Q?YK9E+mcaRao6WyNuIsLmH8CG6Nv1XAw84V76nVpoHyMZJmyzK4sqYmtH5WEH?=
 =?us-ascii?Q?6bCU46KA6JuOBx/SHdkIdPB+z0PR+X3UOPSGHmypr9ZOqmXXk9qyb2d0L9YZ?=
 =?us-ascii?Q?BFfdvoIkHm5BXCEDxUtFfvBzbaz8aI0uN/IKNJwPOkt+oEUW8N/aOmaSolTZ?=
 =?us-ascii?Q?tfYCdBSk3slZn8ROPVLVqRnhK34s/hDB1Un9FKjJgcQq9P8F1J37fcEc43l/?=
 =?us-ascii?Q?LiOi2TKS9JdjJlSuhjVAbmWWCmAeQNZg6sYHd1K+vEnwgM6SPrwtEZrDFGEa?=
 =?us-ascii?Q?3+jDNfY7BYl2ohrd90W+2YirnO5Rvhb96XJBZUNBwyF7UGYGcukt/XjybUR5?=
 =?us-ascii?Q?1ZgibgAYTJCZOLovAu9vroaw9/2ERDotaR5PaxTQgmIisRrUvDLY7vcGEW8S?=
 =?us-ascii?Q?gZLhUJRR0LJGmLMcDy+3lMCSSZ1mH57+808TlwXMUfIoi3hB9OaP1/mJx4kh?=
 =?us-ascii?Q?Im+Z1oLxlTJFos2qTGS4K9U9xTqwWqrfVFqC3dkgypYlSZmE39t8rNKZ5wpB?=
 =?us-ascii?Q?k2VPkfYapkGs1HXnVLjZdNeu4bc2GqOBq6ncCX/+3E4egRBEmoSDC4s+ZhJM?=
 =?us-ascii?Q?+CaJDqXe5gRs4jajO53zjjzKlrbyewUPrM86cVJCGQ+gE5JIHZs+SIkBY9Ue?=
 =?us-ascii?Q?FMAMEPSxhlMbzcNHGO7N+FLQd/p1bxgh8L3HyVfrOlNARvb9VeCU/s+r18/o?=
 =?us-ascii?Q?6lurd7PHaUrk5BOPlKpsgLT7T5MrShdJ/Tc5yRzVUZgGN1XFQUPMEg97TP3Y?=
 =?us-ascii?Q?c3hpwPPbszLBx71VhNacbYIxbLGqEP1Ympgci5JfOO21Y7baJT0Fz0u4UbRA?=
 =?us-ascii?Q?SedE2SE3txmERntOiClORt3yB+f5XUkbD/9TyNZDVdc9Uxdp5otneKB1SzUi?=
 =?us-ascii?Q?28xCqkTuviLnx3lgGAlQ/DCrQxsiedbvgUtgNrtzEXm9NSBn3mPNX8VIeKhP?=
 =?us-ascii?Q?DMXR+4r2AfXI0nCDaN6dv0Q/PvrTOJ3PkLBsRR0kYd9x7/7FYfaRwjGkZHcN?=
 =?us-ascii?Q?mkn4TvwF6zpNBCQX58xxSCfVe87qtjk4X2tyyrTx4lF/w6KnhIRRNJeoZyHy?=
 =?us-ascii?Q?dXZShDGkei3BlDaVID6Y15aI/KqEymKeMBjhEUYn6WjCRRqW7bwOkWdGi28T?=
 =?us-ascii?Q?67KA+uk9tg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16048462-6c25-4adf-03d0-08da220be119
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4347.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2022 13:52:44.4093
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eq3/0fvbsaFW73owMeJbYZ6iRCMXdf9sjSaczlp8/U5B30xBiYehUiNPNA1dMzR0GpixH3YeYCUZ0CxbXPFsqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3460
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The test verifies that packets are correctly flooded by the bridge and
the VXLAN device by matching on the encapsulated packets at the other
end. However, if packets other than those generated by the test also
ingress the bridge (e.g., MLD packets), they will be flooded as well and
interfere with the expected count.

Make the test more robust by making sure that only the packets generated
by the test can ingress the bridge. Drop all the rest using tc filters
on the egress of 'br0' and 'h1'.

In the software data path, the problem can be solved by matching on the
inner destination MAC or dropping unwanted packets at the egress of the
VXLAN device, but this is not currently supported by mlxsw.

Fixes: d01724dd2a66 ("selftests: mlxsw: spectrum-2: Add a test for VxLAN flooding with IPv6")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Amit Cohen <amcohen@nvidia.com>
---
 .../net/mlxsw/spectrum-2/vxlan_flooding_ipv6.sh | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/vxlan_flooding_ipv6.sh b/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/vxlan_flooding_ipv6.sh
index 429f7ee735cf..fd23c80eba31 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/vxlan_flooding_ipv6.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/vxlan_flooding_ipv6.sh
@@ -159,6 +159,17 @@ flooding_remotes_add()
 	local lsb
 	local i
 
+	# Prevent unwanted packets from entering the bridge and interfering
+	# with the test.
+	tc qdisc add dev br0 clsact
+	tc filter add dev br0 egress protocol all pref 1 handle 1 \
+		matchall skip_hw action drop
+	tc qdisc add dev $h1 clsact
+	tc filter add dev $h1 egress protocol all pref 1 handle 1 \
+		flower skip_hw dst_mac de:ad:be:ef:13:37 action pass
+	tc filter add dev $h1 egress protocol all pref 2 handle 2 \
+		matchall skip_hw action drop
+
 	for i in $(eval echo {1..$num_remotes}); do
 		lsb=$((i + 1))
 
@@ -195,6 +206,12 @@ flooding_filters_del()
 	done
 
 	tc qdisc del dev $rp2 clsact
+
+	tc filter del dev $h1 egress protocol all pref 2 handle 2 matchall
+	tc filter del dev $h1 egress protocol all pref 1 handle 1 flower
+	tc qdisc del dev $h1 clsact
+	tc filter del dev br0 egress protocol all pref 1 handle 1 matchall
+	tc qdisc del dev br0 clsact
 }
 
 flooding_check_packets()
-- 
2.33.1

