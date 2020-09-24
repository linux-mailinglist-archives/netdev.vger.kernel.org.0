Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C15F277B84
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 00:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbgIXWME (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 18:12:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726205AbgIXWMD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 18:12:03 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B258C0613CE;
        Thu, 24 Sep 2020 15:12:03 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id s66so454429otb.2;
        Thu, 24 Sep 2020 15:12:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=o5cO6tbzjzTN48Ge74/ijT3b4ZdZsLxt0NyWmKNGPIg=;
        b=J+/PBBVyu+YBMOlpeIJ5Mu2t+IeKKBEq78c6OWQFjzsGWQ6HwAR0Lys0oI/a3V0Vhc
         WS/LZ/3JEFvYnYsvMoqYWiFRtO85bi+gmMR4jc4zlx1IWBjLCRDoiuJMf3Sd10rzdC8m
         kI5ZMlFUWIVbn33jwmVDj6tEOY8Led6o1UgLweMU5LjG9R3ifJ+ccPLZBJQuovDtA9WF
         JzTCwyAI4vYU61sGmn/fn9l+PYAxIv63bioS3b0rexxDHl18fJcqJJTfbpC7vVk+mjgE
         1f7my9vSnefKTplyNBg40G7obTrNgNfulEJbW59mvSXqPF8WPnwnGUGUSwM9BEWTz04i
         BRqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=o5cO6tbzjzTN48Ge74/ijT3b4ZdZsLxt0NyWmKNGPIg=;
        b=YjrZnBst2WEKCf1LCSfH3Qo54y9QN3gU0PchteJXq6+OaPKv0CZrRoQ82rL0XHibd/
         EYXTyNcDSJK+CSLQV/RJrP+5RTZi+yGsiI3tTK+YQarhSg69hndFPMkHgHfa+u0CD8j3
         e1IlkYUm8wD9TLuZvmcTSa/988imv3qIjTlEgbGvCqm1R2tsocpQosUxaWEqXTc8yhud
         5Z7HUY8vOwW8N/xLGZIKmmv2ZYSeCsxSy99Y3Q+hEppU+jYGLeCQ8fNW7AqdTaAe3aPJ
         tH2JLFYwyyHKir1HwQqJRflYbdcueIu6mHsSzua2l5gkYZj1BRzPxr8T2gdqK0qLVX32
         XPOw==
X-Gm-Message-State: AOAM530wJvekygltdH8CrETpX+OjB1+XXzLpkMjf3CJOCe2Xd83g1Ws/
        Wde5HHIVlCdcL/0qQNt98AzePVg2PuOR6A==
X-Google-Smtp-Source: ABdhPJxVpWUfNHO2KfStJKiq5O1fGn2RUdONBQKFBeqra67vtglY5H69w9EzjvhCZijZo1CPks20jg==
X-Received: by 2002:a9d:5d2:: with SMTP id 76mr808973otd.99.1600985522785;
        Thu, 24 Sep 2020 15:12:02 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:f921:c3fe:6d94:b608])
        by smtp.googlemail.com with ESMTPSA id c19sm194948ooq.35.2020.09.24.15.12.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Sep 2020 15:12:02 -0700 (PDT)
Subject: Re: [PATCH bpf-next 3/6] bpf: add redirect_neigh helper as redirect
 drop-in
To:     Daniel Borkmann <daniel@iogearbox.net>, ast@kernel.org
Cc:     john.fastabend@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <cover.1600967205.git.daniel@iogearbox.net>
 <721fd3f8d5cf55169561e59fdec5fad2e0bf6115.1600967205.git.daniel@iogearbox.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <09aedc04-ee19-e72d-9a8d-aa4be7551a53@gmail.com>
Date:   Thu, 24 Sep 2020 16:12:01 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <721fd3f8d5cf55169561e59fdec5fad2e0bf6115.1600967205.git.daniel@iogearbox.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/24/20 12:21 PM, Daniel Borkmann wrote:
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 0f913755bcba..19caa2fc21e8 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -2160,6 +2160,205 @@ static int __bpf_redirect(struct sk_buff *skb, struct net_device *dev,
>  		return __bpf_redirect_no_mac(skb, dev, flags);
>  }
>  
> +#if IS_ENABLED(CONFIG_IPV6)
> +static int bpf_out_neigh_v6(struct net *net, struct sk_buff *skb)
> +{
> +	struct dst_entry *dst = skb_dst(skb);
> +	struct net_device *dev = dst->dev;
> +	const struct in6_addr *nexthop;
> +	struct neighbour *neigh;
> +
> +	if (dev_xmit_recursion())
> +		goto out_rec;
> +	skb->dev = dev;
> +	rcu_read_lock_bh();
> +	nexthop = rt6_nexthop((struct rt6_info *)dst, &ipv6_hdr(skb)->daddr);
> +	neigh = __ipv6_neigh_lookup_noref_stub(dev, nexthop);
> +	if (unlikely(!neigh))
> +		neigh = __neigh_create(ipv6_stub->nd_tbl, nexthop, dev, false);

the last 3 lines can be replaced with ip_neigh_gw6.

> +	if (likely(!IS_ERR(neigh))) {
> +		int ret;
> +
> +		sock_confirm_neigh(skb, neigh);
> +		dev_xmit_recursion_inc();
> +		ret = neigh_output(neigh, skb, false);
> +		dev_xmit_recursion_dec();
> +		rcu_read_unlock_bh();
> +		return ret;
> +	}
> +	rcu_read_unlock_bh();
> +	IP6_INC_STATS(dev_net(dst->dev),
> +		      ip6_dst_idev(dst), IPSTATS_MIB_OUTNOROUTES);
> +out_drop:
> +	kfree_skb(skb);
> +	return -EINVAL;
> +out_rec:
> +	net_crit_ratelimited("bpf: recursion limit reached on datapath, buggy bpf program?\n");
> +	goto out_drop;
> +}
> +

...

> +
> +#if IS_ENABLED(CONFIG_INET)
> +static int bpf_out_neigh_v4(struct net *net, struct sk_buff *skb)
> +{
> +	struct dst_entry *dst = skb_dst(skb);
> +	struct rtable *rt = (struct rtable *)dst;

please use container_of here; I'd like to see the typecasts get removed.

> +	struct net_device *dev = dst->dev;
> +	u32 hh_len = LL_RESERVED_SPACE(dev);
> +	struct neighbour *neigh;
> +	bool is_v6gw = false;
> +
> +	if (dev_xmit_recursion())
> +		goto out_rec;
