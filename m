Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E35942E0C79
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 16:11:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728079AbgLVPJ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 10:09:29 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:37082 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726920AbgLVPJ3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 10:09:29 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1krjHC-00DOur-V5; Tue, 22 Dec 2020 16:08:38 +0100
Date:   Tue, 22 Dec 2020 16:08:38 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Bjarni Jonasson <bjarni.jonasson@microchip.com>
Cc:     Steen Hegelund <steen.hegelund@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Mark Einon <mark.einon@gmail.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH v2 4/8] net: sparx5: add port module support
Message-ID: <20201222150838.GN3107610@lunn.ch>
References: <20201217075134.919699-1-steen.hegelund@microchip.com>
 <20201217075134.919699-5-steen.hegelund@microchip.com>
 <20201220233543.GB3107610@lunn.ch>
 <d728e952c95dff188239d5d5a3c066a3e633af6b.camel@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d728e952c95dff188239d5d5a3c066a3e633af6b.camel@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > +static int sparx5_port_verify_speed(struct sparx5 *sparx5,
> > > +                                 struct sparx5_port *port,
> > > +                                 struct sparx5_port_config *conf)
> > > +{
> > > +     case PHY_INTERFACE_MODE_SGMII:
> > > +             if (conf->speed != SPEED_1000 &&
> > > +                 conf->speed != SPEED_100 &&
> > > +                 conf->speed != SPEED_10 &&
> > > +                 conf->speed != SPEED_2500)
> > > +                     return sparx5_port_error(port, conf,
> > > SPX5_PERR_SPEED);
> > 
> > Is it really SGMII over clocked at 2500? Or 2500BaseX?
> 
> Yes the SGMII mode in the serdes driver is overclocked.
> Nothing in the switch driver needs changing when changing between
> speeds 1G/2G5.

So it continues to use the SGMII inband signalling?

There is a lot of confusion in this area, but SGMII inband signalling
overclocked does not make much sense. So it is more likely to be using
2500BaseX.

	Andrew
