Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23DC046DF0F
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 00:43:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241226AbhLHXrF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 18:47:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241220AbhLHXrD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 18:47:03 -0500
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81078C0617A1
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 15:43:30 -0800 (PST)
Received: by mail-oi1-x230.google.com with SMTP id 7so6259724oip.12
        for <netdev@vger.kernel.org>; Wed, 08 Dec 2021 15:43:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=C/FUweGTnMQwWIn7JKGm+0zszytVnZ+/olqck51xvNA=;
        b=k6vJ2U7U4FAPNSa118eENI0y6aGULCssXPpQKUEcSjfOSySCbS/s8q++eDzfMoDhLs
         Ap1sKnw3ts608ZDwfIsi5M0JGDauDTodMBNl9dbqZnvGwgSTN1t0+4TydT0WLM5LSToY
         Ef0HWxJs5cO9Y6QgNt0jmX425YlJHy6zSqGQCY0SiV+V3q6LRP4EHoPBvk1AGJLwEiJH
         At76iRmE9pbeUjnGpEOxflNhDekyVl580IAiCQSgoCVL9XQHALHhmzDEkp76JqNmvt/j
         yYxOTNe0X0QfAqjyLLA+Xw/CjbyWl5yVYpSiGzSdmstidq+C5tKWVyXBcdbOlAW9Md6R
         LGog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=C/FUweGTnMQwWIn7JKGm+0zszytVnZ+/olqck51xvNA=;
        b=LpyB3US6g113XaEy0cJYbxfIfp5pbeU/JsLgkuwLVBq1Av1If6MhOUDhtb6PWTFqYk
         g9UJHqOeEpaacViMU+rkuxIunlS0eTdEXt2vhr2KlryoLByRHAklm2StPSMj8N/ErKss
         pIQwszaEqzNGwfbCg92/lajcIkJw6QRZuNMzPY+3vOp+oMlxL/s7r5O/aepnoixJUOsq
         h3PFPRvdvba6zwvzfKzOdXo4pzisR7JBQBRlSKNX5tFamGt+C4ycXVtRvVJolHBrUHKr
         EuQdBi2jvYMHq1OvpydGnLv/6ECAm9J6CiHHJiQAM6WFgDaKiVvMzOwsJhJDvQingkbM
         1EoA==
X-Gm-Message-State: AOAM530UjavobWe+rXoPMkr36RFUbjC+pLFH8l5VyZHmdZyGcW98J+nS
        RLB3V6oB9se8l6tQAh8RZsw=
X-Google-Smtp-Source: ABdhPJy1fCLFhqt98BbSVkvjRSFtSXFdTayncOIR4N1aTCnBgyDzlj60bpZKIrGPrPc+KUx1HpoYDQ==
X-Received: by 2002:a05:6808:210c:: with SMTP id r12mr2630317oiw.104.1639007009920;
        Wed, 08 Dec 2021 15:43:29 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id x17sm727661oot.30.2021.12.08.15.43.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Dec 2021 15:43:29 -0800 (PST)
Message-ID: <05fe0ea9-56ba-9248-fa05-b359d6166c9f@gmail.com>
Date:   Wed, 8 Dec 2021 16:43:28 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [PATCH net-next v5] rtnetlink: Support fine-grained netdevice
 bulk deletion
Content-Language: en-US
To:     Lahav Schlesinger <lschlesinger@drivenets.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, nikolay@nvidia.com
References: <20211205093658.37107-1-lschlesinger@drivenets.com>
 <e5d8a127-fc98-4b3d-7887-a5398951a9a0@gmail.com>
 <20211208214711.zr4ljxqpb5u7z3op@kgollan-pc>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20211208214711.zr4ljxqpb5u7z3op@kgollan-pc>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/8/21 2:47 PM, Lahav Schlesinger wrote:
> No visible changes from what I saw, this API is as fast as group
> deletion. Maybe a few tens of milliseconds slower, but it's lost in the
> noise.
> I'll run more thorough benchmarks to get to a more conclusive conclusion.
> 
> Also just pointing out that the sort will be needed even if we pass an
> array (IFLA_IFINDEX_LIST) instead.
> Feels like CS 101, but do you have a better approach for detecting
> duplicates in an array? I imagine a hash table will be slower as it will
> need to allocate a node object for each device (assuming we don't want
> to add a new hlist_node to 'struct net_device' just for this)

I think marking the dev's and then using a delete loop is going to be
the better approach - avoid the sort and duplicate problem. I use that
approach for nexthop deletes:

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/net/ipv4/nexthop.c#n1849

Find a hole in net_device struct in an area used only for control path
and add 'bool grp_delete' (or a 1-bit hole). Mark the devices on pass
and delete them on another.
