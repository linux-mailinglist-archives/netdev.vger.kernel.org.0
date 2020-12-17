Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D30F52DD8C0
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 19:54:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730367AbgLQSwU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 13:52:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727063AbgLQSwU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 13:52:20 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A289BC061794
        for <netdev@vger.kernel.org>; Thu, 17 Dec 2020 10:51:39 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id k10so6461039wmi.3
        for <netdev@vger.kernel.org>; Thu, 17 Dec 2020 10:51:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PqIJU/UiiYdbQyKwDiZYB1eA+uLCOP7hSkA3qwa+zco=;
        b=McD3QmJiKEZC2vyxVD4y7kISfiGNAb5U2+z3LuY4GlGEB/sOXGudnGS95ebu1bjd2e
         ZybYiyV+oUg6OtiKuKLXdm2zCwCDMoms1GBto6HVJvHS4gNqs98AMCaFVMPy5ywHndQ3
         uDhk9g1+zU3md/Bq69wk3b57+MUbRYDQRPoXX1agn8qoR9eduoyhyTcmXadrcRREIBOn
         AkQ3TKl0Sufix48jV79VIllBm0R66u4xtbfZF7hSqprB6tQf01sdCt4jzfB9iaEhenY+
         tjjagr7Hb/4TqoekqIPok5MJhu6nvHTUFLdEJmVQNm31Dbbg0e5bp5IqbZZevmZIKowT
         LYcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PqIJU/UiiYdbQyKwDiZYB1eA+uLCOP7hSkA3qwa+zco=;
        b=MQzhRBErFTW/yX9PqeAs/za64089sx7lPUvLWid2GpmS2tRMgQdC1YwRIhAU3b7DGO
         /7visJq6m9rvEjRf/10n07MYCoHDXCjDaFHzWKqLehxeGy5+RJULClNubGXWNCSkd2/O
         x98UiLrZdChVQFM/FH08hPaxus41s+4IF+1iSsC4nkmEd7CqSjlehJCgJ/cLVtlqQhG+
         U3Y+a2590VQJFVB9ntrYEb4sXJTFrceMjXpzgPNSLRDoPdukh+dPEwAadnmUH+In9OgR
         Jf/6FJXn79fhEDuFYLFD22qGQXyLQoSJ1y1pHKqrweluCrUpuvGs/3lDbu9YcmViJvvL
         mWOw==
X-Gm-Message-State: AOAM530C0cOBLHN92jVMBUyMjqMWcAnTwGEWC3GNx65YM6C/zgpLJWz7
        sS2vAlBvDhApQT1qfaZwQGU=
X-Google-Smtp-Source: ABdhPJwvd9Qf99bvDwqHusFUK1jWFZSS0hypNsWzRO4Qx002zrPwHv1FjEMMOcE8taNkkjgcvzYzdw==
X-Received: by 2002:a1c:630b:: with SMTP id x11mr719402wmb.138.1608231098472;
        Thu, 17 Dec 2020 10:51:38 -0800 (PST)
Received: from [192.168.1.11] ([213.57.108.142])
        by smtp.gmail.com with ESMTPSA id f9sm11279137wrw.81.2020.12.17.10.51.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Dec 2020 10:51:35 -0800 (PST)
Subject: Re: [PATCH v1 net-next 05/15] nvme-tcp: Add DDP offload control path
To:     Shai Malin <malin1024@gmail.com>,
        Boris Pismenny <borisp@mellanox.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>, "hch@lst.de" <hch@lst.de>,
        "sagi@grimberg.me" <sagi@grimberg.me>,
        "axboe@fb.com" <axboe@fb.com>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "edumazet@google.com" <edumazet@google.com>
Cc:     Yoray Zack <yorayz@mellanox.com>,
        "yorayz@nvidia.com" <yorayz@nvidia.com>,
        "boris.pismenny@gmail.com" <boris.pismenny@gmail.com>,
        Ben Ben-Ishay <benishay@mellanox.com>,
        "benishay@nvidia.com" <benishay@nvidia.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        "ogerlitz@nvidia.com" <ogerlitz@nvidia.com>,
        Shai Malin <smalin@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>
References: <20201207210649.19194-1-borisp@mellanox.com>
 <20201207210649.19194-6-borisp@mellanox.com>
 <PH0PR18MB3845486FF240614CA08E7B4CCCCB0@PH0PR18MB3845.namprd18.prod.outlook.com>
 <0a272589-940c-6488-9cb9-1833400f38b3@gmail.com>
 <CAKKgK4xvS9SeM3NmNKDNe5oFxxfi0m_=iHCXeXX0DGcgzG_BBA@mail.gmail.com>
From:   Boris Pismenny <borispismenny@gmail.com>
Message-ID: <c667ccb0-7444-6892-f647-8971d0b0b461@gmail.com>
Date:   Thu, 17 Dec 2020 20:51:31 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <CAKKgK4xvS9SeM3NmNKDNe5oFxxfi0m_=iHCXeXX0DGcgzG_BBA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 15/12/2020 15:33, Shai Malin wrote:
> On 12/14/2020 08:38, Boris Pismenny wrote:
>> On 10/12/2020 19:15, Shai Malin wrote:
>>> diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c index c0c33320fe65..ef96e4a02bbd 100644
>>> --- a/drivers/nvme/host/tcp.c
>>> +++ b/drivers/nvme/host/tcp.c
>>> @@ -14,6 +14,7 @@
>>>  #include <linux/blk-mq.h>
>>>  #include <crypto/hash.h>
>>>  #include <net/busy_poll.h>
>>> +#include <net/tcp_ddp.h>
>>>
>>>  #include "nvme.h"
>>>  #include "fabrics.h"
>>> @@ -62,6 +63,7 @@ enum nvme_tcp_queue_flags {
>>>       NVME_TCP_Q_ALLOCATED    = 0,
>>>       NVME_TCP_Q_LIVE         = 1,
>>>       NVME_TCP_Q_POLLING      = 2,
>>> +     NVME_TCP_Q_OFFLOADS     = 3,
>>>  };
>>>
>>> The same comment from the previous version - we are concerned that perhaps
>>> the generic term "offload" for both the transport type (for the Marvell work)
>>> and for the DDP and CRC offload queue (for the Mellanox work) may be
>>> misleading and confusing to developers and to users.
>>>
>>> As suggested by Sagi, we can call this NVME_TCP_Q_DDP.
>>>
>>
>> While I don't mind changing the naming here. I wonder  why not call the
>> toe you use TOE and not TCP_OFFLOAD, and then offload is free for this?
> 
> Thanks - please do change the name to NVME_TCP_Q_DDP.
> The Marvell nvme-tcp-offload patch series introducing the offloading of both the
> TCP as well as the NVMe/TCP layer, therefore it's not TOE.
> 

Will do.

>>
>> Moreover, the most common use of offload in the kernel is for partial offloads
>> like this one, and not for full offloads (such as toe).
> 
> Because each vendor might implement a different partial offload I
> suggest naming it
> with the specific technique which is used, as was suggested - NVME_TCP_Q_DDP.
> 


IIUC, if TCP/IP is offloaded entirely then it is called TOE. It doesn't matter
than you offload additional stuff (nvme-tcp)


