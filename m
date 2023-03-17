Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3B796BE09D
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 06:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbjCQFaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 01:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbjCQFaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 01:30:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAEC5B4F65;
        Thu, 16 Mar 2023 22:30:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 47381B82456;
        Fri, 17 Mar 2023 05:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EF324C4339B;
        Fri, 17 Mar 2023 05:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679031018;
        bh=/4VzzEaFSwxdD/HqTzC1bjLRMF6ZN+02kIc3xzCx3r8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tFJfUScRg13o8LAXcYXFzG4gV4Yz1J0NjDsOkNhBBaSsxtFI75fX5KppVvyNXUGkt
         GlA9L5I722XRS6xwCMH1tnEumhI/tUaadb0utb/nk8JbqzRyzahXfbT1hQIMoEudDt
         UJclDiZMd8Mh7IwXMQkZxXYVeK6owwoHh4HLNI4/6ZCBlxxJfECoDELeuh7e9bYEKN
         kf6g+y322AWxtfMSD6qLeWx4g2IhieD5KSlTDupYJmUEFxL64Pfg6V2y4JvTiG7FBf
         DO49Hi3bklGoYAcwuWzGjt8XRKPRM5DOaR6I7qYg7XQ0stQiFmWoUa15IBNsvgMwNl
         lhNuT4/Z60bAw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D3D97E21EE9;
        Fri, 17 Mar 2023 05:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next 0/2] double-fix bpf_test_run + XDP_PASS recycling
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167903101786.26830.4703373832959381961.git-patchwork-notify@kernel.org>
Date:   Fri, 17 Mar 2023 05:30:17 +0000
References: <20230316175051.922550-1-aleksander.lobakin@intel.com>
In-Reply-To: <20230316175051.922550-1-aleksander.lobakin@intel.com>
To:     Alexander Lobakin <aleksander.lobakin@intel.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, maciej.fijalkowski@intel.com,
        larysa.zaremba@intel.com, toke@redhat.com, iii@linux.ibm.com,
        song@kernel.org, hawk@kernel.org, kuba@kernel.org,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (master)
by Alexei Starovoitov <ast@kernel.org>:

On Thu, 16 Mar 2023 18:50:49 +0100 you wrote:
> Enabling skb PP recycling revealed a couple issues in the bpf_test_run
> code. Recycling broke the assumption that the headroom won't ever be
> touched during the test_run execution: xdp_scrub_frame() invalidates the
> XDP frame at the headroom start, while neigh xmit code overwrites 2 bytes
> to the left of the Ethernet header. The first makes the kernel panic in
> certain cases, while the second breaks xdp_do_redirect selftest on BE.
> test_run is a limited-scope entity, so let's hope no more corner cases
> will happen here or at least they will be as easy and pleasant to fix
> as those two.
> 
> [...]

Here is the summary with links:
  - [bpf-next,1/2] bpf, test_run: fix crashes due to XDP frame overwriting/corruption
    https://git.kernel.org/bpf/bpf-next/c/e5995bc7e2ba
  - [bpf-next,2/2] selftests/bpf: fix "metadata marker" getting overwritten by the netstack
    https://git.kernel.org/bpf/bpf-next/c/5640b6d89434

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


