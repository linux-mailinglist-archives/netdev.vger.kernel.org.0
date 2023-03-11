Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 170646B618B
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 23:41:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbjCKWly (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 17:41:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbjCKWlx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 17:41:53 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 175F43867E
        for <netdev@vger.kernel.org>; Sat, 11 Mar 2023 14:41:52 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id fd25so5701171pfb.1
        for <netdev@vger.kernel.org>; Sat, 11 Mar 2023 14:41:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678574511;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=z4uQV76iJQjw06+ByrZCmJ3Psq1e3CLPrv5Gqf6Y4B0=;
        b=WIu65A7zkhZG6AjCHHGmGnXXihNlaGzJUmUEkwWwSYm6PB7O36XV76cARBpHRRREh9
         mD1DzD6QvEsDjW3ZF7EBIftZKLofngtQV907cgcyVcLhTTYZybZmjfneM3j4zXhRFQua
         8/sQ1++RUT7vVJCv1Dz1vAzVrC7b1uDgfsXSfs1g1LN7VprxA84mmkYumrJWvXYtxrVY
         OFLJUn5AoFKduMqsvYZO4zbm5lia4tvMmMnhklNk5sRA4GyicpPwdDyMz7FRtiI/RNl0
         QXlMOPGnh8ydUDhMB6Q3BR+uH8mW9P9YO4Hl51Navpwlcnbv6w+MOWW400h2o+JmwM5R
         f8wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678574511;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=z4uQV76iJQjw06+ByrZCmJ3Psq1e3CLPrv5Gqf6Y4B0=;
        b=FiXyq1Xg5gvDBTga9enH78rryA2gHEtRUxrwXwbCdjqnH0I8Zt80zu74o72Cb4E/l6
         5sfHCizrS+VfxTFTDU45GVcy0GA4QtLspOxNbCjZJ8kGG5SAVulquWq4etY8/El7YUn1
         fsPMw1mTJtjEgTukiY401JVDT9cP/+4j1sFkrOZn2H0ESXgB9sRZvRzK1ox2+sd6tNyh
         boo1tlNpF3opR1ZrRGOEbgLcjLreXQyu5YarrpYLqkH/5gf/6lF+Zl26DBR8Pe9E7FWC
         90efajeVZtLN7NSlvmiic/RVOTMZuM1A0zCVMBytnM7PR97jXFNVysNE+bGWnHO+Twjy
         O1QA==
X-Gm-Message-State: AO0yUKWDdB4dpR3LvvTiTMBdIc552/rr/dMQ5JUmOLMt8n+rTMzn/dHX
        hDMQgr2KBZEjH7WUwaQEZ1g=
X-Google-Smtp-Source: AK7set8SOL8x7iZoVmFatfuB0Na97XaVYisySaOMMNThG3TXqmHHIM9NKqLgQ0d4wek/zqoCXP1BrQ==
X-Received: by 2002:aa7:8bd6:0:b0:5dc:107f:2e19 with SMTP id s22-20020aa78bd6000000b005dc107f2e19mr27412118pfd.9.1678574511432;
        Sat, 11 Mar 2023 14:41:51 -0800 (PST)
Received: from [192.168.0.128] ([98.97.116.32])
        by smtp.googlemail.com with ESMTPSA id i23-20020a63e917000000b004cd2eebc551sm1920536pgh.62.2023.03.11.14.41.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Mar 2023 14:41:50 -0800 (PST)
Message-ID: <a1deb614e9583ea82be932f34c82a2d922d148e3.camel@gmail.com>
Subject: Re: [PATCH net v8 2/2] net/ps3_gelic_net: Use dma_mapping_error
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Geoff Levand <geoff@infradead.org>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Paolo Abeni <pabeni@redhat.com>
Date:   Sat, 11 Mar 2023 14:41:48 -0800
In-Reply-To: <642c56a7da025406c36862464f5a15aba3e5340e.1678570942.git.geoff@infradead.org>
References: <cover.1678570942.git.geoff@infradead.org>
         <642c56a7da025406c36862464f5a15aba3e5340e.1678570942.git.geoff@infradead.org>
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

On Sat, 2023-03-11 at 21:46 +0000, Geoff Levand wrote:
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
> Fixes: 02c1889166b4 ("ps3: gigabit ethernet driver for PS3, take3")
> Signed-off-by: Geoff Levand <geoff@infradead.org>
> ---
>  drivers/net/ethernet/toshiba/ps3_gelic_net.c | 24 +++++++++++---------
>  1 file changed, 13 insertions(+), 11 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.c b/drivers/net/e=
thernet/toshiba/ps3_gelic_net.c
> index 56557fc8d18a..87d3c768286e 100644
> --- a/drivers/net/ethernet/toshiba/ps3_gelic_net.c
> +++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
> @@ -325,15 +325,17 @@ static int gelic_card_init_chain(struct gelic_card =
*card,
> =20
>  	/* set up the hardware pointers in each descriptor */
>  	for (i =3D 0; i < no; i++, descr++) {
> +		dma_addr_t cpu_addr;
> +
>  		gelic_descr_set_status(descr, GELIC_DESCR_DMA_NOT_IN_USE);
> -		descr->bus_addr =3D
> -			dma_map_single(ctodev(card), descr,
> -				       GELIC_DESCR_SIZE,
> -				       DMA_BIDIRECTIONAL);
> =20
> -		if (!descr->bus_addr)
> +		cpu_addr =3D dma_map_single(ctodev(card), descr,
> +					  GELIC_DESCR_SIZE, DMA_BIDIRECTIONAL);
> +
> +		if (dma_mapping_error(ctodev(card), cpu_addr))
>  			goto iommu_error;
> =20
> +		descr->bus_addr =3D cpu_to_be32(cpu_addr);
>  		descr->next =3D descr + 1;
>  		descr->prev =3D descr - 1;
>  	}
> @@ -377,6 +379,7 @@ static int gelic_card_init_chain(struct gelic_card *c=
ard,
>  static int gelic_descr_prepare_rx(struct gelic_card *card,
>  				  struct gelic_descr *descr)
>  {
> +	dma_addr_t cpu_addr;
>  	int offset;
> =20
>  	if (gelic_descr_get_status(descr) !=3D  GELIC_DESCR_DMA_NOT_IN_USE)
> @@ -398,11 +401,10 @@ static int gelic_descr_prepare_rx(struct gelic_card=
 *card,
>  	if (offset)
>  		skb_reserve(descr->skb, GELIC_NET_RXBUF_ALIGN - offset);
>  	/* io-mmu-map the skb */
> -	descr->buf_addr =3D cpu_to_be32(dma_map_single(ctodev(card),
> -						     descr->skb->data,
> -						     gelic_rx_skb_size,
> -						     DMA_FROM_DEVICE));
> -	if (!descr->buf_addr) {
> +	cpu_addr =3D dma_map_single(ctodev(card), descr->skb->data,
> +				  gelic_rx_skb_size, DMA_FROM_DEVICE);
> +	descr->buf_addr =3D cpu_to_be32(cpu_addr);
> +	if (dma_mapping_error(ctodev(card), cpu_addr)) {
>  		dev_kfree_skb_any(descr->skb);
>  		descr->skb =3D NULL;
>  		dev_info(ctodev(card),
> @@ -782,7 +784,7 @@ static int gelic_descr_prepare_tx(struct gelic_card *=
card,
> =20
>  	buf =3D dma_map_single(ctodev(card), skb->data, skb->len, DMA_TO_DEVICE=
);
> =20
> -	if (!buf) {
> +	if (dma_mapping_error(ctodev(card), buf)) {
>  		dev_err(ctodev(card),
>  			"dma map 2 failed (%p, %i). Dropping packet\n",
>  			skb->data, skb->len);

Looks good to me. The only tweak I would make is maybe using "dma_addr"
, "phys_addr" or "bus_addr" instead of "cpu_addr", however that is more
cosmetic than anything else.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>

