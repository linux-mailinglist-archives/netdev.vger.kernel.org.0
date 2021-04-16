Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36B15362B99
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 00:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232618AbhDPWuf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 18:50:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:53932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230489AbhDPWuf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 18:50:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D4BD26137D;
        Fri, 16 Apr 2021 22:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618613409;
        bh=dbeNpTnbu7Ue4m+KfAjUNHO3r6I1R6du9rAi3SDujho=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HaQtcFmAm9FdHznBHOSsgjZcsAnu9NqLn6TlldwaXOLtx6oHqr67Iqxp3BMqAWAsc
         UurWMGSd104Qzgy3v4Blr0YGa7ddkGLz7xl0rd3UAmDjwOjfi+Tj1xz8mbew5C0w21
         dG+jfG8qJPxeEjR6PS/xNJ/5tZNmQDRPrQboshK9WzBSbqqGwIjHTtQ6ea7d1Opbm7
         h7JuSDOoMJ7Lt8Zt6QyTI2QmKx5bDgcZBIlwQMGXz2rW95WwQn67fFzlp4ii9WxEp+
         F5kMuchZEaTYbLbU6aCmumtHP8OUocSF9Cor4dXjOBgWq0AP8hImT/c85/LToVgaTV
         fxIF8lgCK6hYA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CAAA660CDF;
        Fri, 16 Apr 2021 22:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] mld: fix suspicious RCU usage in __ipv6_dev_mc_dec()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161861340982.29090.2285538599646945503.git-patchwork-notify@kernel.org>
Date:   Fri, 16 Apr 2021 22:50:09 +0000
References: <20210416141606.24029-1-ap420073@gmail.com>
In-Reply-To: <20210416141606.24029-1-ap420073@gmail.com>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        dsahern@kernel.org, yoshfuji@linux-ipv6.org, edumazet@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 16 Apr 2021 14:16:06 +0000 you wrote:
> __ipv6_dev_mc_dec() internally uses sleepable functions so that caller
> must not acquire atomic locks. But caller, which is addrconf_verify_rtnl()
> acquires rcu_read_lock_bh().
> So this warning occurs in the __ipv6_dev_mc_dec().
> 
> Test commands:
>     ip netns add A
>     ip link add veth0 type veth peer name veth1
>     ip link set veth1 netns A
>     ip link set veth0 up
>     ip netns exec A ip link set veth1 up
>     ip a a 2001:db8::1/64 dev veth0 valid_lft 2 preferred_lft 1
> 
> [...]

Here is the summary with links:
  - [net-next] mld: fix suspicious RCU usage in __ipv6_dev_mc_dec()
    https://git.kernel.org/netdev/net-next/c/aa8caa767e31

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


