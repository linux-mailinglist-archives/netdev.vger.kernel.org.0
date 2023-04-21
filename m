Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA6C96EA89F
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 12:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231592AbjDUKub (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 06:50:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231609AbjDUKua (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 06:50:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B8B1C17D;
        Fri, 21 Apr 2023 03:50:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 15D1F64EAE;
        Fri, 21 Apr 2023 10:50:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6A89EC433D2;
        Fri, 21 Apr 2023 10:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682074220;
        bh=h3RyoSOiFiFDRTwCsypI3F6F6H66CtCaPUBSqdRhiJ8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Lwe1/I0feXEzKrBlGaiywDpyX8T/e5JLErtWqZbv3wUsSZkhLJ9QyXgi4Cl5iKKBL
         wtxjKqfqqi+14+me1QiDhWWYEcmTIvdkz/PWwC+QWih6sO5NfXM14zqfh+plW2/Pkb
         KKTLwe1yFBryWZ3R8Y4iwBFi7jbhKM6jVdn9EebM59x3OnEMjnKbJ3QwtDar9hI3gw
         iJiearVhA24EDIYN53Ejo5fKVA9ArYA8doB+PYgkKENBFUKpHCvECt36WBtxckwiFJ
         xf945wKK/hhAxktaYQ6wAkNlJ0SQXgdygfH/jlPYJQ30nRlp4fbTNW9KN/wOdHkRs7
         WQOz8AdM+JgMg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 515BDC561EE;
        Fri, 21 Apr 2023 10:50:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v6] net: stmmac:fix system hang when setting up
 tag_8021q VLAN for DSA ports
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168207422032.11185.11526430974844545291.git-patchwork-notify@kernel.org>
Date:   Fri, 21 Apr 2023 10:50:20 +0000
References: <KL1PR01MB544874DAEE749710E67727A2E6629@KL1PR01MB5448.apcprd01.prod.exchangelabs.com>
In-Reply-To: <KL1PR01MB544874DAEE749710E67727A2E6629@KL1PR01MB5448.apcprd01.prod.exchangelabs.com>
To:     Yan Wang <rk.code@outlook.com>
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        kuba@kernel.org, mcoquelin.stm32@gmail.com, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        qiangqing.zhang@nxp.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Wed, 19 Apr 2023 22:13:46 +0800 you wrote:
> The system hang because of dsa_tag_8021q_port_setup()->
> 				stmmac_vlan_rx_add_vid().
> 
> I found in stmmac_drv_probe() that cailing pm_runtime_put()
> disabled the clock.
> 
> First, when the kernel is compiled with CONFIG_PM=y,The stmmac's
> resume/suspend is active.
> 
> [...]

Here is the summary with links:
  - [net-next,v6] net: stmmac:fix system hang when setting up tag_8021q VLAN for DSA ports
    https://git.kernel.org/netdev/net-next/c/35226750f7ab

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


