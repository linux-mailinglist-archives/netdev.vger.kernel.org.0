Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12F0D31B3A8
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 01:44:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbhBOAok (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Feb 2021 19:44:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbhBOAoi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Feb 2021 19:44:38 -0500
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38F4EC061574;
        Sun, 14 Feb 2021 16:43:58 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Df52N0LCJz9sCD;
        Mon, 15 Feb 2021 11:43:55 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1613349836;
        bh=86KdjeaJAcMvnL7hlmPOF/VXH2fiYIn9Fa7T7CI5BpQ=;
        h=Date:From:To:Cc:Subject:From;
        b=DNuEZskSYfVGUk2a5JoY7psm6psYdm6DXQgFKXGTnawr2bsfr94XRdtik/lmDQwUH
         G0jBenoS0ddMYmA+81n/RGyrsTzpqCZW9Dk3jJj9bDYUjorC9Ap5OBYT/ppGKev0dN
         /eI/bQPW092/0dyVN/Fh09kRYbryriX6hXGXNdRRBk6UEHnF7tAx4IOUo/7Aw2icRV
         xFp7mmrylc8ku2qD6NoU0gH3JMSRadl7rvdfjpBr70q80X+vCo9L/764RdQqr4buM2
         bLt1PLBwRSKU89qjaJ97+6sAt1eSbXItFFKb62RGai7p0c210R6XN6ylSD6DuSRmy9
         tsyW4/zwAip/w==
Date:   Mon, 15 Feb 2021 11:43:54 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Davide Caratti <dcaratti@redhat.com>,
        Guillaume Nault <gnault@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20210215114354.6ddc94c7@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/+ZLGq3v5TI5CsElH3sQs4O_";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/+ZLGq3v5TI5CsElH3sQs4O_
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  tools/testing/selftests/net/forwarding/tc_flower.sh

between commit:

  d2126838050c ("flow_dissector: fix TTL and TOS dissection on IPv4 fragmen=
ts")

from the net tree and commits:

  203ee5cd7235 ("selftests: tc: Add basic mpls_* matching support for tc-fl=
ower")
  c09bfd9a5df9 ("selftests: tc: Add generic mpls matching support for tc-fl=
ower")

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

diff --cc tools/testing/selftests/net/forwarding/tc_flower.sh
index b11d8e6b5bc1,a554838666c4..000000000000
--- a/tools/testing/selftests/net/forwarding/tc_flower.sh
+++ b/tools/testing/selftests/net/forwarding/tc_flower.sh
@@@ -3,7 -3,9 +3,9 @@@
 =20
  ALL_TESTS=3D"match_dst_mac_test match_src_mac_test match_dst_ip_test \
  	match_src_ip_test match_ip_flags_test match_pcp_test match_vlan_test \
- 	match_ip_tos_test match_indev_test match_ip_ttl_test"
+ 	match_ip_tos_test match_indev_test match_mpls_label_test \
+ 	match_mpls_tc_test match_mpls_bos_test match_mpls_ttl_test \
 -	match_mpls_lse_test"
++	match_mpls_lse_test match_ip_ttl_test"
  NUM_NETIFS=3D2
  source tc_common.sh
  source lib.sh

--Sig_/+ZLGq3v5TI5CsElH3sQs4O_
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmApw8oACgkQAVBC80lX
0Gwu9wf/cQmDGCsSWvXDL+14L8Ilf+wkZyUPY05t8NbzmLxn7vy7MMiFiIMSs17E
NOTImHrCc7RO51fltvEAdpOn6lHXqCaOSmmy4MWGzSwmgfS5ugJc3y78ZWR9psnn
IJq0JgHS9cu1w6GKqZZ2AJGNPl10VSEP72LsRCwqG7T90088W6G/cMcTKSb5kjWk
CvjRPSziLTgx3QcNLaxtgeyWK4YzmZQe7skT9UMFBG6n6i0uHx10dFA8oCj1ql01
oAlNZHvZXuEkYToYH29InWEhlC3cL46Ht4q2D/PEHuAwi6kgYjMdQ5tIFD6yeGh7
/k4Se32GUkVjCfKOdol3nFBlVX4Fuw==
=X6Um
-----END PGP SIGNATURE-----

--Sig_/+ZLGq3v5TI5CsElH3sQs4O_--
