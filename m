Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8E035B868
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 04:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236494AbhDLCLI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 22:11:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235543AbhDLCLH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Apr 2021 22:11:07 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D582DC061574;
        Sun, 11 Apr 2021 19:10:50 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id p16so1586749plf.12;
        Sun, 11 Apr 2021 19:10:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yaVUjVzZXG//isVveNusfn2LxuJbXyw20jQCaiyjYIc=;
        b=g+A+zCWwzK8ZAyXoHM/Ve1WTT/2MDH7nWwtxrikbn+RKWzXglEh05nwTduS4mBiQ2Q
         LNajmxu/Y0PuNDWOAd8TIMWtrEbC6hQLt1W5LuLEyU36NwXSP9tDRNnzxidIqHdsHLSg
         P6WxljovJLA16cW+C/8RkYO2fq6wRurjRAw6NBjACmNFqlzHL+xtzOofT9VOnqJbt2J+
         ACE9aFC7hGBDO/EpTn6YDdfyLan04ZncrLwTKdmaA1NYmaVbHR07KYvZ0F+MrHnJJJ1n
         fsC9NSDf4f56zkegwM8L2Wv9V/WqxbRC9UQjFw6OhMoRoRH9JpKyWiqAYKolqAuLWHoq
         7eBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yaVUjVzZXG//isVveNusfn2LxuJbXyw20jQCaiyjYIc=;
        b=Fy8vau9OScnKW444Xju85uyKSj3uz1BuvwFs97/R+Qd9y8BYP2aFDyDjxJva3eaZiH
         C/IEwz6NhCcu1zT0xiWdvqe/daHqZyI1V2FXd7gDzkC3Mr1S8OXMilmreTJZEG9FaWX1
         pKnmSNyvwUfyW9XWFSlJ6GxCUIAVKZYYDRCCekznRASV5brQdCq1uWxmIu07zcOMsB4S
         uGLn6C6legpSPtWnVF45/BLPIbKf4eKaVgNesMdGi7N8cRex9G4UFdw79u+lLiGcyWyl
         UJz0BRyBNV5jqxBpb89mSyPK9T8aZJtGBEU+8IRKD/uUnOtogMAsIU7tc6O+t/MWLc6u
         rzCQ==
X-Gm-Message-State: AOAM530zBNjZ4WtIJvV0XAsx2Dp+GhGJxPQUdNi1WBEgo6Seseuh7mGr
        F1R+D7YMDvs6JctUK8ofNr8KEVYmW5o=
X-Google-Smtp-Source: ABdhPJx2wmATqmthqB7ZmSq1zVZR6kkoXI3XiyffqvT+fsBt6cE6zWZqk+sMD93x5VpYnRCIcyeAGw==
X-Received: by 2002:a17:90b:2317:: with SMTP id mt23mr10290838pjb.24.1618193449717;
        Sun, 11 Apr 2021 19:10:49 -0700 (PDT)
Received: from [10.230.2.159] ([192.19.228.250])
        by smtp.gmail.com with ESMTPSA id j10sm8912785pjs.11.2021.04.11.19.10.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Apr 2021 19:10:49 -0700 (PDT)
Subject: Re: [PATCH RFC net-next 0/3] Multi-CPU DSA support
To:     Vladimir Oltean <olteanv@gmail.com>,
        Marek Behun <marek.behun@nic.cz>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
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
 <20210411200135.35fb5985@thinkpad> <20210411185017.3xf7kxzzq2vefpwu@skbuf>
 <20210411235358.vpql2mppobjhknfg@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <84a27330-73cb-3ebe-a0a9-eb6afec55902@gmail.com>
Date:   Sun, 11 Apr 2021 19:10:36 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210411235358.vpql2mppobjhknfg@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/11/2021 4:53 PM, Vladimir Oltean wrote:
> On Sun, Apr 11, 2021 at 09:50:17PM +0300, Vladimir Oltean wrote:
>> On Sun, Apr 11, 2021 at 08:01:35PM +0200, Marek Behun wrote:
>>> On Sat, 10 Apr 2021 15:34:46 +0200
>>> Ansuel Smith <ansuelsmth@gmail.com> wrote:
>>>
>>>> Hi,
>>>> this is a respin of the Marek series in hope that this time we can
>>>> finally make some progress with dsa supporting multi-cpu port.
>>>>
>>>> This implementation is similar to the Marek series but with some tweaks.
>>>> This adds support for multiple-cpu port but leave the driver the
>>>> decision of the type of logic to use about assigning a CPU port to the
>>>> various port. The driver can also provide no preference and the CPU port
>>>> is decided using a round-robin way.
>>>
>>> In the last couple of months I have been giving some thought to this
>>> problem, and came up with one important thing: if there are multiple
>>> upstream ports, it would make a lot of sense to dynamically reallocate
>>> them to each user port, based on which user port is actually used, and
>>> at what speed.
>>>
>>> For example on Turris Omnia we have 2 CPU ports and 5 user ports. All
>>> ports support at most 1 Gbps. Round-robin would assign:
>>>   CPU port 0 - Port 0
>>>   CPU port 1 - Port 1
>>>   CPU port 0 - Port 2
>>>   CPU port 1 - Port 3
>>>   CPU port 0 - Port 4
>>>
>>> Now suppose that the user plugs ethernet cables only into ports 0 and 2,
>>> with 1, 3 and 4 free:
>>>   CPU port 0 - Port 0 (plugged)
>>>   CPU port 1 - Port 1 (free)
>>>   CPU port 0 - Port 2 (plugged)
>>>   CPU port 1 - Port 3 (free)
>>>   CPU port 0 - Port 4 (free)
>>>
>>> We end up in a situation where ports 0 and 2 share 1 Gbps bandwidth to
>>> CPU, and the second CPU port is not used at all.
>>>
>>> A mechanism for automatic reassignment of CPU ports would be ideal here.
>>>
>>> What do you guys think?
>>
>> The reason why I don't think this is such a great idea is because the
>> CPU port assignment is a major reconfiguration step which should at the
>> very least be done while the network is down, to avoid races with the
>> data path (something which this series does not appear to handle).
>> And if you allow the static user-port-to-CPU-port assignment to change
>> every time a link goes up/down, I don't think you really want to force
>> the network down through the entire switch basically.
>>
>> So I'd be tempted to say 'tough luck' if all your ports are not up, and
>> the ones that are are assigned statically to the same CPU port. It's a
>> compromise between flexibility and simplicity, and I would go for
>> simplicity here. That's the most you can achieve with static assignment,
>> just put the CPU ports in a LAG if you want better dynamic load balancing
>> (for details read on below).
> 
> Just one more small comment, because I got so carried away with
> describing what I already had in mind, that I forgot to completely
> address your idea.
> 
> I think that DSA should provide the means to do what you want but not
> the policy.

Could not agree more, this point is what has historically prevented any
multi-CPU port patch series from landing because what everyone seems to
have wanted so far is along these lines:

- assign LAN ports 0-3 to CPU port #0
- assign WAN port 4 to CPU port #1

and do that from Device Tree, problem solved? Not entirely unfortunately.

Being able to change the mapping via iproute2 is definitively an
improvement, and to echo to your comment on the iproute2 change proper
we can try to agree on a more specialized syntax.

> Meaning that you can always write a user space program that
> monitors the NETLINK_ROUTE rtnetlink through a socket and listens for
> link state change events on it with poll(), then does whatever (like
> moves the static user-to-CPU port mapping in the way that is adequate to
> your network's requirements). The link up/down events are already
> emitted, and the patch set here gives user space the rope to hang itself.

That seems like an entirely reasonable approach to me, and solving how
to map a given user-port to a particular CPU port definitively belongs
in user-space, within the constraints expressed by what the switch
driver can do of course.

> 
> If you need inspiration, one user of the rtnetlink socket that I know of
> is ptp4l:
> https://github.com/richardcochran/linuxptp/blob/master/rtnl.c
> 

-- 
Florian
