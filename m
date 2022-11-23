Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A86C634F4C
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 06:00:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbiKWFA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 00:00:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234981AbiKWFAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 00:00:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB6DCE6354;
        Tue, 22 Nov 2022 21:00:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 87A0561A5F;
        Wed, 23 Nov 2022 05:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D626BC43146;
        Wed, 23 Nov 2022 05:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669179619;
        bh=CnHc7+jbn2qgmCvOyGqLN+4jUi8M4EVLFEEnfqxa0JA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IcJl4+xKxYQtIzBFhOqsogDfFXppx6z76+UUzm7lOMa7rm1C2Ha/brQvxeYqgfays
         UnIxY0WSjaGQYLlsQ3PevSFeNARUR7JR9yHbmFSWzcTPoVmmg9C31z64VXVVp/hcNC
         U26Y1k21F97XuJxThGOytfCG75XryED4AquWCikuRJWhqe8L7mOB+yI45fzFzg+UCn
         4fqS1eZrC4k5SroQZudSzrZTHBzlQsogMoAkxwIc64F/MLfYm92nhaL59fiVxQ6ffl
         TAOkLxlngLSL+0AZLxMFsIS643n0fdCflrZmuh5W7IwGK51TUU/O3xxANgJSyix29O
         XM8jk4G8yqr9w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B38AEE29F42;
        Wed, 23 Nov 2022 05:00:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4 net 0/4] dccp/tcp: Fix bhash2 issues related to WARN_ON()
 in inet_csk_get_port().
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166917961972.4515.12267352129449341755.git-patchwork-notify@kernel.org>
Date:   Wed, 23 Nov 2022 05:00:19 +0000
References: <20221119014914.31792-1-kuniyu@amazon.com>
In-Reply-To: <20221119014914.31792-1-kuniyu@amazon.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        acme@mandriva.com, joannelkoong@gmail.com, martin.lau@kernel.org,
        mathew.j.martineau@linux.intel.com, william.xuanziyang@huawei.com,
        stephen@networkplumber.org, pengfei.xu@intel.com,
        kuni1840@gmail.com, netdev@vger.kernel.org, dccp@vger.kernel.org
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

On Fri, 18 Nov 2022 17:49:10 -0800 you wrote:
> syzkaller was hitting a WARN_ON() in inet_csk_get_port() in the 4th patch,
> which was because we forgot to fix up bhash2 bucket when connect() for a
> socket bound to a wildcard address fails in __inet_stream_connect().
> 
> There was a similar report [0], but its repro does not fire the WARN_ON() due
> to inconsistent error handling.
> 
> [...]

Here is the summary with links:
  - [v4,net,1/4] dccp/tcp: Reset saddr on failure after inet6?_hash_connect().
    https://git.kernel.org/netdev/net/c/77934dc6db0d
  - [v4,net,2/4] dccp/tcp: Remove NULL check for prev_saddr in inet_bhash2_update_saddr().
    https://git.kernel.org/netdev/net/c/8acdad37cd13
  - [v4,net,3/4] dccp/tcp: Update saddr under bhash's lock.
    https://git.kernel.org/netdev/net/c/8c5dae4c1a49
  - [v4,net,4/4] dccp/tcp: Fixup bhash2 bucket when connect() fails.
    https://git.kernel.org/netdev/net/c/e0833d1fedb0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


