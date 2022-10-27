Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A23E860F5B6
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 12:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234241AbiJ0KuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 06:50:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234480AbiJ0KuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 06:50:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A6853AB09
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 03:50:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 13530B82584
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 10:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A55FBC43146;
        Thu, 27 Oct 2022 10:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666867816;
        bh=tVhOO4IUiaA5FTYST2c/mlsbVWyGan3XjWM5a4+mxYU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=C5rwz40qmE63rnAsLTjX/saaKGIN+yPLsCv8RadW/MAh7PNpTKsV7AsJ4i/Wg0+/I
         Vn68wjVmLIGd/rhrVeQ8bBskKX0xpEiokOW5cmlnVVWn6HJHr1OFwx9Kq/I3au4nAv
         QqrkeF7+wN6L2Ahi6l2ZHP4th4teatqHkdHLVgfpZDJvI0YQ6+/ymKuyHUD7L9uA3g
         PyAsNIYjHXOKtde1t4280c5Eki1mOIwUc6ZUx94UCRUP4XwtJXaLhzLuHo3z/0pCP2
         Z+aAAzEEDjrpji+EmVbx/8Rj1yki1s9jfvnTNDRD183hrhMUsSutAl8rjfdoF8wwqB
         qWI8Z2ltrKk4w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8E115E270DA;
        Thu, 27 Oct 2022 10:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] bond: Disable TLS features indication
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166686781657.26454.14252790072512743395.git-patchwork-notify@kernel.org>
Date:   Thu, 27 Oct 2022 10:50:16 +0000
References: <20221025105300.4718-1-tariqt@nvidia.com>
In-Reply-To: <20221025105300.4718-1-tariqt@nvidia.com>
To:     Tariq Toukan <tariqt@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, borisp@nvidia.com, john.fastabend@gmail.com,
        netdev@vger.kernel.org, saeedm@nvidia.com, gal@nvidia.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 25 Oct 2022 13:53:00 +0300 you wrote:
> Bond agnostically interacts with TLS device-offload requests via the
> .ndo_sk_get_lower_dev operation. Return value is true iff bond
> guarantees fixed mapping between the TLS connection and a lower netdev.
> 
> Due to this nature, the bond TLS device offload features are not
> explicitly controllable in the bond layer. As of today, these are
> read-only values based on the evaluation of bond_sk_check().  However,
> this indication might be incorrect and misleading, when the feature bits
> are "fixed" by some dependency features.  For example,
> NETIF_F_HW_TLS_TX/RX are forcefully cleared in case the corresponding
> checksum offload is disabled. But in fact the bond ability to still
> offload TLS connections to the lower device is not hurt.
> 
> [...]

Here is the summary with links:
  - [net-next] bond: Disable TLS features indication
    https://git.kernel.org/netdev/net-next/c/28581b9c2c94

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


