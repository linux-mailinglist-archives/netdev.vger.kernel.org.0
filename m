Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE7216830D5
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 16:06:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232064AbjAaPG3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 10:06:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232923AbjAaPGE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 10:06:04 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A556B755
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 07:03:13 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id bk15so42383092ejb.9
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 07:03:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4z+jbbMNz2xFo84H/gCN37CtMlp0ECFlQrJh3n2StwM=;
        b=WvCZt3DToF7n7EnipQup8p63T9mWZsRN3kflvkpt9is1ug4rI7TrBphuJgu0z2qug6
         5sZ4C+JRCLQEEq31J/FGfmhu/o11RWrGHkbkBtj/llIShrxwbDVerEvgaeefT5XEQlqE
         JFmlRHAb/5j0poWYNpZ3H+LGnSqdc+jQt5zDLBnsgnRoCyBbZwrS16HnDdR8toyQbFzA
         uXTkilAXZfeRXbHiH7p60bCBFHaEExarUoD7FsjBmLhBdpE6vWrvahYivubfPm7yXDcL
         wY+pTy7RsX9VBEhVW1qKY+RVMMGHn3ZSGTwpMA9aYpUMxUxHu+KgbZ2EyEOHLMJhWJYJ
         aUUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4z+jbbMNz2xFo84H/gCN37CtMlp0ECFlQrJh3n2StwM=;
        b=PUXa3ilaJSTKFTKVT84KNhkbF2rVN5roQWOA44C2sjtgxx+Fdzs6GBlYs3BhLnaQ1j
         zeAh/T4Iws/SD5MEXHCBUwcLR3YFgUrg96gWRDki69rcn8QGg+KXj0pbCBgrduuai8Hm
         PYGgXgPciXgf2ycNemg2IfMlLT6YDZ9tmLDL4Lkhk9SmMiDAua3IpRFXIFZX/tbvzZvi
         /6EwwPQnmxV3QsXSK/AYVAJo2SoQuXfi8Tb6EIyOktfeLtgB9r14rPIX7irzH4JVZjBm
         JlAT0P9yvTuJj8uM0OIGqSb75fEWttvXfyK62+mBG/VWczOmS4EU1eYXzu8sXK0w2xFu
         COwQ==
X-Gm-Message-State: AO0yUKWm0jMe7a//2RBY0abB4wrke4/slI9uavTmiMfzOl0aNgZODqRO
        YxQ8AqoV4zCEkW8FEO3BH9YwcQ==
X-Google-Smtp-Source: AK7set/CL67K+fcEclKdTtnK2dyfBN21e/6fvZHXTkGLZOg1TZkZwgs8VUCQ4K2tAQ3bB7rOwhCr0Q==
X-Received: by 2002:a17:907:970b:b0:880:c284:8436 with SMTP id jg11-20020a170907970b00b00880c2848436mr18107539ejc.57.1675177297941;
        Tue, 31 Jan 2023 07:01:37 -0800 (PST)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id y11-20020a50eb0b000000b00467481df198sm8414307edp.48.2023.01.31.07.01.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Jan 2023 07:01:37 -0800 (PST)
Message-ID: <8bb06e1b-6ec2-4e7c-5ce1-49814704ddb4@blackwall.org>
Date:   Tue, 31 Jan 2023 17:01:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCHv4 net-next 02/10] bridge: use skb_ip_totlen in br
 netfilter
Content-Language: en-US
To:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Aaron Conole <aconole@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Mahesh Bandewar <maheshb@google.com>,
        Paul Moore <paul@paul-moore.com>,
        Guillaume Nault <gnault@redhat.com>
References: <cover.1674921359.git.lucien.xin@gmail.com>
 <4542573738ca3499bd15b2e9980c0176db442dc7.1674921359.git.lucien.xin@gmail.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <4542573738ca3499bd15b2e9980c0176db442dc7.1674921359.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/01/2023 17:58, Xin Long wrote:
> These 3 places in bridge netfilter are called on RX path after GRO
> and IPv4 TCP GSO packets may come through, so replace iph tot_len
> accessing with skb_ip_totlen() in there.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  net/bridge/br_netfilter_hooks.c            | 2 +-
>  net/bridge/netfilter/nf_conntrack_bridge.c | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
> index f20f4373ff40..b67c9c98effa 100644
> --- a/net/bridge/br_netfilter_hooks.c
> +++ b/net/bridge/br_netfilter_hooks.c
> @@ -214,7 +214,7 @@ static int br_validate_ipv4(struct net *net, struct sk_buff *skb)
>  	if (unlikely(ip_fast_csum((u8 *)iph, iph->ihl)))
>  		goto csum_error;
>  
> -	len = ntohs(iph->tot_len);
> +	len = skb_ip_totlen(skb);
>  	if (skb->len < len) {
>  		__IP_INC_STATS(net, IPSTATS_MIB_INTRUNCATEDPKTS);
>  		goto drop;
> diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfilter/nf_conntrack_bridge.c
> index 5c5dd437f1c2..71056ee84773 100644
> --- a/net/bridge/netfilter/nf_conntrack_bridge.c
> +++ b/net/bridge/netfilter/nf_conntrack_bridge.c
> @@ -212,7 +212,7 @@ static int nf_ct_br_ip_check(const struct sk_buff *skb)
>  	    iph->version != 4)
>  		return -1;
>  
> -	len = ntohs(iph->tot_len);
> +	len = skb_ip_totlen(skb);
>  	if (skb->len < nhoff + len ||
>  	    len < (iph->ihl * 4))
>                  return -1;
> @@ -256,7 +256,7 @@ static unsigned int nf_ct_bridge_pre(void *priv, struct sk_buff *skb,
>  		if (!pskb_may_pull(skb, sizeof(struct iphdr)))
>  			return NF_ACCEPT;
>  
> -		len = ntohs(ip_hdr(skb)->tot_len);
> +		len = skb_ip_totlen(skb);
>  		if (pskb_trim_rcsum(skb, len))
>  			return NF_ACCEPT;
>  

Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>


