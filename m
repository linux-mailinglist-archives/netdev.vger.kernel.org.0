Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8958050F30F
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 09:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344351AbiDZHxf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 03:53:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243960AbiDZHx0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 03:53:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 128E9E0A8;
        Tue, 26 Apr 2022 00:50:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4559AB81AD0;
        Tue, 26 Apr 2022 07:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0A045C385A4;
        Tue, 26 Apr 2022 07:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650959411;
        bh=SyM96kAlZhvwbA5ou/RttRY98K2MFlzaVkmgUbGsriI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rFBZM+yBP5iVW67WiVrjwydPVcZvUybbWUcInrLiw1+tr2CE1Ze9R1j7nvJxwIDkd
         ZoNBIWeP8XJSwdYx+gj+n8pe5rIZbGTE9aLZCD2T7VSkzGQzw7uYTPJwCU64nfI82N
         vfIDNoxRSES/7X5uSZsFvFjv2QDCRa5kEq+a4jGlc7CdNQ1ENm2jxeYeTLSKaXXqex
         lgFcpNJvaFZzv3qroZTdfQ/8218NUSzUZQIjsbT5ebjqSCBZGyZPJJwR0LXi+E44XN
         RlEC576i1TtjXbpftHX0EmtmOi7jANbAwzonpu9VcPFYIwWD0z98lY5qrtouq2CSEe
         tXNiYXt9DqaMg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DE1B5E6D402;
        Tue, 26 Apr 2022 07:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v0] mctp: defer the kfree of object mdev->addrs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165095941090.3686.1103250887116949143.git-patchwork-notify@kernel.org>
Date:   Tue, 26 Apr 2022 07:50:10 +0000
References: <20220422114340.32346-1-linma@zju.edu.cn>
In-Reply-To: <20220422114340.32346-1-linma@zju.edu.cn>
To:     Lin Ma <linma@zju.edu.cn>
Cc:     jk@codeconstruct.com.au, matt@codeconstruct.com.au,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Fri, 22 Apr 2022 19:43:40 +0800 you wrote:
> The function mctp_unregister() reclaims the device's relevant resource
> when a netcard detaches. However, a running routine may be unaware of
> this and cause the use-after-free of the mdev->addrs object.
> 
> The race condition can be demonstrated below
> 
>  cleanup thread               another thread
>                           |
> unregister_netdev()       |  mctp_sendmsg()
> ...                       |    ...
>   mctp_unregister()       |    rt = mctp_route_lookup()
>     ...                   |    mctl_local_output()
>     kfree(mdev->addrs)    |      ...
>                           |      saddr = rt->dev->addrs[0];
>                           |
> 
> [...]

Here is the summary with links:
  - [v0] mctp: defer the kfree of object mdev->addrs
    https://git.kernel.org/netdev/net/c/b561275d633b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


