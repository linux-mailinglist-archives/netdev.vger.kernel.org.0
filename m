Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D28FF3D43
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 02:16:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728116AbfKHBQc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 20:16:32 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:45336 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726094AbfKHBQc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 20:16:32 -0500
Received: by mail-qk1-f193.google.com with SMTP id q70so3815866qke.12
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 17:16:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=vdt2C+geesv9gxBDPFxWmGRqSYPbEeSey1ykEQ5i0MQ=;
        b=rvIkRJwXLTY6gD+G753640J0M69Gk/N7ZbG12ZwUG16/+FqGTcZQ9iosuqAWp35ZjJ
         TD4LMJs5zmWuIkLQpJ06wiPyeKHVSs15AggUo+3xmsnijfhIAv6eUEPZZOZ9yNX8wRma
         YmI7reXLlB1fX/fjOUZIGUaa3UH4Io9mYii8NHcOB6dCd1Vz7EbLGtlHVkUpEwLh8wbe
         GlDbXAp9YUy3dhp3MQpUkjXCA2z8mMig+gkMtqVhY47NYavOfyVOduocvtLxv35RyXph
         n0p+aUIhz8qS4YCz8eeVGOOy4/+8sj2HWiucjVHwn0t2m38CoIoujs4Fdm+3vHaTqb2O
         VUFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=vdt2C+geesv9gxBDPFxWmGRqSYPbEeSey1ykEQ5i0MQ=;
        b=ReEaPlZXxinsEjzxu3uAvktJDxXQITU0L+8U7Zfkop8tMIXY2rGCqP4n8PysGlV35U
         BQfTm8Cb6gFhQspLeTXLJGOrjNE8CUR9rXrbXiNC/wDjrgEFEPZADGs9xmKKqa/LExXW
         SF06NdtdHn+HWXocAEq5MXpXhflhx/sGH1n94ubmKiU4GDuytDdV4AsTba48UbS2Fznh
         n499JVpWFi+S+q/HZl8UMqHP4Fve5CPdGlgFoyi+2cDxMYHg882ivOwiF90kERdiJcV4
         k5hi5g+PtUNFkzkidpMwJe8lW746YW9qwHARb4VFErWCZOE/FjzS3cFv4knS7PnmCGr+
         HQ/A==
X-Gm-Message-State: APjAAAWIsoHEEHhg3ra5UA32C6zrVS+jPUy4UWr14yAYOgLbM11SXMvv
        aDDYbTcw8xxmVe/QVKKiXJwTKA==
X-Google-Smtp-Source: APXvYqwgB8RB+85IE+ef9Th25yVeX8Z70RbHTez0Vh44iPGNCrj28Vv5ofUawCeZSCn27OyxpMxn9g==
X-Received: by 2002:a05:620a:208a:: with SMTP id e10mr5847205qka.221.1573175791133;
        Thu, 07 Nov 2019 17:16:31 -0800 (PST)
Received: from cakuba ([65.196.126.174])
        by smtp.gmail.com with ESMTPSA id o2sm1998400qkf.68.2019.11.07.17.16.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Nov 2019 17:16:31 -0800 (PST)
Date:   Thu, 7 Nov 2019 20:16:27 -0500
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Parav Pandit <parav@mellanox.com>
Cc:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: [PATCH net-next 00/19] Mellanox, mlx5 sub function support
Message-ID: <20191107201627.68728686@cakuba>
In-Reply-To: <AM0PR05MB4866A2B92A64DDF345DB14F5D1780@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20191107160448.20962-1-parav@mellanox.com>
        <20191107153234.0d735c1f@cakuba.netronome.com>
        <AM0PR05MB4866A2B92A64DDF345DB14F5D1780@AM0PR05MB4866.eurprd05.prod.outlook.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 7 Nov 2019 20:52:29 +0000, Parav Pandit wrote:
> > On Thu,  7 Nov 2019 10:04:48 -0600, Parav Pandit wrote: =20
> > > Mellanox sub function capability allows users to create several
> > > hundreds of networking and/or rdma devices without depending on PCI S=
R- =20
> > IOV support.
> >=20
> > You call the new port type "sub function" but the devlink port flavour =
is mdev.
> >  =20
> Sub function is the internal driver structure. The abstract entity at use=
r and stack level is mdev.
> Hence the port flavour is mdev.

FWIW I agree mdev as flavour seems like the right choice.

> > As I'm sure you remember you nacked my patches exposing NFP's PCI sub
> > functions which are just regions of the BAR without any mdev capability=
. Am I
> > in the clear to repost those now? Jiri?
> >  =20
> For sure I didn't nack it. :-)

Well, maybe the word "nack" wasn't exactly used :)

> What I remember discussing offline/mailing list is=20
> (a) exposing mdev/sub fuctions as devlink sub ports is not so good abstra=
ction
> (b) user creating/deleting eswitch sub ports would be hard to fit in the =
whole usage model

Okay, so I can repost the "basic" sub functions?

> > > Overview:
> > > ---------
> > > Mellanox ConnectX sub functions are exposed to user as a mediated
> > > device (mdev) [2] as discussed in RFC [3] and further during
> > > netdevconf0x13 at [4].
> > >
> > > mlx5 mediated device (mdev) enables users to create multiple
> > > netdevices and/or RDMA devices from single PCI function.
> > >
> > > Each mdev maps to a mlx5 sub function.
> > > mlx5 sub function is similar to PCI VF. However it doesn't have its
> > > own PCI function and MSI-X vectors.
> > >
> > > mlx5 mdevs share common PCI resources such as PCI BAR region, MSI-X
> > > interrupts.
> > >
> > > Each mdev has its own window in the PCI BAR region, which is
> > > accessible only to that mdev and applications using it.
> > >
> > > Each mlx5 sub function has its own resource namespace for RDMA resour=
ces.
> > >
> > > mdevs are supported when eswitch mode of the devlink instance is in
> > > switchdev mode described in devlink documentation [5]. =20
> >=20
> > So presumably the mdevs don't spawn their own devlink instance today, b=
ut
> > once mapped via VIRTIO to a VM they will create one?
> >  =20
> mdev doesn't spawn the devlink instance today when mdev is created by use=
r, like PCI.
> When PCI bus driver enumerates and creates PCI device, there isn't a devl=
ink instance for it.
>=20
> But, mdev's devlink instance is created when mlx5_core driver binds to th=
e mdev device.
> (again similar to PCI, when mlx5_core driver binds to PCI, its devlink in=
stance is created ).
>=20
> I should have put the example in patch-15 which creates/deletes devlink i=
nstance of mdev.
> I will revise the commit log of patch-15 to include that.
> Good point.

Thanks.

> > It could be useful to specify.
> >  =20
> Yes, its certainly useful. I missed to put the example in commit log of p=
atch-15.
>=20
> > > Network side:
> > > - By default the netdevice and the rdma device of mlx5 mdev cannot
> > > send or receive any packets over the network or to any other mlx5 mde=
v. =20
> >=20
> > Does this mean the frames don't fall back to the repr by default? =20
> Probably I wasn't clear.
> What I wanted to say is, that frames transmitted by mdev's netdevice and =
rdma devices don't go to network.
> These frames goes to representor device.
> User must configure representor to send/receive/steer traffic to mdev.

=F0=9F=91=8D
