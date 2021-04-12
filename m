Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73CC735D2DD
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 00:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241149AbhDLWHb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 18:07:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237667AbhDLWHa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 18:07:30 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 728F6C061574;
        Mon, 12 Apr 2021 15:07:12 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id a85so9644881pfa.0;
        Mon, 12 Apr 2021 15:07:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OJmrg6ZQONOrEQTi8Ytp0vBMufyXEIbh34Ve8Fh/3bg=;
        b=LDwaF6UEoAuutMFodR3tiGRDV4jCEkS4bRRnb8//2k+hgAx8aHR7yqlD4eNxjM7iax
         TbVN8euTyHnPO9Gr9uz3H6fEWHjUy0oDT73r6nsBLZfHcbWZL1P67z57oa81AYpGa90t
         Ueh7+MQdbncy6Cqo52BoMMwhpNi/AximNBg/kh7Tg+9ZpbYPD3d9YkT1IWScmThoCdF5
         WuYe7blLPJ54u9OfKwnarWmrdSmjT4xzd92R+5LBQ9ov+f29idkiKaKhrpUQ+gX1S/Bm
         5A+C2gE7cDA23O4UME3vuzRbufZQIJoX52543U4LkWEnDHzBoqHE4OVmZsj8F0b+7QiZ
         EVMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OJmrg6ZQONOrEQTi8Ytp0vBMufyXEIbh34Ve8Fh/3bg=;
        b=XoXb0UMZfulWSIDE2+QcyK5UyNT0+QEph89zlap+KibG5ErqYZhEfo/O7uDKV93VRh
         hmpLD6gMxASeQIwZr20P+H7//BZkXdWDsqF4xmbK/FiWaZZalx16Jw8UBC1A5g6QyVOe
         pSJpFt5szDS+zoydImJBmp3ajxVSbM+3YxV7caOnpLIUUctTwCkNwXFUzvNZKR5FlUik
         FT+mxOMxRLVzTUksxVD0bY7onkHZrZ/S3pyN52OAtlW1+/E/ENGYRXYACil0jGS8nUO1
         kGSnIRxg5gwPtFSd6lS5AAGBsUqmkNNpRQdRFZMIN5Owjg6Yrzj/s3seuG6okY+OaOho
         1c5w==
X-Gm-Message-State: AOAM533C8dX9pXB80qrtR+eK9b8MYL1ns/1uYelfAYNmSr9OZt6lv3KQ
        jgtzKFXNkfuHxtCmBu/yJo8=
X-Google-Smtp-Source: ABdhPJwxLaa/drCEHm7wP5SCoSbKoy94xeFpSZ+PppQ1/LOKxteLiI5Js7Plxmv3lKfG4uiuVlwuNg==
X-Received: by 2002:a63:5857:: with SMTP id i23mr29079447pgm.152.1618265231910;
        Mon, 12 Apr 2021 15:07:11 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id i73sm13679156pgc.9.2021.04.12.15.07.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 15:07:11 -0700 (PDT)
Date:   Tue, 13 Apr 2021 01:06:55 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
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
Message-ID: <20210412220655.27rsiyxlf3f3tydm@skbuf>
References: <20210410133454.4768-1-ansuelsmth@gmail.com>
 <20210411200135.35fb5985@thinkpad>
 <20210411185017.3xf7kxzzq2vefpwu@skbuf>
 <878s5nllgs.fsf@waldekranz.com>
 <20210412213045.4277a598@thinkpad>
 <8735vvkxju.fsf@waldekranz.com>
 <20210412213402.vwvon2fdtzf4hnrt@skbuf>
 <87zgy3jhr1.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zgy3jhr1.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 12, 2021 at 11:49:22PM +0200, Tobias Waldekranz wrote:
> On Tue, Apr 13, 2021 at 00:34, Vladimir Oltean <olteanv@gmail.com> wrote:
> > On Mon, Apr 12, 2021 at 11:22:45PM +0200, Tobias Waldekranz wrote:
> >> On Mon, Apr 12, 2021 at 21:30, Marek Behun <marek.behun@nic.cz> wrote:
> >> > On Mon, 12 Apr 2021 14:46:11 +0200
> >> > Tobias Waldekranz <tobias@waldekranz.com> wrote:
> >> >
> >> >> I agree. Unless you only have a few really wideband flows, a LAG will
> >> >> typically do a great job with balancing. This will happen without the
> >> >> user having to do any configuration at all. It would also perform well
> >> >> in "router-on-a-stick"-setups where the incoming and outgoing port is
> >> >> the same.
> >> >
> >> > TLDR: The problem with LAGs how they are currently implemented is that
> >> > for Turris Omnia, basically in 1/16 of configurations the traffic would
> >> > go via one CPU port anyway.
> >> >
> >> >
> >> >
> >> > One potencial problem that I see with using LAGs for aggregating CPU
> >> > ports on mv88e6xxx is how these switches determine the port for a
> >> > packet: only the src and dst MAC address is used for the hash that
> >> > chooses the port.
> >> >
> >> > The most common scenario for Turris Omnia, for example, where we have 2
> >> > CPU ports and 5 user ports, is that into these 5 user ports the user
> >> > plugs 5 simple devices (no switches, so only one peer MAC address for
> >> > port). So we have only 5 pairs of src + dst MAC addresses. If we simply
> >> > fill the LAG table as it is done now, then there is 2 * 0.5^5 = 1/16
> >> > chance that all packets would go through one CPU port.
> >> >
> >> > In order to have real load balancing in this scenario, we would either
> >> > have to recompute the LAG mask table depending on the MAC addresses, or
> >> > rewrite the LAG mask table somewhat randomly periodically. (This could
> >> > be in theory offloaded onto the Z80 internal CPU for some of the
> >> > switches of the mv88e6xxx family, but not for Omnia.)
> >> 
> >> I thought that the option to associate each port netdev with a DSA
> >> master would only be used on transmit. Are you saying that there is a
> >> way to configure an mv88e6xxx chip to steer packets to different CPU
> >> ports depending on the incoming port?
> >> 
> >> The reason that the traffic is directed towards the CPU is that some
> >> kind of entry in the ATU says so, and the destination of that entry will
> >> either be a port vector or a LAG. Of those two, only the LAG will offer
> >> any kind of balancing. What am I missing?
> >> 
> >> Transmit is easy; you are already in the CPU, so you can use an
> >> arbitrarily fancy hashing algo/ebpf classifier/whatever to load balance
> >> in that case.
> >
> > Say a user port receives a broadcast frame. Based on your understanding
> > where user-to-CPU port assignments are used only for TX, which CPU port
> > should be selected by the switch for this broadcast packet, and by which
> > mechanism?
> 
> AFAIK, the only option available to you (again, if there is no LAG set
> up) is to statically choose one CPU port per entry. But hopefully Marek
> can teach me some new tricks!
> 
> So for any known (since the broadcast address is loaded in the ATU it is
> known) destination (b/m/u-cast), you can only "load balance" based on
> the DA. You would also have to make sure that unknown unicast and
> unknown multicast is only allowed to egress one of the CPU ports.
> 
> If you have a LAG OTOH, you could include all CPU ports in the port
> vectors of those same entries. The LAG mask would then do the final
> filtering so that you only send a single copy to the CPU.

I forgot that mv88e6xxx keeps the broadcast address in the ATU. I wanted
to know what is done in the flooding case, therefore I should have asked
about unknown destination traffic. It is sent to one CPU but not the
other based on what information?

And for destinations loaded into the ATU, how is user port isolation
performed? Say lan0 and lan1 have the same MAC address of 00:01:02:03:04:05,
but lan0 goes to the eth0 DSA master and lan1 goes to eth1. How many ATU
entries would there be for host addresses, and towards which port would
they point? Are they isolated by a port private VLAN or something along
those lines?
