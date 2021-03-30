Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 305D234DF55
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 05:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231241AbhC3D3m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 23:29:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230247AbhC3D3C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 23:29:02 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 028A6C0613DB;
        Mon, 29 Mar 2021 20:28:51 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id x26so11255164pfn.0;
        Mon, 29 Mar 2021 20:28:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NeGShYc368rl6ljTCiB3vDzY/XEQ6/G4qOdDPRk1LoE=;
        b=bFf6fi0kxldEIdu/O7RtxSVlFy6eaiIV2x2EbRWn3xlZmWfCMA7ZZ18URc353mjQgC
         hpfIYbz4MqVrIP7g7LoYmcxaQ8I6UxIyodZoMOIikBNCu4UEwozVPJDCh8TcmA4Nf6lg
         ORWJ2MxlkHhJLWLpchAtOgD9ANRba0UDFt969NzzTpOiVroZvP8TEN70oNHUlZYdGCfd
         Crq1mxnEb6nznSzGP/7S8EsNwhEKWq34j0oi3L78VT5jhkAz0hUjNLoXFnsRALgVOzTd
         WsZHzryU5Dgm1ZkD8Wt3VL2qBsXR/X8ksT+hlbAe7pnpREc6OSzAViWpvJ4bdBYQTKe3
         rzUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NeGShYc368rl6ljTCiB3vDzY/XEQ6/G4qOdDPRk1LoE=;
        b=ToJ3TtkTa0KXj9ssYlqqphWzwv/qmaNurVZXgHr7d0KQgeqSwxeXyqWDV1HAvsuIcg
         SPc7XvC0p7lRw5RsgCBqaOGI+oLAAhrVb5Fy1pieiOawMJVh6MdeXZUKOKqo1UkujfWS
         +L2I9O2558A+l88ix5d3r7y/42uZur3gWmTyHcUeQ35jhuRr6s4s645wiyjytxEfsLBC
         PgO6HY8N8uAHuhJe/PVzWnCB1VnNlMw6/sFHESwOXfQmWtojY4b1Ss2GyGU0VbYsk0Wm
         z/lM1vg66UgjPqv8OtL125a9uEszWUl8oOc8bG42Qx6UfmSvJSsqY4i2AEnXGqghE8XL
         Vg/w==
X-Gm-Message-State: AOAM532xZhrSA6+VGuLEWwMaum729hnkq/Sx4a7Pquefp3S3D7li/3Ts
        TNFKMDJ2dNiRgLecJ73ouSw=
X-Google-Smtp-Source: ABdhPJxQEeRUjdLNXMCL85Y6dwTbcDaCO3w8D+R2Rb4PuiftGi6xtc6j4l5+YjV5wYcFqoeBeqzCsw==
X-Received: by 2002:aa7:9a89:0:b029:1f6:26b9:bb73 with SMTP id w9-20020aa79a890000b02901f626b9bb73mr27968335pfi.78.1617074930450;
        Mon, 29 Mar 2021 20:28:50 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:19e9])
        by smtp.gmail.com with ESMTPSA id m16sm17174021pgj.26.2021.03.29.20.28.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Mar 2021 20:28:49 -0700 (PDT)
Date:   Mon, 29 Mar 2021 20:28:46 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        bpf <bpf@vger.kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
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
Subject: Re: [PATCH bpf-next 5/5] libbpf: add selftests for TC-BPF API
Message-ID: <20210330032846.rg455fe2danojuus@ast-mbp>
References: <20210325120020.236504-1-memxor@gmail.com>
 <20210325120020.236504-6-memxor@gmail.com>
 <20210327021534.pjfjctcdczj7facs@ast-mbp>
 <CAEf4Bzba_gdTvak_UHqi96-w6GLF5JQcpQRcG7zxnx=kY8Sd5w@mail.gmail.com>
 <20210329014044.fkmusoeaqs2hjiek@ast-mbp>
 <CAEf4BzZaWjVhfkr7vizir7PfbcsaN99yEwOoqKi32V4X17f0Ng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZaWjVhfkr7vizir7PfbcsaN99yEwOoqKi32V4X17f0Ng@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 28, 2021 at 07:38:42PM -0700, Andrii Nakryiko wrote:
> 
> See above. I don't know which hassle is libbpf for users today. You
> were implying code size used for functionality users might not use
> (e.g., linker). Libbpf is a very small library, <300KB. There are
> users building tools for constrained embedded systems that use libbpf.
> There are/were various problems mentioned, but the size of libbpf
> wasn't yet one of them. We should certainly watch the code bloat, but
> we are not yet at the point where library is too big for users to be
> turned off. 

It's true that today sizeof(libbpf + libelf + libz) ~ 500k is not a concern.
I'm worried what it will get to if we don't start splitting things up.

Why split libxdp into its own lib?
If tc attach is going to part of libbpf all things xdp should be
part of libbpf as well.

But af_xdp folks are probably annoyed that they need to add -lelf an -lz
though they're not using them. Just a tech debt that eventually need to be paid.

> > I would take this opportunity to split libbpf into maintainable pieces:
> > - libsysbpf - sys_bpf wrappers (pretty much tools/lib/bpf/bpf.c)
> > - libbpfutil - hash, strset
> 
> strset and hash are internal data structures, I never intended to
> expose them through public APIs. I haven't investigated, but if we
> have a separate shared library (libbpfutil), I imagine we won't be
> able to hide those APIs, right?

In the other thread you've proposed to copy paste hash implemenation
into pahole. That's not ideal. If we had libbpfutil other projects
could have used that without copy-paste.

> But again, let's just reflect for a second that we are talking about
> the library that takes less than 300KB total. 

that's today. Plus mandatory libelf and libz.
I would like to have libsysbpf that doesn't depend on libelf/libz
for folks that don't need it.
Also I'd like to see symbolizer to be included in "libbpf package".
Currently it's the main component that libbcc offers, but libbpf doesn't.
Say we don't split libbpf. Then symbolizer will bring some dwarf library
(say libdwarves ~ 1Mbyte) and libiberty ~ 500k (for c++ demangle).
Now we're looking at multi megabyte libbpf package.
I think the users would benefit from smaller building blocks.
Splitting into 10 mini libs is overkill, of course,
but some split is necessary.
I agree that moving static linking into separate lib won't really
affect .text size. The point is not to reduce text, but to establish
a framework where such things are possible. Then symbolizer and
anything fancier that would depend on other libs can be part
of "libbpf package". I mean single rpm that contains all libbpf libs.
Basic libsysbpf wouldn't need libelf/z.
libbpfsymbolizer would need libdwarf, etc.
Maybe some libbpfnet would depend on libnl or what not.
