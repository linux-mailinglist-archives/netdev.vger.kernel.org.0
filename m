Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 478126E20C6
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 12:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbjDNKa0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 06:30:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbjDNKaY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 06:30:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8AFE212E;
        Fri, 14 Apr 2023 03:30:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B02263927;
        Fri, 14 Apr 2023 10:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D6021C4339B;
        Fri, 14 Apr 2023 10:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681468218;
        bh=ThHHGOZ5/DkBTMb33P0OhyLuJ0MWrMPl62R/BI4hI2Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bAhkl7KVOQf7UNBwt9L0TYRLxCRQM9xekIHbUahi0Mag9jVniPkps0gLiGEFXtx9m
         kOKxHaUPLown2hDPgCWqJxwe2+Wpw8ts8/wKJgFgEle+IVl8zepPHKm1f6N7Ekzxrn
         eRoRNsIi/pWtmGeZyOSj9tBiajZmfx0z+gOZeJkaIW8ptpVPjFm6TI0SYtyScFhwQq
         2ZkPy0fNvYJgwxyLmmCCewlcZ8riVBVKwi56v8rTlRtXfEB6ILJyoOkdjhqIvlvOOk
         zepOXq1M8AAjLODZKWnZrTCcSlSyNWOj6x1HUPtmGo8k2LTwDtDc2n9rqXse7lbD/M
         HpsG2l4QSAiuw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BB8FCE52446;
        Fri, 14 Apr 2023 10:30:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 0/3] net: Finish up ->msg_control{,_user} split
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168146821876.895.6943442132933304910.git-patchwork-notify@kernel.org>
Date:   Fri, 14 Apr 2023 10:30:18 +0000
References: <20230413114705.157046-1-kevin.brodsky@arm.com>
In-Reply-To: <20230413114705.157046-1-kevin.brodsky@arm.com>
To:     Kevin Brodsky <kevin.brodsky@arm.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org, hch@lst.de,
        edumazet@google.com, davem@davemloft.net, kuba@kernel.org
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

This series was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu, 13 Apr 2023 12:47:02 +0100 you wrote:
> Hi,
> 
> Commit 1f466e1f15cf ("net: cleanly handle kernel vs user buffers for
> ->msg_control") introduced the msg_control_user and
> msg_control_is_user fields in struct msghdr, to ensure that user
> pointers are represented as such. It also took care of converting most
> users of struct msghdr::msg_control where user pointers are involved. It
> did however miss a number of cases, and some code using msg_control
> inappropriately has also appeared in the meantime.
> 
> [...]

Here is the summary with links:
  - [v2,1/3] net: Ensure ->msg_control_user is used for user buffers
    https://git.kernel.org/netdev/net-next/c/c39ef2130491
  - [v2,2/3] net/compat: Update msg_control_is_user when setting a kernel pointer
    https://git.kernel.org/netdev/net-next/c/60daf8d40b80
  - [v2,3/3] net/ipv6: Initialise msg_control_is_user
    https://git.kernel.org/netdev/net-next/c/b6d85cf5bd14

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


