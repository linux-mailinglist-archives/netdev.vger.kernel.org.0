Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EA5860C9E9
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 12:23:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232006AbiJYKX2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 06:23:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232209AbiJYKWR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 06:22:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34BA1B86A
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 03:20:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9663CB81CD2
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 10:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 41011C433B5;
        Tue, 25 Oct 2022 10:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666693216;
        bh=VTGtbsKNFABG3TWQ9HDFDYvT+VwAlVf51QsHRGENXTg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=J71mHCjghl7f1dAad2MZj4duN/FN0Yll0LZeiFwr6R9scVk26P4ZC38YCKW2NIJFg
         fIROEdMpBY1+OnhxmMhxGWd9wxHs4rtqAgOu7g+88ddQRg99eIN3gkgladhuns/ATw
         P9bUMwO8O5ZgnZ2LhshrSOrfnAZNOmGnX4K8llsHwFc+6uYY9+kf7hLLars+CGj25q
         LNml4sKtyD5poiR4V8PJWi4VHPMNquUKS3bTlouTmj/iqaRX/cYjIcEPivtMBr0fxT
         W59sW3cdPMvgVNx6sJQWjtOG06PDVvMxPahIsDTXxhYJ3OuQLeOKxUmpHx/ohqH6gY
         gBSZguTBHyX3Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 20D1DE270DD;
        Tue, 25 Oct 2022 10:20:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net-next 0/2] soreuseport: Fix broken SO_INCOMING_CPU.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166669321613.30140.921272213867789279.git-patchwork-notify@kernel.org>
Date:   Tue, 25 Oct 2022 10:20:16 +0000
References: <20221021204435.4259-1-kuniyu@amazon.com>
In-Reply-To: <20221021204435.4259-1-kuniyu@amazon.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, martin.lau@kernel.org, kraig@google.com,
        kazuhooku@gmail.com, kuni1840@gmail.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Fri, 21 Oct 2022 13:44:33 -0700 you wrote:
> setsockopt(SO_INCOMING_CPU) for UDP/TCP is broken since 4.5/4.6 due to
> these commits:
> 
>   * e32ea7e74727 ("soreuseport: fast reuseport UDP socket selection")
>   * c125e80b8868 ("soreuseport: fast reuseport TCP socket selection")
> 
> These commits introduced the O(1) socket selection algorithm and removed
> O(n) iteration over the list, but it ignores the score calculated by
> compute_score().  As a result, it caused two misbehaviours:
> 
> [...]

Here is the summary with links:
  - [v3,net-next,1/2] soreuseport: Fix socket selection for SO_INCOMING_CPU.
    https://git.kernel.org/netdev/net-next/c/b261eda84ec1
  - [v3,net-next,2/2] selftest: Add test for SO_INCOMING_CPU.
    https://git.kernel.org/netdev/net-next/c/6df96146b202

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


