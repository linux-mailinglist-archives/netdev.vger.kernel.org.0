Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2846853B0FC
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 03:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232861AbiFBAuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 20:50:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232858AbiFBAuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 20:50:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 800E059323
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 17:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1A939B81D8B
        for <netdev@vger.kernel.org>; Thu,  2 Jun 2022 00:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 988F0C385B8;
        Thu,  2 Jun 2022 00:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654131012;
        bh=ZsNxLF4rbc4cNGmUcPF2jOUlhdgwp1YY7Ocd92Kahp0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=C5bTALpDLyLk0cGhAZSp64soyPQBh0PkGck/C6PE7ODwEd8AZSAaxytnLnJ8MIAfN
         JIiAQgS+Nqdi40gXRoZtGcyMOcdK44Oj3lUL/KvSSCMZo7k4usTtC/CRGcxYAWF+E4
         /xVDQ6Ae/BsNLKQwHdcj1Tf8cIXsz5k+1K8vxK2cZBFDfePjfpuUU5YwQBwn531dai
         fO0pkzsJibYWwG0loliSjJ7uoYkJj91Dtdwvhk5aSmKOZ4yb/a6cy9megNdy6/q6wj
         fqYOHyc+u7atXfq2b+oLYjYCgckq9DPVZzxZD4SQ0zsjHfKtyN5NjQ3GZaxT12te78
         CK4eN16PfgvBw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7ED28F0394F;
        Thu,  2 Jun 2022 00:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/2] Revert "net: af_key: add check for pfkey_broadcast in
 function pfkey_process"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165413101251.24390.18250818000088174156.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Jun 2022 00:50:12 +0000
References: <20220601103349.2297361-2-steffen.klassert@secunet.com>
In-Reply-To: <20220601103349.2297361-2-steffen.klassert@secunet.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     davem@davemloft.net, kuba@kernel.org, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org
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

This series was applied to netdev/net.git (master)
by Steffen Klassert <steffen.klassert@secunet.com>:

On Wed, 1 Jun 2022 12:33:48 +0200 you wrote:
> From: Michal Kubecek <mkubecek@suse.cz>
> 
> This reverts commit 4dc2a5a8f6754492180741facf2a8787f2c415d7.
> 
> A non-zero return value from pfkey_broadcast() does not necessarily mean
> an error occurred as this function returns -ESRCH when no registered
> listener received the message. In particular, a call with
> BROADCAST_PROMISC_ONLY flag and null one_sk argument can never return
> zero so that this commit in fact prevents processing any PF_KEY message.
> One visible effect is that racoon daemon fails to find encryption
> algorithms like aes and refuses to start.
> 
> [...]

Here is the summary with links:
  - [1/2] Revert "net: af_key: add check for pfkey_broadcast in function pfkey_process"
    https://git.kernel.org/netdev/net/c/9c90c9b3e50e
  - [2/2] xfrm: do not set IPv4 DF flag when encapsulating IPv6 frames <= 1280 bytes.
    https://git.kernel.org/netdev/net/c/6821ad877034

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


