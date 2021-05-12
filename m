Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6E937ED11
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 00:38:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385106AbhELUGk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 16:06:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377527AbhELTEP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 15:04:15 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72D57C061760;
        Wed, 12 May 2021 12:02:23 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id c14so434699ybr.5;
        Wed, 12 May 2021 12:02:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NAb00qPjcyT4ExQTqahgYMnlB8I9W8Nq9hR7/8NZNH8=;
        b=rJGsV3E2vvzzmcvEDo/Z6AY4zdWaqzgKm0+XrzkHp9ELPNmNEbq+NeyUB8HewLwvnc
         y+X8wMb9B+AdPjKZboYdtFF6Fzcdec+8CSsnlSL4bs+dSt1mU2qfmro81QIyg/QwOx6t
         TMw0xDPr+KUvSZUQYFUQkeOHJcqLvon3wBq64H1uwK337iGVQ+iR+vvJVagC4TmIZGru
         /4tMZVTxbPd0Eexfj78DM5eN6bgCrwAXqNQrpUaUdqDs5KXKCk+dpPmBQve1BMSpa/vt
         OvAeKVjfGLwm4VBvfCTXFAHj1nJhLVba4SX5k6VSpB8D1JhVb/4lwoSJwtcuJlWv+FUB
         ucRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NAb00qPjcyT4ExQTqahgYMnlB8I9W8Nq9hR7/8NZNH8=;
        b=KKjP5D/DNXeO0Tyh1SpFH0PPllnnwgZ5T9M2lbaBzKd2qndCIJlhZnmPljrEGf3k0Z
         NkpGnoV8N73/2Yk5nxExY4s+xYFrcAEFS63yFpHBa2dnNT4aq73CNdXTyAet0zNEJ94V
         /RPL8P/5vwmwB0eycqrXKa+YGoE4Jmisj7uZTgXSqM7QAucTrNnwmTG8q55PJHkw9OCZ
         yjADcIIw4jPrzMOcJOoZ6n4nnrvhlgSxyqmy7uiQc95jaAFusQh3YzGfVnd1UcGBkHyd
         hkPtDzbdQiXuhGvuJ4vxDxG08o17DhzqSUJIoih0i+5Wly+NIenRqkkUUG7tg/Hnn7ke
         i9AA==
X-Gm-Message-State: AOAM532/91qnhzll6mbDkD+UIFN8pzNVWT09Eiaj+Chg9exlbDlhL3Iu
        oOVxjoiekGF5Ew3QxXgh7SSXkZNmfAuqMWHq3CFkUCHc
X-Google-Smtp-Source: ABdhPJzF2ScQEqkGJ1MPuqJeczN70mN7VGzaph1Io9kbrh3UzmCpNldbTkUW6suJQKJslYT+gFrPukj58cJNOM6kOS0=
X-Received: by 2002:a25:3357:: with SMTP id z84mr49477847ybz.260.1620846142481;
 Wed, 12 May 2021 12:02:22 -0700 (PDT)
MIME-Version: 1.0
References: <20210510124315.3854-1-thunder.leizhen@huawei.com>
 <CAEf4BzaADXguVoh0KXxGYhzG68eA1bqfKH1T1SWyPvkE5BHa5g@mail.gmail.com> <YJoRd4reWa1viW76@unreal>
In-Reply-To: <YJoRd4reWa1viW76@unreal>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 12 May 2021 12:02:11 -0700
Message-ID: <CAEf4BzaYsjWh_10a4yeSVpAAwC-f=zUNANb10VN2xZ1b5dsY-A@mail.gmail.com>
Subject: Re: [PATCH 1/1] libbpf: Delete an unneeded bool conversion
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Zhen Lei <thunder.leizhen@huawei.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 10, 2021 at 10:09 PM Leon Romanovsky <leon@kernel.org> wrote:
>
> On Mon, May 10, 2021 at 11:00:29AM -0700, Andrii Nakryiko wrote:
> > On Mon, May 10, 2021 at 5:43 AM Zhen Lei <thunder.leizhen@huawei.com> wrote:
> > >
> > > The result of an expression consisting of a single relational operator is
> > > already of the bool type and does not need to be evaluated explicitly.
> > >
> > > No functional change.
> > >
> > > Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
> > > ---
> >
> > See [0] and [1].
> >
> >   [0] https://lore.kernel.org/bpf/CAEf4BzYgLf5g3oztbA-CJR4gQ7AVKQAGrsHWCOgTtUMUM-Mxfg@mail.gmail.com/
> >   [1] https://lore.kernel.org/bpf/CAEf4BzZQ6=-h3g1duXFwDLr92z7nE6ajv8Rz_Zv=qx=-F3sRVA@mail.gmail.com/
>
> How long do you plan to fight with such patches?

As long as necessary. There are better ways to contribute to libbpf
than doing cosmetic changes to the perfectly correct code.

>
> Thanks
>
> >
> > >  tools/lib/bpf/libbpf.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > > index e2a3cf4378140f2..fa02213c451f4d2 100644
> > > --- a/tools/lib/bpf/libbpf.c
> > > +++ b/tools/lib/bpf/libbpf.c
> > > @@ -1504,7 +1504,7 @@ static int set_kcfg_value_tri(struct extern_desc *ext, void *ext_val,
> > >                                 ext->name, value);
> > >                         return -EINVAL;
> > >                 }
> > > -               *(bool *)ext_val = value == 'y' ? true : false;
> > > +               *(bool *)ext_val = value == 'y';
> > >                 break;
> > >         case KCFG_TRISTATE:
> > >                 if (value == 'y')
> > > --
> > > 2.26.0.106.g9fadedd
> > >
> > >
