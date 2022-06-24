Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5009559834
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 12:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbiFXKuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 06:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiFXKuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 06:50:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A54277053
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 03:50:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0BF9F621EA
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 10:50:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 49154C341CB;
        Fri, 24 Jun 2022 10:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656067820;
        bh=uWvok0BJbw7h9k3PH8HFqqK9geXxbkYmRpO9iQDMaf8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=S7f2dkMhvqg1FZfTcgoYPQu3N+bvGsBz92JGJDOnILg8xCeFJDvhZkvrijIHUEa56
         lh7UAJE5eHiPTimOCpfhk5Iaw1cEGR1N5E+dz4KEcLfLTxAaTvkT9o8bnX78mxsynx
         ZuhoZ8jq0zTjxro11lCJtrXrkMYhbFt3TjDrFFJXxdXFt8HlmcZQZGgOJOiyoszVa3
         LksyUN9WVOWmUDZSBm2VMKxk7f4xddTV12MRZUz3vo/s8y2ikyUvWT05NXX/2MbpEm
         dsHXXLTuFu21cGSAI+5Rgpm1M0f4hAhjU+dIx9fvBv579a+omFFW5iznODSEf/zyw8
         ssZS7tzZwjB1w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 28BDEE737F0;
        Fri, 24 Jun 2022 10:50:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 00/19] ipmr: get rid of rwlocks
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165606782016.15655.1274087026188806431.git-patchwork-notify@kernel.org>
Date:   Fri, 24 Jun 2022 10:50:20 +0000
References: <20220623043449.1217288-1-edumazet@google.com>
In-Reply-To: <20220623043449.1217288-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 23 Jun 2022 04:34:30 +0000 you wrote:
> We need to get rid of rwlocks in networking stacks,
> if read_lock() is (ab)used from softirq context.
> 
> As discussed recently [1], rwlock are unfair by design in this case,
> and writers can starve and trigger soft lockups.
> 
> This series convert ipmr code (both IPv4 and IPv6 families)
> to RCU and spinlocks.
> 
> [...]

Here is the summary with links:
  - [v2,net-next,01/19] ip6mr: do not get a device reference in pim6_rcv()
    https://git.kernel.org/netdev/net-next/c/0a24c43f54b2
  - [v2,net-next,02/19] ipmr: add rcu protection over (struct vif_device)->dev
    https://git.kernel.org/netdev/net-next/c/ebc3197963fc
  - [v2,net-next,03/19] ipmr: change igmpmsg_netlink_event() prototype
    https://git.kernel.org/netdev/net-next/c/0b490b51d226
  - [v2,net-next,04/19] ipmr: ipmr_cache_report() changes
    https://git.kernel.org/netdev/net-next/c/646679881a02
  - [v2,net-next,05/19] ipmr: do not acquire mrt_lock in __pim_rcv()
    https://git.kernel.org/netdev/net-next/c/121fefc669bf
  - [v2,net-next,06/19] ipmr: do not acquire mrt_lock in ioctl(SIOCGETVIFCNT)
    https://git.kernel.org/netdev/net-next/c/559260fd9d9a
  - [v2,net-next,07/19] ipmr: do not acquire mrt_lock before calling ipmr_cache_unresolved()
    https://git.kernel.org/netdev/net-next/c/9094db4b8004
  - [v2,net-next,08/19] ipmr: do not acquire mrt_lock while calling ip_mr_forward()
    https://git.kernel.org/netdev/net-next/c/4eadb88244d1
  - [v2,net-next,09/19] ipmr: do not acquire mrt_lock in ipmr_get_route()
    https://git.kernel.org/netdev/net-next/c/e4cd9868e8ec
  - [v2,net-next,10/19] ip6mr: ip6mr_cache_report() changes
    https://git.kernel.org/netdev/net-next/c/3493a5b730e5
  - [v2,net-next,11/19] ip6mr: do not acquire mrt_lock in pim6_rcv()
    https://git.kernel.org/netdev/net-next/c/6d08658736fc
  - [v2,net-next,12/19] ip6mr: do not acquire mrt_lock in ioctl(SIOCGETMIFCNT_IN6)
    https://git.kernel.org/netdev/net-next/c/638cf4a24a09
  - [v2,net-next,13/19] ip6mr: do not acquire mrt_lock before calling ip6mr_cache_unresolved
    https://git.kernel.org/netdev/net-next/c/db9eb7c8ae34
  - [v2,net-next,14/19] ip6mr: do not acquire mrt_lock while calling ip6_mr_forward()
    https://git.kernel.org/netdev/net-next/c/9b1c21d898fd
  - [v2,net-next,15/19] ip6mr: switch ip6mr_get_route() to rcu_read_lock()
    https://git.kernel.org/netdev/net-next/c/6fa40a290219
  - [v2,net-next,16/19] ipmr: adopt rcu_read_lock() in mr_dump()
    https://git.kernel.org/netdev/net-next/c/194366b28b83
  - [v2,net-next,17/19] ipmr: convert /proc handlers to rcu_read_lock()
    https://git.kernel.org/netdev/net-next/c/b96ef16d2f83
  - [v2,net-next,18/19] ipmr: convert mrt_lock to a spinlock
    https://git.kernel.org/netdev/net-next/c/3f55211ecf6a
  - [v2,net-next,19/19] ip6mr: convert mrt_lock to a spinlock
    https://git.kernel.org/netdev/net-next/c/a96f7a6a60b3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


