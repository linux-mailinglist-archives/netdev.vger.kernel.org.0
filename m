Return-Path: <netdev+bounces-7629-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 91927720E1E
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 08:31:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3D45C281BB5
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 06:31:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EBDC8464;
	Sat,  3 Jun 2023 06:31:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53539EA0
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 06:31:48 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B820DE58
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 23:31:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685773905;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mcYCuXu6ZuvMSVCC5fWCA6ob8fq2YImtlnZiWjW4mb8=;
	b=MmEMfzJLclNrhErrTTAESXizK4upf8CHHD5sZhZZ/A9DxpmrRurx8E4QOcVDL4gCNV5OhJ
	OCABj7xqTryMquSEhKsWOTYST+Finbj6n3HFNJcquHZq5GJjWKJ5sYLBUBWgdb/4bqKMDS
	1LLfs8fc901X4rtVL7l0+EMdjxGCiA0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-126-cGwNQqHKPM2CXqfi171Ohg-1; Sat, 03 Jun 2023 02:31:43 -0400
X-MC-Unique: cGwNQqHKPM2CXqfi171Ohg-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-3f6ffc2b423so3993125e9.0
        for <netdev@vger.kernel.org>; Fri, 02 Jun 2023 23:31:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685773902; x=1688365902;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mcYCuXu6ZuvMSVCC5fWCA6ob8fq2YImtlnZiWjW4mb8=;
        b=C/IfgwwXnkBcCoHfFFcMT5QTHQ3Oo8Z0MjvRxrTObOLyT8BfHXqzIHRRwjiV5RmxrL
         AWDiJgZ6doO2nPW2+/8CucuPZkQYcfSLzVLHF0fUmfLIqcAG1h1H7RhPpxGAWkKunxbC
         MjQOMSeAsj5snJ/2zv7Esx4b5gyO1r/Bh3wKkRJy+lhLMXQus9FWZ2djrNkKkl93PsgY
         KpSEGJYLstjiC29abRa0iUfPaEiPINDHUaZuXFoyoXqcJ8hV9ltTDoJogMboy+Ti4Qzj
         PXEOiXPjJRGJX0VQ5aRTp5cD6aPw5C7ZaDytZmEA5V6vKEcUpz94dKP8ssE/OE+QzxHf
         WcbQ==
X-Gm-Message-State: AC+VfDzacKNyN3uDOeIIrEFyn0hEfQg35p8WmiT+bQ8YcVjuZHzH/lz6
	QuKiasvzzBCDo/mWFhmHSvTVjwMXqut90D6HgDxngDH2dtwmOmOhw0IdJ6ci3CGAgq5Cks6wUzO
	7MMutf6ZSUDmSNwjA
X-Received: by 2002:adf:fd84:0:b0:30a:e5e8:c298 with SMTP id d4-20020adffd84000000b0030ae5e8c298mr7836984wrr.3.1685773902643;
        Fri, 02 Jun 2023 23:31:42 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5paMXCww7rTmuBpTRqnITD9P4YojlKyrnmJlg4GbZfFYNJ7JMguCYefWuS2jerBqGsMuthxw==
X-Received: by 2002:adf:fd84:0:b0:30a:e5e8:c298 with SMTP id d4-20020adffd84000000b0030ae5e8c298mr7836975wrr.3.1685773902283;
        Fri, 02 Jun 2023 23:31:42 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-240-111.dyn.eolo.it. [146.241.240.111])
        by smtp.gmail.com with ESMTPSA id r1-20020a5d52c1000000b0030ae69920c9sm3522230wrv.53.2023.06.02.23.31.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jun 2023 23:31:41 -0700 (PDT)
Message-ID: <71bf3e779f59c2417c42293841b76b32eb32a790.camel@redhat.com>
Subject: Re: [net-next/RFC PATCH v1 2/4] net: Add support for associating
 napi with queue[s]
From: Paolo Abeni <pabeni@redhat.com>
To: Amritha Nambiar <amritha.nambiar@intel.com>, netdev@vger.kernel.org, 
	kuba@kernel.org, davem@davemloft.net
Cc: sridhar.samudrala@intel.com
Date: Sat, 03 Jun 2023 08:31:40 +0200
In-Reply-To: <168564135094.7284.9691772825401908320.stgit@anambiarhost.jf.intel.com>
References: 
	<168564116688.7284.6877238631049679250.stgit@anambiarhost.jf.intel.com>
	 <168564135094.7284.9691772825401908320.stgit@anambiarhost.jf.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, 2023-06-01 at 10:42 -0700, Amritha Nambiar wrote:
> After the napi context is initialized, map the napi instance
> with the queue/queue-set on the corresponding irq line.
>=20
> Signed-off-by: Amritha Nambiar <amritha.nambiar@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_lib.c  |   57 +++++++++++++++++++++++=
++++++
>  drivers/net/ethernet/intel/ice/ice_lib.h  |    4 ++
>  drivers/net/ethernet/intel/ice/ice_main.c |    4 ++
>  include/linux/netdevice.h                 |   11 ++++++
>  net/core/dev.c                            |   34 +++++++++++++++++
>  5 files changed, 109 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ether=
net/intel/ice/ice_lib.c
> index 5ddb95d1073a..58f68363119f 100644
> --- a/drivers/net/ethernet/intel/ice/ice_lib.c
> +++ b/drivers/net/ethernet/intel/ice/ice_lib.c
> @@ -2478,6 +2478,12 @@ ice_vsi_cfg_def(struct ice_vsi *vsi, struct ice_vs=
i_cfg_params *params)
>  			goto unroll_vector_base;
> =20
>  		ice_vsi_map_rings_to_vectors(vsi);
> +
> +		/* Associate q_vector rings to napi */
> +		ret =3D ice_vsi_add_napi_queues(vsi);
> +		if (ret)
> +			goto unroll_vector_base;
> +
>  		vsi->stat_offsets_loaded =3D false;
> =20
>  		if (ice_is_xdp_ena_vsi(vsi)) {
> @@ -2957,6 +2963,57 @@ void ice_vsi_dis_irq(struct ice_vsi *vsi)
>  		synchronize_irq(vsi->q_vectors[i]->irq.virq);
>  }
> =20
> +/**
> + * ice_q_vector_add_napi_queues - Add queue[s] associated with the napi
> + * @q_vector: q_vector pointer
> + *
> + * Associate the q_vector napi with all the queue[s] on the vector
> + * Returns 0 on success or < 0 on error
> + */
> +int ice_q_vector_add_napi_queues(struct ice_q_vector *q_vector)
> +{
> +	struct ice_rx_ring *rx_ring;
> +	struct ice_tx_ring *tx_ring;
> +	int ret;
> +
> +	ice_for_each_rx_ring(rx_ring, q_vector->rx) {
> +		ret =3D netif_napi_add_queue(&q_vector->napi, rx_ring->q_index,
> +					   NAPI_RX_CONTAINER);
> +		if (ret)
> +			return ret;
> +	}
> +	ice_for_each_tx_ring(tx_ring, q_vector->tx) {
> +		ret =3D netif_napi_add_queue(&q_vector->napi, tx_ring->q_index,
> +					   NAPI_TX_CONTAINER);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	return ret;
> +}
> +
> +/**
> + * ice_vsi_add_napi_queues
> + * @vsi: VSI pointer
> + *
> + * Associate queue[s] with napi for all vectors
> + * Returns 0 on success or < 0 on error
> + */
> +int ice_vsi_add_napi_queues(struct ice_vsi *vsi)
> +{
> +	int i, ret =3D 0;
> +
> +	if (!vsi->netdev)
> +		return ret;
> +
> +	ice_for_each_q_vector(vsi, i) {
> +		ret =3D ice_q_vector_add_napi_queues(vsi->q_vectors[i]);
> +		if (ret)
> +			return ret;
> +	}
> +	return ret;
> +}
> +
>  /**
>   * ice_napi_del - Remove NAPI handler for the VSI
>   * @vsi: VSI for which NAPI handler is to be removed
> diff --git a/drivers/net/ethernet/intel/ice/ice_lib.h b/drivers/net/ether=
net/intel/ice/ice_lib.h
> index e985766e6bb5..623b5f738a5c 100644
> --- a/drivers/net/ethernet/intel/ice/ice_lib.h
> +++ b/drivers/net/ethernet/intel/ice/ice_lib.h
> @@ -93,6 +93,10 @@ void ice_vsi_cfg_netdev_tc(struct ice_vsi *vsi, u8 ena=
_tc);
>  struct ice_vsi *
>  ice_vsi_setup(struct ice_pf *pf, struct ice_vsi_cfg_params *params);
> =20
> +int ice_q_vector_add_napi_queues(struct ice_q_vector *q_vector);
> +
> +int ice_vsi_add_napi_queues(struct ice_vsi *vsi);
> +
>  void ice_napi_del(struct ice_vsi *vsi);
> =20
>  int ice_vsi_release(struct ice_vsi *vsi);
> diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethe=
rnet/intel/ice/ice_main.c
> index 62e91512aeab..c66ff1473aeb 100644
> --- a/drivers/net/ethernet/intel/ice/ice_main.c
> +++ b/drivers/net/ethernet/intel/ice/ice_main.c
> @@ -3348,9 +3348,11 @@ static void ice_napi_add(struct ice_vsi *vsi)
>  	if (!vsi->netdev)
>  		return;
> =20
> -	ice_for_each_q_vector(vsi, v_idx)
> +	ice_for_each_q_vector(vsi, v_idx) {
>  		netif_napi_add(vsi->netdev, &vsi->q_vectors[v_idx]->napi,
>  			       ice_napi_poll);
> +		ice_q_vector_add_napi_queues(vsi->q_vectors[v_idx]);
> +	}
>  }
> =20
>  /**
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 49f64401af7c..a562db712c6e 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -342,6 +342,14 @@ struct gro_list {
>   */
>  #define GRO_HASH_BUCKETS	8
> =20
> +/*
> + * napi queue container type
> + */
> +enum napi_container_type {
> +	NAPI_RX_CONTAINER,
> +	NAPI_TX_CONTAINER,
> +};
> +
>  struct napi_queue {
>  	struct list_head	q_list;
>  	u16			queue_index;
> @@ -2622,6 +2630,9 @@ static inline void *netdev_priv(const struct net_de=
vice *dev)
>   */
>  #define SET_NETDEV_DEVTYPE(net, devtype)	((net)->dev.type =3D (devtype))
> =20
> +int netif_napi_add_queue(struct napi_struct *napi, u16 queue_index,
> +			 enum napi_container_type);
> +
>  /* Default NAPI poll() weight
>   * Device drivers are strongly advised to not use bigger value
>   */
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 9ee8eb3ef223..ba712119ec85 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -6366,6 +6366,40 @@ int dev_set_threaded(struct net_device *dev, bool =
threaded)
>  }
>  EXPORT_SYMBOL(dev_set_threaded);
> =20
> +/**
> + * netif_napi_add_queue - Associate queue with the napi
> + * @napi: NAPI context
> + * @queue_index: Index of queue
> + * @napi_container_type: queue type as RX or TX
> + *
> + * Add queue with its corresponding napi context
> + */
> +int netif_napi_add_queue(struct napi_struct *napi, u16 queue_index,
> +			 enum napi_container_type type)
> +{
> +	struct napi_queue *napi_queue;
> +
> +	napi_queue =3D kzalloc(sizeof(*napi_queue), GFP_KERNEL);
> +	if (!napi_queue)
> +		return -ENOMEM;
> +
> +	napi_queue->queue_index =3D queue_index;
> +
> +	switch (type) {
> +	case NAPI_RX_CONTAINER:
> +		list_add_rcu(&napi_queue->q_list, &napi->napi_rxq_list);
> +		break;
> +	case NAPI_TX_CONTAINER:
> +		list_add_rcu(&napi_queue->q_list, &napi->napi_txq_list);
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(netif_napi_add_queue);
> +
>  void netif_napi_add_weight(struct net_device *dev, struct napi_struct *n=
api,
>  			   int (*poll)(struct napi_struct *, int), int weight)
>  {
>=20

I think this later 2 chunks are a better fit for the previous patch, so
that here there will be only driver-related changes.

Also it looks like the napi-queue APIs are going to grow a bit. Perhaps
it would be useful move all that new code in a separated file? dev.c is
already pretty big.

Thanks!

Paolo


