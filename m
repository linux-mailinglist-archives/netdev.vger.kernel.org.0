Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A91E1308426
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 04:13:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231802AbhA2DNW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 22:13:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbhA2DNU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 22:13:20 -0500
Received: from mail-oo1-xc2e.google.com (mail-oo1-xc2e.google.com [IPv6:2607:f8b0:4864:20::c2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F006C061573
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 19:12:40 -0800 (PST)
Received: by mail-oo1-xc2e.google.com with SMTP id o5so1963572oop.12
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 19:12:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Dctk8aov6+RstKFl2Jkajexwl/b2K3DwfJBBLKx9esk=;
        b=ZZTJi1viKP2NA2JNyeGZjQyGGwyyg2j/+ZRZOeQoLM262YePMl6Nr7cLVFqc/qCFXe
         1oG3vHbfMEJYR+AosPTItZXntZDwFovKAhmp3L/Wgn1rG60TifAr3i2IiQaXUUPCe5ME
         k1v1IaXR9LV5Rwk6dkQ2YmGoS9c8YKuO+BRAr/jcbRLizFWGI8H/RNJBf5poMwtPYLmv
         71+hGtDFN2XadKnc6tqAiHrdsEzvXbnLi4YYfbNTLN1Up4MG412nWFuMFG4UiD+bO0zz
         2JkzDhuCjT7SKGz0prIsQgmpv/+Lh/kI7Vur83tYQobzxncYBDnAfCE5n9v3tuqPEPLz
         f1jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Dctk8aov6+RstKFl2Jkajexwl/b2K3DwfJBBLKx9esk=;
        b=d8WpoXm9te0BOTx/r28AP4Vcr9/iYvao2B+AZWqZp4irV+KqOKvQ5tXYtlA+B6CzHL
         mawQEethxG5dbqKcQHiwn0DeRtLyjt5u7MkBl3xg3Sg8WB/0Ut/GVM16jmCHnFcXSybJ
         ob0oRR2ulf3Jce5HaczPcnV9K+bKEtGGwl9tim706C+BHOvXqzuxP1K+DUxtIEpN1jiH
         01cuFpAZ5/IlQwLPF9nCAOzmtTzUS9Dj0LzjkbXcwN3+kthNxHvZECPyb7HG40CtJKXC
         b3Vhbntqyt1bDTJXCjmfdWUWF7Oe5AmMXkFM1y9n4KiBK2qtlm1P8Vjn+1SAzuHK653K
         WKpQ==
X-Gm-Message-State: AOAM531/vuSzEXXReQnB4bLUsYD3/nizFZ9NOQ5PpzGgqZIdvgQTF3xR
        QESEDqiqTTI9NqfRWh5Z3NA=
X-Google-Smtp-Source: ABdhPJyjMOKhP72sv4QOH8ikFGFzsWcdjRuvCOHKpBnev6iIDRD4Y/RTgHk7xVf5Ia6Bybb2B+AyxQ==
X-Received: by 2002:a4a:4302:: with SMTP id k2mr1814746ooj.50.1611889959606;
        Thu, 28 Jan 2021 19:12:39 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.50])
        by smtp.googlemail.com with ESMTPSA id y17sm1814695oie.7.2021.01.28.19.12.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jan 2021 19:12:39 -0800 (PST)
Subject: Re: [PATCH net-next 05/12] nexthop: Use enum to encode notification
 type
To:     Petr Machata <petrm@nvidia.com>, netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>
References: <cover.1611836479.git.petrm@nvidia.com>
 <687076047917503b42f35ef9739208b9aaa5bb15.1611836479.git.petrm@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <005e0faf-7021-7ec7-e6b3-33892db120c3@gmail.com>
Date:   Thu, 28 Jan 2021 20:12:37 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <687076047917503b42f35ef9739208b9aaa5bb15.1611836479.git.petrm@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/28/21 5:49 AM, Petr Machata wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> Currently there are only two types of in-kernel nexthop notification.
> The two are distinguished by the 'is_grp' boolean field in 'struct
> nh_notifier_info'.
> 
> As more notification types are introduced for more next-hop group types, a
> boolean is not an easily extensible interface. Instead, convert it to an
> enum.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> Reviewed-by: Petr Machata <petrm@nvidia.com>
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> ---
>  .../ethernet/mellanox/mlxsw/spectrum_router.c | 54 ++++++++++++++-----
>  drivers/net/netdevsim/fib.c                   | 23 ++++----
>  include/net/nexthop.h                         |  7 ++-
>  net/ipv4/nexthop.c                            | 14 ++---
>  4 files changed, 69 insertions(+), 29 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


