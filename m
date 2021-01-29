Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6946308424
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 04:11:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231184AbhA2DK6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 22:10:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231452AbhA2DKi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 22:10:38 -0500
Received: from mail-oo1-xc32.google.com (mail-oo1-xc32.google.com [IPv6:2607:f8b0:4864:20::c32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40155C061574
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 19:09:58 -0800 (PST)
Received: by mail-oo1-xc32.google.com with SMTP id q3so1975179oog.4
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 19:09:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=iyY6WfcxLK6VtUT1a8d3p8EiShP13Rm/KIj5L+FGyrM=;
        b=Sh4DhVyLdWivAtxOgA51+2ykQndYxKWuMvp9jr9dPkE+EIfT/twDL+5cyKhpM+7zi3
         F1KYCYz+DstZY1GCzvu9TiY7SlbFULqFb92JL1XgVdxE9xtyNRPkWrpwOL0kd0NqYW7L
         XBPyGrJrQtl5rJTLy0xOZGjfg2sk+L5Kf3zt7V5fYAMDa3cTzQkVfeCPje+SFz1/v4IT
         Pux9juJtDbJt6NuUeGFspFYh28rPxh/xPopUsl/JAvEoZE7qMXcDURT4flFcU4Nizn01
         vODrq2lgFq5NvRRDjYLZRkpTE2l5JWQFJ1mGTQSH/Vm030eQgVMvg3S4oAE7X/ZlKGrb
         x+RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iyY6WfcxLK6VtUT1a8d3p8EiShP13Rm/KIj5L+FGyrM=;
        b=AuSTW68SHgIrMM3/QQVqDNX4ZeMa2Pzdb0kBKPv8IlVcX+Z8GopSyYEOSkRraRG6Dn
         /dmWpnxsjfDfF0q82L1v6vw0D8CqARgKdqSjMdH/HuaWHFDU7C7qppl+mjUOTfmm7Z8G
         0saCAeLmDLd6GDqy9u+lWi7eWCuEPrJSU0RgIWZes6JRmhFM/0HpgVV1fj7iuboiIQkz
         4agLloUkVt0fyE2Sc2QIAgO8ruuQOMciVifoz55Y4Os8lN4/F9JDE2iLtNAuCWsnydEd
         LyHf6ZfC8whS/bqi/ung0k9Wl6rGlnnqkHxnWWS3o5Ma8ew9uudkyfeE0Lq/z/3Jms43
         fd0g==
X-Gm-Message-State: AOAM530bbKNeONS/LD06KIu7eJ6zYvhwiOdh7D0mEdvzV0cdK2FMdb3G
        BzSyAhType5d4j5CMwx/Z3I=
X-Google-Smtp-Source: ABdhPJyMdiLFX+pz9WDQOsx2fBkghGZZ9Cge0zikrzXhhoEgiCkRj2mFvqtPcT4VdXlKxf78czly1w==
X-Received: by 2002:a05:6820:255:: with SMTP id b21mr1831506ooe.0.1611889797683;
        Thu, 28 Jan 2021 19:09:57 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.50])
        by smtp.googlemail.com with ESMTPSA id e14sm1838718oou.19.2021.01.28.19.09.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jan 2021 19:09:57 -0800 (PST)
Subject: Re: [PATCH net-next 03/12] nexthop: Introduce to struct nh_grp_entry
 a per-type union
To:     Petr Machata <petrm@nvidia.com>, netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>
References: <cover.1611836479.git.petrm@nvidia.com>
 <96736e8f9767633e73dacd59c0836547824d0ff8.1611836479.git.petrm@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c494fd04-a6b1-d787-3036-d18194504b85@gmail.com>
Date:   Thu, 28 Jan 2021 20:09:55 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <96736e8f9767633e73dacd59c0836547824d0ff8.1611836479.git.petrm@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/28/21 5:49 AM, Petr Machata wrote:
> The values that a next-hop group needs to keep track of depend on the group
> type. Introduce a union to separate fields specific to the mpath groups
> from fields specific to other group types.
> 
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  include/net/nexthop.h | 7 ++++++-
>  net/ipv4/nexthop.c    | 4 ++--
>  2 files changed, 8 insertions(+), 3 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


