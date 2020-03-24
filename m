Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF139191CA7
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 23:31:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728367AbgCXWbK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 18:31:10 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:46771 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728227AbgCXWbK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 18:31:10 -0400
Received: by mail-qk1-f196.google.com with SMTP id u4so346608qkj.13;
        Tue, 24 Mar 2020 15:31:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ZVBNkmQ6KNSiQ9imF34wczZJOjW1q9SSGP6SBaBKNY4=;
        b=R1Om5kXeha14u6MpD7gSO8OM7ArVvPGInc7J6L8AyaCrZrWFLKoMjLaEic/E80CeZ3
         ZUapHQXdHT6vgcuNDz321Y2SQeJlpGdk5+pSOG3kitHzyGervHVBvBzxck6dApmQ+W4M
         N6e7ZMeoGHZss02j80DFwWEzUo93m/N+6Qul1r0xy2tOQGl7RM/XEZu7k0HdgTdym1md
         mfLZZu/viVB9/JX+qtS1Ad/WmEne7wUk1lF6rdR7wmK0vu1t5v18eOKIB8I4QQ0m1lCp
         9oKwSJhd2h6+AQGTsnHDvvbsd48EmBzfvsah4fwY8CsHiNB6TTDPmLHIUxwrqRJzepWj
         63Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ZVBNkmQ6KNSiQ9imF34wczZJOjW1q9SSGP6SBaBKNY4=;
        b=E9pwPjJEqicBXPvqQhp/WErWvXoGKVISMBUTGXoXMDvDTyc58XqwpWTLBbhnUlrStM
         njlm0+83n4/bxIOHCijzwTpWTJ4HJIjR9TTyPGPiJIIkM3JzQ8dtQAZUqqgzkhgvfS8y
         GC/Gu5YMeM1/87TVAWWqCBvfrQuGwFD2Y6nRqORNVTQNHnB62i18KxMX4ApmAf7rmLBP
         p3crY1DdT+Q8TZ9a+kISRR8iBvvIYiplDcyKmtUJJYJaEgmBI+tyMtimvy1upw+s0wSB
         ex0G/WXQzQv+FdEpqhNz8FF0sAi3O0SS4jxBpNHJ4skmasRkyqSGdoChvcU1wLrmJy8f
         M0dg==
X-Gm-Message-State: ANhLgQ3h0KZt4IMIn7EhbqfYEo4T3l3+fmEa7R3PQstZ2akntPm+ZIRh
        gjaPAzCZ8SKRYjXvjbNm516iISaHPDdx2BUcUTw=
X-Google-Smtp-Source: ADFU+vt7jbWpWic5LSgwTwL2UxAfd9oqqaxeMFJfScwEx/yIjufmLZBcmPAg+yTYu/z2iu8OIgsF6jcyZbv2XcvL+Bg=
X-Received: by 2002:a37:e40d:: with SMTP id y13mr152356qkf.39.1585089069087;
 Tue, 24 Mar 2020 15:31:09 -0700 (PDT)
MIME-Version: 1.0
References: <158462359206.164779.15902346296781033076.stgit@toke.dk>
 <158462359315.164779.13931660750493121404.stgit@toke.dk> <20200319155236.3d8537c5@kicinski-fedora-PC1C0HJN>
 <875zez76ph.fsf@toke.dk> <20200320103530.2853c573@kicinski-fedora-PC1C0HJN>
 <5e750bd4ebf8d_233f2ab4c81425c4ce@john-XPS-13-9370.notmuch>
 <CAEf4BzbWa8vdyLuzr_nxFM3BtT+hhzjCe9UQF8Y5cN+sVqa72g@mail.gmail.com>
 <87tv2f48lp.fsf@toke.dk> <CAEf4BzYutqP0yAy-KyToUNHM6Z-6C-XaEwK25pK123gejG0s9Q@mail.gmail.com>
 <87h7ye3mf3.fsf@toke.dk> <CAEf4BzY+JsmxCfjMVizLWYU05VS6DiwKE=e564Egu1jMba6fXQ@mail.gmail.com>
 <87tv2e10ly.fsf@toke.dk> <20200324115349.6447f99b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200324115349.6447f99b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 24 Mar 2020 15:30:58 -0700
Message-ID: <CAEf4Bzb=FuVVw1wwLbGW1LU05heAFoUiJjm71=Qqxr+dS78qyQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/4] xdp: Support specifying expected existing
 program when attaching XDP
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Andrey Ignatov <rdna@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 24, 2020 at 11:53 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 24 Mar 2020 11:57:45 +0100 Toke H=C3=B8iland-J=C3=B8rgensen wrote=
:
> > > If everyone is using libbpf, does kernel system (bpf syscall vs
> > > netlink) matter all that much?
> >
> > This argument works the other way as well, though: If libbpf can
> > abstract the subsystem differences and provide a consistent interface t=
o
> > "the BPF world", why does BPF need to impose its own syscall API on the
> > networking subsystem?
>
> Hitting the nail on the head there, again :)
>
> Once upon a time when we were pushing for libbpf focus & unification,
> one of my main motivations was that a solid library that most people
> use give us the ability to provide user space abstractions.

Yes, but bpf_link is not a user-space abstraction only anymore. It
started that way and we quickly realized that we still will need
kernel support. Not everything can be abstracted in user-space only.
So I don't see any contradiction here, that's still libbpf focus.

>
> As much as adding new kernel interfaces "to rule them all" is fun, it
> has a real cost.

We are adding kernel interface regardless of XDP (for cgroups and
tracing, then perf_events, etc). The real point and real cost here is
to not have another duplication of same functionality just for XDP use
case. That's the real cost, not the other way around. Don't know how
to emphasize this further.

And there is very little fun involved from my side, believe it or not...
