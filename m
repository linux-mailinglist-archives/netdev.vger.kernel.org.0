Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EBDE336A3B
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 03:45:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbhCKCoc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 21:44:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbhCKCoS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 21:44:18 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B790DC061574
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 18:44:17 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id hs11so43144571ejc.1
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 18:44:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CAY+OkkUGdpcXDDv2Ao+AVQr0Ke3pNn8k7IYf4mcN0w=;
        b=F1nxexVAcAykoB9k/zmpktXWfT7d1DBMUkKalEe1sRsQCOmr57fxQ6UMeBMMezdlIB
         FxiNXIGhbHQt8kGHjbuCpWShssQlebt8+a09aeKPBbZhmMUR4XVrTYG5OhmyXsZwShoH
         82xND1DUepYrDq54K9YkqsQONV3Tvfv49Jcx4T5Isrs/JpLsTERyaWyCZ85ZaFIANMV4
         SJTpH9m1brj9awuFKFVAndCUgkRWlR/HOuj+2YMI+SKyCyjOkvMCOPMTsDsWDByUemnz
         mybt+Ngg7vNKyaAipKS/gWpuFL1ADvMOfxncSzlHJBE+mOXtJ2jOObzUjadEjIhdu+rQ
         +JVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CAY+OkkUGdpcXDDv2Ao+AVQr0Ke3pNn8k7IYf4mcN0w=;
        b=bFVdhX92jObf82vuUznPANUfrQKN4JgS/Hu9WRgQovtMsqcQFs2HEU+UdSUcqJdqgO
         FZU3plBVOoSUMDC9G+0hLLZ9ieI2VzFnq2EG8NNgIJ1J3ovhZ/iXwLMplPZmAYoBr0VT
         /uLTcmymw0XDQhiPXOYJHFskBe6HsDws7wn7UaDGRNegyvA86hqYPYu/jvYJR9xPEho3
         nEir6q1qy++6vh92SVLvm2GeSe2dHbUPv1asuiTEjYLulxFFwBQGk6josAcrvnFvvRDK
         jhA9q0fRZIvvMfIUP+exzOo0JQ5NtCXopMQzP2eWklzdDdUS3pe+uq+oEulWXu+plkjj
         ZfYw==
X-Gm-Message-State: AOAM5305OS9yDSp6OdOlMwxnLasXWbKAepyl/azvk+PH0/PMEu6zJ5OA
        O07AupXURKAsaS85MibPCRivJEmeR3v5apDTjyk=
X-Google-Smtp-Source: ABdhPJzM6QmcH73tMirBTOAtFqb68iEXklxfjNujLpvSuforyJTE3xZi5P0j2Aw8WFg34YI7PZEfNtePAs5JhBEd0To=
X-Received: by 2002:a17:907:3e8b:: with SMTP id hs11mr866473ejc.117.1615430656345;
 Wed, 10 Mar 2021 18:44:16 -0800 (PST)
MIME-Version: 1.0
References: <20210309031028.97385-1-xiangxia.m.yue@gmail.com>
 <CAKgT0UfZ0c4P4SMyCV9LAN=9PV=B6=0Ck+8jeZV4OxSGHnAuzg@mail.gmail.com>
 <CAMDZJNUobbEC0Z9Tu3jQcNu=Y-Fzzs2PpdZ-DE1v7TyMpc1R-w@mail.gmail.com> <CAKgT0UfkP2baxP=dcNjrX3fr1Ti6s-Kt2Adh7oFRzgSNmdwDcg@mail.gmail.com>
In-Reply-To: <CAKgT0UfkP2baxP=dcNjrX3fr1Ti6s-Kt2Adh7oFRzgSNmdwDcg@mail.gmail.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Thu, 11 Mar 2021 10:40:09 +0800
Message-ID: <CAMDZJNV+Afo7Y64U31=scgxcvvUVuQ1YvvZ_QMK3mpJ9LQn2ig@mail.gmail.com>
Subject: Re: [PATCH] net: sock: simplify tw proto registration
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 10, 2021 at 10:42 AM Alexander Duyck
<alexander.duyck@gmail.com> wrote:
>
> On Tue, Mar 9, 2021 at 5:48 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
> >
> > On Wed, Mar 10, 2021 at 1:39 AM Alexander Duyck
> > <alexander.duyck@gmail.com> wrote:
> > >
> > > On Mon, Mar 8, 2021 at 7:15 PM <xiangxia.m.yue@gmail.com> wrote:
> > > >
> > > > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > > >
> > > > Introduce a new function twsk_prot_init, inspired by
> > > > req_prot_init, to simplify the "proto_register" function.
> > > >
> > > > Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > > > ---
> > > >  net/core/sock.c | 44 ++++++++++++++++++++++++++++----------------
> > > >  1 file changed, 28 insertions(+), 16 deletions(-)
> > > >
> > > > diff --git a/net/core/sock.c b/net/core/sock.c
> > > > index 0ed98f20448a..610de4295101 100644
> > > > --- a/net/core/sock.c
> > > > +++ b/net/core/sock.c
> > > > @@ -3475,6 +3475,32 @@ static int req_prot_init(const struct proto *prot)
> > > >         return 0;
> > > >  }
> > > >
> > > > +static int twsk_prot_init(const struct proto *prot)
> > > > +{
> > > > +       struct timewait_sock_ops *twsk_prot = prot->twsk_prot;
> > > > +
> > > > +       if (!twsk_prot)
> > > > +               return 0;
> > > > +
> > > > +       twsk_prot->twsk_slab_name = kasprintf(GFP_KERNEL, "tw_sock_%s",
> > > > +                                             prot->name);
> > > > +       if (!twsk_prot->twsk_slab_name)
> > > > +               return -ENOMEM;
> > > > +
> > > > +       twsk_prot->twsk_slab =
> > > > +               kmem_cache_create(twsk_prot->twsk_slab_name,
> > > > +                                 twsk_prot->twsk_obj_size, 0,
> > > > +                                 SLAB_ACCOUNT | prot->slab_flags,
> > > > +                                 NULL);
> > > > +       if (!twsk_prot->twsk_slab) {
> > > > +               pr_crit("%s: Can't create timewait sock SLAB cache!\n",
> > > > +                       prot->name);
> > > > +               return -ENOMEM;
> > > > +       }
> > > > +
> > > > +       return 0;
> > > > +}
> > > > +
> > >
> > > So one issue here is that you have two returns but they both have the
> > > same error clean-up outside of the function. It might make more sense
> > > to look at freeing the kasprintf if the slab allocation fails and then
> > > using the out_free_request_sock_slab jump label below if the slab
> > > allocation failed.
> > Hi, thanks for your review.
> > if twsk_prot_init failed, (kasprintf, or slab alloc), we will invoke
> > the tw_prot_cleanup() to clean up
> > the sources allocated.
> > 1. kfree(twsk_prot->twsk_slab_name); // if name is NULL, kfree() will
> > return directly
> > 2. kmem_cache_destroy(twsk_prot->twsk_slab); // if slab is NULL,
> > kmem_cache_destroy() will return directly too.
> > so we don't care what err in twsk_prot_init().
> >
> > and req_prot_cleanup() will clean up all sources allocated for req_prot_init().
>
> I see. Okay so the expectation is that tw_prot_cleanup will take care
> of a partially initialized timewait_sock_ops.
>
> With that being the case the one change I would ask you to make would
> be to look at moving the function up so it is just below
> tw_prot_cleanup so it is obvious that the two are meant to be paired
> rather than placing it after req_prot_init.
Thanks, will be changed in v2
and change the new function name from twsk_prot_init to tw_prot_init
(tw_prot_cleanup).

> Otherwise the patch set itself looks good to me.
>
> Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>



-- 
Best regards, Tonghao
