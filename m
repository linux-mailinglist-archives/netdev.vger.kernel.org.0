Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EBBA5E5832
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 03:41:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231136AbiIVBla (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 21:41:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231128AbiIVBl3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 21:41:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 814247AC30
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 18:41:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663810887;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TIfhKq61xO6QH7rgAjTE4pO7Kfb94I1KOlakBeMYdtw=;
        b=AZ/8yJTM+8ZFpMoK6800/XI43yuxbAQqygna9YTo18o3kx2qQRoKRiOD6t1M4VmlLWmbOG
        Wtag1g2tw4gZgoMKsFUuUamjF57oWY5z3C98KTfCwYiMQEKeEOILUmMkDI8GxbLeGAwPhB
        /PGRIHKgh+1pqwu1XCkYQogTl7r3jaw=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-592-Yvfw4J5YMjCnB3rMI1s57Q-1; Wed, 21 Sep 2022 21:41:26 -0400
X-MC-Unique: Yvfw4J5YMjCnB3rMI1s57Q-1
Received: by mail-pj1-f69.google.com with SMTP id g15-20020a17090a708f00b00203a68c9acaso316097pjk.8
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 18:41:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=TIfhKq61xO6QH7rgAjTE4pO7Kfb94I1KOlakBeMYdtw=;
        b=LEAxdk1qWZA2DzbsWavALUHnPQiAMCgOsGZ11FjF0gj16aFkXX/hKkVqtX+7SmUScb
         aIFe3ui8gUMIYJRGfEAnrDwI97p1tazSMZBO4n8YCJRqKhCU6d/F5TsNDeCUmZiQunca
         yuX7OjNgTGkTJKISk5U6TL1uI0wSWWPN85canrl2IYotuArLjQbwGNQPEqYt7R6KoOpu
         IekhXe6dleLJ+8T8WIsC3S2Zyr9d7OHsTVcKQc0V4p/ruWZylaJr+kHhqmTPvtoCcJZu
         gBxvRMkk5hSfT/wI+1mqvhwcVF+ZFLPRd5viHpn2KvmGfqAICUKgjTDJjevwOdowWy1F
         FiYg==
X-Gm-Message-State: ACrzQf10xn+CzDUpdTuutHPUcsILfu9yOiuSgjdFtPPwqsT525oUHrJi
        dIAjJswU6ROinUCJb+BSR3QR6oORcua2KlGG/ownXVmCYPL3sdV2/aDQ85LX7ry0qDyggSZMCmp
        qqkvtHHxZKCvBUFTo
X-Received: by 2002:a17:902:7795:b0:178:897e:16b2 with SMTP id o21-20020a170902779500b00178897e16b2mr842602pll.153.1663810885431;
        Wed, 21 Sep 2022 18:41:25 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6luUiD0QV+HVUNnyL3QlSYTq4CR8EaVAumYf+PyZ5yhvh93CSjjUjNOKMM3EKCV04QYUVZ0w==
X-Received: by 2002:a17:902:7795:b0:178:897e:16b2 with SMTP id o21-20020a170902779500b00178897e16b2mr842582pll.153.1663810885151;
        Wed, 21 Sep 2022 18:41:25 -0700 (PDT)
Received: from [10.72.13.82] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id r26-20020a63441a000000b0042b5095b7b4sm2638151pga.5.2022.09.21.18.41.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Sep 2022 18:41:24 -0700 (PDT)
Message-ID: <b271dd91-49d5-fac4-bb3d-8405099c2710@redhat.com>
Date:   Thu, 22 Sep 2022 09:41:17 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH v6 2/2] virtio-net: use mtu size as buffer length for big
 packets
Content-Language: en-US
To:     Gavin Li <gavinl@nvidia.com>, mst@redhat.com,
        stephen@networkplumber.org, davem@davemloft.net,
        jesse.brandeburg@intel.com, kuba@kernel.org,
        sridhar.samudrala@intel.com, loseweigh@gmail.com,
        netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        virtio-dev@lists.oasis-open.org
Cc:     Gavi Teitz <gavi@nvidia.com>, Parav Pandit <parav@nvidia.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>
References: <20220914144911.56422-1-gavinl@nvidia.com>
 <20220914144911.56422-3-gavinl@nvidia.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220914144911.56422-3-gavinl@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/9/14 22:49, Gavin Li 写道:
> Currently add_recvbuf_big() allocates MAX_SKB_FRAGS segments for big
> packets even when GUEST_* offloads are not present on the device.
> However, if guest GSO is not supported, it would be sufficient to
> allocate segments to cover just up the MTU size and no further.
> Allocating the maximum amount of segments results in a large waste of
> buffer space in the queue, which limits the number of packets that can
> be buffered and can result in reduced performance.
>
> Therefore, if guest GSO is not supported, use the MTU to calculate the
> optimal amount of segments required.
>
> Below is the iperf TCP test results over a Mellanox NIC, using vDPA for
> 1 VQ, queue size 1024, before and after the change, with the iperf
> server running over the virtio-net interface.
>
> MTU(Bytes)/Bandwidth (Gbit/s)
>               Before   After
>    1500        22.5     22.4
>    9000        12.8     25.9
>
> And result of queue size 256.
> MTU(Bytes)/Bandwidth (Gbit/s)
>               Before   After
>    9000        2.15     11.9
>
> With this patch no degradation is observed with multiple below tests and
> feature bit combinations. Results are summarized below for q depth of
> 1024. Interface MTU is 1500 if MTU feature is disabled. MTU is set to 9000
> in other tests.
>
> Features/              Bandwidth (Gbit/s)
>                           Before   After
> mtu off                   20.1     20.2
> mtu/indirect on           17.4     17.3
> mtu/indirect/packed on    17.2     17.2
>
> Signed-off-by: Gavin Li <gavinl@nvidia.com>
> Reviewed-by: Gavi Teitz <gavi@nvidia.com>
> Reviewed-by: Parav Pandit <parav@nvidia.com>
> Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Reviewed-by: Si-Wei Liu <si-wei.liu@oracle.com>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
> changelog:
> v5->v6
> - Addressed comments from Jason and Michael S. Tsirkin
> - Remove wrong commit log description
> - Rename virtnet_set_big_packets_fields with virtnet_set_big_packets
> - Add more test results for different feature combinations
> v4->v5
> - Addressed comments from Michael S. Tsirkin
> - Improve commit message
> v3->v4
> - Addressed comments from Si-Wei
> - Rename big_packets_sg_num with big_packets_num_skbfrags
> v2->v3
> - Addressed comments from Si-Wei
> - Simplify the condition check to enable the optimization
> v1->v2
> - Addressed comments from Jason, Michael, Si-Wei.
> - Remove the flag of guest GSO support, set sg_num for big packets and
>    use it directly
> - Recalculate sg_num for big packets in virtnet_set_guest_offloads
> - Replace the round up algorithm with DIV_ROUND_UP
> ---
>   drivers/net/virtio_net.c | 37 ++++++++++++++++++++++++-------------
>   1 file changed, 24 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index f54c7182758f..7106932c6f88 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -225,6 +225,9 @@ struct virtnet_info {
>   	/* I like... big packets and I cannot lie! */
>   	bool big_packets;
>   
> +	/* number of sg entries allocated for big packets */
> +	unsigned int big_packets_num_skbfrags;
> +
>   	/* Host will merge rx buffers for big packets (shake it! shake it!) */
>   	bool mergeable_rx_bufs;
>   
> @@ -1331,10 +1334,10 @@ static int add_recvbuf_big(struct virtnet_info *vi, struct receive_queue *rq,
>   	char *p;
>   	int i, err, offset;
>   
> -	sg_init_table(rq->sg, MAX_SKB_FRAGS + 2);
> +	sg_init_table(rq->sg, vi->big_packets_num_skbfrags + 2);
>   
> -	/* page in rq->sg[MAX_SKB_FRAGS + 1] is list tail */
> -	for (i = MAX_SKB_FRAGS + 1; i > 1; --i) {
> +	/* page in rq->sg[vi->big_packets_num_skbfrags + 1] is list tail */
> +	for (i = vi->big_packets_num_skbfrags + 1; i > 1; --i) {
>   		first = get_a_page(rq, gfp);
>   		if (!first) {
>   			if (list)
> @@ -1365,7 +1368,7 @@ static int add_recvbuf_big(struct virtnet_info *vi, struct receive_queue *rq,
>   
>   	/* chain first in list head */
>   	first->private = (unsigned long)list;
> -	err = virtqueue_add_inbuf(rq->vq, rq->sg, MAX_SKB_FRAGS + 2,
> +	err = virtqueue_add_inbuf(rq->vq, rq->sg, vi->big_packets_num_skbfrags + 2,
>   				  first, gfp);
>   	if (err < 0)
>   		give_pages(rq, first);
> @@ -3690,13 +3693,27 @@ static bool virtnet_check_guest_gso(const struct virtnet_info *vi)
>   		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_UFO);
>   }
>   
> +static void virtnet_set_big_packets(struct virtnet_info *vi, const int mtu)
> +{
> +	bool guest_gso = virtnet_check_guest_gso(vi);
> +
> +	/* If device can receive ANY guest GSO packets, regardless of mtu,
> +	 * allocate packets of maximum size, otherwise limit it to only
> +	 * mtu size worth only.
> +	 */
> +	if (mtu > ETH_DATA_LEN || guest_gso) {
> +		vi->big_packets = true;
> +		vi->big_packets_num_skbfrags = guest_gso ? MAX_SKB_FRAGS : DIV_ROUND_UP(mtu, PAGE_SIZE);
> +	}
> +}
> +
>   static int virtnet_probe(struct virtio_device *vdev)
>   {
>   	int i, err = -ENOMEM;
>   	struct net_device *dev;
>   	struct virtnet_info *vi;
>   	u16 max_queue_pairs;
> -	int mtu;
> +	int mtu = 0;
>   
>   	/* Find if host supports multiqueue/rss virtio_net device */
>   	max_queue_pairs = 1;
> @@ -3784,10 +3801,6 @@ static int virtnet_probe(struct virtio_device *vdev)
>   	INIT_WORK(&vi->config_work, virtnet_config_changed_work);
>   	spin_lock_init(&vi->refill_lock);
>   
> -	/* If we can receive ANY GSO packets, we must allocate large ones. */
> -	if (virtnet_check_guest_gso(vi))
> -		vi->big_packets = true;
> -
>   	if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF))
>   		vi->mergeable_rx_bufs = true;
>   
> @@ -3853,12 +3866,10 @@ static int virtnet_probe(struct virtio_device *vdev)
>   
>   		dev->mtu = mtu;
>   		dev->max_mtu = mtu;
> -
> -		/* TODO: size buffers correctly in this case. */
> -		if (dev->mtu > ETH_DATA_LEN)
> -			vi->big_packets = true;
>   	}
>   
> +	virtnet_set_big_packets(vi, mtu);
> +
>   	if (vi->any_header_sg)
>   		dev->needed_headroom = vi->hdr_len;
>   

