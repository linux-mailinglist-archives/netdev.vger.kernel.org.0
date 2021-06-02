Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A9AE397E36
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 03:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbhFBBr6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 21:47:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230143AbhFBBr5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 21:47:57 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B6B9C061574;
        Tue,  1 Jun 2021 18:46:14 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id jz2-20020a17090b14c2b0290162cf0b5a35so2495454pjb.5;
        Tue, 01 Jun 2021 18:46:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=NQ/P7MmOfTgjLDrX8LPnbwkLUjHtdnmt9LzgvoXycJ8=;
        b=i2oQvi+AxPV5aUIajMmP6uDrAMm0+iK3MAME114cvSQrseAOnqQgbBQQkVXGzRzjrB
         IvGd7a0j7/U6ahzmXcEAdsz+3rTm09K1ZZ0FljGAjnhfjAmwdsMONc0jNiEyuQBKPn7E
         kVUs+nsYaTqS5F+zaFeDZbXJVlzN3j8c8iT4bZnMEX0kG17UNlslkGZRHzdMNjTICFXn
         NoMLHil1hw1neYgdTnJMZAsUSmOEky9hiJkSrJPPVotnM6G9JCMCzd1Qz9aazu+HH0Ok
         mcqciFlwrTtC1XiyqQVyZ1Gmf+KvSsdKE6Z48Mkndtten9pBEsNDCHcB/bq3tVv8eeIG
         0CLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=NQ/P7MmOfTgjLDrX8LPnbwkLUjHtdnmt9LzgvoXycJ8=;
        b=R1rhYHaFDzSLzK/dkzO7sUNTKwZIAQlXRRYx+8TE0msbPD9tyTn8WXXA9KBvtFRnXM
         vjzh4PzIGRHVQx3WCqbg/eqapQ7RN/zkfAhNRR/YIzaiasJR50yU074amf7n1yDjn32f
         PemwJw6fc0hByYENOB8VoSvFgi8/f8tmxKvz4vIjdy9zhsfwEVG1yDqx4IUtyN4JUe+M
         fKbOn6bMn3tRoQrI4JSteNUOdTT3JdLIHVJ4IV4w5gULi/CJ6c11Li2G/tApIxSiPSQq
         27fY+OnhtWxk+vLEn9bG+8j8qBDM278DgEyo1amMO1o7CEIiOyOsteC781mW72cjrF6r
         ipxA==
X-Gm-Message-State: AOAM530kfNyYnMcAnEtVwxlHWVjElM/Bd9zNTWe4oIwujW4De8AkTela
        jLpuOvy2FPCkr/1ERb7Sa7I=
X-Google-Smtp-Source: ABdhPJyk1OcfKjs+iGcc+TSQtJPs6yx36Aw0cJMpkiLro0EUq96/JtKsl68U6EwOWmCr/qFM7CX2tw==
X-Received: by 2002:a17:90b:38c4:: with SMTP id nn4mr14063131pjb.166.1622598373413;
        Tue, 01 Jun 2021 18:46:13 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:bdb9])
        by smtp.gmail.com with ESMTPSA id 65sm4963049pfu.159.2021.06.01.18.46.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jun 2021 18:46:12 -0700 (PDT)
Date:   Tue, 1 Jun 2021 18:46:08 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH bpf-next 1/3] bpf: Introduce bpf_timer
Message-ID: <20210602014608.wxzfsgzuq7rut4ra@ast-mbp.dhcp.thefacebook.com>
References: <20210527040259.77823-1-alexei.starovoitov@gmail.com>
 <20210527040259.77823-2-alexei.starovoitov@gmail.com>
 <87r1hsgln6.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87r1hsgln6.fsf@toke.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 27, 2021 at 06:57:17PM +0200, Toke Høiland-Jørgensen wrote:
> >     if (val) {
> >         bpf_timer_init(&val->timer, timer_cb2, 0);
> >         bpf_timer_start(&val->timer, 1000 /* call timer_cb2 in 1 msec */);
> 
> nit: there are 1M nanoseconds in a millisecond :)

oops :)

> >     }
> > }
> >
> > This patch adds helper implementations that rely on hrtimers
> > to call bpf functions as timers expire.
> > The following patch adds necessary safety checks.
> >
> > Only programs with CAP_BPF are allowed to use bpf_timer.
> >
> > The amount of timers used by the program is constrained by
> > the memcg recorded at map creation time.
> >
> > The bpf_timer_init() helper is receiving hidden 'map' and 'prog' arguments
> > supplied by the verifier. The prog pointer is needed to do refcnting of bpf
> > program to make sure that program doesn't get freed while timer is armed.
> >
> > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> 
> Overall this LGTM, and I believe it will be usable for my intended use
> case. One question:
> 
> With this, it will basically be possible to create a BPF daemon, won't
> it? I.e., if a program includes a timer and the callback keeps re-arming
> itself this will continue indefinitely even if userspace closes all refs
> to maps and programs? Not saying this is a problem, just wanted to check
> my understanding (i.e., that there's not some hidden requirement on
> userspace keeping a ref open that I'm missing)...

That is correct.
Another option would be to auto-cancel the timer when the last reference
to the prog drops. That may feel safer, since forever
running bpf daemon is a certainly new concept.
The main benefits of doing prog_refcnt++ from bpf_timer_start are ease
of use and no surprises.
Disappearing timer callback when prog unloads is outside of bpf prog control.
For example the tracing bpf prog might collect some data and periodically
flush it to user space. The prog would arm the timer and when callback
is invoked it would send the data via ring buffer and start another
data collection cycle.
When the user space part of the service exits it doesn't have
an ability to enforce the flush of the last chunk of data.
It could do prog_run cmd that will call the timer callback,
but it's racy.
The solution to this problem could be __init and __fini
sections that will be invoked when the prog is loaded
and when the last refcnt drops.
It's a complementary feature though.
The prog_refcnt++ from bpf_timer_start combined with a prog
explicitly doing bpf_timer_cancel from __fini
would be the most flexible combination.
This way the prog can choose to be a daemon or it can choose
to cancel its timers and do data flushing when the last prog
reference drops.
The prog refcnt would be split (similar to uref). The __fini callback
will be invoked when refcnt reaches zero, but all increments
done by bpf_timer_start will be counted separately.
The user space wouldn't need to do the prog_run command.
It would detach the prog and close(prog_fd).
That will trigger __fini callback that will cancel the timers
and the prog will be fully unloaded.
That would make bpf progs resemble kernel modules even more.

> > +BPF_CALL_5(bpf_timer_init, struct bpf_timer_kern *, timer, void *, cb, int, flags,
> > +	   struct bpf_map *, map, struct bpf_prog *, prog)
> > +{
> > +	struct bpf_hrtimer *t;
> > +
> > +	if (flags)
> > +		return -EINVAL;
> > +	if (READ_ONCE(timer->timer))
> > +		return -EBUSY;
> > +	/* allocate hrtimer via map_kmalloc to use memcg accounting */
> > +	t = bpf_map_kmalloc_node(map, sizeof(*t), GFP_ATOMIC, NUMA_NO_NODE);
> > +	if (!t)
> > +		return -ENOMEM;
> > +	t->callback_fn = cb;
> > +	t->value = (void *)timer /* - offset of bpf_timer inside elem */;
> > +	t->key = t->value - round_up(map->key_size, 8);
> 
> For array-maps won't this just point to somewhere inside the previous value?

Excellent catch. Thank you. Will fix.

> > +	t->map = map;
> > +	t->prog = prog;
> > +	spin_lock_init(&t->lock);
> > +	hrtimer_init(&t->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL_SOFT);
> > +	t->timer.function = timer_cb;
> > +	if (cmpxchg(&timer->timer, NULL, t)) {
> > +		/* Parallel bpf_timer_init() calls raced. */
> > +		kfree(t);
> > +		return -EBUSY;
> > +	}
> > +	return 0;
> > +}
> > +
> > +static const struct bpf_func_proto bpf_timer_init_proto = {
> > +	.func		= bpf_timer_init,
> > +	.gpl_only	= false,
> 
> hrtimer_init() is EXPORT_SYMBOL_GPL, should this be as well? Same with
> the others below.

Excellent catch as well! Will fix.
