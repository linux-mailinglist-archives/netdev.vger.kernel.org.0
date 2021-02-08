Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26E7531358D
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 15:49:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231208AbhBHOsU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 09:48:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230352AbhBHOrW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 09:47:22 -0500
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09962C06178A
        for <netdev@vger.kernel.org>; Mon,  8 Feb 2021 06:46:43 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id q4so4716714otm.9
        for <netdev@vger.kernel.org>; Mon, 08 Feb 2021 06:46:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fitHJU6fgIz43s6gomgoRGNbEK6sA9S10LIkpwU5gdc=;
        b=M/b9AaWmwaTUMm+ms95cxEe1aKTmEbXJNmJwTDvIa9aj79Nl8N7FWzRy7M7Q7KeZ/d
         uWwQs9lBiJkF1uJ/aQq1B8Q/IY7GlsBkdvxaLApVoVAW2+JW445HUJndOJV2v+HoZdXF
         Lsso8zU2mxT8Au559rhD8lkiaWlRXWhioyYLa5MV7ejopGTy8YnbHlYjc/BPfMoLU5c5
         7enHQYM+lp59m+be5J1UUqdV/PskgB4ewpGIBpErvl2NWBof4lmuI1w/Cr22AcH3zrs/
         pXVDgHb1si2/GAxActKHNRRaz8c2erHujvFcfaAJAuINzg7C4PYAf89bYiWYnA2xB5XJ
         3kTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fitHJU6fgIz43s6gomgoRGNbEK6sA9S10LIkpwU5gdc=;
        b=cnxYWTvhVT6nC/RE+mpbL8G2/C+vGA4NlnBEycZX9edrH440JO6ghJ7xpCZLLodKO2
         xwRslkPBhsqRtDnhlTrgRysJ7rc7KEXEq5ZfaDRhgHUA5tQwX6EjgCV4okiSH49vfrr2
         6QcGrX+CjnQgsv5TE8ravKWdAr+PYsW6GEf6/msRrVYEz5yFEqDMcq6WvnsgJG67vp/p
         rzhP6li9Ua6l613U4s0Uj/DBrHxsRKpdREmODLQg/mXsLCI9fxyckNjN09ovUgWNk/Ah
         TkvD47PnxSvg5ujXxH+QdQAhzfaNAna4UVT4D7rDS1MaouRsOcyZIGnUxGF9IM+rxXeG
         275w==
X-Gm-Message-State: AOAM531kjkJjfr+6nCyHPLl9UsW5EK1ZHcM3ExmQVx5WiNBowEyJzV27
        qGV4bgq7iNV8HndmSCG8YzBKdfmLymS7ak3gAQ==
X-Google-Smtp-Source: ABdhPJzgIjPdwIQ2upPrOiBuF04dfcyHD2zn6ArENwIQQzMeiUQdGWTOtzFEhiPLoSAeqOmyfZjdNvLHelOe0z+piOA=
X-Received: by 2002:a9d:e82:: with SMTP id 2mr12932354otj.287.1612795602455;
 Mon, 08 Feb 2021 06:46:42 -0800 (PST)
MIME-Version: 1.0
References: <20210204215926.64377-1-george.mccollister@gmail.com>
 <20210204215926.64377-5-george.mccollister@gmail.com> <20210206235349.7ypxtmjvnpxnn5cr@skbuf>
In-Reply-To: <20210206235349.7ypxtmjvnpxnn5cr@skbuf>
From:   George McCollister <george.mccollister@gmail.com>
Date:   Mon, 8 Feb 2021 08:46:29 -0600
Message-ID: <CAFSKS=OpEnGDEFQQbq9eM+MWTNLFEfjhcsd8iNZqV2jhMJ76BQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2 4/4] net: dsa: xrs700x: add HSR offloading support
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 6, 2021 at 5:53 PM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> On Thu, Feb 04, 2021 at 03:59:26PM -0600, George McCollister wrote:
> > +static int xrs700x_hsr_join(struct dsa_switch *ds, int port,
> > +                         struct net_device *hsr)
> > +{
> > +     unsigned int val = XRS_HSR_CFG_HSR_PRP;
> > +     struct dsa_port *partner = NULL, *dp;
> > +     struct xrs700x *priv = ds->priv;
> > +     struct net_device *slave;
> > +     enum hsr_version ver;
> > +     int ret;
> > +
> > +     ret = hsr_get_version(hsr, &ver);
> > +     if (ret)
> > +             return ret;
> > +
> > +     if (ver == HSR_V1)
> > +             val |= XRS_HSR_CFG_HSR;
> > +     else if (ver == PRP_V1)
> > +             val |= XRS_HSR_CFG_PRP;
> > +     else
> > +             return -EOPNOTSUPP;
> > +
> > +     dsa_hsr_foreach_port(dp, ds, hsr) {
> > +             partner = dp;
> > +     }
> > +
> > +     /* We can't enable redundancy on the switch until both
> > +      * redundant ports have signed up.
> > +      */
> > +     if (!partner)
> > +             return 0;
> > +
> > +     regmap_fields_write(priv->ps_forward, partner->index,
> > +                         XRS_PORT_DISABLED);
> > +     regmap_fields_write(priv->ps_forward, port, XRS_PORT_DISABLED);
> > +
> > +     regmap_write(priv->regmap, XRS_HSR_CFG(partner->index),
> > +                  val | XRS_HSR_CFG_LANID_A);
> > +     regmap_write(priv->regmap, XRS_HSR_CFG(port),
> > +                  val | XRS_HSR_CFG_LANID_B);
> > +
> > +     /* Clear bits for both redundant ports (HSR only) and the CPU port to
> > +      * enable forwarding.
> > +      */
> > +     val = GENMASK(ds->num_ports - 1, 0);
> > +     if (ver == HSR_V1) {
> > +             val &= ~BIT(partner->index);
> > +             val &= ~BIT(port);
> > +     }
> > +     val &= ~BIT(dsa_upstream_port(ds, port));
> > +     regmap_write(priv->regmap, XRS_PORT_FWD_MASK(partner->index), val);
> > +     regmap_write(priv->regmap, XRS_PORT_FWD_MASK(port), val);
> > +
> > +     regmap_fields_write(priv->ps_forward, partner->index,
> > +                         XRS_PORT_FORWARDING);
> > +     regmap_fields_write(priv->ps_forward, port, XRS_PORT_FORWARDING);
> > +
> > +     slave = dsa_to_port(ds, port)->slave;
> > +
> > +     slave->features |= NETIF_F_HW_HSR_TAG_INS | NETIF_F_HW_HSR_TAG_RM |
> > +                        NETIF_F_HW_HSR_FWD | NETIF_F_HW_HSR_DUP;
> > +
> > +     return 0;
> > +}
>
> Is it deliberate that only one slave HSR/PRP port will have the offload
> ethtool features set? If yes, then I find that a bit odd from a user
> point of view.

No. Good catch. This is a mistake I introduced when I added the code
for finding the partner. Originally for testing I had hacks that hard
coded the ports used and reconfigured HSR for each join.
