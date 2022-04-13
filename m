Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8FC14FF614
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 13:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235202AbiDMLwj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 07:52:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235314AbiDMLwh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 07:52:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA4F42DA96;
        Wed, 13 Apr 2022 04:50:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5365061DF5;
        Wed, 13 Apr 2022 11:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A5B25C385A6;
        Wed, 13 Apr 2022 11:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649850615;
        bh=MQBp0boSDnHBIUAmB9tPj/kkhCcJGqqMg3aBm1m2UYw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mDeRYCbsh//1wJYEKAD+oqTKsQdBCZonb7FAG5sw45BWIRlVDoU7WWhG10IpU9pce
         LUL8hUBJ2v3d7l9xIJ68lthRjbOeiIBSkIsNduc2qF/eBCC1cL4b8X1feNdwJSAzb/
         HYaZ4lNdtD65VMSbGjnPGGVKIsD14IocpmupgPz/IGwRObo7LpHaNqjB5MQeEjxytd
         gNBkLYibhip2oa0lhaZxTzzHw4PNy6iKT9GXql3P6yiDB+rwzNGUGHhWNBkiIZcJ7H
         n25xCVzaKkJnMNwR1Cpsa5iMKHFIR87QnQ0bTO8qsqcpm3KRiwLu6RyIHWT4gkB5tQ
         NsR+5kcXCXD+w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8A19AE73CC8;
        Wed, 13 Apr 2022 11:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 0/3] net: ethernet: ti: enable bc/mc storm
 prevention support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164985061556.24768.770404239682926455.git-patchwork-notify@kernel.org>
Date:   Wed, 13 Apr 2022 11:50:15 +0000
References: <20220412102929.30719-1-grygorii.strashko@ti.com>
In-Reply-To: <20220412102929.30719-1-grygorii.strashko@ti.com>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, kishon@ti.com, vigneshr@ti.com,
        linux-omap@vger.kernel.org, tony@atomide.com, andrew@lunn.ch,
        vladimir.oltean@nxp.com
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

On Tue, 12 Apr 2022 13:29:26 +0300 you wrote:
> Hi
> 
> This series first adds supports for the ALE feature to rate limit number ingress
> broadcast(BC)/multicast(MC) packets per/sec which main purpose is BC/MC storm
> prevention.
> 
> And then enables corresponding support for ingress broadcast(BC)/multicast(MC)
> packets rate limiting for TI CPSW switchdev and AM65x/J221E CPSW_NUSS drivers by
> implementing HW offload for simple tc-flower with policer action with matches
> on dst_mac/mask:
>  - ff:ff:ff:ff:ff:ff/ff:ff:ff:ff:ff:ff has to be used for BC packets rate
> limiting (exact match)
>  - 01:00:00:00:00:00/01:00:00:00:00:00 fixed value has to be used for MC
> packets rate limiting
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/3] drivers: net: cpsw: ale: add broadcast/multicast rate limit support
    https://git.kernel.org/netdev/net-next/c/e3a5e33fae99
  - [net-next,v3,2/3] net: ethernet: ti: am65-cpsw: enable bc/mc storm prevention support
    https://git.kernel.org/netdev/net-next/c/5ec836be11b3
  - [net-next,v3,3/3] net: ethernet: ti: cpsw_new: enable bc/mc storm prevention support
    https://git.kernel.org/netdev/net-next/c/127c9e970f59

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


