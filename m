Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E28D624E8A
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 00:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231573AbiKJXkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 18:40:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbiKJXkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 18:40:17 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A97244E425;
        Thu, 10 Nov 2022 15:40:15 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4N7dcD5q8Wz4xZb;
        Fri, 11 Nov 2022 10:40:12 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1668123613;
        bh=v7WFZwCJE44bk4UDPUyj4rHwotdx4Bm2Nb3T9fecMuw=;
        h=Date:From:To:Cc:Subject:From;
        b=Y4r9ZkDpf995uXVoICLmPHujhVCw3qMtTeqwS6JHzBBAJ0h0eNoFqpk5jOO1g3/S8
         +fMFzL5SfzVRLJbCv2UdZdGokgYBK+DpTV9fJBGMPNWR7WhCxlbMkMb+UUrGVWzvwK
         u1fE9bG5m47OZSHZcQ1SWEY6gRk7OF/wK7cZau8wQrB8WRd9GXumsGKJ3OhoEzbjjy
         15In/dkOlwsbEWXcl3YAlWLTAPJ2SrrR9KA3M0hOxsNkYW+27XfOXnIwNVSg/7rAhF
         AIMVzlz4XSl1LyAstg7TRP4oOR4bX7Z+hud+E7G9rqJS+CazrBbeuvpFh2KHE1Mg0S
         HB9UQ6O+eCbQQ==
Date:   Fri, 11 Nov 2022 10:40:09 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Eduard Zingerman <eddyz87@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: linux-next: manual merge of the bpf-next tree with the perf tree
Message-ID: <20221111104009.0edfa8a6@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Mf=VGpDvB3Is_MT5DV3pyQm";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/Mf=VGpDvB3Is_MT5DV3pyQm
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the bpf-next tree got a conflict in:

  tools/perf/util/stat.c

between commit:

  8b76a3188b85 ("perf stat: Remove unused perf_counts.aggr field")

from the perf tree and commit:

  c302378bc157 ("libbpf: Hashmap interface update to allow both long and vo=
id* keys/values")

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

diff --cc tools/perf/util/stat.c
index 3a432a949d46,c0656f85bfa5..000000000000
--- a/tools/perf/util/stat.c
+++ b/tools/perf/util/stat.c
@@@ -318,7 -258,27 +318,7 @@@ void evlist__copy_prev_raw_counts(struc
  		evsel__copy_prev_raw_counts(evsel);
  }
 =20
- static size_t pkg_id_hash(const void *__key, void *ctx __maybe_unused)
 -void evlist__save_aggr_prev_raw_counts(struct evlist *evlist)
 -{
 -	struct evsel *evsel;
 -
 -	/*
 -	 * To collect the overall statistics for interval mode,
 -	 * we copy the counts from evsel->prev_raw_counts to
 -	 * evsel->counts. The perf_stat_process_counter creates
 -	 * aggr values from per cpu values, but the per cpu values
 -	 * are 0 for AGGR_GLOBAL. So we use a trick that saves the
 -	 * previous aggr value to the first member of perf_counts,
 -	 * then aggr calculation in process_counter_values can work
 -	 * correctly.
 -	 */
 -	evlist__for_each_entry(evlist, evsel) {
 -		*perf_counts(evsel->prev_raw_counts, 0, 0) =3D
 -			evsel->prev_raw_counts->aggr;
 -	}
 -}
 -
+ static size_t pkg_id_hash(long __key, void *ctx __maybe_unused)
  {
  	uint64_t *key =3D (uint64_t *) __key;
 =20

--Sig_/Mf=VGpDvB3Is_MT5DV3pyQm
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmNti9kACgkQAVBC80lX
0GwgvQf/ZUMJAeCiTypChJ8m4r0T4j7X7SfL7YtAh1iIJA87lNmaQBQs6KcwmfE0
/XRouDfgqloRk0EdSSx9M/bJ7j4pmbHS/n/CfHBEuktttkPxf+V4gd5c5lPNajjq
z1yYKiSo9mMbv4gNrHYhY/r7iv/lTH3hQw8IXUTeX6ShaTrdm53xkNuWg+Np6SEh
wZX1cUXBo3QQXCZHYXiVmrzeGffGznMxy9Zlmfx6CG2KqiEy7EqOXstGDltfAD1l
1zQlrEAVcEXsA7Bcm1lorwWsloRYLQYDne3IaukqqHwJoXNbgLm/fNl3aQd4Jdy2
6Ubwqh7symR9bLFe6oBW5ohU2mzeFg==
=8UFj
-----END PGP SIGNATURE-----

--Sig_/Mf=VGpDvB3Is_MT5DV3pyQm--
