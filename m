Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD71F6E8BB9
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 09:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233963AbjDTHuz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 03:50:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233754AbjDTHux (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 03:50:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31AD35245;
        Thu, 20 Apr 2023 00:50:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E2A0637E5;
        Thu, 20 Apr 2023 07:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B22D4C4339B;
        Thu, 20 Apr 2023 07:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681977018;
        bh=Zex/PHqNKlzuqAb5IKI38cfJjF9+sZcpSyiYt2IgbdE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=O6PaxSi2uEIQi8YDcQHElp+rn3lkbiN/7ej31a2vyTF/ZgCSzg98dqgK4f8btz+8z
         id81Q/PYJ8nRHy96/kU9sCi0WJqwtGhYISQG8dqFXwMjKNq0DJ7jR4HyrsRqnoaBL3
         ceDfwjPuEPUHQ5VLMThnRnWQrJWvqbkCRsw9Z47NdS7BaG+i9CQVIDjvdVBHeLJx9C
         swN/8z/x1GH3TnizoSHIMMPob+veFvEO48/TtO4mpgsdhhA4hkdYwyNW2RRynQhUiZ
         mC4pNNy9rbKxewJICmXaHQriI0Sp5WBbRg3BgNSz6nUX0+vNKIIWH/bxpokmNLNZMY
         ZDXT/eZfMqb0g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 962A7E50D63;
        Thu, 20 Apr 2023 07:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net] net: bridge: switchdev: don't notify FDB entries with
 "master dynamic"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168197701861.16164.10630611699563272591.git-patchwork-notify@kernel.org>
Date:   Thu, 20 Apr 2023 07:50:18 +0000
References: <20230418155902.898627-1-vladimir.oltean@nxp.com>
In-Reply-To: <20230418155902.898627-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, idosch@nvidia.com,
        netdev@kapio-technology.com, roopa@nvidia.com, razor@blackwall.org,
        ivecera@redhat.com, jiri@resnulli.us, jesse.brandeburg@intel.com,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 18 Apr 2023 18:59:02 +0300 you wrote:
> There is a structural problem in switchdev, where the flag bits in
> struct switchdev_notifier_fdb_info (added_by_user, is_local etc) only
> represent a simplified / denatured view of what's in struct
> net_bridge_fdb_entry :: flags (BR_FDB_ADDED_BY_USER, BR_FDB_LOCAL etc).
> Each time we want to pass more information about struct
> net_bridge_fdb_entry :: flags to struct switchdev_notifier_fdb_info
> (here, BR_FDB_STATIC), we find that FDB entries were already notified to
> switchdev with no regard to this flag, and thus, switchdev drivers had
> no indication whether the notified entries were static or not.
> 
> [...]

Here is the summary with links:
  - [v2,net] net: bridge: switchdev: don't notify FDB entries with "master dynamic"
    https://git.kernel.org/netdev/net/c/927cdea5d209

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


