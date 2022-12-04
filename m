Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA9A3641D63
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 15:17:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbiLDORO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 09:17:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbiLDORC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 09:17:02 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2066.outbound.protection.outlook.com [40.107.96.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0028A16489
        for <netdev@vger.kernel.org>; Sun,  4 Dec 2022 06:17:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j0wJfWrd3MnQ66gZhdW87Sz2RRnq2xwrg4vQC78uXISK9vtfy3eS3Cvwrh7+iavTeWwuMKWr6Fzz9mWQutpTvszQpdzJF4JQ9tZYBG0w1HYzknFJ9wwg2ubZhrIOUmN0vupWOKlE+8WRd+Dnd7CSwVHsM97+7gHWUBPd9ZSa/wqa/mSNZ9zy3OSXFnKt4hMeTkngbrn5/HdQsrtVDNbRiQWR9kx40lZHMvP7Ez3OWEjxVm3/vsln8L3+s8GTxIED6ATM4IJzeo/s8MmLjwrVGPKbhUND/Aw8QljZMINoTOOOPxHFpAFF9xpuTES/5RoXW4+n9X7CcTg7dOLS1uTLng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LTny/6TSqOFfO8nfwISfiiAAkcHEXJpf2tH80vHe5Fw=;
 b=awAETMcjUzKuaPe4Q07eIX8EtZCos0IkjDJ8maM6zQjqWQ2mXdeaVueHJLGHoXuaeO23mh3ezxjzXFnD/aPKY+RbDtNZhQ9tW+GKKBWis1OVmZl7v1GFTyXxBXxZwZjA+ETmR69vLXnJKrj5kYNyMtGAMcVlTFL9Bs5ibk3g6has4X8y2SEv0gHNLt3VtQ02YOms098CjMOwWM6pSfSeyO9FrBaxq7xk273jpomwpNstjLmNXtVY8tlGuc05Fb+Ijm7AP+35ZOVwt4yfsv8WjNqUhcYH7fIgEDh/Yt96NCaS+7bh5Fhhwhl0EZ8GUfBS/o/zZbf4+SH71Or/2zcQGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LTny/6TSqOFfO8nfwISfiiAAkcHEXJpf2tH80vHe5Fw=;
 b=W9F+iFJWhJeKD/hEoZoclt5+uBw34Ow1+D4kZaBLOES8AkRKoTdVgXtyI5vZkNTmC8sgNpHNpW50VY88DveThqYwDk6K93C1uY6jUfhNdOXyPG/ehTetYlv85hBldtzd4LzsZpaHDb/ls8BL9x1uahGodVKmmbSrinLtkHfGYxZ/Vul4c+7Ilh1HSFkcCremFd/w1Dlxu82ZCwfu3CKkm0ORGyHIVCSTv9d9+SlVV9l1B03wAYX2ba+NmGZKwq8uCQKzy/OmtvozuLxSkkriWQzM9iUaOhO8G061RqQTU6vHJSRy57dYTGBJhiz+uZdvVqE9BKlTBFY5xqyHyK1Kig==
Received: from MW4PR04CA0388.namprd04.prod.outlook.com (2603:10b6:303:81::33)
 by SJ2PR12MB7867.namprd12.prod.outlook.com (2603:10b6:a03:4cd::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.13; Sun, 4 Dec
 2022 14:17:00 +0000
Received: from CO1NAM11FT013.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:81:cafe::77) by MW4PR04CA0388.outlook.office365.com
 (2603:10b6:303:81::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.13 via Frontend
 Transport; Sun, 4 Dec 2022 14:17:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT013.mail.protection.outlook.com (10.13.174.227) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.13 via Frontend Transport; Sun, 4 Dec 2022 14:17:00 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 4 Dec 2022
 06:16:46 -0800
Received: from nps-server-23.mtl.labs.mlnx (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Sun, 4 Dec 2022 06:16:42 -0800
From:   Shay Drory <shayd@nvidia.com>
To:     <netdev@vger.kernel.org>, <kuba@kernel.org>, <davem@davemloft.net>
CC:     <danielj@nvidia.com>, <yishaih@nvidia.com>, <jiri@nvidia.com>,
        <saeedm@nvidia.com>, <parav@nvidia.com>
Subject: [PATCH net-next V3 1/8] net/mlx5: Introduce IFC bits for migratable
Date:   Sun, 4 Dec 2022 16:16:25 +0200
Message-ID: <20221204141632.201932-2-shayd@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221204141632.201932-1-shayd@nvidia.com>
References: <20221204141632.201932-1-shayd@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT013:EE_|SJ2PR12MB7867:EE_
X-MS-Office365-Filtering-Correlation-Id: a73ed285-31d5-42db-47e2-08dad6023597
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qfbzYyLtWEsJlQAQp5ZVJk3tzo8c10bLT3qPSVhLl0WA5Jqucn7C1UfRi4PwMkg46rIqmiqLq6TxfDtpK5GC5BRNxAE+14f7q2qET1DwOXGeWpVs5BrWG/EKQd3loLUHzcY58i7t6kImag5UjXhpquixuk6L483KHVnnQgedjpALDsZMoPBFXSS9lShJoPnRTLFV0UoVmEGPFUmjxq/mKB1DMe/rDG8enRRwbebTCWbFJdikxYHash2V4csyDyOF/L9hO0HHLFeWZ1VX7+P9tk6TrmVgXNYjdGXDHbJU1cjTJi02pLL+gLlslQQFB4lvfTAp65e7L2BSWZOohPiXqOVVa+HZMiycevwmSxSdtLizmx4lVi5isWovAfYrUSbMqO2DQU83dPRPQ23nYxbw4goXySjhr/sVJ/vn8jdFxirpjeVHipbNPVsSA8/WBalzTYicj8M59YocavC0uo4uSY6X+0L/V7y9d+DXlBq+eO1CQSZerYZLgkcvhlJ/uvdt2srtC1fnQIUswB7ElHn1jjz0yQ7/qFkBBTpEtIWLRIY0CEu/qXCDOq7pOA3mLWaZZ1yt2XMwMmHO1dO+L7t03N9YsZONNv8z9LWI6iRa09kpKUN+dhWR87sY7EFAc9c7MykImnTB59p+zoHSrt3G7v+ABN1ZW8JW6IIn1/QFUx85cI7G/g1w/trwgdYFb4WhrvVP5vh6Ah8JKyqhsZzXVg==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(376002)(136003)(39860400002)(451199015)(40470700004)(46966006)(36840700001)(40480700001)(36756003)(40460700003)(86362001)(7636003)(478600001)(26005)(107886003)(5660300002)(4326008)(41300700001)(110136005)(8676002)(6666004)(8936002)(316002)(70206006)(54906003)(2906002)(70586007)(82310400005)(36860700001)(356005)(82740400003)(83380400001)(2616005)(1076003)(16526019)(336012)(186003)(47076005)(426003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2022 14:17:00.2013
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a73ed285-31d5-42db-47e2-08dad6023597
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT013.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7867
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yishai Hadas <yishaih@nvidia.com>

Introduce IFC related capabilities to enable setting VF to be able to
perform live migration. e.g.: to be migratable.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Acked-by: Saeed Mahameed <saeedm@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 5a4e914e2a6f..2093131483c7 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -68,6 +68,7 @@ enum {
 	MLX5_SET_HCA_CAP_OP_MOD_ODP                   = 0x2,
 	MLX5_SET_HCA_CAP_OP_MOD_ATOMIC                = 0x3,
 	MLX5_SET_HCA_CAP_OP_MOD_ROCE                  = 0x4,
+	MLX5_SET_HCA_CAP_OP_MOD_GENERAL_DEVICE2       = 0x20,
 	MLX5_SET_HCA_CAP_OP_MODE_PORT_SELECTION       = 0x25,
 };
 
@@ -1875,7 +1876,10 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 };
 
 struct mlx5_ifc_cmd_hca_cap_2_bits {
-	u8	   reserved_at_0[0xa0];
+	u8	   reserved_at_0[0x80];
+
+	u8         migratable[0x1];
+	u8         reserved_at_81[0x1f];
 
 	u8	   max_reformat_insert_size[0x8];
 	u8	   max_reformat_insert_offset[0x8];
-- 
2.38.1

