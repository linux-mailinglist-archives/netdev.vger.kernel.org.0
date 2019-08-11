Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8E2789243
	for <lists+netdev@lfdr.de>; Sun, 11 Aug 2019 17:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbfHKPQZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Aug 2019 11:16:25 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:37779 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726164AbfHKPQZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Aug 2019 11:16:25 -0400
Received: by mail-ed1-f66.google.com with SMTP id f22so450014edt.4
        for <netdev@vger.kernel.org>; Sun, 11 Aug 2019 08:16:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=NVL9QnPwu/ALAOn+GieNAWlBMwIueKMsPs9ynCWsG/s=;
        b=hzGx5aoNwLCU3Xz52twgaBe3ZMGpjOdgTUOnmFWXaBrN59/rNHv/fZYLYF1+zysapT
         wSTfWeeXp5OGeJYJmDDhQhBgbiNgCALyOXUCW/DG/HOt0qVIawdqT2VqMCM0TGvchTlO
         Ck+h+4tPdzhsAmTgsVqLp+c5M3ityZaEwT5Nls0+QG0M0tqOH6z0VD9uzmw/0ibTDWrK
         9RDdmIsXsF9hbHGnrA+HfDEwIiwUzT7owYlDdJCB13c7P+Mz1j7Bq8TXJdYAJQRenhy/
         vDQ3MDzNj/9Cp9Pl+g4B6mQArKDA1Q+hb4EJjif4irSQta9LOHetZSDxk+N2P3VsAfdJ
         a5fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=NVL9QnPwu/ALAOn+GieNAWlBMwIueKMsPs9ynCWsG/s=;
        b=iWF4yDxN58aMNPDoakYnl3Nk+YzdHkZre2PW/7DZ4eVVs3aIZVZA1xpe8O5CFBOQ7s
         1fKSG0rjhu9JHB4mj1JelxBe29fZWZGUBHEf3a+yCqEJw45LYHB/vmXr3kV9Pex6DrBQ
         nNWz/E32xHwtNLMrx+V1Fw8FRHSvXyGHgQyahZalkkrdkYSu3yMp/hBzKm541e45lxLe
         GRnhDvD6WSAB8QNN0Gel63QzK8jpJLdGEK9tsKOY08nHiYsPuuxxGOFXWGj3bPNRci2c
         RwMn9Y1V4B6GiZVNqQ1V65jKRnX9ld9DhyYH3P2ZAE167syQKoJJfRjfSrQVeMG1eceh
         lJ/w==
X-Gm-Message-State: APjAAAUj940Gh18HztWuaIQhhmTkhfNmr1musQRJj0pmjPrfeEWl88o5
        QFeRGRC9jPlM5eZwBh8igrkrmr9Cya64OmC1+to=
X-Google-Smtp-Source: APXvYqx7t60wTP4GFoh8wxIvryuHQmihzxtk1zvoxgZPLzOyrfG2y+r3Gic8g8PKXecHhx/XhdL6i1QIonO15SF3sho=
X-Received: by 2002:a05:6402:1285:: with SMTP id w5mr32630335edv.36.1565536582912;
 Sun, 11 Aug 2019 08:16:22 -0700 (PDT)
MIME-Version: 1.0
References: <20190811031857.2899-1-marek.behun@nic.cz> <20190811033910.GL30120@lunn.ch>
 <91cd70df-c856-4c7e-7ebb-c01519fb13d2@gmail.com> <20190811160404.06450685@nic.cz>
In-Reply-To: <20190811160404.06450685@nic.cz>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sun, 11 Aug 2019 18:16:11 +0300
Message-ID: <CA+h21hoOZQ79rj0SLZGLnkSjrKD3aLNos0GcnRjre-Ls=Tq=4w@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/1] net: dsa: fix fixed-link port registration
To:     Marek Behun <marek.behun@nic.cz>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>,
        Sebastian Reichel <sebastian.reichel@collabora.co.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marek,

On Sun, 11 Aug 2019 at 17:06, Marek Behun <marek.behun@nic.cz> wrote:
>
> OK guys, something is terribly wrong here.
>
> I bisected to the commit mentioned (88d6272acaaa), looked around at the
> genphy functions, tried adding the link=3D0 workaround and it did work,
> so I though this was the issue.
>
> What I realized now is that before the commit 88d6272acaaa things
> worked because of two bugs, which negated each other. This commit caused
> one of this bugs not to fire, and thus the second bug was not negated.
>
> What actually happened before the commit that broke it is this:
>   - after the fixed_phy is created, the parameters are corrent
>   - genphy_read_status breaks the parameters:
>      - first it sets the parameters to unknown (SPEED_UNKNOWN,
>        DUPLEX_UNKNOWN)
>      - then read the registers, which are simulated for fixed_phy
>      - then it uses phy-core.c:phy_resolve_aneg_linkmode function, which
>        looks for correct settings by bit-anding the ->advertising and
>        ->lp_advertigins bit arrays. But in fixed_phy, ->lp_advertising
>        is set to zero, so the parameters are left at SPEED_UNKNOWN, ...
>        (this is the first bug)
>   - then adjust_link is called, which then goes to
>     mv88e6xxx_port_setup_mac, where there is a test if it should change
>     something:
>        if (state.link =3D=3D link && state.speed =3D=3D speed &&
>            state.duplex =3D=3D duplex)
>                return 0;
>   - since current speed on the switch port (state.speed) is SPEED_1000,
>     and new speed is SPEED_UNKNOWN, this test fails, and so the rest of
>     this function is called, which makes the port work
>     (the if test is the second bug)
>
> After the commit that broke things:
>   - after the fixed_phy is created, the parameters are corrent
>   - genphy_read_status doesn't change them
>   - mv88e6xxx_port_setup_mac does nothing, since the if condition above
>     is true
>
> So, there are two things that are broken:
>  - the test in mv88e6xxx_port_setup_mac whether there is to be a change
>    should be more sophisticated
>  - fixed_phy should also simulate the lp_advertising register
>
> What do you think of this?
>

I don't know. But I think Heiner was asking you what kernel you're on
because of what you said here:

> Hopefully DSA fixed-link port functionality will be converted to phylink
> API soon.

The DSA fixed-link port functionality *has* been converted to phylink.
See:
- https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/commit=
/?id=3D0e27921816ad9
- https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/commit=
/?id=3D7fb5a711545d7d25fe9726a9ad277474dd83bd06


> Marek
>
> On Sun, 11 Aug 2019 13:35:20 +0200
> Heiner Kallweit <hkallweit1@gmail.com> wrote:
>
> > On 11.08.2019 05:39, Andrew Lunn wrote:
> > > On Sun, Aug 11, 2019 at 05:18:57AM +0200, Marek Beh=C3=BAn wrote:
> > >> Commit 88d6272acaaa ("net: phy: avoid unneeded MDIO reads in
> > >> genphy_read_status") broke fixed link DSA port registration in
> > >> dsa_port_fixed_link_register_of: the genphy_read_status does not do =
what
> > >> it is supposed to and the following adjust_link is given wrong
> > >> parameters.
> > >
> > > Hi Marek
> > >
> > > Which parameters are incorrect?
> > >
> > > In fixed_phy.c, __fixed_phy_register() there is:
> > >
> > >         /* propagate the fixed link values to struct phy_device */
> > >         phy->link =3D status->link;
> > >         if (status->link) {
> > >                 phy->speed =3D status->speed;
> > >                 phy->duplex =3D status->duplex;
> > >                 phy->pause =3D status->pause;
> > >                 phy->asym_pause =3D status->asym_pause;
> > >         }
> > >
> > > Are we not initialising something? Or is the initialisation done here
> > > getting reset sometime afterwards?
> > >
> > In addition to Andrew's question:
> > We talk about this DT config: armada-385-turris-omnia.dts ?
> > Which kernel version are you using?
> >
> > > Thanks
> > >     Andrew
> > >
> > Heiner
>

Regards,
-Vladimir
