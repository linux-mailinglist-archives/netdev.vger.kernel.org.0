Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43D3A5614E8
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 10:24:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233884AbiF3IYN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 04:24:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233613AbiF3IXk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 04:23:40 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2061.outbound.protection.outlook.com [40.107.237.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB8CD102
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 01:23:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XZ9n/7/qJ6fL4GCprEuaZddhEBckQH1wrpWd/S3YQ5om2Gco712DGx1xfL1o73dBVGvJiWRVLtHHKjK5Ic7aCtGg3Ha1+/qfN9yFrdq9plE2wqHdVr4150DgePlydKeIFMDWRREkDznUzlp/tB3yBqZNF7R7NeDszKnDPCK/tLPWol6Eh3Gc0qt3cXxdB0ksHtoWiHiY4w/zkJzqb//SB2lwYTQHq1FRALRLjZeAU4zEH3KnSOeXTg1CMrIJfuP4WZb/9PggKxWj422UCDXZGVt7s6A+hs5YWkIQSt5bq6bCTg6/HB2sdnh242XBlrJWIcfs2rVtQafwWFQIksdfcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PaW3JiSEJ/xK1Qn+SQpmM7tyNY66/Kkx3qTK1TG2FhI=;
 b=HC7gOsZDsL97crxven6s8CPS8KVhSm9psYXp1WQKnYH9q1vTFtPXCxN+rdUwU8ehUvK5qChhFkx009aLyo/ZGE+ngvqKCYuGbvp9Ls+mZdsUZHvny/eQRMuRRvnwlw9+CsrqBWKt8Ndc++1H7Qy989vbKZu00sQhIoMv1jqJEZFvTHC/lbvF05E0EhBIDTBQqsT+JJH/g5uXJG0ND1xGYy9RLrt/nJQ0EO+3AGBhLjAv2ks4ttAOzkXqxjfn6gpiZn74hhbLa7j5+TyiRPZplr9q1Z0uk09lBb8U/an7L48nt0ksHK5JSMsIiGbjjjJofUiS3cCUQAJ9ZeBC4QslHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PaW3JiSEJ/xK1Qn+SQpmM7tyNY66/Kkx3qTK1TG2FhI=;
 b=ANwEayr61oVYRBLPmbuP8t4EguhXi7WQ5P2u4lsGK0AvMQnETBgUcaO9a7Hj0V1h7DSnENumDBUJG1O5Eyy+/Ckydp2RHP5Q/0rquiy6isoVpkxtdD2qYc2NNgKq+prVj7cre5S+4E//6eH2ww/lMq/5TH2U+/967MxtjnXG9DX/Cg6HMtLHg5K1jvgUf8rYvLGNhHowpbm47H2A7E99eevA5HXQuO7Xlp4X9l2LX5n3YSwlwqrWOsaX1Pi1BAd4KiPrHEOxxsFjLN8xFssQhtQkr4QQNOWO7sAr38uUbIm9wDhz7bqiqaAEWnWI92mlGMjRUtnX96/kmab37Sv5TQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by MN2PR12MB2880.namprd12.prod.outlook.com (2603:10b6:208:106::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17; Thu, 30 Jun
 2022 08:23:28 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34%5]) with mapi id 15.20.5395.014; Thu, 30 Jun 2022
 08:23:28 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 02/13] mlxsw: spectrum_fid: Configure VNI to FID classification
Date:   Thu, 30 Jun 2022 11:22:46 +0300
Message-Id: <20220630082257.903759-3-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220630082257.903759-1-idosch@nvidia.com>
References: <20220630082257.903759-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR06CA0158.eurprd06.prod.outlook.com
 (2603:10a6:803:c8::15) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7fdd42be-0bde-4745-c295-08da5a71cf48
X-MS-TrafficTypeDiagnostic: MN2PR12MB2880:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DAFAoBHWvLdrU1olnkwjreV2RyXfQYWUJR0DRqFZFcL0HTvDBfHXzfN6AFmD+TxC+3YhxjKY2/r4z8G7h7etsfRkjl4MrBn4m/i/7CU1eaSwjO+Tv1LOP6uakUxNafydYULtCQ0oVGTBoWUQYWRNjgAPSLSueYa2/GvJwri2uJ7K32tOv/3YJ0ZXET9depd6bzksgBNr3wRx1Up/Sg+EKROtqXutIlM/bg+vU/J/J7pTkuPRO9SxW8MPs24hh3Q7/IN+44qWUbchsl5eG0MFboTqsszF+mxVkmklZNYT8qRR5Cm2Bcb1xRFMIdzaQwC1ZdB9Rehz+dZB/H6OZva+FL0S/TVACxge0IKzmMj9JSwq9hptRPS2rjQoT2fzcpPOWlLvuXVwRv0F88H7FVB3N28DXOIhtc/r5OHnqewqUKwmTgwWAJ6rXqgMdi1HUnsnmRLH3ymCB/oGzOg+Zor+x24iJgy29pR1AjKNCyphweTdGYC5oslkgb5Y/YzxJa4q7a7AKLMvow3032eHQcHx2bm5/v9niqtARcf+8bS5+BNVgLrqmwNajJoxfl/pRBdNHtPdGMwVYWx1tgDLySfPW2drYehO7cKN3CwCgRzw3ZMPMH1baHIyTpBUXZFFA6kkh2twMZatwAYbnBAtiB6OXTISvGLeRfbxHqyt+GvGrGUbuo2EeYu/nNMr2/Wv3mSRo0MxRa1Bvz+QRSYoKh/DK0x5hx+qBDtV5q6FM2BD2auVOpEG9knH2+2St7EzsbjKVzb1j1U/H0RaZKg3dYplVw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(376002)(366004)(39860400002)(136003)(86362001)(6486002)(1076003)(36756003)(8676002)(66556008)(66946007)(478600001)(4326008)(66476007)(8936002)(6916009)(186003)(316002)(5660300002)(6666004)(38100700002)(6506007)(2906002)(6512007)(2616005)(83380400001)(26005)(41300700001)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rLxvTOh/dpDFz5JE8mOPaXIz52kugR2zRrL1TfBJlhj3rnRFLmYKkoFupuEF?=
 =?us-ascii?Q?40Zrfb0AdosMUHJpJX8dQXIxvjKEPa2XgKYwY06Nuspzd4+SC3xg9GPUPIa/?=
 =?us-ascii?Q?OUhCZnR5dXVTTQdhd/m6unVGzt/p6KpMyNwFse1nKDN6JGxZqIU9IiszMth0?=
 =?us-ascii?Q?Z6G5acSVd62++eo6xj9xE3PKhfnkhFWfUM4zKzZCSkW9Vy4d3rsqfBjE9WnB?=
 =?us-ascii?Q?vu03ABnStjgX41k6qX4DqVSYFXgKI/rqB3jvZ8yzu0Ul0LMhJf1hyXP1SN10?=
 =?us-ascii?Q?jYK7SqXrWuPSKJcAWJX8iHyqEBI3MjriBosXhgnUOuqcTEcHmc73CqDwQ4Wz?=
 =?us-ascii?Q?xfQEyQ7mc5wXegSHZjkkiTAUeIwSamQlfdl3vjcfapCjFBk+E3Ttpcx3yPQZ?=
 =?us-ascii?Q?WO73PtOZeVvCRXXlsoZHYzb3TybrzY6harSirY3BT8VbjEB8Hl3H0AF1Oxov?=
 =?us-ascii?Q?bpZT/a5BUMbA9OWlw01MVUVHzNZACFS5xDJZqMFCo98d+gAXxoKnaOGWuRZ4?=
 =?us-ascii?Q?g6Kpd6TTx9L5yPAmRb8c/0iNly4i/4utItWSCqcYNTJ4aa9NUIOn+sfoQRyl?=
 =?us-ascii?Q?ztUHCZwqDg6fmOkgN6jvEvixhtjlicnZ5rDGjR/vapWVsNun4rnAia0kDaS9?=
 =?us-ascii?Q?sY43EC+2JmZt0fks8hAL6ClASl/M0uRZPzaBxB+1/T0BNFqYCY0xfiN3O27j?=
 =?us-ascii?Q?/jt+N/dT51pWt5i0wTbmgJLGvldTORNWD6L6ib3VZGsL0MdhmyhkIPO5CxqI?=
 =?us-ascii?Q?Z1ru3rh0Im34R9tu+bDVXyKWNtxTWRMtUCLY13yYbBJh5ELDfWFte5YX0cf+?=
 =?us-ascii?Q?ERG8bo/WjpQWbiixhvJEAqqu5n+bAB0Rcz0AWaFgnPuVE135jC7YxjuHwSNJ?=
 =?us-ascii?Q?e4ztnPzDLmE9/LRXmRv5/7c7qZhncHiAaFpWECn0UjFYjjuFscTCD0cS+Q4l?=
 =?us-ascii?Q?Hccx/LeZWDw2uTYI3rUaTLbAHdcdIPIYCt7Zk2eUWbLmSkY4QCBX5F/2nBq2?=
 =?us-ascii?Q?j9dP3WldfJ7PmVZ1plXwm75lvDarvu58J7FPwk1Q8y+p6MocESqGNBytt/hV?=
 =?us-ascii?Q?6ypmbszVJly3mPYciCXemQnMW4Fy+FaG8MmagA7pDvA6lUlk/gCq5JLXKV3N?=
 =?us-ascii?Q?8KW6/Xk/IQU+/e6yj0gcQT4UmjOEx8nEMpgOwj537cUGDX/72ROpKFk8sTs6?=
 =?us-ascii?Q?e7bFYN2QvUwCUJrc6lrJ3Zq0wxn52neN/rLXJoUzkXR9Y0Ushv3bMQz0dQRU?=
 =?us-ascii?Q?520aikWolgBRNBMaoF/yiDtkYKgonvBHfNAscPnGwjVKTzu6gQNLSbTlKmGU?=
 =?us-ascii?Q?8TmbMhfM2UC0Mk+SOWSZCXRPmjdMkWVG0Q3oHOv5rICkI4YdtBUBpgwRFCmL?=
 =?us-ascii?Q?TyrE3nwukwm1pfMzxcFB9Wgwi0hmcO0qb14RYBJL9CS/S43RAsLM87aE/ANy?=
 =?us-ascii?Q?vPPbcXznO1/kWhlReEJ8FGxlFDvQNVdhejpw53AImxlYeCbEG+PZ+ASupepk?=
 =?us-ascii?Q?oPUm6tx+WtiiQDLum8kxvhONvQ2EpiuEsy4XzXcVVswpyep8UzKHw9M2ZqVF?=
 =?us-ascii?Q?gjaBlNEmH8JGaKW0DVVlZVvp7cST8/Q+JeQNtD6S?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fdd42be-0bde-4745-c295-08da5a71cf48
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2022 08:23:28.3521
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IzZjFeOpxdBxpptw3Z4OW5bd+lstqaRBAeM3vkYn4sJcz3pjYEFXAOH8YEkmiM8FOikxvp7+Xk3z43v71ITMwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB2880
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

In the new model, SFMR no longer configures both VNI->FID and FID->VNI
classifications, but only the later. The former needs to be configured via
SVFA.

Add SVFA configuration as part of vni_set() and vni_clear().

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_fid.c    | 38 ++++++++++++++++++-
 1 file changed, 36 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
index 160c5af5235d..ffe8c583865d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
@@ -487,6 +487,40 @@ static int mlxsw_sp_fid_edit_op(const struct mlxsw_sp_fid *fid)
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(sfmr), sfmr_pl);
 }
 
+static int mlxsw_sp_fid_vni_to_fid_map(const struct mlxsw_sp_fid *fid,
+				       bool valid)
+{
+	struct mlxsw_sp *mlxsw_sp = fid->fid_family->mlxsw_sp;
+	char svfa_pl[MLXSW_REG_SVFA_LEN];
+
+	mlxsw_reg_svfa_vni_pack(svfa_pl, valid, fid->fid_index,
+				be32_to_cpu(fid->vni));
+	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(svfa), svfa_pl);
+}
+
+static int mlxsw_sp_fid_vni_op(const struct mlxsw_sp_fid *fid)
+{
+	struct mlxsw_sp *mlxsw_sp = fid->fid_family->mlxsw_sp;
+	int err;
+
+	if (mlxsw_sp->ubridge) {
+		err = mlxsw_sp_fid_vni_to_fid_map(fid, fid->vni_valid);
+		if (err)
+			return err;
+	}
+
+	err = mlxsw_sp_fid_edit_op(fid);
+	if (err)
+		goto err_fid_edit_op;
+
+	return 0;
+
+err_fid_edit_op:
+	if (mlxsw_sp->ubridge)
+		mlxsw_sp_fid_vni_to_fid_map(fid, !fid->vni_valid);
+	return err;
+}
+
 static int __mlxsw_sp_fid_port_vid_map(const struct mlxsw_sp_fid *fid,
 				       u16 local_port, u16 vid, bool valid)
 {
@@ -724,12 +758,12 @@ mlxsw_sp_fid_8021d_port_vid_unmap(struct mlxsw_sp_fid *fid,
 
 static int mlxsw_sp_fid_8021d_vni_set(struct mlxsw_sp_fid *fid)
 {
-	return mlxsw_sp_fid_edit_op(fid);
+	return mlxsw_sp_fid_vni_op(fid);
 }
 
 static void mlxsw_sp_fid_8021d_vni_clear(struct mlxsw_sp_fid *fid)
 {
-	mlxsw_sp_fid_edit_op(fid);
+	mlxsw_sp_fid_vni_op(fid);
 }
 
 static int mlxsw_sp_fid_8021d_nve_flood_index_set(struct mlxsw_sp_fid *fid)
-- 
2.36.1

