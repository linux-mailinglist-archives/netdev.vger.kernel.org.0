Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE036306BC4
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 05:04:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231172AbhA1EAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 23:00:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231177AbhA1DhG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 22:37:06 -0500
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 897B8C061574
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 19:36:26 -0800 (PST)
Received: by mail-ot1-x332.google.com with SMTP id e70so3915122ote.11
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 19:36:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/TD59MJMpMDztvcOsHDCjMyRTLfI4gJz8bnimCgen+Y=;
        b=rma8yWtyLW3hZVSK9tKasJzjWJ1K6SrJX9TNxF6UGMgxJuT8B5rR+kurANb/+PLUBx
         iwX1ufATAd9/tQolfT1dTQcBUl19zsniwzYHCd0Du+V3pHPX5DyMdKz+MOD/RqAMJSBW
         mg8cF4CzQPh8n10phuLb7hAQxnYK2QfBVga/kxV7w4YuZScI4+WG4f2ArKYGTrf/8Gq0
         KkZWBctMJYd9pRvxeFUpTBJ+NDIgKXxv/O37kxRWwxaNWVRztHuzNmwP9yvnMwLhBqP3
         l2CRUFvuCsJCyAJXE7yicrvk5nG6tysiWj/QCIO+EVEASJTYhmmbOMXBL+obzeYyInjW
         hVyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/TD59MJMpMDztvcOsHDCjMyRTLfI4gJz8bnimCgen+Y=;
        b=DO/HhRKFbBUx6IC8DUfRXoCwzFK4Mj0m1HNYLU2n9xqFmAXeYcrvYb/iHgIrd6dsZ1
         Mv3KMNLl2kd/2hOaBAzka3BEqT4f8Fzrg3D2cNBNDkeJcslndOoxiRthY6PD8Wq0moga
         c4m4BaXpduIkfK3JM4w2J05PWK/UBjx50v6tDtkHZee7kqayn9kc36T0HiJOpZPb1D9y
         9LenI4SYIqg/92gZY6KVw9+iMyhA9VgLw7ydOgEFpW7mdrpsF0GYIREYZudZaF5SGkJp
         QbsnZNF21DAwW5/gPXVw27YcclEIKajanPzwRrZ5bMxAUEcLPh9jDrAVIlASf5HiLwg5
         eHQw==
X-Gm-Message-State: AOAM533GGUdM0BK64XG/H1avRG/TWzIYqDoUMV8mzmSuqCtihjeVA0uF
        sn1YfG2NmkuNJQbj05D1SjU+CmkJLQc=
X-Google-Smtp-Source: ABdhPJzz73oZSRo9rG3Ic2Kd5uF26BC57cYCNJ9iKO87VkuF6MTLsspYdlRIXXlGv/ul0eWGF/C9ug==
X-Received: by 2002:a9d:748a:: with SMTP id t10mr10032000otk.336.1611804986022;
        Wed, 27 Jan 2021 19:36:26 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.50])
        by smtp.googlemail.com with ESMTPSA id l12sm853411oov.37.2021.01.27.19.36.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Jan 2021 19:36:25 -0800 (PST)
Subject: Re: [PATCH net-next 08/10] net: ipv6: Emit notification when fib
 hardware flags are changed
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, amcohen@nvidia.com,
        roopa@nvidia.com, sharpd@nvidia.com, bpoirier@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
References: <20210126132311.3061388-1-idosch@idosch.org>
 <20210126132311.3061388-9-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <89de17ca-0f67-6389-4a4c-3495c4bec697@gmail.com>
Date:   Wed, 27 Jan 2021 20:36:21 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210126132311.3061388-9-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/26/21 6:23 AM, Ido Schimmel wrote:
> From: Amit Cohen <amcohen@nvidia.com>
> 
> After installing a route to the kernel, user space receives an
> acknowledgment, which means the route was installed in the kernel,
> but not necessarily in hardware.
> 
> The asynchronous nature of route installation in hardware can lead
> to a routing daemon advertising a route before it was actually installed in
> hardware. This can result in packet loss or mis-routed packets until the
> route is installed in hardware.
> 
> It is also possible for a route already installed in hardware to change
> its action and therefore its flags. For example, a host route that is
> trapping packets can be "promoted" to perform decapsulation following
> the installation of an IPinIP/VXLAN tunnel.
> 
> Emit RTM_NEWROUTE notifications whenever RTM_F_OFFLOAD/RTM_F_TRAP flags
> are changed. The aim is to provide an indication to user-space
> (e.g., routing daemons) about the state of the route in hardware.
> 
> Introduce a sysctl that controls this behavior.
> 
> Keep the default value at 0 (i.e., do not emit notifications) for several
> reasons:
> - Multiple RTM_NEWROUTE notification per-route might confuse existing
>   routing daemons.
> - Convergence reasons in routing daemons.
> - The extra notifications will negatively impact the insertion rate.
> - Not all users are interested in these notifications.
> 
> Move fib6_info_hw_flags_set() to C file because it is no longer a short
> function.
> 
> Signed-off-by: Amit Cohen <amcohen@nvidia.com>
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  Documentation/networking/ip-sysctl.rst | 20 ++++++++++++
>  include/net/ip6_fib.h                  | 10 ++----
>  include/net/netns/ipv6.h               |  1 +
>  net/ipv6/af_inet6.c                    |  1 +
>  net/ipv6/route.c                       | 44 ++++++++++++++++++++++++++
>  net/ipv6/sysctl_net_ipv6.c             |  9 ++++++
>  6 files changed, 77 insertions(+), 8 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


