Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FDE225B4E9
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 21:58:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727119AbgIBT6v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 15:58:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726312AbgIBT6t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 15:58:49 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12328C061245;
        Wed,  2 Sep 2020 12:58:49 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id 189so477910ybw.3;
        Wed, 02 Sep 2020 12:58:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=akPwGPVyEn01/5PkIcyW2RKrfHk8fuIlsFrNUzPRZ1c=;
        b=XNJfBAlWfSkqadLD40GNInLlDVREKJC2hTQ0dXAR+p5lETrUjzv+0s/vmopQfFqWac
         2T1Y9QcJ3KWt5+6F1pMqELeyHj4XlHdF2u6OXSap4r2UOiUan4U/O5Zgj1N6JLj3dxL6
         3ZWpi45BC7/HzfkI3czPaatQdDhe6wuolNqjvRnkmHH8EUdknA4Ql9PLBvQ++emqSNUa
         0U8rXypyroW7MuZwf+hmz+5jf88s1V5KXxmYMaZszzQcGUJ8XsokceSK3D8f8Dxgf/1x
         A5T2W7YqpGC5yPUNkJpjMMMQIKce+DEIVSodbmF9USSp4DzLOzv/repVjaxeRTV9icjH
         7Gvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=akPwGPVyEn01/5PkIcyW2RKrfHk8fuIlsFrNUzPRZ1c=;
        b=SW3LmnihhwFVIxN7b+Rh+0Qtaay9WIcjf+hFtmVUvlSYuoJEH59m8MmV9zZRLqT42N
         eOM5mU37YR2DwD6AydQ1i1ywrr6SGo4Y4qgi6Z9vpPmg4o7ooS1p0ZJA9tRp+Lqb5N6N
         A7Dwq6ADNJvK9qzrkE570jHt7uo3s+HVheAL1XvyMlYhlSOgRJt+CnIDCPpm6MPjyVBj
         7VGdYRsBIM1hFRhKOZM4o33W4oUMd/2HbqAAGVNNb1Va0jF9A5/b1CMKzVs271dBv7ca
         8UEP8qnUjIFQWHxNFRKPNlDMg1v+MeHYwY/n4JMsE+5DS3ISjZS4dN97mbzgOYSVo1Mg
         pz3g==
X-Gm-Message-State: AOAM532ekfqg9US0hwTCkSC4QuuFjQdU86FnHuxJbm3UI4TQ6Fs3H6xa
        hj2gTUvzHFR61I68wo2rB9AfbYUJMOBPrFfJfUc=
X-Google-Smtp-Source: ABdhPJwOPal6LTKiDDmPc4/570Jux9htCERyCLT2zJNUur2Lg9rUg2LxAm+9uoypYTvriTZwntF84G5T5TiH8a4t9Ks=
X-Received: by 2002:a25:c4c2:: with SMTP id u185mr13281539ybf.347.1599076728309;
 Wed, 02 Sep 2020 12:58:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200901015003.2871861-1-andriin@fb.com> <20200901015003.2871861-13-andriin@fb.com>
 <20200902054529.5sjbmt2t6pgzi4sk@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200902054529.5sjbmt2t6pgzi4sk@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 2 Sep 2020 12:58:37 -0700
Message-ID: <CAEf4BzaaJtHNCz-J+XdRzMQbhdbmGwRQ+hnDCEO1VYfUATWJqQ@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 12/14] selftests/bpf: convert pyperf,
 strobemeta, and l4lb_noinline to __noinline
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 1, 2020 at 10:45 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Mon, Aug 31, 2020 at 06:50:01PM -0700, Andrii Nakryiko wrote:
> > diff --git a/tools/testing/selftests/bpf/progs/pyperf.h b/tools/testing/selftests/bpf/progs/pyperf.h
> > index cc615b82b56e..13998aee887f 100644
> > --- a/tools/testing/selftests/bpf/progs/pyperf.h
> > +++ b/tools/testing/selftests/bpf/progs/pyperf.h
> > @@ -67,7 +67,7 @@ typedef struct {
> >       void* co_name; // PyCodeObject.co_name
> >  } FrameData;
> >
> > -static __always_inline void *get_thread_state(void *tls_base, PidData *pidData)
> > +static __noinline void *get_thread_state(void *tls_base, PidData *pidData)
> >  {
> >       void* thread_state;
> >       int key;
> > @@ -154,12 +154,10 @@ struct {
> >       __uint(value_size, sizeof(long long) * 127);
> >  } stackmap SEC(".maps");
> >
> > -#ifdef GLOBAL_FUNC
> > -__attribute__((noinline))
> > -#else
> > -static __always_inline
> > +#ifndef GLOBAL_FUNC
> > +static
> >  #endif
> > -int __on_event(struct bpf_raw_tracepoint_args *ctx)
> > +__noinline int __on_event(struct bpf_raw_tracepoint_args *ctx)
> >  {
> >       uint64_t pid_tgid = bpf_get_current_pid_tgid();
> >       pid_t pid = (pid_t)(pid_tgid >> 32);
> > diff --git a/tools/testing/selftests/bpf/progs/strobemeta.h b/tools/testing/selftests/bpf/progs/strobemeta.h
> > index ad61b722a9de..d307c67ce52e 100644
> > --- a/tools/testing/selftests/bpf/progs/strobemeta.h
> > +++ b/tools/testing/selftests/bpf/progs/strobemeta.h
> > @@ -266,8 +266,7 @@ struct tls_index {
> >       uint64_t offset;
> >  };
> >
> > -static __always_inline void *calc_location(struct strobe_value_loc *loc,
> > -                                        void *tls_base)
> > +static __noinline void *calc_location(struct strobe_value_loc *loc, void *tls_base)
>
> hmm. this reduces the existing test coverage. Unless I'm misreading it.
> Could you keep existing strobemta tests and add new one?
> With new ifdefs. Like this GLOBAL_FUNC.

Oh, you mean testing single BPF program complexity when everything is
inlined? Yeah, haven't thought about that. Ok, I'll add new variants
with or without subprogram calls.
