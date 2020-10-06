Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD15284C8F
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 15:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726078AbgJFNak (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 09:30:40 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:36622 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbgJFNaj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 09:30:39 -0400
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601991037;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=D14GHO551n00o35j4i4oNag0nB6Oa+ReNbjC4f4QnRM=;
        b=KJoRaQFx2fkWjY1n08L+eUeB2E8Vds+L6O78ZIesdggekkSPwHX0WRGbTyzUiHkQfxgG+4
        x10fkxiiUZ3olUiaPU+7K0F6TMF9y2Bvcj1OtOfK4bu5yW9uH09lEzuJSDiCzSHdiMW9iw
        j7g5AB1ygRk9xIz1SmWELvA0elelgBCgzR9hnY5E5iZwSYxeF3HuYza+MV5GUu3E6/jCTy
        lMlRMMSQlfXszJUCibCpo0Jsls6OlEuBGwB4afCeiyOXXZEFgCiv1nHEYXdYirHHNAYM9/
        /x9ObnxdgWln8vvokOXIeMRdxsr4WYlTIAJWElDyLawPEwZKA2i7cFc9D0ue5w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601991037;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=D14GHO551n00o35j4i4oNag0nB6Oa+ReNbjC4f4QnRM=;
        b=aWJLZAYkjAoChONyNIQxKm+Uo+G0Q9ont2VHZIp5ee3/CleZ0DYBFoLoADXPG7V+oCs/Fu
        P2se8HhJTepD8GBg==
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH net-next v6 4/7] net: dsa: hellcreek: Add support for hardware timestamping
In-Reply-To: <20201006072847.pjygwwtgq72ghsiq@skbuf>
References: <20201004112911.25085-1-kurt@linutronix.de> <20201004112911.25085-5-kurt@linutronix.de> <20201004143000.blb3uxq3kwr6zp3z@skbuf> <87imbn98dd.fsf@kurt> <20201006072847.pjygwwtgq72ghsiq@skbuf>
Date:   Tue, 06 Oct 2020 15:30:36 +0200
Message-ID: <87tuv77a83.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue Oct 06 2020, Vladimir Oltean wrote:
> On Tue, Oct 06, 2020 at 08:27:42AM +0200, Kurt Kanzenbach wrote:
>> On Sun Oct 04 2020, Vladimir Oltean wrote:
>> > On Sun, Oct 04, 2020 at 01:29:08PM +0200, Kurt Kanzenbach wrote:
>> >> +/* Enabling/disabling TX and RX HW timestamping for different PTP me=
ssages is
>> >> + * not available in the switch. Thus, this function only serves as a=
 check if
>> >> + * the user requested what is actually available or not
>> >> + */
>> >
>> > Correct me if I'm wrong, but to the user it makes zero difference
>> > whether the hardware takes timestamps or not.
>>=20
>> Why not? I think it makes a difference to the user b/o the precision.
>>=20
>> > What matters is whether the skb will be delivered to the stack with a
>> > hardware timestamp or not, so you should definitely accept a
>> > hwtstamp_config with TX and RX timestamping disabled.
>> >
>>=20
>> Sorry, I cannot follow you here.
>
> What I meant to say is that there is no reason you should refuse the
> disabling of hardware timestamping. Even if that operation does not
> really prevent the hardware from taking the timestamps, you simply
> ignore the timestamps in the driver.

That's the point. The user (or anybody else) cannot disable hardware
stamping, because it is always performed. So, why should it be allowed
to disable it even when it cannot be disabled?

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl98cXwACgkQeSpbgcuY
8KYMPA/+Ok6bgkcf1CGwZ6605uQlw88RZd2y0HS3vZuUlW9L6K7nVKbXa0wvC6d7
HnZH5/zn+TGgp36eHrTCtrJWN0aLsZxISlpHhyy8ONjiA1vrsP1r+kHmzyV4OJ48
l3Aezy9pYjDfCryo76SSTVC0c4zKe9Jw2tEZyARLPL22Te3dZUZ7b46unX9Tgy8k
zLIvGN1ftxq6eadNMLh5KdcE+pgXyPfIrfVzS7n7V2YWL4ygerriBi1sU9X8MfHd
h9KxdrziyvXtdTJqYPxJy8FdDLzb61RnohubOc7GK8NIDCp+O23+eR83Ab4K5Ow1
ez5XBIeQp7aujA23MzbNm6jzt3J38HXTdVzmYFZaAtaYowEGD9qgCGUklTXjQOWV
NTTjEpf2byzyxcrfiC5PKZAbu9UD8c/BEyXVYKfpbVgE5d1oJWkjhLwrp4R193CE
EnxSx0uInygkz2qIv6xeJGocQ0+2D7jWcp1f8iuXx9F0yxFePXofuDf72rpAZKV6
NbAjOzUeKE8Vd4z/XiUFFAbYzAaQwM1BHEaptUoXd4AOxCBIiD5OTRXhO8KD0EMP
j0FEqxjnnhrMd+TM49IjfBXRgASO7IhjTRo0/PCLisAzoa3yfQTYDiSYoTRirsC0
pygRaHt86ErlW0Mj40mg/i1PRybqwmaDL1mS0SKTK6l7GTYS86M=
=6LRI
-----END PGP SIGNATURE-----
--=-=-=--
