Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8F432C5957
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 17:35:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391515AbgKZQfE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 11:35:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391313AbgKZQfD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 11:35:03 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 489D2C0613D4;
        Thu, 26 Nov 2020 08:35:02 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id v22so2879286edt.9;
        Thu, 26 Nov 2020 08:35:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cLJC49DM7irMLB8tvOHo0nrjZ03EmHHFDbP2GkwhlpM=;
        b=FmcG0v615Ug1f4qMO6FIEc6oaM6tvhkwbOVx/xO8ggAeW7uPbXwPPPoYeq+y+2vfF0
         fqyw9ucP9i20jrp/BlWOvKsng3Mmoz4lPpcvUplGIm0VxJh0c6rBmxzierb6UuADiPhO
         LpS3LNOOFlkazkRYZDDqc02eq7Je0Iuo8oEHGUoZ5pYccH++ZS2qo/5rHROFWrNCphzp
         crdp7xUqlnPBb95CcDyLO712q8Tr3pBNwGYp62I1ILD5uKf/YQTsrg7FcX0V0bHCDKl3
         PF8G1OiN9mmWN3w4xz1CSXDUhbsXdlHACBMbHpNkYY3wBf/BSw1fCoqIc9XW9TnpUtmK
         3Q3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cLJC49DM7irMLB8tvOHo0nrjZ03EmHHFDbP2GkwhlpM=;
        b=Ui4vmh27PUC30/o9fzN3WxREICq1N9hc3ZRczTjPzs2I1CPOsY+TfhacwtXxIncgOV
         9+XG9JO1A5PNTnWpHpXaQsdiGHYgowfCzi3XoVGpQpCtVtfdEIQnkJ71gf+2cPIADGfv
         rqUvS9JqrSZBD40RneYZAYom9kxDcmml7eaKszgX9DaoN3e7++UjwSpaN/xb5wwuI8EM
         3EAQfAXSr2YaqsfjkYpwTrnNk0/paqsVRZrChiRgStmscCw7U5o4WCxSHJEEQhKSwB2O
         wk6bwHmfG5CICLN3eRrt8Pque/NJp58/3ARjwlvOym4PHXNVmZtFOq308Jej9QTjNOOx
         pHZw==
X-Gm-Message-State: AOAM5329KxqX4y7C83hdWngXLNRi5MW4EmmA5xf5u1Z04bwHgWCKqDfX
        XJugLe2QvZgityCmaHcja7szecoHODX8OUaJJ9Q=
X-Google-Smtp-Source: ABdhPJzDk24ilN02bkv2jEMVbLDYSXRgINgdZIeMmQi+0j8aSktU8o7+dCsOnXEEtoDl2+IprSSOvgr84ddmo2kLSJA=
X-Received: by 2002:a50:8a9c:: with SMTP id j28mr3383337edj.254.1606408501022;
 Thu, 26 Nov 2020 08:35:01 -0800 (PST)
MIME-Version: 1.0
References: <20201125173436.1894624-1-elver@google.com> <20201125124313.593fc2b5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CANpmjNP_=Awx0-eZisMXzgXxKqf7hcrZYCYzFXuebPcwZtkoLw@mail.gmail.com>
In-Reply-To: <CANpmjNP_=Awx0-eZisMXzgXxKqf7hcrZYCYzFXuebPcwZtkoLw@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 26 Nov 2020 11:34:25 -0500
Message-ID: <CAF=yD-JtRUjmy+12kTL=YY8Cfi_c92GVbHZ647smWmasLYiNMg@mail.gmail.com>
Subject: Re: [PATCH net-next] net: switch to storing KCOV handle directly in sk_buff
To:     Marco Elver <elver@google.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Aleksandr Nogikh <a.nogikh@gmail.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Ido Schimmel <idosch@idosch.org>,
        Florian Westphal <fw@strlen.de>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 26, 2020 at 3:19 AM Marco Elver <elver@google.com> wrote:
>
> On Wed, 25 Nov 2020 at 21:43, Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Wed, 25 Nov 2020 18:34:36 +0100 Marco Elver wrote:
> > > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > > index ffe3dcc0ebea..070b1077d976 100644
> > > --- a/net/core/skbuff.c
> > > +++ b/net/core/skbuff.c
> > > @@ -233,6 +233,7 @@ struct sk_buff *__alloc_skb(unsigned int size, gfp_t gfp_mask,
> > >       skb->end = skb->tail + size;
> > >       skb->mac_header = (typeof(skb->mac_header))~0U;
> > >       skb->transport_header = (typeof(skb->transport_header))~0U;
> > > +     skb_set_kcov_handle(skb, kcov_common_handle());
> > >
> > >       /* make sure we initialize shinfo sequentially */
> > >       shinfo = skb_shinfo(skb);
> > > @@ -249,9 +250,6 @@ struct sk_buff *__alloc_skb(unsigned int size, gfp_t gfp_mask,
> > >
> > >               fclones->skb2.fclone = SKB_FCLONE_CLONE;
> > >       }
> > > -
> > > -     skb_set_kcov_handle(skb, kcov_common_handle());
> >
> > Why the move?
>
> v2 of the original series had it above. I frankly don't mind.
>
> 1. Group it with the other fields above?
>
> 2. Leave it at the end here?
>
> > >  out:
> > >       return skb;
> > >  nodata:
> > > @@ -285,8 +283,6 @@ static struct sk_buff *__build_skb_around(struct sk_buff *skb,
> > >       memset(shinfo, 0, offsetof(struct skb_shared_info, dataref));
> > >       atomic_set(&shinfo->dataref, 1);
> > >
> > > -     skb_set_kcov_handle(skb, kcov_common_handle());
> > > -
> > >       return skb;
> > >  }
> >
> > And why are we dropping this?
>
> It wasn't here originally.
>
> > If this was omitted in earlier versions it's just a independent bug,
> > I don't think build_skb() will call __alloc_skb(), so we need a to
> > set the handle here.
>
> Correct, that was an original omission.
>
> Will send v2.

Does it make more sense to revert the patch that added the extensions
and the follow-on fixes and add a separate new patch instead?

If adding a new field to the skb, even if only in debug builds,
please check with pahole how it affects struct layout if you
haven't yet.

The skb_extensions idea was mine. Apologies for steering
this into an apparently unsuccessful direction. Adding new fields
to skb is very rare because possibly problematic wrt allocation.
