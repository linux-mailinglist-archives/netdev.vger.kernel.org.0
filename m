Return-Path: <netdev+bounces-3913-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EE99970985E
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 15:32:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AA037281B66
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 13:32:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED2C9DDBE;
	Fri, 19 May 2023 13:32:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3B0F7C
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 13:32:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91D09C433A0;
	Fri, 19 May 2023 13:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684503162;
	bh=xr8dnZ6wHe0R/88tYpaF8vOYB3YN3mqfAzD/vFKAR3I=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=bAlM4vAnIqNSVyzHCy1wMsXKO0WGQuBY/9943JUkTLqtq/WxtRzO1TgPh5ntfkchW
	 7zVNwj7gV0DzvTMc5ipbo2zw5/dAGLauhwY4xtDHRZ3BgaaY8rves8deOV11Mrk7tw
	 bDYSMlfRRIA3e/rE3tVGAX31fanRplzZm7a0wdp2k2T1EJ/7QfCPiINwvd0CrOfBE/
	 AwFLOOEb1NXe1p8BnR2Ho61Rr1Xj0CaXtlRjFqolJYpVPId1rUiFTS4ZE71/CDw0Xw
	 p3B3G0/3KBZrh8aJ18NRDD9X12FQJXuks3qoEmL3pIaaDByjXuS6NF9v2kxu/Hjpm1
	 Y7SEjXUfmHsng==
Date: Fri, 19 May 2023 15:32:33 +0200
From: Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To: Alexis =?UTF-8?B?TG90aG9yw6k=?= <alexis.lothore@bootlin.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Florian Fainelli <f.fainelli@gmail.com>,
 Vladimir Oltean <olteanv@gmail.com>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
 <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Richard Cochran
 <richardcochran@gmail.com>, netdev@vger.kernel.org,
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
 thomas.petazzoni@bootlin.com, paul.arola@telus.com, scott.roberts@telus.com
Subject: Re: [PATCH net-next 2/2] net: dsa: mv88e6xxx: enable support for
 88E6361 switch
Message-ID: <20230519153233.3fb8a4d1@thinkpad>
In-Reply-To: <7419ffc0-b292-97c4-fee6-610a1a841265@bootlin.com>
References: <20230517203430.448705-1-alexis.lothore@bootlin.com>
	<20230517203430.448705-3-alexis.lothore@bootlin.com>
	<9a836863-c279-490f-a49a-de4db5de9fd4@lunn.ch>
	<ee281c0f-5e8b-8453-08bf-858c5503dc22@bootlin.com>
	<6643e099-7b72-4da2-aba1-521e1a4c961b@lunn.ch>
	<20230519143713.1ac9c7a1@thinkpad>
	<7419ffc0-b292-97c4-fee6-610a1a841265@bootlin.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.37; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 19 May 2023 15:16:57 +0200
Alexis Lothor=C3=A9 <alexis.lothore@bootlin.com> wrote:

> On 5/19/23 14:38, Marek Beh=C3=BAn wrote:
> > On Thu, 18 May 2023 14:58:00 +0200
> > Andrew Lunn <andrew@lunn.ch> wrote:
> >  =20
> >>>>> +	[MV88E6361] =3D {
> >>>>> +		.prod_num =3D MV88E6XXX_PORT_SWITCH_ID_PROD_6361,
> >>>>> +		.family =3D MV88E6XXX_FAMILY_6393,
> >>>>> +		.name =3D "Marvell 88E6361",
> >>>>> +		.num_databases =3D 4096,
> >>>>> +		.num_macs =3D 16384,
> >>>>> +		.num_ports =3D 11,
> >>>>> +		/* Ports 1, 2 and 8 are not routed */
> >>>>> +		.invalid_port_mask =3D BIT(1) | BIT(2) | BIT(8),
> >>>>> +		.num_internal_phys =3D 5,   =20
> >>>>
> >>>> Which ports have internal PHYs? 2, 3, 4, 5, 6, 7 ?  What does
> >>>> mv88e6xxx_phy_is_internal() return for these ports, and
> >>>> mv88e6xxx_get_capsmv88e6xxx_get_caps()? I'm wondering if you actually
> >>>> need to list 8 here?   =20
> >>>
> >>> Indeed there is something wrong here too. I need to tune
> >>> mv88e6393x_phylink_get_caps to reflect 88E6361 differences.
> >>>
> >>> As stated above, port 3 to 7 are the ones with internal PHY.
> >>> For mv88e6xxx_phy_is_internal, I see that it is merely comparing the =
port index
> >>> to the number of internal phys, so in this case it would advertise (w=
rongly)
> >>> that ports 0 to 4 have internal phys.   =20
> >>
> >> Ports 1 and 2 should hopefully be protected by the
> >> invalid_port_mask. It should not even be possible to create those
> >> ports. port 0 is interesting, and possibly currently broken on
> >> 6393. Please take a look at that. =20
> >=20
> > Why would port 0 be broken on 6393x ? =20
> By "broken", I guess Andrew means that if we feed port 0 to
> mv88e6xxx_phy_is_internal, it will return true, which is wrong since ther=
e is no
> internal phy for port 0 on 6393X ?

OK that's true :)

