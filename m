Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9183AE316
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 08:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbhFUGYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 02:24:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24458 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229710AbhFUGYe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 02:24:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624256489;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eCe0XqT7hlnzVykEXgQZZ3co5Ktu3F1QMr/REXMNOgY=;
        b=KOJpasMzA37O7vVn6DrvUYAfmkQQdCZQBAkWoCq89We4ah/oZ5vsBc55oL4VY8dhXd0p3U
        2TINkA9nljNatkEUW7f//k1Ks2mhBLVtV4nv0B5FG/ttueksfpJoZPSFZei4/CbzjLCv5k
        SjX505+C8HIfA49pRTNgaa8gIToyRHM=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-558-2hGiwc9wOayWJL4Nd9_jmw-1; Mon, 21 Jun 2021 02:21:23 -0400
X-MC-Unique: 2hGiwc9wOayWJL4Nd9_jmw-1
Received: by mail-pl1-f197.google.com with SMTP id z7-20020a1709028f87b02901204079e8d7so3420347plo.4
        for <netdev@vger.kernel.org>; Sun, 20 Jun 2021 23:21:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=eCe0XqT7hlnzVykEXgQZZ3co5Ktu3F1QMr/REXMNOgY=;
        b=hd16j4FOIl1wDDkqHUYUIehuSZh7N8hefrjLkz/23Wrf3Eu6cgfEPme4z7cZefWfGj
         Dyp9zvcosERWayLcPW+bSVFTt76PTMTr2dYRSR4O+dk4PjsiVz4LONhjR3lR2fa9pj0C
         TtivbUDZ5VXRY/re64Pg6agroVH08ubA0pbfDPsEvEzJH6ZanM9+GyNb4gu+zj7AIMOX
         YkUDL0jHDgXsyHkkzRzn6/JvQYJ8vPGVzef0tUii22zKmTR0rokBdN2jRiDq9hrDaKBi
         CqW4gaGuVPjSefEarI7XEdqLYCamhfwbibV3uBdWub94I+3Ec3Eq7FUD8EfuGrZr+YJX
         t09g==
X-Gm-Message-State: AOAM532BaHGTEDNKTpTQIhKnehPXWHcfOKWPaqgEvuwCGwxXZ15O9wm+
        neeKKJzUAYAxWbsJKCCse/sRHQVoj79w26B/qlST23K+6p9WWEzjRoIfg5T3sLSpTyYEsdpZc2h
        pCsq8SmC3bjAyt1e5
X-Received: by 2002:a17:902:aa8d:b029:11a:9225:3ea with SMTP id d13-20020a170902aa8db029011a922503eamr16511413plr.49.1624256482751;
        Sun, 20 Jun 2021 23:21:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzJeu9sPwDlIU9dv9ukuvBcRNyJ/YNl903d3lts/alsUMOf5sU5/MEufbhvdpGykP1ZvZWlSQ==
X-Received: by 2002:a17:902:aa8d:b029:11a:9225:3ea with SMTP id d13-20020a170902aa8db029011a922503eamr16511400plr.49.1624256482597;
        Sun, 20 Jun 2021 23:21:22 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j8sm7324717pfu.60.2021.06.20.23.21.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Jun 2021 23:21:22 -0700 (PDT)
Subject: Re: [PATCH] virtio_net: Enable MSI-X vector for ctrl queue
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Keiichi Watanabe <keiichiw@chromium.org>
Cc:     netdev@vger.kernel.org, chirantan@chromium.org,
        "David S . Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
References: <20210618072625.957837-1-keiichiw@chromium.org>
 <20210618083650-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <0933f13d-b52e-321e-4be1-1b0e3cfb346b@redhat.com>
Date:   Mon, 21 Jun 2021 14:21:18 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210618083650-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/6/18 ÏÂÎç8:38, Michael S. Tsirkin Ð´µÀ:
> On Fri, Jun 18, 2021 at 04:26:25PM +0900, Keiichi Watanabe wrote:
>> When we use vhost-user backend on the host, MSI-X vector should be set
>> so that the vmm can get an irq FD and send it to the backend device
>> process with vhost-user protocol.
>> Since whether the vector is set for a queue is determined depending on
>> the queue has a callback, this commit sets an empty callback for
>> virtio-net's control queue.
>>
>> Signed-off-by: Keiichi Watanabe <keiichiw@chromium.org>
> I'm confused by this explanation. If the vmm wants to get
> an interrupt it can do so - why change the guest driver?


+1, it sounds like a bug in the backend or we probably need more context 
here.

Thanks


>
>> ---
>>   drivers/net/virtio_net.c | 7 ++++++-
>>   1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>> index 11f722460513..002e3695d4b3 100644
>> --- a/drivers/net/virtio_net.c
>> +++ b/drivers/net/virtio_net.c
>> @@ -2696,6 +2696,11 @@ static void virtnet_del_vqs(struct virtnet_info *vi)
>>   	virtnet_free_queues(vi);
>>   }
>>   
>> +static void virtnet_ctrlq_done(struct virtqueue *rvq)
>> +{
>> +	/* Do nothing */
>> +}
>> +
>>   /* How large should a single buffer be so a queue full of these can fit at
>>    * least one full packet?
>>    * Logic below assumes the mergeable buffer header is used.
>> @@ -2748,7 +2753,7 @@ static int virtnet_find_vqs(struct virtnet_info *vi)
>>   
>>   	/* Parameters for control virtqueue, if any */
>>   	if (vi->has_cvq) {
>> -		callbacks[total_vqs - 1] = NULL;
>> +		callbacks[total_vqs - 1] = virtnet_ctrlq_done;
>>   		names[total_vqs - 1] = "control";
>>   	}
>>   
>> -- 
>> 2.32.0.288.g62a8d224e6-goog

