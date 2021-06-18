Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C58A63AD2AE
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 21:21:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235437AbhFRTWQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 15:22:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:33838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234386AbhFRTWO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 15:22:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0887461264;
        Fri, 18 Jun 2021 19:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624044005;
        bh=Xqb8RBZ0ASq4yOAuloDrF09hxGXS96TfbcRI+gmXw9Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XeTf4A7zIRZ74HkMH85S1qmVpDNOdMZkU0YGDM23QMbEspRqCv5ggbFNBIAv7elqx
         PUXwT2QHqI5sy+t8tXYFIctj9xjBStvQxfqxRXC+zN1c+TA/15yQRJhpn73NPoUu3J
         X9liQa0S1gBA++irh5sFqHIV+2xyP8nbDb8gkdyEyhpSqGLV4RSQVsteg7IjaCJCLf
         aHLUsOKmczJNQbFYBiLDf+rN4F1A7uS1LGCcAQAscliz2HiVE8Dqw4CHy7X7Fb4gaq
         +mnHRekmAyTZfUyT6M+X5ubUxkmmdvZUnORzT4S1HBN6Aftt+M5d92z+v021T1qC/v
         nGaTijIMPC9pw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EAF8F609D8;
        Fri, 18 Jun 2021 19:20:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/4] net: ll_temac: Make sure to free skb when it is
 completely used
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162404400495.12339.18313933113853867877.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Jun 2021 19:20:04 +0000
References: <d9200a5023973fbe372a2d51dc4e500400450ecd.1624013456.git.esben@geanix.com>
In-Reply-To: <d9200a5023973fbe372a2d51dc4e500400450ecd.1624013456.git.esben@geanix.com>
To:     Esben Haabendal <esben@geanix.com>
Cc:     netdev@vger.kernel.org, stable@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, michal.simek@xilinx.com,
        jesse.brandeburg@intel.com, wanghai38@huawei.com, andrew@lunn.ch,
        zhangchangzhong@huawei.com, michael@walle.cc,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Fri, 18 Jun 2021 12:52:23 +0200 you wrote:
> With the skb pointer piggy-backed on the TX BD, we have a simple and
> efficient way to free the skb buffer when the frame has been transmitted.
> But in order to avoid freeing the skb while there are still fragments from
> the skb in use, we need to piggy-back on the TX BD of the skb, not the
> first.
> 
> Without this, we are doing use-after-free on the DMA side, when the first
> BD of a multi TX BD packet is seen as completed in xmit_done, and the
> remaining BDs are still being processed.
> 
> [...]

Here is the summary with links:
  - [1/4] net: ll_temac: Make sure to free skb when it is completely used
    https://git.kernel.org/netdev/net/c/6aa32217a9a4
  - [2/4] net: ll_temac: Add memory-barriers for TX BD access
    https://git.kernel.org/netdev/net/c/28d9fab458b1
  - [3/4] net: ll_temac: Fix TX BD buffer overwrite
    https://git.kernel.org/netdev/net/c/c364df2489b8
  - [4/4] net: ll_temac: Avoid ndo_start_xmit returning NETDEV_TX_BUSY
    https://git.kernel.org/netdev/net/c/f63963411942

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


