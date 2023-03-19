Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69C7B6C0697
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 00:26:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbjCSX0Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 19:26:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbjCSX0X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 19:26:23 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FEC718A9D;
        Sun, 19 Mar 2023 16:26:22 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4PfvBh0kMYz4x7v;
        Mon, 20 Mar 2023 10:26:20 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1679268380;
        bh=fiRI2j4JNgYg2e5UcM6zUXiHtu7sFp98oVTTEl+NmGM=;
        h=Date:From:To:Cc:Subject:From;
        b=LXjC5bIq5HZUJDV0Q5SMzU5JvtC4zXKuXGiDDY9zxh0YZoMfTpY/zOiNWe/q+zgCz
         0kHuyZWriNFtGs3ILqjFUPjcWQcX00oX0TKAL7tdWE3shWHtvzUGJ64GrqoJEfKowU
         qU8/Ce+aOB40DcfAWOvjmNnvgsNc1nHsLcJRJ4V/nZf1xbOXGwwoJX4JavLnkOGLAS
         03KJFdmBinxITywX/JXleRSQG/QX7V+fmDhyM+HqElNbFYYB/ciM8HJiRAqYXFPdBz
         TU1rfjjuNrzDaBPS7Gspwgvt3u4GIOCnntrwpNKgmta2C0hBIIPLdK37QBlcCxI7qd
         kersRLwGqoTaQ==
Date:   Mon, 20 Mar 2023 10:26:19 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Alexander Lobakin <aleksander.lobakin@intel.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build failure after merge of the bpf-next tree
Message-ID: <20230320102619.05b80a98@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/WemvQLbiQPTRyAAQ3uipdGc";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/WemvQLbiQPTRyAAQ3uipdGc
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the bpf-next tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

net/bpf/test_run.c: In function 'frame_was_changed':
net/bpf/test_run.c:224:22: error: 'const struct xdp_page_head' has no membe=
r named 'frm'; did you mean 'frame'?
  224 |         return head->frm.data !=3D head->orig_ctx.data ||
      |                      ^~~
      |                      frame
net/bpf/test_run.c:225:22: error: 'const struct xdp_page_head' has no membe=
r named 'frm'; did you mean 'frame'?
  225 |                head->frm.flags !=3D head->orig_ctx.flags;
      |                      ^~~
      |                      frame

Caused by commit

  e5995bc7e2ba ("bpf, test_run: fix crashes due to XDP frame overwriting/co=
rruption")

I have used the bpf-next tree from next-20230317 for today.

--=20
Cheers,
Stephen Rothwell

--Sig_/WemvQLbiQPTRyAAQ3uipdGc
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmQXmhsACgkQAVBC80lX
0GxcUQf+JcY5gyg2PpbRTN7oF+fzPcLL2UCJF+iFiWLewPMOgYvcFuM3lBkGJuQ2
l6MT3VoSQqO6nGg7Hf0NOgIQQvVJiKUMM6IL8SYe9V2deE/9/cfpIlba12sxuIzM
FXRgLCfDi9Fiev5DZRwg4JykU/TPQdabQeeYn2FqC71AxVNGNfFcJd5SJ8wzS5hP
wHc4MYeozuaoqOnCSoAgGpOvlR0oA08ucIIT6D5EujYIzMNV02Clm64ecAk6hI2C
zcDBLvJWMcWRK+UhmU8HuDs3PXxzRxscmpwwJT9MjYoff1klVdEaVO5AC9Sq7xi1
P58EsuznZZzK9rtt32z/GD+CG0p1kg==
=Nw/B
-----END PGP SIGNATURE-----

--Sig_/WemvQLbiQPTRyAAQ3uipdGc--
