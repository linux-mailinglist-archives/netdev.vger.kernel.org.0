Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7706D1130EA
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 18:38:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728065AbfLDRiD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 12:38:03 -0500
Received: from mail-eopbgr80081.outbound.protection.outlook.com ([40.107.8.81]:45693
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726934AbfLDRiD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Dec 2019 12:38:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gV3AyiSqiKvgdJKSwSKG3bX6tOgQld+yhWn6JncPpjhi/Mfaq95RT0KsnaV63+zEmw1iGSK32yfXSBxq2UPvtEi7egvSbdolRR0KAEaq32ii+5We20PgrhS5f1BgrHGG4GphOs57EmGBr5Kpse7pNxyV9+MObtnxdYQThAgw6riH87Sgm/8lIZw/tS8dNHS31n5ASTjCqANz47u7wiZBgDght/gq397KMjY17z8D9CQIZjpsvB6vNxx6j1V73CyZk/8Ss8ffNO1fM2pRR+9+RFhII4wa6TCdBpMChCq+JkyK3mPCYOyUv5QUXmiYUltnMv5MxehVkWrESNKtCA9ckA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mi7Turn64v8yzcVNQ/vh4qCJq/Gh6AGYltjMOep9X4E=;
 b=Um2ECD86F/rYtwN2G7KWULcWLhjojmHipW3PJx+E/a7BH3UUyBT8cFPG8oQiDeEo5EM+2E+/L1VgzQYhsYLhtVkKNeN+6mxs6pG2oj+3Vx7xfsMMSinTOTCtEqcAye9+mLeX+cHuRsdDNsSdxGM0IjX8SMT2rwsP4E6sPz8FnqySYz7bYvmpvRi+U1xEUsKBy01M68OBUsU9eP3lij2ThTmR12n718gRx/1O5Ad4aJGSE2bJ4BuTj13kBjjDvtnl/veJapLE9rcXemI7KvmJxWPkuTX5sZzvjSdBRGqz5FsTau26pqL9cnwKQBM+Gxth481P4dBo/Nj/la7fg6Vklg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mi7Turn64v8yzcVNQ/vh4qCJq/Gh6AGYltjMOep9X4E=;
 b=qKANXMbJlRYgYxc0cE71WDzseRR/ZAgAwU0IADymDnWdbIn1eZLZjOKuHjbCz/H+y+tyX8dQlVhn4wUuLAW8BggLeTfEGbCmEGl0NjwQxnwErkMAi38mcZj8lfI6+59sXak2SmmWMXN3OlXqPbEKAoWelf+gJhGAClSBHEXih4A=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB4850.eurprd05.prod.outlook.com (20.177.41.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.21; Wed, 4 Dec 2019 17:36:13 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::16:9951:5a4b:9ec6]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::16:9951:5a4b:9ec6%7]) with mapi id 15.20.2495.014; Wed, 4 Dec 2019
 17:36:13 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Zhenyu Wang <zhenyuw@linux.intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: RE: [PATCH 0/6] VFIO mdev aggregated resources handling
Thread-Topic: [PATCH 0/6] VFIO mdev aggregated resources handling
Thread-Index: AQHViikX93ntAS7QxEa+ZUX9CByqKKeAQaYwgADEfoCAKW0u8A==
Date:   Wed, 4 Dec 2019 17:36:12 +0000
Message-ID: <AM0PR05MB4866757033043CC007B5C9CBD15D0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20191024050829.4517-1-zhenyuw@linux.intel.com>
 <AM0PR05MB4866CA9B70A8BEC1868AF8C8D1780@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191108081925.GH4196@zhen-hp.sh.intel.com>
In-Reply-To: <20191108081925.GH4196@zhen-hp.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [208.176.44.194]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: bbed7904-17c4-49bc-287c-08d778e07541
x-ms-traffictypediagnostic: AM0PR05MB4850:|AM0PR05MB4850:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB4850FDEDDF7C9CA10B1DF515D15D0@AM0PR05MB4850.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0241D5F98C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(39860400002)(366004)(136003)(346002)(13464003)(189003)(199004)(8676002)(9686003)(76176011)(6246003)(6506007)(6306002)(74316002)(54906003)(26005)(6436002)(229853002)(81156014)(53546011)(55016002)(7696005)(102836004)(25786009)(6116002)(14444005)(66446008)(186003)(76116006)(14454004)(81166006)(4326008)(8936002)(99286004)(316002)(66946007)(71190400001)(71200400001)(5660300002)(305945005)(6916009)(7736002)(33656002)(64756008)(66476007)(66556008)(478600001)(2906002)(86362001)(52536014)(966005)(3846002)(11346002)(21314003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4850;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tXFfFaKOMrRDM4zpCzw+qSpxjPH/lKndabKG4hID6q9jSTBn9qgmr2oerqmH2vAnDOeR1dDuQuCZx4QwscEywO9dSXEg2pQB2gz4V6wWw2/PvUqOhW0yBUW7EwZS/hfakEpP45JtiCngJbw+295zudggtAIUE2kdM2g5ekGMuUs+v/9nDDewzWenQwPXiTUwM8AWAyXtLxsrNcH93JaHaDSwNuTleZR2m3qJMa811YM0/vsYJZwKA/Qo2x7C7BUcOOuQLSoFtNSK0kLEDI852mG22pe7a5l0vXmiqTEdcNOm3NoQJq5GgBYgPIjozQlTrOUD6fTIVSpXUHCO7t+b3xg65Gv1ggDCDQtCUwr6bbJqXKvFr+DIZD260Ho6fWXk06UamxAXG7CbgiTPJPJkp7G9XanQLcQep6yX11iqpAo+/Pco/Iifvjr5yG2Fpi1OcXgQlj0e3qMh3yvoqts+5YFvUOU2dMm33uLyFAy2MvnOLx1TA43U0jfHjttgOIC2LbgtnyCR5tg3VRzOM5z+uZA2af0UwX84oEFyW+0dEMk=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbed7904-17c4-49bc-287c-08d778e07541
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2019 17:36:13.0097
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /nT8MD+n/cf1GmonYP1mi9UevDuqRnNy5fvb8xK06gTXbQtKQgwfnRTre4fx5ZvX1j/3yq4GD62NuQCnXbTUng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4850
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+ Jiri + Netdev since you mentioned netdev queue.

+ Jason Wang and Michael as we had similar discussion in vdpa discussion th=
read.

> From: Zhenyu Wang <zhenyuw@linux.intel.com>
> Sent: Friday, November 8, 2019 2:19 AM
> To: Parav Pandit <parav@mellanox.com>
>=20

My apologies to reply late.
Something bad with my email client, due to which I found this patch under s=
pam folder today.
More comments below.

> On 2019.11.07 20:37:49 +0000, Parav Pandit wrote:
> > Hi,
> >
> > > -----Original Message-----
> > > From: kvm-owner@vger.kernel.org <kvm-owner@vger.kernel.org> On
> > > Behalf Of Zhenyu Wang
> > > Sent: Thursday, October 24, 2019 12:08 AM
> > > To: kvm@vger.kernel.org
> > > Cc: alex.williamson@redhat.com; kwankhede@nvidia.com;
> > > kevin.tian@intel.com; cohuck@redhat.com
> > > Subject: [PATCH 0/6] VFIO mdev aggregated resources handling
> > >
> > > Hi,
> > >
> > > This is a refresh for previous send of this series. I got impression
> > > that some SIOV drivers would still deploy their own create and
> > > config method so stopped effort on this. But seems this would still
> > > be useful for some other SIOV driver which may simply want
> > > capability to aggregate resources. So here's refreshed series.
> > >
> > > Current mdev device create interface depends on fixed mdev type,
> > > which get uuid from user to create instance of mdev device. If user
> > > wants to use customized number of resource for mdev device, then
> > > only can create new
> > Can you please give an example of 'resource'?
> > When I grep [1], [2] and [3], I couldn't find anything related to ' agg=
regate'.
>=20
> The resource is vendor device specific, in SIOV spec there's ADI (Assigna=
ble
> Device Interface) definition which could be e.g queue for net device, con=
text
> for gpu, etc. I just named this interface as 'aggregate'
> for aggregation purpose, it's not used in spec doc.
>=20

Some 'unknown/undefined' vendor specific resource just doesn't work.
Orchestration tool doesn't know which resource and what/how to configure fo=
r which vendor.
It has to be well defined.

You can also find such discussion in recent lgpu DRM cgroup patches series =
v4.

Exposing networking resource configuration in non-net namespace aware mdev =
sysfs at PCI device level is no-go.
Adding per file NET_ADMIN or other checks is not the approach we follow in =
kernel.

devlink has been a subsystem though under net, that has very rich interface=
 for syscaller, device health, resource management and many more.
Even though it is used by net driver today, its written for generic device =
management at bus/device level.

Yuval has posted patches to manage PCI sub-devices [1] and updated version =
will be posted soon which addresses comments.

For any device slice resource management of mdev, sub-function etc, we shou=
ld be using single kernel interface as devlink [2], [3].

[1] https://lore.kernel.org/netdev/1573229926-30040-1-git-send-email-yuvala=
v@mellanox.com/
[2] http://man7.org/linux/man-pages/man8/devlink-dev.8.html
[3] http://man7.org/linux/man-pages/man8/devlink-resource.8.html

Most modern device configuration that I am aware of is usually done via wel=
l defined ioctl() of the subsystem (vhost, virtio, vfio, rdma, nvme and mor=
e) or via netlink commands (net, devlink, rdma and more) not via sysfs.

> Thanks
>=20
> >
> > > mdev type for that which may not be flexible. This requirement comes
> > > not only from to be able to allocate flexible resources for KVMGT,
> > > but also from Intel scalable IO virtualization which would use
> > > vfio/mdev to be able to allocate arbitrary resources on mdev instance=
.
> More info on [1] [2] [3].
> > >
> > > To allow to create user defined resources for mdev, it trys to
> > > extend mdev create interface by adding new "aggregate=3Dxxx" paramete=
r
> > > following UUID, for target mdev type if aggregation is supported, it
> > > can create new mdev device which contains resources combined by
> > > number of instances, e.g
> > >
> > >     echo "<uuid>,aggregate=3D10" > create
> > >
> > > VM manager e.g libvirt can check mdev type with "aggregation"
> > > attribute which can support this setting. If no "aggregation"
> > > attribute found for mdev type, previous behavior is still kept for
> > > one instance allocation. And new sysfs attribute
> > > "aggregated_instances" is created for each mdev device to show alloca=
ted
> number.
> > >
> > > References:
> > > [1]
> > > https://software.intel.com/en-us/download/intel-virtualization-techn
> > > ology- for-directed-io-architecture-specification
> > > [2]
> > > https://software.intel.com/en-us/download/intel-scalable-io-virtuali
> > > zation-
> > > technical-specification
> > > [3] https://schd.ws/hosted_files/lc32018/00/LC3-SIOV-final.pdf
> > >
> > > Zhenyu Wang (6):
> > >   vfio/mdev: Add new "aggregate" parameter for mdev create
> > >   vfio/mdev: Add "aggregation" attribute for supported mdev type
> > >   vfio/mdev: Add "aggregated_instances" attribute for supported mdev
> > >     device
> > >   Documentation/driver-api/vfio-mediated-device.rst: Update for
> > >     vfio/mdev aggregation support
> > >   Documentation/ABI/testing/sysfs-bus-vfio-mdev: Update for vfio/mdev
> > >     aggregation support
> > >   drm/i915/gvt: Add new type with aggregation support
> > >
> > >  Documentation/ABI/testing/sysfs-bus-vfio-mdev | 24 ++++++
> > >  .../driver-api/vfio-mediated-device.rst       | 23 ++++++
> > >  drivers/gpu/drm/i915/gvt/gvt.c                |  4 +-
> > >  drivers/gpu/drm/i915/gvt/gvt.h                | 11 ++-
> > >  drivers/gpu/drm/i915/gvt/kvmgt.c              | 53 ++++++++++++-
> > >  drivers/gpu/drm/i915/gvt/vgpu.c               | 56 ++++++++++++-
> > >  drivers/vfio/mdev/mdev_core.c                 | 36 ++++++++-
> > >  drivers/vfio/mdev/mdev_private.h              |  6 +-
> > >  drivers/vfio/mdev/mdev_sysfs.c                | 79 +++++++++++++++++=
+-
> > >  include/linux/mdev.h                          | 19 +++++
> > >  10 files changed, 294 insertions(+), 17 deletions(-)
> > >
> > > --
> > > 2.24.0.rc0
> >
>=20
> --
> Open Source Technology Center, Intel ltd.
>=20
> $gpg --keyserver wwwkeys.pgp.net --recv-keys 4D781827
