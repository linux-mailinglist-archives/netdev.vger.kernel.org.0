Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E77CED4F32
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 12:59:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729179AbfJLK7T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 06:59:19 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:33840 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726793AbfJLK7S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Oct 2019 06:59:18 -0400
Received: by mail-pf1-f193.google.com with SMTP id b128so7615756pfa.1;
        Sat, 12 Oct 2019 03:59:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6fUiD8LPGpZDa0Tf3+BA1bwVbaY9YN/1BL2mRpt5n4k=;
        b=LhiGFfmH7SMf3b0HVzYAS3u8ZxHPRzoBjeavwfU0XlyOzqZRdG74ZFCFS+v3mwwHpd
         oAcyHLvA4MLhwCCk6ssCCkl7M+nJVB1H8zJniiQ3gbHjbnBBNa7Gbfv6AZXzCGMnlJWA
         KTXO54X4VixcYMXoWFp5JgTgxvZ6hZajIeCeoLOkFtmXiyjfCdZAns9jjTnD7PpNOo2z
         k2+98N20AefoXaivNZtZRhvfPtKGbHiGf0qvpfY0/jAus1uNAHvo9mxIaCw6za4EOvlc
         l8xbGDtRk/+lvoNgN5/Fe4+tts6wlGktkmiXc8uXFwQng6FrYAnDc+hThNwoMbLyrKzB
         GHlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6fUiD8LPGpZDa0Tf3+BA1bwVbaY9YN/1BL2mRpt5n4k=;
        b=QAaTQ2k6fF6gz42gKx+pG0eVBlqLYHt9dj5+RIXQU4Iq7AeMbHUrRuAPmEJKqD3nWz
         qqedibHdYB6l0Zslhh9maLCGiTU1ubqpHAUzZXtbaRYNngFJsL1/O3gq3O2mv4XEYqIA
         KuMyRKUm9weNPodJ+26ywAMHNgWGbJT/KlN5GnHgQtImYk+HLahwgQ4fAv9Yr8+XtV4Z
         P82RyzCrkQyvq5Kyz20nl7/R4XZ2eOrrHoyKWtRi/zdavbKc/SMm508Ub56PKWDYaTp8
         R/UePPm52D154xeLhR6QIahZwAoIp7sItNUlIxLwPaU/bKjhWpxplUhv5nTWzXXMOV+K
         xEUw==
X-Gm-Message-State: APjAAAUDgCEghPWRkDIZ2UwuHVpJK/e0KxSe2oQH4lXY5HBxCf/p1hf+
        SJOYocU4LJK+UuLWIqbva2QW5fMW
X-Google-Smtp-Source: APXvYqztSVZQajvqBQQ7ZBMUAnu7VZ8xuM7iDkFGCsXPOxf2MmeJ+xKiIIE/3D77RYOnL/P8spxHGw==
X-Received: by 2002:a63:33c7:: with SMTP id z190mr21314005pgz.67.1570877957779;
        Sat, 12 Oct 2019 03:59:17 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-70.hsd1.ca.comcast.net. [73.241.150.70])
        by smtp.gmail.com with ESMTPSA id f17sm10481049pgd.8.2019.10.12.03.59.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 12 Oct 2019 03:59:17 -0700 (PDT)
Subject: Re: [PATCH net] net: sched: act_mirred: drop skb's dst_entry in
 ingress redirection
To:     Zhiyuan Hou <zhiyuan2048@linux.alibaba.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20191012071620.8595-1-zhiyuan2048@linux.alibaba.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <2d816fb6-befb-aaeb-328b-539507022a22@gmail.com>
Date:   Sat, 12 Oct 2019 03:59:15 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191012071620.8595-1-zhiyuan2048@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/12/19 12:16 AM, Zhiyuan Hou wrote:
> In act_mirred's ingress redirection, if the skb's dst_entry is valid
> when call function netif_receive_skb, the fllowing l3 stack process
> (ip_rcv_finish_core) will check dst_entry and skip the routing
> decision. Using the old dst_entry is unexpected and may discard the
> skb in some case. For example dst->dst_input points to dst_discard.
> 
> This patch drops the skb's dst_entry before calling netif_receive_skb
> so that the skb can be made routing decision like a normal ingress
> skb.
> 
> Signed-off-by: Zhiyuan Hou <zhiyuan2048@linux.alibaba.com>
> ---
>  net/sched/act_mirred.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
> index 9ce073a05414..6108a64c0cd5 100644
> --- a/net/sched/act_mirred.c
> +++ b/net/sched/act_mirred.c
> @@ -18,6 +18,7 @@
>  #include <linux/gfp.h>
>  #include <linux/if_arp.h>
>  #include <net/net_namespace.h>
> +#include <net/dst.h>
>  #include <net/netlink.h>
>  #include <net/pkt_sched.h>
>  #include <net/pkt_cls.h>
> @@ -298,8 +299,10 @@ static int tcf_mirred_act(struct sk_buff *skb, const struct tc_action *a,
>  
>  	if (!want_ingress)
>  		err = dev_queue_xmit(skb2);
> -	else
> +	else {
> +		skb_dst_drop(skb2);
>  		err = netif_receive_skb(skb2);
> +	}
>  
>  	if (err) {
>  out:
> 

Why is dst_discard used ?

This could actually drop packets, for loopback.

A Fixes: tag would tremendously help, I wonder if you are not working around
the other issue Wei was tracking yesterday ( https://www.spinics.net/lists/netdev/msg604397.html )

