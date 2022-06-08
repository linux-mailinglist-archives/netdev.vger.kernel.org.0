Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C99B542660
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 08:57:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234009AbiFHGAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 02:00:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348834AbiFHF6d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 01:58:33 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5EA0DFF60;
        Tue,  7 Jun 2022 21:29:44 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id y19so39016638ejq.6;
        Tue, 07 Jun 2022 21:29:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8QplU7weKkacOBy0k1iMHbg7HMNTg9jQOW3kXNEYn5E=;
        b=PrK5ZFGcFYiwn+BtqlpBV3ewlPm3PWrS/0CJGBquDvMd3wXT6kFX86dJYicey+jodl
         UnnY13VtuHLvMLTQGK9UPS1L0dR7VQrp6fMj1pYjsYGuIX8O056z5cSJfts2nLBvN2x/
         KagIuy7hfLP0mCTpnpOR5njm+Qt9jKZwp4Y5Zzr7f56RI8lnZJfz41qw7fcvnrazcshJ
         m2YX+Q1LyNkEpTTgSqaal2o5JmAAzIZ+B/FZnTfnNExS98uxvqU2p1cpz44dJTO2o9QN
         JZ57g6y7LLgA4WNMsccgy7yxKysBOxA8MTcnkowPbZojXIjEOu/gBAspER9QqHSDRZ63
         INNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8QplU7weKkacOBy0k1iMHbg7HMNTg9jQOW3kXNEYn5E=;
        b=SiJKdTzzbGz9+vW6P5A3Xa7sDw6rL2nmbgJeC3qA73PkS0vk7rgvI3JHHJVl0hvKeq
         3o191zbB2+U4QXgjHW5mHlG1LXO7haCxtq5U8RxnqvRPGehUZpTw1JeNcfnrQfb27t79
         Ckry/Xe+rq99GL8emSs0/wQBw/2f39hkZsV9W7IByFudCdknmIFscpvdfY9zitoccUj1
         sulUq6M4Z7vWRvD48ePr8Lf701ng6E1n0asxzbP+NBJhXkfrNhkypQsDaCGCARnERRuS
         UfloWdG1Ic5hzMYiblGHxKo/x7HRwR+epikZ4I0H6g63NPwpMOQAxPK6ql4GCKZnLYpZ
         h56A==
X-Gm-Message-State: AOAM533lhTsueUAvSoqvxjgdUj8/lPPRW+SMstNIWgtYgVUXRcc4ka7P
        LCKMPoUMLlCbdua8nYbTx1EXy70lW4+oG1zxpYM=
X-Google-Smtp-Source: ABdhPJxAn0OsvETRP9f5wYkQ0ZZTZ6NVGZ+BqQ5UMN1hYHhi7ik/DkQ2N23unr25swkpziJUjQoyVhaCYwB8jPerveM=
X-Received: by 2002:a17:906:449:b0:711:c975:cfb8 with SMTP id
 e9-20020a170906044900b00711c975cfb8mr14946581eja.58.1654662582786; Tue, 07
 Jun 2022 21:29:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220525114003.61890-1-jolsa@kernel.org> <CAEf4BzZ-xe-zSjbBpKLHfQKPnTRTBMA2Eg382+_4kQoTLnj4eQ@mail.gmail.com>
In-Reply-To: <CAEf4BzZ-xe-zSjbBpKLHfQKPnTRTBMA2Eg382+_4kQoTLnj4eQ@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 7 Jun 2022 21:29:30 -0700
Message-ID: <CAADnVQJcDKVAOeJ8LX9j-cUKdkptuFWFDnB3o9C_o0bSScGnsQ@mail.gmail.com>
Subject: Re: [RFC bpf-next] bpf: Use prog->active instead of bpf_prog_active
 for kprobe_multi
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 31, 2022 at 4:24 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Wed, May 25, 2022 at 4:40 AM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > hi,
> > Alexei suggested to use prog->active instead global bpf_prog_active
> > for programs attached with kprobe multi [1].
> >
> > AFAICS this will bypass bpf_disable_instrumentation, which seems to be
> > ok for some places like hash map update, but I'm not sure about other
> > places, hence this is RFC post.
> >
> > I'm not sure how are kprobes different to trampolines in this regard,
> > because trampolines use prog->active and it's not a problem.
> >
> > thoughts?
> >
>
> Let's say we have two kernel functions A and B? B can be called from
> BPF program though some BPF helper, ok? Now let's say I have two BPF
> programs kprobeX and kretprobeX, both are attached to A and B. With
> using prog->active instead of per-cpu bpf_prog_active, what would be
> the behavior when A is called somewhere in the kernel.
>
> 1. A is called
> 2. kprobeX is activated for A, calls some helper which eventually calls B
>   3. kprobeX is attempted to be called for B, but is skipped due to prog->active
>   4. B runs
>   5. kretprobeX is activated for B, calls some helper which eventually calls B
>     6. kprobeX is ignored (prog->active > 0)
>     7. B runs
>     8. kretprobeX is ignored (prog->active > 0)
> 9. kretprobeX is activated for A, calls helper which calls B
>   10. kprobeX is activated for B
>     11. kprobeX is ignored (prog->active > 0)

not correct. kprobeX actually runs.
but the end result is correct.

>     12. B runs
>     13. kretprobeX is ignored (prog->active > 0)
>   14. B runs
>   15. kretprobeX is ignored (prog->active > 0)
>
>
> If that's correct, we get:
>
> 1. kprobeX for A
> 2. kretprobeX for B
> 3. kretprobeX for A
> 4. kprobeX for B

Here it's correct.

> It's quite mind-boggling and annoying in practice. I'd very much
> prefer just kprobeX for A followed by kretprobeX for A. That's it.
>
> I'm trying to protect against this in retsnoop with custom per-cpu
> logic in each program, but I so much more prefer bpf_prog_active,
> which basically says "no nested kprobe calls while kprobe program is
> running", which makes a lot of sense in practice.

It makes sense for retsnoop, but does not make sense in general.

> Given kprobe already used global bpf_prog_active I'd say multi-kprobe
> should stick to bpf_prog_active as well.

I strongly disagree.
Both multi kprobe and kprobe should move to per prog counter
plus some other protection
(we cannot just move to per-prog due to syscalls).
It's true that the above order is mind-boggling,
but it's much better than
missing kprobe invocation completely just because
another kprobe is running on the same cpu.
People complained numerous times about this kprobe behavior.
kprobeX attached to A
kprobeY attached to B.
If kprobeX calls B kprobeY is not going to be called.
Means that anything that bpf is using is lost.
spin locks, lists, rcu, etc.
Sleepable uprobes are coming.
iirc Delyan's patch correctly.
We will do migrate_disable and inc bpf_prog_active.
Now random kprobes on that cpu will be lost.
It's awful. We have to fix it.
