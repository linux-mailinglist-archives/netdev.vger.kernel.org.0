Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B29566A97C
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 06:50:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbjANFu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Jan 2023 00:50:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbjANFu0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Jan 2023 00:50:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59F893A8F;
        Fri, 13 Jan 2023 21:50:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2717CB82314;
        Sat, 14 Jan 2023 05:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A663AC433F0;
        Sat, 14 Jan 2023 05:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673675418;
        bh=opp2z8DhH7GhBl1WVDSZx7oeRGBPac71PULhGVMa5rc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ermLpVtlRIK/2DT2t5FxkTnWWHz3NOQ93hXC6StetYcXmu9EdahdfhKz562c4X1FO
         QYCs3brifBI9nFU5+pGpV+WWajje99OmV2CEeXEtRfJ+P7c6m+Ttjh7WFYz8f6lgcf
         MK5lKIzJTW824vyPWOPWsdZy7ClKkY95zP9f5csi4u6WETfbGlaXhn3bWV3N7QzkfD
         Sq2oihkQ+1+1aCP1VHTfDnj7dQd7tK9rpFX6K9slvTEeO3/tFHFxlAhxse/UZbDOVQ
         lZzCLDo5SSu/8GHLbt/U3GczXsMOJCPyYRPtvaOVjAhuyQzQwjWtsAGCzdx0czyukU
         BBet+xBUvsaSA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 83EEEC395C8;
        Sat, 14 Jan 2023 05:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net-next 1/1] plca.c: fix obvious mistake in checking
 retval
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167367541853.15756.10963343311125406484.git-patchwork-notify@kernel.org>
Date:   Sat, 14 Jan 2023 05:50:18 +0000
References: <f2277af8951a51cfee2fb905af8d7a812b7beaf4.1673616357.git.piergiorgio.beruto@gmail.com>
In-Reply-To: <f2277af8951a51cfee2fb905af8d7a812b7beaf4.1673616357.git.piergiorgio.beruto@gmail.com>
To:     Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, o.rempel@pengutronix.de,
        mailhol.vincent@wanadoo.fr, sudheer.mogilappagari@intel.com,
        sbhatta@marvell.com, linux-doc@vger.kernel.org,
        wangjie125@huawei.com, corbet@lwn.net, lkp@intel.com,
        gal@nvidia.com, gustavoars@kernel.org, bagasdotme@gmail.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 13 Jan 2023 14:26:35 +0100 you wrote:
> Revert a wrong fix that was done during the review process. The
> intention was to substitute "if(ret < 0)" with "if(ret)".
> Unfortunately, the intended fix did not meet the code.
> Besides, after additional review, it was decided that "if(ret < 0)"
> was actually the right thing to do.
> 
> Fixes: 8580e16c28f3 ("net/ethtool: add netlink interface for the PLCA RS")
> Signed-off-by: Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> 
> [...]

Here is the summary with links:
  - [v3,net-next,1/1] plca.c: fix obvious mistake in checking retval
    https://git.kernel.org/netdev/net-next/c/28dbf774bc87

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


