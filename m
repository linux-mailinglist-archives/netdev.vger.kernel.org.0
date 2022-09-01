Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42AF65A8A54
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 03:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231888AbiIABLN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 21:11:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230436AbiIABLK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 21:11:10 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D957DB7D6;
        Wed, 31 Aug 2022 18:11:08 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4MJ2zp4792z4x3w;
        Thu,  1 Sep 2022 11:11:02 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1661994663;
        bh=bdwYw6Lw4PZEUz1P6wwyQRjfONTNQqkdi9285wuidR4=;
        h=Date:From:To:Cc:Subject:From;
        b=pMPqUX9lcpfkOKeVnUk2iNQKJAcx8Tcn3fvNgPZj9MLfG6xHcfE6RB4QSPeNE2zOD
         snD7l6anTEuKX2X/78FbfwGUIRE/fYGuxlrMEKvfnRfpj3qvIxnVznk5+l+26EdfkY
         Bi8okEiU8ovQCpcJTIzLXY8vXbzVH6IaDLNmDNaDyey2w3UAUCXmF1Faed0J8G5CaN
         wCiO5sMcWbeUYpcZtMS7dhfX70dL4YpNiType01t+fIt1xV6MLaX0k3YReMxAWI1Ly
         2SPJ/i9ntkTxjkuPLx/5RfbkMTy2vCeeWdbojtgKXdtatgyFiWjTeCSPrS9t1iurJh
         nAEbfhxDrTirQ==
Date:   Thu, 1 Sep 2022 11:11:01 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Daniel =?UTF-8?B?TcO8bGxlcg==?= <deso@posteo.net>,
        Hou Tao <houtao1@huawei.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>
Subject: linux-next: manual merge of the bpf-next tree with the net tree
Message-ID: <20220901111101.32e9026c@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/vaLzHlUr1ypekTRcD5RedOW";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/vaLzHlUr1ypekTRcD5RedOW
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the bpf-next tree got a conflict in:

  tools/testing/selftests/bpf/DENYLIST.s390x

between commit:

  27e23836ce22 ("selftests/bpf: Add lru_bug to s390x deny list")

from the net tree and commit:

  1c636b6277a2 ("selftests/bpf: Add test cases for htab update")

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
index 5cadfbdadf36,ba02b559ca68..000000000000
--- a/tools/testing/selftests/bpf/DENYLIST.s390x
+++ b/tools/testing/selftests/bpf/DENYLIST.s390x
@@@ -65,4 -65,7 +65,8 @@@ send_signa
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
+ htab_update                              # failed to attach: ERROR: strer=
ror_r(-524)=3D22                                (trampoline)

--Sig_/vaLzHlUr1ypekTRcD5RedOW
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmMQBqUACgkQAVBC80lX
0Gz2pgf+Mp4AM6eo9MWGQGAQYpar1mLyZbRwh6n+bRv675VRkUX2df5LwXvEvNSM
D+0C2J9E9kdeFOvljgvElyB7veTsJhKe7XYsxhdiugEAXDCP9jPipTSjUbw3N9/t
0lVYQ7p1aL4AUCo1+BYjjn4zY04aod5vsmAZ/hSweoTmHwnSPWWfyYEr73GlrKQZ
vTK9owY59ux+ffoEA8dQDzvMkqSjCARLEVOAZW8e8dQK8W5yqtc4+Xw/2sUyZdHU
VjMqXThUHOKLuFqsulRafkcr2482jBuPEeCFgBXxMTZ46uRUEn0rhfSyPrBoqNoA
0O0rCTRCapNpLMM8jCEWNuTdXkWJWw==
=eWu3
-----END PGP SIGNATURE-----

--Sig_/vaLzHlUr1ypekTRcD5RedOW--
