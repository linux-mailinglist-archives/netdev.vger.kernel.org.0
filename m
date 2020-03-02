Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EE641763C5
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 20:22:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727600AbgCBTWj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 14:22:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:36964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727126AbgCBTWj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Mar 2020 14:22:39 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 641B42173E;
        Mon,  2 Mar 2020 19:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583176958;
        bh=UXTQKkSGjTeE+KJ1GPD/JGKupx/qHMGI1vwjG7jNua4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tXCG80ygwKrrTir9Uh96qbP03bDEtIymUUmoiepw/oCUcTXPC1NljLiNyx6b+zWb+
         Bg2/VPUQ4TCeail7w3yJokz97f22JrI7wxvYEe8pIIGPnN7Aw3ihxYNWdEFXqQBJfO
         eCYTtt2Tq39BQrACTOLXuzf3OG31fPtQHGOczZ0Q=
Date:   Mon, 2 Mar 2020 11:22:36 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jianbo Liu <jianbol@mellanox.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Vlad Buslov <vladbu@mellanox.com>,
        Roi Dayan <roid@mellanox.com>, Jiri Pirko <jiri@mellanox.com>
Subject: Re: [net-next 08/16] net/mlx5e: Add devlink fdb_large_groups
 parameter
Message-ID: <20200302112236.0474d821@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200302020420.GA14695@mellanox.com>
References: <20200228004446.159497-1-saeedm@mellanox.com>
        <20200228004446.159497-9-saeedm@mellanox.com>
        <20200228111026.1baa9984@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200302020420.GA14695@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2 Mar 2020 02:04:20 +0000 Jianbo Liu wrote:
> The 02/28/2020 11:10, Jakub Kicinski wrote:
> > On Thu, 27 Feb 2020 16:44:38 -0800 Saeed Mahameed wrote:  
> > > From: Jianbo Liu <jianbol@mellanox.com>
> > > 
> > > Add a devlink parameter to control the number of large groups in a
> > > autogrouped flow table. The default value is 15, and the range is between 1
> > > and 1024.
> > > 
> > > The size of each large group can be calculated according to the following
> > > formula: size = 4M / (fdb_large_groups + 1).
> > > 
> > > Examples:
> > > - Set the number of large groups to 20.
> > >     $ devlink dev param set pci/0000:82:00.0 name fdb_large_groups \
> > >       cmode driverinit value 20
> > > 
> > >   Then run devlink reload command to apply the new value.
> > >     $ devlink dev reload pci/0000:82:00.0
> > > 
> > > - Read the number of large groups in flow table.
> > >     $ devlink dev param show pci/0000:82:00.0 name fdb_large_groups
> > >     pci/0000:82:00.0:
> > >       name fdb_large_groups type driver-specific
> > >         values:
> > >           cmode driverinit value 20
> > > 
> > > Signed-off-by: Jianbo Liu <jianbol@mellanox.com>
> > > Reviewed-by: Vlad Buslov <vladbu@mellanox.com>
> > > Reviewed-by: Roi Dayan <roid@mellanox.com>
> > > Acked-by: Jiri Pirko <jiri@mellanox.com>
> > > Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>  
> > 
> > Slicing memory up sounds like something that should be supported via
> > the devlink-resource API, not by params and non-obvious calculations :(  
> 
> No, it's not to configure memory resource. It is to control how many
> large groups in FW FDB. The calculations to to tell how many rules in each
> large group.

I don't know what a "large group" is. Please update the documentation
so it's not an utter pleonasm.

What's a large group? How does twiddling with this knob change the
behavior of the system? Who and in what conditions may be interested 
in adjusting it?
