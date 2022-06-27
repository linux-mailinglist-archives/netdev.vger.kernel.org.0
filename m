Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0222255D5F3
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233897AbiF0LAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 07:00:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233242AbiF0LAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 07:00:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 302E46417
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 04:00:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD2CC6137A
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 11:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1181DC341CB;
        Mon, 27 Jun 2022 11:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656327613;
        bh=7tkffvmXloXkjqoAeGjndV757ihqBOYPUlUoOdpOKEc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PSxy+g5NcBkBreuhWBK/WXB6v+AE7eVtlWSUK8kYkuACY2uh4skULaHPzFyCXaAvr
         VPRLhy/TuqYDeMIwacje1AP1g7r0u8Tc7GdAnZ4rCxEEdVz6ZCqeE/QrxwMdPvAtB1
         3a1qi2UOvAP9rQN32CRo+4jRvnXOFT0/DkcotlEkmQkTi9LmGxJs7zYSAXCvHv/gYv
         PsR/362lmvdX7+QCIFkpY6/XUExiRA0UyqvFFp1w5E3DDeeQXIg6HddB8sF53A244v
         CIDV9x2gCDlBtevj2xLrxKLKh6fvtFxLis4NXyDDXGV8geKbgkMhaOykPPopCMELrh
         EdzratuzEHHrg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E7FEAE49BBF;
        Mon, 27 Jun 2022 11:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] tipc: move bc link creation back to tipc_node_create
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165632761294.13770.11342795585955064411.git-patchwork-notify@kernel.org>
Date:   Mon, 27 Jun 2022 11:00:12 +0000
References: <fe367ef0159c2f41e475bd1d00e0dc8d8a85b224.1656087871.git.lucien.xin@gmail.com>
In-Reply-To: <fe367ef0159c2f41e475bd1d00e0dc8d8a85b224.1656087871.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        davem@davemloft.net, kuba@kernel.org, jmaloy@redhat.com,
        ying.xue@windriver.com, tuong.t.lien@dektech.com.au
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 24 Jun 2022 12:24:31 -0400 you wrote:
> Shuang Li reported a NULL pointer dereference crash:
> 
>   [] BUG: kernel NULL pointer dereference, address: 0000000000000068
>   [] RIP: 0010:tipc_link_is_up+0x5/0x10 [tipc]
>   [] Call Trace:
>   []  <IRQ>
>   []  tipc_bcast_rcv+0xa2/0x190 [tipc]
>   []  tipc_node_bc_rcv+0x8b/0x200 [tipc]
>   []  tipc_rcv+0x3af/0x5b0 [tipc]
>   []  tipc_udp_recv+0xc7/0x1e0 [tipc]
> 
> [...]

Here is the summary with links:
  - [net] tipc: move bc link creation back to tipc_node_create
    https://git.kernel.org/netdev/net/c/cb8092d70a6f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


