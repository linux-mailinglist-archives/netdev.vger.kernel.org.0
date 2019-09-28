Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD552C121F
	for <lists+netdev@lfdr.de>; Sat, 28 Sep 2019 22:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728655AbfI1U0W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Sep 2019 16:26:22 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:46983 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728569AbfI1U0W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Sep 2019 16:26:22 -0400
Received: by mail-lf1-f68.google.com with SMTP id t8so4249775lfc.13
        for <netdev@vger.kernel.org>; Sat, 28 Sep 2019 13:26:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JOV2JUUiiOGIic7t5kiaC5hTxzALSlTcS9DiwL2WlrI=;
        b=kZDgSLIk2nTpzZcvVRSHNrWN85U1a7qrhib4Htg7W8y2qgNeIL5sPJczM66BvWz19E
         OIkLCAAoCYE4jMsttVJldARct+9C7V7aZpQ7qw2uWDnNvA7wA6RBli7IQ2HgcBVhKTcX
         2UvZA0bYlR6XDe/3LEi1D8KPyCGFP/KQ7dM4Vp2C7mJ5z/xoECUsGgAx+RMNg0BcmCJJ
         U19ZxWlMWnSmxZEgWwxnyBG+/EnqnJ7ErlfZlh5gUC7aRGHFekhonZDbJvP+GF/+KMHX
         iwiRZUPZY6rfeV70QeCS3nM1Td8jn7HzMyJ1wJfuxDukxpZ/sJm1oHEnrHzzSEYcYaUz
         TL+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JOV2JUUiiOGIic7t5kiaC5hTxzALSlTcS9DiwL2WlrI=;
        b=Dk70DTb3PuPYaXtr0P63KT6OXoKU61LNjmTcOQzlC20svxt6ql0kE1u2p5qnZzy9zp
         0uUyWtxOMvUBJsl+GFyCMH9TZg+jAy+hh1YPA+zKMdkef0i0WUGX5r3J8y+OXbcpsMSr
         xozPuewtq8AetmfeicxK5WHLFuCJU/rWgd00pAfTpYATzl3zny4u4m/9HwSiQhpBNCf4
         +wuJqYEuo8SFgQl6IK/wCvowk5+72lIf+EvqpuLvNChVfxdVEFB9AUapJ0cb9fuXA9/g
         Vgse/5JalsH5ABqNmpb9qYiSp/oqlBAxqr5vkWjBcH5NnS9MIw1u1PUmddBKSNUTBTeP
         Jjsg==
X-Gm-Message-State: APjAAAWkeE4GlDBTdWose37KqbxLPnzB0FggYdNeaNfUmRQaoe6mO36g
        Ly0hORKKHaaBhhgU5a3mo2rpmWG28tlzAag5CrgDLWFm
X-Google-Smtp-Source: APXvYqz6Eaqqu1mukAjS9cKjHOKtB+8ktbGJBHD73xqj2grqXOZV6iJJpE8Lot9Kd6dai6vOHCkTl0Rp8J6Y73UXP04=
X-Received: by 2002:a05:6512:419:: with SMTP id u25mr6587732lfk.165.1569702380154;
 Sat, 28 Sep 2019 13:26:20 -0700 (PDT)
MIME-Version: 1.0
References: <20190927163911.11179-1-linus.walleij@linaro.org> <e21e9a80-c8e0-d758-2309-1a8f03dda400@gmail.com>
In-Reply-To: <e21e9a80-c8e0-d758-2309-1a8f03dda400@gmail.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Sat, 28 Sep 2019 22:26:08 +0200
Message-ID: <CACRpkdaLTf9x=yTBBcGXDUmu2fNjLhx_eWVce_LQcPCjeq9TcQ@mail.gmail.com>
Subject: Re: [PATCH] net: dsa: rtl8366: Check VLAN ID and not ports
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 27, 2019 at 6:40 PM Florian Fainelli <f.fainelli@gmail.com> wrote:
> On 9/27/19 9:39 AM, Linus Walleij wrote:
> > There has been some confusion between the port number and
> > the VLAN ID in this driver. What we need to check for
> > validity is the VLAN ID, nothing else.
> >
> > The current confusion came from assigning a few default
> > VLANs for default routing and we need to rewrite that
> > properly.
> >
> > Instead of checking if the port number is a valid VLAN
> > ID, check the actual VLAN IDs passed in to the callback
> > one by one as expected.
> >
> > Fixes: d8652956cf37 ("net: dsa: realtek-smi: Add Realtek SMI driver")
> > Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> > ---
> >  drivers/net/dsa/rtl8366.c | 12 ++++++++----
> >  1 file changed, 8 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/net/dsa/rtl8366.c b/drivers/net/dsa/rtl8366.c
> > index ca3d17e43ed8..e2c91b75e843 100644
> > --- a/drivers/net/dsa/rtl8366.c
> > +++ b/drivers/net/dsa/rtl8366.c
> > @@ -340,9 +340,11 @@ int rtl8366_vlan_prepare(struct dsa_switch *ds, int port,
> >  {
> >       struct realtek_smi *smi = ds->priv;
> >       int ret;
> > +     int i;
> >
> > -     if (!smi->ops->is_vlan_valid(smi, port))
> > -             return -EINVAL;
> > +     for (i = vlan->vid_begin; i < vlan->vid_end; i++)
> > +             if (!smi->ops->is_vlan_valid(smi, port))
> > +                     return -EINVAL;
>
> You are still checking the port and not the "i" (VLAN ID) argument here,
> is there something I am missing?

No you're right, just correcting old mistakes by making
new mistakes .. I'll fix, thanks!

Yours,
Linus Walleij
