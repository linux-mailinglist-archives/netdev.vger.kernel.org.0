Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C491166617B
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 18:12:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbjAKRMw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 12:12:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230523AbjAKRMo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 12:12:44 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5C1FB87
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 09:11:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673457117;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=c/FbRljS7eOWlbCm02wKiOAVIdNdNQrNQ/Lch6qgdWk=;
        b=cV8G1twokz4NXAp0WZ4uF3v4J4mPJKmELeFZWyFcj8wSrEZv11ksDu7xhxARbjZLoe2A7P
        v7Woix/18L4ScgXTY7Vg5b6v58iD2c9NwSMt8T15RjX90eLzXrrKqXc0+R5sj8HbNTJs4X
        McfQ1TfwbVqCVSE8WkYAiIlbOjIyPDY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-156-wJmB8v6IMhy-ohj7gZvbRg-1; Wed, 11 Jan 2023 12:11:56 -0500
X-MC-Unique: wJmB8v6IMhy-ohj7gZvbRg-1
Received: by mail-wr1-f72.google.com with SMTP id u15-20020adfa18f000000b002b129dc55bfso2918510wru.11
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 09:11:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c/FbRljS7eOWlbCm02wKiOAVIdNdNQrNQ/Lch6qgdWk=;
        b=fuOVh6BpztMvrguklK7Ak9K7N5J/Hfx2bjQ26YmfeRQtS8jBkorLkW6ebZeX6GxFJM
         E2qHxdZLUn3J0gicRl0A3liVHCZ6cnJjoyF4QrmQhoV11xFph95Opwdibk+inNEcn+mq
         3+t8Phrx2cR6erbk7Cu7/0MCkBqJ1qG10p6BrytbCzf1ZXj6AiGBCInuez113DeGawjS
         mZaTPWpPkyfE9ImZUdEb5rwduHAE+NguOERh0zfACsoo57p9IiTtoEaAPjcWroZdXqbs
         dGZ1C9zSX5b1vnx8bdkRY/JX5+QClPXttUk/1IZWNd4raxxaeiDRAH9UF7IUKurIVu0c
         doXg==
X-Gm-Message-State: AFqh2kpyQGIZwc/JMndGA7KKGHcndOmyziQ5G82ssCNn6TARyv7rU1Jo
        PVQuwT6xi7o3rJSOoF3vcdEx7ZX6L7a4xn0g+LOm4skrba98EsxpXwKIzK08cjPkIU1pfz3g1pm
        /yrbi9RwkaM0xNSQp
X-Received: by 2002:a05:600c:54c2:b0:3d3:3c74:dbd0 with SMTP id iw2-20020a05600c54c200b003d33c74dbd0mr52645929wmb.13.1673457114766;
        Wed, 11 Jan 2023 09:11:54 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtLvwO8bAdTEPrzKVk6atdhoNhQzDJ/e83vPAk1CYuomjnKDoawdhTbkDGYjIl/EZd5QuGxiA==
X-Received: by 2002:a05:600c:54c2:b0:3d3:3c74:dbd0 with SMTP id iw2-20020a05600c54c200b003d33c74dbd0mr52645919wmb.13.1673457114540;
        Wed, 11 Jan 2023 09:11:54 -0800 (PST)
Received: from localhost (net-188-216-77-84.cust.vodafonedsl.it. [188.216.77.84])
        by smtp.gmail.com with ESMTPSA id p15-20020a1c544f000000b003b4fe03c881sm23089729wmi.48.2023.01.11.09.11.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 09:11:53 -0800 (PST)
Date:   Wed, 11 Jan 2023 18:11:51 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        sujuan.chen@mediatek.com, daniel@makrotopia.org, leon@kernel.org
Subject: Re: [PATCH v4 net-next 3/5] net: ethernet: mtk_eth_soc: align reset
 procedure to vendor sdk
Message-ID: <Y77t18YANM9zsvFZ@lore-desk>
References: <cover.1673372414.git.lorenzo@kernel.org>
 <99dc1741c3fc08e086465ad2fbe607eaab7ae0b9.1673372414.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ltUp30pC9dBbost0"
Content-Disposition: inline
In-Reply-To: <99dc1741c3fc08e086465ad2fbe607eaab7ae0b9.1673372414.git.lorenzo@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ltUp30pC9dBbost0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[...]

> -
> -	/* restart underlying hardware such as power, clock, pin mux
> -	 * and the connected phy
> -	 */
> -	mtk_hw_deinit(eth);

I missed a usleep_range here. Please drop this version, I will post v5 soon.

Regards,
Lorenzo

> =20
>  	if (eth->dev->pins)
>  		pinctrl_select_state(eth->dev->pins->p,
> @@ -3801,15 +3841,19 @@ static void mtk_pending_work(struct work_struct *=
work)
>  	for (i =3D 0; i < MTK_MAC_COUNT; i++) {
>  		if (!test_bit(i, &restart))
>  			continue;
> -		err =3D mtk_open(eth->netdev[i]);
> -		if (err) {
> +
> +		if (mtk_open(eth->netdev[i])) {
>  			netif_alert(eth, ifup, eth->netdev[i],
> -			      "Driver up/down cycle failed, closing device.\n");
> +				    "Driver up/down cycle failed\n");
>  			dev_close(eth->netdev[i]);
>  		}
>  	}
> =20
> -	dev_dbg(eth->dev, "[%s][%d] reset done\n", __func__, __LINE__);
> +	/* enabe FE P3 and P4 */
> +	val =3D mtk_r32(eth, MTK_FE_GLO_CFG) & ~MTK_FE_LINK_DOWN_P3;
> +	if (MTK_HAS_CAPS(eth->soc->caps, MTK_RSTCTRL_PPE1))
> +		val &=3D ~MTK_FE_LINK_DOWN_P4;
> +	mtk_w32(eth, val, MTK_FE_GLO_CFG);
> =20
>  	clear_bit(MTK_RESETTING, &eth->state);
> =20
> diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/et=
hernet/mediatek/mtk_eth_soc.h
> index 18a50529ce7b..a8066b3ee3ed 100644
> --- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
> +++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
> @@ -77,12 +77,24 @@
>  #define	MTK_HW_LRO_REPLACE_DELTA	1000
>  #define	MTK_HW_LRO_SDL_REMAIN_ROOM	1522
> =20
> +/* Frame Engine Global Configuration */
> +#define MTK_FE_GLO_CFG		0x00
> +#define MTK_FE_LINK_DOWN_P3	BIT(11)
> +#define MTK_FE_LINK_DOWN_P4	BIT(12)
> +
>  /* Frame Engine Global Reset Register */
>  #define MTK_RST_GL		0x04
>  #define RST_GL_PSE		BIT(0)
> =20
>  /* Frame Engine Interrupt Status Register */
>  #define MTK_INT_STATUS2		0x08
> +#define MTK_FE_INT_ENABLE	0x0c
> +#define MTK_FE_INT_FQ_EMPTY	BIT(8)
> +#define MTK_FE_INT_TSO_FAIL	BIT(12)
> +#define MTK_FE_INT_TSO_ILLEGAL	BIT(13)
> +#define MTK_FE_INT_TSO_ALIGN	BIT(14)
> +#define MTK_FE_INT_RFIFO_OV	BIT(18)
> +#define MTK_FE_INT_RFIFO_UF	BIT(19)
>  #define MTK_GDM1_AF		BIT(28)
>  #define MTK_GDM2_AF		BIT(29)
> =20
> diff --git a/drivers/net/ethernet/mediatek/mtk_ppe.c b/drivers/net/ethern=
et/mediatek/mtk_ppe.c
> index 269208a841c7..451a87b1bc20 100644
> --- a/drivers/net/ethernet/mediatek/mtk_ppe.c
> +++ b/drivers/net/ethernet/mediatek/mtk_ppe.c
> @@ -730,6 +730,33 @@ int mtk_foe_entry_idle_time(struct mtk_ppe *ppe, str=
uct mtk_flow_entry *entry)
>  	return __mtk_foe_entry_idle_time(ppe, entry->data.ib1);
>  }
> =20
> +int mtk_ppe_prepare_reset(struct mtk_ppe *ppe)
> +{
> +	if (!ppe)
> +		return -EINVAL;
> +
> +	/* disable KA */
> +	ppe_clear(ppe, MTK_PPE_TB_CFG, MTK_PPE_TB_CFG_KEEPALIVE);
> +	ppe_clear(ppe, MTK_PPE_BIND_LMT1, MTK_PPE_NTU_KEEPALIVE);
> +	ppe_w32(ppe, MTK_PPE_KEEPALIVE, 0);
> +	usleep_range(10000, 11000);
> +
> +	/* set KA timer to maximum */
> +	ppe_set(ppe, MTK_PPE_BIND_LMT1, MTK_PPE_NTU_KEEPALIVE);
> +	ppe_w32(ppe, MTK_PPE_KEEPALIVE, 0xffffffff);
> +
> +	/* set KA tick select */
> +	ppe_set(ppe, MTK_PPE_TB_CFG, MTK_PPE_TB_TICK_SEL);
> +	ppe_set(ppe, MTK_PPE_TB_CFG, MTK_PPE_TB_CFG_KEEPALIVE);
> +	usleep_range(10000, 11000);
> +
> +	/* disable scan mode */
> +	ppe_clear(ppe, MTK_PPE_TB_CFG, MTK_PPE_TB_CFG_SCAN_MODE);
> +	usleep_range(10000, 11000);
> +
> +	return mtk_ppe_wait_busy(ppe);
> +}
> +
>  struct mtk_ppe *mtk_ppe_init(struct mtk_eth *eth, void __iomem *base,
>  			     int version, int index)
>  {
> diff --git a/drivers/net/ethernet/mediatek/mtk_ppe.h b/drivers/net/ethern=
et/mediatek/mtk_ppe.h
> index ea64fac1d425..16b02e1d4649 100644
> --- a/drivers/net/ethernet/mediatek/mtk_ppe.h
> +++ b/drivers/net/ethernet/mediatek/mtk_ppe.h
> @@ -309,6 +309,7 @@ struct mtk_ppe *mtk_ppe_init(struct mtk_eth *eth, voi=
d __iomem *base,
>  void mtk_ppe_deinit(struct mtk_eth *eth);
>  void mtk_ppe_start(struct mtk_ppe *ppe);
>  int mtk_ppe_stop(struct mtk_ppe *ppe);
> +int mtk_ppe_prepare_reset(struct mtk_ppe *ppe);
> =20
>  void __mtk_ppe_check_skb(struct mtk_ppe *ppe, struct sk_buff *skb, u16 h=
ash);
> =20
> diff --git a/drivers/net/ethernet/mediatek/mtk_ppe_regs.h b/drivers/net/e=
thernet/mediatek/mtk_ppe_regs.h
> index 59596d823d8b..0fdb983b0a88 100644
> --- a/drivers/net/ethernet/mediatek/mtk_ppe_regs.h
> +++ b/drivers/net/ethernet/mediatek/mtk_ppe_regs.h
> @@ -58,6 +58,12 @@
>  #define MTK_PPE_TB_CFG_SCAN_MODE		GENMASK(17, 16)
>  #define MTK_PPE_TB_CFG_HASH_DEBUG		GENMASK(19, 18)
>  #define MTK_PPE_TB_CFG_INFO_SEL			BIT(20)
> +#define MTK_PPE_TB_TICK_SEL			BIT(24)
> +
> +#define MTK_PPE_BIND_LMT1			0x230
> +#define MTK_PPE_NTU_KEEPALIVE			GENMASK(23, 16)
> +
> +#define MTK_PPE_KEEPALIVE			0x234
> =20
>  enum {
>  	MTK_PPE_SCAN_MODE_DISABLED,
> --=20
> 2.39.0
>=20

--ltUp30pC9dBbost0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCY77t1wAKCRA6cBh0uS2t
rPZMAQCxDJwrkOrRMxgK/hPs5OTz5glMYd96XSdiLjK76ps07AD9E//f8+CsSU9R
Cy86hfhSrvHbbnyehYag1evqDapL3w0=
=1qqc
-----END PGP SIGNATURE-----

--ltUp30pC9dBbost0--

