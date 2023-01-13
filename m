Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6DF5669ED2
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 17:57:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229654AbjAMQ44 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 11:56:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbjAMQ4u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 11:56:50 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2082.outbound.protection.outlook.com [40.107.220.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B76139F85;
        Fri, 13 Jan 2023 08:56:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ilQtB3COo+8yNH1SMAHwf2bjZyoQubJRoo8wHycDjHXwuBos3ST02XAtpF0YsdWUfXjDl2qaFJ4QFwwVceDFQXMvRpCtvCK8ajSNGmEhZ0iGGSXyV21MHmGDbiJ1vWOXwbd1L+IFTRPNfy3Fn+4KyBgxZ2c+i2Zgq70kIt5/EZvXkQu/iR4B+R9xkYifbPguOfTWvMPqCWT/oZNzOTnRHlHeERmym/LUzn/ChvUcwqla2GIpHTFzPDTJhW/I8kSHozQo0yENbqEen6LSdyAwRS3LscEPtQ3aJDfTH1OyyM6vElRbFImDe8N/a/B+cvuHVApxUlLJdM1TVC2x2hV4sA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9hEkvfNid554/edezqmJkbmWBn+U9LvTjp4jBTLeAy0=;
 b=lXwErc0E0CbNXPAAS1w37lk52r3deZME551XUZC+UDoVLse6cuPr7kX8CCAYi+5pgRPPKFExJaFC+Y+sVV+iMRhQ2rOSHdrnuGxBUIoUnFY12E+6OChvUK2NMJS+zTOvE5ozDMKtGpwqFAShM61y0hpRmgNfbqp/p9LOj/9EdcRxQhyUBmjqs6UrTIXXqpUqEyurhxTZNztKIZf0rJwqno9RyQl0Yl1p+AUXTcPnaryKc335wOG0fLqXpgeTL3Anl95/ROWjOF+hBSbZ0Wpex4wzP98BJ9u7Zk/9Q+Lxi+aSbxqjfliVcSKLbFppn3+tm1YmMm5IoV/znlvXNrkDSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9hEkvfNid554/edezqmJkbmWBn+U9LvTjp4jBTLeAy0=;
 b=QTyEGKsV73SJ+jjEdG5iio2WTUugHEg/a6vuOeSSmpc40ewy41ySPfA0EJEwh7/H5OqAwGcRApdFbAe8rObZ+F/Qmrfw4zR8Qz9TlS2E/JnFATuSonRasc5UaQMZmR5jDpkbyDdALZGUkmBm36frxS796gQ7gjpOJbUXwMr8TyHOTNJ0D8rvaQZcG5tiND/3F5R/1XqtQ2MFS7OCQ6sDI5S2+BKHxTEQeegbdE9DRPGf5bTBH4cQAe+4KJCgZeICdKVnamA23gJgfWPkd+5vOj2O2bYMr9jY1Yfmg628fVyTNa2Ac59aHzZw3eouMGIlBDlXBBuHpePrjPd6USCLKQ==
Received: from DM6PR08CA0057.namprd08.prod.outlook.com (2603:10b6:5:1e0::31)
 by DM4PR12MB5198.namprd12.prod.outlook.com (2603:10b6:5:395::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Fri, 13 Jan
 2023 16:56:46 +0000
Received: from DM6NAM11FT114.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1e0:cafe::75) by DM6PR08CA0057.outlook.office365.com
 (2603:10b6:5:1e0::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.16 via Frontend
 Transport; Fri, 13 Jan 2023 16:56:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT114.mail.protection.outlook.com (10.13.172.206) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.13 via Frontend Transport; Fri, 13 Jan 2023 16:56:45 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 13 Jan
 2023 08:56:35 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 13 Jan
 2023 08:56:35 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Fri, 13 Jan
 2023 08:56:31 -0800
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <pablo@netfilter.org>
CC:     <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <ozsh@nvidia.com>, <marcelo.leitner@gmail.com>,
        <simon.horman@corigine.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next v2 3/7] netfilter: flowtable: allow unidirectional rules
Date:   Fri, 13 Jan 2023 17:55:44 +0100
Message-ID: <20230113165548.2692720-4-vladbu@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230113165548.2692720-1-vladbu@nvidia.com>
References: <20230113165548.2692720-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT114:EE_|DM4PR12MB5198:EE_
X-MS-Office365-Filtering-Correlation-Id: af3f7665-8562-44db-7018-08daf58727ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F0ymvwPHw67sXDOejmoEnMpj5EaVJl5yldxvKwdyastA3zVAk+KMaLpxQQ5HqhvvEkGIVVuvdBOh8ic8w0V4VHiYujZMUK+lRXVUoXQKskyX2HtreQx3w4Hu77Jjfi5+1rC6kg+wMdBtWiTIjB1vUefkoY9gqoF0bE6zHD3Xl/Y284otN0p2fBjefZyo2PbzAZC+roaacdZyqSVFxGgcMYCFnUDSG1SFhtSyglfl1bYwGdiZpUYEQ16ALAzBUbgv/NXG5L4aQ10i0v5PkGb9//lGias7r96EqEoqXawxDG35kUJN/FGMu1PLaDIcW7ffnb1CIDdbqkRf2dWvzy4dLxta6yVOktPMmHUZ6R6sn+DZxHeCq5ezspOsOICN/1fG/iADu8w+KQf7ME7Z6uWZ40LaPKLV6/VTKp39WX/1yimwAxAobef0eagKjB67S2AR15N4a/JJCFYhDBoZqQzC5ERaz+GAmkoAqbkInH01ccH/DseRNyXvnO4DQMIwGh1xjZaw4+uiow9EBsCX/IQLXg+Sdv1iJYTxvPg1mNQAs0ifbJJYzsylNef3zp3cO6lKoi9iQmY7ZEDUdBx3ATRprqWHCbkZxtrL6Xhl64O/rE50b4AKyA9F1e/qPPaLJDwoRBrKDQ9WumF6RGiiXYGN0NdDK30rz19beFDAblwmpDi5Hg8I3vJOvAfyTBu6abPiAES4RA7TNzDgNTL/FhOJ/yXOXeWgJJXT/UN/I6gLUbA=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(396003)(39860400002)(376002)(451199015)(46966006)(36840700001)(40470700004)(107886003)(36860700001)(36756003)(7416002)(6666004)(2906002)(70206006)(5660300002)(83380400001)(4326008)(8936002)(8676002)(82740400003)(426003)(478600001)(41300700001)(356005)(47076005)(7636003)(26005)(336012)(70586007)(40480700001)(82310400005)(186003)(7696005)(1076003)(40460700003)(86362001)(2616005)(316002)(54906003)(110136005)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2023 16:56:45.9786
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: af3f7665-8562-44db-7018-08daf58727ac
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT114.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5198
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Modify flow table offload to support unidirectional connections by
extending enum nf_flow_flags with new "NF_FLOW_HW_BIDIRECTIONAL" flag. Only
offload reply direction when the flag is not set. This infrastructure
change is necessary to support offloading UDP NEW connections in original
direction in following patches in series.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
---
 include/net/netfilter/nf_flow_table.h |  1 +
 net/netfilter/nf_flow_table_offload.c | 12 ++++++++----
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index cd982f4a0f50..88ab98ab41d9 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -164,6 +164,7 @@ enum nf_flow_flags {
 	NF_FLOW_HW_DYING,
 	NF_FLOW_HW_DEAD,
 	NF_FLOW_HW_PENDING,
+	NF_FLOW_HW_BIDIRECTIONAL,
 };
 
 enum flow_offload_type {
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 4d9b99abe37d..8b852f10fab4 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -895,8 +895,9 @@ static int flow_offload_rule_add(struct flow_offload_work *offload,
 
 	ok_count += flow_offload_tuple_add(offload, flow_rule[0],
 					   FLOW_OFFLOAD_DIR_ORIGINAL);
-	ok_count += flow_offload_tuple_add(offload, flow_rule[1],
-					   FLOW_OFFLOAD_DIR_REPLY);
+	if (test_bit(NF_FLOW_HW_BIDIRECTIONAL, &offload->flow->flags))
+		ok_count += flow_offload_tuple_add(offload, flow_rule[1],
+						   FLOW_OFFLOAD_DIR_REPLY);
 	if (ok_count == 0)
 		return -ENOENT;
 
@@ -926,7 +927,8 @@ static void flow_offload_work_del(struct flow_offload_work *offload)
 {
 	clear_bit(IPS_HW_OFFLOAD_BIT, &offload->flow->ct->status);
 	flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_ORIGINAL);
-	flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_REPLY);
+	if (test_bit(NF_FLOW_HW_BIDIRECTIONAL, &offload->flow->flags))
+		flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_REPLY);
 	set_bit(NF_FLOW_HW_DEAD, &offload->flow->flags);
 }
 
@@ -946,7 +948,9 @@ static void flow_offload_work_stats(struct flow_offload_work *offload)
 	u64 lastused;
 
 	flow_offload_tuple_stats(offload, FLOW_OFFLOAD_DIR_ORIGINAL, &stats[0]);
-	flow_offload_tuple_stats(offload, FLOW_OFFLOAD_DIR_REPLY, &stats[1]);
+	if (test_bit(NF_FLOW_HW_BIDIRECTIONAL, &offload->flow->flags))
+		flow_offload_tuple_stats(offload, FLOW_OFFLOAD_DIR_REPLY,
+					 &stats[1]);
 
 	lastused = max_t(u64, stats[0].lastused, stats[1].lastused);
 	offload->flow->timeout = max_t(u64, offload->flow->timeout,
-- 
2.38.1

