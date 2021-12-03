Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49143467740
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 13:25:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244220AbhLCM2a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 07:28:30 -0500
Received: from mail-co1nam11on2130.outbound.protection.outlook.com ([40.107.220.130]:65377
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233378AbhLCM2a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Dec 2021 07:28:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j3C1NDmlLFgwdDfClgb1k6bTjfk4khFs7XAgPSJmh/yJE5i/CLcztGq4uoIzmCDytq2YJFDgKN3H64iwdKBELISYRNCxWmZIDMLm1LWCDlDnJMzZrK+MWj8R3JY6hn5rqJ0e1pm+GHGt8p3gaZSRExSdYpYqhUyX7szYOXeVTmh7xjzhK3up7FJd7rkRj+2kcTOph0IS1sMaMT8pPxptxQ7puJv+6MW+6c6nbyn2fuNAWidl6NQn68kCFeZcAAdm0QnU9B7SZz66b2LA3RXYpnr/sCM6EheWzGq/1Pw11ucDZAZuw7FInU6U7VkQpbGdnUt3NU9+u3RgWia7SPsq4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p8LLQp3zHRSWSnacjGf5qSBjctEdinbafUimocvkGnM=;
 b=KWikxh+zCvYfbFi/lsPFmMEfzFau1jYc212yjoB0vLz+X5lN+eRCmJ8XPi9MbRUfQfTKfP4VVwzMjX5j5xKP/sLeSqq4YnVj0MQqWSiroerWagjLbAFMiG2UWRWn7qDLVBYOEiv8JQt55mtM1QJBumma+Gu5mErEkQM7yGQD7+34x76nh46aI/AQTeW2GuaTXgG0N5CwfG1ngLAgwiPGNhQjORd6/ZULT7P9ntE6w2G7LtAex1ajd61Kg84y6OoivayImadk2IkEogS5oHfKQyOSh9/TTLeiCNQgY2PbNCJb5X4CXdgpeuVoalJXRPNLVS95kF9yQl69j3hWfdugpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p8LLQp3zHRSWSnacjGf5qSBjctEdinbafUimocvkGnM=;
 b=rwKVj+RiFgrRxCwt7FF217sRrr5EEIRrtGl9ZwQcu5fOESOqL3njpRgSuSM0o2OB0Ilu5Xjq4O4hgojjj007YSvj1Hvx+R6HQ9EiLOu9jpnii1ifVOYPgRI0u6+dkY2CjzJ2f4TYla3AqjcMzIvlmPhi+bxC+63Kr1ESqkZlxx8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5283.namprd13.prod.outlook.com (2603:10b6:510:f4::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11; Fri, 3 Dec
 2021 12:25:04 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c%9]) with mapi id 15.20.4755.015; Fri, 3 Dec 2021
 12:25:04 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers@corigine.com, Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v5 net-next 02/12] flow_offload: reject to offload tc actions in offload drivers
Date:   Fri,  3 Dec 2021 13:24:34 +0100
Message-Id: <20211203122444.11756-3-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211203122444.11756-1-simon.horman@corigine.com>
References: <20211203122444.11756-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR03CA0059.eurprd03.prod.outlook.com
 (2603:10a6:207:5::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
Received: from madeliefje.horms.nl (2001:982:7ed1:403:201:8eff:fe22:8fea) by AM3PR03CA0059.eurprd03.prod.outlook.com (2603:10a6:207:5::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11 via Frontend Transport; Fri, 3 Dec 2021 12:25:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 657effab-3a54-4886-4292-08d9b657ef7e
X-MS-TrafficTypeDiagnostic: PH0PR13MB5283:EE_
X-Microsoft-Antispam-PRVS: <PH0PR13MB52834B40DD5CDCF808EAD3E4E86A9@PH0PR13MB5283.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7dxzrIE8MOTt7TO+bIBvN7rYmo4Gs/R6wBfbE0mODNlus/g4AG76Rr2/mR9pinK4Fyi5ZL7quY2WFYt/oNp3efbZfaCdL15KpryMNpfwB1pgGDp80yfXzRsgrlln66OiqoXN9vCKOTXdKafYby4Cq2r+iH40lBVlCcXT32lsrjsj2zIRielwpwfN1Y+LYRFiIkjXqH/oUSfwJ9+dgtn4LeORlZhe3WW4xqwyzdNXteaXag41BrLIRJRMeKZTpQvYObcP+LpGgsejwVl4LA43pVmWc/S0UwMzb+97+d3LMMzJiwQYzrdljB6v/19q6F99rDFHFxEIXHtXfLgURW6VCx+zU77dqGxfIRTb+VYa2OJUjXa3oareZxmWB2DPFMwFDWO9o0FvZFE0r3U7SeUvtmhUdr+K1S+3zRG6ilrlNMJ27k+H1EP4fAHbFrt/89ivjKzTf5rhNJfh5UulSBwC/QcUW0motWAeMX9ssjYvFE1QeR4tVVXLzREW3JLPU0gtVK4LkgATq1YmxFGp60kEFm6qkXQrCFEfzspqXXEM12NnAVgpbHzQo1QNPzlgMDK6n3IzQR95HsmtlHRtl6VeQfqeoPEywLzgXRCQlZ43BqkWLVLrcqmlsUkwOZvCwcl2DLydGXzPfaDwSSfUmyA0mQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39830400003)(346002)(376002)(136003)(396003)(86362001)(52116002)(36756003)(44832011)(508600001)(186003)(83380400001)(6666004)(6486002)(66946007)(6916009)(5660300002)(316002)(2616005)(66476007)(8676002)(6506007)(8936002)(107886003)(2906002)(6512007)(54906003)(38100700002)(1076003)(4326008)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RRqFQ9swKtOpDz1EzjqqGHYlHJYrgZNoSjpLjigJyrF9+idlquaMcg/2WlH+?=
 =?us-ascii?Q?SrCZ7u4nk0Msih8r+5TlGFt3kPlNnVbLMRVw6lkvUQWEr+EeLBpMX6Zw6rVI?=
 =?us-ascii?Q?2ope043y6MC+7lW/1xrT2ObvlrpAdijSD5ENBz4vgz6ZZ+/JAbP9bzgYYvL0?=
 =?us-ascii?Q?f7Q3gR2VGw13F6oc40oaoZlZFKb1STozNNMBngHXJrXZSIU3vI17B4FrdHCr?=
 =?us-ascii?Q?gTISm87dKSIckzJjhbKVfYVMC+XAaVTBByxfU78VvEwK5PLyJGWNGOeq4AH/?=
 =?us-ascii?Q?wcpme6Gtt4ionJEJ1r+lo8cLaXUgqoePyvd2nyB5/tK3lm+kl1XXvkQ2Gkg9?=
 =?us-ascii?Q?Hd0BJRtGriLzA60wNLjIWmt11wUYsnqjdzkMsd22doV9IgfK0MqVCY2SspUg?=
 =?us-ascii?Q?6w92R0XLPQwFp7DNiiBOrKJS9KNvDUnZf8TefkDTvPk41+uVEMQ6gzmqwJKm?=
 =?us-ascii?Q?aBv8OR8jcLcu7bUsZWo8oKd62EiJdaEq33uH7+V0S4V8LvnJJetl0EpYL7fI?=
 =?us-ascii?Q?JYRlciHUDZC5cFwhQlUttprDiRpMzF/aJjr/KqgvWwgVD2lzXEZqPrW8B5DQ?=
 =?us-ascii?Q?GNMyl2WyTdXYjEkXdA4z4L08mmUO9mmAdfaQkKLPWXPmVItRhiJOwMIw4Qeq?=
 =?us-ascii?Q?XpX080Y2sgngeF8FSkDoFYhfMpqyu5QEA61Qm+9nsEsL8KmMbL8UOCwDg9SK?=
 =?us-ascii?Q?+dXMecmQ0smB7Kxi0p9LLv0906pXyzp7etvCoIx3xRKGA46dckDHe+tU7TL/?=
 =?us-ascii?Q?8leAbCyG0/dwHPHr2Moaiwo8j2Yi1sjD7vXktbsmWHW69aqoOszzsDhE6syK?=
 =?us-ascii?Q?mJPIU1KoWNFycGKZx1XY6q00YJ0prGComVW/x5v0Z3bQ27lvOZDwah6cIwO8?=
 =?us-ascii?Q?H4gZmvYs5UhNCRnYqvhPvUxsoktZDfqiYdRoLzqt6sBGNDcXLVzxFHvksIxN?=
 =?us-ascii?Q?WBOmYAMAwdReWNvDm6BnzgouHRdhk3eHc6IoVy3irEr0X74JNMWTsiDCWf9D?=
 =?us-ascii?Q?J7u58YigZ5t6ywbWxvbd/nQooS25XyMWaD9+VDLcjxsbK7bDsLisAtG6x9F3?=
 =?us-ascii?Q?L0GokGDtSmlgnri+uWPPfDJzS4JXAbO4Y0Z3JmhsoGf9ggcKAKECAU304uud?=
 =?us-ascii?Q?A/LVUKFEUjgZ6ACPkrnr2d53dYXIpJ9W/DqLH3g3PKEdaUW1oVnJUk1b6r+H?=
 =?us-ascii?Q?E4/IVq3gORvSDpso8bAQ0zXXUPzVJKPq3+xkhT4BJ/xwj3IVEdl0wBIpVgmJ?=
 =?us-ascii?Q?kLjHUXcr71Fe2WWdN8ZXaUEoQRiE4o+S8nhVYP6XuKzMPfgm+dHOoPsR2TRg?=
 =?us-ascii?Q?thFIZCFiJXDSX93zYo+nc2QdgGwupawnsdxEU4UMedohx6/9Q5LXcg4UU+KI?=
 =?us-ascii?Q?3Fwj7T2GHdudEBWcDyWJD/aDHXlVP6kc0vqEyIP7qOMuZ5/I+7sDhGI44qVD?=
 =?us-ascii?Q?t5YqFUBXr1t6n3De642ERuMGcrYWZDxQ6TBVykKRdx+eiibKHgOXiOGPxoMK?=
 =?us-ascii?Q?DUGhBlZe21LIxJUZFIAbbh4g0FseMDyUe6eTHcxNOV8liytxbwF5YASEIgzv?=
 =?us-ascii?Q?RTEVUU6fz32OS7wIiMEUiDa4t1a32znTQ9tY4pNN4kIdSnO2b5LRrDYyUB+v?=
 =?us-ascii?Q?9pNqkt2PbAgln+Q3QG/AOxJBD0PuWlE8Clf7eywcATZAx5AhfazvrcvNMhY+?=
 =?us-ascii?Q?z6Zd+MQb764nGoZoayFGpzsZ3Ugf+30sgX4ws+Evmfq0QJ5bQ8ABmDHsO3uL?=
 =?us-ascii?Q?Q90ZQzWaYw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 657effab-3a54-4886-4292-08d9b657ef7e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2021 12:25:04.7249
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xuOl6amvHDUpWb3ncyXlTMva7zk7M/zblkLmcDNKxG5UkAlqfyVoXPcdPyvRzKhHeZ/bXNES9yQLBlAVYAizEyBhEKEbwq8EhMqPJMZo6sQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5283
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
index 1471b6130a2b..d8afcf8d6b30 100644
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

