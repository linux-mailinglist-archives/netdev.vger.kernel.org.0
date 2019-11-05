Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC2EEF52F
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 06:53:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387615AbfKEFxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 00:53:23 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:34153 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387555AbfKEFxX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Nov 2019 00:53:23 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 476f3G5hh9z9sP6;
        Tue,  5 Nov 2019 16:53:14 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1572933197;
        bh=f9hNs4jQjbohnId4YFBy7pOqvHYnA2ugkM9qvTsebHQ=;
        h=Date:From:To:Cc:Subject:From;
        b=GPVY7jb6FGsf8JZrV/ipYnnxNIEM7HBPaIwCw45kae9w/Q5iODqTnvsiQLpC6Ofxx
         dJ8WhYQlGLrEh7Wg1la0Fa5ej7Aie3yacltVFawILzMPhAQ4l/l1zkbS3N7GqjrdPK
         PT7Rk2RjsfqTmbj40SXrSWFyJMeR3T8uz0FtPzEK6KqLaQO4CnvpZzIwqpQGOsTO/B
         +YIbyw4HV2eRbHTkPCBrHpYQa7AvSb0lDaUcYKegGQDCNIN0gIuaCs99Nd4qlKZesa
         PFB1H7dxLkCQFg7EPMEPusINTTyM1zINwuw0WkWXn30KfnOzDlpo3TRS4vT3av90oy
         /69Nc8RSKtaug==
Date:   Tue, 5 Nov 2019 16:53:13 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Greg KH <greg@kroah.com>, David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Joe Perches <joe@perches.com>,
        =?UTF-8?B?SsOpcsO0?= =?UTF-8?B?bWU=?= Pouiller 
        <jerome.pouiller@silabs.com>
Subject: linux-next: manual merge of the staging tree with the
 staging.current and net-next trees
Message-ID: <20191105165313.59a5cc11@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/f83taoECjBr4uwFqhb6tiJk";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/f83taoECjBr4uwFqhb6tiJk
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the staging tree got conflicts in:

  drivers/staging/Kconfig
  drivers/staging/Makefile

between commits:

  df4028658f9d ("staging: Add VirtualBox guest shared folder (vboxsf) suppo=
rt")
  52340b82cf1a ("hp100: Move 100BaseVG AnyLAN driver to staging")

from the staging.current and net-next trees and commit:

  a7a91ca5a23d ("staging: wfx: add infrastructure for new driver")

from the staging tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc drivers/staging/Kconfig
index be74f91500b3,a490141a0e88..000000000000
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@@ -125,8 -125,6 +125,10 @@@ source "drivers/staging/exfat/Kconfig
 =20
  source "drivers/staging/qlge/Kconfig"
 =20
 +source "drivers/staging/vboxsf/Kconfig"
 +
 +source "drivers/staging/hp/Kconfig"
 +
+ source "drivers/staging/wfx/Kconfig"
+=20
  endif # STAGING
diff --cc drivers/staging/Makefile
index b8bd05091453,4cb548a0ff87..000000000000
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@@ -53,5 -53,4 +53,6 @@@ obj-$(CONFIG_UWB)		+=3D uwb
  obj-$(CONFIG_USB_WUSB)		+=3D wusbcore/
  obj-$(CONFIG_EXFAT_FS)		+=3D exfat/
  obj-$(CONFIG_QLGE)		+=3D qlge/
 +obj-$(CONFIG_VBOXSF_FS)		+=3D vboxsf/
 +obj-$(CONFIG_NET_VENDOR_HP)	+=3D hp/
+ obj-$(CONFIG_WFX)		+=3D wfx/

--Sig_/f83taoECjBr4uwFqhb6tiJk
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl3BDkoACgkQAVBC80lX
0GxBIwf+JkgmrQnEKVPJu7rwU8CbLhidBcV458j3OQGqiRJJw+TuaCAb0ygF9dX6
0oRTOf9YvxFQBitjGkn7rqsMyGyy2p6Q4n4/9/fQU8BwjKfwdQJw13//VypkLj/I
55D2Zwb+hwfmYOhFVioNHX4RsB9qpMK1uDG63oaz5IEHG/n9+prfwRy3raKa6ONX
y/LqUs2LSURHj2y8r0fqh4O4nn+MuMvwQ9X8Z3/CRZgXrZQYGzPja7S3VTJEgkn/
LCXjY0hoTSsutrkGwy4q5t7mZMpWIE49NX/1L5BMpctt6dn3vQpXl6t6wwLBVzKd
4XWDm6zCf8G/zerbC1As51AEFG1h6w==
=g9pO
-----END PGP SIGNATURE-----

--Sig_/f83taoECjBr4uwFqhb6tiJk--
