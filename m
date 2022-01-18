Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 201EA4912E8
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 01:36:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236099AbiARAgw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 19:36:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbiARAgw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 19:36:52 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A17DCC061574;
        Mon, 17 Jan 2022 16:36:51 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id q9-20020a7bce89000000b00349e697f2fbso1938729wmj.0;
        Mon, 17 Jan 2022 16:36:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MrV/5bhSCOAE/eZMpCGxQpdusce2IrkG903/Kn1QmA8=;
        b=o4H2sw2syQe5pwQjH/DoWx1sPXRznthZ2HsxPfzyOjMvoY1gwSzTUHTSJvwQsGFIHu
         LxYj8R81DVJNcxVCj86ZA/8haNNqHtmoBWke7568zUBWe7Rf9Q9Gj2c2w117EzGH+WgB
         o/BvvYvr3bBX1SXXPksTjTsvtSzQUop9NeeUMiNe7fqOrOm0UugtKOAAJP0UlOrOO992
         EyxiSmhBISD6Eh3GXbiysC8wEW06J63cChr9ETiOMqAnA16NMiPmiS7uPUXIuLdimsSi
         n8ufHJN4FhPtTg+ZjmlkeTZjMlk/kwezbwPd/lgGAzbluifDzoiOU9M0S7UB8PebgoKO
         w7qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MrV/5bhSCOAE/eZMpCGxQpdusce2IrkG903/Kn1QmA8=;
        b=4jp1NefOg7+H0Lvs7O/m2p7YOBl2OgJ608CmD+SGSX2eluj+hQhOrynJr4/ksNU1d3
         JciQLkX04/n4UPmP+n6Rfu0UajNaOVEAfoniOgBks+ale1FysrFdEDXB5tQ9uJkBfI3r
         qChAjI2IaJuy17fElOyqA1KbzZhJSLfHjboYrGAQKBiCoWxNbVC2PXw/YgWHRpdXLCW/
         mNWTmScYTyOtXQPlLlYxgcwyDyLi37cQTVyGgIrs29vAIwHK6B/10++szngOXbGP1r1K
         orWudHYO07+FnNAjaGC0HphE15bak0N8V1KlQt9juR2MDMhrpuHzEarSPeYK1rCysw24
         sYcA==
X-Gm-Message-State: AOAM531iKZuBKn5pKODIlxS373SdSJ1T8LFzbk3Uc4A+U4UN8QSH7qWf
        jihuQhII2ojEILcvK0U8gVAO+EWvpbZ6obTvai4=
X-Google-Smtp-Source: ABdhPJyZvLUNPEB6LCDJLsQG84xS7JMkP4t5c0tgKOONgVDbpLReDbkNuu+sq8E4cLOCN9DjsJXMYHKsUZQEzHvCg3w=
X-Received: by 2002:a05:6000:105:: with SMTP id o5mr16404069wrx.56.1642466210320;
 Mon, 17 Jan 2022 16:36:50 -0800 (PST)
MIME-Version: 1.0
References: <20220117115440.60296-1-miquel.raynal@bootlin.com>
 <20220117115440.60296-18-miquel.raynal@bootlin.com> <CAB_54W76X5vhaVMUv=s3e0pbWZgHRK3W=27N9m5LgEdLgAPAcA@mail.gmail.com>
In-Reply-To: <CAB_54W76X5vhaVMUv=s3e0pbWZgHRK3W=27N9m5LgEdLgAPAcA@mail.gmail.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Mon, 17 Jan 2022 19:36:39 -0500
Message-ID: <CAB_54W5Uu9_hpqmeL0MC+1ps=yfn2j0-o46cBL7BeBxKXKHa4w@mail.gmail.com>
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

On Mon, 17 Jan 2022 at 19:34, Alexander Aring <alex.aring@gmail.com> wrote:
>
> Hi,
>
> On Mon, 17 Jan 2022 at 06:55, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> >
> > ieee802154_xmit_complete() is the right helper to call when a
> > transmission is over. The fact that it completed or not is not really a
> > question, but drivers must tell the core that the completion is over,
> > even if it was canceled. Do not call ieee802154_wake_queue() manually,
> > in order to let full control of this task to the core.
> >
> > By using the complete helper we also avoid leacking the skb structure.
> >
> > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > ---
> >  drivers/net/ieee802154/at86rf230.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/ieee802154/at86rf230.c b/drivers/net/ieee802154/at86rf230.c
> > index 583f835c317a..1941e1f3d2ef 100644
> > --- a/drivers/net/ieee802154/at86rf230.c
> > +++ b/drivers/net/ieee802154/at86rf230.c
> > @@ -343,7 +343,7 @@ at86rf230_async_error_recover_complete(void *context)
> >         if (ctx->free)
> >                 kfree(ctx);
> >
> > -       ieee802154_wake_queue(lp->hw);
> > +       ieee802154_xmit_complete(lp->hw, lp->tx_skb, false);
>
> also this lp->tx_skb can be a dangled pointer, after xmit_complete()
> we need to set it to NULL in a xmit_error() we can check on NULL
> before calling kfree_skb().
>

forget the NULL checking, it's already done by core. However in some
cases this is called with a dangled pointer on lp->tx_skb.

- Alex
