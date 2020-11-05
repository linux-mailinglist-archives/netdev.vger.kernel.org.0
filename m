Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CFBF2A887D
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 22:01:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732238AbgKEVBx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 16:01:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726801AbgKEVBx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 16:01:53 -0500
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8D39C0613CF;
        Thu,  5 Nov 2020 13:01:51 -0800 (PST)
Received: by mail-yb1-xb41.google.com with SMTP id a12so2546107ybg.9;
        Thu, 05 Nov 2020 13:01:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uG3VHYj9R3VZ91Ugiucg6oGzGyGHvVwymHvdx7Sg8bs=;
        b=rhiC3g5B6f2Er8Zi59aQ1UQ0qrRJj6jg1TyG5ZB+YxGZbbBJ4D0O9rjF4JyWVOViVT
         tiQfMRkMRlhYVlcIXcqwqXOzoQaMUzQrk8D4vo781g6OW64yYt6aisgCb4hYjT3xbY+0
         lj9KFCHOLDt4x9lrvjOuv4cHemnxMFBp7Q3BPEYzs3ihCM5LYlyGHWXeazIOGZfmK9Dr
         edEFZqnaf6Krv+WmMDieM+PG7jMTiVZou6z1Dri3b4WSNKrjm2R6/iI+L9u0YBou1VO9
         tGTsmHY3hAJKfmHaUAI/Ntt7T1eDuIwh3GG7rOh8UBxDOKotObmm0MGuRlGj4yQhWF1g
         T64Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uG3VHYj9R3VZ91Ugiucg6oGzGyGHvVwymHvdx7Sg8bs=;
        b=V3WLLT7q/om05JCJ+9O2g/IAaFmYXZ/luFn1Ej7BRzKDzbY5C8k02qpyoDBRMFfIg1
         7FiZsXwSDPn0zDKIjMVn5yeSDUgCVsql+wGFyAqqFd/DFh50Dr1CfZWz99vqESVzyAHe
         7J5x3i7sDzmhr9xWbQJ9FUKlq6c7pcWGGJqsSBfXHCvVQTWofHX5/tti7/Es9Id76Tck
         0nUOTa9s442JPNt9sfhoUOv7QjzdsHgNcSG9lH2UOw4GSkJxCQRyv5LF/uxtoCkI0ltY
         rmWNNTNp26Ann3+9ENM/GrLfYMZwLYURPw0rl2PO7JYLLoRdkfDRHuctfYalfJAgJ2H7
         0grw==
X-Gm-Message-State: AOAM530LKFU/vw12/F0Wi5dWJe8E5q4hzWnmLbRkZi9QzfXOb57j6C/E
        ZgqtvF0J/T+M//9XDdK5SJ66zpJeT5M7VA78M0U=
X-Google-Smtp-Source: ABdhPJxZehXK+pVGe24BwsQEqSt2UIlSAfv6wJ2sAXn0fFBnMIUV+lgTRc2vNQGhdLAFRgga2FTNTaTmlkjwHZNPBs4=
X-Received: by 2002:a25:3443:: with SMTP id b64mr5935020yba.510.1604610110932;
 Thu, 05 Nov 2020 13:01:50 -0800 (PST)
MIME-Version: 1.0
References: <20201028132529.3763875-1-haliu@redhat.com> <20201029151146.3810859-1-haliu@redhat.com>
 <646cdfd9-5d6a-730d-7b46-f2b13f9e9a41@gmail.com> <CAEf4BzYupkUqfgRx62uq3gk86dHTfB00ZtLS7eyW0kKzBGxmKQ@mail.gmail.com>
 <edf565cf-f75e-87a1-157b-39af6ea84f76@iogearbox.net> <3306d19c-346d-fcbc-bd48-f141db26a2aa@gmail.com>
 <CAADnVQ+EWmmjec08Y6JZGnan=H8=X60LVtwjtvjO5C6M-jcfpg@mail.gmail.com>
 <71af5d23-2303-d507-39b5-833dd6ea6a10@gmail.com> <20201103225554.pjyuuhdklj5idk3u@ast-mbp.dhcp.thefacebook.com>
 <20201104021730.GK2408@dhcp-12-153.nay.redhat.com> <20201104031145.nmtggnzomfee4fma@ast-mbp.dhcp.thefacebook.com>
 <2e8ba0be-51bf-9060-e1f7-2148fbaf0f1d@iogearbox.net> <ec50328d-61ab-71fb-f266-5e49e9dbf98e@gmail.com>
 <1118ef27-3302-d077-021a-43aa8d8f3ebb@mojatatu.com>
In-Reply-To: <1118ef27-3302-d077-021a-43aa8d8f3ebb@mojatatu.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 5 Nov 2020 13:01:39 -0800
Message-ID: <CAEf4Bzag9XCRKCV_vkFU3TyCza3W+NJzm=Vh=NPkSNBY+Qke_A@mail.gmail.com>
Subject: Re: [PATCHv3 iproute2-next 0/5] iproute2: add libbpf support
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     David Ahern <dsahern@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Hangbin Liu <haliu@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Jiri Benc <jbenc@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 5, 2020 at 6:05 AM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>
> On 2020-11-04 10:19 p.m., David Ahern wrote:
>
> [..]
> >
> > User experience keeps getting brought up, but I also keep reading the
> > stance that BPF users can not expect a consistent experience unless they
> > are constantly chasing latest greatest versions of *ALL* S/W related to
> > BPF. That is not a realistic expectation for users. Distributions exist
> > for a reason. They solve real packaging problems.
> >
> > As libbpf and bpf in general reach a broader audience, the requirements
> > to use, deploy and even tryout BPF features needs to be more user
> > friendly and that starts with maintainers of the BPF code and how they
> > approach extensions and features. Telling libbpf consumers to make
> > libbpf a submodule of their project and update the reference point every
> > time a new release comes out is not user friendly.
> >
> > Similarly, it is not realistic or user friendly to *require* general
> > Linux users to constantly chase latest versions of llvm, clang, dwarves,
> > bcc, bpftool, libbpf, (I am sure I am missing more), and, by extension
> > of what you want here, iproute2 just to upgrade their production kernel
> > to say v5.10, the next LTS, or to see what relevant new ebpf features
> > exists in the new kernel. As a specific example BTF extensions are added
> > in a way that is all or nothing. Meaning, you want to compile kernel
> > version X with CONFIG_DEBUG_INFO_BTF enabled, update your toolchain.
> > Sure, you are using the latest LTS of $distro, and it worked fine with
> > kernel version X-1 last week, but now compile fails completely unless
> > the pahole version is updated. Horrible user experience. Again, just an
> > example and one I brought up in July. I am sure there more.
> >
>
>
> 2cents feedback from a dabbler in ebpf on user experience:
>
> What David described above *has held me back*.
> Over time it seems things have gotten better with libbpf
> (although a few times i find myself copying includes from the
> latest iproute into libbpf). I ended up just doing static links.
> The idea of upgrading clang/llvm every 2 months i revisit ebpf is
> the most painful. At times code that used to compile just fine
> earlier doesnt anymore. There's a minor issue of requiring i install

Do you have a specific example of something that stopped compiling?
I'm not saying that can't happen, but we definitely try hard to avoid
any regressions. I might be forgetting something, but I don't recall
the situation when something would stop compiling just due to newer
libbpf.

> kernel headers every time i want to run something in samples, etc
> but i am probably lacking knowledge on how to ease the pain in that
> regard.
>
> I find the loader and associated tooling in iproute2/tc to be quiet
> stable (not shiny but works everytime).
> And for that reason i often find myself sticking to just tc instead
> of toying with other areas.

That's the part that others on this thread mentioned is bit rotting?
Doesn't seem like everyone is happy about that, though. Stopping any
development definitely makes things stable by definition. BPF and
libbpf try to be stable while not stagnating, which is harder than
just stopping any development, unfortunately.

> Slight tangent:
> One thing that would help libbpf adoption is to include an examples/
> directory. Put a bunch of sample apps for tc, probes, xdp etc.
> And have them compile outside of the kernel. Maybe useful Makefiles
> that people can cutnpaste from. Every time you add a new feature
> put some sample code in the examples.

That's what tools/testing/selftests/bpf in kernel source are for. It's
not the greatest showcase of examples, but all the new features have a
test demonstrating its usage. I do agree about having simple Makefiles
and we do have that at [0]. I'm also about to do another sample repo
with a lot of things pre-setup, for tinkering and using that as a
bootstrap for BPF development with libbpf.

  [0] https://github.com/iovisor/bcc/tree/master/libbpf-tools

>
> cheers,
> jamal
