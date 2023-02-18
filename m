Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2CA069B792
	for <lists+netdev@lfdr.de>; Sat, 18 Feb 2023 02:50:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbjBRBuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 20:50:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjBRBuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 20:50:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F03DA6BDC7
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 17:50:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 89151620B5
        for <netdev@vger.kernel.org>; Sat, 18 Feb 2023 01:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E35C8C433A0;
        Sat, 18 Feb 2023 01:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676685017;
        bh=162xYcEU/ZozEdOdflnzyIKYiUdXY9BtOP3Zwh5wy+0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=U9fU1xpX8CIeXA7Mrp1UGPkwXHBpUzLbhO7g4qSTPQ7itjo7DF1tG5aYXKJHL4FvU
         hPIv199jwPovt9My56O1s/2qpOikLN8nm2Lm/SAxOkPG3UBaN6IGxQ6gOm+YdOSkX3
         BV45Z6IwXqskKaV8mGW//XY9XxxJmMf1YCwn+3KkiALZquPPyLLTKdIXamNLr+flno
         5ze17tHjOcMK56EpyEBOnItFUZAVUNZB0d7YFRwCU0UFDhK7YMK6WQuIDoFUFUhRbj
         E1xCYv46Sh4p/PZL8JT8xH7ol5TNfZTfjyZA75j+0/e2hQusJtDkS9D2Y0dB/HccP5
         FGxsPaWFNFy+g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CE679E49FA6;
        Sat, 18 Feb 2023 01:50:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ip: fix UB in strncpy (e.g. truncated ip route output)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167668501783.31159.4836986808159241082.git-patchwork-notify@kernel.org>
Date:   Sat, 18 Feb 2023 01:50:17 +0000
References: <20230213032631.143810-1-sam@gentoo.org>
In-Reply-To: <20230213032631.143810-1-sam@gentoo.org>
To:     Sam James <sam@gentoo.org>
Cc:     dwfreed@mtu.edu, freswa@archlinux.org, netdev@vger.kernel.org,
        stephen@networkplumber.org, toolchain@gentoo.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2.git (main)
by Stephen Hemminger <stephen@networkplumber.org>:

On Mon, 13 Feb 2023 03:26:31 +0000 you wrote:
> Fix overlapping buffers passed to strncpy which is UB. format_host_rta_r writes
> to the buffer passed to it, so hostname (derived from b1) & b1 partly overlap.
> 
> This gets worse with sys-libs/glibc-2.37 where the ip route output can be truncated,
> but it was UB anyway and you can see it occurring w/ glibc-2.36.
> 
> Bug: https://lore.kernel.org/netdev/0011AC38-4823-4D0A-8580-B108D08959C2@gentoo.org/T/#u
> Bug: https://sourceware.org/bugzilla/show_bug.cgi?id=30112
> Thanks-to: Doug Freed <dwfreed@mtu.edu>
> Signed-off-by: Sam James <sam@gentoo.org>
> 
> [...]

Here is the summary with links:
  - ip: fix UB in strncpy (e.g. truncated ip route output)
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=890c599ec2e8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


