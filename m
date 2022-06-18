Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE79555028B
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 05:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236729AbiFRDkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 23:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235136AbiFRDkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 23:40:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66948522E2;
        Fri, 17 Jun 2022 20:40:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1B30BB82D2A;
        Sat, 18 Jun 2022 03:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CE939C3411E;
        Sat, 18 Jun 2022 03:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655523612;
        bh=OOk6ffM6mMXD1lN55Xk2zrDTD1uhQsn749ExZWBioGQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=M/apV2pmDG1T4spEQhKbgf1YImnxMq/oBhEGt0bLqTTXLvys1Ol6hOGxL4atxed82
         3h9jUK8Cjz6AXRKsS2R4GQh2m23qftf6VRdRLH7bJHRJmrgRTXFY5rFCoOrO0so2ib
         876hvOK3WsIcI/egjq35hR6ZgnSqoxQmLuSBA43sl+PLWHyr+HARCBd7+i2LoO96hm
         I4ayhR38v+oaK+aDcWAztWsD2DXg5iyiS881Cf7/67M9le9eu0jpuQaxAgrBPon/3e
         e/0vnUVlQPCOy70/MkQeT30jgl3+beoCFE2I+p5jKaFA4DapqH2ZaveLsAra8OhiuH
         ZoFJ1VzcVI4Pw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B199BFD99FF;
        Sat, 18 Jun 2022 03:40:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/sched: sch_netem: Fix arithmetic in netem_dump() for
 32-bit platforms
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165552361272.10717.10367352534095157027.git-patchwork-notify@kernel.org>
Date:   Sat, 18 Jun 2022 03:40:12 +0000
References: <20220616234336.2443-1-yepeilin.cs@gmail.com>
In-Reply-To: <20220616234336.2443-1-yepeilin.cs@gmail.com>
To:     Peilin Ye <yepeilin.cs@gmail.com>
Cc:     stephen@networkplumber.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        peilin.ye@bytedance.com, chenyuming.junnan@bytedance.com,
        ted@mostlyuseful.tech, dave.taht@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        cong.wang@bytedance.com
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 16 Jun 2022 16:43:36 -0700 you wrote:
> From: Peilin Ye <peilin.ye@bytedance.com>
> 
> As reported by Yuming, currently tc always show a latency of UINT_MAX
> for netem Qdisc's on 32-bit platforms:
> 
>     $ tc qdisc add dev dummy0 root netem latency 100ms
>     $ tc qdisc show dev dummy0
>     qdisc netem 8001: root refcnt 2 limit 1000 delay 275s  275s
>                                                ^^^^^^^^^^^^^^^^
> 
> [...]

Here is the summary with links:
  - [net] net/sched: sch_netem: Fix arithmetic in netem_dump() for 32-bit platforms
    https://git.kernel.org/netdev/net/c/a2b1a5d40bd1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


