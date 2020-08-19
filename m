Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C550524A3DD
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 18:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbgHSQSr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 12:18:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:44094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725275AbgHSQSq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Aug 2020 12:18:46 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A4892078D;
        Wed, 19 Aug 2020 16:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597853926;
        bh=UM/vkOiUGYTwlF0gUq/HCYB45aeweW+a2Yop53G5kjY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PY5fGyeHte7sfdei7FsW2ESW+2Izu/2HNiFpxeOlcR4be/r5waLqe92PBM/YeO7/M
         /lc2L2OWfurpBAWGydtRrX4NHobsj7RjtY+sLXNHDZsPmpsZEeeibCLAQ+7E4+3GJs
         xklKk7ghs3Q8zQsKDDVHnx74XLvrqKK2coaMQb6M=
Date:   Wed, 19 Aug 2020 09:18:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     David Ahern <dsahern@gmail.com>, Ido Schimmel <idosch@idosch.org>,
        netdev@vger.kernel.org, davem@davemloft.net, jiri@nvidia.com,
        amcohen@nvidia.com, danieller@nvidia.com, mlxsw@nvidia.com,
        roopa@nvidia.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        tariqt@nvidia.com, ayal@nvidia.com, mkubecek@suse.cz,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next 0/6] devlink: Add device metric support
Message-ID: <20200819091843.33ddd113@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <55e40430-a52f-f77b-0d1e-ef79386a0a53@gmail.com>
References: <20200817125059.193242-1-idosch@idosch.org>
        <20200818172419.5b86801b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <58a0356d-3e15-f805-ae52-dc44f265661d@gmail.com>
        <20200818203501.5c51e61a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <55e40430-a52f-f77b-0d1e-ef79386a0a53@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Aug 2020 21:30:16 -0700 Florian Fainelli wrote:
> >>> I spend way too much time patrolling ethtool -S outputs already.  
> >>
> >> But that's the nature of detailed stats which are often essential to
> >> ensuring the system is operating as expected or debugging some problem.
> >> Commonality is certainly desired in names when relevant to be able to
> >> build tooling around the stats.  
> > 
> > There are stats which are clearly detailed and device specific,
> > but what ends up happening is that people expose very much not
> > implementation specific stats through the free form interfaces,
> > because it's the easiest.
> > 
> > And users are left picking up the pieces, having to ask vendors what
> > each stat means, and trying to create abstractions in their user space
> > glue.  
> 
> Should we require vendors to either provide a Documentation/ entry for 
> each statistics they have (and be guaranteed that it will be outdated 
> unless someone notices), or would you rather have the statistics 
> description be part of the devlink interface itself? Should we define 
> namespaces such that standard metrics should be under the standard 
> namespace and the vendor standard is the wild west?

I'm trying to find a solution which will not require a policeman to
constantly monitor the compliance. Please see my effort to ensure
drivers document and use the same ethtool -S stats in the TLS offload
implementations. I've been trying to improve this situation for a long
time, and it's getting old.

Please focus on the stats this set adds, instead of fantasizing of what
could be. These are absolutely not implementation specific!

> > If I have to download vendor documentation and tooling, or adapt my own
> > scripts for every new vendor, I could have as well downloaded an SDK.  
> 
> Are not you being a bit over dramatic here with your example? 

I hope not. It's very hard/impossible today to run a fleet of Linux
machines without resorting to vendor tooling.

> At least  you can run the same command to obtain the stats regardless
> of the driver and vendor, so from that perspective Linux continues to
> be the abstraction and that is not broken.

Format of the data is no abstraction.
