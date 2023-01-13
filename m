Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18D3566950C
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 12:11:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241387AbjAMLLg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 06:11:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240773AbjAMLKn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 06:10:43 -0500
Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EEBC7D9EF;
        Fri, 13 Jan 2023 03:02:28 -0800 (PST)
Received: from wsk (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 02CA885160;
        Fri, 13 Jan 2023 12:02:25 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1673607746;
        bh=0AOevGqJKoVQxeVBRuZQl7WhrtXlVKL5Q5AjpRfvu1U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DTCc8hZSlbUYGcuaFby0ShOFkl21kC5eU6YkjfqXADWBQ/k+gB/2yR0PFa/9JVm/S
         jLZtlbOI/Cv7xoV7OARyE8V3U8ukSmsMBJ1uer3sCig0cmEMfdcKUDcZbM6MoDkPB/
         hemRXuxm4KuvLROWyt5Oqk5TsT6Oj55rccelJPY1Vl49t1i24yTroK3Z+/oitjMb4L
         anetn58mbt5L3MOqFRo0yf32aGolRIZi2aaggB45SPvg/TAn+Q87RONd2CdqERvO+s
         hUzgKAs/xjLdR5IFRlU+ta26U5+j0fJ8abMJSiODX4En3xBPNkvt2gTS8lp3xeXs2b
         7WVruH1gpmepg==
Date:   Fri, 13 Jan 2023 12:02:19 +0100
From:   Lukasz Majewski <lukma@denx.de>
To:     Vladimir Oltean <olteanv@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/3] dsa: marvell: Provide per device information
 about max frame size
Message-ID: <20230113120219.7dc931c1@wsk>
In-Reply-To: <20230113104937.75umsf4avujoxbaq@skbuf>
References: <20230106101651.1137755-1-lukma@denx.de>
        <Y7gdNlrKkfi2JvQk@lunn.ch>
        <20230113113908.5e92b3a5@wsk>
        <20230113104937.75umsf4avujoxbaq@skbuf>
Organization: denx.de
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/rqvhpIpmHo/d1evgXR/6VYw";
 protocol="application/pgp-signature"; micalg=pgp-sha512
X-Virus-Scanned: clamav-milter 0.103.6 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/rqvhpIpmHo/d1evgXR/6VYw
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Vladimir,

> On Fri, Jan 13, 2023 at 11:39:08AM +0100, Lukasz Majewski wrote:
> > Are there any more comments, or is this patch set eligible for
> > pulling into net-next tree? =20
>=20
> How about responding to the comment that was already posted first?

Could you be more specific?


On the beginning (first posted version) the patch included 9 patches
(which included work for ADDR4 for some mv88e6020 setup).

But after the discussion, I've decided to split this patch set to
smaller pieces;

First to add the set_max_frame size with basic definition for mv88e6020
and mv88e6071 and then follow with more complicated changes (for which
there is no agreement on how to tackle them).

For the 'set_max_frame' feature Alexander Dyuck had some comments
regarding defensive programming approach, but finally he agreed with
Andrew's approach.

As of now - the v4 has been Acked by Andrew, so it looks like at least
this "part" of the work is eligible for upstreaming.


Or there are any more issues about which I've forgotten ?

Best regards,

Lukasz Majewski

--

DENX Software Engineering GmbH,      Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-59 Fax: (+49)-8142-66989-80 Email: lukma@denx.de

--Sig_/rqvhpIpmHo/d1evgXR/6VYw
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEgAyFJ+N6uu6+XupJAR8vZIA0zr0FAmPBOjsACgkQAR8vZIA0
zr1c8QgA0GHLC18ZdClzvr6Lz/qe4RNhCr5giywjnQloZ0YQ9ipa1Ymc3M+32g7O
rvpuq+x16EIveey1OEqifTvsqBQ7UDdh8B+KoD1gd80PVBCIhZdVo+tCEcNQRbdj
5GYlSlZxih/sLVn2f7HYlF+EI9nTPpgrfdOwcA0IX5BXdoStBw2ocdt/BhmTlneU
vAd4PUA6lUkI/of/1MVRVhmSIA0zrBOgQuyna2crGx8O4luH29245WHA5DOM7PPX
6GIUu2bslCsOmOiQDaOPe2nFmUTp2VpgZUI6iVH13IYC6KKf8jCvk3+tZ7gbqCrl
hZlIeCDkk9wkJi2ZMliPaxs/y5EHsw==
=W/KO
-----END PGP SIGNATURE-----

--Sig_/rqvhpIpmHo/d1evgXR/6VYw--
