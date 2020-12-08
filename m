Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 371EC2D3038
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 17:53:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730236AbgLHQw7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 11:52:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:43298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729793AbgLHQw7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 11:52:59 -0500
Date:   Tue, 8 Dec 2020 08:52:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607446338;
        bh=2ZiHcHbEKdRawgO6KfFexrUtN/Uuc2cI32K9p6Uoq88=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=dyDSN9GyCIK4xjPL7hvPr9HFVlMNIUk9hXxa5muzS7HQN4rA6NJVSdbJI8rgbtCFz
         z0NA/eOjt3baRsB1/TSpzNLMR9Z4bc+xClq75mBYiXlReG5vKvvTV1HtRFxKduCDmE
         bkZNJzJbMp9wFiWtz0ISAHUBPe++48dOchipJKDDrOGELiqu7DRE6n7wYQEhHFqRA0
         pRZMKc+16SFCcHQAeZsDvc9Pxw5IQ8wIneCdtz08aUbLVPxh/V61Cx6VEnf6Q7fACs
         8A+Qiwx0DwaqM51zyJvtZJASn8tCUMWx36ZrESIN0/eIfDvjTRhcY06H8CtYy9aGAW
         haLWFKJYPqqLQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sven Van Asbroeck <thesven73@gmail.com>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        David S Miller <davem@davemloft.net>,
        Helmut Grohne <helmut.grohne@intenta.de>,
        netdev <netdev@vger.kernel.org>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: Re: [PATCH net v1 1/2] net: dsa: microchip: fix devicetree parsing
 of cpu node
Message-ID: <20201208085216.790ecdc3@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <CAGngYiXdJ=oLe+A034wGL_rjtjSnEw7DhSJ3sE7M9PAAjkZMTQ@mail.gmail.com>
References: <20201205152814.7867-1-TheSven73@gmail.com>
        <CAGngYiXdJ=oLe+A034wGL_rjtjSnEw7DhSJ3sE7M9PAAjkZMTQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 8 Dec 2020 10:33:28 -0500 Sven Van Asbroeck wrote:
> Andrew, Jakub,
> 
> On Sat, Dec 5, 2020 at 10:28 AM Sven Van Asbroeck <thesven73@gmail.com> wrote:
> >
> > From: Sven Van Asbroeck <thesven73@gmail.com>
> >
> > On the ksz8795, if the devicetree contains a cpu node,
> > devicetree parsing fails and the whole driver errors out.
> >
> > Fix the devicetree parsing code by making it use the
> > correct number of ports.
> >
> > Fixes: 912aae27c6af ("net: dsa: microchip: really look for phy-mode in port nodes")
> > Tested-by: Sven Van Asbroeck <thesven73@gmail.com> # ksz8795
> > Signed-off-by: Sven Van Asbroeck <thesven73@gmail.com>
> > ---  
> 
> Any chance that this patch could still get merged?
> I believe this will work fine on both ksz8795 and ksz9477, even though num_ports
> is defined differently, because:
> 
> ksz8795:
> /* set the real number of ports */
> dev->ds->num_ports = dev->port_cnt + 1;
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/net/dsa/microchip/ksz8795.c?h=v5.10-rc7#n1266
> 
> ksz9477:
> /* set the real number of ports */
> dev->ds->num_ports = dev->port_cnt;
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/net/dsa/microchip/ksz9477.c?h=v5.10-rc7#n1585
> 
> Would it be possible to merge this into net, so users get working cpu nodes?
> I don't think this will prevent you from harmonizing port_cnt in net-next.

What I was talking about in the email yesterday was 0x8794 support
in ksz8795.c. Is the cpu port configuration going to work there?
Isn't the CPU port always port 5 (index 4)?

It sure as hell looked like it until commit c9f4633b93ea ("net: dsa:
microchip: remove usage of mib_port_count") came along. I wonder if 
ksz8794 works on net-next :/
