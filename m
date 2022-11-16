Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D601062CCDE
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 22:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234268AbiKPVkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 16:40:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234016AbiKPVkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 16:40:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA87A64D8;
        Wed, 16 Nov 2022 13:40:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 76FD261FE0;
        Wed, 16 Nov 2022 21:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D9B23C433D7;
        Wed, 16 Nov 2022 21:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668634815;
        bh=kj8ADXYtV7/FQq+a3FDgaZPiX27KXWwGGYAGWoz10JI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JQbSArbX7a/8qfmG0JDjqgbuRpQGDufdczmQ7pgvTEsgly4Ln5aVP/P7xDcADT0ws
         G1HxezspSE4wvnlGXkkdDQFpSaJtVuFfUa6aa1u7Suncb0BvjTxQZFz1r81PydQU74
         Btd6ykBHl4yfUw5uA/wiIjqgInZ7iYQP8AhwRHXPShmw+9LT/+S3b8/PQ9ip1i7KaA
         SxBuv73KZGJ7e3uzgiooPH9tv3B5zvGs4OfPMgzfNkMWvyqAkYGp2F6Y1D/CPZjzcG
         NZsv51HGZL+GYwcH7oQTeF+KW0BPwhiL+4loRT/y5+Uo8fgAlQ2+ORV46YHjEZzu/O
         BO8c2zQhiXy2w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BE447E270D5;
        Wed, 16 Nov 2022 21:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] Bluetooth: silence a dmesg error message in hci_request.c
From:   patchwork-bot+bluetooth@kernel.org
Message-Id: <166863481577.13601.1517745268400800639.git-patchwork-notify@kernel.org>
Date:   Wed, 16 Nov 2022 21:40:15 +0000
References: <20221116202856.55847-1-mat.jonczyk@o2.pl>
In-Reply-To: <20221116202856.55847-1-mat.jonczyk@o2.pl>
To:     =?utf-8?b?TWF0ZXVzeiBKb8WEY3p5ayA8bWF0LmpvbmN6eWtAbzIucGw+?=@ci.codeaurora.org
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, brian.gix@intel.com,
        luiz.von.dentz@intel.com, marcel@holtmann.org,
        johan.hedberg@gmail.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bluetooth/bluetooth-next.git (master)
by Luiz Augusto von Dentz <luiz.von.dentz@intel.com>:

On Wed, 16 Nov 2022 21:28:56 +0100 you wrote:
> On kernel 6.1-rcX, I have been getting the following dmesg error message
> on every boot, resume from suspend and rfkill unblock of the Bluetooth
> device:
> 
> 	Bluetooth: hci0: HCI_REQ-0xfcf0
> 
> After some investigation, it turned out to be caused by
> commit dd50a864ffae ("Bluetooth: Delete unreferenced hci_request code")
> which modified hci_req_add() in net/bluetooth/hci_request.c to always
> print an error message when it is executed. In my case, the function was
> executed by msft_set_filter_enable() in net/bluetooth/msft.c, which
> provides support for Microsoft vendor opcodes.
> 
> [...]

Here is the summary with links:
  - Bluetooth: silence a dmesg error message in hci_request.c
    https://git.kernel.org/bluetooth/bluetooth-next/c/c3fd63f7fe5a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


