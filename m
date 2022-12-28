Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71ED6657331
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 07:25:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbiL1GZW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Dec 2022 01:25:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiL1GZV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Dec 2022 01:25:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF359BE0D
        for <netdev@vger.kernel.org>; Tue, 27 Dec 2022 22:24:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672208670;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EUDH72TbKImXu1q4pMXibpdpASgzGn6M9w4L0s3sKfo=;
        b=PCI2AYc1Hm5xW/5VCEAbxkfVCLOMHdljN6PE0htTeWbthKSIuihQOLvmmVLycr6hgsvZtG
        x3soYZJ8doF1ZxBdERuRDFTgS3cdEwWP/PVUskollxXOfQRHNku9bKOycxE1goUvvLEI8U
        70Mf7C575PW04dtMII/xJJ3EGss+H3E=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-493-n3Kzykx5Nmy-NAHPbF1Afw-1; Wed, 28 Dec 2022 01:24:29 -0500
X-MC-Unique: n3Kzykx5Nmy-NAHPbF1Afw-1
Received: by mail-pj1-f72.google.com with SMTP id ep17-20020a17090ae65100b00219702c495cso6364562pjb.2
        for <netdev@vger.kernel.org>; Tue, 27 Dec 2022 22:24:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EUDH72TbKImXu1q4pMXibpdpASgzGn6M9w4L0s3sKfo=;
        b=vZ0UMtosajDDRBHMbE1/Ij2aIkoukf3mQ+iK8uyzOUKJHmT/5Z9jYWORZ8KlztNLon
         473TisULaIMwqRZQfWK8fcXv3s89lz9LYUcU1+0871aa7NtK16QJFCxiUys+8tk2FdON
         axLpJIEZmPFcII+GdBtHiI0o+NSO17jo+jJfmXV4maJcRqKqkzrkG8E79C6wrCMclYDA
         867OybcTo7xlZbnmF/qN9VmYzdsldqAFM0waYgZIDZrZlr4YvCnzr3DzdholgNQxm0CA
         KoNKu0q3k7GXIb+JVbHaKislMEbMVDCvTSQ5lvYv8IvpVvbsZfTpzjEKL2DfR4v5kh17
         asWw==
X-Gm-Message-State: AFqh2koqid6lWxGRHOXEEiBDmb+nFa8BGyTELXI2BP6ELETzfZJMt/xq
        gXv2BrSld6h083tV7wd0T9Dk4wJlhrMjAT2LlL4/eaj60MLn2R18TsOMc41U0p02fhq7kg9K5Y8
        wU2NyMXBoFWTj7D50
X-Received: by 2002:aa7:9e81:0:b0:581:73f8:d593 with SMTP id p1-20020aa79e81000000b0058173f8d593mr4192846pfq.31.1672208668273;
        Tue, 27 Dec 2022 22:24:28 -0800 (PST)
X-Google-Smtp-Source: AMrXdXt/JNtWpTfxNuYFPgPBSu09JHSdhMBVFCXcI0EpYIaeTvvkzv0JPFpFz8vmo1rFNpyq0HVD0w==
X-Received: by 2002:aa7:9e81:0:b0:581:73f8:d593 with SMTP id p1-20020aa79e81000000b0058173f8d593mr4192831pfq.31.1672208667943;
        Tue, 27 Dec 2022 22:24:27 -0800 (PST)
Received: from [10.72.13.7] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x68-20020a626347000000b0056bc742d21esm9726233pfb.176.2022.12.27.22.24.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Dec 2022 22:24:27 -0800 (PST)
Message-ID: <bfc3f1d0-b656-8d2b-c85d-f20a23f2e976@redhat.com>
Date:   Wed, 28 Dec 2022 14:24:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH v2 5/9] virtio_net: construct multi-buffer xdp in
 mergeable
Content-Language: en-US
To:     Heng Qi <hengqi@linux.alibaba.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     "Michael S . Tsirkin" <mst@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
References: <20221220141449.115918-1-hengqi@linux.alibaba.com>
 <20221220141449.115918-6-hengqi@linux.alibaba.com>
 <5a03364e-c09e-63ff-7e73-1efec1ed8ca8@redhat.com>
 <83dc59b1-99f6-58fe-56b5-de5158bcc3cd@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <83dc59b1-99f6-58fe-56b5-de5158bcc3cd@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/12/27 17:31, Heng Qi 写道:
>
>
> 在 2022/12/27 下午3:01, Jason Wang 写道:
>>
>> 在 2022/12/20 22:14, Heng Qi 写道:
>>> Build multi-buffer xdp using virtnet_build_xdp_buff_mrg().
>>>
>>> For the prefilled buffer before xdp is set, we will probably use
>>> vq reset in the future. At the same time, virtio net currently
>>> uses comp pages, and bpf_xdp_frags_increase_tail() needs to calculate
>>> the tailroom of the last frag, which will involve the offset of the
>>> corresponding page and cause a negative value, so we disable tail
>>> increase by not setting xdp_rxq->frag_size.
>>>
>>> Signed-off-by: Heng Qi <hengqi@linux.alibaba.com>
>>> Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
>>> ---
>>>   drivers/net/virtio_net.c | 60 
>>> +++++++++++++++++++++++++++++-----------
>>>   1 file changed, 44 insertions(+), 16 deletions(-)
>>>
>>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>>> index 8fc3b1841d92..40bc58fa57f5 100644
>>> --- a/drivers/net/virtio_net.c
>>> +++ b/drivers/net/virtio_net.c
>>> @@ -1018,6 +1018,7 @@ static struct sk_buff 
>>> *receive_mergeable(struct net_device *dev,
>>>                        unsigned int *xdp_xmit,
>>>                        struct virtnet_rq_stats *stats)
>>>   {
>>> +    unsigned int tailroom = SKB_DATA_ALIGN(sizeof(struct 
>>> skb_shared_info));
>>>       struct virtio_net_hdr_mrg_rxbuf *hdr = buf;
>>>       u16 num_buf = virtio16_to_cpu(vi->vdev, hdr->num_buffers);
>>>       struct page *page = virt_to_head_page(buf);
>>> @@ -1048,11 +1049,14 @@ static struct sk_buff 
>>> *receive_mergeable(struct net_device *dev,
>>>       rcu_read_lock();
>>>       xdp_prog = rcu_dereference(rq->xdp_prog);
>>>       if (xdp_prog) {
>>> +        unsigned int xdp_frags_truesz = 0;
>>> +        struct skb_shared_info *shinfo;
>>>           struct xdp_frame *xdpf;
>>>           struct page *xdp_page;
>>>           struct xdp_buff xdp;
>>>           void *data;
>>>           u32 act;
>>> +        int i;
>>>             /* Transient failure which in theory could occur if
>>>            * in-flight packets from before XDP was enabled reach
>>> @@ -1061,19 +1065,23 @@ static struct sk_buff 
>>> *receive_mergeable(struct net_device *dev,
>>>           if (unlikely(hdr->hdr.gso_type))
>>>               goto err_xdp;
>>>   -        /* Buffers with headroom use PAGE_SIZE as alloc size,
>>> -         * see add_recvbuf_mergeable() + get_mergeable_buf_len()
>>> +        /* Now XDP core assumes frag size is PAGE_SIZE, but buffers
>>> +         * with headroom may add hole in truesize, which
>>> +         * make their length exceed PAGE_SIZE. So we disabled the
>>> +         * hole mechanism for xdp. See add_recvbuf_mergeable().
>>>            */
>>>           frame_sz = headroom ? PAGE_SIZE : truesize;
>>>   -        /* This happens when rx buffer size is underestimated
>>> -         * or headroom is not enough because of the buffer
>>> -         * was refilled before XDP is set. This should only
>>> -         * happen for the first several packets, so we don't
>>> -         * care much about its performance.
>>> +        /* This happens when headroom is not enough because
>>> +         * of the buffer was prefilled before XDP is set.
>>> +         * This should only happen for the first several packets.
>>> +         * In fact, vq reset can be used here to help us clean up
>>> +         * the prefilled buffers, but many existing devices do not
>>> +         * support it, and we don't want to bother users who are
>>> +         * using xdp normally.
>>>            */
>>> -        if (unlikely(num_buf > 1 ||
>>> -                 headroom < virtnet_get_headroom(vi))) {
>>> +        if (!xdp_prog->aux->xdp_has_frags &&
>>> +            (num_buf > 1 || headroom < virtnet_get_headroom(vi))) {
>>>               /* linearize data for XDP */
>>>               xdp_page = xdp_linearize_page(rq, &num_buf,
>>>                                 page, offset,
>>> @@ -1084,17 +1092,26 @@ static struct sk_buff 
>>> *receive_mergeable(struct net_device *dev,
>>>               if (!xdp_page)
>>>                   goto err_xdp;
>>>               offset = VIRTIO_XDP_HEADROOM;
>>> +        } else if (unlikely(headroom < virtnet_get_headroom(vi))) {
>>
>>
>> I believe we need to check xdp_prog->aux->xdp_has_frags at least 
>> since this may not work if it needs more than one frags?
>
> Sorry Jason, I didn't understand you, I'll try to answer. For 
> multi-buffer xdp programs, if the first buffer is a pre-filled buffer 
> (no headroom),
> we need to copy it out and use the subsequent buffers of this packet 
> as its frags (this is done in virtnet_build_xdp_buff_mrg()), therefore,
> it seems that there is no need to check 'xdp_prog->aux->xdp_has_frags' 
> to mark multi-buffer xdp (of course I can add it),
>
> + } else if (unlikely(headroom < virtnet_get_headroom(vi))) {
>
> Because the linearization of single-buffer xdp has all been done 
> before, the subsequent situation can only be applied to multi-buffer xdp:
> + if (!xdp_prog->aux->xdp_has_frags &&
> + (num_buf > 1 || headroom < virtnet_get_headroom(vi))) {


I basically meant what happens if

!xdp_prog->aux->xdp_has_frags && num_buf > 2 && headroom < 
virtnet_get_headroom(vi)

In this case the current code seems to leave the second buffer in the 
frags. This is the case of the buffer size underestimation that is 
mentioned in the comment before (I'd like to keep that).

(And that's why I'm asking to use linearizge_page())

Thanks


>
>>
>> Btw, I don't see a reason why we can't reuse xdp_linearize_page(), 
>> (we probably don't need error is the buffer exceeds PAGE_SIZE).
>
> For multi-buffer xdp, we only need to copy out the pre-filled first 
> buffer, and use the remaining buffers of this packet as frags in 
> virtnet_build_xdp_buff_mrg().
>
> Thanks.
>
>>
>> Other looks good.
>>
>> Thanks
>>
>>
>>> +            if ((VIRTIO_XDP_HEADROOM + len + tailroom) > PAGE_SIZE)
>>> +                goto err_xdp;
>>> +
>>> +            xdp_page = alloc_page(GFP_ATOMIC);
>>> +            if (!xdp_page)
>>> +                goto err_xdp;
>>> +
>>> +            memcpy(page_address(xdp_page) + VIRTIO_XDP_HEADROOM,
>>> +                   page_address(page) + offset, len);
>>> +            frame_sz = PAGE_SIZE;
>>> +            offset = VIRTIO_XDP_HEADROOM;
>>>           } else {
>>>               xdp_page = page;
>>>           }
>>> -
>>> -        /* Allow consuming headroom but reserve enough space to push
>>> -         * the descriptor on if we get an XDP_TX return code.
>>> -         */
>>>           data = page_address(xdp_page) + offset;
>>> -        xdp_init_buff(&xdp, frame_sz - vi->hdr_len, &rq->xdp_rxq);
>>> -        xdp_prepare_buff(&xdp, data - VIRTIO_XDP_HEADROOM + 
>>> vi->hdr_len,
>>> -                 VIRTIO_XDP_HEADROOM, len - vi->hdr_len, true);
>>> +        err = virtnet_build_xdp_buff_mrg(dev, vi, rq, &xdp, data, 
>>> len, frame_sz,
>>> +                         &num_buf, &xdp_frags_truesz, stats);
>>> +        if (unlikely(err))
>>> +            goto err_xdp_frags;
>>>             act = bpf_prog_run_xdp(xdp_prog, &xdp);
>>>           stats->xdp_packets++;
>>> @@ -1190,6 +1207,17 @@ static struct sk_buff 
>>> *receive_mergeable(struct net_device *dev,
>>>                   __free_pages(xdp_page, 0);
>>>               goto err_xdp;
>>>           }
>>> +err_xdp_frags:
>>> +        shinfo = xdp_get_shared_info_from_buff(&xdp);
>>> +
>>> +        if (unlikely(xdp_page != page))
>>> +            __free_pages(xdp_page, 0);
>>> +
>>> +        for (i = 0; i < shinfo->nr_frags; i++) {
>>> +            xdp_page = skb_frag_page(&shinfo->frags[i]);
>>> +            put_page(xdp_page);
>>> +        }
>>> +        goto err_xdp;
>>>       }
>>>       rcu_read_unlock();
>

