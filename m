Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6C351F7C18
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 19:06:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726340AbgFLRFz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 13:05:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726219AbgFLRFy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jun 2020 13:05:54 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82748C03E96F;
        Fri, 12 Jun 2020 10:05:54 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id a45so4392261pje.1;
        Fri, 12 Jun 2020 10:05:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=NFOCrgH6eGJQLRvUxxWJHc8tPJ802WFeLj+g5WWWrNY=;
        b=tmmp2B2/p/KqqfCVxYXpZ1mtjOw1Yg2khN+rxKlvlu7Wwmi9os/iOL6cwdagCrX/20
         dIEbynRFRiTpPCFx2iwR33mJtUQt/RxhsLHzy1jJS4rZnaZqZmUq5QCC1IXNX6QQ3mOw
         DewOyfdZs4rusVKLxO4VyllqN2lFA0elIJCczRD3xDyN7lq4hDN19E7sPtlSxFojWRqW
         kNIn0fnn/qN44PuK+bYitGIgKIsFwsIom0GpTesAp4aAusdzlvMihWTpvnxAyHxhX6OU
         T1GjLA72WloBKeuMbs4xQ0W+t7fWkqAUjlrP0CBu3dUCjnYjWqmYBbmWg7aAPjEK/PBF
         zIhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=NFOCrgH6eGJQLRvUxxWJHc8tPJ802WFeLj+g5WWWrNY=;
        b=A16q9GBFfzVi6UaCi/V1kaJVTrmxBHTvcvJgp0CDhx6BV3puJWvLC7c4ZC333A8GyL
         7NCTbmq9X+GW6epfA21YSuEZGzEFaRtuIe7lDmiH4Py467P5BshAYOA0M5hTGKIXHrTq
         OEQO1fNyVD3nV5mKLAEcRKLLDnQcD7fqSYSdiV+fcL9mP4KbJtjeneGITwTUBZm5CDTp
         bFdpa2Fae+1GP2SpnDGzDTl+lZsJi1K9oPjT7y2VRulWlUEgPTrTxk0Qdy+sfBDvKfwW
         u7+khDxogCPGAWunVL2xa3hFPmUjp6RvDqb5Hhm5U2jq2POvKv/ii83fAtSaEqhpX2q/
         V0vA==
X-Gm-Message-State: AOAM5323RiyXDdmuUmmqNDBLWop2BAwe9tT2HgnRJNf1NCI65Jz8f2f1
        B4vz2JM3nUR0hQL1x6Vzfaw=
X-Google-Smtp-Source: ABdhPJySJcbGGFTSUGv8noBkhhx9mYcAOTBq7R02iZRY1EvKec63pnZH0lcpfQKDW/SUPeha91uunQ==
X-Received: by 2002:a17:90a:ae04:: with SMTP id t4mr13184861pjq.131.1591981553971;
        Fri, 12 Jun 2020 10:05:53 -0700 (PDT)
Received: from [192.168.0.179] (c-24-130-66-48.hsd1.ca.comcast.net. [24.130.66.48])
        by smtp.gmail.com with ESMTPSA id o96sm6041421pjo.13.2020.06.12.10.05.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jun 2020 10:05:53 -0700 (PDT)
Subject: Re: [RFC,net-next, 0/5] Strict mode for VRF
To:     Andrea Mayer <andrea.mayer@uniroma2.it>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Shrijeet Mukherjee <shrijeet@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc:     Donald Sharp <sharpd@cumulusnetworks.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@cnit.it>,
        Ahmed Abdelsalam <ahabdels@gmail.com>
References: <20200612164937.5468-1-andrea.mayer@uniroma2.it>
From:   Dinesh G Dutt <didutt@gmail.com>
Message-ID: <34a020ef-6024-5253-3e14-be865a7f6de1@gmail.com>
Date:   Fri, 12 Jun 2020 10:05:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200612164937.5468-1-andrea.mayer@uniroma2.it>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for doing this Andrea. This is a very important patch. I'll let 
the others comment on the specificity of the patch, but strict mode=1 
should be the default .

Dinesh

On 6/12/20 9:49 AM, Andrea Mayer wrote:
> This patch set adds the new "strict mode" functionality to the Virtual
> Routing and Forwarding infrastructure (VRF). Hereafter we discuss the
> requirements and the main features of the "strict mode" for VRF.
>
> On VRF creation, it is necessary to specify the associated routing table used
> during the lookup operations. Currently, there is no mechanism that avoids
> creating multiple VRFs sharing the same routing table. In other words, it is not
> possible to force a one-to-one relationship between a specific VRF and the table
> associated with it.
>
>
> The "strict mode" imposes that each VRF can be associated to a routing table
> only if such routing table is not already in use by any other VRF.
> In particular, the strict mode ensures that:
>   
>   1) given a specific routing table, the VRF (if exists) is uniquely identified;
>   2) given a specific VRF, the related table is not shared with any other VRF.
>
> Constraints (1) and (2) force a one-to-one relationship between each VRF and the
> corresponding routing table.
>
>
> The strict mode feature is designed to be network-namespace aware and it can be
> directly enabled/disabled acting on the "strict_mode" parameter.
> Read and write operations are carried out through the classic sysctl command on
> net.vrf.strict_mode path, i.e: sysctl -w net.vrf.strict_mode=1.
>
> Only two distinct values {0,1} are accepted by the strict_mode parameter:
>
>   - with strict_mode=0, multiple VRFs can be associated with the same table.
>     This is the (legacy) default kernel behavior, the same that we experience
>     when the strict mode patch set is not applied;
>
>   - with strict_mode=1, the one-to-one relationship between the VRFs and the
>     associated tables is guaranteed. In this configuration, the creation of a VRF
>     which refers to a routing table already associated with another VRF fails and
>     the error is returned to the user.
>
>
> The kernel keeps track of the associations between a VRF and the routing table
> during the VRF setup, in the "management" plane. Therefore, the strict mode does
> not impact the performance or intrinsic functionality of the data plane in any
> way.
>
> When the strict mode is active it is always possible to disable the strict mode,
> while the reverse operation is not always allowed.
> Setting the strict_mode parameter to 0 is equivalent to removing the one-to-one
> constraint between any single VRF and its associated routing table.
>
> Conversely, if the strict mode is disabled and there are multiple VRFs that
> refer to the same routing table, then it is prohibited to set the strict_mode
> parameter to 1. In this configuration, any attempt to perform the operation will
> lead to an error and it will be reported to the user.
> To enable strict mode once again (by setting the strict_mode parameter to 1),
> you must first remove all the VRFs that share common tables.
>
> There are several use cases which can take advantage from the introduction of
> the strict mode feature. In particular, the strict mode allows us to:
>
>    i) guarantee the proper functioning of some applications which deal with
>       routing protocols;
>
>   ii) perform some tunneling decap operations which require to use specific
>       routing tables for segregating and forwarding the traffic.
>
>
> Considering (i), the creation of different VRFs that point to the same table
> leads to the situation where two different routing entities believe they have
> exclusive access to the same table. This leads to the situation where different
> routing daemons can conflict for gaining routes control due to overlapping
> tables. By enabling strict mode it is possible to prevent this situation which
> often occurs due to incorrect configurations done by the users.
> The ability to enable/disable the strict mode functionality does not depend on
> the tool used for configuring the networking. In essence, the strict mode patch
> solves, at the kernel level, what some other patches [1] had tried to solve at
> the userspace level (using only iproute2) with all the related problems.
>
> Considering (ii), the introduction of the strict mode functionality allows us
> implementing the SRv6 End.DT4 behavior. Such behavior terminates a SR tunnel and
> it forwards the IPv4 traffic according to the routes present in the routing
> table supplied during the configuration. The SRv6 End.DT4 can be realized
> exploiting the routing capabilities made available by the VRF infrastructure.
> This behavior could leverage a specific VRF for forcing the traffic to be
> forwarded in accordance with the routes available in the VRF table.
> Anyway, in order to make the End.DT4 properly work, it must be guaranteed that
> the table used for the route lookup operations is bound to one and only one VRF.
> In this way, it is possible to use the table for uniquely retrieving the
> associated VRF and for routing packets.
>
> I would like to thank David Ahern for his constant and valuable support during
> the design and development phases of this patch set.
>
> Comments, suggestions and improvements are very welcome!
>
> Thanks,
> Andrea Mayer
>
>
> [1] https://lore.kernel.org/netdev/20200307205916.15646-1-sharpd@cumulusnetworks.com/
>
> Andrea Mayer (5):
>    l3mdev: add infrastructure for table to VRF mapping
>    vrf: track associations between VRF devices and tables
>    vrf: add sysctl parameter for strict mode
>    vrf: add l3mdev registration for table to VRF device lookup
>    selftests: add selftest for the VRF strict mode
>
>   drivers/net/vrf.c                             | 450 +++++++++++++++++-
>   include/net/l3mdev.h                          |  37 ++
>   net/l3mdev/l3mdev.c                           |  95 ++++
>   .../selftests/net/vrf_strict_mode_test.sh     | 390 +++++++++++++++
>   4 files changed, 963 insertions(+), 9 deletions(-)
>   create mode 100755 tools/testing/selftests/net/vrf_strict_mode_test.sh
>
