Return-Path: <netdev+bounces-4691-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E635470DEF0
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 16:15:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6D0C61C20D2D
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 14:15:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BD091F177;
	Tue, 23 May 2023 14:15:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 672C56FC7
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 14:15:33 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2057.outbound.protection.outlook.com [40.107.237.57])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45CEEC4;
	Tue, 23 May 2023 07:15:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EZm5jRekizNNTaXmOeKvBrJc7MQQCXXOEG96W4NeH55C4vv7od4inn2qqONlwwt8tCEODNehu7Bn7JWkNCE5N5H+UmAPb5HiLa5+ISXH3py+PyCRAsEs3M1BZQupdo+F0l1AmKUEMBI7BVsXLll1IjPR9k10Qk9QsXh0YqCEFezz6FKAsUQfTJOMiAqbI9p79YISguEKpFF6WQMCcnQZVtpTYMXTMf6Aj66zgFp+eSPOn8NyIIkWJFZ90bmzsdrEJyw6fnF590KpBsWiNuwXiAdy8rwugs9b9mqTZjbmyaTP7A8lqa9cyqYpd/CnBcyMMzBTlRXRaVomGw5hVrsz5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KfRokTSpDZcIwsdDa7CQRjmOqu54W9lgvrne7tsMURM=;
 b=Py0LBaKrKIY50gogEJxryl3ZwmxeuBiVM50a94SE7IQ2YBkxnwYtUtY/JWGQBYssQpsJZEkt3F8+mYeE2f2NtG7dr23vWhKFP1CE7lgKHAR3xVVnwxDeehmJxlRMrKqrLbX1eBPl9xUXwTr7QYcXvyFo73q8hhukRZ+K6eSblqoMbxfaNfT965HwZ4Iijk0BYUY3O/hg5GXvFyevW9T4zpVaXo4tH0JSZWAI8YTzVkq+bAZ91SzJ0WhDUyAOym61oOXNQ+RA7QorQOO4djKWGLldmVjvTWPaFpFrpB527crl7g8DPHY8U4Wm9n4SSiBq0DSfmEC+5vesYnpV728/3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=bytedance.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KfRokTSpDZcIwsdDa7CQRjmOqu54W9lgvrne7tsMURM=;
 b=te6d+VlpETfKXlEJtOuc66bPg65s2UIg0wCBEPKXNyjTTj8g7X3bt9efN7A+JiZV+0FEC4aoZYoeZxgHbPC6PswYMHupQIX2SVzhkBtjGfU3ZCAfzqX1KLlaGkCbFvClVUZMmk/6ikYoJ+g3nIHXnnL+lMHnEn67NfJeODdsCELXCnu7d0MrIh5sWd5Jb1JyMsx348xt3Gsq5j928giwQjL6uYwnRxgQ+XS/Fjv9cB4ndyE3pr67U35aUMoJS0gAaYO4F5FBRbYCJsG5zPHcxet1rEMYLCo289WVB/Vm4BRPx7XelEenL9tJsaTNarShhbMTBL3OgYlsFcSGINV4Wg==
Received: from MW4PR03CA0295.namprd03.prod.outlook.com (2603:10b6:303:b5::30)
 by DS7PR12MB5813.namprd12.prod.outlook.com (2603:10b6:8:75::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Tue, 23 May
 2023 14:15:26 +0000
Received: from CO1NAM11FT102.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b5:cafe::2f) by MW4PR03CA0295.outlook.office365.com
 (2603:10b6:303:b5::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28 via Frontend
 Transport; Tue, 23 May 2023 14:15:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT102.mail.protection.outlook.com (10.13.175.87) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6411.29 via Frontend Transport; Tue, 23 May 2023 14:15:26 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 23 May 2023
 07:15:11 -0700
Received: from fedora.nvidia.com (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Tue, 23 May
 2023 07:15:07 -0700
References: <cover.1684796705.git.peilin.ye@bytedance.com>
 <8e3383d0bacd084f0e33d9158d24bd411f1bf6ba.1684796705.git.peilin.ye@bytedance.com>
User-agent: mu4e 1.8.11; emacs 28.2
From: Vlad Buslov <vladbu@nvidia.com>
To: Peilin Ye <yepeilin.cs@gmail.com>
CC: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, Jamal Hadi Salim <jhs@mojatatu.com>, Cong Wang
	<xiyou.wangcong@gmail.com>, Jiri Pirko <jiri@resnulli.us>, Peilin Ye
	<peilin.ye@bytedance.com>, Daniel Borkmann <daniel@iogearbox.net>, "John
 Fastabend" <john.fastabend@gmail.com>, Vlad Buslov <vladbu@mellanox.com>,
	Pedro Tammela <pctammela@mojatatu.com>, Hillf Danton <hdanton@sina.com>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Cong Wang
	<cong.wang@bytedance.com>
Subject: Re: [PATCH v2 net 6/6] net/sched: qdisc_destroy() old ingress and
 clsact Qdiscs before grafting
Date: Tue, 23 May 2023 17:04:40 +0300
In-Reply-To: <8e3383d0bacd084f0e33d9158d24bd411f1bf6ba.1684796705.git.peilin.ye@bytedance.com>
Message-ID: <87sfbnxhg7.fsf@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT102:EE_|DS7PR12MB5813:EE_
X-MS-Office365-Filtering-Correlation-Id: 91f75f8f-f46d-4f78-1c5c-08db5b9827b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	YSKp1rZs6ZfNmMQ+CgpB3sgkL8X/IhV31Nr4J3868xTYBkJREPY9+Hq9LmiP5oXn0w4+6qK8ZIndxZa0pQ7e2q2yS36mSGA0t3BneTza1Q2sZQ+e+hTvhJpQ2OvX+LsqFvHdmvU7spSixXlL2wJs1QK5r/LlanWz2Og6nrzklYqdn3YWeWn/+ttf4FL2/zJtTf93+C0yscLCO4jvzJGHmu6PwxknIBvT1Pl4ztfKH15QvM0hVhVqZQFwEg3KkqhxwXI3ttMcXi72AP4dvGYWJvelu+bdBgWwUupxbWAvSxjAL32UamTREJtec8UliCQWY2QGeTRY/4XmaSko1RmOjLU6DEq0cqWbtdA9z1hv4X0hF/q4nyKp0788F/xbUp++mXtn1JcCE0ySvCSzOif7oDnE13QKfNPDScUwrYgFU9330axgxqr7IQ52HBFezTeDr2eOsbgNPOy+tM4BFlEOsuvfuInu4zUb+f1U5L/YKqX78u7IvH3zXYnhJR6paIBz2TEfsYOz/SNm4M+xMatdicsA2E1Mq4jAD5v76w9BZJI9BRhtd0+A67Pjr7mS/mpOCZMn/a4NiCcAIT7yBHJ5r4P66yiBwtfAvws74vyMvuWqdkyxqdPi/tehyVnbln2JQI0d2Gayo0JuMmP99YWZWlf9phcdXzVq3oK9KblmoQ+kR/oaeUDGOtEMQMJUgwM6V3bST+54lYi4act+FWwb5m0eyiD0W66tlIr+Pp98VGUZV1T+nDLc1ZIDbsjYujgXs9483DCeQN2mE+GoLHjrBQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(39860400002)(376002)(346002)(451199021)(40470700004)(46966006)(36840700001)(2906002)(82310400005)(356005)(7636003)(47076005)(426003)(2616005)(8676002)(40480700001)(5660300002)(26005)(83380400001)(186003)(16526019)(36860700001)(82740400003)(40460700003)(7416002)(8936002)(36756003)(316002)(86362001)(4326008)(41300700001)(336012)(7696005)(6916009)(6666004)(966005)(70586007)(70206006)(54906003)(478600001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2023 14:15:26.0857
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 91f75f8f-f46d-4f78-1c5c-08db5b9827b3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1NAM11FT102.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5813
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Peilin,

Thanks again for the great analysis and investing effort into fixing
this!

On Mon 22 May 2023 at 16:55, Peilin Ye <yepeilin.cs@gmail.com> wrote:
> mini_Qdisc_pair::p_miniq is a double pointer to mini_Qdisc, initialized in
> ingress_init() to point to net_device::miniq_ingress.  ingress Qdiscs
> access this per-net_device pointer in mini_qdisc_pair_swap().  Similar for
> clsact Qdiscs and miniq_egress.
>
> Unfortunately, after introducing RTNL-unlocked RTM_{NEW,DEL,GET}TFILTER
> requests (thanks Hillf Danton for the hint), when replacing ingress or
> clsact Qdiscs, for example, the old Qdisc ("@old") could access the same
> miniq_{in,e}gress pointer(s) concurrently with the new Qdisc ("@new"),
> causing race conditions [1] including a use-after-free bug in
> mini_qdisc_pair_swap() reported by syzbot:
>
>  BUG: KASAN: slab-use-after-free in mini_qdisc_pair_swap+0x1c2/0x1f0 net/sched/sch_generic.c:1573
>  Write of size 8 at addr ffff888045b31308 by task syz-executor690/14901
> ...
>  Call Trace:
>   <TASK>
>   __dump_stack lib/dump_stack.c:88 [inline]
>   dump_stack_lvl+0xd9/0x150 lib/dump_stack.c:106
>   print_address_description.constprop.0+0x2c/0x3c0 mm/kasan/report.c:319
>   print_report mm/kasan/report.c:430 [inline]
>   kasan_report+0x11c/0x130 mm/kasan/report.c:536
>   mini_qdisc_pair_swap+0x1c2/0x1f0 net/sched/sch_generic.c:1573
>   tcf_chain_head_change_item net/sched/cls_api.c:495 [inline]
>   tcf_chain0_head_change.isra.0+0xb9/0x120 net/sched/cls_api.c:509
>   tcf_chain_tp_insert net/sched/cls_api.c:1826 [inline]
>   tcf_chain_tp_insert_unique net/sched/cls_api.c:1875 [inline]
>   tc_new_tfilter+0x1de6/0x2290 net/sched/cls_api.c:2266
> ...
>
> @old and @new should not affect each other.  In other words, @old should
> never modify miniq_{in,e}gress after @new, and @new should not update
> @old's RCU state.  Fixing without changing sch_api.c turned out to be
> difficult (please refer to Closes: for discussions).  Instead, make sure
> @new's first call always happen after @old's last call, in
> qdisc_destroy(), has finished:
>
> In qdisc_graft(), return -EAGAIN and tell the caller to replay
> (suggested by Vlad Buslov) if @old has any ongoing RTNL-unlocked filter
> requests, and call qdisc_destroy() for @old before grafting @new.
>
> Introduce qdisc_refcount_dec_if_one() as the counterpart of
> qdisc_refcount_inc_nz() used for RTNL-unlocked filter requests.  Introduce
> a non-static version of qdisc_destroy() that does a TCQ_F_BUILTIN check,
> just like qdisc_put() etc.
>
> Depends on patch "net/sched: Refactor qdisc_graft() for ingress and clsact
> Qdiscs".
>
> [1] To illustrate, the syzkaller reproducer adds ingress Qdiscs under
> TC_H_ROOT (no longer possible after patch "net/sched: sch_ingress: Only
> create under TC_H_INGRESS") on eth0 that has 8 transmission queues:
>
>   Thread 1 creates ingress Qdisc A (containing mini Qdisc a1 and a2), then
>   adds a flower filter X to A.
>
>   Thread 2 creates another ingress Qdisc B (containing mini Qdisc b1 and
>   b2) to replace A, then adds a flower filter Y to B.
>
>  Thread 1               A's refcnt   Thread 2
>   RTM_NEWQDISC (A, RTNL-locked)
>    qdisc_create(A)               1
>    qdisc_graft(A)                9
>
>   RTM_NEWTFILTER (X, RTNL-unlocked)
>    __tcf_qdisc_find(A)          10
>    tcf_chain0_head_change(A)
>    mini_qdisc_pair_swap(A) (1st)
>             |
>             |                         RTM_NEWQDISC (B, RTNL-locked)
>          RCU sync                2     qdisc_graft(B)
>             |                    1     notify_and_destroy(A)
>             |
>    tcf_block_release(A)          0    RTM_NEWTFILTER (Y, RTNL-unlocked)
>    qdisc_destroy(A)                    tcf_chain0_head_change(B)
>    tcf_chain0_head_change_cb_del(A)    mini_qdisc_pair_swap(B) (2nd)
>    mini_qdisc_pair_swap(A) (3rd)                |
>            ...                                 ...
>
> Here, B calls mini_qdisc_pair_swap(), pointing eth0->miniq_ingress to its
> mini Qdisc, b1.  Then, A calls mini_qdisc_pair_swap() again during
> ingress_destroy(), setting eth0->miniq_ingress to NULL, so ingress packets
> on eth0 will not find filter Y in sch_handle_ingress().
>
> This is only one of the possible consequences of concurrently accessing
> miniq_{in,e}gress pointers.  The point is clear though: again, A should
> never modify those per-net_device pointers after B, and B should not
> update A's RCU state.
>
> Fixes: 7a096d579e8e ("net: sched: ingress: set 'unlocked' flag for Qdisc ops")
> Fixes: 87f373921c4e ("net: sched: ingress: set 'unlocked' flag for clsact Qdisc ops")
> Reported-by: syzbot+b53a9c0d1ea4ad62da8b@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/r/0000000000006cf87705f79acf1a@google.com/
> Cc: Hillf Danton <hdanton@sina.com>
> Cc: Vlad Buslov <vladbu@mellanox.com>
> Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
> ---
> changes in v2:
>   - replay the request if the current Qdisc has any ongoing RTNL-unlocked
>     filter requests (Vlad)
>   - minor changes in code comments and commit log
>
>  include/net/sch_generic.h |  8 ++++++++
>  net/sched/sch_api.c       | 32 ++++++++++++++++++++++++++------
>  net/sched/sch_generic.c   | 14 +++++++++++---
>  3 files changed, 45 insertions(+), 9 deletions(-)
>
> diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
> index fab5ba3e61b7..3e9cc43cbc90 100644
> --- a/include/net/sch_generic.h
> +++ b/include/net/sch_generic.h
> @@ -137,6 +137,13 @@ static inline void qdisc_refcount_inc(struct Qdisc *qdisc)
>  	refcount_inc(&qdisc->refcnt);
>  }
>  
> +static inline bool qdisc_refcount_dec_if_one(struct Qdisc *qdisc)
> +{
> +	if (qdisc->flags & TCQ_F_BUILTIN)
> +		return true;
> +	return refcount_dec_if_one(&qdisc->refcnt);
> +}
> +
>  /* Intended to be used by unlocked users, when concurrent qdisc release is
>   * possible.
>   */
> @@ -652,6 +659,7 @@ void dev_deactivate_many(struct list_head *head);
>  struct Qdisc *dev_graft_qdisc(struct netdev_queue *dev_queue,
>  			      struct Qdisc *qdisc);
>  void qdisc_reset(struct Qdisc *qdisc);
> +void qdisc_destroy(struct Qdisc *qdisc);
>  void qdisc_put(struct Qdisc *qdisc);
>  void qdisc_put_unlocked(struct Qdisc *qdisc);
>  void qdisc_tree_reduce_backlog(struct Qdisc *qdisc, int n, int len);
> diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
> index f72a581666a2..b3bafa6c1b44 100644
> --- a/net/sched/sch_api.c
> +++ b/net/sched/sch_api.c
> @@ -1080,10 +1080,18 @@ static int qdisc_graft(struct net_device *dev, struct Qdisc *parent,
>  		if ((q && q->flags & TCQ_F_INGRESS) ||
>  		    (new && new->flags & TCQ_F_INGRESS)) {
>  			ingress = 1;
> -			if (!dev_ingress_queue(dev)) {
> +			dev_queue = dev_ingress_queue(dev);
> +			if (!dev_queue) {
>  				NL_SET_ERR_MSG(extack, "Device does not have an ingress queue");
>  				return -ENOENT;
>  			}
> +
> +			/* Replay if the current ingress (or clsact) Qdisc has ongoing
> +			 * RTNL-unlocked filter request(s).  This is the counterpart of that
> +			 * qdisc_refcount_inc_nz() call in __tcf_qdisc_find().
> +			 */
> +			if (!qdisc_refcount_dec_if_one(dev_queue->qdisc_sleeping))
> +				return -EAGAIN;
>  		}
>  
>  		if (dev->flags & IFF_UP)
> @@ -1104,8 +1112,16 @@ static int qdisc_graft(struct net_device *dev, struct Qdisc *parent,
>  				qdisc_put(old);
>  			}
>  		} else {
> -			dev_queue = dev_ingress_queue(dev);
> -			old = dev_graft_qdisc(dev_queue, new);
> +			old = dev_graft_qdisc(dev_queue, NULL);
> +
> +			/* {ingress,clsact}_destroy() @old before grafting @new to avoid
> +			 * unprotected concurrent accesses to net_device::miniq_{in,e}gress
> +			 * pointer(s) in mini_qdisc_pair_swap().
> +			 */
> +			qdisc_notify(net, skb, n, classid, old, new, extack);
> +			qdisc_destroy(old);
> +
> +			dev_graft_qdisc(dev_queue, new);
>  		}
>  
>  skip:
> @@ -1119,8 +1135,6 @@ static int qdisc_graft(struct net_device *dev, struct Qdisc *parent,
>  
>  			if (new && new->ops->attach)
>  				new->ops->attach(new);
> -		} else {
> -			notify_and_destroy(net, skb, n, classid, old, new, extack);
>  		}
>  
>  		if (dev->flags & IFF_UP)
> @@ -1458,6 +1472,7 @@ static int tc_get_qdisc(struct sk_buff *skb, struct nlmsghdr *n,
>  	struct Qdisc *p = NULL;
>  	int err;
>  
> +replay:

Perhaps also set q and p to NULL here? Even though on cursory look you
should get the same lookup result since the function is called under
rtnl_lock, tc_modify_qdisc() does this on replay ("Reinit, just in case
something touches this.") and tc_new_tfilter() got some non-obvious bugs
after I introduced replay there without re-setting some of the required
variables.

>  	err = nlmsg_parse_deprecated(n, sizeof(*tcm), tca, TCA_MAX,
>  				     rtm_tca_policy, extack);
>  	if (err < 0)
> @@ -1515,8 +1530,11 @@ static int tc_get_qdisc(struct sk_buff *skb, struct nlmsghdr *n,
>  			return -ENOENT;
>  		}
>  		err = qdisc_graft(dev, p, skb, n, clid, NULL, q, extack);
> -		if (err != 0)
> +		if (err != 0) {
> +			if (err == -EAGAIN)
> +				goto replay;
>  			return err;
> +		}
>  	} else {
>  		qdisc_notify(net, skb, n, clid, NULL, q, NULL);
>  	}
> @@ -1704,6 +1722,8 @@ static int tc_modify_qdisc(struct sk_buff *skb, struct nlmsghdr *n,
>  	if (err) {
>  		if (q)
>  			qdisc_put(q);
> +		if (err == -EAGAIN)
> +			goto replay;
>  		return err;
>  	}
>  
> diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
> index 37e41f972f69..e14ed47f961c 100644
> --- a/net/sched/sch_generic.c
> +++ b/net/sched/sch_generic.c
> @@ -1046,7 +1046,7 @@ static void qdisc_free_cb(struct rcu_head *head)
>  	qdisc_free(q);
>  }
>  
> -static void qdisc_destroy(struct Qdisc *qdisc)
> +static void __qdisc_destroy(struct Qdisc *qdisc)
>  {
>  	const struct Qdisc_ops  *ops = qdisc->ops;
>  
> @@ -1070,6 +1070,14 @@ static void qdisc_destroy(struct Qdisc *qdisc)
>  	call_rcu(&qdisc->rcu, qdisc_free_cb);
>  }
>  
> +void qdisc_destroy(struct Qdisc *qdisc)
> +{
> +	if (qdisc->flags & TCQ_F_BUILTIN)
> +		return;
> +
> +	__qdisc_destroy(qdisc);
> +}
> +
>  void qdisc_put(struct Qdisc *qdisc)
>  {
>  	if (!qdisc)
> @@ -1079,7 +1087,7 @@ void qdisc_put(struct Qdisc *qdisc)
>  	    !refcount_dec_and_test(&qdisc->refcnt))
>  		return;
>  
> -	qdisc_destroy(qdisc);
> +	__qdisc_destroy(qdisc);
>  }
>  EXPORT_SYMBOL(qdisc_put);
>  
> @@ -1094,7 +1102,7 @@ void qdisc_put_unlocked(struct Qdisc *qdisc)
>  	    !refcount_dec_and_rtnl_lock(&qdisc->refcnt))
>  		return;
>  
> -	qdisc_destroy(qdisc);
> +	__qdisc_destroy(qdisc);
>  	rtnl_unlock();
>  }
>  EXPORT_SYMBOL(qdisc_put_unlocked);


