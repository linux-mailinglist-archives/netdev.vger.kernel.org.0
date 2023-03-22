Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4A286C423C
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 06:40:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbjCVFkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 01:40:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbjCVFkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 01:40:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C859D12855
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 22:40:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6F473B81B5B
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 05:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0D8ACC4339B;
        Wed, 22 Mar 2023 05:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679463619;
        bh=Be2plHDAC8wXQh6A+X607TnvD9n4jWY/Ubn3JXpAAlk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dWDf6X2o7j10CIsW9BRq5/XAfCm18zJ5Ri/46V0daJkau0H/eLAk2IEPN7/yPYc98
         7vHeyMPj1PVVlFAJSal8FXl9xN0AdD2kYgdbf+gVKXvRjQ7qEAhDXOlxyAoLa+sRFg
         Zog/xhrb9syQblPh38/rG7+KS/SSuV62TAk5u6nhkTPDldvrVtSYmWlHU6vlcOuCgj
         v19KbnGo3M87CVK7ysSXqp4cALYtPoil1z03+hY4BhNmzfIiX0klPR2hbdoYRKtfCm
         9YVVUe69GgVGV3xj4X0UlmwpkDSuPoN7GH4hwmcFbghpxp1NeGPzz3YL8xTXFhqzhh
         rurRX/HTohrnw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E3ACBE4F0D7;
        Wed, 22 Mar 2023 05:40:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] net: remove some rcu_bh cruft
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167946361892.17510.15632019270276603427.git-patchwork-notify@kernel.org>
Date:   Wed, 22 Mar 2023 05:40:18 +0000
References: <20230321040115.787497-1-edumazet@google.com>
In-Reply-To: <20230321040115.787497-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        dsahern@kernel.org, netdev@vger.kernel.org, eric.dumazet@gmail.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 21 Mar 2023 04:01:12 +0000 you wrote:
> There is no point using rcu_bh variant hoping to free objects faster,
> especially hen using call_rcu() or kfree_rcu().
> 
> Disabling/enabling BH has a non-zero cost, and adds distracting
> hot spots in kernel profilesm eg in ip6_xmit().
> 
> Eric Dumazet (3):
>   ipv6: flowlabel: do not disable BH where not needed
>   neighbour: switch to standard rcu, instead of rcu_bh
>   net: remove rcu_dereference_bh_rtnl()
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] ipv6: flowlabel: do not disable BH where not needed
    https://git.kernel.org/netdev/net-next/c/4c5c496a942f
  - [net-next,2/3] neighbour: switch to standard rcu, instead of rcu_bh
    https://git.kernel.org/netdev/net-next/c/09eed1192cec
  - [net-next,3/3] net: remove rcu_dereference_bh_rtnl()
    https://git.kernel.org/netdev/net-next/c/fe602c87df1b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


