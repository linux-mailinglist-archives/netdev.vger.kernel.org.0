Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E9213209F6
	for <lists+netdev@lfdr.de>; Sun, 21 Feb 2021 12:30:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbhBULad (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Feb 2021 06:30:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbhBULaZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Feb 2021 06:30:25 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1424C061574
        for <netdev@vger.kernel.org>; Sun, 21 Feb 2021 03:29:44 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id p2so18119022edm.12
        for <netdev@vger.kernel.org>; Sun, 21 Feb 2021 03:29:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NkqLH2iI4TGIsYEyVAwIq/vBaQt2ewB722xv9p5GaH8=;
        b=NVXRFqEWEExByzBwj7i9f834L8MsUCdcmvojkY75wdVpyoTFjKqBDhT6JmUq23R9nY
         UkV8/eAXs3jNZE0haptV7Ajct4s/a8Ewk5MQvLt3ebe3rLcjm3a5Insg+tnPTOeKakuS
         MrxTCTEU64ZZAb37iwpT6AAZu1j/OAl3g53UAC4QR4J0Vtm/maqI/IC3xfsoMQy3RGct
         atgIBrALiN6+mA5qAxu3v7at2kN577Z6o7okxXWhs+VOogtjQzwfEWsCemF3u/CfsCwF
         qofU8Fhkxvx1AGFX1orVris6c9m/83bM1TMkfCRDKN6CTY1aQZenK35EbLAlQXbG1eOg
         hr5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NkqLH2iI4TGIsYEyVAwIq/vBaQt2ewB722xv9p5GaH8=;
        b=dOn9rKq1Ev2sfjQ4oQLMzVYe3pcRw8MJOMmBXX8DS4MBQvwfmLqWKYA7rDSvKWWpmD
         HcWctMAYwU7X3b0h8LObHFxXtgtUncjcqLM3okq1LtyN28p2RblRJm8dC0/vpEENoKfw
         napUZqu8HmWteIW/0unR8aTjRpaqSh57joA2yX5wI/6QGXul9W997UjG1rjnItVcsRP+
         L2GVK3HfHxp73kT1elvPIlZUWFsUXRL+fbvtYXq74FH3j1zo1P7Q9jI0nwiodW4NF2Pe
         xZTYnqOoU4B7VrkniwrJPp4cWLusZVM+5Nf7z23OJm6Y5nb+9nUCoS/KfgfuoQjneUYB
         C6+w==
X-Gm-Message-State: AOAM531lhPcqSX8+cvPW3jd3dwusDIrveWupgeeKl1NVDQB4u3ZMgUtj
        SDz9RVv83WFbi4my2MpCAFk=
X-Google-Smtp-Source: ABdhPJxPPe2ES370m4Jkp1KQ93EluukjDD976InpundPP02BkBdhuQJ5EsOwsIzNx5CZIwtekspfoQ==
X-Received: by 2002:a05:6402:190a:: with SMTP id e10mr17851608edz.110.1613906983513;
        Sun, 21 Feb 2021 03:29:43 -0800 (PST)
Received: from [132.68.43.202] ([132.68.43.202])
        by smtp.gmail.com with ESMTPSA id v9sm8128251ejd.92.2021.02.21.03.29.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Feb 2021 03:29:42 -0800 (PST)
Subject: Re: [PATCH v4 net-next 06/21] nvme-tcp: Add DDP offload control path
To:     Or Gerlitz <gerlitz.or@gmail.com>, David Ahern <dsahern@gmail.com>
Cc:     Boris Pismenny <borisp@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>, axboe@fb.com,
        Keith Busch <kbusch@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Eric Dumazet <edumazet@google.com>, smalin@marvell.com,
        Yoray Zack <yorayz@mellanox.com>, yorayz@nvidia.com,
        boris.pismenny@gmail.com, Ben Ben-Ishay <benishay@mellanox.com>,
        benishay@nvidia.com, linux-nvme@lists.infradead.org,
        Linux Netdev List <netdev@vger.kernel.org>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Or Gerlitz <ogerlitz@nvidia.com>
References: <20210211211044.32701-1-borisp@mellanox.com>
 <20210211211044.32701-7-borisp@mellanox.com>
 <2dd10b2f-df00-e21c-7886-93f41a987040@gmail.com>
 <CAJ3xEMjMqK81uNv21poD+DoZCRxYak0DYFZrjDbmWaSxw4R5ig@mail.gmail.com>
From:   Boris Pismenny <borispismenny@gmail.com>
Message-ID: <3f447ef7-3ded-8c1c-fdfa-ec137e11a19a@gmail.com>
Date:   Sun, 21 Feb 2021 13:29:39 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <CAJ3xEMjMqK81uNv21poD+DoZCRxYak0DYFZrjDbmWaSxw4R5ig@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17/02/2021 15:55, Or Gerlitz wrote:
> On Sun, Feb 14, 2021 at 8:20 PM David Ahern <dsahern@gmail.com> wrote:
>> On 2/11/21 2:10 PM, Boris Pismenny wrote:
>>> @@ -223,6 +229,164 @@ static inline size_t nvme_tcp_pdu_last_send(struct nvme_tcp_request *req,
>>>       return nvme_tcp_pdu_data_left(req) <= len;
>>>  }
>>>
>>> +#ifdef CONFIG_TCP_DDP
>>> +
>>> +static bool nvme_tcp_resync_request(struct sock *sk, u32 seq, u32 flags);
>>> +static const struct tcp_ddp_ulp_ops nvme_tcp_ddp_ulp_ops = {
>>> +     .resync_request         = nvme_tcp_resync_request,
>>> +};
>>> +
>>> +static int nvme_tcp_offload_socket(struct nvme_tcp_queue *queue)
>>> +{
>>> +     struct net_device *netdev = queue->ctrl->offloading_netdev;
>>> +     struct nvme_tcp_ddp_config config = {};
>>> +     int ret;
>>> +
>>> +     if (!(netdev->features & NETIF_F_HW_TCP_DDP))
>>
>> If nvme_tcp_offload_limits does not find a dst_entry on the socket then
>> offloading_netdev may not NULL at this point.
> 
> correct :( will look on that
> 

That's only partially true.
If nvme_tcp_offload_limits finds a dst_entry, but then the netdevice
goes down, then the check here will catch it. This is needed because
nvme_tcp_offload_limits doesn't hold a reference! We opted not to grab a
reference on nvme_tcp_offload_limits because it doesn't create a context.


>>> +             queue->ctrl->offloading_netdev = NULL;
>>> +             return -ENODEV;
>>> +     }
>>> +
>>> +     if (netdev->features & NETIF_F_HW_TCP_DDP &&
>>> +         netdev->tcp_ddp_ops &&
>>> +         netdev->tcp_ddp_ops->tcp_ddp_limits)
>>> +             ret = netdev->tcp_ddp_ops->tcp_ddp_limits(netdev, &limits);
>>> +     else
>>> +             ret = -EOPNOTSUPP;
>>> +
>>> +     if (!ret) {
>>> +             queue->ctrl->offloading_netdev = netdev;
>>
>> you save a reference to the netdev here, but then release the refcnt
>> below. That device could be deleted between this point in time and the
>> initialization of all queues.
> 

That's true, and this is why we repeat the checks there.

We avoid holding the reference here because there is no obvious
complementary release point for nvme_tcp_offload_limits and there is no
hardware context created here, so there is no real need to hold it at
this stage.
