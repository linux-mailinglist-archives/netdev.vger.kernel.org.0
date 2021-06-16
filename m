Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECDCA3A999A
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 13:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232559AbhFPLyS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 07:54:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230262AbhFPLyR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 07:54:17 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DC9EC061574;
        Wed, 16 Jun 2021 04:52:11 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id e33so1769365pgm.3;
        Wed, 16 Jun 2021 04:52:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Zi4349ytEsYpxEnkJFAQeeIv2zTZD4tj8+PmWF7nGW0=;
        b=Be7KycS09MBuq+l7OABg5896QJrhC+VUbDS82seDG7loqyvEg+BuryvDiz1sFkPXZT
         Kmo8bwleZJ7HzkxOf6vivBevRuVhciSiHBHlNwLt7pZWXDa5B83G28rNKZBrhhfOv8Xg
         pPrn4aBL6SMeqSFZK8W1fa0iDXKBRE7aDaMHLmhAGonifSURRVbDUjfw2cm7z9BHvPTm
         DkYBXw35YJtwo6VnU8dYP80Sl93GSQ1Dx9KHVkKnB3zOcwphbgl+KLuwvrJPI8N+3SBJ
         hAkQD+D9H49nBve9kfViv2EwcQTHpBdojT0MXX8uIGbBd/5g/HU/N5LY4XWdeg3vXgRu
         DEtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Zi4349ytEsYpxEnkJFAQeeIv2zTZD4tj8+PmWF7nGW0=;
        b=qlw3l/ttcEeXj80dMrzocMshd161upNyaIuq0T0IL5//y90oZl3E0BYBlWOGHmBHoj
         EfSJzPRioy6tIj13RuYbm1ot/rsvkRFbHUcEx1eIWVrtG102FMg3+2Q8XpNoK+Pvfbrw
         NeWvC11VPdkhUsG9K8vjHGpZcILW/04EFG+KY7n5MnPbjRFJ2pQzv2eoULJLDjESThJx
         +TOOpXdRNjcTAeDwoaP4hEwx8cmJ6CIxgK0UuUtyeS7ICHciC6Z4j5rn0rhE0w+qXhPl
         qPP7t2+TDQN6ENAWSHIS0yR6e3GRwk6PekVyJ4nkfoXqn0RTZgqiX1xOPEX3SlXS/F6b
         jzYA==
X-Gm-Message-State: AOAM533J6fNjvCx4suMTXh9sShB3WkQo6xrFb2tuTvKNoBqIUPv6dcqf
        otxUuin9d5/D1xD7WZQU4nE=
X-Google-Smtp-Source: ABdhPJzqkUaZQ4vxPO2mBmT6tLw168sF+R0e0dVbvCsXpHhGE4H5TlvL0QzE7K15nwsnno9bd4XlmA==
X-Received: by 2002:a05:6a00:a17:b029:2f9:a2bb:e126 with SMTP id p23-20020a056a000a17b02902f9a2bbe126mr9612244pfh.30.1623844330672;
        Wed, 16 Jun 2021 04:52:10 -0700 (PDT)
Received: from fedora ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id ca6sm2201348pjb.21.2021.06.16.04.52.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jun 2021 04:52:10 -0700 (PDT)
Date:   Wed, 16 Jun 2021 19:52:04 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Chengyang Fan <cy.fan@huawei.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ipv4: fix memory leak in ip_mc_add1_src
Message-ID: <YMnl5C/jhqpQSmvQ@fedora>
References: <20210616095925.1571600-1-cy.fan@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210616095925.1571600-1-cy.fan@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 16, 2021 at 05:59:25PM +0800, Chengyang Fan wrote:
> BUG: memory leak
> unreferenced object 0xffff888101bc4c00 (size 32):
>   comm "syz-executor527", pid 360, jiffies 4294807421 (age 19.329s)
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
>     01 00 00 00 00 00 00 00 ac 14 14 bb 00 00 02 00 ................
>   backtrace:
>     [<00000000f17c5244>] kmalloc include/linux/slab.h:558 [inline]
>     [<00000000f17c5244>] kzalloc include/linux/slab.h:688 [inline]
>     [<00000000f17c5244>] ip_mc_add1_src net/ipv4/igmp.c:1971 [inline]
>     [<00000000f17c5244>] ip_mc_add_src+0x95f/0xdb0 net/ipv4/igmp.c:2095
>     [<000000001cb99709>] ip_mc_source+0x84c/0xea0 net/ipv4/igmp.c:2416
>     [<0000000052cf19ed>] do_ip_setsockopt net/ipv4/ip_sockglue.c:1294 [inline]
>     [<0000000052cf19ed>] ip_setsockopt+0x114b/0x30c0 net/ipv4/ip_sockglue.c:1423
>     [<00000000477edfbc>] raw_setsockopt+0x13d/0x170 net/ipv4/raw.c:857
>     [<00000000e75ca9bb>] __sys_setsockopt+0x158/0x270 net/socket.c:2117
>     [<00000000bdb993a8>] __do_sys_setsockopt net/socket.c:2128 [inline]
>     [<00000000bdb993a8>] __se_sys_setsockopt net/socket.c:2125 [inline]
>     [<00000000bdb993a8>] __x64_sys_setsockopt+0xba/0x150 net/socket.c:2125
>     [<000000006a1ffdbd>] do_syscall_64+0x40/0x80 arch/x86/entry/common.c:47
>     [<00000000b11467c4>] entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> In commit 24803f38a5c0 ("igmp: do not remove igmp souce list info when set
> link down"), the ip_mc_clear_src() in ip_mc_destroy_dev() was removed,
> because it was also called in igmpv3_clear_delrec().
> 
> Rough callgraph:
> 
> inetdev_destroy
> -> ip_mc_destroy_dev
>      -> igmpv3_clear_delrec
>         -> ip_mc_clear_src
> -> RCU_INIT_POINTER(dev->ip_ptr, NULL)
> 
> However, ip_mc_clear_src() called in igmpv3_clear_delrec() doesn't
> release in_dev->mc_list->sources. And RCU_INIT_POINTER() assigns the
> NULL to dev->ip_ptr. As a result, in_dev cannot be obtained through
> inetdev_by_index() and then in_dev->mc_list->sources cannot be released
> by ip_mc_del1_src() in the sock_close. Rough call sequence goes like:
> 
> sock_close
> -> __sock_release
>    -> inet_release
>       -> ip_mc_drop_socket
>          -> inetdev_by_index
>          -> ip_mc_leave_src
>             -> ip_mc_del_src
>                -> ip_mc_del1_src
> 
> So we still need to call ip_mc_clear_src() in ip_mc_destroy_dev() to free
> in_dev->mc_list->sources.
> 
> Fixes: 24803f38a5c0 ("igmp: do not remove igmp souce list info ...")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Chengyang Fan <cy.fan@huawei.com>
> ---
>  net/ipv4/igmp.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
> index 7b272bbed2b4..6b3c558a4f23 100644
> --- a/net/ipv4/igmp.c
> +++ b/net/ipv4/igmp.c
> @@ -1801,6 +1801,7 @@ void ip_mc_destroy_dev(struct in_device *in_dev)
>  	while ((i = rtnl_dereference(in_dev->mc_list)) != NULL) {
>  		in_dev->mc_list = i->next_rcu;
>  		in_dev->mc_count--;
> +		ip_mc_clear_src(i);
>  		ip_ma_put(i);
>  	}
>  }
> -- 
> 2.18.0.huawei.25
> 

Acked-by: Hangbin Liu <liuhangbin@gmail.com>
