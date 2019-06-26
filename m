Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1BDE56826
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 14:02:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbfFZMCt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 08:02:49 -0400
Received: from ozlabs.org ([203.11.71.1]:55759 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726131AbfFZMCs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 08:02:48 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45YhVX2Y9jz9s3C;
        Wed, 26 Jun 2019 22:02:44 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1561550565;
        bh=w+QRbv9L2/ZXmnp052EBNEJxLhRrtzCyrMYK4G+/uqU=;
        h=Date:From:To:Cc:Subject:From;
        b=aYeWvHghTT7MDezFGVvdSsdRo3/VfdVPeSzVrHCh8vXL+ncKzR/3DS+uX0/LrIUMK
         FRigKjrMiVHZZfBx37rexsaz/ouZRUMmLgGJwYUVtw9gKMiTlyQtG07bgXxj4azP/l
         2RpubkVDYAV4wc7xj/rFMrNm/TiXMs7vX6dwPhV6a9cXFWM5qa+V28A/jxHk0tM+uq
         W/5R9+K5J7PaSPnkbCwMVuSXGYi1gktv2f5xg8bZLNN1hQO2yYslCXagUDYvtIDrcf
         ZeUZcyYXxtXiW9mrbB4zDfi/HjB0jsSw9Nbs9J7cckmGxmgzvaftXIgwwZcYfBgMcf
         lDowXfPhYlnhQ==
Date:   Wed, 26 Jun 2019 22:02:42 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Eiichi Tsukata <devel@etsukata.com>,
        Matteo Croce <mcroce@redhat.com>
Subject: linux-next: manual merge of the akpm tree with the net tree
Message-ID: <20190626220242.26fc2d3e@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/IAiEFUnBd=9XVVSDEnGhKa6"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/IAiEFUnBd=9XVVSDEnGhKa6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the akpm tree got a conflict in:

  net/ipv6/route.c

between commit:

  b8e8a86337c2 ("net/ipv6: Fix misuse of proc_dointvec "skip_notify_on_dev_=
down"")

from the net tree and patch:

  "proc/sysctl: add shared variables for range check"

from the akpm tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc net/ipv6/route.c
index a0994415484e,c5125cdff32c..000000000000
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@@ -6077,9 -6074,9 +6074,9 @@@ static struct ctl_table ipv6_route_tabl
  		.data		=3D	&init_net.ipv6.sysctl.skip_notify_on_dev_down,
  		.maxlen		=3D	sizeof(int),
  		.mode		=3D	0644,
 -		.proc_handler	=3D	proc_dointvec,
 +		.proc_handler	=3D	proc_dointvec_minmax,
- 		.extra1		=3D	&zero,
- 		.extra2		=3D	&one,
+ 		.extra1		=3D	SYSCTL_ZERO,
+ 		.extra2		=3D	SYSCTL_ONE,
  	},
  	{ }
  };

--Sig_/IAiEFUnBd=9XVVSDEnGhKa6
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl0TXuIACgkQAVBC80lX
0GzVGQgAi6KpMwwYvxK6TZnE4Xv4rKpUNWLM+tX4+Z02jY4ue7Igt3X2IRURmt7J
2jJx0UlDRsExYucQdAQQHwnaKzZ9nFQPGezGoc6KsoYrry9adJkZ2FZeoHj/ZPJ8
VSsG4hf3pdhHcFoV53bnY0V1Ai0/TXgg80LdXOSY+TdQNtDj9hkIznS3vTOaQ4ar
dqhoLtKPz4lJr+9unfUACWR1r2TGiZ5tywc3j9/XEo0KLx/yPB0nE+zTVCjX0I65
dSKLZpo+g3sWrEb77E9Alokj2OXx4qBtnpXzkXXlXjgRUOM2shFDCAUUH9gjRqnx
RUFR153oJ89iXTbWGO9+FCWZExL+8Q==
=CNIh
-----END PGP SIGNATURE-----

--Sig_/IAiEFUnBd=9XVVSDEnGhKa6--
