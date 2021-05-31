Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA60D395436
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 05:36:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230041AbhEaDau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 May 2021 23:30:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30345 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229952AbhEaDau (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 May 2021 23:30:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622431750;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m45hNuVFYeGW1Xz/2rfmBSBDjFlEr9Kgts0SpTXrBnw=;
        b=LDa3Am0z2XxM2HyE0EF8/hWASvcC9mXQDl5nd1CgyTspNKdUP28seFEFncLRwPTjjw3DZY
        +QCHDpsciUip5usczhMhtH0VlFIvMdv65eRgOIGXeo5Cdi+pT1S52iR33LZTxOqNzt4mEw
        LUlSgNMRQdPZhxghEPIK+9O+lXSaIWU=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-15-aLmgxnCBOfOzPqJAzmf2Vw-1; Sun, 30 May 2021 23:29:07 -0400
X-MC-Unique: aLmgxnCBOfOzPqJAzmf2Vw-1
Received: by mail-pj1-f70.google.com with SMTP id i8-20020a17090a7188b029015f9564a698so9616552pjk.8
        for <netdev@vger.kernel.org>; Sun, 30 May 2021 20:29:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=m45hNuVFYeGW1Xz/2rfmBSBDjFlEr9Kgts0SpTXrBnw=;
        b=efmv5pPM8GD4Zw5YXEkUTWZKGxAKUJyH6tm+msZE1pdRo1jVroUjv9WjnO19xYAkbq
         cXU+bVrO5Oi9kV8OUBNwYkQxU3y/EYERBSMgPFWvH3/CucBGU9KTIPJqtAQuUaLnYrfs
         pv/MKp663MSF3sWBmxW6y35hqucwOz6ovD9VYW7NMpvIYvs9hO5nweisMJAdVF/obBwf
         cfgn8J7YrR4tK208D8eGft7zQMFzSL4fPUIvQ6kCWX0CUSFX8UEHKSAh67DX7n/bXBwG
         gWqs9Bz+1OKFotd9cYkvG41QwRSypnvbh0wHH7R43y9s2mvNcQ7CL4Y6n2j0obBre3uY
         IDnA==
X-Gm-Message-State: AOAM530CEaGLSuB/01t8BHy9U12uV1h8By0r6elfxZQw+V8W8o4VxZOT
        u92ZI6LacXJfqlr4KzcDM6Lck71FtkH2ad8x1pXOh1mX5WlCJS95uDMHeanySdWOjTzseheJksE
        5gFOCQNDXIeg3kiHl
X-Received: by 2002:a17:90a:1588:: with SMTP id m8mr17072558pja.31.1622431746044;
        Sun, 30 May 2021 20:29:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy/d/61zAmRkvATlZvt85qn1GHGi5BiOuv5Z+UIHQ5rWVq/ZAEduNPO3CWSD13UAG0w6hZDGw==
X-Received: by 2002:a17:90a:1588:: with SMTP id m8mr17072544pja.31.1622431745832;
        Sun, 30 May 2021 20:29:05 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id mp21sm9923834pjb.50.2021.05.30.20.29.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 30 May 2021 20:29:05 -0700 (PDT)
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
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <0fcc1413-cb20-7a17-bdcd-6f9994990432@redhat.com>
Date:   Mon, 31 May 2021 11:28:57 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <d18383f7e675452d9392321506db6fa0@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/5/28 下午6:58, wangyunjian 写道:
>> -----Original Message-----
>>> From: Yunjian Wang <wangyunjian@huawei.com>
>>>
>>> The NIC can't receive/send packets if a rx/tx virtqueue is broken.
>>> However, the link state of the NIC is still normal. As a result, the
>>> user cannot detect the NIC exception.
>>
>> Doesn't we have:
>>
>>          /* This should not happen! */
>>           if (unlikely(err)) {
>>                   dev->stats.tx_fifo_errors++;
>>                   if (net_ratelimit())
>>                           dev_warn(&dev->dev,
>>                                    "Unexpected TXQ (%d) queue
>> failure: %d\n",
>>                                    qnum, err);
>>                   dev->stats.tx_dropped++;
>>                   dev_kfree_skb_any(skb);
>>                   return NETDEV_TX_OK;
>>           }
>>
>> Which should be sufficient?
> There may be other reasons for this error, e.g -ENOSPC(no free desc).


This should not happen unless the device or driver is buggy. We always 
reserved sufficient slots:

         if (sq->vq->num_free < 2+MAX_SKB_FRAGS) {
                 netif_stop_subqueue(dev, qnum);
...


> And if rx virtqueue is broken, there is no error statistics.


Feel free to add one if it's necessary.

Let's leave the policy decision (link down) to userspace.


>
>>
>>> The driver can set the link state down when the virtqueue is broken.
>>> If the state is down, the user can switch over to another NIC.
>>
>> Note that, we probably need the watchdog for virtio-net in order to be a
>> complete solution.
> Yes, I can think of is that the virtqueue's broken exception is detected on watchdog.
> Is there anything else that needs to be done?


Basically, it's all about TX stall which watchdog tries to catch. Broken 
vq is only one of the possible reason.

Thanks


>
> Thanks
>
>> Thanks
>>
>>

