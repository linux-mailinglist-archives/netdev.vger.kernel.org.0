Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A8631CC137
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 14:17:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728463AbgEIMRB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 08:17:01 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:24786 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726782AbgEIMRA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 08:17:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589026619;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=H76Mksznw95btvUBSKx6gefc+t9SRkpD4GR2A1wMEWw=;
        b=OdpbGzk0Zqy42wX91MLwN6vUIa6+JE63/SgHqttVObUDdzllzyNal/DdwSo1JQEJywDTWR
        iCnv7hyTCdJ/Bwwf0LEQHztv+UldqTmUkyV2KdQ8GGPQ/uVltLuM2hm8LNDnDQ+nPLn/tI
        rKKRwLLyjc790aH8QBgucsbPPH8uNI0=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-460-66k-JWA1NvG9T8djC2G4Qw-1; Sat, 09 May 2020 08:16:57 -0400
X-MC-Unique: 66k-JWA1NvG9T8djC2G4Qw-1
Received: by mail-ej1-f71.google.com with SMTP id q24so1888538ejb.3
        for <netdev@vger.kernel.org>; Sat, 09 May 2020 05:16:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=H76Mksznw95btvUBSKx6gefc+t9SRkpD4GR2A1wMEWw=;
        b=W5Bpw2kjZVjoJK31AKuvrBBtlLbx0FaUnvcWd6vA39F6HVtz+Ei3alX6EreOOI+6z1
         JBcwWEPh3k+QZvolTTPuZbJGnGNuvrE2dvw5JVL/d8VDc6PeD8YDaSitdO3vSH3J9Pi9
         eWNGvuInRR/8s/X7+OR8gkw73v9dPZNI7H6HPySuBY/MvJXuD56DsvncL1EniLgSIFEJ
         dl/XYS0sqq6HwI06xKXJD6NpiHkXRwt1fGimz7dJJvbW4OxOQv86LA4hRBuCnvvCgr31
         g4EyCQ4Me0N6AJyTWODrQ+tAqpdSbf5VWVzPGeWu5UfOfDSalYf36O3O52HP5L4GABOO
         k0Kw==
X-Gm-Message-State: AGi0Pubx7L9+M1o9wazI3wXKlA6/kgUON2kBDSUw0T909V9vT3is15Lr
        N1vAVQUGS51qQ6bem0sxKNt/QmKjDuXv+v+il5UK1A+FbMnWTTV5bGQr0epouK8YHy5l56yGijA
        4Pp7l30HnmNwNwNLiPXAQNU0NSBXFwsct
X-Received: by 2002:a17:906:3584:: with SMTP id o4mr5983536ejb.70.1589026616174;
        Sat, 09 May 2020 05:16:56 -0700 (PDT)
X-Google-Smtp-Source: APiQypI1UXFBpEK1GTG9DqxWl2WPCdbZuNHFa+X/9FasNbc4VjLFflOlGIHoBd2LBjBaMDinS7oLti41vflUZ4eTHZc=
X-Received: by 2002:a17:906:3584:: with SMTP id o4mr5983519ejb.70.1589026615896;
 Sat, 09 May 2020 05:16:55 -0700 (PDT)
MIME-Version: 1.0
References: <20190524100554.8606-1-maxime.chevallier@bootlin.com>
 <20190524100554.8606-4-maxime.chevallier@bootlin.com> <CAGnkfhzsx_uEPkZQC-_-_NamTigD8J0WgcDioqMLSHVFa3V6GQ@mail.gmail.com>
 <20200423170003.GT25745@shell.armlinux.org.uk> <CAGnkfhwOavaeUjcm4_+TG-xLxQA519o+fR8hxBCCfSy3qpcYhQ@mail.gmail.com>
 <DM5PR18MB1146686527DE66495F75D0DAB0A30@DM5PR18MB1146.namprd18.prod.outlook.com>
In-Reply-To: <DM5PR18MB1146686527DE66495F75D0DAB0A30@DM5PR18MB1146.namprd18.prod.outlook.com>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Sat, 9 May 2020 14:16:19 +0200
Message-ID: <CAGnkfhwV4YyR9f1KC8VFx4FPRYkAoXXUURa715wb3+=23=rr6Q@mail.gmail.com>
Subject: Re: [EXT] Re: [PATCH net-next 3/5] net: mvpp2: cls: Use RSS contexts
 to handle RSS tables
To:     Stefan Chulski <stefanc@marvell.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "gregory.clement@bootlin.com" <gregory.clement@bootlin.com>,
        "miquel.raynal@bootlin.com" <miquel.raynal@bootlin.com>,
        Nadav Haklai <nadavh@marvell.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 9, 2020 at 1:16 PM Stefan Chulski <stefanc@marvell.com> wrote:
> > Hi,
> >
> > What do you think about temporarily disabling it like this?
> >
> > --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > @@ -5775,7 +5775,8 @@ static int mvpp2_port_probe(struct platform_device
> > *pdev,
> >                             NETIF_F_HW_VLAN_CTAG_FILTER;
> >
> >         if (mvpp22_rss_is_supported()) {
> > -               dev->hw_features |= NETIF_F_RXHASH;
> > +               if (port->phy_interface != PHY_INTERFACE_MODE_SGMII)
> > +                       dev->hw_features |= NETIF_F_RXHASH;
> >                 dev->features |= NETIF_F_NTUPLE;
> >         }
> >
> >
> > David, is this "workaround" too bad to get accepted?
>
> Not sure that RSS related to physical interface(SGMII), better just remove NETIF_F_RXHASH as "workaround".
>
> Stefan.

Hi,

The point is that RXHASH works fine on all interfaces, but on the
gigabit one (eth2 usually).
And on the 10 gbit interface is very very effective, the throughput
goes 4x when enabled, so it would be a big drawback to disable it on
all interfaces.

Honestly I don't have any 2.5 gbit hardware to test it on eth3, so I
don't know if rxhash actually only works on the first interface of a
unit (so eth0 and eth1),
or if it just doesn't work on the gigabit one.

If someone could test it on the 2.5 gbit port, this will be helpful.

Regards,
-- 
Matteo Croce
per aspera ad upstream

