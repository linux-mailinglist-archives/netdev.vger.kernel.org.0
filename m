Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4160674A02
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 04:20:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbjATDUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 22:20:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjATDUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 22:20:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BD47C0;
        Thu, 19 Jan 2023 19:20:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B7A5561DEF;
        Fri, 20 Jan 2023 03:20:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1BEABC433F1;
        Fri, 20 Jan 2023 03:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674184821;
        bh=jHP/KfWRf0rvAsjTo62SlFaUXRfLpQHjGLZgs37HA/Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RdAEBAJhYVgvVjAK+ZcD1cZy5KyT7Bo21zsQvlF2VTwAH21IpzJE+gNPQzyY+/DNp
         /hKsrlOfsNa1O7GGQzMTxVd49D0KV8WTvqFSfVI6SNGaU5xwkeOpf1NXAOVNDXxTsb
         XkunSeI4Sepf5E8+kqX9dbEdSLTqeCjREQBIADbSmcbo+hH2GOcCrIfssU66ceGXfi
         Tt6Wby55uToUrWrXcC2GBuwjLXXo8z/iLw6DMs51QuO+zMpWNevRrSPM5IfaGQ64m8
         ScMN6tADReoB5upTcQ+Qu/TCTnC8LoZUECyAzrf+w4AapzPanTuw2bu6RDPNun2v6Z
         uvC9eTRpjpklw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F3107C43147;
        Fri, 20 Jan 2023 03:20:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 1/1] net: phy: fix use of uninit variable when
 setting PLCA config
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167418482098.4845.761688179914150843.git-patchwork-notify@kernel.org>
Date:   Fri, 20 Jan 2023 03:20:20 +0000
References: <f22f1864165a8dbac8b7a2277f341bc8e7a7b70d.1674056765.git.piergiorgio.beruto@gmail.com>
In-Reply-To: <f22f1864165a8dbac8b7a2277f341bc8e7a7b70d.1674056765.git.piergiorgio.beruto@gmail.com>
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

On Wed, 18 Jan 2023 16:47:31 +0100 you wrote:
> Coverity reported the following:
> 
> *** CID 1530573:    (UNINIT)
> drivers/net/phy/phy-c45.c:1036 in genphy_c45_plca_set_cfg()
> 1030     				return ret;
> 1031
> 1032     			val = ret;
> 1033     		}
> 1034
> 1035     		if (plca_cfg->node_cnt >= 0)
> vvv     CID 1530573:    (UNINIT)
> vvv     Using uninitialized value "val".
> 1036     			val = (val & ~MDIO_OATC14_PLCA_NCNT) |
> 1037     			      (plca_cfg->node_cnt << 8);
> 1038
> 1039     		if (plca_cfg->node_id >= 0)
> 1040     			val = (val & ~MDIO_OATC14_PLCA_ID) |
> 1041     			      (plca_cfg->node_id);
> drivers/net/phy/phy-c45.c:1076 in genphy_c45_plca_set_cfg()
> 1070     				return ret;
> 1071
> 1072     			val = ret;
> 1073     		}
> 1074
> 1075     		if (plca_cfg->burst_cnt >= 0)
> vvv     CID 1530573:    (UNINIT)
> vvv     Using uninitialized value "val".
> 1076     			val = (val & ~MDIO_OATC14_PLCA_MAXBC) |
> 1077     			      (plca_cfg->burst_cnt << 8);
> 1078
> 1079     		if (plca_cfg->burst_tmr >= 0)
> 1080     			val = (val & ~MDIO_OATC14_PLCA_BTMR) |
> 1081     			      (plca_cfg->burst_tmr);
> 
> [...]

Here is the summary with links:
  - [v2,net-next,1/1] net: phy: fix use of uninit variable when setting PLCA config
    https://git.kernel.org/netdev/net-next/c/1038bfb23649

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


