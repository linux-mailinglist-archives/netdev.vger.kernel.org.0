Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 763A31934D8
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 01:07:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727561AbgCZAHb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 20:07:31 -0400
Received: from ozlabs.org ([203.11.71.1]:36159 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727498AbgCZAHa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Mar 2020 20:07:30 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 48nlfl0q1gz9sRf;
        Thu, 26 Mar 2020 11:07:26 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1585181247;
        bh=keFlslcJaRKofY7rCRgd9PqhxN1VT7bn4dRi+eink6Q=;
        h=Date:From:To:Cc:Subject:From;
        b=u5H7mQvME0/LhV28sahCWQsdPqO66ApJF46LerxHE2TEEqTAeGHV8gNNWSkbSg1ie
         lr0tMuccAimUYshoe2krVlb5EbAeG7xi7xCgXAc8h3hnSsccLanRFsBkWEBbzZlewb
         EnjS7xu0KzLGWcJu8iqMjaKHu4Vy7AcSN8AzMOi8aREcqT2XvdR5bmRtQUCrtcR2nk
         yCv31Eg6RK4sc+A41ggN5o1ue3ojOs0zxmo17kmV1rlweikRESb4L+uS6ZT8tooYfE
         M/EVBpKfqPlBZ2GNAUbpLq969nsh2WUlm6Fi0ZLRewO89K3BGZy3tRylAfdRYEZc5p
         9/i/LQun+WZ3Q==
Date:   Thu, 26 Mar 2020 11:07:25 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20200326110725.37b1e636@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/AzVdnvS/5ABMom621vxy99V";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/AzVdnvS/5ABMom621vxy99V
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  tools/testing/selftests/net/Makefile

between commit:

  919a23e9d6cc ("selftests/net: add missing tests to Makefile")

from the net tree and commit:

  7f204a7de8b0 ("selftests: net: Add SO_REUSEADDR test to check if 4-tuples=
 are fully utilized.")

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

diff --cc tools/testing/selftests/net/Makefile
index 4c1bd03ffa1c,48063fd69924..000000000000
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@@ -11,9 -11,8 +11,10 @@@ TEST_PROGS +=3D udpgso_bench.sh fib_rule_
  TEST_PROGS +=3D udpgro_bench.sh udpgro.sh test_vxlan_under_vrf.sh reusepo=
rt_addr_any.sh
  TEST_PROGS +=3D test_vxlan_fdb_changelink.sh so_txtime.sh ipv6_flowlabel.=
sh
  TEST_PROGS +=3D tcp_fastopen_backup_key.sh fcnal-test.sh l2tp.sh tracerou=
te.sh
 -TEST_PROGS +=3D fin_ack_lat.sh
 +TEST_PROGS +=3D fin_ack_lat.sh fib_nexthop_multiprefix.sh fib_nexthops.sh
 +TEST_PROGS +=3D altnames.sh icmp_redirect.sh ip6_gre_headroom.sh
 +TEST_PROGS +=3D route_localnet.sh
+ TEST_PROGS +=3D reuseaddr_ports_exhausted.sh
  TEST_PROGS_EXTENDED :=3D in_netns.sh
  TEST_GEN_FILES =3D  socket nettest
  TEST_GEN_FILES +=3D psock_fanout psock_tpacket msg_zerocopy reuseport_add=
r_any

--Sig_/AzVdnvS/5ABMom621vxy99V
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl578j0ACgkQAVBC80lX
0GxLAwf+LDXAAlbFQJbPpQBxl2YhP9wzxhfQED180RaiXp3167dE5ubFlqkXz6W6
M+ptm06I9Any+a5l13LkKm3I3A3Y+AEwjyQQzZaoKZtlfduahRB5JaTrzlP6jLTa
kxt/bosF9kwKWgrL5p3GSjGN3qkIEBlwui2XbmZwCpOtH4zlPojDLxSHhalNeCsD
kh4UgN/tMhZEnjcqjcS85eY1uuaNaz3yvRjpB5v+W7jWyyVQsZ35EaPIAJwo2BMc
o7LreYonkNtKjBtQKuIKO8IJ5iyyzLgDs2VHL8qg9Fqhjmcg1IckduCZHyXk+AtS
92iBUcQjpXAWvxQce8tI0Uf7sqsa9g==
=JHqU
-----END PGP SIGNATURE-----

--Sig_/AzVdnvS/5ABMom621vxy99V--
