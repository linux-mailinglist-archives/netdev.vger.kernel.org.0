Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 372BA575FA1
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 13:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232070AbiGOLAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 07:00:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232147AbiGOLAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 07:00:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3726185FB4
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 04:00:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B6D82B82B75
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 11:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4C382C341C0;
        Fri, 15 Jul 2022 11:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657882816;
        bh=3sdMLNa7te0yItCExYg9Hw517g2g9N+/sML/dUSyf0c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RMX4baU5qhJZYaEPqzvG3ix7WRxvEyrEcf1D+PASebaK8HbT+4DjTnaE84LMbLuII
         7/YI+X+Sig5uBKOvyLj2vssfnW9fVMGxWBWC7B7yjaV8773xukpqX8QFItLJKG/q1L
         MnqokX194hRj3amb67s9/lr1gOxHR869ctTrgs1nQTOpRTG7OKGD82ttotEtlFF0n4
         9tnBFdssAbH2kFilUiIKpsqtwuAdvJEEiWhanzIf8hLYcQMojn3kcsOJDG75FGfTwj
         YOn9ChWxXzPeN4AXt9MQu4+NFQkmhwIeicKFtaf5/vjdVlRWMw2h/uB9jx4ijTfmwd
         C/rMni/XWAUvQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 336B6E45227;
        Fri, 15 Jul 2022 11:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v1 net 00/15] sysctl: Fix data-races around ipv4_net_table
 (Round 2).
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165788281620.10604.17094681395919541354.git-patchwork-notify@kernel.org>
Date:   Fri, 15 Jul 2022 11:00:16 +0000
References: <20220713205205.15735-1-kuniyu@amazon.com>
In-Reply-To: <20220713205205.15735-1-kuniyu@amazon.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, dsahern@kernel.org, kuni1840@gmail.com,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 13 Jul 2022 13:51:50 -0700 you wrote:
> This series fixes data-races around 15 knobs after ip_default_ttl in
> ipv4_net_table.
> 
> These two knobs are skipped.
>   - ip_local_port_range is safe with its own lock.
>   - ip_local_reserved_ports uses proc_do_large_bitmap(), which will need
>     an additional lock and can be fixed later.
> 
> [...]

Here is the summary with links:
  - [v1,net,01/15] ip: Fix data-races around sysctl_ip_default_ttl.
    https://git.kernel.org/netdev/net/c/8281b7ec5c56
  - [v1,net,02/15] ip: Fix data-races around sysctl_ip_no_pmtu_disc.
    https://git.kernel.org/netdev/net/c/0968d2a441bf
  - [v1,net,03/15] ip: Fix data-races around sysctl_ip_fwd_use_pmtu.
    https://git.kernel.org/netdev/net/c/60c158dc7b1f
  - [v1,net,04/15] ip: Fix data-races around sysctl_ip_fwd_update_priority.
    https://git.kernel.org/netdev/net/c/7bf9e18d9a5e
  - [v1,net,05/15] ip: Fix data-races around sysctl_ip_nonlocal_bind.
    https://git.kernel.org/netdev/net/c/289d3b21fb0b
  - [v1,net,06/15] ip: Fix a data-race around sysctl_ip_autobind_reuse.
    https://git.kernel.org/netdev/net/c/0db232765887
  - [v1,net,07/15] ip: Fix a data-race around sysctl_fwmark_reflect.
    https://git.kernel.org/netdev/net/c/85d0b4dbd74b
  - [v1,net,08/15] tcp/dccp: Fix a data-race around sysctl_tcp_fwmark_accept.
    https://git.kernel.org/netdev/net/c/1a0008f9df59
  - [v1,net,09/15] tcp: Fix data-races around sysctl_tcp_l3mdev_accept.
    https://git.kernel.org/netdev/net/c/08a75f106794
  - [v1,net,10/15] tcp: Fix data-races around sysctl_tcp_mtu_probing.
    https://git.kernel.org/netdev/net/c/f47d00e077e7
  - [v1,net,11/15] tcp: Fix data-races around sysctl_tcp_base_mss.
    https://git.kernel.org/netdev/net/c/88d78bc097cd
  - [v1,net,12/15] tcp: Fix data-races around sysctl_tcp_min_snd_mss.
    https://git.kernel.org/netdev/net/c/78eb166cdefc
  - [v1,net,13/15] tcp: Fix a data-race around sysctl_tcp_mtu_probe_floor.
    https://git.kernel.org/netdev/net/c/8e92d4423615
  - [v1,net,14/15] tcp: Fix a data-race around sysctl_tcp_probe_threshold.
    https://git.kernel.org/netdev/net/c/92c0aa417547
  - [v1,net,15/15] tcp: Fix a data-race around sysctl_tcp_probe_interval.
    https://git.kernel.org/netdev/net/c/2a85388f1d94

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


