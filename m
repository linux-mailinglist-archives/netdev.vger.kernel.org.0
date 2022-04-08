Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30A654F9F5B
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 23:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234839AbiDHVwU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 17:52:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230091AbiDHVwS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 17:52:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A7A0269370;
        Fri,  8 Apr 2022 14:50:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A411D62092;
        Fri,  8 Apr 2022 21:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EEDC1C385A1;
        Fri,  8 Apr 2022 21:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649454613;
        bh=MMWxN9/pAcEmvP6x4QuOTX0OpH6h4Vv/E7V6sj/cSjg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pF9LIGW3aXBw4VlnALd1CSaaJswJMRiYIlRFfI5GB9qkrM7I44/v8Pnc04qhFXkSU
         HWQuv1QdqPBm3yKb7R18IrqPhBtC8sX1Zc08yEJUXx49XE85OfXZlc3T11mTSxx/Jk
         emO/3ffaNnqfvurVn4BGBdzV0wGQY9S8pRe+dP7S4JaHHGFdes5eZ9fv3fvYZ5IzPI
         iRnHN5SQ71DfqItLU/CuTbxtuo6CakaPC45IRCKDpj73+wEeDG2UzAHdM/GRXGdsu4
         BWrZ6eREFsYT/2wIn2OPZtDYwjloMpCeUX3hsO1WJvFvrAJYnJCxumv6P/8wMGgimk
         M5buK1TOPFD2A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C9469E8DD5E;
        Fri,  8 Apr 2022 21:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv2 net] sctp: use the correct skb for
 security_sctp_assoc_request
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164945461280.21125.3636048110583865924.git-patchwork-notify@kernel.org>
Date:   Fri, 08 Apr 2022 21:50:12 +0000
References: <71becb489e51284edf0c11fc15246f4ed4cef5b6.1649337862.git.lucien.xin@gmail.com>
In-Reply-To: <71becb489e51284edf0c11fc15246f4ed4cef5b6.1649337862.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, marcelo.leitner@gmail.com,
        nhorman@tuxdriver.com, omosnace@redhat.com
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  7 Apr 2022 09:24:22 -0400 you wrote:
> Yi Chen reported an unexpected sctp connection abort, and it occurred when
> COOKIE_ECHO is bundled with DATA Fragment by SCTP HW GSO. As the IP header
> is included in chunk->head_skb instead of chunk->skb, it failed to check
> IP header version in security_sctp_assoc_request().
> 
> According to Ondrej, SELinux only looks at IP header (address and IPsec
> options) and XFRM state data, and these are all included in head_skb for
> SCTP HW GSO packets. So fix it by using head_skb when calling
> security_sctp_assoc_request() in processing COOKIE_ECHO.
> 
> [...]

Here is the summary with links:
  - [PATCHv2,net] sctp: use the correct skb for security_sctp_assoc_request
    https://git.kernel.org/netdev/net/c/e2d88f9ce678

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


