Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F30638FAC4
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 08:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230463AbhEYGUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 02:20:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44606 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230224AbhEYGUo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 02:20:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621923554;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rP1fweoyRJtr6Mi6XlE6lVpYI+0VMhwzNpbtJBa3S1E=;
        b=CI25JyNrQixwpKwXEYmEusbXSjmDWoFQmGMCBgFNsRzBlhsb/MfQAksDfr5+2miJa/8V/N
        VKk1G9iz8anJpitdL3KL2RaoupF/EXs7rcFFIfR6r2DIXadG+GU8pzLA39uf6qcB+wb7Yl
        NepbRBXYTR8XrS5xfmBag/D6P1JkTVk=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-46-VcsM7LN2PcGM-nFEXb5_sg-1; Tue, 25 May 2021 02:19:12 -0400
X-MC-Unique: VcsM7LN2PcGM-nFEXb5_sg-1
Received: by mail-pl1-f197.google.com with SMTP id t13-20020a170902dccdb02900f0bc643e1fso14081407pll.2
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 23:19:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=rP1fweoyRJtr6Mi6XlE6lVpYI+0VMhwzNpbtJBa3S1E=;
        b=OejJ4CWZiADVNqofUEttpF9gOg+SFrFLqwn7lOfdrVbpwY5NQt2tX83Ul1CCPkCAXk
         wf4Ie1cYOQtxH1VSSR8EzfXhNxh6ixvUQRUgjbV1d+z+6Nkb5OP9K4hV3O3+vljR97BT
         06u4DdDePd7plvRyuU5s2AdvGfAgVQe7oL1au+GOquS4WQmstGJUNikPxsE5r0vcBpOo
         w5PpOxRK7umwsAklmXSjEk1qalrG77+wsBOTAwXw1zgoSaisMc8Ahshhgp3REqyPE0bh
         8rvnizmXph54OJT4Cit1ZSJkLg8ZPSkMZy48V8BbVYGFySYw3JqBIwbu+bBy58bR3a+B
         hIRw==
X-Gm-Message-State: AOAM533MilrjGzxLvvm8Oz7LGwaLpeUA2nNdAlInhxqIBD1JNV1mkVCD
        mweIlS83Jce5OEfHZWFlPRclj81wk+RLQNxIjHwjChjjaYL0bqvN/UeU5MlYnRAysjk6hLZG5P/
        dSDU3TsMSKl2+XiwD
X-Received: by 2002:a17:90a:3988:: with SMTP id z8mr29530496pjb.175.1621923551449;
        Mon, 24 May 2021 23:19:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzHuSGZNZRBpr7BFjN2z2DGgUtoW4OBh5VlH3j5+cXLDOpjFD+S6KAYt8UK28l5a4+wF9lImw==
X-Received: by 2002:a17:90a:3988:: with SMTP id z8mr29530464pjb.175.1621923551060;
        Mon, 24 May 2021 23:19:11 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id r13sm12449973pfl.191.2021.05.24.23.19.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 May 2021 23:19:10 -0700 (PDT)
Subject: Re: [PATCH] virtio_net: Remove BUG() to aviod machine dead
To:     Xianting Tian <xianting.tian@linux.alibaba.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <a351fbe1-0233-8515-2927-adc826a7fb94@linux.alibaba.com>
 <20210518055336-mutt-send-email-mst@kernel.org>
 <4aaf5125-ce75-c72a-4b4a-11c91cb85a72@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <72f284c6-b2f5-a395-a68f-afe801eb81be@redhat.com>
Date:   Tue, 25 May 2021 14:19:03 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <4aaf5125-ce75-c72a-4b4a-11c91cb85a72@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/5/19 下午10:18, Xianting Tian 写道:
> thanks, I submit the patch as commented by Andrew 
> https://lkml.org/lkml/2021/5/18/256
>
> Actually, if xmit_skb() returns error, below code will give a warning 
> with error code.
>
>     /* Try to transmit */
>     err = xmit_skb(sq, skb);
>
>     /* This should not happen! */
>     if (unlikely(err)) {
>         dev->stats.tx_fifo_errors++;
>         if (net_ratelimit())
>             dev_warn(&dev->dev,
>                  "Unexpected TXQ (%d) queue failure: %d\n",
>                  qnum, err);
>         dev->stats.tx_dropped++;
>         dev_kfree_skb_any(skb);
>         return NETDEV_TX_OK;
>     }
>
>
>
>
>
> 在 2021/5/18 下午5:54, Michael S. Tsirkin 写道:
>> typo in subject
>>
>> On Tue, May 18, 2021 at 05:46:56PM +0800, Xianting Tian wrote:
>>> When met error, we output a print to avoid a BUG().


So you don't explain why you need to remove BUG(). I think it deserve a 
BUG().


>>>
>>> Signed-off-by: Xianting Tian <xianting.tian@linux.alibaba.com>
>>> ---
>>>   drivers/net/virtio_net.c | 5 ++---
>>>   1 file changed, 2 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>>> index c921ebf3ae82..a66174d13e81 100644
>>> --- a/drivers/net/virtio_net.c
>>> +++ b/drivers/net/virtio_net.c
>>> @@ -1647,9 +1647,8 @@ static int xmit_skb(struct send_queue *sq, struct
>>> sk_buff *skb)
>>>           hdr = skb_vnet_hdr(skb);
>>>
>>>       if (virtio_net_hdr_from_skb(skb, &hdr->hdr,
>>> -                    virtio_is_little_endian(vi->vdev), false,
>>> -                    0))
>>> -        BUG();
>>> +                virtio_is_little_endian(vi->vdev), false, 0))
>>> +        return -EPROTO;
>>>
>>
>> why EPROTO? can you add some comments to explain what is going on pls?
>>
>> is this related to a malicious hypervisor thing?


I think not if I was not wrong.

Each sources (either userspace or device), the skb should be built 
through virtio_net_hdr_to_skb() which means the validation has already 
been done.

If we it fails here, it's a real bug.

Thanks


>>
>> don't we want at least a WARN_ON? Or _ONCE?
>>
>>>       if (vi->mergeable_rx_bufs)
>>>           hdr->num_buffers = 0;
>>> -- 
>>> 2.17.1
>

