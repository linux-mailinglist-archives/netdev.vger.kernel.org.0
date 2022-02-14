Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED0424B51EA
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 14:40:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354488AbiBNNkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 08:40:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354462AbiBNNkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 08:40:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E7D94A3CB;
        Mon, 14 Feb 2022 05:40:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE5EC6150B;
        Mon, 14 Feb 2022 13:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3F0D4C36AE2;
        Mon, 14 Feb 2022 13:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644846011;
        bh=4T1Tqdk5SogHHJiSp6CWK0qg1zInEsqzVOwmJuDHDwU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TGbjXWKTwfJ3/W8m6tW+nqSevJjeyMBRPJALiLWEC7PLz4Ldmjq+71b+Y9s5TW5YI
         bGKE+wIWPX9J+W/3ovdcGyXCL+q3Kpe+meiK2T7b1fPHUK3/ap13SEhfGnKkhjQIe7
         Ly7G4LH7BAZaJuN8ijaU0iQ9RyjiVzNIJ8RIcCistMcDcc4uARjtPXlSvpzwJrX1Lj
         jDpr+AgDBiuCzYnzkH1BEq4vWw09Nh0dIa1DW+0X6iX33C0o3gflWEXfGxMf1+wRcx
         TpMJ9evr8+jFJCvOg4Bp5X3uLZiTNO5JGMvYJPTMeWZyWCONBOCoc0OWwt2fK/4brm
         Pzv6/Q8luuOnA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2D3F4E6D458;
        Mon, 14 Feb 2022 13:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v7 net-next 0/4] use bulk reads for ocelot statistics
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164484601117.23487.5745096307974974865.git-patchwork-notify@kernel.org>
Date:   Mon, 14 Feb 2022 13:40:11 +0000
References: <20220213191254.1480765-1-colin.foster@in-advantage.com>
In-Reply-To: <20220213191254.1480765-1-colin.foster@in-advantage.com>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, UNGLinuxDriver@microchip.com,
        alexandre.belloni@bootlin.com, claudiu.manoil@nxp.com,
        vladimir.oltean@nxp.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Sun, 13 Feb 2022 11:12:50 -0800 you wrote:
> Ocelot loops over memory regions to gather stats on different ports.
> These regions are mostly continuous, and are ordered. This patch set
> uses that information to break the stats reads into regions that can get
> read in bulk.
> 
> The motiviation is for general cleanup, but also for SPI. Performing two
> back-to-back reads on a SPI bus require toggling the CS line, holding,
> re-toggling the CS line, sending 3 address bytes, sending N padding
> bytes, then actually performing the read. Bulk reads could reduce almost
> all of that overhead, but require that the reads are performed via
> regmap_bulk_read.
> 
> [...]

Here is the summary with links:
  - [v7,net-next,1/4] net: mscc: ocelot: remove unnecessary stat reading from ethtool
    https://git.kernel.org/netdev/net-next/c/e27d785e60b6
  - [v7,net-next,2/4] net: ocelot: align macros for consistency
    https://git.kernel.org/netdev/net-next/c/65c53595bc2a
  - [v7,net-next,3/4] net: mscc: ocelot: add ability to perform bulk reads
    https://git.kernel.org/netdev/net-next/c/40f3a5c81555
  - [v7,net-next,4/4] net: mscc: ocelot: use bulk reads for stats
    https://git.kernel.org/netdev/net-next/c/d87b1c08f38a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


