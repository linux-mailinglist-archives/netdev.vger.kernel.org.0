Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4002923B8C4
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 12:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728709AbgHDKaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 06:30:22 -0400
Received: from mx2.suse.de ([195.135.220.15]:51594 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726056AbgHDKaW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Aug 2020 06:30:22 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 62C19B5B6;
        Tue,  4 Aug 2020 10:30:36 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 4861E6030D; Tue,  4 Aug 2020 12:30:20 +0200 (CEST)
Date:   Tue, 4 Aug 2020 12:30:20 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Adrian Pop <popadrian1996@gmail.com>
Cc:     netdev@vger.kernel.org, linville@tuxdriver.com,
        davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        vadimp@mellanox.com, mlxsw@mellanox.com, idosch@mellanox.com,
        andrew@lunn.ch
Subject: Re: [PATCH] ethtool: Add QSFP-DD support
Message-ID: <20200804103020.4myko3zlw3bh62az@lion.mk-sys.cz>
References: <20200731084725.7804-1-popadrian1996@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="tfutiioxkn66jxih"
Content-Disposition: inline
In-Reply-To: <20200731084725.7804-1-popadrian1996@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--tfutiioxkn66jxih
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I noticed one more minor problem:

On Fri, Jul 31, 2020 at 11:47:25AM +0300, Adrian Pop wrote:
> +static void qsfp_dd_show_sig_optical_pwr(const __u8 *id, __u32 eeprom_le=
n)
> +{
> +	static const char * const aw_strings[] =3D {
> +		"%s power high alarm   (Channel %d)",
> +		"%s power low alarm    (Channel %d)",
> +		"%s power high warning (Channel %d)",
> +		"%s power low warning  (Channel %d)"
> +	};
> +	__u8 module_type =3D id[QSFP_DD_MODULE_TYPE_OFFSET];
> +	char field_desc[QSFP_DD_MAX_DESC_SIZE];
> +	struct qsfp_dd_diags sd =3D { { 0 } };

This causes a compiler warning with recent gcc:

  qsfp-dd.c: In function =E2=80=98qsfp_dd_show_sig_optical_pwr=E2=80=99:
  qsfp-dd.c:438:9: warning: missing initializer for field =E2=80=98sfp_temp=
=E2=80=99 of =E2=80=98struct qsfp_dd_diags=E2=80=99 [-Wmissing-field-initia=
lizers]
    438 |  struct qsfp_dd_diags sd =3D { { 0 } };
        |         ^~~~~~~~~~~~~
  In file included from qsfp-dd.c:26:
  qsfp-dd.h:30:8: note: =E2=80=98sfp_temp=E2=80=99 declared here
     30 |  __s16 sfp_temp[4];
        |        ^~~~~~~~

An empty initializer like

	struct qsfp_dd_diags sd =3D {};

should be fine (and is already used in many other places).

Michal

--tfutiioxkn66jxih
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAl8pOLYACgkQ538sG/LR
dpWV1gf/c5hjIeCWENKbye/gTFHhZOoSdEfjZnDPxAHS1mmPlR1rxHuIodlfwLzc
j7d+PgpnwJFMOgqJP0evSd/+7OAMIodOBersFYvtur1XiQuU+a/KqiTcDRycFhms
B3D5TDJ5XOGp82I9MMAmUTwTO7XUyvUNxVAJXYWBa3GuRbvJ1QkO75R06mTprjD1
BYfmBUHUEciJddS2YY3XZ9vt2RyeKIAi1XmlskjrFRi6t/zT1GBhe5PUgbMDYSC1
Gzg9OSNdxmbcNRxOPpbpJZb6kXU2ZpSmHQFeMVwV9FZq99Qst4fzIDCBjyo7ocdS
zFUulTkU+XaJ0+zrbzOiM/bYzghcpw==
=1mq2
-----END PGP SIGNATURE-----

--tfutiioxkn66jxih--
