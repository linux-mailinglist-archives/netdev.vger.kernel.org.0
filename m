Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 466C668C323
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 17:25:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbjBFQZW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 11:25:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbjBFQZV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 11:25:21 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C8881F919
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 08:25:17 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id g13so7850491ple.10
        for <netdev@vger.kernel.org>; Mon, 06 Feb 2023 08:25:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:to:from:subject:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZC6pN9MiOSrVZPkItJ97qe6ruoIQZ3hNGLWeQvbdH18=;
        b=Tj3HezqfMaBCBli4mX4a8VBISTTImApAIXblRB8yn0OynT11qxqLWh8t1QphiezYsp
         lK/gBj0nDsI8BRWqRk30Z5/fLTTHcz9bo93CAZ7eXf/nHPL5MMeayxjI2bB1EWFZT1L6
         bUZN0X13eqNzPvmMfvKSJUd/Gmiwq1y4+t+YDHmGVfkxDEz+Ac2BFX59TYj8GCti54y9
         ykOIvfenyUYMLVBismT1njRwGI+REjSAGL+xCmd0Ehcw0wRqeHX0x5ZJLMuYkzTrU+90
         sBN6aPKxng2zzuHVIoGaRgQk5UAZGfyI5oAop8MxiCvWkQGjyA/tqLuHDIm6lHomgrLh
         dSag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:to:from:subject:message-id:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZC6pN9MiOSrVZPkItJ97qe6ruoIQZ3hNGLWeQvbdH18=;
        b=Wz2Be6PKIv5eHgzpTl/QQX1oK4Fm/uQ1+izK3SikqrPcVjtIvySiU312gcwbwlzFqF
         m/ilAt7oAuNMNfGg3wsraz8d8FwGV6KUqFmwwlVBOuKAUswKNg2pX2R6HgxPw4y+wgu3
         9PkpHf2e1krzNxEXCRyTgAJb3lYchkoVEf4Rj3AXfAIP+ezzayWdEduI3UV85ESg+08o
         xqSSBIRLXEMCYcswknPfUL4q3icB3xfNLOf91Tv7IhtKZQ2dM943GgvcwGsr2y4uKx1V
         f3X4w0BZSydclMCNAimGtttoPbKAd3itK2ULBLN1W6SOiFJOWZYCnS78RGyj8nhgtpvm
         MNAQ==
X-Gm-Message-State: AO0yUKWCGTszDNg+YdWA8XbLvpVGUa5ku9ZIPsAz0aOq1ZLNEPZK3xLn
        4M84U0DwyeyJehDPqDKmFNw=
X-Google-Smtp-Source: AK7set+yD8d9QfN7ZgTFY0JGD1efI9T8vc/1lKOhLfTsxZGMfcpaXmQYuvhsTNWSfCytAkot7IFGSg==
X-Received: by 2002:a17:902:ab59:b0:198:e3ee:2c98 with SMTP id ij25-20020a170902ab5900b00198e3ee2c98mr10358001plb.67.1675700716471;
        Mon, 06 Feb 2023 08:25:16 -0800 (PST)
Received: from [192.168.0.128] ([98.97.112.127])
        by smtp.googlemail.com with ESMTPSA id jo18-20020a170903055200b001966d94cb2esm2947821plb.288.2023.02.06.08.25.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Feb 2023 08:25:16 -0800 (PST)
Message-ID: <9ddd548874378f29ce7729823a1590dac0c6eca2.camel@gmail.com>
Subject: Re: [PATCH net v4 1/2] net/ps3_gelic_net: Fix RX sk_buff length
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Geoff Levand <geoff@infradead.org>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Date:   Mon, 06 Feb 2023 08:25:15 -0800
In-Reply-To: <4150b1589ed367e18855c16762ff160e9d73a42f.1675632296.git.geoff@infradead.org>
References: <cover.1675632296.git.geoff@infradead.org>
         <4150b1589ed367e18855c16762ff160e9d73a42f.1675632296.git.geoff@infradead.org>
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
> The Gelic Ethernet device needs to have the RX sk_buffs aligned to
> GELIC_NET_RXBUF_ALIGN and the length of the RX sk_buffs must be a multipl=
e of
> GELIC_NET_RXBUF_ALIGN.
>=20
> The current Gelic Ethernet driver was not allocating sk_buffs large enoug=
h to
> allow for this alignment.
>=20
> Fixes various randomly occurring runtime network errors.
>=20
> Fixes: 02c1889166b4 (ps3: gigabit ethernet driver for PS3, take3)
> Signed-off-by: Geoff Levand <geoff@infradead.org>
> ---
>  drivers/net/ethernet/toshiba/ps3_gelic_net.c | 56 ++++++++++++--------
>  1 file changed, 34 insertions(+), 22 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.c b/drivers/net/e=
thernet/toshiba/ps3_gelic_net.c
> index cf8de8a7a8a1..7a8b5e1e77a6 100644
> --- a/drivers/net/ethernet/toshiba/ps3_gelic_net.c
> +++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
> @@ -365,51 +365,63 @@ static int gelic_card_init_chain(struct gelic_card =
*card,
>   *
>   * allocates a new rx skb, iommu-maps it and attaches it to the descript=
or.
>   * Activate the descriptor state-wise
> + *
> + * Gelic RX sk_buffs must be aligned to GELIC_NET_RXBUF_ALIGN and the le=
ngth
> + * must be a multiple of GELIC_NET_RXBUF_ALIGN.
>   */
>  static int gelic_descr_prepare_rx(struct gelic_card *card,
>  				  struct gelic_descr *descr)
>  {
> -	int offset;
> -	unsigned int bufsize;
> +	struct device *dev =3D ctodev(card);
> +	struct {
> +		unsigned int total_bytes;
> +		unsigned int offset;
> +	} aligned_buf;
> +	dma_addr_t cpu_addr;
> =20
>  	if (gelic_descr_get_status(descr) !=3D  GELIC_DESCR_DMA_NOT_IN_USE)
>  		dev_info(ctodev(card), "%s: ERROR status\n", __func__);
> -	/* we need to round up the buffer size to a multiple of 128 */
> -	bufsize =3D ALIGN(GELIC_NET_MAX_MTU, GELIC_NET_RXBUF_ALIGN);
> =20
> -	/* and we need to have it 128 byte aligned, therefore we allocate a
> -	 * bit more */
> -	descr->skb =3D dev_alloc_skb(bufsize + GELIC_NET_RXBUF_ALIGN - 1);
> +	aligned_buf.total_bytes =3D (GELIC_NET_RXBUF_ALIGN - 1) +
> +		GELIC_NET_MAX_MTU + (GELIC_NET_RXBUF_ALIGN - 1);
> +

This value isn't aligned to anything as there have been no steps taken
to align it. In fact it is guaranteed to be off by 2. Did you maybe
mean to use an "&" somewhere?

> +	descr->skb =3D dev_alloc_skb(aligned_buf.total_bytes);
> +
>  	if (!descr->skb) {
> -		descr->buf_addr =3D 0; /* tell DMAC don't touch memory */
> +		descr->buf_addr =3D 0;
>  		return -ENOMEM;

Why remove this comment?

>  	}
> -	descr->buf_size =3D cpu_to_be32(bufsize);
> +
> +	aligned_buf.offset =3D
> +		PTR_ALIGN(descr->skb->data, GELIC_NET_RXBUF_ALIGN) -
> +			descr->skb->data;
> +
> +	descr->buf_size =3D ALIGN(GELIC_NET_MAX_MTU, GELIC_NET_RXBUF_ALIGN);

Originally this was being written using cpu_to_be32. WIth this you are
writing it raw w/ the cpu endianness. Is there a byte ordering issue
here?

>  	descr->dmac_cmd_status =3D 0;
>  	descr->result_size =3D 0;
>  	descr->valid_size =3D 0;
>  	descr->data_error =3D 0;
> =20
> -	offset =3D ((unsigned long)descr->skb->data) &
> -		(GELIC_NET_RXBUF_ALIGN - 1);
> -	if (offset)
> -		skb_reserve(descr->skb, GELIC_NET_RXBUF_ALIGN - offset);

Rather than messing with all this it might be easier to just drop
offset in favor of NET_SKB_PAD since that should be offset in all cases
where dev_alloc_skb is being used. With that the reserve could just be
a constant.

> -	/* io-mmu-map the skb */
> -	descr->buf_addr =3D cpu_to_be32(dma_map_single(ctodev(card),
> -						     descr->skb->data,
> -						     GELIC_NET_MAX_MTU,
> -						     DMA_FROM_DEVICE));
> +	skb_reserve(descr->skb, aligned_buf.offset);
> +
> +	cpu_addr =3D dma_map_single(dev, descr->skb->data, descr->buf_size,
> +		DMA_FROM_DEVICE);
> +
> +	descr->buf_addr =3D cpu_to_be32(cpu_addr);
> +
>  	if (!descr->buf_addr) {

This check should be for dma_mapping_error based on "cpu_addr". There
are some configs that don't return NULL to indicate a mapping error.

>  		dev_kfree_skb_any(descr->skb);
> +		descr->buf_addr =3D 0;
> +		descr->buf_size =3D 0;
>  		descr->skb =3D NULL;
> -		dev_info(ctodev(card),
> +		dev_info(dev,
>  			 "%s:Could not iommu-map rx buffer\n", __func__);
>  		gelic_descr_set_status(descr, GELIC_DESCR_DMA_NOT_IN_USE);
>  		return -ENOMEM;
> -	} else {
> -		gelic_descr_set_status(descr, GELIC_DESCR_DMA_CARDOWNED);
> -		return 0;
>  	}
> +
> +	gelic_descr_set_status(descr, GELIC_DESCR_DMA_CARDOWNED);
> +	return 0;
>  }
> =20
>  /**

