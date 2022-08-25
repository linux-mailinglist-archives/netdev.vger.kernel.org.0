Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 343ED5A055F
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 02:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231393AbiHYAuc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 20:50:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231476AbiHYAua (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 20:50:30 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4392F596;
        Wed, 24 Aug 2022 17:50:26 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4MCksD337Yz4x1P;
        Thu, 25 Aug 2022 10:50:24 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1661388625;
        bh=jkJhTztnPozjBCAI2OXAXu68d53m4Zie/yipx6ewnvU=;
        h=Date:From:To:Cc:Subject:From;
        b=a4viQohaRfNokVNeIdcHIcHj149f6jR+b1RHoajsoZaLYDvc0tlgYWB8UDqjPNCKO
         qq10fPc3lzwE8fpsTxn5EspqVHcrBW5CX+Ga0Z2JCEtHj3+awtNOScwdoirYq3hf6F
         ZNANOorqMjGuP+z/I/5m5JqOfeT5a41eOqxKXTd/OKpzh/1ijNgIcKCtfOQRpU6w+1
         h1yR9T9+1E44KyKeou5xuAJMPg9g2l9+bQHVsozNGA17rg8cir+bHnNriFflIA6pJd
         /DAbTH0JliN1DK2wXraus69pRUDL/sVn0W1YIDNfgkvuzR0HGlvZt4yda80VptqXsn
         qO/dnWBKdBwiQ==
Date:   Thu, 25 Aug 2022 10:50:22 +1000
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
Message-ID: <20220825105022.7bcaade9@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/h2zF+eM+1jSWEbUpYb5CiSs";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/h2zF+eM+1jSWEbUpYb5CiSs
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the bpf-next tree got a conflict in:

  tools/testing/selftests/bpf/DENYLIST.s390x

between commit:

  27e23836ce22 ("selftests/bpf: Add lru_bug to s390x deny list")

from the bpf tree and commits:

  b979f005d9b1 ("selftest/bpf: Add setget_sockopt to DENYLIST.s390x")
  092e67772728 ("selftests/bpf: Add cb_refs test to s390x deny list")

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
index 5cadfbdadf36,37bafcbf952a..000000000000
--- a/tools/testing/selftests/bpf/DENYLIST.s390x
+++ b/tools/testing/selftests/bpf/DENYLIST.s390x
@@@ -65,4 -65,5 +65,6 @@@ send_signa
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

--Sig_/h2zF+eM+1jSWEbUpYb5CiSs
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmMGx04ACgkQAVBC80lX
0Gx0Cwf/anXU6xaCKz9Ov8vB6G1PNLR3uOqG/X0xGnKd5gyMiKCASasF0qLaP1fk
xJHI6rrSWQ8dZXRnzIN4GvyNEWsvaV529ST9R22SfpYWGHENY61W5zsEyefEgFMc
jKML81Yt70douwFYv31vG19sxWDCEFC9XqsocguecWLTElpnlKUMSed94UI8vjnw
e2a4ZUoKTAFveuONgTBPTSVeVgcGiLkPBYYAO6pisqJEMHZN9FawFU9TWIg+DDXK
rKRuWdyCQU9+3+2d5zD9WMFwRsrZLXDAzZEi+GeE68QfXT286yffQRN3B5sF876G
3ARiTjwQdrlUUjSesTNg+cybIjPHOA==
=5Xzz
-----END PGP SIGNATURE-----

--Sig_/h2zF+eM+1jSWEbUpYb5CiSs--
