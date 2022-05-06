Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AD1D51CE0B
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 04:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351910AbiEFBYA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 21:24:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347738AbiEFBX4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 21:23:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E98219D;
        Thu,  5 May 2022 18:20:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 793B662018;
        Fri,  6 May 2022 01:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C94B1C385A4;
        Fri,  6 May 2022 01:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651800012;
        bh=Qhl/N+qbK22h+zLWoK1of85zPPO7o7EyYgwHNqqHCO8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fsb06PynXkuBvejMe/qIlAnqbucOMG9AAN2OKAijbMC3JYg3N+AAH7yar1GGl2Aty
         +cXonLAUBt15799WSbFPw0zIJaEGQ14AbtIdmxqGL4B6wTqI9XxsCbJOvo+XSVXQ8q
         hWbe8TDVQNg+72stlyQJTE+CoYU3CSqCLmnKyZS6WG6woOAmPz0EJcal+h+B2VnDAJ
         /VwbZOW299EvYVE/v41fIWPz5XADTjh9Gw3xZKRtepBUUvQY+hESQzsKXpE3cBHYJG
         THVU3YoE5wNWwaaazmn5RuU8XNg4i0YvLB3fJeU9KyVwjViP2mCFFzngdfTmqg38eZ
         /niae7/SDkyrQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A777CF03876;
        Fri,  6 May 2022 01:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: rds: use maybe_get_net() when acquiring refcount
 on TCP sockets
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165180001268.16316.132918877268340088.git-patchwork-notify@kernel.org>
Date:   Fri, 06 May 2022 01:20:12 +0000
References: <41d09faf-bc78-1a87-dfd1-c6d1b5984b61@I-love.SAKURA.ne.jp>
In-Reply-To: <41d09faf-bc78-1a87-dfd1-c6d1b5984b61@I-love.SAKURA.ne.jp>
To:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc:     edumazet@google.com, pabeni@redhat.com,
        patchwork-bot+netdevbpf@kernel.org, santosh.shilimkar@oracle.com,
        davem@davemloft.net, kuba@kernel.org,
        syzbot+694120e1002c117747ed@syzkaller.appspotmail.com,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        linux-rdma@vger.kernel.org
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 5 May 2022 10:53:53 +0900 you wrote:
> Eric Dumazet is reporting addition on 0 problem at rds_tcp_tune(), for
> delayed works queued in rds_wq might be invoked after a net namespace's
> refcount already reached 0.
> 
> Since rds_tcp_exit_net() from cleanup_net() calls flush_workqueue(rds_wq),
> it is guaranteed that we can instead use maybe_get_net() from delayed work
> functions until rds_tcp_exit_net() returns.
> 
> [...]

Here is the summary with links:
  - [net,v2] net: rds: use maybe_get_net() when acquiring refcount on TCP sockets
    https://git.kernel.org/netdev/net/c/6997fbd7a3da

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


