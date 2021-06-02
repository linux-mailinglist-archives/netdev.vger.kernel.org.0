Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C21303982C2
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 09:15:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231565AbhFBHQs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 03:16:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36233 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231557AbhFBHQr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 03:16:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622618104;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Lhy5TNU50fmOq5Bhp93lg/KbZ5b2aX5N5cZ4YcFgRAI=;
        b=IAXzQJ7A37/t7sZLNC9wXwkFwJF47z5ooLUArfUYIp77i2PozJWtYfSAFLn+vhSEOKQ6l/
        VBBGp5XaKG3CononAHaFX36Z3+j9t9QN59+baNU88weK4vE4b1XzVl0owvButS16l+Mq56
        65DHTR27y5cPszF68uovORcVQe/d1P0=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-269-pezNVh-GOk6ejSnbKg3a4w-1; Wed, 02 Jun 2021 03:15:01 -0400
X-MC-Unique: pezNVh-GOk6ejSnbKg3a4w-1
Received: by mail-pg1-f200.google.com with SMTP id k193-20020a633dca0000b029021ff326b222so1137053pga.9
        for <netdev@vger.kernel.org>; Wed, 02 Jun 2021 00:15:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Lhy5TNU50fmOq5Bhp93lg/KbZ5b2aX5N5cZ4YcFgRAI=;
        b=klD9l8yLAy3FFFFLymGbE8p/9M06jKQGpi3NE4k3VZxXCiAChIpwiqQvheZDmUfoiz
         UJqjCNbUJILLe0Z+sPqXVPgrE1B3yZBYIgOD5CpQ2t5PSgMt3nXRakwAMQyKhlJA/u5G
         9ThfaRr3gH4XmCsujGZVES+7kepVl+NJYFXJoPkQjzIQSOGMVVAhSJWdBOHUYrVQCVkv
         DNm8U/9JpZDKmxdBXJgfL2ryoCA6ZmmtqI+KmXwZRSoM1DsVL3BOHFUfrY8lmHs2npmo
         GaEiiObZ9WTtp+tMtlHsZHU3u2RZLA+eqWlkC1fR+wr8V3JXOb0tHPWZOPl44hOiO69n
         SNQg==
X-Gm-Message-State: AOAM532xMTOIZzNLHxUlgC6ELmKW1pW9aNgSbsZHWvyYeV/60jVv5JQy
        1p+pxHuXYQlGjoGfAISRr0uCRH3/qb8Gf+4NGFqC5LwBbVo3ze4P3MeAf1upImkCAeD+w3E+ux9
        fIhsp1+bLdAX6Wp5g
X-Received: by 2002:a63:1703:: with SMTP id x3mr15032584pgl.421.1622618100243;
        Wed, 02 Jun 2021 00:15:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxufrPCd7Pf/XaCWAaBdiVWeER94rYldeUimhvZhIrvYw6A2cPFCPX7XVd/UFcPhoryLQJVig==
X-Received: by 2002:a63:1703:: with SMTP id x3mr15032563pgl.421.1622618100025;
        Wed, 02 Jun 2021 00:15:00 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id c134sm15028445pfb.135.2021.06.02.00.14.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Jun 2021 00:14:59 -0700 (PDT)
Subject: Re: [PATCH] virtio_net: Remove BUG() to aviod machine dead
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Xianting Tian <xianting.tian@linux.alibaba.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <a351fbe1-0233-8515-2927-adc826a7fb94@linux.alibaba.com>
 <20210518055336-mutt-send-email-mst@kernel.org>
 <4aaf5125-ce75-c72a-4b4a-11c91cb85a72@linux.alibaba.com>
 <72f284c6-b2f5-a395-a68f-afe801eb81be@redhat.com> <YLcePtKhnt9gXq8E@unreal>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <b80a2841-32aa-02ff-b2cc-f2fb3eeed9a1@redhat.com>
Date:   Wed, 2 Jun 2021 15:14:50 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <YLcePtKhnt9gXq8E@unreal>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/6/2 下午1:59, Leon Romanovsky 写道:
> On Tue, May 25, 2021 at 02:19:03PM +0800, Jason Wang wrote:
>> 在 2021/5/19 下午10:18, Xianting Tian 写道:
>>> thanks, I submit the patch as commented by Andrew
>>> https://lkml.org/lkml/2021/5/18/256
>>>
>>> Actually, if xmit_skb() returns error, below code will give a warning
>>> with error code.
>>>
>>>      /* Try to transmit */
>>>      err = xmit_skb(sq, skb);
>>>
>>>      /* This should not happen! */
>>>      if (unlikely(err)) {
>>>          dev->stats.tx_fifo_errors++;
>>>          if (net_ratelimit())
>>>              dev_warn(&dev->dev,
>>>                   "Unexpected TXQ (%d) queue failure: %d\n",
>>>                   qnum, err);
>>>          dev->stats.tx_dropped++;
>>>          dev_kfree_skb_any(skb);
>>>          return NETDEV_TX_OK;
>>>      }
>>>
>>>
>>>
>>>
>>>
>>> 在 2021/5/18 下午5:54, Michael S. Tsirkin 写道:
>>>> typo in subject
>>>>
>>>> On Tue, May 18, 2021 at 05:46:56PM +0800, Xianting Tian wrote:
>>>>> When met error, we output a print to avoid a BUG().
>>
>> So you don't explain why you need to remove BUG(). I think it deserve a
>> BUG().
> BUG() will crash the machine and virtio_net is not kernel core
> functionality that must stop the machine to prevent anything truly
> harmful and basic.


Note that the BUG() here is not for virtio-net itself. It tells us that 
a bug was found by virtio-net.

That is, the one that produces the skb has a bug, usually it's the 
network core.

There could also be the issue of the packet from untrusted source 
(userspace like TAP or packet socket) but they should be validated there.

Thanks


>
> I would argue that code in drivers/* shouldn't call BUG() macros at all.
>
> If it is impossible, don't check for that or add WARN_ON() and recover,
> but don't crash whole system.
>
> Thanks
>

