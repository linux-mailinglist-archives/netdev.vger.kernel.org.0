Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BADE5E962D
	for <lists+netdev@lfdr.de>; Sun, 25 Sep 2022 23:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232425AbiIYV1T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Sep 2022 17:27:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230219AbiIYV1S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Sep 2022 17:27:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48ED52A248
        for <netdev@vger.kernel.org>; Sun, 25 Sep 2022 14:27:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D94C360DCB
        for <netdev@vger.kernel.org>; Sun, 25 Sep 2022 21:27:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6B37C433C1;
        Sun, 25 Sep 2022 21:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664141236;
        bh=Rbz1zGH0GqMSn96wkkP2rNJ9kqxZfKKDKoPQgNJPquc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WHu1hGyAt7vDOqEP7H0odVmG15cEuzyosyK+3+1JWDrCo9d71+XN6GZgGO0L9GAWZ
         ep1t45BQas8KFYfHT0l/Jl/bzeaiJqftqykdwZCSbvj3dhmbvikiZ6Qq/dL2QWWLY2
         XWA7ibpvl4O2rRbHjbL4G5L3G/kcbMkHKxRSlLXyFsb7yN6MjPRZ3xj8DHQlvskJmz
         xKnplmwkpbrgz5LBH6Q6h3FWqlFoUT8BWFtncTK3J0DN+8552ppLvx2iwq6i9MlzRq
         8UF3Y7/8X4pSUfNtvX3IT1WGys4qz5ZQ2qnTcwdtuVrCQtKAuSnuX/57QKZOgeOcDK
         y5LqFMfaU2eew==
Date:   Sun, 25 Sep 2022 23:27:12 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     linux-mediatek@lists.infradead.org, netdev@vger.kernel.org,
        Sujuan Chen <sujuan.chen@mediatek.com>,
        Bo Jiao <Bo.Jiao@mediatek.com>, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Chen Minqiang <ptpt52@gmail.com>
Subject: Re: [PATCH 2/2] net: ethernet: mtk_eth_soc: fix usage of
 foe_entry_size
Message-ID: <YzDHsJ7ilCnEQgUo@lore-desk>
References: <YzBqPIgQR2gLrPoK@makrotopia.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="NrpRlPxFAxiArcc9"
Content-Disposition: inline
In-Reply-To: <YzBqPIgQR2gLrPoK@makrotopia.org>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--NrpRlPxFAxiArcc9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> As sizeof(hwe->data) can now longer be used as the actual size depends
> on foe_entry_size, in commit 9d8cb4c096ab02
> ("net: ethernet: mtk_eth_soc: add foe_entry_size to mtk_eth_soc") the
> use of sizeof(hwe->data) is hence replaced.
>=20
> However, replacing it with ppe->eth->soc->foe_entry_size is wrong as
> foe_entry_size represents the size of the whole descriptor and not just
> the 'data' field.
>=20
> Fix this by subtracing the size of the only other field in the struct
> 'ib1', so we actually end up with the correct size to be copied to the
> data field.
>=20
> Reported-by: Chen Minqiang <ptpt52@gmail.com>
> Fixes: 9d8cb4c096ab02 ("net: ethernet: mtk_eth_soc: add foe_entry_size to=
 mtk_eth_soc")
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>

Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>

> ---
>  drivers/net/ethernet/mediatek/mtk_ppe.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/mediatek/mtk_ppe.c b/drivers/net/ethern=
et/mediatek/mtk_ppe.c
> index 4ea2b342f252ac..887f430734f747 100644
> --- a/drivers/net/ethernet/mediatek/mtk_ppe.c
> +++ b/drivers/net/ethernet/mediatek/mtk_ppe.c
> @@ -547,7 +547,7 @@ __mtk_foe_entry_commit(struct mtk_ppe *ppe, struct mt=
k_foe_entry *entry,
>  	}
> =20
>  	hwe =3D mtk_foe_get_entry(ppe, hash);
> -	memcpy(&hwe->data, &entry->data, eth->soc->foe_entry_size);
> +	memcpy(&hwe->data, &entry->data, eth->soc->foe_entry_size - sizeof(hwe-=
>ib1));
>  	wmb();
>  	hwe->ib1 =3D entry->ib1;
> =20
> --=20
> 2.37.3
>=20

--NrpRlPxFAxiArcc9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYzDHsAAKCRA6cBh0uS2t
rMS1AP0YPgNBO9K0LJnKjNS664lozBLlv/z9B8RVZSIDRZPMEgEAyUK/li93ge07
2xcOy89rkcP+n5x9svtmj5SZ+QstmQk=
=fvir
-----END PGP SIGNATURE-----

--NrpRlPxFAxiArcc9--
