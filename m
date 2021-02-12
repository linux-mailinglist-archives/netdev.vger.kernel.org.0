Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5881331984B
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 03:23:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbhBLCUu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 21:20:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:47376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229575AbhBLCUt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Feb 2021 21:20:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 858FA64E56;
        Fri, 12 Feb 2021 02:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613096408;
        bh=0qOGiLQcI0MhLlgeIpswMqKVFF1HrYtTGCTj9nVrkCg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=myo77rAv1pJhDfxgoRfXa9rfU/+avmWKtrYtbw1gleAapFQyol08E6i9+NXubjpBR
         hbA0pKT/ys4A8Tz7NQfPahcbG6cOaiQc/kv+NgL2Ou4JtN9NUT0RrPCn4sccyQOxCj
         bNvY2X2m/KGvzsYzRgQWDg25Lf9cQh5EuHvB/+ENXflqTrfIIBjN+75gJJBfspEZxs
         MDRMDCvjp3L7sxIukor8EGSjyRwxK5XXIoErc7EgQfvtBqIXl7LS+WZAq60sMj4ndp
         3L7oSqfw7DeRmACeGD4Ec6osYg2uTbF/jF4g0n00+Kep3LKSAmQvdH2m3gsbyP/rl5
         ft4uyfXVtirvQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 786F660951;
        Fri, 12 Feb 2021 02:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [Patch net-next v3] net: fix dev_ifsioc_locked() race condition
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161309640848.12988.7029386535147942032.git-patchwork-notify@kernel.org>
Date:   Fri, 12 Feb 2021 02:20:08 +0000
References: <20210211193410.172700-1-xiyou.wangcong@gmail.com>
In-Reply-To: <20210211193410.172700-1-xiyou.wangcong@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, cong.wang@bytedance.com,
        sishuai@purdue.edu, eric.dumazet@gmail.com, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 11 Feb 2021 11:34:10 -0800 you wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> dev_ifsioc_locked() is called with only RCU read lock, so when
> there is a parallel writer changing the mac address, it could
> get a partially updated mac address, as shown below:
> 
> Thread 1			Thread 2
> // eth_commit_mac_addr_change()
> memcpy(dev->dev_addr, addr->sa_data, ETH_ALEN);
> 				// dev_ifsioc_locked()
> 				memcpy(ifr->ifr_hwaddr.sa_data,
> 					dev->dev_addr,...);
> 
> [...]

Here is the summary with links:
  - [net-next,v3] net: fix dev_ifsioc_locked() race condition
    https://git.kernel.org/netdev/net-next/c/3b23a32a6321

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


