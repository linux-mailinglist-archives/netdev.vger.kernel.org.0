Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70DE2A32B4
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 10:35:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727741AbfH3Iew (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 04:34:52 -0400
Received: from ozlabs.org ([203.11.71.1]:60069 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727043AbfH3Iew (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Aug 2019 04:34:52 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 46KXpb5KJPz9sML;
        Fri, 30 Aug 2019 18:34:47 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1567154089;
        bh=9OJ8AufYKE/UYQvEH07V3RR2Rg0rrMtuziIYoRJkZRY=;
        h=Date:From:To:Cc:Subject:From;
        b=jTGtFZaae6vOUJlJTlW3fE0MeJlXfebAsIB3NRVa5uclMZX5B5Pzkd23/Wg7EjAQ2
         A810/uiJUAJNJPYn+MxdLU4gun4B5NMcnND3vNPx3YzRT3GTcqAmZWWX+S+sOGOqqD
         kHUDPkJcyK8VVt2uG2XCLXffE88IhQknEqB+ZxJnTKbwRdbztwkoyN0pocHXnqRLQI
         EFhLTutebx+UlngX1FGnCUCBSeM7Ib1sKjHsCJF8hcGHPItiEVhC+jNOTY1fmJudJz
         VggozfMorXdIoWq1PrL/sELIuvix5aj6JVw6EEA/IBa7jq4yrtVW2vI47HoLx9j1MX
         mKXBku1GyIuUw==
Date:   Fri, 30 Aug 2019 18:34:45 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Greg KH <greg@kroah.com>, David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Benjamin Poirier <bpoirier@suse.com>,
        Valdis =?UTF-8?B?S2zEk3RuaWVrcw==?= <valdis.kletnieks@vt.edu>,
        Sasha Levin <alexander.levin@microsoft.com>
Subject: linux-next: manual merge of the staging tree with the net-next and
 usb trees
Message-ID: <20190830183445.7ee30c35@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/7Rz0+Y84nhStRS26SvAVNmn";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/7Rz0+Y84nhStRS26SvAVNmn
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the staging tree got conflicts in:

  drivers/staging/Kconfig
  drivers/staging/Makefile

between commits:

  955315b0dc8c ("qlge: Move drivers/net/ethernet/qlogic/qlge/ to drivers/st=
aging/qlge/")
  71ed79b0e4be ("USB: Move wusbcore and UWB to staging as it is obsolete")

from the net-next and usb trees and commit:

  c48c9f7ff32b ("staging: exfat: add exfat filesystem code to staging")

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
index fc1420f2a949,fbdc33874780..000000000000
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@@ -120,9 -118,6 +118,11 @@@ source "drivers/staging/kpc2000/Kconfig
 =20
  source "drivers/staging/isdn/Kconfig"
 =20
 +source "drivers/staging/qlge/Kconfig"
 +
 +source "drivers/staging/wusbcore/Kconfig"
 +source "drivers/staging/uwb/Kconfig"
 +
+ source "drivers/staging/exfat/Kconfig"
+=20
  endif # STAGING
diff --cc drivers/staging/Makefile
index b08ab677e49b,ca13f87b1e1b..000000000000
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@@ -49,7 -49,4 +49,7 @@@ obj-$(CONFIG_XIL_AXIS_FIFO)	+=3D axis-fif
  obj-$(CONFIG_FIELDBUS_DEV)     +=3D fieldbus/
  obj-$(CONFIG_KPC2000)		+=3D kpc2000/
  obj-$(CONFIG_ISDN_CAPI)		+=3D isdn/
 +obj-$(CONFIG_QLGE)		+=3D qlge/
 +obj-$(CONFIG_UWB)		+=3D uwb/
 +obj-$(CONFIG_USB_WUSB)		+=3D wusbcore/
+ obj-$(CONFIG_EXFAT_FS)		+=3D exfat/

--Sig_/7Rz0+Y84nhStRS26SvAVNmn
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl1o36UACgkQAVBC80lX
0GzgUggAlvhyLRTs12ZYfRL8uP2FsACfLiGBGKs7py8Acj/onxEI84OuCspxe8VH
TlsRWV2Sf9JeFOsDv2tLGphZKM5rdXLSgxJIm5yVKpbMJmptOcVGyHaUbTzHg9X7
oD2TpyMkFr1neO4nV+NAp9vKMyPe89IfLJz2ZSw5IrfyQ4ysW4//sAaieTdcC8Jy
OGuUYlxRWs+D3Kwz3pGKGlD9WoTMtuX55AWBYDu1DLM23F/FPtGtJyfB7WSzrqZ4
iVYDyG0dEuhvZyy7afPbuAI7O6kPeITddrt0uQwEOyO4FZg4n/C7UabtLLoYxETw
Pb5HvjE5R4yHfe1OwSIx5lVJlrfO+A==
=yPvP
-----END PGP SIGNATURE-----

--Sig_/7Rz0+Y84nhStRS26SvAVNmn--
