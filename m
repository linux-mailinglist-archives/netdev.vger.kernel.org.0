Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 312001C6586
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 03:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729828AbgEFBaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 21:30:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728609AbgEFBaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 21:30:16 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6719C061A0F;
        Tue,  5 May 2020 18:30:15 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id a9so33202lfb.8;
        Tue, 05 May 2020 18:30:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hj8S2KHc69NEk+qWOC+GYPiuiIXNaHZxXAt5jsTgngs=;
        b=boz+EkaJPI0E+uIIM/cgtwmsZHD2KWQ0FcU/nHrOzVNs8z7crDVVKsV/T54WwnmoUv
         DGkurWyY15z755Gn9iv1iTKT7zsZVabuZ9yTGj6+CqPVmfaqgwtYjDTsHLJBRLFsaoAR
         FM11WyBAsYntG6dRmt2nKWtemS+rz3V1IVNe5QXdvYsaB6ytgHqHxSbHIggtAaal6Lp1
         VoftDaoGrgpnlAmYo9qsPqn6lqD0D6uiVv6BWe4up5h59/aaBZKt0cDUsBFNlJ6rSEHL
         RID9k4dIP7UeboDWYBEKJxUf6z0cZ/fDf8Ak2Omprer9vAf7I7G0x1iTxH0/3f0eXAdy
         x52A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hj8S2KHc69NEk+qWOC+GYPiuiIXNaHZxXAt5jsTgngs=;
        b=OUEs0w/qo0+17cAnVeCMl4eeixjSBLfrtKsbGun+SJfPSOMyP8/xo71jWwiCSvCFAI
         Sv6nP5vJFUCDlcyF/KNsSCUpWKJ5vrBlzyp/lnDJ3GNI9d8bjLr2dBJgMb/MD+8Dsd27
         UIueA+Q5sXSCazu5sGriztJPG0sq7RCz4rrZ549BrEmAv/lrNDE8PLBDIWsB2eOJEozC
         nVfsI92x96TIK2YLcBolyZ/XDn9DF8037LbUkKUBpo2OdybjlLcbN+09D7+lktGccJCo
         KStnv5mI6A+IQnkhNs2IXCOgkr4+8TZOVRWjDuGKQquSpSNQ9JaqJTgvSy1Xl9lCnL/6
         YGIQ==
X-Gm-Message-State: AGi0Pua228Vs03kDEXQDKikZ0bHG3sWL5igLTKeq9jTXMVBmXNByuvGn
        I0P8CDxSwlR8bZMcuCmh2R9hwYHQbECGmAkmA8k=
X-Google-Smtp-Source: APiQypJDW7fXK4fE5RX+0kcweXn4NyPOCByK1LFeriowpCSlBLQpvpsOm3HQ1J8trVBg35MqlD5CeDZ3YrCVmRLnc2I=
X-Received: by 2002:ac2:442f:: with SMTP id w15mr3241305lfl.73.1588728614209;
 Tue, 05 May 2020 18:30:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200424185556.7358-1-lmb@cloudflare.com> <20200424185556.7358-2-lmb@cloudflare.com>
 <20200426173324.5zg7isugereb5ert@ast-mbp.dhcp.thefacebook.com>
 <CACAyw98nK_Vkstp-vEqNwKXtoCRnTOPr7Eh+ziH56tJGbnPsig@mail.gmail.com>
 <185417b8-0d50-f8a3-7a09-949066579732@iogearbox.net> <20200504234827.6mrogryxk73jc6x2@ast-mbp.dhcp.thefacebook.com>
 <a5829cb4-3759-6cd8-c9de-62e9813f00d6@iogearbox.net>
In-Reply-To: <a5829cb4-3759-6cd8-c9de-62e9813f00d6@iogearbox.net>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 5 May 2020 18:30:02 -0700
Message-ID: <CAADnVQKjZoaPgWWTKrADLv73VuYaC+WsdgNdo-h_mW1FW7VmFw@mail.gmail.com>
Subject: Re: [PATCH 1/1] selftests/bpf: add cls_redirect classifier
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Lorenz Bauer <lmb@cloudflare.com>, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Theo Julienne <theojulienne@github.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Clang-Built-Linux ML <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 5, 2020 at 6:37 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 5/5/20 1:48 AM, Alexei Starovoitov wrote:
> > On Sat, May 02, 2020 at 01:48:51AM +0200, Daniel Borkmann wrote:
> >> On 4/27/20 11:45 AM, Lorenz Bauer wrote:
> >>> On Sun, 26 Apr 2020 at 18:33, Alexei Starovoitov
> >>> <alexei.starovoitov@gmail.com> wrote:
> >> [...]
> >>>>> +/* Linux packet pointers are either aligned to NET_IP_ALIGN (aka 2 bytes),
> >>>>> + * or not aligned if the arch supports efficient unaligned access.
> >>>>> + *
> >>>>> + * Since the verifier ensures that eBPF packet accesses follow these rules,
> >>>>> + * we can tell LLVM to emit code as if we always had a larger alignment.
> >>>>> + * It will yell at us if we end up on a platform where this is not valid.
> >>>>> + */
> >>>>> +typedef uint8_t *net_ptr __attribute__((align_value(8)));
> >>>>
> >>>> Wow. I didn't know about this attribute.
> >>>> I wonder whether it can help Daniel's memcpy hack.
> >>>
> >>> Yes, I think so.
> >>
> >> Just for some more context [0]. I think the problem is a bit more complex in
> >> general. Generally, _any_ kind of pointer to some data (except for the stack)
> >> is currently treated as byte-by-byte copy from __builtin_memcpy() and other
> >> similarly available __builtin_*() helpers on BPF backend since the backend
> >> cannot make any assumptions about the data's alignment and whether unaligned
> >> access from the underlying arch is ok & efficient (the latter the verifier
> >> does judge for us however). So it's definitely not just limited to xdp->data.
> >> There is also the issue that while access to any non-stack data can be
> >> unaligned, access to the stack however cannot. I've discussed a while back
> >> with Yonghong about potential solutions. One would be to add a small patch
> >> to the BPF backend to enable __builtin_*() helpers to allow for unaligned
> >> access which could then be opt-ed in e.g. via -mattr from llc for the case
> >> when we know that the compiled program only runs on archs with efficient
> >> unaligned access anyway. However, this still potentially breaks with the BPF
> >> stack for the case when objects are, for example, larger than size 8 but with
> >> a natural alignment smaller than 8 where __builtin_memcpy() would then decide
> >> to emit dw-typed load/stores. But for these cases could then be annotated via
> >> __aligned(8) on stack. So this is basically what we do right now as a generic
> >> workaround in Cilium [0], meaning, our own memcpy/memset with optimal number
> >> of instructions and __aligned(8) where needed; most of the time this __aligned(8)
> >> is not needed, so it's really just a few places, and we also have a cocci
> >> scripts to catch these during development if needed. Anyway, real thing would
> >> be to allow the BPF stack for unaligned access as well and then BPF backend
> >> could nicely solve this in a native way w/o any workarounds, but that is tbd.
> >>
> >> Thanks,
> >> Daniel
> >>
> >>    [0] https://github.com/cilium/cilium/blob/master/bpf/include/bpf/builtins.h
> >
> > Daniel,
> > do you mind adding such memcpy to libbpf ?
>
> We could do that, yeah. Is there a way from BPF C code when compiling with clang to
> get to the actual underlying architecture (x86-64, arm64, ppc, etc) when compiling
> with `-target bpf` so that we can always fall back to __builtin_*() for those where
> verifier would bail out on unaligned access? Keep in mind the __bpf_memcpy() and
> __bpf_memzero() from [0] are fully compile time resolved and I did the implementation
> for sizes of 1,2,4,..., 96 where the latter is in two' increments, so no odd buffer
> sizes as we don't need them in our code. If someone does hit such an odd case, then
> I'm currently throwing a compilation error via __throw_build_bug(). Latter is a nice
> way to be able to guarantee that a switch/case or if condition is never hit during
> compilation time. It resolves to __builtin_trap() which is not implemented in the
> BPF backend and therefore yells to the developer when built into the code (this has
> a nice property which wouldn't work with BUILD_BUG_ON() for example). Anyway, what
> I'm saying is that either we'd need the full thing with all sizes or document that
> unsupported size would be hit when __builtin_trap() assertion is seen.

I think it would be fine to simply document it.
Most structures have at least one 'int' and don't have 'packed',
so they are multiple of 4 typically. Multiple of 2 limitation should be
acceptable for most cases.
