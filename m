Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A91345FBAB
	for <lists+netdev@lfdr.de>; Sat, 27 Nov 2021 03:12:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347235AbhK0CP2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 21:15:28 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:43548 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241888AbhK0CN1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 21:13:27 -0500
Received: from mail.kernel.org (unknown [198.145.29.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90CCCB829ED
        for <netdev@vger.kernel.org>; Sat, 27 Nov 2021 02:10:12 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPS id DCA4060184;
        Sat, 27 Nov 2021 02:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637979010;
        bh=bUjYDEjiq/520OXGfinLN5sCMnuQsTk7d88spaPpB7w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NjEdxW1mTnBc2hnzmd21Q/MIZzbL6Xl4ydN8pLzO8l1F1Gd+Hv109vJPYRRYdcPLi
         cZcx+LaMmGDwaYLOMMhdnu1gjlC2yNOdyfiMt2oDxKg93hRofh7IMs+KJ9enDc7S8b
         ph1PyScJIwv2riFFlCKDbp6386suPLghONoQ5LkxKbvaLEgQsx2DfvEJGRHapynD8n
         F7/QPNuOfqCJcEJHBYaoCBbYwWJbcbeQ6LUk7y07DaNmlP82ynNTOL5ue6f4ssHBam
         i1HgoB50Ql4+th6EdkoB8tMvbh1CMyU6GEGEBtchL9QdDDeH6Uq+4bgTO9B7vNTYpp
         4dBhKaB3LAjlw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CB9FF60BC9;
        Sat, 27 Nov 2021 02:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net-next 00/13] af_unix: Replace unix_table_lock with
 per-hash locks.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163797901082.19531.11591663067037920330.git-patchwork-notify@kernel.org>
Date:   Sat, 27 Nov 2021 02:10:10 +0000
References: <20211124021431.48956-1-kuniyu@amazon.co.jp>
In-Reply-To: <20211124021431.48956-1-kuniyu@amazon.co.jp>
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Cc:     davem@davemloft.net, kuba@kernel.org, viro@zeniv.linux.org.uk,
        eric.dumazet@gmail.com, kuni1840@gmail.com, benh@amazon.com,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 24 Nov 2021 11:14:18 +0900 you wrote:
> The hash table of AF_UNIX sockets is protected by a single big lock,
> unix_table_lock.  This series replaces it with small per-hash locks.
> 
> 1st -  2nd : Misc refactoring
> 3rd -  8th : Separate BSD/abstract address logics
> 9th - 11th : Prep to save a hash in each socket
> 12th       : Replace the big lock
> 13th       : Speed up autobind()
> 
> [...]

Here is the summary with links:
  - [v3,net-next,01/13] af_unix: Use offsetof() instead of sizeof().
    https://git.kernel.org/netdev/net-next/c/755662ce78d1
  - [v3,net-next,02/13] af_unix: Pass struct sock to unix_autobind().
    https://git.kernel.org/netdev/net-next/c/f7ed31f4615f
  - [v3,net-next,03/13] af_unix: Factorise unix_find_other() based on address types.
    https://git.kernel.org/netdev/net-next/c/fa39ef0e4729
  - [v3,net-next,04/13] af_unix: Return an error as a pointer in unix_find_other().
    https://git.kernel.org/netdev/net-next/c/aed26f557bbc
  - [v3,net-next,05/13] af_unix: Cut unix_validate_addr() out of unix_mkname().
    https://git.kernel.org/netdev/net-next/c/b8a58aa6fccc
  - [v3,net-next,06/13] af_unix: Copy unix_mkname() into unix_find_(bsd|abstract)().
    https://git.kernel.org/netdev/net-next/c/d2d8c9fddb1c
  - [v3,net-next,07/13] af_unix: Remove unix_mkname().
    https://git.kernel.org/netdev/net-next/c/5c32a3ed64b4
  - [v3,net-next,08/13] af_unix: Allocate unix_address in unix_bind_(bsd|abstract)().
    https://git.kernel.org/netdev/net-next/c/12f21c49ad83
  - [v3,net-next,09/13] af_unix: Remove UNIX_ABSTRACT() macro and test sun_path[0] instead.
    https://git.kernel.org/netdev/net-next/c/5ce7ab4961a9
  - [v3,net-next,10/13] af_unix: Add helpers to calculate hashes.
    https://git.kernel.org/netdev/net-next/c/f452be496a5c
  - [v3,net-next,11/13] af_unix: Save hash in sk_hash.
    https://git.kernel.org/netdev/net-next/c/e6b4b873896f
  - [v3,net-next,12/13] af_unix: Replace the big lock with small locks.
    https://git.kernel.org/netdev/net-next/c/afd20b9290e1
  - [v3,net-next,13/13] af_unix: Relax race in unix_autobind().
    https://git.kernel.org/netdev/net-next/c/9acbc584c3a4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


