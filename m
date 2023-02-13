Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD698694229
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 11:00:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbjBMKAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 05:00:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230121AbjBMKAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 05:00:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D734BDD8
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 02:00:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3FEC1B80DF1
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 10:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CC8FFC433EF;
        Mon, 13 Feb 2023 10:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676282417;
        bh=5qTasuSt1o6RTHjyqR0U5nAxGAJtUllci80eFiOiJg4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=A9NjDTDFRWrNyRy3T3mDSKAOXEFHmS7CDx8vXUxr4JcHgSxSXxiI5tDd3vCsT8kjc
         NUfNrjRF6wpjrB/fENArf53jTtUarGi9lGUz3EBvblQRymD/m39jwI3MUOC1UpySaI
         22X/7IZoiN9Bt1XfSAlS7IKNNuEYbYhstxvvpGPB1TMQP9ox7yBMmnDxcj0drJKry7
         8zLEG/rlSIpxcumejaIm4Ru/8mFF+KzBd5JBBnXB9kEFDZ5iIYVUccmZGCsLvuBzoW
         PuHdldBOTMuFVZM7ASoUmLPdiFHLBmRoaonpt3On2m+6H6bn9Z7GBEfkS4xWFGdDOi
         XUKuH+OJEW2uA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B33DBE68D30;
        Mon, 13 Feb 2023 10:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] bnxt_en: Fix mqprio and XDP ring checking logic
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167628241773.19101.6036160465962539322.git-patchwork-notify@kernel.org>
Date:   Mon, 13 Feb 2023 10:00:17 +0000
References: <1676050315-19381-1-git-send-email-michael.chan@broadcom.com>
In-Reply-To: <1676050315-19381-1-git-send-email-michael.chan@broadcom.com>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, gospo@broadcom.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 10 Feb 2023 12:31:55 -0500 you wrote:
> In bnxt_reserve_rings(), there is logic to check that the number of TX
> rings reserved is enough to cover all the mqprio TCs, but it fails to
> account for the TX XDP rings.  So the check will always fail if there
> are mqprio TCs and TX XDP rings.  As a result, the driver always fails
> to initialize after the XDP program is attached and the device will be
> brought down.  A subsequent ifconfig up will also fail because the
> number of TX rings is set to an inconsistent number.  Fix the check to
> properly account for TX XDP rings.  If the check fails, set the number
> of TX rings back to a consistent number after calling netdev_reset_tc().
> 
> [...]

Here is the summary with links:
  - [net] bnxt_en: Fix mqprio and XDP ring checking logic
    https://git.kernel.org/netdev/net/c/2038cc592811

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


