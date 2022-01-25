Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B88549B2CF
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 12:20:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380608AbiAYLRj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 06:17:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:45465 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1381323AbiAYLPT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 06:15:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643109274;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Rvvfbm9DdsitiqMaGToeqN6bn83eZm9ryJcgfNBtuTE=;
        b=Czv4sJX60lkHayqqwWLvuAFKOVielAm0gzTtOHbQcC1ABUn5Ybb1hLsvWFjig3eJ6D7Z4L
        pGRd2oxReWu2nN7xy7jJjkDRYd0aAA4u0L7lickd6q6GXoVQRimXBagb0qddheyjqFIQGj
        jBRkeL94YWTngKVvzbreksGRHipZCnE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-441-halLLIX5OKuuw2Fegy0MoQ-1; Tue, 25 Jan 2022 06:14:32 -0500
X-MC-Unique: halLLIX5OKuuw2Fegy0MoQ-1
Received: by mail-wm1-f72.google.com with SMTP id w5-20020a1cf605000000b0034b8cb1f55eso1099875wmc.0
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 03:14:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Rvvfbm9DdsitiqMaGToeqN6bn83eZm9ryJcgfNBtuTE=;
        b=TnCf2kTk2xFfMkysbmjLsziOmMMznhAXp8xhxvYARPbsCmsRNfNqV/3F800JQWqz1l
         3v7YT5BBh4SlV9FSsLwmsHDajBw7hPLmJtGKYqJhj8mrFvyjSH/ANq+51Ls42X1HFolR
         6PAyfFrwndCXcS7Ub0brzUrgpQFd8mIqwrFe4VKc4KKmInPR4nyQll+bXTTi3RQutxww
         9ciSgvBdopiaXphivCm9VPDcBACrwipC56F74rif7X3lxjbXKDanPWsRlerq8e8JZHZw
         pLtpqZqq5zK/SdQRk1G9j7mTvdWxMbqL1PI5k4jHGHoqF8vRIWv0DZWeI9VC7qifY7bv
         YQvA==
X-Gm-Message-State: AOAM532CrkECLNtDcHClPz8QXWqkDCWY9J1uLdaZ3s7GQK1b1XDcTIkD
        0KF/Q25HfjeiEgyQtPka0Ati4gZXIYuuSxlUwxVFgbbkVYjthapHY/a25jRqkAEVpiHp3sABEZS
        O+KY43G77RXjgxugE
X-Received: by 2002:adf:ebd2:: with SMTP id v18mr18147982wrn.502.1643109266761;
        Tue, 25 Jan 2022 03:14:26 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwe9f8UE+t1HaCGIVAqAvlkesdvDMkIgGHznqy4t0x7dqgJcd7Nmt776tM9Ir7lrl12OgiLkA==
X-Received: by 2002:adf:ebd2:: with SMTP id v18mr18147939wrn.502.1643109266078;
        Tue, 25 Jan 2022 03:14:26 -0800 (PST)
Received: from steredhat ([62.19.185.119])
        by smtp.gmail.com with ESMTPSA id t14sm60428wmq.21.2022.01.25.03.14.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 03:14:25 -0800 (PST)
Date:   Tue, 25 Jan 2022 12:14:22 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH v1] vhost: cache avail index in vhost_enable_notify()
Message-ID: <20220125111422.tmsnk575jo7ckt46@steredhat>
References: <20220114090508.36416-1-sgarzare@redhat.com>
 <Ye6OJdi2M1EBx7b3@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <Ye6OJdi2M1EBx7b3@stefanha-x1.localdomain>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 24, 2022 at 11:31:49AM +0000, Stefan Hajnoczi wrote:
>On Fri, Jan 14, 2022 at 10:05:08AM +0100, Stefano Garzarella wrote:
>> In vhost_enable_notify() we enable the notifications and we read
>> the avail index to check if new buffers have become available in
>> the meantime.
>>
>> We are not caching the avail index, so when the device will call
>> vhost_get_vq_desc(), it will find the old value in the cache and
>> it will read the avail index again.
>
>I think this wording is clearer because we do keep a cached the avail
>index value, but the issue is we don't update it:
>s/We are not caching the avail index/We do not update the cached avail
>index value/

I'll fix in v3.
It seems I forgot to CC you on v2: 
https://lore.kernel.org/virtualization/20220121153108.187291-1-sgarzare@redhat.com/

>
>>
>> It would be better to refresh the cache every time we read avail
>> index, so let's change vhost_enable_notify() caching the value in
>> `avail_idx` and compare it with `last_avail_idx` to check if there
>> are new buffers available.
>>
>> Anyway, we don't expect a significant performance boost because
>> the above path is not very common, indeed vhost_enable_notify()
>> is often called with unlikely(), expecting that avail index has
>> not been updated.
>>
>> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>> ---
>> v1:
>> - improved the commit description [MST, Jason]
>> ---
>>  drivers/vhost/vhost.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
>> index 59edb5a1ffe2..07363dff559e 100644
>> --- a/drivers/vhost/vhost.c
>> +++ b/drivers/vhost/vhost.c
>> @@ -2543,8 +2543,9 @@ bool vhost_enable_notify(struct vhost_dev *dev, 
>> struct vhost_virtqueue *vq)
>>  		       &vq->avail->idx, r);
>>  		return false;
>>  	}
>> +	vq->avail_idx = vhost16_to_cpu(vq, avail_idx);
>>
>> -	return vhost16_to_cpu(vq, avail_idx) != vq->avail_idx;
>> +	return vq->avail_idx != vq->last_avail_idx;
>
>vhost_vq_avail_empty() has a fast path that's missing in
>vhost_enable_notify():
>
>  if (vq->avail_idx != vq->last_avail_idx)
>      return false;

Yep, I thought about that, but devices usually call 
vhost_enable_notify() right when vq->avail_idx == vq->last_avail_idx, so 
I don't know if it's an extra check for a branch that will never be 
taken.

Do you think it is better to add that check? (maybe with unlikely())

Thanks,
Stefano

