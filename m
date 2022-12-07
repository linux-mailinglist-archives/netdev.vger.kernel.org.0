Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF546451C7
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 03:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbiLGCKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 21:10:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbiLGCKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 21:10:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5021645ECD;
        Tue,  6 Dec 2022 18:10:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E0EF0611D6;
        Wed,  7 Dec 2022 02:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3D9EEC433D7;
        Wed,  7 Dec 2022 02:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670379018;
        bh=dOr+qztnngszfpp2eOrSQgntQvej41Vfq61jH8VjaMI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RW1ksyP0fxUdLoR21eUi2nzrfdGTNE6RfNWquYu0ZLpVWIJ5Mkqa8gRPGXdRqBuFp
         Q9dIsrqjI8tdCqG8dLJgkvGefow+BNhqRKHy0rGBDJ9nEMSc78WOqWjwiapLl8MZEx
         3hmthm8fsAbDq35BsnUa7XeMotpOogAgO6JM9kMUX6o52LfmaapERurfhc7mob7vh/
         P6FqUMPtNmwZPzSVt75vqT9H+tAOa9WDDu3+o1OejzIA/qmdwnfS1GlX4Z1pyI+S14
         kWo+h/w7UQiJHYvdUIB/QEMF81I2vCeY1nnKq/dCfPuex9VTFvTDnQJMT+Aa8po2+o
         h+g3VjjCdlkYQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 20AD5C395E5;
        Wed,  7 Dec 2022 02:10:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net/ncsi: Silence runtime memcpy() false positive warning
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167037901812.29262.11761339624947092178.git-patchwork-notify@kernel.org>
Date:   Wed, 07 Dec 2022 02:10:18 +0000
References: <20221202212418.never.837-kees@kernel.org>
In-Reply-To: <20221202212418.never.837-kees@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     sam@mendozajonas.com, joel@jms.id.au, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri,  2 Dec 2022 13:24:22 -0800 you wrote:
> The memcpy() in ncsi_cmd_handler_oem deserializes nca->data into a
> flexible array structure that overlapping with non-flex-array members
> (mfr_id) intentionally. Since the mem_to_flex() API is not finished,
> temporarily silence this warning, since it is a false positive, using
> unsafe_memcpy().
> 
> Reported-by: Joel Stanley <joel@jms.id.au>
> Link: https://lore.kernel.org/netdev/CACPK8Xdfi=OJKP0x0D1w87fQeFZ4A2DP2qzGCRcuVbpU-9=4sQ@mail.gmail.com/
> Cc: Samuel Mendoza-Jonas <sam@mendozajonas.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> 
> [...]

Here is the summary with links:
  - net/ncsi: Silence runtime memcpy() false positive warning
    https://git.kernel.org/netdev/net-next/c/b93884eea26f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


