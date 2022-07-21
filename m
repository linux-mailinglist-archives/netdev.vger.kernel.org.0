Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4B7657C505
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 09:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232336AbiGUHJC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 03:09:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232322AbiGUHJA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 03:09:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 139BB77A4E
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 00:08:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658387338;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=20XB7X4uMFrdCQowchk09EqnsM7R3g6B8Dxeh2uQp8M=;
        b=Do7a/N7NIGRItx61IRnl6DoU+PQsIJQgkpKehBFhpIDGecdXcUMwMwdW+WX3ZT7AEdXyJH
        GDMeeHRu35q7/nzKVpBaGRc6uOF5HqEJYiXK2P2HStX8QCCpnzXzxlXiOC0nrdKNockDHt
        xqndSTd/5vAc1MCuJko+kMB5h2s4oYE=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-654-NQ-a1_6JOayEhDkRqF7ypA-1; Thu, 21 Jul 2022 03:08:57 -0400
X-MC-Unique: NQ-a1_6JOayEhDkRqF7ypA-1
Received: by mail-pl1-f199.google.com with SMTP id i9-20020a170902cf0900b0016d1e277547so725096plg.0
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 00:08:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=20XB7X4uMFrdCQowchk09EqnsM7R3g6B8Dxeh2uQp8M=;
        b=MWJBesTee8OWVP113cn9wTSvP8J/nNhLU+z/KC11+hMy5Lo4+9GCr3UyGGk5VBv9Hl
         3RWsttBqScI1m8Gpur1dX/Ur8nT/UpGVHxRdryD4LYWLvngXtCxO4avr9Hk3Ci3+xRpp
         vR1GRsQFUgWWujkNDICuvLvyDASe2b50SO3rZqClV4P7nmNz/ne8iFW75JM4K3LouRJP
         vUJn94nvHfsRCNQlQ6/ymB3TlvUraygaXByib4V1VNbMi/qGJmZpZqSXNrpkWTSmy74P
         fyjXCg3BF+4uFVQQX4wyti17HnB8X51bTLb5sj5/06nJ/COZ/3559s7+yimtT4fHo+d6
         hsCg==
X-Gm-Message-State: AJIora8Q/hSszXFLwQnCA7lPK1f4+T+ywqIhLA6jNwdR1bv3APjLtwYo
        uncNCRs2QBdmVRMGS7vhtORrPXJ/SRW8twM3g2o4P3K8lXxIjjn3keUFvtCmiKzxdAb9KpvX5o+
        PINfMP9fPUC3GUe5T
X-Received: by 2002:a05:6a00:998:b0:52a:db4c:541b with SMTP id u24-20020a056a00099800b0052adb4c541bmr42860430pfg.35.1658387335775;
        Thu, 21 Jul 2022 00:08:55 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uJ7ogdlWO9wq9dujWOVNZNut2Pk1AGg7QtSX4Ep4NpLAUcMg6IEWg7tcD5uQIK4LSqmKQ0RA==
X-Received: by 2002:a05:6a00:998:b0:52a:db4c:541b with SMTP id u24-20020a056a00099800b0052adb4c541bmr42860380pfg.35.1658387335468;
        Thu, 21 Jul 2022 00:08:55 -0700 (PDT)
Received: from [10.72.12.47] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 82-20020a621455000000b0052bae7b2af8sm862397pfu.201.2022.07.21.00.08.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Jul 2022 00:08:54 -0700 (PDT)
Message-ID: <a8a9fd2e-a1e3-ad68-c085-322ec002a4d5@redhat.com>
Date:   Thu, 21 Jul 2022 15:08:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH v12 07/40] virtio_ring: split: introduce
 vring_free_split()
Content-Language: en-US
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        virtualization@lists.linux-foundation.org
Cc:     Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        Vadim Pasternak <vadimp@nvidia.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        linux-um@lists.infradead.org, netdev@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, bpf@vger.kernel.org,
        kangjie.xu@linux.alibaba.com
References: <20220720030436.79520-1-xuanzhuo@linux.alibaba.com>
 <20220720030436.79520-8-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220720030436.79520-8-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/7/20 11:04, Xuan Zhuo 写道:
> Free the structure struct vring_vritqueue_split.
>
> Subsequent patches require it.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   drivers/virtio/virtio_ring.c | 11 +++++++++++
>   1 file changed, 11 insertions(+)
>
> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> index 87ce17562b29..c94c5461e702 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -939,6 +939,17 @@ static void *virtqueue_detach_unused_buf_split(struct virtqueue *_vq)
>   	return NULL;
>   }
>   
> +static void vring_free_split(struct vring_virtqueue_split *vring_split,
> +			     struct virtio_device *vdev)
> +{
> +	vring_free_queue(vdev, vring_split->queue_size_in_bytes,
> +			 vring_split->vring.desc,
> +			 vring_split->queue_dma_addr);
> +
> +	kfree(vring_split->desc_state);
> +	kfree(vring_split->desc_extra);
> +}
> +
>   static struct virtqueue *vring_create_virtqueue_split(
>   	unsigned int index,
>   	unsigned int num,

