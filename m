Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 153B7438821
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 11:56:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbhJXJ5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 05:57:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:59250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229868AbhJXJ5Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 Oct 2021 05:57:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 71CAB60F11;
        Sun, 24 Oct 2021 09:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635069296;
        bh=KEefYJzo54+0puQuDIA1mfGE4sldBanUctO+6L2/obA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=m5Traf/32Bmtn+aI+hPH0F9ZInG26qb0z6ZPGoizIjb91eQldPy3INZQFBXEvUqxb
         0oCFls/rIxPdBTZ1ozH9VcVef5y9mUK1rpC5iimNeyx8eZ5S7moh3KwxKVy4uf4yVe
         Tjz3jN3Cs9HbEmXY8zW8WeC30iGwtx5mjwjBqFGaf1vk0lQyGbti/PYCUYV4JVVBKn
         dDzLH7wGTafbL9jTct7XCFJTHrVc7BVrog1jN96Ecly3xB0Z2G0ZisaqmuHfyCndxk
         ZGj1uOL4m1VDDqS1Ktxzd9Zq1g4VKQhpSKtTg80gNlorzIRRSMHdrstAOHP6LZWZfi
         qIARU9PlYf97g==
Date:   Sun, 24 Oct 2021 12:54:52 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org,
        syzbot+93d5accfaefceedf43c1@syzkaller.appspotmail.com
Subject: Re: [PATCH net-next] netdevsim: Register and unregister devlink
 traps on probe/remove device
Message-ID: <YXUtbOpjmmWr71dU@unreal>
References: <725e121f05362da4328dda08d5814211a0725dac.1635064599.git.leonro@nvidia.com>
 <YXUhyLXsc2egWNKx@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YXUhyLXsc2egWNKx@shredder>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 24, 2021 at 12:05:12PM +0300, Ido Schimmel wrote:
> On Sun, Oct 24, 2021 at 11:42:11AM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > Align netdevsim to be like all other physical devices that register and
> > unregister devlink traps during their probe and removal respectively.
> 
> No, this is incorrect. Out of the three drivers that support both reload
> and traps, both netdevsim and mlxsw unregister the traps during reload.
> Here is another report from syzkaller about mlxsw [1].

Sorry, I overlooked it.

> 
> Please revert both 22849b5ea595 ("devlink: Remove not-executed trap
> policer notifications") and 8bbeed485823 ("devlink: Remove not-executed
> trap group notifications").

However, before we rush and revert commit, can you please explain why
current behavior to reregister traps on reload is correct?

I think that you are not changing traps during reload, so traps before
reload will be the same as after reload, am I right?

Thanks
