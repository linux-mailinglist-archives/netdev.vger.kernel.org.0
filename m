Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3DAE5EEC13
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 04:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234037AbiI2Cu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 22:50:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234315AbiI2Cu1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 22:50:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D794A2A72A
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 19:50:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 411CA6200C
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 02:50:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8F9EAC433B5;
        Thu, 29 Sep 2022 02:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664419825;
        bh=7WLDio6Ebyjuebf3lHH2UlLKIE4MubqVAJkXUv45UAQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FgjiEXtYVVnp1mRDGe35tU7112wnr0JSzrBGOUqcxQddqm2SxdSlajtibbYUrep/v
         Vb6oppDYh1ibzawnlT/MuRHk6HJOquEPYtTusTCH5dDIEYAxGc644x8cgxYtAkMPJ6
         Ck7eCrrLmdNF3djrMudoe9bTr2tzt8v2+YQwgDeLGiS7lcyZAIaqccKrsdsr4pisjE
         w8WdzX4x8Gij+s91ori/KIhYi+xnkcuJmJ+XGIcA6XltHPcYiDxWaVYKF8mCe4H7Wa
         6dRJ+V8Czq90kA6YtfztxC5tkATSpXCTQw/lffNkNQOSNYsUHcAq4IOHBN3E3XN2Lx
         +bhEG6P8OoHfg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7224AE4D018;
        Thu, 29 Sep 2022 02:50:25 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/5] Rework resource allocation in Felix DSA driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166441982546.2371.1761318853116155565.git-patchwork-notify@kernel.org>
Date:   Thu, 29 Sep 2022 02:50:25 +0000
References: <20220927191521.1578084-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220927191521.1578084-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, colin.foster@in-advantage.com, fido_max@inbox.ru
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 27 Sep 2022 22:15:15 +0300 you wrote:
> The Felix DSA driver controls NXP variations of Microchip switches.
> Colin Foster is trying to add support in this driver for "genuine"
> Microchip hardware, but some of the NXP-isms in this driver need to go
> away before that happens cleanly.
> https://patchwork.kernel.org/project/netdevbpf/cover/20220926002928.2744638-1-colin.foster@in-advantage.com/
> 
> The starting point was Colin's patch 08/14 "net: dsa: felix: update
> init_regmap to be string-based", and this continues to be the central
> theme here, but things are done differently.
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] net: dsa: felix: remove felix_info :: imdio_res
    https://git.kernel.org/netdev/net-next/c/5fc080de89f1
  - [net-next,2/5] net: dsa: felix: remove felix_info :: imdio_base
    https://git.kernel.org/netdev/net-next/c/1382ba68a053
  - [net-next,3/5] net: dsa: felix: remove felix_info :: init_regmap
    https://git.kernel.org/netdev/net-next/c/8f66c64bfca3
  - [net-next,4/5] net: dsa: felix: use DEFINE_RES_MEM_NAMED for resources
    https://git.kernel.org/netdev/net-next/c/044d447a801f
  - [net-next,5/5] net: dsa: felix: update init_regmap to be string-based
    https://git.kernel.org/netdev/net-next/c/1109b97b6161

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


