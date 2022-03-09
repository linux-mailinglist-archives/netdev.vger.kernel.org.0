Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC7D4D2B66
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 10:07:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231779AbiCIJHp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 04:07:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230008AbiCIJHn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 04:07:43 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8109616BCE9
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 01:06:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646816804;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dmarRpfjcD+wJIBdiG5Aw9gDSJ+EPWEuC8CvMx7WuN8=;
        b=L8Srg0nwvYsJ+ReIt6n6AgpZNE+w6g2EltcoZWyQ5QtkGFzKLg//JMj+aKs6jVochSySum
        g3vD6cSA4QoiwjwbRFqfhDIRJHVW4xq+lYotB5i0QNeUHAApHEk69Oawgf369GzFuhOcHd
        Q/53iR6vdB5mjFIUG0nzhOmKFvIg3NY=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-77-FKE7izoJNKul5cpMLu1xMw-1; Wed, 09 Mar 2022 04:06:43 -0500
X-MC-Unique: FKE7izoJNKul5cpMLu1xMw-1
Received: by mail-pf1-f199.google.com with SMTP id f18-20020a623812000000b004f6a259bbf4so1211426pfa.7
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 01:06:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=dmarRpfjcD+wJIBdiG5Aw9gDSJ+EPWEuC8CvMx7WuN8=;
        b=AOFnNJg+32c8mQXfLz6azLQOuseGxPHe0G0H69glOcKa4wD64jwuWiwLYl6zNzSd7x
         FnAjnjNHikxt/c2MhgjGxI1a39/PMLx8w1ADmjXxxWkuTZtDeppu/tutCBEhp2AboW1A
         wuOR8tFQzJ5GBj9L3grvjbzSRbZ+k+UEaIUwHv+ncyjlQANQduRHIQwOBrbws8yoVsBq
         FTp4g8S9UbqRotzEnl8FtnfiPH08FKZvNhGqBU2BGycosDaFOUmTlb1MozauFsVDPcrc
         8ObnUGCKI921cixrQNMTbVqiYL8f18NyvIM9seFIcPJkOx1w2JsgcDTnzrgvnPdKwyh7
         Fbzw==
X-Gm-Message-State: AOAM533GumgF5BArDN3S3BHjZrZJO+BgSo/3iuqVg8XJh6Z7LrKzdsL1
        aFe2aRugx/ZvbficnrFOYq/sEX2D+/L4rWlHe2Z/JxGNptzdRljIy0I0wR0JAErxlqVRoHzmqUa
        WTYuiaiZtPWsyS9wn
X-Received: by 2002:a63:854a:0:b0:380:352e:8009 with SMTP id u71-20020a63854a000000b00380352e8009mr12892127pgd.292.1646816802487;
        Wed, 09 Mar 2022 01:06:42 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz9eDcfFxbje1rdv28H7WkiZwFVsxL2GSk9kNibKQYu1fo/Qm/IxgRXDvzx0fDGJ0esSBvzvg==
X-Received: by 2002:a63:854a:0:b0:380:352e:8009 with SMTP id u71-20020a63854a000000b00380352e8009mr12892088pgd.292.1646816802085;
        Wed, 09 Mar 2022 01:06:42 -0800 (PST)
Received: from [10.72.12.183] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x3-20020a17090ad68300b001b8bcd47c35sm5646802pju.6.2022.03.09.01.06.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 01:06:41 -0800 (PST)
Message-ID: <9049128d-543e-be7b-a0a1-08e9bf94c282@redhat.com>
Date:   Wed, 9 Mar 2022 17:06:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH v7 23/26] virtio_net: split free_unused_bufs()
Content-Language: en-US
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
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
        linux-um@lists.infradead.org, platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, bpf@vger.kernel.org
References: <20220308123518.33800-1-xuanzhuo@linux.alibaba.com>
 <20220308123518.33800-24-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220308123518.33800-24-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/3/8 下午8:35, Xuan Zhuo 写道:
> This patch separates two functions for freeing sq buf and rq buf from
> free_unused_bufs().
>
> When supporting the enable/disable tx/rq queue in the future, it is
> necessary to support separate recovery of a sq buf or a rq buf.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   drivers/net/virtio_net.c | 53 +++++++++++++++++++++++-----------------
>   1 file changed, 31 insertions(+), 22 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 59b1ea82f5f0..409a8e180918 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -2804,36 +2804,45 @@ static void free_receive_page_frags(struct virtnet_info *vi)
>   			put_page(vi->rq[i].alloc_frag.page);
>   }
>   
> -static void free_unused_bufs(struct virtnet_info *vi)
> +static void virtnet_sq_free_unused_bufs(struct virtnet_info *vi,
> +					struct send_queue *sq)
>   {
>   	void *buf;
> -	int i;
>   
> -	for (i = 0; i < vi->max_queue_pairs; i++) {
> -		struct virtqueue *vq = vi->sq[i].vq;
> -		while ((buf = virtqueue_detach_unused_buf(vq)) != NULL) {
> -			if (!is_xdp_frame(buf))
> -				dev_kfree_skb(buf);
> -			else
> -				xdp_return_frame(ptr_to_xdp(buf));
> -		}
> +	while ((buf = virtqueue_detach_unused_buf(sq->vq)) != NULL) {
> +		if (!is_xdp_frame(buf))
> +			dev_kfree_skb(buf);
> +		else
> +			xdp_return_frame(ptr_to_xdp(buf));
>   	}
> +}
>   
> -	for (i = 0; i < vi->max_queue_pairs; i++) {
> -		struct virtqueue *vq = vi->rq[i].vq;
> -
> -		while ((buf = virtqueue_detach_unused_buf(vq)) != NULL) {
> -			if (vi->mergeable_rx_bufs) {
> -				put_page(virt_to_head_page(buf));
> -			} else if (vi->big_packets) {
> -				give_pages(&vi->rq[i], buf);
> -			} else {
> -				put_page(virt_to_head_page(buf));
> -			}
> -		}
> +static void virtnet_rq_free_unused_bufs(struct virtnet_info *vi,
> +					struct receive_queue *rq)
> +{
> +	void *buf;
> +
> +	while ((buf = virtqueue_detach_unused_buf(rq->vq)) != NULL) {
> +		if (vi->mergeable_rx_bufs)
> +			put_page(virt_to_head_page(buf));
> +		else if (vi->big_packets)
> +			give_pages(rq, buf);
> +		else
> +			put_page(virt_to_head_page(buf));
>   	}
>   }
>   
> +static void free_unused_bufs(struct virtnet_info *vi)
> +{
> +	int i;
> +
> +	for (i = 0; i < vi->max_queue_pairs; i++)
> +		virtnet_sq_free_unused_bufs(vi, vi->sq + i);
> +
> +	for (i = 0; i < vi->max_queue_pairs; i++)
> +		virtnet_rq_free_unused_bufs(vi, vi->rq + i);
> +}
> +
>   static void virtnet_del_vqs(struct virtnet_info *vi)
>   {
>   	struct virtio_device *vdev = vi->vdev;

