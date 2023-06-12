Return-Path: <netdev+bounces-10258-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E04E572D444
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 00:16:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 02FCD281121
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 22:16:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F95423437;
	Mon, 12 Jun 2023 22:16:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 371B918AE0
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 22:16:43 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F25110DF
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 15:16:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686608201;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kTZtyuUlXixxMxO/No1lfJ4jfgIlGKSKtZpjkWwouX4=;
	b=Rie3WbJeK2EvaE5U7nJC66YwYOECajeqXr4POy2O8sCm8cUXj3di0Td+W6moASgqfZf0WV
	UD+AEAjafv4hn41ASydC8v6Or/v0Ya7TzUVeFj3ytUA0+XR6cCK72LK63Fq9REnPDXYJjL
	MkNjShIZArXlKok2Utz8jRpoWUAi9MM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-392-3V0JEuoFMz6vzHPYdllnoA-1; Mon, 12 Jun 2023 18:16:34 -0400
X-MC-Unique: 3V0JEuoFMz6vzHPYdllnoA-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-3f5df65f9f4so21360485e9.2
        for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 15:16:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686608193; x=1689200193;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kTZtyuUlXixxMxO/No1lfJ4jfgIlGKSKtZpjkWwouX4=;
        b=gd36zvTUdNF0tjQwATVTvzVpMltUxuIUuzwn0z5TzXZ617A7GamFVXTwtY5UisLTDd
         Twftv6Jhvtx+XO7/JaL/ya9u9myC/iM0PcG2XAdg57eDX0uJIAG5nvpGPcKW3dAqo1lO
         8JYLZi2BhXp6cnFPEihR+NMti2QTchmR6SDr66OiEG/Cga5IHY03V8DMVAm5AmAoBOW0
         wDVTgtzA8fFgGpVMAfl5hgIVw72DAohAxATixdkZVDm00g9SaPlu1zuw81usdqb75EUh
         sNxvXHLSm2YYEECbjr49j9diec6LvQBz38wse+StR2FYxCb7R3H2+f+/tieRFJkrrEyP
         sTsw==
X-Gm-Message-State: AC+VfDx/OgJIgQfngXzS36Cir4G8K+WYRm9bfJnWOzvsCH3pFILQsyll
	okTLcy+fbAeocYQK78Lhh4540Q2rhxjhwuIDBNWBDbqbWH1qliBb/leCE7Ne/OtxwElsLFKEc6+
	dHUTe4p+UlqhcBhJP
X-Received: by 2002:a5d:4c88:0:b0:30f:bb0c:a2c0 with SMTP id z8-20020a5d4c88000000b0030fbb0ca2c0mr3763736wrs.5.1686608193385;
        Mon, 12 Jun 2023 15:16:33 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6vhzxAZAyN5mFmZdbyQbsrTmXIEJTazMrYY97aHI+UWILU1SiUfJAeHgaq8ps1Vzz+ZOsSqw==
X-Received: by 2002:a5d:4c88:0:b0:30f:bb0c:a2c0 with SMTP id z8-20020a5d4c88000000b0030fbb0ca2c0mr3763713wrs.5.1686608193039;
        Mon, 12 Jun 2023 15:16:33 -0700 (PDT)
Received: from localhost (net-130-25-106-149.cust.vodafonedsl.it. [130.25.106.149])
        by smtp.gmail.com with ESMTPSA id e4-20020adfdbc4000000b0030ada01ca78sm13512230wrj.10.2023.06.12.15.16.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jun 2023 15:16:32 -0700 (PDT)
Date: Tue, 13 Jun 2023 00:16:30 +0200
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: Daniel Golle <daniel@makrotopia.org>, netdev@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Mark Lee <Mark-MC.Lee@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>, John Crispin <john@phrozen.org>,
	Felix Fietkau <nbd@nbd.name>, Conor Dooley <conor+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Rob Herring <robh+dt@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sam Shih <Sam.Shih@mediatek.com>
Subject: Re: [PATCH net-next 5/8] net: ethernet: mtk_eth_soc: add
 MTK_NETSYS_V3 capability bit
Message-ID: <ZIeZPqFJqdf928f4@lore-desk>
References: <ZIUXf9APDFCNaUG1@makrotopia.org>
 <ZIb/WKKNlzjTIu2h@shell.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="MZEWyw36ZZKq14wi"
Content-Disposition: inline
In-Reply-To: <ZIb/WKKNlzjTIu2h@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--MZEWyw36ZZKq14wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Sun, Jun 11, 2023 at 01:38:23AM +0100, Daniel Golle wrote:
> > @@ -1333,8 +1354,13 @@ static int mtk_tx_map(struct sk_buff *skb, struc=
t net_device *dev,
> >  	mtk_tx_set_dma_desc(dev, itxd, &txd_info);
> > =20
> >  	itx_buf->flags |=3D MTK_TX_FLAGS_SINGLE0;
> > -	itx_buf->flags |=3D (!mac->id) ? MTK_TX_FLAGS_FPORT0 :
> > -			  MTK_TX_FLAGS_FPORT1;
> > +	if (mac->id =3D=3D MTK_GMAC1_ID)
> > +		itx_buf->flags |=3D MTK_TX_FLAGS_FPORT0;
> > +	else if (mac->id =3D=3D MTK_GMAC2_ID)
> > +		itx_buf->flags |=3D MTK_TX_FLAGS_FPORT1;
> > +	else
> > +		itx_buf->flags |=3D MTK_TX_FLAGS_FPORT2;
>=20
> There appears to be two places that this code structure appears, and
> this is in the path for packet transmission. I wonder if it would be
> more efficient to instead do:
>=20
> 	itx_buf->flags |=3D MTK_TX_FLAGS_SINGLE0 | mac->tx_flags;
>=20
> with mac->tx_flags appropriately initialised?
>=20
> > @@ -2170,7 +2214,9 @@ static int mtk_poll_tx_qdma(struct mtk_eth *eth, =
int budget,
> >  		tx_buf =3D mtk_desc_to_tx_buf(ring, desc,
> >  					    eth->soc->txrx.txd_size);
> >  		if (tx_buf->flags & MTK_TX_FLAGS_FPORT1)
> > -			mac =3D 1;
> > +			mac =3D MTK_GMAC2_ID;
> > +		else if (tx_buf->flags & MTK_TX_FLAGS_FPORT2)
> > +			mac =3D MTK_GMAC3_ID;
>=20
> This has me wondering whether the flags are used for hardware or just
> for the driver's purposes. If it's the latter, can we instead store the
> MAC index in tx_buf, rather than having to decode a bitfield?
>=20
> I suspect these are just for the driver given that the addition of
> MTK_TX_FLAGS_FPORT2 changes all subsequent bit numbers in this struct
> member.

ack, I agree. I will rework it.

Regards,
Lorenzo

>=20
> > =20
> >  		if (!tx_buf->data)
> >  			break;
> > @@ -3783,7 +3829,26 @@ static int mtk_hw_init(struct mtk_eth *eth, bool=
 reset)
> >  	mtk_w32(eth, eth->soc->txrx.rx_irq_done_mask, reg_map->qdma.int_grp +=
 4);
> >  	mtk_w32(eth, 0x21021000, MTK_FE_INT_GRP);
> > =20
> > -	if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2)) {
> > +	if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V3)) {
> > +		/* PSE should not drop port1, port8 and port9 packets */
> > +		mtk_w32(eth, 0x00000302, PSE_DROP_CFG);
> > +
> > +		/* GDM and CDM Threshold */
> > +		mtk_w32(eth, 0x00000707, MTK_CDMW0_THRES);
> > +		mtk_w32(eth, 0x00000077, MTK_CDMW1_THRES);
> > +
> > +		/* Disable GDM1 RX CRC stripping */
> > +		val =3D mtk_r32(eth, MTK_GDMA_FWD_CFG(0));
> > +		val &=3D ~MTK_GDMA_STRP_CRC;
> > +		mtk_w32(eth, val, MTK_GDMA_FWD_CFG(0));
>=20
> mtk_m32() ?
>=20
> Thanks!
>=20
> --=20
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!
>=20

--MZEWyw36ZZKq14wi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCZIeZPgAKCRA6cBh0uS2t
rOWZAP93LCOL1i0nkHkj6wrpRzOraRpEoqEK3GPo84WYL1nFzQEAs2hJgVY3XzfF
KF3PwyoYttShSk1kgjn4c0xzXmKqKgU=
=Fpo3
-----END PGP SIGNATURE-----

--MZEWyw36ZZKq14wi--


