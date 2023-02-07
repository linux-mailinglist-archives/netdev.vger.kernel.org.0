Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B07BE68CF94
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 07:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbjBGGk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 01:40:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230170AbjBGGkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 01:40:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 336B122A22;
        Mon,  6 Feb 2023 22:40:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B5278B816E1;
        Tue,  7 Feb 2023 06:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5A772C433D2;
        Tue,  7 Feb 2023 06:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675752019;
        bh=GgmMa/hW/qPclk4cx2xKmUN6z8eQ0eDk/hanLVDkJOM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PfBzQ+bFq8s2PLUACgvGoXw7Ep4ebyrT+x9EJF5FRIEEbQRIt0L7xD9t/02T8T3GP
         +TDo4c9G8rhNC87Fhf4a+IExdqSjemDqAQpdNsb/KeYWjKspGU5YchGO7Gar+ZenCM
         D8Yp6Uv6GzQyoCVdEQuuL5CrrWAy21YC8qEK+LMVSpqICBIPYta9D/+zqh0zBg39L4
         NxapeHLP3NN+RpF0pTrn6uPndMoqjxV5a+UmdrevltQY3GLTOdn/SZck45AtAi96oD
         jgtgr/ZjOF6YM5p1eEpv1cQc+3Lo7bm5Ycgylr32M2qSPFsZydgYddlNB5Cq6GV++p
         9C7UDWky6apXA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 416C1E55F09;
        Tue,  7 Feb 2023 06:40:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] amd-xgbe: fix mismatched prototype
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167575201926.385.6211179782970890907.git-patchwork-notify@kernel.org>
Date:   Tue, 07 Feb 2023 06:40:19 +0000
References: <20230203121553.2871598-1-arnd@kernel.org>
In-Reply-To: <20230203121553.2871598-1-arnd@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Shyam-sundar.S-k@amd.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, Raju.Rangoju@amd.com,
        arnd@arndb.de, thomas.lendacky@amd.com, andrew@lunn.ch,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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

On Fri,  3 Feb 2023 13:15:36 +0100 you wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The forward declaration was introduced with a prototype that does
> not match the function definition:
> 
> drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c:2166:13: error: conflicting types for 'xgbe_phy_perform_ratechange' due to enum/integer mismatch; have 'void(struct xgbe_prv_data *, enum xgbe_mb_cmd,  enum xgbe_mb_subcmd)' [-Werror=enum-int-mismatch]
>  2166 | static void xgbe_phy_perform_ratechange(struct xgbe_prv_data *pdata,
>       |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c:391:13: note: previous declaration of 'xgbe_phy_perform_ratechange' with type 'void(struct xgbe_prv_data *, unsigned int,  unsigned int)'
>   391 | static void xgbe_phy_perform_ratechange(struct xgbe_prv_data *pdata,
>       |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> [...]

Here is the summary with links:
  - amd-xgbe: fix mismatched prototype
    https://git.kernel.org/netdev/net-next/c/bbe641866318

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


