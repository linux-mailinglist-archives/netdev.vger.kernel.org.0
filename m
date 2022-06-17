Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13C3854F4FC
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 12:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381624AbiFQKKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 06:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381629AbiFQKKQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 06:10:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C25A639687;
        Fri, 17 Jun 2022 03:10:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E8AF61D4E;
        Fri, 17 Jun 2022 10:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BA987C3411B;
        Fri, 17 Jun 2022 10:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655460614;
        bh=giW/nh6R+3bCDQhbundWZhZv88bc+bqumrocrjBl1Ho=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AEb6YlcFL4v07Q/q8NcG/OLkSxY8vqwP+id+J02WkyniDtSdO0IHtoBG+vTwmJoSN
         3WzDTZ/7JQLN8YzXZDENQ0eISlfaVDVEjg7gSd+oa2U/y2rxnoO9TQ5xE/pRj0Z/A4
         g0HRNl/tpiIbvTZwcgfuAamE/vve0HmzBQnejtf/hfALxvl7bnrZEO6sJyz7VgLy/l
         cUL6PcqqXI2rT6kMqCYl2r/jBTAe3GIDEATrXp7YtpZfwfWybDFFKOUv+SeysU0ldU
         XqUqwMeSZNitvSdkYtLPBVm1XHCHvxijL0ZcFT3X39D1M0Sx04WL94RroHxwDQtaUu
         Qf2pXKU6XA5UA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9CAC4E7385E;
        Fri, 17 Jun 2022 10:10:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v1 1/1] net: ag71xx: fix discards 'const' qualifier
 warning
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165546061463.1839.2452113204278992956.git-patchwork-notify@kernel.org>
Date:   Fri, 17 Jun 2022 10:10:14 +0000
References: <20220616113724.890970-1-o.rempel@pengutronix.de>
In-Reply-To: <20220616113724.890970-1-o.rempel@pengutronix.de>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     chris.snook@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
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

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 16 Jun 2022 13:37:24 +0200 you wrote:
> Current kernel will compile this driver with warnings. This patch will
> fix it.
> 
> drivers/net/ethernet/atheros/ag71xx.c: In function 'ag71xx_fast_reset':
> drivers/net/ethernet/atheros/ag71xx.c:996:31: warning: passing argument 2 of 'ag71xx_hw_set
> _macaddr' discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
>   996 |  ag71xx_hw_set_macaddr(ag, dev->dev_addr);
>       |                            ~~~^~~~~~~~~~
> drivers/net/ethernet/atheros/ag71xx.c:951:69: note: expected 'unsigned char *' but argument
>  is of type 'const unsigned char *'
>   951 | static void ag71xx_hw_set_macaddr(struct ag71xx *ag, unsigned char *mac)
>       |                                                      ~~~~~~~~~~~~~~~^~~
> drivers/net/ethernet/atheros/ag71xx.c: In function 'ag71xx_open':
> drivers/net/ethernet/atheros/ag71xx.c:1441:32: warning: passing argument 2 of 'ag71xx_hw_se
> t_macaddr' discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
>  1441 |  ag71xx_hw_set_macaddr(ag, ndev->dev_addr);
>       |                            ~~~~^~~~~~~~~~
> drivers/net/ethernet/atheros/ag71xx.c:951:69: note: expected 'unsigned char *' but argument
>  is of type 'const unsigned char *'
>   951 | static void ag71xx_hw_set_macaddr(struct ag71xx *ag, unsigned char *mac)
>       |                                                      ~~~~~~~~~~~~~~~^~~
> 
> [...]

Here is the summary with links:
  - [net-next,v1,1/1] net: ag71xx: fix discards 'const' qualifier warning
    https://git.kernel.org/netdev/net-next/c/225b0ed27e6a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


