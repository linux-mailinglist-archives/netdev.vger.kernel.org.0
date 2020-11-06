Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 555662A9ED7
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 22:07:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728519AbgKFVHN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 16:07:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727559AbgKFVHN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 16:07:13 -0500
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06BC0C0613CF;
        Fri,  6 Nov 2020 13:07:12 -0800 (PST)
Received: by mail-yb1-xb44.google.com with SMTP id c129so2316570yba.8;
        Fri, 06 Nov 2020 13:07:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bGfdFfDDww8R0ZXEW6u+L4tM5gZAoA/sM8hGXJ7g8Hg=;
        b=kKjglrt+IA3HPNNRt98Ahj1PczwGGpfQaZVPDq9VLd239+iJ5hTU2cp8iaoTSbyrDc
         sgqliHSHgJyDXdEFLg0lW0x7HtUEWSU0srusUzlmLKVxBNog0k/8iNdlWwdEK0Hpacsg
         rhkax3vT1Bx5tLTknodu9yuOo2DuRiRw9KbMBOwV9gU5ho9opA20CKq6uykVxQfQKcqX
         wbDiD55eQFDhW5FT3NFgQbHY6ND5jNjY8WGV9wRYHpBFN5YPAlrrSL5ywJ3wj9v+HSaB
         BAzBttyg1MKiRfjvSmDka1MWsOnquSv/Tr9WiSqUS4nKB6ZSZLz2+xDUD7mSBo6Nuhpd
         WB0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bGfdFfDDww8R0ZXEW6u+L4tM5gZAoA/sM8hGXJ7g8Hg=;
        b=Hija41XaaHg4+WogDPLCsF10YqPNROCFp0GoV5NoGHLZix9onaCKqD1uNk/oZnrKMW
         QclqZzWJhqoejmT878rVOAVtrVDp/q2pjCH3yCAvdvVy/3sZdfogrG8kD6i/s0XSbmGJ
         HOakFGuLaG5KbGHg1mBlEWUKQU2Ys6a0cm9o5xiZu27elC5Tg4f7lzjpvFuqmDsVdcnP
         mpZgp4jJwHvgLgyvtHmzhHU7FyLfOV6FPDVC5u5BhAf2K6Nozf72GQSM0VIDT/+fyJB6
         SA3+JUQufTmuI9ZSPB2qsf0UW7y8ABnTiKpjfudVXQ7nNzEXrngeILQMRJePOv2StVdp
         rjJg==
X-Gm-Message-State: AOAM532UWYxetkQuBbGhzOStQAqaHjrwy76RQxJ+tNtbsXUSgKh0qcqM
        WhKUG/zC4Mi3gCSIoqrvXOJNrsF+VKQsGwVUiCc=
X-Google-Smtp-Source: ABdhPJxoByrmxcet+009xNjFBNZ7abfKEKFxNwYY4AatTIOgrJXkFMrF9x0aRiMdL1hWYZa+P/naXCjJmoRvNYVU5Ro=
X-Received: by 2002:a25:cb10:: with SMTP id b16mr5629634ybg.459.1604696832197;
 Fri, 06 Nov 2020 13:07:12 -0800 (PST)
MIME-Version: 1.0
References: <20201028132529.3763875-1-haliu@redhat.com> <20201029151146.3810859-1-haliu@redhat.com>
 <646cdfd9-5d6a-730d-7b46-f2b13f9e9a41@gmail.com> <CAEf4BzYupkUqfgRx62uq3gk86dHTfB00ZtLS7eyW0kKzBGxmKQ@mail.gmail.com>
 <edf565cf-f75e-87a1-157b-39af6ea84f76@iogearbox.net> <3306d19c-346d-fcbc-bd48-f141db26a2aa@gmail.com>
 <CAADnVQ+EWmmjec08Y6JZGnan=H8=X60LVtwjtvjO5C6M-jcfpg@mail.gmail.com>
 <71af5d23-2303-d507-39b5-833dd6ea6a10@gmail.com> <20201103225554.pjyuuhdklj5idk3u@ast-mbp.dhcp.thefacebook.com>
 <20201104021730.GK2408@dhcp-12-153.nay.redhat.com> <20201104031145.nmtggnzomfee4fma@ast-mbp.dhcp.thefacebook.com>
 <2e8ba0be-51bf-9060-e1f7-2148fbaf0f1d@iogearbox.net> <ec50328d-61ab-71fb-f266-5e49e9dbf98e@gmail.com>
 <CAEf4BzbQz5ZqoB3TEtM-4e=Ndx9WCGN16Be8-JoK+mvUyAGC3w@mail.gmail.com> <20201106100007.10049857@redhat.com>
In-Reply-To: <20201106100007.10049857@redhat.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 6 Nov 2020 13:07:01 -0800
Message-ID: <CAEf4BzY4p-DMStpkpEVUNn5-_psjc-UivskdTEr5E8pyBieyTQ@mail.gmail.com>
Subject: Re: [PATCHv3 iproute2-next 0/5] iproute2: add libbpf support
To:     Jiri Benc <jbenc@redhat.com>
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
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 6, 2020 at 1:00 AM Jiri Benc <jbenc@redhat.com> wrote:
>
> On Thu, 5 Nov 2020 12:45:39 -0800, Andrii Nakryiko wrote:
> > That's not true. If you need new functionality like BTF, CO-RE,
> > function-by-function verification, etc., then yes, you have to update
> > kernel, compiler, libbpf, sometimes pahole. But if you have an BPF
> > application that doesn't use and need any of the newer features, it
> > will keep working just fine with the old kernel, old libbpf, and old
> > compiler.
>
> I'm fine with this.
>
> It doesn't work that well in practice, we've found ourselves chasing
> problems caused by llvm update (problems for older bpf programs, not
> new ones), problems on non-x86_64 caused by kernel updates, etc. It can
> be attributed to living on the edge and it should stabilize over time,
> hopefully. But it's still what the users are experiencing and it's
> probably what David is referring to. I expect it to smooth itself over
> time.

It's definitely going to be better over time, of course. I honestly
can't remember many cases where working applications stopped working
with newer kernels. I only remember cases when Clang changed the code
generation patterns. Also there were few too permissive checks fixed
in later kernels, which could break apps, if apps relied on buggy
logic. That did happen I think.

But anyway, I bet people just got a "something like that happened in
the past" flag in their head, but won't be able to recall specific
details anymore. My point is that we (BPF developers) don't take these
things lightly, so I'd just like to avoid the perception that we don't
care about this. Because we do, despite it sometimes being painful.
But there are layers upon layers of abstraction and it's not all
always under our control, so things might break.

>
> Add to that the fact that something that is in fact a new feature is
> perceived as a bug fix by some users. For example, a perfectly valid
> and simple C program, not using anything shiny but a basic simple loop,
> compiles just fine but is rejected by the kernel. A newer kernel and a
> newer compiler and a newer libbpf and a newer pahole will cause the
> same program to be accepted. Now, the user does not see that for this,
> a new load of BTF functionality had to be added and all those mentioned
> projects enhanced with substantial code. All they see is their simple
> hello world test program did not work and now it does.

Right. The unavoidable truth that anyone using BPF has to have at
least a surface-level idea about what BPF verifier is and what (and
sometimes how) it checks. It also gets better over time so much that
for some simpler application it will just work perfectly from the
first version of written code.

But let's also not lose perspective here. There aren't many examples
of practical static verification of program safety and termination,
right? It's tricky, and especially when making it also practical for a
wide variety of use cases.

>
> I'm not saying I have a solution nor I'm saying you should do something
> about it. Just trying to explain the perception.

Thanks for that, it's a good perspective. Hopefully my explanation
also makes sense ;)

>
>  Jiri
>
