Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 358E7567B83
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 03:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbiGFBaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 21:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbiGFBaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 21:30:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C395E17E33;
        Tue,  5 Jul 2022 18:30:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 73A06B81A63;
        Wed,  6 Jul 2022 01:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3B9B8C341D0;
        Wed,  6 Jul 2022 01:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657071013;
        bh=3oalzuiYe0zGBaUFaK8SCjg/XsPgiKV0GjpE/QNaGUY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=maCMwqSLEFfSePEEp4CNDNsM2XjZl79HP42cugcl9fifVZ/eg7Ug2qOkvkczf9Pmm
         k4S9IAclDQLRHQLDDgb2vXvcEubjAxrcMDwoWfQmSUSrE4s65J4nEpVHuAQkj/mDPp
         9jcRG5yulcz2pO/XVV8Sm2tkhi3Y4lbOUN0eO3Y65iEIo7cR0AFZi+HJDG4wkoI1Kx
         e1UJwa4B1W0ow60RNAiBD5n73U9dnT1MxfGuS0fpHhdhhRVMZJaOqC9oS2AB66kUEE
         +/ilLfgoMVf8ZOX3ANW3H3ADNwJcKNGRfKG4htDlTdysdA5W9w1Yid4awuiUWHITKi
         DAcNJ8jVy7TWQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 24CF6E45BD8;
        Wed,  6 Jul 2022 01:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/2] net: sched: provide shim definitions for
 taprio_offload_{get,free}
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165707101314.30412.7030949936791526390.git-patchwork-notify@kernel.org>
Date:   Wed, 06 Jul 2022 01:30:13 +0000
References: <20220704190241.1288847-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220704190241.1288847-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, xiaoliang.yang_1@nxp.com,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        vinicius.gomes@intel.com, fido_max@inbox.ru,
        colin.foster@in-advantage.com, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  4 Jul 2022 22:02:40 +0300 you wrote:
> All callers of taprio_offload_get() and taprio_offload_free() prior to
> the blamed commit are conditionally compiled based on CONFIG_NET_SCH_TAPRIO.
> 
> felix_vsc9959.c is different; it provides vsc9959_qos_port_tas_set()
> even when taprio is compiled out.
> 
> Provide shim definitions for the functions exported by taprio so that
> felix_vsc9959.c is able to compile. vsc9959_qos_port_tas_set() in that
> case is dead code anyway, and ocelot_port->taprio remains NULL, which is
> fine for the rest of the logic.
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: sched: provide shim definitions for taprio_offload_{get,free}
    https://git.kernel.org/netdev/net-next/c/d7be266adbfd
  - [net-next,2/2] net: dsa: felix: build as module when tc-taprio is module
    https://git.kernel.org/netdev/net-next/c/10ed11ab6399

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


