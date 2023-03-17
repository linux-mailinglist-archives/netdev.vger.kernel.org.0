Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 414846BE264
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 09:00:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231256AbjCQIA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 04:00:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231251AbjCQIA0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 04:00:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3622C3FB9C
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 01:00:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7F49AB823F2
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 08:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 34EFAC4339C;
        Fri, 17 Mar 2023 08:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679040019;
        bh=G4j3Zf+PUQ4bYvP3w/jOD4mX/9F9UNQtvhM7Xmi+8ZA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DEdz68A0fwZ5XsNoBVWsBBiwdcUiPkkvrjocBzn6/dQn9zpsqLRWUscNfQKQoI7NN
         TY1N6RTNY2qylNQxNq1gP+2Cx2VQAA7LMms0d49d783jEa+HGbpDTYOfGqqBsPoj+e
         HHujGYV9qdXBusAhmrmX3Ph3r8k/dhPvSGs+fRKBypHxPFUBK1jtjAHqU52MLh4hhT
         0w/sh3nPQeUuyGJyQKQq9f2pFyn4Ju2+i/wkzfsmyucp0VQoMNZNfXVxhwyuaWuND1
         FrGXPfIV7Y7WZ4Iqew+/MjthxwmUYQkOzWoptfVypQODQS3IS6SQCQzx+SaszgNlPh
         t2+yLx3NhRX8w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EE374E2A03A;
        Fri, 17 Mar 2023 08:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3 0/3] bonding: properly restore flags when bond changes
 ether type
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167904001897.28626.16406389949123155790.git-patchwork-notify@kernel.org>
Date:   Fri, 17 Mar 2023 08:00:18 +0000
References: <20230315111842.1589296-1-razor@blackwall.org>
In-Reply-To: <20230315111842.1589296-1-razor@blackwall.org>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, monis@voltaire.com, syoshida@redhat.com,
        j.vosburgh@gmail.com, andy@greyhouse.net, kuba@kernel.org,
        davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        syzbot+9dfc3f3348729cc82277@syzkaller.appspotmail.com,
        michal.kubiak@intel.com, jtoppins@redhat.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Wed, 15 Mar 2023 13:18:39 +0200 you wrote:
> Hi,
> A bug was reported by syzbot[1] that causes a warning and a myriad of
> other potential issues if a bond, that is also a slave, fails to enslave a
> non-eth device. While fixing that bug I found that we have the same
> issues when such enslave passes and after that the bond changes back to
> ARPHRD_ETHER (again due to ether_setup). This set fixes all issues by
> extracting the ether_setup() sequence in a helper which does the right
> thing about bond flags when it needs to change back to ARPHRD_ETHER. It
> also adds selftests for these cases.
> 
> [...]

Here is the summary with links:
  - [net,v3,1/3] bonding: restore IFF_MASTER/SLAVE flags on bond enslave ether type change
    https://git.kernel.org/netdev/net/c/9ec7eb60dcbc
  - [net,v3,2/3] bonding: restore bond's IFF_SLAVE flag if a non-eth dev enslave fails
    https://git.kernel.org/netdev/net/c/e667d4690986
  - [net,v3,3/3] selftests: bonding: add tests for ether type changes
    https://git.kernel.org/netdev/net/c/222c94ec0ad4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


