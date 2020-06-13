Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75B0C1F83BA
	for <lists+netdev@lfdr.de>; Sat, 13 Jun 2020 16:32:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbgFMOb7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Jun 2020 10:31:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726323AbgFMOb6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Jun 2020 10:31:58 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDE2DC03E96F
        for <netdev@vger.kernel.org>; Sat, 13 Jun 2020 07:31:58 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id i16so9346595qtr.7
        for <netdev@vger.kernel.org>; Sat, 13 Jun 2020 07:31:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=60jtR6x6sT4nhAd2whYFNoR1fQ2RbLGDpVQJf9prCjA=;
        b=lQnKahaAglFTdrDTWd/sHvn49JFe9tSJ20024ZbfUhuJMVJKpIZl3F5DRZLOlf+Q+T
         bIRPqiy0RxUdRz/OypmE3VM6jx8BkwKsqT5A0W9B+nA9tWhLs1a2hI/8HQTpAdw6NSi1
         FTnZ/lHbfSuM65MUGsNYhVYAXgadvDKVtXemwLVOeW23oemZ4YjSNjFr5YmRU93teiWd
         dbxVXMVugx9CYbVj/CZgKj586XU7fPz2lVjRy1qEPGiD6lOdiKi3WtT1wIEVpml+T5n6
         DUlx9c8di++w5FtSFkbpqK9+w7pc5LnXULa6PA2YEqoLIV+lvNbBkpMHaPh/G7YMDHem
         TiZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=60jtR6x6sT4nhAd2whYFNoR1fQ2RbLGDpVQJf9prCjA=;
        b=QtyChWuqF+sJUxs/P4+kZj8JfRaF1zzcwjZUwUClZywkzjRYBgZfRKMg33yNx2gUKk
         okXT0M/x0xygwpfWIWDUDFJC836iFZT/OrwIkDN9h8ZxD7eYVyychTzVd7At8mg1Jz8H
         +9Yo3h+k1o5adv1p1banAky0j4n8ps0Y1XmjgJXMDGloLWuwrutnVeWTkpPQAUolmbqd
         UT5HMf+NTnczgKpppqHfu0LMHHdCr+ciyjLtP7SvUlbXAJ5nDUxb7bTx5Mseh84yH0bP
         whMK0cBNL0uzypNg/TG/Dr60Th5gvMgf2h/J8WhXMDpqv+ii7TbAkk0zha6EJsywQF0z
         kcrg==
X-Gm-Message-State: AOAM531h1JnTLvM6xRWhLX6h8gy1IymVOVQp7ZoDqDYV4rEfRcI8NDEI
        a1gxtx43n1CkbNKCCnrcNMS80py2
X-Google-Smtp-Source: ABdhPJwKVLLy2jgDSRSZQLZVo0ra/AzQDh9QEEm5bvp196HM0epXNQHSBNOQV5zM6BY+45EMEa47HA==
X-Received: by 2002:ac8:1942:: with SMTP id g2mr8199732qtk.107.1592058716515;
        Sat, 13 Jun 2020 07:31:56 -0700 (PDT)
Received: from ?IPv6:2601:284:8202:10b0:c0a6:d168:a4bb:a408? ([2601:284:8202:10b0:c0a6:d168:a4bb:a408])
        by smtp.googlemail.com with ESMTPSA id 69sm6751630qkh.15.2020.06.13.07.31.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Jun 2020 07:31:55 -0700 (PDT)
Subject: Re: [PATCH] net: Fix the arp error in some cases
To:     guodeqing <geffrey.guo@huawei.com>, davem@davemloft.net
Cc:     kuznet@ms2.inr.ac.ru, netdev@vger.kernel.org,
        dsa@cumulusnetworks.com, kuba@kernel.org
References: <1592030995-111190-1-git-send-email-geffrey.guo@huawei.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <5679487d-cd17-fc91-2474-e12b182a59b7@gmail.com>
Date:   Sat, 13 Jun 2020 08:31:54 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <1592030995-111190-1-git-send-email-geffrey.guo@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/13/20 12:49 AM, guodeqing wrote:
> ie.,
> $ ifconfig eth0 6.6.6.6 netmask 255.255.255.0
> 
> $ ip rule add from 6.6.6.6 table 6666

without a default entry in table 6666 the lookup proceeds to the next
table - which by default is the main table.

> 
> $ ip route add 9.9.9.9 via 6.6.6.6
> 
> $ ping -I 6.6.6.6 9.9.9.9
> PING 9.9.9.9 (9.9.9.9) from 6.6.6.6 : 56(84) bytes of data.
> 
> ^C
> --- 9.9.9.9 ping statistics ---
> 3 packets transmitted, 0 received, 100% packet loss, time 2079ms
> 
> $ arp
> Address     HWtype  HWaddress           Flags Mask            Iface
> 6.6.6.6             (incomplete)                              eth0
> 
> The arp request address is error, this problem can be reproduced easily.
> 
> Fixes: 3bfd847203c6("net: Use passed in table for nexthop lookups")
> Signed-off-by: guodeqing <geffrey.guo@huawei.com>
> ---
>  net/ipv4/fib_semantics.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
> index e53871e..1f75dc6 100644
> --- a/net/ipv4/fib_semantics.c
> +++ b/net/ipv4/fib_semantics.c
> @@ -1109,7 +1109,7 @@ static int fib_check_nh_v4_gw(struct net *net, struct fib_nh *nh, u32 table,
>  		if (fl4.flowi4_scope < RT_SCOPE_LINK)
>  			fl4.flowi4_scope = RT_SCOPE_LINK;
>  
> -		if (table)
> +		if (table && table != RT_TABLE_MAIN)
>  			tbl = fib_get_table(net, table);
>  
>  		if (tbl)
> 

how does gateway validation when the route is installed affect arp
resolution?

you are missing something in explaining the problem you are seeing.
