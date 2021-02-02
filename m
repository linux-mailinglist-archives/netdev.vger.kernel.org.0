Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C097830CDE6
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 22:25:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231506AbhBBVZf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 16:25:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:50208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231236AbhBBVZa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 16:25:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD21464F66;
        Tue,  2 Feb 2021 21:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612301088;
        bh=ds4WaVOYd1g32K51R5GqGDIRRrCY7P6IrvUy98Kik1c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=R2dZ8UnB4XJA2gHMNDuorQzgv/zy7NDh6+Ogf/oo3Jjhrjso+exvlcSXLh/5Y6NMc
         5swfBQVFjo9BAw2zEH5LxNogfgNw4XlL01SOkO1bOKhPglyNu7Q/QqdnTHfKde7EwN
         3Ag9gyjcfThETveECBsVQA2RNDP9ChZCKXKVMq/zjYRI4rBwETj2TVp+0eVmpth1e0
         y/Fikr1dSAG5R+sPf0imE/kSwAd2Ww3OG8m5/CIuIrAgpM+OYxJ6V6fY/gnZxfQKjm
         s2D+w9gw7q3Wy38i7Hb0rCNX9XE+WP3qBuoNsLAXK4/Fh79Ha9TZk0poXa2KvY/Ga8
         FHXd1rZ5nBx6g==
Date:   Tue, 2 Feb 2021 13:24:46 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Chris Mi <cmi@nvidia.com>, netdev@vger.kernel.org, jiri@nvidia.com,
        kernel test robot <lkp@intel.com>,
        Ido Schimmel <idosch@idosch.org>
Subject: Re: [PATCH net-next v6] net: psample: Introduce stubs to remove NIC
 driver dependency
Message-ID: <20210202132446.11d3af03@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <2dbcb5f51fd2ad1296c4391d45a854fef3438420.camel@kernel.org>
References: <20210201020412.52790-1-cmi@nvidia.com>
        <20210201171441.46c0edaa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <2dbcb5f51fd2ad1296c4391d45a854fef3438420.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 01 Feb 2021 23:31:15 -0800 Saeed Mahameed wrote:
> On Mon, 2021-02-01 at 17:14 -0800, Jakub Kicinski wrote:
> > On Mon,=C2=A0 1 Feb 2021 10:04:12 +0800 Chris Mi wrote: =20
> > > In order to send sampled packets to userspace, NIC driver calls
> > > psample api directly. But it creates a hard dependency on module
> > > psample. Introduce psample_ops to remove the hard dependency.
> > > It is initialized when psample module is loaded and set to NULL
> > > when the module is unloaded.
> > >=20
> > > Reported-by: kernel test robot <lkp@intel.com>
> > > Signed-off-by: Chris Mi <cmi@nvidia.com>
> > > Reviewed-by: Jiri Pirko <jiri@nvidia.com> =20
> >=20
> > The necessity of making this change is not obvious (you can fix the
> > distro scripts instead), you did not include a clarification in the
> > commit message even though two people asked you why it's needed and=20
> > on top of that you keep sending code which doesn't build.=20
> >=20
> > Please consider this change rejected and do not send a v7. =20
>=20
> Jakub, it is not only about installation dependencies, the issue is
> more critical than this,=20
>=20
> We had some other issues with similar dependency problem where
> mlx5_core had hard dependency with netfilter, firewalld when disabled,
> removes netfilter and all its dependencies including mlx5, this is a no
> go for our users.
>=20
> Again, having a hard dependency between a hardware driver and a
> peripheral module in the kernel is a bad design.

That is not the point.

The technical problem is minor, and it's a problem for _your_ driver.
Yet, it appears to be my responsibility to make sure the patch even
compiles.

I believe there should be a limit to the ignorance a community
volunteer is expected to put up with when dealing with patches=20
from and for the benefit of a commercial vendor.

This is up for discussion, if you disagree let's talk it out. I'm=20
not particularly patient (to put it mildly), but I don't understand=20
how v5 could have built, and yet v6 gets posted with the same exact
problem :/

So from my perspective it seems like the right step to push back.
If you, Tariq, Jiri, Ido or any other seasoned kernel contributor
reposts this after making sure it's up to snuff themselves I will
most certainly take a look / apply.
