Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA4702CFFE8
	for <lists+netdev@lfdr.de>; Sun,  6 Dec 2020 01:20:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbgLFAUD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 19:20:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:35230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726479AbgLFAUD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Dec 2020 19:20:03 -0500
Date:   Sat, 5 Dec 2020 16:19:21 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607213962;
        bh=z74Qu3BZ9THGGDFL/azt1oUbX43/GX6pnXhZ9p2hfMw=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=eXrpgxAjzYcGWihToybJkEVCLO4XGqD2lqnbqJtXTlTXNGd48yxtos5AgATQ6juMS
         Ol+Vpq9uVc/vNm0cAGTq14XqJvR3zI9fXhe+R68DGfwGHNnWKK+XXq2nue43Ui1NeU
         hkZIOTJdJ6JK9A4KjbeiEbYoDUa7uePWv00z+bR5fdZ6XdapmwOQyM2OLLwENQYpwf
         WuT07IegReOl7AMW3IdfRLxKwKsjUlSbarm3wDfKYYHoKfrMjLWPyqoBbeEDvU99ha
         vuBc7H6++PptBWfzQWV0hR3z+DRlJ0G/tU3+UzmFXMJpNiQAhVYi8bjxTYsMu6/qPm
         uSAqPwayb8gsA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, <netdev@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Dave Ertman <david.m.ertman@intel.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: Re: [pull request][for-next] mlx5-next auxbus support
Message-ID: <20201205161921.28d5cb7e@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201205153545.3d30536b@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
References: <20201204182952.72263-1-saeedm@nvidia.com>
        <20201205153545.3d30536b@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 5 Dec 2020 15:35:45 -0800 Jakub Kicinski wrote:
> On Fri, 4 Dec 2020 10:29:52 -0800 Saeed Mahameed wrote:
> > This pull request is targeting net-next and rdma-next branches.
> >=20
> > This series provides mlx5 support for auxiliary bus devices.
> >=20
> > It starts with a merge commit of tag 'auxbus-5.11-rc1' from
> > gregkh/driver-core into mlx5-next, then the mlx5 patches that will conv=
ert
> > mlx5 ulp devices (netdev, rdma, vdpa) to use the proper auxbus
> > infrastructure instead of the internal mlx5 device and interface manage=
ment
> > implementation, which Leon is deleting at the end of this patchset.
> >=20
> > Link: https://lore.kernel.org/alsa-devel/20201026111849.1035786-1-leon@=
kernel.org/
> >=20
> > Thanks to everyone for the joint effort ! =20
>=20
> Pulled, thanks! (I'll push out after build finishes so may be an hour)

Or not, looks like you didn't adjust to Greg's changes:

../drivers/net/ethernet/mellanox/mlx5/core/en_main.c:5505:12: error: initia=
lization of =E2=80=98void (*)(struct auxiliary_device *)=E2=80=99 from inco=
mpatible pointer type =E2=80=98int (*)(struct auxiliary_device *)=E2=80=99 =
[-Werror=3Dincompatible-pointer-types]
 5505 |  .remove =3D mlx5e_remove,
      |            ^~~~~~~~~~~~
../drivers/net/ethernet/mellanox/mlx5/core/en_main.c:5505:12: note: (near i=
nitialization for =E2=80=98mlx5e_driver.remove=E2=80=99)
cc1: some warnings being treated as errors
make[6]: *** [../scripts/Makefile.build:283: drivers/net/ethernet/mellanox/=
mlx5/core/en_main.o] Error 1
make[5]: *** [../scripts/Makefile.build:500: drivers/net/ethernet/mellanox/=
mlx5/core] Error 2
make[4]: *** [../scripts/Makefile.build:500: drivers/net/ethernet/mellanox]=
 Error 2
make[3]: *** [../scripts/Makefile.build:500: drivers/net/ethernet] Error 2
make[3]: *** Waiting for unfinished jobs....

