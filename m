Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55DD435C691
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 14:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241293AbhDLMqd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 08:46:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237283AbhDLMqd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 08:46:33 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08A1AC061574
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 05:46:15 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id j18so21199618lfg.5
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 05:46:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=K9zFwgQThnD5eX67NpvDmwlYzeG84kCePup7Nam43iY=;
        b=G7nI0KdFgTu9x2Gm0LgVO8BLeCpd3E53MYTduPLDoh/nAzdbUShjlY2Bq7s6wcLx6c
         v/HzrGr9dInpgl6OIX3SjSYsR7ltPeMw+L/of9q37M+MS4OACfK9mHanwyqWo2WkPH5P
         QfbhVfvciGXGjAprM9g4i106zLzp/2PigWVCTukRN9yhdxJYqTSamyQa/gBQiZxkMvB+
         gOQQbnSof6Hxu5vyO/1Lvc4XRsUroCeRc+f3hmHs8j+N0ss/Ja3F3RbGMp6teocVVdSP
         ieH/gmv1lZMO2zIy5+iIf54d+hy/5PKAYuvitDxdT27UxXJ6X9sxT3qcJCapKcicWcTC
         IC7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=K9zFwgQThnD5eX67NpvDmwlYzeG84kCePup7Nam43iY=;
        b=nYPzJXMUpPYcFWw3jbBP2RM9sout+ftMQdpHuYuzjuun91hPcITCFeUyEVcVlt8CkV
         NjnQHSH4zDrTBZtRDNlNPgp7hTxdioKr0o1O/2YmLQgoZJrnJ3MkaEhow4bHTOVLWx3i
         LSkS6ItF8qmxCxnPWx8n9uEloIpY5NxkLLbUU/iX17URXgkqMAsnEYLy9JjxqZRQn39/
         TdYKRaqFiyhRgp6tFn6hi9u9OV+p1bp0kohp27w5iHLfYzoDJjQfnFxGR9Ngt4nFFTdS
         +go2jXu6ftILWZLrDOo/547OsxdsXb2eIbhhOR8lEfeSkdrlFWBsVrTWgxN/y3kiGX8H
         7PfQ==
X-Gm-Message-State: AOAM533yaKcmXQsVvHpDQnMqH63LbxeQpQIgtc2hrk58stIqnguVPlw1
        0ACXmhzISviCzc+z1YVxA5/BmQ==
X-Google-Smtp-Source: ABdhPJzjI9GmrUK8iNW4oCMP8MXEMTbgxyK3/Sdw+SGf63/Xij/YmEw31zF4YXLxXo2MH4jCxy/Iag==
X-Received: by 2002:a19:2387:: with SMTP id j129mr15163663lfj.478.1618231573027;
        Mon, 12 Apr 2021 05:46:13 -0700 (PDT)
Received: from wkz-x280 (h-90-88.A259.priv.bahnhof.se. [212.85.90.88])
        by smtp.gmail.com with ESMTPSA id w19sm2413556lfl.199.2021.04.12.05.46.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 05:46:12 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>,
        Marek Behun <marek.behun@nic.cz>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Wei Wang <weiwan@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Taehee Yoo <ap420073@gmail.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        zhang kai <zhangkaiheb@126.com>,
        Weilong Chen <chenweilong@huawei.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Di Zhu <zhudi21@huawei.com>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC net-next 0/3] Multi-CPU DSA support
In-Reply-To: <20210411185017.3xf7kxzzq2vefpwu@skbuf>
References: <20210410133454.4768-1-ansuelsmth@gmail.com> <20210411200135.35fb5985@thinkpad> <20210411185017.3xf7kxzzq2vefpwu@skbuf>
Date:   Mon, 12 Apr 2021 14:46:11 +0200
Message-ID: <878s5nllgs.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 11, 2021 at 21:50, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Sun, Apr 11, 2021 at 08:01:35PM +0200, Marek Behun wrote:
>> On Sat, 10 Apr 2021 15:34:46 +0200
>> Ansuel Smith <ansuelsmth@gmail.com> wrote:
>> 
>> > Hi,
>> > this is a respin of the Marek series in hope that this time we can
>> > finally make some progress with dsa supporting multi-cpu port.
>> > 
>> > This implementation is similar to the Marek series but with some tweaks.
>> > This adds support for multiple-cpu port but leave the driver the
>> > decision of the type of logic to use about assigning a CPU port to the
>> > various port. The driver can also provide no preference and the CPU port
>> > is decided using a round-robin way.
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
>> 
>> What do you guys think?
>
> The reason why I don't think this is such a great idea is because the
> CPU port assignment is a major reconfiguration step which should at the
> very least be done while the network is down, to avoid races with the
> data path (something which this series does not appear to handle).
> And if you allow the static user-port-to-CPU-port assignment to change
> every time a link goes up/down, I don't think you really want to force
> the network down through the entire switch basically.
>
> So I'd be tempted to say 'tough luck' if all your ports are not up, and
> the ones that are are assigned statically to the same CPU port. It's a
> compromise between flexibility and simplicity, and I would go for
> simplicity here. That's the most you can achieve with static assignment,
> just put the CPU ports in a LAG if you want better dynamic load balancing
> (for details read on below).

I agree. Unless you only have a few really wideband flows, a LAG will
typically do a great job with balancing. This will happen without the
user having to do any configuration at all. It would also perform well
in "router-on-a-stick"-setups where the incoming and outgoing port is
the same.

...

> But there is something which is even more interesting about Felix with
> the ocelot-8021q tagger. Since Marek posted his RFC and until Ansuel
> posted the follow-up, things have happened, and now both Felix and the
> Marvell driver support LAG offload via the bonding and/or team drivers.
> At least for Felix, when using the ocelot-8021q tagged, it should be
> possible to put the two CPU ports in a hardware LAG, and the two DSA
> masters in a software LAG, and let the bond/team upper of the DSA
> masters be the CPU port.
>
> I would like us to keep the door open for both alternatives, and to have
> a way to switch between static user-to-CPU port assignment, and LAG.
> I think that if there are multiple 'ethernet = ' phandles present in the
> device tree, DSA should populate a list of valid DSA masters, and then
> call into the driver to allow it to select which master it prefers for
> each user port. This is similar to what Ansuel added with 'port_get_preferred_cpu',
> except that I chose "DSA master" and not "CPU port" for a specific reason.
> For LAG, the DSA master would be bond0.

I do not see why we would go through the trouble of creating a
user-visible bond/team for this. As you detail below, it would mean
jumping through a lot of hoops. I am not sure there is that much we can
use from those drivers.

- We know that the CPU ports are statically up, so there is no "active
  transmit set" to manage, it always consists of all ports.

- The LAG members are statically known at boot time via the DT, so we do
  not need (or want, in fact) any management of that from userspace.

We could just let the drivers setup the LAG internally, and then do the
load-balancing in dsa_slave_xmit or provide a generic helper that the
taggers could use.
