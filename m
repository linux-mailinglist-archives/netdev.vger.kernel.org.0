Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EBEE5ED8EB
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 11:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233517AbiI1J1r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 05:27:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233129AbiI1J1q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 05:27:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38789B40D3
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 02:27:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E954AB8201B
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 09:27:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4742AC433D7;
        Wed, 28 Sep 2022 09:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664357262;
        bh=ccg1pM+XNUwx5lEW8JBcafEXG88UBm4Y4hgUSqf14/Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qyQl9ymlGmwTt72nMnbXlUz9g0IBP4sl+zVhy8eBGXOJGM6Fi7Yb0usTHemOKlSwK
         hiegBLuyX+3p+M4OIEAdJhCakkfpyfUVHhST0tatrNvhr9DsJiYjjSJC5FfjPH2Nro
         Vs8aqEnrE0xAeqApBUj0E3GU1DgAsWtrzJbe9kLsyjScb4laMsyNjDc2zrH/CTQy+3
         UKUjLhZxXyn4j2b/h25M7x59E83e9TiUj5fsokKldzN3zQ9b84Gryx+7y4Uic+Qvqm
         FX5wkqbZxY/QFA09QvYwYVgUI5Cc9Mc1tSa3cQ4SSisjE4MRVRwJGNuTJhTXF8kUuV
         +3SwfyoEIrNaQ==
Date:   Wed, 28 Sep 2022 11:27:39 +0200
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
        Chen Minqiang <ptpt52@gmail.com>,
        Thomas =?iso-8859-1?Q?H=FChn?= <thomas.huehn@hs-nordhausen.de>
Subject: Re: [PATCH] net: ethernet: mtk_eth_soc: fix state in
 __mtk_foe_entry_clear
Message-ID: <YzQTi1CfU79u8RYT@lore-desk>
References: <YzOie0dkiQ43EPnu@makrotopia.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="0XpyYKBevE2ylH7z"
Content-Disposition: inline
In-Reply-To: <YzOie0dkiQ43EPnu@makrotopia.org>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--0XpyYKBevE2ylH7z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Setting ib1 state to MTK_FOE_STATE_UNBIND in __mtk_foe_entry_clear
> routine as done by commit 0e80707d94e4c8 ("net: ethernet: mtk_eth_soc:
> fix typo in __mtk_foe_entry_clear") breaks flow offloading, at least
> on older MTK_NETSYS_V1 SoCs; OpenWrt users have confirmed the bug on
> MT7622 and MT7621 systems.
> Felix Fietkau suggested to use MTK_FOE_STATE_INVALID instead which
> works well on both, MTK_NETSYS_V1 and MTK_NETSYS_V2.
>=20
> Tested on MT7622 (Linksys E8450) and MT7986 (BananaPi BPI-R3).
>=20
> Suggested-by: Felix Fietkau <nbd@nbd.name>
> Fixes: 0e80707d94e4c8 ("net: ethernet: mtk_eth_soc: fix typo in __mtk_foe=
_entry_clear")
> Fixes: 33fc42de33278 ("net: ethernet: mtk_eth_soc: support creating mac a=
ddress based offload entries")
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>

Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>

> ---
>  drivers/net/ethernet/mediatek/mtk_ppe.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/mediatek/mtk_ppe.c b/drivers/net/ethern=
et/mediatek/mtk_ppe.c
> index 887f430734f747..ae00e572390d7b 100644
> --- a/drivers/net/ethernet/mediatek/mtk_ppe.c
> +++ b/drivers/net/ethernet/mediatek/mtk_ppe.c
> @@ -442,7 +442,7 @@ __mtk_foe_entry_clear(struct mtk_ppe *ppe, struct mtk=
_flow_entry *entry)
>  		struct mtk_foe_entry *hwe =3D mtk_foe_get_entry(ppe, entry->hash);
> =20
>  		hwe->ib1 &=3D ~MTK_FOE_IB1_STATE;
> -		hwe->ib1 |=3D FIELD_PREP(MTK_FOE_IB1_STATE, MTK_FOE_STATE_UNBIND);
> +		hwe->ib1 |=3D FIELD_PREP(MTK_FOE_IB1_STATE, MTK_FOE_STATE_INVALID);
>  		dma_wmb();
>  	}
>  	entry->hash =3D 0xffff;
> --=20
> 2.37.3
>=20

--0XpyYKBevE2ylH7z
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYzQTiwAKCRA6cBh0uS2t
rMV8AQDhjJi0FeKHuFhjhaYu7HLNTxJ6uWF1xx0U/i79Ek61TAD+PuB6uf7AItB8
NoV+SHYJreeLaFclZMKTPROB9NBn7gQ=
=W1l5
-----END PGP SIGNATURE-----

--0XpyYKBevE2ylH7z--
