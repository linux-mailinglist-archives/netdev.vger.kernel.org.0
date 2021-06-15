Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B3E33A886F
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 20:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231651AbhFOSWX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 14:22:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:39170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231447AbhFOSWO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Jun 2021 14:22:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0A622613DB;
        Tue, 15 Jun 2021 18:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623781210;
        bh=HRRaznNGBoxwvKxvfU0Nvk1ndcMGA+i5SIfOCPR0wjU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PKYEIJ9RyNv9XfJQoQJyuO5fWEwzZtJ+gLku9UoOkcUaWS7G+6gP9YLecwLdQtYb2
         uMgHoKkkIlfbEgnVDXOGFlg71/7Du7PHVMa8KiDiLW46n3RPYBMOxSZx2EN7ph0Ysc
         UU0nKaZTLiNNMDKEOkz7HPlnNlmxQziQApQP3ylpki5CMTOu3qWnYTXj+oVEx+puB3
         DQmcmyArlItbvWvY10yJ/o1/01r1XyxqxNx6bAQF4tMLvx9s+yzL8S9ywHviab0mah
         OXm506Atfv2AaiCvQMj5HXB+UWJkYUigwt+RTRV23RtAaklW66Pj145Aqnk9LEKs9C
         rLlo3dzeQ7wCQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 02110609F5;
        Tue, 15 Jun 2021 18:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next v3] netlabel: Fix memory leak in netlbl_mgmt_add_common
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162378121000.26290.15147502138863217161.git-patchwork-notify@kernel.org>
Date:   Tue, 15 Jun 2021 18:20:10 +0000
References: <20210615021444.2306687-1-liushixin2@huawei.com>
In-Reply-To: <20210615021444.2306687-1-liushixin2@huawei.com>
To:     Liu Shixin <liushixin2@huawei.com>
Cc:     paul@paul-moore.com, mudongliangabcd@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 15 Jun 2021 10:14:44 +0800 you wrote:
> Hulk Robot reported memory leak in netlbl_mgmt_add_common.
> The problem is non-freed map in case of netlbl_domhsh_add() failed.
> 
> BUG: memory leak
> unreferenced object 0xffff888100ab7080 (size 96):
>   comm "syz-executor537", pid 360, jiffies 4294862456 (age 22.678s)
>   hex dump (first 32 bytes):
>     05 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     fe 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01  ................
>   backtrace:
>     [<0000000008b40026>] netlbl_mgmt_add_common.isra.0+0xb2a/0x1b40
>     [<000000003be10950>] netlbl_mgmt_add+0x271/0x3c0
>     [<00000000c70487ed>] genl_family_rcv_msg_doit.isra.0+0x20e/0x320
>     [<000000001f2ff614>] genl_rcv_msg+0x2bf/0x4f0
>     [<0000000089045792>] netlink_rcv_skb+0x134/0x3d0
>     [<0000000020e96fdd>] genl_rcv+0x24/0x40
>     [<0000000042810c66>] netlink_unicast+0x4a0/0x6a0
>     [<000000002e1659f0>] netlink_sendmsg+0x789/0xc70
>     [<000000006e43415f>] sock_sendmsg+0x139/0x170
>     [<00000000680a73d7>] ____sys_sendmsg+0x658/0x7d0
>     [<0000000065cbb8af>] ___sys_sendmsg+0xf8/0x170
>     [<0000000019932b6c>] __sys_sendmsg+0xd3/0x190
>     [<00000000643ac172>] do_syscall_64+0x37/0x90
>     [<000000009b79d6dc>] entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> [...]

Here is the summary with links:
  - [-next,v3] netlabel: Fix memory leak in netlbl_mgmt_add_common
    https://git.kernel.org/netdev/net-next/c/b8f6b0522c29

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


