Return-Path: <netdev+bounces-873-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 310DC6FB252
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 16:12:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 64B201C20998
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 14:12:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A07615CC;
	Mon,  8 May 2023 14:12:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 591781361
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 14:12:33 +0000 (UTC)
Received: from mail-oo1-xc2b.google.com (mail-oo1-xc2b.google.com [IPv6:2607:f8b0:4864:20::c2b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53A9126EA0
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 07:12:31 -0700 (PDT)
Received: by mail-oo1-xc2b.google.com with SMTP id 006d021491bc7-547299bf5d8so2405664eaf.3
        for <netdev@vger.kernel.org>; Mon, 08 May 2023 07:12:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1683555150; x=1686147150;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BBOQSpkdgEYQoD0cZBQYsHQxADMQ0Ee2J69WM/3BE8A=;
        b=MUtcbcUw5esCCgp4x+vUb/UV0ODUgw50C0iNwE6UAv0KhGAYBUH8FPNM5fmHHbTqpJ
         tzopdR07m03eoV6eRAG+15P+FSn198UeuQaWhRN1g/y4CcB8p4hQ8Wcq0aT6QHUuV35k
         EGP3reVXErzf4h0BIRvqZ3C0ajV/1CoLs6p6BqEXGT5zf9hKKjzIXfn5YMwMOA4Uqxyl
         nqis8oopjaGFxxK72o3DAJwz1J8VUOAVjFtmHxBwmzVEXAzX3+JlCbb5G/087ukOaej3
         E0pYUC3cV1vG9IidyR+OUOpJ54OERTb/yOHJa9Wmju7ptPvWCXmIPL0LqA1+/suA3QaX
         LdZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683555150; x=1686147150;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BBOQSpkdgEYQoD0cZBQYsHQxADMQ0Ee2J69WM/3BE8A=;
        b=ZBqgtJ+M5A+a6AbQy0HKMWtYppfRMoF16Up6nHeN+D/9mw/smYz2RPqf3mHNAJIDjL
         zDn/P5C06ZHKMVTgvkdkbzOKaYvljxT4jWosnHAUZvIcwr1qz2ZS9V0FtJeTpYy55+vK
         0aYheDf+q09mYcCsw2AUraDAxVSh+/zNUs051EIKQPBqXbr4r8JpELnYwfDhheCHkopI
         j4D0MzqLZAv2WvJyJgU/dA0sdWlYtW5g2GknePceXGLvlvFgttcuYbPQY3FmbA0/F1fM
         yd1YZY0cH9cgmkFXbdeKpTMRk5emay7iYDEowk686IA48qmhG1Ffk7kpYo5BXkgFoCgw
         Hf2g==
X-Gm-Message-State: AC+VfDwgp8xs4kxna2jYk6m2Yc6er3ko/DGngXqIKCP38RzXc7zTkmEv
	2D2Zhr7Ghez/fSbN0mOhBptJEQ==
X-Google-Smtp-Source: ACHHUZ452vNcTu3t4t5ExsibTngkr7q0+nbdS5zZNNLu8gFvM+W4aH0XDZFmvmdh2M6DzEk2QRibyw==
X-Received: by 2002:a54:481a:0:b0:384:374c:43c7 with SMTP id j26-20020a54481a000000b00384374c43c7mr4285626oij.25.1683555150609;
        Mon, 08 May 2023 07:12:30 -0700 (PDT)
Received: from ?IPV6:2804:14d:5c5e:44fb:d672:f891:23e9:e156? ([2804:14d:5c5e:44fb:d672:f891:23e9:e156])
        by smtp.gmail.com with ESMTPSA id bh11-20020a056808180b00b0038934c5b400sm20671oib.25.2023.05.08.07.12.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 May 2023 07:12:30 -0700 (PDT)
Message-ID: <2cef1199-98ae-32c1-0e5f-06c69a0eb843@mojatatu.com>
Date: Mon, 8 May 2023 11:12:24 -0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net 6/6] net/sched: qdisc_destroy() old ingress and clsact
 Qdiscs before grafting
Content-Language: en-US
To: Peilin Ye <yepeilin.cs@gmail.com>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Jamal Hadi Salim <jhs@mojatatu.com>, Cong Wang <xiyou.wangcong@gmail.com>,
 Jiri Pirko <jiri@resnulli.us>
Cc: Peilin Ye <peilin.ye@bytedance.com>,
 Daniel Borkmann <daniel@iogearbox.net>,
 John Fastabend <john.r.fastabend@intel.com>,
 Vlad Buslov <vladbu@mellanox.com>, Hillf Danton <hdanton@sina.com>,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 Cong Wang <cong.wang@bytedance.com>
References: <cover.1683326865.git.peilin.ye@bytedance.com>
 <e6c4681dd9205d702ae2e6124e20c6210520e76e.1683326865.git.peilin.ye@bytedance.com>
From: Pedro Tammela <pctammela@mojatatu.com>
In-Reply-To: <e6c4681dd9205d702ae2e6124e20c6210520e76e.1683326865.git.peilin.ye@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 05/05/2023 21:16, Peilin Ye wrote:
> mini_Qdisc_pair::p_miniq is a double pointer to mini_Qdisc, initialized in
> ingress_init() to point to net_device::miniq_ingress.  ingress Qdiscs
> access this per-net_device pointer in mini_qdisc_pair_swap().  Similar for
> clsact Qdiscs and miniq_egress.
> 
> Unfortunately, after introducing RTNL-lockless RTM_{NEW,DEL,GET}TFILTER
> requests, when e.g. replacing ingress (clsact) Qdiscs, the old Qdisc could
> access the same miniq_{in,e}gress pointer(s) concurrently with the new
> Qdisc, causing race conditions [1] including a use-after-free in
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
> The new (ingress or clsact) Qdisc should only call mini_qdisc_pair_swap()
> after the old Qdisc's last call (in {ingress,clsact}_destroy()) has
> finished.
> 
> To achieve this, in qdisc_graft(), return -EBUSY if the old (ingress or
> clsact) Qdisc has ongoing RTNL-lockless filter requests, and call
> qdisc_destroy() for "old" before grafting "new".
> 
> Introduce qdisc_refcount_dec_if_one() as the counterpart of
> qdisc_refcount_inc_nz() used for RTNL-lockless filter requests.  Introduce
> a non-static version of qdisc_destroy() that does a TCQ_F_BUILTIN check,
> just like qdisc_put() etc.
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
>    RTM_NEWTFILTER (X, RTNL-lockless)
>     __tcf_qdisc_find(A)          10
>     tcf_chain0_head_change(A)
>     mini_qdisc_pair_swap(A) (1st)
>              |
>              |                         RTM_NEWQDISC (B, RTNL-locked)
>             RCU                   2     qdisc_graft(B)
>              |                    1     notify_and_destroy(A)
>              |
>     tcf_block_release(A)          0    RTM_NEWTFILTER (Y, RTNL-lockless)
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
> This is just one of the possible consequences of concurrently accessing
> net_device::miniq_{in,e}gress pointers.  The point is clear, however:
> B's first call to mini_qdisc_pair_swap() should take place after A's
> last call, in qdisc_destroy().
> 
> Fixes: 7a096d579e8e ("net: sched: ingress: set 'unlocked' flag for Qdisc ops")
> Fixes: 87f373921c4e ("net: sched: ingress: set 'unlocked' flag for clsact Qdisc ops")
> Reported-by: syzbot+b53a9c0d1ea4ad62da8b@syzkaller.appspotmail.com
> Link: https://lore.kernel.org/netdev/0000000000006cf87705f79acf1a@google.com
> Cc: Hillf Danton <hdanton@sina.com>
> Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>

Thanks for chasing this!

Tested-by: Pedro Tammela <pctammela@mojatatu.com>

> ---
>   include/net/sch_generic.h |  8 ++++++++
>   net/sched/sch_api.c       | 26 +++++++++++++++++++++-----
>   net/sched/sch_generic.c   | 14 +++++++++++---
>   3 files changed, 40 insertions(+), 8 deletions(-)
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
> index f72a581666a2..a2d07bc8ded6 100644
> --- a/net/sched/sch_api.c
> +++ b/net/sched/sch_api.c
> @@ -1080,10 +1080,20 @@ static int qdisc_graft(struct net_device *dev, struct Qdisc *parent,
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
> +			/* This is the counterpart of that qdisc_refcount_inc_nz() call in
> +			 * __tcf_qdisc_find() for RTNL-lockless filter requests.
> +			 */
> +			if (!qdisc_refcount_dec_if_one(dev_queue->qdisc_sleeping)) {
> +				NL_SET_ERR_MSG(extack,
> +					       "Current ingress or clsact Qdisc has ongoing filter request(s)");
> +				return -EBUSY;
> +			}
>   		}
>   
>   		if (dev->flags & IFF_UP)
> @@ -1104,8 +1114,16 @@ static int qdisc_graft(struct net_device *dev, struct Qdisc *parent,
>   				qdisc_put(old);
>   			}
>   		} else {
> -			dev_queue = dev_ingress_queue(dev);
> -			old = dev_graft_qdisc(dev_queue, new);
> +			old = dev_graft_qdisc(dev_queue, NULL);
> +
> +			/* {ingress,clsact}_destroy() "old" before grafting "new" to avoid
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
> @@ -1119,8 +1137,6 @@ static int qdisc_graft(struct net_device *dev, struct Qdisc *parent,
>   
>   			if (new && new->ops->attach)
>   				new->ops->attach(new);
> -		} else {
> -			notify_and_destroy(net, skb, n, classid, old, new, extack);
>   		}
>   
>   		if (dev->flags & IFF_UP)
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


