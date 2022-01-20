Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 263F1494436
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 01:19:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357751AbiATATt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 19:19:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357737AbiATATs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 19:19:48 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3200CC061574;
        Wed, 19 Jan 2022 16:19:48 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id az27-20020a05600c601b00b0034d2956eb04so9469905wmb.5;
        Wed, 19 Jan 2022 16:19:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dodQjANZ5PCXc+ytYjE2SatA6sQLbldj+/e4HCBmgYI=;
        b=HCoNj7X+OsAVv3LrWzwNq/f5rzxja0Cdjbcdzc1dpWFsBxOA067MGaCEgPzkFvZFaG
         jKqt+v0qH1K8gv+PssqTAAyefB/578uEXkfnoNG37yYFdLydN38lOXJ8LTdEXnR5r3VV
         hEWgdN3CvqU+2htvYtI0bdIDaYhrL61Jlxg7LNWoukYDcmuhEuTVoAEnpNjIVPcXRWQ7
         MPv4JZLTAbzfpNj5xVtOF+zU+QMZLG4VMSATflgYGo9M0pix9EHqMs8yEFpaqFEKSyP4
         KraC3YCp4JVnFAdFOi5GTzbxOP1B3kjARS/lyF1b+7hyOywrB3wwU+7SpI/hNWl5ODzN
         PliA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dodQjANZ5PCXc+ytYjE2SatA6sQLbldj+/e4HCBmgYI=;
        b=qk59BkD5p9mTE4e90tHaGAxcBf72Y4xTm/0Xob/HMMG8O/q65n78jcRxUSHo+gDu6+
         7pm+8k5ZWsGf3JHpz6hwSEVBAocHoJjq4gl6zH2lNY7cyFU1+CAcnyOnMRu5HexZ9kQB
         6+y7qseqtrR649zjkrXKQPmsGDtDgsDmQVq9e18cbk0OhuPcfekplqnaSlIk7bREZPdM
         NwWwwK++xeiMg7dHwVIb6WVOs8KjggX7KyvPnb6qtnD+wnooSnsYmXuR/LXOiXaxJiJr
         3QivMmkPfqnpkr0BIjrbWgvRigXZEmBxh4pwmF35ALlf6XLxlhYT6R3wr7Fzw0Y77Pfe
         Yizw==
X-Gm-Message-State: AOAM532oPXU4qSdq+rFIRqD/m/ANEFaggXlgt7Rt6AoNM9fChhqzuxNL
        RzFaJs1cZm0PWi50XQhEt0IYJD6Pf3qZAD6L6Sc=
X-Google-Smtp-Source: ABdhPJwqBbPwglKHGNlmDRPClR61u0jJdWV90on3kVCoJ3LdBKVXl1imW6IpA8LKWXBM0ZIrv5FZrA9p4rVcHC9Veoo=
X-Received: by 2002:adf:fa8d:: with SMTP id h13mr7973400wrr.154.1642637986835;
 Wed, 19 Jan 2022 16:19:46 -0800 (PST)
MIME-Version: 1.0
References: <20220117115440.60296-1-miquel.raynal@bootlin.com>
 <20220117115440.60296-18-miquel.raynal@bootlin.com> <CAB_54W76X5vhaVMUv=s3e0pbWZgHRK3W=27N9m5LgEdLgAPAcA@mail.gmail.com>
 <CAB_54W5Uu9_hpqmeL0MC+1ps=yfn2j0-o46cBL7BeBxKXKHa4w@mail.gmail.com>
 <20220119235600.48173f5b@xps13> <CAB_54W4Dy13=EMD0ZEvwX6HLC3bM=nAp0esqDXBj9T+9Jjd_aw@mail.gmail.com>
In-Reply-To: <CAB_54W4Dy13=EMD0ZEvwX6HLC3bM=nAp0esqDXBj9T+9Jjd_aw@mail.gmail.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Wed, 19 Jan 2022 19:19:35 -0500
Message-ID: <CAB_54W7Cs8=zBokk_ka-LWAOoSQy-M-aHxn5kjCckfO5EqQGJg@mail.gmail.com>
Subject: Re: [PATCH v3 17/41] net: ieee802154: at86rf230: Call the complete
 helper when a transmission is over
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org Wireless" 
        <linux-wireless@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Xue Liu <liuxuenetmail@gmail.com>, Alan Ott <alan@signal11.us>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, 19 Jan 2022 at 18:34, Alexander Aring <alex.aring@gmail.com> wrote:
>
> Hi,
>
> On Wed, 19 Jan 2022 at 17:56, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> >
> > Hi Alexander,
> >
> > alex.aring@gmail.com wrote on Mon, 17 Jan 2022 19:36:39 -0500:
> >
> > > Hi,
> > >
> > > On Mon, 17 Jan 2022 at 19:34, Alexander Aring <alex.aring@gmail.com> wrote:
> > > >
> > > > Hi,
> > > >
> > > > On Mon, 17 Jan 2022 at 06:55, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > > > >
> > > > > ieee802154_xmit_complete() is the right helper to call when a
> > > > > transmission is over. The fact that it completed or not is not really a
> > > > > question, but drivers must tell the core that the completion is over,
> > > > > even if it was canceled. Do not call ieee802154_wake_queue() manually,
> > > > > in order to let full control of this task to the core.
> > > > >
> > > > > By using the complete helper we also avoid leacking the skb structure.
> > > > >
> > > > > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > > > > ---
> > > > >  drivers/net/ieee802154/at86rf230.c | 2 +-
> > > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > >
> > > > > diff --git a/drivers/net/ieee802154/at86rf230.c b/drivers/net/ieee802154/at86rf230.c
> > > > > index 583f835c317a..1941e1f3d2ef 100644
> > > > > --- a/drivers/net/ieee802154/at86rf230.c
> > > > > +++ b/drivers/net/ieee802154/at86rf230.c
> > > > > @@ -343,7 +343,7 @@ at86rf230_async_error_recover_complete(void *context)
> > > > >         if (ctx->free)
> > > > >                 kfree(ctx);
> > > > >
> > > > > -       ieee802154_wake_queue(lp->hw);
> > > > > +       ieee802154_xmit_complete(lp->hw, lp->tx_skb, false);
> > > >
> > > > also this lp->tx_skb can be a dangled pointer, after xmit_complete()
> > > > we need to set it to NULL in a xmit_error() we can check on NULL
> > > > before calling kfree_skb().
> > > >
> > >
> > > forget the NULL checking, it's already done by core. However in some
> > > cases this is called with a dangled pointer on lp->tx_skb.
> >
> > Actually I don't see why tx_skb is dangling?
> >
> > There is no function that could accesses lp->tx_skb between the free
> > operation and the next call to ->xmit() which does a lp->tx_skb = skb.
> > Am I missing something?
> >
>
> look into at86rf230_sync_state_change() it is a sync over async and
> the function "at86rf230_async_error_recover_complete()" is a generic
> error handling to recover from a state change. It's e.g. being used in
> e.g. at86rf230_start() which can occur in cases which are not xmit
> related.
>

which means there is more being broken that we should not simply call
to wake the queue in non-transmit cases...

- Alex
