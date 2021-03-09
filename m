Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24C433330E8
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 22:29:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232039AbhCIV2y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 16:28:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232005AbhCIV2Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 16:28:24 -0500
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BED47C06174A
        for <netdev@vger.kernel.org>; Tue,  9 Mar 2021 13:28:14 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id q14so22758260ljp.4
        for <netdev@vger.kernel.org>; Tue, 09 Mar 2021 13:28:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=dqus0IPVTBSZgzlrfKqnwq9mMrH2KVMjzD1Vf9C72Zk=;
        b=KN/Xlq1PAj0cqao/knTC6vBpmvD4dK0SZbk2RZnlvAZqxiGNuRHA2DErkxuFclnCeq
         L6u64sSNL86HnwgQOVqBLy3M9JBi/irPoFJwLwCLqFajsNbcB+OOriBcBr5pF3Kkds04
         CUcIcyLGo1UVq3lFz+/vJKvPKVpXoMDweJudVkps2fw5F4HtIdxAtmoTAVopxvwKjZm4
         uP+rEYkTZ+h8wVnC6sqvnW4OX1968MJ853EVELGnX4sfDMqIyK+Cz2+JwviDgRgGa/pk
         MH1NkbS34LTwOmiTqEYqRhXCFRh9LKzwPnDIzxxDr+o9nMNHkQ2GgROcnFlpiSgD+7ei
         dM5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=dqus0IPVTBSZgzlrfKqnwq9mMrH2KVMjzD1Vf9C72Zk=;
        b=CSS4M/LNBtZMJj8b95wn0ix2xFd/xy9enYW23Uh7G7mBLK3n5lCmCA0kpKV5t4xO9K
         4+18CLOJ481l6e+5a/Yub/QpnIT99Rf7X5ORjYWEWrrvKQR7WzRcDu9zyMCwox2Az2XS
         K6FJiPphgHLqAPfBvtlkwLf/025CS6HWOYhQKqmN8QHwNZRBM6f4SIpC0fRagoLi4aUD
         Hh7tN7ZRszkDVzZ1Qkbm1UphbmpXpQ3QAFJYlwXLDbTX6Si9WQMZ/99CVEMzrXlHDIMW
         DXWHmxdO8W5owLHaStcKx52qf1WztL7L8dhDHC56o27sRDmHMcN+xBjq6zsWNTuuQ1+h
         pCQQ==
X-Gm-Message-State: AOAM5310OJ28ZQwTw+BqHwo92V67mNvFyIHauPxJMB9aLu0l5iHCp6Fs
        Ki48j9mmyHSWr2mO1QpMl03xr/nEKuugyg==
X-Google-Smtp-Source: ABdhPJxSr112pP0o7NHvssODkwBxx4OKCdVh4G9sMUpbd3uk9YGQ9Rc5Af5kBhF4Einu9qDCywIYJQ==
X-Received: by 2002:a2e:9a42:: with SMTP id k2mr12918779ljj.363.1615325292835;
        Tue, 09 Mar 2021 13:28:12 -0800 (PST)
Received: from wkz-x280 (h-236-82.A259.priv.bahnhof.se. [98.128.236.82])
        by smtp.gmail.com with ESMTPSA id n20sm2151666lfu.112.2021.03.09.13.28.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Mar 2021 13:28:12 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Florian Fainelli <f.fainelli@gmail.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, olteanv@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [RFC net] net: dsa: Centralize validation of VLAN configuration
In-Reply-To: <699042d3-e124-7584-6486-02a6fb45423e@gmail.com>
References: <20210309184244.1970173-1-tobias@waldekranz.com> <699042d3-e124-7584-6486-02a6fb45423e@gmail.com>
Date:   Tue, 09 Mar 2021 22:28:11 +0100
Message-ID: <87h7lkow44.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 09, 2021 at 12:40, Florian Fainelli <f.fainelli@gmail.com> wrote:
> On 3/9/21 10:42 AM, Tobias Waldekranz wrote:
>> There are three kinds of events that have an inpact on VLAN
>> configuration of DSA ports:
>> 
>> - Adding of stacked VLANs
>>   (ip link add dev swp0.1 link swp0 type vlan id 1)
>> 
>> - Adding of bridged VLANs
>>   (bridge vlan add dev swp0 vid 1)
>> 
>> - Changes to a bridge's VLAN filtering setting
>>   (ip link set dev br0 type bridge vlan_filtering 1)
>> 
>> For all of these events, we want to ensure that some invariants are
>> upheld:
>> 
>> - For hardware where VLAN filtering is a global setting, either all
>>   bridges must use VLAN filtering, or no bridge can.
>
> I suppose that is true, given that a non-VLAN filtering bridge must not
> perform ingress VID checking, OK.
>
>> 
>> - For all filtering bridges, no stacked VLAN on any port may be
>>   configured on multiple ports.
>
> You need to qualify multiple ports a bit more here, are you saying
> multiple ports that are part of said bridge, or?

Yeah sorry, I can imagine that makes no sense whatsoever without the
context of the recent discussions. It is basically guarding against this
situation:

.100  br0  .100
   \  / \  /
   lan0 lan1

$ ip link add dev br0 type bridge vlan_filtering 1
$ ip link add dev lan0.100 link lan0 type vlan id 100
$ ip link add dev lan1.100 link lan1 type vlan id 100
$ ip link set dev lan0 master br0
$ ip link set dev lan1 master br0 # This should fail

>> - For all filtering bridges, no stacked VLAN may be configured in the
>>   bridge.
>
> Being stacked in the bridge does not really compute for me, you mean, no
> VLAN upper must be configured on the bridge master device(s)? Why would
> that be a problem though?

Again sorry, I relize that this message needs a lot of work. It guards
against this scenario:

.100  br0
   \  / \
   lan0 lan1

$ ip link add dev br0 type bridge vlan_filtering 1
$ ip link add dev lan0.100 link lan0 type vlan id 100
$ ip link set dev lan0 master br0
$ ip link set dev lan1 master br0
$ bridge vlan add dev lan1 vid 100 # This should fail

>> Move the validation of these invariants to a central function, and use
>> it from all sites where these events are handled. This way, we ensure
>> that all invariants are always checked, avoiding certain configs being
>> allowed or disallowed depending on the order in which commands are
>> given.
>> 
>> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
>> ---
>> 
>> There is still testing left to do on this, but I wanted to send early
>> in order show what I meant by "generic" VLAN validation in this
>> discussion:
>> 
>> https://lore.kernel.org/netdev/87mtvdp97q.fsf@waldekranz.com/
>> 
>> This is basically an alternative implementation of 1/4 and 2/4 from
>> this series by Vladimir:
>> 
>> https://lore.kernel.org/netdev/20210309021657.3639745-1-olteanv@gmail.com/
>
> I really have not been able to keep up with your discussion, and I am
> not sure if I will given how quickly you guys can spin patches (not a
> criticism, this is welcome).

Yeah I know, it has been a bit of a whirlwind.

Maybe I should just have posted this inline in the other thread, since
it was mostly to show Vladimir my idea, and it seemed easier to write it
in C than in English :)
