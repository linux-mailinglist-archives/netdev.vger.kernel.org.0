Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6068E215D3F
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 19:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729660AbgGFReQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 13:34:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729413AbgGFReP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 13:34:15 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76601C061755
        for <netdev@vger.kernel.org>; Mon,  6 Jul 2020 10:34:15 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id j80so35597437qke.0
        for <netdev@vger.kernel.org>; Mon, 06 Jul 2020 10:34:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=k3AwaYAhtFxHLaMYUxvtAEh3gXLGkp+FkVaoitnmTtc=;
        b=DF86t75aufpnJvczHUwebCbIXkKfXZ/Grh1lJqKYAtfqIKIMKpR1DBJTu1s62NfDm0
         fRq7MbX0tM91wRw01yah8/SL27/b6RBSuZOKlRp532Q4gTz3o8hwiC0I4j6JMVfp1X31
         ds8ATxNm6e5R4KN9hyfPX5F4k8L0ci1V7jjX2kBVxWWhVb7yLCBYV8O6WUhEiknbGQJP
         gSrJdyXawaGjDxgs46lpi4BUfe9TN4LiC7wRYLAxpTBo0W2cXODanGJcnjbpgSnEv2Ko
         U3KfrwcbS6X7DOpYtnR7Vw1LCumkqHU+FlUlP3UUcI0hMBhpcDoVVX8+Y5FsCAsGcg9B
         d+IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=k3AwaYAhtFxHLaMYUxvtAEh3gXLGkp+FkVaoitnmTtc=;
        b=gRzor5Mf/zPE3W0n7gculB4ZAuNd9by28OxWTIoFsaXFlLIvc2iPxzbCpgbYmja9Z2
         CJSbjZdjGiJczZfUjGq9Acm+Djcw+caZC+PhX/vwJ4FUNDofYNA6GbVoR9b8NNvGhGST
         jn8u8kxBJO4uXlNd1xzkjeRHknVNDP49/FFTAo0O3Qw6oR3e/W39j/xaCC5HRYqQuvSu
         xEx1Ai5QHjM7oI/ByfDV6Fq7U6upNSf5MHp6zTcSuaoYZLEs1DPF8062jdAWiMDqp3aZ
         WFadzvxZjfyMMzUzsNqdT/emD/E2pEqyuZ8NxIatpRULk7Azd8iTpuj8gJDXWV6KjIFj
         8m2A==
X-Gm-Message-State: AOAM533kZGt6zOwXZU0hZ9uoOCvhcXn6E9RM79k20qqSYORWl1IaClhU
        khkMHZB7wXmy9cs0sxc9BYtUy1lG
X-Google-Smtp-Source: ABdhPJzGhc2UUYRWKeq/3k/s24RCARDP2drY+EMiYA/Zpy5qKr6WpBdL09CujRCq7FVTktkH19dCNQ==
X-Received: by 2002:a37:9682:: with SMTP id y124mr45700102qkd.442.1594056854754;
        Mon, 06 Jul 2020 10:34:14 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:f517:b957:b896:7107? ([2601:282:803:7700:f517:b957:b896:7107])
        by smtp.googlemail.com with ESMTPSA id s24sm22860027qtb.63.2020.07.06.10.34.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jul 2020 10:34:14 -0700 (PDT)
Subject: Re: [PATCH net] ipv6: fib6_select_path can not use out path for
 nexthop objects
To:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net
Cc:     brak@choopa.com
References: <20200706171908.18222-1-dsahern@kernel.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <5d2deb19-3c7d-5db1-23c8-4f8d15594089@gmail.com>
Date:   Mon, 6 Jul 2020 11:34:12 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200706171908.18222-1-dsahern@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/6/20 11:19 AM, David Ahern wrote:
> diff --git a/net/ipv6/route.c b/net/ipv6/route.c
> index 82cbb46a2a4f..6451ba313506 100644
> --- a/net/ipv6/route.c
> +++ b/net/ipv6/route.c
> @@ -431,7 +431,7 @@ void fib6_select_path(const struct net *net, struct fib6_result *res,
>  	struct fib6_info *sibling, *next_sibling;
>  	struct fib6_info *match = res->f6i;
>  
> -	if ((!match->fib6_nsiblings && !match->nh) || have_oif_match)
> +	if (!match->nh && (!match->fib6_nsiblings || have_oif_match))
>  		goto out;
>  
>  	/* We might have already computed the hash for ICMPv6 errors. In such

of course I notice this after sending the patch. This can actually break
with multipath nexthop objects since it can overwrite the selected path
if done earlier.

DaveM: please drop; will send a v2
