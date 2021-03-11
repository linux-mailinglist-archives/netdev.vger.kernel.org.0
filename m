Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A53C337935
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 17:23:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234518AbhCKQXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 11:23:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234176AbhCKQWn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 11:22:43 -0500
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0854EC061574
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 08:22:42 -0800 (PST)
Received: by mail-ot1-x330.google.com with SMTP id e45so1981553ote.9
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 08:22:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/kQMMsL/eN6O1+/rkEHB6BTJY6up4bhWJevAIlEFo0k=;
        b=U62nC2E98B/CzF2p9ABI8jF6aJCkMV74n+tpw+VOJKDnqRfg7aLKHK9Xyj+ZOna4L4
         L6WfnCXNgsblMUetIV19yzGloC7TQjqW2Bhq666oewAKf76Gg7xeUPV1XS+QZB32eP02
         xOcOyo79F+CH6ggII6xEGNVSYeBm+JxGg+BdeIylSNyaOUSvpzw0d9tiFkrpn2/EwLcS
         lk08eRs5rMKlLRkkoh7LzH3d6g+dXgOh9hG/iDH6dON+xxEm1S/d2W0/HnUJ6utIyEh6
         0HHbgHcOSLmE4iV0bN3F+cQLaKQqREiY6oxiFBm1k8k6q8nAUJDebA7MtvkDzvQJGTcq
         hFHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/kQMMsL/eN6O1+/rkEHB6BTJY6up4bhWJevAIlEFo0k=;
        b=SOeqrmPr0Eip+k7rQzMl1PalzJws/rv6rgof95wsaPIKhir7ulRfAsA/ix9JplWaEH
         6srL1/F3i4+hDOEYPpTw8vctnBPqc7IPxuKFwU63ngrWepwLKyTlxgYBA6rHGSXZZ5AN
         B0hrpmFFQitFMw8ZF8X6TeqO/QqXfyaCtQURmUBCEK8/dEVeQ/lW2GG28W7TpyeS2SnO
         xQ96WbDKqYYmYp9WabA+rhPO6RpE8IGXqbktoV27frpGWLc+VJHWPlU+espfjENV1X5i
         8iuFLnsIkCbmj8yF2zZZCdlzMgXkK+x+Wt1DCj7vEJWIWVP5nkWR3AJAnT5fTH1OiFew
         cwoQ==
X-Gm-Message-State: AOAM533qRtVNhlzvepf2KuyPkcDOKDt4MIVgABoTXWgJvd0z3EbYz1RO
        71a78R3RmTebYa9sZCrEsX9cHIdkt1M=
X-Google-Smtp-Source: ABdhPJwB+rH/NsGJNab02ViQkTxWqgJd9m750vlJL79NAx1Yh8DZ8jrcIczn8dCZHZEWOe8jbblkWQ==
X-Received: by 2002:a05:6830:57a:: with SMTP id f26mr7341344otc.70.1615479762218;
        Thu, 11 Mar 2021 08:22:42 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.56])
        by smtp.googlemail.com with ESMTPSA id a6sm740396otq.79.2021.03.11.08.22.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Mar 2021 08:22:41 -0800 (PST)
Subject: Re: [PATCH net-next 00/14] nexthop: Resilient next-hop groups
To:     Petr Machata <petrm@nvidia.com>, netdev@vger.kernel.org
Cc:     Ido Schimmel <idosch@nvidia.com>, David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <cover.1615387786.git.petrm@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <a9f40a79-4ec2-69ae-1663-20c261084dbf@gmail.com>
Date:   Thu, 11 Mar 2021 09:22:38 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <cover.1615387786.git.petrm@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/10/21 8:02 AM, Petr Machata wrote:
> At this moment, there is only one type of next-hop group: an mpath group.
> Mpath groups implement the hash-threshold algorithm, described in RFC
> 2992[1].
> 
> To select a next hop, hash-threshold algorithm first assigns a range of
> hashes to each next hop in the group, and then selects the next hop by
> comparing the SKB hash with the individual ranges. When a next hop is
> removed from the group, the ranges are recomputed, which leads to
> reassignment of parts of hash space from one next hop to another. RFC 2992
> illustrates it thus:
> 
>              +-------+-------+-------+-------+-------+
>              |   1   |   2   |   3   |   4   |   5   |
>              +-------+-+-----+---+---+-----+-+-------+
>              |    1    |    2    |    4    |    5    |
>              +---------+---------+---------+---------+
> 
>               Before and after deletion of next hop 3
> 	      under the hash-threshold algorithm.
> 
> Note how next hop 2 gave up part of the hash space in favor of next hop 1,
> and 4 in favor of 5. While there will usually be some overlap between the
> previous and the new distribution, some traffic flows change the next hop
> that they resolve to.
> 
> If a multipath group is used for load-balancing between multiple servers,
> this hash space reassignment causes an issue that packets from a single
> flow suddenly end up arriving at a server that does not expect them, which
> may lead to TCP reset.
> 
> If a multipath group is used for load-balancing among available paths to
> the same server, the issue is that different latencies and reordering along
> the way causes the packets to arrive in the wrong order.
> 
> Resilient hashing is a technique to address the above problem. Resilient
> next-hop group has another layer of indirection between the group itself
> and its constituent next hops: a hash table. The selection algorithm uses a
> straightforward modulo operation on the SKB hash to choose a hash table
> bucket, then reads the next hop that this bucket contains, and forwards
> traffic there.
> 
> This indirection brings an important feature. In the hash-threshold
> algorithm, the range of hashes associated with a next hop must be
> continuous. With a hash table, mapping between the hash table buckets and
> the individual next hops is arbitrary. Therefore when a next hop is deleted
> the buckets that held it are simply reassigned to other next hops:
> 
>              +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
>              |1|1|1|1|2|2|2|2|3|3|3|3|4|4|4|4|5|5|5|5|
>              +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> 	                      v v v v
>              +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
>              |1|1|1|1|2|2|2|2|1|2|4|5|4|4|4|4|5|5|5|5|
>              +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> 
>               Before and after deletion of next hop 3
> 	      under the resilient hashing algorithm.
> 
> When weights of next hops in a group are altered, it may be possible to
> choose a subset of buckets that are currently not used for forwarding
> traffic, and use those to satisfy the new next-hop distribution demands,
> keeping the "busy" buckets intact. This way, established flows are ideally
> kept being forwarded to the same endpoints through the same paths as before
> the next-hop group change.
> 
> This patch set adds the implementation of resilient next-hop groups.
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
> being an insufficient number of idle ones.
> 
> To illustrate the usage, consider the following commands:
> 
>  # ip nexthop add id 1 via 192.0.2.2 dev dummy1
>  # ip nexthop add id 2 via 192.0.2.3 dev dummy1
>  # ip nexthop add id 10 group 1/2 type resilient \
> 	buckets 8 idle_timer 60 unbalanced_timer 300
> 
> The last command creates a resilient next-hop group. It will have 8
> buckets, each bucket will be considered idle when no traffic hits it for at
> least 60 seconds, and if the table remains out of balance for 300 seconds,
> it will be forcefully brought into balance.
> 
> If not present in netlink message, the idle timer defaults to 120 seconds,
> and there is no unbalanced timer, meaning the group may remain unbalanced
> indefinitely. The value of 120 is the default in Cumulus implementation of
> resilient next-hop groups. To a degree the default is arbitrary, the only
> value that certainly does not make sense is 0. Therefore going with an
> existing deployed implementation is reasonable.
> 
> Unbalanced time, i.e. how long since the last time that all nexthops had as
> many buckets as they should according to their weights, is reported when
> the group is dumped:
> 
>  # ip nexthop show id 10
>  id 10 group 1/2 type resilient buckets 8 idle_timer 60 unbalanced_timer 300 unbalanced_time 0
> 
> When replacing next hops or changing weights, if one does not specify some
> parameters, their value is left as it was:
> 
>  # ip nexthop replace id 10 group 1,2/2 type resilient
>  # ip nexthop show id 10
>  id 10 group 1,2/2 type resilient buckets 8 idle_timer 60 unbalanced_timer 300 unbalanced_time 0
> 
> It is also possible to do a dump of individual buckets (and now you know
> why there were only 8 of them in the example above):
> 
>  # ip nexthop bucket show id 10
>  id 10 index 0 idle_time 5.59 nhid 1
>  id 10 index 1 idle_time 5.59 nhid 1
>  id 10 index 2 idle_time 8.74 nhid 2
>  id 10 index 3 idle_time 8.74 nhid 2
>  id 10 index 4 idle_time 8.74 nhid 1
>  id 10 index 5 idle_time 8.74 nhid 1
>  id 10 index 6 idle_time 8.74 nhid 1
>  id 10 index 7 idle_time 8.74 nhid 1
> 
> Note the two buckets that have a shorter idle time. Those are the ones that
> were migrated after the nexthop replace command to satisfy the new demand
> that nexthop 1 be given 6 buckets instead of 4.
> 
> The patchset proceeds as follows:
> 
> - Patches #1 and #2 are small refactoring patches.
> 
> - Patch #3 adds a new flag to struct nh_group, is_multipath. This flag is
>   meant to be set for all nexthop groups that in general have several
>   nexthops from which they choose, and avoids a more expensive dispatch
>   based on reading several flags, one for each nexthop group type.
> 
> - Patch #4 contains defines of new UAPI attributes and the new next-hop
>   group type. At this point, the nexthop code is made to bounce the new
>   type. As the resilient hashing code is gradually added in the following
>   patch sets, it will remain dead. The last patch will make it accessible.
> 
>   This patch also adds a suite of new messages related to next hop buckets.
>   This approach was taken instead of overloading the information on the
>   existing RTM_{NEW,DEL,GET}NEXTHOP messages for the following reasons.
> 
>   First, a next-hop group can contain a large number of next-hop buckets
>   (4k is not unheard of). This imposes limits on the amount of information
>   that can be encoded for each next-hop bucket given a netlink message is
>   limited to 64k bytes.
> 
>   Second, while RTM_NEWNEXTHOPBUCKET is only used for notifications at this
>   point, in the future it can be extended to provide user space with
>   control over next-hop buckets configuration.
> 
> - Patch #5 contains the meat of the resilient next-hop group support.
> 
> - Patches #6 and #7 implement support for notifications towards the
>   drivers.
> 
> - Patch #8 adds an interface for the drivers to report resilient hash
>   table bucket activity. Drivers will be able to report through this
>   interface whether traffic is hitting a given bucket.
> 
> - Patch #9 adds an interface for the drivers to report whether a given
>   hash table bucket is offloaded or trapping traffic.
> 
> - In patches #10, #11, #12 and #13, UAPI is implemented. This includes all
>   the code necessary for creation of resilient groups, bucket dumping and
>   getting, and bucket migration notifications.
> 
> - In patch #14 the next-hop groups are finally made available.
> 
> The overall plan is to contribute approximately the following patchsets:
> 
> 1) Nexthop policy refactoring (already pushed)
> 2) Preparations for resilient next-hop groups (already pushed)
> 3) Implementation of resilient next-hop groups (this patchset)
> 4) Netdevsim offload plus a suite of selftests
> 5) Preparations for mlxsw offload of resilient next-hop groups
> 6) mlxsw offload including selftests
> 
> Interested parties can look at the current state of the code at [2] and
> [3].
> 
> [1] https://tools.ietf.org/html/rfc2992
> [2] https://github.com/idosch/linux/commits/submit/res_integ_v1
> [3] https://github.com/idosch/iproute2/commits/submit/res_v1
> 

well done and well documented. Thanks for the attention to detail there.

When you get to the end of the sets, it would be good to submit
documentation for resilient multipath under Documentation/networking

