Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60C3F3631C7
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 20:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236796AbhDQSOU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Apr 2021 14:14:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:54474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236759AbhDQSOT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Apr 2021 14:14:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C892A611C2;
        Sat, 17 Apr 2021 18:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618683233;
        bh=28DZOWoZnhOsBSjCaTzC1g0irrUuYNChX3IwZiaKmHE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dap2kghP8N1Zc2DnG3dZJDBwHKDoDPxPYQfC8P/6bQ3S9GCfXH6NgLHrzLHNoSbeL
         ksDJ7X/uJ0/PwwKbHJMHPXtYmtG4gfIFLpTPaiYRbOyvOHVywq+LC/nIPo4hrjdg1R
         3oaGG/a7EmRb57kFG2dp6iuZHqHm8ibUDzmNob7jvzqN71q8yLZ2fXYDB2No5sv2rM
         RQLryvXGHvEE7StZzdw1woHXXXC7FHAKNTU5K9Hqon7H2dsaEkVzniIEYcL+Ck+aZC
         viKEyT7FkuPwPOJgc8B8R8ysg0GDiXrYr1dok3Jv8sVfX27i/u0cS7UEUQ/HzdEGdQ
         An8p7BV9uD1/A==
Date:   Sat, 17 Apr 2021 11:13:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, andrew@lunn.ch,
        mkubecek@suse.cz, idosch@nvidia.com, saeedm@nvidia.com,
        michael.chan@broadcom.com
Subject: Re: [PATCH net-next v2 3/9] ethtool: add a new command for reading
 standard stats
Message-ID: <20210417111351.27c54b99@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210417105742.76bb2461@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210416192745.2851044-1-kuba@kernel.org>
        <20210416192745.2851044-4-kuba@kernel.org>
        <YHsXnzqVDjL9Q0Bz@shredder.lan>
        <20210417105742.76bb2461@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 17 Apr 2021 10:57:42 -0700 Jakub Kicinski wrote:
> > I tried to understand how you add new groups without user space
> > changes and I think this statement is not entirely accurate.
> > 
> > At minimum, user space needs to know the names of these groups, but
> > currently there is no way to query the information, so it's added to
> > ethtool's help message:
> > 
> > ethtool [ FLAGS ] -S|--statistics DEVNAME       Show adapter statistics       
> >        [ --groups [eth-phy] [eth-mac] [eth-ctrl] [rmon] ]  
> 
> Um, yes and now. The only places the user space puts those names 
> is the help message and man page.
> 
> Thru the magic of bitsets it doesn't actually interpret them, so
> with old user space you can still query a new group, it will just 
> not show up in "ethtool -h".
> 
> Is that what you're saying?

FWIW ethnl_parse_bit() -> ETHTOOL_A_BITSET_BIT_NAME
User space can also use raw flags like --groups 0xf but that's perhaps
too spartan for serious use.
