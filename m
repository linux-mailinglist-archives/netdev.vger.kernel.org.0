Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF8A58A799
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 10:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240396AbiHEIAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 04:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233549AbiHEIAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 04:00:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0679DE80
        for <netdev@vger.kernel.org>; Fri,  5 Aug 2022 01:00:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7DCA96172E
        for <netdev@vger.kernel.org>; Fri,  5 Aug 2022 08:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D2E6BC433B5;
        Fri,  5 Aug 2022 08:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659686414;
        bh=R4tuNSzaFLNOpp+zSKi8dpTAT+sV73c32tC1zRUR09c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HR2y5PcuwiFzWEMjc0OmPqWdFwmJ2/Wtbbx+yMZb4VgqrbLmbEdr5heJziItM3t7g
         RjUzuInPfs1ux290HG6DQ3jL53Og5YNTql7AZ5ICaAYiMDjt3644GeVPcWEeo72YOk
         sgqpQakV3HD2TNRbzNpw82zanaJPFcImmjC5rW6poBsvdCrpUB660wLqXggEdwr84h
         kreIiGWldLMRTQhDhV/AqP5nU8F8ZkvlC5g4dUey4bFZr54LDuIkkllsGO8x5BKQnM
         FHGoyDTIOZyF3mzXCmvorWzciHnDeGPEF22WLl622ecDEpCNDZwRRMHr+V0oA1mUsL
         WcmHs3xKMSCoQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BDCBEC43144;
        Fri,  5 Aug 2022 08:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v5 net] net: tap: NULL pointer derefence in
 dev_parse_header_protocol when skb->dev is null
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165968641477.31624.9662939829824626375.git-patchwork-notify@kernel.org>
Date:   Fri, 05 Aug 2022 08:00:14 +0000
References: <20220803062759.3967-1-cbulinaru@gmail.com>
In-Reply-To: <20220803062759.3967-1-cbulinaru@gmail.com>
To:     c b <cbulinaru@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, willemb@google.com,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed,  3 Aug 2022 02:27:59 -0400 you wrote:
> Fixes a NULL pointer derefence bug triggered from tap driver.
> When tap_get_user calls virtio_net_hdr_to_skb the skb->dev is null
> (in tap.c skb->dev is set after the call to virtio_net_hdr_to_skb)
> virtio_net_hdr_to_skb calls dev_parse_header_protocol which
> needs skb->dev field to be valid.
> 
> The line that trigers the bug is in dev_parse_header_protocol
> (dev is at offset 0x10 from skb and is stored in RAX register)
>   if (!dev->header_ops || !dev->header_ops->parse_protocol)
>   22e1:   mov    0x10(%rbx),%rax
>   22e5:	  mov    0x230(%rax),%rax
> 
> [...]

Here is the summary with links:
  - [v5,net] net: tap: NULL pointer derefence in dev_parse_header_protocol when skb->dev is null
    https://git.kernel.org/netdev/net/c/4f61f133f354

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


