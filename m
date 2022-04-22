Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBE3050B7A3
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 14:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233867AbiDVM5e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 08:57:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1447653AbiDVMxG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 08:53:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95CB1DEE6;
        Fri, 22 Apr 2022 05:50:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3AA766112B;
        Fri, 22 Apr 2022 12:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8EDCCC385A8;
        Fri, 22 Apr 2022 12:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650631812;
        bh=A/VElV67rY+XYeSdLD39ruqlrB3+QJRia6c0TYpJjr4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=prPT1RZp1k/KvfMy3Asgj/v6zQiGeuwoK5wuJQmXCuhxt3Y0wrfkVpXb9JvtK1lmH
         jFtSQSYkY/8HxsDmbongJ2Xb/jAwjCGRlQtCXVfaADH9SO3Gxe1HMFfTfgsGWejxD/
         2TF97BPMhCookwnERDyk8yEO2qSMrGd4GLi7YaLz29wP7CKDbVHSrNJ3rX/Jq1kAjY
         0omy0+iNqRAQkQb8xVFlj/cbjupl6msVnjzXZ3zg5RcblJNsrU2nmq+CmBNIWNV4Vc
         adbpNmfTZ70risyak1MeFuow0toRU5dl1ZPRTZd4nFzpTBLRZQoC1g58Jbj1k3/fY9
         e56Pa0MvrnHPw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5B611E8DD61;
        Fri, 22 Apr 2022 12:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] ipv4: First steps toward removing RTO_ONLINK
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165063181235.24908.15151109016653470553.git-patchwork-notify@kernel.org>
Date:   Fri, 22 Apr 2022 12:50:12 +0000
References: <cover.1650470610.git.gnault@redhat.com>
In-Reply-To: <cover.1650470610.git.gnault@redhat.com>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, dccp@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 21 Apr 2022 01:21:19 +0200 you wrote:
> RTO_ONLINK is a flag that allows to reduce the scope of route lookups.
> It's stored in a normally unused bit of the ->flowi4_tos field, in
> struct flowi4. However it has several problems:
> 
>  * This bit is also used by ECN. Although ECN bits are supposed to be
>    cleared before doing a route lookup, it happened that some code
>    paths didn't properly sanitise their ->flowi4_tos. So this mechanism
>    is fragile and we had bugs in the past where ECN bits slipped in and
>    could end up being erroneously interpreted as RTO_ONLINK.
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] ipv4: Don't reset ->flowi4_scope in ip_rt_fix_tos().
    https://git.kernel.org/netdev/net-next/c/16a28267774c
  - [net-next,2/3] ipv4: Avoid using RTO_ONLINK with ip_route_connect().
    https://git.kernel.org/netdev/net-next/c/67e1e2f4854b
  - [net-next,3/3] ipv4: Initialise ->flowi4_scope properly in ICMP handlers.
    https://git.kernel.org/netdev/net-next/c/b1ad41384866

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


