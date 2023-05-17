Return-Path: <netdev+bounces-3476-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 061D0707642
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 01:08:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EA9C61C21015
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 23:08:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C2482A9D1;
	Wed, 17 May 2023 23:08:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DF1A2A9C0
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 23:08:34 +0000 (UTC)
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D2FA526E;
	Wed, 17 May 2023 16:07:52 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4QM7yh2v95z4x3l;
	Thu, 18 May 2023 09:06:35 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
	s=201702; t=1684364796;
	bh=TLigtFIBgNJwprVuOd00Sej3gN4o6b45qDmLjvBO1+Q=;
	h=Date:From:To:Cc:Subject:From;
	b=D5+6aVoaSHKSGWh9ZDQtJK4KcpnS7yNchJkS7NlfXBu+VMnKFJhyikjZwj8xmulAj
	 I8uztHmZXEeu+0YbBlTQXaawNHkEz9EyISi6zMYclUfYDE0O1SdKi/uPTv9NOrqt+I
	 Kag7Msyj+bH0M+JITVikprdlot4CtflPQIqkdIB3oPBUvCOSld019m9pkoUxc2aJNw
	 Van2FP0Kbvai0TtXHbUI+ZJ91xu1D/wznMregfCUVSmDFp170d8gi0c1/HysYzqQJ7
	 9U9CdgsqnKF/VX88pEV+zVVjrFpkc8OwnWQmq9rPZTzHnM+1ra+0b5pmaKizxr6VT4
	 +sj0ehU2CbhoA==
Date: Thu, 18 May 2023 09:06:34 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, Networking <netdev@vger.kernel.org>
Cc: Jakub Kicinski <kuba@kernel.org>, Dario Binacchi
 <dario.binacchi@amarulasolutions.com>, Marc Kleine-Budde
 <mkl@pengutronix.de>, Linux Kernel Mailing List
 <linux-kernel@vger.kernel.org>, Linux Next Mailing List
 <linux-next@vger.kernel.org>
Subject: linux-next: build failure after merge of the net tree
Message-ID: <20230518090634.6ec6b1e1@canb.auug.org.au>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/oMfsfzBtc69v/FQFFrgQOeO";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

--Sig_/oMfsfzBtc69v/FQFFrgQOeO
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net tree, today's linux-next build (arm
multi_v7_defconfig) failed like this:

Error: arch/arm/boot/dts/stm32f746.dtsi:265.20-21 syntax error
FATAL ERROR: Unable to parse input tree
make[2]: *** [scripts/Makefile.lib:419: arch/arm/boot/dts/stm32f746-disco.d=
tb] Error 1
Error: arch/arm/boot/dts/stm32f746.dtsi:265.20-21 syntax error
FATAL ERROR: Unable to parse input tree
make[2]: *** [scripts/Makefile.lib:419: arch/arm/boot/dts/stm32f769-disco.d=
tb] Error 1
Error: arch/arm/boot/dts/stm32f746.dtsi:265.20-21 syntax error
FATAL ERROR: Unable to parse input tree

Caused by commit

  0920ccdf41e3 ("ARM: dts: stm32: add CAN support on stm32f746")

I have used the net tree from next-20230517 for today.

--=20
Cheers,
Stephen Rothwell

--Sig_/oMfsfzBtc69v/FQFFrgQOeO
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmRlXfoACgkQAVBC80lX
0Gxkjgf/Sii3tAf/wi+QcJErmCZmqfLkkQk8ZNy/w7ZL7+wj/A29VoLFieJnEJEA
8tHY+qM0NnagOtVKYzstfUH8SHwYmEciRtJb2t57r/NK0tAiZOUkz/pZupF8zPYt
okoZXX6jOx0DVaRtLc3SROP2ltb5pu7GvY0WSPdhkHirQ7N6dOhWgE6i5IN96wAq
qIX0hHiLfVbfk01KkaubvQz/lpknllXwY12vma1QVJvkxHnIH8cLt9tjdN5lAGcE
QKS2zqtaKEx3xo53CrhUjHTpQZmU2jFyj9K8s5Zyb22mXajy0iSPHc9M1w5TU3fV
5siBJTkNkUeKNuCNV6jrFxk4AwKDVg==
=W1eQ
-----END PGP SIGNATURE-----

--Sig_/oMfsfzBtc69v/FQFFrgQOeO--

