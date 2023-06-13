Return-Path: <netdev+bounces-10537-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 31CAD72EE6D
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 23:56:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 283931C209F6
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 21:56:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D593E3ED8F;
	Tue, 13 Jun 2023 21:55:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E3917FE6
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 21:55:29 +0000 (UTC)
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2057.outbound.protection.outlook.com [40.107.21.57])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 968E62118;
	Tue, 13 Jun 2023 14:55:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V83ssJ85rrFgGEBkN/FbKPc0mLSP8QYzvRZLpBoAWk225cq1qTvoBcIlx6WHq44eTyQYRj1ueaGihlq7cvYCLb86NKbSz+AhCwCujhQeUG2gNBLmzCfVPJjUzZlWpxUoJfqE009MPQv/nw/tPy3I0rSh+79djB3lkfn+6Tfxm3iUunu+thODA0VylklUZMvjuz2qV5/ube9PD5z5dKrFvC97f2IeRB7FFhs5lmxQLGHtXbMQt4OCG8V64mz6UJjlU+o5AkFCNpjlzK/0lYQ+NhVSF/hirsasd942tHvaGxjmJ0WmK9UHsw64jPhGkoCYWvwwhn/beq9jZxpuLRJ7WA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6SmBY9ThK2Z/s95Jn4Ig3yijmVeSyN54LUDxWQlFZtk=;
 b=iIpP2rc2QoOWEcJdb9BTwMdGmCRjy8ozRUevaKSTcTgybbS6azYCisbpWJhNtZH26zoEGSdvOXnLOIXWYXKldveYdpPUy+5sriA8KcVz0LVO4TMZcryQpYITORrCPmTtM8vUb/jSLV0Vp2/fJ+ZnGKjEL5hilB4iLD2T3TZ3CmOJTMs+oj23sHsxTaSyUNQKVu48CYlUfBiStt9tXTQXMbVtGqqovOeMI44LICGtACxBzvZiqtTkosWank7zfz3AzYhvuQ9zAYre2mdX+d58AEe0DtRYgYcjtbzq/yV4QHR3QalfsuYlvYOKMQdSA1XEMj4hnbM7RWH2g5P2UnsDhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6SmBY9ThK2Z/s95Jn4Ig3yijmVeSyN54LUDxWQlFZtk=;
 b=qzu1Ltyb4yEA2Sy9RPrCkZwhjTZiD0xEOuZ/Fpa5ESk6ScG33wnqrwoobndBS0DFR97FwhHkZ1SGRHiAwiXWtSYpg7Hkdg7OAsNrE3JLnqR1jk4WECwLC9jiC0GUGOhHE6ckfPBmrmZe3q1xkG269B7WmEP6WbbQ4jgqT+ikXEE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AM9PR04MB8081.eurprd04.prod.outlook.com (2603:10a6:20b:3e2::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Tue, 13 Jun
 2023 21:54:56 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::c40e:d76:fd88:f460]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::c40e:d76:fd88:f460%4]) with mapi id 15.20.6455.045; Tue, 13 Jun 2023
 21:54:56 +0000
From: Vladimir Oltean <vladimir.oltean@nxp.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Jiri Pirko <jiri@resnulli.us>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	linux-kernel@vger.kernel.org,
	intel-wired-lan@lists.osuosl.org,
	Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
	Peilin Ye <yepeilin.cs@gmail.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	Richard Cochran <richardcochran@gmail.com>,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Maxim Georgiev <glipus@gmail.com>
Subject: [PATCH v2 net-next 4/9] net/sched: taprio: delete misleading comment about preallocating child qdiscs
Date: Wed, 14 Jun 2023 00:54:35 +0300
Message-Id: <20230613215440.2465708-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230613215440.2465708-1-vladimir.oltean@nxp.com>
References: <20230613215440.2465708-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0044.eurprd04.prod.outlook.com
 (2603:10a6:208:1::21) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AM9PR04MB8081:EE_
X-MS-Office365-Filtering-Correlation-Id: b75d9ea6-635d-4cb0-9288-08db6c58d361
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	wpEqW+o5mMxPdJ8PHA9+t3Idi3QSn8vjDdTMSHBCVWuGYTKUWb8TL4EoRsjpqkV4Kd/lDMlnJwa1eLEpPlFsDWOq2w7QmWf0yMCg+u7gzoWcjJMyEY+532g9rA67K0Sf8chQ+zl9mcux33ExW3RI8RdJ8RY53BxdE4U93vzyiUg/Wmxd8v1WaOR3GJuUZP7q/NV3xW5wxV846rqSaZO1wStWRFd7jPxhpWBcx0yR+Iin3v8p703JYzD13DajGL46Y1DBPvlIHc9gtpHxmiIjwGNsP8XC5w7ISu9QFsGJsgZO8tBt0gwUEMBHphyL+vOyfOh+VK+bgj3i8vIkeGijKj+EdsdQWORFMXvAUdwAE9vXH0EuZHCmoZkN4T4f1CYzxIHAnvQZQjacVyhjbN8JYSeT6+hqI4mhVEaF8g+zImyC7RB6c/9TfhPogvTAnQhqkQIdLk4pAdyRRAbsSiwN7Y66HM8zKK2g219NRTw9Qb0B88ms9dU4ep5uiblWo+JZwqvxaPMkg3x6J8lKy8pa+WWCmcsAl8PzBN156n48cC1Pylb0jyUmsQxKpODXgVyRNqhFIOIxH4nO+J611OQ8Ha9gMmNxvFRJWX6uxw+8fFKx275GRvxyNFGI6WMbucYA
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(39860400002)(366004)(346002)(376002)(451199021)(6916009)(66946007)(4326008)(66556008)(36756003)(186003)(54906003)(478600001)(2616005)(2906002)(66476007)(8676002)(6666004)(316002)(41300700001)(86362001)(6486002)(7416002)(6506007)(1076003)(8936002)(44832011)(83380400001)(26005)(5660300002)(38100700002)(52116002)(38350700002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cwB2oh83J9gZYGfsweQ1lIcuhgPby99P0NI0Ufp+HOj32SFnBfUWu1vkexaX?=
 =?us-ascii?Q?2unCZjCgyvqU6gkRNdnJdvqaFtfOWYzmelnVQgS6NxIQGNJhZlA6CccKCecw?=
 =?us-ascii?Q?UI5GjhYxbu/OiPvSqoOqTTzCzN5y1y2SMQmS/tNJ2zw5eBa3gFj6rIxBQxwi?=
 =?us-ascii?Q?FcBRm7H9TvC8iFpABMEmvW+fv+nkl8PfdnPs9nCyry0Lw2sRLcgk2oMqYWRB?=
 =?us-ascii?Q?USPX4MkpVem3JcaxxCFZ0jQX8mFk3+QvUmLRK4LpUp7VfanNfv9ONR7g1KQc?=
 =?us-ascii?Q?CLF4CR/Bec3Cx/QVnGJCaNYBMn9QJ1sL2w85pq3U2snZV68PrH7pfhgoGnZR?=
 =?us-ascii?Q?giTAJ9QQVC0pewrQloNIQwjMqCLbOalDUHBs4DwiuGmUpckvYdYeiHRjLjXS?=
 =?us-ascii?Q?fxviKMM6LRsyN5NNIFe46ZLa7AuNxZVjrnZgkZweDZaR6wUoth/XhB/misD3?=
 =?us-ascii?Q?CyGb1LU3L4CElPE+vTOzQMlU3IYtcpXqndMrprUTmzMbvFat50KKu8Wh9xUD?=
 =?us-ascii?Q?swQrSABOU9aPPu5epfeqLwL2Qjqxmoc4+omWNVj7mnwZ5el2IlWz2jYv0lsF?=
 =?us-ascii?Q?/wSS8vRaJiulhR+HIU/9UjDkQ1V/0Cj88w+nVkdi7CJD8wYBcjaQ7CwHYqYf?=
 =?us-ascii?Q?gij3QTjW4vkvQK8wzxvaRNOv0m0Xq95efW78sLRDNA4vyXauf1PG2Zhb5pOe?=
 =?us-ascii?Q?jhGiAjES8qnUKHnDs31/LpIBINMMvI5+rA8aYz2r7GbnWUhd0ULMejY+1iVP?=
 =?us-ascii?Q?AnvHrp5fBDph9ZEyMyGwet4GhotFtWv5EYz9WT1cYz6YgB5EMUyeiMdU38Cs?=
 =?us-ascii?Q?cN0FLeu3eZYW7ARhPKLUMY2Uj067Q9xbDHU7HNKxExIvSyLtZ3bQl/i43qhC?=
 =?us-ascii?Q?iTZsiV2Hg8WcfoK0g66IKG57fUIwiuKY4JrEfhqTLi+YdQb2ti7UaE0ASnHt?=
 =?us-ascii?Q?5coaWywGnhEMuDG0ybIqPyxFtBfqIgpzbQgjVlV0nS0/5ML+OUxLYv+CJ/H0?=
 =?us-ascii?Q?jg0QHCWotk2jkXC6pivTSK3PUkVSmwwGnjWt7LakCJ2Rst+xHryYRSGT1cSV?=
 =?us-ascii?Q?jFWJl6D1rjkbohHHYgbYe+tD7B3QEUED92m+6txHx5rfObxuZk/h7Td/Rtzl?=
 =?us-ascii?Q?lEEuz1/dNC034epYXIg9BqPgrXBslc+qSgTXxEswG1A1qSE0w5/BhZTZUwMP?=
 =?us-ascii?Q?1ByeGTfUpPAXpnPHm46EOmcYnA0zC1NNMm1bAKtx9h1Awgoy8EnccqN+Upc+?=
 =?us-ascii?Q?iTJ8mSGycI8WbzECLECYQufMrvoclqPEcSWccrKJqv/C4ZoJnmFkGa6YDnP1?=
 =?us-ascii?Q?6UNLTnRtXFvbDmKOgd7JuH9e8AoZKiqOpjd1KxUnxRWwyOdTZcf8VN7qg+HR?=
 =?us-ascii?Q?YcapUXaR6AofLpOqkjES0XMWP9MSKvN/RkpLk4Nxk7tiy2JihceAgcvMfn80?=
 =?us-ascii?Q?kkuSK1NISeo4KbgzjhR+NK5DAvDmb9+EnjqYei4qhzxHASIj8AJFBVye76Dg?=
 =?us-ascii?Q?yoHwvk594smMqQ/jinSZqwFzioq4GJSuuY9q+Jf0vfxaF9ila6J4WJDZZG4O?=
 =?us-ascii?Q?IQhuL7LjUGYW0uec2U3a2sCcLhT89aFAHJiYoQSqG22d0qRJDG1QzYomgdVs?=
 =?us-ascii?Q?6Q=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b75d9ea6-635d-4cb0-9288-08db6c58d361
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2023 21:54:56.3762
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8IsLzGqMTTVFQgBKDmSaCMeKlO6ohyioGRpLy6bWyJaFOhZGVPAc+CXfFvae4AI9xT12UswM4jgg2Yv6JdgtDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8081
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

As mentioned in commit af7b29b1deaa ("Revert "net/sched: taprio: make
qdisc_leaf() see the per-netdev-queue pfifo child qdiscs"") - unlike
mqprio, taprio doesn't use q->qdiscs[] only as a temporary transport
between Qdisc_ops :: init() and Qdisc_ops :: attach().

Delete the comment, which is just stolen from mqprio, but there, the
usage patterns are a lot different, and this is nothing but confusing.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: none

 net/sched/sch_taprio.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 14d628926d61..c35e27d0e49e 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -2085,11 +2085,8 @@ static int taprio_init(struct Qdisc *sch, struct nlattr *opt,
 		return -EOPNOTSUPP;
 	}
 
-	/* pre-allocate qdisc, attachment can't fail */
-	q->qdiscs = kcalloc(dev->num_tx_queues,
-			    sizeof(q->qdiscs[0]),
+	q->qdiscs = kcalloc(dev->num_tx_queues, sizeof(q->qdiscs[0]),
 			    GFP_KERNEL);
-
 	if (!q->qdiscs)
 		return -ENOMEM;
 
-- 
2.34.1


