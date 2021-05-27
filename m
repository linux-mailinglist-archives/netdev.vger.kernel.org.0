Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C80B392613
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 06:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbhE0EYF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 00:24:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45504 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229453AbhE0EYE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 00:24:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622089352;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OAGVZlyn+FPPGIT5k/Jxmg610YPRZpRAynqprUWUe3g=;
        b=IBWBbmBvgXv4ZTb+lCmaAiwg893v2aHKsA/g4ySZEBPnXkhmoOkGFpClLBt2WR3rkAjB7a
        ZbB8FqP1/hMXN20B4HvSm+IaDK9FA9jEkvBblfhA/DnMNK0TCDPqlZ2HRiC3UYOCqkoYro
        v1iYOMfZTla7zcrgObc0GGJW5DrDo5Q=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-558-2mJBB3MqP_uHlFILxrftsw-1; Thu, 27 May 2021 00:22:30 -0400
X-MC-Unique: 2mJBB3MqP_uHlFILxrftsw-1
Received: by mail-pj1-f69.google.com with SMTP id j8-20020a17090a94c8b029015f7f304d3cso1771099pjw.2
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 21:22:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=OAGVZlyn+FPPGIT5k/Jxmg610YPRZpRAynqprUWUe3g=;
        b=eXFI5n04KDC8i2wGfVl/M4ms3IM2W7DgchURYfd07PtKTe3Q2GPnaaV9l+HVMYeeim
         Kex/CJqAltJHxVsQXhtVSDplZhomnXNLYwr/osdtJp7eHPltCSoI+AS9iiVkLQd1nyUD
         S/fcs2GwCMCOIZBep+4FjlIIpcqc9mX/AbaQl/9ZuiHea56Z9+JZny1XsGVrCdUj2SM4
         1SZr2BioqOdFxP60be7s5lFynX6F+BGGfHnrGqVXgpQYMmSIGd+pd9t7nxXd2zaEFV3l
         Qu5nI4XvdXbmSx5VXfsowRRIKrL2+ns1SYfx8W7PnTtI38cznb7y5Rytm5ehTHOPiW5z
         qSkA==
X-Gm-Message-State: AOAM533fxazQY2ix8paKRG6XE/6iUMu5oiTnaPQ13yP2G6odtwb+c4z6
        M9jLvo752EtU42cU7E4htnCGGeJWiCgPNYsQV5tL5jcVEa7RCY4Gnh/HiCyst7W7SbiIpM0vF4U
        zXF3IEgxHWLxC0t3u
X-Received: by 2002:aa7:8ec4:0:b029:2e6:54e2:3055 with SMTP id b4-20020aa78ec40000b02902e654e23055mr1876350pfr.15.1622089348980;
        Wed, 26 May 2021 21:22:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzyd2eT/V1Ms2ZM7PWLESpRQekmEteUSwxxEgZMT8D6lNlMWkAWMl4EbTD5ypfjP5ICL6WJPw==
X-Received: by 2002:aa7:8ec4:0:b029:2e6:54e2:3055 with SMTP id b4-20020aa78ec40000b02902e654e23055mr1876329pfr.15.1622089348681;
        Wed, 26 May 2021 21:22:28 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w189sm618069pfb.46.2021.05.26.21.22.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 May 2021 21:22:28 -0700 (PDT)
Subject: Re: [PATCH net-next] virtio_net: set link state down when virtqueue
 is broken
To:     wangyunjian <wangyunjian@huawei.com>, netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, mst@redhat.com,
        virtualization@lists.linux-foundation.org, dingxiaoxiong@huawei.com
References: <79907bf6c835572b4af92f16d9a3ff2822b1c7ea.1622028946.git.wangyunjian@huawei.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <03c68dd1-a636-9d3b-1dec-5e11c8025ccc@redhat.com>
Date:   Thu, 27 May 2021 12:22:20 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <79907bf6c835572b4af92f16d9a3ff2822b1c7ea.1622028946.git.wangyunjian@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/5/26 下午7:39, wangyunjian 写道:
> From: Yunjian Wang <wangyunjian@huawei.com>
>
> The NIC can't receive/send packets if a rx/tx virtqueue is broken.
> However, the link state of the NIC is still normal. As a result,
> the user cannot detect the NIC exception.


Doesn't we have:

        /* This should not happen! */
         if (unlikely(err)) {
                 dev->stats.tx_fifo_errors++;
                 if (net_ratelimit())
                         dev_warn(&dev->dev,
                                  "Unexpected TXQ (%d) queue failure: %d\n",
                                  qnum, err);
                 dev->stats.tx_dropped++;
                 dev_kfree_skb_any(skb);
                 return NETDEV_TX_OK;
         }

Which should be sufficient?


>
> The driver can set the link state down when the virtqueue is broken.
> If the state is down, the user can switch over to another NIC.


Note that, we probably need the watchdog for virtio-net in order to be a 
complete solution.

Thanks


>
> Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
> ---
>   drivers/net/virtio_net.c | 36 +++++++++++++++++++++++++++++++++++-
>   1 file changed, 35 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 073fec4c0df1..05a3cd1c589b 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -237,6 +237,10 @@ struct virtnet_info {
>   
>   	/* failover when STANDBY feature enabled */
>   	struct failover *failover;
> +
> +	/* Work struct for checking vq status, stop NIC if vq is broken. */
> +	struct delayed_work vq_check_work;
> +	bool broken;
>   };
>   
>   struct padded_vnet_hdr {
> @@ -1407,6 +1411,27 @@ static void refill_work(struct work_struct *work)
>   	}
>   }
>   
> +static void virnet_vq_check_work(struct work_struct *work)
> +{
> +	struct virtnet_info *vi =
> +		container_of(work, struct virtnet_info, vq_check_work.work);
> +	struct net_device *netdev = vi->dev;
> +	int i;
> +
> +	if (vi->broken)
> +		return;
> +
> +	/* If virtqueue is broken, set link down and stop all queues */
> +	for (i = 0; i < vi->max_queue_pairs; i++) {
> +		if (virtqueue_is_broken(vi->rq[i].vq) || virtqueue_is_broken(vi->sq[i].vq)) {
> +			netif_carrier_off(netdev);
> +			netif_tx_stop_all_queues(netdev);
> +			vi->broken = true;
> +			break;
> +		}
> +	}
> +}
> +
>   static int virtnet_receive(struct receive_queue *rq, int budget,
>   			   unsigned int *xdp_xmit)
>   {
> @@ -1432,6 +1457,9 @@ static int virtnet_receive(struct receive_queue *rq, int budget,
>   		}
>   	}
>   
> +	if (unlikely(!virtqueue_is_broken(rq->vq)))
> +		schedule_delayed_work(&vi->vq_check_work, HZ);
> +
>   	if (rq->vq->num_free > min((unsigned int)budget, virtqueue_get_vring_size(rq->vq)) / 2) {
>   		if (!try_fill_recv(vi, rq, GFP_ATOMIC))
>   			schedule_delayed_work(&vi->refill, 0);
> @@ -1681,6 +1709,7 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
>   				 qnum, err);
>   		dev->stats.tx_dropped++;
>   		dev_kfree_skb_any(skb);
> +		schedule_delayed_work(&vi->vq_check_work, HZ);
>   		return NETDEV_TX_OK;
>   	}
>   
> @@ -1905,6 +1934,7 @@ static int virtnet_close(struct net_device *dev)
>   
>   	/* Make sure refill_work doesn't re-enable napi! */
>   	cancel_delayed_work_sync(&vi->refill);
> +	cancel_delayed_work_sync(&vi->vq_check_work);
>   
>   	for (i = 0; i < vi->max_queue_pairs; i++) {
>   		xdp_rxq_info_unreg(&vi->rq[i].xdp_rxq);
> @@ -2381,6 +2411,7 @@ static void virtnet_freeze_down(struct virtio_device *vdev)
>   	netif_device_detach(vi->dev);
>   	netif_tx_unlock_bh(vi->dev);
>   	cancel_delayed_work_sync(&vi->refill);
> +	cancel_delayed_work_sync(&vi->vq_check_work);
>   
>   	if (netif_running(vi->dev)) {
>   		for (i = 0; i < vi->max_queue_pairs; i++) {
> @@ -2662,7 +2693,7 @@ static void virtnet_config_changed_work(struct work_struct *work)
>   
>   	vi->status = v;
>   
> -	if (vi->status & VIRTIO_NET_S_LINK_UP) {
> +	if ((vi->status & VIRTIO_NET_S_LINK_UP) && !vi->broken) {
>   		virtnet_update_settings(vi);
>   		netif_carrier_on(vi->dev);
>   		netif_tx_wake_all_queues(vi->dev);
> @@ -2889,6 +2920,8 @@ static int virtnet_alloc_queues(struct virtnet_info *vi)
>   		goto err_rq;
>   
>   	INIT_DELAYED_WORK(&vi->refill, refill_work);
> +	INIT_DELAYED_WORK(&vi->vq_check_work, virnet_vq_check_work);
> +
>   	for (i = 0; i < vi->max_queue_pairs; i++) {
>   		vi->rq[i].pages = NULL;
>   		netif_napi_add(vi->dev, &vi->rq[i].napi, virtnet_poll,
> @@ -3240,6 +3273,7 @@ static int virtnet_probe(struct virtio_device *vdev)
>   	net_failover_destroy(vi->failover);
>   free_vqs:
>   	cancel_delayed_work_sync(&vi->refill);
> +	cancel_delayed_work_sync(&vi->vq_check_work);
>   	free_receive_page_frags(vi);
>   	virtnet_del_vqs(vi);
>   free:

