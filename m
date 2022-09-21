Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6B235BF28D
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 03:04:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231167AbiIUBEo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 21:04:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbiIUBEn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 21:04:43 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11B2810FC3;
        Tue, 20 Sep 2022 18:04:41 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4MXKvC0xbvz4xG9;
        Wed, 21 Sep 2022 11:04:39 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1663722279;
        bh=QYiZ/3EajQNT/5YEDcWBcSjjbAKnltSIy5iJgQfWgwU=;
        h=Date:From:To:Cc:Subject:From;
        b=Tquj4+wFnxqK/8THmORMr23oLgh7MAmfYHazE7z90oY1/e2XY0U/PrhUwHdGEFu8M
         jQBNgRnqghV7oBACPhR+3kbEWi0oyC1pnqpTxiEMKJZcjLvhYAllt5abMiE1wqKOHy
         l3W6w623ICeJz7hF5CxlIYTiLyculJPHIXEtfYoY8sqgJ4/MeJwixcakJ0qajScKMD
         cCIzCBrpOBglJ9+USVTI3i3TYESvbVEOy4roBR8OCDkjmGiijspWjPA5aFd9Eohgc9
         SDbEXbwd44OGjBHiK9Z0uzZe0PMrbyXZZrjcYSKajnXvvyHqmlnl3pxz4hklMTnkEO
         +GB7ByrsAkFmA==
Date:   Wed, 21 Sep 2022 11:04:37 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Benjamin Poirier <bpoirier@nvidia.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20220921110437.5b7dbd82@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/fMzlTe=dfgNibQEXH1RoZP1";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/fMzlTe=dfgNibQEXH1RoZP1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  tools/testing/selftests/drivers/net/bonding/Makefile

between commit:

  bbb774d921e2 ("net: Add tests for bonding and team address list managemen=
t")

from the net tree and commit:

  152e8ec77640 ("selftests/bonding: add a test for bonding lladdr target")

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

diff --cc tools/testing/selftests/drivers/net/bonding/Makefile
index 0f9659407969,d209f7a98b6c..000000000000
--- a/tools/testing/selftests/drivers/net/bonding/Makefile
+++ b/tools/testing/selftests/drivers/net/bonding/Makefile
@@@ -1,9 -1,7 +1,10 @@@
  # SPDX-License-Identifier: GPL-2.0
  # Makefile for net selftests
 =20
 -TEST_PROGS :=3D bond-break-lacpdu-tx.sh
 +TEST_PROGS :=3D bond-break-lacpdu-tx.sh \
 +	      dev_addr_lists.sh
+ TEST_PROGS +=3D bond-lladdr-target.sh
 =20
 +TEST_FILES :=3D lag_lib.sh
 +
  include ../../../lib.mk

--Sig_/fMzlTe=dfgNibQEXH1RoZP1
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmMqYyUACgkQAVBC80lX
0GzWcwf/Uo+MDRXuWaswDOzApoLW53AoWpLbvZA5CZHYyyAeDTkYBrhn6oSCUrep
zvFDyCm72RPsCqYh0eplUtbZ5wUg3H3OmhSrR2FphdL886jjhpSQCWcjHDRJUC38
40nKUkGK+Ho+e7b+Ai1peHE6h8ngFiJbUXF0ei1/br+lrJ7Ixc4LqEn6qWPKKnJ6
yly/mDszX1EwdosSnxf+k6XrIpSbBQnGpwlpheHqmMcu6HMZIvfK9JaSHfad8zI9
b15pgVJI6YPWJzvFJ+vrg7zP9608K4qCZSlHE3ICDWgdTzDIc+UNM8QoQc/0jUB7
fCLhxsKO6IAbvRTMScsQJOlsI2ZDtg==
=LLRc
-----END PGP SIGNATURE-----

--Sig_/fMzlTe=dfgNibQEXH1RoZP1--
