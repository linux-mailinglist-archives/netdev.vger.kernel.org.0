Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97CFC592C80
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 12:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242361AbiHOKkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 06:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbiHOKkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 06:40:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62046103;
        Mon, 15 Aug 2022 03:40:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EABAD610A0;
        Mon, 15 Aug 2022 10:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 49499C433C1;
        Mon, 15 Aug 2022 10:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660560014;
        bh=IN/SUAzchpOoLNXggdYmu94Tr7OW2tb2RGVJjwYbZAQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=urFWGcH2Da2d8L2Qn855+I5hT0lqSXPiofm29qOG8tNSugzJJaw80NlKaYWxFSC0Z
         d1/rXVxVU5r+DcZ/aP3mPxsuHMB6XVxlfOmA3yP2o/zLq1WcBu1P+UpdRZMZ+tqUpu
         UixGFjb6nsim4YKF+9GQ1NWtzT4rzqWUXFagDe9RnfPe04iP5xbgMmUKF5GlpESvXA
         3L0zRgefjpRiouXDVpbMgxPfgEqELaLFJcLQD7fKzRCZsen3qj6UOIgTu97a7/s2b+
         yc2uNqI1DuywGzRcSYH69YyG8sk37m7MK0uVGy2phViIwTycTushyMlSpnyIOoKGmc
         szzj+/x0aycCg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2C5AFC43142;
        Mon, 15 Aug 2022 10:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 0/2] neighbour: fix possible DoS due to net iface
 start/stop loop
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166056001417.15339.4238820299140401617.git-patchwork-notify@kernel.org>
Date:   Mon, 15 Aug 2022 10:40:14 +0000
References: <20220811152012.319641-1-alexander.mikhalitsyn@virtuozzo.com>
In-Reply-To: <20220811152012.319641-1-alexander.mikhalitsyn@virtuozzo.com>
To:     Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, daniel@iogearbox.net,
        dsahern@kernel.org, yajun.deng@linux.dev, roopa@nvidia.com,
        brauner@kernel.org, linux-kernel@vger.kernel.org, den@openvz.org,
        kuznet@ms2.inr.ac.ru, khorenko@virtuozzo.com,
        ptikhomirov@virtuozzo.com, andrey.zhadchenko@virtuozzo.com,
        alexander@mihalicyn.com, kernel@openvz.org, devel@openvz.org
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

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 11 Aug 2022 18:20:10 +0300 you wrote:
> Dear friends,
> 
> Recently one of OpenVZ users reported that they have issues with network
> availability of some containers. It was discovered that the reason is absence
> of ARP replies from the Host Node on the requests about container IPs.
> 
> Of course, we started from tcpdump analysis and noticed that ARP requests
> successfuly comes to the problematic node external interface. So, something
> was wrong from the kernel side.
> 
> [...]

Here is the summary with links:
  - [v3,1/2] neigh: fix possible DoS due to net iface start/stop loop
    https://git.kernel.org/netdev/net/c/66ba215cb513
  - [v3,2/2] neighbour: make proxy_queue.qlen limit per-device
    https://git.kernel.org/netdev/net/c/0ff4eb3d5ebb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


