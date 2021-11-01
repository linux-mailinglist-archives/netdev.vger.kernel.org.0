Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11F1D441B9F
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 14:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232296AbhKANWm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 09:22:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:50274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232050AbhKANWl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Nov 2021 09:22:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 06C3160FE8;
        Mon,  1 Nov 2021 13:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635772808;
        bh=ygVFoIUzzoC+VhpFooAh0MBeNPLJ7LT2upj5IUVrV7A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RDxOxk1Sog/bss1aP3Z0/VZEClY6L2iACOUUu05NKJMpTGrd81hSjw38mFFvJGNwF
         hsjgkXEZzYqUKpo8y4YZeu98VUQ/TBQccnvZPawVF6zzjj32wClnQMVB0/8MMgt/C7
         /7eT16BOpOKiWOik21s3pbmIGdu99lORMjnvbFYVXeUauerPcR6X9vu8FM9OENLfmD
         oiNSohxMTFXcpRnk478Q8ZvfObACM3yWIPC9Ib8TnyhbeWSiXEGipm5neJx9SKMWyo
         75a+r1nqa2GJEtg4/23StzwzTjGS9Io+0/QSd7vPFjAI29jd8/mA3CEK+QpfUovNF5
         HARfYLmIXM7Dw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EF4CB609B9;
        Mon,  1 Nov 2021 13:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/3] ibmvnic: don't stop queue in xmit
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163577280797.31246.172894097034323578.git-patchwork-notify@kernel.org>
Date:   Mon, 01 Nov 2021 13:20:07 +0000
References: <20211029220316.2003519-1-sukadev@linux.ibm.com>
In-Reply-To: <20211029220316.2003519-1-sukadev@linux.ibm.com>
To:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc:     netdev@vger.kernel.org, brking@linux.ibm.com, drt@linux.ibm.com,
        abdhalee@in.ibm.com, vaish123@in.ibm.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 29 Oct 2021 15:03:14 -0700 you wrote:
> If adapter's resetting bit is on, discard the packet but don't stop the
> transmit queue - instead leave that to the reset code. With this change,
> it is possible that we may get several calls to ibmvnic_xmit() that simply
> discard packets and return.
> 
> But if we stop the queue here, we might end up doing so just after
> __ibmvnic_open() started the queues (during a hard/soft reset) and before
> the ->resetting bit was cleared. If that happens, there will be no one to
> restart queue and transmissions will be blocked indefinitely.
> 
> [...]

Here is the summary with links:
  - [net,1/3] ibmvnic: don't stop queue in xmit
    https://git.kernel.org/netdev/net/c/8878e46fcfd4
  - [net,2/3] ibmvnic: Process crqs after enabling interrupts
    https://git.kernel.org/netdev/net/c/6e20d00158f3
  - [net,3/3] ibmvnic: delay complete()
    https://git.kernel.org/netdev/net/c/6b278c0cb378

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


