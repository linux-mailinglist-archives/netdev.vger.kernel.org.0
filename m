Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB1F2131BFA
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 00:01:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727289AbgAFXAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 18:00:52 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:41026 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726721AbgAFXAw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 18:00:52 -0500
Received: by mail-ed1-f66.google.com with SMTP id c26so48814070eds.8
        for <netdev@vger.kernel.org>; Mon, 06 Jan 2020 15:00:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Zu+XyweFvziow87ovzwjTzDkHcdJLBUiW1Hon7dAC8Q=;
        b=sOSKFLvIy/nMNsYvBAQdKEjPgP6YI3whTftwa/ljtULbo9tkH8GgskVZKMb8EROhyK
         f+t9PHX+KoytLo4Ll/Vu17pg/17eMWcpgc11LW+6r7tVzzL6qPyR1g1BfOOY+1KSrAFc
         +G12v4Hx2eEsRYSjujbARI1WD18HowiqWG/JfbpC9uIngGpcwGNKeN0P8hnSvsi5XwlJ
         IwKrLK8YJN1IE2xaNmo/0+ShzOnQYMsZMKiAidL58uN+Yc5eD7lnRYvXi03hQal/v1a/
         AHURdoSLgz3+QQuyhVM0cwJJYzGNt13+97GnXQuI8cRMB/24UdvFMr+Fwtyz7W+u+WXR
         n55w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Zu+XyweFvziow87ovzwjTzDkHcdJLBUiW1Hon7dAC8Q=;
        b=n4OMdDxuNGJzO51MJyLhwc+wEaQQgtb5RXBuyFHB3Hk+fbQEgCgIuSi/eviazRLL+c
         N6KdTCMS46g//nW500B/ix81v3DNHKbrfLv+1PGWEwXQ2yfq3an57VvKFZN5ZxJB18sG
         T0iRAstLTrTN3HP/6falVJleKAf6diZH40fB3mkaxMSi0KXNyVN7blFpNXhhgv4m/hiY
         fxXK7vwwk8bPdYCFVaZlYD+81LI3QnbnaQ58nw03C+rDiX86ZQ9YcaKHt7QRmR0No5CI
         M8B2YtkvWA2cUVUbzk6PFuZr0UoISrpfmYfSR2mhgEv5mb6/be4XWs+V7CybU71Ygo8p
         py9A==
X-Gm-Message-State: APjAAAXVACaZY39GBsYEZhXEKh6z+23/YkxHAXa1aGVFqeP3oc9FFlNQ
        Ab8LhEJcoRLU9HjVmZt+6He9hRkcrgkqJsODGM0=
X-Google-Smtp-Source: APXvYqzeK60jDMWWjvODUn6MwiKVkxM+4GYT42c271hPcQ43CPxZD3zw8Y5SsqhO9uJJdAiq+3ENfeBLbIMXxg00FvA=
X-Received: by 2002:a05:6402:311b:: with SMTP id dc27mr109987208edb.36.1578351649622;
 Mon, 06 Jan 2020 15:00:49 -0800 (PST)
MIME-Version: 1.0
References: <20200106013417.12154-1-olteanv@gmail.com> <20200106013417.12154-6-olteanv@gmail.com>
 <8718ea22-d1aa-fe58-bd69-521eeee5190a@gmail.com>
In-Reply-To: <8718ea22-d1aa-fe58-bd69-521eeee5190a@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 7 Jan 2020 01:00:38 +0200
Message-ID: <CA+h21hotFQ9UbxbsQRk2TvTb4H27hfqYK+mX=3urqOoTnaLMDg@mail.gmail.com>
Subject: Re: [PATCH v5 net-next 5/9] enetc: Make MDIO accessors more generic
 and export to include/linux/fsl
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "Y.b. Lu" <yangbo.lu@nxp.com>, netdev <netdev@vger.kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

On Mon, 6 Jan 2020 at 21:35, Florian Fainelli <f.fainelli@gmail.com> wrote:
>
> On 1/5/20 5:34 PM, Vladimir Oltean wrote:
> > From: Claudiu Manoil <claudiu.manoil@nxp.com>
> >
> > Within the LS1028A SoC, the register map for the ENETC MDIO controller
> > is instantiated a few times: for the central (external) MDIO controller,
> > for the internal bus of each standalone ENETC port, and for the internal
> > bus of the Felix switch.
> >
> > Refactoring is needed to support multiple MDIO buses from multiple
> > drivers. The enetc_hw structure is made an opaque type and a smaller
> > enetc_mdio_priv is created.
> >
> > 'mdio_base' - MDIO registers base address - is being parameterized, to
> > be able to work with different MDIO register bases.
> >
> > The ENETC MDIO bus operations are exported from the fsl-enetc-mdio
> > kernel object, the same that registers the central MDIO controller (the
> > dedicated PF). The ENETC main driver has been changed to select it, and
> > use its exported helpers to further register its private MDIO bus. The
> > DSA Felix driver will do the same.
>
> This series has already been applied so this may be food for thought at
> this point, but why was not the solution to create a standalone mii_bus
> driver and have all consumers be pointed it?
>

I have no real opinion on this.

To be honest, the reason is that the existing "culture" of Freescale
MDIO drivers wasn't to put them in drivers/net/phy/mdio-*.c, and I
just didn't look past the fence.

But what is the benefit? What gets passed between bcmgenet and
mdio-bcm-unimac with struct bcmgenet_platform_data is equivalent with
what gets passed between vsc9959 and enetc_mdio with the manual
population of struct mii_bus and struct enetc_mdio_priv, no? I'm not
even sure there is a net reduction in code size. And I am not really
sure that I want an of_node for the MDIO bus platform device anyway.
Whereas genet seems to be instantiating a port-private MDIO bus for
the _real_ (but nonetheless embedded) PHY, the MDIO bus we have here
is for the MAC PCS, which is more akin to the custom device tree
binding "pcsphy-handle" that the DPAA1 driver is using (see
arch/arm64/boot/dts/qoriq-fman3-0-10g-0.dtsi for example). So there is
no requirement to run the PHY state machine on it, it's just locally
driven, so I don't want to add a dependency on device tree where it's
really not needed. (By the way I am further confused by the
undocumented/unused "brcm,40nm-ephy" compatible string that these
device tree bindings for genet have).

> It is not uncommon for MDIO controllers to be re-used and integrated
> within a larger block and when that happens whoever owns the largest
> address space, say the Ethernet MAC can request the large resource
> region and the MDIO bus controler can work on that premise, that's what
> we did with genet/bcmmii.c and mdio-bcm-unimac.c for instance (so we
> only do an ioremap, not request_mem_region + ioremap).
>

I don't really understand this. In arch/mips/boot/dts, for all of
bcm73xx and bcm74xx SoCs, you have a single Ethernet port DT node, and
a single MDIO bus as a child beneath it, where is this reuse that you
mention?
And because I don't really understand what you've said, my following
comment maybe makes no sense, but I think what you mean by "MDIO
controller reuse" is that there are multiple instantiations of the
register map, but ultimately every transaction ends up on the same
MDIO/MDC pair of wires and the same electrical bus.
We do have some of that with the ENETC, but not with the switch, whose
internal MDIO bus has no connection to the outside world, it just
holds the PCS front-ends for the SerDes.
I also don't understand the reference to request_mem_region, perhaps
it would help if you could show some code.

> Your commit message does not provide a justification for why this
> abstraction (mii_bus) was not suitable or considered here. Do you think
> that could be changed?
>

I'm sorry, was the mii_bus abstraction really not considered here?
Based on the stuff exported in this patch, an mii_bus is exactly what
I'm registering in 9/9, no?

> Thanks!
> --
> Florian

Regards,
-Vladimir
