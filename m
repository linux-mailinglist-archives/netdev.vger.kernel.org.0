Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78792225443
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 23:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726601AbgGSVQ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 17:16:57 -0400
Received: from mx2.suse.de ([195.135.220.15]:59186 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726073AbgGSVQ4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Jul 2020 17:16:56 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 0718CAB7D;
        Sun, 19 Jul 2020 21:17:01 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id EF302603A9; Sun, 19 Jul 2020 23:16:54 +0200 (CEST)
Date:   Sun, 19 Jul 2020 23:16:54 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Chris Healy <cphealy@gmail.com>
Cc:     netdev@vger.kernel.org, vivien.didelot@gmail.com,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH] ethtool: dsa: mv88e6xxx: add pretty dump for 88E6352
 SERDES
Message-ID: <20200719211654.hwolppixqqwqz3rx@lion.mk-sys.cz>
References: <20200716175526.14005-1-cphealy@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="owkpyjjha3e6s24x"
Content-Disposition: inline
In-Reply-To: <20200716175526.14005-1-cphealy@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--owkpyjjha3e6s24x
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 16, 2020 at 10:55:26AM -0700, Chris Healy wrote:
> From: Andrew Lunn <andrew@lunn.ch>
>=20
> In addition to the port registers, the device can provide the
> SERDES/PCS registers. Dump these, and for a few of the important
> SGMII/1000Base-X registers decode the bits.
>=20
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Chris Healy <cphealy@gmail.com>
> ---
[...]
> +	case 32 + 0:
> +		REG(reg - 32, "Fiber Control", val);

Could you give these "32" (and similar below) a name?

[...]
> @@ -667,6 +850,17 @@ static int dsa_mv88e6xxx_dump_regs(struct ethtool_re=
gs *regs)
>  		else
>  			REG(i, "", data[i]);
> =20
> +	/* Dump the SERDES registers, if provided */
> +	if (regs->len > 32 * 2) {

sizeof(u16) would be easier to read, IMHO

> +		printf("\n%s Switch Port SERDES Registers\n", sw->name);
> +		printf("-------------------------------------\n");
> +		for (i =3D 32; i < regs->len / 2; i++)
> +			if (sw->dump)
> +				sw->dump(i, data[i]);
> +			else
> +				REG(i, "", data[i]);

In the dump handler above you subtract 32 (offset of SERDES registers,
IIUC) from register number but in the generic branch you don't, this
seems inconsistent.

Michal

> +	}
> +
>  	return 0;
>  }
> =20
> --=20
> 2.21.3
>=20

--owkpyjjha3e6s24x
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAl8UuD4ACgkQ538sG/LR
dpUIHQgAm2psiioOSGnLvKBzhAGL3DFXiuG1RkiC6rar7sHY4slHIkRDtX65/Tdz
PpAkPoj10XuPzmQ2qDCLPBxBDzmFKLmXr7s3QMl4utfu6TaJ2THB3xUqNJte8GLH
eZGYMLE+xfn/dho3+VSuSf+juJWdnrGSIOq4Qz45sn/F9D8E9qrArS4+fHS4yYqu
h46fU2okXCbjDAKrI30kpgsETo4E1b0+h1JdZj9CZRssMz/hdBeZDWGWHxwT95jV
wrkNoYu89BOzwykhEAXO5+kDTrTZcgD4RIl6q5dq46LciG55azxmctBlmCRfBqLw
UdwnSc8jYS/DN1Fgl5HxOQpBv2ZcDQ==
=HQIv
-----END PGP SIGNATURE-----

--owkpyjjha3e6s24x--
