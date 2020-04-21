Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28C8C1B29D0
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 16:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728974AbgDUOcA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 10:32:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728881AbgDUOcA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 10:32:00 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A5E2C061A10
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 07:32:00 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1jQtwM-00016p-Kh; Tue, 21 Apr 2020 16:31:58 +0200
Received: from mgr by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1jQtwK-0003zO-Lj; Tue, 21 Apr 2020 16:31:56 +0200
Date:   Tue, 21 Apr 2020 16:31:56 +0200
From:   Michael Grzeschik <mgr@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, davem@davemloft.net,
        kernel@pengutronix.de
Subject: Re: [PATCH] mdio-bitbang: add support for lowlevel mdio read/write
Message-ID: <20200421143156.GD2338@pengutronix.de>
References: <20191107154201.GF7344@lunn.ch>
 <20191218162919.5293-1-m.grzeschik@pengutronix.de>
 <20191221164110.GL30801@lunn.ch>
 <20200129154201.oaxjbqkkyifvf5gg@pengutronix.de>
 <20200129155346.GG12180@lunn.ch>
 <20200129214805.l4djnzrzpk7inkvk@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="xo44VMWPx7vlQ2+2"
Content-Disposition: inline
In-Reply-To: <20200129214805.l4djnzrzpk7inkvk@pengutronix.de>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 16:23:14 up 61 days, 21:53, 108 users,  load average: 0.34, 0.27,
 0.23
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: mgr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--xo44VMWPx7vlQ2+2
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

I want to refresh this thread.

On Wed, Jan 29, 2020 at 10:48:05PM +0100, Michael Grzeschik wrote:
>On Wed, Jan 29, 2020 at 04:53:46PM +0100, Andrew Lunn wrote:
>> On Wed, Jan 29, 2020 at 04:42:01PM +0100, Michael Grzeschik wrote:
>> > Hi Andrew!
>> >
>> > I tested your patch. But it works only partially. For the case that
>> > the upper driver is directly communicating in SMI mode with the phy,
>> > this works fine. But the regular MDIO connection does not work anymore
>> > afterwards.
>> >
>> > The normals MDIO communication still needs to work, as mdio-gpio is
>> > calling of_mdiobus_register that on the other end calls get_phy_device
>> > and tries to communicate via regular MDIO to the device.
>>
>> Do you mean you have a mix of devices on the bus, some standards
>> comformant, and others using this hacked up SMI0 mode?
>
>Actually it is the same device used in both modes. The SMI0
>mode is used by the switch driver to address the extended switch
>functions. But on the same bus we have the fec connected to
>the cpu bound fixed-phy (microchip,ks8863) via MDIO.
>
>> You need to specify per device if SMI0 should be used?
>
>Yes, we have to use the same bus fot both modes SMI0 and MDIO.

In fact I for now used the cpu bound port with phy-handle to the fec.
This way it still used mdio for the initial probe.

But it should also work to use fixed-phy for it don't run into mdio
communication on the same bus. This way your patch should work.

In case you did not think of anything else, I will send the series
including your patch after I tested it with master.

Regards,
Michael

--=20
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--xo44VMWPx7vlQ2+2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEElXvEUs6VPX6mDPT8C+njFXoeLGQFAl6fA9IACgkQC+njFXoe
LGSBnQ/9G1YZbHcWoE8h+DKZe8wjwDAdBuYHnQ1lPgNexSs9t1UTKnx02rjhjbhF
4qmASLeIMWYP68vADrM3jEWg1br4CqK5YaCgcccL6dqAmVwZKBU48aV8y1ReRLfD
wIr8nubOFu0KLREMM3jek/tSvIg/6NFmF3lhPGDu1tzoMh1CJ/PuDy9LmTPY7zuc
jo4AZKpqRySIfAZ1kXYL8yr1z+tx+KAPwGFXzlRqPRrPLioQqALnNts5sDcxSPjt
/jPthxmL4J0rE48EBdP+U83PiZPVe8CbO+EZQ62g7wS6lSHOSP3EFhtYg/MBH/7o
1uRJ92ez1kmIy4AciAJ20a2RkCV/NT29pw8y6GaoiK/YvgbTxmgpt2N/XKT/RStY
u56hWSkEOuxgg2arn+FBJulYbAiTMUyOz2j8dWreJAnOa7o7nbl75ABlhiXPlStx
KAgVLmit+8rJFUnbZ2TlNuGRUg2psJZRg86YRGXasE8DrhUGAHRAUhmyNfJ/vm8J
Pc1Y7HrGxmRp0c+QllnzWSm5qnV12TqS7uSrxfwRGkBPSaP+vHlyPY4KvLuM15QP
TWx11isyhxeFjZg+qyLxuhLnHY2L5gScaS3iqCGzIN+LpChkUTYY88APgCYuit8V
cgAKvXuyHDywLTAyLn2A/AMnwlHfzaJtJMCnFFPaPAvihf2Oqnk=
=s2j3
-----END PGP SIGNATURE-----

--xo44VMWPx7vlQ2+2--
