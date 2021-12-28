Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23669480932
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 13:50:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231451AbhL1MuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 07:50:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231132AbhL1MuL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Dec 2021 07:50:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15A8EC061574
        for <netdev@vger.kernel.org>; Tue, 28 Dec 2021 04:50:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3ACD611D1
        for <netdev@vger.kernel.org>; Tue, 28 Dec 2021 12:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E15B0C36AE7;
        Tue, 28 Dec 2021 12:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640695809;
        bh=tqqeXrrUblnDPnKc5DDT331WoY/vGyUkcu2GJm16f3U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=vRvVnx55/7m6l2EeGR6DJagUJgnvi4xGwxiMRTsL91Qx+9TOTTj4GdveRRlPI8vDo
         fRmbOUF53nnFWsLNGz9eREl69QVgEPr36zyZdYBskw/ZBs7pr5IVoV0VFi1o8swPkF
         E1FoGKfKzLaVqNxZMFqNW5a+jrA/kUtVsCoE+DPcZ9CAkbVy6RbFmIhfD3dqgZpeHz
         BqtOLz23msgHaEv6OVhzHc7lZvGFKrlFxcblsJeRyv1BvRzE1jSoZy+ny6+PVbVkcs
         K4soIrBQhIqeBxogEVmJwfXiI1nju22sdMpLsXUHvQaa/mPv+S4CT76DMI77q2ouwv
         GO5l1FM6jU6gQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C900EC395E8;
        Tue, 28 Dec 2021 12:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] NFC: st21nfca: Fix memory leak in device probe and remove
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164069580981.6060.173027739512573206.git-patchwork-notify@kernel.org>
Date:   Tue, 28 Dec 2021 12:50:09 +0000
References: <20211228124811.3122182-1-weiyongjun1@huawei.com>
In-Reply-To: <20211228124811.3122182-1-weiyongjun1@huawei.com>
To:     Wei Yongjun <weiyongjun1@huawei.com>
Cc:     krzysztof.kozlowski@canonical.com, davem@davemloft.net,
        kuba@kernel.org, christophe.ricard@gmail.com,
        sameo@linux.intel.com, netdev@vger.kernel.org, hulkci@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 28 Dec 2021 12:48:11 +0000 you wrote:
> 'phy->pending_skb' is alloced when device probe, but forgot to free
> in the error handling path and remove path, this cause memory leak
> as follows:
> 
> unreferenced object 0xffff88800bc06800 (size 512):
>   comm "8", pid 11775, jiffies 4295159829 (age 9.032s)
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<00000000d66c09ce>] __kmalloc_node_track_caller+0x1ed/0x450
>     [<00000000c93382b3>] kmalloc_reserve+0x37/0xd0
>     [<000000005fea522c>] __alloc_skb+0x124/0x380
>     [<0000000019f29f9a>] st21nfca_hci_i2c_probe+0x170/0x8f2
> 
> [...]

Here is the summary with links:
  - [net] NFC: st21nfca: Fix memory leak in device probe and remove
    https://git.kernel.org/netdev/net/c/1b9dadba5022

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


