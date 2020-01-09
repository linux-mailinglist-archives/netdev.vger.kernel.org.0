Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3914B135274
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 06:12:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbgAIFMH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 00:12:07 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:52511 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725308AbgAIFMH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jan 2020 00:12:07 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 47tZ3l0TdTz9sRW;
        Thu,  9 Jan 2020 16:12:03 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1578546724;
        bh=QA8ykIBgXdJHHmcJeSCaM8Lb3DNtWxLG5NWiWOAvPS8=;
        h=Date:From:To:Cc:Subject:From;
        b=PxfPt4NNqT7kL1m1ZlWYu4BohonoFu1yfU91AKgv3g6Mfp7mwIpO5YnTmv5MTUWhY
         GgjMAwdLhbrd+oCIAOhXLdukknYNNzWPelMeDqckHJHHHd4wzKWDFWqv4aMw9nfQpi
         ug86AW9KhexBczMYZ2vTSeEJe4b0K5vJ2vbxEcUr5jW5eMFOSacI/RltC8Z8JbUqeu
         N9J6AFoMG3N/Ub8AGUtM8K+GDzhM+lhs2nm7+N99sSDS1/8PnqlWhRyoKSpfhKiWdz
         INsVUP2Jj8KJwuYA84XPLl8VbwEE89/568xVDYfs8mbaXEX7zJBBsiXKeb5rk8VwKQ
         lmc2kdOvfnIsA==
Date:   Thu, 9 Jan 2020 16:12:02 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Christoph Hellwig <hch@lst.de>, David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexandru-Mihai Maftei <amaftei@solarflare.com>
Subject: linux-next: manual merge of the generic-ioremap tree with the
 net-next tree
Message-ID: <20200109161202.1b0909d9@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/RIa0AbXsBTQ9W2mKrfN=yIJ";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/RIa0AbXsBTQ9W2mKrfN=yIJ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the generic-ioremap tree got a conflict in:

  drivers/net/ethernet/sfc/efx.c

between commit:

  f1826756b499 ("sfc: move struct init and fini code")

from the net-next tree and commit:

  4bdc0d676a64 ("remove ioremap_nocache and devm_ioremap_nocache")

from the generic-ioremap tree.

I fixed it up (the latter moved the code, so I applied the following
merge fix patch) and can carry the fix as necessary. This is now fixed
as far as linux-next is concerned, but any non trivial conflicts should
be mentioned to your upstream maintainer when your tree is submitted
for merging.  You may also want to consider cooperating with the
maintainer of the conflicting tree to minimise any particularly complex
conflicts.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 9 Jan 2020 16:08:52 +1100
Subject: [PATCH] fix up for "sfc: move struct init and fini code"

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/net/ethernet/sfc/efx_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/s=
fc/efx_common.c
index fe74c66c8ec6..bf0126633c25 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -954,7 +954,7 @@ int efx_init_io(struct efx_nic *efx, int bar, dma_addr_=
t dma_mask,
 		goto fail3;
 	}
=20
-	efx->membase =3D ioremap_nocache(efx->membase_phys, mem_map_size);
+	efx->membase =3D ioremap(efx->membase_phys, mem_map_size);
 	if (!efx->membase) {
 		netif_err(efx, probe, efx->net_dev,
 			  "could not map memory BAR at %llx+%x\n",
--=20
2.24.0

--=20
Cheers,
Stephen Rothwell

--Sig_/RIa0AbXsBTQ9W2mKrfN=yIJ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl4WtiIACgkQAVBC80lX
0GxrdQf/Qe09sntulvZvyRuitkoeFqoKe86oZn23jbPWcB7UOJDRXW127OHq5hYp
2BI/v65vM5qwK6i8UsQfLdgzIUbSWHwFJE5wlSnpFmZURPJEI3Jz0FlmLMEiRt3A
/rRERlcuPD7juwlJT8V80QwkYcpa/4gkn8ojEoIK+A/1n5EApKsTfzoF1CQoKazB
oiDTZzN1Q14D7IunTQyBZo2hmmC8t9t9zhBQJ2QdRQnqCt6/IkR/v4FeHXGA8g3Y
sbmjJ7MJLdMzLH04N/paFtqGj8oNNmKadUs1SSRLW35bgOMT9x7Ix+JrBr7BRdmv
4DYrImolmmQhGYwnyhxiGc1TMdEKPQ==
=GP+f
-----END PGP SIGNATURE-----

--Sig_/RIa0AbXsBTQ9W2mKrfN=yIJ--
