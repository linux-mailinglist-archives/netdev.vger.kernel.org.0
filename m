Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D9E65FF99F
	for <lists+netdev@lfdr.de>; Sat, 15 Oct 2022 12:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbiJOKUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Oct 2022 06:20:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbiJOKUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Oct 2022 06:20:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B3862AC4A;
        Sat, 15 Oct 2022 03:20:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD29460C07;
        Sat, 15 Oct 2022 10:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 26E86C43142;
        Sat, 15 Oct 2022 10:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665829216;
        bh=bsjIMKUlrzDaW7XKvCitE02vrcY7t/uH3nEyGad8D08=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=El3X02IiQduy87eLnqEBA45WqzpWWylNnvBJvch7Zq67hTtbhwbCb/Bq5Wnla87DY
         0X66r7mu9Mt2UwjShESr7Jbikt/h62gdX7E3DcrFpzO+uY310Rxi5/I7L51uUwa6GY
         JsqSA9ZIMw6QrpOF56GOxEa8pnsLVRYZ6CjDIoTUkORrWsZshaOK7lPUs5t8bqyfsB
         v+67lngkv/e0gPMMXpu+/W4wH0BHKYGfMNdfGn9P7QGg9dAwcdeCG2hM/hcddElGXR
         5U/BXEoNgybK9qbWdJOipM9dbRw00p8V5yMu0skb5ey6RhytcgOBRuMbKDYSVf5F1N
         OCnf6Po47Vk9Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 08B32E52525;
        Sat, 15 Oct 2022 10:20:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3] net: hv_netvsc: Fix a warning triggered by memcpy in
 rndis_filter
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166582921603.1299.10791611158258198610.git-patchwork-notify@kernel.org>
Date:   Sat, 15 Oct 2022 10:20:16 +0000
References: <20221014024503.4533-1-cbulinaru@gmail.com>
In-Reply-To: <20221014024503.4533-1-cbulinaru@gmail.com>
To:     Cezar Bulinaru <cbulinaru@gmail.com>
Cc:     pabeni@redhat.com, kys@microsoft.com, haiyangz@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org, mikelley@microsoft.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 13 Oct 2022 22:45:03 -0400 you wrote:
> memcpy: detected field-spanning write (size 168) of single field "(void *)&request->response_msg + (sizeof(struct rndis_message) - sizeof(union rndis_message_container)) + sizeof(*req_id)" at drivers/net/hyperv/rndis_filter.c:338 (size 40)
> RSP: 0018:ffffc90000144de0 EFLAGS: 00010282
> RAX: 0000000000000000 RBX: ffff8881766b4000 RCX: 0000000000000000
> RDX: 0000000000000102 RSI: 0000000000009ffb RDI: 00000000ffffffff
> RBP: ffffc90000144e38 R08: 0000000000000000 R09: 00000000ffffdfff
> R10: ffffc90000144c48 R11: ffffffff82f56ac8 R12: ffff8881766b403c
> R13: 00000000000000a8 R14: ffff888100b75000 R15: ffff888179301d00
> FS:  0000000000000000(0000) GS:ffff8884d6280000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000055f8b024c418 CR3: 0000000176548001 CR4: 00000000003706e0
> Call Trace:
>  <IRQ>
>  ? _raw_spin_unlock_irqrestore+0x27/0x50
>  netvsc_poll+0x556/0x940 [hv_netvsc]
>  __napi_poll+0x2e/0x170
>  net_rx_action+0x299/0x2f0
>  __do_softirq+0xed/0x2ef
>  __irq_exit_rcu+0x9f/0x110
>  irq_exit_rcu+0xe/0x20
>  sysvec_hyperv_callback+0xb0/0xd0
>  </IRQ>
>  <TASK>
>  asm_sysvec_hyperv_callback+0x1b/0x20
> RIP: 0010:native_safe_halt+0xb/0x10
> 
> [...]

Here is the summary with links:
  - [v3] net: hv_netvsc: Fix a warning triggered by memcpy in rndis_filter
    https://git.kernel.org/netdev/net/c/017e42540639

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


