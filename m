Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD743AD677
	for <lists+netdev@lfdr.de>; Sat, 19 Jun 2021 03:21:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234846AbhFSBVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 21:21:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234601AbhFSBVD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 21:21:03 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCA91C061574
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 18:18:52 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id m137so12648123oig.6
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 18:18:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=v5QG/YX1lFGJLrsLIVOF7lYE5hjqnCerdgJtwrVRi/w=;
        b=XMfnKLnhGZRyBSeAr8jPJ5izMQVW/cIWq1fQiNKKNf2p50c+redFXfpp97bnwwgtMK
         0CJ9Ix8zQLROTBy8k69LBSYuuY3zB1Wq34thxEOOHeImszBKP26uEZ0Pqys6iTNDHmAz
         yFIpo1PtHvEfTR284JI0Qs2lWOxNgc3RnF9Q8NZujavFuN1MfvxBaGGJL+wZfuGNqGRR
         hA7kJVHEtJoHYi7CPoZEKUfuYjMIcjusXHPe+G7duTMy35GpoGZpWatwU8y/PeKHk2V6
         1pJuCNwDVE9rLZPSEZNKArmtG/NWEDvEa6oIVxfXQC7Z77+KECW3TZYHwQXFqOQlwW+K
         55hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=v5QG/YX1lFGJLrsLIVOF7lYE5hjqnCerdgJtwrVRi/w=;
        b=gIPkHDG/Okn6UxUvmN+P0ixdjJubC2URvG48NUNOYmwswW6XAT+bxe24pqUwdddoRE
         yU3LkWzxq3t50JpcRL29A4gC2FDg2t+bICSyEigIBe5um8nPM9uMVNnRde2NgQu9KkUM
         eRUG77SfdiVDhLalGY31Y4v8Dmc2laKp0NJnN0YMFx2iSjAmBZqUTKgmWDJm/j9ZjrAl
         fQc90obEzmhUFaSw5gSZVeawA0r4XVsV3RS3BnX4QdNbt8WnI5oZZy9+s+5xHk1sCjNJ
         +I5nrFZoiwJtDyjQp7kjxFM+kkoilFuQrgo1VsN+8MMyRXs3Un6VCOIUT2e9PuR25JFX
         SBtQ==
X-Gm-Message-State: AOAM532vUwQfIvPCFQi1xURiOLDw6kWVkj+kesFMng8Hte5FUXzGvPzp
        677ejFbtAUiHXv/mLBU4LYE=
X-Google-Smtp-Source: ABdhPJxxLau2gNgkKItkiqjoEfq1SwL4VI4KVa21//ykEgbH2k2cMaYzEx9tvOX6xNx5jbev4CTqtQ==
X-Received: by 2002:a05:6808:34a:: with SMTP id j10mr15984014oie.149.1624065532305;
        Fri, 18 Jun 2021 18:18:52 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.38])
        by smtp.googlemail.com with ESMTPSA id 3sm2172754oob.1.2021.06.18.18.18.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Jun 2021 18:18:51 -0700 (PDT)
Subject: Re: [PATCH net] vrf: do not push non-ND strict packets with a source
 LLA through packet taps again
To:     Antoine Tenart <atenart@kernel.org>, davem@davemloft.net,
        kuba@kernel.org, dsahern@kernel.org
Cc:     netdev@vger.kernel.org, Stephen Suryaputra <ssuryaextr@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>
References: <20210618151553.59456-1-atenart@kernel.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <16920ba3-57b7-3431-4667-9aaf0d7380af@gmail.com>
Date:   Fri, 18 Jun 2021 19:18:50 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210618151553.59456-1-atenart@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/18/21 9:15 AM, Antoine Tenart wrote:
> Non-ND strict packets with a source LLA go through the packet taps
> again, while non-ND strict packets with other source addresses do not,
> and we can see a clone of those packets on the vrf interface (we should
> not). This is due to a series of changes:
> 
> Commit 6f12fa775530[1] made non-ND strict packets not being pushed again
> in the packet taps. This changed with commit 205704c618af[2] for those
> packets having a source LLA, as they need a lookup with the orig_iif.
> 
> The issue now is those packets do not skip the 'vrf_ip6_rcv' function to
> the end (as the ones without a source LLA) and go through the check to
> call packet taps again. This check was changed by commit 6f12fa775530[1]
> and do not exclude non-strict packets anymore. Packets matching
> 'need_strict && !is_ndisc && is_ll_src' are now being sent through the
> packet taps again. This can be seen by dumping packets on the vrf
> interface.
> 
> Fix this by having the same code path for all non-ND strict packets and
> selectively lookup with the orig_iif for those with a source LLA. This
> has the effect to revert to the pre-205704c618af[2] condition, which
> should also be easier to maintain.
> 
> [1] 6f12fa775530 ("vrf: mark skb for multicast or link-local as enslaved to VRF")
> [2] 205704c618af ("vrf: packets with lladdr src needs dst at input with orig_iif when needs strict")
> 
> Fixes: 205704c618af ("vrf: packets with lladdr src needs dst at input with orig_iif when needs strict")
> Cc: Stephen Suryaputra <ssuryaextr@gmail.com>
> Reported-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Antoine Tenart <atenart@kernel.org>
> ---
>  drivers/net/vrf.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
> index 28a6c4cfe9b8..414afcb0a23f 100644
> --- a/drivers/net/vrf.c
> +++ b/drivers/net/vrf.c
> @@ -1366,22 +1366,22 @@ static struct sk_buff *vrf_ip6_rcv(struct net_device *vrf_dev,
>  	int orig_iif = skb->skb_iif;
>  	bool need_strict = rt6_need_strict(&ipv6_hdr(skb)->daddr);
>  	bool is_ndisc = ipv6_ndisc_frame(skb);
> -	bool is_ll_src;
>  
>  	/* loopback, multicast & non-ND link-local traffic; do not push through
>  	 * packet taps again. Reset pkt_type for upper layers to process skb.
> -	 * for packets with lladdr src, however, skip so that the dst can be
> -	 * determine at input using original ifindex in the case that daddr
> -	 * needs strict
> +	 * For strict packets with a source LLA, determine the dst using the
> +	 * original ifindex.
>  	 */
> -	is_ll_src = ipv6_addr_type(&ipv6_hdr(skb)->saddr) & IPV6_ADDR_LINKLOCAL;
> -	if (skb->pkt_type == PACKET_LOOPBACK ||
> -	    (need_strict && !is_ndisc && !is_ll_src)) {
> +	if (skb->pkt_type == PACKET_LOOPBACK || (need_strict && !is_ndisc)) {
>  		skb->dev = vrf_dev;
>  		skb->skb_iif = vrf_dev->ifindex;
>  		IP6CB(skb)->flags |= IP6SKB_L3SLAVE;
> +
>  		if (skb->pkt_type == PACKET_LOOPBACK)
>  			skb->pkt_type = PACKET_HOST;
> +		else if (ipv6_addr_type(&ipv6_hdr(skb)->saddr) & IPV6_ADDR_LINKLOCAL)
> +			vrf_ip6_input_dst(skb, vrf_dev, orig_iif);
> +
>  		goto out;
>  	}
>  
> 

you are basically moving Stephen's is_ll_src within the need_strict and
not ND.

Did you run the fcnal-test script and verify no change in test results?
