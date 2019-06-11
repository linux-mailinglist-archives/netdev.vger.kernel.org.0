Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE19B3C5E2
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 10:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404727AbfFKI0r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 04:26:47 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:40515 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403996AbfFKI0r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Jun 2019 04:26:47 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45NNQC5pVCz9sBp;
        Tue, 11 Jun 2019 18:26:42 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1560241604;
        bh=PeRbKliT0EifnHfr0s140XpRtxDlY3OUvNTQHClWPPU=;
        h=Date:From:To:Cc:Subject:From;
        b=lQ8v5ML7hV3hen8t9DneukbifqX4mIMXzKEEZZ+6S8/ryhgGKaVyiR6P46BEpO0Z7
         twa5225t327ZK5B6pCoPl5uVlKDrsO9AtMfTfmUUOrFogMLfvRGvQFUVINfrrtAaRd
         NcrsMHqHkYUv1kqkgA9BXoyEE18k2WPe20OS+N5aJ2pr8lbwsTkDFQu5ZsdTJabmcz
         Vk8Ig13k2eh8B3r/EAJ6Juspm+dIjT2mwYOT8JSpnPrZGRxDWxkAQp/rcgQzfZJ5L+
         Xrsu4rUdxQJ4wiY+dpxW5d1+K9Fm5d8mlZ1V7jxpg0+e28CxTpkSQRy5oQ/6C4UQx8
         uNARcOMz+bDxg==
Date:   Tue, 11 Jun 2019 18:26:40 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: linux-next: build failure after merge of the net-next tree
Message-ID: <20190611182640.44a4a73d@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/UoN_PsASjWyoilpmu=DVVDC"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/UoN_PsASjWyoilpmu=DVVDC
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/net/ethernet/ti/cpts.c: In function 'cpts_of_mux_clk_setup':
drivers/net/ethernet/ti/cpts.c:567:2: error: implicit declaration of functi=
on 'of_clk_parent_fill'; did you mean 'of_clk_get_parent_name'? [-Werror=3D=
implicit-function-declaration]
  of_clk_parent_fill(refclk_np, parent_names, num_parents);
  ^~~~~~~~~~~~~~~~~~
  of_clk_get_parent_name
drivers/net/ethernet/ti/cpts.c:575:11: error: implicit declaration of funct=
ion 'clk_hw_register_mux_table'; did you mean 'clk_hw_register_clkdev'? [-W=
error=3Dimplicit-function-declaration]
  clk_hw =3D clk_hw_register_mux_table(cpts->dev, refclk_np->name,
           ^~~~~~~~~~~~~~~~~~~~~~~~~
           clk_hw_register_clkdev
drivers/net/ethernet/ti/cpts.c:575:9: warning: assignment to 'struct clk_hw=
 *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
  clk_hw =3D clk_hw_register_mux_table(cpts->dev, refclk_np->name,
         ^
drivers/net/ethernet/ti/cpts.c:586:29: error: 'clk_hw_unregister_mux' undec=
lared (first use in this function); did you mean 'clk_hw_register_clkdev'?
            (void(*)(void *))clk_hw_unregister_mux,
                             ^~~~~~~~~~~~~~~~~~~~~
                             clk_hw_register_clkdev
drivers/net/ethernet/ti/cpts.c:586:29: note: each undeclared identifier is =
reported only once for each function it appears in
drivers/net/ethernet/ti/cpts.c:593:8: error: implicit declaration of functi=
on 'of_clk_add_hw_provider'; did you mean 'of_clk_get_from_provider'? [-Wer=
ror=3Dimplicit-function-declaration]
  ret =3D of_clk_add_hw_provider(refclk_np, of_clk_hw_simple_get, clk_hw);
        ^~~~~~~~~~~~~~~~~~~~~~
        of_clk_get_from_provider
drivers/net/ethernet/ti/cpts.c:593:42: error: 'of_clk_hw_simple_get' undecl=
ared (first use in this function); did you mean 'ida_simple_get'?
  ret =3D of_clk_add_hw_provider(refclk_np, of_clk_hw_simple_get, clk_hw);
                                          ^~~~~~~~~~~~~~~~~~~~
                                          ida_simple_get
drivers/net/ethernet/ti/cpts.c:598:29: error: 'of_clk_del_provider' undecla=
red (first use in this function); did you mean 'of_clk_get_from_provider'?
            (void(*)(void *))of_clk_del_provider,
                             ^~~~~~~~~~~~~~~~~~~
                             of_clk_get_from_provider
cc1: some warnings being treated as errors

Caused by commit

  a3047a81ba13 ("net: ethernet: ti: cpts: add support for ext rftclk select=
ion")

of_clk_parent_fill() and others above are only available if
CONFIG_COMMON_CLK is set (which it is not for this build).

I have reverted that commit for today.

--=20
Cheers,
Stephen Rothwell

--Sig_/UoN_PsASjWyoilpmu=DVVDC
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlz/ZcEACgkQAVBC80lX
0Gzb1wgAiRuZPnzj+RLpIckzkvD5xxGkj1ZRMBFklt6VwXSYKQfJJkYVcxYWWJAS
zpXFWgRfjp4IDlGUnRz39vgorkOjb4NrVqn292X0Ln6xm5e4umA4XB6nKDMURKGd
6bplOtuP8SgPum8Opny8jtpWYpoGW1xMi0kw2JTKgF1UVf+wBkiTYBzRJkZpw3UQ
cB0g26fbhOOg4ZFxfo2Q86dsTS6YZPnH7CaPaz6Wk2/W8hbq3SsJKMbXHGgp2Kxs
fbrulPXP6tGFuku7vsQhP4SfPEp6dU34HzZPP/9rnsgQQmO5KvUTGerI+2GANgEE
8RsZBLLFc5plpC6gkR+K0yiV5qWNeQ==
=rjZT
-----END PGP SIGNATURE-----

--Sig_/UoN_PsASjWyoilpmu=DVVDC--
