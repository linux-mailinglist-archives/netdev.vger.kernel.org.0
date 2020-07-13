Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35DF021CFBE
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 08:34:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729246AbgGMGeF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 02:34:05 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:33822 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728341AbgGMGeF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 02:34:05 -0400
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1594622042;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gz+RIm1i6Cxy/hPxPhdgJ4qdopKz9kcCzsUPWt0a7wI=;
        b=VfSGc/WEcM2Ax8+jDkDCk9hozs3LCylBXjVMp96uLgrYUAIODJq9cgelWM9lDyXoYyUxJ7
        51Ke0beLlzkA+utFpF+E3GzKY5FDu4/1Fjm6LwidBZpJeIpm3yFHt5uzsqaLq6wyRxGv5i
        0xLHyEsm12qrQPpb9E6HBSK/vcfQ5vaIAq56CX2DbEOpwTFA1Cmwvu58iKZ3/ph8A5xhAf
        LxGKKD4rEWdrNuZDXY37uaD+I8Jp0K8gin+ztLPeI2dYKRZ22fvY0JvW/Az0hxKNhWoDqa
        /duvqRIyXUDSDdqp8VDVamuV8Va+SqD6w2p1AV5wO0sfN5xu8QbIpgdeZLvfhQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1594622042;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gz+RIm1i6Cxy/hPxPhdgJ4qdopKz9kcCzsUPWt0a7wI=;
        b=FWZNe1tj23kCX7H9YJmZUxLGEG9TasEh9fR/UD/OmpnjjJ7eCfhn1lYOShHivtb7cb3V3f
        pGwIUdmvZfr88ZBg==
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org, Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH v1 3/8] net: dsa: hellcreek: Add PTP clock support
In-Reply-To: <01981d4a-6e28-2789-6d15-5d825e7ce09b@gmail.com>
References: <20200710113611.3398-1-kurt@linutronix.de> <20200710113611.3398-4-kurt@linutronix.de> <01981d4a-6e28-2789-6d15-5d825e7ce09b@gmail.com>
Date:   Mon, 13 Jul 2020 08:34:01 +0200
Message-ID: <87sgdvncti.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat Jul 11 2020, Florian Fainelli wrote:
> On 7/10/2020 4:36 AM, Kurt Kanzenbach wrote:
>> From: Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>
>>=20
>> The switch has internal PTP hardware clocks. Add support for it. There a=
re three
>> clocks:
>>=20
>>  * Synchronized
>>  * Syntonized
>>  * Free running
>>=20
>> Currently the synchronized clock is exported to user space which is a go=
od
>> default for the beginning. The free running clock might be exported later
>> e.g. for implementing 802.1AS-2011/2020 Time Aware Bridges (TAB). The sw=
itch
>> also supports cross time stamping for that purpose.
>>=20
>> The implementation adds support setting/getting the time as well as offs=
et and
>> frequency adjustments. However, the clock only holds a partial timeofday
>> timestamp. This is why we track the seconds completely in software (see =
overflow
>> work and last_ts).
>>=20
>> Furthermore, add the PTP multicast addresses into the FDB to forward that
>> packages only to the CPU port where they are processed by a PTP program.
>>=20
>> Signed-off-by: Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>
>> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
>
> Are not you missing an depends on PTP_1588_CLOCK somewhere?

Most likely. Thanks!

>
>> ---
>
> [snip]
>
>>=20=20
>> +static int hellcreek_setup_fdb(struct hellcreek *hellcreek)
>> +{
>> +	static struct hellcreek_fdb_entry ptp =3D {
>> +		/* MAC: 01-1B-19-00-00-00 */
>> +		.mac	      =3D { 0x01, 0x1b, 0x19, 0x00, 0x00, 0x00 },
>> +		.portmask     =3D 0x03,	/* Management ports */
>
> Should not this depend on the actual number of ports enabled by the user
> and so it would be more logical to program those entries (or update
> them) at port_enable() time?

For me this is a switch configuration. It means forward all PTP traffic
to the switch's CPU port and therefore it doesn't depend on the enabled
ports.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl8MAFkACgkQeSpbgcuY
8KZGUhAAtNX9yACTWdGjQh/xcyeLMxfc8wgMY2SHn22kQPwsLYCQlNB36VOq0oE0
05hNIdK2BRhcVIAO8XK611PkAVHmGuCMl6JXJ9X/zShjZBM6Fq9f3bgFBLSfc97B
zLhRYz7u6vGMPzwwRWtNjY+Op7VirtSYvnGZNqEWoC2rtnA1TIXz2GKbzuOIeO5p
NgVy2sOkfnAoTH3dYvLQwCOeZGM9h4oJxd5Tl6tGrdYMqO6DxYXvlc5cxIh0TmPM
fWgkuvyETqxGJPalVSmOwZS26EjbYobdJWsjPO5LBysy4LDkXG0ZuUm/K08ONkkq
pUn3nF1eVNK4mvbe4CtjFPm54vgv27BXQlzZARP1Ln8sdJ73G/Ea0Ug66MWNqO2r
ITjDKCUOVKFEGkkDwCrNLzE6kDwT1PCTnIkKRRr4QZeirUaKnca4jQBnRaBSToW6
CC/6H8AUWIA3tdg+XoG4VuBkO/TUT+wxZbK1UHcnTVD6FIptQI7/3yF0sfE1FPvT
hKP98aO+0uvoK07dVb3i3KUNrPrEbAvN93hWqzXcPXRnay5S1mHQosyJwBaDFsLN
LQkAg7lW34f5EJ3NRfOUn7mNlQbpH5xZcVHYEfqPK0thq9Gm78p/W3PQmkI9g8fy
l3lanOwBeS8qDrK3BDv326s+y7vkAn6rB1S5M0HPXp0001BP/kI=
=rWdt
-----END PGP SIGNATURE-----
--=-=-=--
