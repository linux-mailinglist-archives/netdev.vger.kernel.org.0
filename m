Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2D5C5B02C0
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 13:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbiIGLUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 07:20:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiIGLUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 07:20:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEC987D1F9;
        Wed,  7 Sep 2022 04:20:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 62EA4B81C29;
        Wed,  7 Sep 2022 11:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0BE35C433B5;
        Wed,  7 Sep 2022 11:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662549615;
        bh=k8PfALuiQbwc0QDg1tqPOjpnoonAdF7UOcRkN54cpJQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZnzYVoTbIpa53SuWUNQHHhlm24c3/U5zJ3UMU7JpQMkNnkrE7I6JDJ4Nn+fqr9oE3
         69a5wu9kUiJqHzc5ujWYk1t9EEHtEGgyPVqTYN4bq+h2xlz5oHnmn7d72YGCuTOWrA
         UsuT486tRvLhUxq9/XODPt9zEBSkrfE9wGsFxDr3aY8v0CyashcWXdgYEFNEJuzzJM
         BjEsybKYWTcx84gUvDVRrOgEMhqkcO524+OfCCIvqa8dJzKrq8rq2LZWFSKUo/ow+f
         bfRapOrj9YGD8FmgGh0kS5mOL1RpV+acofy7iOBwaD9LqXV0ej5QTgBmOcOynyy+fR
         TgMMQoQPrNweg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E0932C4166E;
        Wed,  7 Sep 2022 11:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 1/2] net: dsa: LAN9303: Add early read to sync
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166254961491.1463.4925500577031178152.git-patchwork-notify@kernel.org>
Date:   Wed, 07 Sep 2022 11:20:14 +0000
References: <20220902213021.23151-1-jerry.ray@microchip.com>
In-Reply-To: <20220902213021.23151-1-jerry.ray@microchip.com>
To:     Jerry Ray <jerry.ray@microchip.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 2 Sep 2022 16:30:20 -0500 you wrote:
> Add initial BYTE_ORDER read to sync the 32-bit accesses over the 16-bit
> mdio bus to improve driver robustness.
> 
> The lan9303 expects two mdio read transactions back-to-back to read a
> 32-bit register. The first read transaction causes the other half of the
> 32-bit register to get latched.  The subsequent read returns the latched
> second half of the 32-bit read. The BYTE_ORDER register is an exception to
> this rule. As it is a constant value, there is no need to latch the second
> half. We read this register first in case there were reads during the boot
> loader process that might have occurred prior to this driver taking over
> ownership of accessing this device.
> 
> [...]

Here is the summary with links:
  - [v2,1/2] net: dsa: LAN9303: Add early read to sync
    https://git.kernel.org/netdev/net-next/c/732f374e23a9
  - [v2,2/2] net: dsa: LAN9303: Add basic support for LAN9354
    https://git.kernel.org/netdev/net-next/c/13248b975038

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


