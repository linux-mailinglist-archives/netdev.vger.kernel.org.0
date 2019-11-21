Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 208991058CC
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 18:51:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbfKURvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 12:51:15 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:45751 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726279AbfKURvP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 12:51:15 -0500
Received: by mail-ed1-f66.google.com with SMTP id b5so3513522eds.12
        for <netdev@vger.kernel.org>; Thu, 21 Nov 2019 09:51:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ScUlCrYpMJqvyq1tDUBSUEDmaKGd9e0N611oKgo+l18=;
        b=Jt6gZcSCM8eBLsCzExi6EjS1qta1MRndKaSDNZ56TQfWalnYdIogNNNz2jrLqii1YD
         bWfBd9ZiCXBesTwex37nDH4GU0OJ+MoEk8JZzuGkQXw1uWbuXlUu561hDXBpwS5P/bQG
         x29Xt8O0sz5aK4rR0wAnPpxKa8aDHZXWO4mGV9to2hQMvKSPS54/b89TEupPIBvdKi5Q
         /PcpYiSYvvLOOPk2hwadV8mzT/y2HaJlBo5a/pmk9NfsXGASFbcQrX5OxSjfOfcWfWIC
         qt8fmuPtaamHUAbdAcH42sFce/vzbm1vmF1/SbOZUdhm4lzvwOlq0f243Z2YC+b9DGkc
         7huQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ScUlCrYpMJqvyq1tDUBSUEDmaKGd9e0N611oKgo+l18=;
        b=MesgZRYnNVXzcuOIf7e1E5GDFoWs3rsBd2R6l8rm1E01o64ToXW21Evj/kmEbDUgAz
         jTM7O2MGMENB54XquCK2mL4xw7ED5x2wZu4i8EY5BBPtMEKzgBwl1mOqqZjrvrBJuux5
         JpU2jOSj/LCcf8LpbC6t9JzbyxVglYUS6vPGqg4aiSzmPNe2NNrwHwj0UAgw5lq60Drq
         Q7GOHHWxv1NeHILbAj1HBhY+JesEPw9XxKWcK82vOM2YAxYMQuRt/BIU6Qwxz6iqSWk2
         qfxKjAsvis6BKyW/EM8OF9r5aH7BiY3gxW9hUFu+FWP3/XS3kwtjPEFbDBj0MSmg+ff3
         fb8A==
X-Gm-Message-State: APjAAAU1rzSC9QMX/+iH9M/DtRKw2vzEbj9O5MdgIhh/pnr0SLhl9mOO
        RITeTmUpmeUgrpdsDCTxA8vsXSja62uJzEAkZos=
X-Google-Smtp-Source: APXvYqzCrYAaa0QLDb2Nt7IIjCR3fPWzApkOOTbPcbOx5eJTvjsObVsON5WeWzfeTY7y6P94uR3iqbW3TKcSl/7lVPc=
X-Received: by 2002:a17:906:d210:: with SMTP id w16mr15525532ejz.86.1574358673104;
 Thu, 21 Nov 2019 09:51:13 -0800 (PST)
MIME-Version: 1.0
References: <20191118181030.23921-1-olteanv@gmail.com> <20191118231339.ztotkr536udxuzsl@soft-dev3.microsemi.net>
 <CA+h21hpKN+7ifvFUt6KMYARf19i=Jfw_dwciuPxPC6ZyHRF2XQ@mail.gmail.com>
 <20191119204855.vgiwtrzx3426hbrc@soft-dev3.microsemi.net> <20191119214257.GB19542@lunn.ch>
 <20191120120849.xdizdx4vntor2fvv@soft-dev3.microsemi.net> <CA+h21hpDL=cLsZXyyk3V7=gQnaf-ZdyyuHjcaZ-DY+zRUcnJOw@mail.gmail.com>
 <20191120232152.p22rfjdngm4wtmak@soft-dev3.microsemi.net>
In-Reply-To: <20191120232152.p22rfjdngm4wtmak@soft-dev3.microsemi.net>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 21 Nov 2019 19:51:02 +0200
Message-ID: <CA+h21hrDN1daBFniPOvz_H6h=sStvwbad6JbCgmvrsZAmXpHkg@mail.gmail.com>
Subject: Re: [PATCH net-next 0/2] Convert Ocelot and Felix switches to PHYLINK
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Joergen Andreasen <joergen.andreasen@microchip.com>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "Y.b. Lu" <yangbo.lu@nxp.com>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 Nov 2019 at 01:21, Horatiu Vultur
<horatiu.vultur@microchip.com> wrote:
>
> > >  };
> > >
> > >  &port0 {
> > > +       phy-mode = "sgmii";
> > >         phy-handle = <&phy0>;
> > >  };
> > >
> > >  &port1 {
> > > +       phy-mode = "sgmii";
> > >         phy-handle = <&phy1>;
> > >  };
> > >
> > >  &port2 {
> > > +       phy-mode = "sgmii";
> > >         phy-handle = <&phy2>;
> > >  };
> > >
> > >  &port3 {
> > > +       phy-mode = "sgmii";
> > >         phy-handle = <&phy3>;
> > >  };
> > > diff --git a/drivers/net/ethernet/mscc/ocelot_board.c b/drivers/net/ethernet/mscc/ocelot_board.c
> > > index aecaf4ef6ef4..9dad031900b5 100644
> > > --- a/drivers/net/ethernet/mscc/ocelot_board.c
> > > +++ b/drivers/net/ethernet/mscc/ocelot_board.c
> > > @@ -513,6 +513,10 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
> > >                 if (IS_ERR(regs))
> > >                         continue;
> > >
> > > +               of_get_phy_mode(portnp, &phy_mode);
> > > +               if (phy_mode == PHY_INTERFACE_MODE_NA)
> > > +                       continue;
> > > +
> >
> > So this effectively reverts your own patch 4214fa1efffd ("net: mscc:
> > ocelot: omit error check from of_get_phy_mode")?
>
> Not really, at that point it was OK to have interface
> PHY_INTERFACE_MODE_NA. There were few more checks before creating the
> network device. Now with your changes you were creating
> a network device for each port of the soc even if some ports
> were not used on a board. Also with your changes you first create the
> port and after that you create the phylink but between these two calls it
> was the switch which continue for the interface PHY_INTERFACE_MODE_NA,
> which is not correct. So these are the 2 reason why I have added the
> property phy-mode to the ports and add back the check to see which ports
> are used on each board.
>
> >
> > >                 err = ocelot_probe_port(ocelot, port, regs);
> > >                 if (err) {
> > >                         of_node_put(portnp);
> > > @@ -523,11 +527,7 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
> > >                 priv = container_of(ocelot_port, struct ocelot_port_private,
> > >                                     port);
> > >
> > > -               of_get_phy_mode(portnp, &phy_mode);
> > > -
> > >                 switch (phy_mode) {
> > > -               case PHY_INTERFACE_MODE_NA:
> > > -                       continue;
> > >                 case PHY_INTERFACE_MODE_SGMII:
> > >                         break;
> > >                 case PHY_INTERFACE_MODE_QSGMII:
> > > @@ -549,20 +549,7 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
> > >                 }
> > >
> > >                 serdes = devm_of_phy_get(ocelot->dev, portnp, NULL);
> > > -               if (IS_ERR(serdes)) {
> > > -                       err = PTR_ERR(serdes);
> > > -                       if (err == -EPROBE_DEFER)
> > > -                               dev_dbg(ocelot->dev, "deferring probe\n");
> >
> > Why did you remove the probe deferral for the serdes phy?
> Because not all the ports have the "phys" property.
> >
> > > -                       else
> > > -                               dev_err(ocelot->dev,
> > > -                                       "missing SerDes phys for port%d\n",
> > > -                                       port);
> > > -
> > > -                       of_node_put(portnp);
> > > -                       goto out_put_ports;
> > > -               }
> > > -
> > > -               if (serdes) {
> > > +               if (!IS_ERR(serdes)) {
> > >                         err = phy_set_mode_ext(serdes, PHY_MODE_ETHERNET,
> > >                                                phy_mode);
> > >                         if (err) {
> > > --
> > > 2.17.1
> > >
> > >
> > > >
> > > >    Andrew
> > >
> > > --
> > > /Horatiu
> >
> > Thanks,
> > -Vladimir
>
> --
> /Horatiu

Horatiu,

Do the 10/100 speeds work over the SGMII ports on your board? (not
with this patch, but in general)

Thanks,
-Vladimir
