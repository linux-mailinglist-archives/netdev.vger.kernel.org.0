Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE654671FD8
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 15:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbjAROkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 09:40:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230407AbjAROjm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 09:39:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 137341A966;
        Wed, 18 Jan 2023 06:30:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 987E9B81D4D;
        Wed, 18 Jan 2023 14:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0255FC433F0;
        Wed, 18 Jan 2023 14:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674052217;
        bh=VVw4J8idSEvIBSQvZDSTQ6Z7QfAX3np3qATDr5Zr2I0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MOZeqUWh1aPy3sA4DDyiV0jNM6BDDlTNZX2YHAgNGNoSoye8gmW04IQ8dJWo+9SaS
         +qBjkBLt/SphVzDkWpTKLjsWhny2INkaFv/Yhz+FhI4Z/baVQOKVOQ7ACuq7/zdFD7
         2f7nMH6PAQEiibKoSdijXFElpf4tgm/1CX5lK2UXVb2YzCGEe2r3Pu5bOcK1Jw75gh
         LGtf/4yorTmWzjQ1FTPr2HyZkdCbnb5fbOmXTRrIa7Pa3StkZuJODBqQ1a5A8oZFqJ
         fLlROOdQy2QPPvD6d8vWPavcLgI0i21ydxwPnE7xFMLClArLjWT62hq47iTq2n1BWp
         t5HNSC5tMTVYg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DB6A9C395C6;
        Wed, 18 Jan 2023 14:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: macb: fix PTP TX timestamp failure due to packet
 padding
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167405221689.16594.624017223236152220.git-patchwork-notify@kernel.org>
Date:   Wed, 18 Jan 2023 14:30:16 +0000
References: <20230116214133.1834364-1-robert.hancock@calian.com>
In-Reply-To: <20230116214133.1834364-1-robert.hancock@calian.com>
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     nicolas.ferre@microchip.com, claudiu.beznea@microchip.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, richardcochran@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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

On Mon, 16 Jan 2023 15:41:33 -0600 you wrote:
> PTP TX timestamp handling was observed to be broken with this driver
> when using the raw Layer 2 PTP encapsulation. ptp4l was not receiving
> the expected TX timestamp after transmitting a packet, causing it to
> enter a failure state.
> 
> The problem appears to be due to the way that the driver pads packets
> which are smaller than the Ethernet minimum of 60 bytes. If headroom
> space was available in the SKB, this caused the driver to move the data
> back to utilize it. However, this appears to cause other data references
> in the SKB to become inconsistent. In particular, this caused the
> ptp_one_step_sync function to later (in the TX completion path) falsely
> detect the packet as a one-step SYNC packet, even when it was not, which
> caused the TX timestamp to not be processed when it should be.
> 
> [...]

Here is the summary with links:
  - [net] net: macb: fix PTP TX timestamp failure due to packet padding
    https://git.kernel.org/netdev/net/c/7b90f5a665ac

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


