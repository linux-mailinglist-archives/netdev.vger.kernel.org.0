Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB5FE49C13C
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 03:25:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236291AbiAZCZN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 21:25:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236268AbiAZCZM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 21:25:12 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50DF1C06161C;
        Tue, 25 Jan 2022 18:25:12 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id h7so8093621iof.3;
        Tue, 25 Jan 2022 18:25:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ETAmtGjVjXzQlXzPSOU5L8ahySqQBrjE9OJtM2gVQSg=;
        b=faFyR8OaOnIiyD+3xPNd4uJV2yqG7xlUnr5oC4qtJyX0DBq1G0OSA0kaQHMexbRqUk
         +ri2oaQN6AdgfJX9Qh6bLlDBvDE6TXkWkA8cgSspSKeT60JpJt+2Vgt+qDIb86yRBa3x
         ZvOhf1JrnItYR0xxZRsfSetENB1EWBJNgTuCmb499aBUdfl5qAPL5M9tfFZbQPWNEauF
         FEKfJ8BZ2smtUcVGxyH9QkgRdeYwjk/VHMaMRpzUZ2P9PlhGeslAuZG7Hh4mLAAq25sk
         TsJlHcIhKBLJNpE/6mgjTHhcNzFSpFYNekF8jc3y6/oTSLNmWsuMr2CVeB9xKoDtUZp5
         Y3DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ETAmtGjVjXzQlXzPSOU5L8ahySqQBrjE9OJtM2gVQSg=;
        b=TxRiD/9uTHM0kY4CCVYSG6K5dk8JqmXmU/zmaRLOVDqa8Y03El3foBDmGs1EUp5baT
         u+oEgCYMPyQANi3NOXraG6GAvnViyrhrNM9KeyKKLB4EaxjQBlWQsevwbqeZ5GDkjpF7
         EUpq6aazQIqc0fqgdD0kitbz6zsRjcjdh/yPUK3vrokRQxMlEAQOhCBBTyd5xt9sJuKK
         +l2Ip2eC/UIyIZ4zfPlI57ofbnjuDHvtmop11Z//9OxERvwvRmgQlJSqBi8VpY+2Q9Nd
         /EzuixbPtwPLuhzXSDyQTDeOpCNsiL/2R6iPZhlyoN6AxakgO+h4kyKTaspftApFphVC
         ODag==
X-Gm-Message-State: AOAM532OrKp62LjzdwHmb/ptLdof5aj42rp4BLZ6ndGHc0tEIHFTZEqX
        d0qGizxaszYKMra8Dlcsd3u5U7x+a4o=
X-Google-Smtp-Source: ABdhPJzPTVS1a18KE/Z+h/k2o3c8tOE24BXB2iNw1y+fksldIVVPVpzCoRsXHJmWWi9PbD6ZND5mmg==
X-Received: by 2002:a5d:97c3:: with SMTP id k3mr12465595ios.191.1643163911636;
        Tue, 25 Jan 2022 18:25:11 -0800 (PST)
Received: from ?IPV6:2601:282:800:dc80:1502:2fac:6dee:881? ([2601:282:800:dc80:1502:2fac:6dee:881])
        by smtp.googlemail.com with ESMTPSA id l12sm9626174ios.32.2022.01.25.18.25.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jan 2022 18:25:11 -0800 (PST)
Message-ID: <308b88bf-7874-4b04-47f7-51203fef4128@gmail.com>
Date:   Tue, 25 Jan 2022 19:25:10 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Subject: Re: [PATCH net-next 5/6] net: udp: use kfree_skb_reason() in
 udp_queue_rcv_one_skb()
Content-Language: en-US
To:     menglong8.dong@gmail.com, kuba@kernel.org
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, pablo@netfilter.org,
        kadlec@netfilter.org, fw@strlen.de, imagedong@tencent.com,
        edumazet@google.com, alobakin@pm.me, paulb@nvidia.com,
        pabeni@redhat.com, talalahmad@google.com, haokexin@gmail.com,
        keescook@chromium.org, memxor@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        cong.wang@bytedance.com
References: <20220124131538.1453657-1-imagedong@tencent.com>
 <20220124131538.1453657-6-imagedong@tencent.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220124131538.1453657-6-imagedong@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/24/22 6:15 AM, menglong8.dong@gmail.com wrote:
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 603f77ef2170..dd64a4f2ff1d 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -330,6 +330,7 @@ enum skb_drop_reason {
>  	SKB_DROP_REASON_UNICAST_IN_L2_MULTICAST,
>  	SKB_DROP_REASON_XFRM_POLICY,
>  	SKB_DROP_REASON_IP_NOPROTO,
> +	SKB_DROP_REASON_UDP_FILTER,

Is there really a need for a UDP and TCP version? why not just:

	/* dropped due to bpf filter on socket */
	SKB_DROP_REASON_SOCKET_FILTER

>  	SKB_DROP_REASON_MAX,
>  };
>  

