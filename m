Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65071421BD2
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 03:24:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbhJEB0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 21:26:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbhJEB0A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Oct 2021 21:26:00 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08633C061745;
        Mon,  4 Oct 2021 18:24:11 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4HNfxh4NxZz4xbR;
        Tue,  5 Oct 2021 12:24:08 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1633397049;
        bh=yxerCLRqyOOm+Qv4v2U5hcnkfkJTlw2XC0iLRrwkNzU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ob4T9gDUKG8Rq0Hvuhu2v1Rzz1zesPIkYTYRW3DHc8Y2Q/F19n5ICeOUHzDERHFt0
         33bduw9DUHyRxvdQLKfHn7xZH1+ezCYXyFuSKoy1zhLopiO4joZRZVRE8zezTQcZ+q
         DBy5pufXQFrMKtRg4u64ietZX+yI+Y2vA6GcaK4E7JFLv3tEY85wngWX4TDfYoIqA3
         p7iB3dnt07ZkkxfzNCWIWZUMmc6khy8TDCIhNu+9oOYWvvKPdjUY9XCR8LptSkyqda
         HpF9E0Gb+Nra70Rxqy1UVuG/rWI/owlWs4nnNfQkTnceUrT/YlY8tp6HtJEoYj+tr/
         ip5g/3FAhdTAg==
Date:   Tue, 5 Oct 2021 12:24:07 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Subject: Re: linux-next: build failure after merge of the net-next tree
Message-ID: <20211005122407.25274909@canb.auug.org.au>
In-Reply-To: <20211005115637.3eacc45f@canb.auug.org.au>
References: <20211005115637.3eacc45f@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/vdkn.pXgtEz.5Gm_bUxROfa";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/vdkn.pXgtEz.5Gm_bUxROfa
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Tue, 5 Oct 2021 11:56:37 +1100 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> After merging the net-next tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
>=20
> drivers/net/ethernet/ibm/ehea/ehea_main.c: In function 'ehea_setup_single=
_port':
> drivers/net/ethernet/ibm/ehea/ehea_main.c:2989:23: error: passing argumen=
t 2 of 'eth_hw_addr_set' from incompatible pointer type [-Werror=3Dincompat=
ible-pointer-types]
>  2989 |  eth_hw_addr_set(dev, &port->mac_addr);
>       |                       ^~~~~~~~~~~~~~~
>       |                       |
>       |                       u64 * {aka long long unsigned int *}
> In file included from include/linux/if_vlan.h:11,
>                  from include/linux/filter.h:19,
>                  from include/net/sock.h:59,
>                  from include/linux/tcp.h:19,
>                  from drivers/net/ethernet/ibm/ehea/ehea_main.c:20:
> include/linux/etherdevice.h:309:70: note: expected 'const u8 *' {aka 'con=
st unsigned char *'} but argument is of type 'u64 *' {aka 'long long unsign=
ed int *'}
>   309 | static inline void eth_hw_addr_set(struct net_device *dev, const =
u8 *addr)
>       |                                                            ~~~~~~=
~~~~^~~~
> cc1: some warnings being treated as errors
>=20
> Caused by commit
>=20
>   a96d317fb1a3 ("ethernet: use eth_hw_addr_set()")
>=20
> I have used the net-next tree from next-20211001 for today.

I also had to use the next-20211001 version if the bpf-next tree (since
it had been reset past the broken commit in the net-next tree).

--=20
Cheers,
Stephen Rothwell

--Sig_/vdkn.pXgtEz.5Gm_bUxROfa
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmFbqTcACgkQAVBC80lX
0GyHNgf+IoiEDX3xLfrpgRZCVaL1GC0cBjU1+nfiTHOIPGu77fR5SRANw0RbU+D0
xybpri6oJ57oN0WFSXW1T+9bQR0j/y6Y+ANxNECjwJ2yFSQJ5gRgoeZuzwo2xcPp
91UwyKHLzDeM06egqKL2TvBP4RYcpuuv/Bp/7jisRGNRjtK0Vhb8Q8jo3LMTOBKx
jEn7WUCoLtyIcs86mXX7woDDqzDmQcPsjzGwU3kf07LtU0vKM29+wUfInAYgiJRt
D3npLdi9SrW4ZR3cnNjplgFyH57OHrh8KsBds1T42gN10TerJCH69qlnIjMl0YSF
hEsmh7vVM/yq5oKufONW0jYqcSc1kQ==
=mnT6
-----END PGP SIGNATURE-----

--Sig_/vdkn.pXgtEz.5Gm_bUxROfa--
