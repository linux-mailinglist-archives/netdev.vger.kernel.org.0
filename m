Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE0335FAE0
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 20:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234493AbhDNSkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 14:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234383AbhDNSkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 14:40:18 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA7B8C061574
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 11:39:56 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id j18so34905263lfg.5
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 11:39:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=5SzeLYXFwNLoeejAn+Lbkrah8+IOEnfJx2FJbq6WG9g=;
        b=nlLz+TSUn9ACQIP/P4JdDpoazhtV2QPsF25ExAvQmfp/PXBDSiDdLJso4iCPwL/ids
         QCWxK59ynsc8ZrjXsNCZ7XnqtJL75/27VfEB+zfp8O8uKkh8CrB3OViBKVNYeuyGaeS3
         Vdeq2EGrghqMV5jrkH5CD5Utk4cUdYHxGlA4sjUoaYFg3j5GGYOHHXYEzaCG//pjDYMt
         tW50QwnJa6eMESR4FC7Qz1vHYs3hMaj2ZUTymU9KoLpVpZOJuZ8WAkTBnwe9gAYuSgKl
         rekG5GsLHHoi/sqR2HLrUbj8avLq46iqXUqAMOmDyEBTWQ12m7PTZkrIQENiFlMt02pd
         1tJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=5SzeLYXFwNLoeejAn+Lbkrah8+IOEnfJx2FJbq6WG9g=;
        b=qLYGc3XiAKp6bBj96L9olW15tPcs9i7KmSzTmPxs1zWaOh5bcOja8hsKHXgXQDgVOC
         BIxMe6uqHmLt0PfHHvGAVo0V9TKXGcNS8gGcTtl6vefK2q2ILdfOL6O7aBX+iSUIK6iQ
         Xst4yLt/q9PirhqK5pspTaJDdsbGuL45uHO3QuCqcxKjbuGlVBuMOl+dbkpw6tpBI4Ky
         rMEoR08BRAE8MgJilYd7e4MsO/dap7QnUT3XQxrrihtfHhF3v3VmAwLAOrMJOn/OVjNX
         GhVmidWnxx6ryJG7R573eRnE9xtUp7eHIrDjBwCtp3wIlT4Zd4pPg+KzyQR6M5lnZPEB
         As8A==
X-Gm-Message-State: AOAM5321VndzElkzhszgcCwoevpWN/vcCX7H14zL0FG4DW3mmK10s/fI
        9AGDxr/oFoDc/bsWUYU/tuSaCA==
X-Google-Smtp-Source: ABdhPJwMBDNG/ZhvSA7y+XyRE4QBxfS2c++aV2KZowE7pzQCNNJMrDbYl2QEcV1qAVc5vGvdbG6t7g==
X-Received: by 2002:a05:6512:3187:: with SMTP id i7mr13781311lfe.340.1618425595225;
        Wed, 14 Apr 2021 11:39:55 -0700 (PDT)
Received: from wkz-x280 (h-90-88.A259.priv.bahnhof.se. [212.85.90.88])
        by smtp.gmail.com with ESMTPSA id q10sm121879lfo.78.2021.04.14.11.39.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Apr 2021 11:39:54 -0700 (PDT)
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
In-Reply-To: <20210414171439.1a2e7c1a@thinkpad>
References: <20210410133454.4768-1-ansuelsmth@gmail.com> <20210411200135.35fb5985@thinkpad> <20210411185017.3xf7kxzzq2vefpwu@skbuf> <878s5nllgs.fsf@waldekranz.com> <20210412213045.4277a598@thinkpad> <8735vvkxju.fsf@waldekranz.com> <20210412235054.73754df9@thinkpad> <87wnt7jgzk.fsf@waldekranz.com> <20210413005518.2f9b9cef@thinkpad> <87r1jfje26.fsf@waldekranz.com> <87o8ejjdu6.fsf@waldekranz.com> <20210413015450.1ae597da@thinkpad> <20210413022730.2a51c083@thinkpad> <87im4qjl87.fsf@waldekranz.com> <20210413171443.1b2b2f88@thinkpad> <87fszujbif.fsf@waldekranz.com> <20210414171439.1a2e7c1a@thinkpad>
Date:   Wed, 14 Apr 2021 20:39:53 +0200
Message-ID: <87blagk8w6.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 14, 2021 at 17:14, Marek Behun <marek.behun@nic.cz> wrote:
> On Tue, 13 Apr 2021 20:16:24 +0200
> Tobias Waldekranz <tobias@waldekranz.com> wrote:
>
>> You could imagine a different mode in which the DSA driver would receive
>> the bucket allocation from the bond/team driver (which in turn could
>> come all the way from userspace). Userspace could then implement
>> whatever strategy it wants to maximize utilization, though still bound
>> by the limitations of the hardware in terms of fields considered during
>> hashing of course.
>
> The problem is that even with the ability to change the bucket
> configuration however we want it still can happen with non-trivial
> probability that all (src,dst) pairs on the network will hash to one
> bucket.
>
> The probability of that happening is 1/(8^(n-1)) for n (src,dst) pairs.

Yes I understand all that, hence "though still bound by the limitations
of the hardware in terms of fields considered during hashing of course."

> On Turris Omnia the most common configuration is that the switch ports
> are bridged.
>
> If the user plugs only two devices into the lan ports, one would expect
> that both devices could utilize 1 gbps each. In this case there is
> 1/8 probability that both devices would hash to the same bucket. It is
> quite bad if multi-CPU upload won't work for 12.5% of our customers that
> are using our device in this way.

Agreed, but it is a category error to talk in terms of expectations and
desires here. I am pretty sure the silicon just does not have the gates
required to do per-port steering in combination with bridging. (Except
by using the TCAM).

> So if there is some reasonable solution how to implement multi-CPU via
> the port vlan mask, I will try to pursue this.

I hope whatever solution you come up with does not depend on the
destination being unknown. If the current patch works for the reason I
suspect, you will effectively limit the downstream bandwidth of all
connected stations to 1G minus the aggregated upstream rate. Example:

     .------.
 A --+ lan0 |
 B --+ lan1 |
 C --+ lan2 |
 D --+ lan3 |
     |      |
     + wan  |
     '------'

If you run with this series applied, in this setup, and have A,B,C each
send a 10 kpps flow to the CPU, what is the observed rate on D?  My
guess would be 30 kpps, as all traffic is being flooded as unknown
unicast. This is true also for net-next at the moment. To solve that you
have to load the CPU address in the ATU, at which point you have to
decide between cpu0 and cpu1.

In order to have two entries for the same destination, they must belong
to different FIDs. But that FID is also used for automatic learning. So
if all ports use their own FID, all the switched traffic will have to be
flooded instead, since any address learned on lan0 will be invisible to
lan1,2,3 and vice versa.
