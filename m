Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A8B0F9E9B
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 00:55:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726991AbfKLXzt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 18:55:49 -0500
Received: from ozlabs.org ([203.11.71.1]:34825 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726910AbfKLXzt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 18:55:49 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 47CPl63zYYz9sPc;
        Wed, 13 Nov 2019 10:55:46 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1573602946;
        bh=9/oHQmWzkmZQ3Y2KBGMkjOb1W+95AIdAK19GVnSXqkY=;
        h=Date:From:To:Cc:Subject:From;
        b=NzayJEYIuIGxScvf8+F3XPHFGtTBYmnBK+Y2zSGWouuAh7e5JOzSnKxQ1WkEGsLtl
         qo/Lq0oP2fMlmp5XZDxFkTUnxW61TksTEQat5VwFXa4JlJp7SkBpJrLsqqhB9fJ17V
         5ChDk0j7B5IiWSsqQj6S8poUcLN1Svh1CANgDZqwku4wi8umAaP9q0zSg1i7fBcsqQ
         x3bfX6t3cA1P3B1bR8GvL2fqEPDfmhQtJUQUxosidjpj+Zg8Bn9/CedWpRiBBlbGbK
         TVLY/EmJF+RFMwEFnfLzW7wJmFcHrc6QciGojM28QBXfx7Ah8IxiT9jiSZrWLmUVvr
         sO4OkwYgkoIMA==
Date:   Wed, 13 Nov 2019 10:55:38 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>, Jiri Pirko <jiri@mellanox.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20191113105527.17d825da@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Kt0psQJsHnjo4Q6rmz3J/ke";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/Kt0psQJsHnjo4Q6rmz3J/ke
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  include/uapi/linux/devlink.h

between commit:

  d279505b723c ("devlink: Add method for time-stamp on reporter's dump")

from the net tree and commit:

  070c63f20f6c ("net: devlink: allow to change namespaces during reload")

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

diff --cc include/uapi/linux/devlink.h
index a8a2174db030,b558ea88b766..000000000000
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@@ -421,7 -421,10 +421,12 @@@ enum devlink_attr=20
 =20
  	DEVLINK_ATTR_RELOAD_FAILED,			/* u8 0 or 1 */
 =20
 +	DEVLINK_ATTR_HEALTH_REPORTER_DUMP_TS_NS,	/* u64 */
++
+ 	DEVLINK_ATTR_NETNS_FD,			/* u32 */
+ 	DEVLINK_ATTR_NETNS_PID,			/* u32 */
+ 	DEVLINK_ATTR_NETNS_ID,			/* u32 */
+=20
  	/* add new attributes above here, update the policy in devlink.c */
 =20
  	__DEVLINK_ATTR_MAX,

--Sig_/Kt0psQJsHnjo4Q6rmz3J/ke
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl3LRnoACgkQAVBC80lX
0GxPcgf/Vdy7NSKAT0Xz5/H2uJI7SvvjKDoQYXOcTo7iPy0PWe4xskRv4D1Ha7oI
3YKdlhRGi6ENWE19SJ5vJyKMbQpUTotDsTooL+3sM2oH5Y10k3RhvhWClNYBmWjb
JLID+hjqSrhYHtb5rKKBfU9EkoLgJnKur/2g6zIe/oDCdV6lsJn5+LukfNPjuda8
pCCqXSAs/0Ysu9VTtJbpLVB8rySc30+EK/HdOw2Mk0u2TegNe3PNttPNDvqApvZ9
wmQ3/q50LDAC0L8xBRcSCQRqL5y8Mm3UXYk2c2ydLxarEHFMkcvzGO8WExUtiXJF
Vu9K8aV3HB1Jm3GGTjxoeXZivVRj2g==
=mGw+
-----END PGP SIGNATURE-----

--Sig_/Kt0psQJsHnjo4Q6rmz3J/ke--
