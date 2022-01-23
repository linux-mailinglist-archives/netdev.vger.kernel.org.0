Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A68849764B
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 00:14:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240396AbiAWXO0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jan 2022 18:14:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230242AbiAWXOZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jan 2022 18:14:25 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27058C06173B;
        Sun, 23 Jan 2022 15:14:25 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id ba4so10346646wrb.4;
        Sun, 23 Jan 2022 15:14:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pEDDP0XpkbFXXQWc38dssQCZ3q41KV2wRDYR5r7oy+s=;
        b=MrHCskx6bDdxn9y40t6otV3lUcOJcB303r9BLR5ZBH7uv5X0tOI9vKTALUotbHpKrO
         EduqYM52kbznfJ/Ax4iz2G5bbwVbzRK0TCvUy8RGxs8jlZuLQMPgQAl3B9cOlisEvxS8
         ipvlk2+TZniohZKKkLOKIjPtMUmvylDZfAUElHABKcSRabkODWBgcB3T2GS+c1oDBuk9
         MZOK73/NdAHcugPcXQE8RFPu1nvTST20L6cs8+iNawT4m2ole4d6NV47+YDZP6dnP+Vr
         1aqrYoTaeTMcGGfOw89iSq2GDUYt25J0DF5fG65Ff1IMgreXbkEqPPau3nKvG/JXXnBu
         aXug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pEDDP0XpkbFXXQWc38dssQCZ3q41KV2wRDYR5r7oy+s=;
        b=vfs8zzZNv9TAbe4HSeqHhkdtXopSI5w2q1KXEuejRw1D/S81dCzKBZjToDXZ6jTaOc
         FyCgbonh5Lfy/ArjdS55FLgT3UFqLAkoTPiVSxs/LskHr9lsFHT5/Xk8gPj/k29qaVZT
         zMZYm3P9tO8itNyVuMP72KwTIzNrtK/pg1dryNUts+p74lRrUlBNOtUHaIds8vN+t3Et
         cxQLMBS1v7Nr4b8mxS+9XwNaIScMYKk+QmPPNzjmLLJQSiWYaglzF38sTlw5q+ndsOHN
         mqBg2oIw2FeR803L5LUxchaIEIjyumNQR8/ZHICYKlZT2zrtgbMfYyqveczuBvO57dYc
         4dmQ==
X-Gm-Message-State: AOAM533IVTFDRrCXU7mrfViuig6kSYiA3GMnLv96IOaeT+xezX5tcjTO
        Zc4UhO3F27l7o1kvTZHckI3EpPW69zdz6ACRALQ=
X-Google-Smtp-Source: ABdhPJwpx6cq3n3oo+ROTRzhLp263Eyjw6sTk7gT4dTf1PJksWIxvKJBHAsAEKlfPH56i0xFlO096F6TfkQDzPkSQw8=
X-Received: by 2002:a05:6000:18ac:: with SMTP id b12mr1729330wri.81.1642979663702;
 Sun, 23 Jan 2022 15:14:23 -0800 (PST)
MIME-Version: 1.0
References: <20220120112115.448077-1-miquel.raynal@bootlin.com>
 <20220120112115.448077-5-miquel.raynal@bootlin.com> <CAB_54W721DFUw+qu6_UR58GFvjLxshmxiTE0DX-DNNY-XLskoQ@mail.gmail.com>
 <CAB_54W4qLJQhPYY1h-88VK7n554SdtY9CLF3U5HLR6QS4i4tNA@mail.gmail.com>
In-Reply-To: <CAB_54W4qLJQhPYY1h-88VK7n554SdtY9CLF3U5HLR6QS4i4tNA@mail.gmail.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Sun, 23 Jan 2022 18:14:12 -0500
Message-ID: <CAB_54W6GLqY69D=kmjiGCaVHh1+vjKp8OtdS77Nu-bZRqELjNw@mail.gmail.com>
Subject: Re: [wpan-next v2 4/9] net: ieee802154: at86rf230: Stop leaking skb's
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Xue Liu <liuxuenetmail@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Harry Morris <harrymorris12@gmail.com>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Sun, 23 Jan 2022 at 17:41, Alexander Aring <alex.aring@gmail.com> wrote:
>
> Hi,
>
> On Sun, 23 Jan 2022 at 15:43, Alexander Aring <alex.aring@gmail.com> wrote:
> >
> > Hi,
> >
> > On Thu, 20 Jan 2022 at 06:21, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > >
> > > Upon error the ieee802154_xmit_complete() helper is not called. Only
> > > ieee802154_wake_queue() is called manually. We then leak the skb
> > > structure.
> > >
> > > Free the skb structure upon error before returning.
> > >
> > > There is no Fixes tag applying here, many changes have been made on this
> > > area and the issue kind of always existed.
> > >
> > > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > > ---
> > >  drivers/net/ieee802154/at86rf230.c | 1 +
> > >  1 file changed, 1 insertion(+)
> > >
> > > diff --git a/drivers/net/ieee802154/at86rf230.c b/drivers/net/ieee802154/at86rf230.c
> > > index 7d67f41387f5..0746150f78cf 100644
> > > --- a/drivers/net/ieee802154/at86rf230.c
> > > +++ b/drivers/net/ieee802154/at86rf230.c
> > > @@ -344,6 +344,7 @@ at86rf230_async_error_recover_complete(void *context)
> > >                 kfree(ctx);
> > >
> > >         ieee802154_wake_queue(lp->hw);
> > > +       dev_kfree_skb_any(lp->tx_skb);
> >
> > as I said in other mails there is more broken, we need a:
> >
> > if (lp->is_tx) {
> >         ieee802154_wake_queue(lp->hw);
> >         dev_kfree_skb_any(lp->tx_skb);
> >         lp->is_tx = 0;
> > }
> >
> > in at86rf230_async_error_recover().
> >
> s/at86rf230_async_error_recover/at86rf230_async_error_recover_complete/
>
> move the is_tx = 0 out of at86rf230_async_error_recover().

Sorry, still seeing an issue here.

We cannot move is_tx = 0 out of at86rf230_async_error_recover()
because switching to RX_AACK_ON races with a new interrupt and is_tx
is not correct anymore. We need something new like "was_tx" to
remember that it was a tx case for the error handling in
at86rf230_async_error_recover_complete().

- Alex
