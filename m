Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 801FB35D3BD
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 01:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243869AbhDLXOP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 19:14:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237900AbhDLXOO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 19:14:14 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16839C061574
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 16:13:56 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id a25so4029976ljm.11
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 16:13:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=43L1TmoC0o/WoYVrJNkztVPgj9lsKn+w1wvXb0t9ND0=;
        b=s8zravPsbqkaJM0CP7dtGXsar3TTR1vsAUZcbw+1fswlHymAZw4MNMLC9vJpMA2eM9
         2R+5sB8DQanYW6hzDtwYUXDBr8z8O6fm0oSlhl+qlSVuD77oLC1kx9i3hOp+csxGUjM3
         DmMRHph/jvSHRswTTstkeopP0pWh4Wj5gXEFR8w7h0PVNV1XffmiV0oUeA4BFTi36/yC
         X6TFbn/CgoiSlEv9VI8pU6JKCT90+j44WEoKy8Y2y5x+PUC5zKtdn90KMRMAKYzjoPsY
         15ZG3RHncoimJfw7U4LpIxs81SIyRDDZvLdCVzUgNGKP341ohCOZJ/JEoNxfRQnojtV1
         SVUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=43L1TmoC0o/WoYVrJNkztVPgj9lsKn+w1wvXb0t9ND0=;
        b=G+pDeL41FeiYMoYtRQz8lAVFyl3/+Sh3fK6on7a83PoIKwb4NmMJ7DFKHaUDQgFQI9
         mgC6Kx7r8X4GxBtmIiDvMWqRdbUloz21Z61gPwckPg2sRlnObFqRDMFcwt7HveJpN58P
         XDkGXMfrb11yITRErcs0oNPg1wPS/3GYQcX1Yc6RKVBRi9s4+wN2YPBvMZ8CK20nYQf/
         g6qC/AiWESiB69U3hQtrh1wI+1uz5MiSvvCCVmKmTVkT3pA6BRnErz2cOktO8hONaqOx
         Xhu9CS8R5vMzCkLYR7VoGFVXUyLn5Nq1fnWBnarhvvtNaMlcEg+Jq160P2YfP8G7QxQF
         6xyw==
X-Gm-Message-State: AOAM533uoK9SFLuLi1F5qi4Wg2+/NbhEWEcQwpjlvUZeAehSEZ8O/lo9
        htKWLCXUOBh1xErIalM27RhZuw==
X-Google-Smtp-Source: ABdhPJzO/Oj8VIOs2UvRnEnQ0hruWLctA76syg0/2xzlr+i2E5aS3nYSibh87yRu+flGLj3Gy/AJlQ==
X-Received: by 2002:a05:651c:211a:: with SMTP id a26mr19159766ljq.373.1618269234447;
        Mon, 12 Apr 2021 16:13:54 -0700 (PDT)
Received: from wkz-x280 (h-90-88.A259.priv.bahnhof.se. [212.85.90.88])
        by smtp.gmail.com with ESMTPSA id x207sm2636738lff.92.2021.04.12.16.13.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 16:13:54 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Marek Behun <marek.behun@nic.cz>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
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
In-Reply-To: <87r1jfje26.fsf@waldekranz.com>
References: <20210410133454.4768-1-ansuelsmth@gmail.com> <20210411200135.35fb5985@thinkpad> <20210411185017.3xf7kxzzq2vefpwu@skbuf> <878s5nllgs.fsf@waldekranz.com> <20210412213045.4277a598@thinkpad> <8735vvkxju.fsf@waldekranz.com> <20210412235054.73754df9@thinkpad> <87wnt7jgzk.fsf@waldekranz.com> <20210413005518.2f9b9cef@thinkpad> <87r1jfje26.fsf@waldekranz.com>
Date:   Tue, 13 Apr 2021 01:13:53 +0200
Message-ID: <87o8ejjdu6.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 13, 2021 at 01:09, Tobias Waldekranz <tobias@waldekranz.com> wrote:
> On Tue, Apr 13, 2021 at 00:55, Marek Behun <marek.behun@nic.cz> wrote:
>> On Tue, 13 Apr 2021 00:05:51 +0200
>> Tobias Waldekranz <tobias@waldekranz.com> wrote:
>>
>>> On Mon, Apr 12, 2021 at 23:50, Marek Behun <marek.behun@nic.cz> wrote:
>>> > On Mon, 12 Apr 2021 23:22:45 +0200
>>> > Tobias Waldekranz <tobias@waldekranz.com> wrote:
>>> >  
>>> >> On Mon, Apr 12, 2021 at 21:30, Marek Behun <marek.behun@nic.cz> wrote:  
>>> >> > On Mon, 12 Apr 2021 14:46:11 +0200
>>> >> > Tobias Waldekranz <tobias@waldekranz.com> wrote:
>>> >> >    
>>> >> >> I agree. Unless you only have a few really wideband flows, a LAG will
>>> >> >> typically do a great job with balancing. This will happen without the
>>> >> >> user having to do any configuration at all. It would also perform well
>>> >> >> in "router-on-a-stick"-setups where the incoming and outgoing port is
>>> >> >> the same.    
>>> >> >
>>> >> > TLDR: The problem with LAGs how they are currently implemented is that
>>> >> > for Turris Omnia, basically in 1/16 of configurations the traffic would
>>> >> > go via one CPU port anyway.
>>> >> >
>>> >> >
>>> >> >
>>> >> > One potencial problem that I see with using LAGs for aggregating CPU
>>> >> > ports on mv88e6xxx is how these switches determine the port for a
>>> >> > packet: only the src and dst MAC address is used for the hash that
>>> >> > chooses the port.
>>> >> >
>>> >> > The most common scenario for Turris Omnia, for example, where we have 2
>>> >> > CPU ports and 5 user ports, is that into these 5 user ports the user
>>> >> > plugs 5 simple devices (no switches, so only one peer MAC address for
>>> >> > port). So we have only 5 pairs of src + dst MAC addresses. If we simply
>>> >> > fill the LAG table as it is done now, then there is 2 * 0.5^5 = 1/16
>>> >> > chance that all packets would go through one CPU port.
>>> >> >
>>> >> > In order to have real load balancing in this scenario, we would either
>>> >> > have to recompute the LAG mask table depending on the MAC addresses, or
>>> >> > rewrite the LAG mask table somewhat randomly periodically. (This could
>>> >> > be in theory offloaded onto the Z80 internal CPU for some of the
>>> >> > switches of the mv88e6xxx family, but not for Omnia.)    
>>> >> 
>>> >> I thought that the option to associate each port netdev with a DSA
>>> >> master would only be used on transmit. Are you saying that there is a
>>> >> way to configure an mv88e6xxx chip to steer packets to different CPU
>>> >> ports depending on the incoming port?
>>> >>
>>> >> The reason that the traffic is directed towards the CPU is that some
>>> >> kind of entry in the ATU says so, and the destination of that entry will
>>> >> either be a port vector or a LAG. Of those two, only the LAG will offer
>>> >> any kind of balancing. What am I missing?  
>>> >
>>> > Via port vectors you can "load balance" by ports only, i.e. input port X  
>>> > -> trasmit via CPU port Y.  
>>> 
>>> How is this done? In a case where there is no bridging between the
>>> ports, then I understand. Each port could have its own FID. But if you
>>> have this setup...
>>> 
>>>    br0    wan
>>>    / \
>>> lan0 lan1
>>> 
>>> lan0 and lan1 would use the same FID. So how could you say that frames
>>> from lan0 should go to cpu0 and frames from lan1 should go to cpu1 if
>>> the DA is the same? What would be the content of the ATU in a setup
>>> like that?
>>> 
>>> > When using LAGs, you are load balancing via hash(src MAC | dst mac)
>>> > only. This is better in some ways. But what I am saying is that if the
>>> > LAG mask table is static, as it is now implemented in mv88e6xxx code,
>>> > then for many scenarios there is a big probability of no load balancing
>>> > at all. For Turris Omnia for example there is 6.25% probability that
>>> > the switch chip will send all traffic to the CPU via one CPU port.
>>> > This is because the switch chooses the LAG port only from the hash of
>>> > dst+src MAC address. (By the 1/16 = 6.25% probability I mean that for
>>> > cca 1 in 16 customers, the switch would only use one port when sending
>>> > data to the CPU).
>>> >
>>> > The round robin solution here is therefore better in this case.  
>>> 
>>> I agree that it would be better in that case. I just do not get how you
>>> get the switch to do it for you.
>>
>> I thought that this is configured in the mv88e6xxx_port_vlan() function.
>> For each port, you specify via which ports data can egress.
>> So for ports 0, 2, 4 you can enable CPU port 0, and for ports 1 and 3
>> CPU port 1.
>
> Ahh I see. Well the port based VLANs are just an isolation mechanism. So
> with a setup like this...
>
>     cpu0 cpu1 lan0 lan1
> cpu0           x
> cpu1                x
> lan0 x              x
> lan1      x    x
>
> ...you could get the isolation in place. But you will still lookup the
> DA in the ATU, and there you will find a destination of either cpu0 or
> cpu1. So for one of the ports, the destination will be outside of its
> port based VLAN. Once the vectors are ANDed together, it is left with no
> valid port to egress through, and the packet is dropped.
>
>> Am I wrong? I confess that I did not understand this into the most fine
>> details, so it is entirely possible that I am missing something
>> important and am completely wrong. Maybe this cannot be done.
>
> I really doubt that it can be done. Not in any robust way at
> least. Happy to be proven wrong though! :)

I think I figured out why it "works" for you. Since the CPU address is
never added to the ATU, traffic for it is treated as unknown. Thanks to
that, it flooded and the isolation brings it together. As soon as
mv88e6xxx starts making use of Vladimirs offloading of host addresses
though, I suspect this will fall apart.
