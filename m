Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2501768B014
	for <lists+netdev@lfdr.de>; Sun,  5 Feb 2023 14:55:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbjBENzs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Feb 2023 08:55:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbjBENzr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Feb 2023 08:55:47 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDD1D1E2AA
        for <netdev@vger.kernel.org>; Sun,  5 Feb 2023 05:55:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rl8RHL7uvutGS1NYmGaDDbRiFeGJTTxUGITDY0QSXD6mjLqOWYAAarCyYVP8Ytsuuzc9NcIB8BhVJqzRma9Yv+t0cz9V5nC36nQsc3EGQq8bSpQNESewlUUJZ+1xMsykGYAILIOcVMrVBfNxceFaPxMs/e0DLm5Xqqx8vrWAgSCJlSp5wxxSYsI0hfNhJqHgGLvcrnRzZmzwBJ6z5DA26aXxsONrfRDfaqog1h9iB6C3LonryK/hTwxCBURCje9oq5/zd1yeGzy7Po3Obe9yHZYdaICPw9iLRPt+42QCLY1f6ogdUuAQUt/8KpC406Qnrp221FtW+MUTYQ2GT+jM0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uYidjSZnwvZk6/CSjod/j+4hD5+c2KmBSY3wGeTDLr8=;
 b=StTycz/6TM8Rt+waVDHicss1LKwThsT2YCdu2YO1ZEipYSDD7VZ48a79SCq10vdbzCIKvLrv4/5BUFOYjxJWtgI2bazdue7POOKYQQXq6dmdN4B8hjnAutde7oSVRPdDaOB5nHAZ9cPpNra4SJcyy82VEXWvrZIoRZI7a8jBiDpOyaQfF7J6cQbKQfnE83Ly/kIPwRgswZNrZ5z8u7UlVMQ7/4mtxEldwG7UYRa/ctJrvAqpDSlVoSynfavoY8R52kXEAQ658itQ/jCmJaJGAACN2Jm5Nb9F6W1grt7ihNsYCx2PUNCt7Y90IkKA9fok/YOfr2tuOvfCYtY19S/pNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uYidjSZnwvZk6/CSjod/j+4hD5+c2KmBSY3wGeTDLr8=;
 b=jFn2CVJtYpZNqHERbUN3Z/HYStWEvK/i5l/g6GTZpjgQx0WeKb+1+hYiFdZ3GfEDUJClLNxmmbPmqDwQaRsqyHryI+edQhBKH5yej2CpRmxSdDehzwQ2Ar3hv70AhhHCXkf/ZqIGjr2cQ0+WBvl9L37CZAT98ah3t3EHehgaMJTzQB47s6rtwpsWR9bIk5oY/yHATUvgjLGE0EdI2HBAHoAxyioIU5ORbIXb5GSunLdC+1URl7BurmILKa38STqTAxUnTIf5UoG0WPRIaifm/5kJmopMF9hohq87BCNaajPaG3TL82r3EzSAkscbje+xfzQ43IxMqD2DN20LDZs8Lw==
Received: from BN9PR03CA0749.namprd03.prod.outlook.com (2603:10b6:408:110::34)
 by DM4PR12MB6087.namprd12.prod.outlook.com (2603:10b6:8:b1::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Sun, 5 Feb
 2023 13:55:44 +0000
Received: from BN8NAM11FT021.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:110:cafe::e5) by BN9PR03CA0749.outlook.office365.com
 (2603:10b6:408:110::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34 via Frontend
 Transport; Sun, 5 Feb 2023 13:55:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT021.mail.protection.outlook.com (10.13.177.114) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.32 via Frontend Transport; Sun, 5 Feb 2023 13:55:43 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 5 Feb 2023
 05:55:34 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 5 Feb 2023
 05:55:34 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.9) with Microsoft SMTP Server id 15.2.986.36 via
 Frontend Transport; Sun, 5 Feb 2023 05:55:32 -0800
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
Subject: [PATCH  net-next v2 1/9] net/sched: optimize action stats api calls
Date:   Sun, 5 Feb 2023 15:55:17 +0200
Message-ID: <20230205135525.27760-2-ozsh@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230205135525.27760-1-ozsh@nvidia.com>
References: <20230205135525.27760-1-ozsh@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT021:EE_|DM4PR12MB6087:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d0e30ea-73da-47df-4e5a-08db0780acc5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KnZGBK9vza4h4y3T8EpPZTGwIAHcbOfrXT99gssv71KguZ349x4GFxaiii1QyGeTYDkNU+70HUYHO16uaSDnimRW4RUSsqQ45Yqef6iuWc6VpjVLg1TUyXgSQrrSTV1SP4tjkdnlYRCzmEVk4UDNvnBDO5AV/w6C33CrJnQt0jaFTKR3eTmYKNlYZTPkvmTfVDWpx9n6AeFQQCcyjpNH2JMcOHN+VGjt0KR1HzXYRJPjDiCQIoYiKYT+HmNGq2xmvZXsfuWvSXUJ1McEhQkFtlbL2LxBho9sWZuy2DM4Hw6Bwjxg3VBGtMMMrvt18AC492fOprD25oKPyCgGtXCefzW7l3udbVsFkSBNoWU9NtSczGOS7wPByNeyzxV5NuWzMpudXw1W7L9Rfl0AoicyTeABHyBUXvpiuUB1WkumEPljZumkfECI9Xh0VkAiBT7lc2PaGvhEdtpdUe5VA6yej8ho1IB9s8mh0NMq42RdJ0o7c8/CiOTcc4/fFbTuzUBI2WTVRva1koccZCIDf3UT/9QxGD9i8MsjVblzhr1Uye7hVSig/FS7S/caNp2FhC3eu1dgtcrTrJH+pex2eIsE9yZsm+i8uBZdS2YTPtB5fbdjNxcYggC9+wMLMvK5w7fwOMo1ViaIGoxMLc4Q0svmyjYUc/U/ncJjCGnLD+ETaLNz09wric3492kNG21HJ4GYGTmA3cexHJ+wt3rUIrFarQ==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(396003)(136003)(346002)(376002)(451199018)(36840700001)(40470700004)(46966006)(4326008)(6916009)(70586007)(70206006)(8676002)(356005)(82740400003)(107886003)(6666004)(7636003)(186003)(26005)(1076003)(336012)(83380400001)(426003)(86362001)(47076005)(36860700001)(40480700001)(82310400005)(316002)(478600001)(54906003)(40460700003)(36756003)(2616005)(2906002)(8936002)(41300700001)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2023 13:55:43.6689
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d0e30ea-73da-47df-4e5a-08db0780acc5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT021.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6087
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

