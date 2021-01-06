Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 481A52EC658
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 23:47:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727722AbhAFWqj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 17:46:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726993AbhAFWqj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 17:46:39 -0500
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE616C061757
        for <netdev@vger.kernel.org>; Wed,  6 Jan 2021 14:45:58 -0800 (PST)
Received: by mail-qv1-xf49.google.com with SMTP id t16so3484147qvk.13
        for <netdev@vger.kernel.org>; Wed, 06 Jan 2021 14:45:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=z/minfmnrCiZQKZriVAE3kJbpflP12fwCuTdg+lvXfs=;
        b=LRt3VS2Qn/kw01C4b4FGHOiC4xEszwrU+2zXDqLEBPlzYU5WIJsqJSuVQZaKRDRLZK
         I6S4E+79b9HV4ZYL5p1Ku8DJEcVUpPQl0AzkueiILjketSY8eIeDxxXm+WhhEgW17k2W
         +wymWR2GqBcCg6/TO4rpV9IC5cr5Gobt5AtniVlQJ7twhO+BCn0LqNhfDHWRcg0PfPsm
         ugvPph+mt80UfONP2CkTc3daARibnp5UcCsqGCBcW/iqa8FPrz34vFanUufMztF8SolX
         xa3pVRopQ81kltC/r+Cex32MHHN5bum+yMOA4LKUdH7TukUp+fNPlmQxnbIw/GQFbx7h
         ZEgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=z/minfmnrCiZQKZriVAE3kJbpflP12fwCuTdg+lvXfs=;
        b=So2fPFhpvdxE5LoyrQvGJigKPkY++bmSAz96xnxeAMiYDBI1bbGwy9dxv9AUfIMwJB
         jb+lbA8IZKwVupMi3mZcQh54uvXOySnqMKTzgE45mdmrMInFBq0I0X5utjrrsvXozACv
         sLxVCF86+xQd+iH3dv8OUoSKl3vS19pgaknDUy/Y7X8x+Onpew9MDIfi5bYaZkqPPuKG
         GOKEq/UMmiIZCy9RPrdIB8WSJoVX3tNcOr6fwp/nTlSWJVPkUs0OxZdLrw3Aeqb87Ic1
         vcNwunn5wQfOAdxsrQA8+KRvhk6976RuraJjZ7DvBsDdm+Jc8yl4YJjpZfRVKMVh6yih
         TpiQ==
X-Gm-Message-State: AOAM530AqgZ9IZRpsvsBeZPO8GuAdyTtpxCjBeifDqpQ/wsRcdSNqe8O
        6Jo83g67QGm7+vPmvDszzVWiwL4=
X-Google-Smtp-Source: ABdhPJwLccvHErMuMdBybE0Z0T+2vCwRgDAuzmZ5/ukOihAcHxIcI6L5mKGMCvX4fBypmQJcNJ0kYFs=
Sender: "sdf via sendgmr" <sdf@sdf2.svl.corp.google.com>
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:1:7220:84ff:fe09:7732])
 (user=sdf job=sendgmr) by 2002:a0c:fdec:: with SMTP id m12mr6242193qvu.11.1609973157864;
 Wed, 06 Jan 2021 14:45:57 -0800 (PST)
Date:   Wed, 6 Jan 2021 14:45:56 -0800
In-Reply-To: <20210106194756.vjkulozifc4bfuut@kafai-mbp.dhcp.thefacebook.com>
Message-Id: <X/Y9pAaiq2FMHoBs@google.com>
Mime-Version: 1.0
References: <20210105214350.138053-1-sdf@google.com> <20210105214350.138053-4-sdf@google.com>
 <20210106194756.vjkulozifc4bfuut@kafai-mbp.dhcp.thefacebook.com>
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
> On Tue, Jan 05, 2021 at 01:43:50PM -0800, Stanislav Fomichev wrote:
> > Add custom implementation of getsockopt hook for TCP_ZEROCOPY_RECEIVE.
> > We skip generic hooks for TCP_ZEROCOPY_RECEIVE and have a custom
> > call in do_tcp_getsockopt using the on-stack data. This removes
> > 3% overhead for locking/unlocking the socket.
> >
> > Also:
> > - Removed BUILD_BUG_ON (zerocopy doesn't depend on the buf size anymore)
> > - Separated on-stack buffer into bpf_sockopt_buf and downsized to 32  
> bytes
> >   (let's keep it to help with the other options)
> >
> > (I can probably split this patch into two: add new features and rework
> >  bpf_sockopt_buf; can follow up if the approach in general sounds
> >  good).
> >
> > Without this patch:
> >      3.29%     0.07%  tcp_mmap  [kernel.kallsyms]  [k]  
> __cgroup_bpf_run_filter_getsockopt
> >             |
> >              --3.22%--__cgroup_bpf_run_filter_getsockopt
> >                        |
> >                        |--0.66%--lock_sock_nested
> A general question for sockopt prog, why the BPF_CGROUP_(GET|SET)SOCKOPT  
> prog
> has to run under lock_sock()?
I don't think there is a strong reason. We expose sk to the BPF program,
but mainly for the socket storage map (which, afaik, doesn't require
socket to be locked). OTOH, it seems that providing a consistent view
of the sk to the BPF is a good idea.

Eric has suggested to try to use fast socket lock. It helps a bit,
but it doesn't remove the issue completely because
we do a bunch of copy_{to,from}_user in the generic
__cgroup_bpf_run_filter_getsockopt as well :-(

> >                        |
> >                        |--0.57%--__might_fault
> >                        |
> >                         --0.56%--release_sock
> >
> > With the patch applied:
> >      0.42%     0.10%  tcp_mmap  [kernel.kallsyms]  [k]  
> __cgroup_bpf_run_filter_getsockopt_kern
> >      0.02%     0.02%  tcp_mmap  [kernel.kallsyms]  [k]  
> __cgroup_bpf_run_filter_getsockopt
> >
> [ ... ]

> > @@ -1445,15 +1442,29 @@ int __cgroup_bpf_run_filter_getsockopt(struct  
> sock *sk, int level,
> >  				       int __user *optlen, int max_optlen,
> >  				       int retval)
> >  {
> > -	struct cgroup *cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
> > -	struct bpf_sockopt_kern ctx = {
> > -		.sk = sk,
> > -		.level = level,
> > -		.optname = optname,
> > -		.retval = retval,
> > -	};
> > +	struct bpf_sockopt_kern ctx;
> > +	struct bpf_sockopt_buf buf;
> > +	struct cgroup *cgrp;
> >  	int ret;
> >
> > +#ifdef CONFIG_INET
> > +	/* TCP do_tcp_getsockopt has optimized getsockopt implementation
> > +	 * to avoid extra socket lock for TCP_ZEROCOPY_RECEIVE.
> > +	 */
> > +	if (sk->sk_prot->getsockopt == tcp_getsockopt &&
> > +	    level == SOL_TCP && optname == TCP_ZEROCOPY_RECEIVE)
> > +		return retval;
> > +#endif
> That seems too much protocol details and not very scalable.
> It is not very related to kernel/bpf/cgroup.c which has very little idea
> whether a specific protocol has optimized things in some ways (e.g. by
> directly calling cgroup's bpf prog at some strategic places in this  
> patch).
> Lets see if it can be done better.

> At least, these protocol checks belong to the net's socket.c
> more than the bpf's cgroup.c here.  If it also looks like layering
> breakage in socket.c, may be adding a signal in sk_prot (for example)
> to tell if the sk_prot->getsockopt has already called the cgroup's bpf
> prog?  (e.g. tcp_getsockopt() can directly call the cgroup's bpf for all
> optname instead of only TCP_ZEROCOPY_RECEIVE).

> For example:

> int __sys_getsockopt(...)
> {
> 	/* ... */

> 	if (!sk_prot->bpf_getsockopt_handled)
> 		BPF_CGROUP_RUN_PROG_GETSOCKOPT(...);
> }

> Thoughts?

Sounds good. I didn't go that far because I don't expect there to be
a lot of special cases like that. But it might be worth supporting
it in a generic way from the beginning.

I was thinking about something simpler:

int __cgroup_bpf_run_filter_getsockopt(sk, ...)
{
	if (sk->sk_prot->bypass_bpf_getsockopt(level, optlen)) {
		return retval;
	}

  	// ...
}

Not sure it's worth exposing it to the __sys_getsockopt. WDYT?
