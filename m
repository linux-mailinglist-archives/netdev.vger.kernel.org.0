Return-Path: <netdev+bounces-7019-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BE6D571933D
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 08:31:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4742E1C20C33
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 06:31:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D41C199;
	Thu,  1 Jun 2023 06:31:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 897B742505
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 06:31:13 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2068.outbound.protection.outlook.com [40.107.94.68])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8D4D11F
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 23:31:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BypRZ+GZYCEovogbsfzUvLgk92bQ8VGjyjcHG6oEEAB4lujTHQltAgqFeRpUWCOLytG4DE/R+7wNK8qMFVI9k351Ye0WkEYSS+wAtJ8PMTceNTFsNO8KoaODfVwUCbBq3CHtD6ffTV1tlQH4UmtWdGZQBf3BXTSd+B6eTaNMgiqPU1i3b4Jx8gpEc7qSDlFZnayUchfVJPS7asn3dsBKgyQB+zj7hEfVhUhcE4eu3dUpYU/M+Pzxshf7pCZwUGLeSEGwdG1FeN/Ap5aalvUACkihUHEGWGA5YF5feFc1NrVfbVbbt99lSJzmyW7WuZQ0NlmoP/NujTaaCG/t9eR/nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VCtBodEYaQQmqm4FYMfXM9J6OEvI31hZK9eUdmJ5y18=;
 b=CXczg7u2/tQGjXpzjFganj1VvVsk/6smcw040TMz2DlzlIt1uYkDhs6GR9jIA92WHWpAhfxLHGXb8zTcJrr757XbxnD/gOBC+W+5zAXUsYH+xkDZRlGzaLlLvYrhmy69kIHtMXxZiY000+mvD8m91iZVpGZ6d4GuS4dm6tn6hwdx4pD3Co4E5B0IPDguiPSfQMIlQ3rwQaOwIzl0biq/Wu3KPSruJwVDsPo8deXaBKiRXhK8BzdJfWjsbwU7hAfLIW5F+COwpRokdX74KGiAb1qkvHMlGs9oxIKz+R6Em/BcAmjrDmUm5Aq0/NIQ5AYJDomhEr0bhdI9xYk3sZsTBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=bytedance.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VCtBodEYaQQmqm4FYMfXM9J6OEvI31hZK9eUdmJ5y18=;
 b=rdUwOXDqa7KTBygSk2SvixNJLT1zCUY99bGquLBP1RrMxuGKl001ptWboXDCibd3z287EM2NT/ONFmQb110YTBIzq7LaPs6QbM0wWroI/2Z61EcvK+/0jfiqfMVV6hXx3lly4GsjtIOvC5PbPAc5Vhq8xEWbduJAV2qAl4vTUZIr9tGe414oylKxCfyB+BSNLKHIyQspNO5ZCdWyJIF5QtJSXjUq1AOkvmZZ/R8RJ18BcwFGmnzYUCz6/U9kkVUe3Y8/c6zlziofcKLBi9wtoWa6sFuQ1JyQHy3djYZFNHZvf2uQcLz50jktIJ+okOOZkHkCtebHuFeYHcTlawnneg==
Received: from MW4PR03CA0015.namprd03.prod.outlook.com (2603:10b6:303:8f::20)
 by MN2PR12MB4224.namprd12.prod.outlook.com (2603:10b6:208:1dd::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Thu, 1 Jun
 2023 06:31:07 +0000
Received: from CO1NAM11FT109.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8f:cafe::e) by MW4PR03CA0015.outlook.office365.com
 (2603:10b6:303:8f::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.23 via Frontend
 Transport; Thu, 1 Jun 2023 06:31:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT109.mail.protection.outlook.com (10.13.174.176) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.23 via Frontend Transport; Thu, 1 Jun 2023 06:31:07 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Wed, 31 May 2023
 23:30:52 -0700
Received: from fedora.nvidia.com (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Wed, 31 May
 2023 23:30:48 -0700
References: <CAM0EoM=FS2arxv0__aQXF1a7ViJnM0hST=TL9dcnJpkf-ipjvA@mail.gmail.com>
 <7879f218-c712-e9cc-57ba-665990f5f4c9@mojatatu.com>
 <ZHE8P9Bi6FlKz4US@C02FL77VMD6R.googleapis.com>
 <20230526193324.41dfafc8@kernel.org>
 <ZHG+AR8qgpJ6/Zhx@C02FL77VMD6R.googleapis.com>
 <CAM0EoM=xLkAr5EF7bty+ETmZ3GXnmB9De3fYSCrQjKPb8qDy7Q@mail.gmail.com>
 <87jzwrxrz8.fsf@nvidia.com> <87fs7fxov6.fsf@nvidia.com>
 <ZHW9tMw5oCkratfs@C02FL77VMD6R.googleapis.com> <87bki2xb3d.fsf@nvidia.com>
 <ZHgXL+Bsm2M+ZMiM@C02FL77VMD6R.googleapis.com>
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
Date: Thu, 1 Jun 2023 09:20:39 +0300
In-Reply-To: <ZHgXL+Bsm2M+ZMiM@C02FL77VMD6R.googleapis.com>
Message-ID: <877csny9rd.fsf@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CO1NAM11FT109:EE_|MN2PR12MB4224:EE_
X-MS-Office365-Filtering-Correlation-Id: 4841ed14-647d-43d8-c96e-08db6269c81b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	FFPaDWcdOGMagxFrP4CsstO6cnHx3UdoZQ5+EL8xLddkBv/4j5W00tf4Bpq0L4YhU1KhUIP22KBXWuGx5KKrrxTcKhvl78X70mMJw+pQTDyXAp0H44XZWRhWws5q7lJv4wz1sxat3sSf9uPJzim8rWilUkZ5SpZOPXLIdDDsqPWDxTInIknhjxym+Gp+a2YlOJq5Q43HnWtQn+5P9laFnc5C5Gg2dfOhtGuim2+FbfdR6dsUnjgdS61W+m3QWDUTVGdWG8XtWPtgyPsQR/7XTB02727nK85sPq7Xczb8pauDBMsJYEF/SdMweXUNT9CcGtJm7z9iglhvL9KLUUSidST009QeVBNs8H9ZXfQdW4g0wtPrv+ohh1mi/Oo8JJaBNY70aYgRpAdZl01mXv4riqoR5YyBGMunh1hM7X2zzrj3aiXO7dVz9jJ707lRtkYD4A4GqN1CREMkiorsoS1f25XxvKbRJ+6jJluxFvwt/m4yVqT0agN4jGNX/uooj3cPX/UXxFMpwh8HRfv7GKhkqxkbDDc4uayb38GatmAF+4zXzaoGyEij7Ic9oex7HJYeaQd6fZgJzry/UNUGzRLiNYXJZP5hH7dmIe1bFjrzJvHqub8Bf72m4n4TDbD11TmGoMmDR+itPRx95a2abBagDZs7yxYrkARMOcfnDJ4W3XL0bSYMC1HW7YVMEFnFURgBcBmBZ0i5u3sf0UAWEaRwRakW5LzRhJwGFU9lsGp5qd4QVpLdvtcgoYBaV93mIEKK
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(136003)(376002)(346002)(451199021)(46966006)(36840700001)(40470700004)(186003)(2906002)(54906003)(2616005)(16526019)(26005)(478600001)(426003)(336012)(83380400001)(47076005)(36860700001)(40460700003)(82740400003)(86362001)(7696005)(8936002)(7636003)(41300700001)(356005)(8676002)(40480700001)(36756003)(5660300002)(316002)(70586007)(6666004)(70206006)(82310400005)(4326008)(7416002)(6916009);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2023 06:31:07.0472
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4841ed14-647d-43d8-c96e-08db6269c81b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1NAM11FT109.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4224
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed 31 May 2023 at 20:57, Peilin Ye <yepeilin.cs@gmail.com> wrote:
> Hi Vlad and all,
>
> On Tue, May 30, 2023 at 03:18:19PM +0300, Vlad Buslov wrote:
>> >> If livelock with concurrent filters insertion is an issue, then it can
>> >> be remedied by setting a new Qdisc->flags bit
>> >> "DELETED-REJECT-NEW-FILTERS" and checking for it together with
>> >> QDISC_CLASS_OPS_DOIT_UNLOCKED in order to force any concurrent filter
>> >> insertion coming after the flag is set to synchronize on rtnl lock.
>> >
>> > Thanks for the suggestion!  I'll try this approach.
>> >
>> > Currently QDISC_CLASS_OPS_DOIT_UNLOCKED is checked after taking a refcnt of
>> > the "being-deleted" Qdisc.  I'll try forcing "late" requests (that arrive
>> > later than Qdisc is flagged as being-deleted) sync on RTNL lock without
>> > (before) taking the Qdisc refcnt (otherwise I think Task 1 will replay for
>> > even longer?).
>> 
>> Yeah, I see what you mean. Looking at the code __tcf_qdisc_find()
>> already returns -EINVAL when q->refcnt is zero, so maybe returning
>> -EINVAL from that function when "DELETED-REJECT-NEW-FILTERS" flags is
>> set is also fine? Would be much easier to implement as opposed to moving
>> rtnl_lock there.
>
> I implemented [1] this suggestion and tested the livelock issue in QEMU (-m
> 16G, CONFIG_NR_CPUS=8).  I tried deleting the ingress Qdisc (let's call it
> "request A") while it has a lot of ongoing filter requests, and here's the
> result:
>
>                         #1         #2         #3         #4
>   ----------------------------------------------------------
>    a. refcnt            89         93        230        571
>    b. replayed     167,568    196,450    336,291    878,027
>    c. time real   0m2.478s   0m2.746s   0m3.693s   0m9.461s
>            user   0m0.000s   0m0.000s   0m0.000s   0m0.000s
>             sys   0m0.623s   0m0.681s   0m1.119s   0m2.770s
>
>    a. is the Qdisc refcnt when A calls qdisc_graft() for the first time;
>    b. is the number of times A has been replayed;
>    c. is the time(1) output for A.
>
> a. and b. are collected from printk() output.  This is better than before,
> but A could still be replayed for hundreds of thousands of times and hang
> for a few seconds.

I don't get where does few seconds waiting time come from. I'm probably
missing something obvious here, but the waiting time should be the
maximum filter op latency of new/get/del filter request that is already
in-flight (i.e. already passed qdisc_is_destroying() check) and it
should take several orders of magnitude less time.

>
> Is this okay?  If not, is it possible (or should we) to make A really
> _wait_ on Qdisc refcnt, instead of "busy-replaying"?
>
> Thanks,
> Peilin Ye
>
> [1] Diff against v5 patch 6 (printk() calls not included):
>
> diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
> index 3e9cc43cbc90..de7b0538b309 100644
> --- a/include/net/sch_generic.h
> +++ b/include/net/sch_generic.h
> @@ -94,6 +94,7 @@ struct Qdisc {
>  #define TCQ_F_INVISIBLE                0x80 /* invisible by default in dump */
>  #define TCQ_F_NOLOCK           0x100 /* qdisc does not require locking */
>  #define TCQ_F_OFFLOADED                0x200 /* qdisc is offloaded to HW */
> +#define TCQ_F_DESTROYING       0x400 /* destroying, reject filter requests */
>         u32                     limit;
>         const struct Qdisc_ops  *ops;
>         struct qdisc_size_table __rcu *stab;
> @@ -185,6 +186,11 @@ static inline bool qdisc_is_empty(const struct Qdisc *qdisc)
>         return !READ_ONCE(qdisc->q.qlen);
>  }
>
> +static inline bool qdisc_is_destroying(const struct Qdisc *qdisc)
> +{
> +       return qdisc->flags & TCQ_F_DESTROYING;

Hmm, do we need at least some kind of {READ|WRITE}_ONCE() for accessing
flags since they are now used in unlocked filter code path?

> +}
> +
>  /* For !TCQ_F_NOLOCK qdisc, qdisc_run_begin/end() must be invoked with
>   * the qdisc root lock acquired.
>   */
> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> index 2621550bfddc..3e7f6f286ac0 100644
> --- a/net/sched/cls_api.c
> +++ b/net/sched/cls_api.c
> @@ -1172,7 +1172,7 @@ static int __tcf_qdisc_find(struct net *net, struct Qdisc **q,
>                 *parent = (*q)->handle;
>         } else {
>                 *q = qdisc_lookup_rcu(dev, TC_H_MAJ(*parent));
> -               if (!*q) {
> +               if (!*q || qdisc_is_destroying(*q)) {
>                         NL_SET_ERR_MSG(extack, "Parent Qdisc doesn't exists");
>                         err = -EINVAL;
>                         goto errout_rcu;
> diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
> index 286b7c58f5b9..d6e47546c7fe 100644
> --- a/net/sched/sch_api.c
> +++ b/net/sched/sch_api.c
> @@ -1086,12 +1086,18 @@ static int qdisc_graft(struct net_device *dev, struct Qdisc *parent,
>                                 return -ENOENT;
>                         }
>
> -                       /* Replay if the current ingress (or clsact) Qdisc has ongoing
> -                        * RTNL-unlocked filter request(s).  This is the counterpart of that
> -                        * qdisc_refcount_inc_nz() call in __tcf_qdisc_find().
> +                       /* If current ingress (clsact) Qdisc has ongoing filter requests, stop
> +                        * accepting any more by marking it as "being destroyed", then tell the
> +                        * caller to replay by returning -EAGAIN.
>                          */
> -                       if (!qdisc_refcount_dec_if_one(dev_queue->qdisc_sleeping))
> +                       q = dev_queue->qdisc_sleeping;
> +                       if (!qdisc_refcount_dec_if_one(q)) {
> +                               q->flags |= TCQ_F_DESTROYING;
> +                               rtnl_unlock();
> +                               schedule();
> +                               rtnl_lock();
>                                 return -EAGAIN;
> +                       }
>                 }
>
>                 if (dev->flags & IFF_UP)


