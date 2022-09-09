Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD8B35B3E2D
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 19:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231174AbiIIRuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 13:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230353AbiIIRuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 13:50:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D9CC4D14F;
        Fri,  9 Sep 2022 10:50:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B070FB825FF;
        Fri,  9 Sep 2022 17:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4FB08C433D7;
        Fri,  9 Sep 2022 17:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662745816;
        bh=7+2lWiCjz905HgbneEm6cNAffs6ayLWYU5RQPsXmkLc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BTLP2UU8329A67jhSse9ToYruq7ooICRXktaNPH3fIVMOrodZtbhKkB0oNrtvioXY
         r7ewLxy9o2fmpAtU+8Os3mNE+bpSt9E2fKxyHp9rDXNrT1L0dXQ7GyhBKOUo2E522X
         mepBGemWAIZXieQSm7yaMqPZ+/xjaWq6rRFBG2LA0dzT4UDvE0Sm1OyJ1dFEF7n60O
         cp7PiL43X0bS7t41Qvq1uj3MWJvW+TV1K8R/hKsyIJ1Fy8xkkgvZoTdsBRrukAoNVd
         UT1QZQeWbUA558QeqWoz6wXcYZCNmkrgJ+pSgtHJJdXYJEB1Gpord0R+SkpVWIp6BT
         V60EW7VJbF8YA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 335A5C73FE7;
        Fri,  9 Sep 2022 17:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4 bpf-next 0/3] cgroup/connect{4,6} programs for unprivileged
 ICMP ping
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166274581620.27936.8009091475815991986.git-patchwork-notify@kernel.org>
Date:   Fri, 09 Sep 2022 17:50:16 +0000
References: <cover.1662682323.git.zhuyifei@google.com>
In-Reply-To: <cover.1662682323.git.zhuyifei@google.com>
To:     YiFei Zhu <zhuyifei@google.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, sdf@google.com, martin.lau@linux.dev,
        john.fastabend@gmail.com, jolsa@kernel.org, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
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

This series was applied to bpf/bpf-next.git (master)
by Martin KaFai Lau <martin.lau@kernel.org>:

On Fri,  9 Sep 2022 00:49:38 +0000 you wrote:
> Usually when a TCP/UDP connection is initiated, we can bind the socket
> to a specific IP attached to an interface in a cgroup/connect hook.
> But for pings, this is impossible, as the hook is not being called.
> 
> This series adds the invocation for cgroup/connect{4,6} programs to
> unprivileged ICMP ping (i.e. ping sockets created with SOCK_DGRAM
> IPPROTO_ICMP(V6) as opposed to SOCK_RAW). This also adds a test to
> verify that the hooks are being called and invoking bpf_bind() from
> within the hook actually binds the socket.
> 
> [...]

Here is the summary with links:
  - [v4,bpf-next,1/3] bpf: Invoke cgroup/connect{4,6} programs for unprivileged ICMP ping
    https://git.kernel.org/bpf/bpf-next/c/0ffe2412531e
  - [v4,bpf-next,2/3] selftests/bpf: Deduplicate write_sysctl() to test_progs.c
    https://git.kernel.org/bpf/bpf-next/c/e42921c3c346
  - [v4,bpf-next,3/3] selftests/bpf: Ensure cgroup/connect{4,6} programs can bind unpriv ICMP ping
    https://git.kernel.org/bpf/bpf-next/c/58c449a96946

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


