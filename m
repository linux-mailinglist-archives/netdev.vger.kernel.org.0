Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F70949A4B4
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 03:10:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2375531AbiAYAUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 19:20:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2371542AbiAYAIa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 19:08:30 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8194FC07E5FC;
        Mon, 24 Jan 2022 13:56:45 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4JjP2g5NNcz4xkH;
        Tue, 25 Jan 2022 08:56:43 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1643061404;
        bh=4S2QL1mgQdDy3wG5x8z+3aHXu4I0TpoY6OXzQgXC6gM=;
        h=Date:From:To:Cc:Subject:From;
        b=KopXF4/hev5V2fzuxyBJm/547JvhmXcBZp2ruOVmha+g5iNl5GEo8JjNsAN/fDLsN
         PL2zq4XapD+gS79OkAuQQQRWoEVZKl6GOKoHTksRCNZ15K3uTLWmvcCIgYR5LU3WBC
         Ki0toDsFI2H+vQbNtQ/Fo8fYUVFrIJLgbvos0eagCgruCCTOtKYxeVu69O/mXuKByd
         pYgcA89ZsDqonzyTQUoK+aUNkmRceXnTL0WalkmWqd5L7mpn+7MtxJWxfLzKTfXiEh
         JMxdOGNwgMULdmqzLVb7nSYt7ivmCe26pa7wzSds1+jpVYYoYPfCaMtYw/ef5BBI14
         aEjDkmbmRLYqg==
Date:   Tue, 25 Jan 2022 08:56:43 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Toke =?UTF-8?B?SMO4aWxhbmQt?= =?UTF-8?B?SsO4cmdlbnNlbg==?= 
        <toke@redhat.com>
Subject: linux-next: manual merge of the bpf-next tree with Linus' tree
Message-ID: <20220125085643.14e441b6@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/1_7SJyP+trl=NHHKfArBEdF";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/1_7SJyP+trl=NHHKfArBEdF
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the bpf-next tree got a conflict in:

  tools/testing/selftests/bpf/prog_tests/xdp_link.c

between commit:

  4b27480dcaa7 ("bpf/selftests: convert xdp_link test to ASSERT_* macros")

from Linus' tree and commit:

  544356524dd6 ("selftests/bpf: switch to new libbpf XDP APIs")

from the bpf-next tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc tools/testing/selftests/bpf/prog_tests/xdp_link.c
index b2b357f8c74c,0c5e4ea8eaae..000000000000
--- a/tools/testing/selftests/bpf/prog_tests/xdp_link.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_link.c
@@@ -8,9 -8,9 +8,9 @@@
 =20
  void serial_test_xdp_link(void)
  {
- 	DECLARE_LIBBPF_OPTS(bpf_xdp_set_link_opts, opts, .old_fd =3D -1);
 -	__u32 duration =3D 0, id1, id2, id0 =3D 0, prog_fd1, prog_fd2, err;
  	struct test_xdp_link *skel1 =3D NULL, *skel2 =3D NULL;
 +	__u32 id1, id2, id0 =3D 0, prog_fd1, prog_fd2;
+ 	LIBBPF_OPTS(bpf_xdp_attach_opts, opts);
  	struct bpf_link_info link_info;
  	struct bpf_prog_info prog_info;
  	struct bpf_link *link;
@@@ -41,14 -40,14 +41,14 @@@
  	id2 =3D prog_info.id;
 =20
  	/* set initial prog attachment */
- 	err =3D bpf_set_link_xdp_fd_opts(IFINDEX_LO, prog_fd1, XDP_FLAGS_REPLACE=
, &opts);
+ 	err =3D bpf_xdp_attach(IFINDEX_LO, prog_fd1, XDP_FLAGS_REPLACE, &opts);
 -	if (CHECK(err, "fd_attach", "initial prog attach failed: %d\n", err))
 +	if (!ASSERT_OK(err, "fd_attach"))
  		goto cleanup;
 =20
  	/* validate prog ID */
- 	err =3D bpf_get_link_xdp_id(IFINDEX_LO, &id0, 0);
+ 	err =3D bpf_xdp_query_id(IFINDEX_LO, 0, &id0);
 -	CHECK(err || id0 !=3D id1, "id1_check",
 -	      "loaded prog id %u !=3D id1 %u, err %d", id0, id1, err);
 +	if (!ASSERT_OK(err, "id1_check_err") || !ASSERT_EQ(id0, id1, "id1_check_=
val"))
 +		goto cleanup;
 =20
  	/* BPF link is not allowed to replace prog attachment */
  	link =3D bpf_program__attach_xdp(skel1->progs.xdp_handler, IFINDEX_LO);
@@@ -61,9 -60,9 +61,9 @@@
  	}
 =20
  	/* detach BPF program */
- 	opts.old_fd =3D prog_fd1;
- 	err =3D bpf_set_link_xdp_fd_opts(IFINDEX_LO, -1, XDP_FLAGS_REPLACE, &opt=
s);
+ 	opts.old_prog_fd =3D prog_fd1;
+ 	err =3D bpf_xdp_detach(IFINDEX_LO, XDP_FLAGS_REPLACE, &opts);
 -	if (CHECK(err, "prog_detach", "failed %d\n", err))
 +	if (!ASSERT_OK(err, "prog_detach"))
  		goto cleanup;
 =20
  	/* now BPF link should attach successfully */
@@@ -73,24 -72,25 +73,24 @@@
  	skel1->links.xdp_handler =3D link;
 =20
  	/* validate prog ID */
- 	err =3D bpf_get_link_xdp_id(IFINDEX_LO, &id0, 0);
+ 	err =3D bpf_xdp_query_id(IFINDEX_LO, 0, &id0);
 -	if (CHECK(err || id0 !=3D id1, "id1_check",
 -		  "loaded prog id %u !=3D id1 %u, err %d", id0, id1, err))
 +	if (!ASSERT_OK(err, "id1_check_err") || !ASSERT_EQ(id0, id1, "id1_check_=
val"))
  		goto cleanup;
 =20
  	/* BPF prog attach is not allowed to replace BPF link */
- 	opts.old_fd =3D prog_fd1;
- 	err =3D bpf_set_link_xdp_fd_opts(IFINDEX_LO, prog_fd2, XDP_FLAGS_REPLACE=
, &opts);
+ 	opts.old_prog_fd =3D prog_fd1;
+ 	err =3D bpf_xdp_attach(IFINDEX_LO, prog_fd2, XDP_FLAGS_REPLACE, &opts);
 -	if (CHECK(!err, "prog_attach_fail", "unexpected success\n"))
 +	if (!ASSERT_ERR(err, "prog_attach_fail"))
  		goto cleanup;
 =20
  	/* Can't force-update when BPF link is active */
- 	err =3D bpf_set_link_xdp_fd(IFINDEX_LO, prog_fd2, 0);
+ 	err =3D bpf_xdp_attach(IFINDEX_LO, prog_fd2, 0, NULL);
 -	if (CHECK(!err, "prog_update_fail", "unexpected success\n"))
 +	if (!ASSERT_ERR(err, "prog_update_fail"))
  		goto cleanup;
 =20
  	/* Can't force-detach when BPF link is active */
- 	err =3D bpf_set_link_xdp_fd(IFINDEX_LO, -1, 0);
+ 	err =3D bpf_xdp_detach(IFINDEX_LO, 0, NULL);
 -	if (CHECK(!err, "prog_detach_fail", "unexpected success\n"))
 +	if (!ASSERT_ERR(err, "prog_detach_fail"))
  		goto cleanup;
 =20
  	/* BPF link is not allowed to replace another BPF link */
@@@ -109,8 -109,9 +109,8 @@@
  		goto cleanup;
  	skel2->links.xdp_handler =3D link;
 =20
- 	err =3D bpf_get_link_xdp_id(IFINDEX_LO, &id0, 0);
+ 	err =3D bpf_xdp_query_id(IFINDEX_LO, 0, &id0);
 -	if (CHECK(err || id0 !=3D id2, "id2_check",
 -		  "loaded prog id %u !=3D id2 %u, err %d", id0, id1, err))
 +	if (!ASSERT_OK(err, "id2_check_err") || !ASSERT_EQ(id0, id2, "id2_check_=
val"))
  		goto cleanup;
 =20
  	/* updating program under active BPF link works as expected */

--Sig_/1_7SJyP+trl=NHHKfArBEdF
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmHvIJsACgkQAVBC80lX
0GwzXwf/d+fypAnqe9dQ0KH2hWEWCM+EuR+6KNO3awVyilMlumFFqA6fgj6gjnVi
N7KUtj4XuyLHdDyScoWy8JXfFBz4V1wyVRoKB6I2bB0xF3inV3GrPOucv9ytQrU1
CtCRSDaEe/FeUM9pr5ck70fwB6X36+zPqERqOD4xkD8Rvc1VRr16zKydAhsup1Tv
7X4QMazfwHoavWKk5vSqmd1ePx4ZlHEcpcF8ES7rgmgqFUrLXK2RaovwBhVX0oFV
UjzwPYkw2BKE/hgSITSVI2H9H4UcADcK9fcfKfEmGDC1AwiVNU4XbyXqcq+Hfagg
ScEKp1VDUWHVb5osbZVoLIWAkgU/wA==
=XKBz
-----END PGP SIGNATURE-----

--Sig_/1_7SJyP+trl=NHHKfArBEdF--
