Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9461F49E793
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 17:33:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243771AbiA0QdP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 11:33:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231582AbiA0QdO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 11:33:14 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21F74C061714;
        Thu, 27 Jan 2022 08:33:14 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id d188so4224765iof.7;
        Thu, 27 Jan 2022 08:33:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=q84yGr7Gaka4IHHlv2hPek2r+CXOmfQHdCA6PWLxQs8=;
        b=O57+dYy3yY/AB1l1QVfQriCMPs4BzFmBwImxM+E8uzaCYk4y0KYDph1PVUqvpLZ737
         h8Dbb9ej6NCSJCGkgInGwGsVRvXB3z/BWbAvb2/Hf7BKllTSUUglzAqX7+cvVlNez6qy
         TJR2o4ltKxG4jxrG0ssaBMTRqXq3rbwQ64U/inv6Ffbl2NyYNeXFs0CIIMfLCvjm9vtf
         JS9RZ+enl/k4rB2D1O5fQpyTLxN26uKBGvj8XqQUMvD2FW/PT+WtzGUDMDSEDV52RoEE
         RFxs8zi6vV4zm9y4ZYoiaQPDje+GrD/elrZBvM/+Nk5tJXeTKXMqfsfkhME0/8HKHF6I
         80+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=q84yGr7Gaka4IHHlv2hPek2r+CXOmfQHdCA6PWLxQs8=;
        b=YnZ73Hsg0ioNfR9LR6fBw+55L5d+wNlYT+QYUS0/9M82DduBZV7FdLKdumnvKVQF5j
         x4LbXj4Ei0I4YKzbPyxYWUnTcODN5TtnPX2guAYQXMoce5Az+SrT75Y5uJmBPpOgEWwB
         TomPQ7wYcrHmYEkCGBjJTIVK12zRgzks5h5V1skAJKXLy7VXXT73PrO07ezEF4NJblZV
         SelqSKaXtnL9fJI1QS8CsqZMDI/aVm2U/BUzfv9sT7/8moOZaP0/J3ghYHeWXfNAQktI
         8tZ25hihKVU0lVwe3oqV+6d8JBPEsguxsasPWqTSKdYJeeDAf9BExpU5STMiAmfgBpyn
         qpBw==
X-Gm-Message-State: AOAM530X+QOPzl2rIG9j5NqWofHoj/ko1Ee6rXJ6vuqyh1msEoMk153B
        qgKC9Vsk1MuvWFZLGWyqIvc=
X-Google-Smtp-Source: ABdhPJzi30CPf4vqvDRH0Lxf7eLGhIkIGUWpq2AxcSZ7LLcP430uxCOBg6n6N+RsmaQXR6XPFAgKxg==
X-Received: by 2002:a02:9985:: with SMTP id a5mr2248535jal.204.1643301193262;
        Thu, 27 Jan 2022 08:33:13 -0800 (PST)
Received: from ?IPV6:2601:282:800:dc80:182c:2e54:e650:90f5? ([2601:282:800:dc80:182c:2e54:e650:90f5])
        by smtp.googlemail.com with ESMTPSA id o4sm7693558iou.42.2022.01.27.08.33.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Jan 2022 08:33:13 -0800 (PST)
Message-ID: <04cbb826-5563-61c0-617a-415850218a63@gmail.com>
Date:   Thu, 27 Jan 2022 09:33:10 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH v2 net-next 4/8] net: ipv4: use kfree_skb_reason() in
 ip_rcv_core()
Content-Language: en-US
To:     menglong8.dong@gmail.com, dsahern@kernel.org, kuba@kernel.org
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, edumazet@google.com, pablo@netfilter.org,
        kadlec@netfilter.org, fw@strlen.de, imagedong@tencent.com,
        alobakin@pm.me, pabeni@redhat.com, cong.wang@bytedance.com,
        talalahmad@google.com, haokexin@gmail.com, keescook@chromium.org,
        memxor@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, mengensun@tencent.com
References: <20220127091308.91401-1-imagedong@tencent.com>
 <20220127091308.91401-5-imagedong@tencent.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220127091308.91401-5-imagedong@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/27/22 2:13 AM, menglong8.dong@gmail.com wrote:
> diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
> index 3a025c011971..7f64c5432cba 100644
> --- a/net/ipv4/ip_input.c
> +++ b/net/ipv4/ip_input.c
> @@ -436,13 +436,18 @@ static int ip_rcv_finish(struct net *net, struct sock *sk, struct sk_buff *skb)
>  static struct sk_buff *ip_rcv_core(struct sk_buff *skb, struct net *net)
>  {
>  	const struct iphdr *iph;
> +	int drop_reason;
>  	u32 len;
>  
> +	drop_reason = SKB_DROP_REASON_NOT_SPECIFIED;
> +
>  	/* When the interface is in promisc. mode, drop all the crap
>  	 * that it receives, do not try to analyse it.
>  	 */
> -	if (skb->pkt_type == PACKET_OTHERHOST)
> +	if (skb->pkt_type == PACKET_OTHERHOST) {
> +		drop_reason = SKB_DROP_REASON_OTHERHOST;
>  		goto drop;
> +	}
>  
>  	__IP_UPD_PO_STATS(net, IPSTATS_MIB_IN, skb->len);
>  
> @@ -516,11 +521,13 @@ static struct sk_buff *ip_rcv_core(struct sk_buff *skb, struct net *net)

There's another path:
        len = ntohs(iph->tot_len);
        if (skb->len < len) {
                __IP_INC_STATS(net, IPSTATS_MIB_INTRUNCATEDPKTS);
                goto drop;
        } else if (len < (iph->ihl*4))
...

where reason = SKB_DROP_REASON_PKT_TOO_SMALL

rest looks ok to me.


>  	return skb;
>  
>  csum_error:
> +	drop_reason = SKB_DROP_REASON_IP_CSUM;
>  	__IP_INC_STATS(net, IPSTATS_MIB_CSUMERRORS);
>  inhdr_error:
> +	drop_reason = drop_reason ?: SKB_DROP_REASON_IP_INHDR;
>  	__IP_INC_STATS(net, IPSTATS_MIB_INHDRERRORS);
>  drop:
> -	kfree_skb(skb);
> +	kfree_skb_reason(skb, drop_reason);
>  out:
>  	return NULL;
>  }

