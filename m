Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1ECC05E257
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 12:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbfGCKt1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 06:49:27 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:50335 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726544AbfGCKt1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jul 2019 06:49:27 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45dyXg5Kw8z9s4Y;
        Wed,  3 Jul 2019 20:49:23 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1562150964;
        bh=wcJRF5awK9VFplzQrvl0xSNRx3Qpc7cMbU202oXK/bE=;
        h=Date:From:To:Cc:Subject:From;
        b=R1uWKAifUwCwvrVaqOS6ql1oNTIskGbaHY1sAWqqnC2TVj5qIh9eBDRfyeGwNqtxd
         cDThu0moCJ6dkORD3ioXIzF3cPj7HCIsxmvqd4+SGgTAFMcBA6hYAc+DLqlhYEzBVx
         uMK15vGPJekJ3bYsYadRGe7bRcVN3t18Ztsp8Bpu0C00U88eRMnl8PWeyVxiCh0S5A
         S7iUsY+Ho7ODnprGxyjQARSeyMO/UGdLzu0fo1OG2E0IXoHamO6rOdKuatTh4JSYBh
         WRYkVnWnSDd7kpbJGSAH5XP270rwF25/WSiTRGmDp6Ceze2fqY7dFIT/u71cqVnseJ
         C1vsaEaaRDhFA==
Date:   Wed, 3 Jul 2019 20:49:21 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Eiichi Tsukata <devel@etsukata.com>
Subject: linux-next: manual merge of the akpm tree with the net-next tree
Message-ID: <20190703204921.69bc9074@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/RMargG3XWq7_PIiCvD6joQA"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/RMargG3XWq7_PIiCvD6joQA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the akpm tree got a conflict in:

  net/ipv6/sysctl_net_ipv6.c

between commit:

  00dc3307c0f7 ("net/ipv6: Fix misuse of proc_dointvec "flowlabel_reflect"")

from the net-next tree and patch:

  "proc-sysctl-add-shared-variables-for-range-check-fix-2-fix"

from the akpm tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc net/ipv6/sysctl_net_ipv6.c
index 57f520d1bf45,e00cf070e542..000000000000
--- a/net/ipv6/sysctl_net_ipv6.c
+++ b/net/ipv6/sysctl_net_ipv6.c
@@@ -112,8 -112,8 +112,8 @@@ static struct ctl_table ipv6_table_temp
  		.data		=3D &init_net.ipv6.sysctl.flowlabel_reflect,
  		.maxlen		=3D sizeof(int),
  		.mode		=3D 0644,
 -		.proc_handler	=3D proc_dointvec,
 +		.proc_handler	=3D proc_dointvec_minmax,
- 		.extra1		=3D &zero,
+ 		.extra1		=3D SYSCTL_ZERO,
  		.extra2		=3D &flowlabel_reflect_max,
  	},
  	{

--Sig_/RMargG3XWq7_PIiCvD6joQA
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl0ciDEACgkQAVBC80lX
0GwpZAf8DYM6yf+jJSeiMzFBHbQsePC0ea5FZ5eVPIRS9Yeai3g+CUfNrBgGi0qV
faGK895dzjZpylJk9nZveABDCX+sY0TXByp8jYDDPSh9KJAcUDKbzrqiIOQFPEUh
qPLglC7k6VnybrSmFVmNf1/jC2AH1/cTRkohBaD/EweLKJVxmFwyCMPNrpg54HDo
QQSZGXqvd5LjGR2o5UhA/OQGDE9ron8wnr2N+dF0pTTgMqkE8sXvKbNHFXII7QdN
UB8UljWT4IH3t5GbmBn94xAFkSzclwpTFhdvmVpmox8STpkavfAmC31QR5AS+nbO
2W1n3BFUWqMsL+wVdwaEfZicyyxvvA==
=AHoM
-----END PGP SIGNATURE-----

--Sig_/RMargG3XWq7_PIiCvD6joQA--
