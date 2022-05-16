Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 482AF527B59
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 03:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239040AbiEPBTZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 May 2022 21:19:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236470AbiEPBTX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 May 2022 21:19:23 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 363F72E9EC;
        Sun, 15 May 2022 18:19:22 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4L1hHB6gh5z4xLb;
        Mon, 16 May 2022 11:19:18 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1652663960;
        bh=YerwPDpR6NiGitLx1rHAaKW6WOaVHQI2JQUt6Kc7awE=;
        h=Date:From:To:Cc:Subject:From;
        b=sO/buOP2+lmZQdCPJqktK+zxNbcIOHit47Yov6le0nWJbIhBr3QWZNvcZT3roCQ6r
         XoliTlx8XBs6z7t28/CtO3JeFfEj9iNajwUQl99lWOVZ9pmka3er6QmEkfp49jdS74
         Jo/TOcsVj3xEaHEU1XOJtGrlWNH3FWXBimSVJzLRG9CA7qmry89bjSK9h/vVcS6TBE
         WR5t8hiKEHYYhm3ahuZ3PyoydigGmBGAEmZXT6FT1sqaVOnqMHBMoY5g7Fy6MaR2WF
         Ib/VBksG1HuxpqHpRDyTlMOzCiPxIgpfkYn0+Dv3ZrzOyGx1KEWWZCGXLj8Io2JtzK
         OrQ4LETRyWjYA==
Date:   Mon, 16 May 2022 11:19:18 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>
Cc:     Networking <netdev@vger.kernel.org>,
        Geliang Tang <geliang.tang@suse.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Paolo Abeni <pabeni@redhat.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20220516111918.366d747f@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/oG9G.D4Cl_PQSJ2xzIU8OBo";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/oG9G.D4Cl_PQSJ2xzIU8OBo
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  tools/testing/selftests/net/mptcp/mptcp_join.sh

between commit:

  e274f7154008 ("selftests: mptcp: add subflow limits test-cases")

from the net tree and commits:

  b6e074e171bc ("selftests: mptcp: add infinite map testcase")
  5ac1d2d63451 ("selftests: mptcp: Add tests for userspace PM type")

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

diff --cc tools/testing/selftests/net/mptcp/mptcp_join.sh
index 48ef112f42c2,d1de1e7702fb..000000000000
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@@ -2583,7 -2690,91 +2717,91 @@@ fastclose_tests(
  	fi
  }
 =20
+ pedit_action_pkts()
+ {
+ 	tc -n $ns2 -j -s action show action pedit index 100 | \
+ 		sed 's/.*"packets":\([0-9]\+\),.*/\1/'
+ }
+=20
+ fail_tests()
+ {
+ 	# single subflow
+ 	if reset_with_fail "Infinite map" 1; then
+ 		run_tests $ns1 $ns2 10.0.1.1 128
+ 		chk_join_nr 0 0 0 +1 +0 1 0 1 "$(pedit_action_pkts)"
+ 		chk_fail_nr 1 -1 invert
+ 	fi
+ }
+=20
+ userspace_tests()
+ {
+ 	# userspace pm type prevents add_addr
+ 	if reset "userspace pm type prevents add_addr"; then
+ 		set_userspace_pm $ns1
+ 		pm_nl_set_limits $ns1 0 2
+ 		pm_nl_set_limits $ns2 0 2
+ 		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
+ 		run_tests $ns1 $ns2 10.0.1.1
+ 		chk_join_nr 0 0 0
+ 		chk_add_nr 0 0
+ 	fi
+=20
+ 	# userspace pm type does not echo add_addr without daemon
+ 	if reset "userspace pm no echo w/o daemon"; then
+ 		set_userspace_pm $ns2
+ 		pm_nl_set_limits $ns1 0 2
+ 		pm_nl_set_limits $ns2 0 2
+ 		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
+ 		run_tests $ns1 $ns2 10.0.1.1
+ 		chk_join_nr 0 0 0
+ 		chk_add_nr 1 0
+ 	fi
+=20
+ 	# userspace pm type rejects join
+ 	if reset "userspace pm type rejects join"; then
+ 		set_userspace_pm $ns1
+ 		pm_nl_set_limits $ns1 1 1
+ 		pm_nl_set_limits $ns2 1 1
+ 		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
+ 		run_tests $ns1 $ns2 10.0.1.1
+ 		chk_join_nr 1 1 0
+ 	fi
+=20
+ 	# userspace pm type does not send join
+ 	if reset "userspace pm type does not send join"; then
+ 		set_userspace_pm $ns2
+ 		pm_nl_set_limits $ns1 1 1
+ 		pm_nl_set_limits $ns2 1 1
+ 		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
+ 		run_tests $ns1 $ns2 10.0.1.1
+ 		chk_join_nr 0 0 0
+ 	fi
+=20
+ 	# userspace pm type prevents mp_prio
+ 	if reset "userspace pm type prevents mp_prio"; then
+ 		set_userspace_pm $ns1
+ 		pm_nl_set_limits $ns1 1 1
+ 		pm_nl_set_limits $ns2 1 1
+ 		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
+ 		run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow backup
+ 		chk_join_nr 1 1 0
+ 		chk_prio_nr 0 0
+ 	fi
+=20
+ 	# userspace pm type prevents rm_addr
+ 	if reset "userspace pm type prevents rm_addr"; then
+ 		set_userspace_pm $ns1
+ 		set_userspace_pm $ns2
+ 		pm_nl_set_limits $ns1 0 1
+ 		pm_nl_set_limits $ns2 0 1
+ 		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
+ 		run_tests $ns1 $ns2 10.0.1.1 0 0 -1 slow
+ 		chk_join_nr 0 0 0
+ 		chk_rm_nr 0 0
+ 	fi
+ }
+=20
 -implicit_tests()
 +endpoint_tests()
  {
  	# userspace pm type prevents add_addr
  	if reset "implicit EP"; then
@@@ -2668,7 -2842,9 +2886,9 @@@ all_tests_sorted=3D
  	d@deny_join_id0_tests
  	m@fullmesh_tests
  	z@fastclose_tests
+ 	F@fail_tests
+ 	u@userspace_tests
 -	I@implicit_tests
 +	I@endpoint_tests
  )
 =20
  all_tests_args=3D""

--Sig_/oG9G.D4Cl_PQSJ2xzIU8OBo
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmKBppYACgkQAVBC80lX
0Gxgwgf/ZOg3OUe/tGNvEUpX/7+4cegAp0wYQomddeAqdrQoUnOonqXFfwiYu10L
Z/0tv66w45GXJm9T9fffmgHIA+zZnKqUuJ1EmaFO/IK1FNm3rUotuiBZBDQpJQH+
sd/GQKm1mbD3GrBBf2yWBdQSeaSGBf88szedCeMDXHqmS2n1HxnBnS2kBxYvDX3w
+SpXRix70Bw4/0LjwJ495oaoek4uQVL/Axo7LeZl2xIJICQ7ozLDiaQ6y7sxcLfA
DlrB3nIOJ8kzopucPH6KUSrE+z1zUjfNymtzNsvYQgc0sDBI9vIb2i/ri1UJMAbY
zYfmZ3vBt6v7GDKyMNvJ4Kt0oILJBQ==
=IgLR
-----END PGP SIGNATURE-----

--Sig_/oG9G.D4Cl_PQSJ2xzIU8OBo--
