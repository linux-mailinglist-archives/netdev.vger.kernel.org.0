Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55E234A4DB8
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 19:06:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238335AbiAaSGB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 13:06:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232320AbiAaSGA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 13:06:00 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A78DCC061714;
        Mon, 31 Jan 2022 10:06:00 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id s18so17958810ioa.12;
        Mon, 31 Jan 2022 10:06:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=endXrB2uhXskcRLRruqh/Q73nVn4E/GfzSTpU/fBQ4A=;
        b=RelxbTsg6tKVtEgR5KL+97rLVbd/KJqLQsyRaMl/IO99XnhWIfqkZiiNwLWSGQjYxS
         Q+RbvolYRdPOhkHI+cPRuqh/Yd+Go+tFlM8NMBbFlVG9STkx/Tdl0IOUb1EIJElpEp1e
         gEdYpfmjdZJaJaM6MRA4Ck1GrP0PC6xvP+RiXKTZ/W4f6W7DncnvxeyZc8X0EL2OVJ9R
         ChK24/1HoLzujenOYRzRmW4iAa8BoEks4AbIJkYNhPy3P+/d/OZq4jVzdLplK4fPz8Y4
         DC04DHuOsarSaHjjtkGRkFis+1ohDQdbuJ2FR7rF4itg3C2o3VpVeieGiUaXNU+Z5Zxb
         YYJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=endXrB2uhXskcRLRruqh/Q73nVn4E/GfzSTpU/fBQ4A=;
        b=raJFj1cvVk2ledBhfO9upVSY4Ntl+mQuvwWdNzoyR4DXIACi76sG04FmZg7tFvNeBV
         FRfEi98YjXId56Rzbpyewvtf5BGuNz/xelduGxVSLvnd5Avcg8PFtDuQZ0MuEXLrc6To
         O0SNZYAR6jb3L0Zrt7EkM5EpxF5rGPAYk03d+ljby0O/7rupBGlMzMYG56JvM9Uan+SR
         I0DZQQfVjWP1RwNHXQGR6oHAete+tBIWSaYIvLi46SWUQHofT2H6QPKjavgocfFyz81c
         ZmsPjuyyX2ohHv3u7IwI4HQXnk8+Ipl9cC4YENKv/uNBkVad/ZekbUzmQPz+UC+9kJx4
         cAbQ==
X-Gm-Message-State: AOAM531wJDJxK2tWAv85x4E8gFnlBemA/ro86J0PATWluO4lgwHBLKIi
        dWuiWsDFfaJgwH1Lo9CuotI=
X-Google-Smtp-Source: ABdhPJz/pQFt73Z6yqgCIFUZpcvo/ZM19fBDHEJph1/12gQKJclHsZJ48Ao2TvDlGS2RSrymHxCL6A==
X-Received: by 2002:a05:6638:18a:: with SMTP id a10mr7547247jaq.130.1643652360073;
        Mon, 31 Jan 2022 10:06:00 -0800 (PST)
Received: from ?IPV6:2601:282:800:dc80:8870:ce19:2c7:3513? ([2601:282:800:dc80:8870:ce19:2c7:3513])
        by smtp.googlemail.com with ESMTPSA id r9sm10520744ill.52.2022.01.31.10.05.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Jan 2022 10:05:59 -0800 (PST)
Message-ID: <16e8de51-6b56-3dfe-e9c4-524ab40cdea9@gmail.com>
Date:   Mon, 31 Jan 2022 11:05:58 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH v3 net-next 3/7] net: ipv4: use kfree_skb_reason() in
 ip_rcv_core()
Content-Language: en-US
To:     menglong8.dong@gmail.com, dsahern@kernel.org, kuba@kernel.org
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, pablo@netfilter.org, kadlec@netfilter.org,
        fw@strlen.de, imagedong@tencent.com, edumazet@google.com,
        alobakin@pm.me, paulb@nvidia.com, keescook@chromium.org,
        talalahmad@google.com, haokexin@gmail.com, memxor@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        cong.wang@bytedance.com, mengensun@tencent.com
References: <20220128073319.1017084-1-imagedong@tencent.com>
 <20220128073319.1017084-4-imagedong@tencent.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220128073319.1017084-4-imagedong@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/28/22 12:33 AM, menglong8.dong@gmail.com wrote:
\> diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
> index 3a025c011971..627fad437593 100644
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

move this line down, right before:

	if (!pskb_may_pull(skb, sizeof(struct iphdr)))
		goto inhdr_error;

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
> @@ -488,6 +493,7 @@ static struct sk_buff *ip_rcv_core(struct sk_buff *skb, struct net *net)
>  
>  	len = ntohs(iph->tot_len);
>  	if (skb->len < len) {
> +		drop_reason = SKB_DROP_REASON_PKT_TOO_SMALL;
>  		__IP_INC_STATS(net, IPSTATS_MIB_INTRUNCATEDPKTS);
>  		goto drop;
>  	} else if (len < (iph->ihl*4))
> @@ -516,11 +522,13 @@ static struct sk_buff *ip_rcv_core(struct sk_buff *skb, struct net *net)
>  	return skb;
>  
>  csum_error:
> +	drop_reason = SKB_DROP_REASON_IP_CSUM;
>  	__IP_INC_STATS(net, IPSTATS_MIB_CSUMERRORS);
>  inhdr_error:
> +	drop_reason = drop_reason ?: SKB_DROP_REASON_IP_INHDR;

That makes assumptions about the value of SKB_DROP_REASON_NOT_SPECIFIED.
Make that line:
	if (drop_reason != SKB_DROP_REASON_NOT_SPECIFIED)
		drop_reason = SKB_DROP_REASON_IP_INHDR;

>  	__IP_INC_STATS(net, IPSTATS_MIB_INHDRERRORS);
>  drop:
> -	kfree_skb(skb);
> +	kfree_skb_reason(skb, drop_reason);
>  out:
>  	return NULL;
>  }

