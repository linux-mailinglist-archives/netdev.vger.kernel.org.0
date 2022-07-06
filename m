Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD6C5687D2
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 14:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233344AbiGFMKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 08:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232378AbiGFMKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 08:10:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDA7F25589;
        Wed,  6 Jul 2022 05:10:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 88A66B81CA6;
        Wed,  6 Jul 2022 12:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 41A30C341CA;
        Wed,  6 Jul 2022 12:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657109415;
        bh=Fh74RXkBxb5qR+VbTaZWkzrhg2eyH/wAqBl/LYQyt0A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=c/1vkV/vpUlOMm7VrCDesvLhKVWm6TWzb1lIdab4ZpPubyUfcrGNIpHoAEymG40uh
         DaGUfoBuEmReKSCRCtDgG52No3ouquJvhanoMKm8yasIo1cgRt5oHGw68ESNvTnhgm
         Mj8LwYi05+qsPffq07RvJofSPir+K1EAUwWyxxAWk6/PfciMXwj5a8ON0OvPuxFNyc
         2MSmQ6yIptxQXjRCiwmICxS8tvEAUE+d2Z6EugVzLrPqZMFgaJBd+PF0VCnEAg8fgi
         1dBnxQzXNlLMDhjxqYoiwElgmHlukOe4aXq/labCzhxwTOHEYRo7mMYVRwzOALsbPW
         0dSQmDfwx3aOA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1BA2CE45BDC;
        Wed,  6 Jul 2022 12:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/5] tls: rx: nopad and backlog flushing
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165710941510.29479.16431508550562245023.git-patchwork-notify@kernel.org>
Date:   Wed, 06 Jul 2022 12:10:15 +0000
References: <20220705235926.1035407-1-kuba@kernel.org>
In-Reply-To: <20220705235926.1035407-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, john.fastabend@gmail.com, borisp@nvidia.com,
        linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
        maximmi@nvidia.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue,  5 Jul 2022 16:59:21 -0700 you wrote:
> This small series contains the two changes I've been working
> towards in the previous ~50 patches a couple of months ago.
> 
> The first major change is the optional "nopad" optimization.
> Currently TLS 1.3 Rx performs quite poorly because it does
> not support the "zero-copy" or rather direct decrypt to a user
> space buffer. Because of TLS 1.3 record padding we don't
> know if a record contains data or a control message until
> we decrypt it. Most records will contain data, tho, so the
> optimization is to try the decryption hoping its data and
> retry if it wasn't.
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] tls: rx: don't include tail size in data_len
    https://git.kernel.org/netdev/net-next/c/603380f54f83
  - [net-next,2/5] tls: rx: support optimistic decrypt to user buffer with TLS 1.3
    https://git.kernel.org/netdev/net-next/c/ce61327ce989
  - [net-next,3/5] tls: rx: add sockopt for enabling optimistic decrypt with TLS 1.3
    https://git.kernel.org/netdev/net-next/c/88527790c079
  - [net-next,4/5] selftests: tls: add selftest variant for pad
    https://git.kernel.org/netdev/net-next/c/f36068a20256
  - [net-next,5/5] tls: rx: periodically flush socket backlog
    https://git.kernel.org/netdev/net-next/c/c46b01839f7a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


