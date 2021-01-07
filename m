Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4732D2ED3F7
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 17:10:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727994AbhAGQKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 11:10:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726427AbhAGQKY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 11:10:24 -0500
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA458C0612F4
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 08:09:43 -0800 (PST)
Received: by mail-qk1-x749.google.com with SMTP id a17so6491051qko.11
        for <netdev@vger.kernel.org>; Thu, 07 Jan 2021 08:09:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=3RBxr/reMzKfPribD5dZoWu7aXfUyId4YfssBQJvW2o=;
        b=X2liaHVP1bFT2QLr+XbJHbt5yM5hTWrJNrNf1ywq2unnECdQQrOQbB7VsFX/LEiZ2R
         g5TN24fFyMBTSVMtPhm/Egw1TwH2PPbjdd/6agWNNyL139QH7GjyntKKiLcDeF8d+ona
         cM7Wh4ZcKmBIKuoOhM2hfv+G6eLYgqAokj3RxV2SNBQPIOIkzXYzZpmtYA6nWOT4oRi2
         bFqIY2pKwkFPYqXGaJzUXW0gcNQLaS5ccNQrmsNh3B29PEWOnDscwBk7GUD6TxtkbewQ
         JTLCNjuj8shaShJiHgtwksD0DXRSOPgMAaLIRa/lxgfbMmXAUSXGN5qJobdVbVVcZWdl
         DdbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=3RBxr/reMzKfPribD5dZoWu7aXfUyId4YfssBQJvW2o=;
        b=shRmpBEM+iV0kPvySGj5Z/Wd5AH6Y+8fjvn+Lda9DnIbW7mXPvBzJcKVpSiJTt0t6R
         28LEm3sgDM6DvGlm+TPvAq9ybHvazkehr21buDLtoFf+pKjlr4f5TZB8GILYcGRAdVrm
         DCj4oFD02k8DdGUJTM/7bTrMGLz1hVLDZDdO/RdX//3oFTnNcPNC98yEWi9yZQP1Vd8U
         eFuGGIrFb9FPiMl4k1nhDhEV+IjFb37YFTgvnVnpBc/YQModX+5ba8vOQWh1qbi+TGkf
         UeIrI+kqCGehqSYn3WLP88T0oZgqV993iI6aYt9v1m8FZHjSKyk80wRBOvlWeHm+T0Ub
         J9dg==
X-Gm-Message-State: AOAM533c164vb1GL+zXLACPz2TD0UnO2vvWZ5OZ/wXw8YqlGCjHguT5t
        D+bZLMiuHWbSYlKQpw7/zD+5ujg=
X-Google-Smtp-Source: ABdhPJzRVg5bEU4/NgP93X8o6FEcsbk03MPfbGI9AN3U3LrNSOghRh4yQakopzykrsyVcVYSawnaPkg=
Sender: "sdf via sendgmr" <sdf@sdf2.svl.corp.google.com>
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:1:7220:84ff:fe09:7732])
 (user=sdf job=sendgmr) by 2002:ad4:4643:: with SMTP id y3mr9197086qvv.3.1610035782775;
 Thu, 07 Jan 2021 08:09:42 -0800 (PST)
Date:   Thu, 7 Jan 2021 08:09:41 -0800
In-Reply-To: <20210107012943.rht4ktth5ecdrz42@kafai-mbp.dhcp.thefacebook.com>
Message-Id: <X/cyRZy9Tw7Va6gp@google.com>
Mime-Version: 1.0
References: <20210105214350.138053-1-sdf@google.com> <20210105214350.138053-4-sdf@google.com>
 <20210106194756.vjkulozifc4bfuut@kafai-mbp.dhcp.thefacebook.com>
 <X/Y9pAaiq2FMHoBs@google.com> <20210107012943.rht4ktth5ecdrz42@kafai-mbp.dhcp.thefacebook.com>
Subject: Re: [PATCH bpf-next v3 3/3] bpf: remove extra lock_sock for TCP_ZEROCOPY_RECEIVE
From:   sdf@google.com
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, Song Liu <songliubraving@fb.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/06, Martin KaFai Lau wrote:
> On Wed, Jan 06, 2021 at 02:45:56PM -0800, sdf@google.com wrote:
> > On 01/06, Martin KaFai Lau wrote:
> > > On Tue, Jan 05, 2021 at 01:43:50PM -0800, Stanislav Fomichev wrote:
> > > > Add custom implementation of getsockopt hook for  
> TCP_ZEROCOPY_RECEIVE.
> > > > We skip generic hooks for TCP_ZEROCOPY_RECEIVE and have a custom
> > > > call in do_tcp_getsockopt using the on-stack data. This removes
> > > > 3% overhead for locking/unlocking the socket.
> > > >
> > > > Also:
> > > > - Removed BUILD_BUG_ON (zerocopy doesn't depend on the buf size  
> anymore)
> > > > - Separated on-stack buffer into bpf_sockopt_buf and downsized to 32
> > > bytes
> > > >   (let's keep it to help with the other options)
> > > >
> > > > (I can probably split this patch into two: add new features and  
> rework
> > > >  bpf_sockopt_buf; can follow up if the approach in general sounds
> > > >  good).
> > > >
> > > > Without this patch:
> > > >      3.29%     0.07%  tcp_mmap  [kernel.kallsyms]  [k]
> > > __cgroup_bpf_run_filter_getsockopt
> > > >             |
> > > >              --3.22%--__cgroup_bpf_run_filter_getsockopt
> > > >                        |
> > > >                        |--0.66%--lock_sock_nested
> > > A general question for sockopt prog, why the BPF_CGROUP_(GET| 
> SET)SOCKOPT
> > > prog
> > > has to run under lock_sock()?
> > I don't think there is a strong reason. We expose sk to the BPF program,
> > but mainly for the socket storage map (which, afaik, doesn't require
> > socket to be locked). OTOH, it seems that providing a consistent view
> > of the sk to the BPF is a good idea.
> hmm... most of the bpf prog also does not require a locked sock.  For
> example, the __sk_buff->sk.  If a bpf prog needs a locked view of sk,
> a more generic solution is desired.  Anyhow, I guess the train has sort
> of sailed for sockopt bpf.

> >
> > Eric has suggested to try to use fast socket lock. It helps a bit,
> > but it doesn't remove the issue completely because
> > we do a bunch of copy_{to,from}_user in the generic
> > __cgroup_bpf_run_filter_getsockopt as well :-(
> >
> > > >                        |
> > > >                        |--0.57%--__might_fault
> Is it a debug kernel?
Yeah, I think I did have CONFIG_DEBUG_ATOMIC_SLEEP=y for this particular
run, but I don't think I have anything else debugging related (although,
it might bring in DEBUG_KERNEL and some other crap). Let me check if
something else has crept in and rerun the benchmarks without it.
I'll respin with the updated data if nothing serious pop up.

> > > >                        |
> > > >                         --0.56%--release_sock
> > > >
> > > > With the patch applied:
> > > >      0.42%     0.10%  tcp_mmap  [kernel.kallsyms]  [k]
> > > __cgroup_bpf_run_filter_getsockopt_kern
> > > >      0.02%     0.02%  tcp_mmap  [kernel.kallsyms]  [k]
> > > __cgroup_bpf_run_filter_getsockopt
> > > >
> > > [ ... ]
> >
> > > > @@ -1445,15 +1442,29 @@ int  
> __cgroup_bpf_run_filter_getsockopt(struct
> > > sock *sk, int level,
> > > >  				       int __user *optlen, int max_optlen,
> > > >  				       int retval)
> > > >  {
> > > > -	struct cgroup *cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
> > > > -	struct bpf_sockopt_kern ctx = {
> > > > -		.sk = sk,
> > > > -		.level = level,
> > > > -		.optname = optname,
> > > > -		.retval = retval,
> > > > -	};
> > > > +	struct bpf_sockopt_kern ctx;
> > > > +	struct bpf_sockopt_buf buf;
> > > > +	struct cgroup *cgrp;
> > > >  	int ret;
> > > >
> > > > +#ifdef CONFIG_INET
> > > > +	/* TCP do_tcp_getsockopt has optimized getsockopt implementation
> > > > +	 * to avoid extra socket lock for TCP_ZEROCOPY_RECEIVE.
> > > > +	 */
> > > > +	if (sk->sk_prot->getsockopt == tcp_getsockopt &&
> > > > +	    level == SOL_TCP && optname == TCP_ZEROCOPY_RECEIVE)
> > > > +		return retval;
> > > > +#endif
> > > That seems too much protocol details and not very scalable.
> > > It is not very related to kernel/bpf/cgroup.c which has very little  
> idea
> > > whether a specific protocol has optimized things in some ways (e.g. by
> > > directly calling cgroup's bpf prog at some strategic places in this
> > > patch).
> > > Lets see if it can be done better.
> >
> > > At least, these protocol checks belong to the net's socket.c
> > > more than the bpf's cgroup.c here.  If it also looks like layering
> > > breakage in socket.c, may be adding a signal in sk_prot (for example)
> > > to tell if the sk_prot->getsockopt has already called the cgroup's bpf
> > > prog?  (e.g. tcp_getsockopt() can directly call the cgroup's bpf for  
> all
> > > optname instead of only TCP_ZEROCOPY_RECEIVE).
> >
> > > For example:
> >
> > > int __sys_getsockopt(...)
> > > {
> > > 	/* ... */
> >
> > > 	if (!sk_prot->bpf_getsockopt_handled)
> > > 		BPF_CGROUP_RUN_PROG_GETSOCKOPT(...);
> > > }
> >
> > > Thoughts?
> >
> > Sounds good. I didn't go that far because I don't expect there to be
> > a lot of special cases like that. But it might be worth supporting
> > it in a generic way from the beginning.
> >
> > I was thinking about something simpler:
> >
> > int __cgroup_bpf_run_filter_getsockopt(sk, ...)
> > {
> > 	if (sk->sk_prot->bypass_bpf_getsockopt(level, optlen)) {
> I think it meant s/optlen/optname/ which is not __user.
> Yeah, I think that can provide a more generic solution
> and also abstract things away.
> Please add a details comment in this function.
Sure, will do!

> > 		return retval;
> > 	}
> >
> >  	// ...
> > }
> >
> > Not sure it's worth exposing it to the __sys_getsockopt. WDYT?
> or call that in BPF_CGROUP_RUN_PROG_GETSOCKOPT().  then the
> changes in __cgroup_bpf_run_filter_getsockopt() in this
> patch should go away?
SG, will add to BPF_CGROUP_RUN_PROG_GETSOCKOPT.
