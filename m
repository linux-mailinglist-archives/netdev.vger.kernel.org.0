Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53D6135DF78
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 14:56:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345898AbhDMMxd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 08:53:33 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48200 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240321AbhDMMxb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 08:53:31 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lWIXL-00GTYv-RL; Tue, 13 Apr 2021 14:52:59 +0200
Date:   Tue, 13 Apr 2021 14:52:59 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marc Zyngier <maz@kernel.org>
Cc:     DENG Qingfang <dqfext@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Sean Wang <sean.wang@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-staging@lists.linux.dev, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, Weijie Gao <weijie.gao@mediatek.com>,
        Chuanhong Guo <gch981213@gmail.com>,
        =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Ungerer <gerg@kernel.org>
Subject: Re: [RFC v4 net-next 2/4] net: dsa: mt7530: add interrupt support
Message-ID: <YHWUK+tG3v9ZU/DT@lunn.ch>
References: <20210412034237.2473017-1-dqfext@gmail.com>
 <20210412034237.2473017-3-dqfext@gmail.com>
 <87fszvoqvb.wl-maz@kernel.org>
 <20210412152210.929733-1-dqfext@gmail.com>
 <YHTgu1+6GZFdFgWJ@lunn.ch>
 <8735vuobfo.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8735vuobfo.wl-maz@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I guess this is depends whether the most usual case is to have all
> these interrupts being actively in use or not. Most interrupts only
> use a limited portion of their interrupt space at any given time.
> Allocating all interrupts and creating mappings upfront is a waste of
> memory.
> 
> If the use case here is that all these interrupts will be wired and
> used in most cases, then upfront allocation is probably not a problem.

Hi Marc

The interrupts are generally used. Since this is an Ethernet switch,
generally the port is administratively up, even if there is no cable
plugged in. Once/if a cable is plugged in and there is a link peer,
the PHY will interrupt to indicate this.

The only real case i can think of when the interrupts are not used is
when the switch has more ports than connected to the front panel. This
can happen in industrial settings, but not SOHO. Those ports which
don't go anywhere are never configured up and so the interrupt is
never used.

      Andrew
