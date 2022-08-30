Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34D615A6011
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 12:02:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230012AbiH3KCk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 06:02:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229874AbiH3KBs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 06:01:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D865657E3D;
        Tue, 30 Aug 2022 03:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8C926B81691;
        Tue, 30 Aug 2022 10:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 35DCFC433D7;
        Tue, 30 Aug 2022 10:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661853615;
        bh=RbNLgaU0VdiLiev6MW1xgBhP2qXRPB2B/gTgDJZSro4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rrRSmSBAuqTb7nmgI9Ax8p5okymXy69indsZ2I27ALkxb8HpmWELEEWM77wLt8cFF
         IGOz23VfGROtZ3bbz4QWsb0GwUtkVjjO8IfGlm+tj6K2+yzHqjEW7hPdbI3WtbezuH
         83xVsDSUhL2QeIwZ6RKW9E3yihwjxN8b184ar9kBH1kgNxKsig+jsZ8TxTFPeHUX8t
         mjMMSQ4OYE33FP+Plv8iltZnEsJKrz2FDPnGpErkoGBRju3oBu4ePZPOSkdCPcZZQF
         PiocDs6mjAvnnw0q3Ggz9V5Xt5zm3vwIGxG+6TffXRGoHjAjsnmAzOsg7TOdu0qSSc
         77tNaj3V+sdFg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1445FE924D8;
        Tue, 30 Aug 2022 10:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net,v2] net: sched: tbf: don't call qdisc_put() while holding
 tree lock
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166185361506.21797.5581795536615394834.git-patchwork-notify@kernel.org>
Date:   Tue, 30 Aug 2022 10:00:15 +0000
References: <20220826013930.340121-1-shaozhengchao@huawei.com>
In-Reply-To: <20220826013930.340121-1-shaozhengchao@huawei.com>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, vladbu@mellanox.com, weiyongjun1@huawei.com,
        yuehaibing@huawei.com
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
by Paolo Abeni <pabeni@redhat.com>:

On Fri, 26 Aug 2022 09:39:30 +0800 you wrote:
> The issue is the same to commit c2999f7fb05b ("net: sched: multiq: don't
> call qdisc_put() while holding tree lock"). Qdiscs call qdisc_put() while
> holding sch tree spinlock, which results sleeping-while-atomic BUG.
> 
> Fixes: c266f64dbfa2 ("net: sched: protect block state with mutex")
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net,v2] net: sched: tbf: don't call qdisc_put() while holding tree lock
    https://git.kernel.org/netdev/net/c/b05972f01e7d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


