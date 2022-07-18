Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9056357813C
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 13:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234587AbiGRLu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 07:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234589AbiGRLuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 07:50:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E6D022B34
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 04:50:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 12504B81221
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 11:50:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C80A9C341CA;
        Mon, 18 Jul 2022 11:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658145019;
        bh=Q/Q7IJ1y4C8w1jgisL+yIFMV74bUfMzbDLiS2SFRNsk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=C0hXPaqm8YBOFrm7bTJK0X0uUNgFETJCshSUmiDPuBYEfaWvsqF0DQehlcNYkM45P
         M4dGh11dCck9dpzSSUW4xg7/m9Sq9m2wfx3nfy5wtzp3updL40d2NwogFOTnuabBzB
         fABpBE9+vVBVFRGqIkk9Qh2HlkYOMYNqt23w6FWorVQKM4JYt27Vmxt2xj+UI4R0nV
         D2xBS4aFF7w3vVMlkdE54YbiIl2HuSopo+cY4r2W/N/CyyETXyExzC+4/VVhp4zlw4
         GG9HUDa1HcwqoxzR6CAKi6/x6Z9sDCu5ipCMLHwFT/ibXAgcphK/2c/kwCJjGBvMUh
         d8IvVDuTpEp+A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B1558E451AD;
        Mon, 18 Jul 2022 11:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v1 net 00/15] sysctl: Fix data-races around ipv4_net_table
 (Round 3).
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165814501872.27406.12746498576328156078.git-patchwork-notify@kernel.org>
Date:   Mon, 18 Jul 2022 11:50:18 +0000
References: <20220715171755.38497-1-kuniyu@amazon.com>
In-Reply-To: <20220715171755.38497-1-kuniyu@amazon.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, dsahern@kernel.org, kuni1840@gmail.com,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 15 Jul 2022 10:17:40 -0700 you wrote:
> This series fixes data-races around 21 knobs after
> igmp_link_local_mcast_reports in ipv4_net_table.
> 
> These 4 knobs are skipped because they are safe.
> 
>   - tcp_congestion_control: Safe with RCU and xchg().
>   - tcp_available_congestion_control: Read only.
>   - tcp_allowed_congestion_control: Safe with RCU and spinlock().
>   - tcp_fastopen_key: Safe with RCU and xchg()
> 
> [...]

Here is the summary with links:
  - [v1,net,01/15] igmp: Fix data-races around sysctl_igmp_llm_reports.
    https://git.kernel.org/netdev/net/c/f6da2267e711
  - [v1,net,02/15] igmp: Fix a data-race around sysctl_igmp_max_memberships.
    https://git.kernel.org/netdev/net/c/6305d821e3b9
  - [v1,net,03/15] igmp: Fix data-races around sysctl_igmp_max_msf.
    https://git.kernel.org/netdev/net/c/6ae0f2e55373
  - [v1,net,04/15] igmp: Fix data-races around sysctl_igmp_qrv.
    https://git.kernel.org/netdev/net/c/8ebcc62c738f
  - [v1,net,05/15] tcp: Fix data-races around keepalive sysctl knobs.
    https://git.kernel.org/netdev/net/c/f2f316e287e6
  - [v1,net,06/15] tcp: Fix data-races around sysctl_tcp_syn(ack)?_retries.
    https://git.kernel.org/netdev/net/c/20a3b1c0f603
  - [v1,net,07/15] tcp: Fix data-races around sysctl_tcp_syncookies.
    https://git.kernel.org/netdev/net/c/f2e383b5bb6b
  - [v1,net,08/15] tcp: Fix data-races around sysctl_tcp_migrate_req.
    https://git.kernel.org/netdev/net/c/4177f545895b
  - [v1,net,09/15] tcp: Fix data-races around sysctl_tcp_reordering.
    https://git.kernel.org/netdev/net/c/46778cd16e6a
  - [v1,net,10/15] tcp: Fix data-races around some timeout sysctl knobs.
    https://git.kernel.org/netdev/net/c/39e24435a776
  - [v1,net,11/15] tcp: Fix a data-race around sysctl_tcp_notsent_lowat.
    https://git.kernel.org/netdev/net/c/55be873695ed
  - [v1,net,12/15] tcp: Fix a data-race around sysctl_tcp_tw_reuse.
    https://git.kernel.org/netdev/net/c/cbfc6495586a
  - [v1,net,13/15] tcp: Fix data-races around sysctl_max_syn_backlog.
    https://git.kernel.org/netdev/net/c/79539f34743d
  - [v1,net,14/15] tcp: Fix data-races around sysctl_tcp_fastopen.
    https://git.kernel.org/netdev/net/c/5a54213318c4
  - [v1,net,15/15] tcp: Fix data-races around sysctl_tcp_fastopen_blackhole_timeout.
    https://git.kernel.org/netdev/net/c/021266ec640c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


