Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 485E46C9FFA
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 11:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233295AbjC0Jk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 05:40:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232810AbjC0JkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 05:40:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C02154EEF;
        Mon, 27 Mar 2023 02:40:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EA59DB8104F;
        Mon, 27 Mar 2023 09:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5451CC433D2;
        Mon, 27 Mar 2023 09:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679910017;
        bh=beK1YV3pWAJeOza+SpVzg1PajY/RpZfsGNm70c4I2BI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SxRKoKkSG7Juge8cawhKUPDLAX/38dT6fgFtMlg6yIZnnNHtGfB1bhQFMjUdFjz3F
         HJu4ogZ8dDdnzGeSjjK90nsS2BKMnCd0Pjfya6fcrs/+wvX0z5tWHwKIc32B5/m5Dl
         5WYM6yC/5ySmtyAEZIGdXdZq4BgJd8/mK9Ts6pKVTkQeWY/yGV7Ekt6qHwBIdYuV8a
         p/PGihhnu21aMj8DgK0Pvjadxm8KIe7unIRYeT9GnbvhTsXKw/jUpmDlLO+xMxo+R7
         rV7ds/5/QqhNw7VlPrNwyMEqNBXxai+tcqux0hwaUnyxyt2ezQkBP6/+D+can2Xi7h
         6vgUuXTkZ7Ydg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1E4ADE4D029;
        Mon, 27 Mar 2023 09:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: stmmac: don't reject VLANs when IFF_PROMISC is set
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167991001711.30696.13664523807439827345.git-patchwork-notify@kernel.org>
Date:   Mon, 27 Mar 2023 09:40:17 +0000
References: <20230325112815.3053288-1-vladimir.oltean@nxp.com>
In-Reply-To: <20230325112815.3053288-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mcoquelin.stm32@gmail.com,
        boon.leong.ong@intel.com, kim.tatt.chuah@intel.com,
        vee.khee.wong@intel.com, tee.min.tan@intel.com, kurt@linutronix.de,
        andrew@lunn.ch, f.fainelli@gmail.com,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Sat, 25 Mar 2023 13:28:15 +0200 you wrote:
> The blamed commit has introduced the following tests to
> dwmac4_add_hw_vlan_rx_fltr(), called from stmmac_vlan_rx_add_vid():
> 
> 	if (hw->promisc) {
> 		netdev_err(dev,
> 			   "Adding VLAN in promisc mode not supported\n");
> 		return -EPERM;
> 	}
> 
> [...]

Here is the summary with links:
  - [net] net: stmmac: don't reject VLANs when IFF_PROMISC is set
    https://git.kernel.org/netdev/net/c/a7602e7332b9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


