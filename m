Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2D1A4FF166
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 10:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233666AbiDMIJS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 04:09:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233364AbiDMIJP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 04:09:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2E77922B30
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 01:06:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649837214;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3oVDDbPJyK3HgpM5oKcpbE9J9tBIr9ChlAXnnhFjPGo=;
        b=VJekOwGbLy7d1Uvdnd974Z1VOkxCkal8E4PikuOfzh54STCpjdgSs3prB2WhIbccHCZ9c3
        TfdsvZG54Elk6DqOXHJKUcpdYGFLFIy3Wc5W4PYCBxpS8rh71rSMB4UoM2fnGmMOwMfIby
        ZhNkoxIvSYLJmfjrZDZ+iYrNg0NAJuI=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-616-rA6KrmNXMSuznLHx5d2Few-1; Wed, 13 Apr 2022 04:06:51 -0400
X-MC-Unique: rA6KrmNXMSuznLHx5d2Few-1
Received: by mail-pg1-f197.google.com with SMTP id q13-20020a638c4d000000b003821725ad66so702929pgn.23
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 01:06:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=3oVDDbPJyK3HgpM5oKcpbE9J9tBIr9ChlAXnnhFjPGo=;
        b=0rt5wco6/pdy5oEsS3m3sUVZlDd9e/ggPyenTZ8G4Q0UhIxk9/mSSCmqD1rvNRJhKF
         MRrlTSe5APkV4Qfnvfu+gUw8Z5xFoCqkvOWfLLUpwXYnUsfuYluL+CER4BJi4K8PO+lz
         XDpq993PtZ0cYZ9FpbVGJ34eiG3JdZglzE4+4K3JSskYEQb85W8i4hmvlJPHKXmeTUG0
         CcCLSFxX3EYk7Wm+RdFPsRNSPcGq/PYpKlVF1Hkmh83IEq0LBl6QFGkT6HjM1vn0wsiq
         6E7xI6HIhqRLom/BC4Q4kIZEmCuOYv/0V61EPZnUh2ei4455YxZwpdYxNlpUYLI77ww8
         S8nQ==
X-Gm-Message-State: AOAM530/l5Hkbi9ZIq77MCM1z1xfCqErNzCloYNUnMQFxmEAVORzzqod
        D6RQWxFlrLGUsaAugwOZ7bm8ewyT0I6lBHPimZbvgal7d7IpKhARdXAU6SLPITysM7paeUTDBSc
        nuMPPazC00XJSkhgE
X-Received: by 2002:a17:90b:1e06:b0:1cb:b742:ba0d with SMTP id pg6-20020a17090b1e0600b001cbb742ba0dmr9526922pjb.24.1649837209897;
        Wed, 13 Apr 2022 01:06:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxA8440BQVqz6KdwXBOHrMtT4WnGyMxsQffyGtbEDMm0ObQF/C2qu9IScvqE/FloA/61fylAQ==
X-Received: by 2002:a17:90b:1e06:b0:1cb:b742:ba0d with SMTP id pg6-20020a17090b1e0600b001cbb742ba0dmr9526892pjb.24.1649837209610;
        Wed, 13 Apr 2022 01:06:49 -0700 (PDT)
Received: from [10.72.13.223] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id p10-20020a17090a680a00b001c7bf7d32f9sm1982517pjj.55.2022.04.13.01.06.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Apr 2022 01:06:49 -0700 (PDT)
Message-ID: <96d1fe97-2e8a-ae8a-a35f-bba2ce0f44b4@redhat.com>
Date:   Wed, 13 Apr 2022 16:06:33 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH v9 32/32] virtio_net: support set_ringparam
Content-Language: en-US
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        virtualization@lists.linux-foundation.org
Cc:     Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        Vadim Pasternak <vadimp@nvidia.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        linux-um@lists.infradead.org, netdev@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, bpf@vger.kernel.org
References: <20220406034346.74409-1-xuanzhuo@linux.alibaba.com>
 <20220406034346.74409-33-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220406034346.74409-33-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/4/6 上午11:43, Xuan Zhuo 写道:
> Support set_ringparam based on virtio queue reset.
>
> Users can use ethtool -G eth0 <ring_num> to modify the ring size of
> virtio-net.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>


Acked-by: Jason Wang <jasowang@redhat.com>

(One thing that I see is that, when resize fails, the param reported via 
get_ringparam might be wrong, this is a corner case but might worth to 
fix in the future).


> ---
>   drivers/net/virtio_net.c | 47 ++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 47 insertions(+)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index ba6859f305f7..37e4e27f1e4e 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -2264,6 +2264,52 @@ static void virtnet_get_ringparam(struct net_device *dev,
>   	ring->tx_pending = virtqueue_get_vring_size(vi->sq[0].vq);
>   }
>   
> +static int virtnet_set_ringparam(struct net_device *dev,
> +				 struct ethtool_ringparam *ring,
> +				 struct kernel_ethtool_ringparam *kernel_ring,
> +				 struct netlink_ext_ack *extack)
> +{
> +	struct virtnet_info *vi = netdev_priv(dev);
> +	u32 rx_pending, tx_pending;
> +	struct receive_queue *rq;
> +	struct send_queue *sq;
> +	int i, err;
> +
> +	if (ring->rx_mini_pending || ring->rx_jumbo_pending)
> +		return -EINVAL;
> +
> +	rx_pending = virtqueue_get_vring_size(vi->rq[0].vq);
> +	tx_pending = virtqueue_get_vring_size(vi->sq[0].vq);
> +
> +	if (ring->rx_pending == rx_pending &&
> +	    ring->tx_pending == tx_pending)
> +		return 0;
> +
> +	if (ring->rx_pending > virtqueue_get_vring_max_size(vi->rq[0].vq))
> +		return -EINVAL;
> +
> +	if (ring->tx_pending > virtqueue_get_vring_max_size(vi->sq[0].vq))
> +		return -EINVAL;
> +
> +	for (i = 0; i < vi->max_queue_pairs; i++) {
> +		rq = vi->rq + i;
> +		sq = vi->sq + i;
> +
> +		if (ring->tx_pending != tx_pending) {
> +			err = virtnet_tx_resize(vi, sq, ring->tx_pending);
> +			if (err)
> +				return err;
> +		}
> +
> +		if (ring->rx_pending != rx_pending) {
> +			err = virtnet_rx_resize(vi, rq, ring->rx_pending);
> +			if (err)
> +				return err;
> +		}
> +	}
> +
> +	return 0;
> +}
>   
>   static void virtnet_get_drvinfo(struct net_device *dev,
>   				struct ethtool_drvinfo *info)
> @@ -2497,6 +2543,7 @@ static const struct ethtool_ops virtnet_ethtool_ops = {
>   	.get_drvinfo = virtnet_get_drvinfo,
>   	.get_link = ethtool_op_get_link,
>   	.get_ringparam = virtnet_get_ringparam,
> +	.set_ringparam = virtnet_set_ringparam,
>   	.get_strings = virtnet_get_strings,
>   	.get_sset_count = virtnet_get_sset_count,
>   	.get_ethtool_stats = virtnet_get_ethtool_stats,

