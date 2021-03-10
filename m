Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAC5633333B
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 03:43:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231872AbhCJCm4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 21:42:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231174AbhCJCmg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 21:42:36 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E36C2C061760
        for <netdev@vger.kernel.org>; Tue,  9 Mar 2021 18:42:35 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id z13so16290235iox.8
        for <netdev@vger.kernel.org>; Tue, 09 Mar 2021 18:42:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=15h8tMwdfkWyy7Pp9kmOba9JQnUMygMsSfVNzhtBOr4=;
        b=NNxyW4YJWVs2IJF6pGSKOJ9m4vl/W0+ukQkGX3agz2MmtVia6NvdaL2ezzYXOYFUrq
         9ZBF5zz1zNQt/lLhElhB8Fd2HsqhSQ1WZBAmgOxbtIFkjXhO3vpFv6aJ2Bf8jYiYoEFa
         CcoyouwkRMeeNRRbPxB1ApAVV2ndyafP+S3yvmiHTlCY4GmV9EW5ZHL1UHuSsCtC56Kg
         Gn8rFJEJ/e4D7jBzgnnQsJCA/zWoZ5Nc1KR4FHDjWxvtuI9pb5Df3P7K1dUYxFN8gjBM
         kIE69etKuqXlwH6a8HxY8nO9i8OnoI6vzGM1RzPfXN7mdh3DZCUmsslDvaegUp5fwe6U
         4aHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=15h8tMwdfkWyy7Pp9kmOba9JQnUMygMsSfVNzhtBOr4=;
        b=iUw0RoD18roZj6om0NaXfsnveUsFMBVjqc2ub2MYQ2UWcN2w5M0lbGfD4FmiJTzK6N
         vPJL6bXZnNfSNFayEvC0Zk6iZoXYd+51aUJfty0WiefUgjrpeZPx4DlVCz91wONhBm6U
         eTJWZIHZe9aWAHWKLR2RNHInXPYDB9nAwyreCC0UD4ONgJdiw16n2YRJLpl+Mc4S98Uz
         UzUR5X3vQ1GpnqazLbo7xmMdVFViaR/0BsioU612lvD4wguCxU1Lm+3uNMqnS/9NiYlu
         jLAyabIq2rc0XmR4NPg7giQJCqJVAfKNudbYAMUQpOqouXTgagjmA6uuu8FZ6Ah88qwM
         xtfg==
X-Gm-Message-State: AOAM5302E9CwVJy3Mu+jdtlv1NV+4pp3zgkY9yAVBAc3czRgGXNwvqBU
        Q+c2TA+jVHgstyzUpitxcSqVzofDlwJQPN2PwQ4=
X-Google-Smtp-Source: ABdhPJw1kum+HVVPxo4z5O+2+keU5TVHzegjhOdv/MXYlBvb1cNIZErvrDWw4QikyKmRcJJ3vadXinWRYbVvz2min9Y=
X-Received: by 2002:a02:3c01:: with SMTP id m1mr1132388jaa.87.1615344155374;
 Tue, 09 Mar 2021 18:42:35 -0800 (PST)
MIME-Version: 1.0
References: <20210309031028.97385-1-xiangxia.m.yue@gmail.com>
 <CAKgT0UfZ0c4P4SMyCV9LAN=9PV=B6=0Ck+8jeZV4OxSGHnAuzg@mail.gmail.com> <CAMDZJNUobbEC0Z9Tu3jQcNu=Y-Fzzs2PpdZ-DE1v7TyMpc1R-w@mail.gmail.com>
In-Reply-To: <CAMDZJNUobbEC0Z9Tu3jQcNu=Y-Fzzs2PpdZ-DE1v7TyMpc1R-w@mail.gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 9 Mar 2021 18:42:24 -0800
Message-ID: <CAKgT0UfkP2baxP=dcNjrX3fr1Ti6s-Kt2Adh7oFRzgSNmdwDcg@mail.gmail.com>
Subject: Re: [PATCH] net: sock: simplify tw proto registration
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 9, 2021 at 5:48 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
>
> On Wed, Mar 10, 2021 at 1:39 AM Alexander Duyck
> <alexander.duyck@gmail.com> wrote:
> >
> > On Mon, Mar 8, 2021 at 7:15 PM <xiangxia.m.yue@gmail.com> wrote:
> > >
> > > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > >
> > > Introduce a new function twsk_prot_init, inspired by
> > > req_prot_init, to simplify the "proto_register" function.
> > >
> > > Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > > ---
> > >  net/core/sock.c | 44 ++++++++++++++++++++++++++++----------------
> > >  1 file changed, 28 insertions(+), 16 deletions(-)
> > >
> > > diff --git a/net/core/sock.c b/net/core/sock.c
> > > index 0ed98f20448a..610de4295101 100644
> > > --- a/net/core/sock.c
> > > +++ b/net/core/sock.c
> > > @@ -3475,6 +3475,32 @@ static int req_prot_init(const struct proto *prot)
> > >         return 0;
> > >  }
> > >
> > > +static int twsk_prot_init(const struct proto *prot)
> > > +{
> > > +       struct timewait_sock_ops *twsk_prot = prot->twsk_prot;
> > > +
> > > +       if (!twsk_prot)
> > > +               return 0;
> > > +
> > > +       twsk_prot->twsk_slab_name = kasprintf(GFP_KERNEL, "tw_sock_%s",
> > > +                                             prot->name);
> > > +       if (!twsk_prot->twsk_slab_name)
> > > +               return -ENOMEM;
> > > +
> > > +       twsk_prot->twsk_slab =
> > > +               kmem_cache_create(twsk_prot->twsk_slab_name,
> > > +                                 twsk_prot->twsk_obj_size, 0,
> > > +                                 SLAB_ACCOUNT | prot->slab_flags,
> > > +                                 NULL);
> > > +       if (!twsk_prot->twsk_slab) {
> > > +               pr_crit("%s: Can't create timewait sock SLAB cache!\n",
> > > +                       prot->name);
> > > +               return -ENOMEM;
> > > +       }
> > > +
> > > +       return 0;
> > > +}
> > > +
> >
> > So one issue here is that you have two returns but they both have the
> > same error clean-up outside of the function. It might make more sense
> > to look at freeing the kasprintf if the slab allocation fails and then
> > using the out_free_request_sock_slab jump label below if the slab
> > allocation failed.
> Hi, thanks for your review.
> if twsk_prot_init failed, (kasprintf, or slab alloc), we will invoke
> the tw_prot_cleanup() to clean up
> the sources allocated.
> 1. kfree(twsk_prot->twsk_slab_name); // if name is NULL, kfree() will
> return directly
> 2. kmem_cache_destroy(twsk_prot->twsk_slab); // if slab is NULL,
> kmem_cache_destroy() will return directly too.
> so we don't care what err in twsk_prot_init().
>
> and req_prot_cleanup() will clean up all sources allocated for req_prot_init().

I see. Okay so the expectation is that tw_prot_cleanup will take care
of a partially initialized timewait_sock_ops.

With that being the case the one change I would ask you to make would
be to look at moving the function up so it is just below
tw_prot_cleanup so it is obvious that the two are meant to be paired
rather than placing it after req_prot_init.

Otherwise the patch set itself looks good to me.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
