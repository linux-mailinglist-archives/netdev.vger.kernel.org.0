Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E5C61D8E34
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 05:28:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbgESD2E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 23:28:04 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:45489 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726293AbgESD2D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 May 2020 23:28:03 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 49R1YD0kt3z9sTC;
        Tue, 19 May 2020 13:27:59 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1589858881;
        bh=cZmRISKrI+RYRn17j7r5WAvmlVlJYEo6WE9o3Prs4qY=;
        h=Date:From:To:Cc:Subject:From;
        b=RYZE/KvSSLbpmyc5P88oI+NdYktrTk+GX1g00WdrEmpT/bgKMs0YDUaek/5Xt6r7y
         tMPPnHBtFoeZUcCwneMlmqNVBxZagXRLYeDXdOZe8a5z3Jh+XEM7sBUK8DeT+syunc
         pZT8TDuR0PQyx6pMK0NHaIkM3b/7ygvGvZwhUgXU8x/YtVSQ3l8zuP9PQskyO6AR9/
         RhJPQ98ZgixDf9e5HKjyeyehYHJFBPjA2/Zpkvrfqx8gPW8a8KC68Wg0YU5Ci4kgcp
         iRNbVjGyL96Yxp9D0c5R+Quni4lM75tbfliTA9c+1GdRvNE3TtPuiPEBh+pWdniNlX
         15FUzTM26oAIA==
Date:   Tue, 19 May 2020 13:27:58 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: linux-next: manual merge of the ipsec-next tree with the net-next
 tree
Message-ID: <20200519132758.56a187a2@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/liktNAd7tVSiXK0VUsJftfo";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/liktNAd7tVSiXK0VUsJftfo
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the ipsec-next tree got a conflict in:

  net/ipv6/af_inet6.c

between commit:

  3986912f6a9a ("ipv6: move SIOCADDRT and SIOCDELRT handling into ->compat_=
ioctl")

from the net-next tree and commit:

  0146dca70b87 ("xfrm: add support for UDPv6 encapsulation of ESP")

from the ipsec-next tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc net/ipv6/af_inet6.c
index b69496eaf922,aa4882929fd0..000000000000
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@@ -60,7 -60,7 +60,8 @@@
  #include <net/calipso.h>
  #include <net/seg6.h>
  #include <net/rpl.h>
 +#include <net/compat.h>
+ #include <net/xfrm.h>
 =20
  #include <linux/uaccess.h>
  #include <linux/mroute6.h>

--Sig_/liktNAd7tVSiXK0VUsJftfo
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl7DUj4ACgkQAVBC80lX
0GxoSAgApEQQagmIGKqn8Qa5Nm3riSF5J8LlYFILdlec/nxuKS2pL3Vn72YAS0Ln
pJc+wZde8Ha7ywbllIzq08xaDnXrH5EIlF1Kmo/RYKnSzAyOZUBMsLEi6rcN2RIg
3UJcSF85x79NksGwd7PeCM/NJcwHLjMyrFZZKPxu+W98C58KyeECTTRmZe2l5zZ4
8JBX0szMTUbQafRfRRSuRrRhx30Wc2SSII0Z6+T9jLwIXK6zAZLxWpzjHyNGpSMY
tnluq4jqxWoYyyj7Am2VVD4AzTMK3a69iz8qdgwXgDGhhUz1nzuf9sNRngU69nvN
ncs8u/ETIB+JBo+MIASyCxcBeRr7+Q==
=mIB0
-----END PGP SIGNATURE-----

--Sig_/liktNAd7tVSiXK0VUsJftfo--
