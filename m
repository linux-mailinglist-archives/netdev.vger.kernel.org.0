Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E11C77796
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 10:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728407AbfG0IQh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 04:16:37 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36659 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728347AbfG0IQg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 04:16:36 -0400
Received: by mail-wr1-f67.google.com with SMTP id n4so56712944wrs.3;
        Sat, 27 Jul 2019 01:16:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=76rL5iz1eRzr5KitnsEreILjrU7y5lITzKiCAHJ8VEY=;
        b=QEXihd9uQzvpUue7hGkwAlr9ICErBB4oKYYS+g4/KGJ5wBpNiRw4QkxeyTDeDhYH5+
         /k5SNh65HKMMk1suzYtGm7Tarca3zmPu50NvHgFd17X3OVBQT6QI3Z2ooejJiCYs5gmq
         +vZFa8M9quXlFKraBh1eomrrzbq0bgDNEVkJSoauxKeRe6LMf8zsIsqJhlXAdk/aZ0xt
         g+JORzEIRsg0o6tYzEgQDoI4paJejFLVJePK6VRWxa4bILG0CnirhNjm88/aj3IkRSie
         gCSwKHUVwXIiA3sQ4gA1LpycEpZbIi3iPZRISwyYqQydKyV5dAE7jK8QA/MPHBMQyoFI
         P55w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=76rL5iz1eRzr5KitnsEreILjrU7y5lITzKiCAHJ8VEY=;
        b=BJiq5Spum9rOb283M8B3kEHq9xNi5SwgZgPBdQWYDZeFdHAUeq6P5dzhX26kHTsjlg
         tgv0gPPqb0slGYEZmJyAfd7o7QKIGr8b9ufjp83soeo+Nhc9M/f0gWP0wJUGD3THlVR8
         56YogVmgYk+r5wHVOWH8LN0yvMq6SiMLqf6ixvz3ryuW7VTFM0tBM66XipRTe+lL6ltC
         xrPYfLbdzYlKSZJ1VdZBXL/TnuT4poqThMgJ2U92lwoSlNRuxDZZs7lY/izYTAcVbgXk
         l5B0KWU+TRGHImjWp4+ygbRhFPKv+kihoDRkwiC3nbJ/lXPvf6dNRFErHHwyoWc2yy0e
         qDUw==
X-Gm-Message-State: APjAAAWILuNDJP2DZGE2dSMRcW1rZD4AS8MzQBTUAF4gxmc8j63l/e4N
        Zl44QarswdTa2GwymhHfL+q1UQCXQDwvIqhPdg0=
X-Google-Smtp-Source: APXvYqx7/IxvBOy5UgQX7aBlYajcmAp/kCJ5LhlRmCHrjnL/Vq1J1RSLOsBd+rI21yWR46IBMboNvxfaDJ4cDw8xYxo=
X-Received: by 2002:a5d:498f:: with SMTP id r15mr100608236wrq.353.1564215393799;
 Sat, 27 Jul 2019 01:16:33 -0700 (PDT)
MIME-Version: 1.0
References: <CA+icZUWF=B_phP8eGD3v2d9jSSK6Y-N65y-T6xewZnY91vc2_Q@mail.gmail.com>
 <c2524c96-d71c-d7db-22ec-12da905dc180@fb.com> <CA+icZUXYp=Jx+8aGrZmkCbSFp-cSPcoRzRdRJsPj4yYNs_mJQw@mail.gmail.com>
 <CA+icZUXsPRWmH3i-9=TK-=2HviubRqpAeDJGriWHgK1fkFhgUg@mail.gmail.com>
 <295d2acd-0844-9a40-3f94-5bcbb13871d2@fb.com> <CA+icZUUe0QE9QGMom1iQwuG8nM7Oi4Mq0GKqrLvebyxfUmj6RQ@mail.gmail.com>
 <CAADnVQLhymu8YqtfM1NHD5LMgO6a=FZYaeaYS1oCyfGoBDE_BQ@mail.gmail.com> <CA+icZUXGPCgdJzxTO+8W0EzNLZEQ88J_wusp7fPfEkNE2RoXJA@mail.gmail.com>
In-Reply-To: <CA+icZUXGPCgdJzxTO+8W0EzNLZEQ88J_wusp7fPfEkNE2RoXJA@mail.gmail.com>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Sat, 27 Jul 2019 10:16:21 +0200
Message-ID: <CA+icZUWVf6AK3bxfWBZ7iM1QTyk_G-4+1_LyK0jkoBDkDzvx4Q@mail.gmail.com>
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

On Sat, Jul 27, 2019 at 9:36 AM Sedat Dilek <sedat.dilek@gmail.com> wrote:
>
> On Sat, Jul 27, 2019 at 4:24 AM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Fri, Jul 26, 2019 at 2:19 PM Sedat Dilek <sedat.dilek@gmail.com> wrote:
> > >
> > > On Fri, Jul 26, 2019 at 11:10 PM Yonghong Song <yhs@fb.com> wrote:
> > > >
> > > >
> > > >
> > > > On 7/26/19 2:02 PM, Sedat Dilek wrote:
> > > > > On Fri, Jul 26, 2019 at 10:38 PM Sedat Dilek <sedat.dilek@gmail.com> wrote:
> > > > >>
> > > > >> Hi Yonghong Song,
> > > > >>
> > > > >> On Fri, Jul 26, 2019 at 5:45 PM Yonghong Song <yhs@fb.com> wrote:
> > > > >>>
> > > > >>>
> > > > >>>
> > > > >>> On 7/26/19 1:26 AM, Sedat Dilek wrote:
> > > > >>>> Hi,
> > > > >>>>
> > > > >>>> I have opened a new issue in the ClangBuiltLinux issue tracker.
> > > > >>>
> > > > >>> Glad to know clang 9 has asm goto support and now It can compile
> > > > >>> kernel again.
> > > > >>>
> > > > >>
> > > > >> Yupp.
> > > > >>
> > > > >>>>
> > > > >>>> I am seeing a problem in the area bpf/seccomp causing
> > > > >>>> systemd/journald/udevd services to fail.
> > > > >>>>
> > > > >>>> [Fri Jul 26 08:08:43 2019] systemd[453]: systemd-udevd.service: Failed
> > > > >>>> to connect stdout to the journal socket, ignoring: Connection refused
> > > > >>>>
> > > > >>>> This happens when I use the (LLVM) LLD ld.lld-9 linker but not with
> > > > >>>> BFD linker ld.bfd on Debian/buster AMD64.
> > > > >>>> In both cases I use clang-9 (prerelease).
> > > > >>>
> > > > >>> Looks like it is a lld bug.
> > > > >>>
> > > > >>> I see the stack trace has __bpf_prog_run32() which is used by
> > > > >>> kernel bpf interpreter. Could you try to enable bpf jit
> > > > >>>     sysctl net.core.bpf_jit_enable = 1
> > > > >>> If this passed, it will prove it is interpreter related.
> > > > >>>
> > > > >>
> > > > >> After...
> > > > >>
> > > > >> sysctl -w net.core.bpf_jit_enable=1
> > > > >>
> > > > >> I can start all failed systemd services.
> > > > >>
> > > > >> systemd-journald.service
> > > > >> systemd-udevd.service
> > > > >> haveged.service
> > > > >>
> > > > >> This is in maintenance mode.
> > > > >>
> > > > >> What is next: Do set a permanent sysctl setting for net.core.bpf_jit_enable?
> > > > >>
> > > > >
> > > > > This is what I did:
> > > >
> > > > I probably won't have cycles to debug this potential lld issue.
> > > > Maybe you already did, I suggest you put enough reproducible
> > > > details in the bug you filed against lld so they can take a look.
> > > >
> > >
> > > I understand and will put the journalctl-log into the CBL issue
> > > tracker and update informations.
> > >
> > > Thanks for your help understanding the BPF correlations.
> > >
> > > Is setting 'net.core.bpf_jit_enable = 2' helpful here?
> >
> > jit_enable=1 is enough.
> > Or use CONFIG_BPF_JIT_ALWAYS_ON to workaround.
> >
> > It sounds like clang miscompiles interpreter.

Just to clarify:
This does not happen with clang-9 + ld.bfd (GNU/ld linker).

> > modprobe test_bpf
> > should be able to point out which part of interpreter is broken.
>
> Maybe we need something like...
>
> "bpf: Disable GCC -fgcse optimization for ___bpf_prog_run()"
>
> ...for clang?
>

Not sure if something like GCC's...

-fgcse

Perform a global common subexpression elimination pass. This pass also
performs global constant and copy propagation.

Note: When compiling a program using computed gotos, a GCC extension,
you may get better run-time performance if you disable the global
common subexpression elimination pass by adding -fno-gcse to the
command line.

Enabled at levels -O2, -O3, -Os.

...is available for clang.

I tried with hopping to turn off "global common subexpression elimination":

diff --git a/arch/x86/net/Makefile b/arch/x86/net/Makefile
index 383c87300b0d..92f934a1e9ff 100644
--- a/arch/x86/net/Makefile
+++ b/arch/x86/net/Makefile
@@ -3,6 +3,8 @@
 # Arch-specific network modules
 #

+KBUILD_CFLAGS += -O0
+
 ifeq ($(CONFIG_X86_32),y)
         obj-$(CONFIG_BPF_JIT) += bpf_jit_comp32.o
 else

Still see...
BROKEN: test_bpf: #294 BPF_MAXINSNS: Jump, gap, jump, ... jited:0

- Sedat -
