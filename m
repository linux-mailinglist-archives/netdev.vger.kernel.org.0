Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64F55538AAC
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 06:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243878AbiEaEkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 00:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238541AbiEaEkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 00:40:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 754A1939FD;
        Mon, 30 May 2022 21:40:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E639B80FAF;
        Tue, 31 May 2022 04:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D1CDAC34114;
        Tue, 31 May 2022 04:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653972011;
        bh=YYGMHB1tRZgyGr3hkrF7aXliEHOxYxSinGWXm7jnZpg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hATqCSBioHx7P0SLQNKcXrlj/DAH/MMgdYTSrgqSIrLsoiEDASflQVIbOS12i9r8l
         gyeuU7EePR+hDBipkNNWQ/lRow9xkQRObgnboNehmLONRWUcAt+fwwA/LGwqIlFsSG
         u5D/tkvf8NbWOt+BnNsuX6GgTLKDzgajm0W4Yo2BuMaTMYVlZUbUn6OeAYMLDpa7//
         DlBmqxGusX1Z0Gz2ohHBReLRGSy4zWyzXTA88RDLKgHR4qov6dlLQ+5/tK+AhfYsSM
         dwzLUTrAo2h2Fvb4/C3IQSJLXP6kdDcj5FKnExitM4g5zrE7pdfhyMK9CldQ47r943
         jyUibhI2Np5fA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id ACFB3F0394E;
        Tue, 31 May 2022 04:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: phy: at803x: disable WOL at probe
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165397201170.21793.7926133541403141360.git-patchwork-notify@kernel.org>
Date:   Tue, 31 May 2022 04:40:11 +0000
References: <20220527084935.235274-1-viorel.suman@oss.nxp.com>
In-Reply-To: <20220527084935.235274-1-viorel.suman@oss.nxp.com>
To:     Viorel Suman (OSS) <viorel.suman@oss.nxp.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, luoj@codeaurora.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com,
        viorel.suman@nxp.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 27 May 2022 11:49:34 +0300 you wrote:
> From: Viorel Suman <viorel.suman@nxp.com>
> 
> Before 7beecaf7d507b ("net: phy: at803x: improve the WOL feature") patch
> "at803x_get_wol" implementation used AT803X_INTR_ENABLE_WOL value to set
> WAKE_MAGIC flag, and now AT803X_WOL_EN value is used for the same purpose.
> The problem here is that the values of these two bits are different after
> hardware reset: AT803X_INTR_ENABLE_WOL=0 after hardware reset, but
> AT803X_WOL_EN=1. So now, if called right after boot, "at803x_get_wol" will
> set WAKE_MAGIC flag, even if WOL function is not enabled by calling
> "at803x_set_wol" function. The patch disables WOL function on probe thus
> the behavior is consistent.
> 
> [...]

Here is the summary with links:
  - [v2] net: phy: at803x: disable WOL at probe
    https://git.kernel.org/netdev/net/c/d7cd5e06c9dd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


