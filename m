Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0257C526102
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 13:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379926AbiEMLaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 07:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379920AbiEMLaP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 07:30:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3910C2B4CAD
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 04:30:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C860161DFF
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 11:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 29F4CC34117;
        Fri, 13 May 2022 11:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652441413;
        bh=NnX/3pSytbIvXbbFBwJqnztDDvU7whb0gc3Ww7PMRU8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UOoPZkxaUogYwm+K5iu0IDllcZxpYHDWulUcvr9R5yq7ZwunRzJ9+cOrCh/FLHt0U
         4LAhSDaa5vW7rYzjh9r/UL9UrZOF1Hn7fOlOwok2jRqOi+xHwd6Cpr1C/30edMxzWo
         /8p3ayHy76ZFDl8dwOGzTyc5ziqHUCDdsFOYxgc/b0yQQ0WAgsNC0nAGwYftnuvSPC
         IbCRMFBr3jzCJxXWYTNL7ZltNX3wWBSdnR2UFaW4VuyIZoiumf1EHMyrMzkzJ1A/Ks
         sIN6SH9bmRXklBHNlaSjqkrnexC40f1OQDAk8AJ2XcwDUusQQf7ihyg7KExyxHvWKH
         CmN8e7xwYJEMw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0B983F03935;
        Fri, 13 May 2022 11:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v7 1/2] net: axienet: Be more careful about updating
 tx_bd_tail
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165244141304.14739.6534983406795564149.git-patchwork-notify@kernel.org>
Date:   Fri, 13 May 2022 11:30:13 +0000
References: <20220512171853.4100193-2-robert.hancock@calian.com>
In-Reply-To: <20220512171853.4100193-2-robert.hancock@calian.com>
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     netdev@vger.kernel.org, radhey.shyam.pandey@xilinx.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, michal.simek@xilinx.com,
        linux-arm-kernel@lists.infradead.org
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

On Thu, 12 May 2022 11:18:52 -0600 you wrote:
> The axienet_start_xmit function was updating the tx_bd_tail variable
> multiple times, with potential rollbacks on error or invalid
> intermediate positions, even though this variable is also used in the
> TX completion path. Use READ_ONCE where this variable is read and
> WRITE_ONCE where it is written to make this update more atomic, and
> move the write before the MMIO write to start the transfer, so it is
> protected by that implicit write barrier.
> 
> [...]

Here is the summary with links:
  - [net-next,v7,1/2] net: axienet: Be more careful about updating tx_bd_tail
    https://git.kernel.org/netdev/net-next/c/f0cf4000f586
  - [net-next,v7,2/2] net: axienet: Use NAPI for TX completion path
    https://git.kernel.org/netdev/net-next/c/9e2bc267e780

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


