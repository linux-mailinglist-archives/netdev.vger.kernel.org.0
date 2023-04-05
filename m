Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D400E6D724D
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 04:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236723AbjDECKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 22:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232695AbjDECKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 22:10:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDB2C3C0A;
        Tue,  4 Apr 2023 19:10:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C70263986;
        Wed,  5 Apr 2023 02:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B7CB7C433D2;
        Wed,  5 Apr 2023 02:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680660617;
        bh=4zJ4kLaeaZbHgZtylnXU4eUVkHyBkUaet36sI15YNo8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MtjY6CQPKm7hzi4jCZ8G4ZOL70G+tRaFbgX3Qo1mjQaCWGGszB8J+6X6ckYA1cCV9
         D/uDMZy3uroXe8iDIyGvCA+nt5eBFAC4kdREUHIIHjiAq5rWKLFt7Z23UMMKUs3tEI
         tdkvEB4bDgwNUXA/VL8U5DY3nIdHFxZRHzEmI6YIA8RmeH7C4DR/faW2p/caJAhYgp
         jEe2rLGDO29zc6uAcLkqNgAOoUkWajZQvYf4V/W+fMge/vnekc+dJ1Pbh7GjrXQ97+
         yBrcxsdVgPWvtpq8npBOlH+BuXyJFzeaa9ZKCiXuflPBMz1Pwm3Dir4aHm3SglcKD4
         h9TZ/FwmeFW1w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 97249E4D02D;
        Wed,  5 Apr 2023 02:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: qrtr: correct types of trace event
 parameters
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168066061761.16096.17994837774956890281.git-patchwork-notify@kernel.org>
Date:   Wed, 05 Apr 2023 02:10:17 +0000
References: <20230402-qrtr-trace-types-v1-1-92ad55008dd3@kernel.org>
In-Reply-To: <20230402-qrtr-trace-types-v1-1-92ad55008dd3@kernel.org>
To:     Simon Horman <horms@kernel.org>
Cc:     kuba@kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, mani@kernel.org, rostedt@goodmis.org,
        mhiramat@kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 03 Apr 2023 17:43:16 +0200 you wrote:
> The arguments passed to the trace events are of type unsigned int,
> however the signature of the events used __le32 parameters.
> 
> I may be missing the point here, but sparse flagged this and it
> does seem incorrect to me.
> 
>   net/qrtr/ns.c: note: in included file (through include/trace/trace_events.h, include/trace/define_trace.h, include/trace/events/qrtr.h):
>   ./include/trace/events/qrtr.h:11:1: warning: cast to restricted __le32
>   ./include/trace/events/qrtr.h:11:1: warning: restricted __le32 degrades to integer
>   ./include/trace/events/qrtr.h:11:1: warning: restricted __le32 degrades to integer
>   ... (a lot more similar warnings)
>   net/qrtr/ns.c:115:47:    expected restricted __le32 [usertype] service
>   net/qrtr/ns.c:115:47:    got unsigned int service
>   net/qrtr/ns.c:115:61: warning: incorrect type in argument 2 (different base types)
>   ... (a lot more similar warnings)
> 
> [...]

Here is the summary with links:
  - [net-next] net: qrtr: correct types of trace event parameters
    https://git.kernel.org/netdev/net-next/c/054fbf7ff814

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


