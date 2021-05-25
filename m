Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6BA939076D
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 19:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233770AbhEYRXa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 13:23:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:56024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230362AbhEYRX1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 May 2021 13:23:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 714C961042;
        Tue, 25 May 2021 17:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621963317;
        bh=35p1XpMZd0i0fFy5Zgpc/Uhj0KoRWRO3Ung62ONTQR0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZBCO06/V7/UA+yEi9E2XXTPsuHnDGLRxxngSMQlpc9jKPgXAdl64vB4T8zmLAI3tX
         RldGbKMuLdm8kAHUzjEpg8BtPzyfk1AioWPvP0x9g9xGg6KkaNBYY4guyC0w49u3xI
         081uRsV7EIo7P6FEx/cFtWmaKKjCfCIoO+/U3jxKnyv+xlizm4j3jqXzvEZaNaTWYN
         RewVKzaurNsqfMacFy9gk/X6XI2y/N7DO4akXaKaHp/dgHa4xKiMWg//jjgvcrL/Qh
         NQ9IznnHIqq9CcjOXf9g4j43eK2zgs04qEBBnbo9qF6M1qIo7uKPs3HV/ZG7xIZKHe
         eR2yJi8ngKDEg==
Date:   Tue, 25 May 2021 10:21:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Aviad Yehezkel <aviadye@nvidia.com>,
        "Tariq Toukan" <tariqt@nvidia.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net 2/2] net/tls: Fix use-after-free after the TLS
 device goes down and up
Message-ID: <20210525102156.2b27205f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <578ddba5-f23a-0294-c6f3-d7801de0cda3@nvidia.com>
References: <20210524121220.1577321-1-maximmi@nvidia.com>
        <20210524121220.1577321-3-maximmi@nvidia.com>
        <20210524091528.3b53c1ce@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <578ddba5-f23a-0294-c6f3-d7801de0cda3@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 May 2021 11:52:31 +0300 Maxim Mikityanskiy wrote:
> > Can we have the Rx resync take the device_offload_lock for read instead?
> > Like Tx already does?  
> 
> I believe you previously made this attempt in commit 38030d7cb779 
> ("net/tls: avoid NULL-deref on resync during device removal"), and this 
> approach turned out to be problematic, as explained in commit 
> e52972c11d6b ("net/tls: replace the sleeping lock around RX resync with 
> a bit lock"): "RX resync may get called from soft IRQ, so we can't use 
> the rwsem".

If only my memory wasn't this shit.. :) Let me take a look at the patch
again.
