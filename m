Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16F17421C21
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 03:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232259AbhJEBi3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 21:38:29 -0400
Received: from gandalf.ozlabs.org ([150.107.74.76]:42083 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231467AbhJEBhf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Oct 2021 21:37:35 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4HNgC25zFKz4xbq;
        Tue,  5 Oct 2021 12:35:42 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1633397743;
        bh=47QfV4nu+DZPLTppE4pwknz4UZg87R1qgXfAER5Zwlo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rfcbA3K9rUkTT1Wj1TUz/MYtCudZq8ibqQTMyZ1L+JD9GMYcYnj2cUwC8OdRFG77m
         qXPgblcPgYDViwhTmmxEp4oJGxQf0/9lFIXJQrWCMJKZAt1ancpOSltBxXesdsyrny
         6Df6o+oreetpZIKJH1rztRmSilLnV5/Wtd8Vx+PEtKXdmEoqEcC4YtJVA2Fbi3j59g
         2FTsC0eQUaFX6woF8/C9pUIxhjaGCL8vMdEepjRKiMVFHyjnl+k4EXTteeOFJZ4cVK
         zfpMgOZnaSGyh2MYLKEFjcI7XneOC+rnTDHxwfCqgWhwKl+OYDBkwxzzPcuk0DB9uS
         6wHde2TGm+iIg==
Date:   Tue, 5 Oct 2021 12:35:41 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>
Subject: Re: linux-next: build failure after merge of the net-next tree
Message-ID: <20211005123541.5614abd8@canb.auug.org.au>
In-Reply-To: <20211005122407.25274909@canb.auug.org.au>
References: <20211005115637.3eacc45f@canb.auug.org.au>
        <20211005122407.25274909@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/cbcd=_7knEFw__qlU1jv_N1";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/cbcd=_7knEFw__qlU1jv_N1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Tue, 5 Oct 2021 12:24:07 +1100 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> Hi all,
>=20
> On Tue, 5 Oct 2021 11:56:37 +1100 Stephen Rothwell <sfr@canb.auug.org.au>=
 wrote:
> >
> > After merging the net-next tree, today's linux-next build (powerpc
> > ppc64_defconfig) failed like this:
> >=20
> > drivers/net/ethernet/ibm/ehea/ehea_main.c: In function 'ehea_setup_sing=
le_port':
> > drivers/net/ethernet/ibm/ehea/ehea_main.c:2989:23: error: passing argum=
ent 2 of 'eth_hw_addr_set' from incompatible pointer type [-Werror=3Dincomp=
atible-pointer-types]
> >  2989 |  eth_hw_addr_set(dev, &port->mac_addr);
> >       |                       ^~~~~~~~~~~~~~~
> >       |                       |
> >       |                       u64 * {aka long long unsigned int *}
> > In file included from include/linux/if_vlan.h:11,
> >                  from include/linux/filter.h:19,
> >                  from include/net/sock.h:59,
> >                  from include/linux/tcp.h:19,
> >                  from drivers/net/ethernet/ibm/ehea/ehea_main.c:20:
> > include/linux/etherdevice.h:309:70: note: expected 'const u8 *' {aka 'c=
onst unsigned char *'} but argument is of type 'u64 *' {aka 'long long unsi=
gned int *'}
> >   309 | static inline void eth_hw_addr_set(struct net_device *dev, cons=
t u8 *addr)
> >       |                                                            ~~~~=
~~~~~~^~~~
> > cc1: some warnings being treated as errors
> >=20
> > Caused by commit
> >=20
> >   a96d317fb1a3 ("ethernet: use eth_hw_addr_set()")
> >=20
> > I have used the net-next tree from next-20211001 for today. =20
>=20
> I also had to use the next-20211001 version if the bpf-next tree (since
> it had been reset past the broken commit in the net-next tree).

And the bluetooth tree similarly.

--=20
Cheers,
Stephen Rothwell

--Sig_/cbcd=_7knEFw__qlU1jv_N1
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmFbq+0ACgkQAVBC80lX
0GwGwQf/QT+ZmXAZnb8cEKZiojFmKsUEzw0NBaiZbWErMEHQj6q+yJ858HnUOnjD
EiTIZ/61DAe26JxA1uUW5eEAIPvDpuntyj5VngROppYI+EJ03vvMeYYV6qBCkUqE
WG302g3VT48L/wrzpHsIVWhIzttuIHe0LrL65hKm3NroQoJ2v4ytqT0gbRaCyM2L
nCGsl1GKdWbB4sVvAWcNg+LTzRQrUPmvYC3DMtDQZTohWYBJthJe29XH8g16TAvv
V85PIvsQDgbcCn5UhOR/hN+q7B52IxOrJOWGL9u5UPXnOqgKT6AqkzTB0ImCnMDA
0F3GtKuHFswZ/c3og5eb0FILp9BDrg==
=e8Tn
-----END PGP SIGNATURE-----

--Sig_/cbcd=_7knEFw__qlU1jv_N1--
