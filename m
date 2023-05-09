Return-Path: <netdev+bounces-1033-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C52366FBE51
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 06:43:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 84B0828125E
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 04:43:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AF61191;
	Tue,  9 May 2023 04:42:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECD6F20EB
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 04:42:53 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A9757688
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 21:42:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683607370;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=W7lkveXXMx28z2hQQkgi6XifNwekRx4w5U94EsCpzfo=;
	b=TG2ZWeNKZFsGST2PvpfMl3tGc6OMDLD6MXZiIUINq+XwLKf2CSycbaJZ5qy3/kvZulo+Sq
	4NpoCFGxxX4XoL9jOUHu22WHBDAXrC6rYOLB7F4TRXqhkPghVDsi28oP2NJS9R/Y7I3Bv4
	d2UdI4ppyHrQWsb83KJKWsM4goBagf4=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-674-YHqJkPVrP66Nv0wxmSUIAQ-1; Tue, 09 May 2023 00:42:49 -0400
X-MC-Unique: YHqJkPVrP66Nv0wxmSUIAQ-1
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-7577727a00eso744714085a.1
        for <netdev@vger.kernel.org>; Mon, 08 May 2023 21:42:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683607368; x=1686199368;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W7lkveXXMx28z2hQQkgi6XifNwekRx4w5U94EsCpzfo=;
        b=VoWyf0A/fgoc/mRCMBUiiSkZOHMUSbF3JRj4VfJJ3o2ZL+P9V+qnAPssqj2/dEOCDr
         oKnWp+LtD8N4SWvCKBrjmiNRbrtonjitN3vD3LLcsIK0wgeqmRTHUW1npMZfJIKHB0cz
         AxACrVyOanxbkBKXFgkwTIc3abSTZlIn0r3Oyr9HprUyGRv758fi6F9MZmyw7Xdycs9+
         ZJSziGF1e4xtXTwUBGPa0LCw2OS88+oEZTxzs60syHy7cmqRblHujIp4H7dIDnSrTd/T
         hiMg1x2pTcTjSxyiVFMB5IRgvyOYoIEFQOnpOyZGEjjfZt+3PgblHoNMw3R7JAcpPnQX
         fU3A==
X-Gm-Message-State: AC+VfDys5q7/EpukFv7NHyaKEW40jCUy8vOxo4ZP9ne7uc3UIKqkJFSE
	i4afcwNZFXqOlaaXFjdrXiDAvH6N6UI8QFPfc38pQvTzbbAia4aBkUXiyUs4mxJArKUgGvK/Jj3
	gZ5/U+HA0XS2fkZmra4A6/NGlCDg=
X-Received: by 2002:a05:6214:408:b0:5dd:b986:b44 with SMTP id z8-20020a056214040800b005ddb9860b44mr22544262qvx.6.1683607368249;
        Mon, 08 May 2023 21:42:48 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6j3iab8C9dTm3YoE+9qDG5jkVMfm91YDSkfYW2q1isW0mgFLBflIC9pEd53x+/Sn1pYDGxFw==
X-Received: by 2002:a05:6214:408:b0:5dd:b986:b44 with SMTP id z8-20020a056214040800b005ddb9860b44mr22544245qvx.6.1683607367963;
        Mon, 08 May 2023 21:42:47 -0700 (PDT)
Received: from redhat.com ([185.187.243.118])
        by smtp.gmail.com with ESMTPSA id r3-20020a0ce283000000b005dd8b9345aesm492559qvl.70.2023.05.08.21.42.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 21:42:47 -0700 (PDT)
Date: Tue, 9 May 2023 00:42:39 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Feng Liu <feliu@nvidia.com>
Cc: virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Simon Horman <simon.horman@corigine.com>,
	Bodong Wang <bodong@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH net v4] virtio_net: Fix error unwinding of XDP
 initialization
Message-ID: <20230509004010-mutt-send-email-mst@kernel.org>
References: <20230508222708.68281-1-feliu@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230508222708.68281-1-feliu@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 08, 2023 at 06:27:08PM -0400, Feng Liu wrote:
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
> ---
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
>  drivers/net/virtio_net.c | 58 ++++++++++++++++++++++++++++------------
>  1 file changed, 41 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 8d8038538fc4..df7c08048fa7 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -1868,6 +1868,38 @@ static int virtnet_poll(struct napi_struct *napi, int budget)
>  	return received;
>  }
>  
> +static void virtnet_disable_qp(struct virtnet_info *vi, int qp_index)


I am guessing _qp stands for queue pair? Let's call it
virtnet_disable_queue_pair please, consistently with max_queue_pairs.

> +{
> +	virtnet_napi_tx_disable(&vi->sq[qp_index].napi);
> +	napi_disable(&vi->rq[qp_index].napi);
> +	xdp_rxq_info_unreg(&vi->rq[qp_index].xdp_rxq);
> +}
> +
> +static int virtnet_enable_qp(struct virtnet_info *vi, int qp_index)

Similarly, virtnet_enable_queue_pair

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
> @@ -1881,22 +1913,17 @@ static int virtnet_open(struct net_device *dev)
>  			if (!try_fill_recv(vi, &vi->rq[i], GFP_KERNEL))
>  				schedule_delayed_work(&vi->refill, 0);
>  
> -		err = xdp_rxq_info_reg(&vi->rq[i].xdp_rxq, dev, i, vi->rq[i].napi.napi_id);
> +		err = virtnet_enable_qp(vi, i);
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
> +	for (i--; i >= 0; i--)
> +		virtnet_disable_qp(vi, i);
> +	return err;
>  }
>  
>  static int virtnet_poll_tx(struct napi_struct *napi, int budget)
> @@ -2305,11 +2332,8 @@ static int virtnet_close(struct net_device *dev)
>  	/* Make sure refill_work doesn't re-enable napi! */
>  	cancel_delayed_work_sync(&vi->refill);
>  
> -	for (i = 0; i < vi->max_queue_pairs; i++) {
> -		virtnet_napi_tx_disable(&vi->sq[i].napi);
> -		napi_disable(&vi->rq[i].napi);
> -		xdp_rxq_info_unreg(&vi->rq[i].xdp_rxq);
> -	}
> +	for (i = 0; i < vi->max_queue_pairs; i++)
> +		virtnet_disable_qp(vi, i);
>  
>  	return 0;
>  }
> -- 
> 2.37.1 (Apple Git-137.1)


