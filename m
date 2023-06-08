Return-Path: <netdev+bounces-9171-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D00F727B40
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 11:28:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 767351C20FF5
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 09:27:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5E2DA934;
	Thu,  8 Jun 2023 09:27:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3320A92B
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 09:27:46 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on20606.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e89::606])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A6BB213C
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 02:27:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e1OFzsJ3KwOSz8OlLLqFEbWxl6rZOcKlDElDjH0DD4Ix0105sfq7pA19BUyvlxLaJOBQy1IWwY7PcVP2W9tBMt4keTddjUtAiT2PTu9Q+llTJhPZu7qYPpA3TxSyW7FPk/0vzqQ8jgjUsBd6eJfr4IuiBPhNys+jf+nuWMQwv2Y0z0xVHq5RcL4N6eDwx+ORAaZhLNFy08ro55rKwDK50hXZyMLe5i/TEtAR7d7PtSi53vTTv7GwPMvtgXQUScb1UhV9ylbYinATdZnL8vCWIcZb9rIUTSRYHwUqXahVeN/+WNKIhLvG7zGrXLDZL+y5KA4JcaOOGNOO98VJ0DzcRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qjPz67dGEfIxculFgdC1yNUSHx87ci2liMhJ0jZqjH8=;
 b=MKiIYq3HRAaRQAwjcOslhu9T8WwjV86WUE7In2mZFKbFHcMdEnAq67hJLAEkNfmaNHrxzb+eDPju5Pm69Cf9QOEWG81uTp+ZgIw5pbhL2BywcJr7WlOt3lxUGDdhQZaed1nDtUnoDVlFHzYnXsfSnvdDsl+KOUHPoEO4zRvw8Tp7ryJll1IM6zybPbyR6ZsiI3J8g/BnGLF4uM/nYJK4+vWtVZcrzWwELTWclDwuiBvvT7IwxFTrpBgE1RgyGMlYoJkSOCYImq7iwfvqsKT/MLhyvqP4oRHFx4RfYk09FYFZCJ2QuzPQfDgH/9S8W27uHgXaBvrLZ/XISQi4+8HUmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=bytedance.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qjPz67dGEfIxculFgdC1yNUSHx87ci2liMhJ0jZqjH8=;
 b=KetdGUmEd6zoNRKTP2yhaWsR03GXGKBkxTOO/zRF3+9brjFb2W/5+7zAkQEStWRofmRTqtuanhp4ctEcT9V3JONOtw8KsBsUytSfe3H6lRFFwvwdNVS7o3EZr4ElCykGAgcLKupPc4YfCPHKDcfOAgE0UQ0sLiPH1wWAhj+klvvpfim3YMKf+mFIxjClqDGXAb5rZ2lwrB8mZwF7o1OlhU43YtyvEtZkAhlYwhEHza2CnWnIhlvEXobmWcb1KGS+OIV51GiN841NnN8hflOM19XrTI/Tw9qiL2L5whQX7wGtquYRt/Td2W+nk9I5ZCA6vB0HDNMzw8xsDhErG00zOA==
Received: from BN0PR03CA0041.namprd03.prod.outlook.com (2603:10b6:408:e7::16)
 by SN7PR12MB8057.namprd12.prod.outlook.com (2603:10b6:806:34a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Thu, 8 Jun
 2023 09:27:42 +0000
Received: from BN8NAM11FT083.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e7:cafe::ba) by BN0PR03CA0041.outlook.office365.com
 (2603:10b6:408:e7::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33 via Frontend
 Transport; Thu, 8 Jun 2023 09:27:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT083.mail.protection.outlook.com (10.13.177.75) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6477.24 via Frontend Transport; Thu, 8 Jun 2023 09:27:41 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Thu, 8 Jun 2023
 02:27:26 -0700
Received: from fedora.nvidia.com (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Thu, 8 Jun 2023
 02:27:22 -0700
References: <ZHE8P9Bi6FlKz4US@C02FL77VMD6R.googleapis.com>
 <20230526193324.41dfafc8@kernel.org>
 <ZHG+AR8qgpJ6/Zhx@C02FL77VMD6R.googleapis.com>
 <CAM0EoM=xLkAr5EF7bty+ETmZ3GXnmB9De3fYSCrQjKPb8qDy7Q@mail.gmail.com>
 <87jzwrxrz8.fsf@nvidia.com> <87fs7fxov6.fsf@nvidia.com>
 <ZHW9tMw5oCkratfs@C02FL77VMD6R.googleapis.com> <87bki2xb3d.fsf@nvidia.com>
 <ZHgXL+Bsm2M+ZMiM@C02FL77VMD6R.googleapis.com> <877csny9rd.fsf@nvidia.com>
 <ZIEjUobtdPCu648e@C02FL77VMD6R.googleapis.com>
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
Date: Thu, 8 Jun 2023 12:17:27 +0300
In-Reply-To: <ZIEjUobtdPCu648e@C02FL77VMD6R.googleapis.com>
Message-ID: <87pm66wbgo.fsf@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN8NAM11FT083:EE_|SN7PR12MB8057:EE_
X-MS-Office365-Filtering-Correlation-Id: dfb83eee-4b01-4005-5756-08db68029bfb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	jP4TiezsDI5yE5DTnKIqWwh003OaK4ua+bWh8ncN1D6KaP92qLBAUs+eijA0ArMUGXIeinFj1FoLo4iIUglVMpgu4r4jVV84dF8/ECZDtg0hOfwGJiyuR6xW0266tlChKy/quX0kjtVcCXu9DpWXbQsoO96IuVGP1SK6niP3cPqoR0a64Yjmea7cok3QN7uendqrv6z7grIUxHXZ6yy1CyK5PVUrDJV/gNJn3Lc+ixCLmXaBcjWaA5cqgZVR0A4REZNhtZI1gy8qAraWdpZvTF8InkLJB2Ll64MEBgFc1QBwRWE65otKfgl//oTgbqbBq19dIqiDPBzevMmwjjRKxI7NeCKTooVACMOQbKMtwb61yiRJI07JwNJ4h/cxwPaWdDlLEHJLd/Gf8uRFAmDYH2u24/KJegxp7yBSAmVZeQOU0wNHLFrDWUaNH2JcUC4qwhHUehwHud4BH8ik64TYmeEozbu0oNJyXXKfXQFvt9vx5LSO7UrK4im9VA5BQ6veXN6UMpB6H/N0wNHFgnEqUg5Zy0tY55RNTgvLMafHJrDe1/QK6SxA9IRNqaKa5ThQ3fWVK6gxulrEzZfx6lxqrWn8Xx1b3sBBwpHYlkj0ojl3THTVEqjEcaycWmaMbvt0TKmTtpWmpYXKsHul4O2CyyIeX4gEt+zrCVPUFquTG6oq1VA07xfLH53UFJ/iGy5n+PpJX3iMIq4onzkwl32+YiBWBta+eeq4iApPI/mXLt+TNKX93b/9k2kqhsAavA/k
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(136003)(39860400002)(376002)(451199021)(36840700001)(40470700004)(46966006)(40460700003)(26005)(36860700001)(336012)(426003)(36756003)(83380400001)(47076005)(86362001)(82310400005)(356005)(82740400003)(7636003)(16526019)(186003)(40480700001)(2616005)(41300700001)(70586007)(54906003)(4326008)(6916009)(2906002)(70206006)(478600001)(316002)(8676002)(8936002)(7416002)(5660300002)(7696005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2023 09:27:41.7345
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dfb83eee-4b01-4005-5756-08db68029bfb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN8NAM11FT083.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8057
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


On Wed 07 Jun 2023 at 17:39, Peilin Ye <yepeilin.cs@gmail.com> wrote:
> On Thu, Jun 01, 2023 at 09:20:39AM +0300, Vlad Buslov wrote:
>> >> >> If livelock with concurrent filters insertion is an issue, then it can
>> >> >> be remedied by setting a new Qdisc->flags bit
>> >> >> "DELETED-REJECT-NEW-FILTERS" and checking for it together with
>> >> >> QDISC_CLASS_OPS_DOIT_UNLOCKED in order to force any concurrent filter
>> >> >> insertion coming after the flag is set to synchronize on rtnl lock.
>> >> >
>> >> > Thanks for the suggestion!  I'll try this approach.
>> >> >
>> >> > Currently QDISC_CLASS_OPS_DOIT_UNLOCKED is checked after taking a refcnt of
>> >> > the "being-deleted" Qdisc.  I'll try forcing "late" requests (that arrive
>> >> > later than Qdisc is flagged as being-deleted) sync on RTNL lock without
>> >> > (before) taking the Qdisc refcnt (otherwise I think Task 1 will replay for
>> >> > even longer?).
>> >> 
>> >> Yeah, I see what you mean. Looking at the code __tcf_qdisc_find()
>> >> already returns -EINVAL when q->refcnt is zero, so maybe returning
>> >> -EINVAL from that function when "DELETED-REJECT-NEW-FILTERS" flags is
>> >> set is also fine? Would be much easier to implement as opposed to moving
>> >> rtnl_lock there.
>> >
>> > I implemented [1] this suggestion and tested the livelock issue in QEMU (-m
>> > 16G, CONFIG_NR_CPUS=8).  I tried deleting the ingress Qdisc (let's call it
>> > "request A") while it has a lot of ongoing filter requests, and here's the
>> > result:
>> >
>> >                         #1         #2         #3         #4
>> >   ----------------------------------------------------------
>> >    a. refcnt            89         93        230        571
>> >    b. replayed     167,568    196,450    336,291    878,027
>> >    c. time real   0m2.478s   0m2.746s   0m3.693s   0m9.461s
>> >            user   0m0.000s   0m0.000s   0m0.000s   0m0.000s
>> >             sys   0m0.623s   0m0.681s   0m1.119s   0m2.770s
>> >
>> >    a. is the Qdisc refcnt when A calls qdisc_graft() for the first time;
>> >    b. is the number of times A has been replayed;
>> >    c. is the time(1) output for A.
>> >
>> > a. and b. are collected from printk() output.  This is better than before,
>> > but A could still be replayed for hundreds of thousands of times and hang
>> > for a few seconds.
>> 
>> I don't get where does few seconds waiting time come from. I'm probably
>> missing something obvious here, but the waiting time should be the
>> maximum filter op latency of new/get/del filter request that is already
>> in-flight (i.e. already passed qdisc_is_destroying() check) and it
>> should take several orders of magnitude less time.
>
> Yeah I agree, here's what I did:
>
> In Terminal 1 I keep adding filters to eth1 in a naive and unrealistic
> loop:
>
>   $ echo "1 1 32" > /sys/bus/netdevsim/new_device
>   $ tc qdisc add dev eth1 ingress
>   $ for (( i=1; i<=3000; i++ ))
>   > do
>   > tc filter add dev eth1 ingress proto all flower src_mac 00:11:22:33:44:55 action pass > /dev/null 2>&1 &
>   > done
>
> When the loop is running, I delete the Qdisc in Terminal 2:
>
>   $ time tc qdisc delete dev eth1 ingress
>
> Which took seconds on average.  However, if I specify a unique "prio" when
> adding filters in that loop, e.g.:
>
>   $ for (( i=1; i<=3000; i++ ))
>   > do
>   > tc filter add dev eth1 ingress proto all prio $i flower src_mac 00:11:22:33:44:55 action pass > /dev/null 2>&1 &
>   > done				     ^^^^^^^
>
> Then deleting the Qdisc in Terminal 2 becomes a lot faster:
>
>   real  0m0.712s
>   user  0m0.000s
>   sys   0m0.152s 
>
> In fact it's so fast that I couldn't even make qdisc->refcnt > 1, so I did
> yet another test [1], which looks a lot better.

That makes sense, thanks for explaining.

>
> When I didn't specify "prio", sometimes that
> rhashtable_lookup_insert_fast() call in fl_ht_insert_unique() returns
> -EEXIST.  Is it because that concurrent add-filter requests auto-allocated
> the same "prio" number, so they collided with each other?  Do you think
> this is related to why it's slow?

It is slow because when creating a filter without providing priority you
are basically measuring the latency of creating a whole flower
classifier instance (multiple memory allocation, initialization of all
kinds of idrs, hash tables and locks, updating tp list in chain, etc.),
not just a single filter, so significantly higher latency is expected.

But my point still stands: with latest version of your fix the maximum
time of 'spinning' in sch_api is the maximum concurrent
tcf_{new|del|get}_tfilter op latency that has already obtained the qdisc
and any concurrent filter API messages coming after qdisc->flags
"DELETED-REJECT-NEW-FILTERS" has been set will fail and can't livelock
the concurrent qdisc del/replace.

>
> Thanks,
> Peilin Ye
>
> [1] In a beefier QEMU setup (64 cores, -m 128G), I started 64 tc instances
> in -batch mode that keeps adding a unique filter (with "prio" and "handle"
> specified) then deletes it.  Again, when they are running I delete the
> ingress Qdisc, and here's the result:
>
>                          #1         #2         #3         #4
>    ----------------------------------------------------------
>     a. refcnt            64         63         64         64
>     b. replayed         169      5,630        887      3,442
>     c. time real   0m0.171s   0m0.147s   0m0.186s   0m0.111s
>             user   0m0.000s   0m0.009s   0m0.001s   0m0.000s
>              sys   0m0.112s   0m0.108s   0m0.115s   0m0.104s


