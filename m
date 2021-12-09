Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8220B46E58C
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 10:28:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236224AbhLIJcM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 04:32:12 -0500
Received: from mail-bn8nam08on2090.outbound.protection.outlook.com ([40.107.100.90]:64096
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236165AbhLIJcL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 04:32:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CIMsO0SZ7deBctN/IPPFXVL+gjBPLeHIoakXVmbDqilEP8tEAtDPm2suc7qWUrKhpUsrrXB5Gt4HRP8W1KqiY3PbXIzvvC50BnJR6r5Cp7me/V7cRbFPIBXsgqin0utAUoNdooQjPGYNyqRb5YraFZJaydqoVhgC6DQoXHpoPS/93dkxMD4xcHTrKOn2qj+9P5Hehpiiu7ElYFwqkZ0+rHOoeG1BRUriheiTdKP1Us6pIqklzEN91fMueFfSpyHNLjaZ7eQOB9hewnZyptlhPir1pXS5g8yD6QktG6vL/GjlVPj1ERiYyvnRqhQvx1xetqRC7FiN1xS/DTPX5myVQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p8LLQp3zHRSWSnacjGf5qSBjctEdinbafUimocvkGnM=;
 b=IERfHUtTMUOqVM/vhZMfcKJD0mrp7u/Snst+BXioSqvfEGU9wkqDNGi2TQVHbXdQlAXFxxIDIVcLvybkiTTvg7lkTMZnqJhR0iUaqRgh0hsnuSGbmmnfhzJBsHzHal+HFwRKnjPoYI2hQ8XnDBKTzIH5TQkP3S9bEPVYUk2a9GafuBEL781MpS/UYMxtdx5Za/aBTSAGSTHLJmVg40WzW1NnW7Dq2vzz4DWyuLL0BzcEwzAVX7QA46e0QCUOVifqUsJgs3AnBXllaVr5Rz8w12UJxAdo3Uvaj6E4IzTb4yebQjvKR6B4e1H/QcomIutzFo4DkodTH5J9mjYHtH9BnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p8LLQp3zHRSWSnacjGf5qSBjctEdinbafUimocvkGnM=;
 b=LTy6aQy1mnJlC/2rfnF1f5PpEY0nGyCQjzFEkDiJTyvkPmOMN3EZgPkbhwbN5VjUmw82V80qyCPqXymBbc6INTlyiWTcY/yJQIK2VsBfsDJBMaZTiJpLV3C2z8kOYB9JniudnIds7+9EmtPPqBChtxM9MCbQRRv8p+zOU2Rno1E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5494.namprd13.prod.outlook.com (2603:10b6:510:128::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.10; Thu, 9 Dec
 2021 09:28:31 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c%9]) with mapi id 15.20.4778.012; Thu, 9 Dec 2021
 09:28:31 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers@corigine.com, Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v6 net-next 02/12] flow_offload: reject to offload tc actions in offload drivers
Date:   Thu,  9 Dec 2021 10:27:56 +0100
Message-Id: <20211209092806.12336-3-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211209092806.12336-1-simon.horman@corigine.com>
References: <20211209092806.12336-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR03CA0068.eurprd03.prod.outlook.com
 (2603:10a6:207:5::26) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ad29b60c-0328-4da4-8c15-08d9baf6439f
X-MS-TrafficTypeDiagnostic: PH0PR13MB5494:EE_
X-Microsoft-Antispam-PRVS: <PH0PR13MB5494473AD544087AF1A7F820E8709@PH0PR13MB5494.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ySDxlbgUKWU60mr3p3XQczGSwuOjTRhQX8kX6lQtDOylj4SX5+AjrihBKnTMYJpkS98yPqzSc+P1hxtcDs4LNOMFvRFaoYiVVA5q+2mVUOKR6D+nx4jXRNgfsKSLH/jnNbCeJVAfn2OFXyfSTSTKNqiAY9BlnLzVijpVj88cpCXhHsiYdr0Wl9b3dbtyzsqzJthfEiG4mquM8tTO3owyNBiTb39N1NBwkA1jzem2sDVM7fiwfpMljs9z0m1Bo9/vur6S/uuq92Ere3y9ODa4BbIxM6aAGIp8e9L0LVsEv4bqSnjYILlssaaa0qwHysilwNXjUox/UIsqcIlmEb3TJ35gP3Of4MZc41lB0aMJaY4pe1p8pEkgotkYzsoPdJUWsDqtfa2XSmXXuEeCyAMznR3LBcZKncekclwKyTjhrFYABnIl93HFEVUcUAHObJGc+BtMIVUSxX9VaXL6trBeK8Ba1eA8KA97etR2RLSNlzo6KSbEqe4VDdJFiG9juraf5dLKqWT+gC562q+erz/SNHKKL97S6oylPk+DiZ+YA9L7Fzh4DNTU2frvWdC7Vei76fTlxThq2RGr8Pp1C286DqauNR4bP4nyeAeGff1NOMs9ajQ1QCgUq0Qydtlpo+DAj+ug/Utg3a975tHkimLK8Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(39840400004)(396003)(346002)(136003)(376002)(366004)(6666004)(6512007)(44832011)(38100700002)(6916009)(66556008)(86362001)(52116002)(316002)(1076003)(6506007)(8936002)(8676002)(4326008)(36756003)(2906002)(6486002)(5660300002)(186003)(66476007)(2616005)(83380400001)(508600001)(54906003)(66946007)(107886003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?e8MAw2jW0AWtiMSVRVCd6094ik1RE45cTF3oCAV1/HYjQzcJG4yUNfmR6yUA?=
 =?us-ascii?Q?fp514IiJCMBIz6hhQJAcec5QrmWSCo/egglOnK7dYj2a5l1oHC5EOA58cUhT?=
 =?us-ascii?Q?pGamPX+dvnJlfW/rvHaisXMkp9wOKcVTf6CCZ3E7qfLTq2o6q+ASHA7oABRM?=
 =?us-ascii?Q?ZS3yHhByEkrOSltzxLg5pbU/vKbE3HoWLTQlpH651PXsUSbJXWuzOzWgd3MF?=
 =?us-ascii?Q?/BntDqRTwpk9OwNBL/glTCGr2TDNA2pXUnPbX7reVgqtJx2i1ZQkOdCj/J3H?=
 =?us-ascii?Q?DCd+2x6fx9ZyWq/7xx8WY85dI4vN+rTUM82R9z8CoXwLGWPFog6FR4j6GqJw?=
 =?us-ascii?Q?SRRnh0DB5WcYaSzJyz6XNqEHH3ctHqwmzBZLq6/0BJDoOSj1QPHwl0vkLJGB?=
 =?us-ascii?Q?dUXvS2xJwMdyZr6HzGnuF81V7ZkFOAg8ltRl5I7T6Y99UgDgZw4rzqVsJ6+S?=
 =?us-ascii?Q?5DGCEsNlhR4Ocq0htcRMRNvyH2waU1TLq+FC1gXONt0FGMcf9ii7W9PR50QZ?=
 =?us-ascii?Q?0Fmld/vd4Aq4ee892np9lwAr012nJ+vctjhD1TWF56f8Vvbg/OUVCMjSfio9?=
 =?us-ascii?Q?HqTE9EmXyJZMje5d/8nUa/vIBa2nSK2o1WoKvopHUtqmaP8gzV6FuLUv+S8W?=
 =?us-ascii?Q?nrUJ87UFHJ9Kx1EvzIxWUexNPHbK6nCI5gw3C6JSlzMkhZC89KO8DeHzL+Vg?=
 =?us-ascii?Q?cLWtnHmV36JxVEDxadSjcc9YWsfCFe92RG679sAQ0DMoQZxZeLE/z9u+rPOd?=
 =?us-ascii?Q?Jy8XDzN6rXUrIhKQYvqZKcCrc075WVdTnGXeHgt6s9KXV/UeQ6qdP0IGWUN5?=
 =?us-ascii?Q?lSTtdEfen5HjoOSybX1B8FmqghzDeXqUtsXHt3UZu6VgWfYZO43UJEVnWvH2?=
 =?us-ascii?Q?Xo2HRRvc6VHufY6KzGRkQu27SZtaQgvsX5ssBGvJCJ6UfjdDODFL4J+3uLSR?=
 =?us-ascii?Q?+yoD6zw5d70So5ujFWTQSN930x6Dx81n2QCoYEPMzocMAuvKiR7y1m+Pk/Gl?=
 =?us-ascii?Q?F+mxyqPph/aG0oLbc4Heulw8eY0ZT43tm7yjWnDXtwPkMCk4tQ05yIvO3GMU?=
 =?us-ascii?Q?k1R4A6Skqb4zZbJBxK5gIqz8LoREU83skF1qr6FDMrABqCC0NTcKVy3JrrA/?=
 =?us-ascii?Q?+UH7ITKXBRYFsq/vROfcuZDLhrVQXMoGP24ZtkYyG4+CxuVHw2WfO6xF5iLO?=
 =?us-ascii?Q?w//yJTRHnCrFeER9i1G8k73u8eet53WnqwhvKloplhNkQz+PwioJsqON6xf8?=
 =?us-ascii?Q?BWHbZtzdI2Qq8IRs5NxroWyWy9N7SO3H4rXPveLVz8nzlu8QMgkKDhmPMM42?=
 =?us-ascii?Q?sf6j95V+t3fZoa+I3z8VSbXccdXZUcT+ZW19XeQ2sTTzf6o/2JZyrWUszQV8?=
 =?us-ascii?Q?bhW3jvbJ+bBQ6209nqfevn5tblKw0wzuvKIdMjlcKKilNXpCWEqnNawrYcYL?=
 =?us-ascii?Q?iqmXHxdcdsBSWTPvpq1z8a+1/X7xWm2U8IENgZ5c6glK5adPRCcWWG72lRZW?=
 =?us-ascii?Q?iNo87ItERqNkST0DKnZIWx9QEAhZhXI7/3Q46tb4+euDj1cYJGDsp0NkLZ4b?=
 =?us-ascii?Q?KGWZAagASIZGPNnUnzkrxtPIumFKPk8hp384kSc8rnZmv+wb+QN9nyTb5UIq?=
 =?us-ascii?Q?BHLX0XwODEJYT6e+Hr4lKYSBGDVvdfEwcMkkeuZtIzi5qRtss8nuJoeh49O5?=
 =?us-ascii?Q?nUIvjM2T2w3wTV3ETg50BH9+cgQAYDRbHgbGMUeY2oIKxGDZ+mJ4Cg4xSfKH?=
 =?us-ascii?Q?2P5KvWBfdu4fCpPeV5MQDxldldF1qQs=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad29b60c-0328-4da4-8c15-08d9baf6439f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2021 09:28:31.0091
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xK6PGBUw7O5Tc3IzkeAJwGFI+3h3oH6DiKccCY5X//nSwM7qiQCekxdKU96qZIJVk/tX+QaxzAUloKJZsJF/Ph+2tBvFc9wylgqsDrrxL/A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5494
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

