Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B96F9516458
	for <lists+netdev@lfdr.de>; Sun,  1 May 2022 14:20:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347091AbiEAMX7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 May 2022 08:23:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346912AbiEAMXk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 May 2022 08:23:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1055CF28;
        Sun,  1 May 2022 05:20:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BC0EAB80D30;
        Sun,  1 May 2022 12:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3FB8DC385AF;
        Sun,  1 May 2022 12:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651407612;
        bh=9KU8d1fcPKUAh6U47Hcgbxe7EAYzVBg/xG4xE2hash8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rfnB6iZAQ0DenBuR2lVcmvsXcAIcJjHvXriyn5iwJXVViBXzageFTNr256yZYtjz6
         56w9X5XYJ1cPBHPj+FLeqV58E3xNuuOIO3mSR5uV0KOBllTabIZgP6gw9o4FjnKK4w
         4oCmAfwJIqRkfscEwkRB372LojjuHuliwYtbuCbP59JJByM/CqYkGi7+I8SFpe75nF
         xgjO8AhVKjqdpQws0zPdPOKMCNml+2L8FZ+Iz5yRiN2s1l1N6dFyENwTGwyq+bFRB5
         j4JMv4FKu+64B178SNUVXC5CVFWIJtIE1jcaXYYsr7qZ5M2sn+BOIYWL4j5Goa93Uq
         j3qBhP6go42Hw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 246EEE8DBDA;
        Sun,  1 May 2022 12:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] UDP sock_wfree optimisations
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165140761214.13523.8144885912180320727.git-patchwork-notify@kernel.org>
Date:   Sun, 01 May 2022 12:20:12 +0000
References: <cover.1650891417.git.asml.silence@gmail.com>
In-Reply-To: <cover.1650891417.git.asml.silence@gmail.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        dsahern@kernel.org, edumazet@google.com,
        linux-kernel@vger.kernel.org
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

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 28 Apr 2022 11:58:16 +0100 you wrote:
> The series is not UDP specific but that the main beneficiary. 2/3 saves one
> atomic in sock_wfree() and on top 3/3 removes an extra barrier.
> Tested with UDP over dummy netdev, 2038491 -> 2099071 req/s (or around +3%).
> 
> note: in regards to 1/3, there is a "Should agree with poll..." comment
> that I don't completely get, and there is no git history to explain it.
> Though I can't see how it could rely on having the second check without
> racing with tasks woken by wake_up*().
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] sock: dedup sock_def_write_space wmem_alloc checks
    https://git.kernel.org/netdev/net-next/c/14bfee9b6270
  - [net-next,2/3] sock: optimise UDP sock_wfree() refcounting
    https://git.kernel.org/netdev/net-next/c/052ada096842
  - [net-next,3/3] sock: optimise sock_def_write_space barriers
    https://git.kernel.org/netdev/net-next/c/0a8afd9f026a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


