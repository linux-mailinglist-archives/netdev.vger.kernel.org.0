Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A82CC49760D
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 23:41:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240380AbiAWWlP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jan 2022 17:41:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbiAWWlO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jan 2022 17:41:14 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48419C06173B;
        Sun, 23 Jan 2022 14:41:14 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id az25so10288111wrb.6;
        Sun, 23 Jan 2022 14:41:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IsqIbMDd5aaqsqLJQ1D8We/a2bZGm3Czx6yZQ+dhnIc=;
        b=JL8f4iRvyqr7CzCdse/pUJgEQLobod/nuMpJkUs4dGhB79osyhaqlb7auAM4wQwmq6
         k9Ky/3e666euEYrK+5ImJrnSjlF0HFLvmIO2po8efIPCqGsgKcVBoc7sayy43hV2Hj8A
         ifRuNP+rAK4SURdev5jvQmpifI0rLzqCBVuWtwaNlU4tnO0DWSDE3Mf2f5bHkISmStIc
         qet82NqYzrZpUvWfg2jHMS7OfLu8PJbhq+L+9/xZkWumpQTagATwbs6H+JQUxCF4rRhv
         ucS7i72oHQU9a/WyA6WktHd5PVHoJ3ql2V5jM2zCioZgy6Pmh6HLQuGXttuzuNeDECfb
         GMBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IsqIbMDd5aaqsqLJQ1D8We/a2bZGm3Czx6yZQ+dhnIc=;
        b=05NbYwCoo9kyOMn2ryjuc3lHtIP8M9BEhlhxVFIV/U/+5c3v1o2wadr8FKL1pEkvvx
         crjw6mIk6/paLqmFfF0bIzQGv8l7dyPxPVuqfQNfjv/gG02vjWOdI1kc5Es75GOYmDVB
         NSQ0E6QgA06SVXeOxTUAFxwvUopYTQIDtmxlpRvjWy6bwjiSiauRiIXzSfdju5VyFM9A
         QgOdE1r1/6blJHF+huPouDjWCEY9pRkb+bPzKb4RwmeJTJU2t2MuCdlXq9/4vPhMtIXq
         c3skV17/ldjcbhx3RfFgGkQO4jGvqhG/H0wOyV0Ctq03F7aZZbHEMIBvy0x5IauKDhFq
         acQg==
X-Gm-Message-State: AOAM533uCtfjW+icm0vn6sfxy8dqQioiWDSHHuoZatpB+R8tAmHa2HQq
        P4onRUeXGwuYxpjteRzF1B+1MJOp1vNg3XK5e3o=
X-Google-Smtp-Source: ABdhPJx4cRrTdvADRI7ih5bqJbb01y1Zj113j54VEUAs31gmokRLHfCnw/aNv7+mDt9nVUVAvckTRZ/ryVczFBFWofI=
X-Received: by 2002:a05:6000:168f:: with SMTP id y15mr1893855wrd.205.1642977672842;
 Sun, 23 Jan 2022 14:41:12 -0800 (PST)
MIME-Version: 1.0
References: <20220120112115.448077-1-miquel.raynal@bootlin.com>
 <20220120112115.448077-5-miquel.raynal@bootlin.com> <CAB_54W721DFUw+qu6_UR58GFvjLxshmxiTE0DX-DNNY-XLskoQ@mail.gmail.com>
In-Reply-To: <CAB_54W721DFUw+qu6_UR58GFvjLxshmxiTE0DX-DNNY-XLskoQ@mail.gmail.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Sun, 23 Jan 2022 17:41:01 -0500
Message-ID: <CAB_54W4qLJQhPYY1h-88VK7n554SdtY9CLF3U5HLR6QS4i4tNA@mail.gmail.com>
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

On Sun, 23 Jan 2022 at 15:43, Alexander Aring <alex.aring@gmail.com> wrote:
>
> Hi,
>
> On Thu, 20 Jan 2022 at 06:21, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> >
> > Upon error the ieee802154_xmit_complete() helper is not called. Only
> > ieee802154_wake_queue() is called manually. We then leak the skb
> > structure.
> >
> > Free the skb structure upon error before returning.
> >
> > There is no Fixes tag applying here, many changes have been made on this
> > area and the issue kind of always existed.
> >
> > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > ---
> >  drivers/net/ieee802154/at86rf230.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/drivers/net/ieee802154/at86rf230.c b/drivers/net/ieee802154/at86rf230.c
> > index 7d67f41387f5..0746150f78cf 100644
> > --- a/drivers/net/ieee802154/at86rf230.c
> > +++ b/drivers/net/ieee802154/at86rf230.c
> > @@ -344,6 +344,7 @@ at86rf230_async_error_recover_complete(void *context)
> >                 kfree(ctx);
> >
> >         ieee802154_wake_queue(lp->hw);
> > +       dev_kfree_skb_any(lp->tx_skb);
>
> as I said in other mails there is more broken, we need a:
>
> if (lp->is_tx) {
>         ieee802154_wake_queue(lp->hw);
>         dev_kfree_skb_any(lp->tx_skb);
>         lp->is_tx = 0;
> }
>
> in at86rf230_async_error_recover().
>
s/at86rf230_async_error_recover/at86rf230_async_error_recover_complete/

move the is_tx = 0 out of at86rf230_async_error_recover().

- Alex
