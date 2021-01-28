Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B9E6306D9C
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 07:29:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbhA1G3J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 01:29:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbhA1G3I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 01:29:08 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E6A1C061573;
        Wed, 27 Jan 2021 22:28:27 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id lw17so4252502pjb.0;
        Wed, 27 Jan 2021 22:28:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DAbNeqn4HrFrwHesm9EjNkW+m3p+6Gw00s2+sHZm0lg=;
        b=GwVoXgW8/huQGLo9yRdTRNCp+UlxLS5bainwfcCUT0dMAg6pp6hEKZvdxHYZBK1h4P
         5gRJ6c7QEExmrHQlgT0fMfOWij6wS1EcFt0k0l7F7sLa4aT2Yf/SdyhFoLzw2goqhh+P
         sYkWkHX/8Fzf/rYc23XArIE3UAcOf9665sqyC6Qw0HWoiU/fh6lqhrX486TQ0hhzt4kA
         Qey3M3/BtblX9QOGUFGcRoDgXDPq9blgooQeKPaT5rnM5MXlYsuyc5y2dz1j3w4/PYpH
         0uECw3yrVT1DhXL/OHlTWjGLNYQc4qtkz9UKaDdksAvn5VerdFdAO/ylfvzuSQdOGjCa
         PLzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DAbNeqn4HrFrwHesm9EjNkW+m3p+6Gw00s2+sHZm0lg=;
        b=IKd04m9oiM6BTYUgWgzp+JswoCt5ES9NPr724FeSQbluqGURa7wp/vLG3Sb1ikXCsL
         ptLyT0Tc+rXIVUxQp1gFTSqRysQazcYC/GlrEV1c5fEtjOQOb8lvxVWb6XKUVzXSO6Cy
         NRhmFkuNOONH8J5BAyzVpBC74QqwioLmeq2eyDzxhxlGRBULYQSeeOMwwGvil3cT3Ew6
         IWypHTeFvfF4cV74FiEU3EHt2Gg3p7xHhz0WFsmbnyBfzDeEJa+cneVl6Aekushwg8pZ
         e+SBeLPFsKLKogKmnUTmyvHBAgosbKJEI6lN6maGrJffS2LJmB5/gYyk+R1wXvhFYQ2b
         1wMg==
X-Gm-Message-State: AOAM5338t1OfELcFKVvG0/MePFnh+NsF866eXqUYHjQkIKeNR5Ez/BLj
        cmvUtrIlBpwPBfHapLwOnLiEmMK2dKIW3WYCBuU=
X-Google-Smtp-Source: ABdhPJzFVvjKbtEKY7g/qQjhsm6z2fa/ElvnLyetxE5toYVafRRG6gYuQflfNb9g3mdeeoRBrcXU6cXgxj3kXZtkRog=
X-Received: by 2002:a17:902:9d8d:b029:df:e5a6:1ef7 with SMTP id
 c13-20020a1709029d8db02900dfe5a61ef7mr15010646plq.77.1611815306375; Wed, 27
 Jan 2021 22:28:26 -0800 (PST)
MIME-Version: 1.0
References: <20210122205415.113822-1-xiyou.wangcong@gmail.com>
 <20210122205415.113822-2-xiyou.wangcong@gmail.com> <d69d44ca-206c-d818-1177-c8f14d8be8d1@iogearbox.net>
 <CAM_iQpW8aeh190G=KVA9UEZ_6+UfenQxgPXuw784oxCaMfXjng@mail.gmail.com> <CAADnVQKmNiHj8qy1yqbOrf-OMyhnn8fKm87w6YMfkiDHkBpJVg@mail.gmail.com>
In-Reply-To: <CAADnVQKmNiHj8qy1yqbOrf-OMyhnn8fKm87w6YMfkiDHkBpJVg@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 27 Jan 2021 22:28:15 -0800
Message-ID: <CAM_iQpXAQ7AMz34=o5E=81RFGFsQB5jCDTCCaVdHokU6kaJQsQ@mail.gmail.com>
Subject: Re: [Patch bpf-next v5 1/3] bpf: introduce timeout hash map
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Jamal Hadi Salim <jhs@mojatatu.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Dongdong Wang <wangdongdong.6@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 27, 2021 at 10:00 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Jan 26, 2021 at 11:00 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > > >               ret = PTR_ERR(l_new);
> > > > +             if (ret == -EAGAIN) {
> > > > +                     htab_unlock_bucket(htab, b, hash, flags);
> > > > +                     htab_gc_elem(htab, l_old);
> > > > +                     mod_delayed_work(system_unbound_wq, &htab->gc_work, 0);
> > > > +                     goto again;
> > >
> > > Also this one looks rather worrying, so the BPF prog is stalled here, loop-waiting
> > > in (e.g. XDP) hot path for system_unbound_wq to kick in to make forward progress?
> >
> > In this case, the old one is scheduled for removal in GC, we just wait for GC
> > to finally remove it. It won't stall unless GC itself or the worker scheduler is
> > wrong, both of which should be kernel bugs.
> >
> > If we don't do this, users would get a -E2BIG when it is not too big. I don't
> > know a better way to handle this sad situation, maybe returning -EBUSY
> > to users and let them call again?
>
> I think using wq for timers is a non-starter.
> Tying a hash/lru map with a timer is not a good idea either.

Both xt_hashlimit and nf_conntrack_core use delayed/deferrable
works, probably since their beginnings. They seem to have started
well. ;)

>
> I think timers have to be done as independent objects similar to
> how the kernel uses them.
> Then there will be no question whether lru or hash map needs it.

Yeah, this probably could make the code easier, but when we have
millions of entries in a map, millions of timers would certainly bring
a lot of CPU overhead (timer interrupt storm?).


> The bpf prog author will be able to use timers with either.
> The prog will be able to use timers without hash maps too.
>
> I'm proposing a timer map where each object will go through
> bpf_timer_setup(timer, callback, flags);
> where "callback" is a bpf subprogram.
> Corresponding bpf_del_timer and bpf_mod_timer would work the same way
> they are in the kernel.
> The tricky part is kernel style of using from_timer() to access the
> object with additional info.
> I think bpf timer map can model it the same way.
> At map creation time the value_size will specify the amount of extra
> bytes necessary.
> Another alternative is to pass an extra data argument to a callback.

Hmm, this idea is very interesting. I still think arming a timer,
whether a kernel timer or a bpf timer, for each entry is overkill,
but we can arm one for each map, something like:

bpf_timer_run(interval, bpf_prog, &any_map);

so we run 'bpf_prog' on any map every 'interval', but the 'bpf_prog'
would have to iterate the whole map during each interval to delete
the expired ones. This is probably doable: the timestamps can be
stored either as a part of key or value, and bpf_jiffies64() is already
available, users would have to discard expired ones after lookup
when they are faster than the timer GC.

Let me take a deeper look tomorrow.

Thanks.
