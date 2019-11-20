Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C07CB103ACC
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 14:13:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728995AbfKTNNy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 08:13:54 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:37614 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727958AbfKTNNy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 08:13:54 -0500
Received: by mail-ed1-f66.google.com with SMTP id k14so20218890eds.4
        for <netdev@vger.kernel.org>; Wed, 20 Nov 2019 05:13:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1WLzDLfe7ZPf9OXHOY/KoFf3sgI7JLKNIFsp3cv/tgI=;
        b=lzhq92BCSUThBwmKKepqhev0LjuEoatYouEYcfJaK9s5sTy8cFJ53X0tq41YMLS17d
         D8NrA5KZr96rxPBFzXeoHY0UhoGU41CLPRoxjYNelSc7zmWOAB5I8Yt7V20iMj2wyTJa
         UzKqj11dfBMZrv4iJ/VdJw+fyUV9FhJUfkwmBYbzbtqf21V4P2XCfvP0kYvPihdstwtE
         xTOSF2sq/F3EPP9D98nOm/N7ClrpQV0WUySNRPsP3usiR+iNUtzyKfQGfRBUqL7O6+nW
         yV4fpp4fBAnhk8cM8vE2zXaCffSyhlm+IIamMBye/Q++2Upap9OaPoCEbLXXb5CX7kK+
         pKDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1WLzDLfe7ZPf9OXHOY/KoFf3sgI7JLKNIFsp3cv/tgI=;
        b=PoEjOGiw15cF1EtjZ0t0HWKqiGg40FzsOibfqzXR5i7PzzN36Ol+hDtWcaiihVx62K
         O7sNuHwOqOt178ALQNRcopzzCWSfjwWnFCKNYUTndL0sT1XrI1F6g5REXE1yz3qZ6r9g
         76ePEj5DyLJmWUsTS8q0h+Cne+fBkuG8DSc1lBQ5hqfJ9qEHaIO/nAAK8nZpFQefqzPs
         ckojStzlmKHxcUAN6rZGkat464p9/5nQusqD4naG8U+Qxh2712N6nzvb0ugZhGMlc5Fd
         AHR8scvmD9g4ofzfPTXPu8OuB3sbRya+IWfTgCn9V2dFDUxIKB+tFgcjXF5nXkOjubYb
         x5Bw==
X-Gm-Message-State: APjAAAXJm2bZVb62N2wZ1Um5R1BLpVV3GJBSiRwAuLgyf6ZlpQXGpWQu
        qJHDOCUBL82C/6Y0B4KbJZmPX2nW/iV8g0yuLEQ=
X-Google-Smtp-Source: APXvYqxmilG51ApFioqIGBfrqo6aKVs0bHha6rOqkvwmznbzgZyQ6nsGYSHyeE3Dl0SC/X5oiFVQIC/VWR8eqPZLaaA=
X-Received: by 2002:a17:906:70e:: with SMTP id y14mr5393680ejb.70.1574255630060;
 Wed, 20 Nov 2019 05:13:50 -0800 (PST)
MIME-Version: 1.0
References: <20191118181030.23921-1-olteanv@gmail.com> <20191118231339.ztotkr536udxuzsl@soft-dev3.microsemi.net>
 <CA+h21hpKN+7ifvFUt6KMYARf19i=Jfw_dwciuPxPC6ZyHRF2XQ@mail.gmail.com>
 <20191119204855.vgiwtrzx3426hbrc@soft-dev3.microsemi.net> <20191119214257.GB19542@lunn.ch>
 <20191120120849.xdizdx4vntor2fvv@soft-dev3.microsemi.net>
In-Reply-To: <20191120120849.xdizdx4vntor2fvv@soft-dev3.microsemi.net>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 20 Nov 2019 15:13:38 +0200
Message-ID: <CA+h21hpDL=cLsZXyyk3V7=gQnaf-ZdyyuHjcaZ-DY+zRUcnJOw@mail.gmail.com>
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

On Wed, 20 Nov 2019 at 14:08, Horatiu Vultur
<horatiu.vultur@microchip.com> wrote:
>
> The 11/19/2019 22:42, Andrew Lunn wrote:
> > EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> >
> > > Before this commit it was ok to use PHY_INTERFACE_MODE_NA but now that
> > > is not true anymore. In this case we have 4 ports that have phy and
> > > then 6 sfp ports. So I was looking to describe this in DT but without
> > > any success. If you have any advice that would be great.
> >
> > Is it the copper ports causing the trouble, or the SFP?  Ideally, you
> > should describe the SFPs as SFPs. But i don't think the driver has the
> > needed support for that yet. So you might need to use fixed-link for
> > the moment.
>
> It was both of them. So I have done few small changes to these patches.
> - first I added the phy-mode in DT on the interfaces that have a
>   phy(internal or external)
> - add a check for PHY_INTERFACE_MODE_NA before the port is probed so it
>   would not create net device if the phy mode is PHY_INTERFACE_MODE_NA
>   because in that case the phylink was not created.
>
> With these changes now only the ports that have phy are probed. This is
> the same behaviour as before these patches. I have tried to configure
> the sfp ports as fixed-links but unfortunetly it didn't work, I think
> because of some missconfiguration on MAC or SerDes, which I need to
> figure out. But I think this can be fix in a different patch.
>
> I have done few tests and they seem to work fine.
> Here are my changes.
>
> diff --git a/arch/mips/boot/dts/mscc/ocelot_pcb120.dts b/arch/mips/boot/dts/mscc/ocelot_pcb120.dts
> index 33991fd209f5..0800a86b7f16 100644
> --- a/arch/mips/boot/dts/mscc/ocelot_pcb120.dts
> +++ b/arch/mips/boot/dts/mscc/ocelot_pcb120.dts
> @@ -60,18 +60,22 @@
>
>  &port0 {
>         phy-handle = <&phy0>;
> +       phy-mode = "sgmii";
>  };
>
>  &port1 {
>         phy-handle = <&phy1>;
> +       phy-mode = "sgmii";
>  };
>
>  &port2 {
>         phy-handle = <&phy2>;
> +       phy-mode = "sgmii";
>  };
>
>  &port3 {
>         phy-handle = <&phy3>;
> +       phy-mode = "sgmii";
>  };
>
>  &port4 {
> diff --git a/arch/mips/boot/dts/mscc/ocelot_pcb123.dts b/arch/mips/boot/dts/mscc/ocelot_pcb123.dts
> index ef852f382da8..6b0b1fb358ad 100644
> --- a/arch/mips/boot/dts/mscc/ocelot_pcb123.dts
> +++ b/arch/mips/boot/dts/mscc/ocelot_pcb123.dts
> @@ -47,17 +47,21 @@
>  };
>
>  &port0 {
> +       phy-mode = "sgmii";
>         phy-handle = <&phy0>;
>  };
>
>  &port1 {
> +       phy-mode = "sgmii";
>         phy-handle = <&phy1>;
>  };
>
>  &port2 {
> +       phy-mode = "sgmii";
>         phy-handle = <&phy2>;
>  };
>
>  &port3 {
> +       phy-mode = "sgmii";
>         phy-handle = <&phy3>;
>  };
> diff --git a/drivers/net/ethernet/mscc/ocelot_board.c b/drivers/net/ethernet/mscc/ocelot_board.c
> index aecaf4ef6ef4..9dad031900b5 100644
> --- a/drivers/net/ethernet/mscc/ocelot_board.c
> +++ b/drivers/net/ethernet/mscc/ocelot_board.c
> @@ -513,6 +513,10 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
>                 if (IS_ERR(regs))
>                         continue;
>
> +               of_get_phy_mode(portnp, &phy_mode);
> +               if (phy_mode == PHY_INTERFACE_MODE_NA)
> +                       continue;
> +

So this effectively reverts your own patch 4214fa1efffd ("net: mscc:
ocelot: omit error check from of_get_phy_mode")?

>                 err = ocelot_probe_port(ocelot, port, regs);
>                 if (err) {
>                         of_node_put(portnp);
> @@ -523,11 +527,7 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
>                 priv = container_of(ocelot_port, struct ocelot_port_private,
>                                     port);
>
> -               of_get_phy_mode(portnp, &phy_mode);
> -
>                 switch (phy_mode) {
> -               case PHY_INTERFACE_MODE_NA:
> -                       continue;
>                 case PHY_INTERFACE_MODE_SGMII:
>                         break;
>                 case PHY_INTERFACE_MODE_QSGMII:
> @@ -549,20 +549,7 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
>                 }
>
>                 serdes = devm_of_phy_get(ocelot->dev, portnp, NULL);
> -               if (IS_ERR(serdes)) {
> -                       err = PTR_ERR(serdes);
> -                       if (err == -EPROBE_DEFER)
> -                               dev_dbg(ocelot->dev, "deferring probe\n");

Why did you remove the probe deferral for the serdes phy?

> -                       else
> -                               dev_err(ocelot->dev,
> -                                       "missing SerDes phys for port%d\n",
> -                                       port);
> -
> -                       of_node_put(portnp);
> -                       goto out_put_ports;
> -               }
> -
> -               if (serdes) {
> +               if (!IS_ERR(serdes)) {
>                         err = phy_set_mode_ext(serdes, PHY_MODE_ETHERNET,
>                                                phy_mode);
>                         if (err) {
> --
> 2.17.1
>
>
> >
> >    Andrew
>
> --
> /Horatiu

Thanks,
-Vladimir
