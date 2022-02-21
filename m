Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF864BDD48
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 18:45:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356765AbiBULv1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 06:51:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356768AbiBULuf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 06:50:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBEDD1EEED;
        Mon, 21 Feb 2022 03:50:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 51620611DD;
        Mon, 21 Feb 2022 11:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AECAEC340EC;
        Mon, 21 Feb 2022 11:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645444210;
        bh=2xK2DD6+961JwYR2MY2k3NcaI9MsfIk+TlPg/j9dtTI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JBZhs2eRz1VLTooCDRM+67eJkuBopTiSQ2xYl2Rc/dea51TN4Rq5W8Jb4fgbARoK8
         8PgE7wVH9j+MLGov4JJeAm7Q8J0iXx/lkxkOE24hxdnXnmNvzNYMJilyxkQxavXqSu
         VuT2nKx6YJM/szQv265BPS7yh7ljDQ52+3VFe/CDXhNh2w+caQ0eF6pqQQ/RbpAtAU
         ldJ7UdV4UvImHhWIBMFS2cS3orAbt4x2YQPrTj5X0UuIQCi0Q/xk9guPvTzwSjBGUJ
         kIfPbetx70koi7rhl6yO5Cg6tTMANv1dqrlng4C6T9FGzSvHqQS/kRKX9tyyeNDwuJ
         /osJQ408O1wXg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 940C3E5CF96;
        Mon, 21 Feb 2022 11:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3] gso: do not skip outer ip header in case of ipip and
 net_failover
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164544421060.17998.17041019336851197628.git-patchwork-notify@kernel.org>
Date:   Mon, 21 Feb 2022 11:50:10 +0000
References: <20220218143524.61642-1-thomas.liu@ucloud.cn>
In-Reply-To: <20220218143524.61642-1-thomas.liu@ucloud.cn>
To:     Tao Liu <thomas.liu@ucloud.cn>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, edumazet@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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
by David S. Miller <davem@davemloft.net>:

On Fri, 18 Feb 2022 22:35:24 +0800 you wrote:
> We encounter a tcp drop issue in our cloud environment. Packet GROed in
> host forwards to a VM virtio_net nic with net_failover enabled. VM acts
> as a IPVS LB with ipip encapsulation. The full path like:
> host gro -> vm virtio_net rx -> net_failover rx -> ipvs fullnat
>  -> ipip encap -> net_failover tx -> virtio_net tx
> 
> When net_failover transmits a ipip pkt (gso_type = 0x0103, which means
> SKB_GSO_TCPV4, SKB_GSO_DODGY and SKB_GSO_IPXIP4), there is no gso
> did because it supports TSO and GSO_IPXIP4. But network_header points to
> inner ip header.
> 
> [...]

Here is the summary with links:
  - [net,v3] gso: do not skip outer ip header in case of ipip and net_failover
    https://git.kernel.org/netdev/net/c/cc20cced0598

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


