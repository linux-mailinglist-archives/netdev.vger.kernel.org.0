Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A2415B16C3
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 10:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbiIHIUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 04:20:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbiIHIUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 04:20:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C49A3550A5
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 01:20:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 56A9E61BB8
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 08:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B8A06C433D7;
        Thu,  8 Sep 2022 08:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662625217;
        bh=tt5pNw545GGdWzNyJNvr5Ao3R4SZx3Fnq+mjQE1DDa4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QTuuvW4pJR3vRD1U0L8w4dClBOWPHwES7PbNmb8t2VbTCkXFLO+/JYckTmxZHvX1n
         V+cqGUfuxcJbhuYKbidIayuTpz1UmILDKtWZSbxoyWVwazHQYe4QZQFHwRLluqHLBo
         usKH+cS6ESkWPvn2hsOeynhL7MBlI4AXVOr9za6/zsBAxyIIZVKAhXWeXbRnNAipLT
         gryjSKr5r8PwD9tlqmDwtyYHgM1w8WMdLM2ZxRQC53ZhDy3xmJr6JCKuvRlImI1bg8
         VrFlingN7rDZyYvmx7seVOySrQOBICaKBfAntsF4eVBY/UIG1KnocEzHSsG/ta82+u
         shgGz8HA/iRaw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 926FAC73FEF;
        Thu,  8 Sep 2022 08:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v1] net: stmmac: Disable automatic FCS/Pad stripping
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166262521759.28234.1058076387389491092.git-patchwork-notify@kernel.org>
Date:   Thu, 08 Sep 2022 08:20:17 +0000
References: <20220905130155.193640-1-kurt@linutronix.de>
In-Reply-To: <20220905130155.193640-1-kurt@linutronix.de>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
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

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Mon,  5 Sep 2022 15:01:55 +0200 you wrote:
> The stmmac has the possibility to automatically strip the padding/FCS for IEEE
> 802.3 type frames. This feature is enabled conditionally. Therefore, the stmmac
> receive path has to have a determination logic whether the FCS has to be
> stripped in software or not.
> 
> In fact, for DSA this ACS feature is disabled and the determination logic
> doesn't check for it properly. For instance, when using DSA in combination with
> an older stmmac (pre version 4), the FCS is not stripped by hardware or software
> which is problematic.
> 
> [...]

Here is the summary with links:
  - [net-next,v1] net: stmmac: Disable automatic FCS/Pad stripping
    https://git.kernel.org/netdev/net-next/c/929d43421ee5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


