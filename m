Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1C2B516516
	for <lists+netdev@lfdr.de>; Sun,  1 May 2022 18:12:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240525AbiEAQNr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 May 2022 12:13:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232597AbiEAQNp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 May 2022 12:13:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F529F58
        for <netdev@vger.kernel.org>; Sun,  1 May 2022 09:10:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B386AB80E58
        for <netdev@vger.kernel.org>; Sun,  1 May 2022 16:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6EBCAC385A9;
        Sun,  1 May 2022 16:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651421410;
        bh=hILsvBf/s1QTL1fDTvmnRl8mdgzYSnNLS+CwYLK3p74=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mFSBr+ItsR7k2knmkhq62Kn3z9pvV1YIxmNxh3jYkdGDXmFbDbZvvCNj9DWhvFZFc
         BCI3jmgMvuVW4c2vnN7AToU+E6hZSQ9qlvnXYcV79zMoFNLzpcZ44HAJ2GuJ+Bcrjz
         HLcDZUwbXQl5OlRibq81RKyTqyw1FrEtlnIwjdcj8lQEe/QpXCmRfiuiMuujgsVkPg
         BJ0xH9g18a5DrI6XVGiQUnd71CuWHbgo45VH3KknIVG3tT2XKGnRwxyfL18f4zyqc2
         zkGzFP6/Fg99wWaV6SASLhvbhrRKOVpYV8dN0IKxC9zw2R6oZ/of55Zbh4F5U3QM8Q
         4/7TUbkiEe2Qw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 53B3DE6D402;
        Sun,  1 May 2022 16:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: ['[PATCH] net: thunderx: Do not invoke pci_irq_vector() from\n interrupt
 context', '']
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165142141033.5854.5996010695898086875.git-patchwork-notify@kernel.org>
Date:   Sun, 01 May 2022 16:10:10 +0000
References: <87r15gngfj.ffs@tglx>
In-Reply-To: <87r15gngfj.ffs@tglx>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     omosnace@redhat.com, sgoutham@marvell.com, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org
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
by David S. Miller <davem@davemloft.net>:

On Fri, 29 Apr 2022 15:54:24 +0200 you wrote:
> pci_irq_vector() can't be used in atomic context any longer. This conflicts
> with the usage of this function in nic_mbx_intr_handler().
> 
> Cache the Linux interrupt numbers in struct nicpf and use that cache in the
> interrupt handler to select the mailbox.
> 
> Fixes: 495c66aca3da ("genirq/msi: Convert to new functions")
> Reported-by: Ondrej Mosnacek <omosnace@redhat.com>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Sunil Goutham <sgoutham@marvell.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: netdev@vger.kernel.org
> Cc: stable@vger.kernel.org
> Link: https://bugzilla.redhat.com/show_bug.cgi?id=2041772
> 
> [...]

Here is the summary with links:
  - net: thunderx: Do not invoke pci_irq_vector() from interrupt context
    https://git.kernel.org/netdev/net/c/6b292a04c694

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


