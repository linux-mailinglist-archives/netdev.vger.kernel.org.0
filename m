Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B0AA2E0D98
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 17:58:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727618AbgLVQ4u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 11:56:50 -0500
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:62701 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726991AbgLVQ4u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 11:56:50 -0500
X-Originating-IP: 176.167.34.245
Received: from localhost (unknown [176.167.34.245])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id 75EA424000E;
        Tue, 22 Dec 2020 16:56:03 +0000 (UTC)
Date:   Tue, 22 Dec 2020 17:56:00 +0100
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Steen Hegelund <steen.hegelund@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Mark Einon <mark.einon@gmail.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH v2 2/8] net: sparx5: add the basic sparx5 driver
Message-ID: <20201222165600.GE3819852@piout.net>
References: <20201217075134.919699-1-steen.hegelund@microchip.com>
 <20201217075134.919699-3-steen.hegelund@microchip.com>
 <20201219191157.GC3026679@lunn.ch>
 <37309f64bf0bb94e55bc2db4c482c1e3e7f1be6f.camel@microchip.com>
 <20201222150122.GM3107610@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201222150122.GM3107610@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22/12/2020 16:01:22+0100, Andrew Lunn wrote:
> > The problem is that the switch core reset also affects (reset) the
> > SGPIO controller.
> > 
> > We tried to put this in the reset driver, but it was rejected. If the
> > reset is done at probe time, the SGPIO driver may already have
> > initialized state.
> > 
> > The switch core reset will then reset all SGPIO registers. 
> 
> Ah, O.K. Dumb question. Why is the SGPIO driver a separate driver? It
> sounds like it should be embedded inside this driver if it is sharing
> hardware.
> 
> Another option would be to look at the reset subsystem, and have this
> driver export a reset controller, which the SGPIO driver can bind to.
> Given that the GPIO driver has been merged, if this will work, it is
> probably a better solution.
> 

That was my suggestion. Then you can ensure from the reset controller
driver that this is done exactly once, either from the sgpio driver or
from the switchdev driver. IIRC, the sgpio from the other SoCs are not
affected by the reset.


-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
