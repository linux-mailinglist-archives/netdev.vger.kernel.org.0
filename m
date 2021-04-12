Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F8C635D28B
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 23:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241128AbhDLVXH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 17:23:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237910AbhDLVXG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 17:23:06 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 169F9C061574
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 14:22:48 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id u20so17045248lja.13
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 14:22:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=X/nVZlZWogdbt/b/rHVbs9pJBJGAVO4zLjcTUrHYEa4=;
        b=CqVqT37b4IXGhzlMALkZvN2i9C35RFBOVFEhMSFSKDNZwn0OHG0fX2zcqN+ZASioaw
         wrFSo7cBXOSpG7uqCQBsValO5nGiV0hC1z8dYtYWJ402pS98Revy0MLu+9aErN5/Ml3r
         qDP56uIpej1V/yE30doC3yIhADP215w3HDhNo8Aiqjn0su2yRSSEtK3emyJXuCp732eO
         7oHmVXCaSl60YFl707Vqpm0VqI2YGBfk3AoHudgaeJysGUOGgFKJfRBA6MJ7btSPdTk5
         GKj3Jd79JkCRnRNRX+y2PJmP8djI736mohzA4P3iXrUkmlrP+uFUjDG258uFw6TI6Vux
         5U3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=X/nVZlZWogdbt/b/rHVbs9pJBJGAVO4zLjcTUrHYEa4=;
        b=jvEgNpZh7M9bpSCyoSval8PT9G5kxNbAtzcEbHidpiFliL61lvdcxa8D9258ldgFvI
         vS+fH+fA9FRfgcmEuaYNn+rJUA5c9C+v46ks3m+w7ojo1xXIIE2e8Tei+DOX91rbevML
         zHpUlWw5wYrnEcGkzDFaPIDMI+ptZEIXCKJEHiOxAY/JIVTUkyr6DOIWFWlNl9J2NQCm
         4f307XRG482uNSQMxNzeS/KCfSerpJ4u/yOAlJcqd2G9qMjqyKYgdkhGDNLEe+Q/0Z2c
         TtWiuBUmURTe2rhPlRZQjJ/PLuXxINxFIOFb9sTO+Bqh7VmQkZ/+WKZAMaYWj1rwoqXt
         Z2TA==
X-Gm-Message-State: AOAM530t8fnIop0jlng9w/hEkCTz1HfVsjZLnXYapcSUxM7diJsHOzAC
        qdPKjBnTxOZIZol9A0oRqcM9Kw==
X-Google-Smtp-Source: ABdhPJySYFG4O7x1RJzYQ/9DGEfxhuncXtHh4QB1PGMasLvDWi8tyxHVB2vjj/WSDuNikPbqoBhcvw==
X-Received: by 2002:a05:651c:110a:: with SMTP id d10mr20148725ljo.307.1618262566528;
        Mon, 12 Apr 2021 14:22:46 -0700 (PDT)
Received: from wkz-x280 (h-90-88.A259.priv.bahnhof.se. [212.85.90.88])
        by smtp.gmail.com with ESMTPSA id l17sm2560744lfg.178.2021.04.12.14.22.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 14:22:46 -0700 (PDT)
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
In-Reply-To: <20210412213045.4277a598@thinkpad>
References: <20210410133454.4768-1-ansuelsmth@gmail.com> <20210411200135.35fb5985@thinkpad> <20210411185017.3xf7kxzzq2vefpwu@skbuf> <878s5nllgs.fsf@waldekranz.com> <20210412213045.4277a598@thinkpad>
Date:   Mon, 12 Apr 2021 23:22:45 +0200
Message-ID: <8735vvkxju.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 12, 2021 at 21:30, Marek Behun <marek.behun@nic.cz> wrote:
> On Mon, 12 Apr 2021 14:46:11 +0200
> Tobias Waldekranz <tobias@waldekranz.com> wrote:
>
>> I agree. Unless you only have a few really wideband flows, a LAG will
>> typically do a great job with balancing. This will happen without the
>> user having to do any configuration at all. It would also perform well
>> in "router-on-a-stick"-setups where the incoming and outgoing port is
>> the same.
>
> TLDR: The problem with LAGs how they are currently implemented is that
> for Turris Omnia, basically in 1/16 of configurations the traffic would
> go via one CPU port anyway.
>
>
>
> One potencial problem that I see with using LAGs for aggregating CPU
> ports on mv88e6xxx is how these switches determine the port for a
> packet: only the src and dst MAC address is used for the hash that
> chooses the port.
>
> The most common scenario for Turris Omnia, for example, where we have 2
> CPU ports and 5 user ports, is that into these 5 user ports the user
> plugs 5 simple devices (no switches, so only one peer MAC address for
> port). So we have only 5 pairs of src + dst MAC addresses. If we simply
> fill the LAG table as it is done now, then there is 2 * 0.5^5 = 1/16
> chance that all packets would go through one CPU port.
>
> In order to have real load balancing in this scenario, we would either
> have to recompute the LAG mask table depending on the MAC addresses, or
> rewrite the LAG mask table somewhat randomly periodically. (This could
> be in theory offloaded onto the Z80 internal CPU for some of the
> switches of the mv88e6xxx family, but not for Omnia.)

I thought that the option to associate each port netdev with a DSA
master would only be used on transmit. Are you saying that there is a
way to configure an mv88e6xxx chip to steer packets to different CPU
ports depending on the incoming port?

The reason that the traffic is directed towards the CPU is that some
kind of entry in the ATU says so, and the destination of that entry will
either be a port vector or a LAG. Of those two, only the LAG will offer
any kind of balancing. What am I missing?

Transmit is easy; you are already in the CPU, so you can use an
arbitrarily fancy hashing algo/ebpf classifier/whatever to load balance
in that case.
