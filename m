Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD12F5A8789
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 22:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbiHaUaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 16:30:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiHaUaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 16:30:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 852EE6E2E8;
        Wed, 31 Aug 2022 13:30:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 479BFB82314;
        Wed, 31 Aug 2022 20:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DD956C433D6;
        Wed, 31 Aug 2022 20:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661977815;
        bh=HF45hYssB2ZTVFkCbeL6AGokFJ2A8Ps5jvj0PPT0ZLc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZML8AFaU5zh45iI6n1Wwb0n9o2vBFlyf9JABqPlBeOwNhIZA1HnLHwsT3p5ncspAc
         Nd9okwydc9n73Rx9a/P0YLJ3NODRYgI9fHhOJMSBb/lXF9+/hv72A4HGA0YD87BAy3
         PxAR3CuJQ2WN/f/gDGmc9DKLWzh+DrddYdOHuqelz1zdlPnIFC2NreqU09zGvLffA7
         NdReEJkyHY6SGnCpX7Jk7uAlaU+L9vd5oBiv8IAggeV+SAIamDU8RfuGIL5tmrZUY0
         LG6aCHDtrxxJtEDt7DoXJjMkHDicSdS7KLOhSbeW+IrqC5G4tOCsoCsLSmIMULCDEO
         KRJrsP9JHFAxA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BDA9AE924DB;
        Wed, 31 Aug 2022 20:30:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next 1/2] bpf: net: Avoid loading module when calling
 bpf_setsockopt(TCP_CONGESTION)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166197781476.8460.17070230581972195161.git-patchwork-notify@kernel.org>
Date:   Wed, 31 Aug 2022 20:30:14 +0000
References: <20220830231946.791504-1-martin.lau@linux.dev>
In-Reply-To: <20220830231946.791504-1-martin.lau@linux.dev>
To:     Martin KaFai Lau <martin.lau@linux.dev>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        andrii@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, kernel-team@fb.com,
        pabeni@redhat.com, sdf@google.com
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
by Daniel Borkmann <daniel@iogearbox.net>:

On Tue, 30 Aug 2022 16:19:46 -0700 you wrote:
> When bpf prog changes tcp-cc by calling bpf_setsockopt(TCP_CONGESTION),
> it should not try to load module which may be a blocking
> operation.  This details was correct in the v1 [0] but missed by
> mistake in the later revision in
> commit cb388e7ee3a8 ("bpf: net: Change do_tcp_setsockopt() to use the sockopt's lock_sock() and capable()")
> 
> This patch fixes it by checking the has_current_bpf_ctx().
> 
> [...]

Here is the summary with links:
  - [bpf-next,1/2] bpf: net: Avoid loading module when calling bpf_setsockopt(TCP_CONGESTION)
    https://git.kernel.org/bpf/bpf-next/c/84e5a0f208ca
  - [bpf-next,2/2] selftest/bpf: Ensure no module loading in bpf_setsockopt(TCP_CONGESTION)
    https://git.kernel.org/bpf/bpf-next/c/197072945a70

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


