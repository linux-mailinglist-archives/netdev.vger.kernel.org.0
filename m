Return-Path: <netdev+bounces-11558-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 02E357339D8
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 21:28:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E21221C20A68
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 19:28:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FBB81E50B;
	Fri, 16 Jun 2023 19:28:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94CD41ACDB
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 19:28:13 +0000 (UTC)
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9B3E44B3;
	Fri, 16 Jun 2023 12:27:52 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id A234B1C0E72; Fri, 16 Jun 2023 21:27:39 +0200 (CEST)
Date: Fri, 16 Jun 2023 21:27:39 +0200
From: Pavel Machek <pavel@denx.de>
To: Sasha Levin <sashal@kernel.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	Xin Long <lucien.xin@gmail.com>, Jon Maloy <jmaloy@redhat.com>,
	"David S . Miller" <davem@davemloft.net>, ying.xue@windriver.com,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net
Subject: Re: [PATCH AUTOSEL 6.1 30/57] tipc: add tipc_bearer_min_mtu to
 calculate min mtu
Message-ID: <ZIy3q/R6olw/6lNY@duo.ucw.cz>
References: <20230525183607.1793983-1-sashal@kernel.org>
 <20230525183607.1793983-30-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pOcNN0TIb0EnTA2m"
Content-Disposition: inline
In-Reply-To: <20230525183607.1793983-30-sashal@kernel.org>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
	SPF_NEUTRAL,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--pOcNN0TIb0EnTA2m
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Xin Long <lucien.xin@gmail.com>
>=20
> [ Upstream commit 3ae6d66b605be604644d4bb5708a7ffd9cf1abe8 ]
>=20
> As different media may requires different min mtu, and even the
> same media with different net family requires different min mtu,
> add tipc_bearer_min_mtu() to calculate min mtu accordingly.
>=20
> This API will be used to check the new mtu when doing the link
> mtu negotiation in the next patch.

Ok, but we don't have the next patch queued with the AUTOSEL, so do we
need this?

> +++ b/net/tipc/bearer.c
> @@ -541,6 +541,19 @@ int tipc_bearer_mtu(struct net *net, u32 bearer_id)
>  	return mtu;
>  }
> =20
> +int tipc_bearer_min_mtu(struct net *net, u32 bearer_id)
> +{
> +	int mtu =3D TIPC_MIN_BEARER_MTU;
> +	struct tipc_bearer *b;
> +
> +	rcu_read_lock();
> +	b =3D bearer_get(net, bearer_id);
> +	if (b)
> +		mtu +=3D b->encap_hlen;
> +	rcu_read_unlock();
> +	return mtu;
> +}
> +

AFAICT this function is unused.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--pOcNN0TIb0EnTA2m
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZIy3qwAKCRAw5/Bqldv6
8k+uAJ46xZVMPMS2L/yZhPiLRpnzuQRsVgCfQpI/MrXuf63XQEISIzq40yFfyVQ=
=NHQn
-----END PGP SIGNATURE-----

--pOcNN0TIb0EnTA2m--

