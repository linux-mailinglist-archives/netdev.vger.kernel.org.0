Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 997243AA860
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 03:04:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231802AbhFQBGn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 21:06:43 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:36943 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231441AbhFQBGm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 21:06:42 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4G53jq3VJlz9sSs;
        Thu, 17 Jun 2021 11:04:30 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1623891874;
        bh=PGOqoYEJCty324bOdGDVnfPpYTv2WarAErgTfo8Si3U=;
        h=Date:From:To:Cc:Subject:From;
        b=f+QfLnPcYAss84a9Sw3DGkEq5HL9TCHjz2Q5Mdx0QOOFunePA5P530C5LmuqdMYGH
         n9RkCzjn9u0bi0J7s2cbLk+LKTJjXLKjpEpI9I7EAJHY07EtAK+HQIuWhZpN8Aq6Kj
         QGVCYDDsmoNep7hxz0Msn6AWQjiYpUqKn/Z2tLa5m39k/4+xQNnpxyCPCETcoJNOnb
         AWlAfNM7vzliS9PdvjxXf+iNyUnCxyDTORDKHHvj1zOTcn5AmAaqSi4VFgJuUpvbT0
         ie7k12Fc2KTYe0if5LLEEcxcl6zqb3XgjrlR6mSeb7WNZB91ITsUXQYwEoMRAqJieu
         +mcqo1ymDfc8Q==
Date:   Thu, 17 Jun 2021 11:04:29 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Patrick Menschel <menschel.p@posteo.de>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20210617110429.51a3812d@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/W+wJpQreJrpsAl/NSVshP3i";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/W+wJpQreJrpsAl/NSVshP3i
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  net/can/isotp.c

between commit:

  8d0caedb7596 ("can: bcm/raw/isotp: use per module netdevice notifier")

from the net tree and commit:

  6a5ddae57884 ("can: isotp: add symbolic error message to isotp_module_ini=
t()")

from the net-next tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc net/can/isotp.c
index be6183f8ca11,f995eaef5d7b..000000000000
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@@ -1482,9 -1452,7 +1484,9 @@@ static __init int isotp_module_init(voi
 =20
  	err =3D can_proto_register(&isotp_can_proto);
  	if (err < 0)
- 		pr_err("can: registration of isotp protocol failed\n");
+ 		pr_err("can: registration of isotp protocol failed %pe\n", ERR_PTR(err)=
);
 +	else
 +		register_netdevice_notifier(&canisotp_notifier);
 =20
  	return err;
  }

--Sig_/W+wJpQreJrpsAl/NSVshP3i
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmDKn50ACgkQAVBC80lX
0Gy1cgf/SjjZKizmHvVdB8a5oYerWDreGdFhmfpmY2QRa2Vf7D79lJrx2ulU+OKz
xJhATu/PkMw4U+Ow+/TUaoa44hrI19wzRLmn+pRkFPQqm3KZbIDYBsjigde8LDxD
pygw/oBsdyB49cgB+VLYE3VoZ9hGmWcGNpkBoFvqxnsFgObRds0cFvHuXoPzx2ab
qzdwvK4XJi8iLXWdOPL8BUyfvbTxeh3zt82ZB/2/8HGbZ8EL+SUNqrQxTd5iSrpl
IqHyPvikTGD18S+0OIgRdtwUo57aaely6OOtXXfBBaQJlGjeA4mIbR+vauOn5jgZ
ThJGWM8HothU2IQ8z05mHLf8JRm66Q==
=jiqI
-----END PGP SIGNATURE-----

--Sig_/W+wJpQreJrpsAl/NSVshP3i--
