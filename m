Return-Path: <netdev+bounces-10294-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 09D9672DA13
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 08:46:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4FDA01C20C2D
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 06:46:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1871423B8;
	Tue, 13 Jun 2023 06:46:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D3EC1844
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 06:46:45 +0000 (UTC)
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E21310D5;
	Mon, 12 Jun 2023 23:46:43 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4QgJxX6GNQz4x42;
	Tue, 13 Jun 2023 16:46:40 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
	s=201702; t=1686638801;
	bh=8+PuIQDjHvRIypCywmblAWQTn4D9Of06vgaNnepsJJA=;
	h=Date:From:To:Cc:Subject:From;
	b=sR1JwL08YgKFOrkD3jJJ+tlhf1w+z/Yu1nADYNVlQa3fQFf/X2O/n8QOOHd1p3vdE
	 P27zymrcGVmuyu76O3ajiAGPogKr1c8Ug60pxyiqSRlsSaOgQBVKiz2vA965VhsL7Z
	 xF4D5B47cI2Mx9dBiidOu/xCh2APQTZeCPcto+yiLalZyl0ZJqgMyiJzbZqZTDphHL
	 bWV4dMOls7DMxWwPMK3d3rOlWoS/ZE3kFkQlzUw/4v8j9vqIljOO5rZ0XOC36/y/RS
	 a5VoAyR1URMIpuXlrZH7GX6zkDNpyzJeEdDFFue9Nzas355hz2FAbHgaN8Tt+qZFmj
	 lAjqUdkXgtIZQ==
Date: Tue, 13 Jun 2023 16:46:39 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, Networking <netdev@vger.kernel.org>
Cc: Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Next
 Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build failure after merge of the net-next tree
Message-ID: <20230613164639.164b2991@canb.auug.org.au>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Tw_E9OZMaCE5DbSiGMgrfQ=";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

--Sig_/Tw_E9OZMaCE5DbSiGMgrfQ=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (sparc64
defconfig) failed like this:

drivers/net/ethernet/sun/sunvnet_common.c: In function 'vnet_handle_offload=
s':
drivers/net/ethernet/sun/sunvnet_common.c:1277:16: error: implicit declarat=
ion of function 'skb_gso_segment'; did you mean 'skb_gso_reset'? [-Werror=
=3Dimplicit-function-declaration]
 1277 |         segs =3D skb_gso_segment(skb, dev->features & ~NETIF_F_TSO);
      |                ^~~~~~~~~~~~~~~
      |                skb_gso_reset
drivers/net/ethernet/sun/sunvnet_common.c:1277:14: warning: assignment to '=
struct sk_buff *' from 'int' makes pointer from integer without a cast [-Wi=
nt-conversion]
 1277 |         segs =3D skb_gso_segment(skb, dev->features & ~NETIF_F_TSO);
      |              ^

Caused by commit

  d457a0e329b0 ("net: move gso declarations and functions to their own file=
s")

I have applied the following patch for today.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 13 Jun 2023 16:38:10 +1000
Subject: [PATCH] Fix a sparc64 use of the gso functions

This was missed when they were moved.

Fixes: d457a0e329b0 ("net: move gso declarations and functions to their own=
 files")
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/net/ethernet/sun/sunvnet_common.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/sun/sunvnet_common.c b/drivers/net/ethern=
et/sun/sunvnet_common.c
index a6211b95ed17..3525d5c0d694 100644
--- a/drivers/net/ethernet/sun/sunvnet_common.c
+++ b/drivers/net/ethernet/sun/sunvnet_common.c
@@ -25,6 +25,7 @@
 #endif
=20
 #include <net/ip.h>
+#include <net/gso.h>
 #include <net/icmp.h>
 #include <net/route.h>
=20
--=20
2.39.2

--=20
Cheers,
Stephen Rothwell

--Sig_/Tw_E9OZMaCE5DbSiGMgrfQ=
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmSIEM8ACgkQAVBC80lX
0Gw5VQf7BoFtLqlYCcZ1EcmSB6rSgKpa+rwDE0zWUy0pmlqre9HG5FjOpqlRzPqV
wcM+ljVgC3cbAYnk/Bf7rkTmmGj888ur/de3Gig7Fu1Onp8iMu0ZJ7uAe7RdLvbb
ai1E2PfD90TAEIYQtrmc6ep3QZRejQMO2J2DfKlOuc4OY4PRdFJxyBXXhnZKl7b5
8YizNNcYANGOSjZqTJZL9bimOSHg5Pfb/QTrVTt+Z3A6Rb/tBSfAVOqcfd6xDYOQ
G+SnMqhK2AomOv6MW/UbSiVQ9dHkTG2jUkDCWvqWUpbdpX+8UCUxMcycNRUlwSsQ
J5MDRriuuXjOEQAWtv1B7V+SopvYVg==
=xo73
-----END PGP SIGNATURE-----

--Sig_/Tw_E9OZMaCE5DbSiGMgrfQ=--

