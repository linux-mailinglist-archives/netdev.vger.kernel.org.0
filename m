Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D50672C4ADF
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 23:43:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727498AbgKYWms (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 17:42:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbgKYWms (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 17:42:48 -0500
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8852BC0617A7
        for <netdev@vger.kernel.org>; Wed, 25 Nov 2020 14:42:48 -0800 (PST)
Received: by mail-oi1-x242.google.com with SMTP id a130so92837oif.7
        for <netdev@vger.kernel.org>; Wed, 25 Nov 2020 14:42:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f1PVKlmL3TJCVAgQFKxha9czXUuPklpO8Bu1h8i+26E=;
        b=pgzp6Ubn73wNcMon0636wnyvAsgppUo+gylhtax9SBZH+rcaRux/E8k5+Htq31MOge
         NiT6nl8LnC2tL8IFTlEguF/d1YfWTCmiaa+pIFZV0Zwh7V3tZFToKAD7eHeydIIOJNAC
         QYOii5xqrCTk53KBGZueOL54HygtYTbWbanIPg85eJpwE+3TS4fl6gzlY211aSn4b5ze
         MMNTy6ODNQlW28WZqAA88/tsYiCkAYm2jckjUoYaknkq7g3CPvhiNbreiGj3gZACdQFf
         N8n1Hb2Ri/whDV7kZorFWlDPiWOAO8y8gWNUpccTRY2+uwQY2aOOtKkbq3z9qLo+IMgF
         EU0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f1PVKlmL3TJCVAgQFKxha9czXUuPklpO8Bu1h8i+26E=;
        b=lXVNiToeZwOp8y+k9w068gtxaNatNXmWGHLo6ykxB3MDvwgmclwDWZ3DGa3RACHtPY
         XDix/2kYGGCbjw6dE2AM21MU0j2N7tBKlSYWhIF++rTmdWshCQUTB+Y+gm1zNgHQ7EWu
         1YxYnwMZub5ECZugI8c3ru6ii/v/5IWO2qxJP+/SVeKLPzPscVgkG4BMQUoktfVtIQQ6
         NUtaHptEDAJdlB/UmASsfPEwMybRGeVlI1dgZ0G5dIxWscwDYNYH9AloB/WEfx5/RlNl
         lCgiHt3AfVgtcL6p3Dd+hJuuLmXF1fumSSv89XgrQvFrR7eozfZA7W3kj0CmHi+AU40I
         7OPQ==
X-Gm-Message-State: AOAM530eOqbGf3cpucFFqHXdtewIkUPgXoJ5aVtNbro9iOCI5ny8TTxR
        5qBNjqeE6/ijj1+JZ5qqXa/QEXjXSFBMCZ3zUSzHtw==
X-Google-Smtp-Source: ABdhPJzjRavk1ufBlUCV/33Hy2qhC9jbb5v2ICAvB39VW9s28siNQGRRZK3BZNFBatp0GwI71EKJMH66vO3HMZoutgg=
X-Received: by 2002:a54:4394:: with SMTP id u20mr245293oiv.70.1606344167711;
 Wed, 25 Nov 2020 14:42:47 -0800 (PST)
MIME-Version: 1.0
References: <20201125173436.1894624-1-elver@google.com> <20201125124313.593fc2b5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201125124313.593fc2b5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Marco Elver <elver@google.com>
Date:   Wed, 25 Nov 2020 23:42:36 +0100
Message-ID: <CANpmjNP_=Awx0-eZisMXzgXxKqf7hcrZYCYzFXuebPcwZtkoLw@mail.gmail.com>
Subject: Re: [PATCH net-next] net: switch to storing KCOV handle directly in sk_buff
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Aleksandr Nogikh <a.nogikh@gmail.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
        Ido Schimmel <idosch@idosch.org>,
        Florian Westphal <fw@strlen.de>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 25 Nov 2020 at 21:43, Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 25 Nov 2020 18:34:36 +0100 Marco Elver wrote:
> > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > index ffe3dcc0ebea..070b1077d976 100644
> > --- a/net/core/skbuff.c
> > +++ b/net/core/skbuff.c
> > @@ -233,6 +233,7 @@ struct sk_buff *__alloc_skb(unsigned int size, gfp_t gfp_mask,
> >       skb->end = skb->tail + size;
> >       skb->mac_header = (typeof(skb->mac_header))~0U;
> >       skb->transport_header = (typeof(skb->transport_header))~0U;
> > +     skb_set_kcov_handle(skb, kcov_common_handle());
> >
> >       /* make sure we initialize shinfo sequentially */
> >       shinfo = skb_shinfo(skb);
> > @@ -249,9 +250,6 @@ struct sk_buff *__alloc_skb(unsigned int size, gfp_t gfp_mask,
> >
> >               fclones->skb2.fclone = SKB_FCLONE_CLONE;
> >       }
> > -
> > -     skb_set_kcov_handle(skb, kcov_common_handle());
>
> Why the move?

v2 of the original series had it above. I frankly don't mind.

1. Group it with the other fields above?

2. Leave it at the end here?

> >  out:
> >       return skb;
> >  nodata:
> > @@ -285,8 +283,6 @@ static struct sk_buff *__build_skb_around(struct sk_buff *skb,
> >       memset(shinfo, 0, offsetof(struct skb_shared_info, dataref));
> >       atomic_set(&shinfo->dataref, 1);
> >
> > -     skb_set_kcov_handle(skb, kcov_common_handle());
> > -
> >       return skb;
> >  }
>
> And why are we dropping this?

It wasn't here originally.

> If this was omitted in earlier versions it's just a independent bug,
> I don't think build_skb() will call __alloc_skb(), so we need a to
> set the handle here.

Correct, that was an original omission.

Will send v2.
