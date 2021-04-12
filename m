Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6569535D30B
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 00:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242513AbhDLW1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 18:27:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240565AbhDLW1O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 18:27:14 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93C93C061574
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 15:26:55 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id n138so24015448lfa.3
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 15:26:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=yIB6RrqTVOqagkzz+6JKueo9U658PLq5ojSe8Jf4DqQ=;
        b=b71wKnnoDR3b9ne2h8+GfIr6D7nxIhNwqTVX/JzpAtMip60HoifBxcdBPFX3Faye5i
         xH0sslWk6HNbPA7EOPHjlKZMbJHuoo8uZnvdoiapWANJjWeepUJh3R4VqfFTYryCKGot
         DT2a9WeIx1kky367Bd+2M4y5MD/Esa1/b9X8vIM8xe1FMQRJ+3mQTmMyB7IVnsw2xPBA
         lNH1EMow11YhLPkkjGsYeT4DlErNRpF+pF/jCDYMWmYsY9Ks5gdTfNDFAytuZFLo79v6
         9Z60EakmjpZzaL7oc1ejEp515+LtMSIIfGZn9mWOrRsCpvtt0u3NnMu3hSKkWLoNZmPf
         2ufg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=yIB6RrqTVOqagkzz+6JKueo9U658PLq5ojSe8Jf4DqQ=;
        b=C5RVC0qEQqMP77b8Fs+9LiNB8A7ap2bUcrqH5LA4lNQi816FrKIUSP3uCWZ7tUkbVn
         fVQOOCdQqso03hsnghEPkcynaDl0Lg+vwVYmV3TrUw0Yj5qPSYDCq+/2dtIA6pumNLtY
         dxb7eYGdFX9977HueVQFXEW1H6/58aJgN6ueWZCkKvwcSBWz/yI1Vt9mPEauQ5z1kvTS
         O1Ug+qcmcf61niT3577iVcr7EQTMNUzgb2UK4UYcaCeltMudkD2+92nsU9ls1XnMZrWv
         +kQgdyw8O2Nwcl5UP8K6r/BGaQ9A761BvEQWFshKPyQ7GQikJLsYeKU7UcVjwHV1PlfD
         wVGw==
X-Gm-Message-State: AOAM531p4dbCjRihD/Nd/Whr3XdOIJD1X32iCfb7M3xoc0oICv7dY8DH
        qkab3IpI8Xl+0za3VPy9TsqedzQZw6qngUH1
X-Google-Smtp-Source: ABdhPJwawOTAJMZU7A2QkCkGQFXG3DUmas9RCLb8BA1/RjJsB9ISqbYCZM0jG4+bn7EREPEzHSKj+A==
X-Received: by 2002:a05:6512:3b82:: with SMTP id g2mr8928422lfv.499.1618266414008;
        Mon, 12 Apr 2021 15:26:54 -0700 (PDT)
Received: from wkz-x280 (h-90-88.A259.priv.bahnhof.se. [212.85.90.88])
        by smtp.gmail.com with ESMTPSA id v3sm1802596ljg.77.2021.04.12.15.26.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 15:26:53 -0700 (PDT)
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
In-Reply-To: <20210412220655.27rsiyxlf3f3tydm@skbuf>
References: <20210410133454.4768-1-ansuelsmth@gmail.com> <20210411200135.35fb5985@thinkpad> <20210411185017.3xf7kxzzq2vefpwu@skbuf> <878s5nllgs.fsf@waldekranz.com> <20210412213045.4277a598@thinkpad> <8735vvkxju.fsf@waldekranz.com> <20210412213402.vwvon2fdtzf4hnrt@skbuf> <87zgy3jhr1.fsf@waldekranz.com> <20210412220655.27rsiyxlf3f3tydm@skbuf>
Date:   Tue, 13 Apr 2021 00:26:52 +0200
Message-ID: <87tuobjg0j.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 13, 2021 at 01:06, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Mon, Apr 12, 2021 at 11:49:22PM +0200, Tobias Waldekranz wrote:
>> On Tue, Apr 13, 2021 at 00:34, Vladimir Oltean <olteanv@gmail.com> wrote:
>> > On Mon, Apr 12, 2021 at 11:22:45PM +0200, Tobias Waldekranz wrote:
>> >> On Mon, Apr 12, 2021 at 21:30, Marek Behun <marek.behun@nic.cz> wrote:
>> >> > On Mon, 12 Apr 2021 14:46:11 +0200
>> >> > Tobias Waldekranz <tobias@waldekranz.com> wrote:
>> >> >
>> >> >> I agree. Unless you only have a few really wideband flows, a LAG will
>> >> >> typically do a great job with balancing. This will happen without the
>> >> >> user having to do any configuration at all. It would also perform well
>> >> >> in "router-on-a-stick"-setups where the incoming and outgoing port is
>> >> >> the same.
>> >> >
>> >> > TLDR: The problem with LAGs how they are currently implemented is that
>> >> > for Turris Omnia, basically in 1/16 of configurations the traffic would
>> >> > go via one CPU port anyway.
>> >> >
>> >> >
>> >> >
>> >> > One potencial problem that I see with using LAGs for aggregating CPU
>> >> > ports on mv88e6xxx is how these switches determine the port for a
>> >> > packet: only the src and dst MAC address is used for the hash that
>> >> > chooses the port.
>> >> >
>> >> > The most common scenario for Turris Omnia, for example, where we have 2
>> >> > CPU ports and 5 user ports, is that into these 5 user ports the user
>> >> > plugs 5 simple devices (no switches, so only one peer MAC address for
>> >> > port). So we have only 5 pairs of src + dst MAC addresses. If we simply
>> >> > fill the LAG table as it is done now, then there is 2 * 0.5^5 = 1/16
>> >> > chance that all packets would go through one CPU port.
>> >> >
>> >> > In order to have real load balancing in this scenario, we would either
>> >> > have to recompute the LAG mask table depending on the MAC addresses, or
>> >> > rewrite the LAG mask table somewhat randomly periodically. (This could
>> >> > be in theory offloaded onto the Z80 internal CPU for some of the
>> >> > switches of the mv88e6xxx family, but not for Omnia.)
>> >> 
>> >> I thought that the option to associate each port netdev with a DSA
>> >> master would only be used on transmit. Are you saying that there is a
>> >> way to configure an mv88e6xxx chip to steer packets to different CPU
>> >> ports depending on the incoming port?
>> >> 
>> >> The reason that the traffic is directed towards the CPU is that some
>> >> kind of entry in the ATU says so, and the destination of that entry will
>> >> either be a port vector or a LAG. Of those two, only the LAG will offer
>> >> any kind of balancing. What am I missing?
>> >> 
>> >> Transmit is easy; you are already in the CPU, so you can use an
>> >> arbitrarily fancy hashing algo/ebpf classifier/whatever to load balance
>> >> in that case.
>> >
>> > Say a user port receives a broadcast frame. Based on your understanding
>> > where user-to-CPU port assignments are used only for TX, which CPU port
>> > should be selected by the switch for this broadcast packet, and by which
>> > mechanism?
>> 
>> AFAIK, the only option available to you (again, if there is no LAG set
>> up) is to statically choose one CPU port per entry. But hopefully Marek
>> can teach me some new tricks!
>> 
>> So for any known (since the broadcast address is loaded in the ATU it is
>> known) destination (b/m/u-cast), you can only "load balance" based on
>> the DA. You would also have to make sure that unknown unicast and
>> unknown multicast is only allowed to egress one of the CPU ports.
>> 
>> If you have a LAG OTOH, you could include all CPU ports in the port
>> vectors of those same entries. The LAG mask would then do the final
>> filtering so that you only send a single copy to the CPU.
>
> I forgot that mv88e6xxx keeps the broadcast address in the ATU. I wanted
> to know what is done in the flooding case, therefore I should have asked
> about unknown destination traffic. It is sent to one CPU but not the
> other based on what information?
>
> And for destinations loaded into the ATU, how is user port isolation
> performed? Say lan0 and lan1 have the same MAC address of 00:01:02:03:04:05,
> but lan0 goes to the eth0 DSA master and lan1 goes to eth1. How many ATU
> entries would there be for host addresses, and towards which port would
> they point? Are they isolated by a port private VLAN or something along
> those lines?

This is what I do not understand. This is what I hope that Marek can
tell me. To my knowledge, there is no way to per-port load balancing
from the switch to the CPU. In any given FID, there can be only one
entry per address, and that entry can only point to either a vector or a
LAG.

So my theory is that the only way of getting any load balancing, however
flawed, on receive (from switch to CPU) is by setting up a
LAG. Hopefully there is some trick that I do not know about which means
we have another option available to us.
