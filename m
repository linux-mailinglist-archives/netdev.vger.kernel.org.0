Return-Path: <netdev+bounces-2226-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8022A700D21
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 18:37:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4FBB5281CEE
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 16:37:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54FA8A32;
	Fri, 12 May 2023 16:37:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46B40210F
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 16:37:23 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 613FEA25D
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 09:37:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683909440;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ryX5sovAmXV6c1qawtyVZ+Us+777l7mLCNx8VtBdO6Q=;
	b=i6BI4hX6SCz9RHao1iXHYGwa13yR121s3JGtgz9Boicl2oZIbIORkYzAEY3VfB3CXflqy+
	FeUqf67jKCL5U1XGcoE3kbigThrj/B2wkUJoBaEcP1L/VgMKPSZSVi4N9rI2gojiYdSjNm
	1Vq6Szj2S2wMO8OUcK1F6aS0sbKN7VE=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-544-rRgFX2p1O2-c6g2B38m_BQ-1; Fri, 12 May 2023 12:37:19 -0400
X-MC-Unique: rRgFX2p1O2-c6g2B38m_BQ-1
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-3f4d7e97a37so19468291cf.0
        for <netdev@vger.kernel.org>; Fri, 12 May 2023 09:37:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683909438; x=1686501438;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ryX5sovAmXV6c1qawtyVZ+Us+777l7mLCNx8VtBdO6Q=;
        b=gKx8rNyc18/kDoxYyrEFYUTteABeh38a2RRZ3+jsV/i59H8/CWRz9rPSDOS08Cw3nu
         hf59HazGdAcyikZgm8VVEjifQnJqBJyRruXjUoOcdjJBQVP74ToWR7kcqaDDNHXkZp46
         3WhqLGatgY7IEPP+XRHkb3dkYAbGbVUM8b0cjclfcjPdSa3pAgEtfWMrlvG1la/KTDrN
         A5qbBHpWp4NmVdjLS8JwdP4XznLUoTb8k1f8KW5ITPOH63h4p0gv2PPRG4b8B9Qgf11J
         h4GpjHNSSuy75MpTulBaGlykB6RInYi+afe2jnI3guJv+JIaxMSYLhHlfNsEWGWLAabo
         Egqg==
X-Gm-Message-State: AC+VfDz4dXPXgpeDg+gQMD268CLyYarFgH8ivxKJqQ3OdmxJk2CoXAa6
	Yn4NycGssPJHF1zuoIBA9v4sXj1+6n4Ph6PD4pTTkwv6jComucvpSOHiWMDxv1JosiRPA13xgOZ
	lcr2E/hQMLZ/eVJ4L
X-Received: by 2002:a05:622a:1441:b0:3e6:4b7b:250 with SMTP id v1-20020a05622a144100b003e64b7b0250mr38562981qtx.25.1683909438720;
        Fri, 12 May 2023 09:37:18 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6o892SUq2q7IoDztPxxSs8dPIhgSg2bX0bcnDACuZVhTgium0mRlZboNQGlt/vZAlhkyMFew==
X-Received: by 2002:a05:622a:1441:b0:3e6:4b7b:250 with SMTP id v1-20020a05622a144100b003e64b7b0250mr38562954qtx.25.1683909438451;
        Fri, 12 May 2023 09:37:18 -0700 (PDT)
Received: from redhat.com ([37.19.196.5])
        by smtp.gmail.com with ESMTPSA id l12-20020ac8078c000000b003e9c6a4a381sm3184802qth.54.2023.05.12.09.37.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 May 2023 09:37:18 -0700 (PDT)
Date: Fri, 12 May 2023 12:37:12 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Feng Liu <feliu@nvidia.com>
Cc: virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Simon Horman <simon.horman@corigine.com>,
	Bodong Wang <bodong@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
	William Tu <witu@nvidia.com>
Subject: Re: [PATCH net v6] virtio_net: Fix error unwinding of XDP
 initialization
Message-ID: <20230512123705-mutt-send-email-mst@kernel.org>
References: <20230512151812.1806-1-feliu@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230512151812.1806-1-feliu@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 12, 2023 at 11:18:12AM -0400, Feng Liu wrote:
> When initializing XDP in virtnet_open(), some rq xdp initialization
> may hit an error causing net device open failed. However, previous
> rqs have already initialized XDP and enabled NAPI, which is not the
> expected behavior. Need to roll back the previous rq initialization
> to avoid leaks in error unwinding of init code.
> 
> Also extract helper functions of disable and enable queue pairs.
> Use newly introduced disable helper function in error unwinding and
> virtnet_close. Use enable helper function in virtnet_open.
> 
> Fixes: 754b8a21a96d ("virtio_net: setup xdp_rxq_info")
> Signed-off-by: Feng Liu <feliu@nvidia.com>
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>
> Reviewed-by: William Tu <witu@nvidia.com>

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
> v5 -> v6
> feedbacks from Xuan Zhuo
> - add disable_delayed_refill and cancel_delayed_work_sync
> 
> v4 -> v5
> feedbacks from Michael S. Tsirkin
> - rename helper as virtnet_disable_queue_pair
> - rename helper as virtnet_enable_queue_pair
> 
> v3 -> v4
> feedbacks from Jiri Pirko
> - Add symmetric helper function virtnet_enable_qp to enable queues.
> - Error handle:  cleanup current queue pair in virtnet_enable_qp,
>   and complete the reset queue pairs cleanup in virtnet_open.
> - Fix coding style.
> feedbacks from Parav Pandit
> - Remove redundant debug message and white space.
> 
> v2 -> v3
> feedbacks from Michael S. Tsirkin
> - Remove redundant comment.
> 
> v1 -> v2
> feedbacks from Michael S. Tsirkin
> - squash two patches together.
> 
> ---
>  drivers/net/virtio_net.c | 61 +++++++++++++++++++++++++++++-----------
>  1 file changed, 44 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index a12ae26db0e2..56ca1d270304 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -1868,6 +1868,38 @@ static int virtnet_poll(struct napi_struct *napi, int budget)
>  	return received;
>  }
>  
> +static void virtnet_disable_queue_pair(struct virtnet_info *vi, int qp_index)
> +{
> +	virtnet_napi_tx_disable(&vi->sq[qp_index].napi);
> +	napi_disable(&vi->rq[qp_index].napi);
> +	xdp_rxq_info_unreg(&vi->rq[qp_index].xdp_rxq);
> +}
> +
> +static int virtnet_enable_queue_pair(struct virtnet_info *vi, int qp_index)
> +{
> +	struct net_device *dev = vi->dev;
> +	int err;
> +
> +	err = xdp_rxq_info_reg(&vi->rq[qp_index].xdp_rxq, dev, qp_index,
> +			       vi->rq[qp_index].napi.napi_id);
> +	if (err < 0)
> +		return err;
> +
> +	err = xdp_rxq_info_reg_mem_model(&vi->rq[qp_index].xdp_rxq,
> +					 MEM_TYPE_PAGE_SHARED, NULL);
> +	if (err < 0)
> +		goto err_xdp_reg_mem_model;
> +
> +	virtnet_napi_enable(vi->rq[qp_index].vq, &vi->rq[qp_index].napi);
> +	virtnet_napi_tx_enable(vi, vi->sq[qp_index].vq, &vi->sq[qp_index].napi);
> +
> +	return 0;
> +
> +err_xdp_reg_mem_model:
> +	xdp_rxq_info_unreg(&vi->rq[qp_index].xdp_rxq);
> +	return err;
> +}
> +
>  static int virtnet_open(struct net_device *dev)
>  {
>  	struct virtnet_info *vi = netdev_priv(dev);
> @@ -1881,22 +1913,20 @@ static int virtnet_open(struct net_device *dev)
>  			if (!try_fill_recv(vi, &vi->rq[i], GFP_KERNEL))
>  				schedule_delayed_work(&vi->refill, 0);
>  
> -		err = xdp_rxq_info_reg(&vi->rq[i].xdp_rxq, dev, i, vi->rq[i].napi.napi_id);
> +		err = virtnet_enable_queue_pair(vi, i);
>  		if (err < 0)
> -			return err;
> -
> -		err = xdp_rxq_info_reg_mem_model(&vi->rq[i].xdp_rxq,
> -						 MEM_TYPE_PAGE_SHARED, NULL);
> -		if (err < 0) {
> -			xdp_rxq_info_unreg(&vi->rq[i].xdp_rxq);
> -			return err;
> -		}
> -
> -		virtnet_napi_enable(vi->rq[i].vq, &vi->rq[i].napi);
> -		virtnet_napi_tx_enable(vi, vi->sq[i].vq, &vi->sq[i].napi);
> +			goto err_enable_qp;
>  	}
>  
>  	return 0;
> +
> +err_enable_qp:
> +	disable_delayed_refill(vi);
> +	cancel_delayed_work_sync(&vi->refill);
> +
> +	for (i--; i >= 0; i--)
> +		virtnet_disable_queue_pair(vi, i);
> +	return err;
>  }
>  
>  static int virtnet_poll_tx(struct napi_struct *napi, int budget)
> @@ -2305,11 +2335,8 @@ static int virtnet_close(struct net_device *dev)
>  	/* Make sure refill_work doesn't re-enable napi! */
>  	cancel_delayed_work_sync(&vi->refill);
>  
> -	for (i = 0; i < vi->max_queue_pairs; i++) {
> -		virtnet_napi_tx_disable(&vi->sq[i].napi);
> -		napi_disable(&vi->rq[i].napi);
> -		xdp_rxq_info_unreg(&vi->rq[i].xdp_rxq);
> -	}
> +	for (i = 0; i < vi->max_queue_pairs; i++)
> +		virtnet_disable_queue_pair(vi, i);
>  
>  	return 0;
>  }
> -- 
> 2.37.1 (Apple Git-137.1)


