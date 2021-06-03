Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED6233997CE
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 03:58:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbhFCCAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 22:00:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbhFCCAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 22:00:13 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9879C06174A;
        Wed,  2 Jun 2021 18:58:13 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id u9so2004487plr.1;
        Wed, 02 Jun 2021 18:58:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=3sAVOWbeQe2a7JyZJ0a3p+dGEq1lmH8mcAW/IDv04eg=;
        b=gONwvZeEaGJOMfgri3bq9IWp5S/hyD+FXAKlX6xpMBlXBUTZRK3uRHxt++bvlEXgJj
         cOsi4ms+07SmRqKSzrGh9/f1W3rcirOuKpQC4WNNX6RwFsCK3HkQ57W9atXRhCHiN+zw
         L34bWucp51hJFc2iZbp49FfZB0StKZfU+pGiL+OS/BuIfHGk5pSG/ZxicZkecsg5HpJh
         d9LfKFWtusSkE6RkBcW50PLW5FJ522MSo9OJD64MhhatWtCfuEk3C6qJ8HcZ4tZ+Aifm
         3xgHXzekaef8FuiPS2hjq+yqCdCbmtPfWqZqzQsNVns1ou2wt988/3S8FWG4aFf0W57Q
         1brQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=3sAVOWbeQe2a7JyZJ0a3p+dGEq1lmH8mcAW/IDv04eg=;
        b=mK/EOyuUReQr5gaQuGm/528p7QF7EQjGv7yCa7/3LnY3XqdvawpxGzC4OqSq/lRDd+
         EKKnHeUlfTXd+Z0MjZlX6UcTG+Wo7iKvXDgGJy02CnyqvFNGhgQjwQCJDfaZeO21EYXN
         YOWpOZ4//QgnE8gEQNbDFLkyHx8DmfnTHWQTNsaWcn4r1W0dVZgI7q0Zw/SkaQWzckg2
         yuR8ziQcjGXAEpOtvMdhG2ZWDiLNC9hq6AJ4JphdwbYn97R7+x+W2qEwJiXUMr6n2V3n
         jbZtpxqvEwMruBPE+r10LQZ7/HarWOz8Vcrs/WRVUvpb2rjwGjCOoanSVtENeqJsNeI+
         UK4Q==
X-Gm-Message-State: AOAM533h7D4KxWQujwIfQKuZKtecKufEh3XZEI31llYr9Or6UmgAf/Ua
        dHr7/30p3LRQeaR1vIHazQE=
X-Google-Smtp-Source: ABdhPJzKZ+4hIjsP++l5aMoHunAry3pldxiVbnzOQdTkN2tjdmGcHCf2wt44c8081kpEnNiJfHrTDQ==
X-Received: by 2002:a17:90b:108f:: with SMTP id gj15mr14136796pjb.124.1622685493199;
        Wed, 02 Jun 2021 18:58:13 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:27da])
        by smtp.gmail.com with ESMTPSA id i8sm544063pjs.54.2021.06.02.18.58.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 18:58:12 -0700 (PDT)
Date:   Wed, 2 Jun 2021 18:58:09 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH bpf-next 1/3] bpf: Introduce bpf_timer
Message-ID: <20210603015809.l2dez754vzxjueew@ast-mbp.dhcp.thefacebook.com>
References: <20210527040259.77823-1-alexei.starovoitov@gmail.com>
 <20210527040259.77823-2-alexei.starovoitov@gmail.com>
 <87r1hsgln6.fsf@toke.dk>
 <20210602014608.wxzfsgzuq7rut4ra@ast-mbp.dhcp.thefacebook.com>
 <87a6o7aoxa.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87a6o7aoxa.fsf@toke.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 03, 2021 at 12:21:05AM +0200, Toke Høiland-Jørgensen wrote:
> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> 
> > On Thu, May 27, 2021 at 06:57:17PM +0200, Toke Høiland-Jørgensen wrote:
> >> >     if (val) {
> >> >         bpf_timer_init(&val->timer, timer_cb2, 0);
> >> >         bpf_timer_start(&val->timer, 1000 /* call timer_cb2 in 1 msec */);
> >> 
> >> nit: there are 1M nanoseconds in a millisecond :)
> >
> > oops :)
> >
> >> >     }
> >> > }
> >> >
> >> > This patch adds helper implementations that rely on hrtimers
> >> > to call bpf functions as timers expire.
> >> > The following patch adds necessary safety checks.
> >> >
> >> > Only programs with CAP_BPF are allowed to use bpf_timer.
> >> >
> >> > The amount of timers used by the program is constrained by
> >> > the memcg recorded at map creation time.
> >> >
> >> > The bpf_timer_init() helper is receiving hidden 'map' and 'prog' arguments
> >> > supplied by the verifier. The prog pointer is needed to do refcnting of bpf
> >> > program to make sure that program doesn't get freed while timer is armed.
> >> >
> >> > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> >> 
> >> Overall this LGTM, and I believe it will be usable for my intended use
> >> case. One question:
> >> 
> >> With this, it will basically be possible to create a BPF daemon, won't
> >> it? I.e., if a program includes a timer and the callback keeps re-arming
> >> itself this will continue indefinitely even if userspace closes all refs
> >> to maps and programs? Not saying this is a problem, just wanted to check
> >> my understanding (i.e., that there's not some hidden requirement on
> >> userspace keeping a ref open that I'm missing)...
> >
> > That is correct.
> > Another option would be to auto-cancel the timer when the last reference
> > to the prog drops. That may feel safer, since forever
> > running bpf daemon is a certainly new concept.
> > The main benefits of doing prog_refcnt++ from bpf_timer_start are ease
> > of use and no surprises.
> > Disappearing timer callback when prog unloads is outside of bpf prog control.
> > For example the tracing bpf prog might collect some data and periodically
> > flush it to user space. The prog would arm the timer and when callback
> > is invoked it would send the data via ring buffer and start another
> > data collection cycle.
> > When the user space part of the service exits it doesn't have
> > an ability to enforce the flush of the last chunk of data.
> > It could do prog_run cmd that will call the timer callback,
> > but it's racy.
> > The solution to this problem could be __init and __fini
> > sections that will be invoked when the prog is loaded
> > and when the last refcnt drops.
> > It's a complementary feature though.
> > The prog_refcnt++ from bpf_timer_start combined with a prog
> > explicitly doing bpf_timer_cancel from __fini
> > would be the most flexible combination.
> > This way the prog can choose to be a daemon or it can choose
> > to cancel its timers and do data flushing when the last prog
> > reference drops.
> > The prog refcnt would be split (similar to uref). The __fini callback
> > will be invoked when refcnt reaches zero, but all increments
> > done by bpf_timer_start will be counted separately.
> > The user space wouldn't need to do the prog_run command.
> > It would detach the prog and close(prog_fd).
> > That will trigger __fini callback that will cancel the timers
> > and the prog will be fully unloaded.
> > That would make bpf progs resemble kernel modules even more.
> 
> I like the idea of a "destructor" that will trigger on refcnt drop to
> zero. And I do think a "bpf daemon" is potentially a useful, if novel,
> concept.

I think so too. Long ago folks requested periodic bpf progs to
do sampling in tracing. All these years attaching bpf prog
to a perf_event was a workaround for such feature request.
perf_event bpf prog can be pinned in perf_event array,
so "bpf daemon" kinda exist today. Just more convoluted.

> The __fini thing kinda supposes a well-behaved program, though, right?
> I.e., it would be fairly trivial to write a program that spins forever
> by repeatedly scheduling the timer with a very short interval (whether
> by malice or bugginess).

It's already possible without bpf_timer.

> So do we need a 'bpfkill' type utility to nuke
> buggy programs, or how would resource constraints be enforced?

That is possible without 'bpfkill'.
bpftool can delete map element that contains bpf_timer and
that will cancel it. I'll add tests to make sure it's the case.
