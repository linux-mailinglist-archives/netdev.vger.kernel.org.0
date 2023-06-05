Return-Path: <netdev+bounces-7820-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F1B0721B24
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 02:08:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8A044280FEA
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 00:08:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64A73181;
	Mon,  5 Jun 2023 00:08:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 595D2160
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 00:08:27 +0000 (UTC)
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D6CBCA;
	Sun,  4 Jun 2023 17:08:25 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4QZDTZ5MLPz4x3x;
	Mon,  5 Jun 2023 10:08:18 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
	s=201702; t=1685923699;
	bh=pOuSQOaAtbYZsqBRiDrrigcw5i1OYkXIadN59Arc/E0=;
	h=Date:From:To:Cc:Subject:From;
	b=CwEbPaMySvPrNOJMWKcrPQ2k2yRRLUopa4U+AObiivGk8UZY3mxuwRhdvUKEAG68D
	 55ECZO3XcxU3XRa0iqCtNqAGH4FDhwOxuQ8sWov2L8EO8rTusoUNwUjvsyRrOAR7lv
	 PJx6e2mNnG8kWAzQTdR6ancCX3B6ttHoL6TDddGg57hw+jpWqq9XmvBEEzkmHai2e8
	 +XnZ6WarUIzwOcJcggjg3uQGC080HfwPooynDp8txv7NelD9MyERQsdWB5y8Q685JK
	 SPKRTkvOIxyHUUioNHZ2mYtFNG3Arb5ff/XOXhknoMoB9BnZlWdufpHZ2mHifyjtZa
	 Dp21JstSvMDJA==
Date: Mon, 5 Jun 2023 10:08:16 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, Networking <netdev@vger.kernel.org>
Cc: Akihiro Suda <akihiro.suda.cz@hco.ntt.co.jp>, Akihiro Suda
 <suda.gitsendemail@gmail.com>, David Morley <morleyd@google.com>, Kuniyuki
 Iwashima <kuniyu@amazon.com>, Linux Kernel Mailing List
 <linux-kernel@vger.kernel.org>, Linux Next Mailing List
 <linux-next@vger.kernel.org>, Neal Cardwell <ncardwell@google.com>, Paolo
 Abeni <pabeni@redhat.com>, Yuchung Cheng <ycheng@google.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20230605100816.08d41a7b@canb.auug.org.au>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/u3D+RwDlPWSFsvlRdb6GZfK";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

--Sig_/u3D+RwDlPWSFsvlRdb6GZfK
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  net/ipv4/sysctl_net_ipv4.c

between commit:

  e209fee4118f ("net/ipv4: ping_group_range: allow GID from 2147483648 to 4=
294967294")

from the net tree and commit:

  ccce324dabfe ("tcp: make the first N SYN RTO backoffs linear")

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

diff --cc net/ipv4/sysctl_net_ipv4.c
index 88dfe51e68f3,6ae3345a3bdf..000000000000
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@@ -34,8 -34,9 +34,9 @@@ static int ip_ttl_min =3D 1
  static int ip_ttl_max =3D 255;
  static int tcp_syn_retries_min =3D 1;
  static int tcp_syn_retries_max =3D MAX_TCP_SYNCNT;
+ static int tcp_syn_linear_timeouts_max =3D MAX_TCP_SYNCNT;
 -static int ip_ping_group_range_min[] =3D { 0, 0 };
 -static int ip_ping_group_range_max[] =3D { GID_T_MAX, GID_T_MAX };
 +static unsigned long ip_ping_group_range_min[] =3D { 0, 0 };
 +static unsigned long ip_ping_group_range_max[] =3D { GID_T_MAX, GID_T_MAX=
 };
  static u32 u32_max_div_HZ =3D UINT_MAX / HZ;
  static int one_day_secs =3D 24 * 3600;
  static u32 fib_multipath_hash_fields_all_mask __maybe_unused =3D

--Sig_/u3D+RwDlPWSFsvlRdb6GZfK
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmR9J3AACgkQAVBC80lX
0Gw4KAf/WUlZ1HiMtDpseIqqq8A4ZUoXPy7QxK8guXuvpKEBN7LIV8ZXr7vwVeOQ
oQBEXwg18mLRT8L5KBVRrcg0GZXSgLkN/ZPcROcMiB9imC56Ag3j9H21zlLEpL29
LEGDlfneaNTnJdSx3aBKsg6Wne7BTh9EQED/7a0IHAOOIfYLRT8Mf7ic6Y7Dl8p0
Xl8j9O8bBvP+IB2dw/wOiTlECY+IIlQQyEr+zJKLjjFYV7Sw402J/IFhf+iihHhd
BSlETxgZZyknOuN6PSUfAgXigaVKDi/LKuAXft37RTPRl6bdAgNpEmhWEMx17aJ3
l8k0Kl+LEwpObX54frPxvZwuD94oZA==
=HRyB
-----END PGP SIGNATURE-----

--Sig_/u3D+RwDlPWSFsvlRdb6GZfK--

