Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B23953084DD
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 06:11:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230389AbhA2FKz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 00:10:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:54292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229656AbhA2FKx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Jan 2021 00:10:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id A2F9164E02;
        Fri, 29 Jan 2021 05:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611897012;
        bh=NLW3ZL2CYEKKcmjyeQON4C3leGflZ6qZPF4PaQI61+A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Db16E/zuZfIcqp0HyVERPNKXaA2GYVOMhOK24/PJTFqm4A8Fp0qRch9ieA7hZq2lI
         VPjiEeVX7ytbjePzd94coX1gvaacL8zs+bWvcfUXoibyfJP8J28CjEHAgnKQjVA47G
         BFibhmPf70XGrS7os6h/yJjHS8Ibz+eljhPXUoHZYswCrourCp0bSGQRlyEDO4YOo9
         u5RSPye/6ULLpHD4VLksuSB1OB11yszBtspKLRzA5R+V3v4qvM57euJaUbNplkLQrV
         Z5UjZy8eUW9OcmuGsKlc1KgaTyPqIY+ilhzFV+sBaa6Vy7UbwEZYnrVwm14HMW/Pwt
         qSfXRM6doXOvg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8FE5E65324;
        Fri, 29 Jan 2021 05:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/12] nexthop: Preparations for resilient next-hop
 groups
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161189701258.6524.15386234021397362082.git-patchwork-notify@kernel.org>
Date:   Fri, 29 Jan 2021 05:10:12 +0000
References: <cover.1611836479.git.petrm@nvidia.com>
In-Reply-To: <cover.1611836479.git.petrm@nvidia.com>
To:     Petr Machata <petrm@nvidia.com>
Cc:     netdev@vger.kernel.org, dsahern@kernel.org, davem@davemloft.net,
        kuba@kernel.org, idosch@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 28 Jan 2021 13:49:12 +0100 you wrote:
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
> [...]

Here is the summary with links:
  - [net-next,01/12] nexthop: Rename nexthop_free_mpath
    https://git.kernel.org/netdev/net-next/c/5d1f0f09b5f0
  - [net-next,02/12] nexthop: Dispatch nexthop_select_path() by group type
    https://git.kernel.org/netdev/net-next/c/79bc55e3fee9
  - [net-next,03/12] nexthop: Introduce to struct nh_grp_entry a per-type union
    https://git.kernel.org/netdev/net-next/c/b9bae61be466
  - [net-next,04/12] nexthop: Assert the invariant that a NH group is of only one type
    https://git.kernel.org/netdev/net-next/c/720ccd9a7285
  - [net-next,05/12] nexthop: Use enum to encode notification type
    https://git.kernel.org/netdev/net-next/c/09ad6becf535
  - [net-next,06/12] nexthop: Dispatch notifier init()/fini() by group type
    https://git.kernel.org/netdev/net-next/c/da230501f2c9
  - [net-next,07/12] nexthop: Extract dump filtering parameters into a single structure
    https://git.kernel.org/netdev/net-next/c/56450ec6b7fc
  - [net-next,08/12] nexthop: Extract a common helper for parsing dump attributes
    https://git.kernel.org/netdev/net-next/c/b9ebea127661
  - [net-next,09/12] nexthop: Strongly-type context of rtm_dump_nexthop()
    https://git.kernel.org/netdev/net-next/c/a6fbbaa64c3b
  - [net-next,10/12] nexthop: Extract a helper for walking the next-hop tree
    https://git.kernel.org/netdev/net-next/c/cbee18071e72
  - [net-next,11/12] nexthop: Add a callback parameter to rtm_dump_walk_nexthops()
    https://git.kernel.org/netdev/net-next/c/e948217d258f
  - [net-next,12/12] nexthop: Extract a helper for validation of get/del RTNL requests
    https://git.kernel.org/netdev/net-next/c/0bccf8ed8aa6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


