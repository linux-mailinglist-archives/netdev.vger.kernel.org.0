Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DDD55F120
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 04:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727095AbfGDCHv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 22:07:51 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:40891 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726736AbfGDCHu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jul 2019 22:07:50 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45fLwM5YR1z9sBp;
        Thu,  4 Jul 2019 12:07:47 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1562206067;
        bh=FZC5OmKx87+MlDzcP0uX/EGD8A8QXvO+bKQTAKFNPHQ=;
        h=Date:From:To:Cc:Subject:From;
        b=QPNNxX29URxDDHh6fJqWVzz19YXoS9MEi/tnIqYFwG5ePsYZjALYBKs5qS9gH6rjQ
         Gi207c+a5eQvJ30KjPyjZxsIASlckitkULavSgyDkDKF3yD9euvy3SESEBk75cxG3N
         GFtKnPL2kYTFNdL4K+5CXxDr8OWWrqaL8KytdSVKhfLVIPZvMNvtdHcmB9zy+gSxLz
         QIDx+/CqNaO0cU9kmT9+k7vGxKUaJ1zu8h5Su0sT4Kiv53TtKklvQyfy8CMLtIiqrl
         dTPOTMLvozIX+aKsk1mNjPLOwt/Lk5NvxfC0q+8fZM0m4FJ7kA0MJgVBDee1txOMDp
         SgGyBWhFB3KQg==
Date:   Thu, 4 Jul 2019 12:07:46 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Po-Hsu Lin <po-hsu.lin@canonical.com>,
        Willem de Bruijn <willemb@google.com>,
        Mahesh Bandewar <maheshb@google.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20190704120746.23390c34@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/XidfUzLJcY7Hg=ulE2tv0XA"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/XidfUzLJcY7Hg=ulE2tv0XA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  tools/testing/selftests/net/config

between commit:

  ff95bf28c234 ("selftests/net: skip psock_tpacket test if KALLSYMS was not=
 enabled")

from the net tree and commit:

  af5136f95045 ("selftests/net: SO_TXTIME with ETF and FQ")
  509e56b37cc3 ("blackhole_dev: add a selftest")

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

diff --cc tools/testing/selftests/net/config
index 3dea2cba2325,e4b878d95ba0..000000000000
--- a/tools/testing/selftests/net/config
+++ b/tools/testing/selftests/net/config
@@@ -25,4 -25,6 +25,7 @@@ CONFIG_NF_TABLES_IPV6=3D
  CONFIG_NF_TABLES_IPV4=3Dy
  CONFIG_NFT_CHAIN_NAT_IPV6=3Dm
  CONFIG_NFT_CHAIN_NAT_IPV4=3Dm
 +CONFIG_KALLSYMS=3Dy
+ CONFIG_NET_SCH_FQ=3Dm
+ CONFIG_NET_SCH_ETF=3Dm
+ CONFIG_TEST_BLACKHOLE_DEV=3Dm

--Sig_/XidfUzLJcY7Hg=ulE2tv0XA
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl0dX3IACgkQAVBC80lX
0GwskAf+M/f2Jog5t1K6Y0vSyLWCN+X1iASgzbyekBP8Z0AY/7p6hc1UPv0V9Jrc
WOuZhkteYf34tePR1UyU2sMmKO41pIZaveDAF2fHDRrZ2KSLPD3GuJEQ05AOIUW1
3gYPHYcGR/u0R1glVFQ70E416iLFakeYhCCCC8UmDtVZri9SZo388kPRxvyia21i
oeHTNqjuxRRK/JtHNDt0FlQnUIuTylLk4xEOn6TfYXZsZVW/XLE7bmnDhwZLQPa8
OSmqJGVN0dMz+yQyoxK1aq6tKBUGYwgaSG0JVTr847UT/aMSH6kwEx+zXsJvgRlB
4i0ILBOhqOUPlE9s1M8w3Oq6Ri+6hA==
=IL5W
-----END PGP SIGNATURE-----

--Sig_/XidfUzLJcY7Hg=ulE2tv0XA--
