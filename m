Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82C2D654343
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 15:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbiLVOkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 09:40:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbiLVOkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 09:40:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEE672A27B;
        Thu, 22 Dec 2022 06:40:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5FF9AB81DCC;
        Thu, 22 Dec 2022 14:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 18750C433D2;
        Thu, 22 Dec 2022 14:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671720016;
        bh=mesbrDVl2N17I6VECslJAXZSNpf4I6xgG+gsEQAKHk0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hDeKgm0+sB1v53Ux0hyaN0In/agWxbcJQRzx5ICi/dnrXI2mfOkNFPbGU4XbckDbE
         NvZWnjRtZEnSsVjJAWrkOrdTvhw1HRto7J4mKidJF2enaW3y95g4aRSL3C2wGQgAUj
         RGhbAiEpy8cosbSqVsaCeb4fiRpVSQJoQ0Nm1gzsOgV0Bz/QRlIdoKqUAXZ//+86Jk
         mjcrk2gmWj73gkrOnws/tvBOMf695vECzpllC4ctazCaE0lPm3OHOzMN7PXyuYC/lE
         Tzh59ilAcF543mMfN6dB9VQ69OXPyMNkbvTg+y00hYeSG5mFLyLvGKJoitMLHVS/uu
         lcluN9MIKV1UA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0045FC395EA;
        Thu, 22 Dec 2022 14:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] veth: Fix race with AF_XDP exposing old or uninitialized
 descriptors
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167172001599.2279.15742715253058774343.git-patchwork-notify@kernel.org>
Date:   Thu, 22 Dec 2022 14:40:15 +0000
References: <20221220185903.1105011-1-sbohrer@cloudflare.com>
In-Reply-To: <20221220185903.1105011-1-sbohrer@cloudflare.com>
To:     Shawn Bohrer <sbohrer@cloudflare.com>
Cc:     magnus.karlsson@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, bjorn@kernel.org, kernel-team@cloudflare.com,
        davem@davemloft.net
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 20 Dec 2022 12:59:03 -0600 you wrote:
> When AF_XDP is used on on a veth interface the RX ring is updated in two
> steps.  veth_xdp_rcv() removes packet descriptors from the FILL ring
> fills them and places them in the RX ring updating the cached_prod
> pointer.  Later xdp_do_flush() syncs the RX ring prod pointer with the
> cached_prod pointer allowing user-space to see the recently filled in
> descriptors.  The rings are intended to be SPSC, however the existing
> order in veth_poll allows the xdp_do_flush() to run concurrently with
> another CPU creating a race condition that allows user-space to see old
> or uninitialized descriptors in the RX ring.  This bug has been observed
> in production systems.
> 
> [...]

Here is the summary with links:
  - veth: Fix race with AF_XDP exposing old or uninitialized descriptors
    https://git.kernel.org/netdev/net/c/fa349e396e48

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


