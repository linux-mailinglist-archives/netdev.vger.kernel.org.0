Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91C8927B433
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 20:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbgI1SOM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 14:14:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726565AbgI1SOM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 14:14:12 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00BE5C061755
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 11:14:12 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id u19so2139382ion.3
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 11:14:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ojoLsXhhOYV8JUEC2PXBuDsbOcVVspFSt+vtu6KOKO4=;
        b=NsC2FqRhpQLDN+b/cUZo8Ktq7cAIdHd1RHJ9CkZNtn89PdqCIGHXyc/xbzni3v4Gd1
         hoH/PbYWzclcXdXxghrGJuZmbaKzLWx/oLl7sW6HXpp1vHK/lBNdlj3WemNB7XzA7wQD
         A31wzqS1vjy6E+6unpShkGC09lNbcZi0KfK/pQYZ4VlG1G7iXLWHV1s+YqkDILYFD7YY
         ZsfCgodHXFhsYcFC05KjZQLB6QXKxs49ItK1iKugvLMR/uu6wT2XOkneho0e4KwdvBKR
         bOPSIUW+KX34g8dCG3FJmXMaJlh9MdSV/fmNIgPxI8czfAYCFmBCP78bl93xoRnPm58G
         OaxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ojoLsXhhOYV8JUEC2PXBuDsbOcVVspFSt+vtu6KOKO4=;
        b=Yl9DagnIaube11ZLlaPPFs8/BoqR9C2rKcIbKmGL5XUBoXi4P0cfW9OAWi7SgP/7AP
         RtKAAAkCvGxCUv6xhOT0/GwYG6SFdZtGfmkXpthLeFfoJP8uAkDiJzwr4nIP3M43OuZp
         g+pcMOL4aqMT/bqVD/Wk+dp1fiH4zYGLxRxDT2ET73yOxzKCanqCsTR/zaewh8hfhF5G
         PO6V9+JSUix/8dOyyDi8o6b/jnKm70a+Vw6VJvVgPI5zXQKr179mbl8pRbNtvQBP8EGP
         j3djQkTyzu1LO6peupCsS8VXpwyPQ3Jc8SBJzL/0vQ+EEZBY6cPg3EjV/K04O/lxe87b
         vF4Q==
X-Gm-Message-State: AOAM531HLf6kwNL61VHRVOeONcQF76nQYhIxaIBFbTbGlYm6Sw9KonRN
        UQ8R1QpYRgJpLbN/sKTqHJzQhus1Kr2j6qWWQbLCCQ==
X-Google-Smtp-Source: ABdhPJyzZARUxWdFdhsQK0bVFwMkbQ+vqY2PuBICQ24tpjdkSHk5OXOnq5u/Hg36JxtjfSeTuW1ksQW0rvhD7RU0GM8=
X-Received: by 2002:a05:6638:ec5:: with SMTP id q5mr2181963jas.13.1601316851151;
 Mon, 28 Sep 2020 11:14:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200914172453.1833883-1-weiwan@google.com> <20200914172453.1833883-2-weiwan@google.com>
 <2ab7cdc1-b9e1-48c7-89b2-a10cd5e19545@www.fastmail.com> <CAEA6p_DyU7jyHEeRiWFtNZfMPQjJJEV2jN1MV-+5txumC5nmZg@mail.gmail.com>
 <021e455b-faaf-4044-94bb-30291e1c9ee1@www.fastmail.com> <f4cb4816d70e480f1b9bc88bfee1ec5d9017d42a.camel@redhat.com>
In-Reply-To: <f4cb4816d70e480f1b9bc88bfee1ec5d9017d42a.camel@redhat.com>
From:   Wei Wang <weiwan@google.com>
Date:   Mon, 28 Sep 2020 11:13:59 -0700
Message-ID: <CAEA6p_B3cw0Ae0migRkOyw6t0sXowJ-aOV0eaVxqRcPu9nNQAQ@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 1/6] net: implement threaded-able napi poll
 loop support
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Hannes Frederic Sowa <hannes@stressinduktion.org>,
        David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Felix Fietkau <nbd@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 28, 2020 at 1:45 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> Hello,
>
> On Sat, 2020-09-26 at 16:22 +0200, Hannes Frederic Sowa wrote:
> > On Sat, Sep 26, 2020, at 01:50, Wei Wang wrote:
> > > I took a look at the current "threadirqs" implementation. From my
> > > understanding, the kthread used there is to handle irq from the
> > > driver, and needs driver-specific thread_fn to be used. It is not
> > > as
> > > generic as in the napi layer where a common napi_poll() related
> > > function could be used as the thread handler. Or did I
> > > misunderstand
> > > your point?
> >
> > Based on my memories: We had napi_schedule & co being invoked inside
> > the threads
>
> I just looked at the code - I really forgot most details. The above is
> correct...
>
> > without touching any driver code when we specified
> > threadirqs. But this would need a double check.
>
> ... but still that code needed some per device driver modification: the
> irq subsystem handled the switch to/from threaded mode, and needed some
> callback, provided from the device driver, to notify the network code
> about the change (specifically, to mark the threaded status inside the
> relevant napi struct).

Thanks for the clarification. This corresponds with my understanding as well.

>
> Cheers,
>
> Paolo
>
