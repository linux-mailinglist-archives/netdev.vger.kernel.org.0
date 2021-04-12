Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56C7435B866
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 04:07:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235543AbhDLCHt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 22:07:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235844AbhDLCHq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Apr 2021 22:07:46 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8687AC061574;
        Sun, 11 Apr 2021 19:07:28 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id b8-20020a17090a5508b029014d0fbe9b64so7935268pji.5;
        Sun, 11 Apr 2021 19:07:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bvjdp3ahuYju51q1+1qQFX0ZeyUR0vs0519xG53Vx3g=;
        b=FJ4uC3yngQfBOIp7kWe8Kv4Ks82Ny9wrp7bJ5obe9mTTNFUzUNZKzdSv6jIVMbg0D2
         rB/TIw47uhPl5ogfaf06xZrno6KtwRyGKUWg9nb5AkHYal8IDu6CLVv6Qx64JUwz09MK
         xzzpactU935+/vNOwvkhPbrlrGBikxHS8/XwlJHgvfD35OOaQulY7V/dLYUvHpRT/2cF
         PR6ehdJb8M1nXOnjXvENbq7ec7VJuNrPnZNVoGBa79fouDiSsyziCXkrFbG9SCP5cjJ7
         4k9EMGGxOaBa0lY6k0dbubGuG8uWKVt16yKuB071ECyYbbdqNhPGxxZnHwgqTw5E1I+X
         9Szw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bvjdp3ahuYju51q1+1qQFX0ZeyUR0vs0519xG53Vx3g=;
        b=DG3Fylyv5o4B8ZRTxzGI9F1klhbKu/nl8tnr29zeKH6POIHK8e67vFpAthzy7L4Lw0
         4es4ix/Ku/kqyKjkTYFAq/jrTC2ytARFfTvs7l/Gd9l0l4rvAE1m6CDr/Ke9FxCp0kTg
         W2Yaq/sHz3fBcTdakrumtXnvlaTzhHRTBI02LxA2B66ogSlIFDxzccC5UCM6hnV0frbr
         ohMIQ+/7ZNVuTWnPXIw8FTYsvy7+KjRkB5e85bFrX0Lcl0s7amrLWgixu9hk5nAUBhpM
         9omvitkUJQfA2uVi0TzSkT1igl4w/pPVVko8SarJu6+BmXNbBcz4CYStCdicIco9TyHd
         kpxw==
X-Gm-Message-State: AOAM531oOzam5iyAez/BVKeXuSvKZLbgfrxrY+Oy4zHFP1B1h0GhfLOB
        EKyZKUZbZebDsxM9KnQlBGkMCkaQXFw=
X-Google-Smtp-Source: ABdhPJy8uVAb8XEtbTDwjn6bmn/cVyjU2UOUGkuKYm9Cb+mdGGfVKp9AFmO7/0mZgbdaXekeYKrDcQ==
X-Received: by 2002:a17:903:31cc:b029:e4:bd48:c8e3 with SMTP id v12-20020a17090331ccb02900e4bd48c8e3mr23579790ple.40.1618193246916;
        Sun, 11 Apr 2021 19:07:26 -0700 (PDT)
Received: from [10.230.2.159] ([192.19.228.250])
        by smtp.gmail.com with ESMTPSA id fs3sm8817579pjb.30.2021.04.11.19.07.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Apr 2021 19:07:26 -0700 (PDT)
Subject: Re: [PATCH RFC net-next 0/3] Multi-CPU DSA support
To:     Andrew Lunn <andrew@lunn.ch>, Marek Behun <marek.behun@nic.cz>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Wei Wang <weiwan@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Taehee Yoo <ap420073@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        zhang kai <zhangkaiheb@126.com>,
        Weilong Chen <chenweilong@huawei.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Di Zhu <zhudi21@huawei.com>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        linux-kernel@vger.kernel.org
References: <20210410133454.4768-1-ansuelsmth@gmail.com>
 <20210411200135.35fb5985@thinkpad> <YHNCUDJrz7ISiLVT@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <d76e6ef9-8eab-2fb9-17dd-6ff4f8036337@gmail.com>
Date:   Sun, 11 Apr 2021 19:07:08 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <YHNCUDJrz7ISiLVT@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/11/2021 11:39 AM, Andrew Lunn wrote:
> On Sun, Apr 11, 2021 at 08:01:35PM +0200, Marek Behun wrote:
>> On Sat, 10 Apr 2021 15:34:46 +0200
>> Ansuel Smith <ansuelsmth@gmail.com> wrote:
>>
>>> Hi,
>>> this is a respin of the Marek series in hope that this time we can
>>> finally make some progress with dsa supporting multi-cpu port.
>>>
>>> This implementation is similar to the Marek series but with some tweaks.
>>> This adds support for multiple-cpu port but leave the driver the
>>> decision of the type of logic to use about assigning a CPU port to the
>>> various port. The driver can also provide no preference and the CPU port
>>> is decided using a round-robin way.
>>
>> In the last couple of months I have been giving some thought to this
>> problem, and came up with one important thing: if there are multiple
>> upstream ports, it would make a lot of sense to dynamically reallocate
>> them to each user port, based on which user port is actually used, and
>> at what speed.
>>
>> For example on Turris Omnia we have 2 CPU ports and 5 user ports. All
>> ports support at most 1 Gbps. Round-robin would assign:
>>   CPU port 0 - Port 0
>>   CPU port 1 - Port 1
>>   CPU port 0 - Port 2
>>   CPU port 1 - Port 3
>>   CPU port 0 - Port 4
>>
>> Now suppose that the user plugs ethernet cables only into ports 0 and 2,
>> with 1, 3 and 4 free:
>>   CPU port 0 - Port 0 (plugged)
>>   CPU port 1 - Port 1 (free)
>>   CPU port 0 - Port 2 (plugged)
>>   CPU port 1 - Port 3 (free)
>>   CPU port 0 - Port 4 (free)
>>
>> We end up in a situation where ports 0 and 2 share 1 Gbps bandwidth to
>> CPU, and the second CPU port is not used at all.
>>
>> A mechanism for automatic reassignment of CPU ports would be ideal here.
> 
> One thing you need to watch out for here source MAC addresses. I've
> not looked at the details, so this is more a heads up, it needs to be
> thought about.
> 
> DSA slaves get there MAC address from the master interface. For a
> single CPU port, all the slaves have the same MAC address. What
> happens when you have multiple CPU ports? Does the slave interface get
> the MAC address from its CPU port?

It seems to be addressed by this part of patch 2:

+	if (ether_addr_equal(dev->dev_addr, master->dev_addr))
+		eth_hw_addr_inherit(dev, cpu_dev);

although this could create an interesting set of issues if done fully
dynamically while the data path is active.

> What happens when a slave moves
> from one CPU interface to another CPU interface? Does its MAC address
> change. ARP is going to be unhappy for a while? Also, how is the
> switch deciding on which CPU port to use? Some switches are probably
> learning the MAC address being used by the interface and doing
> forwarding based on that. So you might need unique slave MAC
> addresses, and when a slave moves, it takes it MAC address with it,
> and you hope the switch learns about the move. But considered trapped
> frames as opposed to forwarded frames. So BPDU, IGMP, etc. Generally,
> you only have the choice to send such trapped frames to one CPU
> port. So potentially, such frames are going to ingress on the wrong
> port. Does this matter? What about multicast? How do you control what
> port that ingresses on? What about RX filters on the master
> interfaces? Could it be we added it to the wrong master?
> 
> For this series to make progress, we need to know what has been
> tested, and if all the more complex functionality works, not just
> basic pings.

Agreed.
-- 
Florian
