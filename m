Return-Path: <netdev+bounces-2649-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BBA3702D7C
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 15:06:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 005CE281305
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 13:06:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35D8CC8DB;
	Mon, 15 May 2023 13:06:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D23C79D4
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 13:06:25 +0000 (UTC)
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2094.outbound.protection.outlook.com [40.107.101.94])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0457C2D58;
	Mon, 15 May 2023 06:05:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jHCNvg/oyRET117F+140mDG7eYzFsUNHWmHFMXLL6tZvUV3jKCcRcH7EG3Qbm4cWyH1L6EbCBQjBfN9JHesubITMMBIHVqM4jUy4Z72Lyv38Kx9YvSmKIP9uT1D9rJXXZAO0ub5nmWwv1Ly6ggIlAWCGC7O7B10OyrwrHq7bjM98K7H/XvvMcn1g16XO1W0fP+qiHTONC1u276ma+cyvsQwfzIcIhtd3VeTuZN3c8gsQ1n5RLO2IkDPYxlyMbFGHUpdPiogS1aRkRpueXgLs6OR+g7w+z1vZY9zCaaVEjv7Lw5IRTtOFxiXb2oGBhe1835u5qS/OdkV2jS0AMr+Hhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q1n9eL6RCvoOF3cxthSkXieGJ2W4xHwUjscKnwSIS1I=;
 b=Il/86AKcmBgLGTMhwYnLsKSWx1iFbc4WesXEMoLN4AnNnnYseE+gNUyESB1GnaG9LbBTyp0xp2WiWS00lBYKJRwUoeBjbZKY0yP/9gS2dyMOiznMe7Qe5WBrGK+8+SehwA7E+XotvZVPG3SWdwWFgrXu668vSBmmBeiBUo8ydyN2vpjn5WyORhWTVRI6ea/kSfucpse0xLhXOGwPAngYnwTxFaN+q8zk+bBI0FH2kImpud8zFn5pgkKModZCdrgFtS/L8946nivBzK9Olk0QmHbe8uFPZttURyJW2pARMM5cBH8M8Dmn33T6lULOGh2huUn0RwROqd95tAESM29cNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q1n9eL6RCvoOF3cxthSkXieGJ2W4xHwUjscKnwSIS1I=;
 b=vUEQsvOpE17rS24THJlmH12yghVKtRJsbJMJjTBMhb2gRetDR9Y/smwjO4jywz4oxkgmzonBUfypfIF1YDor5X9f58xg4yXq3Yy/mhiILsJcbFc9SeZu/soRvjVlXDIep78lXurbXbTv58cZB/sFIayIJAu0jfd/3833u7sXj+c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB6343.namprd13.prod.outlook.com (2603:10b6:510:2f6::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.14; Mon, 15 May
 2023 13:05:46 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.030; Mon, 15 May 2023
 13:05:45 +0000
Date: Mon, 15 May 2023 15:05:38 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Zhengchao Shao <shaozhengchao@huawei.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	johannes@sipsolutions.net, kvalo@kernel.org, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	jaewan@google.com, steen.hegelund@microchip.com,
	weiyongjun1@huawei.com, yuehaibing@huawei.com,
	syzbot+904ce6fbb38532d9795c@syzkaller.appspotmail.com
Subject: Re: [PATCH net-next,v2] mac80211_hwsim: fix memory leak in
 hwsim_new_radio_nl
Message-ID: <ZGIuImVBq+CTMs9r@corigine.com>
References: <20230515092227.2691437-1-shaozhengchao@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230515092227.2691437-1-shaozhengchao@huawei.com>
X-ClientProxiedBy: AM0PR02CA0029.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::42) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH7PR13MB6343:EE_
X-MS-Office365-Filtering-Correlation-Id: 2baaae22-1a8a-4d00-4474-08db55451888
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	pHz+0uQV+ACHEMmE7fEEXew3yRZS6VhzpOKUo4ButKhQfM9u1JHpIYb1VJO6rXWKxwX0E7Ti7LTZGa0htH2/DZp07us872andwFUQhVY09ycZjlSMsqmC+csBc5Rsgj/3gjkScqpHYtt4FXLdHgq5KbDdrm6SUD2lfnjKgkPudBIO7u8NEBL7/nlCeNm0NHG5D7EDfNngLXF9Fh9h3O8rxrjfPKp8xz6dJkt+HaQeDzCaFr79K1Y06eQND145hQmnE9DQ7lT0WNjhIjxShNcBFy1tNV6HdtvH53Z+8a+v1qYlpgP1TRlvbbjQoCm4TxecYcOIKhHdfbFgyh7bmlORTD+p7L61zenqfzcBY0pTQCqrcZhIhKj0yh5OzUBAZEFUPws8FIrYNho/BBoIFBujP9TJornF2H/neUzWJaoZJjZQLXvVs2AP91BiXcZTdkbLz6meZ9W2kQGvK3gQLlZxOtSd7PnhUIL2okhN+K7owmufQYKPGNMwQF0ifaIHK/1EaqDPgbhI/2cbcYeHRFcg8FyU3L3tPp13lzjjYEEJGRF1X/SQFZE84ZUUTBuZ2SrDo9DxRQQZj7dFuW7rWuyKAqkMskC6iA+WZmg/5Fmnf8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(39840400004)(396003)(366004)(346002)(451199021)(4326008)(6916009)(36756003)(41300700001)(38100700002)(6506007)(6512007)(6486002)(478600001)(66946007)(316002)(66476007)(66556008)(2616005)(8676002)(8936002)(44832011)(7416002)(5660300002)(2906002)(4744005)(86362001)(186003)(6666004)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?D7vn+Zu9AjRinJHmrpw5URNyWC4iSDq6iCSlzVYE+o04su5gNAMY+zOpffds?=
 =?us-ascii?Q?B5jSJrq2WPY7xByQodKV4vTw3spWkCDbTlbgEzlVvn9GRIUN4l5EgOHhs7u+?=
 =?us-ascii?Q?KeiOidT/2wtz0UFxuavVgNDRfCFmIoYHfUEy1IyulB184OJDx6mALVwCsNXi?=
 =?us-ascii?Q?quE9jUp2nB+hL16j+vOppvzDAKHYU2DcbR+ZML5yMJ/q2vteJUIGAkLAl1zY?=
 =?us-ascii?Q?P2qC27i95jEE2RliZSWjcc9VBb17GwMRhWWjMidv0zY/p/+/ppfzGibXhwsu?=
 =?us-ascii?Q?1zQsfqtu6Rxc6K645gG5u6dXqMYOEj2VI2wNUmp25wJ9aB7ru4kg2fXEhmZS?=
 =?us-ascii?Q?7StbOI9CE9kpxdBEbBz0eWxNZn/2OG9a4qHa5GunuOxOR4AEPTzEUDhiBUGk?=
 =?us-ascii?Q?n3nCUC1oG/Jq04eGmeVRlYkrDlHwkGSDr5YyS2VI/Fnn07rRsxYYbyIPVlcl?=
 =?us-ascii?Q?GTxEDORVT5CKMGB9Fa02sP3R+ACMh9Uy0ixnagu942RcSsv5MbXuchEJiGT2?=
 =?us-ascii?Q?BY8GpXZH+1PPB/6JZfaVVE90TA8JbOk1G6N+D42AGo4/CZdL5dkhTRHbTgcO?=
 =?us-ascii?Q?Rhmkh1v+du1w6uciQ59S0n0UwWPl8lG/rB+w2149zF60aDz3vqrJBsG1ejyH?=
 =?us-ascii?Q?h6/EEzSb0ZPjbkyX1p8JARL4hC9VJukHjNk3yjM/CpE/1CJVtszyvLacAx5X?=
 =?us-ascii?Q?ELNwjcTLdSxSM8KuqmV1qWZwwTWBJyuUSoN7XoPqQexiVqHsQNgNT5TuekBd?=
 =?us-ascii?Q?kpcRH3tMV9LYxgBVc2Q0V/ysuD0s45kwv6+E3Pe3ZVSQZkRnfadMsBpyfvgd?=
 =?us-ascii?Q?n3e3/tW7EskEXMEH3G+EGnZP/rsLBqN9r+CALI7fHTFED+I361VIQgnwZfJM?=
 =?us-ascii?Q?85R9AYUbZhhIrbMYAYNwX98GH+8tx3jXFHAesxvCOkL9Ha8ZLiuQLScfHtDB?=
 =?us-ascii?Q?1DuAAPe2tnvgG0jCtY1vkBFvsHYKKkuZWYZlSx9utWjcDim5LcLHCQB7yAiM?=
 =?us-ascii?Q?QwQPzPbggUzykUI4IqCwBSSC4ZQ/57znTrGB1hm3a2Nj9m/WwIfchsQS6vLS?=
 =?us-ascii?Q?V3X4rjzifZC2RiI+TTsxQ92FJErH1YoNGm3u0PZ+TB8hHxWX0RAgVJMRaZwC?=
 =?us-ascii?Q?xu4pr37+kyTJvEkDvDcUBaolfDvg2cwb0y84sDnLt8hyEZFOqGlUlZaWrhGM?=
 =?us-ascii?Q?IWmUXETMgjDkBmsmWkJW4h7uxFg4p51UjZx3wp76j6UAx12w8jCTs5z3KqwU?=
 =?us-ascii?Q?nOn46imWaERIGFzRRk+btSN+Fwo/abcPJw1dLbcD2RkmQFK3lOs3av8N+rFd?=
 =?us-ascii?Q?34esGR8kNngeQPQ24vU8alqrEWfcGxDhRJJ2NlO0vYlR9MzWi4W7L17vKyIr?=
 =?us-ascii?Q?AZo6uOsKiU3Xo2ICNj4dLHQdmInu6QdZ8Nm5NmLMvFqhFnul8lhYk+Rp436r?=
 =?us-ascii?Q?+Fn3mIGsV+9zqO28Vzn7RPMOGFpjUYhEHzAbpHk/WCKtADh2pzpnMinTcxmu?=
 =?us-ascii?Q?KtyHDJqRrgNhYOhrS5l+fVGFxXFooKoE5Ucb3Dxgl0bTNudHCocFY9A5/czO?=
 =?us-ascii?Q?RK7535LyhC9L0PxWsbLTGyr+rbsmmCbis0NbU/BFKr9uMYUZ1A3DJnAnrKkB?=
 =?us-ascii?Q?MDS/PSBJSOtpvFNOJNE0HMo3lHJk6E8Rd2pfPJfOEZASyICqvx/GfA7WaqBz?=
 =?us-ascii?Q?hpO39A=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2baaae22-1a8a-4d00-4474-08db55451888
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2023 13:05:45.7906
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ha17PRDY0sBtnfSGifF2HdNxCEDU/8Vua2TEy96dPFZSSzT4MEV/Mb1hXTOrYcbFF0YsbkByy9uhBO/rMuC+q6pPzlCYwIjoOidxf/M2UQk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB6343
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 15, 2023 at 05:22:27PM +0800, Zhengchao Shao wrote:
> When parse_pmsr_capa failed in hwsim_new_radio_nl, the memory resources
> applied for by pmsr_capa are not released. Add release processing to the
> incorrect path.
> 
> Fixes: 92d13386ec55 ("mac80211_hwsim: add PMSR capability support")
> Reported-by: syzbot+904ce6fbb38532d9795c@syzkaller.appspotmail.com
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---
> v2: move the value assigned to pmsr_capa before parse_pmsr_capa

Reviewed-by: Simon Horman <simon.horman@corigine.com>


