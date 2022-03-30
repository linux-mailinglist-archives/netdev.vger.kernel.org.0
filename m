Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0287A4EC5A5
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 15:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346057AbiC3Nb7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 09:31:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346036AbiC3Nb5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 09:31:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA6A62126E;
        Wed, 30 Mar 2022 06:30:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3BCEF60F1F;
        Wed, 30 Mar 2022 13:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 94F2EC34112;
        Wed, 30 Mar 2022 13:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648647011;
        bh=cU8FjeWxOjskSz09ATG64xR2J22qjPfKR5JAlqWFTsU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oIazSJ8dJkTweVSaLD7gv52wfnAvgvMuz1q8BPkHFCO0roeMMghRjdBSgte27H1iO
         e/2VMnIw3AY/86nhOPPmWKEzPffyyeidH6grDO99f7YnyW3OQpMp7P1vvGJEIaDqaG
         GZtcTuSZnes1DtTe33oLC8HnFlPFTOo+AQB7D5Dak4do8vuyeZDWtGOjzTmsG2pCNN
         fw7d2MU90Hib43+nKL6Os1iemRSqoS3V6WBIV84lo92nIiAmRJYEKMrf5nkmYlhL/u
         /IR0TA12HQolm1HwmlRlAVzqzMnvWcmKZsBYXhCu3hgkKiJVsyRC2YRkQwPZcwQj//
         a6TbmvGDnkRRg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7624FF0384B;
        Wed, 30 Mar 2022 13:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] bpf: Fix sparse warnings in kprobe_multi_resolve_syms
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164864701147.1602.6890084343658807023.git-patchwork-notify@kernel.org>
Date:   Wed, 30 Mar 2022 13:30:11 +0000
References: <20220330110510.398558-1-jolsa@kernel.org>
In-Reply-To: <20220330110510.398558-1-jolsa@kernel.org>
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@chromium.org
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

This patch was applied to bpf/bpf.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Wed, 30 Mar 2022 13:05:10 +0200 you wrote:
> Adding missing __user tags to fix sparse warnings:
> 
> kernel/trace/bpf_trace.c:2370:34: warning: incorrect type in argument 2 (different address spaces)
> kernel/trace/bpf_trace.c:2370:34:    expected void const [noderef] __user *from
> kernel/trace/bpf_trace.c:2370:34:    got void const *usyms
> kernel/trace/bpf_trace.c:2376:51: warning: incorrect type in argument 2 (different address spaces)
> kernel/trace/bpf_trace.c:2376:51:    expected char const [noderef] __user *src
> kernel/trace/bpf_trace.c:2376:51:    got char const *
> kernel/trace/bpf_trace.c:2443:49: warning: incorrect type in argument 1 (different address spaces)
> kernel/trace/bpf_trace.c:2443:49:    expected void const *usyms
> kernel/trace/bpf_trace.c:2443:49:    got void [noderef] __user *[assigned] usyms
> 
> [...]

Here is the summary with links:
  - bpf: Fix sparse warnings in kprobe_multi_resolve_syms
    https://git.kernel.org/bpf/bpf/c/d31e0386a2f1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


