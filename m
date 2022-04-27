Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFEB4512564
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 00:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbiD0Wn0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 18:43:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbiD0WnZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 18:43:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB58A1277A
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 15:40:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B95561DFC
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 22:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 634D8C385AE;
        Wed, 27 Apr 2022 22:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651099211;
        bh=qjlqSnnlj4n5so+yxE4FBJ48i/6pyLrr7YfgnDC/0LQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nNMHEnZOWtaTvO7PTp3t8EScHD++12UsQLmw9g7XUIBhW0MUz+xBTwrjsPQnvD+o8
         zs8Ys1PQ4uERdYfxxmmlQ4cQQ1XENlJs9yzn6kypHmUi+VxZOy5zZIH3+sOZ/dT4Fm
         sVxaug2rCN88HxpNr8TqS8NFNr/fKKu2alRG5O8BLl6mfl5Oz3ouEvvzR5200Ezuo0
         UC8Nf+S3pIn9BL51SSVPklbFzhfewByoOMV4xMlmTI2r3WvA/rGlqLZSVYV2Z3cTrx
         BDbm1HCq0tWrlxdCSpY1Zbw4n27apBX6iOUSrIpAdRMKwm0AT+0L5rcbh/s3D6oN3T
         VU9ex2C/80wOg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 40A79E8DD85;
        Wed, 27 Apr 2022 22:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] tls: Skip tls_append_frag on zero copy size
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165109921126.22144.16254272748385728809.git-patchwork-notify@kernel.org>
Date:   Wed, 27 Apr 2022 22:40:11 +0000
References: <20220426154949.159055-1-maximmi@nvidia.com>
In-Reply-To: <20220426154949.159055-1-maximmi@nvidia.com>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     borisp@nvidia.com, john.fastabend@gmail.com, daniel@iogearbox.net,
        kuba@kernel.org, davem@davemloft.net, pabeni@redhat.com,
        tariqt@nvidia.com, aviadye@mellanox.com, netdev@vger.kernel.org
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
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 26 Apr 2022 18:49:49 +0300 you wrote:
> Calling tls_append_frag when max_open_record_len == record->len might
> add an empty fragment to the TLS record if the call happens to be on the
> page boundary. Normally tls_append_frag coalesces the zero-sized
> fragment to the previous one, but not if it's on page boundary.
> 
> If a resync happens then, the mlx5 driver posts dump WQEs in
> tx_post_resync_dump, and the empty fragment may become a data segment
> with byte_count == 0, which will confuse the NIC and lead to a CQE
> error.
> 
> [...]

Here is the summary with links:
  - [net,v2] tls: Skip tls_append_frag on zero copy size
    https://git.kernel.org/netdev/net/c/a0df71948e95

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


