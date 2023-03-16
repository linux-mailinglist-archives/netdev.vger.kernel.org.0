Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5FD96BD77B
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 18:50:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbjCPRu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 13:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230235AbjCPRuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 13:50:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5C59F978;
        Thu, 16 Mar 2023 10:50:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 86AA4B822EF;
        Thu, 16 Mar 2023 17:50:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1EE9CC433EF;
        Thu, 16 Mar 2023 17:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678989020;
        bh=itpBSwNfPKlmIjx0UnOwPWQ3oN8irZn0RWBKyljXEM0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ey3iZvjUiD2wWsmuQnMKXhRql9vkaZ7mQtdPhXcsRFYHAGTO5nO49YXmQbSK+wbMP
         Dp+BN8Mnlmmp3Tb/EYC2UiPoMx+XeKM0K7s32VXWwHzVvOZBpwuL63WwVzkVNiU1JC
         pEbv7QaUAXHaa3vmbMY/YhakTY8hnWRtvv3qfLYaUOk9pQXBJ2DIJI2h49PMW4LMb7
         EfJv0FLXk2U/RFYIQ1B7pSqApNMVwuUmGI26S62p5z2H1CR6yFsT0uuouX/iy8GfnQ
         wA1GtUYn3EnWPgABWwNjMgIU4XMQv7ZSnYPPr6QGhPO6bPqELnNkL18sncqwbBP3uo
         qchHLOwGS50iw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EFF62E447D3;
        Thu, 16 Mar 2023 17:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] Fix MTU reporting for Marvell DSA switches where we
 can't change it
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167898901996.2133.17007453063913182709.git-patchwork-notify@kernel.org>
Date:   Thu, 16 Mar 2023 17:50:19 +0000
References: <20230314182405.2449898-1-vladimir.oltean@nxp.com>
In-Reply-To: <20230314182405.2449898-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        murali.policharla@broadcom.com, lukma@denx.de,
        linux@armlinux.org.uk, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Tue, 14 Mar 2023 20:24:03 +0200 you wrote:
> As explained in patch 2, the driver doesn't know how to change the MTU
> on MV88E6165, MV88E6191, MV88E6220, MV88E6250 and MV88E6290, and there
> is a regression where it actually reports an MTU value below the
> Ethernet standard (1500).
> 
> Fixing that shows another issue where DSA is unprepared to be told that
> a switch supports an MTU of only 1500, and still errors out. That is
> addressed by patch 1.
> 
> [...]

Here is the summary with links:
  - [net,1/2] net: dsa: don't error out when drivers return ETH_DATA_LEN in .port_max_mtu()
    https://git.kernel.org/netdev/net/c/636e8adf7878
  - [net,2/2] net: dsa: mv88e6xxx: fix max_mtu of 1492 on 6165, 6191, 6220, 6250, 6290
    https://git.kernel.org/netdev/net/c/7e9517375a14

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


