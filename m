Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B86F357A8C
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 04:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbhDHCuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 22:50:07 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:42877 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229510AbhDHCuF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 22:50:05 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4FG5Mh2YWjz9sWC;
        Thu,  8 Apr 2021 12:49:52 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1617850193;
        bh=tFrRRUHWBWHDMHiksNGUJeEfJl/zE07+4IvQbpl0H5E=;
        h=Date:From:To:Cc:Subject:From;
        b=sHG3bdgtRJnuHGRBUZBs3U7zD5OpJy8cU+hteUtLSANc3HepQXAedzGghdxzyuDY+
         DNj8/oP70hZygW6/ydgLcWcQRfsafzQ5U5edEYrEXfAiVq6lmnd8u/GfFvxIPwZCPF
         JxFPTK8IWa81jUy4Kl1eVPC+AmCVRyxgpQj+qUCrVhuci7S0R0+U3coMAfQ6GRPH1v
         ZJ0Ide439pFiaou16126TS/uAZu9XVSDda7YEhOfKKQCXxDD2YFegd61awYU/uPgh8
         XaXaDJl5tjE5iNXRDUzB3COtdqWLaSPQhNpMh1u3fqbCZhleSAx2QIOFKdsbvZpXdh
         ndq19E5glRs6A==
Date:   Thu, 8 Apr 2021 12:49:51 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Alexander Duyck <alexanderduyck@fb.com>,
        Danielle Ratson <danieller@nvidia.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20210408124951.2f9941e6@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/XugG1y.a2CQY2vZAp/UzqRq";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/XugG1y.a2CQY2vZAp/UzqRq
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  include/linux/ethtool.h

between commit:

  a975d7d8a356 ("ethtool: Remove link_mode param and derive link params fro=
m driver")

from the net tree and commit:

  7888fe53b706 ("ethtool: Add common function for filling out strings")

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

diff --cc include/linux/ethtool.h
index cdca84e6dd6b,5c631a298994..000000000000
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@@ -573,12 -573,13 +575,22 @@@ struct ethtool_phy_ops=20
   */
  void ethtool_set_ethtool_phy_ops(const struct ethtool_phy_ops *ops);
 =20
 +/*
 + * ethtool_params_from_link_mode - Derive link parameters from a given li=
nk mode
 + * @link_ksettings: Link parameters to be derived from the link mode
 + * @link_mode: Link mode
 + */
 +void
 +ethtool_params_from_link_mode(struct ethtool_link_ksettings *link_ksettin=
gs,
 +			      enum ethtool_link_mode_bit_indices link_mode);
++
+ /**
+  * ethtool_sprintf - Write formatted string to ethtool string data
+  * @data: Pointer to start of string to update
+  * @fmt: Format of string to write
+  *
+  * Write formatted string to data. Update data to point at start of
+  * next string.
+  */
+ extern __printf(2, 3) void ethtool_sprintf(u8 **data, const char *fmt, ..=
.);
  #endif /* _LINUX_ETHTOOL_H */

--Sig_/XugG1y.a2CQY2vZAp/UzqRq
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmBub08ACgkQAVBC80lX
0Gz9ZQf8DF8M6ktYa8BHkGHp7acx7b7Q7den+tpMGI+x3Ub9gBxZ2diVDXeLzRVf
olYlUCGGYEJyKOVGPMvHEK3z+JQXKQ7kTn6+iUq7IRv8wo1e9YDZv3TePLOAxfrm
CC4TteWR6s/HGB0621LdJABVbHQOlnipDXL+HTbkzDJ4Y3phb8mfuwEoLM/eHzl+
gz3p4wMfXYQboSwYoH5+ofPZB9ce/9BAifKqIhVtC1k2Fc/d+2pESGHiVt/V5naq
OJijmvltNrhO2DF5nbiS4hAwEZlcZ6WV/Lw4Px2t1p74uaW9EK54dL95q3kc+cqJ
5PkO97ISv5dcW2rYJGxjVwJizkT27A==
=YpTz
-----END PGP SIGNATURE-----

--Sig_/XugG1y.a2CQY2vZAp/UzqRq--
