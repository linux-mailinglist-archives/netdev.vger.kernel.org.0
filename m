Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2ADCB95C31
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 12:23:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729392AbfHTKWz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 06:22:55 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:41012 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728545AbfHTKWz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 06:22:55 -0400
Received: by mail-ed1-f67.google.com with SMTP id w5so5696437edl.8
        for <netdev@vger.kernel.org>; Tue, 20 Aug 2019 03:22:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YqG886AdsFA/q35UJ6Mv481X58+6avjiAa/LueAQgms=;
        b=oZAAYGeF2AEvhECcHMgoG3gf2KHRP+KxiTHJG8L1bH5s6CAOWMmJCF9X5vovIw0Z6c
         ZOV9jPo7IZ0gq/pCdj2wWIAjE7TfdjZF4By7facUip2trLNy3ukafVKNuXnlm4cdNdXq
         WA0nCMBRdlKlwiCEwepPQpqsqO5YCxE1nw1uACud24Bwwwp0Wc9UurYqQRIzJEdJ1XaR
         MMZWTYuQijKq7ODe19ilconApl+LOoJDm/Lyo9NPPzQ525vbFhsQoW0GSV+vz/me12A3
         YsMuSosgb5W1MrlYKfxSFkEY18pHYZGlOgfJt8/bONVnTJ9jfZ/FVD8PhmyMy0NNM0fK
         btyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YqG886AdsFA/q35UJ6Mv481X58+6avjiAa/LueAQgms=;
        b=E8SJmwtSfp7r2JatTV35AZcrEyIwam3DA2+py0yuHUigKfCgeLyQzwKyId9PMs6oNN
         BdHcKRg6/JfPK9xq2Pw/vEhPAJJJGH7HcNi7/13iHfvmM15tGk6I42mMkdx/tu7JniAI
         QO2QbPH4Ty2NyCqAT1UimUfwU+Vs0MgavKn5ZNdvEuF030UE892UIptWk4eNI2mKv/bI
         1P5DmdfkolMoTIjCE0GEKfp9p/ZKZFC9lGf5K+S3NhzauITfsywnmfX4JMbwg+r8jvS+
         o1SX6vF6PENpNxmrKwn+2cndtRye6W86+kCJ+UxSOpukb04A8EgUAzTHbUSa8Dr5/8C2
         NcAw==
X-Gm-Message-State: APjAAAX7LzYkIrJs+dF0MZITEun1rp5hOHar2PO9qnkrPQw0p9gD7kG/
        ipFkKpXOTj6/wJJ6v8eVp6JCLOVxlPN/3M/hOcI=
X-Google-Smtp-Source: APXvYqxpGtJg8IzhxlEHLG8Co8LVKk/bSQd+XRzR7eyTOEDNryCr30DO4VHWg99eTsRQTm7U/8DIfzasw1DA3GIlR7o=
X-Received: by 2002:a17:907:2069:: with SMTP id qp9mr25134983ejb.90.1566296573442;
 Tue, 20 Aug 2019 03:22:53 -0700 (PDT)
MIME-Version: 1.0
References: <20190820000002.9776-1-olteanv@gmail.com> <20190820000002.9776-5-olteanv@gmail.com>
 <20190820020709.GD975@t480s.localdomain>
In-Reply-To: <20190820020709.GD975@t480s.localdomain>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 20 Aug 2019 13:22:42 +0300
Message-ID: <CA+h21hpWxEO8LQWM3KfcYoFOBZFo=YfDOJ+rLxLaC-Facg+MXA@mail.gmail.com>
Subject: Re: [PATCH net-next 4/6] net: dsa: Don't program the VLAN as pvid on
 the upstream port
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Ido Schimmel <idosch@idosch.org>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        nikolay@cumulusnetworks.com,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vivien,

On Tue, 20 Aug 2019 at 09:07, Vivien Didelot <vivien.didelot@gmail.com> wrote:
>
> On Tue, 20 Aug 2019 03:00:00 +0300, Vladimir Oltean <olteanv@gmail.com> wrote:
> > Commit b2f81d304cee ("net: dsa: add CPU and DSA ports as VLAN members")
> > programs the VLAN from the bridge into the specified port as well as the
> > upstream port, with the same set of flags.
> >
> > Consider the typical case of installing pvid 1 on user port 1, pvid 2 on
> > user port 2, etc. The upstream port would end up having a pvid equal to
> > the last user port whose pvid was programmed from the bridge. Less than
> > useful.
> >
> > So just don't change the pvid of the upstream port and let it be
> > whatever the driver set it internally to be.
> >
> > Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> > ---
> >  net/dsa/switch.c | 16 ++++++++++++----
> >  1 file changed, 12 insertions(+), 4 deletions(-)
> >
> > diff --git a/net/dsa/switch.c b/net/dsa/switch.c
> > index 84ab2336131e..02ccc53f1926 100644
> > --- a/net/dsa/switch.c
> > +++ b/net/dsa/switch.c
> > @@ -239,17 +239,21 @@ dsa_switch_vlan_prepare_bitmap(struct dsa_switch *ds,
> >                              const struct switchdev_obj_port_vlan *vlan,
> >                              const unsigned long *bitmap)
> >  {
> > +     struct switchdev_obj_port_vlan v = *vlan;
> >       int port, err;
> >
> >       if (!ds->ops->port_vlan_prepare || !ds->ops->port_vlan_add)
> >               return -EOPNOTSUPP;
> >
> >       for_each_set_bit(port, bitmap, ds->num_ports) {
> > -             err = dsa_port_vlan_check(ds, port, vlan);
> > +             if (dsa_is_cpu_port(ds, port) || dsa_is_dsa_port(ds, port))
> > +                     v.flags &= ~BRIDGE_VLAN_INFO_PVID;
>
> So you keep the BRIDGE_VLAN_INFO_PVID flag cleared for all other ports that
> come after any CPU or DSA port?
>

It looks like the convenient hardware decision of making the CPU port
on my board also be the numerically highest one strikes again :)
I always find bugs when I change the CPU port to another number.
This is another example (also related to the inclusion of upstream
ports in the VLAN bitmap, like they all seem to be):
https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/commit/?id=d34d2baa9173f6e0c0f22d005d18e83d1cb54d8d

> > +
> > +             err = dsa_port_vlan_check(ds, port, &v);
> >               if (err)
> >                       return err;
> >
> > -             err = ds->ops->port_vlan_prepare(ds, port, vlan);
> > +             err = ds->ops->port_vlan_prepare(ds, port, &v);
> >               if (err)
> >                       return err;
> >       }
> > @@ -262,10 +266,14 @@ dsa_switch_vlan_add_bitmap(struct dsa_switch *ds,
> >                          const struct switchdev_obj_port_vlan *vlan,
> >                          const unsigned long *bitmap)
> >  {
> > +     struct switchdev_obj_port_vlan v = *vlan;
> >       int port;
> >
> > -     for_each_set_bit(port, bitmap, ds->num_ports)
> > -             ds->ops->port_vlan_add(ds, port, vlan);
> > +     for_each_set_bit(port, bitmap, ds->num_ports) {
> > +             if (dsa_is_cpu_port(ds, port) || dsa_is_dsa_port(ds, port))
> > +                     v.flags &= ~BRIDGE_VLAN_INFO_PVID;
>
> Same here. Did you intend to initialize your switchdev_obj_port_vlan structure
> _within_ the for_each_set_bit loop maybe?
>

Thanks for pointing this out.

> > +             ds->ops->port_vlan_add(ds, port, &v);
> > +     }
> >  }
> >
> >  static int dsa_switch_vlan_add(struct dsa_switch *ds,
>
> Do you even test your patches?

No.

Regards,
-Vladimir
