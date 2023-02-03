Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7116F689407
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 10:41:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232847AbjBCJkp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 04:40:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232807AbjBCJkm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 04:40:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CD7725BAB;
        Fri,  3 Feb 2023 01:40:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CBCFE61E54;
        Fri,  3 Feb 2023 09:40:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0AD4CC4339E;
        Fri,  3 Feb 2023 09:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675417221;
        bh=/k+SbAutPWSh1dlHBpz4JedijoZd4GjaA+KmfH7v9W8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TdyQtqdY29keJqDTFD+A/wTNCNtnJNXeSDcjIChmIx+XD/D3B+OvGyq8C8sZlA300
         u7hga/ywCgdOdAIgNxJWaXJWtsK/tDEcewA4ir6QUGXwUw+k28/kVtG+Lrs9c/d3sD
         m+++CqAOy8EPP3YP4g0439LbFQniPJ3FxLfpXatpg395xoAGB9IBW6PzyyymWqslru
         NVoufLUz0EzjISf3qgjz+PP2xsXyecSJrk25DU2EhSb+z2nJoroUjRcXcv4JHuB8NN
         RfKW+N+zfNRloawrhcduQ0/AexWtpORatUJS10fJE0UmUgXCyO6GYM16M2/XyjZigb
         qpxlM1aXULVKg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E642CE21ED1;
        Fri,  3 Feb 2023 09:40:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v6 0/7] Allow offloading of UDP NEW connections via
 act_ct
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167541722093.18212.4252308707328592384.git-patchwork-notify@kernel.org>
Date:   Fri, 03 Feb 2023 09:40:20 +0000
References: <20230201163100.1001180-1-vladbu@nvidia.com>
In-Reply-To: <20230201163100.1001180-1-vladbu@nvidia.com>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        pablo@netfilter.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, ozsh@nvidia.com,
        marcelo.leitner@gmail.com, simon.horman@corigine.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 1 Feb 2023 17:30:53 +0100 you wrote:
> Currently only bidirectional established connections can be offloaded
> via act_ct. Such approach allows to hardcode a lot of assumptions into
> act_ct, flow_table and flow_offload intermediate layer codes. In order
> to enabled offloading of unidirectional UDP NEW connections start with
> incrementally changing the following assumptions:
> 
> - Drivers assume that only established connections are offloaded and
>   don't support updating existing connections. Extract ctinfo from meta
>   action cookie and refuse offloading of new connections in the drivers.
> 
> [...]

Here is the summary with links:
  - [net-next,v6,1/7] net: flow_offload: provision conntrack info in ct_metadata
    https://git.kernel.org/netdev/net-next/c/29744a10c59e
  - [net-next,v6,2/7] netfilter: flowtable: fixup UDP timeout depending on ct state
    https://git.kernel.org/netdev/net-next/c/0eb5acb16418
  - [net-next,v6,3/7] netfilter: flowtable: allow unidirectional rules
    https://git.kernel.org/netdev/net-next/c/8f84780b84d6
  - [net-next,v6,4/7] netfilter: flowtable: cache info of last offload
    https://git.kernel.org/netdev/net-next/c/1a441a9b8be8
  - [net-next,v6,5/7] net/sched: act_ct: set ctinfo in meta action depending on ct state
    https://git.kernel.org/netdev/net-next/c/d5774cb6c55c
  - [net-next,v6,6/7] net/sched: act_ct: offload UDP NEW connections
    https://git.kernel.org/netdev/net-next/c/6a9bad0069cf
  - [net-next,v6,7/7] netfilter: nf_conntrack: allow early drop of offloaded UDP conns
    https://git.kernel.org/netdev/net-next/c/df25455e5a48

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


