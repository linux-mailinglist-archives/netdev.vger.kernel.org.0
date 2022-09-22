Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 812DA5E64BC
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 16:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229448AbiIVOKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 10:10:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230436AbiIVOKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 10:10:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4060E6BCDE;
        Thu, 22 Sep 2022 07:10:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C7620634B2;
        Thu, 22 Sep 2022 14:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 28F6DC433B5;
        Thu, 22 Sep 2022 14:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663855816;
        bh=eh4ObEUuIkDM4NMuRNEtG7sy49Qz55iaL5hBbk9QuYY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bHodsX8HDejU6yGVjGryT6frz/osHqJqpwXTKZTdU/g8Mpwb1tjkVJxiRGFztFGis
         kJ6nsVk6M2xxrQEJruKHLY4RdS4yOXytnmbJcLbIU0BnA13XJt5uLoYZwi1dlalVZg
         +xECPN1/kPE2kCmRy5BRJJaP9IyXX9TYEvkGo2oL4DUXzXf5aGIzjFMGGCebj7Kabj
         kviCuMCmkw1dMMbplatW87r/smd6zRTFJqK4913rB/ptdVN/OmOwQ95fbEDUGcPsbe
         az9YHsTyBExIT/ccILwu3lDQ22CFnK1ZdsfiAD0xTbYcmHSWwD8216B84Y/naWitOP
         fJTGudY+7dYUw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0807DE4D03F;
        Thu, 22 Sep 2022 14:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: sunhme: Fix packet reception for len <
 RX_COPY_THRESHOLD
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166385581602.2095.7967202939695469127.git-patchwork-notify@kernel.org>
Date:   Thu, 22 Sep 2022 14:10:16 +0000
References: <20220920235018.1675956-1-seanga2@gmail.com>
In-Reply-To: <20220920235018.1675956-1-seanga2@gmail.com>
To:     Sean Anderson <seanga2@gmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, nbowler@draconx.ca,
        eike-kernel@sf-tec.de, zheyuma97@gmail.com, andrew@lunn.ch
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

On Tue, 20 Sep 2022 19:50:18 -0400 you wrote:
> There is a separate receive path for small packets (under 256 bytes).
> Instead of allocating a new dma-capable skb to be used for the next packet,
> this path allocates a skb and copies the data into it (reusing the existing
> sbk for the next packet). There are two bytes of junk data at the beginning
> of every packet. I believe these are inserted in order to allow aligned DMA
> and IP headers. We skip over them using skb_reserve. Before copying over
> the data, we must use a barrier to ensure we see the whole packet. The
> current code only synchronizes len bytes, starting from the beginning of
> the packet, including the junk bytes. However, this leaves off the final
> two bytes in the packet. Synchronize the whole packet.
> 
> [...]

Here is the summary with links:
  - [net,v2] net: sunhme: Fix packet reception for len < RX_COPY_THRESHOLD
    https://git.kernel.org/netdev/net/c/878e2405710a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


