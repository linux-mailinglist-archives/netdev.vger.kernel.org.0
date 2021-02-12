Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD14D31A33B
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 18:06:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbhBLREf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 12:04:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229465AbhBLREa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 12:04:30 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F296EC061574
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 09:03:47 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id v1so5416085wrd.6
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 09:03:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TwkzEQPCcBC6+hXAt+spdM1iv+J1am0Esik4crIE79M=;
        b=ARnzVUb5rB4fqzGv8hqFRA8f3HZcA3KEj1uPwqbszIwpoZpy/B7MTL+FJ54oqekUR/
         NuCOU0QwxlSH8tjYPatlHHAhPbLV2ip4rRc/RrTiH4dWXRzjXm7GgDxzQhsvqCU0hbBB
         r3YgyrAEt/+Axz8yoLIbQyNMUS+7GVUUoqxfiXxoin7uveC5WQupekXYXdNT1AXxxBLK
         JWHwaMJFLo+l/O3+m7rJ95yrWpWvJO3vJVv1caWygb79qfptdUTWyxLytkpdNfQMiprg
         TPB1N2bWR1cMcbuRs2/QUhCGbJGNO1K16nKlp+zQv3TF4TDwx+f+n4yierPwJHVYbHFE
         Jitw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TwkzEQPCcBC6+hXAt+spdM1iv+J1am0Esik4crIE79M=;
        b=QP4ERD/lLjo7ubF0jqhZLWHNS37emDgs95KqPKglK7WrKLctbh4OI9aox0wmeLgdA8
         /e1s7GcdqjHmdFGp8HZUzXUEsFtpI+8YJ3EjdFTZSdQtED9m+X0fwp7DMeFJ98ItWILb
         KBezP0Oi8shKUZ6xRzToDAk9jpc68HFxu3Vic0TqHBqWJbfptB4+sJgMERgPciLWNhr0
         pZHLkDMTcwz34lgHqOZVJconT9WMSCaWfD0feQWy7JDHl4mKoh3XCdhDv27K+GYxpySy
         3UJ4H/J5UNHDAsvGgDSD7JA3HRdXU1pRepWpMABNVRSDka9RAm95WYvUNNEcJVLKXUii
         Xf5Q==
X-Gm-Message-State: AOAM531BZw9j5eduXrf1Ij7kZS/wISH/jN02roEsiRsnDJc50pJgDjf+
        Itj3/CrmMFI3EMzO6SLmr5Y=
X-Google-Smtp-Source: ABdhPJymeGaf1GtpOSYifPcXdRHrcmeC3P4/NTyWqW5nEDUarTffOa8kgaRa90fuQOaftHKufnFUZg==
X-Received: by 2002:a5d:620d:: with SMTP id y13mr4638080wru.88.1613149426741;
        Fri, 12 Feb 2021 09:03:46 -0800 (PST)
Received: from [192.168.1.101] ([37.171.154.76])
        by smtp.gmail.com with ESMTPSA id k11sm10954459wrl.84.2021.02.12.09.03.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Feb 2021 09:03:46 -0800 (PST)
Subject: Re: [PATCH net-next V1] net: followup adjust net_device layout for
 cacheline usage
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>
References: <161313782625.1008639.6000589679659428869.stgit@firesoul>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <bbae767f-ebb5-51a2-7123-5f2251cdbb2c@gmail.com>
Date:   Fri, 12 Feb 2021 18:03:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <161313782625.1008639.6000589679659428869.stgit@firesoul>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/12/21 2:50 PM, Jesper Dangaard Brouer wrote:
> As Eric pointed out in response to commit 28af22c6c8df ("net: adjust
> net_device layout for cacheline usage") the netdev_features_t members
> wanted_features and hw_features are only used in control path.
> 
> Thus, this patch reorder the netdev_features_t to let more members that
> are used in fast path into the 3rd cacheline. Whether these members are
> read depend on SKB properties, which are hinted as comments. The member
> mpls_features could not fit in the cacheline, but it was the least
> commonly used (depend on CONFIG_NET_MPLS_GSO).
> 
> In the future we should consider relocating member gso_partial_features
> to be closer to member gso_max_segs. (see usage in gso_features_check()).
> 
> Suggested-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>  include/linux/netdevice.h |   11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index bfadf3b82f9c..3898bb167579 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -1890,13 +1890,16 @@ struct net_device {
>  	unsigned short		needed_headroom;
>  	unsigned short		needed_tailroom;
>  
> +	/* Fast path features - via netif_skb_features */
>  	netdev_features_t	features;
> +	netdev_features_t	vlan_features;       /* if skb_vlan_tagged */
> +	netdev_features_t	hw_enc_features;     /* if skb->encapsulation */
> +	netdev_features_t	gso_partial_features;/* if skb_is_gso */
> +	netdev_features_t	mpls_features; /* if eth_p_mpls+NET_MPLS_GSO */
> +
> +	/* Control path features */
>  	netdev_features_t	hw_features;
>  	netdev_features_t	wanted_features;
> -	netdev_features_t	vlan_features;
> -	netdev_features_t	hw_enc_features;
> -	netdev_features_t	mpls_features;
> -	netdev_features_t	gso_partial_features;
>  
>  	unsigned int		min_mtu;
>  	unsigned int		max_mtu;
> 
> 


Please also note we currently have at least 3 distinct blocks for tx path.

Presumably netdev_features_t are only used in TX, so should be grouped with the other TX
sections.


        /* --- cacheline 3 boundary (192 bytes) --- */       
...
        netdev_features_t          features;             /*  0xe0   0x8 */  

... Lots of ctrl stuff....


        /* --- cacheline 14 boundary (896 bytes) --- */
         struct netdev_queue *      _tx __attribute__((__aligned__(64))); /* 0x380   0x8 */          


....

/* Mix of unrelated control stuff like rtnl_link_ops

 /* --- cacheline 31 boundary (1984 bytes) --- */ 
 unsigned int               gso_max_size;         /* 0x7c0   0x4 */
 u16                        gso_max_segs;         /* 0x7c4   0x2 */ 



Ideally we should move _all_ control/slow_path stuff at the very end of the structure,
in order to not pollute the cache lines we need for data path, to keep them as small
and packed as possible.

This could be done one field at a time, to ease code review.

We should have something like this 

/* section used in RX (fast) path */
/* section used in both RX/TX (fast) path */
/* section used in TX (fast) path */
/* section used for slow path, and control path */

