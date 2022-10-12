Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FCAD5FC57C
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 14:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbiJLMkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 08:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbiJLMkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 08:40:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8709376543
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 05:40:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E8BC4614D0
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 12:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4A3D2C433C1;
        Wed, 12 Oct 2022 12:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665578415;
        bh=GN9kzDROQWsgxUwxQfV3ILI8Qveol06uco+HRzURMvY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=J3iqKwtShhaomPjyZG9PNmbSOtzDfqpk5HjMA4GZk5zUKw4YEUTQ1dZtcY9IUvbiw
         oirno0bQ1m4s2K11GDqiceoqfZY9pZMR1YHJkDwcveyrwFazQCbCoStqdU0itGqksV
         9JNHyChrrZYDOC0dnM2CVZFxzmpP8iPYZjdFUykfUD5ZEJn2eOfaP73BHDyZ+C5UFZ
         g6ZtApsYulquaUflTDg2/hmGiDW8B7FoN8maDLadwnntVkYE3BHvX2V5kBMa1SIR/Z
         hw4Xuv8RNHpmzqId909sdLyAYsFPeOBpzUHxLxvz55p37vEFrOMoyS5DU0AmUjZxtM
         nEPmCpe/mVRGA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 263CEE4D00C;
        Wed, 12 Oct 2022 12:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] mctp: prevent double key removal and unref
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166557841515.32004.12665127576617421909.git-patchwork-notify@kernel.org>
Date:   Wed, 12 Oct 2022 12:40:15 +0000
References: <20221012020851.931298-1-jk@codeconstruct.com.au>
In-Reply-To: <20221012020851.931298-1-jk@codeconstruct.com.au>
To:     Jeremy Kerr <jk@codeconstruct.com.au>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, matt@codeconstruct.com.au,
        butterflyhuangxx@gmail.com
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

On Wed, 12 Oct 2022 10:08:51 +0800 you wrote:
> Currently, we have a bug where a simultaneous DROPTAG ioctl and socket
> close may race, as we attempt to remove a key from lists twice, and
> perform an unref for each removal operation. This may result in a uaf
> when we attempt the second unref.
> 
> This change fixes the race by making __mctp_key_remove tolerant to being
> called on a key that has already been removed from the socket/net lists,
> and only performs the unref when we do the actual remove. We also need
> to hold the list lock on the ioctl cleanup path.
> 
> [...]

Here is the summary with links:
  - [net] mctp: prevent double key removal and unref
    https://git.kernel.org/netdev/net/c/3a732b46736c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


