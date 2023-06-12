Return-Path: <netdev+bounces-9989-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F397172B972
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 09:59:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D8EF91C20AC3
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 07:59:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9EA4E576;
	Mon, 12 Jun 2023 07:59:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B750BDF4C
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 07:59:39 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2062.outbound.protection.outlook.com [40.107.243.62])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B10E0126;
	Mon, 12 Jun 2023 00:59:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eJWmrPXWKZ3Zx65mA3LGnvecAvfQ42FKM/V1UYEGKbDI3EWRG3L4krVNIxQIa/uO3WKAdtbTqXy0o+KljVPjW578auFo3g8T4hHUAZmhOZukgjOIHPvKj+B/khCWP6nIObRxknaFlXNdS1sE70g4IwfCOhEOe2QsA4zzBuTaDQu9jcMVLfK1K42FUX07zOnk8y1lY8ZCKFl75GDb9MqG0O8yMTLg3JPcIH9x+Dk+N4EHlk9byMi2+SWuTFlCA0Mr0/rW44IqtBwn+GJPNMbeGXaGkPVgboG93XKA/FQFlXPN8+MllIT5KD6xLtKNvK/KtlakUP6/CXdAoVZ+N+VrDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9tL3jNN18M1rVhHni1etpQyDMyhCDnNd4a7AtFWdJ88=;
 b=gGIz/90j6ZVBWomng6+P+eGTXv12q3YT/NHDbLtZJCVInobGxBQ3LlGGIEOyBhBywfol6pP4+RnVB94qXmwSM0vGtQ0G4NdqbZ/MuelFi9ergca7dxVHJ99L/ac+lWOKtx/fFVvGVQ6G/rKisfdEE6EmdnkOreA0zxivdq5CoYLMHi8FS50Rg8eN7pAQPWD3SiaNS0Q89qRJzICMOhy5mm4DCIG4pb7GeA9ToVn7CRWutMjEtgGectc4w/5laJ/NRZZEAcsbsQAAS2/LyqAULDhTBCN4ES32yCNTLhyVIbKunCK1I/HqnSw+0+lTe/0Moh0CguBdfq0wRc08FIuxtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9tL3jNN18M1rVhHni1etpQyDMyhCDnNd4a7AtFWdJ88=;
 b=pLf4GtQyM0ejegb6E2JuIKMwl1qyQeZ6i8wsh4ogXrqT4iSLQR5CuG/junXlCv6FIiB7ncZ4VrpbB6bDoWAkM/f5jDc2WEGAjih4uDVZbHelNC8UP8zhfIf0MNyqvASwlDFpjfha8TlSp6eg+m6S5IBd5taFepu5ktSZuJiCivIzy2BjfWLBheaG/P7WAjoWMsZW163cr/OgEGMdNHORsESNENXEU/kUv9VoK2Q0COXGhQE14lWlMmZRB5BMkJpW+vc5IGEgDi89PEPiQmjZqfgIC/otJHMi0ey/ygf2dPyJDFldieC+W8wgAZVR+o8Gk7S1MIthrg5Y/mAlKho0vQ==
Received: from MW4PR04CA0173.namprd04.prod.outlook.com (2603:10b6:303:85::28)
 by SN7PR12MB7321.namprd12.prod.outlook.com (2603:10b6:806:298::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.44; Mon, 12 Jun
 2023 07:57:58 +0000
Received: from CO1PEPF000044F1.namprd05.prod.outlook.com
 (2603:10b6:303:85:cafe::15) by MW4PR04CA0173.outlook.office365.com
 (2603:10b6:303:85::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.34 via Frontend
 Transport; Mon, 12 Jun 2023 07:57:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1PEPF000044F1.mail.protection.outlook.com (10.167.241.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6500.22 via Frontend Transport; Mon, 12 Jun 2023 07:57:57 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 12 Jun 2023
 00:57:45 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Mon, 12 Jun
 2023 00:57:45 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.37 via Frontend Transport; Mon, 12 Jun
 2023 00:57:41 -0700
From: Vlad Buslov <vladbu@nvidia.com>
To: <pabeni@redhat.com>, <davem@davemloft.net>, <kuba@kernel.org>,
	<shuah@kernel.org>, <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>,
	<jiri@resnulli.us>
CC: <netdev@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<marcelo.leitner@gmail.com>, <shaozhengchao@huawei.com>,
	<victor@mojatatu.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net 4/4] selftests/tc-testing: Remove configs that no longer exist
Date: Mon, 12 Jun 2023 09:57:12 +0200
Message-ID: <20230612075712.2861848-5-vladbu@nvidia.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230612075712.2861848-1-vladbu@nvidia.com>
References: <20230612075712.2861848-1-vladbu@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F1:EE_|SN7PR12MB7321:EE_
X-MS-Office365-Filtering-Correlation-Id: 87de974d-12e5-4bb3-fbd5-08db6b1abc9b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	eczhdDrGI1YMyB3Weo92Io69/NJU48NprHDduPDjXZGwqTGWPNp46Pep9U3K2k5UJCYrBnTb1oLZvGteRYXt1PKySLG14qUmeMStGyoeFqO00p0SCVK7np+1DtEG/HCMageGkAZl/dWoQtY04xzF9+dbvPoKykVOhFCdoOehZyVrKaCyIxsaoa0lJckLMON9P6GQXDk8s1VFN/I4Fs1IBTzuSMCzN6RoQMCowTOfG4vtiebd4KzajaDPHhzO7jb//2QtMCFElZ/DhxNkIbYY8vHwkscCZLeLawIk/XDyx0ptKDSmapZx47NcSH1HDa/AEqndYQEJoJbGIHRcyqlPuriqqtWoJHtLvwW/sLSX7StjRvIqKgIDUef76PxcBmH/Xu87IZTOfgbkc92AUygCsJ4HZvNDxIjGg4Dzo1qBPytKGRSCW/RTjbGpJ4S3Sn3O6d+IO5CaEBCo3km5teye84DmB4U1UNJ4c2fSEU7sI6BPjUJVAowpUhSjr/W2VszhvDVKEUnCK1vfWZCjXgNoBw+pyt1Y2wkH3x4lJgQVC3CTvSY9R4T4uatYoRCAmHtdlDJjyv6g8VkCx2qfQbVghqXqQ943S8KmwrDt5hRh7PYhDOyG2shxvgTU/GRey+5izoFV+AVTXDJnWgBGzeOs4qIuubwVJDrBMfIPIdh5EJaGHau9ZyVPUISNhbHRzEFa2Eg5IBKLgq5Ca4jTnXx2qw8TQK9Tw8NqAHwRKet7gCWUeFbU3DbGgKTLwFr9QTGf
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(136003)(376002)(346002)(451199021)(40470700004)(36840700001)(46966006)(7696005)(316002)(40460700003)(41300700001)(426003)(83380400001)(2616005)(86362001)(82310400005)(36860700001)(47076005)(1076003)(26005)(186003)(107886003)(7416002)(2906002)(7636003)(356005)(82740400003)(40480700001)(336012)(36756003)(5660300002)(8936002)(8676002)(110136005)(70586007)(70206006)(54906003)(4326008)(6666004)(478600001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 07:57:57.9155
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 87de974d-12e5-4bb3-fbd5-08db6b1abc9b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F1.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7321
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Some qdiscs and classifiers have recently been retired from kernel.
However, tc-testing config is still cluttered with them which causes noise
when using merge_config.sh script to update existing config for tc-testing
compatibility. Remove the config settings for affected qdiscs and
classifiers.

Fixes: fb38306ceb9e ("net/sched: Retire ATM qdisc")
Fixes: 051d44209842 ("net/sched: Retire CBQ qdisc")
Fixes: bbe77c14ee61 ("net/sched: Retire dsmark qdisc")
Fixes: 265b4da82dbf ("net/sched: Retire rsvp classifier")
Fixes: 8c710f75256b ("net/sched: Retire tcindex classifier")
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
---
 tools/testing/selftests/tc-testing/config | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/tools/testing/selftests/tc-testing/config b/tools/testing/selftests/tc-testing/config
index aec4de8bea78..6e73b09c20c8 100644
--- a/tools/testing/selftests/tc-testing/config
+++ b/tools/testing/selftests/tc-testing/config
@@ -13,14 +13,11 @@ CONFIG_NET_SCHED=y
 #
 # Queueing/Scheduling
 #
-CONFIG_NET_SCH_ATM=m
 CONFIG_NET_SCH_CAKE=m
-CONFIG_NET_SCH_CBQ=m
 CONFIG_NET_SCH_CBS=m
 CONFIG_NET_SCH_CHOKE=m
 CONFIG_NET_SCH_CODEL=m
 CONFIG_NET_SCH_DRR=m
-CONFIG_NET_SCH_DSMARK=m
 CONFIG_NET_SCH_ETF=m
 CONFIG_NET_SCH_FQ=m
 CONFIG_NET_SCH_FQ_CODEL=m
@@ -58,8 +55,6 @@ CONFIG_NET_CLS_FLOW=m
 CONFIG_NET_CLS_FLOWER=m
 CONFIG_NET_CLS_MATCHALL=m
 CONFIG_NET_CLS_ROUTE4=m
-CONFIG_NET_CLS_RSVP=m
-CONFIG_NET_CLS_TCINDEX=m
 CONFIG_NET_EMATCH=y
 CONFIG_NET_EMATCH_STACK=32
 CONFIG_NET_EMATCH_CMP=m
-- 
2.39.2


