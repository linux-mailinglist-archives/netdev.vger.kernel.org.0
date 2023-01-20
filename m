Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26C2D675123
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 10:31:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbjATJbH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 04:31:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbjATJbG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 04:31:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35EE4A503A;
        Fri, 20 Jan 2023 01:30:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C22DB82149;
        Fri, 20 Jan 2023 09:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F0D1FC433EF;
        Fri, 20 Jan 2023 09:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674207019;
        bh=97eI/DzcEUwW2P+NrxiMBczLVyLZV62pIyAx6vShmiQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aKs5JidAhcuZ+EXnrOFIMksDiys/RhVMeErD4zr60UiIuTIXEpL8fJjksgnDMSqNv
         oQCjZKthm/KIzXJdm64DJCTvS8fhvCLb0AkuvuJargLtHLVwNLodnfQDj+ggbJ7ZEI
         ewqSMnRZXUy1OVXhL+ktTMuv7tMJV7EW+9T8Uivxzzi36dfnYIpmJss2n8vuI1LnIs
         Vto+WIEr3tPHGg1H8ScMCpPaOIDvwYBNh9XXYfSh2TcFCA5IMrICc7x9XJZOnzMcw1
         B6tSAl8KdMPBg6odc4vMWxiU0DrfoUDhRvM8UqODB4Mj+ps9Chx8Nh+eDIeiufua1g
         4p6zDDdA8E8JA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D1A7BE54D2B;
        Fri, 20 Jan 2023 09:30:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net RESEND] net: stmmac: enable all safety features by default
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167420701885.26805.13129690985056892754.git-patchwork-notify@kernel.org>
Date:   Fri, 20 Jan 2023 09:30:18 +0000
References: <20230118165638.1383764-1-ahalaney@redhat.com>
In-Reply-To: <20230118165638.1383764-1-ahalaney@redhat.com>
To:     Andrew Halaney <ahalaney@redhat.com>
Cc:     davem@davemloft.net, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        mcoquelin.stm32@gmail.com, richardcochran@gmail.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        vee.khee.wong@linux.intel.com, noor.azura.ahmad.tarmizi@intel.com,
        vijayakannan.ayyathurai@intel.com, michael.wei.hong.sit@intel.com,
        ncai@quicinc.com
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
by David S. Miller <davem@davemloft.net>:

On Wed, 18 Jan 2023 10:56:38 -0600 you wrote:
> In the original implementation of dwmac5
> commit 8bf993a5877e ("net: stmmac: Add support for DWMAC5 and implement Safety Features")
> all safety features were enabled by default.
> 
> Later it seems some implementations didn't have support for all the
> features, so in
> commit 5ac712dcdfef ("net: stmmac: enable platform specific safety features")
> the safety_feat_cfg structure was added to the callback and defined for
> some platforms to selectively enable these safety features.
> 
> [...]

Here is the summary with links:
  - [net,RESEND] net: stmmac: enable all safety features by default
    https://git.kernel.org/netdev/net/c/fdfc76a116b5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


