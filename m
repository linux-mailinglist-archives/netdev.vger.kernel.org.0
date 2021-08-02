Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 169E23DDE0D
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 18:54:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232875AbhHBQy6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 12:54:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:53100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232056AbhHBQy5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 12:54:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B4D6461102;
        Mon,  2 Aug 2021 16:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627923287;
        bh=L/sUfR22GEbbNSONQcQP8tmdTKa+xgv0SqjX+jMedGI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jgXl9t2gf9EHO1UQAobNMT6EFmoD4qiYmEF8B4WF8Jq0Q9Xr0uDGa5VrRcEPJaKH1
         2if0/AhxXCmvxQWirPochROaBKuE6EHPSBmhjf1BORJsD4GVkKHBB10t//iwHgLdrP
         HbkxtHuMiMK6iv2vONzxFwO7hX/Y1QFO7dXKs5s8d678YI8Bwqoc8D7gfV0jLTcJH5
         dUi7xQVVXiD4IWRv9Q+NfBe1AsiWmvqPoKrbuKDCTinlZ0CkW1FYNgWxIgcD/cLRht
         SqVNPM1T1F92GqoXmKPWFKgv+3kb1jDIJiHyqlvSVMFteN125FjwLEgntG7Kh9gAWd
         lh2ELR6R0nQuQ==
Date:   Mon, 2 Aug 2021 09:54:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 0/4] ethtool: runtime-resume netdev parent
 before ethtool ops
Message-ID: <20210802095446.22364041@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <b5ab0494-fd2a-8cc8-2f8f-07e1fe5e325d@gmail.com>
References: <106547ef-7a61-2064-33f5-3cc8d12adb34@gmail.com>
        <8bcca610-601d-86d0-4d74-0e5055431738@gmail.com>
        <20210802071531.34a66e68@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <b5ab0494-fd2a-8cc8-2f8f-07e1fe5e325d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2 Aug 2021 18:42:28 +0200 Heiner Kallweit wrote:
> On 02.08.2021 16:15, Jakub Kicinski wrote:
> > On Sun, 1 Aug 2021 18:25:52 +0200 Heiner Kallweit wrote:  
> >> Patchwork is showing the following warning for all patches in the series.
> >>
> >> netdev/cc_maintainers	warning	7 maintainers not CCed: ecree@solarflare.com andrew@lunn.ch magnus.karlsson@intel.com danieller@nvidia.com arnd@arndb.de irusskikh@marvell.com alexanderduyck@fb.com
> >>
> >> This seems to be a false positive, e.g. address ecree@solarflare.com
> >> doesn't exist at all in MAINTAINERS file.  
> > 
> > It gets the list from the get_maintainers script. It's one of the less
> > reliable tests, but I feel like efforts should be made primarily
> > towards improving get_maintainers rather than improving the test itself.
> >   
> When running get_maintainers.pl for any of the patches in the series
> I don't get these addresses. I run get_maintainers w/o options, maybe
> you set some special option? That's what I get when running get_maintainers:
> 
> "David S. Miller" <davem@davemloft.net> (maintainer:NETWORKING [GENERAL])
> Jakub Kicinski <kuba@kernel.org> (maintainer:NETWORKING [GENERAL])
> Stephen Rothwell <sfr@canb.auug.org.au> (commit_signer:1/2=50%,authored:1/2=50%,added_lines:3144/3159=100%)
> Heiner Kallweit <hkallweit1@gmail.com> (commit_signer:1/2=50%,authored:1/2=50%,removed_lines:3/3=100%)
> netdev@vger.kernel.org (open list:NETWORKING [GENERAL])
> linux-kernel@vger.kernel.org (open list)

Mm. Maybe your system doesn't have some perl module? Not sure what it
may be. With tip of net-next/master:

$ ./scripts/get_maintainer.pl /tmp/te/0002-ethtool-move-implementation-of-ethnl_ops_begin-compl.patch
"David S. Miller" <davem@davemloft.net> (maintainer:NETWORKING [GENERAL],commit_signer:12/16=75%,commit_signer:15/18=83%)
Jakub Kicinski <kuba@kernel.org> (maintainer:NETWORKING [GENERAL],commit_signer:11/16=69%,authored:9/16=56%,added_lines:127/198=64%,removed_lines:41/57=72%,commit_signer:14/18=78%,authored:11/18=61%,added_lines:74/84=88%,removed_lines:35/52=67%)
Heiner Kallweit <hkallweit1@gmail.com> (commit_signer:3/16=19%,authored:3/16=19%,added_lines:46/198=23%,removed_lines:13/57=23%,authored:1/18=6%,removed_lines:13/52=25%)
Fernando Fernandez Mancera <ffmancera@riseup.net> (commit_signer:1/16=6%,authored:1/16=6%)
Vladyslav Tarasiuk <vladyslavt@nvidia.com> (commit_signer:1/16=6%,added_lines:11/198=6%,commit_signer:1/18=6%)
Yangbo Lu <yangbo.lu@nxp.com> (authored:1/16=6%,added_lines:10/198=5%,authored:1/18=6%)
Johannes Berg <johannes.berg@intel.com> (authored:1/16=6%)
Zheng Yongjun <zhengyongjun3@huawei.com> (commit_signer:1/18=6%)
Andrew Lunn <andrew@lunn.ch> (commit_signer:1/18=6%)
Danielle Ratson <danieller@nvidia.com> (authored:1/18=6%)
Ido Schimmel <idosch@nvidia.com> (authored:1/18=6%)
netdev@vger.kernel.org (open list:NETWORKING [GENERAL])
linux-kernel@vger.kernel.org (open list)
