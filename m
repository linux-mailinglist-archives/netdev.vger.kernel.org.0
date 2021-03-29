Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E84134C1FD
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 04:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbhC2Cje (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 22:39:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230271AbhC2CjF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Mar 2021 22:39:05 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B0EAC061574;
        Sun, 28 Mar 2021 19:38:54 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id w8so12274478ybt.3;
        Sun, 28 Mar 2021 19:38:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=33INFIPrDA+cLi64cYDVf5nELFJnPwDCsojs1BYS9e0=;
        b=SC1GDA/YlCTwqzfTlUPUqTarHSRijy6NQPPURkC+c5JedNIaUevKXRNN6GR3Rzfsvo
         0X5VLT+yQIEW8jE++wPbLPbAYI/RmfWGlcSlUjd0FVD64QP7vbBFFAYFTIXQkPV9joPP
         L1TivumWiKtT2TZTFj2O5IBxl0f0PLovY08i44p4UIK5oqEKJBDYdj6NvqlYyY7bsiZi
         yKRPTykL1LqQNs7vC5fqbIaQdhGGOU6rEuNWipa6TATu+vUZsMRzQk02fnsRTqzD9BJr
         /Feo7egdRN4e7y21/GeoKE/PAEUT4j+M2PCl+Tjty5bn/nsw8+GbnAnrKkS76+KfguKx
         w2HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=33INFIPrDA+cLi64cYDVf5nELFJnPwDCsojs1BYS9e0=;
        b=ktgYA49fB3yJmsnLWcoSmO4j74KHBKkMPJNokQfKJG5Dmjm6Ap58ENL1Ek779SbDZ+
         8SMpiFeQkyLa7TNFksp/poGCeON5Gqs8rdUwfRcPHc1/7oHd8sh7AYoj8Z8Mpj9mXhnF
         eXjVcDIofGd0EXnXzG4bQBYF8a/zWwgeWqiu6VpL5KFSPgbyujKFrCGAj6RsQrxlxmdi
         5fIK9XyeJEoF9FWxJ4My2ltpSTxB6ARgwkxMMAOMxko5ZwqpMf9xg7yTq9MMUTAP96gy
         qqaQVlkyz5uGDIkWMJGCnJWmT4Ph2yiDJrzXQTxigrp/P4SQnzunLnjzsqnaCzhgEIIW
         ardQ==
X-Gm-Message-State: AOAM532Wh8usAFwp85iauCj5ZLV7wWEanxtVL3PPpO6dBsNhTGdE+axn
        AK92y0MrGvvgVHp/dSaSrLpVw8e5AVzdAdcJ0wdMRuNwLLLADg==
X-Google-Smtp-Source: ABdhPJz1j+34Rh8ICwuMs7SviJVhKkh9I5jSrmbaTtDKcHP5T82buMHpLjfGwIL+UvptjDLIVK+QfP842TaGHHEd0Bs=
X-Received: by 2002:a25:4982:: with SMTP id w124mr33691184yba.27.1616985533223;
 Sun, 28 Mar 2021 19:38:53 -0700 (PDT)
MIME-Version: 1.0
References: <20210325120020.236504-1-memxor@gmail.com> <20210325120020.236504-6-memxor@gmail.com>
 <20210327021534.pjfjctcdczj7facs@ast-mbp> <CAEf4Bzba_gdTvak_UHqi96-w6GLF5JQcpQRcG7zxnx=kY8Sd5w@mail.gmail.com>
 <20210329014044.fkmusoeaqs2hjiek@ast-mbp>
In-Reply-To: <20210329014044.fkmusoeaqs2hjiek@ast-mbp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sun, 28 Mar 2021 19:38:42 -0700
Message-ID: <CAEf4BzZaWjVhfkr7vizir7PfbcsaN99yEwOoqKi32V4X17f0Ng@mail.gmail.com>
Subject: Re: [PATCH bpf-next 5/5] libbpf: add selftests for TC-BPF API
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        bpf <bpf@vger.kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 28, 2021 at 6:40 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Sat, Mar 27, 2021 at 09:32:58PM -0700, Andrii Nakryiko wrote:
> > > I think it's better to start with new library for tc/xdp and have
> > > libbpf as a dependency on that new lib.
> > > For example we can add it as subdir in tools/lib/bpf/.
> > >
> > > Similarly I think integerating static linking into libbpf was a mistake.
> > > It should be a sub library as well.
> > >
> > > If we end up with core libbpf and ten sublibs for tc, xdp, af_xdp, linking,
> > > whatever else the users would appreciate that we don't shove single libbpf
> > > to them with a ton of features that they might never use.
> >
> > What's the concern exactly? The size of the library? Having 10
> > micro-libraries has its own set of downsides,
>
> specifically?

You didn't answer my question, but from what you write below I assume
libbpf size is your main concern?

As for downsides, I'm sure I'm not yet seeing all of the problems
we'll encounter when splitting libbpf into 10 pieces. But as a user,
having to figure out which libraries I need to use is a big hassle.
E.g., for XDP application using ringbuf, I'll need libbpfelf,
libbpftrace, libbpfnet, which implicitly also would depend on
libsysbpf, libbtf, libbpfutil, I assume. So having to list 3 vs 1
library is already annoying, but when statically linking I'd need to
specify all 6. I'd very much rather know that it has to be -lbpf at it
will provide me with all the basics (and it's already -lz and -lelf in
static linking scenario, which I wish we could get rid of).

>
> > I'm not convinced that's
> > a better situation for end users. And would certainly cause more
> > hassle for libbpf developers and packagers.
>
> For developers and packagers.. yes.
> For users.. quite the opposite.

See above. I don't know which hassle is libbpf for users today. You
were implying code size used for functionality users might not use
(e.g., linker). Libbpf is a very small library, <300KB. There are
users building tools for constrained embedded systems that use libbpf.
There are/were various problems mentioned, but the size of libbpf
wasn't yet one of them. We should certainly watch the code bloat, but
we are not yet at the point where library is too big for users to be
turned off. In shared library case it's even less of a concern.

> The skel gen and static linking must be split out before the next libbpf release.
> Not a single application linked with libbpf is going to use those pieces.
> bpftool is one and only that needs them. Hence forcing libbpf users
> to increase their .text with a dead code is a selfish call of libbpf
> developers and packagers. The user's priorities must come first.
>
> > And what did you include in "core libbpf"?
>
> I would take this opportunity to split libbpf into maintainable pieces:
> - libsysbpf - sys_bpf wrappers (pretty much tools/lib/bpf/bpf.c)
> - libbpfutil - hash, strset

strset and hash are internal data structures, I never intended to
expose them through public APIs. I haven't investigated, but if we
have a separate shared library (libbpfutil), I imagine we won't be
able to hide those APIs, right?

> - libbtf - BTF read/write
> - libbpfelf - ELF parsing, CORE, ksym, kconfig
> - libbpfskel - skeleton gen used by bpftool only

skeleton generation is already part of bpftool, there is no need to
split anything out

> - libbpflink - linker used by bpftool only
> - libbpfnet - networking attachment via netlink including TC and XDP
> - libbpftrace - perfbuf, ringbuf

ringbuf and perfbuf are both very small code-wise, and are used in
majority of BPF applications anyways

> - libxdp - Toke's xdp chaining
> - libxsk - af_xdp logic
>

Now, if we look at libbpf .o files, we can approximately see what
functionality is using most code:

File                Size Percent

bpf.o              17800    4.88
bpf_prog_linfo.o    2952    0.81
btf_dump.o         20472    5.61
btf.o              58160   15.93
hashmap.o           4056    1.11
libbpf_errno.o      2912    0.80
libbpf.o          190072   52.06
libbpf_probes.o     6696    1.83
linker.o           29408    8.05
netlink.o           5944    1.63
nlattr.o            2744    0.75
ringbuf.o           6128    1.68
str_error.o         1640    0.45
strset.o            3656    1.00
xsk.o              12456    3.41

Total             365096  100.00

so libbpf.o which has mostly bpf_object open/load logic and CO-RE take
more than half already. And it depends on still more stuff in btf,
hashmap, bpf, libbpf_probes, errno. But the final code size is even
smaller, because libbpf.so is just 285128 bytes (not 365096 as implied
by the table above), so even these numbers are pessimistic.

linker.o, which is about 8% of the code right now, but is also
actually taking less than 29KB, because when I remove linker.o and
re-compile, the final libbpf.so goes from 285128 to 267576 = 17552
reduction. Even if it grows 2x, I'd still say it's not a big deal.

One reason to keep BPF linker in libbpf is that it is not only bpftool
that would be using it. Our libbpf Rust bindings
 is implementing its own BPF skeleton generation, and we'd like to use
linker APIs to support static linking when using libbpf-rs without
depending on bpftool. So having it in libbpf and not in bpftool is
good when you consider the wider ecosystem.

But again, let's just reflect for a second that we are talking about
the library that takes less than 300KB total. It would be also
interesting to experiment with LTO and its effect on final binaries
when statically linking against libbpf. I haven't tried yet, though.


> In the future the stack trace symbolization code can come
> into libbpftrace or be a part of its own lib.
> My upcoming loader program and signed prog generation logic
> can be part of libbpfskel.
