Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 428C8517CB2
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 06:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231316AbiECErZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 00:47:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231296AbiECErK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 00:47:10 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2084.outbound.protection.outlook.com [40.107.212.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 283473E5D0
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 21:43:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FgFy7wixjRiL0tVoFGSy5Bkrkx3HghT49JFVeSCZy4VdAOwj/3FczPueuwSrGzR5sINi2lInw21wEP1CmL7Nzqw7MPOUzirnus1KPbQ/Dfm33xTw38B+qYzCCfoUTGw+XFUcG8Xy0yawkOFntWKbgz0V/pZG8UnDf8I8n73OmfvwtpTG9KyNo03GUZASgxWOHlvou5Gs1cvE91za+oYByUuAzYwgNkkgW9VlXsLOWjgyTx4evucbUtN8SLRaCjcna9Pl0n6NHf1H8Yq2B0U+gyXICrA4TrLuAEm+HTp/05OX7OdC1iGOdL698pOZVva3NQIYB6qT7TWnfUzpTCcltg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Uxsz0lpNoRlVNlP8jEHGilrSkD5m5InFz3HtKnJ4L88=;
 b=as9k52+kfYI1pqSl8KChrs9VSeya9NoLePksQTbV3IQ2tQYckkftllVq+tVTyT9TyM87jJ3B3ormikvR9MNLHJNI/P04gOqv6rpQfI4FTcxQEcusYvLq4oY2l+wJFaGfRvp9sOFb09wjgtUxYb0T3WPMaNulwR1N+A6wh3sxEdeoSRMYhDE1Y+QhgCbwhtGyXBGrPE0AgeapThiMnNcPT7bhycxVaXuRnjQ6mHdY2PNmpnGMujqfcnIaBUPhK8u5XhR6cHanEcN/sukBJ7JouTt3uU7V6cZMLhBVhu6jhpAAL/T6yjexdDHkNwPH7ud/ybOFMmFWz+ujCnFc49EUdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uxsz0lpNoRlVNlP8jEHGilrSkD5m5InFz3HtKnJ4L88=;
 b=Siqv1Eb/qppRlCvGNtMVppzpIlhK2B4a8WF7jZ5rD838McHSGMtuKGWce2mSuffT7MliREVHDiUFY4VaB7cFytX6YlKNQp1m9MQk+DRjVn+W16EhmLEYga9wG49r3BqAFSP+r5W3CoQzAxyzXSFez4Dr1V5ZkceqgrcSrDNFSN9HpQfrBEWysBeFj0GZ/yXAW7/Dv/ZZXTTzz6e1XNU1OvPtuujZxLpgUciNjYBUt71YRg1PMzzTfxUqp0LChBR2TBBQqCkky0xvLynusAgYAvHoUtd641VS70oZUTSNYDtlKJPR02Jqqx8TV7jdFacbbGfS7IOXmGcyANS9yFXQnQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Tue, 3 May
 2022 04:43:35 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca%4]) with mapi id 15.20.5206.024; Tue, 3 May 2022
 04:43:35 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 14/15] net/mlx5: fs, call the deletion function of the node
Date:   Mon,  2 May 2022 21:42:08 -0700
Message-Id: <20220503044209.622171-15-saeedm@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220503044209.622171-1-saeedm@nvidia.com>
References: <20220503044209.622171-1-saeedm@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0004.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::14) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bb9b0ed9-2103-4092-c491-08da2cbf7b9e
X-MS-TrafficTypeDiagnostic: BY5PR12MB4322:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB43227C002B340F154F39ECBEB3C09@BY5PR12MB4322.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Gwp2tuVe81kd4wd6wY4laR4o+Zf6nMSDL0bdS9UjbsSwpMVzM9trniK7GSYuT3SnVy7Is0vnnp7J1xrZNW4OKsftpebds4YV0X2WVblGaBmcFKWPe776NFQqBnwqwx8g8CQxk9BvVWuElGwaYSSpMsaq/Njs4Eb3oUZU5dz0rWISObMXSoHnksFoYLQjsg3COCiQjQnGjzHS3fTehZZfRPhspg8/UqF1bS6Zx0XuYqLAngO9ibaQmRNwgxKMTwcYFeB63pv+9IBQrhAfk9zyyS3TMc+SEtbiAxDuhKXkPw3hHWHKnNI1Wx17B2WA9y7lmQbRgNGbdhLLJAlv43IYCsJzBgmo6xo3LYHTVhq84Tt3xpy9ZGLfEH0Z9u9rvUxmlbsQn16q9WfCfmf5Cw3gFT9BKJPMPeXjd3w5sAkY7Z242YeEvzgthlBNMBew3ynAObuVfwghAWmw5HtYNbtk4Zbyq7aeOkMBXn5Y1/cuv+oesHuYASc1ko7Tmt1FVqyzjp1mbcTegr0qaNMWJHKIi35Hb7hB2xD1FFUeifLr+XpJxis8fKgdNw5N31bCQMenRlNR10Ydkp4OY2BmZ99qG5InAY8FvWtjXxZh9LyGSCvIh6LA6Srt5oD4kH5VpOWCNhd3iAgDgzUc0kvOXM6KeA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4326008)(66476007)(66556008)(8936002)(6666004)(8676002)(66946007)(83380400001)(6512007)(6486002)(1076003)(2906002)(508600001)(86362001)(2616005)(186003)(36756003)(107886003)(5660300002)(316002)(6506007)(38100700002)(110136005)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YDlogEzUr4C/a6VCl3oDEzK2xPTb21YUJxrpczdbBfoouAcqwCH3mDtgAhxz?=
 =?us-ascii?Q?rt13Qtg37gQlzqufqV/QFPd05vDZOHtX3voFtVvCbpeHG55hjAg0Yf0FAuFm?=
 =?us-ascii?Q?BBAXav09WSFhyzP1MHhvJujjZbaJF7fV79lWqGTtAM6K2867XCtVEhyUwScC?=
 =?us-ascii?Q?x0oRptY3VmylLyhZPhXCKitdbFqcvUr2mFF8pXtRewuNBUobE3IV/g0xugh6?=
 =?us-ascii?Q?Q0iZAmF8nafsNQxH1AH6T2k1CahIfL9hO3H6Jte7RlBohkJ/yCroOO+YNu10?=
 =?us-ascii?Q?V4Fq94rliucdPjn9B9w3AE39RUJN1sgE/WW9oS7QzAN48dtaaPuwK80q4TzD?=
 =?us-ascii?Q?OsgSvmiFCtvHepIE+2/zdassHnB26qaSYKOmWm4F2s8kkfj48gFF+6ZZQX8j?=
 =?us-ascii?Q?B3bwkUOKSN3Hy+i7Fa+Y+CyowTT5iHHXSbSA05JjnK59eXYd6Ig1P7tqIlbM?=
 =?us-ascii?Q?Wx4CFpyzmLzuH5JSfqq+LFE/KPbhvyAOwabQpyJdJvcIIeIhU21yWPd13L40?=
 =?us-ascii?Q?NY3CoZxl+xvCpQLdbqKM+LcKaLtVVWUivwCsBV+rSDi25MAwBva7LjyOR/Y2?=
 =?us-ascii?Q?4GQeljRGm/5GJoAa9OGiV6PEfBTddeRzMUjb5hErPMp2uXeH2NnfYLa8kVII?=
 =?us-ascii?Q?WWd8FiBdUxP6LmN07raFiJbDH0Ohz1InkrIRBMD/2Y+7pyfRnJagrpNfr5SH?=
 =?us-ascii?Q?VJTfy/5Iz4XN+DR1GaTroFfHBpDFnDgsGyQRxzjSWVnRiWYpc3Tx/4ROLpmH?=
 =?us-ascii?Q?odXx+fx3deKpHuGFUD7XmNf3hw/8o6gNaBMH4Wtcy1MKRcZMK8D7+Gk6yiPT?=
 =?us-ascii?Q?7ly2MfURJdPwBx6aZmVpKE0qt88GiRLt1YLIiGQWbGp3cby9FtUlbAqwfiGw?=
 =?us-ascii?Q?7o8SXXpwb6JNx2HBVGDwa+3A/CFYZhiWkNXZ+ZDuXRst0UBk77rNcseTJGHf?=
 =?us-ascii?Q?ZN5+zHjyCKHTGVO7K8vd8WOYx4J0N/ktyScgmpW6QpxLc385hpV1Jssl0TYd?=
 =?us-ascii?Q?E31TYmfIv9lkN4wJI4GkER9TdMp7kPlXT5UB3SPMJ8/+R1kyXQeZHMvJz05E?=
 =?us-ascii?Q?v9ofl9aTGI4+8RmAp/db7+Ct3BYp9WpVLV2Fz+kslY6aeRG/S+sNHEwhzc8T?=
 =?us-ascii?Q?L8cQ8M3xn4MfgYCKahsejJKxx/I9WRmMSbFXnNkasj4N7+GFMBCYsO5bA+L6?=
 =?us-ascii?Q?9szzCZ5mjWYvUgzy8C3q+0BKLQsTHiJwFUPJ5m1Uuw/K7JkrzfiYtmY7FXf9?=
 =?us-ascii?Q?A0k5t338hm09sWWrayojVzHIwuexUiEytQd1YA/Nw4hysiLlfIXrZ5FVGeG0?=
 =?us-ascii?Q?paoHRsEQunI5BwWljd96vMuKqBoLLZhiDPEytcwhWMcM4L6hiMIPpVQjyrCZ?=
 =?us-ascii?Q?+CCGcymHyMq4J5W8k7bJNXYDmoqSma2vmcbRxatx9ePdBUEo2APLxKB/aM+D?=
 =?us-ascii?Q?pJQxKy1yNvCnYEMCQPqJ/PNU4l3DxXrLBvfaMbAkvHe6Ng7jhPj/IzUFcuuY?=
 =?us-ascii?Q?wZjxV4c+g0xLSYRu1B078rl09mLbEnBX+ubiU7a7QEvf6/Me4OKHDz204WBn?=
 =?us-ascii?Q?3r7CO+yfjdrUg7y6yS70IK6h7oM+NNFI+2ZHbRkh1zy2Mef5IFiFJyjt/G2b?=
 =?us-ascii?Q?6lthfySnFWX76h4HUIRiLDetz4jtihRq517az7LAwlHyTQhHlNvBimwF7o5I?=
 =?us-ascii?Q?eUkTLzdEqk5tlD6SFvaotO+7/yhQBCwUTrxzg0CHd+EYvfVSspZhSLGEiLhp?=
 =?us-ascii?Q?lXWiJHWTtTMRtOfRU4Y+VlZLaueSJ3qLU+JWyY8V37IKRrG6mi4b?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb9b0ed9-2103-4092-c491-08da2cbf7b9e
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2022 04:43:35.2130
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1YOA9NEy7bh4v3JqGEa9x+F6iFBqzlQcq7MdlEYQ8lYgeUDSgeMx8vUNt98Tbn3TD7nuW0oV23eSqVqS3Tixkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4322
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Bloch <mbloch@nvidia.com>

Don't call del_hw_fte() directly, instead use the hardware deletion
function set. This is just a small cleanup and doesn't change anything
as for an FTE the deletion function is already set to del_hw_fte().

Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 572237f262e0..d512445c7627 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -2085,7 +2085,7 @@ void mlx5_del_flow_rules(struct mlx5_flow_handle *handle)
 	for (i = handle->num_rules - 1; i >= 0; i--)
 		tree_remove_node(&handle->rule[i]->node, true);
 	if (list_empty(&fte->node.children)) {
-		del_hw_fte(&fte->node);
+		fte->node.del_hw_func(&fte->node);
 		/* Avoid double call to del_hw_fte */
 		fte->node.del_hw_func = NULL;
 		up_write_ref_node(&fte->node, false);
-- 
2.35.1

