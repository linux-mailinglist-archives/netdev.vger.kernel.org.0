Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5DBCF404F
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 07:20:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726987AbfKHGUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 01:20:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:53938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725802AbfKHGUP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 01:20:15 -0500
Received: from localhost (unknown [77.137.81.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 138742087E;
        Fri,  8 Nov 2019 06:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573194014;
        bh=N/MoQ4MYJawRwuvj7G31vynYOq6V+QZcyF3n3loEhM4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UuXBAZDx7Mx0GED68RAmJ+/7SvmCBsgtEXSYFHQGuzdftMLIV89ZDpsZqNb6EpLQO
         X55jQ3GZZM1VL0TfRC9sO+qdRGoOOD2PDm4ea3ATp+FUrhMS393IIDmaI28eY5n0Z+
         ufbLhHmTyVPtFPkJYsy/pTEDu+y1pgK3qCCyc1u0=
Date:   Fri, 8 Nov 2019 08:20:03 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Parav Pandit <parav@mellanox.com>
Cc:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH net-next 00/19] Mellanox, mlx5 sub function support
Message-ID: <20191108062003.GN6763@unreal>
References: <20191107160448.20962-1-parav@mellanox.com>
 <20191107170341.GM6763@unreal>
 <AM0PR05MB4866BE0BA3BEA9523A034EDDD1780@AM0PR05MB4866.eurprd05.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM0PR05MB4866BE0BA3BEA9523A034EDDD1780@AM0PR05MB4866.eurprd05.prod.outlook.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 07, 2019 at 08:10:45PM +0000, Parav Pandit wrote:
> Hi Leon,
>
> > -----Original Message-----
> > From: Leon Romanovsky <leon@kernel.org>
> > Sent: Thursday, November 7, 2019 11:04 AM
> > To: Parav Pandit <parav@mellanox.com>
> > Cc: alex.williamson@redhat.com; davem@davemloft.net;
> > kvm@vger.kernel.org; netdev@vger.kernel.org; Saeed Mahameed
> > <saeedm@mellanox.com>; kwankhede@nvidia.com; cohuck@redhat.com; Jiri
> > Pirko <jiri@mellanox.com>; linux-rdma@vger.kernel.org
> > Subject: Re: [PATCH net-next 00/19] Mellanox, mlx5 sub function support
> >
> > On Thu, Nov 07, 2019 at 10:04:48AM -0600, Parav Pandit wrote:
> > > Hi Dave, Jiri, Alex,
> > >
> >
> > <...>
> >
> > > - View netdevice and (optionally) RDMA device using iproute2 tools
> > >     $ ip link show
> > >     $ rdma dev show
> >
> > You perfectly explained how ETH devices will be named, but what about
> > RDMA?
> > How will be named? I feel that rdma-core needs to be extended to support such
> > mediated devices.
> >
> rdma devices are named by default using mlx_X.
> After your persistent naming patches, I thought we have GUID based naming scheme which doesn't care about its underlying bus.

No, it is not how it is done. RDMA persistent naming is modeled exactly
as ETH naming, it means that we do care about bus and we don't use GUID
unless user explicitly asked, exactly as MAC based names in ETH world.

> So mdevs will be able to use current GUID based naming scheme we already have.

Unfortunately, no.

>
> Additionally, if user prefers, mdev alias, we can extend systemd/udev to use mdev alias based names (like PCI bdf).

It is not "Additionally", but "must".

> Such as,
> rocem<alias1>
> ibm<alias2>
> Format is:
> <link_layer><m><alias>
> m -> stands for mdev device (similar to 'p' for PCI)
