Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8B4C68948D
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 11:00:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232997AbjBCKAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 05:00:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232291AbjBCKAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 05:00:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEBCD7B40B;
        Fri,  3 Feb 2023 02:00:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E0EFB82A56;
        Fri,  3 Feb 2023 10:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 11B95C4339B;
        Fri,  3 Feb 2023 10:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675418419;
        bh=8AirJ5o4OGmJjbCTnCt47ANglCIZe8XazxiSiTRWwS8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kCAq+o9XSvJ4ehUay4CN4uDmPXPNOkCrmmF8hjglhbUmZlb6JMqR8gQCzjBo+8QxL
         gqI9JH9fAqhachpigqsrHQEXHeWfNi+Cfm70RA4TdIvMjnCToMk6y4op7ZUA7PSyWj
         KywZWG/9c7nvpk3r3LIsuESjm9rKSAH56B3Q2BhAZkgKruhQwKObmEc+ZtyvSXa2kJ
         ZR0Jqs4tG/oxQAQWhLS9zzZMWsfYtYkRMgb9AlEynABRTjoL8ozCd3w27TbqCmkL6I
         hwlcTLaUONLWE1wcuQ7HXXRBnIXAJ2KBcufpBN5P67HBLtiY3rGw49+rHgAvxc//mg
         D/PI4yT8pT6dg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E3D1DE270CA;
        Fri,  3 Feb 2023 10:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: phylink: move phy_device_free() to correctly release
 phy device
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167541841890.29536.5155833242169895352.git-patchwork-notify@kernel.org>
Date:   Fri, 03 Feb 2023 10:00:18 +0000
References: <20230131100242.33514-1-clement.leger@bootlin.com>
In-Reply-To: <20230131100242.33514-1-clement.leger@bootlin.com>
To:     =?utf-8?b?Q2zDqW1lbnQgTMOpZ2VyIDxjbGVtZW50LmxlZ2VyQGJvb3RsaW4uY29tPg==?=@ci.codeaurora.org
Cc:     linux@armlinux.org.uk, andrew@lunn.ch, hkallweit1@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, grant.likely@arm.com,
        calvin.johnson@oss.nxp.com, ioana.ciornei@nxp.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 31 Jan 2023 11:02:42 +0100 you wrote:
> After calling fwnode_phy_find_device(), the phy device refcount is
> incremented. Then, when the phy device is attached to a netdev with
> phy_attach_direct(), the refcount is also incremented but only
> decremented in the caller if phy_attach_direct() fails. Move
> phy_device_free() before the "if" to always release it correctly.
> Indeed, either phy_attach_direct() failed and we don't want to keep a
> reference to the phydev or it succeeded and a reference has been taken
> internally.
> 
> [...]

Here is the summary with links:
  - [net] net: phylink: move phy_device_free() to correctly release phy device
    https://git.kernel.org/netdev/net/c/ce93fdb5f2ca

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


