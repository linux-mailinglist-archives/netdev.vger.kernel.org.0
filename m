Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2CCD679459
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 10:40:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232654AbjAXJkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 04:40:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232517AbjAXJkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 04:40:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92CE6A0
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 01:40:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E74C60ACE
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 09:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 87098C4339B;
        Tue, 24 Jan 2023 09:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674553216;
        bh=bNnpEP9t40JaM5jTaNeDH3GwRLHAiPw4Q7pPzcqhk/M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fPxmHco5Zu3ArONVgCj1Btv+iZQ3/gcbTRQ0E6DUKttjZ1pAgni/esyT4QKZn7RYj
         9mqgYWLIIj9oScaWHz2Oea3Uf1qNFodzyY0SjIel4xhdgaRztzC54+6n13QCJ+A2AF
         UXCkQR3hs1LSPX4ZhaxEXg+dB/tpvIMy0WvkX1aQafPtctgq97tHi3duIMHMICp4OD
         BtvsrzwqH1gzhGVptp5ZaX/zhg2pEf3nNVI5gpooaxPCKXIl33mCdgd4u6itb724DT
         2UYJZMCgxoKU9q74Sl/Qe20ncS5Z6eLu8wcSdUZk4MhyqCRIk+0+nglzv74f87Fotq
         DsKhTvPWYINAg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6EFD0C5C7D4;
        Tue, 24 Jan 2023 09:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] net/sched: use the backlog for nested mirred
 ingress
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167455321644.29265.14993421601700671769.git-patchwork-notify@kernel.org>
Date:   Tue, 24 Jan 2023 09:40:16 +0000
References: <cover.1674233458.git.dcaratti@redhat.com>
In-Reply-To: <cover.1674233458.git.dcaratti@redhat.com>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     jhs@mojatatu.com, jiri@resnulli.us, lucien.xin@gmail.com,
        marcelo.leitner@gmail.com, netdev@vger.kernel.org,
        pabeni@redhat.com, wizhao@redhat.com, xiyou.wangcong@gmail.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Fri, 20 Jan 2023 18:01:38 +0100 you wrote:
> TC mirred has a protection against excessive stack growth, but that
> protection doesn't really guarantee the absence of recursion, nor
> it guards against loops. Patch 1/2 rewords "recursion" to "nesting" to
> make this more clear.
> We can leverage on this existing mechanism to prevent TCP / SCTP from doing
> soft lock-up in some specific scenarios that uses mirred egress->ingress:
> patch 2 changes mirred so that the networking backlog is used for nested
> mirred ingress actions.
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net/sched: act_mirred: better wording on protection against excessive stack growth
    https://git.kernel.org/netdev/net-next/c/78dcdffe0418
  - [net-next,2/2] act_mirred: use the backlog for nested calls to mirred ingress
    https://git.kernel.org/netdev/net-next/c/ca22da2fbd69

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


