Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1B9A77779
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 09:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728332AbfG0Hge (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 03:36:34 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38777 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726197AbfG0Hge (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 03:36:34 -0400
Received: by mail-wr1-f65.google.com with SMTP id g17so56580539wrr.5;
        Sat, 27 Jul 2019 00:36:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=76ws4qemCbK8PdXmvOPFqC7qosVhVH8+4Ya0bG6HZyU=;
        b=fAWCaJ1iAvmLQfjZi/HMIwN+ytyy2n4tTQpgr/FGuNMhF9qeAWCCSx8t3/6OMu8GSS
         k/74shZx9E0KhapiK0TH+XP+h69DjxFMvFFLmlyHEwGhmbdowfk1iv9PpNzCvlG+zTa7
         87HHwy26rVnjJ1mw++sisyoFRKdQicBbvdgTaWEduLOFlmxrICVyYIPAsDKxNWDKs8Y5
         9jeY9qnSBywQF7xQ2Sw2izpzDKdjuLnJBYh8lSwH1KhyfGh2FCwk1xhP1F6UOAv8IUhy
         5OnfQtNIsWKzyHkNeHpTVAMU/sQe2MhXdgQlB+zxpxizHL+Z3UfTsJcxZV5tKS5tbAEw
         XFmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=76ws4qemCbK8PdXmvOPFqC7qosVhVH8+4Ya0bG6HZyU=;
        b=nmLB9pX1V+bilDtKeFDDPijX1tnQYqBhdoevkJQ+POOF1Z+ZP3fRs7sDM+TwR1tGVS
         V2Q9+hjo0nbFKjrQF3W6cS3KZZPYEMB45Cg6CCXkzYUDyJ4WaA3EF0ezWdUi05OtFka0
         Wc+k6olH8bw8ygabFMnP5h+rdjy/ODXhgg2c6K8piA4rMJEmn1bs+H+ap8Qu3CxPELQ8
         vPIBV/bLrCkP1NvZb+9sHQMKYrymnOwUrH+3kh/GfhDgXIUWxz+5QXhl/edKOM2euFux
         L7hsH6GNG6zXpVa6/4cGgvGM8szFIcavxTbRduJuggizrlUjW1dhMF93FpDi+e0ljXVy
         JLUg==
X-Gm-Message-State: APjAAAWA+Z3a8xT8wx4F8iNiLfV4mHZ4NVq4lpPOeQ9aF0vjP0pYI23c
        6rqS72h2Fe9VTyr+Dc3zShcuZdQOEsT1flgeK0w=
X-Google-Smtp-Source: APXvYqxroH+KmlWgRBo+HzQxhgLvRnbBgWmKuDR+aiS23pQ4whB2EoPIjXLGsovY6+QMmmEzNblRBH0uQi5koKnIFPM=
X-Received: by 2002:a5d:4101:: with SMTP id l1mr52631955wrp.202.1564212991777;
 Sat, 27 Jul 2019 00:36:31 -0700 (PDT)
MIME-Version: 1.0
References: <CA+icZUWF=B_phP8eGD3v2d9jSSK6Y-N65y-T6xewZnY91vc2_Q@mail.gmail.com>
 <c2524c96-d71c-d7db-22ec-12da905dc180@fb.com> <CA+icZUXYp=Jx+8aGrZmkCbSFp-cSPcoRzRdRJsPj4yYNs_mJQw@mail.gmail.com>
 <CA+icZUXsPRWmH3i-9=TK-=2HviubRqpAeDJGriWHgK1fkFhgUg@mail.gmail.com>
 <295d2acd-0844-9a40-3f94-5bcbb13871d2@fb.com> <CA+icZUUe0QE9QGMom1iQwuG8nM7Oi4Mq0GKqrLvebyxfUmj6RQ@mail.gmail.com>
 <CAADnVQLhymu8YqtfM1NHD5LMgO6a=FZYaeaYS1oCyfGoBDE_BQ@mail.gmail.com>
In-Reply-To: <CAADnVQLhymu8YqtfM1NHD5LMgO6a=FZYaeaYS1oCyfGoBDE_BQ@mail.gmail.com>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Sat, 27 Jul 2019 09:36:20 +0200
Message-ID: <CA+icZUXGPCgdJzxTO+8W0EzNLZEQ88J_wusp7fPfEkNE2RoXJA@mail.gmail.com>
Subject: Re: next-20190723: bpf/seccomp - systemd/journald issue?
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Clang-Built-Linux ML <clang-built-linux@googlegroups.com>,
        Kees Cook <keescook@chromium.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 27, 2019 at 4:24 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Fri, Jul 26, 2019 at 2:19 PM Sedat Dilek <sedat.dilek@gmail.com> wrote:
> >
> > On Fri, Jul 26, 2019 at 11:10 PM Yonghong Song <yhs@fb.com> wrote:
> > >
> > >
> > >
> > > On 7/26/19 2:02 PM, Sedat Dilek wrote:
> > > > On Fri, Jul 26, 2019 at 10:38 PM Sedat Dilek <sedat.dilek@gmail.com> wrote:
> > > >>
> > > >> Hi Yonghong Song,
> > > >>
> > > >> On Fri, Jul 26, 2019 at 5:45 PM Yonghong Song <yhs@fb.com> wrote:
> > > >>>
> > > >>>
> > > >>>
> > > >>> On 7/26/19 1:26 AM, Sedat Dilek wrote:
> > > >>>> Hi,
> > > >>>>
> > > >>>> I have opened a new issue in the ClangBuiltLinux issue tracker.
> > > >>>
> > > >>> Glad to know clang 9 has asm goto support and now It can compile
> > > >>> kernel again.
> > > >>>
> > > >>
> > > >> Yupp.
> > > >>
> > > >>>>
> > > >>>> I am seeing a problem in the area bpf/seccomp causing
> > > >>>> systemd/journald/udevd services to fail.
> > > >>>>
> > > >>>> [Fri Jul 26 08:08:43 2019] systemd[453]: systemd-udevd.service: Failed
> > > >>>> to connect stdout to the journal socket, ignoring: Connection refused
> > > >>>>
> > > >>>> This happens when I use the (LLVM) LLD ld.lld-9 linker but not with
> > > >>>> BFD linker ld.bfd on Debian/buster AMD64.
> > > >>>> In both cases I use clang-9 (prerelease).
> > > >>>
> > > >>> Looks like it is a lld bug.
> > > >>>
> > > >>> I see the stack trace has __bpf_prog_run32() which is used by
> > > >>> kernel bpf interpreter. Could you try to enable bpf jit
> > > >>>     sysctl net.core.bpf_jit_enable = 1
> > > >>> If this passed, it will prove it is interpreter related.
> > > >>>
> > > >>
> > > >> After...
> > > >>
> > > >> sysctl -w net.core.bpf_jit_enable=1
> > > >>
> > > >> I can start all failed systemd services.
> > > >>
> > > >> systemd-journald.service
> > > >> systemd-udevd.service
> > > >> haveged.service
> > > >>
> > > >> This is in maintenance mode.
> > > >>
> > > >> What is next: Do set a permanent sysctl setting for net.core.bpf_jit_enable?
> > > >>
> > > >
> > > > This is what I did:
> > >
> > > I probably won't have cycles to debug this potential lld issue.
> > > Maybe you already did, I suggest you put enough reproducible
> > > details in the bug you filed against lld so they can take a look.
> > >
> >
> > I understand and will put the journalctl-log into the CBL issue
> > tracker and update informations.
> >
> > Thanks for your help understanding the BPF correlations.
> >
> > Is setting 'net.core.bpf_jit_enable = 2' helpful here?
>
> jit_enable=1 is enough.
> Or use CONFIG_BPF_JIT_ALWAYS_ON to workaround.
>
> It sounds like clang miscompiles interpreter.
> modprobe test_bpf
> should be able to point out which part of interpreter is broken.

Maybe we need something like...

"bpf: Disable GCC -fgcse optimization for ___bpf_prog_run()"

...for clang?

- Sedat -

[1] https://git.kernel.org/linus/3193c0836f203a91bef96d88c64cccf0be090d9c
