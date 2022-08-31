Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 035E45A88B5
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 00:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232331AbiHaWAa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 18:00:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232471AbiHaWAY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 18:00:24 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E08B6BCF1
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 15:00:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E9628CE2387
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 22:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 52B2FC433D6;
        Wed, 31 Aug 2022 22:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661983215;
        bh=OFVbfPoVE/sndLxRKf2F2wburjak1LNcrFfj8pCOZjI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Qhh7S8ROKi1dXZv9/LYL1rS68FpMNkiRsqo6CFhCiwL7P3msN5r3wBemFx2GRcg6D
         u6ByT9dbAoXJViTRFGHMUhyoEHFZE9Dw/54dj1+M+ZuGuyWFqX9gTjalhNXivhGiRt
         8UpnvqFaO6dnaSWImnVrX+/V7t4Fv5ed2XIxc/Wnk6zClKCLKh4qxyiUw1CQE3a09M
         6XOXuJ4P8nW950pYIKnOMJscs5iiKe72O9Adte73KVm248w6F3LLWLFKoB5snuBGlN
         rukMvPxp3xceXpLFgntlZxQrFe0uHUkYeqJhzPd8InNU+L57ZSNbAoU9ctf3kQ1olD
         kl5BZImRfw6Jg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2ECCEE924D6;
        Wed, 31 Aug 2022 22:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] sch_cake: Return __NET_XMIT_STOLEN when consuming
 enqueued skb
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166198321517.20200.12054704879498725145.git-patchwork-notify@kernel.org>
Date:   Wed, 31 Aug 2022 22:00:15 +0000
References: <20220831092103.442868-1-toke@toke.dk>
In-Reply-To: <20220831092103.442868-1-toke@toke.dk>
To:     =?utf-8?b?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2VuIDx0b2tlQHRva2UuZGs+?=@ci.codeaurora.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, cake@lists.bufferbloat.net,
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 31 Aug 2022 11:21:03 +0200 you wrote:
> When the GSO splitting feature of sch_cake is enabled, GSO superpackets
> will be broken up and the resulting segments enqueued in place of the
> original skb. In this case, CAKE calls consume_skb() on the original skb,
> but still returns NET_XMIT_SUCCESS. This can confuse parent qdiscs into
> assuming the original skb still exists, when it really has been freed. Fix
> this by adding the __NET_XMIT_STOLEN flag to the return value in this case.
> 
> [...]

Here is the summary with links:
  - [net] sch_cake: Return __NET_XMIT_STOLEN when consuming enqueued skb
    https://git.kernel.org/netdev/net/c/90fabae8a2c2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


