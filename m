Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67931775F4
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 04:24:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727589AbfG0CYe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 22:24:34 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:46264 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726806AbfG0CYe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 22:24:34 -0400
Received: by mail-lf1-f66.google.com with SMTP id z15so34071962lfh.13;
        Fri, 26 Jul 2019 19:24:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dBSGvoN0c2FHrhYCgc5hOl319yWYWmBdFzMKxGL9ZAQ=;
        b=JvYfiJXaqJP8aN9j2HHocVEG0CLr3zCePc3HOARxUZQIKPSYalbxTIbMO5a5piCDoa
         6NkHB3I/WaVK31x0e5KGK5v9M+SBgQypa1XSSrDLCEYEtnwuP+zHCgNu2MFHBRZkZxtR
         iVAmBVNnJQslDwSg3VROZc8g/KahJU452gVegCkT+SBavOU6z1cvmQG4evb02o7yj6wm
         xVklA0IEalyN/qnqcp2RlJTUcNVpVfqzxrsY7Uao5QZ39kCd8iAJXkieWTVg0Ftxv1sV
         w0pSP2AQjiwbhSDtdMJYyPJRv/odFrtNaxuntyqlakx5kv2D3NLrjcHUBvkWLapZXWbd
         8Vkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dBSGvoN0c2FHrhYCgc5hOl319yWYWmBdFzMKxGL9ZAQ=;
        b=EHN2Up1f5dPLvP3LXrDmPBFZ7YQCe5nHpvkcP15T+PV/myDbL4YJXk1DDCDhNAMnZA
         3S+TvR4QXUVhSKWPLZzM9sdpDnMLEyL4VZgQ/kaX8M0UOSJTdD490asLZavEzRSn9YUp
         WnPpntySeF1nEU5oaOeWZ1xLG5Bzu5hgeLnt7QlLaymG7VNILnRgtis0qnjIUQr/8pfg
         B4GxaVr5p1HgRDOBO02UCnAvGCioiF2RKvHxRgX4oLuctRTDzbHdDtXcqAwG2EBRg+kv
         zu52uhxTcCTmMhAUttH9iSeG8Bgxnft8Ps6/m+9k6e+z1PTWEs7PcpBeUt4Cb+pp0ffj
         U0IQ==
X-Gm-Message-State: APjAAAUz4hTm81XuJT9heZgO5clQVeX1Njht2yv1eg68efL6ZgI+UW3X
        673nMVOyJ6R33WVMCg7UwKxRupWn4XkVsFrKhJg=
X-Google-Smtp-Source: APXvYqxInzEYX2yEEOAkZcjndwudEf4QiSz2GOn2kNhb78TsRJSQPw2FjUEGszb6HcKMGNZtGcBrAbr0R/affKO0J/M=
X-Received: by 2002:a05:6512:288:: with SMTP id j8mr50127136lfp.181.1564194271869;
 Fri, 26 Jul 2019 19:24:31 -0700 (PDT)
MIME-Version: 1.0
References: <CA+icZUWF=B_phP8eGD3v2d9jSSK6Y-N65y-T6xewZnY91vc2_Q@mail.gmail.com>
 <c2524c96-d71c-d7db-22ec-12da905dc180@fb.com> <CA+icZUXYp=Jx+8aGrZmkCbSFp-cSPcoRzRdRJsPj4yYNs_mJQw@mail.gmail.com>
 <CA+icZUXsPRWmH3i-9=TK-=2HviubRqpAeDJGriWHgK1fkFhgUg@mail.gmail.com>
 <295d2acd-0844-9a40-3f94-5bcbb13871d2@fb.com> <CA+icZUUe0QE9QGMom1iQwuG8nM7Oi4Mq0GKqrLvebyxfUmj6RQ@mail.gmail.com>
In-Reply-To: <CA+icZUUe0QE9QGMom1iQwuG8nM7Oi4Mq0GKqrLvebyxfUmj6RQ@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 26 Jul 2019 19:24:20 -0700
Message-ID: <CAADnVQLhymu8YqtfM1NHD5LMgO6a=FZYaeaYS1oCyfGoBDE_BQ@mail.gmail.com>
Subject: Re: next-20190723: bpf/seccomp - systemd/journald issue?
To:     sedat.dilek@gmail.com
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

On Fri, Jul 26, 2019 at 2:19 PM Sedat Dilek <sedat.dilek@gmail.com> wrote:
>
> On Fri, Jul 26, 2019 at 11:10 PM Yonghong Song <yhs@fb.com> wrote:
> >
> >
> >
> > On 7/26/19 2:02 PM, Sedat Dilek wrote:
> > > On Fri, Jul 26, 2019 at 10:38 PM Sedat Dilek <sedat.dilek@gmail.com> wrote:
> > >>
> > >> Hi Yonghong Song,
> > >>
> > >> On Fri, Jul 26, 2019 at 5:45 PM Yonghong Song <yhs@fb.com> wrote:
> > >>>
> > >>>
> > >>>
> > >>> On 7/26/19 1:26 AM, Sedat Dilek wrote:
> > >>>> Hi,
> > >>>>
> > >>>> I have opened a new issue in the ClangBuiltLinux issue tracker.
> > >>>
> > >>> Glad to know clang 9 has asm goto support and now It can compile
> > >>> kernel again.
> > >>>
> > >>
> > >> Yupp.
> > >>
> > >>>>
> > >>>> I am seeing a problem in the area bpf/seccomp causing
> > >>>> systemd/journald/udevd services to fail.
> > >>>>
> > >>>> [Fri Jul 26 08:08:43 2019] systemd[453]: systemd-udevd.service: Failed
> > >>>> to connect stdout to the journal socket, ignoring: Connection refused
> > >>>>
> > >>>> This happens when I use the (LLVM) LLD ld.lld-9 linker but not with
> > >>>> BFD linker ld.bfd on Debian/buster AMD64.
> > >>>> In both cases I use clang-9 (prerelease).
> > >>>
> > >>> Looks like it is a lld bug.
> > >>>
> > >>> I see the stack trace has __bpf_prog_run32() which is used by
> > >>> kernel bpf interpreter. Could you try to enable bpf jit
> > >>>     sysctl net.core.bpf_jit_enable = 1
> > >>> If this passed, it will prove it is interpreter related.
> > >>>
> > >>
> > >> After...
> > >>
> > >> sysctl -w net.core.bpf_jit_enable=1
> > >>
> > >> I can start all failed systemd services.
> > >>
> > >> systemd-journald.service
> > >> systemd-udevd.service
> > >> haveged.service
> > >>
> > >> This is in maintenance mode.
> > >>
> > >> What is next: Do set a permanent sysctl setting for net.core.bpf_jit_enable?
> > >>
> > >
> > > This is what I did:
> >
> > I probably won't have cycles to debug this potential lld issue.
> > Maybe you already did, I suggest you put enough reproducible
> > details in the bug you filed against lld so they can take a look.
> >
>
> I understand and will put the journalctl-log into the CBL issue
> tracker and update informations.
>
> Thanks for your help understanding the BPF correlations.
>
> Is setting 'net.core.bpf_jit_enable = 2' helpful here?

jit_enable=1 is enough.
Or use CONFIG_BPF_JIT_ALWAYS_ON to workaround.

It sounds like clang miscompiles interpreter.
modprobe test_bpf
should be able to point out which part of interpreter is broken.
