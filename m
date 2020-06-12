Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E2B51F74D9
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 09:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbgFLHyA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 03:54:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726292AbgFLHyA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jun 2020 03:54:00 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18DF2C03E96F;
        Fri, 12 Jun 2020 00:54:00 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id l63so1515725pge.12;
        Fri, 12 Jun 2020 00:54:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HSoq4fBhS29jXlxAf4nZSM1jPyTY7Z30awoY3tBw3PQ=;
        b=nmTT6wctBTX45TLNOJwZ4VyRRvGUnMU5TSdZOv5y0Ho0eDYJv86f+kQvPQYDQWew6Z
         4EE/Q408+iH+qIa+5q3Y99gTw5dUaV5DFaCjpunDVWbofWYPQmtyZyFIwjVcgtb9rMML
         wWKBDx7MLOB4tbgCC8xDdEqMBJgnEA1nx4LLxv5beK8O5h6IG+66HOOM3ObveGvNuJMA
         qEQWKNMXQy6bDBjbEyHArvMf8gb690IuiTwp0sfWMwbPgayFPLTEpZYTbA2hjzBmyoxv
         mNTSV5s0paitouq/FGuMkuv96oaSFi9M9CaAhNsLfYZORK8OZQ7blm6nd+BB4YQtcWx3
         FOcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HSoq4fBhS29jXlxAf4nZSM1jPyTY7Z30awoY3tBw3PQ=;
        b=TuFV5XvIqDGAJQnxcqm/UvYUQgMDh+ncS1lAY1ki2oVvTyI0uM4S9EKJxAfCeNk1Aq
         pavFGIw9WffbNdxAu7i4kWvOgzSMA23hNlYwpIBss0DcXfGqeHezQAY6k3P8KwCPFdlD
         o0rQ5Zg/FAGVEjq1pYFDRF106xaitWnCx6VXjfX0sW9OS5tR0SRu9AwAX08EqFD04c5N
         LZEh1RWKQDOBSxm2W+Y5AXj3vTpi30C5No5e9M6FrgfLNpc2ir36VWlNrP22u8WhtNA2
         NXurK8IsT4GJcgfIwtPkVLhKaV6SJMgmX1rsIjjWxTwONf+GCDvy0eOPbDee0SVb8kLr
         0d7w==
X-Gm-Message-State: AOAM530xW1VmWwCYs7fyDQZejynCpkvzFTsMJBkbaqr4o5ZsOJ6lK1XD
        sEV3VLepwui6oguLP2RugoVliORUgmL9Xw==
X-Google-Smtp-Source: ABdhPJw14zTabvGzNU3WA59zgPm0zbxC+yUlYaSaCQt2fnFHW+xwviKmJdi0iiYY5IXr9qbkgC4TLg==
X-Received: by 2002:a62:3183:: with SMTP id x125mr1553356pfx.3.1591948439461;
        Fri, 12 Jun 2020 00:53:59 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w18sm5350811pfq.121.2020.06.12.00.53.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2020 00:53:58 -0700 (PDT)
Date:   Fri, 12 Jun 2020 15:53:48 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Wang Hai <wanghai38@huawei.com>
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] mld: fix memory leak in ipv6_mc_destroy_dev()
Message-ID: <20200612075348.GS102436@dhcp-12-153.nay.redhat.com>
References: <20200611075750.18545-1-wanghai38@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200611075750.18545-1-wanghai38@huawei.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 11, 2020 at 03:57:50PM +0800, Wang Hai wrote:
> Commit a84d01647989 ("mld: fix memory leak in mld_del_delrec()") fixed
> the memory leak of MLD, but missing the ipv6_mc_destroy_dev() path, in
> which mca_sources are leaked after ma_put().
> 
> Using ip6_mc_clear_src() to take care of the missing free.
> 
> BUG: memory leak
> unreferenced object 0xffff8881113d3180 (size 64):
>   comm "syz-executor071", pid 389, jiffies 4294887985 (age 17.943s)
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 ff 02 00 00 00 00 00 00  ................
>     00 00 00 00 00 00 00 01 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<000000002cbc483c>] kmalloc include/linux/slab.h:555 [inline]
>     [<000000002cbc483c>] kzalloc include/linux/slab.h:669 [inline]
>     [<000000002cbc483c>] ip6_mc_add1_src net/ipv6/mcast.c:2237 [inline]
>     [<000000002cbc483c>] ip6_mc_add_src+0x7f5/0xbb0 net/ipv6/mcast.c:2357
>     [<0000000058b8b1ff>] ip6_mc_source+0xe0c/0x1530 net/ipv6/mcast.c:449
>     [<000000000bfc4fb5>] do_ipv6_setsockopt.isra.12+0x1b2c/0x3b30 net/ipv6/ipv6_sockglue.c:754
>     [<00000000e4e7a722>] ipv6_setsockopt+0xda/0x150 net/ipv6/ipv6_sockglue.c:950
>     [<0000000029260d9a>] rawv6_setsockopt+0x45/0x100 net/ipv6/raw.c:1081
>     [<000000005c1b46f9>] __sys_setsockopt+0x131/0x210 net/socket.c:2132
>     [<000000008491f7db>] __do_sys_setsockopt net/socket.c:2148 [inline]
>     [<000000008491f7db>] __se_sys_setsockopt net/socket.c:2145 [inline]
>     [<000000008491f7db>] __x64_sys_setsockopt+0xba/0x150 net/socket.c:2145
>     [<00000000c7bc11c5>] do_syscall_64+0xa1/0x530 arch/x86/entry/common.c:295
>     [<000000005fb7a3f3>] entry_SYSCALL_64_after_hwframe+0x49/0xb3
> 
> Fixes: 1666d49e1d41 ("mld: do not remove mld souce list info when set link down")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wang Hai <wanghai38@huawei.com>
> ---
>  net/ipv6/mcast.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
> index 7e12d2114158..8cd2782a31e4 100644
> --- a/net/ipv6/mcast.c
> +++ b/net/ipv6/mcast.c
> @@ -2615,6 +2615,7 @@ void ipv6_mc_destroy_dev(struct inet6_dev *idev)
>  		idev->mc_list = i->next;
>  
>  		write_unlock_bh(&idev->lock);
> +		ip6_mc_clear_src(i);
>  		ma_put(i);
>  		write_lock_bh(&idev->lock);
>  	}
> -- 
> 2.17.1
> 

Acked-by: Hangbin Liu <liuhangbin@gmail.com>
