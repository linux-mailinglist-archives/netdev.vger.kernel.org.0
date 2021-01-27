Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF833052BA
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 07:03:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234733AbhA0GCr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 01:02:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232813AbhA0FP0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 00:15:26 -0500
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B664C06178A
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 21:14:46 -0800 (PST)
Received: by mail-ot1-x331.google.com with SMTP id v1so560569ott.10
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 21:14:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/TD59MJMpMDztvcOsHDCjMyRTLfI4gJz8bnimCgen+Y=;
        b=Yw5u2Zwj1+gX01HekqhaG6W4W6UrWzARS8niHdX7FlcuJdZd9eOrzrtQ3uyQk3Emt8
         wxhHA9SH2mPNFVJJHr7XlVPjwkbHDMKRBcOOelGkD0kS+Rbc8iuLIWxMo3neOuRKeEP3
         8GDr0DJqKdKT0l//vltOiya3E66YnQsppF6+P9QkDcMNkS9XVKuMSs+ywqUBbUts3mqi
         w6IGoPL3aq36gB+JpEcOHIu6qis6/aTW/xQXSpN+DLIgbiRkKeEGwpbZlmCO8YmAP4Tr
         VEktCQzgzzj3IRBu2orX1w82a+tUOaq0f+4rQaFYc0zFwZVG/Yl6Fzlc8R9wNgW8685G
         Dc5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/TD59MJMpMDztvcOsHDCjMyRTLfI4gJz8bnimCgen+Y=;
        b=IdG00oSgtb7lNbmBLhOtA96bFax7Ur3kOO7eJfDlpEMC46mT71JW5WV7M8iCaewJRc
         44082mJ1QvAYowvB0QXcvS4qTcQHKb60iuxZhWgnBO3tIDjSlaGaTUEFDPTTMiUITJPU
         Y50X28xbZT5vkkLJX1ngfZl+ukkZwaKuxR4qL2v137xKy6sbnYoRRuhFJb+9GCf+y2Y1
         sIeEpS/L7yheZFdNxRffq+NoR8bhJL4JSn7UbAjqyX4jJchRitZ38TntyOC97xmrB35b
         MULBpshfttlSgp9mAGQD+yh1DH3q6KjLhygKJpLR9DnnTL9DBOiftyJuIhBX+Ztl4OF1
         6x2A==
X-Gm-Message-State: AOAM533TmId/AtN/f3y4htiECrscbWZigV/E3TJi/ODiqA3hVNj41LaH
        D5OWxpt06EL4/5jmPdFa5Iw=
X-Google-Smtp-Source: ABdhPJydxZCB4LylnpX2tgOyROZtLlDhmY9oCtjmOyaoVFs95xhPh1KRn8NqRIl6LVl3xQwV4c3/JQ==
X-Received: by 2002:a9d:ae7:: with SMTP id 94mr6440843otq.94.1611724485711;
        Tue, 26 Jan 2021 21:14:45 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:284:8203:54f0:a08d:e5cd:cfb5:2f9])
        by smtp.googlemail.com with ESMTPSA id c10sm196263otm.22.2021.01.26.21.14.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jan 2021 21:14:45 -0800 (PST)
Subject: Re: [PATCH net-next 08/10] net: ipv6: Emit notification when fib
 hardware flags are changed
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, amcohen@nvidia.com,
        roopa@nvidia.com, sharpd@nvidia.com, bpoirier@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
References: <20210126132311.3061388-1-idosch@idosch.org>
 <20210126132311.3061388-9-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <62e40970-18f2-130d-c68f-edb36ee0a5ca@gmail.com>
Date:   Tue, 26 Jan 2021 22:14:44 -0700
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


