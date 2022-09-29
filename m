Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AA615EEB99
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 04:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234728AbiI2CUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 22:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234566AbiI2CUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 22:20:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DE3F9AFF7
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 19:20:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 562E161F2A
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 02:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AD864C43143;
        Thu, 29 Sep 2022 02:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664418017;
        bh=c9/cBGTyqtwPL5GCl6xiOEns7VU5VliT3AcqmnhX2K8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Vri2S7MaY6Yy0bvhV4a0+2yZ/5VXUJEb5DU0tcGl0InU2/lmzNkFMMVSeXkCRw/Ig
         kdbWN0iQv15DZpwDuzuIvGzLjgYn2fINEqvBzAIVv1PReirmRgxWgUGEqA1m+A1122
         DjXJ3KshDdB4dAV8W2ILnQV/k1w+j0NNtlFzfiS+Vj6FYW7FFGZjSOjNIRajjaXwYq
         RqxW8/OwMnxHjKjQEzMkkQzcIZYyYLoC1QM2T8Pzljp2/5z1pCVpO+nlqCBIekvzO+
         Ojx4OGYjQe8qe4qmBL/znPwwztdV4p1LJo3wjrGewG0HLiyQXfElSFLmgktXHa9B55
         7WkemcYXsn2xQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 90C25E4D022;
        Thu, 29 Sep 2022 02:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: mscc: ocelot: fix tagged VLAN refusal while under a
 VLAN-unaware bridge
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166441801758.18961.18103006412857469945.git-patchwork-notify@kernel.org>
Date:   Thu, 29 Sep 2022 02:20:17 +0000
References: <20220927122042.1100231-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220927122042.1100231-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, colin.foster@in-advantage.com, fido_max@inbox.ru
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 27 Sep 2022 15:20:42 +0300 you wrote:
> Currently the following set of commands fails:
> 
> $ ip link add br0 type bridge # vlan_filtering 0
> $ ip link set swp0 master br0
> $ bridge vlan
> port              vlan-id
> swp0              1 PVID Egress Untagged
> $ bridge vlan add dev swp0 vid 10
> Error: mscc_ocelot_switch_lib: Port with more than one egress-untagged VLAN cannot have egress-tagged VLANs.
> 
> [...]

Here is the summary with links:
  - [net] net: mscc: ocelot: fix tagged VLAN refusal while under a VLAN-unaware bridge
    https://git.kernel.org/netdev/net/c/276d37eb4491

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


