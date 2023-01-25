Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BCB267AA26
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 07:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232306AbjAYGAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 01:00:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbjAYGAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 01:00:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 602E82CFDC;
        Tue, 24 Jan 2023 22:00:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 180FDB818B2;
        Wed, 25 Jan 2023 06:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B5654C4339B;
        Wed, 25 Jan 2023 06:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674626417;
        bh=pPaPHTFJKkUju7jhoEnCIPJXpXCtFQn0wXZj1P0Q/wM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aaVDFpwoASUsfZm0NEj8JAPiujzsI8SrjrxoOvGRlZyI6MriMXLxnO6qVCCLGkL4W
         IHXA0XWnn75zuPcul/5QqQ9rLb/0bz7nbqFzWohbE3PXx6EYA1icvwzle0PXF7pVFt
         ULppA0Ydyna0j8Xg5NlYwXcGh9dsuDbMgQmTfDBqCXczENhRp0pYLfKgFk0spyZbbX
         A3Fio/rTYPzQFtmEQf/bYQ7Ol3BTV0tG/yKoJcqYdc5zuH4WNTW/upweRqeZtVvGR0
         7rUZwpQv3prwcriftJtIJE25hK3u7d9PetPPn/kVKD9Yw+pKcwcZnmITnnrx1mHwjd
         MC7kJzZOsHnNw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9807FE52507;
        Wed, 25 Jan 2023 06:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf v2 0/4] bpf, sockmap: Fix infinite recursion in
 sock_map_close
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167462641761.6291.18360402728308632393.git-patchwork-notify@kernel.org>
Date:   Wed, 25 Jan 2023 06:00:17 +0000
References: <20230113-sockmap-fix-v2-0-1e0ee7ac2f90@cloudflare.com>
In-Reply-To: <20230113-sockmap-fix-v2-0-1e0ee7ac2f90@cloudflare.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        john.fastabend@gmail.com, edumazet@google.com,
        daniel@iogearbox.net, ast@kernel.org, andrii@kernel.org,
        kernel-team@cloudflare.com,
        syzbot+04c21ed96d861dccc5cd@syzkaller.appspotmail.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf.git (master)
by Alexei Starovoitov <ast@kernel.org>:

On Sat, 21 Jan 2023 13:41:42 +0100 you wrote:
> This patch set addresses the syzbot report in [1].
> 
> Patch #1 has been suggested by Eric [2]. I extended it to cover the rest of
> sock_map proto callbacks. Otherwise we would still overflow the stack.
> 
> Patch #2 contains the actual fix and bug analysis.
> Patches #3 & #4 add coverage to selftests to trigger the bug.
> 
> [...]

Here is the summary with links:
  - [bpf,v2,1/4] bpf, sockmap: Don't let sock_map_{close,destroy,unhash} call itself
    https://git.kernel.org/bpf/bpf/c/5b4a79ba65a1
  - [bpf,v2,2/4] bpf, sockmap: Check for any of tcp_bpf_prots when cloning a listener
    https://git.kernel.org/bpf/bpf/c/ddce1e091757
  - [bpf,v2,3/4] selftests/bpf: Pass BPF skeleton to sockmap_listen ops tests
    https://git.kernel.org/bpf/bpf/c/b4ea530d024c
  - [bpf,v2,4/4] selftests/bpf: Cover listener cloning with progs attached to sockmap
    https://git.kernel.org/bpf/bpf/c/c88ea16a8f89

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


