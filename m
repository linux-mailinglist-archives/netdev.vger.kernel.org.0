Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FC6D68BF22
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 15:01:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbjBFOBH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 09:01:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231300AbjBFOAt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 09:00:49 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2053.outbound.protection.outlook.com [40.107.94.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AD2625953
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 06:00:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dr75wSLoh18nxvzArAagU1U4dISC3cGetHS1CP5Ij9u9HhC1S3D0KD80YKg2S3D8SO8/mmlBytrR+ogtJtdK3cWLwTGnkdfgVNw+qG9oZJzpozkFCmPwVIkyLftidIcrPdmIrV/I/BmFFbQFMMORcagG1Ul1CztQz4f4uI2fyx453hGpuxE3dfKlC5LVFvrRdRG+wUD9fySvrs2L3CtNln94O9YD51Hamf+5RT4GzEjxkhLkMQNbNJSdgS4fOJa+CmR0cq2ivKZ/rvDLnoafR1segRrt6kA6VNsYl9LH+y7oZLe7cYBjvdwMQVKysoqgX8HrPJHhOrgYgQYyYUv14Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uYidjSZnwvZk6/CSjod/j+4hD5+c2KmBSY3wGeTDLr8=;
 b=XE0yv4VSkvbpPfmLEknLBz7JZgDVjEdvx772qw4PWo4rROdMNALimZxf22IcQyyShgJcH2QGx5InpyF/o6OGYlAmvDawmVi7vQDlOSjv8UEm3LJmtVr0USP4oDWa2+7ET+s55wVLGR8GoFMvBVnvJMfPlmmvsd2FWeXNkDYgBTm6dzci4aPi6t/bgPpu0e/QQirbeF4mfIOCzv+hRprzM7VKeo+xfxZnELXLid4jHIVdpeMWRUBRyRhdGz0kJz+eFQt1+M0d3E/sdUmEA/OAhK8P/r/2l30VkjyunrvlSGKo3YpFS/gyQtvbINjLOHXnYbuOP7RQCHnMxgptne93QA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uYidjSZnwvZk6/CSjod/j+4hD5+c2KmBSY3wGeTDLr8=;
 b=BGbGjkU9lZY5GgIEoizR0Ys6pKgIJBZJrs8lmm1c1bRnh+V9AaWgATn3La8OaPKEbe8tiKDwERYpr5tBeW1nniPkLwTN2pMBS5EBreTpGoEkbNgds2TVUYyVSEaWmrDCN0ZcCmdgWmIuK6k3u+NC095/1fpPuf0DxlIx73JhPe51GcGvbR3wuoY1K9vZ1RdCXL12LFbJmWm7GuTRbAf5WoxkHJrMJ7zaf5rv2Iwjw8CV69D88w8vPPV8NL4wNZPuJFOLazoYOGHquv6aimT3RepLZrbWVhK2wRsT20Tg3vgADQ5dpLVk0Jh2ylFIl06s3F9topFFAufpSdjs9gEsOQ==
Received: from BN9PR03CA0445.namprd03.prod.outlook.com (2603:10b6:408:113::30)
 by SA1PR12MB6774.namprd12.prod.outlook.com (2603:10b6:806:259::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Mon, 6 Feb
 2023 14:00:16 +0000
Received: from BN8NAM11FT027.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:113:cafe::fa) by BN9PR03CA0445.outlook.office365.com
 (2603:10b6:408:113::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34 via Frontend
 Transport; Mon, 6 Feb 2023 14:00:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN8NAM11FT027.mail.protection.outlook.com (10.13.177.96) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.34 via Frontend Transport; Mon, 6 Feb 2023 14:00:16 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 6 Feb 2023
 06:00:08 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Mon, 6 Feb 2023 06:00:07 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.126.190.180) with Microsoft SMTP Server id 15.2.986.36
 via Frontend Transport; Mon, 6 Feb 2023 06:00:05 -0800
From:   Oz Shlomo <ozsh@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Saeed Mahameed <saeedm@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        "Jiri Pirko" <jiri@nvidia.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        "Simon Horman" <simon.horman@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        "Oz Shlomo" <ozsh@nvidia.com>
Subject: [PATCH  net-next v3 1/9] net/sched: optimize action stats api calls
Date:   Mon, 6 Feb 2023 15:54:34 +0200
Message-ID: <20230206135442.15671-2-ozsh@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230206135442.15671-1-ozsh@nvidia.com>
References: <20230206135442.15671-1-ozsh@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT027:EE_|SA1PR12MB6774:EE_
X-MS-Office365-Filtering-Correlation-Id: 93850763-d98f-4f58-42d4-08db084a79c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fXVtNeQUFO59rW+g+Cv92zPHSO7jlnjMuu4TIjW3Wh5w4NqhrlJ8aww9Z8Sv/It/ors/NVhvB7HPfdJNFli2neDZKMyG3gnbyqU7LMfU730GXozEKotnC+8Mn21B4u+tJGASlGRnoldPHwi+/xnyfVO6B0bunlyeu0MjE0JYq/i/rt0CqihP7wjB+KySMz3D3PMerdlIjHeVP7ziD2X6w1dKMND8/EIubd6uvsM2Vn+Ycl2dQzb8kiWIh9LHEYutmTm/k6AdsYa3YQ+hH8pX8QCyVF4gulq6P+X/ZvmSHShELogZFIRnU2DKxqzD6qx0nrEJSYp6so9QI2H4OttNcn1Da1rlnKcDWxl49fzlKGTpDJ1omzDIjCv9TI7xqluogBKSeJWTBY8BR3qE4Q3VAict3kcQZTEPH2ku34svcP117MHgnmFvYqKpZXPyvIDjx63NUtFbDMBc3at5U0IPZSWY3y3GdY2leRLkFb32rOgizuvOGrlZLGM6islu/R8jwiIDAn9Cn0LeU2pYKwmiIlUCioMzTQAKywOGFeYvhPXcBShSzV06NgATpliW3Y+UqPUG/nM6K5Kc/tLPk6dK/nVbLCVcOLUquqVqACzNSd0Z867cXYHVKiWMZ6RPEyEsLh+gL88CpedDk6dt6EidrzTZeqEdDWVLyq3Sf5DDkhkBCg/YbXJlS38DdpMvPTSE21g1IDrmSvGzSvvS1b42QQ==
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(39860400002)(136003)(376002)(451199018)(40470700004)(36840700001)(46966006)(70206006)(54906003)(82310400005)(70586007)(6916009)(8676002)(4326008)(41300700001)(316002)(8936002)(5660300002)(356005)(7636003)(86362001)(36860700001)(36756003)(82740400003)(1076003)(26005)(107886003)(6666004)(186003)(426003)(47076005)(40460700003)(40480700001)(2906002)(478600001)(83380400001)(2616005)(336012);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 14:00:16.4755
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 93850763-d98f-4f58-42d4-08db084a79c5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT027.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6774
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the hw action stats update is called from tcf_exts_hw_stats_update,
when a tc filter is dumped, and from tcf_action_copy_stats, when a hw
action is dumped.
However, the tcf_action_copy_stats is also called from tcf_action_dump.
As such, the hw action stats update cb is called 3 times for every
tc flower filter dump.

Move the tc action hw stats update from tcf_action_copy_stats to
tcf_dump_walker to update the hw action stats when tc action is dumped.

Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
 net/sched/act_api.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index cd09ef49df22..f4fa6d7340f8 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -539,6 +539,8 @@ static int tcf_dump_walker(struct tcf_idrinfo *idrinfo, struct sk_buff *skb,
 			       (unsigned long)p->tcfa_tm.lastuse))
 			continue;
 
+		tcf_action_update_hw_stats(p);
+
 		nest = nla_nest_start_noflag(skb, n_i);
 		if (!nest) {
 			index--;
@@ -1539,9 +1541,6 @@ int tcf_action_copy_stats(struct sk_buff *skb, struct tc_action *p,
 	if (p == NULL)
 		goto errout;
 
-	/* update hw stats for this action */
-	tcf_action_update_hw_stats(p);
-
 	/* compat_mode being true specifies a call that is supposed
 	 * to add additional backward compatibility statistic TLVs.
 	 */
-- 
1.8.3.1

