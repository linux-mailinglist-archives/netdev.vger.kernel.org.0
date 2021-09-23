Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 878214160C2
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 16:09:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241606AbhIWOLU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 10:11:20 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56766 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241463AbhIWOLT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Sep 2021 10:11:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=xQgxqK+Omh+ETGrdtsoUW3Gy+NDg808eHja9Ii9a27k=; b=aUgT2IAoRFPgCSOsS1DrMz/sxk
        9KKSua9q2PVGi3AUTA4VapP2feVpP6qwKDMsBy+H58mdCL5jojpPFeLFbXAh5Vm07zxcMfgaSDwBD
        e+wE/fpY8UV4go6pvI00WHKgt34XSBWB0cC4NL5MQwO4VratZbPAXsscbaSbv//DOgBk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mTPPr-007w1H-D7; Thu, 23 Sep 2021 16:09:35 +0200
Date:   Thu, 23 Sep 2021 16:09:35 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Adam Ford <aford173@gmail.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: Re: [PATCH 0/9] renesas: Add compatible properties to Ethernet PHY
 nodes
Message-ID: <YUyKn19mJm8tizw+@lunn.ch>
References: <cover.1631174218.git.geert+renesas@glider.be>
 <CAMuHMdU6Mrfina3+2iW+RKaujk57JSRtmixRPn1b0d2w5dZ3eA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdU6Mrfina3+2iW+RKaujk57JSRtmixRPn1b0d2w5dZ3eA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 23, 2021 at 01:00:11PM +0200, Geert Uytterhoeven wrote:
> On Thu, Sep 9, 2021 at 10:49 AM Geert Uytterhoeven
> <geert+renesas@glider.be> wrote:
> > If an Ethernet PHY reset is asserted when the Ethernet driver is
> > initialized, the PHY cannot be probed:
> >
> >     mdio_bus ee700000.ethernet-ffffffff: MDIO device at address 1 is missing
> >
> > This happens because the Linux PHY subsystem tries to read the PHY
> > Identifier registers before handling PHY reset.  Hence if the PHY reset
> > was asserted before, identification fails.
> >
> > An easy way to reproduce this issue is by using kexec to launch a new
> > kernel (the PHY reset will be asserted before starting the new kernel),
> > or by unbinding and rebinding the Ethernet driver (the PHY reset will be
> > asserted during unbind), e.g. on koelsch:
> >
> >     echo ee700000.ethernet > /sys/bus/platform/drivers/sh-eth/unbind
> >     $ echo ee700000.ethernet > /sys/bus/platform/drivers/sh-eth/bind
> >
> > The recommended approach[1][2] seems to be working around this issue by
> > adding compatible values to all ethernet-phy nodes, so Linux can
> > identify the PHY at any time, without reading the PHY ID from the
> > device, and regardless of the state of the PHY reset line.
> >
> > Hence this patch series adds such compatible values to all Ethernet PHY
> > subnodes representing PHYs on all boards with Renesas ARM and ARM64
> > SoCs.  For easier review, I have split the series in one patch per PHY
> > model.

It is a reasonable approach.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
