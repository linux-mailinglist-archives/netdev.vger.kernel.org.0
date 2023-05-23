Return-Path: <netdev+bounces-4637-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0350C70DA58
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 12:22:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 36D7028135C
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 10:22:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80EA71EA82;
	Tue, 23 May 2023 10:22:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E1F41EA7C
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 10:22:31 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2112.outbound.protection.outlook.com [40.107.244.112])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DCAA109
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 03:22:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jkI7j9B+d7bpr5NBB7S2hFRlYa7ShDoDmlskFm0PcioClzq4b+5dVpUhQTE10FbSNDl1WDV/Gr647bUS3GUYBct7YkZxOTC63E0EoFYjDJID3CmKrFIw/DQ2vXeT+mLYOBnSCaYmg3QJd8TGmdNVU7ktxgU0CNO5rR0lAfrRJXMr/07YGjAht0QN9hXyUjspQmcpCI6UAIig3c0pK1ktV5jAYcbMdWRfyGoEB4rz8aIDjRZkIQjzzB6faAJziSCQqLUqhG1Yfhtjseqc6acJm22aFJGjiyP8GvhujkFeEV+gI7Rtfn41A0KU8RstjXBuZLbby48/cYSkjYcqj+D2Cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EkyYzBLVYodcTWha/fBRBd30NewaVLy7UYg8YNOjNsY=;
 b=ng4alHbCydNEM/ovxx0v0G3eV0NpfEVDSpyRUgI3G1Q7LPaiTjTnjmHy9zOtkltUhF21Hmonelu7ToaHPODR6SV9tu5fkFsHtqQiL+YovdQJzhAKxvarKvfPPknQEFwrMIR1UbZFxX5F5nDf9YDDcaF8VfhYA1M5tHnyRg4jB/KSgghargUYFPnxWfoj0Bf0vHOvIf4iX7CBCETYJ/GQmLcbappy3q8cijXmt0wQ2eYFMCbb9sPRF28Jb/YGK/a9nE3JGrezzVgzdvjOhqf8+acFuRQoTV5VeAETN44jeEcEJrNlo7NpzUzJCzzmMz2C+YK6HLfDYV0B62UFf5IfZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EkyYzBLVYodcTWha/fBRBd30NewaVLy7UYg8YNOjNsY=;
 b=g8MUh0MlFZlQ0J/9TpIuiStI/3I9wXqnflLIMu6q0KC2CCKnuyZVIcWYCPLbS3BAWPFGSgUR6bXVDBVjtMMjrpiZzk7w467Fh1c8CIH13hW9CSVu0mIffl5RziDnfaSO6T+vkBam6JbTjCWgM/ZwmqGux8iqYpNGG/rWdF3TALY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO1PR13MB4775.namprd13.prod.outlook.com (2603:10b6:303:d8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Tue, 23 May
 2023 10:21:23 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.029; Tue, 23 May 2023
 10:21:22 +0000
Date: Tue, 23 May 2023 12:21:06 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Ziwei Xiao <ziweixiao@google.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
	Coco Li <lixiaoyan@google.com>
Subject: Re: [PATCH net-next] gve: Support IPv6 Big TCP on DQ
Message-ID: <ZGyTkjrvCIQozPUj@corigine.com>
References: <20230522201552.3585421-1-ziweixiao@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230522201552.3585421-1-ziweixiao@google.com>
X-ClientProxiedBy: AM3PR03CA0072.eurprd03.prod.outlook.com
 (2603:10a6:207:5::30) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO1PR13MB4775:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ed2207c-a4b9-466b-aec4-08db5b7774bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	9bRUbp0ixAncrFsNsUnfOelWkXzOlmY0U62k1gtx8AkYg/88N4YstP2IlDUwmRBmOG2rp0pntYSXo/1sZ9tNg4KtKEZVDG7DYwEqzaOzzA47Vj3Dr0MiGA1l2J1zVztComPqWs4+kRlaICi94ltS9aRqKCQpPqWUAfVos8CaMuN4A/5ldUQa1bl79Fg1P0oiu2PbX7bWhPDFdGSSTtP1+oHmoc2xlw100FTVIhL+jBcwda0VFydtbXmkUP5m7iv74oEiYCSxgiT1SHOKi7dS0dL+DJMHso3Pi39JwYy7X7FTvb/Rw6+6MzBPc7xH3rW9z989H8gxXW6NwYsZsCAVChF21OO+v+IrAbYvmy1MDP8xZAoblEKm80fypPgSzBgRTTfTydf2mMqEvrZ3bEPZGEO/V+sKKwVlVhhQ3OGbyeZKY4e8uxAXgGbrSILKKwBH+k0SNKanWJEf7yPDfH2+Yq2r5/1x9TluC+o2YGSdYKASckofWlDKxKtdyDjQxPOlWuMUF0aURDNqADiPrON4z3nnmfsPYUj5y3Jiry27sGU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(136003)(39840400004)(366004)(346002)(451199021)(6916009)(4326008)(66946007)(66556008)(66476007)(478600001)(86362001)(6666004)(41300700001)(6486002)(966005)(316002)(5660300002)(8936002)(8676002)(44832011)(38100700002)(6512007)(6506007)(186003)(2906002)(36756003)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0Zx26zK6qEhOBheSuKVinm8TGTFX3+Ilfyat0rok7Y4qio6ElcKZSw7DVw7a?=
 =?us-ascii?Q?3XXtmU8B/6VxBiu8MDnu2MWy+YE3qcITz+lHFyjWhlnZQNiEIeGVOE0A7alJ?=
 =?us-ascii?Q?aeYxdZuD5ZWp3EQGI7Y9Cs+oXK5vgMqIiLEQ1ZJ/0fZ7vea9EnyIbXc55pmV?=
 =?us-ascii?Q?XgAgAv4IiWyOzHidys1fjJFwg2xIySvCrR1Vz4oPBMA1KIvAEb4LL2KqPNYv?=
 =?us-ascii?Q?FXKrSTHmEep7/TrRnz+lYz9Oqv8RcR6FLUx0DXDqCrDsR3rP2r9m3fUOO0TP?=
 =?us-ascii?Q?Djxsdpz/MN86DY8VAv/aJKZXqZGgEVmuW0avGFa7cN0egAdmbkhBcGXEn4gy?=
 =?us-ascii?Q?QOutSj3ZXbz0n0XXwtEmrWar0CicEBPbA+gcqHEXDRe/y+U7+FtGoJy3owxv?=
 =?us-ascii?Q?5KIbxq5jr2K8IoNyMEQ1vfonOhEcpJwWwtt160vEiVPn15GmJw5Q77bbS3uj?=
 =?us-ascii?Q?YBL/+z4ehjhahc8qVfMl6P73ffc6R8OGBM6P69aWCFwZJoqpJHe5qRIHHWUS?=
 =?us-ascii?Q?IJhCl9qLLOoTQxjRolmHY+2ZM5fpyRBA0npezxbAdQtRYUMxQ2LYekGmrYI/?=
 =?us-ascii?Q?V2T34kXXnMXUcr7ZaHOfkl18859eAN+2Y6dqfKGNZAlVUa+bWIusFErenK1F?=
 =?us-ascii?Q?5YkSFqyuXmRI+cnrlsoY8Otk9sxeLwM8Pn8afTa1l1P945D9I0PpqxK7lpxw?=
 =?us-ascii?Q?BLwwpB9Wi7LA2bR3BBmZUbtc5M7i6iIMDRvw/JjHBOqOcbN404MWHBNMRR9l?=
 =?us-ascii?Q?slt54ICF1MVXrhr7wjbjwPorIPIDuXowfX9MgggiZEPN2c1Bua5NAUoIXUWV?=
 =?us-ascii?Q?1kRnctlr/dhXhuaK7aXNV23ireAJbG2Bl2yra7Fnj1XRqam3cIvfNWZ6XB6B?=
 =?us-ascii?Q?3PQBBfG3tminxD3/UREW/Cvq7xuzQd3IMupfrUylHot8J5fVIEabASQp1C/c?=
 =?us-ascii?Q?STD3OUKZuT3ktqBuw5DP6n63g3x29elAmRJTTJ4Z54cTvjw/gSmF+yAqboHz?=
 =?us-ascii?Q?LN/sTuVkP1ycBrRGs3Oawo9wd/m/aDCst1/yTClH/VBSTKudAfBr6bAwpYjF?=
 =?us-ascii?Q?e5nKcvbaly6yDAMjG82AMyGTl7L1SOyCq6VgXd1ZQYEbAa8w3E0wtZvHmjPm?=
 =?us-ascii?Q?uO9/oto0z5Ma2QROiy6Z1RdKAhl1X/YJqAooBuvGTulxHbvYdQTHGkzBuv3u?=
 =?us-ascii?Q?77A9IqRXTI4SZia7v3XP/BBMCw85X91EMMKW1rgTVk6L9S4n6b4SLGd/CPZQ?=
 =?us-ascii?Q?Cm1UD71C5+IxxqtP4IdZmPQt9ahO6e8Y0ciJRTpvTG1IPpOoCr0g2lk6l/gU?=
 =?us-ascii?Q?F3G+pJUt+KgiCOxRZBDVe1wrZLy4JYrV5Cmg3x6DkojIstrPySb2YbUrUmaf?=
 =?us-ascii?Q?F3QWIH84Eez69cBPDcL40wtAbThCOyX4pjz0p/6vUZ5PJi23J2oVsUymhVKl?=
 =?us-ascii?Q?Ed02dIU45KdIgADI5BcseIyNhGkvz0WZ0Jsrf8bX38zzcaeT02Z0CjdVu5im?=
 =?us-ascii?Q?/4VSrzqDCiGMji6WCzjQt/VpSplwzvFMgtLdjn1QYu1ArnjmdSIOP+zGORo6?=
 =?us-ascii?Q?TKlur8wP2ZbOnjin9xSw+tuszdaY9iksqdwEM3Et+SO9LuxTjqVHV6ny8grz?=
 =?us-ascii?Q?cZPXSKXz536jzFzedXiWEpxlrnKrTrMUwa5Jg1BYP9Qh68QWy9iHUbnMocXC?=
 =?us-ascii?Q?Ty3Wng=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ed2207c-a4b9-466b-aec4-08db5b7774bd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2023 10:21:22.2332
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gNYsz2G+vL1NVVL6SKctzkNSyiyiU2/v+nSUL+rvOhAYmIBpoiVwVqZRKX/QdNcK1BLpuVNRx2dwAR/vwauxF8ynuQYXwEv2Rb3vcL1qGDw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR13MB4775
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 22, 2023 at 01:15:52PM -0700, Ziwei Xiao wrote:
> From: Coco Li <lixiaoyan@google.com>
> 
> Add support for using IPv6 Big TCP on DQ which can handle large TSO/GRO
> packets. See https://lwn.net/Articles/895398/. This can improve the
> throughput and CPU usage.
> 
> Perf test result:
> ip -d link show $DEV
> gso_max_size 185000 gso_max_segs 65535 tso_max_size 262143 tso_max_segs 65535 gro_max_size 185000
> 
> For performance, tested with neper using 9k MTU on hardware that supports 200Gb/s line rate.
> 
> In single streams when line rate is not saturated, we expect throughput improvements.
> When the networking is performing at line rate, we expect cpu usage improvements.
> 
> Tcp_stream (unidirectional stream test, T=thread, F=flow):
> skb=180kb, T=1, F=1, no zerocopy: throughput average=64576.88 Mb/s, sender stime=8.3, receiver stime=10.68
> skb=64kb,  T=1, F=1, no zerocopy: throughput average=64862.54 Mb/s, sender stime=9.96, receiver stime=12.67
> skb=180kb, T=1, F=1, yes zerocopy:  throughput average=146604.97 Mb/s, sender stime=10.61, receiver stime=5.52
> skb=64kb,  T=1, F=1, yes zerocopy:  throughput average=131357.78 Mb/s, sender stime=12.11, receiver stime=12.25
> 
> skb=180kb, T=20, F=100, no zerocopy:  throughput average=182411.37 Mb/s, sender stime=41.62, receiver stime=79.4
> skb=64kb,  T=20, F=100, no zerocopy:  throughput average=182892.02 Mb/s, sender stime=57.39, receiver stime=72.69
> skb=180kb, T=20, F=100, yes zerocopy: throughput average=182337.65 Mb/s, sender stime=27.94, receiver stime=39.7
> skb=64kb,  T=20, F=100, yes zerocopy: throughput average=182144.20 Mb/s, sender stime=47.06, receiver stime=39.01
> 
> Signed-off-by: Ziwei Xiao <ziweixiao@google.com>
> Signed-off-by: Coco Li <lixiaoyan@google.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


