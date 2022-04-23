Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41C9150C977
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 13:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235117AbiDWLDN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Apr 2022 07:03:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232883AbiDWLDL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Apr 2022 07:03:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09582E72
        for <netdev@vger.kernel.org>; Sat, 23 Apr 2022 04:00:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B2CAAB80B20
        for <netdev@vger.kernel.org>; Sat, 23 Apr 2022 11:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4D40AC385A0;
        Sat, 23 Apr 2022 11:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650711612;
        bh=wTEpW5crzbWU23lACHJ6N3S1AID+v/qtxAzBSnyteMk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Px2wD0iiADZhdBpqM9wqhqJrNKTPizs0AeHwXHN8kNw0o2d97fpDXTptNJwd/5z+n
         xjmosw96qqrIDIFXnJU7J3D+L+FK7tTsdsYJCLV03RaS2emwAQAJMXuuf1IWOVoB6W
         obgXSkbWzeXrWQrl6DscWXJxKM2u/ianBSuS5x/hPPUW7bbrB7QVZa/IA/Dn4E4pYk
         gYQv/QuR2eHelcYyH/Ai+ra6/x8SZameC735fpxvGDQKCCjy6D4ntPxA4WKQEDScI2
         sLVstc7gtaZ71+vWrWLO9ZUqBQa66z+xfyRlChDt8YeatFfrXoJ5Y/cFPmA+MrHhYL
         BCvqa6EnOrADg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 30760E7399D;
        Sat, 23 Apr 2022 11:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/8] mptcp: TCP fallback for established connections
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165071161219.8812.1323328975738766476.git-patchwork-notify@kernel.org>
Date:   Sat, 23 Apr 2022 11:00:12 +0000
References: <20220422215543.545732-1-mathew.j.martineau@linux.intel.com>
In-Reply-To: <20220422215543.545732-1-mathew.j.martineau@linux.intel.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev
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

On Fri, 22 Apr 2022 14:55:35 -0700 you wrote:
> RFC 8684 allows some MPTCP connections to fall back to regular TCP when
> the MPTCP DSS checksum detects middlebox interference, there is only a
> single subflow, and there is no unacknowledged out-of-sequence
> data. When this condition is detected, the stack sends a MPTCP DSS
> option with an "infinite mapping" to signal that a fallback is
> happening, and the peers will stop sending MPTCP options in their TCP
> headers. The Linux MPTCP stack has not yet supported this type of
> fallback, instead closing the connection when the MPTCP checksum fails.
> 
> [...]

Here is the summary with links:
  - [net-next,1/8] mptcp: don't send RST for single subflow
    https://git.kernel.org/netdev/net-next/c/1761fed25678
  - [net-next,2/8] mptcp: add the fallback check
    https://git.kernel.org/netdev/net-next/c/0348c690ed37
  - [net-next,3/8] mptcp: track and update contiguous data status
    https://git.kernel.org/netdev/net-next/c/0530020a7c8f
  - [net-next,4/8] mptcp: infinite mapping sending
    https://git.kernel.org/netdev/net-next/c/1e39e5a32ad7
  - [net-next,5/8] mptcp: infinite mapping receiving
    https://git.kernel.org/netdev/net-next/c/f8d4bcacff3b
  - [net-next,6/8] mptcp: add mib for infinite map sending
    https://git.kernel.org/netdev/net-next/c/104125b82e5c
  - [net-next,7/8] mptcp: dump infinite_map field in mptcp_dump_mpext
    https://git.kernel.org/netdev/net-next/c/d9fdd02d4265
  - [net-next,8/8] selftests: mptcp: add infinite map mibs check
    https://git.kernel.org/netdev/net-next/c/8bd03be3418c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


