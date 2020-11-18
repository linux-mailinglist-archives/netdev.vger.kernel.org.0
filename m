Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8A052B7470
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 03:58:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727262AbgKRC5y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 21:57:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726298AbgKRC5x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 21:57:53 -0500
Received: from mail-oo1-xc43.google.com (mail-oo1-xc43.google.com [IPv6:2607:f8b0:4864:20::c43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 750ABC0613D4;
        Tue, 17 Nov 2020 18:57:53 -0800 (PST)
Received: by mail-oo1-xc43.google.com with SMTP id c25so49641ooe.13;
        Tue, 17 Nov 2020 18:57:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PRy8v2fDNXdncY+CvqHKMoW0jx0iwPASvgOwfw3H6WE=;
        b=DoolhP6gZWQXyd56o6ZtAv0rSnjdzpne1xakbkx4o3mSg9rwoXv2dYun0Q0e6gBzBS
         8PTSLTyDXVX/NJNSObjfN8VqcBJ+IRKo/ffBprME0yH05jSwwiogBimPaFjXZFUeSfto
         F4O1b0C/fXGTHSoQAsxEpDsa+3qWwJl1m6BItZ5b3pJOoMDKtAclLmTUTyoUH/k56L0P
         Rc6K5K7yumG/4vIqZAUaHhOBnnQRAfgG3sGC3i1Nz2kx+TixBrKinvUZG55g0M1+dLXb
         Y7mmIwNSOOy8VFOogKRfWwcmzyZ7xfPhQSG1uAeGEL14m8qqg0d4Uo6X+NvSZRjxnX/H
         TixA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PRy8v2fDNXdncY+CvqHKMoW0jx0iwPASvgOwfw3H6WE=;
        b=DC8AW4AVS7zWEVeDvbNwhLFs/hYd5WDWXDuzqCB066+a3FTouzH8QIw3K/pM+BiXlW
         3v27pzHCQ9+WmAGl3bn0WglogerU5r0Qq90S3fABwXgz4ES+pqw/9gfhpDfQ+Xch43FG
         8Q/zvZSnbiwW8Jcb56QCitNwR5DvOZglq3hUrgKyV42zcKv8cwWZGsJACiQIdxFzRwNI
         Q6CEImbO05vjE6OIRRZ96gTiPSniIJNd8Y/zaG6so28iiHI5RbcynvM5n1DG5he4YRI7
         n70uEFh1idCgvUg7lpie6/xRYK7Oiwwhpue37DpNQ0SunJoLCOcZLrgnQ8ZpSD69GY1g
         d6Mg==
X-Gm-Message-State: AOAM533jU3+/R6AOieioK9fsmW6lCUmkSjTzydFFHqelhNOhDgRi4ugA
        01rNpbkhB0paGKl4RtWU5llldZm52LbbrFFmQA==
X-Google-Smtp-Source: ABdhPJzNFaZYyl/DLKNUHPv+jYBR1FeV47W/lLMEhbEA+pbPycF5/40tfGt8DnXF/YsL+gVtq7mDKgBS5gRmVIIZaZs=
X-Received: by 2002:a4a:4085:: with SMTP id n127mr5148530ooa.80.1605668272877;
 Tue, 17 Nov 2020 18:57:52 -0800 (PST)
MIME-Version: 1.0
References: <20201117145644.1166255-1-danieltimlee@gmail.com>
 <20201117145644.1166255-10-danieltimlee@gmail.com> <CAEf4BzaOMOhX14zXGzkPmLxCHLj+e4a98d9YtT4RdJNNtrPnOQ@mail.gmail.com>
In-Reply-To: <CAEf4BzaOMOhX14zXGzkPmLxCHLj+e4a98d9YtT4RdJNNtrPnOQ@mail.gmail.com>
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
Date:   Wed, 18 Nov 2020 11:57:36 +0900
Message-ID: <CAEKGpzjytK7yot=Z0FCkZWydLBJis-i60vRHqZTEF1UWYnGBOw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 9/9] samples: bpf: remove bpf_load loader completely
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, brakmo <brakmo@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        David Ahern <dsa@cumulusnetworks.com>,
        Yonghong Song <yhs@fb.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Ira Weiny <ira.weiny@intel.com>, Thomas Graf <tgraf@suug.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Xdp <xdp-newbies@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 18, 2020 at 11:49 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Tue, Nov 17, 2020 at 6:58 AM Daniel T. Lee <danieltimlee@gmail.com> wrote:
> >
> > Numerous refactoring that rewrites BPF programs written with bpf_load
> > to use the libbpf loader was finally completed, resulting in BPF
> > programs using bpf_load within the kernel being completely no longer
> > present.
> >
> > This commit removes bpf_load, an outdated bpf loader that is difficult
> > to keep up with the latest kernel BPF and causes confusion.
> >
> > Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> > ---
>
> RIP, bpf_load().
>
> Probably makes more sense to combine this patch with the previous patch.
>
> Acked-by: Andrii Nakryiko <andrii@kernel.org>

Will merge and send the next version of patch!

Thanks for your time and effort for the review.

-- 
Best,
Daniel T. Lee
