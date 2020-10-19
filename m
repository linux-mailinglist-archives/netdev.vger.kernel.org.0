Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5281292819
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 15:23:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727996AbgJSNXf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 09:23:35 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:5901 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727893AbgJSNXd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 09:23:33 -0400
Received: from HKMAIL101.nvidia.com (Not Verified[10.18.92.100]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f8d93540000>; Mon, 19 Oct 2020 21:23:32 +0800
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 19 Oct
 2020 13:23:31 +0000
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (104.47.45.58) by
 HKMAIL101.nvidia.com (10.18.16.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 19 Oct 2020 13:23:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P7Y5Kk7YggJpk5XbCy4jiHTEYj9J3j3ZnitgDwRDRnV6GnWLdyaqR8l2dlxg+u8lkbc5wUDDEP3WMhdzMb3VI2a/RuH2ifZG2MI+WvuhfnzEdkbSNCW5PCxmcxQNS3WZQnZJKOh6YoPDv1HOOMBDwlTMPcMxIv+vSeuEE+mQ29fqAnU1CRLfD26olCasGbu4WIYqhl9pEJ88JE59omfpDhziqXmd6iyj2jWEhCegZ6MZsvCHZMkdjKy2YSTPqLE+eBI1UzlnTdR+M/g9KpFNHEhMmFiJVLduX7hQRu0DmjK3ELmLjetNBqUD0c5I+87d7wgp/Aw6cDAWMRxf9A3u6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=akFED7BEhqddxSWg2op3zZoxk0CM58ZKaTEX8zaLSps=;
 b=ZoqGEa/6S4YZWEkbhaeXAC4AbU5DHcx6v+yf31d49d31X88aIARRoKueYl6iH/1MO3MQG4GbrB+O/dNbSl5b5sDS+9Bz81Tppdprbm9GCFAQknIntQEfc9iiyZEeyXvsXJuc1Jp+C5xbUlq4Q1k/0xTmb3xjVVIgPqiChM7XI9hSnX0knlrFX9gHendKkRFg/ohGy2IkYmXqFzxvXfoHopzBxjSRaRjnT3GHx1lSF5nszSwMz8bMlUd46aZ2c+SkhfDkiuH5bSt/zT6pY+pxehyJhKx+NsN60pebWhuezTir5mf3kq0DyCJ7HFQGL33k+L8Ig5LwESYev1dzg17bBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BYAPR12MB4741.namprd12.prod.outlook.com (2603:10b6:a03:a2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.25; Mon, 19 Oct
 2020 13:23:24 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::3c25:6e4c:d506:6105]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::3c25:6e4c:d506:6105%6]) with mapi id 15.20.3477.028; Mon, 19 Oct 2020
 13:23:24 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Jason Gunthorpe <jgg@nvidia.com>, Leon Romanovsky <leon@kernel.org>
CC:     Doug Ledford <dledford@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Jiri Pirko" <jiri@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Michael Guralnik <michaelgur@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: RE: [PATCH rdma-rc] RDMA/mlx5: Fix devlink deadlock on net namespace
 deletion
Thread-Topic: [PATCH rdma-rc] RDMA/mlx5: Fix devlink deadlock on net namespace
 deletion
Thread-Index: AQHWpdiUyESckSXaE0yVQeBJxm0NBame5gGAgAABELA=
Date:   Mon, 19 Oct 2020 13:23:23 +0000
Message-ID: <BY5PR12MB4322102A3DD0EC976FF317E7DC1E0@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20201019052736.628909-1-leon@kernel.org>
 <20201019130751.GE6219@nvidia.com>
In-Reply-To: <20201019130751.GE6219@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.195.223]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7e93e084-0eaa-46fd-7671-08d874322810
x-ms-traffictypediagnostic: BYAPR12MB4741:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB47416501481426CEC06B4825DC1E0@BYAPR12MB4741.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: T+r0pYmkhe6MiHXdEd3tdr5Hik8ow9cGd1aesPmBXzOf/frBQc+Ghh+57RAR7PWVpzsBsFKlfBnSwJMWnkyk73XlwJh3bm52Nh7bzZ+upVDlHlzO0byyLH2qPSchbqUsotHXiK8NbPLLWJCopjUcNDeKqK3Qb3kKdxHB/hP64mkWlkGfTQVmOuQGkXnLel9HcV33sf2XgBlhmMzwkpIAQ8b42mgc/crausAhXfEnkvA2wrNC0ZAoMmytx6vBgsc+S0MCqHjOQ/LNFHir0O8dZKfKaEY0IKn7nrisWtsScIGGS+c6bHggyvNhIuz15w5Z+pSGAbPIoGIfFNEyV86Ccw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(366004)(376002)(346002)(39860400002)(186003)(316002)(55236004)(110136005)(54906003)(4326008)(83380400001)(86362001)(52536014)(5660300002)(55016002)(76116006)(71200400001)(9686003)(7696005)(107886003)(6506007)(478600001)(26005)(8676002)(66476007)(66446008)(66556008)(2906002)(8936002)(33656002)(64756008)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: VHBFFEfe4eHlzDW2UDOzrBLoS1uOMEU5ZCdk7YDW8IDRSWU0aVpKB690LAn7y3tKsVjkUQB3n1dpCX0Wy5Vz8Dxnrs79+H+SoWELli385w0eptEr/4XAQ4vNHAl5Bikt9VY6Ze17HuW8vdMVH2puoHoJopvWgM97IYWtTa1maTvvYyue7M3FIMDwnPhYekRwctSJ/gH0B/XOAWml5pCuCo3LUPi1nm3YKlVrPYDEUcVm9xuLzOgfNAC4kuXBUJeD8CZMN/im5wgNEnWJD+dXynsgq2SjHTTG1AZcKDyJis2y4WtoztcBtCTZpEigQRrqOm/Wp1MEH9Rbz7LpTZaZeSddoZL7fxEK6sXNaJfgr6N5eFMyoyMUUrzOCUBJNDp3evTwyuyWFw74iTFXnR/cSBYuL2QIgNyeC8VsCS912P3WrClI4mLvrk4pghOdcPpsjMlRgro4BriZQorGnM8QrVGoObim9vR35M1Fvv2bRHNudJGCwtl4/3lo3dgKZd/7dkXjMZy0nBxSUk2PMLsItKMEpfwZ9zA2iJLOXfaeI+09tz3R1wTVcT5ItbUDO0FEoz8tDqUsTShm5RH8ruQL+qsfB2O3QO8VgiWfpvgKZtSAmJxET/dQX6APY0pwNoQQhRYZO4XSOcnkuaz1bao86w==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e93e084-0eaa-46fd-7671-08d874322810
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Oct 2020 13:23:24.0009
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kgznM7gDhzRUlu1maJkrdV/dXrUKjDHusHjgoc1Y/VhPuGdITiTxDNYpYoZcAPUdywrXR8QKeOxzndjQQJGNjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB4741
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1603113812; bh=akFED7BEhqddxSWg2op3zZoxk0CM58ZKaTEX8zaLSps=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
         In-Reply-To:Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-ms-exchange-transport-forked:
         x-microsoft-antispam-prvs:x-ms-oob-tlc-oobclassifiers:
         x-ms-exchange-senderadcheck:x-microsoft-antispam:
         x-microsoft-antispam-message-info:x-forefront-antispam-report:
         x-ms-exchange-antispam-messagedata:Content-Type:
         Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=QcwKiYgRj7eN+SI9yXGpXXV75Nx27MTmOGyT/lYi7w2ooXUP2Z/mRdgx6kYKzgO5s
         EkqMOBgIgUoelyXeJ00UyEuxyD9NZA2UW9pCsDwO9zMrDWT9CVPBwYU/Ty8I/yAEnu
         JMP3dU8pWXmYGIlGehs6qymQknNckXy3pxACl/BVsl1vNy7y7wPF7+uQx11+oDu1WN
         3ePcOz9U9kmwFhTYF/c3Li/eNlgMk7r+/uLbRZr1+KWge00+4qegqUMw31YpM8hT9x
         kYrb+MuGbl7x8GmEg/0e4/XkeaIF4ro5menyHOohIiiKCY67Docg7rkBoeIsetF5/U
         jFZpzfjKubE/Q==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Monday, October 19, 2020 6:38 PM
>=20
> On Mon, Oct 19, 2020 at 08:27:36AM +0300, Leon Romanovsky wrote:
> > From: Parav Pandit <parav@nvidia.com>
> >
> > When a mlx5 core devlink instance is reloaded in different net
> > namespace, its associated IB device is deleted and recreated.
> >
> > Example sequence is:
> > $ ip netns add foo
> > $ devlink dev reload pci/0000:00:08.0 netns foo $ ip netns del foo
> >
> > mlx5 IB device needs to attach and detach the netdevice to it through
> > the netdev notifier chain during load and unload sequence.
> > A below call graph of the unload flow.
> >
> > cleanup_net()
> >    down_read(&pernet_ops_rwsem); <- first sem acquired
> >      ops_pre_exit_list()
> >        pre_exit()
> >          devlink_pernet_pre_exit()
> >            devlink_reload()
> >              mlx5_devlink_reload_down()
> >                mlx5_unload_one()
> >                [...]
> >                  mlx5_ib_remove()
> >                    mlx5_ib_unbind_slave_port()
> >                      mlx5_remove_netdev_notifier()
> >                        unregister_netdevice_notifier()
> >                          down_write(&pernet_ops_rwsem);<- recurrsive
> > lock
> >
> > Hence, when net namespace is deleted, mlx5 reload results in deadlock.
> >
> > When deadlock occurs, devlink mutex is also held. This not only
> > deadlocks the mlx5 device under reload, but all the processes which
> > attempt to access unrelated devlink devices are deadlocked.
> >
> > Hence, fix this by mlx5 ib driver to register for per net netdev
> > notifier instead of global one, which operats on the net namespace
> > without holding the pernet_ops_rwsem.
> >
> > Fixes: 4383cfcc65e7 ("net/mlx5: Add devlink reload")
> > Signed-off-by: Parav Pandit <parav@nvidia.com>
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> >  drivers/infiniband/hw/mlx5/main.c                  | 6 ++++--
> >  drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h | 5 -----
> >  include/linux/mlx5/driver.h                        | 5 +++++
> >  3 files changed, 9 insertions(+), 7 deletions(-)
> >
> > diff --git a/drivers/infiniband/hw/mlx5/main.c
> > b/drivers/infiniband/hw/mlx5/main.c
> > index 944bb7691913..b1b3e563c15e 100644
> > +++ b/drivers/infiniband/hw/mlx5/main.c
> > @@ -3323,7 +3323,8 @@ static int mlx5_add_netdev_notifier(struct
> mlx5_ib_dev *dev, u8 port_num)
> >  	int err;
> >
> >  	dev->port[port_num].roce.nb.notifier_call =3D mlx5_netdev_event;
> > -	err =3D register_netdevice_notifier(&dev->port[port_num].roce.nb);
> > +	err =3D register_netdevice_notifier_net(mlx5_core_net(dev->mdev),
> > +					      &dev->port[port_num].roce.nb);
>=20
> This looks racy, what lock needs to be held to keep *mlx5_core_net() stab=
le?

mlx5_core_net() cannot be accessed outside of mlx5 driver's load, unload, r=
eload path.

When this is getting executed, devlink cannot be executing reload.
This is guarded by devlink_reload_enable/disable calls done by mlx5 core.

>=20
> >  	if (err) {
> >  		dev->port[port_num].roce.nb.notifier_call =3D NULL;
> >  		return err;
> > @@ -3335,7 +3336,8 @@ static int mlx5_add_netdev_notifier(struct
> > mlx5_ib_dev *dev, u8 port_num)  static void
> > mlx5_remove_netdev_notifier(struct mlx5_ib_dev *dev, u8 port_num)  {
> >  	if (dev->port[port_num].roce.nb.notifier_call) {
> > -		unregister_netdevice_notifier(&dev-
> >port[port_num].roce.nb);
> > +		unregister_netdevice_notifier_net(mlx5_core_net(dev-
> >mdev),
> > +						  &dev-
> >port[port_num].roce.nb);
>=20
> This seems dangerous too, what if the mlx5_core_net changed before we
> get here?
>=20
When I inspected driver, code, I am not aware of any code flow where this c=
an
change before reaching here, because registration and unregistratio is done=
 only in driver load, unload and reload path.
Reload can happen only after devlink_reload_enable() is done.

> What are the rules for when devlink_net() changes?
>=20
devlink_net() changes only after unload() callback is completed in driver.
