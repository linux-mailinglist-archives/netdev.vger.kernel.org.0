Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C93839D2F2
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 04:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbhFGCa7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Jun 2021 22:30:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56930 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230193AbhFGCa6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Jun 2021 22:30:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623032947;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5VUeJVdhPn2VuLW7BaccrekOt7TaxxTxZqwvCsiTqLA=;
        b=bUFuofInTLh8Sa4kbMx1BIbBBQTJc1Yin7k5aamCrYsePfokEjKf2eNK1n2fmcX4iI7trt
        w+pzZNGBfYFFxSbYF1Iq6CVnJ7PkXr+HoK0tcooFMRCRUTvADtDZzG98kHuF89Fijp1THp
        NNwHySuVSSu7zzDNwx7QRMPeIFixf0A=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-493-mqd1kZOXMWqReEWaMbH-FA-1; Sun, 06 Jun 2021 22:29:02 -0400
X-MC-Unique: mqd1kZOXMWqReEWaMbH-FA-1
Received: by mail-pf1-f198.google.com with SMTP id i13-20020aa78b4d0000b02902ea019ef670so6975270pfd.0
        for <netdev@vger.kernel.org>; Sun, 06 Jun 2021 19:29:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=5VUeJVdhPn2VuLW7BaccrekOt7TaxxTxZqwvCsiTqLA=;
        b=Z6NCd85GkMGgJ2p8Q3xOOQ7d8U+rYiByC2qYiQSxfI8FfvsB6ESOUVYB9tSEHIDGuF
         H55Qwcl03vjz9hSIXETItQm2McBa2Ojuv8gLWQi6PXgtzyBpvYqejZ/LstJ0WUbfU+/n
         nysAbnjDH9BkfhoVxJLmyJp+wtmI2n4lXEuaX3tt/m1PBKaxj45juqDI+Qmp/qwT3YhI
         HsfWCpywADObxDaCNpPcKA9Wg9m7x0dZZowoyL7B1sxtIPKIAUhB2Aya8zpgqUCgoh5X
         9Hc+CAIvDSAnqCJZMsgOvcwLuoBr6wYSVzMKwIzUSXXz91q96r5ByPnPX03G4726WGZZ
         uNkw==
X-Gm-Message-State: AOAM5304XDvsElbZxOPKG6zKyTBQDY+jFditYseIgdo3HNsPcqCijBOJ
        YBMj8Qx+/uCrw+fKXXgc7VFLuRXOPv29TFwjP97W8G70+u2TJ/luXKyseFB6+q7rLR0JLJfk6ST
        xYAUSsWhnLQpXs2ic
X-Received: by 2002:a17:90b:4b51:: with SMTP id mi17mr30393731pjb.109.1623032941724;
        Sun, 06 Jun 2021 19:29:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwvVvxNkgnHrJ2d3RgrbdFzecGugtjc5EPSwjXywyTeTkJohMyytdl/wnAUpQRjX3BuI/eg8Q==
X-Received: by 2002:a17:90b:4b51:: with SMTP id mi17mr30393705pjb.109.1623032941406;
        Sun, 06 Jun 2021 19:29:01 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id in24sm3095374pjb.54.2021.06.06.19.28.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Jun 2021 19:29:00 -0700 (PDT)
Subject: Re: [PATCH net-next] virtio_net: set link state down when virtqueue
 is broken
To:     wangyunjian <wangyunjian@huawei.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jcfaracco@gmail.com" <jcfaracco@gmail.com>
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
 <1cc933e6-cde4-ba20-3c54-7391db93a9a1@redhat.com>
 <5d6fdd5c8e62498ba804aa22d71eb6a8@huawei.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <0cc0cba2-dcda-6d8c-4304-af51089a649e@redhat.com>
Date:   Mon, 7 Jun 2021 10:28:56 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <5d6fdd5c8e62498ba804aa22d71eb6a8@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/6/5 下午3:10, wangyunjian 写道:
>> -----Original Message-----
>> From: Jason Wang [mailto:jasowang@redhat.com]
>> Sent: Friday, June 4, 2021 10:38 AM
>> To: wangyunjian <wangyunjian@huawei.com>; netdev@vger.kernel.org
>> Cc: kuba@kernel.org; davem@davemloft.net; mst@redhat.com;
>> virtualization@lists.linux-foundation.org; dingxiaoxiong
>> <dingxiaoxiong@huawei.com>
>> Subject: Re: [PATCH net-next] virtio_net: set link state down when virtqueue is
>> broken
>>
>>
>> 在 2021/6/3 下午7:34, wangyunjian 写道:
>>>> -----Original Message-----
>>>> From: Jason Wang [mailto:jasowang@redhat.com]
>>>> Sent: Monday, May 31, 2021 11:29 AM
>>>> To: wangyunjian <wangyunjian@huawei.com>; netdev@vger.kernel.org
>>>> Cc: kuba@kernel.org; davem@davemloft.net; mst@redhat.com;
>>>> virtualization@lists.linux-foundation.org; dingxiaoxiong
>>>> <dingxiaoxiong@huawei.com>
>>>> Subject: Re: [PATCH net-next] virtio_net: set link state down when
>>>> virtqueue is broken
>>>>
>>>>
>>>> 在 2021/5/28 下午6:58, wangyunjian 写道:
>>>>>> -----Original Message-----
>>>>>>> From: Yunjian Wang <wangyunjian@huawei.com>
>>>>>>>
>>>>>>> The NIC can't receive/send packets if a rx/tx virtqueue is broken.
>>>>>>> However, the link state of the NIC is still normal. As a result,
>>>>>>> the user cannot detect the NIC exception.
>>>>>> Doesn't we have:
>>>>>>
>>>>>>            /* This should not happen! */
>>>>>>             if (unlikely(err)) {
>>>>>>                     dev->stats.tx_fifo_errors++;
>>>>>>                     if (net_ratelimit())
>>>>>>                             dev_warn(&dev->dev,
>>>>>>                                      "Unexpected TXQ (%d)
>>>> queue
>>>>>> failure: %d\n",
>>>>>>                                      qnum, err);
>>>>>>                     dev->stats.tx_dropped++;
>>>>>>                     dev_kfree_skb_any(skb);
>>>>>>                     return NETDEV_TX_OK;
>>>>>>             }
>>>>>>
>>>>>> Which should be sufficient?
>>>>> There may be other reasons for this error, e.g -ENOSPC(no free desc).
>>>> This should not happen unless the device or driver is buggy. We
>>>> always reserved sufficient slots:
>>>>
>>>>            if (sq->vq->num_free < 2+MAX_SKB_FRAGS) {
>>>>                    netif_stop_subqueue(dev, qnum); ...
>>>>
>>>>
>>>>> And if rx virtqueue is broken, there is no error statistics.
>>>> Feel free to add one if it's necessary.
>>> Currently receiving scenario, it is impossible to distinguish whether
>>> the reason for not receiving packet is virtqueue's broken or no packet.
>>
>> Can we introduce rx_fifo_errors for that?
>>
>>
>>>> Let's leave the policy decision (link down) to userspace.
>>>>
>>>>
>>>>>>> The driver can set the link state down when the virtqueue is broken.
>>>>>>> If the state is down, the user can switch over to another NIC.
>>>>>> Note that, we probably need the watchdog for virtio-net in order to
>>>>>> be a complete solution.
>>>>> Yes, I can think of is that the virtqueue's broken exception is
>>>>> detected on
>>>> watchdog.
>>>>> Is there anything else that needs to be done?
>>>> Basically, it's all about TX stall which watchdog tries to catch.
>>>> Broken vq is only one of the possible reason.
>>> Are there any plans for the watchdog?
>>
>> Somebody posted a prototype 3 or 4 years ago, you can search it and maybe we
>> can start from there.
> I find the patch (https://patchwork.ozlabs.org/project/netdev/patch/20191126200628.22251-3-jcfaracco@gmail.com/)
>
> The patch checks only the scenario where the sending queue is abnormal, but can
> not detect the exception in the receiving queue.


It's almost impossible to detect the abnormal of receiving queue since 
we there's no deterministic time for a receiving packet.


>
> And the patch restores the NIC by reset, which is inappropriate because the broken
> state may be caused by a front-end or back-end bug. We should keep the scene to
> locate bugs.


This could be changed, we can increase the error counters and let 
userspce to decide what to do.

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
>>>>> Thanks
>>>>>
>>>>>> Thanks
>>>>>>
>>>>>>

