Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C33ED509B7C
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 11:07:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387186AbiDUJDZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 05:03:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387164AbiDUJDE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 05:03:04 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82A9D1DA42;
        Thu, 21 Apr 2022 02:00:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D14A3CE2157;
        Thu, 21 Apr 2022 09:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1772CC385A9;
        Thu, 21 Apr 2022 09:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650531612;
        bh=gNO4r0cmXjtpmBzaOjykkU9ynxPC0HXuCxelkhSQFf4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Hqw+MqWaZsGT/etT7FbJy/PGLRoOmwuWvWSVrSHe1MK2pirmLB+iRtzTkslSgqBNm
         x1GwWpLngwnpnoIjHfAJ9jkOzohTEQ9Y3eRd45lC2DB3h56JZfp1HL+5zMR4PuGzxS
         rqOBgsvQD/We3E7q74/kWVptuM4BPNNUw7XNQO1Jnsrnhro1gpc6nyNvuJjC7LJggb
         Uzv9W1Frr1IBqsd6mDnsb7oQjMZw0tnYVdJ0W3rsH7p0ZnLO6/9CCMgCcPlSQ41KlZ
         +ArHfo3OH4xwbRSuEw+y0hYzMYb9p6IETAwCeSkTuRCXpi0Bl5QBE5w61fLbsxExFW
         QFe6OjA0WFqGw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EC296E8DBDA;
        Thu, 21 Apr 2022 09:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] drivers: net: hippi: Fix deadlock in rr_close()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165053161196.2072.5914610893205922675.git-patchwork-notify@kernel.org>
Date:   Thu, 21 Apr 2022 09:00:11 +0000
References: <20220417125519.82618-1-duoming@zju.edu.cn>
In-Reply-To: <20220417125519.82618-1-duoming@zju.edu.cn>
To:     Duoming Zhou <duoming@zju.edu.cn>
Cc:     linux-kernel@vger.kernel.org, jes@trained-monkey.org,
        netdev@vger.kernel.org, linux-hippi@sunsite.dk, pabeni@redhat.com,
        kuba@kernel.org, davem@davemloft.net
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

On Sun, 17 Apr 2022 20:55:19 +0800 you wrote:
> There is a deadlock in rr_close(), which is shown below:
> 
>    (Thread 1)                |      (Thread 2)
>                              | rr_open()
> rr_close()                   |  add_timer()
>  spin_lock_irqsave() //(1)   |  (wait a time)
>  ...                         | rr_timer()
>  del_timer_sync()            |  spin_lock_irqsave() //(2)
>  (wait timer to stop)        |  ...
> 
> [...]

Here is the summary with links:
  - drivers: net: hippi: Fix deadlock in rr_close()
    https://git.kernel.org/netdev/net/c/bc6de2878429

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


