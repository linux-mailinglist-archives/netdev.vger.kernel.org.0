Return-Path: <netdev+bounces-9153-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 090D972794C
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 09:56:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9162C2815DB
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 07:56:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D19CC883B;
	Thu,  8 Jun 2023 07:56:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF2D18F65
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 07:56:19 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2061.outbound.protection.outlook.com [40.107.94.61])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B89E31FCC
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 00:56:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OCXgg4zHby/+KDVl+6ZEPWAeISuRo1o7WYgGI2NdUsdi9z5JA1zCzpChjuS1+EG8zYx6rLTgkNUspdR7jFKC0iRZ0GsO+P3/Z7wRlNNu8VsUfmhFfFFySB10KzmzPZYThqBWoxST3BSrQR7vNOVKyIcHQoCBRG3097Z2Q84P5XD0V88yUk7qF5wsygGCfpaC3Lj4jGjwdJ0jsivamfxTvHUrIYyxrnO23Fm06VDgjhuM9wv8TZrNsK5wBrnR/CZWZBG5DzU8Rv5fhKU/N/tNVoVQTlMGpPOtUqnfY8JyeSP+T5EgT2OJ5p2m8oTYnvXNaD0Tbccm+1aZbXqztGhmrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z5aupkCuFbIDmzrV3403oAMZWDAQ4V9p3ez755K2qUc=;
 b=by8HQHaB89vLBB5QZRSHhx8Y+K/LQ+fACBu8dNqIDlM4m0j7/ujd/7kveaHtjRBRbNIHVLBEDwULgpWdJnMvYK0zyl2LrH7qOjWUcMjaL+4/RhpUZxf2+Zg7TJGaDeLK+j1S1eyulyiRWQ3RPU1KHiWV8qE/8kqj+j5jMJtnfGS3lb0RxHFbelGRS+VdsUCFCjtyTWIW/OQw5QL+kRz5IeFL/3A410mx8BIn/sxM0v4+sEKFmzdW1GncTna7QGiJluWHsOzTmh/cHeqh9q1RK24U3yyNTaAZqZq6D/Hiaf5FmAh9cHy3qPcegdYWlIxxuonKV+W2S37MjwsjiRE7jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=bytedance.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z5aupkCuFbIDmzrV3403oAMZWDAQ4V9p3ez755K2qUc=;
 b=Zie9SdVJQ4gG+5YX3WE98bw+eGJJzPpClVpEKj8/DOZ6Tm1bmm5QADqL46nOERxq0JZT3oKUI7i8SuJTRBNCq//pSSYAV9PuJWAI6zoRWlmTegaGOpF0GXVbYK/S3yrfLvi1JfpbYzs3kUDOMs2YNcSP1sXp7dikHrcFp6/gFFEbKMR1yZVaAGMpFgk4bpM6u93ud7kBWmSsFSZsh5C2Sr0qUzxoy5UEPDbHMIxZX7XOTaI8gjyoqkjm8V+l55882rxXsmr7yYcdAo7NJ5NmDdN42dWfsQ3TvbZsbw5j1s/aZTrQ9WpusZpd6VhPBk32/xZ30feqT0RTDzsYgeoXRg==
Received: from DS7PR03CA0309.namprd03.prod.outlook.com (2603:10b6:8:2b::7) by
 DM6PR12MB4563.namprd12.prod.outlook.com (2603:10b6:5:28e::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.38; Thu, 8 Jun 2023 07:56:10 +0000
Received: from CY4PEPF0000EE32.namprd05.prod.outlook.com
 (2603:10b6:8:2b:cafe::ea) by DS7PR03CA0309.outlook.office365.com
 (2603:10b6:8:2b::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33 via Frontend
 Transport; Thu, 8 Jun 2023 07:56:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000EE32.mail.protection.outlook.com (10.167.242.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6477.13 via Frontend Transport; Thu, 8 Jun 2023 07:56:10 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Thu, 8 Jun 2023
 00:56:03 -0700
Received: from fedora.nvidia.com (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Thu, 8 Jun 2023
 00:55:59 -0700
References: <ZHG+AR8qgpJ6/Zhx@C02FL77VMD6R.googleapis.com>
 <CAM0EoM=xLkAr5EF7bty+ETmZ3GXnmB9De3fYSCrQjKPb8qDy7Q@mail.gmail.com>
 <87jzwrxrz8.fsf@nvidia.com> <87fs7fxov6.fsf@nvidia.com>
 <ZHW9tMw5oCkratfs@C02FL77VMD6R.googleapis.com> <87bki2xb3d.fsf@nvidia.com>
 <ZHgXL+Bsm2M+ZMiM@C02FL77VMD6R.googleapis.com> <877csny9rd.fsf@nvidia.com>
 <ZH/V5gf+YjKuC0bn@C02FL77VMD6R.googleapis.com> <87y1kvwu5c.fsf@nvidia.com>
 <ZIEqAosXPn8hB1hK@C02FL77VMD6R.googleapis.com>
User-agent: mu4e 1.8.11; emacs 28.2
From: Vlad Buslov <vladbu@nvidia.com>
To: Peilin Ye <yepeilin.cs@gmail.com>
CC: Jamal Hadi Salim <jhs@mojatatu.com>, Jakub Kicinski <kuba@kernel.org>,
	Pedro Tammela <pctammela@mojatatu.com>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Paolo Abeni
	<pabeni@redhat.com>, Cong Wang <xiyou.wangcong@gmail.com>, Jiri Pirko
	<jiri@resnulli.us>, Peilin Ye <peilin.ye@bytedance.com>, Daniel Borkmann
	<daniel@iogearbox.net>, John Fastabend <john.fastabend@gmail.com>, "Hillf
 Danton" <hdanton@sina.com>, <netdev@vger.kernel.org>, Cong Wang
	<cong.wang@bytedance.com>
Subject: Re: [PATCH v5 net 6/6] net/sched: qdisc_destroy() old ingress and
 clsact Qdiscs before grafting
Date: Thu, 8 Jun 2023 10:48:12 +0300
In-Reply-To: <ZIEqAosXPn8hB1hK@C02FL77VMD6R.googleapis.com>
Message-ID: <87ttviwfoy.fsf@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE32:EE_|DM6PR12MB4563:EE_
X-MS-Office365-Filtering-Correlation-Id: bd386d7f-2f6b-4a2e-4011-08db67f5d2b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	nYultvj/m+Hs82rOMVVNAyj4FDU4lkZ8JlEOT+si9T7FgJIjMuXTY0qmtnLb3IAQPXvAhS6c/CmJlo/Fo4XS+zO/mtyR2fN54ZakBlJ2hVJk5pf2vzHv1mHXJewRkv9flp8pisG7lQBuD2fIglSiuDDFeNeoKfjuvMexEvyyoL8wgqLLWbi9l+JwxOSCmxmvk314XiU+qNXQWulO3zRfPcHlcPIaM5COCZF/ngCumK1o0YK16bzD60ospBLyLTKt0yYp9voZQiLPsSfxXDrZiHmxFavncZ3b4TkksDna0kw0hNJvQZu0DSOZsdVsOcXHs41A9go4KtH/fYaXy93IUgtvZMIEVOnYsjx32RBMJf5idqRSjC+5pLCfEhFK4byF9q2AMdBY+XUe4hIAJX8pZ97Xx3n279y0unaKaSVS5xlWbJ+UjB8vmR2tszKTBYbrf7jJXBclPuqbF+lLiNMmXf7OyxUYYGv1KZwWS43hBQ2DRnZQK2RZIfNxWwp1zOAy9SGqwPMxYuBDpd8iHi6hwN8FZGdthxveyopQO16BetKNLheuk5On9+rH+Yf93f2vzseBii6rCzjnONFxx2t7vcDfJpYxWmIkIRN4oceA2mv3IlijY+gvjk3txX2B8rX/39+uvmK5y9Pn3KhNxNdj+XJ00J8mr6453tRH5Cc4IuaA2zcRsd3dR0PyFg2YzHV1mDZTwE4LODyAcQAC02c84TcYfPmuk80WXjyaYLR4XTf8sTMf4pvsh3fiSdTQGtD+
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(136003)(396003)(39860400002)(451199021)(36840700001)(40470700004)(46966006)(70206006)(70586007)(8676002)(5660300002)(8936002)(36756003)(4326008)(6666004)(6916009)(54906003)(478600001)(40460700003)(41300700001)(7696005)(316002)(40480700001)(82740400003)(7636003)(356005)(186003)(26005)(47076005)(7416002)(16526019)(2616005)(336012)(426003)(83380400001)(36860700001)(82310400005)(86362001)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2023 07:56:10.1327
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bd386d7f-2f6b-4a2e-4011-08db67f5d2b4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE32.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4563
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed 07 Jun 2023 at 18:08, Peilin Ye <yepeilin.cs@gmail.com> wrote:
> On Wed, Jun 07, 2023 at 11:18:32AM +0300, Vlad Buslov wrote:
>> > I also thought about adding the new DELETED-REJECT-NEW-FILTERS flag to
>> > ::state2, but not sure if it's okay to extend it for our purpose.
>>
>> As you described above qdisc->flags is already used to interact with cls
>> api (including changing it dynamically), so I don't see why not.
>
> Sorry, I don't follow, I meant qdisc->state2:
>
>   enum qdisc_state2_t {
>           /* Only for !TCQ_F_NOLOCK qdisc. Never access it directly.
>            * Use qdisc_run_begin/end() or qdisc_is_running() instead.
>            */
>           __QDISC_STATE2_RUNNING,
>   };

Sorry, I misunderstood what you were suggesting. Got it now.

>
> NVM, I think using qdisc->flags after making it atomic sounds better.

Agree.

>
> On Wed, Jun 07, 2023 at 11:18:32AM +0300, Vlad Buslov wrote:
>> > 	err = tp->ops->change(net, skb, tp, cl, t->tcm_handle, tca, &fh,
>> > 			      flags, extack);
>> > 	if (err == 0) {
>> > 		tfilter_notify(net, skb, n, tp, block, q, parent, fh,
>> > 			       RTM_NEWTFILTER, false, rtnl_held, extack);
>> > 		tfilter_put(tp, fh);
>> > 		/* q pointer is NULL for shared blocks */
>> > 		if (q)
>> > 			q->flags &= ~TCQ_F_CAN_BYPASS;
>> > 	}               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>> >
>> > TCQ_F_CAN_BYPASS is cleared after e.g. adding a filter to the Qdisc, and it
>> > isn't atomic [1].
>> 
>> Yeah, I see we have already got such behavior in 3f05e6886a59
>> ("net_sched: unset TCQ_F_CAN_BYPASS when adding filters").
>> 
>> > We also have this:
>> >
>> >   ->dequeue()
>> >     htb_dequeue()
>> >       htb_dequeue_tree()
>> >         qdisc_warn_nonwc():
>> >
>> >   void qdisc_warn_nonwc(const char *txt, struct Qdisc *qdisc)
>> >   {
>> >           if (!(qdisc->flags & TCQ_F_WARN_NONWC)) {
>> >                   pr_warn("%s: %s qdisc %X: is non-work-conserving?\n",
>> >                           txt, qdisc->ops->id, qdisc->handle >> 16);
>> >                   qdisc->flags |= TCQ_F_WARN_NONWC;
>> >           }       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>> >   }
>> >   EXPORT_SYMBOL(qdisc_warn_nonwc);
>> >
>> > Also non-atomic; isn't it possible for the above 2 underlined statements to
>> > race with each other?  If true, I think we need to change Qdisc::flags to
>> > use atomic bitops, just like what we're doing for Qdisc::state and
>> > ::state2.  It feels like a separate TODO, however.
>> 
>> It looks like even though 3f05e6886a59 ("net_sched: unset
>> TCQ_F_CAN_BYPASS when adding filters") was introduced after cls api
>> unlock by now we have these in exactly the same list of supported
>> kernels (5.4 LTS and newer). Considering this, the conversion to the
>> atomic bitops can be done as a standalone fix for cited commit and after
>> it will have been accepted and backported the qdisc fix can just assume
>> that qdisc->flags is an atomic bitops field in all target kernels and
>> use it as-is. WDYT?
>
> Sounds great, how about:
>
>   1. I'll post the non-replay version of the fix (after updating the commit
>      message), and we apply that first, as suggested by Jamal

From my side there are no objections to any of the proposed approaches
since we have never had any users with legitimate use-case where they
need to replace/delete a qdisc concurrently with a filter update, so
returning -EBUSY (or -EAGAIN) to the user in such case would work as
either temporary or the final fix. However, Jakub had reservations with
such approach so don't know where we stand now regarding this.

>
>   2. Make qdisc->flags atomic
>
>   3. Make the fix better by replaying and using the (now atomic)
>      IS-DESTROYING flag with test_and_set_bit() and friends
>
> ?

Again, no objections from my side. Ping me if you need help with any of
these.


