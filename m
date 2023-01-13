Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2271166987D
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 14:29:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240277AbjAMN3G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 08:29:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241346AbjAMN20 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 08:28:26 -0500
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56CB42AC9;
        Fri, 13 Jan 2023 05:20:27 -0800 (PST)
Received: from wsk (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 845AE81A0E;
        Fri, 13 Jan 2023 14:20:24 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1673616025;
        bh=1qSwriZFPF+/gR3HQS3JEWuiTAkSalzYficrKXK36/o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SSFFxxBD6FxXQZTcjwHGi5dVi0J9Qt+UVmhfaGUiD+MxZNkIk0HK2/Ym6TyEVXRIW
         SJVKhKTYPCTUsjFv14k2xLUhWh9fwcwmK/aBzBTqB81m86kOrs0RRc0IMYHuANIT9f
         UN/rQTElGMGVpSBkCyI7XhD/ajCVDUo3qg6bOxWjf0BD7xLZpyhaIbruKA8bppO99/
         Llr5VXgMW0oIRxOUHMKorIldbTglOw3nHyW2BJH9EzjR1+w2xV5+p8XoPXmC8vxQNm
         fef+NtwF/y8HLC3yuwig6CTJOKRclynikbip5nsUlxwAN6eRPv+DsVHyjqQF4dYOYR
         dC8R9pKsyT9Lg==
Date:   Fri, 13 Jan 2023 14:20:17 +0100
From:   Lukasz Majewski <lukma@denx.de>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/3] dsa: marvell: Provide per device information
 about max frame size
Message-ID: <20230113142017.78184ce1@wsk>
In-Reply-To: <20230113122754.52qvl3pvwpdy5iqk@skbuf>
References: <20230106101651.1137755-1-lukma@denx.de>
        <20230106101651.1137755-1-lukma@denx.de>
        <20230106145109.mrv2n3ppcz52jwa2@skbuf>
        <20230113131331.28ba7997@wsk>
        <20230113122754.52qvl3pvwpdy5iqk@skbuf>
Organization: denx.de
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/mh=pNnydW6R9nPnu00U2rBP";
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

--Sig_/mh=pNnydW6R9nPnu00U2rBP
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Vladimir,

> On Fri, Jan 13, 2023 at 01:13:31PM +0100, Lukasz Majewski wrote:
> > I think that this commit [1], made the adjustment to fix yet another
> > issue.
> > [1] -
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/comm=
it/?id=3Db9c587fed61cf88bd45822c3159644445f6d5aa6
> > =20
>=20
> It appears that this is the commit to blame, indeed.
>=20
> > It looks like the missing 8 bytes are added in the
> > mv88e6xxx_change_mtu() function. =20
>=20
> Only for DSA and CPU ports. The driver still behaves as if the max MTU
> on user ports is 1492 bytes.
>=20

It looks so...

> > > I wonder, shouldn't we first fix that, and apply this patch set
> > > afterwards? =20
> >=20
> > IMHO, it is up to Andrew to decide how to proceed, as the
> > aforementioned patch [1] is an attempt to fix yet another issue [2].
> > [2] -
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/comm=
it/?id=3D1baf0fac10fbe3084975d7cb0a4378eb18871482
> > =20
>=20
> I think the handling for those switches were neither
> port_set_jumbo_size() nor set_max_frame_size() is present is just a
> roundabout way of saying "hey, I only support ETH_DATA_LEN MTU and
> can't change it, leave me alone". But it isn't what the code does.

I tend to agree... The number of switched which suppor 1522 B max frame
is only six. This may be why the problem was not noticed.

The fixed function maybe should look like below:


static int mv88e6xxx_get_max_mtu(struct dsa_switch *ds, int port)
{
	....

=09
	int max_mtu;

	max_mtu =3D chip->info->max_frame_size - VLAN_ETH_HLEN -
		  ETH_FCS_LE;

	if (dsa_is_dsa_port(ds, port) || dsa_is_cpu_port(ds, port))
		  max_mtu -=3D EDSA_HLEN;

	return max_mtu;
}

Comments more than welcome.



Best regards,

Lukasz Majewski

--

DENX Software Engineering GmbH,      Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-59 Fax: (+49)-8142-66989-80 Email: lukma@denx.de

--Sig_/mh=pNnydW6R9nPnu00U2rBP
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEgAyFJ+N6uu6+XupJAR8vZIA0zr0FAmPBWpEACgkQAR8vZIA0
zr1Vmgf8CFpBbPXV2vgFguRKQywDjo4dxWBziC9RBu4QTEuAkOMq3A/YpHanvOlE
ZsZtpSyRe3raTcpwFGkWn+1VtGR5wpma5tvvK4t+NPJYy3RCaSivIsQnpBIGCiQQ
pM48fne05BMfZWwAlAr3vUQAtmjztlPthCnKHhcOBCepUSfQbxELQ9smYgQ1JsfQ
vvnR0alHFaIHHv4FvrsswjJzWzhzhXUk1D1u71t6d5g2EI6TtTkL3H/RMargVbCa
J5MTzXGIolMcjk8Gj09UKRPFNAM9lnDAdinWaK7MPtL5RWUiTdMs5bLTypTX0arF
xgi6TqD9Qzh6V7G9tiRXjRGR6FI0Ew==
=nndL
-----END PGP SIGNATURE-----

--Sig_/mh=pNnydW6R9nPnu00U2rBP--
