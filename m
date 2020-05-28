Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F82B1E6FB3
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 00:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437425AbgE1Wyr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 18:54:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437392AbgE1Wy3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 18:54:29 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C90D5C08C5C6
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 15:54:28 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id g18so412930qtu.13
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 15:54:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=azLYqNykx8o+C9GuZJvXUbj4n+4gP6OF9yQsCRUpe6E=;
        b=QLN6Ez0qIMiiCayaUmgV5kiX9+jJq12sgjTtDKNZcaubI5huzlCaSkVbfHZJM8YD6j
         KkHmuQvH2f8gIPbkCrWk8cZACksb6IVs70QOEXTkLt7pAwr3HPFCnE4hbwYtyd1/U5AP
         zGdEx0G/uao0fK+f9/AhLA3HJByev3KCXMlcomFCJmGY4xDFGOkkW91rMgpSmQCTaODO
         BNE5L9ej7vSmlrgHMNdDl7PLWdAtKi8T21wJdmQPOmyoo+U36FoMNq2TwBwHWFrqLFIM
         5BWRc2NjUygR6jIxphXhMl/UPz7rX0Tdu/48NLLtN25mn4tHIRbsHaS+DsBrXFjYSXIm
         azwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=azLYqNykx8o+C9GuZJvXUbj4n+4gP6OF9yQsCRUpe6E=;
        b=MRfUBxaFFKIixbGK6xJ4ZYtrQP//JkhXhuLyq5OjpL+igU/ZQXkc+71zBqgGGLdQzd
         tU1/+LQedU3J0Fzm1OdwfwsAa8vbRgt0ZItuzqg959rwgyH+SkhSmfPzUBZaxAnTGcob
         xUJseK3uJr5TYD+e07G+atqH4Q9TCyMizZjMuGhbIgLDmHOO7BYZLAFGKE9UodfnQ5wy
         TNBzisIzT7Z4Amb/WZe2ZiAsFqEiDAeiWZdJN8wGW5V4zlS4E7TbXf/aOIx92c5jqpZq
         66MWOEuKSXS336q3y+36jkE9SUFtTLG77ed2HJ4TJf+puhYo+NjkhJhPzKjPDtpDtx0+
         FE8w==
X-Gm-Message-State: AOAM530OhyGTaHeMJ+R4kqNDOguUlj3UBcZLaRKbpKQQkviShKgdtod8
        XInBdiyVN8+tAYgXGjeFKHqwGoVnCWyI480IaEg=
X-Google-Smtp-Source: ABdhPJwQYcBQULCwviaVx1tWb8fMaGHlFFOybZm4qJC4hlRrSOrnJNsyIkLommaU3Z7dKqQXVvnkqj6kPzMlvbqPIvY=
X-Received: by 2002:ac8:342b:: with SMTP id u40mr5628070qtb.59.1590706468070;
 Thu, 28 May 2020 15:54:28 -0700 (PDT)
MIME-Version: 1.0
References: <20200528001423.58575-1-dsahern@kernel.org> <20200528001423.58575-3-dsahern@kernel.org>
 <CAEf4BzYZSPdGH+RXp+kHfWnGGLRuiP=ho9oMsSf7RsYWyeNk0g@mail.gmail.com> <191ba79f-3aeb-718c-644e-bd2cc539dc60@gmail.com>
In-Reply-To: <191ba79f-3aeb-718c-644e-bd2cc539dc60@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 28 May 2020 15:54:16 -0700
Message-ID: <CAEf4BzZft4TV75RbgBgPfu5Ps3b+h8dM6jbJQ_3_ue=EmSq0rQ@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 2/5] bpf: Add support to attach bpf program to
 a devmap entry
To:     David Ahern <dsahern@gmail.com>
Cc:     David Ahern <dsahern@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        john fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 28, 2020 at 3:40 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 5/28/20 1:01 AM, Andrii Nakryiko wrote:
> >
> > Please cc bpf@vger.kernel.org in the future for patches related to BPF
> > in general.
>
> added to my script
>
> >
> >>  include/linux/bpf.h            |  5 +++
> >>  include/uapi/linux/bpf.h       |  5 +++
> >>  kernel/bpf/devmap.c            | 79 +++++++++++++++++++++++++++++++++-
> >>  net/core/dev.c                 | 18 ++++++++
> >>  tools/include/uapi/linux/bpf.h |  5 +++
> >>  5 files changed, 110 insertions(+), 2 deletions(-)
> >>
> >
> > [...]
> >
> >>
> >> +static struct xdp_buff *dev_map_run_prog(struct net_device *dev,
> >> +                                        struct xdp_buff *xdp,
> >> +                                        struct bpf_prog *xdp_prog)
> >> +{
> >> +       u32 act;
> >> +
> >> +       act = bpf_prog_run_xdp(xdp_prog, xdp);
> >> +       switch (act) {
> >> +       case XDP_DROP:
> >> +               fallthrough;
> >
> > nit: I don't think fallthrough is necessary for cases like:
> >
> > case XDP_DROP:
> > case XDP_PASS:
> >     /* do something */
> >
> >> +       case XDP_PASS:
> >> +               break;
> >> +       default:
> >> +               bpf_warn_invalid_xdp_action(act);
> >> +               fallthrough;
> >> +       case XDP_ABORTED:
> >> +               trace_xdp_exception(dev, xdp_prog, act);
> >> +               act = XDP_DROP;
> >> +               break;
> >> +       }
> >> +
> >> +       if (act == XDP_DROP) {
> >> +               xdp_return_buff(xdp);
> >> +               xdp = NULL;
> >
> > hm.. if you move XDP_DROP case to after XDP_ABORTED and do fallthrough
> > from XDP_ABORTED, you won't even need to override act and it will just
> > handle all the cases, no?
> >
> > switch (act) {
> > case XDP_PASS:
> >     return xdp;
> > default:
> >     bpf_warn_invalid_xdp_action(act);
> >     fallthrough;
> > case XDP_ABORTED:
> >     trace_xdp_exception(dev, xdp_prog, act);
> >     fallthrough;
> > case XDP_DROP:
> >     xdp_return_buff(xdp);
> >     return NULL;
> > }
> >
> > Wouldn't this be simpler?
> >
>
> Switched it to this which captures your intent with a more traditional
> return location.
>
>         act = bpf_prog_run_xdp(xdp_prog, xdp);
>         switch (act) {
>         case XDP_PASS:
>                 return xdp;
>         case XDP_DROP:
>                 break;
>         default:
>                 bpf_warn_invalid_xdp_action(act);
>                 fallthrough;
>         case XDP_ABORTED:
>                 trace_xdp_exception(dev, xdp_prog, act);
>                 break;
>         }
>
>         xdp_return_buff(xdp);
>         return NULL;

looks good as well, thanks
