Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 776C158E6C3
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 07:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbiHJFaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 01:30:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbiHJFaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 01:30:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D53C1AF06;
        Tue,  9 Aug 2022 22:30:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2CE5B81A8C;
        Wed, 10 Aug 2022 05:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 441B5C433D6;
        Wed, 10 Aug 2022 05:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660109415;
        bh=DAKEdeVaJXKEjwOEM9FsGCS+nd5YgZPqRRBOqMJXYf0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hQwJ/I7zaw1gg62+i/RZMdfh1oXgtlCE8wz0vwALjV0i1kOtYY/eO7nk433Hmfskc
         DoJGsyA/edBywnMAZExNUGZTqJSAHk1pY1UommcuK/SsPfujJbtJN2bkNpLAcOrd+g
         fcqa3pHPhLBsI6vmKsIWkPo+M8aApZ0poB+Yu/sCPd8JrkkPnZRtJ1JSJOYDpXI/un
         AMGI+vp1T7hd3NXjxuCssmxC6lsirQPYBPBppxqPB0EuU8xoN5AuSfVG6lkgXQOicg
         ih38KZJV7i4HSRmM/ftbxP8cSh6ZLeTwW0r0xM2BG5SVu0SjTIoStNT1jrs5WrYnpp
         HrRF8yyHObsvA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 171ABC43141;
        Wed, 10 Aug 2022 05:30:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net 0/4] Do not use RT_TOS for IPv6 flowlabel
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166010941509.28354.4070205529525758568.git-patchwork-notify@kernel.org>
Date:   Wed, 10 Aug 2022 05:30:15 +0000
References: <20220805191906.9323-1-matthias.may@westermo.com>
In-Reply-To: <20220805191906.9323-1-matthias.may@westermo.com>
To:     Matthias May <matthias.may@westermo.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, roopa@nvidia.com,
        eng.alaamohamedsoliman.am@gmail.com, bigeasy@linutronix.de,
        saeedm@nvidia.com, leon@kernel.org, roid@nvidia.com,
        maord@nvidia.com, lariel@nvidia.com, vladbu@nvidia.com,
        cmi@nvidia.com, gnault@redhat.com, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, linux-rdma@vger.kernel.org,
        nicolas.dichtel@6wind.com, eyal.birger@gmail.com, jesse@nicira.com,
        linville@tuxdriver.com, daniel@iogearbox.net, hadarh@mellanox.com,
        ogerlitz@mellanox.com, willemb@google.com,
        martin.varghese@nokia.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 5 Aug 2022 21:19:02 +0200 you wrote:
> According to Guillaume Nault RT_TOS should never be used for IPv6.
> 
> Quote:
> RT_TOS() is an old macro used to interprete IPv4 TOS as described in
> the obsolete RFC 1349. It's conceptually wrong to use it even in IPv4
> code, although, given the current state of the code, most of the
> existing calls have no consequence.
> 
> [...]

Here is the summary with links:
  - [v3,net,1/4] geneve: do not use RT_TOS for IPv6 flowlabel
    https://git.kernel.org/netdev/net/c/ca2bb69514a8
  - [v3,net,2/4] vxlan: do not use RT_TOS for IPv6 flowlabel
    https://git.kernel.org/netdev/net/c/e488d4f5d6e4
  - [v3,net,3/4] mlx5: do not use RT_TOS for IPv6 flowlabel
    https://git.kernel.org/netdev/net/c/bcb0da7fffee
  - [v3,net,4/4] ipv6: do not use RT_TOS for IPv6 flowlabel
    https://git.kernel.org/netdev/net/c/ab7e2e0dfa5d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


