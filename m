Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D01D275E08
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 18:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbgIWQzw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 12:55:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726572AbgIWQzw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 12:55:52 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47D6BC0613CE;
        Wed, 23 Sep 2020 09:55:52 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id h9so275374ybm.4;
        Wed, 23 Sep 2020 09:55:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sawJexAoDEM1MGGD6oqsAjFulSz+cyESCUcWECZZvIQ=;
        b=uwpOD/I3MNsfFT26p0xCKV7tO+Hu2q6Tc/8dLiWi9090Md5jQAjfLVkEdSIorWXUUw
         8wW8nWq7FzZ0mmzr+0K8/jmm4vxeOocJi0YTVwWH1IfZKlZSAZJVY58kIguXh7phlpf+
         ALi/N39GS7JUrHdcGvWpFo/vPrKmU4RhQnZwdf72slDwdPck9yKDynppf14i+RKIElSc
         8DHZzk3YtBpZ9HmyVNKmgN4W/RMhkGLMdRcT+l/8eiHLWKe9i06OryiCMmvgIm65cFSX
         XF5Q0sJM4PyFeBoHCRsibTm8XDV9Lly3oQ2X9lDkMQVAAEMNTRHyDWpziFLkHCstE5Tk
         AGRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sawJexAoDEM1MGGD6oqsAjFulSz+cyESCUcWECZZvIQ=;
        b=HCGug89T9mDy0HBsmhLNAZgcbu2d0Z0fmQbbOzKmYKYKk5yC6Mqvv4tZtThQbGzjOC
         xqOy9ioKD3VgvkFuprM7QTDXd0gwS2zUwnLCnD7lhUiIuSQdax8WryibeTS3QjUlgRrF
         nbOx+upJfnNFm5VFrBRi/lI2A/s6R/tYvtZMggFI8d4K24C+vAggIjjwvcg9N4Ux72WP
         Z9x3VTpBbsq9o5DpTWddKgWgIsUzZHhgiAHstap4cMEiCVdYkPy7AxbnZDfulImM58aK
         Lih2b+B1799wKmpmaAegX6TaX0Wtj0XQt7gz/wjKlTypcDNHME9rv5a0oKkZer+mQ/tX
         JK/Q==
X-Gm-Message-State: AOAM532xFHEt+BX02Ddg2Thw27cC5+EuBqUXQApvdJKQrW4+6V5ejJn8
        gBOWFjXKohaii3/cvAj4QqijbK9obC/KMejJdzE=
X-Google-Smtp-Source: ABdhPJzmdIaT3Ywba7xMVhal40Lmb9l5YH65YrAFaZCmRwJR1nIY7cw/jP2mwHCI7ZgcLD8VUl2QIv49g3TDPaDPNc4=
X-Received: by 2002:a25:9d06:: with SMTP id i6mr1294926ybp.510.1600880151567;
 Wed, 23 Sep 2020 09:55:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200916211010.3685-1-maciej.fijalkowski@intel.com>
 <CAADnVQLEYHZLeu-d4nV5Px6t+tVtYEgg8AfPE5-GwAS1uizc0w@mail.gmail.com>
 <CACAyw994v0BFpnGnboVVRCZt62+xjnWqdNDbSqqJHOD6C-cO0g@mail.gmail.com>
 <CAEf4Bzakz65x0-MGa0ZBF8F=PvT23Sm0rtNDDCo3jo4VMOXgeg@mail.gmail.com> <CACAyw9_WkndmJiwBZTn+P8fQa6OFfxmxH7uCxi0RTNOonbCzww@mail.gmail.com>
In-Reply-To: <CACAyw9_WkndmJiwBZTn+P8fQa6OFfxmxH7uCxi0RTNOonbCzww@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 23 Sep 2020 09:55:40 -0700
Message-ID: <CAEf4BzaO5-XSXSqavvXWN-BhfBXHU4wwz1qu2kqY+nRGj8G9qg@mail.gmail.com>
Subject: Re: [PATCH v8 bpf-next 0/7] bpf: tailcalls in BPF subprograms
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 23, 2020 at 9:43 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
>
> On Wed, 23 Sep 2020 at 17:24, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> >
> > On Wed, Sep 23, 2020 at 9:12 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
> > >
> > > On Fri, 18 Sep 2020 at 04:26, Alexei Starovoitov
> > > <alexei.starovoitov@gmail.com> wrote:
> > > [...]
> > > >
> > > > Lorenz,
> > > > if you can test it on cloudflare progs would be awesome.
> > >
> > > Our programs all bpf_tail_call from the topmost function, so no calls
> > > from subprogs. I stripped out our FORCE_INLINE flag, recompiled and
> > > ran our testsuite. cls_redirect.c (also in the kernel selftests) has a
> > > test failure that I currently can't explain, but I don't have the time
> > > to look at it in detail right now.
> > >
> >
> > I've already converted test_cls_redirect.c in selftest to have
> > __noinline variant. And it works fine. There are only 4 helper
> > functions that can't be converted to a sub-program (pkt_parse_ipv4,
> > pkt_parse_ipv6, and three buffer manipulation helpers) because they
> > are accepting a pointer to a stack from a calling function, which
> > won't work with subprograms. But all the other functions were
> > trivially converted to __noinline and keep working.
>
> Yeah, that is very possible. Keep in mind though that our internal
> version has since become more complex, and also has a more
> comprehensive test suite. I wasn't sounding the alarms, it's just an
> FYI that I appreciate the work that went into this and have taken a
> look, but that I need to do some more digging :)
>


> cls_redirect.c (also in the kernel selftests) has a test failure that

This sounded like there is a kernel selftest failure in cls_redirect.c
after you removed FORCE_INLINE flag. So I was curious where the new
failure is and whether it's in those 5 functions that just can't be
not-always_inlined.


> --
> Lorenz Bauer  |  Systems Engineer
> 6th Floor, County Hall/The Riverside Building, SE1 7PB, UK
>
> www.cloudflare.com
