Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9518B62EFA2
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 09:36:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241592AbiKRIf7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 03:35:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240903AbiKRIfe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 03:35:34 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7C948E09F
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 00:35:08 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id c65-20020a1c3544000000b003cfffd00fc0so3013343wma.1
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 00:35:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zmPPp4HMnGJjABr7yjqSFOCUta9R/DZaX0DHPx9pTBM=;
        b=Yanh37WQa3gaS1XaKsvE/aZ3Vc5krHqEQ2/60cvpIzmjKrquT8kihUvnTOlAcyQktK
         gwfNyUqNubXLyhFXKICJuW34eWwD8XHwlBm11HRaNamCHdJ09R3RgznG7bvlMehFO2h0
         5IMC9F/oIIMFjujuKOtIpaDaIG5UQeH0lZBC8tcSMs+4dVNvqULnlEoajBMM4DHLpq+u
         YdJhZLiWwH8m/GDR/p0a14RPNfy5JlVkN5Nrnw+iLOXnZTK22uPInrmH/aeFtVcanbro
         E4qf4etzV9IZxBgvqUrsC0NoKltwMExsP5LtNLZBlLAIc0b6SnjyHIcIgxBV6yy8T3JJ
         N0mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zmPPp4HMnGJjABr7yjqSFOCUta9R/DZaX0DHPx9pTBM=;
        b=JTEH6IHqHIqgW/SgP84Da8BWjMaaFSJ/uvb/89hVEKqzB28QAu3/tp2/gEp/cZS6I8
         hwOuwvClPB0ObAXFDmVmi/D996i7KVoWavkMhuvsIDqiZqZGW5sDgVKwbhpOo13SiYN2
         JTOcblVw7fa6Z3vAcprRwXLhmrbtAYDllhhoZnS1uqISinqQqMop+4L0yIRRQfnoccrc
         6la/ltGmlMN61IeAKcDZD+Fm6fpOSlSR39A+Zf/xJ8BAPSl4lUyzAK6A60POlO8LtTKg
         9AMvU13w7FYXWJalngpKNqgF49jNRlRApIPAJ0JJFjrRp0bti7pFoDJ9981XFQDLfXKI
         LFAg==
X-Gm-Message-State: ANoB5pklVVgNFVlIegVRqZpgN4xenP6klpQi8CZGGXSWxLbmWXJLWiBP
        ksZETr0FyVgEIX70lDwqJZhpqn57uCY=
X-Google-Smtp-Source: AA0mqf5ICwE7e7bWQusMWuOqsuSsrFAAo0VELRT1BeZcr/hJGAFZixuZ0yRD/5FZd+bnUSxpiTt4dQ==
X-Received: by 2002:a05:600c:43d6:b0:3cf:a856:ba2f with SMTP id f22-20020a05600c43d600b003cfa856ba2fmr4261271wmn.37.1668760506946;
        Fri, 18 Nov 2022 00:35:06 -0800 (PST)
Received: from suse.localnet (host-79-26-100-208.retail.telecomitalia.it. [79.26.100.208])
        by smtp.gmail.com with ESMTPSA id q14-20020a05600c46ce00b003c6c182bef9sm10486770wmo.36.2022.11.18.00.35.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 00:35:06 -0800 (PST)
From:   "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
To:     netdev@vger.kernel.org,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Cc:     Ira Weiny <ira.weiny@intel.com>,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Subject: Re: [PATCH net-next 3/5] cassini: Remove unnecessary use of kmap_atomic()
Date:   Fri, 18 Nov 2022 09:35:05 +0100
Message-ID: <3752791.kQq0lBPeGt@suse>
In-Reply-To: <20221117222557.2196195-4-anirudh.venkataramanan@intel.com>
References: <20221117222557.2196195-1-anirudh.venkataramanan@intel.com> <20221117222557.2196195-4-anirudh.venkataramanan@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On gioved=EC 17 novembre 2022 23:25:55 CET Anirudh Venkataramanan wrote:
> Pages for Rx buffers are allocated in cas_page_alloc() using either
> GFP_ATOMIC or GFP_KERNEL. Memory allocated with GFP_KERNEL/GFP_ATOMIC
> can't come from highmem and so there's no need to kmap() them. Just use
> page_address() instead.
>=20
> I don't have hardware, so this change has only been compile tested.
>=20
> Cc: Ira Weiny <ira.weiny@intel.com>
> Cc: Fabio M. De Francesco <fmdefrancesco@gmail.com>
> Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
> ---
>  drivers/net/ethernet/sun/cassini.c | 34 ++++++++++--------------------
>  1 file changed, 11 insertions(+), 23 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/sun/cassini.c
> b/drivers/net/ethernet/sun/cassini.c index 0aca193..2f66cfc 100644
> --- a/drivers/net/ethernet/sun/cassini.c
> +++ b/drivers/net/ethernet/sun/cassini.c
> @@ -1915,7 +1915,7 @@ static int cas_rx_process_pkt(struct cas *cp, struct
> cas_rx_comp *rxc, int off, swivel =3D RX_SWIVEL_OFF_VAL;
>  	struct cas_page *page;
>  	struct sk_buff *skb;
> -	void *addr, *crcaddr;
> +	void *crcaddr;
>  	__sum16 csum;
>  	char *p;
>=20
> @@ -1936,7 +1936,7 @@ static int cas_rx_process_pkt(struct cas *cp, struct
> cas_rx_comp *rxc, skb_reserve(skb, swivel);
>=20
>  	p =3D skb->data;
> -	addr =3D crcaddr =3D NULL;
> +	crcaddr =3D NULL;
>  	if (hlen) { /* always copy header pages */
>  		i =3D CAS_VAL(RX_COMP2_HDR_INDEX, words[1]);
>  		page =3D cp->rx_pages[CAS_VAL(RX_INDEX_RING, i)]
[CAS_VAL(RX_INDEX_NUM, i)];
> @@ -1948,12 +1948,10 @@ static int cas_rx_process_pkt(struct cas *cp, str=
uct
> cas_rx_comp *rxc, i +=3D cp->crc_size;
>  		dma_sync_single_for_cpu(&cp->pdev->dev, page->dma_addr +=20
off,
>  					i, DMA_FROM_DEVICE);
> -		addr =3D cas_page_map(page->buffer);
> -		memcpy(p, addr + off, i);
> +		memcpy(p, page_address(page->buffer) + off, i);
>  		dma_sync_single_for_device(&cp->pdev->dev,
>  					   page->dma_addr + off, i,
>  					   DMA_FROM_DEVICE);
> -		cas_page_unmap(addr);
>  		RX_USED_ADD(page, 0x100);
>  		p +=3D hlen;
>  		swivel =3D 0;
> @@ -1984,12 +1982,11 @@ static int cas_rx_process_pkt(struct cas *cp, str=
uct
> cas_rx_comp *rxc, /* make sure we always copy a header */
>  		swivel =3D 0;
>  		if (p =3D=3D (char *) skb->data) { /* not split */
> -			addr =3D cas_page_map(page->buffer);
> -			memcpy(p, addr + off, RX_COPY_MIN);
> +			memcpy(p, page_address(page->buffer) + off,
> +			       RX_COPY_MIN);
>  			dma_sync_single_for_device(&cp->pdev->dev,
>  						   page->dma_addr=20
+ off, i,
>  						  =20
DMA_FROM_DEVICE);
> -			cas_page_unmap(addr);
>  			off +=3D RX_COPY_MIN;
>  			swivel =3D RX_COPY_MIN;
>  			RX_USED_ADD(page, cp->mtu_stride);
> @@ -2036,10 +2033,8 @@ static int cas_rx_process_pkt(struct cas *cp, stru=
ct
> cas_rx_comp *rxc, RX_USED_ADD(page, hlen + cp->crc_size);
>  		}
>=20
> -		if (cp->crc_size) {
> -			addr =3D cas_page_map(page->buffer);
> -			crcaddr  =3D addr + off + hlen;
> -		}
> +		if (cp->crc_size)
> +			crcaddr =3D page_address(page->buffer) + off +=20
hlen;
>=20
>  	} else {
>  		/* copying packet */
> @@ -2061,12 +2056,10 @@ static int cas_rx_process_pkt(struct cas *cp, str=
uct
> cas_rx_comp *rxc, i +=3D cp->crc_size;
>  		dma_sync_single_for_cpu(&cp->pdev->dev, page->dma_addr +=20
off,
>  					i, DMA_FROM_DEVICE);
> -		addr =3D cas_page_map(page->buffer);
> -		memcpy(p, addr + off, i);
> +		memcpy(p, page_address(page->buffer) + off, i);
>  		dma_sync_single_for_device(&cp->pdev->dev,
>  					   page->dma_addr + off, i,
>  					   DMA_FROM_DEVICE);
> -		cas_page_unmap(addr);
>  		if (p =3D=3D (char *) skb->data) /* not split */
>  			RX_USED_ADD(page, cp->mtu_stride);
>  		else
> @@ -2081,20 +2074,17 @@ static int cas_rx_process_pkt(struct cas *cp, str=
uct
> cas_rx_comp *rxc, page->dma_addr,
>  						dlen + cp-
>crc_size,
>  						DMA_FROM_DEVICE);
> -			addr =3D cas_page_map(page->buffer);
> -			memcpy(p, addr, dlen + cp->crc_size);
> +			memcpy(p, page_address(page->buffer), dlen + cp-
>crc_size);
>  			dma_sync_single_for_device(&cp->pdev->dev,
>  						   page->dma_addr,
>  						   dlen + cp-
>crc_size,
>  						  =20
DMA_FROM_DEVICE);
> -			cas_page_unmap(addr);
>  			RX_USED_ADD(page, dlen + cp->crc_size);
>  		}
>  end_copy_pkt:
> -		if (cp->crc_size) {
> -			addr    =3D NULL;
> +		if (cp->crc_size)
>  			crcaddr =3D skb->data + alloclen;
> -		}
> +

This is a different logical change. Some maintainers I met would have asked=
 =20
for a separate patch, but I'm OK with it being here.

>  		skb_put(skb, alloclen);
>  	}
>=20
> @@ -2103,8 +2093,6 @@ static int cas_rx_process_pkt(struct cas *cp, struct
> cas_rx_comp *rxc, /* checksum includes FCS. strip it out. */
>  		csum =3D csum_fold(csum_partial(crcaddr, cp->crc_size,
>  					      csum_unfold(csum)));
> -		if (addr)
> -			cas_page_unmap(addr);
>  	}
>  	skb->protocol =3D eth_type_trans(skb, cp->dev);
>  	if (skb->protocol =3D=3D htons(ETH_P_IP)) {
> --
> 2.37.2

Reviewed-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>

Thanks,

=46abio



