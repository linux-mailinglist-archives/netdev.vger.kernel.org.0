Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 515495192D2
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 02:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244584AbiEDAeB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 20:34:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244683AbiEDAdu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 20:33:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 235CC140A6;
        Tue,  3 May 2022 17:30:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A5F2661898;
        Wed,  4 May 2022 00:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F3147C385AF;
        Wed,  4 May 2022 00:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651624212;
        bh=KglZuKagv0gxyqvRJeEFFLrjR00kKp2Es5+aP8KqLCo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EeyEI1GdWm4F4DokikeqeKYKcGNKhfOlCb/a2TFROJK/ArROTd4C2zVPiEZRIOukD
         VXOpuFu9R016IP6MFqCTz0ejALYO1ny08t6zlwLmP/WKICBQ0i6dbsaeTUlRixR0iU
         15AUq/hXHNG+gNyBnBHQusl+Kxh2fSLIxTtdcuf5iZ+sKgJx1OPlFB9sGtDSVaeNBR
         A4rLY2Gn4IVBCQG+2hHTBx/1lF4+EVij7c9cALTSVWGCzTRhWe2ab+Jt2Y/FA9pvhp
         wyfFbeU80dd9ZbHnHd0YENhIaaIN7mkurx64BLdSG2G8ZhGqgNcWGLn/oVDKic2Y3Q
         CLim5x4gvf2Hw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CA0A9F03847;
        Wed,  4 May 2022 00:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] selftests: forwarding: add basic QoS classification
 test for Ocelot switches
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165162421182.21688.5454422128647214455.git-patchwork-notify@kernel.org>
Date:   Wed, 04 May 2022 00:30:11 +0000
References: <20220502155424.4098917-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220502155424.4098917-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        pabeni@redhat.com, edumazet@google.com, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, andrew@lunn.ch, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        yangbo.lu@nxp.com, xiaoliang.yang_1@nxp.com, idosch@nvidia.com,
        petrm@nvidia.com, maxime.chevallier@bootlin.com,
        colin.foster@in-advantage.com, linux-kselftest@vger.kernel.org,
        shuah@kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  2 May 2022 18:54:24 +0300 you wrote:
> Test basic (port-default, VLAN PCP and IP DSCP) QoS classification for
> Ocelot switches. Advanced QoS classification using tc filters is covered
> by tc_flower_chains.sh in the same directory.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  .../selftests/drivers/net/ocelot/basic_qos.sh | 253 ++++++++++++++++++
>  1 file changed, 253 insertions(+)
>  create mode 100755 tools/testing/selftests/drivers/net/ocelot/basic_qos.sh

Here is the summary with links:
  - [net-next] selftests: forwarding: add basic QoS classification test for Ocelot switches
    https://git.kernel.org/netdev/net-next/c/7d4e91e06486

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


