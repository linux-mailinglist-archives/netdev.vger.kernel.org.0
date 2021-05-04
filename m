Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B45E037306C
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 21:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232102AbhEDTLG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 15:11:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:37644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231777AbhEDTLF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 May 2021 15:11:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 35D34610E9;
        Tue,  4 May 2021 19:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620155410;
        bh=mvcICgCpSJJpdePB6+Sc/K+HkLVUN9fo5vLs4TITIK0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sZH+j8j+WrDkdM1BOt/cwYd6BWv/28aPXTpKtJlvPTBYZsEJcwzQx1AcJ4qWy88W2
         Aqh9aszMIihOp4dC1+fJyxkbJtXj5Edwr+bJSUGb+Yf3HaxnZMBht6zJ+Vu/4fb56S
         bx7eYOp/eTsQOwo67vzoUqp3xSDlL0LSBrKWEgBqV7w2LIHvQCs81NjT7lK29QJoc5
         5i3zsqRDS1KojoTrYx0EmeOuAQ9rBF0EsD4ztOU6V0ZkfeLwyuc70aHEoLcEnBVHmX
         OF9wgoT1IZXmzmekFfoEudWSqAx9yukQcEpkKSDjOsTHqFMlI+ZcCGMhKLOlj2z0Bk
         0n6mFwBKas/eA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 25E2560A22;
        Tue,  4 May 2021 19:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net/nfc: fix use-after-free llcp_sock_bind/connect
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162015541015.23495.4578937039249917498.git-patchwork-notify@kernel.org>
Date:   Tue, 04 May 2021 19:10:10 +0000
References: <20210504071646.28665-1-orcohen@paloaltonetworks.com>
In-Reply-To: <20210504071646.28665-1-orcohen@paloaltonetworks.com>
To:     Or Cohen <orcohen@paloaltonetworks.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        nixiaoming@huawei.com, matthieu.baerts@tessares.net,
        mkl@pengutronix.de, nmarkus@paloaltonetworks.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue,  4 May 2021 10:16:46 +0300 you wrote:
> Commits 8a4cd82d ("nfc: fix refcount leak in llcp_sock_connect()")
> and c33b1cc62 ("nfc: fix refcount leak in llcp_sock_bind()")
> fixed a refcount leak bug in bind/connect but introduced a
> use-after-free if the same local is assigned to 2 different sockets.
> 
> This can be triggered by the following simple program:
>     int sock1 = socket( AF_NFC, SOCK_STREAM, NFC_SOCKPROTO_LLCP );
>     int sock2 = socket( AF_NFC, SOCK_STREAM, NFC_SOCKPROTO_LLCP );
>     memset( &addr, 0, sizeof(struct sockaddr_nfc_llcp) );
>     addr.sa_family = AF_NFC;
>     addr.nfc_protocol = NFC_PROTO_NFC_DEP;
>     bind( sock1, (struct sockaddr*) &addr, sizeof(struct sockaddr_nfc_llcp) )
>     bind( sock2, (struct sockaddr*) &addr, sizeof(struct sockaddr_nfc_llcp) )
>     close(sock1);
>     close(sock2);
> 
> [...]

Here is the summary with links:
  - net/nfc: fix use-after-free llcp_sock_bind/connect
    https://git.kernel.org/netdev/net/c/c61760e6940d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


