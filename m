Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65F5B3084AD
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 05:51:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231978AbhA2EvO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 23:51:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:52850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231950AbhA2Euz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 23:50:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 82FFB64E09;
        Fri, 29 Jan 2021 04:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611895813;
        bh=sk78cuyoUXNpruAdSPrP5rB1bE1JARdsiV+vb104iHI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tzktbR59cMTObviYLk4H3J4CELlYmZk3Gr45v98Wos4dYd+QimBgKc++4CbURNj4p
         nbvQ5Feeszp6kadvvckyCyq+PhkhG9fL7hbZp5184kGOIgyisZbOalp+Ep3tjWkAtr
         hn+MH/qPM1A7DqzRqVpOFKxEIu3PTAKWf/cQKdKE2gCYpq4wgvyt+wwwEKhUkuYZhy
         PhbT4OlE/d+QkfG3iQ4Vj8WOEDG9ZkEAcg3fSnYauWjfZN2aG6ufmy0Xemxao8vdu7
         HizXXooHzVze1pP/OK7If6hkIB5NwrbqwqmrWsrRR6Qqyhwb/EXtoW82tUwtqK8UGa
         L/ICOcTB8sqJQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 72AFD65328;
        Fri, 29 Jan 2021 04:50:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next V1] net: adjust net_device layout for cacheline usage
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161189581346.32508.3530556174555491097.git-patchwork-notify@kernel.org>
Date:   Fri, 29 Jan 2021 04:50:13 +0000
References: <161168277983.410784.12401225493601624417.stgit@firesoul>
In-Reply-To: <161168277983.410784.12401225493601624417.stgit@firesoul>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     dsahern@gmail.com, netdev@vger.kernel.org, kuba@kernel.org,
        davem@davemloft.net, bpf@vger.kernel.org, eric.dumazet@gmail.com,
        borkmann@iogearbox.net, alexei.starovoitov@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 26 Jan 2021 18:39:39 +0100 you wrote:
> The current layout of net_device is not optimal for cacheline usage.
> 
> The member adj_list.lower linked list is split between cacheline 2 and 3.
> The ifindex is placed together with stats (struct net_device_stats),
> although most modern drivers don't update this stats member.
> 
> The members netdev_ops, mtu and hard_header_len are placed on three
> different cachelines. These members are accessed for XDP redirect into
> devmap, which were noticeably with perf tool. When not using the map
> redirect variant (like TC-BPF does), then ifindex is also used, which is
> placed on a separate fourth cacheline. These members are also accessed
> during forwarding with regular network stack. The members priv_flags and
> flags are on fast-path for network stack transmit path in __dev_queue_xmit
> (currently located together with mtu cacheline).
> 
> [...]

Here is the summary with links:
  - [net-next,V1] net: adjust net_device layout for cacheline usage
    https://git.kernel.org/netdev/net-next/c/28af22c6c8df

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


