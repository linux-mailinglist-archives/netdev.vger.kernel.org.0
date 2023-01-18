Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF919672013
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 15:47:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230339AbjAROrn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 09:47:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231223AbjAROrS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 09:47:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAD44474D3;
        Wed, 18 Jan 2023 06:40:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 729C5B81D6D;
        Wed, 18 Jan 2023 14:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 08E04C433F1;
        Wed, 18 Jan 2023 14:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674052818;
        bh=Tsm1APk/mXfgMvBuRY8ii5mqCI8QhhSSIAOswYeQn38=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BBBym8a4SW7BF4Nklul6hEwwo7OcPVfJKtt0lYp8g8UgMe6+NW8VL++DGVyRiLYel
         VdWGIlgS6wwXJDZHoLtSqsOQYKp46+s3D4tYQCchR8nAU5s6sTiFUejGTsOmyxL4yP
         BZLnf1QuJ1skOCUs+OfqHbYMNbwcoOsyGpektv8YVujt4nSZMD4EwFXiLKe/3A3E9M
         vlpVmq3gguYE5gstMTH+vGeAQV+ZSUQBKfVlY7y2pVKW0PcOq0hcstnwwJTMwK4JQb
         2IUX8WFqWo6/0BccWutNEhwpSakgF+cb0cD756On6pPTo0QAX6M4YXJO4DVgqSGvys
         oVC/Gvv5VSIxg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DC890C3959E;
        Wed, 18 Jan 2023 14:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/5] Improve locking in the VCAP API
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167405281789.22945.18204552117628849446.git-patchwork-notify@kernel.org>
Date:   Wed, 18 Jan 2023 14:40:17 +0000
References: <20230117085544.591523-1-steen.hegelund@microchip.com>
In-Reply-To: <20230117085544.591523-1-steen.hegelund@microchip.com>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, UNGLinuxDriver@microchip.com,
        rdunlap@infradead.org, casper.casan@gmail.com,
        rmk+kernel@armlinux.org.uk, wanjiabing@vivo.com, nhuck@google.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Steen.Hegelund@microchip.com,
        daniel.machon@microchip.com, horatiu.vultur@microchip.com,
        lars.povlsen@microchip.com, error27@gmail.com, michael@walle.cc
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 17 Jan 2023 09:55:39 +0100 you wrote:
> This improves the VCAP cache and the VCAP rule list protection against
> access from different sources.
> 
> The VCAP Admin lock protects the list of rules for the VCAP instance as
> well as the cache used for encoding and decoding rules.
> 
> This series provides dedicated functions for accessing rule statistics,
> decoding rule content, verifying if a rule exists and getting a rule with
> the lock held, as well as ensuring the use of the lock when the list of
> rules or the cache is accessed.
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] net: microchip: sparx5: Add support for rule count by cookie
    https://git.kernel.org/netdev/net-next/c/27d293cceee5
  - [net-next,2/5] net: microchip: sparx5: Add support to check for existing VCAP rule id
    https://git.kernel.org/netdev/net-next/c/975d86acaec7
  - [net-next,3/5] net: microchip: sparx5: Add VCAP admin locking in debugFS
    https://git.kernel.org/netdev/net-next/c/9579e2c271b4
  - [net-next,4/5] net: microchip: sparx5: Improve VCAP admin locking in the VCAP API
    https://git.kernel.org/netdev/net-next/c/1972b6d927ac
  - [net-next,5/5] net: microchip: sparx5: Add lock initialization to the KUNIT tests
    https://git.kernel.org/netdev/net-next/c/595655e08174

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


