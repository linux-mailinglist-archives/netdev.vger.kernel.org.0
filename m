Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 490952C7413
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 23:18:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729362AbgK1Vtq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Nov 2020 16:49:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728063AbgK1SXi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Nov 2020 13:23:38 -0500
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53C5CC025452
        for <netdev@vger.kernel.org>; Sat, 28 Nov 2020 09:03:45 -0800 (PST)
Received: by mail-il1-x144.google.com with SMTP id r17so7332701ilo.11
        for <netdev@vger.kernel.org>; Sat, 28 Nov 2020 09:03:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pOODgo/2EnIlsD7L54ZwFEQjFMd07zCf0+vqNk++KMw=;
        b=E8/sce1m7Cd+gYarstgXlLsJWy4ncMVs0yRfepE9m+2IsZgR1YrPmZnQH+Geo/j10x
         vq4JSa1QpdF7S2d8Zj8VhSfUpr5J52BeNUg8wu5yxCrQunEo+s8gywmuTY3kw6u/SckA
         y9C2FUZ70gFBeJZpWHvOXU8obSCHU4oWN1AeDkjlHagRdN54pu8xJdVmf5iFebvI7psK
         JYUO7D+2QSFvaUPIi8HBPlz9wJmqgzIy4nE8ZBNDVSwt8yUTFE7rA8reZewZxHtmOBsk
         RvADpz1dYmkt0sVzXgMpR+iwm9sdzC5vbi5bX37dYEKa44rI4WJDGYcOijvKexdvfo+9
         frvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pOODgo/2EnIlsD7L54ZwFEQjFMd07zCf0+vqNk++KMw=;
        b=jiBH1RyLaSV2WAF81Gye88GvQlsHG8+vzrvSb1HR/Dv7dRui8yoNGnxr5huqaMysvp
         Sgv3t20Z9JUFgpH3RiPBFJeKfJPbkCTZMzvrrVn7Bm+6U2t0nDcxxHxyl9RzX6DBUcpG
         +ZYRfkydLTY0QvA+fWhaFjavC3NrKVog2acG/wb40Gh3TNy3fNK7IDl1XxNZIrp5uZQT
         jYPMAL4QCFq1UP3xCgSEQZ1p3+agb3zrovDwaTPYk4687N2wYBC3RKiOT+GZp+9QUSCf
         Wn6nvayRd0V6oxf3RrYAB/0htRqilRQ3x9A8rF4an7zXhwteVAV+zEjb3wLLgUF1P6yI
         XzqA==
X-Gm-Message-State: AOAM530KDAVbxUK+TglcHneBxLx8VGSEZBG2w9R79z1Po+yb1UFG/YJf
        Lm8bMUeoXeErQ1D3yx11fu4Q+CkxrGo=
X-Google-Smtp-Source: ABdhPJx1AHaggPzuLJ+xZXKeVKzGfFB7E/IkLOAWVDXM3HaC/9vdoQzr3u6oRCa2AKIhptjFlzwdJA==
X-Received: by 2002:a92:c648:: with SMTP id 8mr12340499ill.176.1606583024611;
        Sat, 28 Nov 2020 09:03:44 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:2def:de5f:be2e:92f1])
        by smtp.googlemail.com with ESMTPSA id l23sm5467535iob.42.2020.11.28.09.03.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 28 Nov 2020 09:03:43 -0800 (PST)
Subject: Re: [PATCH net] ipv4: Fix tos mask in inet_rtm_getroute()
To:     Guillaume Nault <gnault@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Russell Strong <russell@strong.id.au>
References: <b2d237d08317ca55926add9654a48409ac1b8f5b.1606412894.git.gnault@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <ace2daed-7d88-7364-5395-80b63f59ffc1@gmail.com>
Date:   Sat, 28 Nov 2020 10:03:42 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <b2d237d08317ca55926add9654a48409ac1b8f5b.1606412894.git.gnault@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/26/20 11:09 AM, Guillaume Nault wrote:
> When inet_rtm_getroute() was converted to use the RCU variants of
> ip_route_input() and ip_route_output_key(), the TOS parameters
> stopped being masked with IPTOS_RT_MASK before doing the route lookup.
> 
> As a result, "ip route get" can return a different route than what
> would be used when sending real packets.
> 
> For example:
> 
>     $ ip route add 192.0.2.11/32 dev eth0
>     $ ip route add unreachable 192.0.2.11/32 tos 2
>     $ ip route get 192.0.2.11 tos 2
>     RTNETLINK answers: No route to host
> 
> But, packets with TOS 2 (ECT(0) if interpreted as an ECN bit) would
> actually be routed using the first route:
> 
>     $ ping -c 1 -Q 2 192.0.2.11
>     PING 192.0.2.11 (192.0.2.11) 56(84) bytes of data.
>     64 bytes from 192.0.2.11: icmp_seq=1 ttl=64 time=0.173 ms
> 
>     --- 192.0.2.11 ping statistics ---
>     1 packets transmitted, 1 received, 0% packet loss, time 0ms
>     rtt min/avg/max/mdev = 0.173/0.173/0.173/0.000 ms
> 
> This patch re-applies IPTOS_RT_MASK in inet_rtm_getroute(), to
> return results consistent with real route lookups.
> 
> Fixes: 3765d35ed8b9 ("net: ipv4: Convert inet_rtm_getroute to rcu versions of route lookup")
> Signed-off-by: Guillaume Nault <gnault@redhat.com>
> ---
>  net/ipv4/route.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


