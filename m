Return-Path: <netdev+bounces-5107-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 532DE70FA9A
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 17:41:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 83E0228143B
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 15:41:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BE5D19BBC;
	Wed, 24 May 2023 15:41:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89F9718C19
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 15:41:28 +0000 (UTC)
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EBBFE50
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 08:41:06 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id 5614622812f47-39415d3526bso178289b6e.2
        for <netdev@vger.kernel.org>; Wed, 24 May 2023 08:41:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1684942798; x=1687534798;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ie1gW99X/HfQLymQyv3hMisxA5On2/0Wf20XM7jeBo0=;
        b=TQvlg1nbPjHwCfXOUvtX/xH9GVXY+9oUCsCUn93EQEXXeCBxkIn8tQG4lsaSVObx83
         xVimlSg5xEbRSpcm5V6favLBJ4Iicllq89cXAKTzuBj1cfi5+GCSahleqcjIeRBdDSb0
         HryMQoqjppuFylE/E72KNB0QNT6MrMOFFEHBfiu996uqnaA9OafuSzky1qnyZvcU7/9K
         t/w+0NEs8mRvl37ncSYzx94LXJhvaUw6ULnutlE3uiU3e2XzwaFWSo/PHNHSV2ds0XWd
         4rwnGTnmcbX3ETUmz1zT0K16kLrbW/qtlw/kxKswzJ4TlUPMnKz22pgFbddw93r1pqAE
         gS3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684942798; x=1687534798;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ie1gW99X/HfQLymQyv3hMisxA5On2/0Wf20XM7jeBo0=;
        b=TIaeHlFfbAwFbwJlOl9/uZu3pw3Su1dlOtUl+JY4bSKfiHH2YzsWS5LBifB39wxTfQ
         9xgmFU/JFjH6unzV++ZHiAAix9yIwMpmo2ncLq/oRSu6xBBLGKAtZ1EMfGfabemLp7DK
         zJsw+ILTIfzbZhlPcYBKvnUR/O3AwypZyoO65EM47s0Hi2xiTMF0ppFLq2m2Vy96TEAo
         FrQr2mdlETkU5UcJTbZmtW8IfZph8PLx9eZDDYIDOV76Ia/tzgeLJUYryF8YwuK0caqG
         0MsoruFWAM1KgwPgR+GFRf1mJCN9WlCpVDw5MMP/JGmB+ODSxk5hroYtoAah31Quer0Y
         XEww==
X-Gm-Message-State: AC+VfDygI4lXilWZyLwB+tLDc1t9PqxTq7PfL+DXiXvq5DxHMCSEFaQg
	bJpkDRuaIfMkWs9hiOv/MXeNLKw2zp8vyohUDR8=
X-Google-Smtp-Source: ACHHUZ5ivw6t694j0RBq6mTqlLI6mRsx/3LUUkWgcFdl3BNXja9qPjWEq3q5uJR6CrxsGdemQ0QV0g==
X-Received: by 2002:a05:6808:2811:b0:397:fb0a:b665 with SMTP id et17-20020a056808281100b00397fb0ab665mr5741499oib.6.1684942798405;
        Wed, 24 May 2023 08:39:58 -0700 (PDT)
Received: from ?IPV6:2804:14d:5c5e:44fb:522c:f73f:493b:2b5? ([2804:14d:5c5e:44fb:522c:f73f:493b:2b5])
        by smtp.gmail.com with ESMTPSA id az14-20020a056808164e00b0038e086c764dsm4972343oib.43.2023.05.24.08.39.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 May 2023 08:39:58 -0700 (PDT)
Message-ID: <faaeb0b0-8538-9dfa-4c1e-8a225e3534f4@mojatatu.com>
Date: Wed, 24 May 2023 12:39:52 -0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v5 net 6/6] net/sched: qdisc_destroy() old ingress and
 clsact Qdiscs before grafting
Content-Language: en-US
To: Peilin Ye <yepeilin.cs@gmail.com>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Jamal Hadi Salim <jhs@mojatatu.com>, Cong Wang <xiyou.wangcong@gmail.com>,
 Jiri Pirko <jiri@resnulli.us>
Cc: Peilin Ye <peilin.ye@bytedance.com>,
 Daniel Borkmann <daniel@iogearbox.net>,
 John Fastabend <john.fastabend@gmail.com>, Vlad Buslov
 <vladbu@mellanox.com>, Hillf Danton <hdanton@sina.com>,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 Cong Wang <cong.wang@bytedance.com>
References: <cover.1684887977.git.peilin.ye@bytedance.com>
 <429357af094297abbc45f47b8e606f11206df049.1684887977.git.peilin.ye@bytedance.com>
From: Pedro Tammela <pctammela@mojatatu.com>
In-Reply-To: <429357af094297abbc45f47b8e606f11206df049.1684887977.git.peilin.ye@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 23/05/2023 22:20, Peilin Ye wrote:
> From: Peilin Ye <peilin.ye@bytedance.com>
> 
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
>   BUG: KASAN: slab-use-after-free in mini_qdisc_pair_swap+0x1c2/0x1f0 net/sched/sch_generic.c:1573
>   Write of size 8 at addr ffff888045b31308 by task syz-executor690/14901
> ...
>   Call Trace:
>    <TASK>
>    __dump_stack lib/dump_stack.c:88 [inline]
>    dump_stack_lvl+0xd9/0x150 lib/dump_stack.c:106
>    print_address_description.constprop.0+0x2c/0x3c0 mm/kasan/report.c:319
>    print_report mm/kasan/report.c:430 [inline]
>    kasan_report+0x11c/0x130 mm/kasan/report.c:536
>    mini_qdisc_pair_swap+0x1c2/0x1f0 net/sched/sch_generic.c:1573
>    tcf_chain_head_change_item net/sched/cls_api.c:495 [inline]
>    tcf_chain0_head_change.isra.0+0xb9/0x120 net/sched/cls_api.c:509
>    tcf_chain_tp_insert net/sched/cls_api.c:1826 [inline]
>    tcf_chain_tp_insert_unique net/sched/cls_api.c:1875 [inline]
>    tc_new_tfilter+0x1de6/0x2290 net/sched/cls_api.c:2266
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
>    Thread 1 creates ingress Qdisc A (containing mini Qdisc a1 and a2), then
>    adds a flower filter X to A.
> 
>    Thread 2 creates another ingress Qdisc B (containing mini Qdisc b1 and
>    b2) to replace A, then adds a flower filter Y to B.
> 
>   Thread 1               A's refcnt   Thread 2
>    RTM_NEWQDISC (A, RTNL-locked)
>     qdisc_create(A)               1
>     qdisc_graft(A)                9
> 
>    RTM_NEWTFILTER (X, RTNL-unlocked)
>     __tcf_qdisc_find(A)          10
>     tcf_chain0_head_change(A)
>     mini_qdisc_pair_swap(A) (1st)
>              |
>              |                         RTM_NEWQDISC (B, RTNL-locked)
>           RCU sync                2     qdisc_graft(B)
>              |                    1     notify_and_destroy(A)
>              |
>     tcf_block_release(A)          0    RTM_NEWTFILTER (Y, RTNL-unlocked)
>     qdisc_destroy(A)                    tcf_chain0_head_change(B)
>     tcf_chain0_head_change_cb_del(A)    mini_qdisc_pair_swap(B) (2nd)
>     mini_qdisc_pair_swap(A) (3rd)                |
>             ...                                 ...
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

Tested-by: Pedro Tammela <pctammela@mojatatu.com>

> ---
> change in v5:
>    - reinitialize @q, @p (suggested by Vlad) and @tcm before replaying,
>      just like @flags in tc_new_tfilter()
> 
> change in v3, v4:
>    - add in-body From: tag
> 
> changes in v2:
>    - replay the request if the current Qdisc has any ongoing RTNL-unlocked
>      filter requests (Vlad)
>    - minor changes in code comments and commit log
> 
>   include/net/sch_generic.h |  8 ++++++++
>   net/sched/sch_api.c       | 40 ++++++++++++++++++++++++++++++---------
>   net/sched/sch_generic.c   | 14 +++++++++++---
>   3 files changed, 50 insertions(+), 12 deletions(-)
> 
> diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
> index fab5ba3e61b7..3e9cc43cbc90 100644
> --- a/include/net/sch_generic.h
> +++ b/include/net/sch_generic.h
> @@ -137,6 +137,13 @@ static inline void qdisc_refcount_inc(struct Qdisc *qdisc)
>   	refcount_inc(&qdisc->refcnt);
>   }
>   
> +static inline bool qdisc_refcount_dec_if_one(struct Qdisc *qdisc)
> +{
> +	if (qdisc->flags & TCQ_F_BUILTIN)
> +		return true;
> +	return refcount_dec_if_one(&qdisc->refcnt);
> +}
> +
>   /* Intended to be used by unlocked users, when concurrent qdisc release is
>    * possible.
>    */
> @@ -652,6 +659,7 @@ void dev_deactivate_many(struct list_head *head);
>   struct Qdisc *dev_graft_qdisc(struct netdev_queue *dev_queue,
>   			      struct Qdisc *qdisc);
>   void qdisc_reset(struct Qdisc *qdisc);
> +void qdisc_destroy(struct Qdisc *qdisc);
>   void qdisc_put(struct Qdisc *qdisc);
>   void qdisc_put_unlocked(struct Qdisc *qdisc);
>   void qdisc_tree_reduce_backlog(struct Qdisc *qdisc, int n, int len);
> diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
> index f72a581666a2..286b7c58f5b9 100644
> --- a/net/sched/sch_api.c
> +++ b/net/sched/sch_api.c
> @@ -1080,10 +1080,18 @@ static int qdisc_graft(struct net_device *dev, struct Qdisc *parent,
>   		if ((q && q->flags & TCQ_F_INGRESS) ||
>   		    (new && new->flags & TCQ_F_INGRESS)) {
>   			ingress = 1;
> -			if (!dev_ingress_queue(dev)) {
> +			dev_queue = dev_ingress_queue(dev);
> +			if (!dev_queue) {
>   				NL_SET_ERR_MSG(extack, "Device does not have an ingress queue");
>   				return -ENOENT;
>   			}
> +
> +			/* Replay if the current ingress (or clsact) Qdisc has ongoing
> +			 * RTNL-unlocked filter request(s).  This is the counterpart of that
> +			 * qdisc_refcount_inc_nz() call in __tcf_qdisc_find().
> +			 */
> +			if (!qdisc_refcount_dec_if_one(dev_queue->qdisc_sleeping))
> +				return -EAGAIN;
>   		}
>   
>   		if (dev->flags & IFF_UP)
> @@ -1104,8 +1112,16 @@ static int qdisc_graft(struct net_device *dev, struct Qdisc *parent,
>   				qdisc_put(old);
>   			}
>   		} else {
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
>   		}
>   
>   skip:
> @@ -1119,8 +1135,6 @@ static int qdisc_graft(struct net_device *dev, struct Qdisc *parent,
>   
>   			if (new && new->ops->attach)
>   				new->ops->attach(new);
> -		} else {
> -			notify_and_destroy(net, skb, n, classid, old, new, extack);
>   		}
>   
>   		if (dev->flags & IFF_UP)
> @@ -1450,19 +1464,22 @@ static int tc_get_qdisc(struct sk_buff *skb, struct nlmsghdr *n,
>   			struct netlink_ext_ack *extack)
>   {
>   	struct net *net = sock_net(skb->sk);
> -	struct tcmsg *tcm = nlmsg_data(n);
>   	struct nlattr *tca[TCA_MAX + 1];
>   	struct net_device *dev;
> +	struct Qdisc *q, *p;
> +	struct tcmsg *tcm;
>   	u32 clid;
> -	struct Qdisc *q = NULL;
> -	struct Qdisc *p = NULL;
>   	int err;
>   
> +replay:
>   	err = nlmsg_parse_deprecated(n, sizeof(*tcm), tca, TCA_MAX,
>   				     rtm_tca_policy, extack);
>   	if (err < 0)
>   		return err;
>   
> +	tcm = nlmsg_data(n);
> +	q = p = NULL;
> +
>   	dev = __dev_get_by_index(net, tcm->tcm_ifindex);
>   	if (!dev)
>   		return -ENODEV;
> @@ -1515,8 +1532,11 @@ static int tc_get_qdisc(struct sk_buff *skb, struct nlmsghdr *n,
>   			return -ENOENT;
>   		}
>   		err = qdisc_graft(dev, p, skb, n, clid, NULL, q, extack);
> -		if (err != 0)
> +		if (err != 0) {
> +			if (err == -EAGAIN)
> +				goto replay;
>   			return err;
> +		}
>   	} else {
>   		qdisc_notify(net, skb, n, clid, NULL, q, NULL);
>   	}
> @@ -1704,6 +1724,8 @@ static int tc_modify_qdisc(struct sk_buff *skb, struct nlmsghdr *n,
>   	if (err) {
>   		if (q)
>   			qdisc_put(q);
> +		if (err == -EAGAIN)
> +			goto replay;
>   		return err;
>   	}
>   
> diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
> index 37e41f972f69..e14ed47f961c 100644
> --- a/net/sched/sch_generic.c
> +++ b/net/sched/sch_generic.c
> @@ -1046,7 +1046,7 @@ static void qdisc_free_cb(struct rcu_head *head)
>   	qdisc_free(q);
>   }
>   
> -static void qdisc_destroy(struct Qdisc *qdisc)
> +static void __qdisc_destroy(struct Qdisc *qdisc)
>   {
>   	const struct Qdisc_ops  *ops = qdisc->ops;
>   
> @@ -1070,6 +1070,14 @@ static void qdisc_destroy(struct Qdisc *qdisc)
>   	call_rcu(&qdisc->rcu, qdisc_free_cb);
>   }
>   
> +void qdisc_destroy(struct Qdisc *qdisc)
> +{
> +	if (qdisc->flags & TCQ_F_BUILTIN)
> +		return;
> +
> +	__qdisc_destroy(qdisc);
> +}
> +
>   void qdisc_put(struct Qdisc *qdisc)
>   {
>   	if (!qdisc)
> @@ -1079,7 +1087,7 @@ void qdisc_put(struct Qdisc *qdisc)
>   	    !refcount_dec_and_test(&qdisc->refcnt))
>   		return;
>   
> -	qdisc_destroy(qdisc);
> +	__qdisc_destroy(qdisc);
>   }
>   EXPORT_SYMBOL(qdisc_put);
>   
> @@ -1094,7 +1102,7 @@ void qdisc_put_unlocked(struct Qdisc *qdisc)
>   	    !refcount_dec_and_rtnl_lock(&qdisc->refcnt))
>   		return;
>   
> -	qdisc_destroy(qdisc);
> +	__qdisc_destroy(qdisc);
>   	rtnl_unlock();
>   }
>   EXPORT_SYMBOL(qdisc_put_unlocked);


