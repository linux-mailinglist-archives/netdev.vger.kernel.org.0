Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB0A4CFC74
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 12:14:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237737AbiCGLPN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 06:15:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237790AbiCGLOh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 06:14:37 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD38EEA37D;
        Mon,  7 Mar 2022 02:37:03 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4KBvz11kX9z4xxT;
        Mon,  7 Mar 2022 21:37:00 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1646649422;
        bh=peX5ncZNw7W4862AAmtxnFFiEeDsecLxz74PLZVkUnY=;
        h=Date:From:To:Cc:Subject:From;
        b=sq6Com675jtq9Pu1MX5OqZvJFWqVUOt9PRF+ShDkT8CsicDFlIFwofgHxm6CMrcwX
         wSUIBPjN4RD5yDoIH34fVpqaxPFUmqy8Bc2aRTiQBsi+9Q0qtC1mQHVxC389u6ZfFy
         Za7Ag4hYvvVvo/yK8IzLmBctalbbiXyEPfM3OxvWDxSM1deL0PtBbkvP9SJHyOoiTT
         85CMrarWbAG/c3WJC1x+snHz9xZemiwiPCy0kk1ah+fTtcngrvQcSVbaVgdLVG6SNn
         pXez91fJLuxXAfQ9gOE8cyCatkZB1P3bWEX8lg/0gkT8Muf2vdrhOKzRe0BV32mBp8
         /yMRdA7MWEl3Q==
Date:   Mon, 7 Mar 2022 21:36:59 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build failure after merge of the net-next tree
Message-ID: <20220307213659.47658125@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/gCNSrbTFcM+LIOGa/Bs8YV=";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/gCNSrbTFcM+LIOGa/Bs8YV=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (arm64
allmodconfig) failed like this:

drivers/net/ethernet/intel/ice/ice_xsk.c: In function 'ice_xmit_pkt_batch':
drivers/net/ethernet/intel/ice/ice_xsk.c:801:0: error: ignoring #pragma GCC=
 unroll [-Werror=3Dunknown-pragmas]
  loop_unrolled_for(i =3D 0; i < PKTS_PER_BATCH; i++) {
 ^
cc1: all warnings being treated as errors

Caused by commit

  126cdfe1007a ("ice: xsk: Improve AF_XDP ZC Tx and use batching API")

This build was done with gcc v5.4.

--=20
Cheers,
Stephen Rothwell

--Sig_/gCNSrbTFcM+LIOGa/Bs8YV=
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmIl4EsACgkQAVBC80lX
0GzsKQgAngfqOjii58mWhtOY4IN+VcduW2Ox7Wntzl3xddZRXN5A6b9d+FGkzuYw
c2XsRUREr/ppjDQ8CvT72N/IE9bUeH6kkxFoH4jV1p1FYVmZLTbSz26Mtguy8Uz/
5urqMkB0fn9Vqd8wxvieOiifXfHEjYqvko5crFjQeb0ygpz5ktSDiMAQ5PtVAIvQ
zcoU4Z3qZKkkQJcPNGqyHAwyyvvf3M5u/7uRB1mJsrbludpHZe7jnduRTl/VHKqo
zp/6s+NMOJN5kDOsCyEZ/3BgK5UCvo0DCRBeyaRGm+OSLiRNbJ7K9mos4hZsP0JZ
0ekCsotarMDnIkV/kxjKvqaW3VUwtA==
=NraY
-----END PGP SIGNATURE-----

--Sig_/gCNSrbTFcM+LIOGa/Bs8YV=--
