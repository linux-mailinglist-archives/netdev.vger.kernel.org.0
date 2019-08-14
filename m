Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 404E38CA83
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 06:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727136AbfHNEp6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 00:45:58 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:38770 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726373AbfHNEp6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 00:45:58 -0400
Received: by mail-qt1-f194.google.com with SMTP id x4so10817738qts.5;
        Tue, 13 Aug 2019 21:45:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jpDLEJ54g+3C02lMsDTTMO/8dtDGEHfbIQE1QDx5jYM=;
        b=WIk3btQowIEEe8D8R2lkD1NiHx36+kU+0cmcZQ5d0A7/omKwXKuyR1NpdLsj4WVoqx
         tg+fr9JOiMBTonwPF2FyoGR6nLpVQ48mHJAfjkH9HVda3TlxMzOOdP4+fLzzpgli9w8/
         ygBEcjOyGD28r7O1/qu0VQgrbSnpifjuAWAdfsz6DyGcvY+1Bl6rmeJFlRdUdFGTLGRo
         2/reTS5VsnMtwg8CXys/q9WtRJVG8J+pJJRT65uQsqFVcl2eY+zIyBXtS0LNe71Fd7rF
         L26+Sefs1l6iSZjcnScqhGfA7XDaJJAMqsCyhpPsIP2mvvD+pnFXikC3UwppaOnwklYo
         x6HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jpDLEJ54g+3C02lMsDTTMO/8dtDGEHfbIQE1QDx5jYM=;
        b=G/PYWJORVfEuiAo8GUYwm2aUAPQzaXxJeuBGTXqSW+F+IwPcalfqZBWXcy/PqN8AgG
         f+6dG4hbDNRsjAM3DgkUjCnXp65gxukzxhekPD2QXNRb5FcxEyQifnhrNH4RATbWMO/g
         V7G67jyxn3uA778Wha52s5OfkGxsOHgMd2vzc/Iz5mNgxZtTalLcoNUjJjcsLXqjcHUs
         Q/jCJWgAshh53GOEpvlxrfOs62ns/4cHNPtWnEeTR3nyTzZuPZEhyYmzK2bqlrnvstfY
         jSHgm3q0yEM625HhKfPyTo+8CnTdHBOYj/qwO/GntIXdkzZnC7nzme5duVX+LS7bLfu6
         Upfg==
X-Gm-Message-State: APjAAAUEmjuwJXS1x4AGFliv9fU6blN87LPRI9ayVgQl+P4zWxAcHWrH
        YV6JDZy931522JHNe0kP/xDX8a0KB9+dtOWxiqE=
X-Google-Smtp-Source: APXvYqy9flga3/rYQDsoriEOTd4JoB2UoGtHFUfhBMPnyCTP0txeWRB4x8rN3sldquFGRo+BPXNEb5wk5Szsd2LXlZg=
X-Received: by 2002:ac8:488a:: with SMTP id i10mr34068758qtq.93.1565757957114;
 Tue, 13 Aug 2019 21:45:57 -0700 (PDT)
MIME-Version: 1.0
References: <20190813232408.1246694-1-andriin@fb.com> <20190813175115.79383f09@cakuba.netronome.com>
In-Reply-To: <20190813175115.79383f09@cakuba.netronome.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 13 Aug 2019 21:45:45 -0700
Message-ID: <CAEf4BzZnWHr-5QS0zzku=2tspWESAW-mE6yVRjzxbqr3g4_0FA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: make libbpf.map source of truth for
 libbpf version
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>, Andrey Ignatov <rdna@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 13, 2019 at 5:51 PM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Tue, 13 Aug 2019 16:24:08 -0700, Andrii Nakryiko wrote:
> > diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
> > index 9312066a1ae3..d9afc8509725 100644
> > --- a/tools/lib/bpf/Makefile
> > +++ b/tools/lib/bpf/Makefile
> > @@ -1,9 +1,10 @@
> >  # SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause)
> >  # Most of this file is copied from tools/lib/traceevent/Makefile
> >
> > -BPF_VERSION = 0
> > -BPF_PATCHLEVEL = 0
> > -BPF_EXTRAVERSION = 4
> > +BPF_FULL_VERSION = $(shell \
> > +     grep -E 'LIBBPF_([0-9]+)\.([0-9]+)\.([0-9]+) \{' libbpf.map | \
> > +     tail -n1 | cut -d'_' -f2 | cut -d' ' -f1)
> > +BPF_VERSION = $(firstword $(subst ., ,$(BPF_FULL_VERSION)))
> >
> >  MAKEFLAGS += --no-print-directory
> >
> > @@ -79,15 +80,12 @@ export prefix libdir src obj
> >  libdir_SQ = $(subst ','\'',$(libdir))
> >  libdir_relative_SQ = $(subst ','\'',$(libdir_relative))
> >
> > +LIBBPF_VERSION       = $(BPF_FULL_VERSION)
>
> Perhaps better use immediate set here ':='?
> I'm not sure how many times this gets evaluated, but it shouldn't
> really change either..

Yep, makes sense, will do.

>
> >  VERSION              = $(BPF_VERSION)
> > -PATCHLEVEL   = $(BPF_PATCHLEVEL)
> > -EXTRAVERSION = $(BPF_EXTRAVERSION)
> >
> >  OBJ          = $@
> >  N            =
> >
> > -LIBBPF_VERSION       = $(BPF_VERSION).$(BPF_PATCHLEVEL).$(BPF_EXTRAVERSION)
> > -
> >  LIB_TARGET   = libbpf.a libbpf.so.$(LIBBPF_VERSION)
> >  LIB_FILE     = libbpf.a libbpf.so*
> >  PC_FILE              = libbpf.pc
