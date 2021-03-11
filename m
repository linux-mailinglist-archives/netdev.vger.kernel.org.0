Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C2F433786F
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 16:49:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234085AbhCKPsa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 10:48:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234067AbhCKPsF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 10:48:05 -0500
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71448C061760
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 07:48:02 -0800 (PST)
Received: by mail-oi1-x231.google.com with SMTP id u198so18609920oia.4
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 07:48:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EVrcvfoDioxQkelS/mYR+VepRoHSAgaO7oE/svzUp3s=;
        b=HAfuYg0irHqa4s/v4O8tCkDQ086vJsfu77AVr+CJrZ5FGOyGbaFj4WELdi62NPVLhm
         WAv9EW+7FW36ZxJ5qtlOlKLstMi6WDb8S2Z2SMts/3g/V7YtIK3C4KW6/hWGxINFc5df
         6AnqZY9DBF2mFb13gy3+OQOVksBxV4LffJDPCQu7kOv1f+I4SFYQBWUuN22AzEKp24qa
         gbT7Tb8aA+jL/o8tfMCCad7LNWo5/qm5VT2Tr0xDtVZ4YW2SMvUuHAc6B0M3X31p20y+
         LwK7847HTCdT+pt/fBLY0G4gJKX63mqdTVV8+6QAC4iFQ+4/LMK+dW/8SuUuzZcfhl0E
         PD2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EVrcvfoDioxQkelS/mYR+VepRoHSAgaO7oE/svzUp3s=;
        b=Ih2yPl+4LZFv5jrAAs/B+BUkfsIpDPZt35VA4rh/Ur5ZWJWoK7awUDPgJOP43J/GYM
         EgV/h4wTBRADKNLgSvWnZJYvn9WoLtuK1XLl3BmkDTVOTQDL570kV1x6z9tAtzjRF6qT
         tjhtZAGOqjTy5iGlzPFhHVfR0tsBg3xwyTRy4EsyG7GhRc84plEbZWvNrTQ9aKIBjtgd
         +tDQleLPGRZL6Hp4okXHK9wAQjIS6NBmxmqTJ9myiZdk3zcEosw2oBYzZLi1bdhsVHB9
         kuH7hzdKdiEu7NYTyNusmYaB5O6FVorr7SAMXGfLRO5kJJY94FxS375yqIVO5zI0KfRK
         DloQ==
X-Gm-Message-State: AOAM531n3p1muEkY898Z9TkVVCZg6t0A9oS9q9PDQJL5jIP+uI5XPylr
        ankUB8p6tmpUEkPkr8UuRk9HERjH37w=
X-Google-Smtp-Source: ABdhPJy9acpj94NL6aq2ps3XxVjiC0OISmX1xjQE99/lpN29CY4J2iJY44nso3qlQWocn9O0ybPr8Q==
X-Received: by 2002:aca:1e15:: with SMTP id m21mr6404317oic.62.1615477681819;
        Thu, 11 Mar 2021 07:48:01 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.56])
        by smtp.googlemail.com with ESMTPSA id d1sm678517oth.13.2021.03.11.07.48.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Mar 2021 07:48:01 -0800 (PST)
Subject: Re: [PATCH net-next 05/14] nexthop: Add implementation of resilient
 next-hop groups
To:     Petr Machata <petrm@nvidia.com>, netdev@vger.kernel.org
Cc:     Ido Schimmel <idosch@nvidia.com>, David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <cover.1615387786.git.petrm@nvidia.com>
 <7a7d8a6578430dd47e303301e5506e40e0a8cc2b.1615387786.git.petrm@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c571f456-f9dc-73fa-cddb-a02ba54c03d7@gmail.com>
Date:   Thu, 11 Mar 2021 08:47:58 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <7a7d8a6578430dd47e303301e5506e40e0a8cc2b.1615387786.git.petrm@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/10/21 8:02 AM, Petr Machata wrote:
> At this moment, there is only one type of next-hop group: an mpath group,
> which implements the hash-threshold algorithm.
> 
> To select a next hop, hash-threshold algorithm first assigns a range of
> hashes to each next hop in the group, and then selects the next hop by
> comparing the SKB hash with the individual ranges. When a next hop is
> removed from the group, the ranges are recomputed, which leads to
> reassignment of parts of hash space from one next hop to another. While
> there will usually be some overlap between the previous and the new
> distribution, some traffic flows change the next hop that they resolve to.
> That causes problems e.g. as established TCP connections are reset, because
> the traffic is forwarded to a server that is not familiar with the
> connection.
> 
> Resilient hashing is a technique to address the above problem. Resilient
> next-hop group has another layer of indirection between the group itself
> and its constituent next hops: a hash table. The selection algorithm uses a
> straightforward modulo operation to choose a hash bucket, and then reads
> the next hop that this bucket contains, and forwards traffic there.
> 
> This indirection brings an important feature. In the hash-threshold
> algorithm, the range of hashes associated with a next hop must be
> continuous. With a hash table, mapping between the hash table buckets and
> the individual next hops is arbitrary. Therefore when a next hop is deleted
> the buckets that held it are simply reassigned to other next hops. When
> weights of next hops in a group are altered, it may be possible to choose a
> subset of buckets that are currently not used for forwarding traffic, and
> use those to satisfy the new next-hop distribution demands, keeping the
> "busy" buckets intact. This way, established flows are ideally kept being
> forwarded to the same endpoints through the same paths as before the
> next-hop group change.
> 
> In a nutshell, the algorithm works as follows. Each next hop has a number
> of buckets that it wants to have, according to its weight and the number of
> buckets in the hash table. In case of an event that might cause bucket
> allocation change, the numbers for individual next hops are updated,
> similarly to how ranges are updated for mpath group next hops. Following
> that, a new "upkeep" algorithm runs, and for idle buckets that belong to a
> next hop that is currently occupying more buckets than it wants (it is
> "overweight"), it migrates the buckets to one of the next hops that has
> fewer buckets than it wants (it is "underweight"). If, after this, there
> are still underweight next hops, another upkeep run is scheduled to a
> future time.
> 
> Chances are there are not enough "idle" buckets to satisfy the new demands.
> The algorithm has knobs to select both what it means for a bucket to be
> idle, and for whether and when to forcefully migrate buckets if there keeps
> being an insufficient number of idle buckets.
> 
> There are three users of the resilient data structures.
> 
> - The forwarding code accesses them under RCU, and does not modify them
>   except for updating the time a selected bucket was last used.
> 
> - Netlink code, running under RTNL, which may modify the data.
> 
> - The delayed upkeep code, which may modify the data. This runs unlocked,
>   and mutual exclusion between the RTNL code and the delayed upkeep is
>   maintained by canceling the delayed work synchronously before the RTNL
>   code touches anything. Later it restarts the delayed work if necessary.
> 
> The RTNL code has to implement next-hop group replacement, next hop
> removal, etc. For removal, the mpath code uses a neat trick of having a
> backup next hop group structure, doing the necessary changes offline, and
> then RCU-swapping them in. However, the hash tables for resilient hashing
> are about an order of magnitude larger than the groups themselves (the size
> might be e.g. 4K entries), and it was felt that keeping two of them is an
> overkill. Both the primary next-hop group and the spare therefore use the
> same resilient table, and writers are careful to keep all references valid
> for the forwarding code. The hash table references next-hop group entries
> from the next-hop group that is currently in the primary role (i.e. not
> spare). During the transition from primary to spare, the table references a
> mix of both the primary group and the spare. When a next hop is deleted,
> the corresponding buckets are not set to NULL, but instead marked as empty,
> so that the pointer is valid and can be used by the forwarding code. The
> buckets are then migrated to a new next-hop group entry during upkeep. The
> only times that the hash table is invalid is the very beginning and very
> end of its lifetime. Between those points, it is always kept valid.
> 
> This patch introduces the core support code itself. It does not handle
> notifications towards drivers, which are kept as if the group were an mpath
> one. It does not handle netlink either. The only bit currently exposed to
> user space is the new next-hop group type, and that is currently bounced.
> There is therefore no way to actually access this code.
> 
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> ---
> 

Thanks for the detailed documentation around exclusion expectations.

Reviewed-by: David Ahern <dsahern@kernel.org>


