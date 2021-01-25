Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8512D30321E
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 03:50:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729394AbhAYOgF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 09:36:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729491AbhAYOd5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 09:33:57 -0500
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89534C06178C
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 06:33:17 -0800 (PST)
Received: by mail-oi1-x234.google.com with SMTP id d18so5608401oic.3
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 06:33:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BYUTKAHCNcww+RapxIDjajZhUv+/sBoXDEM4duQ3A7I=;
        b=tt9krdsVt25qe5TalMzeLiSFyGroYKwXsTv69WiX74VKWPy03wX29t9iHWvfRYXimO
         q8ugqRv4EMetmboU+cpPWtSqJeZKMbt6CobHoBz/EXB0IQYaJJAN0F+h5hTvWJdA4d1W
         JZjP+Iqapf8muzyP4UREcYokyjrjaqpZkwcehmiBHtRE3yezkoaW7Hi+OBl0g92L9hzH
         AaWNtPozgAslN1pFx8rAXay5hEjlj2afjIg3VSjI6iOshbofyIHHKDaH/YKKB6t3Fo2v
         7WYeWgR7YMURm/o/+Qz6EVCkK0WooyGMHtKw+49fWw9XFkMW2kMxb5oKlR359yek5CNN
         g4SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BYUTKAHCNcww+RapxIDjajZhUv+/sBoXDEM4duQ3A7I=;
        b=AakLp6jzw4GkrS1erbJkfHiNOU0kd7WyW7P8Za3cvNLC/qg0U5p8BIp0MCjv8CvuAf
         8yR1+CfjWvJSOpkcVHojjcxDCGnxJzSpj+ml7FbpyoKRchk7e9jBMDgP74OfuKCnU8eP
         McBTeIWLvh70nd/MxXnixYYOdc3pTqfXrh2NlSeW0yGCcIlLoja0vpF8lrcwwFKpH70m
         uJUFDy14Zur4sYMAUEBUH3jsaDRdtMBjXkX9NVNNs8guXiJuFsck8k/Q13YLEK6Oa3c5
         uzB9LuPbo8b78Zw7p8ZKmsJEjze8iRU+Ig+FLe1ZphbltOlsqN+/jCQXPj0yyd7/2u6a
         CFAA==
X-Gm-Message-State: AOAM5302qg1L3D4th5Rvq4tjl/vwmxXALBNtvPe3f1PSHNolEeHgbaQK
        nwwzNftv09hlNtGErYEyfkeQlPBQeNWq4SiZmw==
X-Google-Smtp-Source: ABdhPJxb7n9GyIIkPtSGwrXFWPUrnAnem71+XHknuoMbhTzs7PBPJlYRbNAxNkqCfKH1WUbbNr8Ibs+n1aDryRX6UN4=
X-Received: by 2002:a05:6808:8e7:: with SMTP id d7mr289843oic.127.1611585196889;
 Mon, 25 Jan 2021 06:33:16 -0800 (PST)
MIME-Version: 1.0
References: <20210122155948.5573-1-george.mccollister@gmail.com>
 <20210122155948.5573-3-george.mccollister@gmail.com> <20210124172938.ikhpe44bqjqmttul@skbuf>
In-Reply-To: <20210124172938.ikhpe44bqjqmttul@skbuf>
From:   George McCollister <george.mccollister@gmail.com>
Date:   Mon, 25 Jan 2021 08:33:04 -0600
Message-ID: <CAFSKS=OGHQpHYFTxP9n5j7BKs9+ZcLRagtziMH9TDw=Rr7Owcg@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 2/3] net: hsr: add DSA offloading support
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, Nishanth Menon <nm@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Sekhar Nori <nsekhar@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 24, 2021 at 11:29 AM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> On Fri, Jan 22, 2021 at 09:59:47AM -0600, George McCollister wrote:
> > diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> > index f2fb433f3828..fc7e3ff11c5c 100644
> > --- a/net/dsa/slave.c
> > +++ b/net/dsa/slave.c
> > @@ -1924,6 +1924,19 @@ static int dsa_slave_changeupper(struct net_device *dev,
> >                       dsa_port_lag_leave(dp, info->upper_dev);
> >                       err = NOTIFY_OK;
> >               }
> > +     } else if (netif_is_hsr_master(info->upper_dev)) {
> > +             if (info->linking) {
> > +                     err = dsa_port_hsr_join(dp, info->upper_dev);
> > +                     if (err == -EOPNOTSUPP) {
> > +                             NL_SET_ERR_MSG_MOD(info->info.extack,
> > +                                                "Offloading not supported");
> > +                             err = 0;
> > +                     }
> > +                     err = notifier_from_errno(err);
> > +             } else {
> > +                     dsa_port_hsr_leave(dp, info->upper_dev);
> > +                     err = NOTIFY_OK;
> > +             }
> >       }
>
> How is the RedBox use case handled with the Linux hsr driver (i.e. a
> HSR-unaware SAN endpoint attached to a HSR ring)? I would expect
> something like this:
>
>                    +---------+
>                    |         |
>                    |   SAN   |
>                    |         |
>                    +---------+
>                         |
>                         |
>                         |
>  +-----------------+---------+------------------+
>  |                 |         |                  |
>  |  Your           |   swp0  |                  |
>  |  board          |         |                  |
>  |                 +---------+                  |
>  |                    |   ^                     |
>  |                    |   |                     |
>  |                    |   | br0                 |
>  |                    |   |                     |
>  |                    v   |                     |
>  |       +-----------------------------+        |
>  |       |                             |        |
>  |       |             hsr0            |        |
>  |       |                             |        |
>  |       +---------+---------+---------+        |
>  |       |         |         |         |        |
>  |       |   swp1  |  DAN-H  |  swp2   |        |
>  |       |         |         |         |        |
>  +-------+---------+---------+---------+--------+
>             |   ^               |   ^
>     to/from |   |               |   | to/from
>      ring   |   |               |   |  ring
>             v   |               v   |
>
> Therefore, aren't you interested in offloading this setup as well?
> I.e. the case where the hsr0 interface joins a bridge that also
> contains other DSA switch ports. This would be similar to the LAG
> offload recently added by Tobias.

I'm familiar with this use case but I don't currently need to support
it on products I'm working on and in fact my hardware doesn't support
it because the fourth switch port isn't brought out on the boards.
I've also never tested it in software. I suppose when an hsr is
bridged with a non-HSR switch port it would need to figure out the hsr
redundancy interfaces are on the same switch and configure the
forwarding accordingly. It's also worth noting that on switches which
don't support automatic insertion/deletion of the HSR/PRP tag (like
the ksz9477 I think) this wouldn't be possible.

If someone has hardware that supports this and wants to work with me
to add support for it I'd certainly be open to it. Adding support for
this in the future if demand arises seems like the best plan given
what I have to work with.
