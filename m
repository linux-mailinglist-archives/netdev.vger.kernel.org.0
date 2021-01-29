Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F5B63082CB
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 02:01:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231622AbhA2BAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 20:00:22 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:34897 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231325AbhA2BAT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 20:00:19 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4DRfBH0Qxcz9sVF;
        Fri, 29 Jan 2021 11:59:34 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1611881976;
        bh=VbodL5Yq9EQvAyiNtgEUuG5/4QZAni95fwV8Yi57A/I=;
        h=Date:From:To:Cc:Subject:From;
        b=PQ/Sy7VzagwS7tRYYvkce70yzNxGS6+fY5dyyI7PfzlPyfedlqmLI/oU2Rd9/GXKN
         U56u4W7qtGL+MiyqJE6H7D/P7Eh48kYzqMLZfWahGLesA4Or1Tdsv6teMBZdzv49kA
         7TC7VZHvxYNyeYl12ixUoV6wt6sRMS79Evpr2UqDwNtDeuhxuLq+XELQz1+HYRuTjX
         8ifkZcQ2GR7Isgc16tcKQ6euX1TC9Ey2gG2aJQm3RZEH5erBYIEM5qHgW+K4myXmAE
         grTJwiRxaaYghSW7BGRnkvyGfTP5TSerU5q2ml4peVrq7CZApXknwurVfmOIN0VVlS
         OERFeS0JVRyew==
Date:   Fri, 29 Jan 2021 11:59:33 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: linux-next: manual merge of the net-next tree with Linus' tree
Message-ID: <20210129115933.281690e7@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/LCrl7gDJS.fsUFOumufyw5V";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/LCrl7gDJS.fsUFOumufyw5V
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  drivers/net/can/dev.c

between commit:

  b552766c872f ("can: dev: prevent potential information leak in can_fill_i=
nfo()")

from Linus' tree and commits:

  3e77f70e7345 ("can: dev: move driver related infrastructure into separate=
 subdir")
  0a042c6ec991 ("can: dev: move netlink related code into seperate file")

from the net-next tree.

I fixed it up (I removed the file and added the following merge fix patch)
and can carry the fix as necessary. This is now fixed as far as linux-next
is concerned, but any non trivial conflicts should be mentioned to your
upstream maintainer when your tree is submitted for merging.  You may
also want to consider cooperating with the maintainer of the conflicting
tree to minimise any particularly complex conflicts.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 29 Jan 2021 11:57:21 +1100
Subject: [PATCH] can: dev: fix for file move

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/net/can/dev/netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/dev/netlink.c b/drivers/net/can/dev/netlink.c
index 3ae884cdf677..867f6be31230 100644
--- a/drivers/net/can/dev/netlink.c
+++ b/drivers/net/can/dev/netlink.c
@@ -263,7 +263,7 @@ static int can_fill_info(struct sk_buff *skb, const str=
uct net_device *dev)
 {
 	struct can_priv *priv =3D netdev_priv(dev);
 	struct can_ctrlmode cm =3D {.flags =3D priv->ctrlmode};
-	struct can_berr_counter bec;
+	struct can_berr_counter bec =3D { };
 	enum can_state state =3D priv->state;
=20
 	if (priv->do_get_state)
--=20
2.29.2

--=20
Cheers,
Stephen Rothwell

--Sig_/LCrl7gDJS.fsUFOumufyw5V
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmATXfUACgkQAVBC80lX
0GzcrQf+LKSClzC8tgkmpfajiRTSqZQDtzhh6in6gad/xvJRgJNiLHefH2n7JxSP
cKIFp4wNI/HUNpawB/+qLdmq3Z9Ppx4VWBYnx7tcO4ToCjx8aOMP6TfEu/N9TcaW
ZCc+vUvj0cSR/zklWJ6OzGtDhdBa6rVK6NmGa+b058FSbEdx/qRG4+zBqOUhLmW+
x8qYJ845qctRCHRyMoScTS0AZveMToAQC9JO3o5ysyyW8+ZqWZRlVEow60BkVCRJ
by522hCsUVw9u+S3jgXK7hGY8tZowDAInvuLVnfzK2lGbQ1vB1dcQbxNMq09VyMK
H1iF+okFTy/ZlgRKDDm97K9gAvlNYg==
=pZHh
-----END PGP SIGNATURE-----

--Sig_/LCrl7gDJS.fsUFOumufyw5V--
