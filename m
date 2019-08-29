Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B427A150A
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 11:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726330AbfH2JfB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 05:35:01 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:45557 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbfH2JfB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 05:35:01 -0400
Received: by mail-ed1-f68.google.com with SMTP id x19so3255851eda.12
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 02:35:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5p8STtfzh5cifS9A0SXoK78H2hSGyJURcZS17QGVsck=;
        b=gQmFVuTk2JhUMPe8gl+Nxna6CFP4K1YAU+trR1uqIuaegty6NCofNpIssJMSEDpJG0
         SG14eu0DD4fiXc8IVV774Gevs51OGbXNw4hndp7C6xKAl9cpbQaJSCeVzsdcUUSq2slx
         w2TJmDhGeRyuAIW6ysevhModQRbd/JfXiX67AJM1Geih1PK/BdN9xZYoPPgLgBqIu5qI
         lB7HOYMNazrzvuQTypFLwSZRa98MkKMrKeVjLC57i6G8r10JoUFDLYmPnvaGZn5MJxJ/
         S9FVEQsV1sRUArzV69bZKwpNW+gfVpnVMeww/7ZSXyo0XTIJeh9aDQlr42U+2wMen0Rd
         USnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5p8STtfzh5cifS9A0SXoK78H2hSGyJURcZS17QGVsck=;
        b=Uni9fcWkZEIvLo4IGgitvhTY2MsF4OIIE9hcYJgsXFu/O/5U5JdCM4XI2ZWIsrp7ev
         fD6G4gLIzehSut3aXLujRLNj7LIQe7hS9agPowmR4XVYYPLWG1Vi+W73ecJlljVxioWL
         hf2akokQBfeq3RTyjSWZScCUzMC+ORflRETcZJPjZA81ihbWfYxav1OomcxpFdIISisL
         aAoSG61DiEqM20bDmolee6wiHNrxRm7toyGcAyICzJFVnQAM4enU4wHOOGQmG47RH8In
         byZNYD5EU+XDAZWId7C8+4N08c3vo0wi5DTQghpzg3pSX50qrQ3NhCZ4nH9Ao3mzKVW+
         VqKg==
X-Gm-Message-State: APjAAAW31jTw7ceHynCj0B5WoFLEOdBaJdckVSHCg63j3wA4iWRyQppV
        YFtOb4oLFg7xkeVw9Pp19hGaoQTZqugTZcVvaZ8=
X-Google-Smtp-Source: APXvYqwjhvzJ4SvWkOgFj/5gqMNLVprcqD9hxZv8txs+Fl5ZggkikmCR7gTxIXD6yEjxR3R53VGSJX7vsmsS4vAann8=
X-Received: by 2002:a05:6402:1244:: with SMTP id l4mr8381472edw.117.1567071299528;
 Thu, 29 Aug 2019 02:34:59 -0700 (PDT)
MIME-Version: 1.0
References: <20190828145802.3609-1-olteanv@gmail.com> <20190828145802.3609-2-olteanv@gmail.com>
 <20190828171431.GR13294@shell.armlinux.org.uk>
In-Reply-To: <20190828171431.GR13294@shell.armlinux.org.uk>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 29 Aug 2019 12:34:48 +0300
Message-ID: <CA+h21hoQzy_iEJOshaZMBa2AUdMiRDQPBb01LhrkkNceueeCjQ@mail.gmail.com>
Subject: Re: [RFC PATCH 1/1] phylink: Set speed to SPEED_UNKNOWN when there is
 no PHY connected
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Arseny Solokha <asolokha@kb.kras.ru>,
        netdev <netdev@vger.kernel.org>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        leandro.maciel.dorileo@intel.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

On Wed, 28 Aug 2019 at 20:14, Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
>
> On Wed, Aug 28, 2019 at 05:58:02PM +0300, Vladimir Oltean wrote:
> > phylink_ethtool_ksettings_get can be called while the interface may not
> > even be up, which should not be a problem. But there are drivers (e.g.
> > gianfar) which connect to the PHY in .ndo_open and disconnect in
> > .ndo_close. While odd, to my knowledge this is again not illegal and
> > there may be more that do the same. But PHYLINK for example has this
> > check in phylink_ethtool_ksettings_get:
> >
> >       if (pl->phydev) {
> >               phy_ethtool_ksettings_get(pl->phydev, kset);
> >       } else {
> >               kset->base.port = pl->link_port;
> >       }
> >
> > So it will not populate kset->base.speed if there is no PHY connected.
> > The speed will be 0, by way of a previous memset. Not SPEED_UNKNOWN.
> > It is arguable whether that is legal or not. include/uapi/linux/ethtool.h
> > says:
> >
> >       All values 0 to INT_MAX are legal.
> >
> > By that measure it may be. But it sure would make users of the
> > __ethtool_get_link_ksettings API need make more complicated checks
> > (against -1, against 0, 1, etc). So far the kernel community has been ok
> > with just checking for SPEED_UNKNOWN.
> >
> > Take net/sched/sch_taprio.c for example. The check in
> > taprio_set_picos_per_byte is currently not robust enough and will
> > trigger this division by zero, due to PHYLINK not setting SPEED_UNKNOWN:
> >
> >       if (!__ethtool_get_link_ksettings(dev, &ecmd) &&
> >           ecmd.base.speed != SPEED_UNKNOWN)
> >               picos_per_byte = div64_s64(NSEC_PER_SEC * 1000LL * 8,
> >                                          ecmd.base.speed * 1000 * 1000);
>
> The ethtool API says:
>
>  * If it is enabled then they are read-only; if the link
>  * is up they represent the negotiated link mode; if the link is down,
>  * the speed is 0, %SPEED_UNKNOWN or the highest enabled speed and
>  * @duplex is %DUPLEX_UNKNOWN or the best enabled duplex mode.
>
> So, it seems that taprio is not following the API... I'd suggest either
> fixing taprio, or getting agreement to change the ethtool API.
>

How would you suggest rewriting the line above in taprio to make
correct and robust use of the ethtool API?

> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
> According to speedtest.net: 11.9Mbps down 500kbps up

Regards,
-Vladimir
