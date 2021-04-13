Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 998E735E61B
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 20:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344284AbhDMSQx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 14:16:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237137AbhDMSQx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 14:16:53 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67E66C061574
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 11:16:28 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id w8so20337187lfr.0
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 11:16:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=/NRxwC56E+MI3F93yElfCXf/3hj5Z06is2uycZkM0qQ=;
        b=DvJDXp/d6RVgY9b8RzGDfa4v7bb80kHLSf6aVUTdCUGASXQijU9fey+HkK22mjfMmP
         Zaw+pH/pdj3l4ftbWEbHMzM/SJic7CkowmqoVf1JbOsKpg5Vx3ODW/XbbiUQg8j0q8Gn
         7uczMoJP5hsoj6crQbcJtd1Sg6yQ2CT6uuQ1DHeY3f491MsXleeoanzBwaQtkwqDdCcN
         hiUXX8ySa8zM4KvxXdmrAfUBEStcXDhvOEjSr+HN3HDAHDvAGQBmqsoMQkO90jNPrxsv
         CQJySlTXy2HN1FLJCkjF6c5G/5OhNaPrGuQNGRTecrenASSgzpUX5EpIa6MNdUdbZdCK
         pzYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=/NRxwC56E+MI3F93yElfCXf/3hj5Z06is2uycZkM0qQ=;
        b=L/dBBlAYetLZd0tE+6BQNdIbh/6l8dCOEEXoyEfzdEMSMcO8HiJFntSOGOA4m2tupG
         37AuM2DcKW1SZfsRXrL7kTdGGMn1CdXfdscRmTGPTB0CqKhIcfRfJSuvHi8YnKK4oRGo
         Ja9a2dk12Ttv4xnyMUr+TrPdAh/HE8YSyUjNLGz8rVVQpOprMtK7WrlI1w8cEVi9rrEG
         DVm6CVF2t1CQxVRt6WIjqXgUazWtuUsVel1MjP67imoZnJAgtz0Qpw/GzSwjoGb3PS0M
         L4SxPOF3+ZZyXje4jN46AE2289PNm01Y2rnCxlyQIQuUAXIuvI9VKPfvyM54vdTtIeYZ
         2aoA==
X-Gm-Message-State: AOAM530xMCBMeyI7QeM09FBup23I7rc7Gx5PFXBP9tyCTIRdFpmGYlbX
        0nD1J2lVhq5y7swjiU+RrC0TOA==
X-Google-Smtp-Source: ABdhPJxGcyzZDO/gtjy3O8QplokV8Ru3RCNy02FMyuq/NhsrG7A5qqWuSRiXcZg/cSyET00Wi4U/VA==
X-Received: by 2002:ac2:58c9:: with SMTP id u9mr11384189lfo.103.1618337786726;
        Tue, 13 Apr 2021 11:16:26 -0700 (PDT)
Received: from wkz-x280 (h-90-88.A259.priv.bahnhof.se. [212.85.90.88])
        by smtp.gmail.com with ESMTPSA id v4sm2263993lfe.18.2021.04.13.11.16.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 11:16:25 -0700 (PDT)
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
In-Reply-To: <20210413171443.1b2b2f88@thinkpad>
References: <20210410133454.4768-1-ansuelsmth@gmail.com> <20210411200135.35fb5985@thinkpad> <20210411185017.3xf7kxzzq2vefpwu@skbuf> <878s5nllgs.fsf@waldekranz.com> <20210412213045.4277a598@thinkpad> <8735vvkxju.fsf@waldekranz.com> <20210412235054.73754df9@thinkpad> <87wnt7jgzk.fsf@waldekranz.com> <20210413005518.2f9b9cef@thinkpad> <87r1jfje26.fsf@waldekranz.com> <87o8ejjdu6.fsf@waldekranz.com> <20210413015450.1ae597da@thinkpad> <20210413022730.2a51c083@thinkpad> <87im4qjl87.fsf@waldekranz.com> <20210413171443.1b2b2f88@thinkpad>
Date:   Tue, 13 Apr 2021 20:16:24 +0200
Message-ID: <87fszujbif.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 13, 2021 at 17:14, Marek Behun <marek.behun@nic.cz> wrote:
> On Tue, 13 Apr 2021 16:46:32 +0200
> Tobias Waldekranz <tobias@waldekranz.com> wrote:
>
>> On Tue, Apr 13, 2021 at 02:27, Marek Behun <marek.behun@nic.cz> wrote:
>> > On Tue, 13 Apr 2021 01:54:50 +0200
>> > Marek Behun <marek.behun@nic.cz> wrote:
>> >  
>> >> I will look into this, maybe ask some follow-up questions.  
>> >
>> > Tobias,
>> >
>> > it seems that currently the LAGs in mv88e6xxx driver do not use the
>> > HashTrunk feature (which can be enabled via bit 11 of the
>> > MV88E6XXX_G2_TRUNK_MAPPING register).  
>> 
>> This should be set at the bottom of mv88e6xxx_lag_sync_masks.
>> 
>> > If we used this feature and if we knew what hash function it uses, we
>> > could write a userspace tool that could recompute new MAC
>> > addresses for the CPU ports in order to avoid the problem I explained
>> > previously...
>> >
>> > Or the tool can simply inject frames into the switch and try different
>> > MAC addresses for the CPU ports until desired load-balancing is reached.
>> >
>> > What do you think?  
>> 
>> As you concluded in your followup, not being able to have a fixed MAC
>> for the CPU seems weird.
>> 
>> Maybe you could do the inverse? Allow userspace to set the masks for an
>> individual bond/team port in a hash-based LAG, then you can offload that
>> to DSA. 
>
> What masks?

The table defined in Global2/Register7.

When a frame is mapped to a LAG (e.g. by an ATU lookup), all member
ports will added to the frame's destination vector. The mask table is
the block that then filters the vector to only include a single
member.

By modifying that table, you can choose which buckets are assigned to
which member ports. This includes assigning 7 buckets to one member and
1 to the other for example.

At the moment, mv88e6xxx will statically determine this mapping (in
mv88e6xxx_lag_set_port_mask), by trying to spread the buckets as evenly
as possible. It will also rebalance the assignments whenever a link goes
down, or is "detached" in LACP terms.

You could imagine a different mode in which the DSA driver would receive
the bucket allocation from the bond/team driver (which in turn could
come all the way from userspace). Userspace could then implement
whatever strategy it wants to maximize utilization, though still bound
by the limitations of the hardware in terms of fields considered during
hashing of course.
