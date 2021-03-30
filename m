Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5400F34F508
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 01:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232981AbhC3X15 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 19:27:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232667AbhC3X1e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 19:27:34 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7AE1C061574;
        Tue, 30 Mar 2021 16:27:33 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id b14so26316732lfv.8;
        Tue, 30 Mar 2021 16:27:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7P9evhC2fefpJxi9njQ79qnjbEyr4RKoQ+V/DRcy07E=;
        b=gRjJO0F4OMhIooibcLON9pujbXZ59O41HRnUtt0/UijBRPCbr4+6oJ29xjGXXAdUj9
         L2f7Xsd8LRe47nEdTnNPDyigfE7dlaHQSSAmNySQLb1hM2kSZETM18mtX+Hp86o2/AfP
         QaNYPvg4VS6ySLEH5mGsvB3ljo+yoVdxMFSCaAJ8jNMxhO80vY0J0IsAhgoe2nzDVyvt
         v6Hk3bfXZwU3G/g+bflxpRrAvFUq51dRvDq1HmzrTNgmO1k8QXpQz7Blwkv7f86fjQFY
         bTLqkOz8KupSCvqdGHkpb/ELoZCbHrkgazfEmo9WC51hmOksLS5clZ1JYnwPgRT67QTc
         IwvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7P9evhC2fefpJxi9njQ79qnjbEyr4RKoQ+V/DRcy07E=;
        b=LZQ6zEDHRpaLAR498ZdIvd0rhPEqwxoEwd1Mqws6//vMkl+TmL05eTDFobszPBpOug
         48E9p5cr2q4JJDwlBpbd5JIr2GWpHQy6Rwqp+B9uhk7E+FHCaKEnbNvTCWL95i/zyPRW
         WjZKJ5BPBjRkxgkDLuQLoU0DvdmznkXey3Npc225rH6BXlA0Vu6JsQzFFj2GRV28QrPH
         Xvz3ZyzjaXjSWeuEcn43T6pWFW+Hs9yzwsYOhM8xZ5mGZ08bBo36cxEyxiX3+bijEZf+
         9ttUWdlY0joIAIDvubcak9FqUXGmvaofaDJz+XsxlY6aLLStQs3NnQzzSMVlqSH3S3Sz
         pB4Q==
X-Gm-Message-State: AOAM533bz+4qoBGlvsG1QpwgQnxbokVW+skZaQ3zslOpWYAGCy0/Pp6I
        2MZ9qW/EQRqB+BaUqIaAZgUB2ggzgmI0R81AbDw=
X-Google-Smtp-Source: ABdhPJy7WI6mOofSguzFXSqwA0HRRFR73oG+oJjIPMxPOjrVtnCfKqIVxMO+NYABkepI1iaQ7u6kJncWSGGwnFwpfbk=
X-Received: by 2002:ac2:5ec2:: with SMTP id d2mr375043lfq.214.1617146852070;
 Tue, 30 Mar 2021 16:27:32 -0700 (PDT)
MIME-Version: 1.0
References: <20210325120020.236504-1-memxor@gmail.com> <20210325120020.236504-6-memxor@gmail.com>
 <20210327021534.pjfjctcdczj7facs@ast-mbp> <CAEf4Bzba_gdTvak_UHqi96-w6GLF5JQcpQRcG7zxnx=kY8Sd5w@mail.gmail.com>
 <20210329014044.fkmusoeaqs2hjiek@ast-mbp> <CAEf4BzZaWjVhfkr7vizir7PfbcsaN99yEwOoqKi32V4X17f0Ng@mail.gmail.com>
 <20210330032846.rg455fe2danojuus@ast-mbp> <CAEf4Bzb-YjQq=P2w3S1Np_jfqepUH2_t4MmomLg8PhA0=P6zZg@mail.gmail.com>
In-Reply-To: <CAEf4Bzb-YjQq=P2w3S1Np_jfqepUH2_t4MmomLg8PhA0=P6zZg@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 30 Mar 2021 16:27:20 -0700
Message-ID: <CAADnVQKMBgFV7rYHWYQZW=i5fYkDYspgVOvhSWyNjAzY9CLD9A@mail.gmail.com>
Subject: Re: [PATCH bpf-next 5/5] libbpf: add selftests for TC-BPF API
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
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

On Tue, Mar 30, 2021 at 1:28 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
> >
> > In the other thread you've proposed to copy paste hash implemenation
> > into pahole. That's not ideal. If we had libbpfutil other projects
> > could have used that without copy-paste.
>
> I know it's not ideal. But I don't think libbpf should be in the
> business of providing generic data structures with stable APIs either.

There is a need for hash in pahole and it's already using libbpf.
Would be good to reuse the code.

> > that's today. Plus mandatory libelf and libz.
> > I would like to have libsysbpf that doesn't depend on libelf/libz
> > for folks that don't need it.
>
> TBH, bpf.c is such a minimal shim on top of bpf() syscall, that
> providing all of its implementation as a single .h wouldn't be too
> horrible. Then whatever applications want those syscall wrappers would
> just include bpf/bpf.h and have no need for the library at all.

1k line bpf.h. hmm. That's not going to be a conventional C header,
but it could work I guess.

> > Also I'd like to see symbolizer to be included in "libbpf package".
> > Currently it's the main component that libbcc offers, but libbpf doesn't.
> > Say we don't split libbpf. Then symbolizer will bring some dwarf library
> > (say libdwarves ~ 1Mbyte) and libiberty ~ 500k (for c++ demangle).
> > Now we're looking at multi megabyte libbpf package.
>
> Right, which is one of the reasons why it probably doesn't belong in
> libbpf at all. Another is that it's not BPF-specific functionality at
> all.

symbolizer, usdt, python and lua bindings is what made libbcc successful.
I think "libbpf package" should include everything that bpf tracing folks
might need.
Getting -l flags correct from a single package isn't a big deal
compared with the need to deal with different packages that
depend on each other.

> I'm against pro-active splitting just in case. I'd rather discuss
> specific problems when we get to them. I think it's premature right
> now to split libbpf.

Fine.
I'm mainly advocating to change the mental model to see
libbpf as a collection of tools and libraries and not just single libbpf.a
