Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 871676D9C0F
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 17:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238713AbjDFPUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 11:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236921AbjDFPUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 11:20:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DB8383D0;
        Thu,  6 Apr 2023 08:20:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A95EB64943;
        Thu,  6 Apr 2023 15:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 09F81C4339B;
        Thu,  6 Apr 2023 15:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680794418;
        bh=+bs09GQCF5hAOkAMz+tvy22Eo6BudBimhC/cySd7K8g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HQmmceVBx10JdKaeVzq1b/zZepoaadnmjvytEbXpCpYO7wLztHY6I2yPdASPXNifc
         dElaVEtrjzESJjng1jtThKMlNDhzvEYamEwoUZCi+VXK3MitdsoMJ5OHsEeyZ8nKUa
         8LR3ukZ7xuRpygFdjVNqakEpbfp9vSVu3LlEOGzTgrFgahvw9yFG7lzjdhEa+4zjXv
         mOL2IsgOORuxKmAwAnwgsXWa2LP9mlfNPx63LnVj0DbN3HLuGP79I99OXFi94EK371
         f31mYR3K21sbzZfdPa+IlA8IaK4/XXh2HOpMP+ENccR4p1SFr6q7TeYZPeJ/5xXFAa
         Ae98HiVZ+PGog==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E0175E5EA85;
        Thu,  6 Apr 2023 15:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [RESEND PATCH net 1/1] net: stmmac: check fwnode for phy device
 before scanning for phy
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168079441791.8535.15515583518065122316.git-patchwork-notify@kernel.org>
Date:   Thu, 06 Apr 2023 15:20:17 +0000
References: <20230406024541.3556305-1-michael.wei.hong.sit@intel.com>
In-Reply-To: <20230406024541.3556305-1-michael.wei.hong.sit@intel.com>
To:     Sit@ci.codeaurora.org,
        Michael Wei Hong <michael.wei.hong.sit@intel.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mcoquelin.stm32@gmail.com,
        boon.leong.ong@intel.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux@armlinux.org.uk, hkallweit1@gmail.com, andrew@lunn.ch,
        martin.blumenstingl@googlemail.com, Shahab.Vahedi@synopsys.com,
        m.szyprowski@samsung.com, hong.aun.looi@intel.com,
        weifeng.voon@intel.com, peter.jun.ann.lai@intel.com,
        muhammad.husaini.zulkifli@intel.com, tee.min.tan@intel.com,
        hock.leong.kweh@intel.com
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  6 Apr 2023 10:45:41 +0800 you wrote:
> Some DT devices already have phy device configured in the DT/ACPI.
> Current implementation scans for a phy unconditionally even though
> there is a phy listed in the DT/ACPI and already attached.
> 
> We should check the fwnode if there is any phy device listed in
> fwnode and decide whether to scan for a phy to attach to.
> 
> [...]

Here is the summary with links:
  - [RESEND,net,1/1] net: stmmac: check fwnode for phy device before scanning for phy
    https://git.kernel.org/netdev/net/c/8fbc10b995a5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


