Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2C7A5293B4
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 00:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244522AbiEPWkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 18:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237069AbiEPWkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 18:40:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D0A23EAA0;
        Mon, 16 May 2022 15:40:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BAACB60B32;
        Mon, 16 May 2022 22:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0C0CCC385B8;
        Mon, 16 May 2022 22:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652740813;
        bh=hHH1qHArTkGFBwj6UaB7mwTeQvuPbmIfyY6+B7zbeb0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=D0m91j5JqCiFWbbU0IfkEpUSI0zWGaucWjGlZTaCb8QBnwgtPbf/kLmBxtRqsK5UK
         7rJD1kERj18KQFYEhxaJFJ6I4CdkPguIuoFutXA6KaUxXDnaC0d/84G6KI+L427d/y
         sMHioedB0J7ZQohDbzdvkSFtip3T8YlMJHtzM7StQIfs/ruI5D4Si/+cJUU0u76h4G
         OUDUwPjuusIbWJdjSX8dzZHqAoUgq63jOfqMacKdlfFromuswrj1DZ4MDmie195BQk
         EaS6qYKzFt5vfC2Slpze3mXH7goLfxw1GSEMuSgpOXGmtjlCFRHkWw/CDcLbhfOX4n
         JeAGyWSLMilqg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E422AE8DBBF;
        Mon, 16 May 2022 22:40:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] net: skb: Remove skb_data_area_size()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165274081292.8693.15955361769671914671.git-patchwork-notify@kernel.org>
Date:   Mon, 16 May 2022 22:40:12 +0000
References: <20220513173400.3848271-1-ricardo.martinez@linux.intel.com>
In-Reply-To: <20220513173400.3848271-1-ricardo.martinez@linux.intel.com>
To:     Martinez@ci.codeaurora.org,
        Ricardo <ricardo.martinez@linux.intel.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com, andriy.shevchenko@linux.intel.com,
        dinesh.sharma@intel.com, ilpo.jarvinen@linux.intel.com,
        moises.veleta@intel.com, sreehari.kancharla@intel.com
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 13 May 2022 10:33:58 -0700 you wrote:
> This patch series removes the skb_data_area_size() helper,
> replacing it in t7xx driver with the size used during skb allocation.
> 
> https://lore.kernel.org/netdev/CAHNKnsTmH-rGgWi3jtyC=ktM1DW2W1VJkYoTMJV2Z_Bt498bsg@mail.gmail.com/
> 
> Ricardo Martinez (2):
>   net: wwan: t7xx: Avoid calls to skb_data_area_size()
>   net: skb: Remove skb_data_area_size()
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: wwan: t7xx: Avoid calls to skb_data_area_size()
    https://git.kernel.org/netdev/net-next/c/262d98b1193f
  - [net-next,2/2] net: skb: Remove skb_data_area_size()
    https://git.kernel.org/netdev/net-next/c/89af2ce2d95c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


