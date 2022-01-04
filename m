Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15F634841B9
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 13:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233055AbiADMkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 07:40:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231898AbiADMkL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 07:40:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98068C061761
        for <netdev@vger.kernel.org>; Tue,  4 Jan 2022 04:40:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 367E4613C5
        for <netdev@vger.kernel.org>; Tue,  4 Jan 2022 12:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 99D31C36AE9;
        Tue,  4 Jan 2022 12:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641300010;
        bh=JemO7ys1f6U/HWdveK3dpC9fpOBcxWwUml+cnWpQ5n8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AfNmVq42XSiSDancOKxpIXoN8aXok8wgML7sD6C4QiBbJ2anmmAixPA7oZBZrri9G
         lR8mn9CDlGPZ7eumll+rE8mZ+67DucDeteD2pzuhnjSRo19Gf+EEt+e03flZ1ftYUo
         tZ6FgJzVgg6zTDj3dRHikPs+IfsLflFphkTNKDc5HNKLB+pgAr3TLK2AUKC1qwqhye
         sRxeu85mUqfqx+n1Duk/+p14EKFsxn4/s+DVRByAdsB6kipdIEUmSoC3Iyut7kxDk9
         aRmQDCXzt68z1Q028ed0DUCVkGdbUtHym2/41ctlHZsDFkKg4CeKNJbHXhvDPIvW+/
         zPebjYKaIyE9g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8359EF79405;
        Tue,  4 Jan 2022 12:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v5 net-next 0/3] Fix traceroute in the presence of SRv6
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164130001053.24992.6088004457600780480.git-patchwork-notify@kernel.org>
Date:   Tue, 04 Jan 2022 12:40:10 +0000
References: <20220103171132.93456-1-andrew@lunn.ch>
In-Reply-To: <20220103171132.93456-1-andrew@lunn.ch>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, willemb@google.com, prestwoj@gmail.com,
        justin.iurman@uliege.be, praveen5582@gmail.com, Jason@zx2c4.com,
        edumazet@google.com, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon,  3 Jan 2022 18:11:29 +0100 you wrote:
> When using SRv6 the destination IP address in the IPv6 header is not
> always the true destination, it can be a router along the path that
> SRv6 is using.
> 
> When ICMP reports an error, e.g, time exceeded, which is what
> traceroute uses, it included the packet which invoked the error into
> the ICMP message body. Upon receiving such an ICMP packet, the
> invoking packet is examined and an attempt is made to find the socket
> which sent the packet, so the error can be reported. Lookup is
> performed using the source and destination address. If the
> intermediary router IP address from the IP header is used, the lookup
> fails. It is necessary to dig into the header and find the true
> destination address in the Segment Router header, SRH.
> 
> [...]

Here is the summary with links:
  - [v5,net-next,1/3] seg6: export get_srh() for ICMP handling
    https://git.kernel.org/netdev/net/c/fa55a7d745de
  - [v5,net-next,2/3] icmp: ICMPV6: Examine invoking packet for Segment Route Headers.
    https://git.kernel.org/netdev/net/c/e41294408c56
  - [v5,net-next,3/3] udp6: Use Segment Routing Header for dest address if present
    https://git.kernel.org/netdev/net/c/222a011efc83

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


