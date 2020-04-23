Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83F0E1B5218
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 03:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbgDWBnV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 21:43:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbgDWBnU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 21:43:20 -0400
X-Greylist: delayed 12401 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 22 Apr 2020 18:43:20 PDT
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8221FC03C1AA;
        Wed, 22 Apr 2020 18:43:20 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4970SN6b8Hz9sSd;
        Thu, 23 Apr 2020 11:43:16 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1587606197;
        bh=+Oe8bj8PhMMloiNTEF+tPE9kazN7s8cc/Q+pJLOx2ME=;
        h=Date:From:To:Cc:Subject:From;
        b=fwkUXe3fgqT4VNtMtTTWvC5MfPBmuvdGHhAgNSegkyiawbz/QK7t6+gxtBoEnXJP5
         V/8IhmxIk+pf4BGL7ZB8naFdu157p8RA/NwhNjF1XeU5tHj1+OenAQGpH2WBZ752AU
         hBUzVcH2IE2/aw2BlSHZSrFDUA90ZN3e0b77ilLpJRry28bZ0SQlqDsjQUSWKuzTBK
         Mo6nZE6e5+EhW/7DWj5wgZNFEbY2z55D1qNTGwVWUXO+zjDcARoGm5TXQgJBHX+TtP
         AxIbKk75RlE4OdUTWdmYL5R9XR5PRicob6gt7YxNs9HQaEArnEc+eYtuBt9jt8aaPy
         Yx0+t7qTBaJMQ==
Date:   Thu, 23 Apr 2020 11:43:13 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Leon Romanovsky <leonro@mellanox.com>
Subject: linux-next: manual merge of the net-next tree with the
 kbuild-current tree
Message-ID: <20200423114313.634bf6cd@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/8BsiIvlLwI3mvWUcKjtJ27C";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/8BsiIvlLwI3mvWUcKjtJ27C
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  include/linux/vermagic.h

between commit:

  e3459da6c363 ("arch: split MODULE_ARCH_VERMAGIC definitions out to <asm/v=
ermagic.h>")

from the kbuild-current tree and commit:

  51161bfc66a6 ("kernel/module: Hide vermagic header file from general use")

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

diff --cc include/linux/vermagic.h
index dc236577b92f,7768d20ada39..000000000000
--- a/include/linux/vermagic.h
+++ b/include/linux/vermagic.h
@@@ -1,9 -1,10 +1,13 @@@
  /* SPDX-License-Identifier: GPL-2.0 */
 +#ifndef _LINUX_VERMAGIC_H
 +#define _LINUX_VERMAGIC_H
 =20
+ #ifndef INCLUDE_VERMAGIC
+ #error "This header can be included from kernel/module.c or *.mod.c only"
+ #endif
+=20
  #include <generated/utsrelease.h>
 +#include <asm/vermagic.h>
 =20
  /* Simply sanity version stamp for modules. */
  #ifdef CONFIG_SMP

--Sig_/8BsiIvlLwI3mvWUcKjtJ27C
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl6g8rEACgkQAVBC80lX
0GxBwQf/WI2vcF+eXo4TdZk72JDteMo0bxJRQTxYsF0np8HFDp94a+Z29xzOC9Ue
7M48lUb59GipOSqbAaEQMCTSLJ1MEnALOiAFq5IrBY36wd5AEdfckhTNBN+tKKap
aFF4NkoU9qrY7czZzu/1fiENLfqLWGJbTPAZcPQSyJN+heLQBmPc3+tpPrKlnign
eQCNdTi6gP0pXrITEosOGSqSSaixglXDQaE1bKQMUpr68m6T8rswSDbLEVOyDeLY
1kU20iLaL/Q14LvQuBqoNrH2uDj/JzMdR68iXKymRC2WjMTLq5IYzGY/j81nIfxT
qjgGuoGYgWQSUHlKcLEYAiQPTFbYDg==
=P0PE
-----END PGP SIGNATURE-----

--Sig_/8BsiIvlLwI3mvWUcKjtJ27C--
