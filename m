Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55B322C687B
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 16:11:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728235AbgK0PK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 10:10:28 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:52868 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726410AbgK0PK2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Nov 2020 10:10:28 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kifOA-00992c-Ew; Fri, 27 Nov 2020 16:10:22 +0100
Date:   Fri, 27 Nov 2020 16:10:22 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lukasz Majewski <lukma@denx.de>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Fabio Estevam <festevam@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Peng Fan <peng.fan@nxp.com>, stefan.agner@toradex.com,
        krzk@kernel.org, Shawn Guo <shawnguo@kernel.org>
Subject: Re: [RFC 0/4] net: l2switch: Provide support for L2 switch on i.MX28
 SoC
Message-ID: <20201127151022.GQ2073444@lunn.ch>
References: <20201125232459.378-1-lukma@denx.de>
 <20201126123027.ocsykutucnhpmqbt@skbuf>
 <20201127003549.3753d64a@jawa>
 <20201127010811.GR2075216@lunn.ch>
 <20201127102528.33737ea4@jawa>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201127102528.33737ea4@jawa>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 27, 2020 at 10:25:28AM +0100, Lukasz Majewski wrote:
> Hi Andrew,
> 
> > > > I would push back and say that the switch offers bridge
> > > > acceleration for the FEC.   
> > > 
> > > Am I correct, that the "bridge acceleration" means in-hardware
> > > support for L2 packet bridging?   
> > 
> > You should think of the hardware as an accelerator, not a switch. The
> > hardware is there to accelerate what linux can already do. You setup a
> > software bridge in linux, and then offload L2 switching to the
> > accelerator. You setup vlans in linux, and then offload the filtering
> > of them to the accelerator. If there is something linux can do, but
> > the hardware cannot accelerate, you leave linux to do it in software.
> 
> Ok.
> 
> > 
> > > Do you propose to catch some kind of notification when user calls:
> > > 
> > > ip link add name br0 type bridge; ip link set br0 up;
> > > ip link set lan1 up; ip link set lan2 up;
> > > ip link set lan1 master br0; ip link set lan2 master br0;
> > > bridge link
> > > 
> > > And then configure the FEC driver to use this L2 switch driver?  
> > 
> > That is what switchdev does. There are various hooks in the network
> > stack which call into switchdev to ask it to offload operations to the
> > accelerator.
> 
> Ok.
> 
> > 
> > > The differences from "normal" DSA switches:
> > > 
> > > 1. It uses mapped memory (for its register space) for
> > > configuration/statistics gathering (instead of e.g. SPI, I2C)  
> Hmm...
> 
> I cannot find such chapter in the official documentation from NXP:
> "VFxxx Controller Reference Manual, Rev. 0, 10/2016"

I have

Vybrid Reference Manual
F-Series

Document Number: VYBRIDRM
Rev 7, 06/2014

    Andrew
