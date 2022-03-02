Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7AA54C9B46
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 03:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239110AbiCBCk4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 21:40:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239051AbiCBCkz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 21:40:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C3B02E6AC
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 18:40:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BBB36B81EFE
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 02:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3F216C340F0;
        Wed,  2 Mar 2022 02:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646188810;
        bh=LTl5Wx1BgVP1gOgLIaxUkI6uWzAKOSRwsUdO1rMDi1Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=i5OqVahrZN/WdyE0bIvL9RShXqkU8xaha3ebCRDCXNW5mjAgcvDl1jGL28QJ/30QP
         bk1TNGXqnafCRc7xF6Osv4z7ZYVSTHu4mlBxZjv3/R9M3D8Qr1gk2hk2JwV3iXzb/B
         mWpTtEckL7HZRAb0Vn2Z2aFn/SOIv50k2iWV9xoDu5aL7I3bipjlLBsaH2t2OBRjJF
         tVAJ7H7Plv4Yd6TdKWlX9bW7taapesIHsdYpmwqvRjjI1c0rI1yMJ+Do9Vowmee3KB
         ZsOHsPAKZAUVw7xgrUK/IXakAyM6oJExhueEFccx9IkeVpEsQVxyqVJAbLyWdniIty
         Vc1xR/3GgrnLg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1A87BEAC096;
        Wed,  2 Mar 2022 02:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dsa: restore error path of dsa_tree_change_tag_proto
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164618881010.18670.11444898290619701913.git-patchwork-notify@kernel.org>
Date:   Wed, 02 Mar 2022 02:40:10 +0000
References: <20220228141715.146485-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220228141715.146485-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        olteanv@gmail.com, ansuelsmth@gmail.com
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 28 Feb 2022 16:17:15 +0200 you wrote:
> When the DSA_NOTIFIER_TAG_PROTO returns an error, the user space process
> which initiated the protocol change exits the kernel processing while
> still holding the rtnl_mutex. So any other process attempting to lock
> the rtnl_mutex would deadlock after such event.
> 
> The error handling of DSA_NOTIFIER_TAG_PROTO was inadvertently changed
> by the blamed commit, introducing this regression. We must still call
> rtnl_unlock(), and we must still call DSA_NOTIFIER_TAG_PROTO for the old
> protocol. The latter is due to the limiting design of notifier chains
> for cross-chip operations, which don't have a built-in error recovery
> mechanism - we should look into using notifier_call_chain_robust for that.
> 
> [...]

Here is the summary with links:
  - [net] net: dsa: restore error path of dsa_tree_change_tag_proto
    https://git.kernel.org/netdev/net/c/0b0e2ff10356

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


