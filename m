Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E062E5509EF
	for <lists+netdev@lfdr.de>; Sun, 19 Jun 2022 13:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235607AbiFSLAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jun 2022 07:00:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232285AbiFSLAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jun 2022 07:00:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 543A110553;
        Sun, 19 Jun 2022 04:00:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DBE7561018;
        Sun, 19 Jun 2022 11:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 41263C3411D;
        Sun, 19 Jun 2022 11:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655636413;
        bh=X7kcYmvmxSFga3Do3Q9sIMqZ4wFeediR+aGyUKidwAA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Fa9i5L/da9q/dNEOfCkeOwbX4rAovXqM6Va4yJTmmkTj+E/7nBF+WGR5o6/grkPm0
         YXvvunpY/cN9n4YXCAg3TxK3EvzzxtAcwSWVw5OXeSeSli+U7F0peohjoZgSpqDHZe
         E0GnHX35ueyMN51ROkIFhLmEQ/jxkHUEqfJvZxzkoFl5O6zQLQ6JK1yJZeFNbxyemu
         ioXFW7rJnre7SmN5kibJumN0SwMDU23tIvTgBRp5thz557glBm+7DvhFnvt37AWoyE
         ak+mhARKXwXmj1dXDFRH0Y96EVHqAtRW4Ok+s6FOYjBcst64cvIY1FvEN6BsoERF0Q
         Xj7LbLVy78tew==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 22BFCE737F0;
        Sun, 19 Jun 2022 11:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] drivers/net/ethernet/neterion/vxge: Fix a use-after-free bug
 in vxge-main.c
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165563641313.16837.10425130041626423819.git-patchwork-notify@kernel.org>
Date:   Sun, 19 Jun 2022 11:00:13 +0000
References: <20220619141454.3881-1-Wentao_Liang_g@163.com>
In-Reply-To: <20220619141454.3881-1-Wentao_Liang_g@163.com>
To:     Wentao_Liang <Wentao_Liang_g@163.com>
Cc:     jdmason@kudzu.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
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

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun, 19 Jun 2022 22:14:54 +0800 you wrote:
> The pointer vdev points to a memory region adjacent to a net_device
> structure ndev, which is a field of hldev. At line 4740, the invocation
> to vxge_device_unregister unregisters device hldev, and it also releases
> the memory region pointed by vdev->bar0. At line 4743, the freed memory
> region is referenced (i.e., iounmap(vdev->bar0)), resulting in a
> use-after-free vulnerability. We can fix the bug by calling iounmap
> before vxge_device_unregister.
> 
> [...]

Here is the summary with links:
  - drivers/net/ethernet/neterion/vxge: Fix a use-after-free bug in vxge-main.c
    https://git.kernel.org/netdev/net/c/8fc74d18639a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


