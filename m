Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB834F6672
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 19:07:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238535AbiDFRHE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 13:07:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238349AbiDFRGu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 13:06:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B36D52EF15D
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 07:30:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F1E1619F2
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 14:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7FEFAC385A3;
        Wed,  6 Apr 2022 14:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649255412;
        bh=EMsk1MmIG4KYmwrrw2CuvR+MA1ADGF7hlBdSEFNR18k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=H0vfJLqwTjm2bQWZmv5eNDUP2cWgoJCYHO0ayJ6zQiB668HcWTbB7ccM0ay7cETO/
         qmxMMHWA3h4bXrA5VJNKpOF3DEafv/9g4FpKXw0FUs+h4mBl1NvA5E0ZWHe8u8H2iU
         CpL9MYBu0oI3dpU17yu+f/FkMs/a3+9tPeMD44EN5dlmtMmIBuXedNLXx5JJZaYXyf
         KyL4KIyAilZdSwGjGfOrAMbbJ8aqddveDmHc0s1pMaI2ygqp90tRQ4x1x3ragS187k
         VXMEkreZ9IikLwfLEqpJAdU50jCGqDqBnDVTMQzB93la05KtKlblvQsDaY6283vNOM
         xinj+pbMzVbCw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5F05CE4A6CB;
        Wed,  6 Apr 2022 14:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: usb: aqc111: Fix out-of-bounds accesses in RX fixup
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164925541238.21938.8958052455955539634.git-patchwork-notify@kernel.org>
Date:   Wed, 06 Apr 2022 14:30:12 +0000
References: <20220406080537.22026-1-marcinguy@gmail.com>
In-Reply-To: <20220406080537.22026-1-marcinguy@gmail.com>
To:     Marcin Kozlowski <marcinguy@gmail.com>
Cc:     netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Wed,  6 Apr 2022 10:05:37 +0200 you wrote:
> aqc111_rx_fixup() contains several out-of-bounds accesses that can be
> triggered by a malicious (or defective) USB device, in particular:
> 
>  - The metadata array (desc_offset..desc_offset+2*pkt_count) can be out of bounds,
>    causing OOB reads and (on big-endian systems) OOB endianness flips.
>  - A packet can overlap the metadata array, causing a later OOB
>    endianness flip to corrupt data used by a cloned SKB that has already
>    been handed off into the network stack.
>  - A packet SKB can be constructed whose tail is far beyond its end,
>    causing out-of-bounds heap data to be considered part of the SKB's
>    data.
> 
> [...]

Here is the summary with links:
  - net: usb: aqc111: Fix out-of-bounds accesses in RX fixup
    https://git.kernel.org/netdev/net/c/afb8e2465275

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


