Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8189B01CD
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 18:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729203AbfIKQke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 12:40:34 -0400
Received: from mail-eopbgr130045.outbound.protection.outlook.com ([40.107.13.45]:19938
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728794AbfIKQke (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Sep 2019 12:40:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I+ko8AggwGvNInEXoWOvqefVR9guaUtvViNSq0heQCf+1M+MVx+RARWI0msVrRFbf8bnkqC1MVsr4WbSqDC/5bYm2R85PnDmQjlUuFVmdV0ruTwFuchhH5+2mDZkN9JYSonblsDzBWrp3v7/dC5AjPWyu3QUhUM+XRMecH5bVewbnIOh6n1oB2CA76h6qR7ITdJKtCGNV/dz0XvA7j13dGm4icAvMax/WlAM+XyRCNi67h6H1NrT0yvL0Cv4JM8AmvdTZMyoi4e9qZUhWp1X2YqBhW77bNBClpP4D6EA032PNfht6pDDsodFdIC5EvnckJm5yNVaM05/d9jZ1sdm7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gKs8tz1Ilj5YSp6Cr+wPxtHLLXOVeI+umVS1qr6dcCY=;
 b=FaPMKMfJxCzI3t09yL2phtecl2ihpCkF32lVIiGp/+CmFmklUKOPnEaR2RWUEbq1i44DEkbJk1XxF8t3MmG52rUv5IicGZXzzE4sccAFgAVbqHpi6RCJJqmZs5uKB6EXuL/pn5RWO7xnYmxKyRtpYIElMX3jtsrqLZ+yvYQMftWdRn1GBRC250B8O9dspFXemDtNncNnTguGK75fPOAS5PpdQgjDEcj6NaM2LBK63ijsX601PyUuixaHDp1ebOnvqYmEQ8npZG/qkW0umi0nOSltfXz/tfmV1bYhWV7cHMr6n8/qtLOMKyULoKcr64ZD97FZLG3rLc6IXmSPbZ3BqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gKs8tz1Ilj5YSp6Cr+wPxtHLLXOVeI+umVS1qr6dcCY=;
 b=W7fFHP1i5GMEshfHN6LlX9epKcq3WdLMVZ3jioyedKLp4xLJ3e3G778Dhyqe+B7I0eAV0UVsCrsou6buJt3eLuHUJkfuhWLg0omPpUXo+8u10ciIKqK08c7EbFaiiISxWaBHUt3oGNwRMVNqtOsF+vU1uIFLEM00I3v6rlignJg=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB6129.eurprd05.prod.outlook.com (20.178.117.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.20; Wed, 11 Sep 2019 16:38:49 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::bc4c:7c4c:d3e2:8b28]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::bc4c:7c4c:d3e2:8b28%6]) with mapi id 15.20.2241.018; Wed, 11 Sep 2019
 16:38:49 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Parav Pandit <parav@mellanox.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     Jiri Pirko <jiri@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v3 0/5] Introduce variable length mdev alias
Thread-Topic: [PATCH v3 0/5] Introduce variable length mdev alias
Thread-Index: AQHVYUZdAS6KYIr8SUO1vQ8myuXcNacjy68wgALDGQCAABfpQIAAEvsA
Date:   Wed, 11 Sep 2019 16:38:49 +0000
Message-ID: <AM0PR05MB48667E374853D485788D8159D1B10@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190826204119.54386-1-parav@mellanox.com>
        <20190902042436.23294-1-parav@mellanox.com>
        <AM0PR05MB4866F76F807409ED887537D7D1B70@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190911145610.453b32ec@x1.home>
 <AM0PR05MB48668DFF8E816F0D2D3041BFD1B10@AM0PR05MB4866.eurprd05.prod.outlook.com>
In-Reply-To: <AM0PR05MB48668DFF8E816F0D2D3041BFD1B10@AM0PR05MB4866.eurprd05.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [208.176.44.194]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 00ec339f-cacd-449b-e11e-08d736d685e6
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB6129;
x-ms-traffictypediagnostic: AM0PR05MB6129:|AM0PR05MB6129:
x-ms-exchange-purlcount: 4
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB6129A38C71988C208F2E679BD1B10@AM0PR05MB6129.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0157DEB61B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(39860400002)(366004)(346002)(376002)(13464003)(54534003)(189003)(199004)(256004)(229853002)(2940100002)(11346002)(446003)(74316002)(76176011)(81166006)(6436002)(7736002)(53546011)(102836004)(76116006)(8676002)(8936002)(966005)(81156014)(110136005)(478600001)(54906003)(71200400001)(71190400001)(14444005)(6506007)(305945005)(14454004)(316002)(99286004)(86362001)(66946007)(52536014)(66476007)(66556008)(64756008)(66446008)(55016002)(7696005)(5660300002)(3846002)(2906002)(6116002)(4326008)(476003)(66066001)(53936002)(186003)(6246003)(53376002)(9686003)(6306002)(486006)(33656002)(26005)(25786009);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB6129;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 40Y1SuZyZgBfow1zPJKsIDjK8+IJ+KxBWcxw8ZVzKwrRAomDAwIyYsYnCKjgsZ580OTAzCXhCNk/XXcU9zvGrHdCsCV19+tTPg3JjIndhT5djuCGFUJ0piZysOnr75je/vKFirXxnkavZFCz8I+l6f/7YhRQicUoGspAtGbb8Qqu4+5+OQWDkcyFLw1ZeehkwOyAr9lq1Gva4fWQT0qIrDm/PuOCp6jIBaFXVBpvdVuux5SIAW1CMR7Lo23zvVH3PWRfC6iwIC35PlaELTS/typfXeraYkEZ4hSXk8Upw596HF3BxgIRLNzs767uprcINk2xewmZBygPgq5+Q267OlgpfVTjuHcqXA4pQJlBcPW68xnV7lv/v9OUwrqek22gQJc7vvFZnD4JoM0FjkiQaJJm4XZbrzc8IHSYhhObaUc=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00ec339f-cacd-449b-e11e-08d736d685e6
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2019 16:38:49.2856
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 754g59yC8m3Qdoo1fKZTCX/ZLdQ/5B2AXw2Po1NNNonty2DHUfJ5pfv512urUVypzpt7RZvzorpP3VguugeHzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6129
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org <linux-kernel-
> owner@vger.kernel.org> On Behalf Of Parav Pandit
> Sent: Wednesday, September 11, 2019 10:31 AM
> To: Alex Williamson <alex.williamson@redhat.com>
> Cc: Jiri Pirko <jiri@mellanox.com>; kwankhede@nvidia.com;
> cohuck@redhat.com; davem@davemloft.net; kvm@vger.kernel.org; linux-
> kernel@vger.kernel.org; netdev@vger.kernel.org
> Subject: RE: [PATCH v3 0/5] Introduce variable length mdev alias
>=20
> Hi Alex,
>=20
> > -----Original Message-----
> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Wednesday, September 11, 2019 8:56 AM
> > To: Parav Pandit <parav@mellanox.com>
> > Cc: Jiri Pirko <jiri@mellanox.com>; kwankhede@nvidia.com;
> > cohuck@redhat.com; davem@davemloft.net; kvm@vger.kernel.org; linux-
> > kernel@vger.kernel.org; netdev@vger.kernel.org
> > Subject: Re: [PATCH v3 0/5] Introduce variable length mdev alias
> >
> > On Mon, 9 Sep 2019 20:42:32 +0000
> > Parav Pandit <parav@mellanox.com> wrote:
> >
> > > Hi Alex,
> > >
> > > > -----Original Message-----
> > > > From: Parav Pandit <parav@mellanox.com>
> > > > Sent: Sunday, September 1, 2019 11:25 PM
> > > > To: alex.williamson@redhat.com; Jiri Pirko <jiri@mellanox.com>;
> > > > kwankhede@nvidia.com; cohuck@redhat.com; davem@davemloft.net
> > > > Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> > > > netdev@vger.kernel.org; Parav Pandit <parav@mellanox.com>
> > > > Subject: [PATCH v3 0/5] Introduce variable length mdev alias
> > > >
> > > > To have consistent naming for the netdevice of a mdev and to have
> > > > consistent naming of the devlink port [1] of a mdev, which is
> > > > formed using phys_port_name of the devlink port, current UUID is
> > > > not usable because UUID is too long.
> > > >
> > > > UUID in string format is 36-characters long and in binary 128-bit.
> > > > Both formats are not able to fit within 15 characters limit of
> > > > netdev
> > name.
> > > >
> > > > It is desired to have mdev device naming consistent using UUID.
> > > > So that widely used user space framework such as ovs [2] can make
> > > > use of mdev representor in similar way as PCIe SR-IOV VF and PF
> > representors.
> > > >
> > > > Hence,
> > > > (a) mdev alias is created which is derived using sha1 from the
> > > > mdev
> > name.
> > > > (b) Vendor driver describes how long an alias should be for the
> > > > child mdev created for a given parent.
> > > > (c) Mdev aliases are unique at system level.
> > > > (d) alias is created optionally whenever parent requested.
> > > > This ensures that non networking mdev parents can function without
> > > > alias creation overhead.
> > > >
> > > > This design is discussed at [3].
> > > >
> > > > An example systemd/udev extension will have,
> > > >
> > > > 1. netdev name created using mdev alias available in sysfs.
> > > >
> > > > mdev UUID=3D83b8f4f2-509f-382f-3c1e-e6bfe0fa1001
> > > > mdev 12 character alias=3Dcd5b146a80a5
> > > >
> > > > netdev name of this mdev =3D enmcd5b146a80a5 Here en =3D Ethernet l=
ink
> > > > m =3D mediated device
> > > >
> > > > 2. devlink port phys_port_name created using mdev alias.
> > > > devlink phys_port_name=3Dpcd5b146a80a5
> > > >
> > > > This patchset enables mdev core to maintain unique alias for a mdev=
.
> > > >
> > > > Patch-1 Introduces mdev alias using sha1.
> > > > Patch-2 Ensures that mdev alias is unique in a system.
> > > > Patch-3 Exposes mdev alias in a sysfs hirerchy, update
> > > > Documentation
> > > > Patch-4 Introduces mdev_alias() API.
> > > > Patch-5 Extends mtty driver to optionally provide alias generation.
> > > > This also enables to test UUID based sha1 collision and trigger
> > > > error handling for duplicate sha1 results.
> > > >
> > > > [1] http://man7.org/linux/man-pages/man8/devlink-port.8.html
> > > > [2] https://docs.openstack.org/os-vif/latest/user/plugins/ovs.html
> > > > [3] https://patchwork.kernel.org/cover/11084231/
> > > >
> > > > ---
> > > > Changelog:
> > > > v2->v3:
> > > >  - Addressed comment from Yunsheng Lin
> > > >  - Changed strcmp() =3D=3D0 to !strcmp()
> > > >  - Addressed comment from Cornelia Hunk
> > > >  - Merged sysfs Documentation patch with syfs patch
> > > >  - Added more description for alias return value
> > >
> > > Did you get a chance review this updated series?
> > > I addressed Cornelia's and yours comment.
> > > I do not think allocating alias memory twice, once for comparison
> > > and once for storing is good idea or moving alias generation logic
> > > inside the mdev_list_lock(). So I didn't address that suggestion of
> Cornelia.
> >
> > Sorry, I'm at LPC this week.  I agree, I don't think the double
> > allocation is necessary, I thought the comment was sufficient to
> > clarify null'ing the variable.  It's awkward, but seems correct.
> >
> > I'm not sure what we do with this patch series though, has the real
> > consumer of this even been proposed? =20

Jiri already acked to use mdev_alias() to generate phys_port_name several d=
ays back in the discussion we had in [1].
After concluding in the thread [1], I proceed with mdev_alias().
mlx5_core patches are not yet present on netdev mailing list, but we all ag=
ree to use it in mdev_alias() in devlink phys_port_name generation.
So we have collective agreement on how to proceed forward.
I wasn't probably clear enough in previous email reply about it, so adding =
link here.

[1] https://patchwork.kernel.org/cover/11084231/#22838955

> It feels optimistic to include
> > at this point.  We've used the sample driver as a placeholder in the
> > past for mdev_uuid(), but we arrived at that via a conversion rather
> > than explicitly adding the API.  Please let me know where the consumer
> > patches stand, perhaps it would make more sense for them to go in
> > together rather than risk adding an unused API.  Thanks,
> >
> Given that consumer patch series is relatively large (around 15+ patches)=
, I
> was considering to merge this one as pre-series to it.
> Its ok to combine this with consumer patch series.
> But wanted to have it reviewed beforehand, so that churn is less in actua=
l
> consumer series which is more mlx5_core and devlink/netdev centric.
> So if you can add Review-by, it will be easier to combine with consumer
> series.
>=20
> And if we merge it with consumer series, it will come through Dave Miller=
's
> tree instead of your tree.
> Would that work for you?
