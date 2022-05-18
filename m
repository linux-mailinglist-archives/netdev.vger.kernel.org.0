Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C9CC52BC7E
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 16:16:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237352AbiERNAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 09:00:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237185AbiERNAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 09:00:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FDBF1A44BE;
        Wed, 18 May 2022 06:00:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2AED161770;
        Wed, 18 May 2022 13:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 87694C34117;
        Wed, 18 May 2022 13:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652878811;
        bh=jV0UE4C0jzdCV5m7lxDB5yRcAJgyYyREBVZUK8Fu95g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NB3cjU0V9Hb4m8mqwu969TTrs5SMIsx090peKIyan3upbns4BgzjPTQLOzcUCxCDa
         w3Nt1EOlOr40Fs9l5CwdvADRqbOhQIB71dMWXAEhN1cQ49kfPM/TAs4jJwI4ZBbfYG
         Qxif6dlBivnFLlog1n3+ipw8ec8S3RJHRgrF1lgfv3Iupr1B/SXW0GVIyySA06JKeQ
         rrpe307JcxKvH40yin5xv6YOE5gymqXHUxisDxVzIgPOGGEAmSZvnqtpw5aa7X1TJt
         xmYxl2TDDVM9So7m2qqA0bwyEVHPB0SiWvPxxtkYkDQFpOx8JqpT9zLwfEiQE8kLvP
         806OPfToNGlHg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6EB49F0383D;
        Wed, 18 May 2022 13:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v0] nfc: pn533: Fix buggy cleanup order
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165287881144.21214.2658320019255160778.git-patchwork-notify@kernel.org>
Date:   Wed, 18 May 2022 13:00:11 +0000
References: <20220518105321.32746-1-linma@zju.edu.cn>
In-Reply-To: <20220518105321.32746-1-linma@zju.edu.cn>
To:     Lin Ma <linma@zju.edu.cn>
Cc:     krzysztof.kozlowski@linaro.org, dan.carpenter@oracle.com,
        cyeaa@connect.ust.hk, rikard.falkeborn@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 18 May 2022 18:53:21 +0800 you wrote:
> When removing the pn533 device (i2c or USB), there is a logic error. The
> original code first cancels the worker (flush_delayed_work) and then
> destroys the workqueue (destroy_workqueue), leaving the timer the last
> one to be deleted (del_timer). This result in a possible race condition
> in a multi-core preempt-able kernel. That is, if the cleanup
> (pn53x_common_clean) is concurrently run with the timer handler
> (pn533_listen_mode_timer), the timer can queue the poll_work to the
> already destroyed workqueue, causing use-after-free.
> 
> [...]

Here is the summary with links:
  - [v0] nfc: pn533: Fix buggy cleanup order
    https://git.kernel.org/netdev/net/c/b8cedb7093b2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


