Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F66C57D838
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 04:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233367AbiGVCAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 22:00:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiGVCAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 22:00:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BA89B7C3;
        Thu, 21 Jul 2022 19:00:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F58561FB8;
        Fri, 22 Jul 2022 02:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 02110C341C6;
        Fri, 22 Jul 2022 02:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658455214;
        bh=65FiU5LF+lUO5mHaxemok8ZbbBBbx1xhBO//j1ABqCY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=k3sZkm2WTDCk4rMeMcp+0NJABt/hev4MjlecRo6uro1jhy1/X2DKbbYdpdPVi2+d/
         XDRhzhg2dMKH9sJvI087R7xZrNBb3fso6xl3DAV5hX3X832MqYJ2yrBECN0SLINwXP
         zlanWa64Kujyw45/uNCQcWlJhUCCcfX0T2iIEhVR0OMD+hIX/iNtBkPeyqKPSSibD7
         BAWK9csoNdu/Z9If4IaDWodyt/t37fFDdXkG0VEMWf0/RwyjnmW2bVUUrW1qgMtysm
         Ii0krn7nKcx96WVdL17SH5tcOqPGH/IexoxepQIIMQlOWqNndmOosZIMfpB+h4Op9g
         P3PWpO50R/HOQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D5B1CE451BA;
        Fri, 22 Jul 2022 02:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] can: pch_can: pch_can_error(): initialize errc
 before using it
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165845521387.922.8823304957699439976.git-patchwork-notify@kernel.org>
Date:   Fri, 22 Jul 2022 02:00:13 +0000
References: <20220721163042.3448384-2-mkl@pengutronix.de>
In-Reply-To: <20220721163042.3448384-2-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de,
        mailhol.vincent@wanadoo.fr, nathan@kernel.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Marc Kleine-Budde <mkl@pengutronix.de>:

On Thu, 21 Jul 2022 18:30:42 +0200 you wrote:
> From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
> 
> After commit 3a5c7e4611dd, the variable errc is accessed before being
> initialized, c.f. below W=2 warning:
> 
> | In function 'pch_can_error',
> |     inlined from 'pch_can_poll' at drivers/net/can/pch_can.c:739:4:
> | drivers/net/can/pch_can.c:501:29: warning: 'errc' may be used uninitialized [-Wmaybe-uninitialized]
> |   501 |                 cf->data[6] = errc & PCH_TEC;
> |       |                             ^
> | drivers/net/can/pch_can.c: In function 'pch_can_poll':
> | drivers/net/can/pch_can.c:484:13: note: 'errc' was declared here
> |   484 |         u32 errc, lec;
> |       |             ^~~~
> 
> [...]

Here is the summary with links:
  - [net-next] can: pch_can: pch_can_error(): initialize errc before using it
    https://git.kernel.org/netdev/net-next/c/9950f1121133

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


