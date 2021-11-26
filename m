Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AFE045F348
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 18:59:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236165AbhKZSCy convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 26 Nov 2021 13:02:54 -0500
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:53513 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238628AbhKZSAy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 13:00:54 -0500
Received: (Authenticated sender: clement.leger@bootlin.com)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id 9EDB0FF808;
        Fri, 26 Nov 2021 17:57:36 +0000 (UTC)
Date:   Fri, 26 Nov 2021 18:57:27 +0100
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Denis Kirjanov <dkirjanov@suse.de>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: Re: [PATCH net-next v3 3/4] net: ocelot: pre-compute injection
 frame header content
Message-ID: <20211126185727.7213fda4@fixe.home>
In-Reply-To: <20211126175454.7md7bauojqlt7kvw@skbuf>
References: <20211126172739.329098-1-clement.leger@bootlin.com>
        <20211126172739.329098-4-clement.leger@bootlin.com>
        <20211126175454.7md7bauojqlt7kvw@skbuf>
Organization: Bootlin
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Fri, 26 Nov 2021 17:54:55 +0000,
Vladimir Oltean <vladimir.oltean@nxp.com> a écrit :

> On Fri, Nov 26, 2021 at 06:27:38PM +0100, Clément Léger wrote:
> > IFH preparation can take quite some time on slow processors (up to 5% in
> > a iperf3 test for instance). In order to reduce the cost of this
> > preparation, pre-compute IFH since most of the parameters are fixed per
> > port. Only rew_op and vlan tag will be set when sending if different
> > than 0. This allows to remove entirely the calls to packing() with basic
> > usage. In the same time, export this function that will be used by FDMA.
> > 
> > Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> > ---  
> 
> If you would move this injection frame header template into struct
> ocelot_port_private instead of struct ocelot_port, I would not have
> anything against it. Because struct ocelot_port is common with DSA,
> whereas struct ocelot_port_private isn't.
> 
> Also, as things stand, all switch drivers call ocelot_init_port, but not
> all supported switches have the same IFH format. See seville_xmit() ->
> seville_ifh_set_dest(). So even though DSA does not use this for
> anything, it wouldn't even contain valid information even if it wanted
> to. So maybe you can move this initialization to some place isolated to
> vsc7514.

Acked, this makes sense, I will do this.

-- 
Clément Léger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
