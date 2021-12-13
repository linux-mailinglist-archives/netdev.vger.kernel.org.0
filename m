Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7157F472FF4
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 16:00:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239833AbhLMPAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 10:00:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239781AbhLMPAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 10:00:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D19CDC06173F;
        Mon, 13 Dec 2021 07:00:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1B880B8113C;
        Mon, 13 Dec 2021 15:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CDA75C34605;
        Mon, 13 Dec 2021 15:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639407610;
        bh=4J06igrHksM70WNtIIybpq6toY7JZaspv+TRIHiLf6w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qNLjkXXtkQeaJl3uSlSuApOzg5qqUxzBHxVXKsIjEMPKN5ngo6Pil7QePCo+ngxcq
         Kl12ZbtPyx29oW8sgChmpSAXK9xFhwvd7lAInRfNbgZRZleiRvj4cvepSYMAxRudjM
         5JXm1IjF4AlLCc/I2KW9rZw+lZNbkMEowcWFfKS/cKBpprIONmOaX34zJCSNH0BfZZ
         0tZIyr1Nu6LS7F2js6W1YXPtCnLTrnYf4RTDvzIKYUr7vzOj2/G2BmAeHFS5bgVFs9
         3WRBWH9kbLLefS5Jrsuh156GVIVp+IRJUjPnOMWuQ5RuubfWpr1tcnLZjCTx0oPIj9
         moA9WUzsu7Zzg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BD53B609CD;
        Mon, 13 Dec 2021 15:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: bonding: debug: avoid printing debug logs when bond is
 not notifying peers
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163940761077.26947.18066231032018487872.git-patchwork-notify@kernel.org>
Date:   Mon, 13 Dec 2021 15:00:10 +0000
References: <20211213054709.158550-1-suresh2514@gmail.com>
In-Reply-To: <20211213054709.158550-1-suresh2514@gmail.com>
To:     Suresh Kumar <surkumar@redhat.com>
Cc:     j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, suresh2514@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 13 Dec 2021 11:17:09 +0530 you wrote:
> Currently "bond_should_notify_peers: slave ..." messages are printed whenever
> "bond_should_notify_peers" function is called.
> 
> +++
> Dec 12 12:33:26 node1 kernel: bond0: bond_should_notify_peers: slave enp0s25
> Dec 12 12:33:26 node1 kernel: bond0: bond_should_notify_peers: slave enp0s25
> Dec 12 12:33:26 node1 kernel: bond0: bond_should_notify_peers: slave enp0s25
> Dec 12 12:33:26 node1 kernel: bond0: (slave enp0s25): Received LACPDU on port 1
> Dec 12 12:33:26 node1 kernel: bond0: (slave enp0s25): Rx Machine: Port=1, Last State=6, Curr State=6
> Dec 12 12:33:26 node1 kernel: bond0: (slave enp0s25): partner sync=1
> Dec 12 12:33:26 node1 kernel: bond0: bond_should_notify_peers: slave enp0s25
> Dec 12 12:33:26 node1 kernel: bond0: bond_should_notify_peers: slave enp0s25
> Dec 12 12:33:26 node1 kernel: bond0: bond_should_notify_peers: slave enp0s25
> ...
> Dec 12 12:33:30 node1 kernel: bond0: bond_should_notify_peers: slave enp0s25
> Dec 12 12:33:30 node1 kernel: bond0: bond_should_notify_peers: slave enp0s25
> Dec 12 12:33:30 node1 kernel: bond0: (slave enp4s3): Received LACPDU on port 2
> Dec 12 12:33:30 node1 kernel: bond0: (slave enp4s3): Rx Machine: Port=2, Last State=6, Curr State=6
> Dec 12 12:33:30 node1 kernel: bond0: (slave enp4s3): partner sync=1
> Dec 12 12:33:30 node1 kernel: bond0: bond_should_notify_peers: slave enp0s25
> Dec 12 12:33:30 node1 kernel: bond0: bond_should_notify_peers: slave enp0s25
> Dec 12 12:33:30 node1 kernel: bond0: bond_should_notify_peers: slave enp0s25
> +++
> 
> [...]

Here is the summary with links:
  - net: bonding: debug: avoid printing debug logs when bond is not notifying peers
    https://git.kernel.org/netdev/net-next/c/fee32de284ac

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


