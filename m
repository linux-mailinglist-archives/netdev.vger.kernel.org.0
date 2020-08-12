Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01AE8242FD1
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 22:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727838AbgHLUBV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Aug 2020 16:01:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727823AbgHLUBU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Aug 2020 16:01:20 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A87DC061383;
        Wed, 12 Aug 2020 13:01:20 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id g7so450789plq.1;
        Wed, 12 Aug 2020 13:01:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wuMDcQz/yAkAvvq+/eLeF0b83GDzc+mUTWpncJKa/qc=;
        b=NTNf73Rg/7lKO7gPPWJL7Kp/SSDCP+Ypoe8V2wNh2rBY2pkh8yd2QWPPvvdnQHkXms
         hsiZiOz7At1G38+n4DQhedsOjTMvZ6Xdyov8Dhzo9Y77N6e947KTqJBE9E95KT4qJKgA
         VeIhgrspWRrpnKGDzJgvbCTdt4uKjBsJN0Y89zW/zUlHs3f6rIhBaj+JCxamTsJEUl6z
         jhfu4m479bL0+8h1gxuw3fCTfacK+9OMdvXflV0kA0Sr7wYbYaaWmcWF8+7zAtxJ35mz
         PemxQIOKvVd1RML9fmxPBd2L8nl2ORSOM42b0M/P/FXINm7TKLydiV8tGcySNZTnfKKV
         OipA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wuMDcQz/yAkAvvq+/eLeF0b83GDzc+mUTWpncJKa/qc=;
        b=GIpuaJENlz5jVDunFpJG8HSkkqzbIzELOZlrvlvpBBr2ph73EaD1VQBXZ1Bp0RuYl2
         gnjYNyG3F0LSfDfktRuLhQs7ruGv8TKBWVwwYa1e7xQ5wYS84b+lvDwUfDC9oTsTh5k6
         Kl8Ly1JavAwQChCIrlPW7aQCMiO7sZqIklqJNJA7ELVvRm5ZXsxTF51PSKt2Aqkh6Onr
         BFAdoDT/ccjd/p0lQgmM9V8xoW/QQbutoyejTFNoeUwOggPpvICFNPMpjRTaryGrW7tR
         LGVzKk6OYlSTuxpm3HIZJKBrQkwZJqkFjcqfydiitqnYO1bwNqRwPf8iNd9U14C6deB5
         yReA==
X-Gm-Message-State: AOAM531Xfb1910iXOfScFhNFIR/Q4WXR5r1Vh3Q9Yw3SJZi0UR1MoMP1
        CT5cDpcmEccPtnTWVZRFKuL7B7uH
X-Google-Smtp-Source: ABdhPJxXzsxS3PdJA8JNjlgCS8LmmjKmhrP+b6bTQBg0X8VK3Qf/RX50RwLeUrdCay2M6rLhu2GI5Q==
X-Received: by 2002:a17:90a:e107:: with SMTP id c7mr1697574pjz.100.1597262478995;
        Wed, 12 Aug 2020 13:01:18 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id l78sm3284595pfd.130.2020.08.12.13.01.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Aug 2020 13:01:18 -0700 (PDT)
Subject: Re: [PATCH] ipv4: tunnel: fix compilation on ARCH=um
To:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>
References: <20200812210852.dc434e0b40e9.I618f37993ea3ddb2bec31e9b54e4f4ae2f7b7a51@changeid>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <f400c3f1-8bb3-b8bb-a0c0-8cae9e2179a5@gmail.com>
Date:   Wed, 12 Aug 2020 13:01:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200812210852.dc434e0b40e9.I618f37993ea3ddb2bec31e9b54e4f4ae2f7b7a51@changeid>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/12/20 12:08 PM, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> With certain configurations, a 64-bit ARCH=um errors
> out here with an unknown csum_ipv6_magic() function.
> Include the right header file to always have it.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  net/ipv4/ip_tunnel_core.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/ipv4/ip_tunnel_core.c b/net/ipv4/ip_tunnel_core.c
> index 9ddee2a0c66d..4ecf0232ba2d 100644
> --- a/net/ipv4/ip_tunnel_core.c
> +++ b/net/ipv4/ip_tunnel_core.c
> @@ -37,6 +37,7 @@
>  #include <net/geneve.h>
>  #include <net/vxlan.h>
>  #include <net/erspan.h>
> +#include <net/ip6_checksum.h>
>  
>  const struct ip_tunnel_encap_ops __rcu *
>  		iptun_encaps[MAX_IPTUN_ENCAP_OPS] __read_mostly;
> 

Already fixed ?

commit 8ed54f167abda44da48498876953f5b7843378df
Author: Stefano Brivio <sbrivio@redhat.com>
Date:   Wed Aug 5 15:39:31 2020 +0200

    ip_tunnel_core: Fix build for archs without _HAVE_ARCH_IPV6_CSUM
    
    On architectures defining _HAVE_ARCH_IPV6_CSUM, we get
    csum_ipv6_magic() defined by means of arch checksum.h headers. On
    other architectures, we actually need to include net/ip6_checksum.h
    to be able to use it.
    
    Without this include, building with defconfig breaks at least for
    s390.
    
    Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
    Fixes: 4cb47a8644cc ("tunnels: PMTU discovery support for directly bridged IP packets")
    Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>
