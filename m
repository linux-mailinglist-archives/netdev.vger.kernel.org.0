Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC15B6E1BC0
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 07:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbjDNFan (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 01:30:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbjDNFaj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 01:30:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7AB659C5;
        Thu, 13 Apr 2023 22:30:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E8E764428;
        Fri, 14 Apr 2023 05:30:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 816B4C4339C;
        Fri, 14 Apr 2023 05:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681450222;
        bh=amiEszvsisGwIWBvP31HENcYzKgXoVYVT4ZU1EWAtSo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qHffbMfqtunWiB8VXBDSEQoxr/GCTU4NifX8zXJ1Zf/95NTYg1eWMwCpGr8scDLQy
         y9zeMUZdWTDRdGIf3o+InXOBechNl8192B5QSe78uRQHvXJrEnqhLilX8tjLWwvMzj
         sNRW6t+Ssd+/jwwnRro8LtFUIIk1TrLrw1wIrkXcYem5tFcLGba31YU5A1sgjlXQ4y
         VbQQNUhnU7b1nrRoPAZk2o54XPh548p29aURJ8u8IyAjiwzWBi08rXrzi0HQ0z+pNA
         JgC37J04vtz0cqgLOBMK8x0sogtwtj7nfrJC1Jyt387/OjAJd94lf8gSeKzCmIYxKo
         2eADINQ5C2L8g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 678F2E52446;
        Fri, 14 Apr 2023 05:30:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v5 net-next 0/9] Add kernel tc-mqprio and tc-taprio support
 for preemptible traffic classes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168145022242.29714.235263981866322641.git-patchwork-notify@kernel.org>
Date:   Fri, 14 Apr 2023 05:30:22 +0000
References: <20230411180157.1850527-1-vladimir.oltean@nxp.com>
In-Reply-To: <20230411180157.1850527-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        vinicius.gomes@intel.com, kurt@linutronix.de,
        gerhard@engleder-embedded.com, amritha.nambiar@intel.com,
        ferenc.fejes@ericsson.com, xiaoliang.yang_1@nxp.com,
        rogerq@kernel.org, pranavi.somisetty@amd.com,
        harini.katakam@amd.com, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, michael.wei.hong.sit@intel.com,
        mohammad.athari.ismail@intel.com, linux@rempel-privat.de,
        jacob.e.keller@intel.com, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 11 Apr 2023 21:01:48 +0300 you wrote:
> The last RFC in August 2022 contained a proposal for the UAPI of both
> TSN standards which together form Frame Preemption (802.1Q and 802.3):
> https://lore.kernel.org/netdev/20220816222920.1952936-1-vladimir.oltean@nxp.com/
> 
> It wasn't clear at the time whether the 802.1Q portion of Frame Preemption
> should be exposed via the tc qdisc (mqprio, taprio) or via some other
> layer (perhaps also ethtool like the 802.3 portion, or dcbnl), even
> though the options were discussed extensively, with pros and cons:
> https://lore.kernel.org/netdev/20220816222920.1952936-3-vladimir.oltean@nxp.com/
> 
> [...]

Here is the summary with links:
  - [v5,net-next,1/9] net: ethtool: create and export ethtool_dev_mm_supported()
    https://git.kernel.org/netdev/net-next/c/d54151aa0f4b
  - [v5,net-next,2/9] net/sched: mqprio: simplify handling of nlattr portion of TCA_OPTIONS
    https://git.kernel.org/netdev/net-next/c/3dd0c16ec93e
  - [v5,net-next,3/9] net/sched: mqprio: add extack to mqprio_parse_nlattr()
    https://git.kernel.org/netdev/net-next/c/57f21bf85400
  - [v5,net-next,4/9] net/sched: mqprio: add an extack message to mqprio_parse_opt()
    https://git.kernel.org/netdev/net-next/c/ab277d2084ba
  - [v5,net-next,5/9] net/sched: pass netlink extack to mqprio and taprio offload
    https://git.kernel.org/netdev/net-next/c/c54876cd5961
  - [v5,net-next,6/9] net/sched: mqprio: allow per-TC user input of FP adminStatus
    https://git.kernel.org/netdev/net-next/c/f62af20bed2d
  - [v5,net-next,7/9] net/sched: taprio: allow per-TC user input of FP adminStatus
    https://git.kernel.org/netdev/net-next/c/a721c3e54b80
  - [v5,net-next,8/9] net: enetc: rename "mqprio" to "qopt"
    https://git.kernel.org/netdev/net-next/c/50764da37cbe
  - [v5,net-next,9/9] net: enetc: add support for preemptible traffic classes
    https://git.kernel.org/netdev/net-next/c/01e23b2b3bad

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


