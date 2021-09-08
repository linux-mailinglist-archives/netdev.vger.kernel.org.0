Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 068714038FE
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 13:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351501AbhIHLlO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 07:41:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:36522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235453AbhIHLlN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Sep 2021 07:41:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5F95561157;
        Wed,  8 Sep 2021 11:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631101205;
        bh=14G3beQpxy2SPLHfXGVauPG/jcl9eTPysyZMbssgrIw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ox2EONkSBX70W9l9X109b6rWySSfQzgxMidvA865fuOwcrQnK9qc+9uKRKUv8WG62
         5WUFOMVt2OHwJXyGAWw9P/rv92aXR7HRXIwVp/51AO8NSsCgX1+O77hY4ayy7tmYAk
         eA4XQGfNuvECPznb2sHGCsY74Q2jt3qYHqI+i73108SKe85vtN+xmDUdKOE0RKKuG7
         i6ioMZkWrtrmlE1L2lVMYqeAXBq49nPcnOuVSx2EQv9ZUe0KpAziKMZltPRu9hRd8B
         mdySU8QWq8wz4K/ewM8uQP51KrtdiIsJZyN9rFHyB1NkPt7GYc049swUsKN757TIkG
         4sq78R6ZMJzKA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5336A60A6D;
        Wed,  8 Sep 2021 11:40:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: stmmac: fix system hang caused by eee_ctrl_timer
 during suspend/resume
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163110120533.13176.6299418024122400249.git-patchwork-notify@kernel.org>
Date:   Wed, 08 Sep 2021 11:40:05 +0000
References: <20210908074335.4662-1-qiangqing.zhang@nxp.com>
In-Reply-To: <20210908074335.4662-1-qiangqing.zhang@nxp.com>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        linux-imx@nxp.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed,  8 Sep 2021 15:43:35 +0800 you wrote:
> commit 5f58591323bf ("net: stmmac: delete the eee_ctrl_timer after
> napi disabled"), this patch tries to fix system hang caused by eee_ctrl_timer,
> unfortunately, it only can resolve it for system reboot stress test. System
> hang also can be reproduced easily during system suspend/resume stess test
> when mount NFS on i.MX8MP EVK board.
> 
> In stmmac driver, eee feature is combined to phylink framework. When do
> system suspend, phylink_stop() would queue delayed work, it invokes
> stmmac_mac_link_down(), where to deactivate eee_ctrl_timer synchronizly.
> In above commit, try to fix issue by deactivating eee_ctrl_timer obviously,
> but it is not enough. Looking into eee_ctrl_timer expire callback
> stmmac_eee_ctrl_timer(), it could enable hareware eee mode again. What is
> unexpected is that LPI interrupt (MAC_Interrupt_Enable.LPIEN bit) is always
> asserted. This interrupt has chance to be issued when LPI state entry/exit
> from the MAC, and at that time, clock could have been already disabled.
> The result is that system hang when driver try to touch register from
> interrupt handler.
> 
> [...]

Here is the summary with links:
  - [net] net: stmmac: fix system hang caused by eee_ctrl_timer during suspend/resume
    https://git.kernel.org/netdev/net/c/276aae377206

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


