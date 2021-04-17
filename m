Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB4136322E
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 22:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237014AbhDQULI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Apr 2021 16:11:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:41904 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236491AbhDQULH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Apr 2021 16:11:07 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id BB38DB306;
        Sat, 17 Apr 2021 20:10:39 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 5D86A607B3; Sat, 17 Apr 2021 22:10:39 +0200 (CEST)
Date:   Sat, 17 Apr 2021 22:10:39 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org,
        davem@davemloft.net, andrew@lunn.ch, idosch@nvidia.com,
        saeedm@nvidia.com, michael.chan@broadcom.com
Subject: Re: [PATCH net-next v2 3/9] ethtool: add a new command for reading
 standard stats
Message-ID: <20210417201039.5ypk7efz7f57mowe@lion.mk-sys.cz>
References: <20210416192745.2851044-1-kuba@kernel.org>
 <20210416192745.2851044-4-kuba@kernel.org>
 <YHsXnzqVDjL9Q0Bz@shredder.lan>
 <20210417105742.76bb2461@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210417111351.27c54b99@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YHsutM6vesbQq+Ju@shredder.lan>
 <20210417121520.242b0c14@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210417121808.593e221d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210417121808.593e221d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 17, 2021 at 12:18:08PM -0700, Jakub Kicinski wrote:
> On Sat, 17 Apr 2021 12:15:20 -0700 Jakub Kicinski wrote:
> > On Sat, 17 Apr 2021 21:53:40 +0300 Ido Schimmel wrote:
> > > On Sat, Apr 17, 2021 at 11:13:51AM -0700, Jakub Kicinski wrote:  
> > > > On Sat, 17 Apr 2021 10:57:42 -0700 Jakub Kicinski wrote:    
> > > >
> > > > FWIW ethnl_parse_bit() -> ETHTOOL_A_BITSET_BIT_NAME
> > > > User space can also use raw flags like --groups 0xf but that's perhaps
> > > > too spartan for serious use.    
> > > 
> > > So the kernel can work with ETHTOOL_A_BITSET_BIT_INDEX /
> > > ETHTOOL_A_BITSET_BIT_NAME, but I was wondering if using ethtool binary
> > > we can query the strings that the kernel will accept. I think not?  
> 
> Heh, I misunderstood your question. You're asking if the strings can be
> queried from the command line.
> 
> No, I don't think so. We could add some form of "porcelain" command if
> needed.

We don't have such command but I think it would be useful. After all, as
you pointed out, the request is already implemented at UAPI level so all
we need is to make it available to user.

The syntax will be a bit tricky as some string sets are global and some
per device. Out of

    ethtool --show-strings [devname] <setname>
    ethtool --show-strings [devname] set <setname>
    ethtool --show-strings <setname> [dev <devname>]

the third seems nicest but also least consistent with the rest of
ethtool command line syntax. So probably one of the first two.

Michal
