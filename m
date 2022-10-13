Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94CD05FD2FF
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 03:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbiJMBuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 21:50:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbiJMBuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 21:50:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F5E480EA4;
        Wed, 12 Oct 2022 18:50:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2B29B81CF1;
        Thu, 13 Oct 2022 01:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7F86BC43470;
        Thu, 13 Oct 2022 01:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665625816;
        bh=PK1s4cxUqts5AeDNQ7eW9QlS2H93nn0uajqp5uvVlNI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AOajDPheEH8OB7APqbhi5Tt+b/EIgMPHQ9xJWnYITsUYSqVxNAfxujyd3oNH/xfEw
         8xbGdzRsI02llgCEKo6BwWyG9a/p6AsVbGMyKhzHr7CaeKCrHD3F/k6usfP/pceRBm
         meH5EbXB9XsZzpxFdweU+Ndh+Rf0UZHNgf3qnuDdAYiPxalHM8M5Zj/hiiIy1ucdFP
         PqPhkIO5f4S5Uokj8yuWfwL+fgd3YczQZSIflIn7fIT9hv7nq7SyFKfm0I4AMhzR14
         m0fGRoUK3SflzpSo1Ynol1N4tKIFJydSen1ILHZaR5GzaSZysiP3J7hW0n4dS1OI9U
         FZTD+kWDybyrg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 63247E29F37;
        Thu, 13 Oct 2022 01:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v5 net 0/5] tcp/udp: Fix memory leaks and data races around
 IPV6_ADDRFORM.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166562581640.26155.8354911889872528624.git-patchwork-notify@kernel.org>
Date:   Thu, 13 Oct 2022 01:50:16 +0000
References: <20221006185349.74777-1-kuniyu@amazon.com>
In-Reply-To: <20221006185349.74777-1-kuniyu@amazon.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, dsahern@kernel.org, yoshfuji@linux-ipv6.org,
        kuni1840@gmail.com, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 6 Oct 2022 11:53:44 -0700 you wrote:
> This series fixes some memory leaks and data races caused in the
> same scenario where one thread converts an IPv6 socket into IPv4
> with IPV6_ADDRFORM and another accesses the socket concurrently.
> 
> 
> Changes:
>   v5:
>     * Patch 1 & 5
>       * Rebase and resolve conflicts with 24426654ed3a and 34704ef024ae
> 
> [...]

Here is the summary with links:
  - [v5,net,1/5] tcp/udp: Fix memory leak in ipv6_renew_options().
    https://git.kernel.org/netdev/net/c/3c52c6bb831f
  - [v5,net,2/5] udp: Call inet6_destroy_sock() in setsockopt(IPV6_ADDRFORM).
    https://git.kernel.org/netdev/net/c/21985f43376c
  - [v5,net,3/5] tcp/udp: Call inet6_destroy_sock() in IPv6 sk->sk_destruct().
    https://git.kernel.org/netdev/net/c/d38afeec26ed
  - [v5,net,4/5] ipv6: Fix data races around sk->sk_prot.
    https://git.kernel.org/netdev/net/c/364f997b5cfe
  - [v5,net,5/5] tcp: Fix data races around icsk->icsk_af_ops.
    https://git.kernel.org/netdev/net/c/f49cd2f4d617

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


