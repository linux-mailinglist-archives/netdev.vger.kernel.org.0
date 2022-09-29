Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49DC25EFB18
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 18:40:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235707AbiI2QkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 12:40:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235854AbiI2QkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 12:40:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 341843BC48;
        Thu, 29 Sep 2022 09:40:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C46C361F53;
        Thu, 29 Sep 2022 16:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1E272C433D6;
        Thu, 29 Sep 2022 16:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664469617;
        bh=YQX6FHarcS1X79StWM0OSs/gPzgguwYJmabxg1b2Sg8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AIqE52QrH6MBjdURuZbfCOBq3wpkLgNLP+cDK6Qe2hTHfsGIbwpuXEh8/IfC/n9KG
         uMy+QxDM8RsmW+1s93nE1KM5ybhODMMXWiAF3zFJA5Cpiaj+e4bJYFNWOuvkKq/FB3
         BFRjWNBeOz5WOxIB/ju3VxU/X7V9b6ceUFX4zZ4m1svLRxn4ysfz+h5WY6HC+P1zO+
         donS2bgfxztSrRmdsDO0sG6WQb49S4OZQNn6z6iNbGXNC+41ejCw6tkf5DCHWaYAhS
         M83Rskt8912G1AceStx/RJr+88Ox3EXAEretFPqLTHVYBaLS3P/VqVSAa/+f3bqNek
         mvCXOt3+DPJzQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E8515E4D018;
        Thu, 29 Sep 2022 16:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 bpf-next 0/5] bpf: Remove recursion check for struct_ops
 prog
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166446961694.21206.2321358464670286333.git-patchwork-notify@kernel.org>
Date:   Thu, 29 Sep 2022 16:40:16 +0000
References: <20220929070407.965581-1-martin.lau@linux.dev>
In-Reply-To: <20220929070407.965581-1-martin.lau@linux.dev>
To:     Martin KaFai Lau <martin.lau@linux.dev>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        andrii@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, pabeni@redhat.com,
        kernel-team@fb.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (master)
by Alexei Starovoitov <ast@kernel.org>:

On Thu, 29 Sep 2022 00:04:02 -0700 you wrote:
> From: Martin KaFai Lau <martin.lau@kernel.org>
> 
> The struct_ops is sharing the tracing-trampoline's enter/exit
> function which tracks prog->active to avoid recursion.  It turns
> out the struct_ops bpf prog will hit this prog->active and
> unnecessarily skipped running the struct_ops prog.  eg.  The
> '.ssthresh' may run in_task() and then interrupted by softirq
> that runs the same '.ssthresh'.
> 
> [...]

Here is the summary with links:
  - [v3,bpf-next,1/5] bpf: Add __bpf_prog_{enter,exit}_struct_ops for struct_ops trampoline
    https://git.kernel.org/bpf/bpf-next/c/64696c40d03c
  - [v3,bpf-next,2/5] bpf: Move the "cdg" tcp-cc check to the common sol_tcp_sockopt()
    https://git.kernel.org/bpf/bpf-next/c/37cfbe0bf2e8
  - [v3,bpf-next,3/5] bpf: Refactor bpf_setsockopt(TCP_CONGESTION) handling into another function
    https://git.kernel.org/bpf/bpf-next/c/1e7d217faa11
  - [v3,bpf-next,4/5] bpf: tcp: Stop bpf_setsockopt(TCP_CONGESTION) in init ops to recur itself
    https://git.kernel.org/bpf/bpf-next/c/061ff040710e
  - [v3,bpf-next,5/5] selftests/bpf: Check -EBUSY for the recurred bpf_setsockopt(TCP_CONGESTION)
    https://git.kernel.org/bpf/bpf-next/c/3411c5b6f8d6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


