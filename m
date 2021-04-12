Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4116535D2B1
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 23:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245688AbhDLVts (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 17:49:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245367AbhDLVto (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 17:49:44 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8971C061574
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 14:49:25 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id b4so23796438lfi.6
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 14:49:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=W9t0bWXPElaEb1YaSf5S5bNbS7I896kBixhyn7sSIcU=;
        b=Py5R6gWiEi4+VzZN5iUGDXg7zkCfflE4o32Bl6/pu7JFW32sP50k83OubADPjAPnoQ
         yyfz3qXc7gnixUYIAhE/Dj3zM0ZEeOJLsohFHzLyW9NtKSLWpdn5BTq9ZcsyWaINhzoK
         M6kk19GGerSqL8LQpG6wR4yecKOGYgTA7sa4QEkB7E0rV9xPXYxyllJL66n1D6OFSfOm
         4TXNmfVy60xwwu4TzlofV2cdm/xKF8/QUsLyVFDdn2WznUMRjm7GHiXk52ypJRligFz9
         lqpjzl23hnKqhGPOJVMwlDM3lTJQFQGZwbnnMFcFZ56Lgm3fN81RRgkpYk4WobWHJy6X
         VBBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=W9t0bWXPElaEb1YaSf5S5bNbS7I896kBixhyn7sSIcU=;
        b=spRzdpxMwEACJKPZCj+SWo3NR2hpA8wqnwBU/7opMSWVHZ24HAUYXQUfH55yPSCfR8
         LJO6jyOwOT6UxX6UIdlT4lTS8tTaNfanoA7eT0UHieIx62agQKTyoncuLVnXfyWXMsDy
         c98o7jZz6+ghyY4t1Szj0mzYOTv7EHB3c8A1j2owgkmcJZU4E9VkLxHSpkpDyYyVYcy+
         fv685xIhCENBpvko+TTXAVtJIunZ/0VeoiINUKnjCQUW4rr3cm9s6cB5OALi1qdruu9j
         JLd34RG5B2FF9LhhHcJTZhFGyfjyOSwxrF8n6o3atxVpXQidHrWdhqVwRA0dx2dwkw8w
         yrnw==
X-Gm-Message-State: AOAM533+n/Jvpzz7I+DyExUa/iYTwf8chQFdEhqVsk+dDiah/gTP3IZN
        fzIFqyurQBjYVLNmLNuia9sDBA==
X-Google-Smtp-Source: ABdhPJzTKdOqsPYjBhKMknaNiqORq2Bq4yMfuUbt1KLw6S1vcqY0JBv/SFrxY7PEr0TZfHtWF4PAdA==
X-Received: by 2002:a19:3849:: with SMTP id d9mr1456955lfj.388.1618264164358;
        Mon, 12 Apr 2021 14:49:24 -0700 (PDT)
Received: from wkz-x280 (h-90-88.A259.priv.bahnhof.se. [212.85.90.88])
        by smtp.gmail.com with ESMTPSA id a8sm2644579lfr.174.2021.04.12.14.49.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 14:49:23 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Marek Behun <marek.behun@nic.cz>,
        Ansuel Smith <ansuelsmth@gmail.com>, netdev@vger.kernel.org,
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
In-Reply-To: <20210412213402.vwvon2fdtzf4hnrt@skbuf>
References: <20210410133454.4768-1-ansuelsmth@gmail.com> <20210411200135.35fb5985@thinkpad> <20210411185017.3xf7kxzzq2vefpwu@skbuf> <878s5nllgs.fsf@waldekranz.com> <20210412213045.4277a598@thinkpad> <8735vvkxju.fsf@waldekranz.com> <20210412213402.vwvon2fdtzf4hnrt@skbuf>
Date:   Mon, 12 Apr 2021 23:49:22 +0200
Message-ID: <87zgy3jhr1.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 13, 2021 at 00:34, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Mon, Apr 12, 2021 at 11:22:45PM +0200, Tobias Waldekranz wrote:
>> On Mon, Apr 12, 2021 at 21:30, Marek Behun <marek.behun@nic.cz> wrote:
>> > On Mon, 12 Apr 2021 14:46:11 +0200
>> > Tobias Waldekranz <tobias@waldekranz.com> wrote:
>> >
>> >> I agree. Unless you only have a few really wideband flows, a LAG will
>> >> typically do a great job with balancing. This will happen without the
>> >> user having to do any configuration at all. It would also perform well
>> >> in "router-on-a-stick"-setups where the incoming and outgoing port is
>> >> the same.
>> >
>> > TLDR: The problem with LAGs how they are currently implemented is that
>> > for Turris Omnia, basically in 1/16 of configurations the traffic would
>> > go via one CPU port anyway.
>> >
>> >
>> >
>> > One potencial problem that I see with using LAGs for aggregating CPU
>> > ports on mv88e6xxx is how these switches determine the port for a
>> > packet: only the src and dst MAC address is used for the hash that
>> > chooses the port.
>> >
>> > The most common scenario for Turris Omnia, for example, where we have 2
>> > CPU ports and 5 user ports, is that into these 5 user ports the user
>> > plugs 5 simple devices (no switches, so only one peer MAC address for
>> > port). So we have only 5 pairs of src + dst MAC addresses. If we simply
>> > fill the LAG table as it is done now, then there is 2 * 0.5^5 = 1/16
>> > chance that all packets would go through one CPU port.
>> >
>> > In order to have real load balancing in this scenario, we would either
>> > have to recompute the LAG mask table depending on the MAC addresses, or
>> > rewrite the LAG mask table somewhat randomly periodically. (This could
>> > be in theory offloaded onto the Z80 internal CPU for some of the
>> > switches of the mv88e6xxx family, but not for Omnia.)
>> 
>> I thought that the option to associate each port netdev with a DSA
>> master would only be used on transmit. Are you saying that there is a
>> way to configure an mv88e6xxx chip to steer packets to different CPU
>> ports depending on the incoming port?
>> 
>> The reason that the traffic is directed towards the CPU is that some
>> kind of entry in the ATU says so, and the destination of that entry will
>> either be a port vector or a LAG. Of those two, only the LAG will offer
>> any kind of balancing. What am I missing?
>> 
>> Transmit is easy; you are already in the CPU, so you can use an
>> arbitrarily fancy hashing algo/ebpf classifier/whatever to load balance
>> in that case.
>
> Say a user port receives a broadcast frame. Based on your understanding
> where user-to-CPU port assignments are used only for TX, which CPU port
> should be selected by the switch for this broadcast packet, and by which
> mechanism?

AFAIK, the only option available to you (again, if there is no LAG set
up) is to statically choose one CPU port per entry. But hopefully Marek
can teach me some new tricks!

So for any known (since the broadcast address is loaded in the ATU it is
known) destination (b/m/u-cast), you can only "load balance" based on
the DA. You would also have to make sure that unknown unicast and
unknown multicast is only allowed to egress one of the CPU ports.

If you have a LAG OTOH, you could include all CPU ports in the port
vectors of those same entries. The LAG mask would then do the final
filtering so that you only send a single copy to the CPU.
