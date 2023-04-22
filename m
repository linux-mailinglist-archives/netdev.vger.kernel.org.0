Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 548706EB721
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 05:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbjDVDk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 23:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbjDVDkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 23:40:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 836A91BCC
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 20:40:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0F97864172
        for <netdev@vger.kernel.org>; Sat, 22 Apr 2023 03:40:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 619A4C433D2;
        Sat, 22 Apr 2023 03:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682134820;
        bh=KbD81mLOex86zMRNcDz/3D3AAjMMiZlyNd057mX5YhM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Rk8reQHDGBrRwVg7IojgTBWwZEyNH4Sw2fhHwRoGV4L1NHWN4cCBKJDuezdxVOFF+
         Zxjer9VZvWDzhT1oLJ0apZcf2qS7XZY90TqcowIqXxux1DU0wbSY6TX29ioXKeJeqc
         MLtZcmJmHSrl01VXiCTB7ZcS2RcULUIMrVPwbWWRaVqFP/lkd4jNwcETMTynBS40li
         cljhksToBeJainIo0SR55JcFOY8ekhteKEdeuF3BXQm2nAbYorsY2McrHsq5T86ZAz
         rwBtvgegstc7NGlhxhuUEikt/70PAsn6xjfnJcxGRcJkA8cfqOSsyhXUMMqlqTQ6OB
         DelolXekLmVxQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 43B50E270DA;
        Sat, 22 Apr 2023 03:40:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net/sched: sch_fq: fix integer overflow of "credit"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168213482026.27640.13626059018545502132.git-patchwork-notify@kernel.org>
Date:   Sat, 22 Apr 2023 03:40:20 +0000
References: <7b3a3c7e36d03068707a021760a194a8eb5ad41a.1682002300.git.dcaratti@redhat.com>
In-Reply-To: <7b3a3c7e36d03068707a021760a194a8eb5ad41a.1682002300.git.dcaratti@redhat.com>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     edumazet@google.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, kuba@kernel.org, netdev@vger.kernel.org
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

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 20 Apr 2023 16:59:46 +0200 you wrote:
> if sch_fq is configured with "initial quantum" having values greater than
> INT_MAX, the first assignment of "credit" does signed integer overflow to
> a very negative value.
> In this situation, the syzkaller script provided by Cristoph triggers the
> CPU soft-lockup warning even with few sockets. It's not an infinite loop,
> but "credit" wasn't probably meant to be minus 2Gb for each new flow.
> Capping "initial quantum" to INT_MAX proved to fix the issue.
> 
> [...]

Here is the summary with links:
  - [net,v2] net/sched: sch_fq: fix integer overflow of "credit"
    https://git.kernel.org/netdev/net/c/7041101ff6c3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


