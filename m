Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 361443EE56A
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 06:16:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233855AbhHQERW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 00:17:22 -0400
Received: from ozlabs.org ([203.11.71.1]:56977 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230335AbhHQERV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Aug 2021 00:17:21 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Gpd5V0zn6z9sT6;
        Tue, 17 Aug 2021 14:16:45 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1629173807;
        bh=tfgLEP4cMZdo3hQKMzj/TGceL5CB+32UOGdgMV+sK/8=;
        h=Date:From:To:Cc:Subject:From;
        b=eWQggNKUnnM8x/jjpMabEjDlOL/mp88cZulSnoeTGjCELIGLMijM8rIk2tr2M63Cc
         foJtfx2YO1UsP+PtUUCo2ayOEXlhW1rWYMkuuQLUrgjszHnGOCkWnPXn53TOiJrw/V
         E0jEXjOwOqduUBkZf6GIcY4K0NxsbLMvAWxRdi4kLZ1A9jPHo2pKaJZ6GsXK+Y69EO
         gcGaGvchrrxje7mo7Wk+6GZNuLfiPQiHCEBqAhdnrMg/qhIq+sJUzQlked6aHFenEI
         Npg1hAOYtoVVWo+Wko2mtUOMMHnpLUZ80ssWzp9NJBeKxLhi9l/jXoIPygnH8P87xz
         hZtEHIDi3qstw==
Date:   Tue, 17 Aug 2021 14:16:43 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20210817141643.0705a6e9@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/ZqNnJ3fkGT6yPotlqE_y0qv";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/ZqNnJ3fkGT6yPotlqE_y0qv
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  drivers/ptp/Kconfig

between commit:

  55c8fca1dae1 ("ptp_pch: Restore dependency on PCI")

from the net tree and commit:

  e5f31552674e ("ethernet: fix PTP_1588_CLOCK dependencies")

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

diff --cc drivers/ptp/Kconfig
index e085c255da0c,823eae1b4b53..000000000000
--- a/drivers/ptp/Kconfig
+++ b/drivers/ptp/Kconfig
@@@ -90,9 -103,8 +103,9 @@@ config PTP_1588_CLOCK_INE
  config PTP_1588_CLOCK_PCH
  	tristate "Intel PCH EG20T as PTP clock"
  	depends on X86_32 || COMPILE_TEST
 -	depends on HAS_IOMEM && NET
 +	depends on HAS_IOMEM && PCI
 +	depends on NET
- 	imply PTP_1588_CLOCK
+ 	depends on PTP_1588_CLOCK
  	help
  	  This driver adds support for using the PCH EG20T as a PTP
  	  clock. The hardware supports time stamping of PTP packets

--Sig_/ZqNnJ3fkGT6yPotlqE_y0qv
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmEbOCsACgkQAVBC80lX
0Gykngf+K1SL+CKPxp7lDzJuk6nQWkXUnXfbQnvmJAuKlldp+GlKnwJhAJ7KWku6
KAH1pTlrYVOnFp9i/JCt6zxqtCTcsBdHpV6sRfXvrLSYW3e09hYRfw7k0x2qb0Rz
jPW2BsEA1rVRqu357jEC1rDWRdp7yxcHFzGUiwz12yGPqdaICuTi+LfYCfOAOBSG
8XR+cbzgyFCYbOFK4714lUzGh7K4MPFfkotULvUT4FP37+wMEZqiWqYU1VPDMVIa
efuEcxhHPonvua90yhRemS/jCuYY7K79N5DMh2z2NCeBZp+9PDqmTjxMwGGIy9eU
TVPqlRAu6+ZPCCYwQ2VRAJ6qY+t4PQ==
=Rw3E
-----END PGP SIGNATURE-----

--Sig_/ZqNnJ3fkGT6yPotlqE_y0qv--
