Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C02BC201A1E
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 20:15:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387936AbgFSSPk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 14:15:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731978AbgFSSPk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 14:15:40 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAF6FC06174E;
        Fri, 19 Jun 2020 11:15:39 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id q8so9784247qkm.12;
        Fri, 19 Jun 2020 11:15:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RYTTFB9vpBLIdJ5u4RqxHxQWqwi+IRzwIbFYmw2BZoo=;
        b=kp6DN58mQjYUlmrccU4+kTySQcS8a/C/2gnyYhsfvvJVNeMFr2O0Jo74HhMtd+HfyP
         269DS2mt6wVSir99HUHhik1snmXpVTR2qo2F5OrQfxR6t40S5PEAoneeLD4QvzwdcKBM
         oRkgjS3kw8dutF2RY3K+cU9W/0fA89FnujPdkBStmXPURPG2Te9AosfOBKBIkKfH9ndt
         S5izn9ox8RjW/ZeC+jq4Wp13ZFS7g8twkYaNIUdwuLj2ReDXLwVrw1I4Ia32t5j+8tWx
         2N+HnutCPq6VjwxLDwsxom6ylH7Nh9WNEZ5XxKMRWe9wSI0CSwb///ct6uDpTP4Q0rIi
         vCHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RYTTFB9vpBLIdJ5u4RqxHxQWqwi+IRzwIbFYmw2BZoo=;
        b=AIRhYFnrQr1dCljv156N35r9VNg/ADFikozN6wVlBXvlFGb7yKOUYgfDbdKbYHP8BN
         hikBKIZb73+p1MzRn4+7D1zYeqTM0Chn7x4yRFWzr5AuqvaDAdzqDY0m4M+WSALpIUo3
         2IHq8sJzexg9rJcKurYCGcrNWYmRhH7mqeKZCgHZIfmBDbAZtKUZ2hL1uZFxTgL/a1vY
         l4bMJZin9pXS6zyz6pyiM8gC42TvvMvl1nvyWw0/GYgOUs6UxZ8ZfHqMI9KG+0Y0ustj
         kLzcXnBTJOJnajg2rEkO5XVH2ShmvQAVTw1Km1mbRcSm6KIw6GtABE3mbdIQOJlQW00N
         SAMA==
X-Gm-Message-State: AOAM5332CZPpOIE2CL9h3+PVQDS7FGYseQfaHpz9KQrOnYoIYJ/0ASDS
        RHcsspLIkH68aqzIksb81TIaGj1vVykIU4/wbEY=
X-Google-Smtp-Source: ABdhPJxMG7Q9EcwgsIhFOnPt1WrO8kx/gLcbgmHTKrDahoF5DSRWAD6bFc5SXGogFT/UJuc/uxXT012OnFx0gDpIwTA=
X-Received: by 2002:a37:6712:: with SMTP id b18mr4933834qkc.36.1592590538836;
 Fri, 19 Jun 2020 11:15:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200616100512.2168860-1-jolsa@kernel.org> <20200616100512.2168860-4-jolsa@kernel.org>
 <CAEf4BzZ=BN7zDU_8xMEEoF7khjC4bwGitU+iYf+6uFXPZ_=u-g@mail.gmail.com> <20200619131306.GD2465907@krava>
In-Reply-To: <20200619131306.GD2465907@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 19 Jun 2020 11:15:27 -0700
Message-ID: <CAEf4Bza6DpmiwMXquY1WRTjfqhAPvnu87NsrVhVkew_2coU2Rw@mail.gmail.com>
Subject: Re: [PATCH 03/11] bpf: Add btf_ids object
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 19, 2020 at 6:13 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Thu, Jun 18, 2020 at 05:56:38PM -0700, Andrii Nakryiko wrote:
> > On Tue, Jun 16, 2020 at 3:05 AM Jiri Olsa <jolsa@kernel.org> wrote:
> > >
> > > Adding support to generate .BTF_ids section that would
> > > hold various BTF IDs list for verifier.
> > >
> > > Adding macros help to define lists of BTF IDs placed in
> > > .BTF_ids section. They are initially filled with zeros
> > > (during compilation) and resolved later during the
> > > linking phase by btfid tool.
> > >
> > > Following defines list of one BTF ID that is accessible
> > > within kernel code as bpf_skb_output_btf_ids array.
> > >
> > >   extern int bpf_skb_output_btf_ids[];
> > >
> > >   BTF_ID_LIST(bpf_skb_output_btf_ids)
> > >   BTF_ID(struct, sk_buff)
> > >
> > > Suggested-by: Andrii Nakryiko <andrii.nakryiko@gmail.com>
> > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > ---
> > >  include/asm-generic/vmlinux.lds.h |  4 ++
> > >  kernel/bpf/Makefile               |  2 +-
> > >  kernel/bpf/btf_ids.c              |  3 ++
> > >  kernel/bpf/btf_ids.h              | 70 +++++++++++++++++++++++++++++++
> > >  4 files changed, 78 insertions(+), 1 deletion(-)
> > >  create mode 100644 kernel/bpf/btf_ids.c
> > >  create mode 100644 kernel/bpf/btf_ids.h
> > >
> >
> > [...]
> >
> > > +/*
> > > + * Following macros help to define lists of BTF IDs placed
> > > + * in .BTF_ids section. They are initially filled with zeros
> > > + * (during compilation) and resolved later during the
> > > + * linking phase by btfid tool.
> > > + *
> > > + * Any change in list layout must be reflected in btfid
> > > + * tool logic.
> > > + */
> > > +
> > > +#define SECTION ".BTF_ids"
> >
> > nit: SECTION is super generic and non-greppable. BTF_IDS_SECTION?
>
> ok
>
> >
> > > +
> > > +#define ____BTF_ID(symbol)                             \
> > > +asm(                                                   \
> > > +".pushsection " SECTION ",\"a\";               \n"     \
> >
> > section should be also read-only? Either immediately here, of btfid
> > tool should mark it? Unless I missed that it's already doing it :)
>
> hm, it's there next to the .BTF section within RO_DATA macro,
> so I thought that was enough.. I'll double check

ah, linker script magic, got it

>
> >
> > > +".local " #symbol " ;                          \n"     \
> > > +".type  " #symbol ", @object;                  \n"     \
> > > +".size  " #symbol ", 4;                        \n"     \
> > > +#symbol ":                                     \n"     \
> > > +".zero 4                                       \n"     \
> > > +".popsection;                                  \n");
> > > +
> > > +#define __BTF_ID(...) \
> > > +       ____BTF_ID(__VA_ARGS__)
> >
> > why varargs, if it's always a single argument? Or it's one of those
> > macro black magic things were it works only in this particular case,
> > but not others?
>
> yea, I kind of struggled in here, because any other would not
> expand the name concat together with the unique ID bit,
> __VA_ARGS__ did it nicely ;-) I'll revisit this

it's probably not varargs, but rather nested macro call. Macros are
weird and tricky...

>
> thanks,
> jirka
>
