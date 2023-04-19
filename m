Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 374F46E726F
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 06:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231580AbjDSEuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 00:50:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231355AbjDSEuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 00:50:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BC9C3C0A;
        Tue, 18 Apr 2023 21:50:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BADA263AE2;
        Wed, 19 Apr 2023 04:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1ABD1C4339B;
        Wed, 19 Apr 2023 04:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681879818;
        bh=heaxAGW8BqkyV5Xaxa7qN+YraeK/8HWCjkrKGdPZiXA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qCxqNten3hwWo85osv8Jjdhgxd9D4Q8vCwJw+ap6VvL3/7Yw+ms1pDO4M44Jc84Ti
         XNEbgtb8zSHDxPABQqSiHSXJ3pC1yQySkvrimcHPCfIxYoQVkyqL/ZHTQrMtVMNHAH
         LAYU34mVJvptJAyaXLWBfXaP+qjRHL5P05hh27EyXYaQYUDz/TzahBoCtqZEwOht8/
         askD/N4vnZ0NtiiVggE8WJBLxw23uRK6nt9rXcgoXOcW3237c8TT1JJZulaDJI1Wie
         x/N2LKzMhfbk1RwKJyaAqZjQxwAnDXHGpPhvyRA9phyaCCI/yDikbr4pJaCSh3crNs
         BYRq5kYG8kSxw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F2CAFE270E4;
        Wed, 19 Apr 2023 04:50:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: mscc: ocelot: remove incompatible prototypes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168187981798.31004.11296646882244575250.git-patchwork-notify@kernel.org>
Date:   Wed, 19 Apr 2023 04:50:17 +0000
References: <20230417205531.1880657-1-arnd@kernel.org>
In-Reply-To: <20230417205531.1880657-1-arnd@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, jacob.e.keller@intel.com, arnd@arndb.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 17 Apr 2023 22:55:25 +0200 you wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The types for the register argument changed recently, but there are
> still incompatible prototypes that got left behind, and gcc-13 warns
> about these:
> 
> In file included from drivers/net/ethernet/mscc/ocelot.c:13:
> drivers/net/ethernet/mscc/ocelot.h:97:5: error: conflicting types for 'ocelot_port_readl' due to enum/integer mismatch; have 'u32(struct ocelot_port *, u32)' {aka 'unsigned int(struct ocelot_port *, unsigned int)'} [-Werror=enum-int-mismatch]
>    97 | u32 ocelot_port_readl(struct ocelot_port *port, u32 reg);
>       |     ^~~~~~~~~~~~~~~~~
> 
> [...]

Here is the summary with links:
  - net: mscc: ocelot: remove incompatible prototypes
    https://git.kernel.org/netdev/net-next/c/33d74c8ff5ce

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


