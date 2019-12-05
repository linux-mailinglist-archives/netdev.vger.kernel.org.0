Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E719F114765
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 19:59:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729968AbfLES7m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 13:59:42 -0500
Received: from mail-eopbgr40078.outbound.protection.outlook.com ([40.107.4.78]:14413
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729417AbfLES7l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Dec 2019 13:59:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QVQ5KXfK7eApNxWXD/hVzWXOPb9sEmEG8ZNaRKFrCJdOqpikFspIBdCIolpUiILeXyY0eyJw8wXk8CHESH8Vqhx9BC/aGnufPZHhkgIiLnyXEFBNNzVz2X6zfvfx9Ndu8BdpK3zxlFu1DEZRQovNui5TuLnpiUHOHztnCB8l3kMzuq1gSdHp59PFzk+aqZrqwzYuwdxoF98dFcCkQDvY9F0ZlCCDqZzeXxsVbQE3ZezznXJIykFF7mCqXQYHHR88I7NthjpqS5lV0fcCVt/oAU7iIYLLWavQqQau/9st7DyjjikNl3OZYLjMlNwpDz8YSrcPXeR18E7BQjSmE95O5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fmOI+3jJ4JjEBsE+KWczx2X+oteuC5X3jE04rPyGqkI=;
 b=lWfqElbf07znwfKy9lIfECPnV/43KDWB2ogdHbnyQJsbvPcoPhBd+o9teK3OeVio3kLt6k4Oh4YuzE70oHr2lRzlC2mc1OftG64l8qM7ojOkC7gB/FWn/jDjE1xMaM+dWfeANBSEZRV5uOj22qk2ASEXcawNRfA67NndUwWd/lhw5AOyYx7CW+E/ckG+SFcBAmDkZTMtVlFYiPE7JGbGF4UDdXTNcK4G1hnc/SuDaAlprlQlffnrQuKWGcnmyHldKvI/yCim6Qcq5b+gcZLW2RTOCXAWCfAWKNJfU7gfREMEMJd8dqJPbRQm0kuaGL/3IfbD3r8kWKbqPufvsl4rPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fmOI+3jJ4JjEBsE+KWczx2X+oteuC5X3jE04rPyGqkI=;
 b=Lx/o9k/BFoRg8VaCPbOKdvPfYrV9nUZKRKGi/Fi4SyYEdoTxFWALeNn6aG9BFxHJ+TFpmSDdrUCOPe3GYy/+L5+IB/7RGFCfbF4l5q0HuQCLJbQ5aN1C92QCIO0waofHp9IcP9/7Erw3ezjyHaWJHuhhxbt0eAwkTKq+fM2aHOk=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB6516.eurprd05.prod.outlook.com (20.179.35.84) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.14; Thu, 5 Dec 2019 18:59:36 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::16:9951:5a4b:9ec6]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::16:9951:5a4b:9ec6%7]) with mapi id 15.20.2516.014; Thu, 5 Dec 2019
 18:59:36 +0000
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
Thread-Index: AQHViikX93ntAS7QxEa+ZUX9CByqKKeAQaYwgADEfoCAKW0u8IAA3JMAgADWE0A=
Date:   Thu, 5 Dec 2019 18:59:36 +0000
Message-ID: <AM0PR05MB4866C265B6C9D521A201609DD15C0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20191024050829.4517-1-zhenyuw@linux.intel.com>
 <AM0PR05MB4866CA9B70A8BEC1868AF8C8D1780@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191108081925.GH4196@zhen-hp.sh.intel.com>
 <AM0PR05MB4866757033043CC007B5C9CBD15D0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191205060618.GD4196@zhen-hp.sh.intel.com>
In-Reply-To: <20191205060618.GD4196@zhen-hp.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [208.176.44.194]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 15cb0892-87de-4ba2-dd57-08d779b5462c
x-ms-traffictypediagnostic: AM0PR05MB6516:|AM0PR05MB6516:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB6516FA542A76118B4C0BC140D15C0@AM0PR05MB6516.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 02426D11FE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(346002)(376002)(136003)(366004)(39860400002)(13464003)(189003)(199004)(25786009)(7696005)(99286004)(76176011)(11346002)(54906003)(186003)(316002)(4326008)(14444005)(478600001)(71190400001)(53546011)(71200400001)(14454004)(966005)(102836004)(6506007)(81156014)(66556008)(76116006)(66476007)(66946007)(66446008)(64756008)(8936002)(74316002)(33656002)(5660300002)(229853002)(55016002)(81166006)(9686003)(52536014)(8676002)(2906002)(305945005)(26005)(6916009)(86362001)(21314003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB6516;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dH8yGtEujExlENdPuahQ1ZmEBYvKt4PEH1dBc9nGjcYlpcHafKdO6oX85y2qsCQk77+mO0vj5juUgCxM3ogpniEGYStMOmrB91jALcq9WOKJTN0kttJD5ccCCzEAR8cB8q0YXK8TKEsevgQV6P0cc50qJwyk7xHjipoWTGq+kXaJ3lpoLTFkB4YhXosuK9jwr0xuoHBE70T3LVXyML5LqJc7eYIjW2cSlX2Mc5Uh0tpnS51feHqDeJooXcwhZlJs/9Wadui5TwmZ6MGwNWeBpJ4kEt7RXJULc2iTYZjkJ6KQ0KEIKa3DmEdEFuZ+YAyujhz61dJ+VzCGdXdcv7Yk8TaFMbtb7xsfnemraqfonHf8TbVIIFTr6yPizouxLnmVH1js0TKG3lg57YXUzIBU/fPn3jOuURvbbl9Sil01fIHs7322hIrtGKa+1TYAEeK5owb1AtzufWfqNwhKNyCXdclS/goeB0U0lDQ8FOPlFDJxme+GCXu+UsN4nCqeRqQRZbJt/ZEVKVfovcb1r9HORN5GR+wot7g1P1xQ5KUfJUU=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15cb0892-87de-4ba2-dd57-08d779b5462c
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Dec 2019 18:59:36.5583
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +MQAQ0LEN+O7Q1NVoBoOWOgkif0mSw98wwWbtXNYwo+X7zaiiH/enIs77lZBx64L1NCAp2OJ/oHkRhflwsLxPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6516
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> From: Zhenyu Wang <zhenyuw@linux.intel.com>
> Sent: Thursday, December 5, 2019 12:06 AM
> To: Parav Pandit <parav@mellanox.com>
>=20
> On 2019.12.04 17:36:12 +0000, Parav Pandit wrote:
> > + Jiri + Netdev since you mentioned netdev queue.
> >
> > + Jason Wang and Michael as we had similar discussion in vdpa discussio=
n
> thread.
> >
> > > From: Zhenyu Wang <zhenyuw@linux.intel.com>
> > > Sent: Friday, November 8, 2019 2:19 AM
> > > To: Parav Pandit <parav@mellanox.com>
> > >
> >
> > My apologies to reply late.
> > Something bad with my email client, due to which I found this patch und=
er
> spam folder today.
> > More comments below.
> >
> > > On 2019.11.07 20:37:49 +0000, Parav Pandit wrote:
> > > > Hi,
> > > >
> > > > > -----Original Message-----
> > > > > From: kvm-owner@vger.kernel.org <kvm-owner@vger.kernel.org> On
> > > > > Behalf Of Zhenyu Wang
> > > > > Sent: Thursday, October 24, 2019 12:08 AM
> > > > > To: kvm@vger.kernel.org
> > > > > Cc: alex.williamson@redhat.com; kwankhede@nvidia.com;
> > > > > kevin.tian@intel.com; cohuck@redhat.com
> > > > > Subject: [PATCH 0/6] VFIO mdev aggregated resources handling
> > > > >
> > > > > Hi,
> > > > >
> > > > > This is a refresh for previous send of this series. I got
> > > > > impression that some SIOV drivers would still deploy their own
> > > > > create and config method so stopped effort on this. But seems
> > > > > this would still be useful for some other SIOV driver which may
> > > > > simply want capability to aggregate resources. So here's refreshe=
d
> series.
> > > > >
> > > > > Current mdev device create interface depends on fixed mdev type,
> > > > > which get uuid from user to create instance of mdev device. If
> > > > > user wants to use customized number of resource for mdev device,
> > > > > then only can create new
> > > > Can you please give an example of 'resource'?
> > > > When I grep [1], [2] and [3], I couldn't find anything related to '
> aggregate'.
> > >
> > > The resource is vendor device specific, in SIOV spec there's ADI
> > > (Assignable Device Interface) definition which could be e.g queue
> > > for net device, context for gpu, etc. I just named this interface as
> 'aggregate'
> > > for aggregation purpose, it's not used in spec doc.
> > >
> >
> > Some 'unknown/undefined' vendor specific resource just doesn't work.
> > Orchestration tool doesn't know which resource and what/how to configur=
e
> for which vendor.
> > It has to be well defined.
> >
> > You can also find such discussion in recent lgpu DRM cgroup patches ser=
ies
> v4.
> >
> > Exposing networking resource configuration in non-net namespace aware
> mdev sysfs at PCI device level is no-go.
> > Adding per file NET_ADMIN or other checks is not the approach we follow=
 in
> kernel.
> >
> > devlink has been a subsystem though under net, that has very rich inter=
face
> for syscaller, device health, resource management and many more.
> > Even though it is used by net driver today, its written for generic dev=
ice
> management at bus/device level.
> >
> > Yuval has posted patches to manage PCI sub-devices [1] and updated vers=
ion
> will be posted soon which addresses comments.
> >
> > For any device slice resource management of mdev, sub-function etc, we
> should be using single kernel interface as devlink [2], [3].
> >
> > [1]
> > https://lore.kernel.org/netdev/1573229926-30040-1-git-send-email-yuval
> > av@mellanox.com/ [2]
> > http://man7.org/linux/man-pages/man8/devlink-dev.8.html
> > [3] http://man7.org/linux/man-pages/man8/devlink-resource.8.html
> >
> > Most modern device configuration that I am aware of is usually done via=
 well
> defined ioctl() of the subsystem (vhost, virtio, vfio, rdma, nvme and mor=
e) or
> via netlink commands (net, devlink, rdma and more) not via sysfs.
> >
>=20
> Current vfio/mdev configuration is via documented sysfs ABI instead of ot=
her
> ways. So this adhere to that way to introduce more configurable method on
> mdev device for standard, it's optional and not actually vendor specific =
e.g vfio-
> ap.
>=20
Some unknown/undefined resource as 'aggregate' is just not an ABI.
It has to be well defined, as 'hardware_address', 'num_netdev_sqs' or somet=
hing similar appropriate to that mdev device class.
If user wants to set a parameter for a mdev regardless of vendor, they must=
 have single way to do so.

> I'm not sure how many devices support devlink now, or if really make sens=
e to
> utilize devlink for other devices except net, or if really make sense to =
take
> mdev resource configuration from there...
>=20
This is about adding new knobs not the existing one.
It has to be well defined. 'aggregate' is not the word that describes it.
If this is something very device specific, it should be prefixed with 'misc=
_' something.. or it should be misc_X ioctl().
Miscellaneous not so well defined class of devices are usually registered u=
sing misc_register().
Similarly attributes has to be well defined, otherwise, it should fall unde=
r misc category specially when you are pointing to 3 well defined specifica=
tions.

> > >
> > > >
> > > > > mdev type for that which may not be flexible. This requirement
> > > > > comes not only from to be able to allocate flexible resources
> > > > > for KVMGT, but also from Intel scalable IO virtualization which
> > > > > would use vfio/mdev to be able to allocate arbitrary resources on=
 mdev
> instance.
> > > More info on [1] [2] [3].
> > > > >
> > > > > To allow to create user defined resources for mdev, it trys to
> > > > > extend mdev create interface by adding new "aggregate=3Dxxx"
> > > > > parameter following UUID, for target mdev type if aggregation is
> > > > > supported, it can create new mdev device which contains
> > > > > resources combined by number of instances, e.g
> > > > >
> > > > >     echo "<uuid>,aggregate=3D10" > create
> > > > >
> > > > > VM manager e.g libvirt can check mdev type with "aggregation"
> > > > > attribute which can support this setting. If no "aggregation"
> > > > > attribute found for mdev type, previous behavior is still kept
> > > > > for one instance allocation. And new sysfs attribute
> > > > > "aggregated_instances" is created for each mdev device to show
> > > > > allocated
> > > number.
> > > > >
> > > > > References:
> > > > > [1]
> > > > > https://software.intel.com/en-us/download/intel-virtualization-t
> > > > > echn
> > > > > ology- for-directed-io-architecture-specification
> > > > > [2]
> > > > > https://software.intel.com/en-us/download/intel-scalable-io-virt
> > > > > uali
> > > > > zation-
> > > > > technical-specification
> > > > > [3] https://schd.ws/hosted_files/lc32018/00/LC3-SIOV-final.pdf
> > > > >
> > > > > Zhenyu Wang (6):
> > > > >   vfio/mdev: Add new "aggregate" parameter for mdev create
> > > > >   vfio/mdev: Add "aggregation" attribute for supported mdev type
> > > > >   vfio/mdev: Add "aggregated_instances" attribute for supported m=
dev
> > > > >     device
> > > > >   Documentation/driver-api/vfio-mediated-device.rst: Update for
> > > > >     vfio/mdev aggregation support
> > > > >   Documentation/ABI/testing/sysfs-bus-vfio-mdev: Update for vfio/=
mdev
> > > > >     aggregation support
> > > > >   drm/i915/gvt: Add new type with aggregation support
> > > > >
> > > > >  Documentation/ABI/testing/sysfs-bus-vfio-mdev | 24 ++++++
> > > > >  .../driver-api/vfio-mediated-device.rst       | 23 ++++++
> > > > >  drivers/gpu/drm/i915/gvt/gvt.c                |  4 +-
> > > > >  drivers/gpu/drm/i915/gvt/gvt.h                | 11 ++-
> > > > >  drivers/gpu/drm/i915/gvt/kvmgt.c              | 53 ++++++++++++-
> > > > >  drivers/gpu/drm/i915/gvt/vgpu.c               | 56 ++++++++++++-
> > > > >  drivers/vfio/mdev/mdev_core.c                 | 36 ++++++++-
> > > > >  drivers/vfio/mdev/mdev_private.h              |  6 +-
> > > > >  drivers/vfio/mdev/mdev_sysfs.c                | 79 +++++++++++++=
+++++-
> > > > >  include/linux/mdev.h                          | 19 +++++
> > > > >  10 files changed, 294 insertions(+), 17 deletions(-)
> > > > >
> > > > > --
> > > > > 2.24.0.rc0
> > > >
> > >
> > > --
> > > Open Source Technology Center, Intel ltd.
> > >
> > > $gpg --keyserver wwwkeys.pgp.net --recv-keys 4D781827
>=20
> --
> Open Source Technology Center, Intel ltd.
>=20
> $gpg --keyserver wwwkeys.pgp.net --recv-keys 4D781827
