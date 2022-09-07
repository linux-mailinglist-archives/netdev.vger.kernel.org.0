Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E74C5AF9C5
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 04:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbiIGCRg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 22:17:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiIGCRf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 22:17:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C061A8A7E0
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 19:17:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662517052;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=37pp2dOfkAFH3OGVSOJ+e4RmJm5kCPc4oNtISihYwXE=;
        b=D2tdDIH8Ki/kWYw5iYaySgG+3uskBRABYClmM5mEuWQyQ8R5JuUydp36AEE5bWxEjRzOP/
        JwBc+rJN5O5RX8gA+9jwlGoNqJHIcd5Pvb5H0f72nKxRjajlvaGr3sKao42Hi0tsiTP5Lo
        4bfQd/JulmHMYj6PUcNI0wU96PvywuU=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-645-w8OyvOjTM3qq-es4pacN5w-1; Tue, 06 Sep 2022 22:17:31 -0400
X-MC-Unique: w8OyvOjTM3qq-es4pacN5w-1
Received: by mail-pg1-f200.google.com with SMTP id m34-20020a634c62000000b0042aff6dff12so6669644pgl.14
        for <netdev@vger.kernel.org>; Tue, 06 Sep 2022 19:17:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=37pp2dOfkAFH3OGVSOJ+e4RmJm5kCPc4oNtISihYwXE=;
        b=SFwlwM1bm4PBdGsYnLpVCQgUEzqp0hobnhwg8pDitIZSrnOdUh07WTml4TduXbkdZX
         Thw6Wnyrz1AF913UfujBHWJF0Cezr7tVWcuELt5GktMok9BODYbju7DgLMWQJq6Wvu5U
         fDa2EMaajX7I1jt/KGQ1ScyaffHVN8Fq/VdIs//05yalpTlbiPUWbFFN/2v3VUZgqVZy
         1QmES9ElzwwAm3JUFMQT/EARpFXA4NAIhKYMe8HRmgm1ARkBJkzQaA4Is1Hnf8kF/kYM
         U6jDFiF33yleUYQFdk3qT5iwylUiJ35ESUPHlKEum3GyHOURPPp2SEuKbYvKJty208zP
         4WSA==
X-Gm-Message-State: ACgBeo0xJjWwk5GWOEH8Oull14AesIiKtpfo7Q73UBfytGtrvU8b7vOB
        fI//dLeji0y8BQUpg+d9I+pq9qW83QEhBqMfg5n4lNY0hNTTwWiY2Ki+3a9fwQRQDKsdkprVR/+
        36lL30e++3I6V2OpP
X-Received: by 2002:a17:902:f68d:b0:174:471b:4794 with SMTP id l13-20020a170902f68d00b00174471b4794mr1487353plg.156.1662517050532;
        Tue, 06 Sep 2022 19:17:30 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4sVuqAhYxMyMk+K7mSSO1Fis+Kh9CIjCFZJYJAYBxX21s1UEUt8zKqzTAfow8lYTs74ob7Zw==
X-Received: by 2002:a17:902:f68d:b0:174:471b:4794 with SMTP id l13-20020a170902f68d00b00174471b4794mr1487343plg.156.1662517050239;
        Tue, 06 Sep 2022 19:17:30 -0700 (PDT)
Received: from [10.72.13.171] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id ik26-20020a170902ab1a00b00172d0c7edf4sm8256869plb.106.2022.09.06.19.17.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Sep 2022 19:17:29 -0700 (PDT)
Message-ID: <a5e1eae0-d977-a625-afa7-69582bf49cb8@redhat.com>
Date:   Wed, 7 Sep 2022 10:17:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [virtio-dev] [PATCH v5 2/2] virtio-net: use mtu size as buffer
 length for big packets
Content-Language: en-US
To:     Gavin Li <gavinl@nvidia.com>, stephen@networkplumber.org,
        davem@davemloft.net, jesse.brandeburg@intel.com,
        alexander.h.duyck@intel.com, kuba@kernel.org,
        sridhar.samudrala@intel.com, loseweigh@gmail.com,
        netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        virtio-dev@lists.oasis-open.org, mst@redhat.com
Cc:     gavi@nvidia.com, parav@nvidia.com,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>
References: <20220901021038.84751-1-gavinl@nvidia.com>
 <20220901021038.84751-3-gavinl@nvidia.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220901021038.84751-3-gavinl@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/9/1 10:10, Gavin Li 写道:
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
> When guest offload is enabled at runtime, RQ already has packets of bytes
> less than 64K. So when packet of 64KB arrives, all the packets of such
> size will be dropped. and RQ is now not usable.
>
> So this means that during set_guest_offloads() phase, RQs have to be
> destroyed and recreated, which requires almost driver reload.
>
> If VIRTIO_NET_F_CTRL_GUEST_OFFLOADS has been negotiated, then it should
> always treat them as GSO enabled.
>
> Accordingly, for now the assumption is that if guest GSO has been
> negotiated then it has been enabled, even if it's actually been disabled
> at runtime through VIRTIO_NET_F_CTRL_GUEST_OFFLOADS.


Nit: Actually, it's not the assumption but the behavior of the codes 
itself. Since we don't try to change guest offloading in probe so it's 
ok to check GSO via negotiated features?

Thanks


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
> Signed-off-by: Gavin Li <gavinl@nvidia.com>
> Reviewed-by: Gavi Teitz <gavi@nvidia.com>
> Reviewed-by: Parav Pandit <parav@nvidia.com>
> Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Reviewed-by: Si-Wei Liu <si-wei.liu@oracle.com>
> ---
> changelog:
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
> index f831a0290998..dbffd5f56fb8 100644
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
> +static void virtnet_set_big_packets_fields(struct virtnet_info *vi, const int mtu)
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
> +	virtnet_set_big_packets_fields(vi, mtu);
> +
>   	if (vi->any_header_sg)
>   		dev->needed_headroom = vi->hdr_len;
>   

