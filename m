Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E2AB2B8C6E
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 08:39:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725888AbgKSHgS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 02:36:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbgKSHgS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 02:36:18 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66621C0613CF
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 23:36:18 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1kfeUL-0004Aa-02; Thu, 19 Nov 2020 08:36:17 +0100
Received: from mgr by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1kfeUJ-0007g8-Bv; Thu, 19 Nov 2020 08:36:15 +0100
Date:   Thu, 19 Nov 2020 08:36:15 +0100
From:   Michael Grzeschik <mgr@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, davem@davemloft.net,
        kernel@pengutronix.de, matthias.schiffer@ew.tq-group.com,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH 05/11] net: dsa: microchip: ksz8795: use mib_cnt where
 possible
Message-ID: <20201119073615.GB6507@pengutronix.de>
References: <20201118220357.22292-1-m.grzeschik@pengutronix.de>
 <20201118220357.22292-6-m.grzeschik@pengutronix.de>
 <20201119002047.GI1804098@lunn.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="xXmbgvnjoT4axfJE"
Content-Disposition: inline
In-Reply-To: <20201119002047.GI1804098@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:32:01 up 273 days, 15:02, 83 users,  load average: 0.24, 0.20,
 0.20
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: mgr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--xXmbgvnjoT4axfJE
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew!

On Thu, Nov 19, 2020 at 01:20:47AM +0100, Andrew Lunn wrote:
>On Wed, Nov 18, 2020 at 11:03:51PM +0100, Michael Grzeschik wrote:
>> The variable mib_cnt is assigned with TOTAL_SWITCH_COUNTER_NUM. This
>> value can also be derived from the array size of mib_names. This patch
>> uses this calculated value instead, removes the extra define and uses
>> mib_cnt everywhere possible instead of the static define
>> TOTAL_SWITCH_COUNTER_NUM.
>>
>> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
>> ---
>>  drivers/net/dsa/microchip/ksz8795.c     | 8 ++++----
>>  drivers/net/dsa/microchip/ksz8795_reg.h | 3 ---
>>  2 files changed, 4 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/micro=
chip/ksz8795.c
>> index 04a571bde7e6a4f..6ddba2de2d3026e 100644
>> --- a/drivers/net/dsa/microchip/ksz8795.c
>> +++ b/drivers/net/dsa/microchip/ksz8795.c
>> @@ -23,7 +23,7 @@
>>
>>  static const struct {
>>  	char string[ETH_GSTRING_LEN];
>> -} mib_names[TOTAL_SWITCH_COUNTER_NUM] =3D {
>> +} mib_names[] =3D {
>>  	{ "rx_hi" },
>>  	{ "rx_undersize" },
>>  	{ "rx_fragments" },
>> @@ -656,7 +656,7 @@ static void ksz8795_get_strings(struct dsa_switch *d=
s, int port,
>>  {
>>  	int i;
>>
>> -	for (i =3D 0; i < TOTAL_SWITCH_COUNTER_NUM; i++) {
>> +	for (i =3D 0; i < dev->mib_cnt; i++) {
>>  		memcpy(buf + i * ETH_GSTRING_LEN, mib_names[i].string,
>>  		       ETH_GSTRING_LEN);
>>  	}
>> @@ -1236,7 +1236,7 @@ static int ksz8795_switch_init(struct ksz_device *=
dev)
>>  	dev->port_mask |=3D dev->host_mask;
>>
>>  	dev->reg_mib_cnt =3D KSZ8795_COUNTER_NUM;
>> -	dev->mib_cnt =3D TOTAL_SWITCH_COUNTER_NUM;
>> +	dev->mib_cnt =3D ARRAY_SIZE(mib_names);
>
>Hi Michael
>
>I think it would be better to just use ARRAY_SIZE(mib_names)
>everywhere. It is one less hoop to jump through when looking for array
>overruns, etc.

I would better stay with the variable, because of two reasons. First it
is also used in ksz_common.c and ksz_9477.c. Also in my next patches
I will introduce another mib_names array. We will have ksz8863_mib_names
and ksz8795_mib_names. In the init function then the mib_cnt will be set
regarding to the chip that is found.

Do you agree that the extra variable makes the code more readable in
that case?

Regards,
Michael

--=20
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--xXmbgvnjoT4axfJE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEElXvEUs6VPX6mDPT8C+njFXoeLGQFAl+2IGwACgkQC+njFXoe
LGRtnA//bu7IgpGtFqiafZMdYGKGLcGMxgzYq2OIgnfN5bJNiNyJUXuvaWBG1xVp
yXW2iGymldTE8+bOubLUOGZ67G9hAb4z6WoBx0evsMl6dZXhI0aV+PBDzcteVV6e
aYPouHtdfzTmxeWIWJxc1juJVRzkWYXKTXUsD3xr/Y1QqUADw9Cd08bwJEADC1lq
/vvr2DI3ZZLSV7WtCWbf7pSnycx6evk8xyCiSelfhjARsqiWOboNFSawJkmyQQDT
RqosNWDnNKdgAU+rL3ZSep776ALlhDxjAOy2OOHqH7fy7TYPiafXBgLjDm9mO4Kt
o5YNwFZMz1CAuJStZRATZYeogKYnrb022iUCPEc+8RMba6G9U+XW0yeCT0j8YlCm
RI8035uA9Qa/FPh9pd5KbPMKSEQ9fTUQkQJ3RV9N2iu1jNbJrzhAkIYYS+ZREuLQ
B4Apj1J1zp3nqd6SvHHOmMzGLxkgsymX7OODrriHdP2qKmzH1a1eBaWCJDDhnwGN
5r92+vs2Knaru3YNfunRd2mJ1DJDzWu9MDNKjOgNP2YRNFjySVUVzGd2OKURPznW
ZygFJmBkrx1Usv4WGRUMYcG6FQPK6DsX2n0bzzSfg3xdeMuO1HrjsQBcUQ73H1aD
PO1fujdKu/2xxRAEi6Ed1i3hRTzWvXAPyoLivAWNCKIatCGPyDg=
=CJV4
-----END PGP SIGNATURE-----

--xXmbgvnjoT4axfJE--
