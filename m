Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC1039B07F
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 04:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbhFDCjX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 22:39:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43943 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229758AbhFDCjW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 22:39:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622774257;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kOghEYXtPzp+Dy+j69IwEyf3koTKLk9pf72ZLOxEDSY=;
        b=QrcYfmSa3B6RzAbAs96Q3tY2t1s+K+7kusyH2bzi2qQsc4XIa3WlJjsKozpSh+qojVQY3R
        ZTqSW/NZguye8vIoYvRfVLvyu3FNBpOImsn6nszNGjxHVLGAIH0wHZhB9QfQELUL5RbofS
        r41NlkEdfJWQXOCqoPeuay8q1+Q+nio=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-90-MKI1PoUDO4S1jSg4NAkXow-1; Thu, 03 Jun 2021 22:37:35 -0400
X-MC-Unique: MKI1PoUDO4S1jSg4NAkXow-1
Received: by mail-pf1-f197.google.com with SMTP id b8-20020a056a000a88b02902e97a71383dso4522086pfl.13
        for <netdev@vger.kernel.org>; Thu, 03 Jun 2021 19:37:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=kOghEYXtPzp+Dy+j69IwEyf3koTKLk9pf72ZLOxEDSY=;
        b=Wm++CYX5lzXLG9WsXGqoAAoAEUwt76bKPHWlxChn1CmBcvvubTeckAokcyARzIp8Bl
         ODvsqZIyKZ6S/Hy5/ggkY3CW1t5Vb1kcS9b3602JanJ0SKrU562H41hcLOm7ln0EGfJb
         110Jr7GsIuTD1gJK9itL90wehI0fpgtakF3d/neYTvRzIC8/nm75e102rN3eio4yGh51
         +giCoz4Zf44MuTfUN4L+Yps+N2NgoWHCqJfVLWTDlDjooPwJig9GKll+oXij9VSMOU81
         8UdqvYx6udR8PDeLIlq/wfBonu5uKyCR9mFqOyidn2ru5nhrO0OBqrzKk4XmrjiY5DQU
         D61A==
X-Gm-Message-State: AOAM532Z2bUnOXp3amBCyVAK34qLBEFLugSbWx/I6+hnuNnWsbNT8alg
        Vx3XqvfZVw1WTK8+22h4TRORs0YQ4lb638XIf8zM67SLDi8X5IZ8cktiEF0xWLj7QsUgYSG2PMl
        zTuCHNKk+lEBBpPEm
X-Received: by 2002:a65:4109:: with SMTP id w9mr2569870pgp.24.1622774254754;
        Thu, 03 Jun 2021 19:37:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyO+9ehWqEf54UWMqlG5rIQ/fRaRzW8G0Ta0PUxjkaNeUBZnbDO3aVcQ4c02+JK6pUbEW7hUg==
X-Received: by 2002:a65:4109:: with SMTP id w9mr2569857pgp.24.1622774254526;
        Thu, 03 Jun 2021 19:37:34 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g63sm329829pfb.55.2021.06.03.19.37.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Jun 2021 19:37:34 -0700 (PDT)
Subject: Re: [PATCH net-next] virtio_net: set link state down when virtqueue
 is broken
To:     wangyunjian <wangyunjian@huawei.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mst@redhat.com" <mst@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        dingxiaoxiong <dingxiaoxiong@huawei.com>
References: <79907bf6c835572b4af92f16d9a3ff2822b1c7ea.1622028946.git.wangyunjian@huawei.com>
 <03c68dd1-a636-9d3b-1dec-5e11c8025ccc@redhat.com>
 <d18383f7e675452d9392321506db6fa0@huawei.com>
 <0fcc1413-cb20-7a17-bdcd-6f9994990432@redhat.com>
 <20a5f1bd8a5a49fa8c0f90875a49631b@huawei.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <1cc933e6-cde4-ba20-3c54-7391db93a9a1@redhat.com>
Date:   Fri, 4 Jun 2021 10:37:30 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20a5f1bd8a5a49fa8c0f90875a49631b@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/6/3 下午7:34, wangyunjian 写道:
>> -----Original Message-----
>> From: Jason Wang [mailto:jasowang@redhat.com]
>> Sent: Monday, May 31, 2021 11:29 AM
>> To: wangyunjian <wangyunjian@huawei.com>; netdev@vger.kernel.org
>> Cc: kuba@kernel.org; davem@davemloft.net; mst@redhat.com;
>> virtualization@lists.linux-foundation.org; dingxiaoxiong
>> <dingxiaoxiong@huawei.com>
>> Subject: Re: [PATCH net-next] virtio_net: set link state down when virtqueue is
>> broken
>>
>>
>> 在 2021/5/28 下午6:58, wangyunjian 写道:
>>>> -----Original Message-----
>>>>> From: Yunjian Wang <wangyunjian@huawei.com>
>>>>>
>>>>> The NIC can't receive/send packets if a rx/tx virtqueue is broken.
>>>>> However, the link state of the NIC is still normal. As a result, the
>>>>> user cannot detect the NIC exception.
>>>> Doesn't we have:
>>>>
>>>>           /* This should not happen! */
>>>>            if (unlikely(err)) {
>>>>                    dev->stats.tx_fifo_errors++;
>>>>                    if (net_ratelimit())
>>>>                            dev_warn(&dev->dev,
>>>>                                     "Unexpected TXQ (%d)
>> queue
>>>> failure: %d\n",
>>>>                                     qnum, err);
>>>>                    dev->stats.tx_dropped++;
>>>>                    dev_kfree_skb_any(skb);
>>>>                    return NETDEV_TX_OK;
>>>>            }
>>>>
>>>> Which should be sufficient?
>>> There may be other reasons for this error, e.g -ENOSPC(no free desc).
>>
>> This should not happen unless the device or driver is buggy. We always reserved
>> sufficient slots:
>>
>>           if (sq->vq->num_free < 2+MAX_SKB_FRAGS) {
>>                   netif_stop_subqueue(dev, qnum); ...
>>
>>
>>> And if rx virtqueue is broken, there is no error statistics.
>>
>> Feel free to add one if it's necessary.
> Currently receiving scenario, it is impossible to distinguish whether the reason for
> not receiving packet is virtqueue's broken or no packet.


Can we introduce rx_fifo_errors for that?


>
>> Let's leave the policy decision (link down) to userspace.
>>
>>
>>>>> The driver can set the link state down when the virtqueue is broken.
>>>>> If the state is down, the user can switch over to another NIC.
>>>> Note that, we probably need the watchdog for virtio-net in order to
>>>> be a complete solution.
>>> Yes, I can think of is that the virtqueue's broken exception is detected on
>> watchdog.
>>> Is there anything else that needs to be done?
>>
>> Basically, it's all about TX stall which watchdog tries to catch. Broken vq is only
>> one of the possible reason.
> Are there any plans for the watchdog?


Somebody posted a prototype 3 or 4 years ago, you can search it and 
maybe we can start from there.

Thanks


>
> Thanks
>
>> Thanks
>>
>>
>>> Thanks
>>>
>>>> Thanks
>>>>
>>>>

