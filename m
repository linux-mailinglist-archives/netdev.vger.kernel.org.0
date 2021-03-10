Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8A93342D5
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 17:16:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233038AbhCJQPR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 11:15:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231519AbhCJQPJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 11:15:09 -0500
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37EF8C061760
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 08:15:09 -0800 (PST)
Received: by mail-ot1-x334.google.com with SMTP id n23so11269006otq.1
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 08:15:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=T7kGzRNnCMOsh/8T66jkf8hStIE3TfkmsNmveWUDPuw=;
        b=WhZFLjlCPlWj1jdggSsadPWwEPhsY/kGXjZgXJUjYcUdad/SpAo0myr5fLHzBQb2S0
         ipGqvPqJs2LNtzQhj4qswq0+/zN9JAYs6ViHJoujr/2VyaadtzdFXPL4PJPKtry/v14d
         uLjC7nmJEYiIu9imgYPS/+Y+10oBWzo5OQhATxdKxx5q1haphwxc5tqFrZkQxru2l0qk
         CvQ8dGiTXqrA6B+Z+3URcUdQjA35LUfR0B1n+t3aZM4BYiDmCpAsv4fYuTS+cNqUaZ0W
         MWEomEq+ZgUbzF/GkHaB6HQtOWysjNgWMbinkN/A36CCE6lLcYE3J3G1XD3ySsLL41IJ
         xwqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=T7kGzRNnCMOsh/8T66jkf8hStIE3TfkmsNmveWUDPuw=;
        b=OKFxWw36l0a4nNToniCFUAQWHwHl+VQmtCOH5lTCkiRD0LYxb0GU2M7i1Ob9Qhc6uQ
         1O+AXhZ5GYS7EIu7I7TlY4JRYDkitbr1xsB/WRXoTKav6jOw/CSgKH/wL+E5NRQaxtYJ
         ccc6IPiLCOyaxYm7b+apOmTi2JeSppnPiDR7Upvr7NXirsDApjusQ/wE5Ha5pWcwFSjf
         DjFhQFnFZ+zohbzL+5+2WZzmMlOIRlThYsCDQ4p9uHuqzOvGZicCutiThlPag+lDDv91
         TXLbbS5BjqjzNhp5RSvnxNkJWnKeS6LDVlIwPatb50a22EuJFFZUeLfFT4sPxnKaW+pO
         uvBA==
X-Gm-Message-State: AOAM533/q6h4my+GdQs4OdxuVhNvUKa8FGIfBKgMe/Xhtfxbhcq0Xs+q
        q/fF8c20gwy4ZQMfjnklaxI=
X-Google-Smtp-Source: ABdhPJz3wK5lEPXskOjxvfF95xz7hR/CDeIdgS8oNvtqXIMDLRpohWhsorjh4VXWOudnq1fpy8MAJA==
X-Received: by 2002:a9d:19a3:: with SMTP id k32mr3157266otk.189.1615392908695;
        Wed, 10 Mar 2021 08:15:08 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.56])
        by smtp.googlemail.com with ESMTPSA id s21sm3719414oos.5.2021.03.10.08.15.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Mar 2021 08:15:07 -0800 (PST)
Subject: Re: [PATCH net v2] ipv6: fix suspecious RCU usage warning
To:     Wei Wang <weiwan@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     syzbot <syzkaller@googlegroups.com>,
        David Ahern <dsahern@kernel.org>,
        Ido Schimmel <idosch@idosch.org>,
        Petr Machata <petrm@nvidia.com>,
        Eric Dumazet <edumazet@google.com>
References: <20210310022035.2908294-1-weiwan@google.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <2cdaaaed-7529-48cf-5bcc-59da5c93c6d2@gmail.com>
Date:   Wed, 10 Mar 2021 09:15:03 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210310022035.2908294-1-weiwan@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/9/21 7:20 PM, Wei Wang wrote:
> Syzbot reported the suspecious RCU usage in nexthop_fib6_nh() when
> called from ipv6_route_seq_show(). The reason is ipv6_route_seq_start()
> calls rcu_read_lock_bh(), while nexthop_fib6_nh() calls
> rcu_dereference_rtnl().
> The fix proposed is to add a variant of nexthop_fib6_nh() to use
> rcu_dereference_bh_rtnl() for ipv6_route_seq_show().
> 

...

> 
> Fixes: f88d8ea67fbdb ("ipv6: Plumb support for nexthop object in a fib6_info")
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Signed-off-by: Wei Wang <weiwan@google.com>
> Cc: David Ahern <dsahern@kernel.org>
> Cc: Ido Schimmel <idosch@idosch.org>
> Cc: Petr Machata <petrm@nvidia.com>
> Cc: Eric Dumazet <edumazet@google.com>
> ---
>  include/net/nexthop.h | 24 ++++++++++++++++++++++++
>  net/ipv6/ip6_fib.c    |  2 +-
>  2 files changed, 25 insertions(+), 1 deletion(-)
> 


Reviewed-by: David Ahern <dsahern@kernel.org>

Thanks, Wei.
