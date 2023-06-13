Return-Path: <netdev+bounces-10275-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D126E72D715
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 03:44:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D864C2811C5
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 01:44:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07D9B17CF;
	Tue, 13 Jun 2023 01:44:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECD0D17C7
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 01:44:11 +0000 (UTC)
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD55E91;
	Mon, 12 Jun 2023 18:44:08 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4QgBDL0pVrz4xFc;
	Tue, 13 Jun 2023 11:44:01 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
	s=201702; t=1686620642;
	bh=Vhn9NCKI4b+ZWwXU2mlVYVnz7rRJJ08hkIiKzkVYNNo=;
	h=Date:From:To:Cc:Subject:From;
	b=Gl2PVoSMjROmQV85BXjwHm8FVfTw9DainPcCxPYiy604f5OA0xu+ovoq2fmrPponP
	 uN4+Ru7Q64Mq1e98klr030HcrwHBch4w75LHIcz7mcLrRPylGxccjCvgptG+8cNX6X
	 CS2kESfJEDeCl8NNP+u1qzfDOipm6WTF4gDz/bFK/HlZYyZk6oO42gsgGXd1e1NU0w
	 /X6ZD7PE/GMIdfwXqNjZ0lQIh2wE6SAfNcyW38Eu1ykLxEkoj0HOsYKz86+0xv1YV6
	 1PNiwJxRw2X+zzmJybJ6pXjffzrExxOIwpHEbZQm604GWcKs+f3hSZzIkRrtud5dse
	 s80OG90aEei4w==
Date: Tue, 13 Jun 2023 11:43:59 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, Doug Ledford <dledford@redhat.com>,
 Jason Gunthorpe <jgg@mellanox.com>
Cc: Networking <netdev@vger.kernel.org>, Daniel Jurgens
 <danielj@nvidia.com>, Leon Romanovsky <leon@kernel.org>, Linux Kernel
 Mailing List <linux-kernel@vger.kernel.org>, Linux Next Mailing List
 <linux-next@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Saeed
 Mahameed <saeedm@nvidia.com>
Subject: linux-next: manual merge of the net-next tree with the rdma-fixes
 tree
Message-ID: <20230613114359.59cadc05@canb.auug.org.au>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/iZAUV9bTPFy6JH/xdvbPhsh";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

--Sig_/iZAUV9bTPFy6JH/xdvbPhsh
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  include/linux/mlx5/driver.h

between commit:

  617f5db1a626 ("RDMA/mlx5: Fix affinity assignment")

from the rdma-fixes tree and commit:

  dc13180824b7 ("net/mlx5: Enable devlink port for embedded cpu VF vports")

from the net-next tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc include/linux/mlx5/driver.h
index e0156b54d0b3,18a608a1f567..000000000000
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@@ -1228,18 -1246,11 +1236,23 @@@ static inline u16 mlx5_core_max_vfs(con
  	return dev->priv.sriov.max_vfs;
  }
 =20
 +static inline int mlx5_lag_is_lacp_owner(struct mlx5_core_dev *dev)
 +{
 +	/* LACP owner conditions:
 +	 * 1) Function is physical.
 +	 * 2) LAG is supported by FW.
 +	 * 3) LAG is managed by driver (currently the only option).
 +	 */
 +	return  MLX5_CAP_GEN(dev, vport_group_manager) &&
 +		   (MLX5_CAP_GEN(dev, num_lag_ports) > 1) &&
 +		    MLX5_CAP_GEN(dev, lag_master);
 +}
 +
+ static inline u16 mlx5_core_max_ec_vfs(const struct mlx5_core_dev *dev)
+ {
+ 	return dev->priv.sriov.max_ec_vfs;
+ }
+=20
  static inline int mlx5_get_gid_table_len(u16 param)
  {
  	if (param > 4) {

--Sig_/iZAUV9bTPFy6JH/xdvbPhsh
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmSHyd8ACgkQAVBC80lX
0GxOtQgAjStFgSWvROQ22uyIcuGwkDpjCaUL9ezz/pvLyXO/Y5aF1NjHnnaMg+Du
wq4LI2ampmS+i+3YO5G9VgYbYFaq8lXO2Knxm+P8YV2aaaw0N3DkNF4PxMGMSV4n
C+whZvVQX4KknEZ0wa4wYOgJWT/tXtZau5cmuTXvbIr1XyvfaPoKwH1a0DWD2UAO
PeEITW5Now8KotnZSQJ3CYLihbYF7SUb7KwDawrZ+cyc/2CW//O9koUWAJ00mMTu
ot5zrVLnupLN4MQp2vw1zHFehR4D8N0xopvAqeA8cWTxddyzMefcayym3tA3Vm4S
AUIKFgQjBRyA3mKGjrYufmhgxt9EAg==
=v+/8
-----END PGP SIGNATURE-----

--Sig_/iZAUV9bTPFy6JH/xdvbPhsh--

