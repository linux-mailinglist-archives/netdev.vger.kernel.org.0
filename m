Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80AFF2B8DC2
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 09:43:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726095AbgKSIkJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 03:40:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725915AbgKSIkJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 03:40:09 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 553B2C0613CF
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 00:40:09 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1kffU7-0002rk-RD; Thu, 19 Nov 2020 09:40:07 +0100
Received: from mgr by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1kffU5-0003U5-Du; Thu, 19 Nov 2020 09:40:05 +0100
Date:   Thu, 19 Nov 2020 09:40:05 +0100
From:   Michael Grzeschik <mgr@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, davem@davemloft.net,
        kernel@pengutronix.de, matthias.schiffer@ew.tq-group.com,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH 06/11] net: dsa: microchip: ksz8795: use phy_port_cnt
 where possible
Message-ID: <20201119084005.GC6507@pengutronix.de>
References: <20201118220357.22292-1-m.grzeschik@pengutronix.de>
 <20201118220357.22292-7-m.grzeschik@pengutronix.de>
 <20201119002915.GJ1804098@lunn.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="p2kqVDKq5asng8Dg"
Content-Disposition: inline
In-Reply-To: <20201119002915.GJ1804098@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:34:39 up 273 days, 16:05, 89 users,  load average: 0.11, 0.16,
 0.16
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: mgr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--p2kqVDKq5asng8Dg
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 19, 2020 at 01:29:15AM +0100, Andrew Lunn wrote:
>>  	case BR_STATE_DISABLED:
>>  		data |=3D PORT_LEARN_DISABLE;
>> -		if (port < SWITCH_PORT_NUM)
>> +		if (port < dev->phy_port_cnt)
>>  			member =3D 0;
>>  		break;
>
>So this, unlike all the other patches so far, is not obviously
>correct. What exactly does phy_port_cnt mean? Can there be ports
>without PHYs? What if the PHYs are external? You still need to be able
>to change the STP state of such ports.

The variable phy_port_cnt is referring to all external physical
available ports, that are not connected internally to the cpu.

That means that the previous code path was already broken, when stp
handling should include the cpu_port.

Michael

--=20
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--p2kqVDKq5asng8Dg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEElXvEUs6VPX6mDPT8C+njFXoeLGQFAl+2L18ACgkQC+njFXoe
LGQ/WQ/9HGEzsAistMi2l+j1rniUzAQRZKwHnx2KiK/haTh0oxfQiHnTNt7PhkZJ
Q5KgrOL1982Z1VTN5W0gBSNZhO1KifZHP/cQT8adwyGYXEOq+smr3sPraoym3tyl
XbssYolaxc2j7P9kRAUWn6b2U+o9oL5yw5St3UWhIL52E3ErjKj6nxF0YYEqEB8j
MXo7Fj5W5w5gUlBbm7h8ChDHHHfaZhaRQUCMueZcqDmfpyoySShv4xlgiu5X/bPU
HN1aBy/0pnmpAiqj4ldaH3kBTK0jVs6T/KxuKW5XTVaWN4aS7qplmcIn0QRP86+Q
ptdDqnWxvxb04Fu51Ai6w3glZJefmC5Dw/bdfj0DixKcksDwe4yAzUsO0v1wG/HQ
f2NSylzsXQL9JYNoU/XUXmeAzV++7TJy3rEfTQwlY++axL7h0jkuSBw4wuGhjzIc
sFPERoLjl3rR8pzONRSpSd0mwQpStOnrqdqa+YzGyDq2uq3VJA3JgkN87wKn2DC+
t890kxfzudwwoAVQAw0Qy2XtAvxgg+lv4yhimS485juDfMk6jlNvzPCNcIs/c7hZ
YRhvtLSmeXaLoF1IW5DfHCluiHpOGlM6Z88m0HnpA6c8BxUpWL9yh35wtumFESol
0RSdUJDEbXv4HE0xc3a74X5LZlfGnCRj/WG7QfTHmSgmqBwdUw8=
=ot/D
-----END PGP SIGNATURE-----

--p2kqVDKq5asng8Dg--
