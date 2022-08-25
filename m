Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A63065A0742
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 04:31:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235320AbiHYCaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 22:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232141AbiHYCaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 22:30:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E85403DBEB;
        Wed, 24 Aug 2022 19:30:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3D0A4B82704;
        Thu, 25 Aug 2022 02:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EF691C433B5;
        Thu, 25 Aug 2022 02:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661394615;
        bh=lYkL0bzko7RbCa0vV5Au9vOq2SC3YiUbsU95CPkA5j0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CJaFsj4ciGkWh/NQFbA9oihDUqo3o6hdc1sEe6Br9b71scrWkaMhyzJFp3nRqFswf
         Sq+F18vDJKh4H0u6bxw9VjjZNG6v1/bKkg3HPyj2CUAFZoBu3e7ctYSslS41/rrK4J
         XZZLqFpOUyRFIe+/5ll++0WR7s/ltIvQSQtOvMaOoqXoy33IbQOhREqi7SN32VFDad
         gao08YVv1bCJPMQBNmsTFi+k+9u/gtOrpVEngj3twcpOX5/SOnN3MCXUDu66Oh9FN9
         akjpB3y0QmjH6w1JCM+7vU9tMeHNSuuCBqSEOinIcI1ax8c4wQCNXPfnsVZCi7vYnx
         /TiXhPGIFfl2g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CD499C0C3EC;
        Thu, 25 Aug 2022 02:30:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ethernet: ti: davinci_mdio: fix build for mdio
 bitbang uses
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166139461483.28757.164890772424313264.git-patchwork-notify@kernel.org>
Date:   Thu, 25 Aug 2022 02:30:14 +0000
References: <20220824024216.4939-1-rdunlap@infradead.org>
In-Reply-To: <20220824024216.4939-1-rdunlap@infradead.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     netdev@vger.kernel.org, grygorii.strashko@ti.com,
        r-gunasekaran@ti.com, linux-omap@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, naresh.kamboju@linaro.org,
        sudipm.mukherjee@gmail.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 23 Aug 2022 19:42:16 -0700 you wrote:
> davinci_mdio.c uses mdio bitbang APIs, so it should select
> MDIO_BITBANG to prevent build errors.
> 
> arm-linux-gnueabi-ld: drivers/net/ethernet/ti/davinci_mdio.o: in function `davinci_mdio_remove':
> drivers/net/ethernet/ti/davinci_mdio.c:649: undefined reference to `free_mdio_bitbang'
> arm-linux-gnueabi-ld: drivers/net/ethernet/ti/davinci_mdio.o: in function `davinci_mdio_probe':
> drivers/net/ethernet/ti/davinci_mdio.c:545: undefined reference to `alloc_mdio_bitbang'
> arm-linux-gnueabi-ld: drivers/net/ethernet/ti/davinci_mdio.o: in function `davinci_mdiobb_read':
> drivers/net/ethernet/ti/davinci_mdio.c:236: undefined reference to `mdiobb_read'
> arm-linux-gnueabi-ld: drivers/net/ethernet/ti/davinci_mdio.o: in function `davinci_mdiobb_write':
> drivers/net/ethernet/ti/davinci_mdio.c:253: undefined reference to `mdiobb_write'
> 
> [...]

Here is the summary with links:
  - [net-next] net: ethernet: ti: davinci_mdio: fix build for mdio bitbang uses
    https://git.kernel.org/netdev/net-next/c/35bbe652c421

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


