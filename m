Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC55293A2C
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 13:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393568AbgJTLl5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 07:41:57 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:21346 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393558AbgJTLl4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 07:41:56 -0400
Received: from HKMAIL102.nvidia.com (Not Verified[10.18.92.77]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f8ecd020000>; Tue, 20 Oct 2020 19:41:54 +0800
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HKMAIL102.nvidia.com
 (10.18.16.11) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 20 Oct
 2020 11:41:53 +0000
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.173)
 by HKMAIL101.nvidia.com (10.18.16.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 20 Oct 2020 11:41:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fIi8WziEI/doDuJWdZ3bqEJOWFtH/p+BF74Aso2eJLBrni3c+tHNnvOctBKft60XwIzCkkC8vu08K4syBzIu1BnkeKsX5JiQTQCIgHo73KSCz1pL1UyShwy5mDQa+ljqm5XTMNmGb8byj2HKorYt7vtFCGUuvrFf3PjifP43IUqKc0Jz8bAn+rc2RiOpJaH9QTw3vF2/Ki3rPTfCX/LfYcX8jViOkL/AEBWJZinwaweHPPYQ4WetkGIcJVM3EyVrlLKZedV98prB73VBUVuGDMIbKgp3haSVA0y8QcT1dnfplA2Rdu/NECFEEcZ0z4cUruP3UhaZFfX1MIOug7ua5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EVYNZ1ABLvax6Ktf+url3eG6mPsUlw5/ftiSpU9EzYU=;
 b=a+Iqo30Nact5zAZxRqw9jHeqCgIn7l7tdcRXaYXh+PqY/EaF1N5cvH2dmPYzxeSFC/yrCe95a3ymjeyMrH5Us0ncm6E0pyCC4i/VHzmtUs4vXIz4BDgmpeX+9RXl+IDtH4BIgpFitNGC4YZ4o8KsR7FBE4wHFVMiBKcVQEymP8AXL0f1kpfTtJPwrouvoqyqkkOob82c+/NRZYRysxzim+2nOPUmVbpdN7ZDnbEz6znF3frA3xnsHXqZ4Wuhpeg/5VTbMajSg4wqQIi8SeRURsHWQnnFV1dlcXRFXL9HJH1bdt9+i8Q+Lq+wPRTQmTvEo+34OXUiCvd7UYhsrHm8Sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BYAPR12MB3029.namprd12.prod.outlook.com (2603:10b6:a03:ab::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.25; Tue, 20 Oct
 2020 11:41:51 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::3c25:6e4c:d506:6105]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::3c25:6e4c:d506:6105%6]) with mapi id 15.20.3477.028; Tue, 20 Oct 2020
 11:41:51 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Parav Pandit <parav@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>
CC:     Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Michael Guralnik <michaelgur@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: RE: [PATCH rdma-rc] RDMA/mlx5: Fix devlink deadlock on net namespace
 deletion
Thread-Topic: [PATCH rdma-rc] RDMA/mlx5: Fix devlink deadlock on net namespace
 deletion
Thread-Index: AQHWpdiUyESckSXaE0yVQeBJxm0NBame5gGAgAABELCAAGGbAIAABjLQgAEQv7A=
Date:   Tue, 20 Oct 2020 11:41:50 +0000
Message-ID: <BY5PR12MB432287BF4E79E6F453881735DC1F0@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20201019052736.628909-1-leon@kernel.org>
 <20201019130751.GE6219@nvidia.com>
 <BY5PR12MB4322102A3DD0EC976FF317E7DC1E0@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20201019190100.GA6219@nvidia.com>
 <BY5PR12MB43223A907782D48862D82246DC1E0@BY5PR12MB4322.namprd12.prod.outlook.com>
In-Reply-To: <BY5PR12MB43223A907782D48862D82246DC1E0@BY5PR12MB4322.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.195.223]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 884748f9-c7f7-42ff-d173-08d874ed22a7
x-ms-traffictypediagnostic: BYAPR12MB3029:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB30293B80B71D2E0F96161BC6DC1F0@BYAPR12MB3029.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EsZy3rFKylFGQJgugRIVTASLDRZJgjfWs9LjnLAc/Lc1Cum8Mr69d8/UmDIbes7Pl5BchJRBz5WoEdbjkW3qrBgyRREHibqpzz7hzjksgIK4SpYZKqYFeWYc4MuxgAm4wMswYddMjyWsTPjHEbgwBVYH1Tjyw+S7iSX56oQyPx+VmVvXUdt2fSBPoBpcSi3pHc/xp4biEwl8VjO1hkOM54JuLbAaLPi8o77OSMfZ70syPlRFBcEYg9Jr8LNXePh58woI6MJcICHewPYmkWSjVqQUKi7vEbX/7DVvxhsmMBANrgy2LdmqiRXWo9Rg+ePzpVMDNNjJ9MhlBQLrr1EDUg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(376002)(39860400002)(136003)(396003)(71200400001)(2906002)(8936002)(66476007)(83380400001)(66946007)(86362001)(66556008)(66446008)(64756008)(52536014)(76116006)(55016002)(4326008)(107886003)(5660300002)(9686003)(8676002)(478600001)(54906003)(33656002)(316002)(186003)(6636002)(110136005)(26005)(55236004)(7696005)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: G5PNF2qUIIzYYNnCVgSysDASB+P4p/E0IHbJAQCxHFIwsRpzHDuMgwjDfFLPuY+OTISu3+jWPaMdVUh+kj1znCPVKY3US3vx7imFWaKI7gWbibOGUnY55e/uYYMpTUeebj9P01iVMrHmvXcpEIQFxFO9q6CqYle+G12wZjVHfPP3NzUD4lI69CFgnMx1AjQ1tXzZ71S98PCTEQUoc8cztt+0kvLy0XfrShlkWBsbVZP/LRSwK/LBlLEN5ell+7k6kkVfJDKHRSGEDWH0jtplTxP+PqUMKXe0Osqe2cGiXyEGXu7JrQlx1cirkDr5ae7B6fBdXUzxua3PZy3Yz9W/stVEsbXnF9FAsVxV82ghxSOF12H6CUPiPLISSKb6BpF3Qfh5oIH8Xx0Qyo8xWYqm9lpN7iV5eFH6nlxHf3i9HfGqrzXuIYguJAMuZlFtuLWGddlFlUO7x969wg8FdhXcYT+eVKTJZ+aw7lqnG0CMvSyMoaaTwLC5mfl1+FDWheRRdWqnwtSmQ5AMYhJADtk2NWrAeMD1hJWtmgb/K2MvAe/ojrOXp8lStsRCs7Ovo9l+QgAdFBAcGCvQsEXeUw9q9zHsbG5m3T/t2ujJ4TFdaUkZjaMa0Gu9mtyb666l/hCzHfN8JlvrNCqDCRUKlUDBGA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 884748f9-c7f7-42ff-d173-08d874ed22a7
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2020 11:41:50.8448
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tk/Cb9+uWSH6RMF9CmGi3DUI9DTLUqNaePBiLwr5tCVSKovkfnxjWRQPWDK4lUWKYyJtMxyy9GPVYGtbJZH4Qw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3029
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1603194114; bh=EVYNZ1ABLvax6Ktf+url3eG6mPsUlw5/ftiSpU9EzYU=;
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
        b=Sp/u22DZkar4kVl+s9VOMVMZSZNN+GHp9jYLD65F7EhBmrHJppwbxmdBIc3/4aZX+
         s7wyXNIcMSF0kZrhY85Z/vzaXPuwCaBaOB/M/0xUK74qSOlKMlW8dKtYH/Ik81UuvG
         wjWpRAPKU/oYZTN94/3s1y0gkkFW7IaJwcxgI4a8COFc+DjjWPtLac9JgSQKd3t8vc
         kGtRqlT+C0vhB8DTRoAvLuKL1GVl4O/lrL7xW/QQAFtYfh2Atv8xikF8kbGrgL9JTj
         zlLQQP0J26TtjqlVK4Z8a7aeeVlSEkGCKJHIBAp4EOxz45S8giXVuk/lAR604luX6f
         3MQwQw1n/N39g==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jason,

> From: Parav Pandit <parav@nvidia.com>
> Sent: Tuesday, October 20, 2020 12:57 AM
>=20
>=20
>=20
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Tuesday, October 20, 2020 12:31 AM
> >
> > On Mon, Oct 19, 2020 at 01:23:23PM +0000, Parav Pandit wrote:
> > > > > -	err =3D register_netdevice_notifier(&dev-
> >port[port_num].roce.nb);
> > > > > +	err =3D register_netdevice_notifier_net(mlx5_core_net(dev-
> >mdev),
> > > > > +					      &dev-
> >port[port_num].roce.nb);
> > > >
> > > > This looks racy, what lock needs to be held to keep
> > > > *mlx5_core_net()
> > stable?
> > >
> > > mlx5_core_net() cannot be accessed outside of mlx5 driver's load,
> > > unload,
> > reload path.
> > >
> > > When this is getting executed, devlink cannot be executing reload.
> > > This is guarded by devlink_reload_enable/disable calls done by mlx5 c=
ore.
> >
> > A comment that devlink_reload_enable/disable() must be held would be
> > helpful
> >
> Yes. will add.
>=20
> > > >
> > > > >  	if (err) {
> > > > >  		dev->port[port_num].roce.nb.notifier_call =3D NULL;
> > > > >  		return err;
> > > > > @@ -3335,7 +3336,8 @@ static int mlx5_add_netdev_notifier(struct
> > > > >mlx5_ib_dev *dev, u8 port_num)  static void
> > > > >mlx5_remove_netdev_notifier(struct mlx5_ib_dev *dev, u8
> port_num)
> > {
> > > > >  	if (dev->port[port_num].roce.nb.notifier_call) {
> > > > > -		unregister_netdevice_notifier(&dev-
> > > > >port[port_num].roce.nb);
> > > > > +
> 	unregister_netdevice_notifier_net(mlx5_core_net(dev-
> > > > >mdev),
> > > > > +						  &dev-
> > > > >port[port_num].roce.nb);
> > > >
> > > > This seems dangerous too, what if the mlx5_core_net changed before
> > > > we get here?
> > >
> > > When I inspected driver, code, I am not aware of any code flow where
> > > this can change before reaching here, because registration and
> > > unregistration is done only in driver load, unload and reload path.
> > > Reload can happen only after devlink_reload_enable() is done.
> >
> > But we enable reload right after init_one
> >
> > > > What are the rules for when devlink_net() changes?
> > > >
> > > devlink_net() changes only after unload() callback is completed in dr=
iver.
> >
> > You mean mlx5_devlink_reload_down ?
> >
> Right.
> > That seems OK then
> Ok. will work with Leon to add the comment.

Is below fix up ok?

commit 33cf8a09e735849f622e8084a7b08d421f11a4e1 (HEAD -> netns-del-fix)
Author: Parav Pandit <parav@nvidia.com>
Date:   Tue Oct 20 12:26:08 2020 +0300

    fixup: for RDMA/mlx5: Fix devlink deadlock on net namespace deletion

    Changelog:
    v0->v1:
     - Added kdoc comment description for the API usage and allowed context

    issue: 2230150
    Change-Id: Ibd233f771682c27565f48c54cd48fd87b0a7790f
    Signed-off-by: Parav Pandit <parav@nvidia.com>

diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 560b551d5ff8..3382855b7ef1 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1209,6 +1209,19 @@ static inline bool mlx5_is_roce_enabled(struct mlx5_=
core_dev *dev)
        return val.vbool;
 }

+/**
+ * mlx5_core_net - Provide net namespace of the mlx5_core_dev
+ * @dev: mlx5 core device
+ *
+ * mlx5_core_net() returns the net namespace of mlx5 core device.
+ * This can be called only in below described limited context.
+ * (a) When a devlink instance for mlx5_core is registered and
+ *     when devlink reload operation is disabled.
+ *     or
+ * (b) during devlink reload reload_down() and reload_up callbacks
+ *     where it is ensured that devlink instance's net namespace is
+ *     stable.
+ */
 static inline struct net *mlx5_core_net(struct mlx5_core_dev *dev)
 {
        return devlink_net(priv_to_devlink(dev));
