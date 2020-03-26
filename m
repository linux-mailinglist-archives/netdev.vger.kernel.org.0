Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE78B1945F9
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 19:01:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727354AbgCZSB0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 14:01:26 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55272 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726163AbgCZSB0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 14:01:26 -0400
Received: by mail-wm1-f68.google.com with SMTP id c81so7517114wmd.4
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 11:01:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2P1CFBmWkodNTEHJl9eAUEsf6jWN/P2ba0zdgUc4ZDI=;
        b=JVhYtchKgiCrlsqEIEW6w1YamYMF68MWz7yGcNtXQTBBwLAb8D7yxp5JI7giu7EDeg
         7L2NtytUjUElRIzRPBT8U1lRLHmPl0WcgjcGX8r7YmmivfOJdi03SGpi+ACTY/0cPK1m
         R+GTSoopqDuNPeJDZ14KUZAAo8+PialWyGBQlwpSR5D+V2nEaDtGEnxt0dtnfVTMx9vC
         7UUusqn2fBHkfq3BojMYKLeNXj6lFZArBwXKaVQ+QgT/arkBcCTGNc61GzKdr7dn7VRp
         tNmStDfoVnFkxGHpYxO9Q3GPAYLqzTZhQCHnkXMNIOOeLjot4cnZAhxcYGs06dPuW4/g
         Q+vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=2P1CFBmWkodNTEHJl9eAUEsf6jWN/P2ba0zdgUc4ZDI=;
        b=Rmmuk8Qvc7dNekhQ5DWP13f22YSERKbCCuBBGeZzlbpsXx2sfQjDGTDqvXg6FDtvvT
         dAXXqtEVW13Uyj3+HeBBrb8LTw5e8QDLKR8Ah5+W7NqNEyv80rmUK5HWzandpLh2ck/W
         mvC8YzNuvj9HABCgWeenvTDIkh6syRtf+aUOROlwTceELqkq7x9qTSEPI3kUGb8k8Hvw
         kv4eVthL7N1uD2I1mZ5/hGiAwf5tc5kVcCQiCPsVWfN2/H8grCkcf3fQXANx1LpteSOQ
         J6rlwYCDc/FVqc7CiN7H6bvOHmfxDOwPEKQ0G1QIp+lG9tSu0RCkFvAtONz1xKS/8LSy
         Q6Yw==
X-Gm-Message-State: ANhLgQ2D8PNYibAboYBYKyaiuRi6SeyOiWq4Mpw/bj9RYKezw9xQAeWi
        B+yCeQYf37+b0D/+3p1clwwH+A==
X-Google-Smtp-Source: ADFU+vuEwjsGY7nOSHbD7owRRdeDwCyYrUdmgsgXqADMiaFsSamPnjpteBHJwIWQGBLY6bzoUp27aQ==
X-Received: by 2002:a1c:bc84:: with SMTP id m126mr1091801wmf.171.1585245683283;
        Thu, 26 Mar 2020 11:01:23 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:410:bb00:18dc:21ce:7e5f:92a2? ([2a01:e0a:410:bb00:18dc:21ce:7e5f:92a2])
        by smtp.gmail.com with ESMTPSA id 71sm4887572wrc.53.2020.03.26.11.01.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Mar 2020 11:01:21 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net] net, ip_tunnel: fix interface lookup with no key
To:     William Dauchy <w.dauchy@criteo.com>, netdev@vger.kernel.org
Cc:     pshelar@nicira.com
References: <20200325150304.5506-1-w.dauchy@criteo.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <67629ca1-ad66-735a-ecfc-28531b079c40@6wind.com>
Date:   Thu, 26 Mar 2020 19:01:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200325150304.5506-1-w.dauchy@criteo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 25/03/2020 à 16:03, William Dauchy a écrit :
> when creating a new ipip interface with no local/remote configuration,
> the lookup is done with TUNNEL_NO_KEY flag, making it impossible to
> match the new interface (only possible match being fallback or metada
> case interface); e.g: `ip link add tunl1 type ipip dev eth0`
> 
> If we consider `key` being zero in ipip case, we might consider ok to
> go through this last loop, and make it possible to match such interface.
> In fact this is what is done when we create a gre interface without key
> and local/remote.
> 
> context being on my side, I'm creating an extra ipip interface attached
> to the physical one, and moving it to a dedicated namespace.
> 
> Fixes: c54419321455 ("GRE: Refactor GRE tunneling code.")
> Signed-off-by: William Dauchy <w.dauchy@criteo.com>
> ---
>  net/ipv4/ip_tunnel.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
> index 74e1d964a615..f6578bcadbed 100644
> --- a/net/ipv4/ip_tunnel.c
> +++ b/net/ipv4/ip_tunnel.c
> @@ -142,9 +142,6 @@ struct ip_tunnel *ip_tunnel_lookup(struct ip_tunnel_net *itn,
>  			cand = t;
>  	}
>  
> -	if (flags & TUNNEL_NO_KEY)
> -		goto skip_key_lookup;
> -
Hmm, removing this test may break some existing scenario. This flag is part of
the UAPI (for gre). Suppose that a tool configures a gre tunnel, leaves the key
uninitialized and set this flag. After this patch, the lookup may return
something else.


Regards,
Nicolas
