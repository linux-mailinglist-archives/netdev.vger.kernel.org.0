Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C7265B07C6
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 17:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbiIGPAk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 11:00:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230241AbiIGPAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 11:00:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC8549A9E2;
        Wed,  7 Sep 2022 08:00:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 89EDDB81D1C;
        Wed,  7 Sep 2022 15:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 230F7C433D6;
        Wed,  7 Sep 2022 15:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662562816;
        bh=UOGmhrn+BbAQjUtjrIw6EOV2saXaxk5jhJ+AzixV1U4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Frk9mAp3W/YJyl67tr8XtHJtTYpX0C/7vqhJBEyMOPVXEWSSJg7ToYXIwj4oEZJq+
         g+Y4rnomKmcVe/m2nKdV74abgccX2Q7aKtQUldFnFAJZOHY95ZISRWxmK5sVVFhcRZ
         /S4QvKommSn5I2XKcFT1OZz1e/K59/hV6UME3JgV28vDsXAY7rndYAQ/ny4y3xwJQL
         IXWcW1YaRM17DSfyxXCeYplfhWqbHTzMMrdCngd8sj4PJUuZMm/edUNUM1+ZbIAqfJ
         N9BEzJlHxNoANYFFCOrUTranElhBmrXzty5NT1T+IZWqodk5BwNCJZBxZR9M79gmAJ
         rLLg0LXYXQthw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E30F6C73FE7;
        Wed,  7 Sep 2022 15:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3] net: skb: export skb drop reaons to user by
 TRACE_DEFINE_ENUM
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166256281591.26447.5640318834155971016.git-patchwork-notify@kernel.org>
Date:   Wed, 07 Sep 2022 15:00:15 +0000
References: <20220905035015.1130730-1-imagedong@tencent.com>
In-Reply-To: <20220905035015.1130730-1-imagedong@tencent.com>
To:     Menglong Dong <menglong8.dong@gmail.com>
Cc:     edumazet@google.com, kuba@kernel.org, davem@davemloft.net,
        pabeni@redhat.com, rostedt@goodmis.org, mingo@redhat.com,
        imagedong@tencent.com, dsahern@kernel.org, flyingpeng@tencent.com,
        dongli.zhang@oracle.com, robh@kernel.org, asml.silence@gmail.com,
        luiz.von.dentz@intel.com, vasily.averin@linux.dev,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
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

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon,  5 Sep 2022 11:50:15 +0800 you wrote:
> From: Menglong Dong <imagedong@tencent.com>
> 
> As Eric reported, the 'reason' field is not presented when trace the
> kfree_skb event by perf:
> 
> $ perf record -e skb:kfree_skb -a sleep 10
> $ perf script
>   ip_defrag 14605 [021]   221.614303:   skb:kfree_skb:
>   skbaddr=0xffff9d2851242700 protocol=34525 location=0xffffffffa39346b1
>   reason:
> 
> [...]

Here is the summary with links:
  - [net,v3] net: skb: export skb drop reaons to user by TRACE_DEFINE_ENUM
    https://git.kernel.org/netdev/net/c/9cb252c4c1c5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


