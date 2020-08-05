Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8ADD23D3B4
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 23:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbgHEV5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 17:57:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725920AbgHEV5Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 17:57:24 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BFEDC061575;
        Wed,  5 Aug 2020 14:57:24 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id y134so19344365yby.2;
        Wed, 05 Aug 2020 14:57:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=emi+RQ76nlVMZKGrfXvflwv17gy8R5OGfau8eXMSOTs=;
        b=c0FFrI9gdc94+J2jAn+5fzHuywJ5ts4Wt7bib8/jaoX1wRg5YPE3ytedrs3Un3FBFd
         OLx5L4rLyfrQ8l+Mg+HdiwlLrShUk0IG+xg1oj2faCU9Z9As3/uEk8gxXv+7gJURsuVE
         GtyGLY7v1v6SyoI0ekfCv7wjPJzHajz4KD4an+r3/Lu0ACMm/J1hiU+JtCvfFZghn5FJ
         IeIDrxbp8F1hLzN98nql3faz5Evn44YudhTw5Xx+yyfX8kKRYwyPtm7i1Rmqus5+6Bl8
         OGZZzrMeWEJEsyGuwsF3nEvht++YbO/1Y5N8eUll+OunCoYAVGL0ZpCDRX1RFaxe9iJp
         1qfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=emi+RQ76nlVMZKGrfXvflwv17gy8R5OGfau8eXMSOTs=;
        b=OJD0Hrl8QtLYvSgYu3qnt9Lml0BFUkIhuBvv6Uk8708LOn6hWAGzYnVrLEwLZ0CLRl
         aouQ0Cks1O9B3lYNgrFfV8PJMLOWsxdDOuKYLWX/bhTrgnJaIXMbMl5GCRdZwpoPl6dv
         pNW6egx7HbP9dx4NPMTOb4QK5arRaoJXvt9YpQ2BzIVMXjUiMfPBS5+RgxeTgdEat07U
         ZRHdec3mtvDtuTlPvsgfUyotlpPt4J/Q7SNHy+JK820CS/GOhtSe+JAI/9nnv6qSrEXk
         uyyMdD8IVwNhchIewuf1xogTxV++Osp5vxfai82Pe3L4hvspG28tbis1x/0cR9m/bAs/
         QDzg==
X-Gm-Message-State: AOAM531oGQyr/+XUVz1O2/mu9Vm9OKPTU9ZKVtntAl2GOZlgveP7pXoZ
        LmbERzs7hTeyKJldELO70rRUhH7+OM2bO4LrjrM=
X-Google-Smtp-Source: ABdhPJx1EXqSHcOb5kC5Y1YHep+m0g9sD/tFw3aUakKcpwwidC3uh4ud+EMd0AVvdfA9+j5DsF76omtZbbY7zL4ao3E=
X-Received: by 2002:a25:ba0f:: with SMTP id t15mr8156847ybg.459.1596664643529;
 Wed, 05 Aug 2020 14:57:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200801170322.75218-1-jolsa@kernel.org> <20200801170322.75218-9-jolsa@kernel.org>
 <CAEf4BzaWGZT-6h8axOupzQ6Z2UiCakgv+v284PuXDZ6_VF5M9Q@mail.gmail.com>
 <20200805175651.GC319954@krava> <20200805213136.GG319954@krava>
In-Reply-To: <20200805213136.GG319954@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 5 Aug 2020 14:57:10 -0700
Message-ID: <CAEf4Bza5H0+96Pgz1wmWJP=ABGikv3iEmMc9EMWMpZ0+c9Gpbg@mail.gmail.com>
Subject: Re: [PATCH v9 bpf-next 08/14] bpf: Add btf_struct_ids_match function
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 5, 2020 at 2:31 PM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Wed, Aug 05, 2020 at 07:56:51PM +0200, Jiri Olsa wrote:
> > On Tue, Aug 04, 2020 at 11:27:55PM -0700, Andrii Nakryiko wrote:
> >
> > SNIP
> >
> > > > diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> > > > index 7bacc2f56061..ba05b15ad599 100644
> > > > --- a/kernel/bpf/btf.c
> > > > +++ b/kernel/bpf/btf.c
> > > > @@ -4160,6 +4160,37 @@ int btf_struct_access(struct bpf_verifier_log *log,
> > > >         return -EINVAL;
> > > >  }
> > > >
> > > > +bool btf_struct_ids_match(struct bpf_verifier_log *log,
> > > > +                         int off, u32 id, u32 need_type_id)
> > > > +{
> > > > +       const struct btf_type *type;
> > > > +       int err;
> > > > +
> > > > +       /* Are we already done? */
> > > > +       if (need_type_id == id && off == 0)
> > > > +               return true;
> > > > +
> > > > +again:
> > > > +       type = btf_type_by_id(btf_vmlinux, id);
> > > > +       if (!type)
> > > > +               return false;
> > > > +       err = btf_struct_walk(log, type, off, 1, &id);
> > >
> > > nit: this size=1 looks a bit artificial, seems like btf_struct_walk()
> > > will work with size==0 just as well, no?
> >
> > right, it will work the same for 0 ... not sure why I put
> > originaly 1 byte for size.. probably got mixed up by some
> > condition in btf_struct_walk that I thought 0 wouldn't pass,
> > but it should work, I'll change it, it's less tricky
>
> ok, I found why it's 1 ;-) it's this condition in btf_struct_walk:
>
>         for_each_member(i, t, member) {
>                 /* offset of the field in bytes */
>                 moff = btf_member_bit_offset(t, member) / 8;
>                 if (off + size <= moff)
>                         /* won't find anything, field is already too far */
>                         break;
>
> I originaly chose to use 'size = 1' not to medle with this (and probably causing
> other issues) and in any case we expect that anything we find have at least byte
> size, so it has some logic ;-)
>
> we could make 0 size a special case and don't break the loop for it,
> but I wonder there's already someone calling it with zero and is
> expecting it to fail
>

I see, ok, probably no need. Just let it be for now, I guess.

> jirka
>
