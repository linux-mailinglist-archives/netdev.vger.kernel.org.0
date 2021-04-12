Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90E5535D2A2
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 23:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240523AbhDLVej (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 17:34:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237701AbhDLVei (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 17:34:38 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1A34C061574;
        Mon, 12 Apr 2021 14:34:19 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id s14so2514814pjl.5;
        Mon, 12 Apr 2021 14:34:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZBakd+wFpZqBkXZhtANFGvZ6nMhELmLlM7Z0eCX6SN8=;
        b=eGbkvdRyxJwvo9f0LKfNeASx+ALduFoFcmO66YuNkQa81z66RbIP9ZatbBV3TXi+0U
         bIZN+TVxgF8Gz/zBhb90MzA8r7VvNmPtLvu8LiiDCZ6MdlwnL4JnX8XJ45U5LZTotUDI
         YM0lHRlF+6kLSHpxSRacbnLQlf3ASbCMf7XwrExLYo+2/cRBOzpbKa+naycJaffrT6wq
         ZSrQaoNtg63pwXxf3dFwb5uuiRXJaDYuxBLzbOdYDMDzB35Zdz7uIVEYUHW1I++UOFvs
         zRjI522nj6C7fHaD4VKT5l6d+tbKyZy6gmP2ADaZERHKUp2/Ol8UkOADJY0V51kbZDVg
         1F8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZBakd+wFpZqBkXZhtANFGvZ6nMhELmLlM7Z0eCX6SN8=;
        b=JQKAqZpW2Nx7QvQPSE6zpwF3JXl35uN4y/pnL5jvVIfhlyQ6g8NcdzmgwHY3xrLkug
         fT1ZcgdA4VES1E0x7X2WMTvJ543DTbnZ7tGgyzy8IozpvawqEbY5EDhYnkWD3IMGckr9
         VUg86ZGuIG5df8cmcYomOg8sPNVph54hq8lD8JF9pXzk6VYSzhgsXkUnnlZjLkisFySx
         3ZgWHv1OUoGxTtU79emNc/8+qA/z2yUVPXMFH9M8wrLYV+oMiVegDt+jXsnWRV89vDBv
         AyzRmbQvx+sq+8xUAlVTSQNuigI0pRyVmv7LTmAJFP9KiwPew9jJVEovj3g6q6PkQA8b
         DrFw==
X-Gm-Message-State: AOAM531szmTRSbAd1Xwoq7rTkZtEz7WeBG2M3lFEF6H9qbl7zrhTiO+R
        rJP89eSN8hIqRNxn3E1mDNs=
X-Google-Smtp-Source: ABdhPJyrXqUHZXD2ZXMO25ufYonVprj+xe+9J59IZyirrajyLEosQwjkfXoHIW/7BVF9cyqPAidN+g==
X-Received: by 2002:a17:90a:94ca:: with SMTP id j10mr1296432pjw.126.1618263259009;
        Mon, 12 Apr 2021 14:34:19 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id gb15sm316927pjb.32.2021.04.12.14.34.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 14:34:18 -0700 (PDT)
Date:   Tue, 13 Apr 2021 00:34:02 +0300
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
Message-ID: <20210412213402.vwvon2fdtzf4hnrt@skbuf>
References: <20210410133454.4768-1-ansuelsmth@gmail.com>
 <20210411200135.35fb5985@thinkpad>
 <20210411185017.3xf7kxzzq2vefpwu@skbuf>
 <878s5nllgs.fsf@waldekranz.com>
 <20210412213045.4277a598@thinkpad>
 <8735vvkxju.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8735vvkxju.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 12, 2021 at 11:22:45PM +0200, Tobias Waldekranz wrote:
> On Mon, Apr 12, 2021 at 21:30, Marek Behun <marek.behun@nic.cz> wrote:
> > On Mon, 12 Apr 2021 14:46:11 +0200
> > Tobias Waldekranz <tobias@waldekranz.com> wrote:
> >
> >> I agree. Unless you only have a few really wideband flows, a LAG will
> >> typically do a great job with balancing. This will happen without the
> >> user having to do any configuration at all. It would also perform well
> >> in "router-on-a-stick"-setups where the incoming and outgoing port is
> >> the same.
> >
> > TLDR: The problem with LAGs how they are currently implemented is that
> > for Turris Omnia, basically in 1/16 of configurations the traffic would
> > go via one CPU port anyway.
> >
> >
> >
> > One potencial problem that I see with using LAGs for aggregating CPU
> > ports on mv88e6xxx is how these switches determine the port for a
> > packet: only the src and dst MAC address is used for the hash that
> > chooses the port.
> >
> > The most common scenario for Turris Omnia, for example, where we have 2
> > CPU ports and 5 user ports, is that into these 5 user ports the user
> > plugs 5 simple devices (no switches, so only one peer MAC address for
> > port). So we have only 5 pairs of src + dst MAC addresses. If we simply
> > fill the LAG table as it is done now, then there is 2 * 0.5^5 = 1/16
> > chance that all packets would go through one CPU port.
> >
> > In order to have real load balancing in this scenario, we would either
> > have to recompute the LAG mask table depending on the MAC addresses, or
> > rewrite the LAG mask table somewhat randomly periodically. (This could
> > be in theory offloaded onto the Z80 internal CPU for some of the
> > switches of the mv88e6xxx family, but not for Omnia.)
> 
> I thought that the option to associate each port netdev with a DSA
> master would only be used on transmit. Are you saying that there is a
> way to configure an mv88e6xxx chip to steer packets to different CPU
> ports depending on the incoming port?
> 
> The reason that the traffic is directed towards the CPU is that some
> kind of entry in the ATU says so, and the destination of that entry will
> either be a port vector or a LAG. Of those two, only the LAG will offer
> any kind of balancing. What am I missing?
> 
> Transmit is easy; you are already in the CPU, so you can use an
> arbitrarily fancy hashing algo/ebpf classifier/whatever to load balance
> in that case.

Say a user port receives a broadcast frame. Based on your understanding
where user-to-CPU port assignments are used only for TX, which CPU port
should be selected by the switch for this broadcast packet, and by which
mechanism?
