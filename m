Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBE314D9419
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 06:45:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345023AbiCOFqu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 01:46:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242291AbiCOFqs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 01:46:48 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BC5B49CB3;
        Mon, 14 Mar 2022 22:45:36 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4KHj703rzyz4xvW;
        Tue, 15 Mar 2022 16:45:32 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1647323135;
        bh=pe+vPAjT5QFNqMcHo392z8pmy8QGUy4wyJA9JUUOmtE=;
        h=Date:From:To:Cc:Subject:From;
        b=AsIfKZ1aYxTaTQJkAu7bhHlgh4WVD98gHakzJNGUGuMK1o8Ow4qnh+D9qVjgamAzb
         gCk09Ku3VkP1Kkc4G+GMaomFYwR4ZPj2dm43sC68XfeHOh3civvfCfPNoqPM5z+A32
         embzNlgqCIb6w9Z//r49v6tea4mq4ajc/NUTX8F+JUn9AArjaVzbUYMcUZwuE76FFf
         bRDDsGYJ9kH17uauBgVmmcaUjEwwrwKVnT3I5bvEUyHoyAe1vwkiK7Ux4SSuYK1qMK
         fYfNYoRNZ95p89aS9kvy2S9TmEaP76o//Rko3Y8HPT1BEOHmMtLpfAW9n+8u5JNkQy
         +xFoXqx1T0trQ==
Date:   Tue, 15 Mar 2022 16:45:31 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Greg KH <greg@kroah.com>, Arnd Bergmann <arnd@arndb.de>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Vinod Koul <vkoul@kernel.org>
Subject: linux-next: manual merge of the char-misc tree with the net-next
 tree
Message-ID: <20220315164531.6c1b626b@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/IHhPEcfMFY+7wk5Rz+M5EG/";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/IHhPEcfMFY+7wk5Rz+M5EG/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the char-misc tree got a conflict in:

  drivers/phy/freescale/Kconfig

between commit:

  8f73b37cf3fb ("phy: add support for the Layerscape SerDes 28G")

from the net-next tree and commit:

  3d565bd6fbbb ("phy: freescale: i.MX8 PHYs should depend on ARCH_MXC && AR=
M64")

from the char-misc tree.

I fixed it up (I think, see below) and can carry the fix as necessary.
This is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc drivers/phy/freescale/Kconfig
index 0e91cd99c36b,856cbec7057d..000000000000
--- a/drivers/phy/freescale/Kconfig
+++ b/drivers/phy/freescale/Kconfig
@@@ -23,12 -26,4 +26,14 @@@ config PHY_FSL_IMX8M_PCI
  	  Enable this to add support for the PCIE PHY as found on
  	  i.MX8M family of SOCs.
 =20
 +config PHY_FSL_LYNX_28G
 +	tristate "Freescale Layerscape Lynx 28G SerDes PHY support"
 +	depends on OF
 +	select GENERIC_PHY
 +	help
 +	  Enable this to add support for the Lynx SerDes 28G PHY as
 +	  found on NXP's Layerscape platforms such as LX2160A.
 +	  Used to change the protocol running on SerDes lanes at runtime.
 +	  Only useful for a restricted set of Ethernet protocols.
++
+ endif

--Sig_/IHhPEcfMFY+7wk5Rz+M5EG/
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEyBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmIwJ/sACgkQAVBC80lX
0Gxfiwf4kVsGEVe4CkKgK1/YrT8YvXnm/1HiPR6xCdPbeezdHTFhwkmMCvD84akW
eksjm3lAU/FUoU43MhxUhEvCx46sDDEPXmTtTK0JZaZm+E78x37azl+ls/mD9zo/
CGV2/tauuWAP5gPZDI+w5oclvSOesLzS+xi9xqUPz3gZh+d5mwmnJrTHuVg7Yuu7
mAqDkrPR+QiVRl6f99wCOTE93l1Ewc72erG9QfQLqZmKJXtRbMmqtIvM4LXZ0j9c
TANowiFFbQWRMcIDP0B6EesoD9YFB8dCQRDfscm244WCwTn6lOzk9ZhwLtyVi4zC
XdTNjyHT3SCthUajotODfWJPTfHB
=bFL8
-----END PGP SIGNATURE-----

--Sig_/IHhPEcfMFY+7wk5Rz+M5EG/--
