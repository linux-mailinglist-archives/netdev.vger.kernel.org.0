Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C681C5359EE
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 09:13:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345925AbiE0HKi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 03:10:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345244AbiE0HKQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 03:10:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4581F689F;
        Fri, 27 May 2022 00:10:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 92E67B82375;
        Fri, 27 May 2022 07:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3CC2DC34113;
        Fri, 27 May 2022 07:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653635413;
        bh=b1pzJfbbSPiuC3V21TqZtn8sDtxbD5D/BbDZd1ybi0c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DRCas9CAScqe9z0jH4uTLWBMdqJwE/7EppbcSAPNH+kfh741tDXfH2m46u0rrqv7j
         YduomOiuaazE2sr9WFW1dpF67+2YRpgUMk4/0n7S0x5j02xyekTL20cgL1V2vyw0LL
         O1sH7lWdP6/wniRbAQq6jkHdUn7ZoHSHa2R9112+s08HsueSQZuZLXJLrj2wUjdSfF
         OwQMH9PQ9S4+ebujHFtnRBe+cPGjWR783XpnzxLbl3AkLgmeIZdMdFzVSfoICSySvA
         02DZUXWPTaXamR7bXnsUNYoGGYkTFjBOlMrm7zbsWEeR4ibaThVCLFm/7Va/hOG/Nv
         rDS/mZBUbEu0Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 199B2EAC081;
        Fri, 27 May 2022 07:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ethernet: ti: am65-cpsw-nuss: Fix some refcount leaks
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165363541310.15180.16359315108898777386.git-patchwork-notify@kernel.org>
Date:   Fri, 27 May 2022 07:10:13 +0000
References: <20220526085211.43913-1-linmq006@gmail.com>
In-Reply-To: <20220526085211.43913-1-linmq006@gmail.com>
To:     Miaoqian Lin <linmq006@gmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, vladimir.oltean@nxp.com, leon@kernel.org,
        grygorii.strashko@ti.com, vigneshr@ti.com, s-vadapalli@ti.com,
        wangqing@vivo.com, chi.minghao@zte.com.cn, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 26 May 2022 12:52:08 +0400 you wrote:
> of_get_child_by_name() returns a node pointer with refcount
> incremented, we should use of_node_put() on it when not need anymore.
> am65_cpsw_init_cpts() and am65_cpsw_nuss_probe() don't release
> the refcount in error case.
> Add missing of_node_put() to avoid refcount leak.
> 
> Fixes: b1f66a5bee07 ("net: ethernet: ti: am65-cpsw-nuss: enable packet timestamping support")
> Fixes: 93a76530316a ("net: ethernet: ti: introduce am65x/j721e gigabit eth subsystem driver")
> Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
> 
> [...]

Here is the summary with links:
  - net: ethernet: ti: am65-cpsw-nuss: Fix some refcount leaks
    https://git.kernel.org/netdev/net/c/5dd89d2fc438

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


