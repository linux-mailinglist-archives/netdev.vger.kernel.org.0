Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 293AD3B2398
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 00:29:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbhFWWbg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 18:31:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbhFWWbf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 18:31:35 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4F9CC061574;
        Wed, 23 Jun 2021 15:29:16 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4G9HxP1HNPz9sCD;
        Thu, 24 Jun 2021 08:29:12 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1624487353;
        bh=B0nnRaXy3juVwSWhjg6oCgD9xS70cicB6mdlEGWBlF0=;
        h=Date:From:To:Cc:Subject:From;
        b=YhD5Q6GLIwL//8kIvc1dJ1BBS1np/DKQz7tryiVL8eNi69BU5MyGfIfHIF/lc/LXz
         MRW3NrrCRwAcGLt1VWHKz4LHwz9rwVQgc9YvHgY4CLb4Sh4nXWGTwgdhVpgxQyTQ4L
         nSX+Ue6K2yf/DfJ9Sx5JN3tsQQzl3+dO8jlpiiO9oj/ik87nh6pwX7oum5ouj53GJ5
         1Dm5GQVGw2aWimTKIA6cJ9bIRqdKlvI/hrEspv5YMWMGC1V+8674lWD90j2giMEE3A
         x6C0A+VaNirVz/xu++0jUzmrWVSUpJCqr7vCdopPwf2JkXABoAg+tHns87myulzAZs
         nupcoi0ybuxmg==
Date:   Thu, 24 Jun 2021 08:29:11 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Marcin Wojtas <mw@semihalf.com>
Subject: linux-next: build failure after merge of the net-next tree
Message-ID: <20210624082911.5d013e8c@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/ZRNepBVwBa+CXQz8hwLzlt6";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/ZRNepBVwBa+CXQz8hwLzlt6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next build (x86_64 modules_install) failed like this:

depmod: ../tools/depmod.c:1792: depmod_report_cycles_from_root: Assertion `=
is < stack_size' failed.

Caused by commit

62a6ef6a996f ("net: mdiobus: Introduce fwnode_mdbiobus_register()")

(I bisected to there and tested the commit before.)

The actual build is an x86_64 allmodconfig, followed by a
modules_install.  This happens in my cross build environment as well as
a native build.

$ gcc --version
gcc (Debian 10.2.1-6) 10.2.1 20210110
$ ld --version
GNU ld (GNU Binutils for Debian) 2.35.2
$ /sbin/depmod --version
kmod version 28
-ZSTD +XZ -ZLIB +LIBCRYPTO -EXPERIMENTAL

I have no idea why that commit should caused this failure.
--=20
Cheers,
Stephen Rothwell

--Sig_/ZRNepBVwBa+CXQz8hwLzlt6
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmDTtbcACgkQAVBC80lX
0GyWnAf/fmWanH5fu0BZZxX7crVE4yFDux50672MBz3UemASiwSxESWCibgyLt/S
iX4tn6ZZ4xev5Zj/2WBHee53ZQ+R8tpWt8JGultrcy4nWN9/+QzUJL28WRKtg3ih
Wcau62uEnk0nI3pN/LB3OJBdrF3jsPk27zWemNdlGKK9HHLz5jwXuH2cIZXu2Y23
jN+bJbSc/svwAQzQvNpAZiKdN4LCrGXakpYL5ztmWYDVleqYOIDZ2GZU5pQcaT+2
J5pwlBQPjq80n3sqoBObnkTAqVRY0N78uQXraK0SWMJ4ORla9LiHme57uoIIY4nW
JpqVGSvOqSjc9RgasAnIocaM8P4iyQ==
=I5ac
-----END PGP SIGNATURE-----

--Sig_/ZRNepBVwBa+CXQz8hwLzlt6--
