Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 263922CF7A8
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 00:45:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730489AbgLDXnz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 18:43:55 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:39546 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725847AbgLDXnz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 18:43:55 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1klKjR-00AHWo-1M; Sat, 05 Dec 2020 00:43:21 +0100
Date:   Sat, 5 Dec 2020 00:43:21 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Sven Van Asbroeck <thesven73@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        David S Miller <davem@davemloft.net>,
        Marek Vasut <marex@denx.de>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v1] net: dsa: ksz8795: use correct number of physical
 ports
Message-ID: <20201204234321.GJ2400258@lunn.ch>
References: <20201203214645.31217-1-TheSven73@gmail.com>
 <20201204152456.247769b1@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201204152456.247769b1@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 04, 2020 at 03:24:56PM -0800, Jakub Kicinski wrote:
> On Thu,  3 Dec 2020 16:46:45 -0500 Sven Van Asbroeck wrote:
> > From: Sven Van Asbroeck <thesven73@gmail.com>
> > 
> > The ksz8795 has five physical ports, but the driver assumes
> > it has only four. This prevents the driver from working correctly.
> > 
> > Fix by indicating the correct number of physical ports.
> > 
> > Fixes: e66f840c08a23 ("net: dsa: ksz: Add Microchip KSZ8795 DSA driver")
> > Tested-by: Sven Van Asbroeck <thesven73@gmail.com> # ksz8795
> > Signed-off-by: Sven Van Asbroeck <thesven73@gmail.com>
> 
> All the port counts here are -1 compared to datasheets, so I'm assuming
> the are not supposed to include the host facing port or something?
> 
> Can you describe the exact problem you're trying to solve?
> 
> DSA devices are not supposed to have a netdev for the host facing port
> on the switch (sorry for stating the obvious).

Hi Jakub

It is the DSA core layer which takes care of that creating/not
creating netdevs. The switch should declare all the ports it has.

There has been issues with the ksz collection of drivers having
different meanings for port_cnt. There recently was some changes in
this area, maybe it broke something?

     Andrew
