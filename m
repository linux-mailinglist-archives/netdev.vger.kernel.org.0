Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 741D35EB04B
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 20:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231235AbiIZSm2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 14:42:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230130AbiIZSlj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 14:41:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C57333AE48;
        Mon, 26 Sep 2022 11:40:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3D2D6B80D66;
        Mon, 26 Sep 2022 18:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DAAD0C433D7;
        Mon, 26 Sep 2022 18:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664217614;
        bh=kvphuS7uCXH3SGjBR5lP51duYkMWgKELt0OtRVCHwyA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QZ99E4sEqaHLx9CCH1pqw4Jt4AHqJcxA04dMLpSLH7yxWRiM0iqo0NrPxUYMOj4do
         Zd5tMYqj1De0EESgKzcdmS2chYYI2PjhJzddHvWeiqJitjZxHQIZJdXyGr/BsSofOK
         SIrYfJ9gqODLK0JKN9i9Rls8/LE8o68KWpaZv0ML3ucoiEqcn5pZnBE7ivpM2qhTEJ
         8GnFTXzph8R9GirpUUGxY2pU2kv1vLtW49KIcxuvTQwo8QLBomK2Sm18iGrHmpci0w
         n4rxBOdWi/lxg6WwBTUpisHSa3+xA/i74xj7lSIS3ArhOb1DoMC/pmbBNbp9aayI+i
         OM26UO/Pfu1VA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BDD8CC070C8;
        Mon, 26 Sep 2022 18:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] usbnet: Fix memory leak in usbnet_disconnect()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166421761477.17810.9199629462308924051.git-patchwork-notify@kernel.org>
Date:   Mon, 26 Sep 2022 18:40:14 +0000
References: <20220923042551.2745-1-yepeilin.cs@gmail.com>
In-Reply-To: <20220923042551.2745-1-yepeilin.cs@gmail.com>
To:     Peilin Ye <yepeilin.cs@gmail.com>
Cc:     oneukum@suse.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, peilin.ye@bytedance.com,
        gregkh@linuxfoundation.org, ming.lei@canonical.com,
        cong.wang@bytedance.com, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 22 Sep 2022 21:25:51 -0700 you wrote:
> From: Peilin Ye <peilin.ye@bytedance.com>
> 
> Currently usbnet_disconnect() unanchors and frees all deferred URBs
> using usb_scuttle_anchored_urbs(), which does not free urb->context,
> causing a memory leak as reported by syzbot.
> 
> Use a usb_get_from_anchor() while loop instead, similar to what we did
> in commit 19cfe912c37b ("Bluetooth: btusb: Fix memory leak in
> play_deferred").  Also free urb->sg.
> 
> [...]

Here is the summary with links:
  - [net] usbnet: Fix memory leak in usbnet_disconnect()
    https://git.kernel.org/netdev/net/c/a43206156263

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


