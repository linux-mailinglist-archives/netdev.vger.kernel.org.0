Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C96746733C
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 09:27:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356960AbhLCIau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 03:30:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244052AbhLCIau (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 03:30:50 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87048C06173E
        for <netdev@vger.kernel.org>; Fri,  3 Dec 2021 00:27:26 -0800 (PST)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1638520044;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=g0fx3UXWMVoGzPBk5fEDKu36ASA9VIkThUlF3tQh6AM=;
        b=VI4llcgLfEdPMISgewnoVfuVuGD4mD5MjdVjhVQm7Vfc5jzMsExYg7icjisYi2dCaLtvZo
        yJA3N/ZDVfXZsVSeFxR9G1l8WFO0yqi5k3XABg2VI9UakC3Esp11plyFLkm/q5JK1wB4Ua
        tIo5a+IthCffzEpWOvp0xAmL0is9M0EziqlJSfa/0otugp2kZ8jWLYEIMD0QqC4fLzB/GR
        sLL7HFsmwhnwJf2whikAmgrIG9F4JFqcovOSfiMX6OKvhR2+pxwgsQ8Bwo5yrBBi0g5E0Y
        qe85xvHKjjiwURNgyLs0fc4tzo8O7+jGNv20CZcbEMpXdFvrRDCIMdHuWqNPkw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1638520044;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=g0fx3UXWMVoGzPBk5fEDKu36ASA9VIkThUlF3tQh6AM=;
        b=xONYmP+dLt99odrQflOpZ0+in59HYjIoiWeQD+FmAD6ZFYMBeel0rd2WznkMUTDvwffTOn
        FMUAgiZlOft4JFCg==
To:     Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Po Liu <po.liu@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Antoine Tenart <atenart@kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "Y.B. Lu" <yangbo.lu@nxp.com>, Rui Sousa <rui.sousa@nxp.com>,
        "Allan W . Nielsen" <allan.nielsen@microchip.com>
Subject: Re: [PATCH net-next 4/4] net: mscc: ocelot: set up traps for PTP
 packets
In-Reply-To: <20211126170801.GF27081@hoboy.vegasvil.org>
References: <20211125232118.2644060-1-vladimir.oltean@nxp.com>
 <20211125232118.2644060-5-vladimir.oltean@nxp.com>
 <20211126165847.GD27081@hoboy.vegasvil.org>
 <20211126170112.cw53nmeb6usv63bl@skbuf>
 <20211126170801.GF27081@hoboy.vegasvil.org>
Date:   Fri, 03 Dec 2021 09:27:22 +0100
Message-ID: <87ilw66ql1.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Richard,

On Fri Nov 26 2021, Richard Cochran wrote:
> On Fri, Nov 26, 2021 at 05:01:13PM +0000, Vladimir Oltean wrote:
>
>> This, to me, sounds more like the bridge trapping the packets on br0
>> instead of letting them flow on the port netdevices, which is solved by
>> some netfilter rules? Or is it really a driver/hardware issue?
>>=20
>> https://lore.kernel.org/netdev/20211116102138.26vkpeh23el6akya@skbuf/
>
> Yeah, thanks for the link.  I had seen it, but alas it came too late
> for me to try on actual working HW.  Maybe it fixes the issue.
>
> If someone out there has a Marvell switch, please try it and let us
> know...

I did some testing on a Marvell Topaz switch (mv88e6341). The Boundary
Clock over UDPv4/UDPv6 using Vladimir's netfilter rules doesn't
work. Even though I've successfully tested these rules on TI CPSW
(switchdev variant) and hellcreek.

However, BC over Layer 2 transport is also not really working well, as
the switch forwards PTP packets (instead of trapping?). Furthermore,
ptp4l reports loosing of timestamps when running on multiple switch
ports.

Tested with Linux v5.16.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAmGp1OoTHGt1cnRAbGlu
dXRyb25peC5kZQAKCRB5KluBy5jwplKmEACRSr0usMLtxIedkkwdRDvswJoMxzaQ
tmBIJtSr3VPNZh/HhPUY8D4GAIIe+wfs/T0ZH/IyWn5TQd8cvH4m/4qSgg7pAukU
uaXKRwnkas41PnRjC5ptesv2N+N6XwepkOMH4Nk+mliRi18c+tRvgtHSGOOWiacE
tf5ztBkMvpx7kRnYJELCmRz+4xiEqDL0uAold02kD3DwVT16sYSkWoBdyGtiotRR
r9ngK0JkQCfMXzXnO8yTFw4+PmChqt+0Qy0n4H8ZzjYv3l2nS7aKyobvqgBdyLRj
wb5bAgRh1MGKn2JfTniIopY3MfhgUZmxojiBRMl9eLutdubuazTWHqu0+lxgy4XM
hG2XHHj+4soVqqBtKuP2c5NvHfj/B1EKzMgAmxZVIoM2mNFOWkflRl+eE7epG2N8
opYxbim9jfoIl5Fjl4/EgTbYvPTxBQK194aatYu+D143VGAoOu/wwcw3oNerH2+A
Uo5HNH8I44ApuCKhGoX8clwR1XxN3aw1SlPwymULobPUtx9wwQe34zTIx8suaT7N
oLdv4OH/eXe/SMuaYXibKYFoPAbfqkklEGZsk2Thhegi8xiGJjuoUAEW4FuW28Sb
5arLuKa5bP0d969u9IUukAD4/txPxoQ+PhOyzEJXzW6Dq+qepT2TneZ3qWHOaaxx
N27DQQauFpyEOA==
=x4GW
-----END PGP SIGNATURE-----
--=-=-=--
