Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DCBD77F20
	for <lists+netdev@lfdr.de>; Sun, 28 Jul 2019 13:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726010AbfG1LJR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jul 2019 07:09:17 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34349 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725961AbfG1LJR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jul 2019 07:09:17 -0400
Received: by mail-wr1-f67.google.com with SMTP id 31so58808244wrm.1;
        Sun, 28 Jul 2019 04:09:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=beL4mWA1iVeAECG6KDWGVS8O+3XLORAZj0ElPPmdem4=;
        b=TRbQSGnn2PVKQyFXo3U+RBY2TNwwaxgl5HbXTbt9wOR/GO6AGuSpyFnvSOTj1GkMd3
         is6BT+F07GfJdTeMgBfZGlPMD53nxhAlyNVZkobNFnVPAw01U64RGhCYHKhAKDThPtBm
         CSUlNtKE/ayJcSOit3atVObvuqEaICnJk409zwGrSGp8iTs5ir4y9YzcG0+c+cJMWTP6
         3jfraGzHz9mHDNO+0aGKwOBZ0SVSx3uBYzaMW07CMahQp6jf0SKOIg/2oA6lD1BHIGXA
         lINW9hJTycl2AUPqvv7pzZYfyUkYWzzZUSBd533IESDlwEOIuGpUJJfXVmFADElah681
         bmJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=beL4mWA1iVeAECG6KDWGVS8O+3XLORAZj0ElPPmdem4=;
        b=AJLNV9W5skrsZA51V2IHu+PhCCZWOuQufTpiATLH4VVrnV2dv7E2eGouQ/1c6qF6C/
         wVk5qwaIL+R0vbc/pfucm7DKH+VrxaNISVxR+0gFZCHhP2xKD4STS2ui9sBK8gF8FT3C
         L5q/2TAFeqCsa9hNf/9+xpB2BMKC3V+IyE2wXG13bj2V5sQdEA6lIbtklJgVyD3a7C7V
         o6HAuakEpqmSOkI4IVZL16KIEkr67hyuoKyRYnaTb8bpHG572P1BJrBOdwE77JfrTwaD
         EZnZUrnB4yMTY9z+m37spWDCpwpXFyzzEqh2rVIHvrbIl89dwW6Px2m8y5PvJyW4JRCV
         ZeNQ==
X-Gm-Message-State: APjAAAWyEikutSYOR0QXO73w/yBNBERojc9oB/cnCX58r/5dqWmoQI/d
        7ltyBsx5oELlLHmlxmUeXYu7tf9Ay+2JpaRecDk=
X-Google-Smtp-Source: APXvYqyisNyp0sLS7ZG8HrUtViGBwbyzyj/xEFn1IMpCJOOquxD+iDa5nDOXTyGYXIImTNfMojhTyScBeIUf0R8QFGI=
X-Received: by 2002:a5d:4212:: with SMTP id n18mr110877871wrq.261.1564312154314;
 Sun, 28 Jul 2019 04:09:14 -0700 (PDT)
MIME-Version: 1.0
References: <CA+icZUWF=B_phP8eGD3v2d9jSSK6Y-N65y-T6xewZnY91vc2_Q@mail.gmail.com>
 <c2524c96-d71c-d7db-22ec-12da905dc180@fb.com> <CA+icZUXYp=Jx+8aGrZmkCbSFp-cSPcoRzRdRJsPj4yYNs_mJQw@mail.gmail.com>
 <CA+icZUXsPRWmH3i-9=TK-=2HviubRqpAeDJGriWHgK1fkFhgUg@mail.gmail.com>
 <295d2acd-0844-9a40-3f94-5bcbb13871d2@fb.com> <CA+icZUUe0QE9QGMom1iQwuG8nM7Oi4Mq0GKqrLvebyxfUmj6RQ@mail.gmail.com>
 <CAADnVQLhymu8YqtfM1NHD5LMgO6a=FZYaeaYS1oCyfGoBDE_BQ@mail.gmail.com>
 <CA+icZUXGPCgdJzxTO+8W0EzNLZEQ88J_wusp7fPfEkNE2RoXJA@mail.gmail.com> <934a2a0a-c3fb-fd75-b8a3-c1042d73ca0c@fb.com>
In-Reply-To: <934a2a0a-c3fb-fd75-b8a3-c1042d73ca0c@fb.com>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Sun, 28 Jul 2019 13:09:03 +0200
Message-ID: <CA+icZUVcvwKvAxv+doNYmGGmKnxSgc7DpozgnAwWgdVUpsvgtg@mail.gmail.com>
Subject: Re: next-20190723: bpf/seccomp - systemd/journald issue?
To:     Yonghong Song <yhs@fb.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
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

On Sat, Jul 27, 2019 at 7:08 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 7/27/19 12:36 AM, Sedat Dilek wrote:
> > On Sat, Jul 27, 2019 at 4:24 AM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> >>
> >> On Fri, Jul 26, 2019 at 2:19 PM Sedat Dilek <sedat.dilek@gmail.com> wrote:
> >>>
> >>> On Fri, Jul 26, 2019 at 11:10 PM Yonghong Song <yhs@fb.com> wrote:
> >>>>
> >>>>
> >>>>
> >>>> On 7/26/19 2:02 PM, Sedat Dilek wrote:
> >>>>> On Fri, Jul 26, 2019 at 10:38 PM Sedat Dilek <sedat.dilek@gmail.com> wrote:
> >>>>>>
> >>>>>> Hi Yonghong Song,
> >>>>>>
> >>>>>> On Fri, Jul 26, 2019 at 5:45 PM Yonghong Song <yhs@fb.com> wrote:
> >>>>>>>
> >>>>>>>
> >>>>>>>
> >>>>>>> On 7/26/19 1:26 AM, Sedat Dilek wrote:
> >>>>>>>> Hi,
> >>>>>>>>
> >>>>>>>> I have opened a new issue in the ClangBuiltLinux issue tracker.
> >>>>>>>
> >>>>>>> Glad to know clang 9 has asm goto support and now It can compile
> >>>>>>> kernel again.
> >>>>>>>
> >>>>>>
> >>>>>> Yupp.
> >>>>>>
> >>>>>>>>
> >>>>>>>> I am seeing a problem in the area bpf/seccomp causing
> >>>>>>>> systemd/journald/udevd services to fail.
> >>>>>>>>
> >>>>>>>> [Fri Jul 26 08:08:43 2019] systemd[453]: systemd-udevd.service: Failed
> >>>>>>>> to connect stdout to the journal socket, ignoring: Connection refused
> >>>>>>>>
> >>>>>>>> This happens when I use the (LLVM) LLD ld.lld-9 linker but not with
> >>>>>>>> BFD linker ld.bfd on Debian/buster AMD64.
> >>>>>>>> In both cases I use clang-9 (prerelease).
> >>>>>>>
> >>>>>>> Looks like it is a lld bug.
> >>>>>>>
> >>>>>>> I see the stack trace has __bpf_prog_run32() which is used by
> >>>>>>> kernel bpf interpreter. Could you try to enable bpf jit
> >>>>>>>      sysctl net.core.bpf_jit_enable = 1
> >>>>>>> If this passed, it will prove it is interpreter related.
> >>>>>>>
> >>>>>>
> >>>>>> After...
> >>>>>>
> >>>>>> sysctl -w net.core.bpf_jit_enable=1
> >>>>>>
> >>>>>> I can start all failed systemd services.
> >>>>>>
> >>>>>> systemd-journald.service
> >>>>>> systemd-udevd.service
> >>>>>> haveged.service
> >>>>>>
> >>>>>> This is in maintenance mode.
> >>>>>>
> >>>>>> What is next: Do set a permanent sysctl setting for net.core.bpf_jit_enable?
> >>>>>>
> >>>>>
> >>>>> This is what I did:
> >>>>
> >>>> I probably won't have cycles to debug this potential lld issue.
> >>>> Maybe you already did, I suggest you put enough reproducible
> >>>> details in the bug you filed against lld so they can take a look.
> >>>>
> >>>
> >>> I understand and will put the journalctl-log into the CBL issue
> >>> tracker and update informations.
> >>>
> >>> Thanks for your help understanding the BPF correlations.
> >>>
> >>> Is setting 'net.core.bpf_jit_enable = 2' helpful here?
> >>
> >> jit_enable=1 is enough.
> >> Or use CONFIG_BPF_JIT_ALWAYS_ON to workaround.
> >>
> >> It sounds like clang miscompiles interpreter.
> >> modprobe test_bpf
> >> should be able to point out which part of interpreter is broken.
> >
> > Maybe we need something like...
> >
> > "bpf: Disable GCC -fgcse optimization for ___bpf_prog_run()"
> >
> > ...for clang?
>
> Not sure how do you get conclusion it is gcse causing the problem.
> But anyway, adding such flag in the kernel is not a good idea.
> clang/llvm should be fixed instead. Esp. there is still time
> for 9.0.0 release to fix bugs.
>

To clarify: This is a snapshot release of clang-9 built with tc-build.

Building with -O0 is not possible as I see asm-goto failing.

- Sedat -

[1] https://github.com/ClangBuiltLinux/tc-build

> >
> > - Sedat -
> >
> > [1] https://git.kernel.org/linus/3193c0836f203a91bef96d88c64cccf0be090d9c
> >
