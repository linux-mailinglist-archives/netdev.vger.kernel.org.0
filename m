Return-Path: <netdev+bounces-7383-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CE24B71FF87
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 12:39:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 827E02810FD
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 10:39:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85BC2101F3;
	Fri,  2 Jun 2023 10:39:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7417A107AD
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 10:39:31 +0000 (UTC)
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2044.outbound.protection.outlook.com [40.107.20.44])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44C96E63;
	Fri,  2 Jun 2023 03:39:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FQvpGxnUBVHAoDtVVqifZtfl/7hs8N0Iw5EQWCehdnRnGywMVZgxj/jVTku2WLczB/yjkbRA7UqGlGkon8Gc+njHglGQk7FDkEMf9svaTdJaN8tRNDz85BHhoJ6AW50JppaRVTiEInn53ZUffg/N2hCsERdBfrR0gdWAiejWR13qBlf5rELNa8AimxbfmVbBheCXSp6l1moxRg/tUQCPX7GHsCBQirPVPECHF6KUSuc/K0iJo5t/CVZqDAjRhZL9ysWiUMTeGeRdmK3obdKReACJJDspTarjyNG0nIjO3JYonWsRw5mZ58YI834ZbmmyaRQ/jJ2oyLs7bHaGMGJxHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H0MGORJcCTGs5zbRwB6zqDXpNBFUcyabH8AIGWtnHX4=;
 b=Q2oKR0nTKh8voHDPGqdzxuUQv3ix5PTH8dBbY0hhzZ9I5BZZFm078zaxkPWQVFSqOm3ziBBT6J4tlCWtaxAuc88N7W/+xvZ+7OEW7mAkeaX4NIKcdBzWDyt4Ty8kc1HA/UOBfAGHMXK8Mt3EkYmE/w1eD1MvM0SX9bczsJleq53iVcXlZ0a9zdmc52lqppos/nZb3WP3LLD1uPXh91ZqYHFd/lg7ULxLbic78Zj1k26se4ycj+pyLnESlzxH8IZk1Ij9Kb+uHQhYXpyRuo3qbk+DbyWTeV69NO6nRPR85e4DGlhP5dD5oWbSrx05M8ZI1WqPhsKsxfwcOjfHy6rYfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H0MGORJcCTGs5zbRwB6zqDXpNBFUcyabH8AIGWtnHX4=;
 b=rRamzo1CT+4YLXO13F44dBl2rwQp0LnZdqAB6si2bZEDCcvRx5ba4nyzyp4Z+tUsg1OcP3kfVqSqDWQo4D1vlprGeBpZafKbTGYu/VBTZQTqmjCq5MmWl2QsBy9DnvXEhSq7aTudD6N5gbYyb1A1geSuNwfSDi0HgAw5DWovxSw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by PAXPR04MB8926.eurprd04.prod.outlook.com (2603:10a6:102:20d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.24; Fri, 2 Jun
 2023 10:38:17 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::47e4:eb1:e83c:fa4a]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::47e4:eb1:e83c:fa4a%4]) with mapi id 15.20.6455.020; Fri, 2 Jun 2023
 10:38:17 +0000
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
	Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH RESEND net-next 0/5] Improve the taprio qdisc's relationship with its children
Date: Fri,  2 Jun 2023 13:37:45 +0300
Message-Id: <20230602103750.2290132-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0095.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:79::10) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|PAXPR04MB8926:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b29d556-4d77-47a3-a55d-08db635579b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ga9Nm2SAeU7fW+IEYDOM4lteH7CXYCl1Parx0pgXu6vTUbLAP8GTO7ZM6EPrhUSfgIfNW2yyGbLyKaw4MB7XHo8W/ZcJkIjSrhO6YXn8u2uvgmKw83/n4yyWql6/LSbswla0Xsk9cD3zvhsqlTHoLMgRdvWcmY/QFPw8YEJV/VYwIjH1+/aFye8mVXYNlB77MSBxx84CiXlhEjQf6drWHZKNKW58AB0L5Ob6wcJLWnkFIkgUcVy/QpvAEDhvHmDk5gY4+Q5F89WZ1arwiot0p+kTzevmPKQCqPYYTU4dx8lEspvzLOtK4+UENLyY7qOFr57etPWjpSv16h0Eefp/e6Nw9+TXSAZOQ83EJRDGbfowXrP79xwkW+w7k1vqFUBqZ3SlY7AnpSPYgsMzDBkJ83dcWs7uVMUKdUtVSGFQty64y563WY7UKZHgHCNfREbpHokA+AC8Rdu29yUUi2l1qxsRNarFHulbqYF0iihykao8bmWQHb090a2n+inOTbvC5xlk208/LGhmHW5H+CJxJIg6AxVOwO7TPHsgBPBYY+2Da592smd9TmFYueym3HjFpdyNGv7qUpXEJcwfYAnH9uQ5WeOAGrgQtbiFPQW/6CY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(346002)(376002)(39860400002)(136003)(396003)(451199021)(8676002)(478600001)(6506007)(1076003)(26005)(186003)(6512007)(6666004)(966005)(52116002)(6486002)(2616005)(41300700001)(83380400001)(316002)(2906002)(44832011)(8936002)(5660300002)(7416002)(66476007)(66556008)(66946007)(6916009)(54906003)(86362001)(36756003)(4326008)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6J6+iuRlUQ080NeWSZtcHEqBrVdDdhKA5tvsWTbNrU+99rgBZ/B22GpKJ3DE?=
 =?us-ascii?Q?IUwgcj+KAeLWibt0y6Zqw967UJ4vfUfroq1IOP+5dr+7d1TP8rhfEafqZ9Ac?=
 =?us-ascii?Q?g27pJC6qJuBVF9KoGdeTwQdu8Ot6aRMNy5qkDYJef741+yE6xqw4/FevNRXa?=
 =?us-ascii?Q?h2hyutgg2kwIPMWUpeOz20mJnYwToNcu1cQ6nDr1wSLfcJz4xsWpQzn6e1cZ?=
 =?us-ascii?Q?Oo81/8v3+rzfB8+2zaXqWxeO7EkdXmhPEJ3TMlLfniMFe6dka7kVweNwrBQM?=
 =?us-ascii?Q?H4BpOHLuOQI1G5AnvRtttgx93fvPJ8h+y4xVZwHm/H1ITz18GoLf7340QrmR?=
 =?us-ascii?Q?NCOZCnxfgE5n5yGakq5WziSKtOqbOHq4Iy+a8cCeZeLbz2FzRlw+kXoKc2qb?=
 =?us-ascii?Q?X/EhpSEHrYBoYu3arpEKPRGNOep3fUnj+WysG8QCdOgiALn6AQoN+PEg4XKh?=
 =?us-ascii?Q?MT3cyTgvNgY3iToQtZMnwdI3zSqtFSaG0EohaeJ/sXWNEvG8cuDZqdKc/Law?=
 =?us-ascii?Q?lu2qX9mKyzVp6hmLn7t4XMtoLlBvqEEK4LVyceyUBJjG1E5Hjbk3Cb6vsneg?=
 =?us-ascii?Q?8IzUguNVcHULyi/Wx+zaBD8tVXZ06qaQ2813FYGkEvbDtkPj/M8r5noPyYgq?=
 =?us-ascii?Q?rm6sYxzVF7MREnF13CuJrZtgpcv59yut0o8vX+MK3lZwKXj0MbpUx5+o1xJo?=
 =?us-ascii?Q?G+opErLThXuf6mgYzDPrt6lJ3EdITddlpSIYrPKjn2VYur6BeQ+uCXp0Ufhm?=
 =?us-ascii?Q?o4ejyqvaZ0Y+1YaAPhnhQxhQsqH22UGbkNxOksQQY1MBiSUmjBF7PHOhPOfN?=
 =?us-ascii?Q?oHneD/DsJys9yV4vmTgQrl01yflp95IVM4Ou1zYqdm7+FrhSlQcScWiiDJJ6?=
 =?us-ascii?Q?7OY4G5Jx3wlTZA7ebdVUdG9WORApFnBwvfpsaWK30PE9hrt0N9qYQeR96nTa?=
 =?us-ascii?Q?hSv4mDmrAKPthydAQT7oXnOJO0EH6sqvzn6cr45gKDOf9JSOz5UxeZMz+Lqc?=
 =?us-ascii?Q?mKP/7FBiBcRe/FeG/BpmR7ag5i44EnDwM0KZTZdJU5x1ouMvRfBKLbs2fm3r?=
 =?us-ascii?Q?COE+fMOj9UcgW3TtWKaor6IGNJyxrBxg3+uxlZ4MyGKY78f4RuQSF8XumGfa?=
 =?us-ascii?Q?SIDKoMLko8DSMQBWuIeQcupuDuhLVXVwIuoJvvV53F/MlQiKTPLNXwNOlQXn?=
 =?us-ascii?Q?KP0ZlcwKJqEykpa9k6HgX+xfWBOIhjmsMhN4YcrtNlDBDvcUo6M8gMrWd6lv?=
 =?us-ascii?Q?CYI6U2mx8cIrooxLAUADFQqEytAi+rRtSmSSaizUj7VAUyZmIVdt41NABjhR?=
 =?us-ascii?Q?QDqYkqdnHKIkTQjrk77BSPNGdHmQYOuGm1ZgdxVPFmASJr4e9YVM1WY8wW5Q?=
 =?us-ascii?Q?h5t3XpKteL/uGXZLbOCvhgi7p0pNO73vC48DN3jlp636O4p64JR1shBgkJaM?=
 =?us-ascii?Q?X0dAznWDQEcbQ6uakmHuak8+8PzqbcOxp3ilDMTvextqwHqye/rVIE6xlOHb?=
 =?us-ascii?Q?+sUmu4A4xXsXIglcuDoYcf+Lt3WaPnWxsdbEEi3PCoN5bBJqwaxxsvjN+Kwj?=
 =?us-ascii?Q?zGYyitO4mf5OOYFoJP0YcGp5DY9M/V9oz2io1IflyGXwA52OTNJAalLRCHpQ?=
 =?us-ascii?Q?4A=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b29d556-4d77-47a3-a55d-08db635579b4
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2023 10:38:16.9814
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qFgIYnM8vOsm2Ot6d4/zbI9XchE7DyKjinFoHIRbvbSHc9mUCPzxcrZbZ98VnxGKZ1J8Oq81FfsVDkCVjpLWdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8926
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

[ Original patch set was lost due to an apparent transient problem with
kernel.org's DNSBL setup. This is an identical resend. ]

Prompted by Vinicius' request to consolidate some child Qdisc
dereferences in taprio:
https://lore.kernel.org/netdev/87edmxv7x2.fsf@intel.com/

I remembered that I had left some unfinished work in this Qdisc, namely
commit af7b29b1deaa ("Revert "net/sched: taprio: make qdisc_leaf() see
the per-netdev-queue pfifo child qdiscs"").

This patch set represents another stab at, essentially, what's in the
title. Not only does taprio not properly detect when it's grafted as a
non-root qdisc, but it also returns incorrect per-class stats.
Eventually, Vinicius' request is addressed too, although in a different
form than the one he requested (which was purely cosmetic).

Review from people more experienced with Qdiscs than me would be
appreciated. I tried my best to explain what I consider to be problems.
I am deliberately targeting net-next because the changes are too
invasive for net - they were reverted from stable once already.

Vladimir Oltean (5):
  net/sched: taprio: don't access q->qdiscs[] in unoffloaded mode during
    attach()
  net/sched: taprio: keep child Qdisc refcount elevated at 2 in offload
    mode
  net/sched: taprio: try again to report q->qdiscs[] to qdisc_leaf()
  net/sched: taprio: delete misleading comment about preallocating child
    qdiscs
  net/sched: taprio: dump class stats for the actual q->qdiscs[]

 net/sched/sch_taprio.c | 60 ++++++++++++++++++++++++------------------
 1 file changed, 35 insertions(+), 25 deletions(-)

-- 
2.34.1


