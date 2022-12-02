Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF20E640FF4
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 22:25:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234458AbiLBVZn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 16:25:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbiLBVZm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 16:25:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8897CEDD4D;
        Fri,  2 Dec 2022 13:25:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 266AE623FE;
        Fri,  2 Dec 2022 21:25:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 77496C4347C;
        Fri,  2 Dec 2022 21:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670016340;
        bh=1/dCZws0qFEBoVjD6XV0DlnnzbPeN3KFddA2k2jt5oQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=c2AlHYtXW3yFA05dD+eyWoScuhna5G2JHrbRo9bQ849nLOJf+YtnX6mB80jP2zsdu
         U5IlN1kTTFX2+3+TAI+MkJavYv6+yZW0JPWlaQZ1hRXIXibwzY9McMCSurH1RtwkAl
         llFh6XPjWmlR06jnTj8nZoY3xx8ifFBHgrDlQapGHK7qkFwuCzSMM6pid20gjv44+S
         02Uo91Dr/4yPrKKeVGNILioazSkS6SHni43S6s2Xzn/SIgcTU+zLdF8dMFoGEScgpr
         crKPseXZHC37TI9FmJAR8W+ZHBLog2UB2oi7YzzUSCpAWKxgNV/iN46q1ibuvXW5Ow
         JxKagAITyLqoA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 58DA1E29F3F;
        Fri,  2 Dec 2022 21:25:40 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] Bluetooth: Fix not cleanup led when bt_init fails
From:   patchwork-bot+bluetooth@kernel.org
Message-Id: <167001634035.19139.3332943937893587311.git-patchwork-notify@kernel.org>
Date:   Fri, 02 Dec 2022 21:25:40 +0000
References: <20221129092556.116222-1-chenzhongjin@huawei.com>
In-Reply-To: <20221129092556.116222-1-chenzhongjin@huawei.com>
To:     Chen Zhongjin <chenzhongjin@huawei.com>
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
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

On Tue, 29 Nov 2022 17:25:56 +0800 you wrote:
> bt_init() calls bt_leds_init() to register led, but if it fails later,
> bt_leds_cleanup() is not called to unregister it.
> 
> This can cause panic if the argument "bluetooth-power" in text is freed
> and then another led_trigger_register() tries to access it:
> 
> BUG: unable to handle page fault for address: ffffffffc06d3bc0
> RIP: 0010:strcmp+0xc/0x30
>   Call Trace:
>     <TASK>
>     led_trigger_register+0x10d/0x4f0
>     led_trigger_register_simple+0x7d/0x100
>     bt_init+0x39/0xf7 [bluetooth]
>     do_one_initcall+0xd0/0x4e0
> 
> [...]

Here is the summary with links:
  - Bluetooth: Fix not cleanup led when bt_init fails
    https://git.kernel.org/bluetooth/bluetooth-next/c/63d70ae785a9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


