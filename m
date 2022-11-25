Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 850D5638D8E
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 16:38:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbiKYPig (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 10:38:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbiKYPif (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 10:38:35 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE6F72BB3E
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 07:38:33 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id cl5so7295344wrb.9
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 07:38:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qgYtr8VvzDiy70328nRtupHSdxyJsfVt5pKzi3uvBNc=;
        b=IOb02VYU7actVxEtto5C9k6+cjLMWVwP4IN1UTHj6WW6Or2BscdeLS3SucvbEgE1j/
         VCVrat3EY7hjZ7OTzs3kGCej8MN8P9/xHT7uQrR4xX72yKZotf54PK6Lkg2vAyOsYPbV
         pPYTJtEN2wjCBSzEFAyMlfxzmHZn/Or9gSEWAhG9smqXd8rnV2rtvF3UepGl2V2YyjKK
         hXKpjyWzzz+QQWw5JZLZsCxnCMzxiLnptLQCtFXH/3YBEhq4N4MFfAVGtcfS9m3u6Qxa
         nYUGqsTbcsXGgKnDl7tcDZTkrhnWklGG1ASkSVK/lIAKGlixHYha0c0KnJ40wkiJSPGo
         9TFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qgYtr8VvzDiy70328nRtupHSdxyJsfVt5pKzi3uvBNc=;
        b=OFvq35gt7tH0ULVbciMMdKZaCE8TVYWZgA2bCODgLSPUyaPhLCUjgWL6EnQphBsni6
         vy81M2Gba7WE1xZj4lKScyl8V1ldrd0iTT+7ml9InG2/Yu4mACetmtlEnn3i44BILV+I
         jFnlwoDWl5+xz4BU8g6n5zPZOoUWingThaszPaSbuh/OEDfNH3z5OnD+lYAarYMKQ4E4
         rQXuVwbyezH9N8KpkjmaaDZZw3GT7K5mr69wMkGgpjH23BGIt/8qiSDDdNUTG7r4wcmV
         M1ptUK11a6uLjkMhOB20oh/TS4VOlfLAAerLllu0hBolOR8VadXTbXo4YYmWeNeqlZy1
         gq7g==
X-Gm-Message-State: ANoB5pmxN6OcF08NHRaH+cg94z5fX9bgZW/nyr+dA3y/DpKyeEsDnU3t
        h0epQ2ciHRRzakbd1dzd+lW79PTz1l4=
X-Google-Smtp-Source: AA0mqf45EB3Aah3iWzOeWsy3y5URxmfM780to32DY9JTIRfdBIc2oE2SnNWkcW26p9i8knkjO9eW+w==
X-Received: by 2002:adf:ea43:0:b0:22e:433a:46ba with SMTP id j3-20020adfea43000000b0022e433a46bamr17173904wrn.575.1669390712025;
        Fri, 25 Nov 2022 07:38:32 -0800 (PST)
Received: from suse.localnet (host-79-55-110-244.retail.telecomitalia.it. [79.55.110.244])
        by smtp.gmail.com with ESMTPSA id h20-20020a05600c351400b003b4935f04a4sm7222121wmq.5.2022.11.25.07.38.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Nov 2022 07:38:31 -0800 (PST)
From:   "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
To:     netdev@vger.kernel.org,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Cc:     Ira Weiny <ira.weiny@intel.com>,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Subject: Re: [PATCH v2 net-next 3/6] cassini: Use page_address() instead of kmap_atomic()
Date:   Fri, 25 Nov 2022 16:38:30 +0100
Message-ID: <3389596.QJadu78ljV@suse>
In-Reply-To: <20221123205219.31748-4-anirudh.venkataramanan@intel.com>
References: <20221123205219.31748-1-anirudh.venkataramanan@intel.com> <20221123205219.31748-4-anirudh.venkataramanan@intel.com>
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

On mercoled=EC 23 novembre 2022 21:52:16 CET Anirudh Venkataramanan wrote:
> Pages for Rx buffers are allocated in cas_page_alloc() using either
> GFP_ATOMIC or GFP_KERNEL. Memory allocated with GFP_KERNEL/GFP_ATOMIC can=
't
> come from highmem and so there's no need to kmap() them. Just use
> page_address() instead. This makes the variable 'addr' unnecessary, so
> remove it too.
>=20
> Note that kmap_atomic() disables preemption and page-fault processing,
> but page_address() doesn't. When removing uses of kmap_atomic(), one has =
to
> check if the code being executed between the map/unmap implicitly depends
> on page-faults and/or preemption being disabled. If yes, then code to
> disable page-faults and/or preemption should also be added for functional
> correctness. That however doesn't appear to be the case here, so just
> page_address() is used.
>=20
> I don't have hardware, so this change has only been compile tested.
>=20
> Cc: Ira Weiny <ira.weiny@intel.com>
> Cc: Fabio M. De Francesco <fmdefrancesco@gmail.com>
> Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
> ---
> v1 -> v2: Update commit message
> ---
>  drivers/net/ethernet/sun/cassini.c | 34 ++++++++++--------------------
>  1 file changed, 11 insertions(+), 23 deletions(-)

Reviewed-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>

Thanks,

=46abio

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




