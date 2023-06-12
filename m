Return-Path: <netdev+bounces-10055-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A42272BCCC
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 11:36:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 154492810A1
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 09:36:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF71517ACF;
	Mon, 12 Jun 2023 09:36:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC9DA168AF
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 09:36:08 +0000 (UTC)
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2087.outbound.protection.outlook.com [40.107.95.87])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 102BB8F6D
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 02:35:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A66LdqU3vQC9WmBtZlMydLpkVdeD9n5VHCFkrHU5q39w5hQ3Ot4MUWVmYZoaeCX8jnKZQ3bFjHsbebHhaxpwv1vuYC/lFnuYTTaVfYi6U0zP0H80t1JK1FHeDiafq3RVe8Po7YeENr/LWTHDoNUwXYG+ueibg/YV6Ok1KsgWqDKh63zZDJlB7tKJG0aZnRkE3OpBeszodhBmULdTRaUpXXQUKxa4PTG9rqXSd/X6yy0w5kGp7U8M+0FXgJ17vE5fo3N5qI0+amfOBFXsZAzrUp6cCiaEGnECOsgYoHYUbxUqLGMW7ZM6wSYdx72zaQiYpfKWXDhGjC5foU5s5h993Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y7rBszO80I68hOj7dgVIy6gStGuzI5t//C+kIKbS7K0=;
 b=EyLQCJW3P699zKTecSX6gpBIESBZdJvNY3Tdw11BI0Z3STvEMmtIjlvqK3YFfo9aI1FR/6t0Isem+5IbAK53NoA26GDcNhj9y9pKbbqFPkbWoUW7DyTnWZIITSqCByw6LaFywige4aX7z+dLPfvEZvs6omPzWc/dHKMvnhy9Bxw+QswXhXCJo/KgM/AiRFBVgLyJrqI+sG1vXPskqyFsu8hzb4Na8GPo6F5fgpznk/uTr74pURFAtVvZmQnhEQYmSr76uq4kMqr9WhL5XQ/3kJaVgHhaq81hp1d1dZ6eLqKrKYL5JW5X/LCkaunU5kX0yzVT4ikleRa/z5H1/ThEjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y7rBszO80I68hOj7dgVIy6gStGuzI5t//C+kIKbS7K0=;
 b=XlRix24UlMy+xO8KtNAAmdUKAXNOdj25N0fs7MV6Ycr3Ve+xjTWVXtxAk8gZY2JnFaSSA3Isc2s9X7wPKwrefMD/YzPAWsAeg7JATmGLHuhHhOFdyMJCvuC6PC8/pW5p36JcQmhv2u/GipKnG6bZHPPYXEt3/qZ1hPxy8L04h9owqQjE+bO1mlQmNvk88ukZ9pzDHsKl5Mfr5BCJyrM0kk1LZSiop4OY+ypsOmHgIHDPTOVXQIx96PgzBznXnQRVYv3z2K0KKtqo+Sb1UIq9UlxpXNzyGCbSdJGPDPnB257V/OFVBkCpfxm6UToh5sqE9vcAN0GfKL5oF9FJM0XT3A==
Received: from MW3PR05CA0014.namprd05.prod.outlook.com (2603:10b6:303:2b::19)
 by MW4PR12MB7430.namprd12.prod.outlook.com (2603:10b6:303:224::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.36; Mon, 12 Jun
 2023 09:35:15 +0000
Received: from CO1NAM11FT115.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:2b:cafe::50) by MW3PR05CA0014.outlook.office365.com
 (2603:10b6:303:2b::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.21 via Frontend
 Transport; Mon, 12 Jun 2023 09:35:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CO1NAM11FT115.mail.protection.outlook.com (10.13.174.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6500.22 via Frontend Transport; Mon, 12 Jun 2023 09:35:15 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 12 Jun 2023
 02:35:08 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Mon, 12 Jun 2023 02:35:07 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.37 via Frontend
 Transport; Mon, 12 Jun 2023 02:35:04 -0700
From: Vlad Buslov <vladbu@nvidia.com>
To: <pabeni@redhat.com>, <davem@davemloft.net>, <kuba@kernel.org>,
	<jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
	<renmingshuai@huawei.com>
CC: <netdev@vger.kernel.org>, <liaichun@huawei.com>, <caowangbao@huawei.com>,
	<yanan@huawei.com>, <liubo335@huawei.com>, <pctammela@mojatatu.com>,
	<simon.horman@corigine.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net] net/sched: cls_api: Fix lockup on flushing explicitly created chain
Date: Mon, 12 Jun 2023 11:34:26 +0200
Message-ID: <20230612093426.2867183-1-vladbu@nvidia.com>
X-Mailer: git-send-email 2.39.2
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
X-MS-TrafficTypeDiagnostic: CO1NAM11FT115:EE_|MW4PR12MB7430:EE_
X-MS-Office365-Filtering-Correlation-Id: 566222fb-4453-4005-31d7-08db6b285420
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	5yGzzx1WUIWmsh5D4wxvsqZHhPwzd4b46dWqq/S7GE5lwVwXLqVW8D5mfqzwXNCIRKB60ifKQ9bPyXJdRgpcJEr0r0sudtEW027274SSIcYfpvDFbU7X+fJvRh2L7gIvp8wXjpXbn4sxwDyf+Gc3YFL9inUc0YNkddqOzmskj6d7A4rDWtU2Lma1U58bYGxUpVCXje2dVCkvXSudRkhya4CB8h6rFWWHmpBI7XaNqjDp8gJ16Z5YuFniYd2BLffcdklvW2JGnxX5nHnXxS81Ol5U1Jv5UAXDtpzb87XXnYi0PNXfEwl89FF86Kx5BjfFHA9lC+tETo6zjSSrRHZCcAg+MBlYaXl40vprh/8RwP6l+NLCxeDAsuCaWmU89rODMexJins4A5KpE4TZE64kZcCdHwgY6qkVfZELp8Lon1Jtt8o/Oe77tdHdU+bic5tpTaE5EM7TjQRQsPp4dKXoyKKOYMSVdkzUUWFUAkOyisZnPqC1qxm+BYM5XlQBnEWavo9fTtGxwl7n05rcI8v2YDbCNVb8RwnqKw1jSw7MMTQb/TgIM/7snnChkwKBKBnU5P19dvFwQ6xVW8lYzpDJA1sq2P91YOE7skdTmAtwxKrPbHIo7pVmk0rxK9ezOJGcJSJ27zkkWHeIQvbKD5/Jd3f2NxCBvB1h+E1sIe9ncLDeD097r09/MSj52aufHnmUeSg+0kTPwwwS5AC6bwt/tszpG0EGTEV6ywxHmAXueK93gT1hT6Esf0nVCA7up+ZhLS6oInBxQEkWM1lZms7IZJn8QESVn4TBm2uQZ0Uq518=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(136003)(39860400002)(376002)(396003)(346002)(451199021)(40470700004)(36840700001)(46966006)(107886003)(26005)(1076003)(186003)(2616005)(7416002)(36860700001)(426003)(336012)(83380400001)(47076005)(6666004)(7696005)(2906002)(966005)(110136005)(54906003)(82310400005)(8936002)(8676002)(36756003)(40480700001)(478600001)(5660300002)(86362001)(40460700003)(4326008)(82740400003)(41300700001)(316002)(7636003)(70586007)(70206006)(356005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 09:35:15.6379
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 566222fb-4453-4005-31d7-08db6b285420
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1NAM11FT115.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7430
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Mingshuai Ren reports:

When a new chain is added by using tc, one soft lockup alarm will be
 generated after delete the prio 0 filter of the chain. To reproduce
 the problem, perform the following steps:
(1) tc qdisc add dev eth0 root handle 1: htb default 1
(2) tc chain add dev eth0
(3) tc filter del dev eth0 chain 0 parent 1: prio 0
(4) tc filter add dev eth0 chain 0 parent 1:

Fix the issue by accounting for additional reference to chains that are
explicitly created by RTM_NEWCHAIN message as opposed to implicitly by
RTM_NEWTFILTER message.

Fixes: 726d061286ce ("net: sched: prevent insertion of new classifiers during chain flush")
Reported-by: Mingshuai Ren <renmingshuai@huawei.com>
Closes: https://lore.kernel.org/lkml/87legswvi3.fsf@nvidia.com/T/
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
---
 net/sched/cls_api.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 2621550bfddc..e4df96e133cd 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -659,8 +659,8 @@ static void __tcf_chain_put(struct tcf_chain *chain, bool by_act,
 {
 	struct tcf_block *block = chain->block;
 	const struct tcf_proto_ops *tmplt_ops;
+	unsigned int refcnt, non_act_refcnt;
 	bool free_block = false;
-	unsigned int refcnt;
 	void *tmplt_priv;
 
 	mutex_lock(&block->lock);
@@ -680,13 +680,15 @@ static void __tcf_chain_put(struct tcf_chain *chain, bool by_act,
 	 * save these to temporary variables.
 	 */
 	refcnt = --chain->refcnt;
+	non_act_refcnt = refcnt - chain->action_refcnt;
 	tmplt_ops = chain->tmplt_ops;
 	tmplt_priv = chain->tmplt_priv;
 
-	/* The last dropped non-action reference will trigger notification. */
-	if (refcnt - chain->action_refcnt == 0 && !by_act) {
-		tc_chain_notify_delete(tmplt_ops, tmplt_priv, chain->index,
-				       block, NULL, 0, 0, false);
+	if (non_act_refcnt == chain->explicitly_created && !by_act) {
+		if (non_act_refcnt == 0)
+			tc_chain_notify_delete(tmplt_ops, tmplt_priv,
+					       chain->index, block, NULL, 0, 0,
+					       false);
 		/* Last reference to chain, no need to lock. */
 		chain->flushing = false;
 	}
-- 
2.39.2


