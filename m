Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D2B9F50C4
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 17:13:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727550AbfKHQNC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 11:13:02 -0500
Received: from mail-eopbgr30057.outbound.protection.outlook.com ([40.107.3.57]:28674
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726152AbfKHQNC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 11:13:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PIOo5y0Ind3Ot4ESPJyRw8G202FQvLob5+wEpmntTzPiNo9fHIZhE0opJmulc4EahsDxix2Hizosyh2pLekdS+zGQH3Gg6s+8u/Ncm3SXXo8WYdkqe4a6WNJx1csAQG+BYyiBH0vlLSa9T1a+yXOcIw73thUZ7O2Xw+8nsyfIRnfV5XhUtHpbHNcQZecbSuVBnt503EKYUxbNi5cLbwWGkG8S+HFvTeXUKhZi4QCcXP9+P/Tgj/Bgm8qCF7kw3BKoqz9jUChi4AxOjvkmpoLH7aUb8Y+rcXo2qKJgWXWWt38VdMNIab03zXawd7gOCYzo8pT4fbGw7afUBUhOTg1GQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KJKJJrGN3qsn3aUFWh/XIC+wZnvynWHOXTXvtKg3sP0=;
 b=HyaOwwSkzDbqwfkrDgLvR3O58QLK3wSDpdOp2EbHt2JSJ2Bsgsw1V/A6/NB5Tr+YcbJfCqMdm6s4CsAf6h8U5u0QYUIGce/qU9u41O3dkCKQ63Yuu3OLq7HVPLzkPrXxPNrcCAOwqRQ+b6opzzIKHVt7/1yzInd9fLe6byMAV2se/ZOepz4lUYh/IDllTa59m2mLCfTySJYDXCPgKGE0F9Vzp/WjJgeRHLifsW4AfXzyH4iYVcBwh3kL34q6cqTtgYhzDG8MCY/itnokXI+ZXdcUilutyZ/KDMEAi6pMXGMjUSbRnkkzM3vYo6NXrXmM3rw1cDgDmdJwW1IfMLS6Uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KJKJJrGN3qsn3aUFWh/XIC+wZnvynWHOXTXvtKg3sP0=;
 b=S19tkI5f4kbvmc2q9rW0TvbMEApQCUaBdIfZ1/q+2ZCCPCAX5nJsnuUjOgWnNYujroP5sbzY3SdXEGffGpIdmY9DFU/OvNydTSKa6zD37anUjD/CfOEaGmS6/CZaBSdyJEwOhL6VzmBpHUM6MlQBEHmQqgk27W9NpScUXL0YfbI=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB6659.eurprd05.prod.outlook.com (10.186.174.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Fri, 8 Nov 2019 16:12:56 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4%7]) with mapi id 15.20.2430.020; Fri, 8 Nov 2019
 16:12:56 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Cornelia Huck <cohuck@redhat.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "leon@kernel.org" <leon@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: [PATCH net-next 11/19] vfio/mdev: Improvise mdev life cycle and
 parent removal scheme
Thread-Topic: [PATCH net-next 11/19] vfio/mdev: Improvise mdev life cycle and
 parent removal scheme
Thread-Index: AQHVlYW7AxlBOSp/Fk2Dw2OAVe1EB6eBPiMAgAAzyGA=
Date:   Fri, 8 Nov 2019 16:12:56 +0000
Message-ID: <AM0PR05MB486664BEDB1A2238B4FE95C4D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20191107160448.20962-1-parav@mellanox.com>
        <20191107160834.21087-1-parav@mellanox.com>
        <20191107160834.21087-11-parav@mellanox.com>
 <20191108140110.6f24916b.cohuck@redhat.com>
In-Reply-To: <20191108140110.6f24916b.cohuck@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [2605:6000:ec82:1c00:9dfd:71f9:eb37:f669]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 49dfcb3d-6336-4cb8-282b-08d76466845e
x-ms-traffictypediagnostic: AM0PR05MB6659:|AM0PR05MB6659:
x-ms-exchange-purlcount: 1
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB665973D983F540C07F10B2EED17B0@AM0PR05MB6659.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:529;
x-forefront-prvs: 0215D7173F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(346002)(39860400002)(366004)(376002)(199004)(189003)(13464003)(102836004)(2906002)(52536014)(4326008)(6916009)(6436002)(14444005)(256004)(71190400001)(71200400001)(8936002)(53546011)(99286004)(186003)(46003)(6506007)(486006)(476003)(316002)(7736002)(229853002)(81166006)(81156014)(305945005)(74316002)(446003)(11346002)(6306002)(5660300002)(9686003)(8676002)(33656002)(66556008)(66476007)(76176011)(66946007)(7696005)(76116006)(966005)(64756008)(6246003)(14454004)(86362001)(66446008)(25786009)(478600001)(54906003)(6116002)(55016002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB6659;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bpjfeXmxWby2dqvVqexn2LyBiL6k6KnlmOJ+T0S9Q0Tphy+mK0YCefiDdk+QqoevIr08mzJc2wY3cLOk0TtFCoEgxoA9V4/lw3hu5d4xodQoP5+uYbOycQ5hqHTepdORnwtXW2kJRmTFgQzrNg/WB6x7YI/xggAU6N4cPFPNIzHxvuWgGSz7dSjLXybRV4Xw+tfrB+0sL2XnFmm+47jG+sleE07g69mZMmXGR94D21j/5guIs2r3ytVAMqFZVJ9NgvGOGc7vNlxkCA/DgeNexqWWc7yUi+ygyuLutX3ARm/MtleHvEqbzKvudCZS1dbaTLc6zbJZzTj+ZCldbmdQ8t8A0Xk0VbX//2K21GmLdK90r0kKP23vL9P97AiHD6wAdrGe6uKZ9S6TbpirVbGGtT7h7rqHENY/QUk/VHBqhiB9XIT4lJMTQIIL8h5vhe8BbhZNXnXh8IZLGbSE+W9oGM6qyAjXiJ0K9AhDSHm+wew=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49dfcb3d-6336-4cb8-282b-08d76466845e
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2019 16:12:56.4860
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: P3bSN9dNAYyonJm8dp1v5xBhA8Bo9XmpFd2r5lTSlplDGmyupuWCv9b8RrvYkuu/8JG38ZD7N8tzoqhIZvFGCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6659
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Cornelia Huck <cohuck@redhat.com>
> Sent: Friday, November 8, 2019 7:01 AM
> To: Parav Pandit <parav@mellanox.com>
> Cc: alex.williamson@redhat.com; davem@davemloft.net;
> kvm@vger.kernel.org; netdev@vger.kernel.org; Saeed Mahameed
> <saeedm@mellanox.com>; kwankhede@nvidia.com; leon@kernel.org; Jiri
> Pirko <jiri@mellanox.com>; linux-rdma@vger.kernel.org
> Subject: Re: [PATCH net-next 11/19] vfio/mdev: Improvise mdev life cycle =
and
> parent removal scheme
>=20
> On Thu,  7 Nov 2019 10:08:26 -0600
> Parav Pandit <parav@mellanox.com> wrote:
>=20
> I guess that should be s/Improvise/improve/ in $SUBJECT, no?
>
Will do.
=20

[..]

> >
> > To summarize,
> > mdev_remove()
> >   read locks -> unreg_sem [ lock-A ]
> >   [..]
> >   devlink_unregister();
> >     mutex lock devlink_mutex [ lock-B ]
> >
> > devlink eswitch->switchdev-legacy mode change.
> >  devlink_nl_cmd_eswitch_set_doit()
> >    mutex lock devlink_mutex [ lock-B ]
> >    mdev_unregister_device()
> >    write locks -> unreg_sem [ lock-A]
>=20
> So, this problem starts to pop up once you hook up that devlink stuff wit=
h
> the mdev stuff, and previous users of mdev just did not have a locking
> scheme similar to devlink?
>
Correct.
=20
> >
> > Hence, instead of using semaphore, such synchronization is achieved
> > using srcu which is more flexible that eliminates nested locking.
> >
> > SRCU based solution is already proposed before at [2].
> >
> > [1] commit 5715c4dd66a3 ("vfio/mdev: Synchronize device create/remove
> > with parent removal") [2]
> > https://lore.kernel.org/patchwork/patch/1055254/
>=20
> I don't quite recall the discussion there... is this a rework of a patch =
you
> proposed before? Confused.
>=20
It was one huge patch, fixing multiple issues.
Alex suggested to split into multiple.
Initially for this issue I had it srcu, while redoing them to smaller patch=
es, I guess for simplicity I moved to semaphore.
Once I enabled all my tested after a break, I realized that fix is not enou=
gh.

> >
> > Signed-off-by: Parav Pandit <parav@mellanox.com>
> > ---
> >  drivers/vfio/mdev/mdev_core.c    | 56 +++++++++++++++++++++++---------
> >  drivers/vfio/mdev/mdev_private.h |  3 +-
> >  2 files changed, 43 insertions(+), 16 deletions(-)
>=20
> (...)
>=20
> > @@ -207,6 +207,7 @@ int mdev_register_device(struct device *dev, const
> struct mdev_parent_ops *ops)
> >  		dev_warn(dev, "Failed to create compatibility class link\n");
> >
> >  	list_add(&parent->next, &parent_list);
> > +	rcu_assign_pointer(parent->self, parent);
> >  	mutex_unlock(&parent_list_lock);
> >
> >  	dev_info(dev, "MDEV: Registered\n"); @@ -250,14 +251,29 @@ void
> > mdev_unregister_device(struct device *dev)
> >  	list_del(&parent->next);
> >  	mutex_unlock(&parent_list_lock);
> >
> > -	down_write(&parent->unreg_sem);
> > +	/*
> > +	 * Publish that this mdev parent is unregistering. So any new
> > +	 * create/remove cannot start on this parent anymore by user.
> > +	 */
> > +	rcu_assign_pointer(parent->self, NULL);
> > +
> > +	/*
> > +	 * Wait for any active create() or remove() mdev ops on the parent
> > +	 * to complete.
> > +	 */
> > +	synchronize_srcu(&parent->unreg_srcu);
> > +
> > +	/*
> > +	 * At this point it is confirmed that any pending user initiated
> > +	 * create or remove callbacks accessing the parent are completed.
> > +	 * It is safe to remove the parent now.
> > +	 */
>=20
> So, you're putting an srcu-handled self reference there and use that as a=
n
> indication whether the parent is unregistering?
>=20
Right.
