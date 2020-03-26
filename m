Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DA0F194668
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 19:18:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727611AbgCZSST (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 14:18:19 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:42173 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726163AbgCZSSS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 14:18:18 -0400
Received: by mail-qt1-f196.google.com with SMTP id t9so6258044qto.9;
        Thu, 26 Mar 2020 11:18:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+3QZXAC1Z/TouJNkor9Bezltszy4CeetqEBKrDh0Iow=;
        b=qAAyOTFn9g768wR8RbSTSbkHuRq5Gj9t8QftUliLCg9lMZc8fxFZJhKm/ZO0fWo4vF
         DVujYZH85HPkmaomwXblEi2XPWrBqSCUqPQzyiTe9MZ62OM4ii4n727k01abBlcWspz0
         HKTQSvSnteDQSDfSyywJAgbBJUM80XjBqjRbXr0gFM5s7loxl6E6y9F0wiXMuSAFtMAS
         jx9fvZOVmeadnAYCIIm8EFxyKfywUBgzQiswPxgSYw1NDCb/ud9MFIYMpOwXJDX1ylZg
         O62/O7wttvcwu1RtZv/KAeFJqkgzdMbbJCp7dEpuMZ9M+fUK6rnLtSDFdqLnjzqvEwHi
         kDqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+3QZXAC1Z/TouJNkor9Bezltszy4CeetqEBKrDh0Iow=;
        b=bwNOhn35+Ea3GUpHG6mEl8BNnsVENyaUSb5VV3aEPeMGcdvZOFPjg6Ef+aQxYcTIlh
         OAxLMuyGaWrY2ypUmpXfiCgclRxcCP/jTrSutiVD2YSYMTi98Puonuq2axHLhqofpBz6
         SXLS3q+uRqyv0zpwdNMQU8baIc4J+4TT0ud0auW3+3JwF6HlzMqgiDKJ2ij+H7GC50Q4
         skNohm96m/U7YGPoynBAJu8ZHiDpvS0tyRBxzrv1xXpfbNTi27qn+AN1Vc/xK963AqCw
         5nd4Rr28UWgpMyIoSiVeDxK0yORztPOFbp3T9WQajdvHT4rBSqTiriWw4i7+5sXVBnj8
         YL3Q==
X-Gm-Message-State: ANhLgQ3/BAveaZbf/A+k93YvfD1AS53SVMQJtpCgkSzWQP5vAid/zkdl
        9e4wQBf8CgbwxOSFxkFFmMUUWkU9NQ/yKCSv0BI=
X-Google-Smtp-Source: ADFU+vtoF29Ad8uw7wQj1bHH0iALKdZB6tEnCeE7lQFObXmX9wQ8SZt0XQ0N7KMrcW2IK4ZWFsT4t6nETwrg2CQD1/c=
X-Received: by 2002:ac8:6918:: with SMTP id e24mr9620842qtr.141.1585246693937;
 Thu, 26 Mar 2020 11:18:13 -0700 (PDT)
MIME-Version: 1.0
References: <158462359206.164779.15902346296781033076.stgit@toke.dk>
 <158462359315.164779.13931660750493121404.stgit@toke.dk> <20200319155236.3d8537c5@kicinski-fedora-PC1C0HJN>
 <875zez76ph.fsf@toke.dk> <20200320103530.2853c573@kicinski-fedora-PC1C0HJN>
 <5e750bd4ebf8d_233f2ab4c81425c4ce@john-XPS-13-9370.notmuch>
 <CAEf4BzbWa8vdyLuzr_nxFM3BtT+hhzjCe9UQF8Y5cN+sVqa72g@mail.gmail.com>
 <87tv2f48lp.fsf@toke.dk> <CAEf4BzYutqP0yAy-KyToUNHM6Z-6C-XaEwK25pK123gejG0s9Q@mail.gmail.com>
 <87h7ye3mf3.fsf@toke.dk> <CAEf4BzY+JsmxCfjMVizLWYU05VS6DiwKE=e564Egu1jMba6fXQ@mail.gmail.com>
 <87tv2e10ly.fsf@toke.dk> <CAEf4BzY1bs5WRsvr5UbfqV9UKnwxmCUa9NQ6FWirT2uREaj7_g@mail.gmail.com>
 <87369wrcyv.fsf@toke.dk> <CAEf4BzZKvuPz8NZODYnn4DOcjPnj5caVeOHTP9_D3=wL0nVFfw@mail.gmail.com>
 <CACAyw9-FrwgBGjGT1CYrKJuyRJtwn0XUsifF_uR6LpRbcucN+A@mail.gmail.com>
In-Reply-To: <CACAyw9-FrwgBGjGT1CYrKJuyRJtwn0XUsifF_uR6LpRbcucN+A@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 26 Mar 2020 11:18:01 -0700
Message-ID: <CAEf4BzYqPnhvsFcKvN54_xX_kzL8b8jr8ifivDFjXBzmtheBYw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/4] xdp: Support specifying expected existing
 program when attaching XDP
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrey Ignatov <rdna@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 26, 2020 at 3:05 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
>
> On Thu, 26 Mar 2020 at 00:16, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> >
> [...]
> >
> > Those same folks have similar concern with XDP. In the world where
> > container management installs "root" XDP program which other user
> > applications can plug into (libxdp use case, right?), it's crucial to
> > ensure that this root XDP program is not accidentally overwritten by
> > some well-meaning, but not overly cautious developer experimenting in
> > his own container with XDP programs. This is where bpf_link ownership
> > plays a huge role. Tupperware agent (FB's container management agent)
> > would install root XDP program and will hold onto this bpf_link
> > without sharing it with other applications. That will guarantee that
> > the system will be stable and can't be compromised.
>
> Thanks for the extensive explanation Andrii.
>
> This is what I imagine you're referring to: Tupperware creates a new network
> namespace ns1 and a veth0<>veth1 pair, moves one of the veth devices
> (let's says veth1) into ns1 and runs an application in ns1. On which veth
> would the XDP program go?
>
> The way I understand it, veth1 would have XDP, and the application in ns1 would
> be prevented from attaching a new program? Maybe you can elaborate on this
> a little.
>

I'll people with first hand knowledge elaborate, if they are willing to share.

> Lorenz
>
> --
> Lorenz Bauer  |  Systems Engineer
> 6th Floor, County Hall/The Riverside Building, SE1 7PB, UK
>
> www.cloudflare.com
