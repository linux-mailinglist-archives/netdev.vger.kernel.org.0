Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5254C29227E
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 08:28:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbgJSG2b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 02:28:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726626AbgJSG2a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 02:28:30 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B56D1C061755
        for <netdev@vger.kernel.org>; Sun, 18 Oct 2020 23:28:30 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kUOee-0003gp-Fi; Mon, 19 Oct 2020 08:28:24 +0200
Received: from [IPv6:2a03:f580:87bc:d400:a99a:c1c5:5b7f:60] (unknown [IPv6:2a03:f580:87bc:d400:a99a:c1c5:5b7f:60])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits)
         client-signature RSA-PSS (4096 bits))
        (Client CN "mkl@blackshift.org", Issuer "StartCom Class 1 Client CA" (not verified))
        (Authenticated sender: mkl@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 359E657BC30;
        Mon, 19 Oct 2020 06:28:21 +0000 (UTC)
Subject: Re: [RFC] can: can_create_echo_skb(): fix echo skb generation: always
 use skb_clone()
To:     Oliver Hartkopp <socketcan@hartkopp.net>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        dev.kurt@vandijck-laurijssen.be, wg@grandegger.com
Cc:     netdev@vger.kernel.org, kernel@pengutronix.de,
        linux-can@vger.kernel.org
References: <20200124132656.22156-1-o.rempel@pengutronix.de>
 <20200214120948.4sjnqn2jvndldphw@pengutronix.de>
 <f2ae9b3a-0d10-64ae-1533-2308e9346ebc@pengutronix.de>
 <f06cd4bc-6264-242f-fd74-ac8e3f2c10b2@hartkopp.net>
 <9ad203ae-9a50-3d96-1ac9-3e45ca9c1989@hartkopp.net>
From:   Marc Kleine-Budde <mkl@pengutronix.de>
Autocrypt: addr=mkl@pengutronix.de; prefer-encrypt=mutual; keydata=
 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
Message-ID: <4e794974-8b87-9961-a144-fe9f5c236de6@pengutronix.de>
Date:   Mon, 19 Oct 2020 08:28:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <9ad203ae-9a50-3d96-1ac9-3e45ca9c1989@hartkopp.net>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="tmTWZElo08yWeQ31SenvOyzr931fUdJRw"
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--tmTWZElo08yWeQ31SenvOyzr931fUdJRw
Content-Type: multipart/mixed; boundary="jatEB1sZkAVzPFLV1EmwwPFoVIm76xQ0l";
 protected-headers="v1"
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: Oliver Hartkopp <socketcan@hartkopp.net>,
 Oleksij Rempel <o.rempel@pengutronix.de>, dev.kurt@vandijck-laurijssen.be,
 wg@grandegger.com
Cc: netdev@vger.kernel.org, kernel@pengutronix.de, linux-can@vger.kernel.org
Message-ID: <4e794974-8b87-9961-a144-fe9f5c236de6@pengutronix.de>
Subject: Re: [RFC] can: can_create_echo_skb(): fix echo skb generation: always
 use skb_clone()
References: <20200124132656.22156-1-o.rempel@pengutronix.de>
 <20200214120948.4sjnqn2jvndldphw@pengutronix.de>
 <f2ae9b3a-0d10-64ae-1533-2308e9346ebc@pengutronix.de>
 <f06cd4bc-6264-242f-fd74-ac8e3f2c10b2@hartkopp.net>
 <9ad203ae-9a50-3d96-1ac9-3e45ca9c1989@hartkopp.net>
In-Reply-To: <9ad203ae-9a50-3d96-1ac9-3e45ca9c1989@hartkopp.net>

--jatEB1sZkAVzPFLV1EmwwPFoVIm76xQ0l
Content-Type: text/plain; charset=utf-8
Content-Language: de-DE
Content-Transfer-Encoding: quoted-printable

On 10/18/20 10:46 AM, Oliver Hartkopp wrote:
> Oh, answering myself ...
>=20
> On 17.10.20 21:13, Oliver Hartkopp wrote:
>>
>>
>> On 16.10.20 21:36, Marc Kleine-Budde wrote:
>>> On 2/14/20 1:09 PM, Oleksij Rempel wrote:
>>>> Hi all,
>>>>
>>>> any comments on this patch?
>>>
>>> I'm going to take this patch now for 5.10....Comments?
>>
>> Yes.
>>
>> Removing the sk reference will lead to the effect, that you will recei=
ve=20
>> the CAN frames you have sent on that socket - which is disabled by def=
ault:
>>
>> https://elixir.bootlin.com/linux/latest/source/net/can/raw.c#L124
>>
>> See concept here:
>>
>> https://elixir.bootlin.com/linux/latest/source/Documentation/networkin=
g/can.rst#L560=20
>>
>>
>> How can we maintain the CAN_RAW_RECV_OWN_MSGS to be disabled by defaul=
t=20
>> and fix the described problem?
>=20
>>>>> +=C2=A0=C2=A0=C2=A0 nskb =3D skb_clone(skb, GFP_ATOMIC);
>>>>> +=C2=A0=C2=A0=C2=A0 if (unlikely(!nskb)) {
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kfree_skb(skb);
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return NULL;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>>> -=C2=A0=C2=A0=C2=A0 /* we can assume to have an unshared skb with p=
roper owner */
>>>>> -=C2=A0=C2=A0=C2=A0 return skb;
>>>>> +=C2=A0=C2=A0=C2=A0 can_skb_set_owner(nskb, skb->sk);
>=20
> skb-> sk is still set here - so everything should be fine.
>=20
> Sorry for the noise.

Is this a Acked-by/Reviewed-by?

regrards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |


--jatEB1sZkAVzPFLV1EmwwPFoVIm76xQ0l--

--tmTWZElo08yWeQ31SenvOyzr931fUdJRw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAl+NMgAACgkQqclaivrt
76mepAgArN+OsCN+JuBLIW9cCJL1iMQEl2zKEtBTvwPL/RbHzeoRf9GX2NC0dYaD
6gtjWGoD36TjqTg7OJpQ3eIBaqlFtqvY/etKLayythxelN4IOpIpYo6pLe3X5reL
0MRAGbqZ2TIw6n5tVKAj4YQqx+yAx2VzYoyyVwI4Hid1en+IlHpY8uu7tdHLJQa4
5dH5wslxnjsSdKsO9BTYnehp/5SiJtHjBtgWpeSEGRZdFtFISsnDg3it6Askll6p
fo4kL6pGjDFtC9Cmt+DMT44Zubgr+NQmMqJeqyl8hUw3CcpBIQbcSXK/PXofKt5V
GZ15qGy1qX8z9xUErWg9DB/wz2pzjQ==
=f0nO
-----END PGP SIGNATURE-----

--tmTWZElo08yWeQ31SenvOyzr931fUdJRw--
