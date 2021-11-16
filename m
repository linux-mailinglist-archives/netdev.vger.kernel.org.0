Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74EC9452A0B
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 06:49:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237611AbhKPFwo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 00:52:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237537AbhKPFw2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 00:52:28 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8883EC0431B4;
        Mon, 15 Nov 2021 20:44:14 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id u11so16368706plf.3;
        Mon, 15 Nov 2021 20:44:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mCNGifWQwgCO6MjgMGcYLm048vx8sIaahNJu3cWTguI=;
        b=Qck+Lm+FqWNkPQde4ZEYn4uB959Oy09juL7/YIim/M4bS9Ckf1UiI9segtFiiL3Avj
         Ww2we8zlrA+LTCB/SOp1qrHbO7R1D0998KbdgGPWaaA34WhJnCgN4wXaTLJFi75xDvV4
         ftlgsNBU4KlS+6Vp2BS3Xn2sEvtqED9XfjzK9oVh3DyKcSvkARqxX93oWFHTf+3V27G+
         nTibEa325+e5ZekA71nkxopW5hOng8CPoeXYv6YYTYSF1aewIhAbmRBMY8XXESqDUb0L
         2vOdrAY+VzTiKAkK61CPoYqo256KZP82R6si9CUMow6lbAYczlM8GT9bZkvqDL4hnaWy
         j7tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mCNGifWQwgCO6MjgMGcYLm048vx8sIaahNJu3cWTguI=;
        b=eYTv7nRPWyx3Ook3PqCSm/K+D3lgmfV+imOC5JhbHarhM4YbzFH14xZHrgrjn3SUWm
         pkHXgTdtBecbu2G7mLr9ElI0CUcuy7bnt+Utv1aV9g0HC23P17Mdjog/Pt+vBY5cdb7j
         HyuUA0z2kKuftRSzRumdoGeGFSGHP3Avt3y0UO+FX9RFxBPGJfEDEHw9mekH4bgJzqbh
         hRkXYZA4sEoX90Y4rRRUSjGPZv6YxBhyA0fvH29yaTYk9vSZ3fwylTJvVXCCLSG6D4sx
         NmaZQPVz99htfXGUhXOLFyfwsOhTpnOGxBcIM9lH6uHMK5kjGmnkaFAthDp0SR5kUx7V
         K0uA==
X-Gm-Message-State: AOAM5309aGEbRtCARWG2ZZxgnMCu5Ye3tcdYYISdokZ18qd2orCsdkb9
        Gze0Lvc/sZGHy9qh+ejgfBWiuHC1FqkxcDqiVFY=
X-Google-Smtp-Source: ABdhPJyiBlRPlcwL7H8/3MpkBIECeFR+4mIKHKNQC7RshN/fytuthpKv8IZotRmMfJiVsf0OeCrWhs7DD2YhuULhCXk=
X-Received: by 2002:a17:902:b588:b0:143:b732:834 with SMTP id
 a8-20020a170902b58800b00143b7320834mr28184227pls.22.1637037853973; Mon, 15
 Nov 2021 20:44:13 -0800 (PST)
MIME-Version: 1.0
References: <20211113142227.566439-1-me@ubique.spb.ru> <20211113142227.566439-2-me@ubique.spb.ru>
 <87o86k6ep0.ffs@tglx>
In-Reply-To: <87o86k6ep0.ffs@tglx>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 15 Nov 2021 20:44:02 -0800
Message-ID: <CAADnVQJY9=mGVP9ZqpAsfmyhdgfyNBESc4Tr=+BG87TP682=9Q@mail.gmail.com>
Subject: Re: [PATCH bpf v2 1/2] bpf: Forbid bpf_ktime_get_coarse_ns and
 bpf_timer_* in tracing progs
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Dmitrii Banshchikov <me@ubique.spb.ru>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Andrey Ignatov <rdna@fb.com>,
        syzbot <syzbot+43fd005b5a1b4d10781e@syzkaller.appspotmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 15, 2021 at 6:02 PM Thomas Gleixner <tglx@linutronix.de> wrote:
>
> Dmitrii.
>
> > @@ -4632,6 +4632,9 @@ union bpf_attr {
> >   *           system boot, in nanoseconds. Does not include time the system
> >   *           was suspended.
> >   *
> > + *           Tracing programs cannot use **bpf_ktime_get_coarse_ns**\() (but
> > + *           this may change in the future).
>
> Sorry no. This is a bug fix and there is no place for 'may change in the
> future' nonsense. It's simply not possible right now and unless you have
> a plan to make this work backed up by actual patches this comment is
> worse than wishful thinking.

No. The point of 'may' is that it actually may change.
It's certainly realistic and probable.
But based on the tone of your message it doesn't seem that
you're interested in hearing the arguments in favor of it.
So I just removed this comment to put this matter to rest.

> > + *
> >   *           See: **clock_gettime**\ (**CLOCK_MONOTONIC_COARSE**)
> >   *   Return
> >   *           Current *ktime*.
> > @@ -4804,6 +4807,9 @@ union bpf_attr {
> >   *           All other bits of *flags* are reserved.
> >   *           The verifier will reject the program if *timer* is not from
> >   *           the same *map*.
> > + *
> > + *           Tracing programs cannot use **bpf_timer_init**\() (but this may
> > + *           change in the future).
>
> This is even worse than the above because it cannot happen ever. Please
> stop this nonsensical wishful thinking crap. It does not add any value,
> it just adds confusion.

I respectfully disagree, but I removed this comment as well.
And force pushed the commits.
