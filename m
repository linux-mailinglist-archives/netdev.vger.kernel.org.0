Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E48268B7E2
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 10:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbjBFJAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 04:00:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjBFJAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 04:00:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D25F30CC
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 01:00:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1854460DBB
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 09:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6B67DC4339B;
        Mon,  6 Feb 2023 09:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675674019;
        bh=LbjlkWb8XyBiD1qMkYuIHIYS60S6zUEjrPIyWyRLYV4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Uo3qk4jFvFweCncj+XaVraSfXNduQQ2tBq/8Jcq++ag07szLlDtzW1T4RDHG/e6Mx
         z2xx7RAwH8LaS1Aer1HzqyFhcRqWejS57nDeLxGjuWvBF1d+JsVbLBD+MWu5+vCvDX
         wALNIEqilBJqgKRh3sUmiYwRpOi/ewoLd7PGHzcfqp7we3mJIe7ilYdLGUHHVa0ZdY
         elhrZvRtEv0zWS9y7hLpqbrK/BCOmPLz95tRQfVPBqUPY2EtrYlgZrcQvddcVgFwul
         PP1YQxddNze0IlrFwb5/7m6ZwuglXmz98HtOB+yv+wd0Q9sTKgD6Gn0xf9F2/CZtb3
         uhNfzNqw3eg4w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 50BB1E55EFC;
        Mon,  6 Feb 2023 09:00:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 00/16] bridge: Limit number of MDB entries per
 port, port-vlan
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167567401932.11144.3817510754379693271.git-patchwork-notify@kernel.org>
Date:   Mon, 06 Feb 2023 09:00:19 +0000
References: <cover.1675359453.git.petrm@nvidia.com>
In-Reply-To: <cover.1675359453.git.petrm@nvidia.com>
To:     Petr Machata <petrm@nvidia.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, roopa@nvidia.com, razor@blackwall.org,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        idosch@nvidia.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 2 Feb 2023 18:59:18 +0100 you wrote:
> The MDB maintained by the bridge is limited. When the bridge is configured
> for IGMP / MLD snooping, a buggy or malicious client can easily exhaust its
> capacity. In SW datapath, the capacity is configurable through the
> IFLA_BR_MCAST_HASH_MAX parameter, but ultimately is finite. Obviously a
> similar limit exists in the HW datapath for purposes of offloading.
> 
> In order to prevent the issue of unilateral exhaustion of MDB resources,
> introduce two parameters in each of two contexts:
> 
> [...]

Here is the summary with links:
  - [net-next,v3,01/16] net: bridge: Set strict_start_type at two policies
    https://git.kernel.org/netdev/net-next/c/c00041cf1cb8
  - [net-next,v3,02/16] net: bridge: Add extack to br_multicast_new_port_group()
    https://git.kernel.org/netdev/net-next/c/60977a0c6337
  - [net-next,v3,03/16] net: bridge: Move extack-setting to br_multicast_new_port_group()
    https://git.kernel.org/netdev/net-next/c/1c85b80b20a1
  - [net-next,v3,04/16] net: bridge: Add br_multicast_del_port_group()
    https://git.kernel.org/netdev/net-next/c/976b3858dd14
  - [net-next,v3,05/16] net: bridge: Change a cleanup in br_multicast_new_port_group() to goto
    https://git.kernel.org/netdev/net-next/c/eceb30854f6b
  - [net-next,v3,06/16] net: bridge: Add a tracepoint for MDB overflows
    https://git.kernel.org/netdev/net-next/c/d47230a3480a
  - [net-next,v3,07/16] net: bridge: Maintain number of MDB entries in net_bridge_mcast_port
    https://git.kernel.org/netdev/net-next/c/b57e8d870d52
  - [net-next,v3,08/16] net: bridge: Add netlink knobs for number / maximum MDB entries
    https://git.kernel.org/netdev/net-next/c/a1aee20d5db2
  - [net-next,v3,09/16] selftests: forwarding: Move IGMP- and MLD-related functions to lib
    https://git.kernel.org/netdev/net-next/c/344dd2c9e743
  - [net-next,v3,10/16] selftests: forwarding: bridge_mdb: Fix a typo
    https://git.kernel.org/netdev/net-next/c/f7ccf60c4ada
  - [net-next,v3,11/16] selftests: forwarding: lib: Add helpers for IP address handling
    https://git.kernel.org/netdev/net-next/c/fcf4927632ee
  - [net-next,v3,12/16] selftests: forwarding: lib: Add helpers for checksum handling
    https://git.kernel.org/netdev/net-next/c/952e0ee38c72
  - [net-next,v3,13/16] selftests: forwarding: lib: Parameterize IGMPv3/MLDv2 generation
    https://git.kernel.org/netdev/net-next/c/506a1ac9d32b
  - [net-next,v3,14/16] selftests: forwarding: lib: Allow list of IPs for IGMPv3/MLDv2
    https://git.kernel.org/netdev/net-next/c/705d4bc7b6b6
  - [net-next,v3,15/16] selftests: forwarding: lib: Add helpers to build IGMP/MLD leave packets
    https://git.kernel.org/netdev/net-next/c/9ae854697317
  - [net-next,v3,16/16] selftests: forwarding: bridge_mdb_max: Add a new selftest
    https://git.kernel.org/netdev/net-next/c/3446dcd7df05

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


