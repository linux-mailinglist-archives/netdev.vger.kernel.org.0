Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE9B1333947
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 10:55:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231908AbhCJJzE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 04:55:04 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:51199 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231825AbhCJJyw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 04:54:52 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 2BA935C0192;
        Wed, 10 Mar 2021 04:54:52 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 10 Mar 2021 04:54:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=j/eWzm
        PI4qL6rz9yBjvn+TCT28p4blsEfsFaH1p9YC8=; b=WzBkNgAn+wuETyBCvQz1Mk
        eulLAlpBBrXqHDoGsaheeLbUmE7DtLKzcmUZ51BXQCpV7+CTvbQwqeUC/T8p7TUX
        ULVApKfl7jwbGCxHaCIEl2qAnng9iAk7uJ/YBxZ1Ku9Y7/VV3oKAr7t12tpBIqJi
        SBDBlvNsL7Vq6zeb//Z06X1osr/9kpXisk1hKDQ97aUO9KGktmhoS0qNOX1Pz+g1
        yeHZt3nxE7K+aYY058ftfVoZc3oKyWWrHbQFhauxJziaCOf+C/M4gLnR+wTyJgDY
        +EAev3+UJUs0LyrkpWZ1/z6Gjo74edUjcLGKw+pPsmtLW6YRsZwW3NqjM7PZd0mA
        ==
X-ME-Sender: <xms:a5dIYEGrUKkujlbDmJ8Xo2hWLS895kPMDyj3pcCG35dinR6a4l9TGw>
    <xme:a5dIYNVsFxdbbRA7hCPU-Y0abc-67os3_jbSAYeHwURLrRSY1AkUkPfuf-osqkAER
    lx0p7TIBRHmPX8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddukedguddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucfkphepkeegrddvvdelrdduheefrdeggeenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:a5dIYOIMfeKE4b2seIv2UCJj9M-AUuOWNp1ZTUgw47P_Rbcck0bDuw>
    <xmx:a5dIYGH0DOrg1rZhANRZSfCWYYgAjTJwo9fdj3gxGkVFnB3uMgO5rg>
    <xmx:a5dIYKX3wu41ul-LeEjzvWjf1ETtIYm0OXEgOUQ5fEHIbrnyC7-_Vg>
    <xmx:bJdIYIyG2Q3VVjHxx49dVobr8edn5l7F58G9eAQJeYAiQc8Iyp-bgQ>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 62315240057;
        Wed, 10 Mar 2021 04:54:51 -0500 (EST)
Date:   Wed, 10 Mar 2021 11:54:47 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Wei Wang <weiwan@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        syzbot <syzkaller@googlegroups.com>,
        David Ahern <dsahern@kernel.org>,
        Petr Machata <petrm@nvidia.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net v2] ipv6: fix suspecious RCU usage warning
Message-ID: <YEiXZ2K7GTVNE9F0@shredder.lan>
References: <20210310022035.2908294-1-weiwan@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210310022035.2908294-1-weiwan@google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 09, 2021 at 06:20:35PM -0800, Wei Wang wrote:
> Syzbot reported the suspecious RCU usage in nexthop_fib6_nh() when
> called from ipv6_route_seq_show(). The reason is ipv6_route_seq_start()
> calls rcu_read_lock_bh(), while nexthop_fib6_nh() calls
> rcu_dereference_rtnl().
> The fix proposed is to add a variant of nexthop_fib6_nh() to use
> rcu_dereference_bh_rtnl() for ipv6_route_seq_show().
> 
> The reported trace is as follows:
> ./include/net/nexthop.h:416 suspicious rcu_dereference_check() usage!
> 
> other info that might help us debug this:
> 
> rcu_scheduler_active = 2, debug_locks = 1
> 2 locks held by syz-executor.0/17895:
>      at: seq_read+0x71/0x12a0 fs/seq_file.c:169
>      at: seq_file_net include/linux/seq_file_net.h:19 [inline]
>      at: ipv6_route_seq_start+0xaf/0x300 net/ipv6/ip6_fib.c:2616

[...]

> 
> Fixes: f88d8ea67fbdb ("ipv6: Plumb support for nexthop object in a fib6_info")
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Signed-off-by: Wei Wang <weiwan@google.com>
> Cc: David Ahern <dsahern@kernel.org>
> Cc: Ido Schimmel <idosch@idosch.org>
> Cc: Petr Machata <petrm@nvidia.com>
> Cc: Eric Dumazet <edumazet@google.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
