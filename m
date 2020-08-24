Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5EAA24F115
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 04:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728041AbgHXC1I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 22:27:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726737AbgHXC1G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Aug 2020 22:27:06 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4589EC061573
        for <netdev@vger.kernel.org>; Sun, 23 Aug 2020 19:27:06 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id h3so6955793oie.11
        for <netdev@vger.kernel.org>; Sun, 23 Aug 2020 19:27:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FCVfAlsTA63jiRAb8dpv9wWWcLaQKJX9FXa7o9Q7BRw=;
        b=A8nc26tje2KlJW0PL+VSjjc+P/KALAeDIN8C3GLo/jc3LiysB5L7u3a561cXQ7jyEY
         pbiGNb0eQZbe+kZIclwTpR/qMcKcnkw42EGjB10AVOoU5A3fgYPoq1rxiawNnNmhd07u
         3JpTWFcSfYcrY7AynCN33sc9m8Zi3ORTjBF5hfYUkInQmxPLjfLP2WNPAZb79e956fLG
         AXInycR1nm2+2RNJ5nKCcoMShM9cf2fBvG7avugK3fx9p8P4Cgy46iZ/VW4jPSxz/83N
         RoMcdEYq+DUhTHUeQ6FAEQG/nqos/PycmFGV80vkQJY4fZQ9FL46ko7BdoWCp5AJzqQv
         uA9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FCVfAlsTA63jiRAb8dpv9wWWcLaQKJX9FXa7o9Q7BRw=;
        b=nIuDu9zVnnXjSmz76fyMXnPcuZEkKkjjufCAT4lG/bpDFRaq1toyY+B/SjfRt3e2e4
         wp5QOeJW440W09uN6AhxN7B3k0c3T1Kt3p0TyIIszZe69QGmuZwdWOBZhz/JdJvv/NHI
         M1RrQF1ppZeIU93Q5XX6UEGg8MSq+EG3XAvD5gCCvwPQBwFRIZFGrzbmfC1MIq56FG85
         cIazi440+GEeoMfdEBzYKmzJlwK/pG18QV6QgefLjVg6Gxbiw4U/VcrBcHhX3LIcrac3
         kSVceP+78ZTcWn/18gB4TFN4jRhitkw/skNHbQ7faX2zTHbTYnKV0X2+G6I9c+qXoXmv
         YDfQ==
X-Gm-Message-State: AOAM5331xCU5Minqcs3A0E34TS8N2U+0vilz4Ui6NiAlkcFiiKtjGTQr
        gjPMaif8fIwTIdWGbjEoKifgSNH8jsLkzw==
X-Google-Smtp-Source: ABdhPJwgC3vw37Ny2LHzUEXoZv3cCb9rWLXgcoy4v5eB4046HIKSwVn/PF2vKFv5hCBYul8JOujETg==
X-Received: by 2002:a54:478f:: with SMTP id o15mr2026600oic.137.1598236025256;
        Sun, 23 Aug 2020 19:27:05 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:39b0:ac18:30c6:b094])
        by smtp.googlemail.com with ESMTPSA id l24sm1789293otf.79.2020.08.23.19.27.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Aug 2020 19:27:04 -0700 (PDT)
Subject: Re: [PATCH] ipv4: fix the problem of ping failure in some cases
To:     guodeqing <geffrey.guo@huawei.com>, davem@davemloft.net
Cc:     kuba@kernel.org, dsahern@gmail.com, netdev@vger.kernel.org
References: <1598082397-115790-1-git-send-email-geffrey.guo@huawei.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <0b7e931b-f159-4f53-1b9b-5bf84a072712@gmail.com>
Date:   Sun, 23 Aug 2020 20:27:03 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <1598082397-115790-1-git-send-email-geffrey.guo@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/22/20 1:46 AM, guodeqing wrote:
> ie.,
> $ ifconfig eth0 9.9.9.9 netmask 255.255.255.0
> 
> $ ping -I lo 9.9.9.9
> ping: Warning: source address might be selected on device other than lo.
> PING 9.9.9.9 (9.9.9.9) from 9.9.9.9 lo: 56(84) bytes of data.
> 
> 4 packets transmitted, 0 received, 100% packet loss, time 3068ms
> 
> This is because the return value of __raw_v4_lookup in raw_v4_input
> is null, the packets cannot be sent to the ping application.
> The reason of the __raw_v4_lookup failure is that sk_bound_dev_if and
> dif/sdif are not equal in raw_sk_bound_dev_eq.
> 
> Here I add a check of whether the sk_bound_dev_if is LOOPBACK_IFINDEX
> to solve this problem.
> 
> Fixes: 19e4e768064a8 ("ipv4: Fix raw socket lookup for local traffic")
> Signed-off-by: guodeqing <geffrey.guo@huawei.com>
> ---
>  include/net/inet_sock.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/net/inet_sock.h b/include/net/inet_sock.h
> index a3702d1..7707b1d 100644
> --- a/include/net/inet_sock.h
> +++ b/include/net/inet_sock.h
> @@ -144,7 +144,7 @@ static inline bool inet_bound_dev_eq(bool l3mdev_accept, int bound_dev_if,
>  {
>  	if (!bound_dev_if)
>  		return !sdif || l3mdev_accept;
> -	return bound_dev_if == dif || bound_dev_if == sdif;
> +	return bound_dev_if == dif || bound_dev_if == sdif || bound_dev_if == LOOPBACK_IFINDEX;
>  }
>  
>  struct inet_cork {
> 

this is used by more than just raw socket lookups.
