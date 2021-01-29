Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA09D308438
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 04:25:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231837AbhA2DZS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 22:25:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231267AbhA2DZQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 22:25:16 -0500
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BD47C061573
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 19:24:36 -0800 (PST)
Received: by mail-oi1-x232.google.com with SMTP id m13so8444333oig.8
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 19:24:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xJyz9GLu55wMb2KgFpnqvZ4kqTgEtFRl32fku0xP6VE=;
        b=Y1BFE1E840MKP8lBrEzu0RoqJAk1aB1f8RoXmzsTe4fMiFsxLK7RCBpkdyUk7shA0Y
         mr2IOcUVmQmPjJWx+ztUk5BFhruW+52chWdoZl50UNVx1YkgoAOERIrsgi3WWb4LGyh3
         CEGsZtx7DEAg3MstHAAZfNZiSvB0/r7foYg3fQi3phAmXIUBHbj50sfY+5sYnqV6uvC4
         sPqahJKUjQYLsv/Xi07rJb+xtdzg6l77SMFTX7OGfNQnHvtaHrxHs6TA18AAHn8VLXBw
         GKo074cV1Mb+id5EDofq6d75O18wQzgIzfOZL1PcRm/bhEMIJ0IF41Jw6XFrFnFCd419
         YAeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xJyz9GLu55wMb2KgFpnqvZ4kqTgEtFRl32fku0xP6VE=;
        b=EWyWv8cueDAtkaSauW1W2sIQAbsvBBODOZZwdauWFun0LcTQp5aSFBGcxzH0bySEpg
         WbjjkYDhlPCOyHQkWZdr1wK1YLDtYgJNmHfFxIZfnPHE2pFvaPb5eWj30yB98M1iNUi5
         txVMUDkkejtrOkMwNeInUGG9jxKeWr77tj7Lvr7A9I18OJnhnEVUvgtt0hi1AXYuhv1z
         pxVSlC8s5UeOst3Z4LicS8ptg9kJ085v3JUFGzXsxNQTYBQ5E7yAqx5sg/ORXo4Yw3Ko
         PJjSOUz+FQy7yKTSZcbVkP2VYp45jUiOnt+2WfCc3Bw+kcAk1Uy1su4XobbvolbWAbUy
         o3Gw==
X-Gm-Message-State: AOAM530yB5fAhmhOrtfOvKAcL7YRu/BvM1JQCYD2kNvmLGlghkXg1bdr
        eRuJXBPPeC7/HrDfu3E2PoY=
X-Google-Smtp-Source: ABdhPJxhV1Lh2bEPy6sq3Dy3yDLsyV3YxvHnUeZv4EkPsvJbZKsuhZLhG4LRjIdQlhxBfKqaKoavGA==
X-Received: by 2002:a05:6808:57d:: with SMTP id j29mr1571792oig.146.1611890675644;
        Thu, 28 Jan 2021 19:24:35 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.50])
        by smtp.googlemail.com with ESMTPSA id r5sm1732001otd.24.2021.01.28.19.24.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jan 2021 19:24:35 -0800 (PST)
Subject: Re: [PATCH net-next 00/12] nexthop: Preparations for resilient
 next-hop groups
To:     Petr Machata <petrm@nvidia.com>, netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>
References: <cover.1611836479.git.petrm@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <3ee4c868-0bd4-6df2-aaef-07efed2812f6@gmail.com>
Date:   Thu, 28 Jan 2021 20:24:33 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <cover.1611836479.git.petrm@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/28/21 5:49 AM, Petr Machata wrote:
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
> the way causes the packets to arrive in wrong order.
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
> This patchset prepares the next-hop code for eventual introduction of
> resilient hashing groups.
> 
> - Patches #1-#4 carry otherwise disjoint changes that just remove certain
>   assumptions in the next-hop code.
> 
> - Patches #5-#6 extend the in-kernel next-hop notifiers to support more
>   next-hop group types.
> 
> - Patches #7-#12 refactor RTNL message handlers. Resilient next-hop groups
>   will introduce a new logical object, a hash table bucket. It turns out
>   that handling bucket-related messages is similar to how next-hop messages
>   are handled. These patches extract the commonalities into reusable
>   components.
> 
> The plan is to contribute approximately the following patchsets:
> 
> 1) Nexthop policy refactoring (already pushed)
> 2) Preparations for resilient next hop groups (this patchset)
> 3) Implementation of resilient next hop group
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

Very easy to review patchset. Thank you for that and for this cover
letter with the end goal and progress.


