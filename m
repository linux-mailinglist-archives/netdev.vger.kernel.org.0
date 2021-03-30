Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 317AA34F222
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 22:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232298AbhC3U3S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 16:29:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbhC3U2q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 16:28:46 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE13AC061574;
        Tue, 30 Mar 2021 13:28:45 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id a143so18749758ybg.7;
        Tue, 30 Mar 2021 13:28:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6u4b37JcPUGpxcm1s19USgsArFlIb/CHDdAY+Dc44ns=;
        b=tXuFlXyViWkQWGrTetT3PpP6evMt7XBwM2SiHR6oMfy1EJvZHFMsUCBgm9BC2sgPPw
         VriwIL7UOffCz5gkiauZW/gJwRcmiHI2Ue62+2pnznhx7m+anhMtARMUb9PgFvQbVqWz
         qOaOCNzA72+pM2slI9WTA4igMudtHJvrbWs0VWXCT2/FbtFUfERx6exuoHorNp2HSEX1
         z9/NVo4CNbMLXkc2IesCSsonnbzYEvuoB2xEXSAjyFAQU2wqisXWsmY5BD172CsC41Ml
         YG7DqxwRJsi1/4qkUh93jYWRmPKNz/3MZ5XOGHnMbPmGO7OuPM/D9fVBv1dPYRsZsQOa
         HIrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6u4b37JcPUGpxcm1s19USgsArFlIb/CHDdAY+Dc44ns=;
        b=JSY4ACx4/5Qi5TFvQBDwY6lnQCE/dKSItNS1DOE+BCBqXUu3Fdc8JNm6bAjcDpGpI3
         haBsHBl1iFFQXjpXPNBr/NUrsZyh1AI1g6fpN7yX9FgC6G/i6IL9ak/SiwHqkf7nWWmE
         772wbwiqKwGean3s2GyNM4l4SaJk9yXfgTyrRuYtN3e2Daf9yH3qXukRH+MMcmlLRrYk
         3tUdVGrCn1ds5avtVbB7wcxWDnCO0fcaK2F1KojnkkFuMIqHtmoyLEZLquVciVqb68Kw
         SE+NbpkJq4ARUnfrVPyG6XoKDb0ALpW1aTdgk0XMabjEeq2DBaO3RmFbC2/bqoBPbbhn
         sKeQ==
X-Gm-Message-State: AOAM530rksJTWq6hJhvK4r4GgzEOhKtyRrILJq10qYOOK83oeHy8v0WW
        tKFk40YZ8bXlodhssU+VTCAcWalizm9NaO3CWW8uMSxJ
X-Google-Smtp-Source: ABdhPJwQ9ZJxRWPwKEOtjgT83/rZodHzd6yW+b0WqIo2DAX8/zY3k23INWUn5E5GXlBfiQHftUltgZj3H5y5uZ3JJp8=
X-Received: by 2002:a25:6d83:: with SMTP id i125mr2922ybc.27.1617136124883;
 Tue, 30 Mar 2021 13:28:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210325120020.236504-1-memxor@gmail.com> <20210325120020.236504-6-memxor@gmail.com>
 <20210327021534.pjfjctcdczj7facs@ast-mbp> <CAEf4Bzba_gdTvak_UHqi96-w6GLF5JQcpQRcG7zxnx=kY8Sd5w@mail.gmail.com>
 <20210329014044.fkmusoeaqs2hjiek@ast-mbp> <CAEf4BzZaWjVhfkr7vizir7PfbcsaN99yEwOoqKi32V4X17f0Ng@mail.gmail.com>
 <20210330032846.rg455fe2danojuus@ast-mbp>
In-Reply-To: <20210330032846.rg455fe2danojuus@ast-mbp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 30 Mar 2021 13:28:33 -0700
Message-ID: <CAEf4Bzb-YjQq=P2w3S1Np_jfqepUH2_t4MmomLg8PhA0=P6zZg@mail.gmail.com>
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

On Mon, Mar 29, 2021 at 8:28 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Sun, Mar 28, 2021 at 07:38:42PM -0700, Andrii Nakryiko wrote:
> >
> > See above. I don't know which hassle is libbpf for users today. You
> > were implying code size used for functionality users might not use
> > (e.g., linker). Libbpf is a very small library, <300KB. There are
> > users building tools for constrained embedded systems that use libbpf.
> > There are/were various problems mentioned, but the size of libbpf
> > wasn't yet one of them. We should certainly watch the code bloat, but
> > we are not yet at the point where library is too big for users to be
> > turned off.
>
> It's true that today sizeof(libbpf + libelf + libz) ~ 500k is not a concern.
> I'm worried what it will get to if we don't start splitting things up.

I'd say let's cross that bridge when we get there. We might never have
to even worry about that because libbpf won't grow in size that much.

>
> Why split libxdp into its own lib?

Because libxdp is establishing *a way* to perform XDP chaining and all
the setup around that. If it was the only right way to do this (and it
was clear it is the only way), then we might have declared that as a
solved problem worth providing with libbpf out of the box. I don't
think even Toke would claim that his approach is the only possible and
clearly superior to anything else. I think it's too nuanced and
complicated problem to have the solution.

> If tc attach is going to part of libbpf all things xdp should be
> part of libbpf as well.

I'm not TC expert, but it seems to be conceptually equivalent to basic
"attach to cgroup" or "attach XDP to interface" or "attach to
tracepoint" API, so seems in line with what libbpf is trying to
provide. If someone would want to construct higher-level concept on
top of that (e.g., some chaining of TC programs or whatnot), then it
would be out of scope for libbpf.

>
> But af_xdp folks are probably annoyed that they need to add -lelf an -lz
> though they're not using them. Just a tech debt that eventually need to be paid.

Those are dependencies of libbpf. Unless we want to re-implement ELF
handling code, we can't get rid of -lelf. I don't consider that a tech
debt at all. As for -lz, it's used for processing /proc/kconfig.gz
(for __kconfig externs). We can do dynamic libz.so loading only when
__kconfig externs are used, if you think that's a big problem. But
libz is such a widely available library, that no one complained so
far. Yes, I'm annoyed by having to specify -lelf and -lz as well, but
that's how C linking work, so I can't do much about that. Even more,
the order matters as well!

And just in the last email you were proposing to add 10 more
-l<libbpfsomething> and were wondering what's the downside, so I'm
confused about the direction of this discussion.

>
> > > I would take this opportunity to split libbpf into maintainable pieces:
> > > - libsysbpf - sys_bpf wrappers (pretty much tools/lib/bpf/bpf.c)
> > > - libbpfutil - hash, strset
> >
> > strset and hash are internal data structures, I never intended to
> > expose them through public APIs. I haven't investigated, but if we
> > have a separate shared library (libbpfutil), I imagine we won't be
> > able to hide those APIs, right?
>
> In the other thread you've proposed to copy paste hash implemenation
> into pahole. That's not ideal. If we had libbpfutil other projects
> could have used that without copy-paste.

I know it's not ideal. But I don't think libbpf should be in the
business of providing generic data structures with stable APIs either.
We are stuck with C, unfortunately, so we have to live with its
deficiencies.

>
> > But again, let's just reflect for a second that we are talking about
> > the library that takes less than 300KB total.
>
> that's today. Plus mandatory libelf and libz.
> I would like to have libsysbpf that doesn't depend on libelf/libz
> for folks that don't need it.

TBH, bpf.c is such a minimal shim on top of bpf() syscall, that
providing all of its implementation as a single .h wouldn't be too
horrible. Then whatever applications want those syscall wrappers would
just include bpf/bpf.h and have no need for the library at all.

> Also I'd like to see symbolizer to be included in "libbpf package".
> Currently it's the main component that libbcc offers, but libbpf doesn't.
> Say we don't split libbpf. Then symbolizer will bring some dwarf library
> (say libdwarves ~ 1Mbyte) and libiberty ~ 500k (for c++ demangle).
> Now we're looking at multi megabyte libbpf package.

Right, which is one of the reasons why it probably doesn't belong in
libbpf at all. Another is that it's not BPF-specific functionality at
all.

> I think the users would benefit from smaller building blocks.
> Splitting into 10 mini libs is overkill, of course,
> but some split is necessary.
> I agree that moving static linking into separate lib won't really
> affect .text size. The point is not to reduce text, but to establish
> a framework where such things are possible. Then symbolizer and
> anything fancier that would depend on other libs can be part
> of "libbpf package". I mean single rpm that contains all libbpf libs.
> Basic libsysbpf wouldn't need libelf/z.
> libbpfsymbolizer would need libdwarf, etc.
> Maybe some libbpfnet would depend on libnl or what not.

I'm against pro-active splitting just in case. I'd rather discuss
specific problems when we get to them. I think it's premature right
now to split libbpf.
