Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FD66647521
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 18:50:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbiLHRuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 12:50:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbiLHRuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 12:50:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1ED98B3AE;
        Thu,  8 Dec 2022 09:50:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AF046B825A9;
        Thu,  8 Dec 2022 17:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 64905C433D2;
        Thu,  8 Dec 2022 17:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670521815;
        bh=zBK5KvggkjJJ3BCPGvnHXC2UKVb94RIF663iWX+BBgw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mIh+kFn2j8DROl+M//spbSOyIx36jsX2OPrau3yfynAHXwvau11vdk0zSmz4hZGnA
         NqRdS/52/pQwIaFAsbHKvxlTq8zQrEIsP++TWOKWz9y3sVmQdbYBIgUNiRp5c8WpsA
         FH9cjMb3FqRVLyAJezyqFBGRStLrDK5TZH8i5Ofx3QUPUlYVtw+eyoyrWH7y58E90A
         Unyq7mCR24K+hsAFsfuqaGRN9TtUiXg9Js1Jir0WXPabo4+TcFpjl5T6vO6LDvpWtw
         ShKLEzLxCk5EP53fqJLANDOaD3vGdjSMc0INajeno28uEvnyWfaPtA6n+MrCJv2D08
         8mtd4M8hxiZtQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 47E75E1B4D8;
        Thu,  8 Dec 2022 17:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH RESEND v2] net: dsa: sja1105: avoid out of bounds access in
 sja1105_init_l2_policing()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167052181528.971.4904636382041460131.git-patchwork-notify@kernel.org>
Date:   Thu, 08 Dec 2022 17:50:15 +0000
References: <20221207132347.38698-1-radu-nicolae.pirea@oss.nxp.com>
In-Reply-To: <20221207132347.38698-1-radu-nicolae.pirea@oss.nxp.com>
To:     Radu Nicolae Pirea (OSS) <radu-nicolae.pirea@oss.nxp.com>
Cc:     olteanv@gmail.com, andrew@lunn.ch, f.fainelli@gmail.com,
        davem@davemloft.net, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
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
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  7 Dec 2022 15:23:47 +0200 you wrote:
> The SJA1105 family has 45 L2 policing table entries
> (SJA1105_MAX_L2_POLICING_COUNT) and SJA1110 has 110
> (SJA1110_MAX_L2_POLICING_COUNT). Keeping the table structure but
> accounting for the difference in port count (5 in SJA1105 vs 10 in
> SJA1110) does not fully explain the difference. Rather, the SJA1110 also
> has L2 ingress policers for multicast traffic. If a packet is classified
> as multicast, it will be processed by the policer index 99 + SRCPORT.
> 
> [...]

Here is the summary with links:
  - [RESEND,v2] net: dsa: sja1105: avoid out of bounds access in sja1105_init_l2_policing()
    https://git.kernel.org/netdev/net/c/f8bac7f9fdb0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


