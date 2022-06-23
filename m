Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC3615573C8
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 09:20:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230190AbiFWHTz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 03:19:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbiFWHTw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 03:19:52 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2086.outbound.protection.outlook.com [40.107.243.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 723E646158
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 00:19:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GMAgW0TGUwddRvwi5QA2CKQr8vEehRL4Phxbk0dVfraIOtpHpiPTZPn3oZUUv9u16XBFek3gn9pJYuo2H6Qa9pPogSSH5FRC8AgS6k15I2dwuQx5wv7/KtGhr+le0GuQv2fLvilHFeX3jNnp+x3Q9c0Jy0zcOBPR+kAIEoIJWgDJavvAHliHB3Qs5ApuN/eb6OLQxn4szYDm83LnGlxikDoHmV4IN3q1wJfcEcUaZPqwZDa38lQgh7cFRHT1lcQYHRVPa1vYHvxe32XbXjzF53P9N5VtBhFlpg5/UVgzFK06f09FzxXrkQg78Gdu3tRopfpfi1TKfmzWmOYqrUB8Fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BS8XyxZGH4zDg+3gc5hC4F1P8qUZx0F69y1ADOxd5xc=;
 b=PN+43HSgdiZtoN5N6U0bgBPUwQnAVvrvwQgTwY8PAaork4rE4MFOFKvAY+cR/650FsX+ZBW+hBGkXnvQJWSgcFlMiRn5cSCHBMQyCGvIZyOrdhMzzMYRoYKV39AwipsktJOFUbnuQ6bxDJ6XEDjrkiVAXHA/PBbKWETjiRyFDb5Jkbnyi1sQ+lIUz8gEepqLCenUwShoHBhwJLi1I57xJ6JYF4lslGXHh5ds1cUcLfDVeXfkNollTSEHVDmxJp5u/mBybqfItTwejIw+8C2OXEW2Q/EcTvUPAXGB0nd4EhB0z5XDgI8hfEKxbrkZxN+nfGwwYhRbRcg+Eoyt6mpkIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BS8XyxZGH4zDg+3gc5hC4F1P8qUZx0F69y1ADOxd5xc=;
 b=aLwzgy2mviyKNU+D7NX1BAJym5NIDTuCYCBeI3e9x6TaDT5Iv1TXeX/KLObLpOvYXCDdTH+fo+3lgWIQLvtGlSPeQC1RI6Shr+Kpd0+vcSv5L4dxdBx6qJf5PW6+liW2wHzqvjudzOglWEf9NGYdTh6tEaH1z74h6uRcP6bSoLrfSjFmb8qsUoGDdYVXWdFdv4KfpyhwonK1MAqzHw/eAU2IjUSCjqVfNqIYo9diO3GvQca8wtn8Yf6VsKAC6L1B5/DkBNX05ylyho2Xk1rFqmI2Gzd9sFvHSsbIoDO81oFBUCVd9KKbyYcTiYKLQtDcB7HrKq302ZotaQFXaRzP7Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA1PR12MB6163.namprd12.prod.outlook.com (2603:10b6:208:3e9::22)
 by DM5PR12MB2518.namprd12.prod.outlook.com (2603:10b6:4:b0::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.20; Thu, 23 Jun
 2022 07:19:45 +0000
Received: from IA1PR12MB6163.namprd12.prod.outlook.com
 ([fe80::6da4:ce53:39ae:8dbf]) by IA1PR12MB6163.namprd12.prod.outlook.com
 ([fe80::6da4:ce53:39ae:8dbf%7]) with mapi id 15.20.5353.018; Thu, 23 Jun 2022
 07:19:45 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 5/8] mlxsw: spectrum_fid: Pass FID structure to __mlxsw_sp_fid_port_vid_map()
Date:   Thu, 23 Jun 2022 10:17:34 +0300
Message-Id: <20220623071737.318238-6-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623071737.318238-1-idosch@nvidia.com>
References: <20220623071737.318238-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR04CA0084.eurprd04.prod.outlook.com
 (2603:10a6:803:64::19) To IA1PR12MB6163.namprd12.prod.outlook.com
 (2603:10b6:208:3e9::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0510eb36-5ba0-40df-c7e6-08da54e8bf81
X-MS-TrafficTypeDiagnostic: DM5PR12MB2518:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB2518A48251E026C02379F3E6B2B59@DM5PR12MB2518.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: moXruhJA2xewodlppZ9JoXJcJNIzOml6tT9+9dQ4sCr6/fP5t0vxX942QroowfHICA7heLeYK8F6sGAwX4ugBQU1yDVwO+ZoSZA42+jTBm6llbr98IZugksi4P1iXs/N2m1twt+DQNSMgqQkVX13oe1dGOlp9N3bWsiHGtvbpjEuzmlV89sckpx1hlLJk1y6WZin1KfYqZmjbvBeaXyP4f1JCF8MbN+hlYMjhQwjMWyAtKOA+AnMbZM1BAhTdlQqQcYgfM+04mMjGMR+ikraHxmOtDeeo13bMvKBomuicq/xsjjEpDgZQq/MFP10oNJnjG4Z27wVjsSivXHKkM3TV5+2ohJ2ZHketCpbXLrVMhR2ljYz0ETwIC1LbJSB/e0aVAloGUTPmz0cHDkyDJ7G7sjerXvoBMdA/Y2hLkBgNxjXlmts+S9x7CWdKStw9yWHzMAK9NTWy/6Zj4EGauPZ9x60zahRSVacuAIpMlSLZbg+fSKEgTkkCJVsyHobwI6iRt5KGXnyf31gNqWr+N2ijh03CDmiCgjwOQ+hMy/sXF+jL/e3n7C7uhGepMiR9jA7gI7dUszhviq1/EnhpSvVFQNKE9DUSi/7AJDHPyE6c4s6qbZtG46b/SpzJztVGj+QMfdcMVeZrIh9ZMsDyPfGfcauCM5ZZ2FUYe9STUkN1q4sLtTRgArFcDOoqD4mWwGqrInr0MVKwJEkhiClxLlyng==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6163.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(39860400002)(346002)(376002)(366004)(136003)(4326008)(8936002)(66476007)(8676002)(86362001)(1076003)(6666004)(6506007)(66556008)(6512007)(66946007)(107886003)(186003)(6916009)(83380400001)(2616005)(5660300002)(36756003)(41300700001)(38100700002)(26005)(316002)(6486002)(478600001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?26Vb8ZxZX9aiHfcT6l7nEOPTQJjnj6SI4H5xC+lykMlElym6z2bhn3DOERI3?=
 =?us-ascii?Q?z2z2+RX400qJ1/sdkVHBrFLXYYrtlKKfW3yV6Qor2YKvoR2IbSXznveEkwF0?=
 =?us-ascii?Q?nwkpUMqo4fL5O1LtvA7/Dyq7+vmllmqEwI4RAGiyjbDsYTtXZ+c8jfvgP6ao?=
 =?us-ascii?Q?hWpe5Om3xOpBalbZ6SEV96sCRC03cstSiTzOjzEWNi0QKG+08PaGi1HRgf2p?=
 =?us-ascii?Q?i6eM/nKXkeu+Lth4F2RlDlVXf4n8SWwmZfrgE3j58xjUVSlmshqPvjajZ91A?=
 =?us-ascii?Q?Hvx+3Emeoeq9Rhn2uhrmDOGqmaTYUKhPKl9yb+LAeNNXsmM+2KTfmJaxj7lc?=
 =?us-ascii?Q?B/krhVA6SqwSzZyXDndX5dXkRBQvjb/n1HZS94C/L8gw4MfZxeJmQlhCaXam?=
 =?us-ascii?Q?u2Tx0Nfe7yFq44SKec7DnlfDfFdBfgqDkJffW/LOOBIT7cMC/K7HRdcRjI+Z?=
 =?us-ascii?Q?XeYw+1kv5VMxul2JPNj8aKks2x/To4bEA4T3qS9bUKQaO616M4fpyyx0FR8p?=
 =?us-ascii?Q?W/gz/cAxSxZS/QvNnR+H1Alp7D7ZNpUg+NzavCpP7IJ6QkT+vL69v1ww6iTm?=
 =?us-ascii?Q?Wka9G5h4Ui4XHrttOO+89+ogF6R8lh1ySFh87EVYpKVAztLr2Tgx2VsDrhXa?=
 =?us-ascii?Q?cNsYYwtnY5zGU6KHvYxcZJ9lCQfJTARBp/u4d0Ig4rZzvTqRRtVL9ZPO4KUk?=
 =?us-ascii?Q?gYfvTyuPv3f7ByKqB3qXHml4RZpp4LBIexlhU7ZN6772FbZyT2iSHLXhHe0O?=
 =?us-ascii?Q?nAVbinU+pfURLw+13wGeU6WniHm1utGAoxAyaQC5V6gBJkdfbWrmGRxXBuHj?=
 =?us-ascii?Q?5lOS/An4vjs0P21YVStgrDioAr8fPJqS7S+CKhQY0qstspyApXOLndHhPzDp?=
 =?us-ascii?Q?K28tErIxeNtplcCPwznE98W/Cf2VSwTtBZdPwKSznizl7IKIQmtvUVKB21dQ?=
 =?us-ascii?Q?CUtT774LcCDejXK0HJK/9mrpEXrBLLiuOza20yzAG9NvNS5YCvzc3Jg0/KNe?=
 =?us-ascii?Q?eIbwAr2LIkrNaywJBWop71bdscha7GXPSaihvOddw9x9a/AWR6Q9Tu23Fxdw?=
 =?us-ascii?Q?J8hpF3Gx9zgS6QQNPts7oiLJkJezSkTsfyb1hOnkG806Sw7qnach1pn8AvoB?=
 =?us-ascii?Q?q9a8CL7FaRd5dO2CUfmWE0SHC2L4TB7IIYwFRv4HCZ8616u6ZzBBT3K/l1QM?=
 =?us-ascii?Q?gMRmsZAuVRrzV0G5JpOmJPKTjkMZtPem/RlTAhUijrMb5Pt1O+fEWzj0K3lH?=
 =?us-ascii?Q?VxgxOSqILJs9oePTzF0+GCYLDXb4a9t87atgQkejWAVjDuFIMXMrfPuWvz5u?=
 =?us-ascii?Q?TNWoEcEWblt++dm6sczkcuGA6/L3ailEUYv7H6vknEPGZ6jHqthgfqmFYSvi?=
 =?us-ascii?Q?ZPgWJvt/jBYaSDsbteHM0JgsmdQztEAbC1V0kG99UTvm7Z3DCieiF5owcQz/?=
 =?us-ascii?Q?FUl0XhPh/aEZ7fqjAfRWgHRWgbFFu8lyvAaGwZFHPTuUcGX3gNaDgWIBqJRU?=
 =?us-ascii?Q?Q/ESYPm+BqovTmLnIwq9m/xHEFYg9EXp1GggL58lrRacMO4plpl0xBrdDJ16?=
 =?us-ascii?Q?U0zBBXBLDz/E1tR7o/NCufsHvrE2Zp5Wk4jTLxXPgoWUCrR4q7sNMUc436iV?=
 =?us-ascii?Q?SSudLtdaUMKUNs2Ds5IH8BHoP3TmcdN3L2/VrHg5Calm99wJwXfPNTFZtZMx?=
 =?us-ascii?Q?FaIW1RTar2yim9uyundl9GJsEZDjuD6ooIWkB6ZNpdUOv9m81Y+ka7zBXc18?=
 =?us-ascii?Q?joZvjklKYw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0510eb36-5ba0-40df-c7e6-08da54e8bf81
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6163.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2022 07:19:45.0331
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3Sekff5FlrSqeiP4MT/oGuDmnpyjHgJmXPGvACjfCAqbvfbK4oJ4B3J1ADJ4bBaZ1+tzz3ysFvC8E16/TvFuoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2518
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

The function configures {Port, VID}->FID classification entries using
the SVFA register. In the unified bridge model such entries will need to
be programmed with an ingress RIF parameter, which is a FID attribute.

As a preparation for this change, pass the FID structure itself to the
function.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_fid.c    | 25 ++++++++-----------
 1 file changed, 10 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
index e356b4d2193d..27bd55efa94c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
@@ -442,12 +442,13 @@ static int mlxsw_sp_fid_edit_op(const struct mlxsw_sp_fid *fid)
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(sfmr), sfmr_pl);
 }
 
-static int __mlxsw_sp_fid_port_vid_map(struct mlxsw_sp *mlxsw_sp, u16 fid_index,
+static int __mlxsw_sp_fid_port_vid_map(const struct mlxsw_sp_fid *fid,
 				       u16 local_port, u16 vid, bool valid)
 {
+	struct mlxsw_sp *mlxsw_sp = fid->fid_family->mlxsw_sp;
 	char svfa_pl[MLXSW_REG_SVFA_LEN];
 
-	mlxsw_reg_svfa_port_vid_pack(svfa_pl, local_port, valid, fid_index,
+	mlxsw_reg_svfa_port_vid_pack(svfa_pl, local_port, valid, fid->fid_index,
 				     vid);
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(svfa), svfa_pl);
 }
@@ -508,7 +509,6 @@ static u16 mlxsw_sp_fid_8021d_flood_index(const struct mlxsw_sp_fid *fid)
 
 static int mlxsw_sp_port_vp_mode_trans(struct mlxsw_sp_port *mlxsw_sp_port)
 {
-	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
 	struct mlxsw_sp_port_vlan *mlxsw_sp_port_vlan;
 	int err;
 
@@ -520,7 +520,7 @@ static int mlxsw_sp_port_vp_mode_trans(struct mlxsw_sp_port *mlxsw_sp_port)
 		if (!fid)
 			continue;
 
-		err = __mlxsw_sp_fid_port_vid_map(mlxsw_sp, fid->fid_index,
+		err = __mlxsw_sp_fid_port_vid_map(fid,
 						  mlxsw_sp_port->local_port,
 						  vid, true);
 		if (err)
@@ -543,8 +543,7 @@ static int mlxsw_sp_port_vp_mode_trans(struct mlxsw_sp_port *mlxsw_sp_port)
 		if (!fid)
 			continue;
 
-		__mlxsw_sp_fid_port_vid_map(mlxsw_sp, fid->fid_index,
-					    mlxsw_sp_port->local_port, vid,
+		__mlxsw_sp_fid_port_vid_map(fid, mlxsw_sp_port->local_port, vid,
 					    false);
 	}
 	return err;
@@ -552,7 +551,6 @@ static int mlxsw_sp_port_vp_mode_trans(struct mlxsw_sp_port *mlxsw_sp_port)
 
 static void mlxsw_sp_port_vlan_mode_trans(struct mlxsw_sp_port *mlxsw_sp_port)
 {
-	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
 	struct mlxsw_sp_port_vlan *mlxsw_sp_port_vlan;
 
 	mlxsw_sp_port_vp_mode_set(mlxsw_sp_port, false);
@@ -565,8 +563,7 @@ static void mlxsw_sp_port_vlan_mode_trans(struct mlxsw_sp_port *mlxsw_sp_port)
 		if (!fid)
 			continue;
 
-		__mlxsw_sp_fid_port_vid_map(mlxsw_sp, fid->fid_index,
-					    mlxsw_sp_port->local_port, vid,
+		__mlxsw_sp_fid_port_vid_map(fid, mlxsw_sp_port->local_port, vid,
 					    false);
 	}
 }
@@ -617,8 +614,8 @@ static int mlxsw_sp_fid_8021d_port_vid_map(struct mlxsw_sp_fid *fid,
 	u16 local_port = mlxsw_sp_port->local_port;
 	int err;
 
-	err = __mlxsw_sp_fid_port_vid_map(mlxsw_sp, fid->fid_index,
-					  mlxsw_sp_port->local_port, vid, true);
+	err = __mlxsw_sp_fid_port_vid_map(fid, mlxsw_sp_port->local_port, vid,
+					  true);
 	if (err)
 		return err;
 
@@ -639,8 +636,7 @@ static int mlxsw_sp_fid_8021d_port_vid_map(struct mlxsw_sp_fid *fid,
 	mlxsw_sp->fid_core->port_fid_mappings[local_port]--;
 	mlxsw_sp_fid_port_vid_list_del(fid, mlxsw_sp_port->local_port, vid);
 err_port_vid_list_add:
-	__mlxsw_sp_fid_port_vid_map(mlxsw_sp, fid->fid_index,
-				    mlxsw_sp_port->local_port, vid, false);
+	__mlxsw_sp_fid_port_vid_map(fid, mlxsw_sp_port->local_port, vid, false);
 	return err;
 }
 
@@ -655,8 +651,7 @@ mlxsw_sp_fid_8021d_port_vid_unmap(struct mlxsw_sp_fid *fid,
 		mlxsw_sp_port_vlan_mode_trans(mlxsw_sp_port);
 	mlxsw_sp->fid_core->port_fid_mappings[local_port]--;
 	mlxsw_sp_fid_port_vid_list_del(fid, mlxsw_sp_port->local_port, vid);
-	__mlxsw_sp_fid_port_vid_map(mlxsw_sp, fid->fid_index,
-				    mlxsw_sp_port->local_port, vid, false);
+	__mlxsw_sp_fid_port_vid_map(fid, mlxsw_sp_port->local_port, vid, false);
 }
 
 static int mlxsw_sp_fid_8021d_vni_set(struct mlxsw_sp_fid *fid)
-- 
2.36.1

