Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09BBD52B4ED
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 10:38:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233263AbiERIbb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 04:31:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233257AbiERIa5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 04:30:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B82A9CF1;
        Wed, 18 May 2022 01:30:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6A70BB81EE6;
        Wed, 18 May 2022 08:30:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE2B5C385A5;
        Wed, 18 May 2022 08:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652862649;
        bh=mJJb/4OQ3K+BXo8Cd+L/PAtvSVNE3XIPsK9mQ+9dwiE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=X+zdutIv5p2k+3B4+X900Urieq9PE2vgPA5T07eaOphbN3Jm8Wt1SsLzTLuxexhBK
         Bg2E2RQyKJHSpPZ+CVmGq+ReG9+2zvTKmFYn/3N7cOXAUtVYJT+awRHQ3FLXKhklsp
         SDR2NugJg2Xy8XgacCJs8DShSm1sfz/Fk6AmSEAHwPGvZPMHmYW+xhj23z8+tVDW47
         4VWlnI9yT4hnE+niavzZn4whQjvWVrsIowl0uzBRXaQXGAYsqr4XzosnKe7cVyONov
         RFj8LKyWsqeG5oDeScqstSRsGUTC9uf/GBfGybaOYxphBUUB7HANbALWVHrJgwznqS
         VHDv/+hxLN+iQ==
Date:   Wed, 18 May 2022 10:30:45 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        Sam.Shih@mediatek.com, linux-mediatek@lists.infradead.org,
        devicetree@vger.kernel.org, robh@kernel.org,
        lorenzo.bianconi@redhat.com
Subject: Re: [PATCH v2 net-next 10/15] net: ethernet: mtk_eth_soc: rely on
 rxd_size field in mtk_rx_alloc/mtk_rx_clean
Message-ID: <YoSutfDP5CXzgFNQ@lore-desk>
References: <cover.1652716741.git.lorenzo@kernel.org>
 <eca56ab1af7f4bbedc4a6d0990a10ff58911d842.1652716741.git.lorenzo@kernel.org>
 <20220517183935.6863ddc7@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="nOj9tn/EqN8+0tSv"
Content-Disposition: inline
In-Reply-To: <20220517183935.6863ddc7@kernel.org>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--nOj9tn/EqN8+0tSv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Mon, 16 May 2022 18:06:37 +0200 Lorenzo Bianconi wrote:
> > +
> > +		rxd =3D (void *)ring->dma + i * eth->soc->txrx.rxd_size;
> > +		rxd->rxd1 =3D (unsigned int)dma_addr;
> > =20
> >  		if (MTK_HAS_CAPS(eth->soc->caps, MTK_SOC_MT7628))
> > -			ring->dma[i].rxd2 =3D RX_DMA_LSO;
> > +			rxd->rxd2 =3D RX_DMA_LSO;
> >  		else
> > -			ring->dma[i].rxd2 =3D RX_DMA_PLEN0(ring->buf_size);
> > +			rxd->rxd2 =3D RX_DMA_PLEN0(ring->buf_size);
> > +
> > +		rxd->rxd3 =3D 0;
> > +		rxd->rxd4 =3D 0;
>=20
> The clearing of rxd3/rxd4 should probably have been mentioned in the
> commit message. It does not seem related to descriptor size.

ack, I will do it in v3.

Regards,
Lorenzo

--nOj9tn/EqN8+0tSv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYoSutQAKCRA6cBh0uS2t
rDkrAPsFgjPlPYku7AlPv0qwt1GuK/wxa9vPkdKHgYEApUD5aAEA8fu7ZkWQFlby
2oNBn54QPPhGqhBRykcs6nvv39DhpAQ=
=EFN3
-----END PGP SIGNATURE-----

--nOj9tn/EqN8+0tSv--
