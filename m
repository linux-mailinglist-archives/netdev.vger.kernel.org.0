Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF071648D0B
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 05:00:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbiLJEAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 23:00:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbiLJEAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 23:00:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 293D057B53;
        Fri,  9 Dec 2022 20:00:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D512FB82A4B;
        Sat, 10 Dec 2022 04:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 78931C433EF;
        Sat, 10 Dec 2022 04:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670644818;
        bh=Rz+P4SaGHSIpmQsi3KIQXlPIq5hb6Gs+1inK2v4ojnI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mVRc8GNEm3ThZgLn47sVD2FOsXz5OhPQcQagxoFEqhhaxT+/zxO723gzOqpLKhFvr
         xwsHbsZW/+vf2aafWyVXqsIu5kx2Ts5cyw7S+hzfkiodTa+hTArFWIOG9SXqKR/gzW
         8gj/j3HwVwLz98tOtFjF+mg7Fk5AQJvFNwz/TAAxKRlvUD2j1Nk8u5OWTRTC5ecMzP
         onfyGfdpRywRkKy+jjd8QePbW4e9vxT/nzrMLLHUH2RwPTxghDSK1fmYDzN/hGpFS+
         9wSi/0B8xHd4JadPgcWEskDaYcAKCoJjtHAoOJLIyApA4lor6kn8HIhiwkc6TcjUzG
         OGBUIaIzb6wFw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 41E41C41606;
        Sat, 10 Dec 2022 04:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3] skbuff: Introduce slab_build_skb()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167064481825.12189.4717731779203655380.git-patchwork-notify@kernel.org>
Date:   Sat, 10 Dec 2022 04:00:18 +0000
References: <20221208060256.give.994-kees@kernel.org>
In-Reply-To: <20221208060256.give.994-kees@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     kuba@kernel.org,
        syzbot+fda18eaa8c12534ccb3b@syzkaller.appspotmail.com,
        edumazet@google.com, davem@davemloft.net, pabeni@redhat.com,
        asml.silence@gmail.com, soopthegoop@gmail.com, vbabka@suse.cz,
        kasan-dev@googlegroups.com, andrii@kernel.org, ast@kernel.org,
        bpf@vger.kernel.org, daniel@iogearbox.net, haoluo@google.com,
        hawk@kernel.org, john.fastabend@gmail.com, jolsa@kernel.org,
        kpsingh@kernel.org, martin.lau@linux.dev, sdf@google.com,
        song@kernel.org, yhs@fb.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rmody@marvell.com,
        aelior@marvell.com, manishc@marvell.com, imagedong@tencent.com,
        dsahern@kernel.org, richardbgobert@gmail.com, andreyknvl@gmail.com,
        rientjes@google.com, GR-Linux-NIC-Dev@marvell.com,
        linux-hardening@vger.kernel.org
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
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  7 Dec 2022 22:02:59 -0800 you wrote:
> syzkaller reported:
> 
>   BUG: KASAN: slab-out-of-bounds in __build_skb_around+0x235/0x340 net/core/skbuff.c:294
>   Write of size 32 at addr ffff88802aa172c0 by task syz-executor413/5295
> 
> For bpf_prog_test_run_skb(), which uses a kmalloc()ed buffer passed to
> build_skb().
> 
> [...]

Here is the summary with links:
  - [net-next,v3] skbuff: Introduce slab_build_skb()
    https://git.kernel.org/netdev/net-next/c/ce098da1497c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


