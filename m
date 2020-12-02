Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77F0C2CB27F
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 02:50:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727988AbgLBBtZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 20:49:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:47000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727253AbgLBBtX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Dec 2020 20:49:23 -0500
Date:   Tue, 1 Dec 2020 17:48:41 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606873723;
        bh=vegdt07ITOZXxmoKUy72H1JbUFvTeJ15thW3bajvP8s=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=KG0+OoZzj8jp1LQf78JbSBJAbP/BCP5HGXEZuKNqLRHA1WaLGeb3JrgbfYQ1b3Pqx
         7+mk03e6anjhRr3nC9pSI91ZL85T0SLJ5y2xTeXs6HjZ+xccwSqlplk5azyoNjFmye
         YHz5NnTVhwzOGXCMk+4DCLdO2SFeheEPo368Fi2Y=
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH net] geneve: pull IP header before ECN decapsulation
Message-ID: <20201201174841.73a89d70@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201201090507.4137906-1-eric.dumazet@gmail.com>
References: <20201201090507.4137906-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  1 Dec 2020 01:05:07 -0800 Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> IP_ECN_decapsulate() and IP6_ECN_decapsulate() assume
> IP header is already pulled.
> 
> geneve does not ensure this yet.
> 
> Fixing this generically in IP_ECN_decapsulate() and
> IP6_ECN_decapsulate() is not possible, since callers
> pass a pointer that might be freed by pskb_may_pull()
> 
> syzbot reported :
> 
> BUG: KMSAN: uninit-value in __INET_ECN_decapsulate include/net/inet_ecn.h:238 [inline]
> BUG: KMSAN: uninit-value in INET_ECN_decapsulate+0x345/0x1db0 include/net/inet_ecn.h:260

> 
> Fixes: 2d07dc79fe04 ("geneve: add initial netdev driver for GENEVE tunnels")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Applied, thanks!
