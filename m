Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63E4849F4E3
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 09:07:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347178AbiA1IHX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 03:07:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347034AbiA1IHW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 03:07:22 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 651F8C061714
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 00:07:22 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nDMHn-0008MM-VU; Fri, 28 Jan 2022 09:07:12 +0100
Received: from pengutronix.de (unknown [195.138.59.174])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 1FB97258C1;
        Fri, 28 Jan 2022 08:07:10 +0000 (UTC)
Date:   Fri, 28 Jan 2022 09:07:04 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>,
        davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] can: isotp: isotp_rcv_cf(): fix so->rx race problem
Message-ID: <20220128080704.ns5fzbyn72wfoqmx@pengutronix.de>
References: <53279d6d-298c-5a85-4c16-887c95447825@hartkopp.net>
 <280e10c1-d1f4-f39e-fa90-debd56f1746d@huawei.com>
 <eaafaca3-f003-ca56-c04c-baf6cf4f7627@hartkopp.net>
 <890d8209-f400-a3b0-df9c-3e198e3834d6@huawei.com>
 <1fb4407a-1269-ec50-0ad5-074e49f91144@hartkopp.net>
 <2aba02d4-0597-1d55-8b3e-2c67386f68cf@huawei.com>
 <64695483-ff75-4872-db81-ca55763f95cf@hartkopp.net>
 <d7e69278-d741-c706-65e1-e87623d9a8e8@huawei.com>
 <97339463-b357-3e0e-1cbf-c66415c08129@hartkopp.net>
 <24e6da96-a3e5-7b4e-102b-b5676770b80e@hartkopp.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="okf44ik46sxcmcxb"
Content-Disposition: inline
In-Reply-To: <24e6da96-a3e5-7b4e-102b-b5676770b80e@hartkopp.net>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--okf44ik46sxcmcxb
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 28.01.2022 08:56:19, Oliver Hartkopp wrote:
> I've seen the frame processing sometimes freezes for one second when
> stressing the isotp_rcv() from multiple sources. This finally freezes
> the entire softirq which is either not good and not needed as we only
> need to fix this race for stress tests - and not for real world usage
> that does not create this case.

Hmmm, this doesn't sound good. Can you test with LOCKDEP enabled?

>=20
> Therefore I created a V2 patch which uses the spin_trylock() to simply dr=
op
> the incomming frame in the race condition.
>=20
> https://lore.kernel.org/linux-can/20220128074327.52229-1-socketcan@hartko=
pp.net/T/
>=20
> Please take a look, if it also fixes the issue in your test setup.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--okf44ik46sxcmcxb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmHzpCUACgkQqclaivrt
76keTwf8DTeqV+BuWMfRr0sG/Kf+YqVkvDMJEAp9BOhrDmAB6eGQJT+NMkuSbxTm
gSKhG19jokryR+ASqS6HEyO9AOa/A+bRi10fB2rGaL8dh0uuOgLkQ0SavIF3cmRg
ngWB0m8SpNuNXsVlC9sW3+oS8wAZWRq4Rqm17oT+clPWfkWOCYK4cYa8kgggUJxr
Wv6T88+Px5s6A5T1vJuWgmdpor+kRwd8XqQAuo5Co/FSS+9/8XDqTCeojq78I0Rj
4U1GqShTYups/UBgAQbQ8my8hg2YKVtcYMlCEMpceL5bXwpJCA75P3DIrJbp6jO0
2UdFQmbulB0gcl6MYbA/X3bdhcIN7w==
=WjFN
-----END PGP SIGNATURE-----

--okf44ik46sxcmcxb--
