Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D86245A1E54
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 03:47:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244572AbiHZBrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 21:47:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233064AbiHZBrF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 21:47:05 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8454F00;
        Thu, 25 Aug 2022 18:47:02 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4MDN433Jwjz4wgv;
        Fri, 26 Aug 2022 11:46:59 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1661478420;
        bh=Errj4XKH89q1P52Y82X83Hu2p5IV9qbTXCibUzCgWbg=;
        h=Date:From:To:Cc:Subject:From;
        b=I6Y+RyWIeumtWhPItavQxWxcpFwen9E6Nf/lYkiKx3X/+zF8cYln1nCmYyE5ohjWw
         9jYeNZduQP0Xz/6H4SzjGw9ITErqJ4NQamjIAJD47tgwhZk6j2+f9C1GrHG+EqgEnm
         zeDCPIPgXCAGkGoEGb3EXZXL5qY7J6dhnVQLgMye4ndJRrMD4ggJ51KZaaWcYnSSaQ
         BC7UZXY44zHydzsN1dqOO1rNHdsDG9xmCeDIae2lD3UJG6hg0UthckDMGEzYxPVpBf
         YZdWkKkMWxeqc0933ClrodYFF0XUK/B/FLnX5K/KJnVV3A6yx/t8ap24l9Bruwq7kV
         0llkeUjLYMEtw==
Date:   Fri, 26 Aug 2022 11:46:55 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Cc:     Daniel =?UTF-8?B?TcO8bGxlcg==?= <deso@posteo.net>,
        Hao Luo <haoluo@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Yosry Ahmed <yosryahmed@google.com>
Subject: linux-next: manual merge of the bpf-next tree with the bpf tree
Message-ID: <20220826114655.4535c1d0@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/MFR7LOoNg_VNOx55Oz52vhg";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/MFR7LOoNg_VNOx55Oz52vhg
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the bpf-next tree got a conflict in:

  tools/testing/selftests/bpf/DENYLIST.s390x

between commit:

  27e23836ce22 ("selftests/bpf: Add lru_bug to s390x deny list")

from the bpf tree and commit:

  88886309d2e8 ("selftests/bpf: add a selftest for cgroup hierarchical stat=
s collection")

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

diff --cc tools/testing/selftests/bpf/DENYLIST.s390x
index 5cadfbdadf36,736b65f61022..000000000000
--- a/tools/testing/selftests/bpf/DENYLIST.s390x
+++ b/tools/testing/selftests/bpf/DENYLIST.s390x
@@@ -65,4 -65,6 +65,7 @@@ send_signa
  select_reuseport                         # intermittently fails on new s3=
90x setup
  xdp_synproxy                             # JIT does not support calling k=
ernel function                                (kfunc)
  unpriv_bpf_disabled                      # fentry
 +lru_bug                                  # prog 'printk': failed to auto-=
attach: -524
+ setget_sockopt                           # attach unexpected error: -524 =
                                              (trampoline)
+ cb_refs                                  # expected error message unexpec=
ted error: -524                               (trampoline)
+ cgroup_hierarchical_stats                # JIT does not support calling k=
ernel function                                (kfunc)

--Sig_/MFR7LOoNg_VNOx55Oz52vhg
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmMIJg8ACgkQAVBC80lX
0Gw2nQf/Wek0iOFLZ7lv8cXDmZxXlT4Q1afkO81LXDo0g7/ya7FbCjyewnCcksaH
Sgj35dwLh8HPCWQUebBi5gbjYH/OKomVBfoHWIlTs2JvgD8z7KZk16iRGUNsgZLB
DVMWSSXxybmmJCPm7JhyOXZSSDM9cDKsj3YZvyi6j1aaCyUYskSczGnG3ZEdOFRY
l2PVESmnLyBwhAeDdSKIb2P1jBzyITzHQi+aO5ro4AFibxWCHLResK/99ba9pGzn
aJiYWpfQiZbBocv7fgFiqgnqWXyAjyOm8RUZSHg/kLuuivPb6IlzIVFCN4xcR/Oi
7CZeO1GprSvdp5EOc1sXM7djsO9nng==
=51f4
-----END PGP SIGNATURE-----

--Sig_/MFR7LOoNg_VNOx55Oz52vhg--
