Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA53650DE5C
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 13:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238847AbiDYLD1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 07:03:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241602AbiDYLDP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 07:03:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D72D8C7F1
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 04:00:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D7B1960F75
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 11:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3B7ADC385AB;
        Mon, 25 Apr 2022 11:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650884411;
        bh=8JN+K0pO14yQH7tPLcgdN3UzhICAlO37tob3pulLtSY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sWqUElHrieEuQ+NBoGvI46y91Ps4gAwFVGlzA7ORVgk4w1qw+sQ2TeepcKy5QDwtM
         0MHer5EAOCeiaeL56ysNJwQDhaC1mJQjDk2I9nPWFHHw234r/8SUSW996DpqKq7gER
         Mmkg1wZZpVA+ACfgDemcr7g4HiFzv9yvb9GWnCDQzWGpHLjQw4prAP6dkKPfJz7uol
         f28gXTANsTvCmW+c8u1zn83TVXSip7510hDbEmzbnjXRzfeUoj/zshjnyc+bzQi8sV
         NfEeMb0EXfic0Rje9Py72KOFxufo+mb4MNGbxIFDxrzDppKd13d75uOGNnTs4vNYJA
         F0G/5IQ/IwBeA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1EAC5EAC09C;
        Mon, 25 Apr 2022 11:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] Fix Ocelot VLAN regressions introduced by FDB
 isolation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165088441111.15733.14466039470125512601.git-patchwork-notify@kernel.org>
Date:   Mon, 25 Apr 2022 11:00:11 +0000
References: <20220421230105.3570690-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220421230105.3570690-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        pabeni@redhat.com, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, olteanv@gmail.com,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com
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

On Fri, 22 Apr 2022 02:01:03 +0300 you wrote:
> There are 2 regressions in the VLAN handling code of the ocelot/felix
> DSA driver which can be seen when running the bridge_vlan_aware.sh
> selftest. These manifest in the form of valid VLAN configurations being
> rejected by the driver with incorrect extack messages.
> 
> First regression occurs when we attempt to install an egress-untagged
> bridge VLAN to a bridge port that was brought up *while* it was under a
> bridge (not before).
> 
> [...]

Here is the summary with links:
  - [net,1/2] net: mscc: ocelot: ignore VID 0 added by 8021q module
    https://git.kernel.org/netdev/net/c/9323ac367005
  - [net,2/2] net: mscc: ocelot: don't add VID 0 to ocelot->vlans when leaving VLAN-aware bridge
    https://git.kernel.org/netdev/net/c/1fcb8fb3522f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


