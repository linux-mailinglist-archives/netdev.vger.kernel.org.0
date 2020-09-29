Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AAE427D00D
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 15:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729978AbgI2N5L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 09:57:11 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33612 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728917AbgI2N5L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 09:57:11 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kNG7o-00GlHG-Fv; Tue, 29 Sep 2020 15:57:00 +0200
Date:   Tue, 29 Sep 2020 15:57:00 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH net-next v2 1/7] net: devlink: Add unused port flavour
Message-ID: <20200929135700.GG3950513@lunn.ch>
References: <20200926210632.3888886-2-andrew@lunn.ch>
 <20200928143155.4b12419d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200928220507.olh77t464bqsc4ll@skbuf>
 <20200928220730.GD3950513@lunn.ch>
 <20200928153504.1b39a65d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <61860d84-d0c6-c711-0674-774149a8d0af@gmail.com>
 <20200928163936.1bdacb89@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <c877bda0-140c-dce1-49ff-61fac47a66bc@gmail.com>
 <20200929110356.jnqoyy72bjer6psw@skbuf>
 <20200929130758.GF8264@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200929130758.GF8264@nanopsycho>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29, 2020 at 03:07:58PM +0200, Jiri Pirko wrote:
> Tue, Sep 29, 2020 at 01:03:56PM CEST, vladimir.oltean@nxp.com wrote:
> >On Mon, Sep 28, 2020 at 06:46:14PM -0700, Florian Fainelli wrote:
> >> That makes sense to me as it would be confusing to suddenly show unused port
> >> flavors after this patch series land. Andrew, Vladimir, does that work for
> >> you as well?
> >
> >I have nothing to object against somebody adding a '--all' argument to
> >devlink port commands.
> 
> How "unused" is a "flavour"? It seems to me more like a separate
> attribute as port of any "flavour" may be potentially "unused". I don't
> think we should mix these 2.

Hi Jiri

Current flavours are:

enum devlink_port_flavour {
        DEVLINK_PORT_FLAVOUR_PHYSICAL, /* Any kind of a port physically
                                        * facing the user.
                                        */
        DEVLINK_PORT_FLAVOUR_CPU, /* CPU port */
        DEVLINK_PORT_FLAVOUR_DSA, /* Distributed switch architecture
                                   * interconnect port.
                                   */
        DEVLINK_PORT_FLAVOUR_PCI_PF, /* Represents eswitch port for
                                      * the PCI PF. It is an internal
                                      * port that faces the PCI PF.
                                      */
        DEVLINK_PORT_FLAVOUR_PCI_VF, /* Represents eswitch port
                                      * for the PCI VF. It is an internal
                                      * port that faces the PCI VF.
                                      */
        DEVLINK_PORT_FLAVOUR_VIRTUAL, /* Any virtual port facing the user. */
};

A port in the DSA world is generally just a port on the switch. It is
not limited in nature. It can be used as a PHYSICAL, or CPU, or a DSA
port. We don't consider them as unused PHYISCAL ports, or unused CPU
ports. They are just unused ports. Which is why i added an UNUSED
flavour.

Now, it could be this world view is actually just a DSA world
view. Maybe some ASICs have strict roles for their ports? They are not
configurable? And then i could see it being an attribute? But that
messes up the DSA world view :-(

      Andrew
