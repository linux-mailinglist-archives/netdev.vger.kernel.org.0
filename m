Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C810B30D75C
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 11:22:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233737AbhBCKVx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 05:21:53 -0500
Received: from mail-wr1-f42.google.com ([209.85.221.42]:36353 "EHLO
        mail-wr1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233589AbhBCKVu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 05:21:50 -0500
Received: by mail-wr1-f42.google.com with SMTP id u14so1647266wri.3
        for <netdev@vger.kernel.org>; Wed, 03 Feb 2021 02:21:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dcAFChpuSmTlzebnnafCrrA6mJXj3u07ZSxpvEJDfBw=;
        b=i5FiBIUwBH931D8cu2Dw+NFOiwOdvAg03mnvdISGMf2rurFlamBbJI0jXlBzi+ao9H
         nn76UPdGzeUjwILGgn7zeJQyG8KwU69CFdkwn+vHCyqIlIU7UlvrO4wfh8BG7gvfDt3f
         DE32BvwaUXrSIM7Ki8reyqVU6uUX+pU9IyhunmNgT+lOgyWEnuJeZT2QTqwGs5HU78Yl
         QS2UTJIoTB2+/aeH1q692ToMfsGRbpGLDLlEGnDfy004RfA+ShqwXbWEmxMRIKRK1hmu
         RYkWrpBsX3wxkOjiMVMODNRF6eZ5httHLYwh6QjpuT2knpKEsqofnyPXn+N/kMqwbMU3
         ctzQ==
X-Gm-Message-State: AOAM532joiRvaq4czOVckqC1ylZOuXUGj09Pwj5+6AlH4qjhCNELZ6Y9
        EWYHv4oV7lp+o4kH1rTN2QQ=
X-Google-Smtp-Source: ABdhPJwRbTrOG1hx01WoAIg58wIOBVjWZTMw68z7t1C36+if2Bp9OVKLC9/MfDKWlPqlyqHRKZFGcw==
X-Received: by 2002:a5d:6712:: with SMTP id o18mr2564033wru.375.1612347668578;
        Wed, 03 Feb 2021 02:21:08 -0800 (PST)
Received: from ?IPv6:2601:647:4802:9070:819b:e1e8:19a6:9008? ([2601:647:4802:9070:819b:e1e8:19a6:9008])
        by smtp.gmail.com with ESMTPSA id s4sm2276859wme.38.2021.02.03.02.21.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Feb 2021 02:21:08 -0800 (PST)
Subject: Re: [PATCH v3 net-next 07/21] nvme-tcp: Add DDP data-path
To:     Christoph Hellwig <hch@lst.de>
Cc:     Or Gerlitz <gerlitz.or@gmail.com>, Keith Busch <kbusch@kernel.org>,
        axboe@fb.com, Boris Pismenny <borisp@mellanox.com>,
        smalin@marvell.com, yorayz@nvidia.com, boris.pismenny@gmail.com,
        Ben Ben-Ishay <benishay@mellanox.com>,
        Yoray Zack <yorayz@mellanox.com>,
        linux-nvme@lists.infradead.org, David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Or Gerlitz <ogerlitz@mellanox.com>, benishay@nvidia.com,
        Saeed Mahameed <saeedm@nvidia.com>,
        Or Gerlitz <ogerlitz@nvidia.com>
References: <20210201100509.27351-1-borisp@mellanox.com>
 <20210201100509.27351-8-borisp@mellanox.com> <20210201173744.GC12960@lst.de>
 <CAJ3xEMhninJE5zw7=QFL4gBVkH=1tAmQHyq7tKMqcSJ_KkDsWQ@mail.gmail.com>
 <80074375-2d37-d9b9-afbe-1f3d1db4a41f@grimberg.me>
 <20210203100234.GA9050@lst.de>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <12247db9-5847-b791-c9e2-ce9993abc4d4@grimberg.me>
Date:   Wed, 3 Feb 2021 02:21:01 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210203100234.GA9050@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


>>>> Given how much ddp code there is can you split it into a separate file?
>>>
>>> mmm, do we need to check the preferences or get to a consensus among
>>> the maintainers for that one?
>>
>> Not sure if moving it would be better here. Given that the ddp code is
>> working directly on nvme-tcp structs we'll need a new shared header
>> file..
>>
>> Its possible to do, but I'm not sure the end result will be better..
> 
> In the end its your code base.  But I hate having all this offload
> cruft all over the place.

I know, I think that the folks did a solid job consolidating it
given the complexity. But looking at the code again, it is sprinkled
more than I'd like it to be. I think it can be better with a little
more work.

If we can get to a point where we have all the specific logic
moved to dedicated routines and just a few interceptions on
the main flows we should be ok.

> Just saying no to offloads might be an even better position, though.

:)

I've heard complaints about nvme-tcp taking more cpu cycles than
nvme-rdma (well duh..) so I'm not opposed to having mainstream devices
offering offload capabilities to help out with that, not at all.
