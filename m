Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F95940B45B
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 18:18:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbhINQTb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 12:19:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbhINQT1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 12:19:27 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FFC7C061574
        for <netdev@vger.kernel.org>; Tue, 14 Sep 2021 09:18:10 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id m11so17852359ioo.6
        for <netdev@vger.kernel.org>; Tue, 14 Sep 2021 09:18:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RZGtX95KhDg6cOU6Ei2dCC/slYztCW/EyX0L9hAZFtM=;
        b=ZJsotc+H2nYSr7+EQJ92nPpKJeN4hqtXVJ6wQN+VAhtNvYFgslAz+2Nbyj1loKz6R7
         SfsLj04uR8i5G+ZMADV5pyLYwkiGM+CjVhrlhBHoFdat39xj7pnU+wi3kQnXL8/nCAnS
         +ZmhHZVVTqvhSShkKo9FqC6kwBOagzOoEHdjPMXwZXSDPxvTXW9MhrXBpXfAwG9dWDyE
         xecfpYKkXymSnbEajHYkUAulnlFPStl2skxJffCu+jRcIwIGj+gWlDAJooU1KYS/VGPy
         HLrHvKArqtJkt3mA75f1xfcMb2cUG7Igs9af6Wq4jmPPAu1PprJvrX+uW1QpxEqU7+AF
         og0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RZGtX95KhDg6cOU6Ei2dCC/slYztCW/EyX0L9hAZFtM=;
        b=EG52pg2dPZlk/hPX2m1CeWIZq3ZBLZKJGC9GGAGyLDsu+TJe09ejLp/C8PHzP3K6dI
         2iEXlcyq1zg77cE4RgK284pfnYRFKxKNMOGCkkidVkmilaMk3p12hsqDRa7IbZ8+12Ev
         K6fAdO9hnSZbEO+7iF5jN0me3vhP4DDmUqkw5fjC09jZ7wUAufwsiaGY1pjBPUa7Wy+k
         EREAoyLmzTWyxKmthiGHZMctQ9P+liVYXhWgAWD3d6tix9IVtfAqiYDmAQr3FxVKQxIg
         JWw7uY08Not73iN8Q6kqfe/hNyZoRM6xsjQDFmg/2TOI9O2IOJoG43ZyB0dUQ+dpNzgU
         9ZTQ==
X-Gm-Message-State: AOAM532JU1PWgbXNNTMA4ap+UnIcrIdHhmIPY57ktSP2duCefPqlq7T2
        8iJeAqYl3E8mO/Gd4DhrcbYHOsJyCr7iUh+vP+KlCQ==
X-Google-Smtp-Source: ABdhPJxgZagzAwO71dWHLXcdxeoMc/StkZk6J673IGRLD9RYbM4wcXihL2Z0SpALCePj2yVn3BWZHM71Hq98MUBaxdY=
X-Received: by 2002:a02:cf06:: with SMTP id q6mr15264233jar.89.1631636289436;
 Tue, 14 Sep 2021 09:18:09 -0700 (PDT)
MIME-Version: 1.0
References: <20210912192805.1394305-1-vladimir.oltean@nxp.com>
 <CANr-f5wCpcPM+FbeW+x-JmZt0-WmE=b5Ys1Pa_G7p8v3nLyCcQ@mail.gmail.com>
 <20210912213855.kxoyfqdyxktax6d3@skbuf> <YT+dL1R/DTVBWQ7D@lunn.ch>
 <20210914120617.iaqaukal3riridew@skbuf> <YUCytc0+ChhcdOo+@lunn.ch> <20210914151525.gg2ifaqqxrmytaxm@skbuf>
In-Reply-To: <20210914151525.gg2ifaqqxrmytaxm@skbuf>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
Date:   Tue, 14 Sep 2021 18:17:58 +0200
Message-ID: <CANr-f5zNnywpNxMAmNDv60otqXo2oGKiQpT2BL3VraOZftGc4w@mail.gmail.com>
Subject: Re: [RFC PATCH net] Revert "net: phy: Uniform PHY driver access"
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 14, 2021 at 5:15 PM Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
> On Tue, Sep 14, 2021 at 04:33:25PM +0200, Andrew Lunn wrote:
> > On Tue, Sep 14, 2021 at 12:06:18PM +0000, Vladimir Oltean wrote:
> > > On Mon, Sep 13, 2021 at 08:49:19PM +0200, Andrew Lunn wrote:
> > > > > I am not sure why "to_phy_driver" needs cleanup. Au contraire, I think
> > > > > the PHY library's usage of struct phy_device :: drv is what is strange
> > > > > and potentially buggy, it is the only subsystem I know of that keeps its
> > > > > own driver pointer rather than looking at struct device :: driver.
> > > >
> > > > There is one odd driver in the mix. Take a look at xilinx_gmii2rgmii.c.
> > > >
> > > > It probably could be done a better way, but that is what we have.
> > >
> > > Interesting, to say the least. Also, is there any connection between
> > > that and the revert I'm proposing?
> >
> > If i remember correctly, Gerhard Engleder is actually using this, and
> > ran into a problem because the wrong driver structure was used.

Yes, but that was about phy_loopback and was fixed in the commit before.
With this commit I tried to fix the remaining similar problems like the wrong
driver structure use in phy_loopback. But as explained by Vladimir I failed.
So it is totally ok to revert this commit, no functionality is lost.

> > > So compared to other vendors, where the RGMII gasket is part of the MAC
> > > device, with Xilinx Zynq it is accessible via MDIO?
> >
> > Yes. Its control plane sits on the MDIO bus. Unfortunately, it does
> > not have any ID registers, so it does not directly appear as a PHY. So
> > it does interesting things it put itself in the control path to the
> > real PHY.
> >
> > > It looks like it is said that this GMII2RGMII converter can be placed in
> > > front of any GMII MAC. Nice that there are zero in-tree users of
> > > "xlnx,gmii-to-rgmii-1.0" so that I could figure out exactly how that
> > > plays out in practice.
> >
> > If you look back at the thread for that patch, i think Gerhard posted
> > a DT fragment he is using. Hopefully it will get submitted as a full
> > board description at some point.

I submitted it, but Michal Simek argumented that dts files of FPGA logic shall
not be part of mainline. I suggested that at least one reference
platform for every
FPGA based IP core should be allowed, but he said that no one is able
to test it.
So it seems that you will never see any dts file which contains FPGA logic in
mainline. I will try to submit it again if anyone will support me?

> > > Note that th                       e usage of priv->phy_dev, priv->phy_drv, priv->conv_phy_drv
> > > beats me. Why is "phy_dev" kept inside "priv" even though it is accessed
> > > only inside xgmiitorgmii_probe? Why does xgmiitorgmii_configure() need to
> > > be called from xgmiitorgmii_read_status() which in turn hooks into the
> > > attached PHY driver's phy_read_status()? Why does xgmiitorgmii_configure
> > > not get exported and called from an .adjust_link method or the phylink
> > > equivalent, like any other MAC-side hardware linked with the PHY library
> > > in the kernel?
> >
> > I was never happy with this driver. It got submitted before i went on
> > vacation, i had a few rounds trying to get the submitter to refactor
> > it and was mostly ignored. I left on vacation with lots of open review
> > points, and when i got back it had been merged. And the original
> > submitters never responded to my requests for improvements.
>
> Sorry, this is a rabbit hole I really don't want to go into. Allowing it
> to override PHY driver functions in order to 'automagically' configure
> itself when the PHY driver does stuff is probably where the bad decision
> was, everything from there is just the resulting fallout.
>
> Why don't all MAC drivers just hook themselves into the PHY driver's
> ->read_status method and configure themselves from there?! Why do we
> even need adjust_link, phylink, any of that? It's just a small
> pointer/driver override, the PHY library supports it.
>
> I have dug up this discussion where your stance seemed to be that
> "you want the MAC phy-handle to point to the gmii_to_rgmii 'PHY'"
> https://lore.kernel.org/netdev/20190309161912.GD9000@lunn.ch/#t
>
> I am not really sure if that particular reply went towards making this
> driver's design any saner than it is. As explained by Harini Katakam in
> his reply to you, the GMII2RGMII converter is not a PHY, and should
> therefore not be treated like one. It is an RGMII gasket for the MAC.
> Treating it as a satellite device of the MAC, which happens by chance to
> sit on an MDIO bus, but having otherwise nothing to do with the PHY
> library, sounds like a more normal approach (please note that it is
> quite likely I am oversimplifying some things since I just learned about
> this).

Just for information dts with working GMII2RGMII looks like this:

       tnsep0: ethernet@a0000000 {
                       compatible = "engleder,tsnep";
                       reg = <0x0 0xa0000000 0x0 0x10000>;
                       interrupts = <0 89 1>;
                       interrupt-parent = <&gic>;
                       local-mac-address = [00 00 00 00 00 00];
                       phy-mode = "rgmii";
                       phy-handle = <&phy1>;
                       mdio {
                               #address-cells = <1>;
                               #size-cells = <0>;
                               phy1: ethernet-phy@1 {
                                       reg = <1>;
                                       rxc-skew-ps = <1080>;
                               };
                               gmiitorgmii@8 {
                                       compatible = "xlnx,gmii-to-rgmii-1.0";
                                       reg = <8>;
                                       phy-handle = <&phy1>;
                               };
                       };
               };

Gerhard
