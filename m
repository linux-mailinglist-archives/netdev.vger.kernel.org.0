Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 129E14AD0F5
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 06:33:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231735AbiBHFdJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 00:33:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231610AbiBHFKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 00:10:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADDF3C0401DC;
        Mon,  7 Feb 2022 21:10:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D63961584;
        Tue,  8 Feb 2022 05:10:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C6E74C340EC;
        Tue,  8 Feb 2022 05:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644297009;
        bh=V8r54We65WL3T1VjIHdaf2FP69LclfgRD8bEE2fJOsI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MCuERFueE7zCB9ffRvKFJgm7Lv91ENSDCs+tHu2hDxmEuuJmXwtoEg6YWw2TMWNSS
         iH5nBcRPyyJKSQcJ1Wx3b5sRU1lo2C99F9bfTCajdqZXd6hlw9Tz4TjrALhJFJlYu6
         IyfZ9z7HpctaC/vLeV5axvHHUQTzvUefuC3ygM3ZmiRcCnFKf1Bo2LlSUw/yPX/ILG
         0A9mORC+CMtkyTZNXSkIE62Y5/LI8fcVLWz2ynZt/gH1VfQIAB8dfUvZCJs93gnEjW
         4atBQ1hpM8NDWF52R/GysOnDV3BnR6NW/LCNAeehbKKwSq3Yo5tA411wH4Jx+RKVPV
         Lu8847vurH/aQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AF4DBE5D084;
        Tue,  8 Feb 2022 05:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4] inet: Separate DSCP from ECN bits using new
 dscp_t type
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164429700971.22743.17071261100500230532.git-patchwork-notify@kernel.org>
Date:   Tue, 08 Feb 2022 05:10:09 +0000
References: <cover.1643981839.git.gnault@redhat.com>
In-Reply-To: <cover.1643981839.git.gnault@redhat.com>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, toke@redhat.com,
        shuah@kernel.org, linux-kselftest@vger.kernel.org,
        russell@strong.id.au, dave.taht@gmail.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 4 Feb 2022 14:58:09 +0100 you wrote:
> The networking stack currently doesn't clearly distinguish between DSCP
> and ECN bits. The entire DSCP+ECN bits are stored in u8 variables (or
> structure fields), and each part of the stack handles them in their own
> way, using different macros. This has created several bugs in the past
> and some uncommon code paths are still unfixed.
> 
> Such bugs generally manifest by selecting invalid routes because of ECN
> bits interfering with FIB routes and rules lookups (more details in the
> LPC 2021 talk[1] and in the RFC of this series[2]).
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] ipv6: Define dscp_t and stop taking ECN bits into account in fib6-rules
    (no matching commit)
  - [net-next,2/4] ipv4: Stop taking ECN bits into account in fib4-rules
    https://git.kernel.org/netdev/net-next/c/563f8e97e054
  - [net-next,3/4] ipv4: Reject routes specifying ECN bits in rtm_tos
    https://git.kernel.org/netdev/net-next/c/f55fbb6afb8d
  - [net-next,4/4] ipv4: Use dscp_t in struct fib_alias
    https://git.kernel.org/netdev/net-next/c/32ccf1107980

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


