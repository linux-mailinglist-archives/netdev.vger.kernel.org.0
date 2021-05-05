Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE1F9373479
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 06:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231621AbhEEEvO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 00:51:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:56718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229895AbhEEEvL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 00:51:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 55B21611CB;
        Wed,  5 May 2021 04:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620190216;
        bh=8gJ5NuHokJGXy8q2lqyqoBhaOKNwhI526x5V7AnBm+0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sZPf98BbIg+wFutitasOSHo7qr4dHiqtYrTPCKFo6vm/ov9rsVr2kcCVZUm1soPJE
         iIJgEvh+9jjSzB4h3WqQ4YF6likIPXa8F9mlT6y4HZq/vOxBVowVKiQIJwLz4kbHo7
         KSZ7l5rGW7pGH2kElopEd6oaGDzwvwbwUJhC+3tXbDglncM/AfbtVmL9XsHQxaL6hb
         r0A35wcUqykAnILCL9uV9RfGIVc5R/qB2fOgaickOrd7MS7Nimrg7B+Floc3sFOBYv
         dMnXD6DIBtHPAOQxFECA5xbbsygiXpyrWq83i6d81K+APyiy+kN8WpiFegO9QnOzl8
         Ba9OVEjkxLusg==
Date:   Wed, 5 May 2021 07:50:12 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Or Cohen <orcohen@paloaltonetworks.com>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, nixiaoming@huawei.com,
        matthieu.baerts@tessares.net, mkl@pengutronix.de,
        nmarkus@paloaltonetworks.com
Subject: Re: [PATCH] net/nfc: fix use-after-free llcp_sock_bind/connect
Message-ID: <YJIkBH/9kb6SMRh/@unreal>
References: <20210504071646.28665-1-orcohen@paloaltonetworks.com>
 <162015541015.23495.4578937039249917498.git-patchwork-notify@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162015541015.23495.4578937039249917498.git-patchwork-notify@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 04, 2021 at 07:10:10PM +0000, patchwork-bot+netdevbpf@kernel.org wrote:
> Hello:
> 
> This patch was applied to netdev/net.git (refs/heads/master):
> 
> On Tue,  4 May 2021 10:16:46 +0300 you wrote:
> > Commits 8a4cd82d ("nfc: fix refcount leak in llcp_sock_connect()")
> > and c33b1cc62 ("nfc: fix refcount leak in llcp_sock_bind()")
> > fixed a refcount leak bug in bind/connect but introduced a
> > use-after-free if the same local is assigned to 2 different sockets.
> > 
> > This can be triggered by the following simple program:
> >     int sock1 = socket( AF_NFC, SOCK_STREAM, NFC_SOCKPROTO_LLCP );
> >     int sock2 = socket( AF_NFC, SOCK_STREAM, NFC_SOCKPROTO_LLCP );
> >     memset( &addr, 0, sizeof(struct sockaddr_nfc_llcp) );
> >     addr.sa_family = AF_NFC;
> >     addr.nfc_protocol = NFC_PROTO_NFC_DEP;
> >     bind( sock1, (struct sockaddr*) &addr, sizeof(struct sockaddr_nfc_llcp) )
> >     bind( sock2, (struct sockaddr*) &addr, sizeof(struct sockaddr_nfc_llcp) )
> >     close(sock1);
> >     close(sock2);
> > 
> > [...]
> 
> Here is the summary with links:
>   - net/nfc: fix use-after-free llcp_sock_bind/connect
>     https://git.kernel.org/netdev/net/c/c61760e6940d

Dave,

Can you please share your thoughts how this patch can be correct?
https://lore.kernel.org/netdev/YJIjN6MTRdQ7Bvcp@unreal/T/#m1e67ae6c2658312a134f65819c5ad92511f207c1

It is also under review, so unclear why it was merged.

Thanks

> 
> You are awesome, thank you!
> --
> Deet-doot-dot, I am a bot.
> https://korg.docs.kernel.org/patchwork/pwbot.html
> 
> 
