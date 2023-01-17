Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE19166E3A4
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 17:35:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230304AbjAQQfG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 11:35:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232120AbjAQQer (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 11:34:47 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BDE73CE2A
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 08:34:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673973242;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NVmDRrmwM6bLSGgu4CyMQGhit4EFONfy+cKRjvI8WwU=;
        b=AUWCEtvMCZmaLnT3LtwPanakpe1ozSXrLkK8eC4dOTWRtg8NhPRcmBpZnaoDH8qrFlOto9
        ccAXzD9GjvJJ8eTe4NCvJQdaejgV1Sf38HkXBBrQv74L6bAY/mKclFAlnWu+WJdfo2KIOi
        iQd2D3OOGrlKFTYvv+2cVLgS8wXbF7A=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-552-Kjda2vdAP-CNlV9cajt_TA-1; Tue, 17 Jan 2023 11:34:00 -0500
X-MC-Unique: Kjda2vdAP-CNlV9cajt_TA-1
Received: by mail-qv1-f69.google.com with SMTP id mi16-20020a056214559000b005346c5c1f81so6774336qvb.15
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 08:33:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NVmDRrmwM6bLSGgu4CyMQGhit4EFONfy+cKRjvI8WwU=;
        b=yQrBqSon4nAo7WI98B0lxU6cGeVKjbiUEGCU9CCb+lcLRsq3mlBspuhcZBUf0Fcjq7
         ne5MfE6oFSElL5llm126nnYa/36j7p2D9hnxxwjRFDCJK6Jv7VPsBVEqXs+hu8rIDHEd
         IOE++v/2pe7g6yYiPHSwKU/o4NVVwD9Mwj0u9ZL8JHFNgYMig4ybgCelAltY4Di1LzgA
         AVIAPmD4XzNrcqdDAkZEH1kkNJvS8qTtc4ERL04pCBME9UUTWPDURZ1c1FTHy/aHGcL4
         4NaDtw2H90Uv0FNrkF7ML3jgAGmW+Sj1JBpG2+pATXU3RU5Wbjj2oWuZK4WA6QfWp/v4
         liuA==
X-Gm-Message-State: AFqh2kqxwi6xQinvHk9vT5FjuuA1laiY4McgOd105fMNjRpuqvLTI2Kg
        67C95H5vuxW8bV8sNKa2waQucg0NjhMPPmIYzN/r3O/FnPsErY+z0Amu2B29y2fNuEango267QO
        v7r2guV48nhklfvdC
X-Received: by 2002:ac8:58c3:0:b0:3b6:2e8b:3364 with SMTP id u3-20020ac858c3000000b003b62e8b3364mr5463070qta.38.1673973239508;
        Tue, 17 Jan 2023 08:33:59 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvCT6ihocQyYU3l2Kv6blvgT/IPPNSTOnvZX1MrQwg2vhNixBBk1UWBmfkHU0tBUVP1CLc5Ow==
X-Received: by 2002:ac8:58c3:0:b0:3b6:2e8b:3364 with SMTP id u3-20020ac858c3000000b003b62e8b3364mr5463039qta.38.1673973239174;
        Tue, 17 Jan 2023 08:33:59 -0800 (PST)
Received: from [192.168.100.30] ([82.142.8.70])
        by smtp.gmail.com with ESMTPSA id jr49-20020a05622a803100b003ad373d04b6sm13289356qtb.59.2023.01.17.08.33.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Jan 2023 08:33:58 -0800 (PST)
Message-ID: <fefccbdb-9ccd-4057-743a-b23bad4e123d@redhat.com>
Date:   Tue, 17 Jan 2023 17:33:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH net V3] virtio-net: correctly enable callback during
 start_xmit
Content-Language: en-US
To:     Jason Wang <jasowang@redhat.com>, mst@redhat.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xuanzhuo@linux.alibaba.com, Stefano Brivio <sbrivio@redhat.com>
References: <20230117034707.52356-1-jasowang@redhat.com>
From:   Laurent Vivier <lvivier@redhat.com>
In-Reply-To: <20230117034707.52356-1-jasowang@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/17/23 04:47, Jason Wang wrote:
> Commit a7766ef18b33("virtio_net: disable cb aggressively") enables
> virtqueue callback via the following statement:
> 
>          do {
> 		if (use_napi)
> 			virtqueue_disable_cb(sq->vq);
> 
> 		free_old_xmit_skbs(sq, false);
> 
> 	} while (use_napi && kick &&
>                 unlikely(!virtqueue_enable_cb_delayed(sq->vq)));
> 
> When NAPI is used and kick is false, the callback won't be enabled
> here. And when the virtqueue is about to be full, the tx will be
> disabled, but we still don't enable tx interrupt which will cause a TX
> hang. This could be observed when using pktgen with burst enabled.
> 
> TO be consistent with the logic that tries to disable cb only for
> NAPI, fixing this by trying to enable delayed callback only when NAPI
> is enabled when the queue is about to be full.
> 
> Fixes: a7766ef18b33 ("virtio_net: disable cb aggressively")
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
> The patch is needed for -stable.
> Changes since V2:
> - try to enabled delayed callback and schedule NAPI instead of try to
>    poll as when TX NAPI is disabled
> Changes since V1:
> - enable tx interrupt after we disable TX
> ---
>   drivers/net/virtio_net.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 7723b2a49d8e..18b3de854aeb 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -1877,8 +1877,10 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
>   	 */
>   	if (sq->vq->num_free < 2+MAX_SKB_FRAGS) {
>   		netif_stop_subqueue(dev, qnum);
> -		if (!use_napi &&
> -		    unlikely(!virtqueue_enable_cb_delayed(sq->vq))) {
> +		if (use_napi) {
> +			if (unlikely(!virtqueue_enable_cb_delayed(sq->vq)))
> +				virtqueue_napi_schedule(&sq->napi, sq->vq);
> +		} else if (unlikely(!virtqueue_enable_cb_delayed(sq->vq))) {
>   			/* More just got used, free them then recheck. */
>   			free_old_xmit_skbs(sq, false);
>   			if (sq->vq->num_free >= 2+MAX_SKB_FRAGS) {

This fix works fine with my test case (netdev stream + passt)

Tested-by: Laurent Vivier <lvivier@redhat.com>

Thanks,
Laurent

