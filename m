Return-Path: <netdev+bounces-7086-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EAA5E719CDE
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 15:03:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BDACF1C21033
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 13:03:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29842BA3B;
	Thu,  1 Jun 2023 13:03:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1290123414
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 13:03:32 +0000 (UTC)
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53CBE124
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 06:03:29 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id 5614622812f47-39831cb47c6so219987b6e.2
        for <netdev@vger.kernel.org>; Thu, 01 Jun 2023 06:03:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1685624608; x=1688216608;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=O2MTHcbXgwFmYaKWorbkFmW7aLd8OdY8kFW4OcXEY+o=;
        b=Pwy2GFaUzvvvdSQhZuZnSFb6BofUle+kph5ujJtlbNvuo5ifvnoFmkrQLQaYD58Ccc
         68x7AJwX67QLclt6iyBOcrkGltFXCaXTGiIrERPpbIhEKYUOBIir1dOvKQd7JqQHY1eo
         f8BtxCujgVK04KnI0gost7BsyDlSDh0KIiCMkeS+7UOIRttO4S6gE8xqni1uAW6bdt8B
         EYY/R7dJA2zM8CIqVECkCfYPc8uXbo3bsvHEWHtaJyS9uZBy5VSZrVcH5P3t2+9gZep2
         dMG7lCDSqkeiKhxhOmrlIUi+7gQTZheBP4P1Dt8mMsVLjAKI3ktjJio/hBDiiJI/UBJ0
         cRdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685624608; x=1688216608;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O2MTHcbXgwFmYaKWorbkFmW7aLd8OdY8kFW4OcXEY+o=;
        b=DKyTroI8r8+Gx2pT/0o4ISl0F98SPSIPsxkmRYYy7yayhyd8SasqeUqRUC21YWulQk
         n/IGv5Bgh4kyxtRhQXOk8P0pEc/zXs3pBLyW16BAU4zTbFociymnG54MFdIGfvw1AgVW
         U/4/6qzw4jKIU+PJwmxgGAF7479hhaKsufM0YU6WGfj05p2oUAYUuwAo41rU9VuXyleV
         yBfFJRx7rkqfVtEE0kZrk4LK0rlYzbueJpDwhdxNaSybYmxHvgWIyL1wk7q86UMe8gnE
         bT0Yi97Bu8bK3H9pyzoQjjoqMtPfFkO/bbYC1d/TREEHUkPv+Tz6kRMoF52dBXuWMhDX
         RPow==
X-Gm-Message-State: AC+VfDxQpL7M/be9kuVMr+5UVn5dddBJWoeIimArpNILOfjzRzmhPvCr
	tgPLOmJISqeKQAyOzKumRkjTlPGZ9Y95lxq1dTg=
X-Google-Smtp-Source: ACHHUZ6FoCofgxnCPboAjYphMPtuFXkNulJ/p/jUXvJ745JkpR+iBS1nt89sMQRmu97ux5PCwTGPTg==
X-Received: by 2002:aca:6254:0:b0:38c:a20d:d376 with SMTP id w81-20020aca6254000000b0038ca20dd376mr4473852oib.39.1685624608503;
        Thu, 01 Jun 2023 06:03:28 -0700 (PDT)
Received: from ?IPV6:2804:14d:5c5e:44fb:6aab:7933:6a5a:53d6? ([2804:14d:5c5e:44fb:6aab:7933:6a5a:53d6])
        by smtp.gmail.com with ESMTPSA id k184-20020aca3dc1000000b00399ed3b7c56sm1690938oia.35.2023.06.01.06.03.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Jun 2023 06:03:28 -0700 (PDT)
Message-ID: <30a35b1f-9f66-f7c7-61c6-048c1b68efce@mojatatu.com>
Date: Thu, 1 Jun 2023 10:03:22 -0300
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
To: Peilin Ye <yepeilin.cs@gmail.com>, Vlad Buslov <vladbu@nvidia.com>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>, Jakub Kicinski <kuba@kernel.org>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Paolo Abeni <pabeni@redhat.com>, Cong Wang <xiyou.wangcong@gmail.com>,
 Jiri Pirko <jiri@resnulli.us>, Peilin Ye <peilin.ye@bytedance.com>,
 Daniel Borkmann <daniel@iogearbox.net>,
 John Fastabend <john.fastabend@gmail.com>, Hillf Danton <hdanton@sina.com>,
 netdev@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>
References: <CAM0EoM=FS2arxv0__aQXF1a7ViJnM0hST=TL9dcnJpkf-ipjvA@mail.gmail.com>
 <7879f218-c712-e9cc-57ba-665990f5f4c9@mojatatu.com>
 <ZHE8P9Bi6FlKz4US@C02FL77VMD6R.googleapis.com>
 <20230526193324.41dfafc8@kernel.org>
 <ZHG+AR8qgpJ6/Zhx@C02FL77VMD6R.googleapis.com>
 <CAM0EoM=xLkAr5EF7bty+ETmZ3GXnmB9De3fYSCrQjKPb8qDy7Q@mail.gmail.com>
 <87jzwrxrz8.fsf@nvidia.com> <87fs7fxov6.fsf@nvidia.com>
 <ZHW9tMw5oCkratfs@C02FL77VMD6R.googleapis.com> <87bki2xb3d.fsf@nvidia.com>
 <ZHgXL+Bsm2M+ZMiM@C02FL77VMD6R.googleapis.com>
From: Pedro Tammela <pctammela@mojatatu.com>
In-Reply-To: <ZHgXL+Bsm2M+ZMiM@C02FL77VMD6R.googleapis.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 01/06/2023 00:57, Peilin Ye wrote:
> Hi Vlad and all,
> 
> On Tue, May 30, 2023 at 03:18:19PM +0300, Vlad Buslov wrote:
>>>> If livelock with concurrent filters insertion is an issue, then it can
>>>> be remedied by setting a new Qdisc->flags bit
>>>> "DELETED-REJECT-NEW-FILTERS" and checking for it together with
>>>> QDISC_CLASS_OPS_DOIT_UNLOCKED in order to force any concurrent filter
>>>> insertion coming after the flag is set to synchronize on rtnl lock.
>>>
>>> Thanks for the suggestion!  I'll try this approach.
>>>
>>> Currently QDISC_CLASS_OPS_DOIT_UNLOCKED is checked after taking a refcnt of
>>> the "being-deleted" Qdisc.  I'll try forcing "late" requests (that arrive
>>> later than Qdisc is flagged as being-deleted) sync on RTNL lock without
>>> (before) taking the Qdisc refcnt (otherwise I think Task 1 will replay for
>>> even longer?).
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
>                          #1         #2         #3         #4
>    ----------------------------------------------------------
>     a. refcnt            89         93        230        571
>     b. replayed     167,568    196,450    336,291    878,027
>     c. time real   0m2.478s   0m2.746s   0m3.693s   0m9.461s
>             user   0m0.000s   0m0.000s   0m0.000s   0m0.000s
>              sys   0m0.623s   0m0.681s   0m1.119s   0m2.770s
> 
>     a. is the Qdisc refcnt when A calls qdisc_graft() for the first time;
>     b. is the number of times A has been replayed;
>     c. is the time(1) output for A.
> 
> a. and b. are collected from printk() output.  This is better than before,
> but A could still be replayed for hundreds of thousands of times and hang
> for a few seconds.
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
>   #define TCQ_F_INVISIBLE                0x80 /* invisible by default in dump */
>   #define TCQ_F_NOLOCK           0x100 /* qdisc does not require locking */
>   #define TCQ_F_OFFLOADED                0x200 /* qdisc is offloaded to HW */
> +#define TCQ_F_DESTROYING       0x400 /* destroying, reject filter requests */
>          u32                     limit;
>          const struct Qdisc_ops  *ops;
>          struct qdisc_size_table __rcu *stab;
> @@ -185,6 +186,11 @@ static inline bool qdisc_is_empty(const struct Qdisc *qdisc)
>          return !READ_ONCE(qdisc->q.qlen);
>   }
> 
> +static inline bool qdisc_is_destroying(const struct Qdisc *qdisc)
> +{
> +       return qdisc->flags & TCQ_F_DESTROYING;
> +}
> +
>   /* For !TCQ_F_NOLOCK qdisc, qdisc_run_begin/end() must be invoked with
>    * the qdisc root lock acquired.
>    */
> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> index 2621550bfddc..3e7f6f286ac0 100644
> --- a/net/sched/cls_api.c
> +++ b/net/sched/cls_api.c
> @@ -1172,7 +1172,7 @@ static int __tcf_qdisc_find(struct net *net, struct Qdisc **q,
>                  *parent = (*q)->handle;
>          } else {
>                  *q = qdisc_lookup_rcu(dev, TC_H_MAJ(*parent));
> -               if (!*q) {
> +               if (!*q || qdisc_is_destroying(*q)) {
>                          NL_SET_ERR_MSG(extack, "Parent Qdisc doesn't exists");
>                          err = -EINVAL;
>                          goto errout_rcu;
> diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
> index 286b7c58f5b9..d6e47546c7fe 100644
> --- a/net/sched/sch_api.c
> +++ b/net/sched/sch_api.c
> @@ -1086,12 +1086,18 @@ static int qdisc_graft(struct net_device *dev, struct Qdisc *parent,
>                                  return -ENOENT;
>                          }
> 
> -                       /* Replay if the current ingress (or clsact) Qdisc has ongoing
> -                        * RTNL-unlocked filter request(s).  This is the counterpart of that
> -                        * qdisc_refcount_inc_nz() call in __tcf_qdisc_find().
> +                       /* If current ingress (clsact) Qdisc has ongoing filter requests, stop
> +                        * accepting any more by marking it as "being destroyed", then tell the
> +                        * caller to replay by returning -EAGAIN.
>                           */
> -                       if (!qdisc_refcount_dec_if_one(dev_queue->qdisc_sleeping))
> +                       q = dev_queue->qdisc_sleeping;
> +                       if (!qdisc_refcount_dec_if_one(q)) {
> +                               q->flags |= TCQ_F_DESTROYING;
> +                               rtnl_unlock();
> +                               schedule();
Was this intended or just a leftover?
rtnl_lock() would reschedule if needed as it's a mutex_lock
> +                               rtnl_lock();
>                                  return -EAGAIN;
> +                       }
>                  }
> 
>                  if (dev->flags & IFF_UP)
> 


