Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A96A46313BF
	for <lists+netdev@lfdr.de>; Sun, 20 Nov 2022 12:50:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbiKTLuE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Nov 2022 06:50:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbiKTLuD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Nov 2022 06:50:03 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F48328E2A
        for <netdev@vger.kernel.org>; Sun, 20 Nov 2022 03:49:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668944947;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eFFRtDG3SnY31rS3/TY9saZ3cpDv+kx8E+R9eiFK10I=;
        b=QcMrffzZSfwBoEAtK1sberGc+k2aeBzqCBqQuldXlK7gxFKqCUvrmRdXsPX4vHXgUlNRKz
        jWNWCZtnrZ3TYrFgxbWeXsX5fw59bE/1YaJf5PKfmxtic+aIOKNTdgjC50fYwsI+E9fD0z
        oYIZkbAni2UrCw/x5kfcfVqaOFL8uLY=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-6-nKDNiwXlNDCQ1S80kY-o2Q-1; Sun, 20 Nov 2022 06:49:05 -0500
X-MC-Unique: nKDNiwXlNDCQ1S80kY-o2Q-1
Received: by mail-wr1-f71.google.com with SMTP id j20-20020adfb314000000b002366d9f67aaso2380132wrd.3
        for <netdev@vger.kernel.org>; Sun, 20 Nov 2022 03:49:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eFFRtDG3SnY31rS3/TY9saZ3cpDv+kx8E+R9eiFK10I=;
        b=Zdt4gKWF/rIO3KodxzWSBNzFITliD0ZmjSiNAOPK2cg0dfJWia8X5fjdGfrLM7V4NX
         LuL+bUA5wqEyH8RmkMMsh5n7pyeTuINz/hdQHWNlEsfWKUlx9mn0J3oVOqb0rw5KrR1I
         l3nCt6YxKLXUcv1m3BXGKQbLh/b+nDImYArlLZcI1xE9c7qlFqVMBqQYQqX6AxuAvPSr
         AV29/VBu/AsTxovMzLdXCcO+gdhrnePnzKvKU66QqLifFtqLOe4Ed6/0Fj3S1VcEZtip
         4pw4lU/OD7XOVubWk368OdaS6xyT5IZgZRbPLFNttJ+s3Ij5TOZ4j358hRl3Fs9Cjh9I
         KE5A==
X-Gm-Message-State: ANoB5pmc5inxKrweD8faho1IZoxcdfNGauc1dxjDnZNvm3PM46lD2Hca
        EmM4xIVkLuSkWGED9P/FYLEa4mTuuxgzC6AHjcOyp2qK9uTqKN1zCV855X/JJ6YAhHfeNWMi+Uj
        mVl7Jp6Iv9nYWbnwn
X-Received: by 2002:adf:f74d:0:b0:236:4e3c:7720 with SMTP id z13-20020adff74d000000b002364e3c7720mr8545075wrp.674.1668944944671;
        Sun, 20 Nov 2022 03:49:04 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7udSW6/pfqawh/yYUkdpdhzbG5vE8EEGEBnisT1ahzb5hGEDLmfhdqECpSPgvVpZoIghYixw==
X-Received: by 2002:adf:f74d:0:b0:236:4e3c:7720 with SMTP id z13-20020adff74d000000b002364e3c7720mr8545068wrp.674.1668944944420;
        Sun, 20 Nov 2022 03:49:04 -0800 (PST)
Received: from localhost (net-188-216-77-84.cust.vodafonedsl.it. [188.216.77.84])
        by smtp.gmail.com with ESMTPSA id t11-20020adff60b000000b0022e035a4e93sm8629318wrp.87.2022.11.20.03.49.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Nov 2022 03:49:03 -0800 (PST)
Date:   Sun, 20 Nov 2022 12:49:01 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Ziyang Xuan <william.xuanziyang@huawei.com>
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        lorenzo@kernel.org
Subject: Re: [PATCH net] net: ethernet: mtk_eth_soc: fix potential memory
 leak in mtk_rx_alloc()
Message-ID: <Y3oULSsTwbDY2Bvv@lore-desk>
References: <20221120035405.1464341-1-william.xuanziyang@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Mg3mLB7M7b1XKZaD"
Content-Disposition: inline
In-Reply-To: <20221120035405.1464341-1-william.xuanziyang@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Mg3mLB7M7b1XKZaD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> When fail to dma_map_single() in mtk_rx_alloc(), it returns directly.
> But the memory allocated for local variable data is not freed, and
> local variabel data has not been attached to ring->data[i] yet, so the
> memory allocated for local variable data will not be freed outside
> mtk_rx_alloc() too. Thus memory leak would occur in this scenario.
>=20
> Add skb_free_frag(data) when dma_map_single() failed.
>=20
> Fixes: 23233e577ef9 ("net: ethernet: mtk_eth_soc: rely on page_pool for s=
ingle page buffers")
> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
> ---
>  drivers/net/ethernet/mediatek/mtk_eth_soc.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Acked-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

>=20
> diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/et=
hernet/mediatek/mtk_eth_soc.c
> index 7cd381530aa4..bc47ef1e4dd5 100644
> --- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> +++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> @@ -2378,8 +2378,10 @@ static int mtk_rx_alloc(struct mtk_eth *eth, int r=
ing_no, int rx_flag)
>  				data + NET_SKB_PAD + eth->ip_align,
>  				ring->buf_size, DMA_FROM_DEVICE);
>  			if (unlikely(dma_mapping_error(eth->dma_dev,
> -						       dma_addr)))
> +						       dma_addr))) {
> +				skb_free_frag(data);
>  				return -ENOMEM;
> +			}
>  		}
>  		rxd->rxd1 =3D (unsigned int)dma_addr;
>  		ring->data[i] =3D data;
> --=20
> 2.25.1
>=20

--Mg3mLB7M7b1XKZaD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCY3oULQAKCRA6cBh0uS2t
rB+XAQC1NS342yCNR/mijZECnJw0DZzDUciWxdRU9qpQUcIisAD8C9l7RVkWprf7
ZY5de9YVDFIspT/WErMrTjJIkJRU4g8=
=vshG
-----END PGP SIGNATURE-----

--Mg3mLB7M7b1XKZaD--

