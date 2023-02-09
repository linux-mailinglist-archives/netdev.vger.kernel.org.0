Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF04691275
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 22:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbjBIVNF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 16:13:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbjBIVND (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 16:13:03 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C6B35A937
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 13:12:57 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id x10so2443848pgx.3
        for <netdev@vger.kernel.org>; Thu, 09 Feb 2023 13:12:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=AqSTz/L2alBL8Zj/w06cTvAyC9XT2IgrPGAqFADFHi0=;
        b=KdS+mAi5gsRaVPGoK617ANR5OX6QG8JRM3peX4uIGjprw1lEV7xVqfHIsOrhTS3Sn7
         0JXXR72Jw3pkEk0FkcSWenr1w/jcYTbv29RMz55f4gnS4ENmATbGo7QXBczxBPJNb9x0
         mBTc5Epwdz2sAdll0YC93N+M6LZmJgURKGETU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AqSTz/L2alBL8Zj/w06cTvAyC9XT2IgrPGAqFADFHi0=;
        b=M1njm+m47RU2x87EB3DUwVFoRdvoKMcXE8Rj42Wfv/esPUVB753caRvUJoT7voyH/c
         X/YBOHAqhlRjoLfipOYCelC6ntmJA7f08k22Nf6kOfrvTfrYcdz+X5n85Rxeta6HwFpZ
         czIZ5c5SK31f00l/K9frQvKtCTh1ADW7GxAGkvyDXEPzRX3bsVbM8iWLVfaNESm1YX+J
         oAXTvwO/xDvuQgz4khVnKiRtRmrVcqeXtDMUVNb7LjO7SjuvICvTEPb1puAxIewKD+tl
         dspJa1VCo7LrDN8pjIzwlGWCA6vIC2slOnP8wrtM6Wx3AS3ugQuhkbrKpJ4ctVhN7zlF
         cMZg==
X-Gm-Message-State: AO0yUKUl8Bnl9T5voouCsazn/9BGFo4Op7K5s23un9hLHC9N11opcPw3
        OyC6RB0Jo+hQgRK9y6BicB9wHA==
X-Google-Smtp-Source: AK7set/jpeO1CmdqClAOg42qN1DNmiq4fZbFjASTnEdfDr6YLfdRrL2Nv+VwLEIAjZL9+aVp7XiVvg==
X-Received: by 2002:aa7:96b0:0:b0:5a8:65dd:2be with SMTP id g16-20020aa796b0000000b005a865dd02bemr1797059pfk.1.1675977176664;
        Thu, 09 Feb 2023 13:12:56 -0800 (PST)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id z9-20020aa791c9000000b0059416691b64sm1961431pfa.19.2023.02.09.13.12.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 13:12:56 -0800 (PST)
Message-ID: <63e561d8.a70a0220.250aa.3eb9@mx.google.com>
X-Google-Original-Message-ID: <202302091310.@keescook>
Date:   Thu, 9 Feb 2023 13:12:55 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Jiri Olsa <jolsa@kernel.org>, Mykola Lysenko <mykolal@fb.com>,
        Shuah Khan <shuah@kernel.org>,
        Haowen Bai <baihaowen@meizu.com>, bpf <bpf@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        clang-built-linux <llvm@lists.linux.dev>,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH] bpf: Deprecate "data" member of bpf_lpm_trie_key
References: <20230209192337.never.690-kees@kernel.org>
 <CAEf4BzZXrf48wsTP=2H2gkX6T+MM0B45o0WNswi50DQ_B-WG4Q@mail.gmail.com>
 <63e5521a.170a0220.297d7.3a80@mx.google.com>
 <CAADnVQKsB2n0=hShYpYnTr5yFYRt5MX2QMWo3V9SB9JrM6GhTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQKsB2n0=hShYpYnTr5yFYRt5MX2QMWo3V9SB9JrM6GhTg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 09, 2023 at 12:50:28PM -0800, Alexei Starovoitov wrote:
> On Thu, Feb 9, 2023 at 12:05 PM Kees Cook <keescook@chromium.org> wrote:
> >
> > On Thu, Feb 09, 2023 at 11:52:10AM -0800, Andrii Nakryiko wrote:
> > > Do we need to add a new type to UAPI at all here? We can make this new
> > > struct internal to kernel code (e.g. struct bpf_lpm_trie_key_kern) and
> > > point out that it should match the layout of struct bpf_lpm_trie_key.
> > > User-space can decide whether to use bpf_lpm_trie_key as-is, or if
> > > just to ensure their custom struct has the same layout (I see some
> > > internal users at Meta do just this, just make sure that they have
> > > __u32 prefixlen as first member).
> >
> > The uses outside the kernel seemed numerous enough to justify a new UAPI
> > struct (samples, selftests, etc). It also paves a single way forward
> > when the userspace projects start using modern compiler options (e.g.
> > systemd is usually pretty quick to adopt new features).
> 
> I don't understand how the new uapi struct bpf_lpm_trie_key_u8 helps.
> cilium progs and progs/map_ptr_kern.c
> cannot do s/bpf_lpm_trie_key/bpf_lpm_trie_key_u8/.
> They will fail to build, so they're stuck with bpf_lpm_trie_key.

Right -- I'm proposing not changing bpf_lpm_trie_key. I'm proposing
_adding_ bpf_lpm_trie_key_u8 for new users who will be using modern
compiler options (i.e. where "data[0]" is nonsense).

> Can we do just
> struct bpf_lpm_trie_key_kern {
>   __u32   prefixlen;
>   __u8    data[];
> };
> and use it in the kernel?

Yeah, I can do that if that's preferred, but it leaves userspace hanging
when they eventually trip over this in their code when they enable
-fstrict-flex-arrays=3 too.

> What is the disadvantage?

It seemed better to give a working example of how to migrate this code.

Regardless, I can just make this specific to the kernel code if that's
what's wanted.

-- 
Kees Cook
