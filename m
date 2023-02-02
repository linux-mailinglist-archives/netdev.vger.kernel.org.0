Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B78856874F0
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 06:10:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231617AbjBBFK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 00:10:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231185AbjBBFKX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 00:10:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7EC76DFD2
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 21:10:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 72278B8247C
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 05:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0E853C4339B;
        Thu,  2 Feb 2023 05:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675314619;
        bh=UUbyhDItL0pGLfzuDm/D1Gd3lh/IbOlj4zLMcRHgBm8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=V0zrrWACJuH74XhSMN9OThLDdayMO6wvUK9JZWZ1wc8Ib9a7JXqJmHW5xddmE7H+Y
         qpVYF4lcvfiFGOLP4p54YQ54I1XazCqemSQsdb0ooW+Wn9BWBYkv8FiqU4UcatbvZE
         6fvnBLj/MbWp9xypfgm3e0dWkeb+umC04NzoUA63NHAeyvK3N0r8nurTuYH6qlX9+o
         CJESi5j/q7Td0PtNFde92zyYeSYsXjM5uU+w0POzX/VhL1d2iUOiH/ZDkk3K48k3tb
         CEcA8yzIQ8xkFBfzXJ4DdfzwOJTnGGkFrzaE1ogwVwaioQCNaADep9HwtL/bvzAuhA
         E3bRMinc0oPQw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DA29DC0C40E;
        Thu,  2 Feb 2023 05:10:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv4 net-next 00/10] net: support ipv4 big tcp
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167531461888.3090.18277263241067373566.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Feb 2023 05:10:18 +0000
References: <cover.1674921359.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1674921359.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, dsahern@gmail.com,
        yoshfuji@linux-ipv6.org, pshelar@ovn.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, pablo@netfilter.org,
        fw@strlen.de, marcelo.leitner@gmail.com, i.maximets@ovn.org,
        aconole@redhat.com, roopa@nvidia.com, razor@blackwall.org,
        maheshb@google.com, paul@paul-moore.com, gnault@redhat.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Sat, 28 Jan 2023 10:58:29 -0500 you wrote:
> This is similar to the BIG TCP patchset added by Eric for IPv6:
> 
>   https://lwn.net/Articles/895398/
> 
> Different from IPv6, IPv4 tot_len is 16-bit long only, and IPv4 header
> doesn't have exthdrs(options) for the BIG TCP packets' length. To make
> it simple, as David and Paolo suggested, we set IPv4 tot_len to 0 to
> indicate this might be a BIG TCP packet and use skb->len as the real
> IPv4 total length.
> 
> [...]

Here is the summary with links:
  - [PATCHv4,net-next,01/10] net: add a couple of helpers for iph tot_len
    https://git.kernel.org/netdev/net-next/c/058a8f7f73aa
  - [PATCHv4,net-next,02/10] bridge: use skb_ip_totlen in br netfilter
    https://git.kernel.org/netdev/net-next/c/46abd17302ba
  - [PATCHv4,net-next,03/10] openvswitch: use skb_ip_totlen in conntrack
    https://git.kernel.org/netdev/net-next/c/ec84c955a0d0
  - [PATCHv4,net-next,04/10] net: sched: use skb_ip_totlen and iph_totlen
    https://git.kernel.org/netdev/net-next/c/043e397e48c5
  - [PATCHv4,net-next,05/10] netfilter: use skb_ip_totlen and iph_totlen
    https://git.kernel.org/netdev/net-next/c/a13fbf5ed5b4
  - [PATCHv4,net-next,06/10] cipso_ipv4: use iph_set_totlen in skbuff_setattr
    https://git.kernel.org/netdev/net-next/c/7eb072be41ba
  - [PATCHv4,net-next,07/10] ipvlan: use skb_ip_totlen in ipvlan_get_L3_hdr
    https://git.kernel.org/netdev/net-next/c/50e6fb5c6efb
  - [PATCHv4,net-next,08/10] packet: add TP_STATUS_GSO_TCP for tp_status
    https://git.kernel.org/netdev/net-next/c/8e08bb75b60f
  - [PATCHv4,net-next,09/10] net: add gso_ipv4_max_size and gro_ipv4_max_size per device
    https://git.kernel.org/netdev/net-next/c/9eefedd58ae1
  - [PATCHv4,net-next,10/10] net: add support for ipv4 big tcp
    https://git.kernel.org/netdev/net-next/c/b1a78b9b9886

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


