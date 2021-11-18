Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 961E0455C50
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 14:08:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230088AbhKRNLZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 08:11:25 -0500
Received: from mail-dm6nam12on2116.outbound.protection.outlook.com ([40.107.243.116]:35937
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229926AbhKRNLX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 08:11:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LrHBN90DRhQMIbmGF6/XeMKcoRYIyyN0ouuFcLtB+9wpH3APEsTnLPv9n8L4aHYhBBZl3lkYfbPLQS5fG0zqOcuuqhktarAvBIwiSkXxpQSDLX4vK8S7EkqymSpS7Fu0uZ7odQkktTwrU4CftYFexfTqR3RM8vrcppakJzCEHJdaoWH6atGVrwye81mllpaXXKCu/LnXoOhehOmX3QJrGqyuu8275lcGj3iGWsXozwEse8Zy/yqWYopuSfMUcDLJ+iyYwAPMtzKoMXsCEuoyFjSQ4AylZfB2piYfbMdCoXPoFKTc1/OeU2hO/alRCapBygr8O1XSOzDZRENZTrtFNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IKgMD78T+BBXTZoPJgrErs2iq9YAMppak90n+eVV24w=;
 b=O7lDa3o9e+PLFTILthreRXB2FXnhZ66zK0qIZTzUplgtLBO6OBkPgwPvvASOMECuB+O92LjefbndktwtPVE1nDHfwEBk53PgRuIWD5d/ehA/HrSPe3/H9trUIW6OrBOgY28Ea73PuIdZjVQ7E+0gKiA6TuzC1f8cxlYII0EZRurDYYfMpzRLn2/H9gMBQHE4FvERgaYIOWRWLHS0ZuHDKeBueJaGv46FwANjipBNbXmqjD3RrMyT4RYsiQPcHHKI3LoTyxYuVUSS0gLKVIOIdw2Y8zoFftMQ4xZFV98zRktc53lG8sYq+YigfuW7/WOziGTSvFrIFG3eLI+y6BGImQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IKgMD78T+BBXTZoPJgrErs2iq9YAMppak90n+eVV24w=;
 b=nDIFBtr5ghBA6SYV+InesC7lZv1IoyaebNo8LZp3TZeRSslI14R/HvGjWrf4uDni5AIoEYNUhwJtJAC5nzoucSJ2K4WzUG8Z2yEtIJafYqKkA/RW97K8H9GSQsJS01jAqNPESu3XOixw7b8zZMYiNf6lwBdcJEbN+QG9+ONQTfA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5422.namprd13.prod.outlook.com (2603:10b6:510:128::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.10; Thu, 18 Nov
 2021 13:08:22 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::3152:9426:f3b1:6fd7]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::3152:9426:f3b1:6fd7%7]) with mapi id 15.20.4713.016; Thu, 18 Nov 2021
 13:08:22 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers@corigine.com
Subject: [PATCH v4 02/10] flow_offload: reject to offload tc actions in offload drivers
Date:   Thu, 18 Nov 2021 14:07:57 +0100
Message-Id: <20211118130805.23897-3-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211118130805.23897-1-simon.horman@corigine.com>
References: <20211118130805.23897-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0202CA0021.eurprd02.prod.outlook.com
 (2603:10a6:200:89::31) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
Received: from madeliefje.horms.nl (2001:982:7ed1:404:a2a4:c5ff:fe4c:9ce9) by AM4PR0202CA0021.eurprd02.prod.outlook.com (2603:10a6:200:89::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend Transport; Thu, 18 Nov 2021 13:08:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 73b484cd-cb25-4906-63a4-08d9aa947f67
X-MS-TrafficTypeDiagnostic: PH0PR13MB5422:
X-Microsoft-Antispam-PRVS: <PH0PR13MB54222CB3106F61733AD8F31AE89B9@PH0PR13MB5422.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dpddt4zat/oFi5KSsK4Fk/1KgkWC2qwjQxMpzgzIrFCYN/0Q7jfwxO03rsoHNKz3zYNU/4n6cYv4oaPz7T6E8BY6rRAlj8GTXZnl10AXuxHl17bRZE6GiR8LXlcbzIxgswztuMYAm9+FCxHqNhhItzSJmkrJfhYKvA8Cqy2cGyOyt7qH9Xnes/Irc7CLzuoemvENnWpf04ayxcW5tLNabdgqxPN77b9GjleiiREew0bkz5oAXsOPGq6+o+czAW/EckCxjixywLzO3rJzDWQp+NoGenVmCRdT+JFDDBotSfFbLnKI22Tc1NXZXVBxrnP4hky1Ujd+ISRn9J7wjAxhymvkCE1mxrDIRee1fQqwV/8tdjxmMUDrAAZnAAFn6xqFhJvng9ne/FC2L93dAmXgpnG6k2h9vza65yxkQIMtYDU5M5zmhwg3ndNAULK/ZhrbZTpVuxCJS+NhVDsbL+yYKswitIeNfIoPSsjwWnr2c/ZqLBs9REmxqn/ZrcYPSkeH8GY0fPPPE//IDc3JbLgGRUfKmx6uNxwya/ZxM7K4kkWRCZMYhzjFUnOFpXrPSaL8PMtzE2+Iyj8eVpkOUdUJs9wI/EgwGLuK07fBOrmvOdLKWPUu9A9YaRIo7BqlkeuUxmwMe3RihxmlFi4967BXhw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(39830400003)(136003)(376002)(346002)(6486002)(2906002)(54906003)(6666004)(316002)(86362001)(52116002)(6506007)(1076003)(38100700002)(186003)(6916009)(107886003)(2616005)(44832011)(5660300002)(4326008)(8676002)(508600001)(66946007)(8936002)(36756003)(83380400001)(6512007)(66556008)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ijqAqwPR+N1l4HDKXDEZgGdecBn8yW5KCMtSZtZbqMYKVC7dsg/gaBCAshpZ?=
 =?us-ascii?Q?sCbYVwNlmPdf09FX0VOKN+npt74Y37BGdtlb22MtGSEcdBXZ5Xv88QVfoKt/?=
 =?us-ascii?Q?S0wRhrDhVhg3woW2ateNRe5qPJSEcArT71ulDcIw5AYjxwrJXjqfPgXnyZOo?=
 =?us-ascii?Q?kNjlzvRGSAlUprlD7KfaUm6C5uvuqW3pzyyRwJ+Q2uWDHvoXZ9Kd7a5nqBMt?=
 =?us-ascii?Q?c+xAEdhsQ+ymUqhWgPr09OsMk1AnY4pdrQYBOEv0766XM3oRGb4S4w9rk4W0?=
 =?us-ascii?Q?HDUwnNcp87VHwjckVm3r46ksnKOWZ+Fu1UlCOUZScjKrpLcxYr8JSf1ntW9q?=
 =?us-ascii?Q?L3Gul5ncq3FSMmyFOVPZgRm+e8JebmJW8mrdjSXHnQqupL7DXa0AbU6XbDL1?=
 =?us-ascii?Q?uXQ2BPb/j9f7e7OV9c2+3c0VKsJDEM/VCQIe2WTSHF3mfCM5u61wJaafm0kK?=
 =?us-ascii?Q?HugDyvvrV2MzoIoG2U70jmj1lSSLp3fEiBT8CqxLJedSxVq8WzQsIvfOfVtG?=
 =?us-ascii?Q?0mhTW9+t+AJ6WzQhzZIJeS4W+stpcTWYqfFJkJtnPoFNoftOw2KdduOMpnXL?=
 =?us-ascii?Q?tAZz3x/hkopw2AA7PAfNvvy2LSEXpndigz0+Niale9nsBLgXO6PBbsXwdUum?=
 =?us-ascii?Q?GZdfOyymmHBSr/bqZ2avIY4LCYhicZiFbNPiGSz8hhmLXQTc5LiEphyr+uMT?=
 =?us-ascii?Q?xZE87TiUSySkGg2XhZgC6LDBOcSRJBbG0i2cFY22MZVBGAtHHyikIH5rH2HZ?=
 =?us-ascii?Q?7DjqqQTzQkGfijwR/vehfHEksedqrm4Sw6VLWoO7jsg0uDOGC5Xzmgotry9l?=
 =?us-ascii?Q?BYZcZxInbvCOW7WG0urjGFjLYaEEgcnpdtxFXJaKNGpgrbQxt/bINEXjPSyJ?=
 =?us-ascii?Q?pz/JrcPdWfcFoPOsoKgnw8CRSxbH2m9vj5jhAwIdQGnSelKkKHYVhzBvRGEq?=
 =?us-ascii?Q?WwPq7cDJ+j9LY/r4LADJSVKaUpsY6LBHwzuFcHIB5H+JGyqIuBhXbheqteLG?=
 =?us-ascii?Q?PTxPqmG+6XWml4W8R/f2vRlKKfCkN4uXYgA6QJHAdZYxDWtWfgcLKWtJHGD+?=
 =?us-ascii?Q?XC+3D5K0wpw9e732jjFj88C9iZztD6IpeLB49pIYnLoxdiDq/JRnmpxU2Sck?=
 =?us-ascii?Q?qOT6ONqPrh+4Sjxg/ulL0C2FiWwZhDf6NlSWwOeHk3CIqi9cgAUEFjcZr55d?=
 =?us-ascii?Q?dBEmfLnK5Ldz7biCWxnaXkHckiTGOIL8exrCHNrcwZsITCC9qGwhuPyGgAok?=
 =?us-ascii?Q?O+9I7MwWpHIZD4SnSmwCsrC+iYN8xvPWioGtsFgI+iXTw9tMzv4eSIkveqqW?=
 =?us-ascii?Q?wGUqSlTbrzib8gMS+OHs/Z9VZUb8SUnhmksxM5WKf+0mBwa/1m6yo+6v6keW?=
 =?us-ascii?Q?zeKylx3J0bxArs3C7oW4ZF7oZZ1mkyBg8t+EBEDtCVT4LlLnIaTypPNCZyiO?=
 =?us-ascii?Q?fZEBnJLwImnQejMST/c4kFM2oKGBKF5/WaE5mVz3jBraCf3TXJP6ASJufqNV?=
 =?us-ascii?Q?osOu0jV/ojoncuxngPwrL3KuWw97vEsBvQZ10MW+qgXzd9r9ImLuQecq2tkk?=
 =?us-ascii?Q?xokCH3X4CsUmm2zKmTqgpJUj7RBwu78MWBEvBFVsNHzQRPkfJQku1QMRgzff?=
 =?us-ascii?Q?YzH0UXn9m0y8yVdWLs9Oynzlvbg2WmFDXfwMDXvGTPD8xsNXkNHXPMQfdrlR?=
 =?us-ascii?Q?L7PNEpTfXpzfAqVBkp5S2ZAt4FTxL+2Cspa1qtmQwREoKQK9We4djNbyuz9X?=
 =?us-ascii?Q?JkmCMfNc/R1Pr9ntPG5JE1MtuUpqZbE=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73b484cd-cb25-4906-63a4-08d9aa947f67
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2021 13:08:22.1468
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h7sYyinFqjNFzAgAphzYjTHdMV9v3BjGf0FUmYrCmIJUWcJooRcVUDOcpGczENdmYp9/FGgd/eymVnfgGjWw0e5PevkTe49I5a4zT/btsrU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5422
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baowen Zheng <baowen.zheng@corigine.com>

A follow-up patch will allow users to offload tc actions independent of
classifier in the software datapath.

In preparation for this, teach all drivers that support offload of the flow
tables to reject such configuration as currently none of them support it.

Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c        | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c | 3 +++
 drivers/net/ethernet/netronome/nfp/flower/offload.c | 3 +++
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
index e6a4a768b10b..8c9bab932478 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
@@ -1962,7 +1962,7 @@ static int bnxt_tc_setup_indr_cb(struct net_device *netdev, struct Qdisc *sch, v
 				 void *data,
 				 void (*cleanup)(struct flow_block_cb *block_cb))
 {
-	if (!bnxt_is_netdev_indr_offload(netdev))
+	if (!netdev || !bnxt_is_netdev_indr_offload(netdev))
 		return -EOPNOTSUPP;
 
 	switch (type) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
index fcb0892c08a9..0991345c4ae5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
@@ -517,6 +517,9 @@ int mlx5e_rep_indr_setup_cb(struct net_device *netdev, struct Qdisc *sch, void *
 			    void *data,
 			    void (*cleanup)(struct flow_block_cb *block_cb))
 {
+	if (!netdev)
+		return -EOPNOTSUPP;
+
 	switch (type) {
 	case TC_SETUP_BLOCK:
 		return mlx5e_rep_indr_setup_block(netdev, sch, cb_priv, type_data,
diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index 224089d04d98..f97eff5afd12 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -1867,6 +1867,9 @@ nfp_flower_indr_setup_tc_cb(struct net_device *netdev, struct Qdisc *sch, void *
 			    void *data,
 			    void (*cleanup)(struct flow_block_cb *block_cb))
 {
+	if (!netdev)
+		return -EOPNOTSUPP;
+
 	if (!nfp_fl_is_netdev_to_offload(netdev))
 		return -EOPNOTSUPP;
 
-- 
2.20.1

