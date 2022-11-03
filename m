Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF3F6174B3
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 04:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbiKCDAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 23:00:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbiKCDAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 23:00:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6D2E13F86;
        Wed,  2 Nov 2022 20:00:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C1B37B82611;
        Thu,  3 Nov 2022 03:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5A021C433C1;
        Thu,  3 Nov 2022 03:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667444417;
        bh=S4igLbgxh3XNuAlk/q7S38LHWO7DyG+7OcqbV9YpJ6c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VzAs23HAgIfl6zXz0reY8bo94WKM4r00o8vDROQFaftH0nLUyYS2h8N1XFO9jA0+M
         66K27/7Nm6/UU5UJhKJgjESnZg3e1E4OzU3llRsq4ZtyO+5SwoAmyOULoVGaze/H3t
         qqlG8yb8At96YN/Vc6rtAEyNiQkWkgixTtBAcquPl+wrS56e5JfYeW31CU1zP4GTKQ
         OTikAtZX8GYKpDTErlMYI3hIHV35ml6SAMQgN88JlwMslCwNcDyTa0442sbsd1K9P+
         4Gf+zNlItZXfOLTlGyLqczoORR+BbCrQV/ekMnB2g1Rld4EsqZz6mAb/omJ7sWpb13
         jeA0kzuu3UgpQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3BA4EC395FF;
        Thu,  3 Nov 2022 03:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/7] netfilter: nf_tables: netlink notifier might race to
 release objects
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166744441724.18046.4557814101769741140.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Nov 2022 03:00:17 +0000
References: <20221102184659.2502-2-pablo@netfilter.org>
In-Reply-To: <20221102184659.2502-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Wed,  2 Nov 2022 19:46:53 +0100 you wrote:
> commit release path is invoked via call_rcu and it runs lockless to
> release the objects after rcu grace period. The netlink notifier handler
> might win race to remove objects that the transaction context is still
> referencing from the commit release path.
> 
> Call rcu_barrier() to ensure pending rcu callbacks run to completion
> if the list of transactions to be destroyed is not empty.
> 
> [...]

Here is the summary with links:
  - [net,1/7] netfilter: nf_tables: netlink notifier might race to release objects
    https://git.kernel.org/netdev/net/c/d4bc8271db21
  - [net,2/7] netfilter: nf_tables: release flow rule object from commit path
    https://git.kernel.org/netdev/net/c/26b5934ff419
  - [net,3/7] ipvs: use explicitly signed chars
    https://git.kernel.org/netdev/net/c/5c26159c97b3
  - [net,4/7] ipvs: fix WARNING in __ip_vs_cleanup_batch()
    https://git.kernel.org/netdev/net/c/3d00c6a0da8d
  - [net,5/7] ipvs: fix WARNING in ip_vs_app_net_cleanup()
    https://git.kernel.org/netdev/net/c/5663ed63adb9
  - [net,6/7] netfilter: nf_nat: Fix possible memory leak in nf_nat_init()
    https://git.kernel.org/netdev/net/c/cbc1dd5b659f
  - [net,7/7] netfilter: ipset: enforce documented limit to prevent allocating huge memory
    https://git.kernel.org/netdev/net/c/510841da1fcc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


