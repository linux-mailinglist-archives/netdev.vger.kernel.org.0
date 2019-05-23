Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB33E280B4
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 17:12:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730940AbfEWPMP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 11:12:15 -0400
Received: from relay11.mail.gandi.net ([217.70.178.231]:43603 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730709AbfEWPMP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 11:12:15 -0400
Received: from bootlin.com (aaubervilliers-681-1-80-185.w90-88.abo.wanadoo.fr [90.88.22.185])
        (Authenticated sender: maxime.chevallier@bootlin.com)
        by relay11.mail.gandi.net (Postfix) with ESMTPSA id 7EA15100008;
        Thu, 23 May 2019 15:12:10 +0000 (UTC)
Date:   Thu, 23 May 2019 17:12:12 +0200
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [RFC PATCH net-next 0/9] Decoupling PHYLINK from struct
 net_device
Message-ID: <20190523171212.17f21d16@bootlin.com>
In-Reply-To: <20190523011958.14944-1-ioana.ciornei@nxp.com>
References: <20190523011958.14944-1-ioana.ciornei@nxp.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Ioana,

On Thu, 23 May 2019 01:20:36 +0000
Ioana Ciornei <ioana.ciornei@nxp.com> wrote:

>Following two separate discussion threads in:
>  https://www.spinics.net/lists/netdev/msg569087.html
>and:
>  https://www.spinics.net/lists/netdev/msg570450.html
>
>PHYLINK was reworked in order to add a new "raw" interface, alongside
>the one based on struct net_device. The raw interface works by passing
>structures to the owner of the phylink instance through a blocking
>notifier call.
>
>The event API exposed by the new notifier mechanism is a 1:1 mapping to
>the existing PHYLINK mac_ops, plus the PHYLINK fixed-link callback.
>
>PHYLIB (which PHYLINK uses) was reworked to the extent that it does not
>crash when connecting to a PHY and the net_device pointer is NULL.
>
>Lastly, DSA has been reworked in its way that it handles PHYs for ports
>that lack a net_device (CPU and DSA ports).  For these, it was
>previously using PHYLIB and is now using the PHYLINK raw API.

Thanks for this series, I've tested it and it does address the
particular issue I having, with the DSA fixed-link CPU port. I've been
able to use 2500 and 10000 Mbps links with your series, on a board
using a 88e6390X (so, the mv88e6xxx driver).

I've also tested it on boards using PPv2, which uses phylink, and
didn't spot any issue, so this looks fine.

I'll be happy to test future versions,

Thanks,

Maxime
