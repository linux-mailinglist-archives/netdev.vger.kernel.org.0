Return-Path: <netdev+bounces-9095-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D310A7273C0
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 02:31:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8C0882815E3
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 00:31:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DD57636;
	Thu,  8 Jun 2023 00:31:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92D28622
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 00:31:37 +0000 (UTC)
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 609632128;
	Wed,  7 Jun 2023 17:31:35 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4Qc4rw0QHQz4wgv;
	Thu,  8 Jun 2023 10:31:27 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
	s=201702; t=1686184288;
	bh=8F60OUp8CBqwzKFBb/J0sj2amxP/qg9IkT2KgaJBCzU=;
	h=Date:From:To:Cc:Subject:From;
	b=C3PWvFiiyycWravL3+GM6DwHS5Ln6nUX1FN8GqvXB9i/H+AlZX2OtNWS0xpxem7Df
	 at/w2As1RARwqgY/s5+aAlXcrIlHk1IsKqT7huEe7/mwnb0v2eUtL4BNSlEyXs7M0F
	 XJT1fB1m6gCUQhcqlR9s8WO21VLC/aRZsISIFWFFNjNLsUeiqGbePxVyZACB1NUe5g
	 rDtVhCQW1W7j06IQvogFMcd+EFYxmadIpJ+tQNBV2beM3OyuD3A/DEMR3NcNTLrj4j
	 ulALn2z2nPi1+eSSOeRZ3HI9d/Kq0uL56q24XLZMCWASWJpFE/WWV4gJKw8HQoPB7f
	 rA3gHcvka+gYQ==
Date: Thu, 8 Jun 2023 10:31:26 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, Networking <netdev@vger.kernel.org>
Cc: Jakub Kicinski <kuba@kernel.org>, Eric Dumazet <edumazet@google.com>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Next
 Mailing List <linux-next@vger.kernel.org>, Vladimir Oltean
 <vladimir.oltean@nxp.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20230608103126.24c01d43@canb.auug.org.au>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/i77_LI4b+/m/9CssqV4/xF0";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

--Sig_/i77_LI4b+/m/9CssqV4/xF0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  net/sched/sch_taprio.c

between commit:

  d636fc5dd692 ("net: sched: add rcu annotations around qdisc->qdisc_sleepi=
ng")

from the net tree and commit:

  dced11ef84fb ("net/sched: taprio: don't overwrite "sch" variable in tapri=
o_dump_class_stats()")

from the net-next tree.

I fixed it up (I think - see below) and can carry the fix as necessary.
This is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc net/sched/sch_taprio.c
index dd7dea2f6e83,3c4c2c334878..000000000000
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@@ -2388,12 -2456,19 +2456,19 @@@ static int taprio_dump_class_stats(stru
  	__acquires(d->lock)
  {
  	struct netdev_queue *dev_queue =3D taprio_queue_get(sch, cl);
 -	struct Qdisc *child =3D dev_queue->qdisc_sleeping;
++	struct Qdisc *child =3D rtnl_dereference(dev_queue->qdisc_sleeping);
+ 	struct tc_taprio_qopt_offload offload =3D {
+ 		.cmd =3D TAPRIO_CMD_TC_STATS,
+ 		.tc_stats =3D {
+ 			.tc =3D cl - 1,
+ 		},
+ 	};
 =20
- 	sch =3D rtnl_dereference(dev_queue->qdisc_sleeping);
- 	if (gnet_stats_copy_basic(d, NULL, &sch->bstats, true) < 0 ||
- 	    qdisc_qstats_copy(d, sch) < 0)
+ 	if (gnet_stats_copy_basic(d, NULL, &child->bstats, true) < 0 ||
+ 	    qdisc_qstats_copy(d, child) < 0)
  		return -1;
- 	return 0;
+=20
+ 	return taprio_dump_xstats(sch, d, &offload, &offload.tc_stats.stats);
  }
 =20
  static void taprio_walk(struct Qdisc *sch, struct qdisc_walker *arg)

--Sig_/i77_LI4b+/m/9CssqV4/xF0
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmSBIV4ACgkQAVBC80lX
0GwVFAf/XLPsL36oXBv44Wvz0NiQLHfTxc56wDkckBsszqcNDhcdZSKyOeCFNuuc
P+gh0r0FePNRG/64aruMI+3N6aipPa1dyvX5kOqPZKajS0RzCVoPBsXtxODZ8hFa
9VEzpVM55mpaP/ZswJ3ukqC+55klF6e0bhGNGv/lenNi7ooteUYxHqK3wWVST6XO
0/SK+c1HzG5r/7iwZ3gpc4YdW6oSV0ZyNj+nH0neaqtmt4C+S8s1EoPZhA99e4R7
KumiFxIZTb+HPINdwOpQ07/g8EVjjaf+THgl9RbrU+8JbAR+ACoTk+xrlzRe5P7l
iT0MnmQTDladDjQpDRIeTQcNqpnhgw==
=Dg6F
-----END PGP SIGNATURE-----

--Sig_/i77_LI4b+/m/9CssqV4/xF0--

