Return-Path: <netdev+bounces-6572-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AD42B716FAA
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 23:25:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4DA381C20D25
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 21:25:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEED32D271;
	Tue, 30 May 2023 21:25:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1AE7200BC
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 21:25:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A804FC433EF;
	Tue, 30 May 2023 21:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685481932;
	bh=ejaclWSHbDLbp2UXNQomtdqhegOAlHZIrxyIZTVXKG0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=td3ZU43xsQvVU2R0wcNsnwsdM3a1v+ibDR+c4mmB9cjPYvhJPSosdwxhR8Q0ntZGW
	 EX/XuKfGRlh5Jd4qYZGbLtJtdLZ5vbcpXjYu+BNqgzZK1HKkiuYH2nATxREdKmObxF
	 wpGQSOgu5vufwjTf9ma5eUZ5LQIf20q4yGSv+by/z1aQu9Q5UtWVvGhq2pYTKEBfBH
	 DNtPoV3FEZFIv6scJT8igpXey8Y9DQmvGKff1bTgyiNObhDdOtyJLuYMH6oNkOEiWB
	 SmeKRlhvQG8TT0e/OG63n8yrvY71Shk0Yg0dGCVRmfS+B27tRETqSWs8yYQQyncnkb
	 Lh24gvb6yDx4A==
Date: Tue, 30 May 2023 22:25:26 +0100
From: Mark Brown <broonie@kernel.org>
To: Niklas Schnelle <schnelle@linux.ibm.com>
Cc: Shay Drory <shayd@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
	Eli Cohen <elic@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net] net/mlx5: Fix setting of irq->map.index for static
 IRQ case
Message-ID: <7469ae42-63a2-4078-b997-30d959429d70@sirena.org.uk>
References: <20230530141304.1850195-1-schnelle@linux.ibm.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="EZeP2Ayk5L3aJND3"
Content-Disposition: inline
In-Reply-To: <20230530141304.1850195-1-schnelle@linux.ibm.com>
X-Cookie: Many are cold, but few are frozen.


--EZeP2Ayk5L3aJND3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 30, 2023 at 04:13:04PM +0200, Niklas Schnelle wrote:
> When dynamic IRQ allocation is not supported all IRQs are allocated up
> front in mlx5_irq_table_create() instead of dynamically as part of
> mlx5_irq_alloc(). In the latter dynamic case irq->map.index is set
> via the mapping returned by pci_msix_alloc_irq_at(). In the static case
> and prior to commit 1da438c0ae02 ("net/mlx5: Fix indexing of mlx5_irq")
> irq->map.index was set in mlx4_irq_alloc() twice once initially to 0 and
> then to the requested index before storing in the xarray. After this
> commit it is only set to 0 which breaks all other IRQ mappins.

s/mappins/mappings/

We were seeing the issue that this fixes on a Cavium ThunderX2 system
and the analysis looks good so:

Tested-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Mark Brown <broonie@kernel.org>

--EZeP2Ayk5L3aJND3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmR2acUACgkQJNaLcl1U
h9CyKwf/fk+JCCweTuB1F1pHhuuKuWees2MC0dMrpv7VT2X2DcuakOc+KMjUwODW
o0gZ0Hq009KEesiIQN95nyUf8R6MJQHaeKbMQ/CdxQk6g247yKjeS5jcYfenphsf
0IulzAjix0uqHM7TTMO3Rv/C+tfvsI5C7odcJrL1fWQwlTCScdhGHnWs0by1B4QI
0Ki8F1HCXbDIMfNgAH/MrKdIC0Rz0zeTAEIhhhiZcJjDOHAXbcHC+T8ruk3K7t31
gf2AzU/OWw/OL0eAz1uOoaTKSczh6Kq2hTZHpF5yVttJOeESTpqq8oUE9UQEhuLf
eoISI7psNmYdrhMXifygdMYrwBbKIQ==
=puE3
-----END PGP SIGNATURE-----

--EZeP2Ayk5L3aJND3--

