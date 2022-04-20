Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA315088EC
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 15:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358954AbiDTNML (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 09:12:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235000AbiDTNMK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 09:12:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B4421427C5
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 06:09:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650460161;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=H5WElo14BBY5Cz/PaPpg1Na6JGReOhJoOldP3NeoOX8=;
        b=h0Nph4sypKFpcGtP80zXDEYmJWjv4Qb9H2AwYfouX0iMHy5QuI6RBwCUvSvjfs0d45YwyB
        WhpJsEnaTfoP2EWyPYMMSmpCmFsD8V+3BhtAtOrkoRer7XZ6l4WJ2e9QC9Y8F04V8hcwck
        ICRsTLc1Zmo9MNEjjojs2NA+07xbdJw=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-42-fgkE4JgrNBCMOQzsGTq4tw-1; Wed, 20 Apr 2022 09:09:20 -0400
X-MC-Unique: fgkE4JgrNBCMOQzsGTq4tw-1
Received: by mail-qt1-f200.google.com with SMTP id c17-20020ac85a91000000b002f1ff042e0eso870192qtc.10
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 06:09:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=H5WElo14BBY5Cz/PaPpg1Na6JGReOhJoOldP3NeoOX8=;
        b=nG5TE87UTx0zthpEW94Jvs2/mPE+PfyBgZrS0oRfRmthaJFBbJRlJZAVf0b+VN/g0P
         ZroQC8OGaImfX4xR6oSxv8EQeu0LgKLUVRNQWWVctT/JEumVIi791gySkYnIK1PnQrbf
         6iRkPhCTusub4Lb2+EJyAkaJZHn3IQtVyWeaw1ab4YJ7VYioDbI2YTHEYPjjfLtou06w
         PPHXqZCv0wRXOUtDVXzz2pXUhyuU4z5F5rL80G7Kk2hqd1ZHNfp7zl3hnfQLpvIDqjXR
         JUgAFu7+LNRM7oGr3IcD6ctgLP8JEyCwEBjT7qtXCtP09reyT/hiHGS//d7uNfRl+SSK
         J0vQ==
X-Gm-Message-State: AOAM530x2XOK12MB5DO/8DeOcNMfid2glAIJlWOTmM4QL7mEffN5R4L/
        8QrqfNrDzZW/8NK8e26FuyineCeVRyrMnWOdFG3ZffH3Wyu1kkuTWRJpYDnoPY76mtM3BmNvZia
        sv/Fgn0pJ+xK1PLrK
X-Received: by 2002:a05:6214:2462:b0:449:998a:8c09 with SMTP id im2-20020a056214246200b00449998a8c09mr2207938qvb.34.1650460159532;
        Wed, 20 Apr 2022 06:09:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJynjmYOO8LNpuPc3DFNKKwI7gtP6MXM6nmFVA7TGJhkHdGOcq/xSHXBOnMPtHjXtdebu4//zA==
X-Received: by 2002:a05:6214:2462:b0:449:998a:8c09 with SMTP id im2-20020a056214246200b00449998a8c09mr2207908qvb.34.1650460159254;
        Wed, 20 Apr 2022 06:09:19 -0700 (PDT)
Received: from localhost (net-93-71-56-156.cust.vodafonedsl.it. [93.71.56.156])
        by smtp.gmail.com with ESMTPSA id b2-20020a37b202000000b0069c7ad47221sm1462092qkf.38.2022.04.20.06.09.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 06:09:18 -0700 (PDT)
Date:   Wed, 20 Apr 2022 15:09:15 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     anthony.l.nguyen@intel.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        magnus.karlsson@intel.com, jbrouer@redhat.com, toke@redhat.com,
        intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH net-next] ixgbe: add xdp frags support to ndo_xdp_xmit
Message-ID: <YmAF+wBcluzOGXgJ@lore-desk>
References: <6de1d7547b60677ad0b0f7ebcbc7ebc76a31dcf7.1649180962.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Q0eCcL3TwOvk179G"
Content-Disposition: inline
In-Reply-To: <6de1d7547b60677ad0b0f7ebcbc7ebc76a31dcf7.1649180962.git.lorenzo@kernel.org>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Q0eCcL3TwOvk179G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Add the capability to map non-linear xdp frames in XDP_TX and ndo_xdp_xmit
> callback.

Hi Tony,

do you have any feedbacks about this patch?

Regards,
Lorenzo

>=20
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 99 ++++++++++++-------
>  1 file changed, 63 insertions(+), 36 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/=
ethernet/intel/ixgbe/ixgbe_main.c
> index c4a4954aa317..8b84c9b2eecc 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> @@ -2344,6 +2344,7 @@ static int ixgbe_clean_rx_irq(struct ixgbe_q_vector=
 *q_vector,
>  			hard_start =3D page_address(rx_buffer->page) +
>  				     rx_buffer->page_offset - offset;
>  			xdp_prepare_buff(&xdp, hard_start, offset, size, true);
> +			xdp_buff_clear_frags_flag(&xdp);
>  #if (PAGE_SIZE > 4096)
>  			/* At larger PAGE_SIZE, frame_sz depend on len size */
>  			xdp.frame_sz =3D ixgbe_rx_frame_truesize(rx_ring, size);
> @@ -8571,57 +8572,83 @@ static u16 ixgbe_select_queue(struct net_device *=
dev, struct sk_buff *skb,
>  int ixgbe_xmit_xdp_ring(struct ixgbe_ring *ring,
>  			struct xdp_frame *xdpf)
>  {
> -	struct ixgbe_tx_buffer *tx_buffer;
> -	union ixgbe_adv_tx_desc *tx_desc;
> -	u32 len, cmd_type;
> -	dma_addr_t dma;
> -	u16 i;
> -
> -	len =3D xdpf->len;
> +	struct skb_shared_info *sinfo =3D xdp_get_shared_info_from_frame(xdpf);
> +	u8 nr_frags =3D unlikely(xdp_frame_has_frags(xdpf)) ? sinfo->nr_frags :=
 0;
> +	u16 i =3D 0, index =3D ring->next_to_use;
> +	struct ixgbe_tx_buffer *tx_head =3D &ring->tx_buffer_info[index];
> +	struct ixgbe_tx_buffer *tx_buff =3D tx_head;
> +	union ixgbe_adv_tx_desc *tx_desc =3D IXGBE_TX_DESC(ring, index);
> +	u32 cmd_type, len =3D xdpf->len;
> +	void *data =3D xdpf->data;
> =20
> -	if (unlikely(!ixgbe_desc_unused(ring)))
> +	if (unlikely(ixgbe_desc_unused(ring) < 1 + nr_frags))
>  		return IXGBE_XDP_CONSUMED;
> =20
> -	dma =3D dma_map_single(ring->dev, xdpf->data, len, DMA_TO_DEVICE);
> -	if (dma_mapping_error(ring->dev, dma))
> -		return IXGBE_XDP_CONSUMED;
> +	tx_head->bytecount =3D xdp_get_frame_len(xdpf);
> +	tx_head->gso_segs =3D 1;
> +	tx_head->xdpf =3D xdpf;
> =20
> -	/* record the location of the first descriptor for this packet */
> -	tx_buffer =3D &ring->tx_buffer_info[ring->next_to_use];
> -	tx_buffer->bytecount =3D len;
> -	tx_buffer->gso_segs =3D 1;
> -	tx_buffer->protocol =3D 0;
> +	tx_desc->read.olinfo_status =3D
> +		cpu_to_le32(tx_head->bytecount << IXGBE_ADVTXD_PAYLEN_SHIFT);
> =20
> -	i =3D ring->next_to_use;
> -	tx_desc =3D IXGBE_TX_DESC(ring, i);
> +	for (;;) {
> +		dma_addr_t dma;
> =20
> -	dma_unmap_len_set(tx_buffer, len, len);
> -	dma_unmap_addr_set(tx_buffer, dma, dma);
> -	tx_buffer->xdpf =3D xdpf;
> +		dma =3D dma_map_single(ring->dev, data, len, DMA_TO_DEVICE);
> +		if (dma_mapping_error(ring->dev, dma))
> +			goto unmap;
> =20
> -	tx_desc->read.buffer_addr =3D cpu_to_le64(dma);
> +		dma_unmap_len_set(tx_buff, len, len);
> +		dma_unmap_addr_set(tx_buff, dma, dma);
> +
> +		cmd_type =3D IXGBE_ADVTXD_DTYP_DATA | IXGBE_ADVTXD_DCMD_DEXT |
> +			   IXGBE_ADVTXD_DCMD_IFCS | len;
> +		tx_desc->read.cmd_type_len =3D cpu_to_le32(cmd_type);
> +		tx_desc->read.buffer_addr =3D cpu_to_le64(dma);
> +		tx_buff->protocol =3D 0;
> +
> +		if (++index =3D=3D ring->count)
> +			index =3D 0;
> +
> +		if (i =3D=3D nr_frags)
> +			break;
> +
> +		tx_buff =3D &ring->tx_buffer_info[index];
> +		tx_desc =3D IXGBE_TX_DESC(ring, index);
> +		tx_desc->read.olinfo_status =3D 0;
> =20
> +		data =3D skb_frag_address(&sinfo->frags[i]);
> +		len =3D skb_frag_size(&sinfo->frags[i]);
> +		i++;
> +	}
>  	/* put descriptor type bits */
> -	cmd_type =3D IXGBE_ADVTXD_DTYP_DATA |
> -		   IXGBE_ADVTXD_DCMD_DEXT |
> -		   IXGBE_ADVTXD_DCMD_IFCS;
> -	cmd_type |=3D len | IXGBE_TXD_CMD;
> -	tx_desc->read.cmd_type_len =3D cpu_to_le32(cmd_type);
> -	tx_desc->read.olinfo_status =3D
> -		cpu_to_le32(len << IXGBE_ADVTXD_PAYLEN_SHIFT);
> +	tx_desc->read.cmd_type_len |=3D cpu_to_le32(IXGBE_TXD_CMD);
> =20
>  	/* Avoid any potential race with xdp_xmit and cleanup */
>  	smp_wmb();
> =20
> -	/* set next_to_watch value indicating a packet is present */
> -	i++;
> -	if (i =3D=3D ring->count)
> -		i =3D 0;
> -
> -	tx_buffer->next_to_watch =3D tx_desc;
> -	ring->next_to_use =3D i;
> +	tx_head->next_to_watch =3D tx_desc;
> +	ring->next_to_use =3D index;
> =20
>  	return IXGBE_XDP_TX;
> +
> +unmap:
> +	for (;;) {
> +		tx_buff =3D &ring->tx_buffer_info[index];
> +		if (dma_unmap_len(tx_buff, len))
> +			dma_unmap_page(ring->dev, dma_unmap_addr(tx_buff, dma),
> +				       dma_unmap_len(tx_buff, len),
> +				       DMA_TO_DEVICE);
> +		dma_unmap_len_set(tx_buff, len, 0);
> +		if (tx_buff =3D=3D tx_head)
> +			break;
> +
> +		if (!index)
> +			index +=3D ring->count;
> +		index--;
> +	}
> +
> +	return IXGBE_XDP_CONSUMED;
>  }
> =20
>  netdev_tx_t ixgbe_xmit_frame_ring(struct sk_buff *skb,
> --=20
> 2.35.1
>=20

--Q0eCcL3TwOvk179G
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYmAF+wAKCRA6cBh0uS2t
rAfGAP9cIfjFAM7/1E2LcJTfpS5ojEfBGTkaEhugBmbje2aS9gEAukiztxX5QZF7
miBBhHtTQOmeXY1giKmesLsJBhlxuAk=
=HySC
-----END PGP SIGNATURE-----

--Q0eCcL3TwOvk179G--

