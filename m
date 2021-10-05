Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45013421B82
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 03:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230353AbhJEBNs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 21:13:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbhJEBNr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Oct 2021 21:13:47 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC2D4C061745;
        Mon,  4 Oct 2021 18:11:57 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4HNfgb633Bz4xbQ;
        Tue,  5 Oct 2021 12:11:55 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1633396316;
        bh=QcnoFg9wrYYDMZj3ftLGLzrX3IjtvRl4VMlIHDnSDWQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NYeaX52ycFqmW90xJStCD1DZ2BSYd5cIVs3p4NXGASU6pb28y555gxidQ2FretFau
         NE70HAsDecek2ECi9A9VJgFNtOTdIkUTpiUxjVX7p1l6sMX+aPoTtgZYZZZreIdWrx
         3FnIVj+jR0UV4JmjaUUvrIFmbTg5HplSJLz7WfHiDNvlSjNwef3dL5rjlwzzpLJ6nt
         d1W5P4qIXmALpDYYz0yAIFHYlArhDPOEGxkPGN92h0iEY4UGu44pYVf+6hh+j86VTY
         hvwWsVex73STrGW39WPuwVitk5PgSDxBvOL56k5+IazYiImnZ4z7Ro3m2adyZ1LAb2
         BTWxff727APWQ==
Date:   Tue, 5 Oct 2021 12:11:54 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, edumazet@google.com, weiwan@google.com,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the net-next tree
Message-ID: <20211005121154.08641258@canb.auug.org.au>
In-Reply-To: <20211001.144046.309542880703739165.davem@davemloft.net>
References: <20211001161849.51b6deca@canb.auug.org.au>
        <20211001.144046.309542880703739165.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/K5PWtTQ4z25yGFL2XQT1aEi";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/K5PWtTQ4z25yGFL2XQT1aEi
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Fri, 01 Oct 2021 14:40:46 +0100 (BST) David Miller <davem@davemloft.net>=
 wrote:
>
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Fri, 1 Oct 2021 16:18:49 +1000
>=20
> > Hi all,
> >=20
> > After merging the net-next tree, today's linux-next build (sparc64
> > defconfig) failed like this:
> >=20
> > net/core/sock.c: In function 'sock_setsockopt':
> > net/core/sock.c:1417:7: error: 'SO_RESERVE_MEM' undeclared (first use i=
n this function); did you mean 'IORESOURCE_MEM'?
> >   case SO_RESERVE_MEM:
> >        ^~~~~~~~~~~~~~
> >        IORESOURCE_MEM
> > net/core/sock.c:1417:7: note: each undeclared identifier is reported on=
ly once for each function it appears in
> > net/core/sock.c: In function 'sock_getsockopt':
> > net/core/sock.c:1817:7: error: 'SO_RESERVE_MEM' undeclared (first use i=
n this function); did you mean 'IORESOURCE_MEM'?
> >   case SO_RESERVE_MEM:
> >        ^~~~~~~~~~~~~~
> >        IORESOURCE_MEM
> >=20
> > Caused by commit
> >=20
> >   2bb2f5fb21b0 ("net: add new socket option SO_RESERVE_MEM")
> >=20
> > arch/sparc/include/uapi/socket.h does not include uapi/asm/socket.h and
> > some other architectures do not as well.
> >=20
> > I have added the following patch for today (I searched for SO_BUF_LOCK
> > and, of these architectures, I have only compile tested sparc64 and
> > sparc): =20
>=20
> I committed the sparc part into net-next today, thanks.

Unfortunately, there is a typo in what you committed in bfaf03935f74
("sparc: add SO_RESERVE_MEM definition."), SO_RESEVE_MEM instead of
SO_RESERVE_MEM ...

--=20
Cheers,
Stephen Rothwell

--Sig_/K5PWtTQ4z25yGFL2XQT1aEi
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmFbploACgkQAVBC80lX
0Gyo1gf/dnSvjxx13Gkwpx84SSOykZFD7FbLiHsgn2ZK4E+dKRkMP+0SRvzrZcFB
+gPDB0AodxmtwtXX0G/kgoquYFBj/75Y5wNEUGti/C8KOn09ifsz1uP0GB76XRNG
wbU97JfEU9ndRvHjgKrpZg67b4ML6rJTNcTlh73L2QZca5Do4MpdlpER8bUc+42/
SWkir51JextoUOdaRyAHhHz9qad2Wec/owm1NZLRZuwUjpw2xntBK2ocokvmHckb
IZy37ZKT3x0pSVG4hl/MeXhPYEwLKQMNbgw1BzLPbfCPLNzlY7Xvf+sEZBnC7fav
M+VSB5841hft1hSrPjbsLRKhvLP25A==
=pHAX
-----END PGP SIGNATURE-----

--Sig_/K5PWtTQ4z25yGFL2XQT1aEi--
