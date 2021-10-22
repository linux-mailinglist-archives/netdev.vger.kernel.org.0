Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C304436ECE
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 02:24:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231944AbhJVA1A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 20:27:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231740AbhJVA06 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 20:26:58 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B427C061764;
        Thu, 21 Oct 2021 17:24:41 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Hb4qB2FYNz4xbP;
        Fri, 22 Oct 2021 11:24:37 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1634862278;
        bh=4NUhw2kA9TTVCk0/qiwWdQNyoUtSrc/+RLv8jEzz2VA=;
        h=Date:From:To:Cc:Subject:From;
        b=Dqdsl5o79mLBy80YXoxWx7RgAMFwUUFQquou7LD/D6mJDfFV5Hcafw3t7gLZR7cTL
         NC5WVv91dpIud2HNLLP6QTQny0+4bUhXFW/W0Zl7921sBAz7lcDQNG5PMDyYpje2Lq
         3OVFZ3z6fDLM97IDy0egBklApbicKM9IM1c6GOYku01kBbD0J0l75r1bB75UM7FwF/
         qdiWUuGM7EcK/POvodQO1bUSDs8v/zQ7lCUF95ghtbaOzopT86G/PTSqU4WAlAGgC1
         xugJDpajw86dEHvlupBTMt6W1aSsJvHUF6xVgaxiQJienEb90fdV0gEcw1H70oZ3fa
         FgyzgxxqD6LgA==
Date:   Fri, 22 Oct 2021 11:24:36 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Maor Gottlieb <maorg@nvidia.com>, Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build failure after merge of the net-next tree
Message-ID: <20211022112436.4c46b5a4@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/xZbKQyhHJP0aVX9i5lOgcaX";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/xZbKQyhHJP0aVX9i5lOgcaX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/net/ethernet/mellanox/mlx5/core/en_tc.c:71:10: fatal error: lag.h: =
No such file or directory
   71 | #include "lag.h"
      |          ^~~~~~~
drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c:13:10: fatal error: lag=
.h: No such file or directory
   13 | #include "lag.h"
      |          ^~~~~~~

Caused by commit

  3d677735d3b7 ("net/mlx5: Lag, move lag files into directory")

interacting with commit

  14fe2471c628 ("net/mlx5: Lag, change multipath and bonding to be mutually=
 exclusive")

from the net tree.

I have applied the following merge fix patch for today.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 22 Oct 2021 11:10:06 +1100
Subject: [PATCH] fixup for "net/mlx5: Lag, move lag files into directory"

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c | 4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c     | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c b/drivers/=
net/ethernet/mellanox/mlx5/core/en/tc_tun.c
index b7461c17d601..d7e613d0139a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
@@ -10,8 +10,8 @@
 #include "en_tc.h"
 #include "rep/tc.h"
 #include "rep/neigh.h"
-#include "lag.h"
-#include "lag_mp.h"
+#include "lag/lag.h"
+#include "lag/mp.h"
=20
 struct mlx5e_tc_tun_route_attr {
 	struct net_device *out_dev;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tc.c
index 57369925a788..3af3da214a5b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -68,8 +68,8 @@
 #include "lib/fs_chains.h"
 #include "diag/en_tc_tracepoint.h"
 #include <asm/div64.h>
-#include "lag.h"
-#include "lag_mp.h"
+#include "lag/lag.h"
+#include "lag/mp.h"
=20
 #define nic_chains(priv) ((priv)->fs.tc.chains)
 #define MLX5_MH_ACT_SZ MLX5_UN_SZ_BYTES(set_add_copy_action_in_auto)
--=20
2.33.0

--=20
Cheers,
Stephen Rothwell

--Sig_/xZbKQyhHJP0aVX9i5lOgcaX
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmFyBMQACgkQAVBC80lX
0Gx6wAgAll/yy8LLkLU4O5II6DTo+w2fXiSiV2IQICe4Q5067JiX8MtHcbcJPsU2
sIDB5qnH0pcw8/uL/TrVyF8cthtBPRCXRfIzjgOWxN5/aTp35NAuM6LCQopzbuFu
8CXCqYEQoCqaKpa3BkWnyGW1ZRSxxHJVr4r1wC9PdmC4yaurpogz2MHwDIHoFufw
XbN7k+m43PFOiwnGFwlqgsal4eC++BvEN1c2dSBjBSswS6dXJbJdhAT6LaEUh4Xk
Y4SSFMv6cYLCgp7s2cn1cOR7ZhelveuujFSUJl9o9/QnB6fji/WLfUeCjAVTIvyN
oWAquJRJGlubM2ezgv5IBx8xvhCFzQ==
=BJR/
-----END PGP SIGNATURE-----

--Sig_/xZbKQyhHJP0aVX9i5lOgcaX--
