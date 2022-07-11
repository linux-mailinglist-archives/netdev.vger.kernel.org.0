Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA8E570A61
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 21:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231542AbiGKTKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 15:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbiGKTKQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 15:10:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3FD82AE02;
        Mon, 11 Jul 2022 12:10:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8092761557;
        Mon, 11 Jul 2022 19:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C589BC341CA;
        Mon, 11 Jul 2022 19:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657566614;
        bh=6D+2DpXoaKcspcgzrN+pNsncRNJULDzNOzPp8Ld7hoM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NFUmoYBnhmrc9WJYfGgXQmVg60YJU8zfdxGmpXVS8BAyhzXqV52AsUhq6dKG4E75o
         qBC5wDnfluq+3lR1PgH8SiKwFSa2ZnikoFXLeKDvAoeaWavJzUWfGgUyjP3ukAbhF0
         P+ZAa780luJ/AkeByfYJoZl3H/GqP59x7T9HDUibeQrTYLbHMIwFYYuM94LtK7tT0s
         BIfbjogxVwrH5NoizVwPCWDh406pi+TnNze9ybkBLZIaeXUGRU2Ih8TQsJhUmGk3JY
         oPrg88vcBcQNsi4Gb32JbOvqt6rVE8vN9d3gqAJzDkPIlaUHhB4W2s37jGymotWD0j
         aBWVHeZ31iSIg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9B3C7E45223;
        Mon, 11 Jul 2022 19:10:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v9 0/4] bpf trampoline for arm64
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165756661463.27404.16087446828795658696.git-patchwork-notify@kernel.org>
Date:   Mon, 11 Jul 2022 19:10:14 +0000
References: <20220711150823.2128542-1-xukuohai@huawei.com>
In-Reply-To: <20220711150823.2128542-1-xukuohai@huawei.com>
To:     Xu Kuohai <xukuohai@huawei.com>
Cc:     bpf@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        jean-philippe@linaro.org, will@kernel.org, kpsingh@kernel.org,
        mark.rutland@arm.com, catalin.marinas@arm.com,
        daniel@iogearbox.net, ast@kernel.org, andrii@kernel.org,
        zlim.lnx@gmail.com, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, john.fastabend@gmail.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, kuba@kernel.org, hawk@kernel.org,
        rmk+kernel@armlinux.org.uk, james.morse@arm.com,
        houtao1@huawei.com, wangborong@cdjrlc.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Mon, 11 Jul 2022 11:08:19 -0400 you wrote:
> This patchset introduces bpf trampoline on arm64. A bpf trampoline converts
> native calling convention to bpf calling convention and is used to implement
> various bpf features, such as fentry, fexit, fmod_ret and struct_ops.
> 
> The trampoline introduced does essentially the same thing as the bpf
> trampoline does on x86.
> 
> [...]

Here is the summary with links:
  - [bpf-next,v9,1/4] bpf: Remove is_valid_bpf_tramp_flags()
    https://git.kernel.org/bpf/bpf-next/c/535a57a7ffc0
  - [bpf-next,v9,2/4] arm64: Add LDR (literal) instruction
    https://git.kernel.org/bpf/bpf-next/c/f1e8a24ed2ca
  - [bpf-next,v9,3/4] bpf, arm64: Implement bpf_arch_text_poke() for arm64
    https://git.kernel.org/bpf/bpf-next/c/b2ad54e1533e
  - [bpf-next,v9,4/4] bpf, arm64: bpf trampoline for arm64
    https://git.kernel.org/bpf/bpf-next/c/efc9909fdce0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


