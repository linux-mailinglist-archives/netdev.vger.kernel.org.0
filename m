Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B972F231CB3
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 12:29:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbgG2K3L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 06:29:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726449AbgG2K3L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 06:29:11 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 195AEC061794
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 03:29:11 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1596018549;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3i3iiYS6EHEM6i6MP/ljJQp5KX/BMTf68k3nUiKyfiA=;
        b=HuxE7MWu6za66LXgHtuklNtNeaWj+UhQHWE3HQByC6wyOf4QeanBdVkAPNfvMgovrHXKDI
        fsE6XfJcku/uKDtzjbtYfelhzOq/6S6uYrhpOP3Hg59Bi33mWRN0wyLCrX1J+vdUwtWLLe
        +RprBxbKbtxzGCHMf/CCyGbB6dPCXo8HnmAAO/h+jeKjeI47L8oj9VL+TeOlulHbPzZeWW
        MleTOt3zs0emyDXS1R0ZRRLlEb1qcpLs0yD7NTle+6Cr0PJcTDoWS76hgtajX3He7T5zXC
        AYP2mw0AwgQE+6pj05R3bU4eVlkoHTa/W9dOAzZLxRb4lvHTPKhFk8WdxtCBxQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1596018549;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3i3iiYS6EHEM6i6MP/ljJQp5KX/BMTf68k3nUiKyfiA=;
        b=MlOJwcCV8lWgi3zTLvegnZWLsv27qui5Bo7Ktp73uL7GpoeQWGigGLMEEZtGv/GSkLsSJf
        vovOQOILHBaTTgDQ==
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Petr Machata <petrm@mellanox.com>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Samuel Zou <zou_wei@huawei.com>, netdev@vger.kernel.org
Subject: Re: [PATCH v2 4/9] mlxsw: spectrum_ptp: Use generic helper function
In-Reply-To: <20200729100257.GX1551@shell.armlinux.org.uk>
References: <20200727090601.6500-1-kurt@linutronix.de> <20200727090601.6500-5-kurt@linutronix.de> <87a6zli04l.fsf@mellanox.com> <875za7sr7b.fsf@kurt> <87pn8fgxj3.fsf@mellanox.com> <20200729100257.GX1551@shell.armlinux.org.uk>
Date:   Wed, 29 Jul 2020 12:29:08 +0200
Message-ID: <87sgdaaa2z.fsf@kurt>
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

On Wed Jul 29 2020, Russell King - ARM Linux admin wrote:
> On Tue, Jul 28, 2020 at 11:06:08PM +0200, Petr Machata wrote:
>>=20
>> Kurt Kanzenbach <kurt@linutronix.de> writes:
>>=20
>> > On Mon Jul 27 2020, Petr Machata wrote:
>> >> So this looks good, and works, but I'm wondering about one thing.
>> >
>> > Thanks for testing.
>> >
>> >>
>> >> Your code (and evidently most drivers as well) use a different check
>> >> than mlxsw, namely skb->len + ETH_HLEN < X. When I print_hex_dump()
>> >> skb_mac_header(skb), skb->len in mlxsw with some test packet, I get e=
.g.
>> >> this:
>> >>
>> >>     00000000259a4db7: 01 00 5e 00 01 81 00 02 c9 a4 e4 e1 08 00 45 00=
  ..^...........E.
>> >>     000000005f29f0eb: 00 48 0d c9 40 00 01 11 c8 59 c0 00 02 01 e0 00=
  .H..@....Y......
>> >>     00000000f3663e9e: 01 81 01 3f 01 3f 00 34 9f d3 00 02 00 2c 00 00=
  ...?.?.4.....,..
>> >>                             ^sp^^ ^dp^^ ^len^ ^cks^       ^len^
>> >>     00000000b3914606: 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00 02=
  ................
>> >>     000000002e7828ea: c9 ff fe a4 e4 e1 00 01 09 fa 00 00 00 00 00 00=
  ................
>> >>     000000000b98156e: 00 00 00 00 00 00                              =
  ......
>> >>
>> >> Both UDP and PTP length fields indicate that the payload ends exactly=
 at
>> >> the end of the dump. So apparently skb->len contains all the payload
>> >> bytes, including the Ethernet header.
>> >>
>> >> Is that the case for other drivers as well? Maybe mlxsw is just missi=
ng
>> >> some SKB magic in the driver.
>> >
>> > So I run some tests (on other hardware/drivers) and it seems like that
>> > the skb->len usually doesn't include the ETH_HLEN. Therefore, it is
>> > added to the check.
>> >
>> > Looking at the driver code:
>> >
>> > |static void mlxsw_sp_rx_sample_listener(struct sk_buff *skb, u8 local=
_port,
>> > |					void *trap_ctx)
>> > |{
>> > |	[...]
>> > |	/* The sample handler expects skb->data to point to the start of the
>> > |	 * Ethernet header.
>> > |	 */
>> > |	skb_push(skb, ETH_HLEN);
>> > |	mlxsw_sp_sample_receive(mlxsw_sp, skb, local_port);
>> > |}
>> >
>> > Maybe that's the issue here?
>>=20
>> Correct, mlxsw pushes the header very soon. Given that both
>> ptp_classify_raw() and eth_type_trans() that are invoked later assume
>> the header, it is reasonable. I have shuffled the pushes around and have
>> a patch that both works and I think is correct.
>
> Would it make more sense to do:
>
> 	u8 *data =3D skb_mac_header(skb);
> 	u8 *ptr =3D data;
>
> 	if (type & PTP_CLASS_VLAN)
> 		ptr +=3D VLAN_HLEN;
>
> 	switch (type & PTP_CLASS_PMASK) {
> 	case PTP_CLASS_IPV4:
> 		ptr +=3D IPV4_HLEN(ptr) + UDP_HLEN;
> 		break;
>
> 	case PTP_CLASS_IPV6:
> 		ptr +=3D IP6_HLEN + UDP_HLEN;
> 		break;
>
> 	case PTP_CLASS_L2:
> 		break;
>
> 	default:
> 		return NULL;
> 	}
>
> 	ptr +=3D ETH_HLEN;
>
> 	if (ptr + 34 > skb->data + skb->len)
> 		return NULL;
>
> 	return ptr;
>
> in other words, compare pointers, so that whether skb_push() etc has
> been used on the skb is irrelevant?

Yes. Avoiding relying on whether skb_{push,pull} has been used is
overall the simplest solution and it works for all drivers regardless if
DSA or something else is used. Looking at your code, it looks correct
to me.

I'll test it and send v3. But before, I've got another question that
somebody might have an answer to:

The ptp v1 code always does locate the message type at

 msgtype =3D data + offset + OFF_PTP_CONTROL

OFF_PTP_CONTROL is 32. However, looking at the ptp v1 header, the
message type is located at offset 20. What am I missing here?

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl8hT3QACgkQeSpbgcuY
8KajKBAA1WusIx4oA8KsasNIDapSDeBCjwVhofvrsKXr3WAYbqMBRk8e+P0e//iy
2L8XcoAB3JZhGJFjulc+75BAmTFGmcL+GFAyicxkSjFhS5ab0Ov1n9pkDp1ivQ12
nZRo80QJ2rdVWlsZmyiwHMc+k5cKUYR7TtDR/5UORk03U7+0RqNb5/o6uokXMeVT
OxxSmh1ewmv+9kX8EKRKC4t096JRmQiACdGNzyFDhMlCVvqUyH+1GsrWsVAQJm7Y
9GCZvBTWKr+ZabY15JX4SBV8BixFsHsq37wQt581NzlluGxFwtHxRIXdU9AjRaaf
T3bZsEQmPKHFWiTBZj/E5zVt6TEmmREMr+3050dm1oCm+mEFBQ0E4GhMxTKmmmnq
TGZZdGEQG7lJF1/bmvl3MQGz48quGmiR0UKRX47ur25lsjYLKxOivW3PFEf4NrNH
fttqfDI3TAUM9SX48Y9+dj9OfSPLkxSX9KZJ+l7eF7JmlmLfuzodjn9biSsNsyLu
Sx2Jdqcr8D4mjcIHq9Q5ovIU4zCzu97goVXtCIDnR/wCrtlak/AdNSwQrQBmNN/t
WvbHqdXaUi65x2ss2UcRpJ5hREpzuCY7TrrDjNjRWl9/NdA96nhm2wbfo2XB+J3b
LceTFREEj5FdGVQYaqavFGkJcFE64eJpU9R4e8RKmHGA3OzWevs=
=SHvs
-----END PGP SIGNATURE-----
--=-=-=--
