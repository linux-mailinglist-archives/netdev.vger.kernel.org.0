Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89A5359B724
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 03:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232133AbiHVBBy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Aug 2022 21:01:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229948AbiHVBBw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Aug 2022 21:01:52 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15ABE201A8;
        Sun, 21 Aug 2022 18:01:51 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4M9vFj6wXxz4x1N;
        Mon, 22 Aug 2022 11:01:45 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1661130106;
        bh=6l9j7X22BBA4N65+/fw8NpRm9wwmtmsASnaDP6DcOUQ=;
        h=Date:From:To:Cc:Subject:From;
        b=bXna29IRdNDjYgbgweAkj+3drBgKC84AYZtQcJvHH/Fl2Uz9gFjWoMuQ7yLk+h/WW
         EEIwu+SOYK7bcKQ43iemROLVuUyxtylobUTXUBxlzZvctplP4n/ipFJmAFZ/URXtYd
         0G3iVyb7SmUnQ9VxGFZRBZC9YA0uYsRhDMOs4oYTRECDMk6p5wvuFX/po8DVbytfLA
         3wkcRqyAk6pUqQEYT/9SF5OqP9dbiHwD+WpgqZIo3GGYoOfZbphtWSTpQjVjMfOqcB
         YCZPw5oiBk+E4wH+EYZvHgjSBbROhYoxnbVKFvCjplssPGZMpyNomOc1Xqk2yP/0Ou
         acfClBBLHYmzg==
Date:   Mon, 22 Aug 2022 11:01:44 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Cc:     Daniel =?UTF-8?B?TcO8bGxlcg==?= <deso@posteo.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>
Subject: linux-next: manual merge of the bpf-next tree with the bpf tree
Message-ID: <20220822110144.199455d6@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/np7iLFcswnasyimVYWlLVVK";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/np7iLFcswnasyimVYWlLVVK
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the bpf-next tree got a conflict in:

  tools/testing/selftests/bpf/DENYLIST.s390x

between commit:

  27e23836ce22 ("selftests/bpf: Add lru_bug to s390x deny list")

from the bpf tree and commit:

  b979f005d9b1 ("selftest/bpf: Add setget_sockopt to DENYLIST.s390x")

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
index 5cadfbdadf36,a708c3dcc154..000000000000
--- a/tools/testing/selftests/bpf/DENYLIST.s390x
+++ b/tools/testing/selftests/bpf/DENYLIST.s390x
@@@ -65,4 -65,4 +65,5 @@@ send_signa
  select_reuseport                         # intermittently fails on new s3=
90x setup
  xdp_synproxy                             # JIT does not support calling k=
ernel function                                (kfunc)
  unpriv_bpf_disabled                      # fentry
 +lru_bug                                  # prog 'printk': failed to auto-=
attach: -524
+ setget_sockopt                           # attach unexpected error: -524 =
                                              (trampoline)

--Sig_/np7iLFcswnasyimVYWlLVVK
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmMC1XgACgkQAVBC80lX
0GxfMAf/RpVbYOcDE3iGxTsojuJZ4d8t7OgQZu7trQZwAc2EtWXxtP09bwURSe2D
s9Ah3TD2guoOHKEeQ4mDCMMryITDJ/E1qY2H/shn1XbGerBThC+hJwQ1Lx19OkDr
57Yp4/wDnQ5oSnXb4Pb6z5LAtF5KkleQ5yl5vnxa/6xsYKRF+fn6ufpBCrPPdkWP
b+g8embFhny5mEfvjYwQ9QPcceCH9QfDJSUSYwK9HxHbdV5zMzJX4nwCXSxuAJgs
vXd/Of9ZE3Gf5ocoglptg2xJ21hx0nkE6USg1Y9u55OxOIsaq7cyqc6P57cd1gAu
lhuHI8jgKce4U4NgqIf3tM51zNmwoQ==
=hvXH
-----END PGP SIGNATURE-----

--Sig_/np7iLFcswnasyimVYWlLVVK--
