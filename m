Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91C2F2349FB
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 19:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733256AbgGaRPZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 13:15:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732710AbgGaRPY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 13:15:24 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78280C061574;
        Fri, 31 Jul 2020 10:15:24 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id l13so8081220qvt.10;
        Fri, 31 Jul 2020 10:15:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=f/WAbEOG/tptLifB9LgbWD1+/CHIVuvFFHIVIWW5SbY=;
        b=kpw9UYVl+IwL1va1X+QsxMLUZdovpBIuRhu0so4e6ZXtvUMYHDmISR0yC6PQmchjr4
         2Qe+el83U3tB8LkaWW+NhNDv+h9nRVCVVHH9eqG7eDcg8fErviCcMTYmKiFJ9ap42OXx
         GSmfDUyD0vyvV2POZnyJtUEa1kbwlQtYrFpRBll0K7vHj9k4e6pX0wsi0iQ3VgDp/kLp
         /9WhId3hAugDy9T5YQqOxMA5Fw0hEuPvCmGN0hO7G1wYpUUpsnCEYcdqWK69u0rqURhK
         DiuGofmhD/Mbpy8Ikm36/kdZ8GMIkzXbbbmQvLNu8oB4A+BcWeR3BtS5BzdP8w9ZmkVA
         /peA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=f/WAbEOG/tptLifB9LgbWD1+/CHIVuvFFHIVIWW5SbY=;
        b=MO9Lnmg9h3jV55GezZ8XFU5ehSAWTRytRoSzuZVxDMEdsPNSMO3+6FQumeF2XILOHt
         UAEfZcAGZxbAZ3FEpi3MrNPvJBtgE2Mp4Vz6mgzmkRQmLnhD+N24AMa++50XDb7a0k9b
         z9ZlT6OaJXp/zLVyahi3HdJMAm1SvSG1eNddSEb167ZrYFq2ef22sjQl6QDdZNVBog2f
         9Zs2aSCicMS0prUOWDSmrCfNKjNr7s1jsi3nKseZrh9BDXL+kZuPOsb1K/EKSE5EPOfs
         dRWqamCDhNaGIluvbaUxnXUMohB4lLeThWU/05hZaMX5Dz4t9vFO0jahJQPALYCZBax4
         YmEg==
X-Gm-Message-State: AOAM533nOkzA5rnFkhVtgykNXA9utDBcmEdeMRPmXQvV/jR4pq5FXU3w
        fSxFJ8XKvnLMlJfJ9kSnm8cOyT+J
X-Google-Smtp-Source: ABdhPJy3eLsIh2Na3H7aBZv2hHsVXSY7jYLRnC/yeaZDxYJoBQaUtvOMZap2R4HbBVt2V1QxHUMuIA==
X-Received: by 2002:a05:6214:1742:: with SMTP id dc2mr5257973qvb.90.1596215723492;
        Fri, 31 Jul 2020 10:15:23 -0700 (PDT)
Received: from ?IPv6:2601:284:8202:10b0:c147:b41e:be5e:8b7a? ([2601:284:8202:10b0:c147:b41e:be5e:8b7a])
        by smtp.googlemail.com with ESMTPSA id x24sm10465749qtj.8.2020.07.31.10.15.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jul 2020 10:15:22 -0700 (PDT)
Subject: Re: [RFC PATCH bpf-next 2/3] bpf: Add helper to do forwarding lookups
 in kernel FDB table
To:     Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        bpf@vger.kernel.org
References: <1596170660-5582-1-git-send-email-komachi.yoshiki@gmail.com>
 <1596170660-5582-3-git-send-email-komachi.yoshiki@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <5970d82b-3bb9-c78f-c53a-8a1c95a1fad7@gmail.com>
Date:   Fri, 31 Jul 2020 11:15:19 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <1596170660-5582-3-git-send-email-komachi.yoshiki@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/30/20 10:44 PM, Yoshiki Komachi wrote:
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 654c346b7d91..68800d1b8cd5 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -5084,6 +5085,46 @@ static const struct bpf_func_proto bpf_skb_fib_lookup_proto = {
>  	.arg4_type	= ARG_ANYTHING,
>  };
>  
> +#if IS_ENABLED(CONFIG_BRIDGE)
> +BPF_CALL_4(bpf_xdp_fdb_lookup, struct xdp_buff *, ctx,
> +	   struct bpf_fdb_lookup *, params, int, plen, u32, flags)
> +{
> +	struct net_device *src, *dst;
> +	struct net *net;
> +
> +	if (plen < sizeof(*params))
> +		return -EINVAL;

I need to look at the details more closely, but on first reading 2
things caught me eye:
1. you need to make sure flags is 0 since there are no supported flags
at the moment, and

> +
> +	net = dev_net(ctx->rxq->dev);
> +
> +	if (is_multicast_ether_addr(params->addr) ||
> +	    is_broadcast_ether_addr(params->addr))
> +		return BPF_FDB_LKUP_RET_NOENT;
> +
> +	src = dev_get_by_index_rcu(net, params->ifindex);
> +	if (unlikely(!src))
> +		return -ENODEV;
> +
> +	dst = br_fdb_find_port_xdp(src, params->addr, params->vlan_id);

2. this needs to be done via netdev ops to avoid referencing bridge code
which can be compiled as a module. I suspect the build robots will id
this part soon.

