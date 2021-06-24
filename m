Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5039C3B24AA
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 03:58:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229922AbhFXCAz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 22:00:55 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:32849 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229812AbhFXCAy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Jun 2021 22:00:54 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4G9NZy0B8nz9sX1;
        Thu, 24 Jun 2021 11:58:33 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1624499914;
        bh=TtVONHpBgW64sQti2v2KVngpO3bGOmdSaV6jJxzKf9U=;
        h=Date:From:To:Cc:Subject:From;
        b=VuYiF38/+zagiyIkOEMHCRgEr7fV8qgjGYE9VAnGlykMSonlALhy782hN3QrI2UUd
         yfbzd+s5nEXlOOVgQ/EaUpD2NLLODKd0lk/++rmY7E57bRMZ394d8iMcRDZEpZ4YRx
         dGw4YUJFw7XnqG1B4/hPGBiLIzHgq7z12Unzw9VWfnRF3e+L7dmEbIXlk+sCWaneuJ
         wTpoTsEMyMt0tzroObiyHZuwAiMB1Ey88r/VRqQ5JRgP7OCpdlmRUNKgOmFH9uLlDV
         hOacwF1bcUCXzrFsPfFfi3asBuQ4oSKjYfsf76ubYtPhFcieL/xdGeMRi7z+LvgJ/G
         1oKF4oa/e07/w==
Date:   Thu, 24 Jun 2021 11:58:30 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20210624115830.606b35c8@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/RkAg1RTb0HAPH/bjOvC2VIL";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/RkAg1RTb0HAPH/bjOvC2VIL
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  net/netfilter/nf_tables_api.c

between commit:

  3c5e44622011 ("netfilter: nf_tables: memleak in hw offload abort path")

from the net tree and commit:

  ef4b65e53cc7 ("netfilter: nfnetlink: add struct nfgenmsg to struct nfnl_i=
nfo and use it")

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

diff --cc net/netfilter/nf_tables_api.c
index fcb15b8904e8,d6214242fe7f..000000000000
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@@ -3249,9 -3236,9 +3242,9 @@@ static int nf_tables_newrule(struct sk_
  	u8 genmask =3D nft_genmask_next(info->net);
  	struct nft_rule *rule, *old_rule =3D NULL;
  	struct nft_expr_info *expr_info =3D NULL;
+ 	u8 family =3D info->nfmsg->nfgen_family;
 +	struct nft_flow_rule *flow =3D NULL;
- 	int family =3D nfmsg->nfgen_family;
  	struct net *net =3D info->net;
 -	struct nft_flow_rule *flow;
  	struct nft_userdata *udata;
  	struct nft_table *table;
  	struct nft_chain *chain;

--Sig_/RkAg1RTb0HAPH/bjOvC2VIL
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmDT5sYACgkQAVBC80lX
0GyVZAf/WAOJ2xGd77gHjzc/0BJ12ETOmKga+KWO2BN7GfyjCjlQG2S9hRP+Fjoz
fZTBq6mWUxcgHeU4XQx9qxOYSBcfwL1BlEo3WukOujVKZIaI+A0znhugHiHSxSZA
CHTPBprceqxka7h3DCM6MwL7s3P390je0Jd7o06bgHjdlP8I8pCZ4H94m1sMVl2I
KS6AcgGS1teas5EwABblyFwaeH2DAfYfj13cg91rxCZXqpNaZ3O/gRJLAAWgoq7X
faPAMA8Lf0fzhCYl46QlWE2fukQFq/FnSjwCTPSqUiZcvSmAWYtbfruNDOtMgcRN
qy28KEbnGf3ZgAlusW+m+sgzIeiuEw==
=06H5
-----END PGP SIGNATURE-----

--Sig_/RkAg1RTb0HAPH/bjOvC2VIL--
