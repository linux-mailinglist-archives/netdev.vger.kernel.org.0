Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DCFA68C378
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 17:37:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbjBFQhq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 11:37:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbjBFQhp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 11:37:45 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4376B212B5
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 08:37:44 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id pj3so12152811pjb.1
        for <netdev@vger.kernel.org>; Mon, 06 Feb 2023 08:37:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:to:from:subject:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SaYTVktGLezvcBUkaUURdu+2ZnabLhFYQhdxFiqkVsQ=;
        b=ELif1szc3RaBEIOYjMobQf/ly8pF6VWfmt/nghe2VzI0u7wLDvjXuBNpNsT+g/3Cyd
         jYkFUyvChbLNR1UabEZIlfRKvB2qO9k4y01lPp1FVmMUBMUnwDKR4x8r9V6Op6Cp0k0d
         s+ZbtCLFNE8EQsyuSZMhpCpdfOzzZdwhWAei2Tm6QX83rLWH0782Vhnsy8m+GAh5Mtxk
         TrfI9t0oqozUyY1NeiPeA1b3kFYdNmDEKHbHADO/Vkw4w4EaMYmbEtR4XoJDrsflKvl6
         iuifhN4pHw2JlNVNXnPutkbAki1WFPxWJjemcXfSTlQRtJXCUxwL4Kn3Ng0SoTkKAZwf
         rjvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:to:from:subject:message-id:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SaYTVktGLezvcBUkaUURdu+2ZnabLhFYQhdxFiqkVsQ=;
        b=BmtfkEvknjjFsR7D64gTULOznnfkOnJvejheGEGXJXGjL9Y1XzG4/CMnWejMKaFMBJ
         8F3mPIl9cSg1wnnRD3ZQHhHqN3XhPnJlCMbCdt+hHVQbx3C1Mwo41YEaSHsf3W/9v8+Q
         o7e9iLlWkUmtwBky4feLpOfj1KM5xAyr6usyo+r88g6kGYz2ivkXShEbymLw6/FSkBbd
         s3GQsQdKiXNu2bPirCL72gJHEbZqiTAd7jzRQZgXmMW9BSWBrX0s8ajSeOnES/dI+OHK
         p1WKohpkM8Bymmx0MBQqPZCEDD+2zXHvFfHsrcuw4CGg8eAHIMeSHRCD57Jx9nigV9XM
         zlrA==
X-Gm-Message-State: AO0yUKWMjmlXH716/JH/tc2oz70DzQgcKVD36e0xKwTztT3UByQxRQIN
        88bE2kZSG4YkWKJA9dQkD2w=
X-Google-Smtp-Source: AK7set+up3SMyrz04gZrKXROt4bkA4RCb70ucyOXl53VKue/vhREXg/H4l1PMDwlCD7eQX+DP+A0Jg==
X-Received: by 2002:a17:902:ce8b:b0:199:2236:ae88 with SMTP id f11-20020a170902ce8b00b001992236ae88mr2081468plg.43.1675701463629;
        Mon, 06 Feb 2023 08:37:43 -0800 (PST)
Received: from [192.168.0.128] ([98.97.112.127])
        by smtp.googlemail.com with ESMTPSA id ji13-20020a170903324d00b0019926c77577sm545811plb.90.2023.02.06.08.37.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Feb 2023 08:37:43 -0800 (PST)
Message-ID: <79eb8baa3f2d96d47ab3e4d4c4c6bdc8bacfa207.camel@gmail.com>
Subject: Re: [PATCH net v4 2/2] net/ps3_gelic_net: Use dma_mapping_error
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Geoff Levand <geoff@infradead.org>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Date:   Mon, 06 Feb 2023 08:37:41 -0800
In-Reply-To: <8d40259f863ed1a077687f3c3d5b8b3707478170.1675632296.git.geoff@infradead.org>
References: <cover.1675632296.git.geoff@infradead.org>
         <8d40259f863ed1a077687f3c3d5b8b3707478170.1675632296.git.geoff@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2023-02-05 at 22:10 +0000, Geoff Levand wrote:
> The current Gelic Etherenet driver was checking the return value of its
> dma_map_single call, and not using the dma_mapping_error() routine.
>=20
> Fixes runtime problems like these:
>=20
>   DMA-API: ps3_gelic_driver sb_05: device driver failed to check map erro=
r
>   WARNING: CPU: 0 PID: 0 at kernel/dma/debug.c:1027 .check_unmap+0x888/0x=
8dc
>=20
> Fixes: 02c1889166b4 (ps3: gigabit ethernet driver for PS3, take3)
> Signed-off-by: Geoff Levand <geoff@infradead.org>
> ---
>  drivers/net/ethernet/toshiba/ps3_gelic_net.c | 52 ++++++++++----------
>  1 file changed, 27 insertions(+), 25 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.c b/drivers/net/e=
thernet/toshiba/ps3_gelic_net.c
> index 7a8b5e1e77a6..5622b512e2e4 100644
> --- a/drivers/net/ethernet/toshiba/ps3_gelic_net.c
> +++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
> @@ -309,22 +309,34 @@ static int gelic_card_init_chain(struct gelic_card =
*card,
>  				 struct gelic_descr_chain *chain,
>  				 struct gelic_descr *start_descr, int no)
>  {
> -	int i;
> +	struct device *dev =3D ctodev(card);
>  	struct gelic_descr *descr;
> +	int i;
> =20
> -	descr =3D start_descr;
> -	memset(descr, 0, sizeof(*descr) * no);
> +	memset(start_descr, 0, no * sizeof(*start_descr));
> =20
>  	/* set up the hardware pointers in each descriptor */
> -	for (i =3D 0; i < no; i++, descr++) {
> +	for (i =3D 0, descr =3D start_descr; i < no; i++, descr++) {
>  		gelic_descr_set_status(descr, GELIC_DESCR_DMA_NOT_IN_USE);
>  		descr->bus_addr =3D
>  			dma_map_single(ctodev(card), descr,
>  				       GELIC_DESCR_SIZE,
>  				       DMA_BIDIRECTIONAL);

Are bus_addr and the CPU the same byte ordering? Just wondering since
this is being passed raw. I would have expected it to go through a
cpu_to_be32.

> =20
> -		if (!descr->bus_addr)
> -			goto iommu_error;
> +		if (unlikely(dma_mapping_error(dev, descr->bus_addr))) {

The expectation for dma_mapping_error is that the address is in cpu
order. So in this case it is partially correct since bus_addr wasn't
byte swapped, but generally the dma address used should be a CPU byte
ordered variable.

> +			dev_err(dev, "%s:%d: dma_mapping_error\n", __func__,
> +				__LINE__);
> +
> +			for (i--, descr--; i > 0; i--, descr--) {
> +				if (descr->bus_addr) {

So I am pretty sure this is broken. Usually for something like this I
will resort to just doing a while (i--) as "i =3D=3D 0" should be a valid
buffer to have to unmap.

Maybe something like:
			while (i--) {
				descr--;

Also I think you can get rid of the if since descr->bus_addr should be
valid for all values since you populated it just a few lines above for
each value of i.

> +					dma_unmap_single(ctodev(card),
> +						descr->bus_addr,
> +						GELIC_DESCR_SIZE,
> +						DMA_BIDIRECTIONAL);
> +				}
> +			}
> +			return -ENOMEM;
> +		}
> =20
>  		descr->next =3D descr + 1;
>  		descr->prev =3D descr - 1;
> @@ -334,8 +346,7 @@ static int gelic_card_init_chain(struct gelic_card *c=
ard,
>  	start_descr->prev =3D (descr - 1);
> =20
>  	/* chain bus addr of hw descriptor */
> -	descr =3D start_descr;
> -	for (i =3D 0; i < no; i++, descr++) {
> +	for (i =3D 0, descr =3D start_descr; i < no; i++, descr++) {
>  		descr->next_descr_addr =3D cpu_to_be32(descr->next->bus_addr);
>  	}
> =20

This seems like an unrelated change that was snuck in.

> @@ -346,14 +357,6 @@ static int gelic_card_init_chain(struct gelic_card *=
card,
>  	(descr - 1)->next_descr_addr =3D 0;
> =20
>  	return 0;
> -
> -iommu_error:
> -	for (i--, descr--; 0 <=3D i; i--, descr--)
> -		if (descr->bus_addr)
> -			dma_unmap_single(ctodev(card), descr->bus_addr,
> -					 GELIC_DESCR_SIZE,
> -					 DMA_BIDIRECTIONAL);
> -	return -ENOMEM;
>  }
> =20
>  /**
> @@ -407,19 +410,18 @@ static int gelic_descr_prepare_rx(struct gelic_card=
 *card,
>  	cpu_addr =3D dma_map_single(dev, descr->skb->data, descr->buf_size,
>  		DMA_FROM_DEVICE);
> =20
> -	descr->buf_addr =3D cpu_to_be32(cpu_addr);
> -
> -	if (!descr->buf_addr) {
> +	if (unlikely(dma_mapping_error(dev, cpu_addr))) {
> +		dev_err(dev, "%s:%d: dma_mapping_error\n", __func__, __LINE__);
>  		dev_kfree_skb_any(descr->skb);
>  		descr->buf_addr =3D 0;
>  		descr->buf_size =3D 0;
>  		descr->skb =3D NULL;
> -		dev_info(dev,
> -			 "%s:Could not iommu-map rx buffer\n", __func__);
>  		gelic_descr_set_status(descr, GELIC_DESCR_DMA_NOT_IN_USE);
>  		return -ENOMEM;
>  	}
> =20
> +	descr->buf_addr =3D cpu_to_be32(cpu_addr);
> +

Okay, so this addresses the comment I had in the earlier patch.

>  	gelic_descr_set_status(descr, GELIC_DESCR_DMA_CARDOWNED);
>  	return 0;
>  }
> @@ -775,6 +777,7 @@ static int gelic_descr_prepare_tx(struct gelic_card *=
card,
>  				  struct gelic_descr *descr,
>  				  struct sk_buff *skb)
>  {
> +	struct device *dev =3D ctodev(card);
>  	dma_addr_t buf;
> =20
>  	if (card->vlan_required) {
> @@ -789,11 +792,10 @@ static int gelic_descr_prepare_tx(struct gelic_card=
 *card,
>  		skb =3D skb_tmp;
>  	}
> =20
> -	buf =3D dma_map_single(ctodev(card), skb->data, skb->len, DMA_TO_DEVICE=
);
> +	buf =3D dma_map_single(dev, skb->data, skb->len, DMA_TO_DEVICE);
> =20
> -	if (!buf) {
> -		dev_err(ctodev(card),
> -			"dma map 2 failed (%p, %i). Dropping packet\n",
> +	if (unlikely(dma_mapping_error(dev, buf))) {
> +		dev_err(dev, "dma map 2 failed (%p, %i). Dropping packet\n",
>  			skb->data, skb->len);
>  		return -ENOMEM;
>  	}

