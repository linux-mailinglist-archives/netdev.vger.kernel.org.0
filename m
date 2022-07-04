Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8E4E564C1A
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 05:44:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230382AbiGDDon (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jul 2022 23:44:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiGDDol (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jul 2022 23:44:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DC58B2620
        for <netdev@vger.kernel.org>; Sun,  3 Jul 2022 20:44:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656906280;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cv3HUpNj3eAl/vJtQ+pT32ck850vCrBA1S2j2S7C3Ys=;
        b=IwRVPYS+e2uohe1d4HFA3seCyUfjKtK0GsYF7kROiKi6xzpajJVVkiD/i2c8HSofXu04Uz
        PzvpTzwizBIycLeNWUTGIiTEKvup5wTgDPLQf0/w56wPEbpdNppQi0L2R64Wd2GCGLsdt0
        JWvm2HLSqVM4IrGG/uxUpxNoEKOFwd4=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-411-Gwmqpij1NQ2fmJ0eRBeLKw-1; Sun, 03 Jul 2022 23:44:38 -0400
X-MC-Unique: Gwmqpij1NQ2fmJ0eRBeLKw-1
Received: by mail-pg1-f197.google.com with SMTP id e5-20020a636905000000b004119d180b54so3424270pgc.14
        for <netdev@vger.kernel.org>; Sun, 03 Jul 2022 20:44:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=cv3HUpNj3eAl/vJtQ+pT32ck850vCrBA1S2j2S7C3Ys=;
        b=mj/lscukbaSgA03RvPclU7FNN1gAknj9SYhPYkfv4BrtXWKRH4kD9Yg7mmcaprl/TG
         ZkkAHZkfhW6PbwfPLJVRn1yGk9GS+5pGzH9IOD8ECjXF+82den/4nl7mdYL/Z+Pc+Ymi
         xCAZJUXwH23iJSzT6/mPn/QGRQ4nZGc9vdSFEav9EtkjwNqUmO7W3xRINbDPN4SQ96wU
         QO8hCS3mKQVDfRNG4Ys+hnSou5NtSwwy7dpDk/fD/6Kg4rwmNepV815UEA6k8Rd42LcJ
         W1wf4PCIO0xiSa/oHY5bt7EZxDXeaUNbda+MFNwgYeQNcVjqphmc65tWheMv29wM5yb6
         wjdg==
X-Gm-Message-State: AJIora/9lyuHXPG2i7sWW3uqibfQDwRUbqgp/rJ8EkSKWflEZcQJndeB
        p77ALLBsdhnJDeGjBoWAaLNnLN6GeEGBZXCqUcbk/xBtAT0+FOwaOX/JVIVozZN8EM3KA5SqOSN
        wwpeTKUF2vCNHqFyK
X-Received: by 2002:a17:903:2305:b0:16a:6b9c:2b4c with SMTP id d5-20020a170903230500b0016a6b9c2b4cmr33952586plh.100.1656906277847;
        Sun, 03 Jul 2022 20:44:37 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vk/Hd8og5+nDjg8VAC8WRwsbIgZregwPlY1R8NDNjwqjgs0y/y3d5XWztK3kil+f/m4lKdeg==
X-Received: by 2002:a17:903:2305:b0:16a:6b9c:2b4c with SMTP id d5-20020a170903230500b0016a6b9c2b4cmr33952558plh.100.1656906277594;
        Sun, 03 Jul 2022 20:44:37 -0700 (PDT)
Received: from [10.72.13.251] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id c16-20020a056a00009000b0051c1b445094sm20026222pfj.7.2022.07.03.20.44.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Jul 2022 20:44:37 -0700 (PDT)
Message-ID: <c0747cbc-685b-85a9-1931-0124124755f2@redhat.com>
Date:   Mon, 4 Jul 2022 11:44:12 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH v11 38/40] virtio_net: support rx queue resize
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
References: <20220629065656.54420-1-xuanzhuo@linux.alibaba.com>
 <20220629065656.54420-39-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220629065656.54420-39-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/6/29 14:56, Xuan Zhuo 写道:
> This patch implements the resize function of the rx queues.
> Based on this function, it is possible to modify the ring num of the
> queue.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>   drivers/net/virtio_net.c | 22 ++++++++++++++++++++++
>   1 file changed, 22 insertions(+)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 9fe222a3663a..6ab16fd193e5 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -278,6 +278,8 @@ struct padded_vnet_hdr {
>   	char padding[12];
>   };
>   
> +static void virtnet_rq_free_unused_buf(struct virtqueue *vq, void *buf);
> +
>   static bool is_xdp_frame(void *ptr)
>   {
>   	return (unsigned long)ptr & VIRTIO_XDP_FLAG;
> @@ -1846,6 +1848,26 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
>   	return NETDEV_TX_OK;
>   }
>   
> +static int virtnet_rx_resize(struct virtnet_info *vi,
> +			     struct receive_queue *rq, u32 ring_num)
> +{
> +	int err, qindex;
> +
> +	qindex = rq - vi->rq;
> +
> +	napi_disable(&rq->napi);


Do we need to cancel the refill work here?

Thanks


> +
> +	err = virtqueue_resize(rq->vq, ring_num, virtnet_rq_free_unused_buf);
> +	if (err)
> +		netdev_err(vi->dev, "resize rx fail: rx queue index: %d err: %d\n", qindex, err);
> +
> +	if (!try_fill_recv(vi, rq, GFP_KERNEL))
> +		schedule_delayed_work(&vi->refill, 0);
> +
> +	virtnet_napi_enable(rq->vq, &rq->napi);
> +	return err;
> +}
> +
>   /*
>    * Send command via the control virtqueue and check status.  Commands
>    * supported by the hypervisor, as indicated by feature bits, should

