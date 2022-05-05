Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B04AF51CA2D
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 22:09:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231878AbiEEUNY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 16:13:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbiEEUNW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 16:13:22 -0400
Received: from us-smtp-delivery-74.mimecast.com (us-smtp-delivery-74.mimecast.com [170.10.129.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8EC8D5F24B
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 13:09:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651781381;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=isyTAQOpnJ50Qci6kWwR+BCUDagaIaL4jDCJfOF/3QY=;
        b=SbkOUrKak+zHWfQhifv1bGK0YZLGKNjcijw4i07dP70cXsfSCzNehNdZi+x+I9M9HZqAo+
        uQduaV1ElGdj9upmDxfYh0qwKuJsFbHkefLR9z1UbKqyvZRzHCZ1wb6R93eAaT0o8o8dTh
        PVn2EXMmAzQzi9MFVaZLCTmsUROVxaM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-465-e7pfv-0IPIiluGpp5TwO0g-1; Thu, 05 May 2022 16:09:38 -0400
X-MC-Unique: e7pfv-0IPIiluGpp5TwO0g-1
Received: by mail-wm1-f70.google.com with SMTP id g3-20020a7bc4c3000000b0039409519611so2082947wmk.9
        for <netdev@vger.kernel.org>; Thu, 05 May 2022 13:09:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=isyTAQOpnJ50Qci6kWwR+BCUDagaIaL4jDCJfOF/3QY=;
        b=u4cDWv64tD1o9YXjz56Tad0GLpl7Sgv9ptIT8tyY6qWS2H59s9lZM7s4kJ6rON3+Z/
         jx0fJzJ6QnZ5p8idIPSYwM5oEens90P0LbpX0FAuq1iadEG+JO0Qvt1zR2LTjF8J7xBv
         nNG/DTIlC7JVDQlrr3skPCI3JAdcjsrtPNVEBrSgkpeDxcftqiYeBPBdW4mak47lF1dU
         hp+f+yNHgMqs9tUzYphYKbrd/WU3+2LD+C72zP+1l8EcWo3eE+cQbUL1IhJKGz0F7XVg
         Nr5V7Jstzha6WVrLyeZDG6mzk7k+Wui4puxlBFG08hQ6wytGJJM2kgkMt5aK9YzYVRki
         r3zQ==
X-Gm-Message-State: AOAM531ChoxT/xrA+huNjS8rvZJFLLa6+kfF0xWGGdSYXGwBSvhFJMbo
        59RTPifVEBcp4ottZKqWepEAzFxGWwyQi7exNy4DzD+QSIGyKZUK5ZsbCn79h4Bs9i7mcQMQ4Qq
        0pveRaNOOrHIxe99Z
X-Received: by 2002:a7b:c081:0:b0:394:789b:915 with SMTP id r1-20020a7bc081000000b00394789b0915mr26278wmh.105.1651781377116;
        Thu, 05 May 2022 13:09:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyNpu3Kq1OQpeGcBQJAWlDOeFgHLyIekOeIGdXroUkilc1GR7GLGJg7Y41bl+ujcpZFvSbDRA==
X-Received: by 2002:a7b:c081:0:b0:394:789b:915 with SMTP id r1-20020a7bc081000000b00394789b0915mr26267wmh.105.1651781376904;
        Thu, 05 May 2022 13:09:36 -0700 (PDT)
Received: from localhost (net-93-71-56-156.cust.vodafonedsl.it. [93.71.56.156])
        by smtp.gmail.com with ESMTPSA id ay33-20020a05600c1e2100b003942a244ec8sm2157597wmb.13.2022.05.05.13.09.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 13:09:36 -0700 (PDT)
Date:   Thu, 5 May 2022 22:09:34 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        tirthendu.sarkar@intel.com, daniel@iogearbox.net,
        intel-wired-lan@lists.osuosl.org, toke@redhat.com, ast@kernel.org,
        andrii@kernel.org, jbrouer@redhat.com, kuba@kernel.org,
        bpf@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
        magnus.karlsson@intel.com
Subject: Re: [Intel-wired-lan] [PATCH net-next] i40e: add xdp frags support
 to ndo_xdp_xmit
Message-ID: <YnQu/iS7zXEzKWJ0@lore-desk>
References: <c4e15c421c5579da7bfc77512e8d40b6a76beae1.1651769002.git.lorenzo@kernel.org>
 <469d3c7f-fcd1-3e8b-b02d-4b6e1826fa67@molgen.mpg.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="lvbnpHdqnGK8xMVN"
Content-Disposition: inline
In-Reply-To: <469d3c7f-fcd1-3e8b-b02d-4b6e1826fa67@molgen.mpg.de>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--lvbnpHdqnGK8xMVN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

>=20
>=20
> Am 05.05.22 um 18:48 schrieb Lorenzo Bianconi:
> > Add the capability to map non-linear xdp frames in XDP_TX and ndo_xdp_x=
mit
> > callback.
> >=20
> > Tested-by: Sarkar Tirthendu <tirthendu.sarkar@intel.com>
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >   drivers/net/ethernet/intel/i40e/i40e_txrx.c | 87 +++++++++++++++------
> >   1 file changed, 62 insertions(+), 25 deletions(-)
> >=20
> > diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/=
ethernet/intel/i40e/i40e_txrx.c
> > index 7bc1174edf6b..b7967105a549 100644
> > --- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> > +++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> > @@ -2509,6 +2509,7 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx=
_ring, int budget)
> >   			hard_start =3D page_address(rx_buffer->page) +
> >   				     rx_buffer->page_offset - offset;
> >   			xdp_prepare_buff(&xdp, hard_start, offset, size, true);
> > +			xdp_buff_clear_frags_flag(&xdp);
> >   #if (PAGE_SIZE > 4096)
> >   			/* At larger PAGE_SIZE, frame_sz depend on len size */
> >   			xdp.frame_sz =3D i40e_rx_frame_truesize(rx_ring, size);
> > @@ -3713,35 +3714,55 @@ u16 i40e_lan_select_queue(struct net_device *ne=
tdev,
> >   static int i40e_xmit_xdp_ring(struct xdp_frame *xdpf,
> >   			      struct i40e_ring *xdp_ring)
> >   {
> > -	u16 i =3D xdp_ring->next_to_use;
> > -	struct i40e_tx_buffer *tx_bi;
> > -	struct i40e_tx_desc *tx_desc;
> > +	struct skb_shared_info *sinfo =3D xdp_get_shared_info_from_frame(xdpf=
);
> > +	u8 nr_frags =3D unlikely(xdp_frame_has_frags(xdpf)) ? sinfo->nr_frags=
 : 0;
> > +	u16 i =3D 0, index =3D xdp_ring->next_to_use;
> > +	struct i40e_tx_buffer *tx_head =3D &xdp_ring->tx_bi[index];
> > +	struct i40e_tx_buffer *tx_bi =3D tx_head;
> > +	struct i40e_tx_desc *tx_desc =3D I40E_TX_DESC(xdp_ring, index);
> >   	void *data =3D xdpf->data;
> >   	u32 size =3D xdpf->len;
> > -	dma_addr_t dma;
> > -	if (!unlikely(I40E_DESC_UNUSED(xdp_ring))) {
> > +	if (unlikely(I40E_DESC_UNUSED(xdp_ring) < 1 + nr_frags)) {
> >   		xdp_ring->tx_stats.tx_busy++;
> >   		return I40E_XDP_CONSUMED;
> >   	}
> > -	dma =3D dma_map_single(xdp_ring->dev, data, size, DMA_TO_DEVICE);
> > -	if (dma_mapping_error(xdp_ring->dev, dma))
> > -		return I40E_XDP_CONSUMED;
> > -	tx_bi =3D &xdp_ring->tx_bi[i];
> > -	tx_bi->bytecount =3D size;
> > -	tx_bi->gso_segs =3D 1;
> > -	tx_bi->xdpf =3D xdpf;
> > +	tx_head->bytecount =3D xdp_get_frame_len(xdpf);
> > +	tx_head->gso_segs =3D 1;
> > +	tx_head->xdpf =3D xdpf;
> > -	/* record length, and DMA address */
> > -	dma_unmap_len_set(tx_bi, len, size);
> > -	dma_unmap_addr_set(tx_bi, dma, dma);
> > +	for (;;) {
> > +		dma_addr_t dma;
> > -	tx_desc =3D I40E_TX_DESC(xdp_ring, i);
> > -	tx_desc->buffer_addr =3D cpu_to_le64(dma);
> > -	tx_desc->cmd_type_offset_bsz =3D build_ctob(I40E_TX_DESC_CMD_ICRC
> > -						  | I40E_TXD_CMD,
> > -						  0, size, 0);
> > +		dma =3D dma_map_single(xdp_ring->dev, data, size, DMA_TO_DEVICE);
> > +		if (dma_mapping_error(xdp_ring->dev, dma))
> > +			goto unmap;
> > +
> > +		/* record length, and DMA address */
> > +		dma_unmap_len_set(tx_bi, len, size);
> > +		dma_unmap_addr_set(tx_bi, dma, dma);
> > +
> > +		tx_desc->buffer_addr =3D cpu_to_le64(dma);
> > +		tx_desc->cmd_type_offset_bsz =3D
> > +			build_ctob(I40E_TX_DESC_CMD_ICRC, 0, size, 0);
> > +
> > +		if (++index =3D=3D xdp_ring->count)
> > +			index =3D 0;
> > +
> > +		if (i =3D=3D nr_frags)
> > +			break;
> > +
> > +		tx_bi =3D &xdp_ring->tx_bi[index];
> > +		tx_desc =3D I40E_TX_DESC(xdp_ring, index);
> > +
> > +		data =3D skb_frag_address(&sinfo->frags[i]);
> > +		size =3D skb_frag_size(&sinfo->frags[i]);
> > +		i++;
> > +	}
> > +
> > +	tx_desc->cmd_type_offset_bsz |=3D
> > +		cpu_to_le64(I40E_TXD_CMD << I40E_TXD_QW1_CMD_SHIFT);
> >   	/* Make certain all of the status bits have been updated
> >   	 * before next_to_watch is written.
> > @@ -3749,14 +3770,30 @@ static int i40e_xmit_xdp_ring(struct xdp_frame =
*xdpf,
> >   	smp_wmb();
> >   	xdp_ring->xdp_tx_active++;
> > -	i++;
> > -	if (i =3D=3D xdp_ring->count)
> > -		i =3D 0;
> > -	tx_bi->next_to_watch =3D tx_desc;
> > -	xdp_ring->next_to_use =3D i;
> > +	tx_head->next_to_watch =3D tx_desc;
> > +	xdp_ring->next_to_use =3D index;
> >   	return I40E_XDP_TX;
> > +
> > +unmap:
> > +	for (;;) {
> > +		tx_bi =3D &xdp_ring->tx_bi[index];
> > +		if (dma_unmap_len(tx_bi, len))
> > +			dma_unmap_page(xdp_ring->dev,
> > +				       dma_unmap_addr(tx_bi, dma),
> > +				       dma_unmap_len(tx_bi, len),
> > +				       DMA_TO_DEVICE);
> > +		dma_unmap_len_set(tx_bi, len, 0);
> > +		if (tx_bi =3D=3D tx_head)
> > +			break;
> > +
> > +		if (!index)
> > +			index +=3D xdp_ring->count;
> > +		index--;
> > +	}
>=20
> Could
>=20
> ```
> do {
>         tx_bi =3D &xdp_ring->tx_bi[index];
>         if (dma_unmap_len(tx_bi, len))
>                 dma_unmap_page(xdp_ring->dev,
>                                dma_unmap_addr(tx_bi, dma),
>                                dma_unmap_len(tx_bi, len),
>                                DMA_TO_DEVICE);
>         dma_unmap_len_set(tx_bi, len, 0);
>=20
>         if (!index)
>                 index +=3D xdp_ring->count;
>         index--;
> } while (tx_bi !=3D tx_head);
> ```
>=20
> be used instead?

yes, it seems just a matter of test to me, doesn't it? :)

Regards,
Lorenzo

>=20
> > +
> > +	return I40E_XDP_CONSUMED;
> >   }
> >   /**
>=20
>=20
> Kind regards,
>=20
> Paul
>=20

--lvbnpHdqnGK8xMVN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYnQu/gAKCRA6cBh0uS2t
rBQbAP40dlNi8MuEWZ6WyqSv98x5ThtQS08w7wyHrSC25YddgQEA14QUSfAVsXYM
hFkS/P5KbbElkPb3gA8vSJSNBtEWfQw=
=fGwN
-----END PGP SIGNATURE-----

--lvbnpHdqnGK8xMVN--

