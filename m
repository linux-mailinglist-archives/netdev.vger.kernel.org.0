Return-Path: <netdev+bounces-1566-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D698B6FE4D4
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 22:11:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A30701C20DF1
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 20:11:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83634182C8;
	Wed, 10 May 2023 20:11:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7866A8C0F
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 20:11:28 +0000 (UTC)
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7909D59CA;
	Wed, 10 May 2023 13:11:26 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id af79cd13be357-75771dd7242so249559685a.1;
        Wed, 10 May 2023 13:11:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683749485; x=1686341485;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DX6xfM+tgjnrZohY3AHnsDjOHFn31AfRA9AFGJzcssU=;
        b=qIEuaBEAG910FWeZUW6fjZGGuqPORIz0qsUK2jOZKqYn+xvlv/tphXBC+vl8TSYlvJ
         7dHyPAcdWJWXnn52pz8QLk9+fJj3MZy3+R5eK5jnqhOxE2UvHU3D49Q56vJgyKH8xhYe
         5s6+H2aDKh6tq/7JLQPn1pddQ9J6Eggx0Vjw48/s/mxD0/RJYgsmjJn+hUBS2f5kT2bB
         Ywzk1MuOKxvKIlUO9sPFAxQCJs8xEixGbzQ56iACz9uihhdm4qKEpIdQrFw7RXttRfc4
         JETJF5fpLHuDAwFgxCkvtyWvhvwquhSwvSTpYSKnoU5QdQbtvBHDCdc0jM+KdGWSjYG3
         znYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683749485; x=1686341485;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DX6xfM+tgjnrZohY3AHnsDjOHFn31AfRA9AFGJzcssU=;
        b=Pk3e8z11gMVuqe68BTTDBjcwI6WkNojNWGwepGRDUt/Qxl/246fHKb0+ErUFYJMvjT
         vn8UjwKphRXsGtaEJoxMKX4B2vC/TWXrIZCIEykCb836KDgUsTzTNO35Si/OJNpWNXc+
         dLQPbeZpghVOQ75l/q6kJlSs9aGVMQ6NM2nczxXe7c20OEp9w34GsSBb9JmfFpoZ+SJF
         vdRQ3dCiezE1wDXRPPrXMjJzB34LMRB7dnEOFOvG69rvDWyzz0mhecxTQEI+dKEruG7b
         3N/6a0lk47SnOHuMmMwppMToGlA6K09LmU2Y4tOguZrScNe3O/qe25rARQla91bxF6BA
         kU2A==
X-Gm-Message-State: AC+VfDzp31aESG7sFkd/rDu08MJDkRRGkq/yRnDIHZMswnKWOdNPjEwf
	BZm59MhVSy5Q3JbQXyCJWw==
X-Google-Smtp-Source: ACHHUZ7ovXfUg5FlhQiZKO42A2N09WOqM43bDib3z1sJr6bzJoGR6eSLyGevxj9gvgLkv//ofyi+/A==
X-Received: by 2002:ac8:7d4f:0:b0:3f3:9502:6152 with SMTP id h15-20020ac87d4f000000b003f395026152mr14936577qtb.49.1683749485484;
        Wed, 10 May 2023 13:11:25 -0700 (PDT)
Received: from C02FL77VMD6R.googleapis.com ([2600:1700:d860:12b0:c0d6:9de9:187f:dba])
        by smtp.gmail.com with ESMTPSA id n18-20020ae9c312000000b0074e003c55f0sm4197678qkg.102.2023.05.10.13.11.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 May 2023 13:11:24 -0700 (PDT)
Date: Wed, 10 May 2023 13:11:19 -0700
From: Peilin Ye <yepeilin.cs@gmail.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Cong Wang <xiyou.wangcong@gmail.com>, Jiri Pirko <jiri@resnulli.us>,
	Peilin Ye <peilin.ye@bytedance.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Vlad Buslov <vladbu@mellanox.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	Hillf Danton <hdanton@sina.com>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>
Subject: Re: [PATCH net 6/6] net/sched: qdisc_destroy() old ingress and
 clsact Qdiscs before grafting
Message-ID: <ZFv6Z7hssZ9snNAw@C02FL77VMD6R.googleapis.com>
References: <cover.1683326865.git.peilin.ye@bytedance.com>
 <e6c4681dd9205d702ae2e6124e20c6210520e76e.1683326865.git.peilin.ye@bytedance.com>
 <20230508183324.020f3ec7@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230508183324.020f3ec7@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 08, 2023 at 06:33:24PM -0700, Jakub Kicinski wrote:
> Great analysis, thanks for squashing this bug.

Thanks, happy to help!

> Have you considered creating a fix more localized to the miniq
> implementation? It seems that having per-device miniq pointers is
> incompatible with using reference counted objects. So miniq is
> a more natural place to solve the problem. Otherwise workarounds
> in the core keep piling up (here qdisc_graft()).
>
> Can we replace the rcu_assign_pointer in (3rd) with a cmpxchg()?
> If active qdisc is neither a1 nor a2 we should leave the dev state
> alone.

Yes, I have tried fixing this in mini_qdisc_pair_swap(), but I am afraid
it is hard:

(3rd) is called from ->destroy(), so currently it uses RCU_INIT_POINTER()
to set dev->miniq_ingress to NULL.  It will need a logic like:

  I am A.  Set dev->miniq_ingress to NULL, if and only if it is a1 or a2,
  and do it atomically.

We need more than a cmpxchg() to implement this "set NULL iff a1 or a2".
Additionally:

On Fri,  5 May 2023 17:16:10 -0700 Peilin Ye wrote:
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
>   RTM_NEWTFILTER (X, RTNL-lockless)
>    __tcf_qdisc_find(A)          10
>    tcf_chain0_head_change(A)
>    mini_qdisc_pair_swap(A) (1st)
>             |
>             |                         RTM_NEWQDISC (B, RTNL-locked)
>            RCU                   2     qdisc_graft(B)
>             |                    1     notify_and_destroy(A)
>             |
>    tcf_block_release(A)          0    RTM_NEWTFILTER (Y, RTNL-lockless)
>    qdisc_destroy(A)                    tcf_chain0_head_change(B)
>    tcf_chain0_head_change_cb_del(A)    mini_qdisc_pair_swap(B) (2nd)
>    mini_qdisc_pair_swap(A) (3rd)                |
>            ...                                 ...

Looking at the code, I think there is no guarantee that (1st) cannot
happen after (2nd), although unlikely?  Can RTNL-lockless RTM_NEWTFILTER
handlers get preempted?

If (1st) happens later than (2nd), we will need to make (1st) no-op, by
detecting that we are the "old" Qdisc.  I am not sure there is any
(clean) way to do it.  I even thought about:

  (1) Get the containing Qdisc of "miniqp" we are working on, "qdisc";
  (2) Test if "qdisc == qdisc->dev_queue->qdisc_sleeping".  If false, it
      means we are the "old" Qdisc (have been replaced), and should do
      nothing.

However, for clsact Qdiscs I don't know if "miniqp" is the ingress or
egress one, so I can't container_of() during step (1) ...

Eventually I created [5,6/6].  It is a workaround indeed, in the sense
that it changes sch_api.c to avoid a mini Qdisc issue.  However I think it
makes the code correct in a relatively understandable way, without slowing
down mini_qdisc_pair_swap() or sch_handle_*gress().

Thanks,
Peilin Ye


