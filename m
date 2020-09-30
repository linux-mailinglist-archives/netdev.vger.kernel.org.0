Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31F9227EA6A
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 15:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730403AbgI3N5h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 09:57:37 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35890 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729903AbgI3N5g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 09:57:36 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kNcbl-00GuLn-II; Wed, 30 Sep 2020 15:57:25 +0200
Date:   Wed, 30 Sep 2020 15:57:25 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH net-next v2 1/7] net: devlink: Add unused port flavour
Message-ID: <20200930135725.GH3996795@lunn.ch>
References: <20200928220507.olh77t464bqsc4ll@skbuf>
 <20200928220730.GD3950513@lunn.ch>
 <20200928153504.1b39a65d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <61860d84-d0c6-c711-0674-774149a8d0af@gmail.com>
 <20200928163936.1bdacb89@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <c877bda0-140c-dce1-49ff-61fac47a66bc@gmail.com>
 <20200929110356.jnqoyy72bjer6psw@skbuf>
 <20200929130758.GF8264@nanopsycho>
 <20200929135700.GG3950513@lunn.ch>
 <20200930065604.GI8264@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200930065604.GI8264@nanopsycho>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I get it. But I as I wrote previously, I wonder if used/unused should
> not be another attribute. Then the flavour can be "undefined".

In the DSA world, it is not undefined. It is clear defined as
unused. And it cannot be on-the-fly changed. It is a property of the
PCB, in that the pins exist on the chip, but they simply don't go
anywhere on the PCB. This is quite common on appliances, e.g. The
switch has 7 ports, but the installation in the aircraft is a big
ring, so there is a 'left', 'right', 'aux' and the CPU port. That
leaves 3 ports totally unused.

> But, why do you want to show "unused" ports? Can the user do something
> with them? What is the value in showing them?

Because they are just ports, they can have regions. We can look at the
region and be sure they are powered off, the boot loader etc has not
left them in a funny state, bridged to other ports, etc.

Regions are a developers tool, not a 'user' tools. So the idea of
hiding them by default in 'devlink port show' does make some sense,
and have a flag like -d for details, which includes them. In 'devlink
region show' i would probably list all regions, independent of any -d
flag.

      Andrew
