Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 163BA56B8EE
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 13:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238101AbiGHLuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 07:50:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238036AbiGHLuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 07:50:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41E61951EB;
        Fri,  8 Jul 2022 04:50:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E849DB8260F;
        Fri,  8 Jul 2022 11:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 99097C341C6;
        Fri,  8 Jul 2022 11:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657281015;
        bh=nKFRnI+qALnsmOp08E2u0eqpSS7GSFw5iOH6b23gX2Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NaqCqu2GFUhdUplRVuVVP7s2+Zjk4SV86thNmRGM47CJfsa8aV/hMsUDQnMODOiJJ
         qLywkqS4XxJJVcRUIIBYOpORFKZ7HgoeoZjzsh9bUj7ID6NPUh1fBVhFM4SYN189Nh
         BgqHpE0viGWAo9zi4JYM7eSz/ORbobLY4Y4Kbb+AYj+5OhmXzF9JD3+FB4oJO/+znv
         F/uxXIIlHUuVduFQmuJu5+7Y+1/gsdBvq2R6H3+feAVADafB+31bir8BTJm6XIZ2vi
         5HdLy0W68gQCXtS4pefD/lpPNt+dIl1EqibSabIK4NEoplkXPNmswWd+AP85qwOt73
         pdviKb/C9TO8Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7B13CE45BDB;
        Fri,  8 Jul 2022 11:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net 00/12] sysctl: Fix data-races around ipv4_table.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165728101550.21070.5217821052702542560.git-patchwork-notify@kernel.org>
Date:   Fri, 08 Jul 2022 11:50:15 +0000
References: <20220706234003.66760-1-kuniyu@amazon.com>
In-Reply-To: <20220706234003.66760-1-kuniyu@amazon.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mcgrof@kernel.org, keescook@chromium.org,
        yzaikin@google.com, kuni1840@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 6 Jul 2022 16:39:51 -0700 you wrote:
> A sysctl variable is accessed concurrently, and there is always a chance
> of data-race.  So, all readers and writers need some basic protection to
> avoid load/store-tearing.
> 
> The first half of this series changes some proc handlers used in ipv4_table
> to use READ_ONCE() and WRITE_ONCE() internally to fix data-races on the
> sysctl side.  Then, the second half adds READ_ONCE() to the other readers
> of ipv4_table.
> 
> [...]

Here is the summary with links:
  - [v2,net,01/12] sysctl: Fix data races in proc_dointvec().
    https://git.kernel.org/netdev/net/c/1f1be04b4d48
  - [v2,net,02/12] sysctl: Fix data races in proc_douintvec().
    https://git.kernel.org/netdev/net/c/4762b532ec95
  - [v2,net,03/12] sysctl: Fix data races in proc_dointvec_minmax().
    https://git.kernel.org/netdev/net/c/f613d86d014b
  - [v2,net,04/12] sysctl: Fix data races in proc_douintvec_minmax().
    https://git.kernel.org/netdev/net/c/2d3b559df3ed
  - [v2,net,05/12] sysctl: Fix data races in proc_doulongvec_minmax().
    https://git.kernel.org/netdev/net/c/c31bcc8fb89f
  - [v2,net,06/12] sysctl: Fix data races in proc_dointvec_jiffies().
    https://git.kernel.org/netdev/net/c/e87782087766
  - [v2,net,07/12] tcp: Fix a data-race around sysctl_tcp_max_orphans.
    https://git.kernel.org/netdev/net/c/47e6ab24e8c6
  - [v2,net,08/12] inetpeer: Fix data-races around sysctl.
    https://git.kernel.org/netdev/net/c/3d32edf1f3c3
  - [v2,net,09/12] net: Fix data-races around sysctl_mem.
    https://git.kernel.org/netdev/net/c/310731e2f161
  - [v2,net,10/12] cipso: Fix data-races around sysctl.
    https://git.kernel.org/netdev/net/c/dd44f04b9214
  - [v2,net,11/12] icmp: Fix data-races around sysctl.
    https://git.kernel.org/netdev/net/c/48d7ee321ea5
  - [v2,net,12/12] ipv4: Fix a data-race around sysctl_fib_sync_mem.
    https://git.kernel.org/netdev/net/c/73318c4b7dbd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


