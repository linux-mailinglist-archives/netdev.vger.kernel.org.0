Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CABCE17E15C
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 14:38:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbgCINir (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 09:38:47 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:54861 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726427AbgCINir (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 09:38:47 -0400
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1jBIcG-0001sx-Tq; Mon, 09 Mar 2020 14:38:44 +0100
Received: from sha by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1jBIcG-00069j-Bl; Mon, 09 Mar 2020 14:38:44 +0100
Date:   Mon, 9 Mar 2020 14:38:44 +0100
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v3 2/3] fsl/fman: tolerate missing MAC address
 in device tree
Message-ID: <20200309133844.GN3335@pengutronix.de>
References: <1583428138-12733-1-git-send-email-madalin.bucur@oss.nxp.com>
 <1583428138-12733-3-git-send-email-madalin.bucur@oss.nxp.com>
 <20200309064635.GB3335@pengutronix.de>
 <DB8PR04MB6985A0B6A4811DCD5C7B8A6AECFE0@DB8PR04MB6985.eurprd04.prod.outlook.com>
 <20200309131010.GM3335@pengutronix.de>
 <DB8PR04MB698525B2380A452FADDF9D81ECFE0@DB8PR04MB6985.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DB8PR04MB698525B2380A452FADDF9D81ECFE0@DB8PR04MB6985.eurprd04.prod.outlook.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 14:36:20 up 18 days, 21:06, 50 users,  load average: 0.14, 0.12,
 0.10
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 09, 2020 at 01:21:16PM +0000, Madalin Bucur (OSS) wrote:
> > -----Original Message-----
> > From: Sascha Hauer <s.hauer@pengutronix.de>
> > Sent: Monday, March 9, 2020 3:10 PM
> > To: Madalin Bucur (OSS) <madalin.bucur@oss.nxp.com>
> > Cc: davem@davemloft.net; netdev@vger.kernel.org
> > Subject: Re: [PATCH net-next v3 2/3] fsl/fman: tolerate missing MAC
> > address in device tree
> > 
> > On Mon, Mar 09, 2020 at 10:17:36AM +0000, Madalin Bucur (OSS) wrote:
> > > > -----Original Message-----
> > > > From: Sascha Hauer <s.hauer@pengutronix.de>
> > > > Sent: Monday, March 9, 2020 8:47 AM
> > > > To: Madalin Bucur (OSS) <madalin.bucur@oss.nxp.com>
> > > > Cc: davem@davemloft.net; netdev@vger.kernel.org
> > > > Subject: Re: [PATCH net-next v3 2/3] fsl/fman: tolerate missing MAC
> > > > address in device tree
> > > >
> > > > On Thu, Mar 05, 2020 at 07:08:57PM +0200, Madalin Bucur wrote:
> > > > > Allow the initialization of the MAC to be performed even if the
> > > > > device tree does not provide a valid MAC address. Later a random
> > > > > MAC address should be assigned by the Ethernet driver.
> > > > >
> > > > > Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> > > > > Signed-off-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
> > > > > ---
> > > > >  drivers/net/ethernet/freescale/fman/fman_dtsec.c | 10 ++++------
> > > > >  drivers/net/ethernet/freescale/fman/fman_memac.c | 10 ++++------
> > > > >  drivers/net/ethernet/freescale/fman/fman_tgec.c  | 10 ++++------
> > > > >  drivers/net/ethernet/freescale/fman/mac.c        | 13 ++++++------
> > -
> > > > >  4 files changed, 18 insertions(+), 25 deletions(-)
> > > > >
> > > <snip>
> > > > >  	/* Get the MAC address */
> > > > >  	mac_addr = of_get_mac_address(mac_node);
> > > > > -	if (IS_ERR(mac_addr)) {
> > > > > -		dev_err(dev, "of_get_mac_address(%pOF) failed\n",
> > mac_node);
> > > > > -		err = -EINVAL;
> > > > > -		goto _return_of_get_parent;
> > > > > -	}
> > > > > -	ether_addr_copy(mac_dev->addr, mac_addr);
> > > > > +	if (IS_ERR(mac_addr))
> > > > > +		dev_warn(dev, "of_get_mac_address(%pOF) failed\n",
> > mac_node);
> > > >
> > > > Why this warning? There's nothing wrong with not providing the MAC in
> > > > the device tree.
> > > >
> > > > Sascha
> > >
> > > Actually, there is, most likely it's the result of misconfiguration so
> > one
> > > must be made aware of it.
> > 
> > In my case it's not, that's why I wanted to allow random MACs in the
> > first place ;)
> > 
> > On our hardware the MAC addresses are stored in some flash in a special
> > format. There's no need to port parsing of that format into the
> > bootloader, the existing userspace code does that well and sets the
> > desired MAC addresses, but only if the devices do not fail during probe
> > due to the lack of valid MAC addresses.
> > 
> > Sascha
> 
> What MAC address does the bootloader use then?

None. The ethernet controllers are unused in the bootloader. They are
connected to the FPGA only anyway, which doesn't even have firmware
loaded in the bootloader. We have a USB Ethernet dongle for use in the
bootloader.

Sascha

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
