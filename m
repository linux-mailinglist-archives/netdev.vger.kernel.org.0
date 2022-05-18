Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACF2352B4FC
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 10:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233276AbiERIcH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 04:32:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233266AbiERIcF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 04:32:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BABD4E3AF;
        Wed, 18 May 2022 01:32:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C23DE615A8;
        Wed, 18 May 2022 08:32:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9764CC385A5;
        Wed, 18 May 2022 08:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652862724;
        bh=i89CmjQPbwZ9I9KW+4ilTsAY0H2ZbdEroLHap47HDXU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=C5T2kghxgwBMfELFaEmQrxZIBvIRmHgwzjoA3M+9eLJBlZULCe4//RScbNKfzKO6Y
         rQvn1wmwsjRmwSl7rhcqv6APE0sD9Ggac+rI7cekD6H/kURWc67LuYs/qzdiIMdLV2
         W0uh2NzB+sxTgmHegrEtJq2YOLX5W/uEre6Qjw2gtoFKC4bEwjZACQ2MsVNJo5xZkT
         eYCO/sGPyUpT72Qq/pvWSgtgIXjxIZ5s3+7KPY+ojT1tWRWnx8GTGRFZ+L2rmnPifB
         4FYFNhIsP7P62AFZm94aKgo7nSH3xJUieCYSUOFgqgbbIJJaVAeLGPt/CCJ/wfWjPd
         sKtGDpEPAGC7Q==
Date:   Wed, 18 May 2022 10:32:00 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        Sam.Shih@mediatek.com, linux-mediatek@lists.infradead.org,
        devicetree@vger.kernel.org, robh@kernel.org,
        lorenzo.bianconi@redhat.com
Subject: Re: [PATCH v2 net-next 05/15] net: ethernet: mtk_eth_soc: rely on
 txd_size in mtk_tx_alloc/mtk_tx_clean
Message-ID: <YoSvAPd6QaEZi0vh@lore-desk>
References: <cover.1652716741.git.lorenzo@kernel.org>
 <c5228daa3d277cd71a134a1062525bc19b34fa2f.1652716741.git.lorenzo@kernel.org>
 <20220517183522.4a585885@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="V952YIebYHLveMod"
Content-Disposition: inline
In-Reply-To: <20220517183522.4a585885@kernel.org>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--V952YIebYHLveMod
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Mon, 16 May 2022 18:06:32 +0200 Lorenzo Bianconi wrote:
> >  static int mtk_tx_alloc(struct mtk_eth *eth)
> >  {
> > +	const struct mtk_soc_data *soc =3D eth->soc;
> >  	struct mtk_tx_ring *ring =3D &eth->tx_ring;
> > -	int i, sz =3D sizeof(*ring->dma);
>=20
> The change would be smaller if you left sz in place.=20
> I guess you have a reason not to?

ack, I will do in v3.

>=20
> > +	struct mtk_tx_dma *txd;
> > +	int i;
> > =20
> >  	ring->buf =3D kcalloc(MTK_DMA_SIZE, sizeof(*ring->buf),
> >  			       GFP_KERNEL);
> >  	if (!ring->buf)
> >  		goto no_tx_mem;
> > =20
> > -	ring->dma =3D dma_alloc_coherent(eth->dma_dev, MTK_DMA_SIZE * sz,
> > +	ring->dma =3D dma_alloc_coherent(eth->dma_dev,
> > +				       MTK_DMA_SIZE * soc->txrx.txd_size,
> >  				       &ring->phys, GFP_ATOMIC);
>=20
> Another GFP nugget.

ack I will fix it in v3.

Regards,
Lorenzo

--V952YIebYHLveMod
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYoSvAAAKCRA6cBh0uS2t
rPEcAQD4hpMut1iYt3xxUlNN+ANkFcAie0jZ9H74iYcNnZFTBQEAjNI2Lf419uvr
vkbOZqF7Pt+jc7JdoTgftIcE/levnAI=
=oaCo
-----END PGP SIGNATURE-----

--V952YIebYHLveMod--
