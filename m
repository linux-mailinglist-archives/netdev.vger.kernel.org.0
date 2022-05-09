Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6388B51FF1B
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 16:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236787AbiEIOFQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 10:05:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236800AbiEIOFP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 10:05:15 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2050.outbound.protection.outlook.com [40.107.212.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3542725C7C
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 07:01:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gPz1oIvE/Ue7XR5bCfYZo0D72qu1lTc74Awqde3KoSyfUaEeiaduKgWz+k4RdtjPbwuw0ab7UW/TK6hr5EfKTiVibFgf24FxTxfhbvXVuJdxxBWKpVVtLgaLsuiom2yTwvI6dDhwqBOX6WcA+cn9+wUhWx+qazlrvADVDAiXcI3f37ZP1KUi1G7OMiB+/YiyrKcQibm8p5ab8O69Us9QzYK510Iv22OOnNA1PR0i9y9/7yEmvK1pH9wo5ApNQiKlpxLqvIuWjj346ux/LDaddpY5x/s7sjk5X76/bQB502mi17fg8yR6iEPs5Sl5R64ykuyQ6ZqwPhyH54qa7Gyhdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M7r2lDArsV5Yts/h9Bhzf4ak3GJZ7R65XInyN3Q8WdI=;
 b=BdeeYowmBDEjvlBhe4uMAYd3Zbe87NimtBnLG5vlTl+sNdFTsmVZHZsAGSVs/si6IkbriF3Ptw+YcFN7ZjSLwjmKuVkQ/px2sapszZW1RH0hq2KjvQ0ahr9AyV1zLGPMbyH6sLDWQkwWWvMegtvrOoUJjReysmOACvKyD/Wfouqj6vjwnfz+DRDEKJ0NcDNXweTC+5QpvAWV4QaE5Q8Y+/GUSh/U5JrqRmhdn/tBMpAKU6THVWqVKeEzOqNHzRoyFnITQDzItz00lOckyuHop8WyZ5I6gtShfWtES3+DN7Ek7rzaMpmiz40IO4l//HYq4iFiMJ5nOFSr3LqEcaqs+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M7r2lDArsV5Yts/h9Bhzf4ak3GJZ7R65XInyN3Q8WdI=;
 b=oeSwXc4usf4UlVddO7PScSiS/gK/FKK10djrjkvTvhC9DmddoW8RZAWjJ28fTdjKUuiintNvy1FSt3zKO/sLofz4dPjsu98qfb3vwoSHwsifRmN5xxZfdahIFyKAsk1XeZyINuvyilSbUKYVhX2B4+asA4BV/SkgDMLE+/kS6I2iP8dGmumWhSwxp8gPpxIof7Ws+VDX1baAMig5y/29kJMXMv1WOoIy+CcoAajlgRLaUK9Izdoenja/wIaYmAbjT4DGWiL5cfG0zq4Ko4keOOkAIPMdv3uzLNuSmDLRZIDC2mQc8M9gDnBNPTpEJxxIqukvHgq9rZZsvkO8ue8R4w==
Received: from MW4P221CA0024.NAMP221.PROD.OUTLOOK.COM (2603:10b6:303:8b::29)
 by MN2PR12MB3056.namprd12.prod.outlook.com (2603:10b6:208:ca::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Mon, 9 May
 2022 14:01:17 +0000
Received: from CO1NAM11FT032.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8b:cafe::bd) by MW4P221CA0024.outlook.office365.com
 (2603:10b6:303:8b::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.18 via Frontend
 Transport; Mon, 9 May 2022 14:01:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT032.mail.protection.outlook.com (10.13.174.218) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5227.15 via Frontend Transport; Mon, 9 May 2022 14:01:16 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Mon, 9 May
 2022 14:01:16 +0000
Received: from localhost.localdomain (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Mon, 9 May 2022
 07:01:14 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@gmail.com>, Ido Schimmel <idosch@nvidia.com>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH iproute2-next 05/10] ipstats: Add a third level of stats hierarchy, a "suite"
Date:   Mon, 9 May 2022 15:59:58 +0200
Message-ID: <11d977863011c6bb3d764ce59d9f5863f4f042f9.1652104101.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1652104101.git.petrm@nvidia.com>
References: <cover.1652104101.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7bcc55ac-015c-437b-045c-08da31c462ce
X-MS-TrafficTypeDiagnostic: MN2PR12MB3056:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB3056B802D555DF22A8A36F45D6C69@MN2PR12MB3056.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ejx1vszU3eSe/Z8SWtSlwodmIsc4jHNr/Hcy5wS8QD0j2rpNpJpx5QGr8yI69lksoX7lAUsHeQOp1aJZcDNjr/gQPcibPqcrPdT/6yVI6ZtJnwN0NbruxF+POcvCzgn3XSZcQV4frH0zFjB7tjmHA/3eMMwzDJJiBgtfJhbXU+bwJrUs0F56Um1r2+WQmwqIl2I+yM13gWZ3BsbN6LH2xczJ/QKmxUwNoclbTxtVlO75nYj0iTHOZgI/UtsNI+0uIM9+R+ERfSg7oW09H7wTiY3PV3VEXyGB09Zh+6eky85oHlgYz6Kl6myQT7+6f9R+5iBv5/JGwSL6TDjXPsyQjIlGh/+gOHO7JHbcxmdzya2fcuJpHseMpKnWIaoCboQ+10jKD1FAl0STrVD2At08unv9bDaB8P5MNXSnPVnLG/qhNh9RsmyDZlPW5yUHwSy8viMhpZmyZBFqPxopl0tp1F5wnIKXsOzX0Bc9j7D54bLSWLt+VhpBQ1r/RbaLKlAYfAs2eWuBoZryPCLJYpnc1d8LJctnFyRx8rqinYNK28OkTzZBjHGRW/v2O9GuKgAeiSeohfWl0nhDYE5SspjKN8TtbazXwPMDyHQ49iQ4uEYZLEfPaPckNiw63/bXCY6Yv91gJ+ikHFvoSs8gYOOwAgCkhLuLOyXnJ16soDO2J1nXEewpjeptdcalnXmMuuW9gT5xiZI8NmMDyQsLu44fcw==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(36756003)(2906002)(356005)(40460700003)(36860700001)(5660300002)(16526019)(508600001)(81166007)(8936002)(107886003)(186003)(70206006)(47076005)(4326008)(426003)(83380400001)(336012)(70586007)(2616005)(8676002)(82310400005)(54906003)(316002)(6916009)(26005)(86362001)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2022 14:01:16.6272
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bcc55ac-015c-437b-045c-08da31c462ce
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT032.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3056
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To show statistics nested under IFLA_STATS_LINK_XSTATS_SLAVE or
IFLA_STATS_LINK_XSTATS, one would use "group" to select the top-level
attribute, then "subgroup" to select the link type, which is itself a nest,
and then would lack a way to denote which attribute to select out of the
link-type nest.

To that end, add the selector level "suite", which is filtered in the
userspace.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 ip/ipstats.c        | 9 ++++++++-
 man/man8/ip-stats.8 | 3 ++-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/ip/ipstats.c b/ip/ipstats.c
index 5b9333e3..0e7f2b3c 100644
--- a/ip/ipstats.c
+++ b/ip/ipstats.c
@@ -34,6 +34,7 @@ struct ipstats_stat_show_attrs {
 static const char *const ipstats_levels[] = {
 	"group",
 	"subgroup",
+	"suite",
 };
 
 enum {
@@ -1024,7 +1025,7 @@ static int do_help(void)
 
 	fprintf(stderr,
 		"Usage: ip stats help\n"
-		"       ip stats show [ dev DEV ] [ group GROUP [ subgroup SUBGROUP ] ... ] ...\n"
+		"       ip stats show [ dev DEV ] [ group GROUP [ subgroup SUBGROUP [ suite SUITE ] ... ] ... ] ...\n"
 		"       ip stats set dev DEV l3_stats { on | off }\n"
 		);
 
@@ -1048,6 +1049,8 @@ static int do_help(void)
 			continue;
 
 		for (j = 0; j < desc->nsubs; j++) {
+			size_t k;
+
 			if (j == 0)
 				fprintf(stderr, "%s SUBGROUP := {", desc->name);
 			else
@@ -1057,6 +1060,10 @@ static int do_help(void)
 
 			if (desc->subs[j]->kind != IPSTATS_STAT_DESC_KIND_GROUP)
 				continue;
+
+			for (k = 0; k < desc->subs[j]->nsubs; k++)
+				fprintf(stderr, " [ suite %s ]",
+					desc->subs[j]->subs[k]->name);
 		}
 		if (opened)
 			fprintf(stderr, " }\n");
diff --git a/man/man8/ip-stats.8 b/man/man8/ip-stats.8
index 7eaaf122..a82fe9f7 100644
--- a/man/man8/ip-stats.8
+++ b/man/man8/ip-stats.8
@@ -19,7 +19,8 @@ ip-stats \- manage and show interface statistics
 .RB "[ " group
 .IR GROUP " [ "
 .BI subgroup " SUBGROUP"
-.R " ] ... ] ..."
+.RB " [ " suite
+.IR " SUITE" " ] ... ] ... ] ..."
 
 .ti -8
 .BR "ip stats set"
-- 
2.31.1

