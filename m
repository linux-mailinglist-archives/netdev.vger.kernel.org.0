Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5247C62F51B
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 13:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241849AbiKRMkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 07:40:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241733AbiKRMkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 07:40:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B351E1571C;
        Fri, 18 Nov 2022 04:40:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 681CBB823B8;
        Fri, 18 Nov 2022 12:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1DD05C43146;
        Fri, 18 Nov 2022 12:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668775217;
        bh=LPBFgSKFD5AdIjqnCkO6K97ysfnR29SoQ+jLLCp5Hmk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qlqk32OhujQDCJJQHtkS+7oVHuc5WnnBANZkbwTnbMrSnlFa9uRruq/HD6kbKBk9S
         Hii5uzRir5+O2aXpqQtAEpW3jvwpnTDEizkgCjdaBWfuW4PmS+HHVbqrDi6eWSv6WK
         XGY2zBDZY5goUVCLfifAnPz4abgRYhAN5DRvhK+D3uu3lbRkcVezufg1Xo/xsec9pS
         1k75RGQgqYRjPIHfbSnvKihX1QatnjardAIrDsIUbTeZMCOKdNiwxamCwCWiolc2Dq
         MK6pTxuX9SdWvQQGxGgyWARV8mxSICVX/SObD0+RaojdSX2vnaiVxN6Z/FDkK1pm0B
         QRpNSnhOnKOJQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0885FE29F44;
        Fri, 18 Nov 2022 12:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] mrp: introduce active flags to prevent UAF when applicant
 uninit
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166877521703.4012.15281131262381117062.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Nov 2022 12:40:17 +0000
References: <20221116114511.7720-1-schspa@gmail.com>
In-Reply-To: <20221116114511.7720-1-schspa@gmail.com>
To:     Schspa Shi <schspa@gmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, Jason@zx2c4.com, djwong@kernel.org,
        jack@suse.cz, hca@linux.ibm.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+6fd64001c20aa99e34a4@syzkaller.appspotmail.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 16 Nov 2022 19:45:11 +0800 you wrote:
> The caller of del_timer_sync must prevent restarting of the timer, If
> we have no this synchronization, there is a small probability that the
> cancellation will not be successful.
> 
> And syzbot report the fellowing crash:
> ==================================================================
> BUG: KASAN: use-after-free in hlist_add_head include/linux/list.h:929 [inline]
> BUG: KASAN: use-after-free in enqueue_timer+0x18/0xa4 kernel/time/timer.c:605
> Write at addr f9ff000024df6058 by task syz-fuzzer/2256
> Pointer tag: [f9], memory tag: [fe]
> 
> [...]

Here is the summary with links:
  - mrp: introduce active flags to prevent UAF when applicant uninit
    https://git.kernel.org/netdev/net-next/c/ab0377803daf

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


