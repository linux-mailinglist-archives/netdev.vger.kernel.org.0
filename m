Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0A514E217A
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 08:39:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344984AbiCUHlL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 03:41:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238264AbiCUHlJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 03:41:09 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B60622513;
        Mon, 21 Mar 2022 00:39:44 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4KMRMy59Ysz4xPv;
        Mon, 21 Mar 2022 18:39:41 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1647848383;
        bh=xDLtKCzIwCMOXBHCTysR+A2l6/zwqzCD/UzOuvSWAZI=;
        h=Date:From:To:Cc:Subject:From;
        b=ARNjyVoIrw6o8vWG9ZOvzpl09B5jTblExDJW+LtVbrDL1Z5zK4eFu2N5sSu6Z/QMv
         vfVuMtzwy+EARzZ2O/Qj2lNVLgK2YzxGLZtXQlFnUsYYqXrWrxaSuSJq/Nkda2vsmo
         qyxeBvJEYSIspuqz/p59yb/WU+FDaJ+QzWHOiQ8fQopCjzKIZDwIxY/XerR4P0nNV6
         rnEicGuESxOAA0rQmbGHcJzIGriGZp3zrq+ds0t1bKeHpV61SYW8zcNdplHktzeb9z
         1iShVynPMzmlFyo/HP0z1EH0N4fJTbtAKTME/eBLClg/9bly+APcQ+jthF6zB7YyOy
         JB6DDeaXrzkOw==
Date:   Mon, 21 Mar 2022 18:39:41 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>
Cc:     Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build failure after merge of the net-next tree
Message-ID: <20220321183941.74be2543@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Nd0fBZt5UlW52XVUm3/L7yX";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/Nd0fBZt5UlW52XVUm3/L7yX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (x86_64
allmodconfig) failed like this:

In file included from include/linux/string.h:253,
                 from include/linux/bitmap.h:11,
                 from include/linux/cpumask.h:12,
                 from arch/x86/include/asm/cpumask.h:5,
                 from arch/x86/include/asm/msr.h:11,
                 from arch/x86/include/asm/processor.h:22,
                 from arch/x86/include/asm/timex.h:5,
                 from include/linux/timex.h:65,
                 from include/linux/time32.h:13,
                 from include/linux/time.h:60,
                 from include/linux/ktime.h:24,
                 from include/linux/timer.h:6,
                 from include/linux/netdevice.h:24,
                 from include/trace/events/xdp.h:8,
                 from include/linux/bpf_trace.h:5,
                 from drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c:33:
In function 'fortify_memset_chk',
    inlined from 'mlx5e_xmit_xdp_frame' at drivers/net/ethernet/mellanox/ml=
x5/core/en/xdp.c:438:3:
include/linux/fortify-string.h:242:25: error: call to '__write_overflow_fie=
ld' declared with attribute warning: detected write beyond size of field (1=
st parameter); maybe use struct_group()? [-Werror=3Dattribute-warning]
  242 |                         __write_overflow_field(p_size_field, size);
      |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Caused by commit

  9ded70fa1d81 ("net/mlx5e: Don't prefill WQEs in XDP SQ in the multi buffe=
r mode")

exposed by the kspp tree.

I have applied the following fix patch for today (a better one is
probably possible).

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 21 Mar 2022 18:29:24 +1100
Subject: [PATCH] fxup for "net/mlx5e: Don't prefill WQEs in XDP SQ in the m=
ulti buffer mode"

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c | 3 +--
 include/linux/mlx5/qp.h                          | 5 +++++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net=
/ethernet/mellanox/mlx5/core/en/xdp.c
index f35b62ce4c07..8f321a6c0809 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -435,8 +435,7 @@ mlx5e_xmit_xdp_frame(struct mlx5e_xdpsq *sq, struct mlx=
5e_xmit_data *xdptxd,
 		u8 num_pkts =3D 1 + num_frags;
 		int i;
=20
-		memset(&cseg->signature, 0, sizeof(*cseg) -
-		       sizeof(cseg->opmod_idx_opcode) - sizeof(cseg->qpn_ds));
+		memset(&cseg->trailer, 0, sizeof(cseg->trailer));
 		memset(eseg, 0, sizeof(*eseg) - sizeof(eseg->trailer));
=20
 		eseg->inline_hdr.sz =3D cpu_to_be16(inline_hdr_sz);
diff --git a/include/linux/mlx5/qp.h b/include/linux/mlx5/qp.h
index 61e48d459b23..8bda3ba5b109 100644
--- a/include/linux/mlx5/qp.h
+++ b/include/linux/mlx5/qp.h
@@ -202,6 +202,9 @@ struct mlx5_wqe_fmr_seg {
 struct mlx5_wqe_ctrl_seg {
 	__be32			opmod_idx_opcode;
 	__be32			qpn_ds;
+
+	struct_group(trailer,
+
 	u8			signature;
 	u8			rsvd[2];
 	u8			fm_ce_se;
@@ -211,6 +214,8 @@ struct mlx5_wqe_ctrl_seg {
 		__be32		umr_mkey;
 		__be32		tis_tir_num;
 	};
+
+	); /* end of trailer group */
 };
=20
 #define MLX5_WQE_CTRL_DS_MASK 0x3f
--=20
2.34.1

--=20
Cheers,
Stephen Rothwell

--Sig_/Nd0fBZt5UlW52XVUm3/L7yX
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmI4K70ACgkQAVBC80lX
0GwSsQf/SjRsicTXSYYGxTyqF9otWEDRGHu9z6Zen6irTuRD7utl2m8heIBL18Za
ZNDQM+tJp5uL2h80cS/V/v09QhQgb22VwweKrxgZ733duJTizPZjUWbmjTpaJGUU
yPQ2uGah1A6gIHSZelE1pxFNs8atMQn9lXnuJC3VonlWK18d9HbDLXdZ4zhnsWzv
BVutgzCvU8r4l4NHAN4auhkzPZpLYAkPMKPFOa6Y7Oxh54Fk7OTFM+4vaDXVT99M
YnCiuHkE5MQxaL4j3Njb5q0Sw4Z0wquvkgbzulPpRxpixMwnr0qXlqNH11LQuDmq
uan7jV11As4rNQwx5O2yLchxbUnGeA==
=x6Ul
-----END PGP SIGNATURE-----

--Sig_/Nd0fBZt5UlW52XVUm3/L7yX--
