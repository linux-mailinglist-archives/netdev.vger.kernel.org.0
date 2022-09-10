Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FBEE5B4AD1
	for <lists+netdev@lfdr.de>; Sun, 11 Sep 2022 01:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbiIJXUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Sep 2022 19:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiIJXUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Sep 2022 19:20:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55C0F1FCC8;
        Sat, 10 Sep 2022 16:20:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C6195B8091F;
        Sat, 10 Sep 2022 23:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7DACDC433C1;
        Sat, 10 Sep 2022 23:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662852014;
        bh=KDT7WPDlyok+RU2cmq9/Ekd4+tmfgAu0On+qHzJZJ3w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hC+260x9O+O1j9aSlEhoho1+u1Nq2Rom+EXeHWKIiqMyCuGMwu/MHX4iIVqZMkJgS
         Jw51jesu49//qQR/boWLj4MBIMcXu2hF88x714DddBp8UQzJjI85yNQSrkXcFJArib
         UBi9IA6W0xV3fd5NVJgbSmUyfTflqp1shQA8mmsDajrmjZBqt4JBru4/3WGA18Gydh
         9tmSgnIC0euYMcWy4EYPP+0rYCEiG2eDoq/z7VriQp7+Kp8zOst8g4rG8jZz3sx1IB
         /2GQVMl1GNlMPv89ICXImGNe8mDM1mz4M4jiLD597OGiy5dxXysNimgpyeXAZ9bgJs
         jpiKmzxLtI9Jw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 62399C73FF0;
        Sat, 10 Sep 2022 23:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] bpf: add missing percpu_counter_destroy() in htab_map_alloc()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166285201439.18848.5095971070838643208.git-patchwork-notify@kernel.org>
Date:   Sat, 10 Sep 2022 23:20:14 +0000
References: <e2e4cc0e-9d36-4ca1-9bfa-ce23e6f8310b@I-love.SAKURA.ne.jp>
In-Reply-To: <e2e4cc0e-9d36-4ca1-9bfa-ce23e6f8310b@I-love.SAKURA.ne.jp>
To:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        memxor@gmail.com,
        syzbot+5d1da78b375c3b5e6c2b@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Alexei Starovoitov <ast@kernel.org>:

On Sun, 11 Sep 2022 00:07:11 +0900 you wrote:
> syzbot is reporting ODEBUG bug in htab_map_alloc() [1], for
> commit 86fe28f7692d96d2 ("bpf: Optimize element count in non-preallocated
> hash map.") added percpu_counter_init() to htab_map_alloc() but forgot to
> add percpu_counter_destroy() to the error path.
> 
> Link: https://syzkaller.appspot.com/bug?extid=5d1da78b375c3b5e6c2b [1]
> Reported-by: syzbot <syzbot+5d1da78b375c3b5e6c2b@syzkaller.appspotmail.com>
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Fixes: 86fe28f7692d96d2 ("bpf: Optimize element count in non-preallocated hash map.")
> 
> [...]

Here is the summary with links:
  - bpf: add missing percpu_counter_destroy() in htab_map_alloc()
    https://git.kernel.org/bpf/bpf-next/c/cf7de6a53600

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


