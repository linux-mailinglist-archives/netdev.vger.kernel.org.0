Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B631F7730
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 15:58:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726991AbfKKO6X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 09:58:23 -0500
Received: from mail-eopbgr50048.outbound.protection.outlook.com ([40.107.5.48]:16846
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726950AbfKKO6X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Nov 2019 09:58:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZKMQ0XdUgai5izGlL418g2pGG9pZ1IgZYc7N1N0pqsNJw8OUCLJCt3BEaqRFrr+iCzfgLyHm+MCjdlEIqsqChxekTmmdCjLe8ldJixsMfaxUxOLnzIk7gS+X0lObx/QXNMR+71JxMJ1QImTZJmfpZIqarAoats9ppB/ybU56asXr0tcHyoH1iOep9QHtMNZjIHIeZdqzcpdyYBz8l2yOQTdxS8b1MZJkjPz393cvOBx+JEiedMGOTe8VhL4CQVXsCC6WJrRHaCqVzYhoPYEs3UNqLUFihqFabCOVofYNDDbOmQ8rEIEYYBYrsJpnllBuEtTzBhkdg4P2+H7yKOItew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=35aFREQgVr4UNbqHF2MhcsyC8OUCCgltZ+ZbmIyutw4=;
 b=Krk0nKhJTWotF0kf/bwNWVOZ5Oogf1tUTsUkpx2u234/5t+IdLulRKPasShhW9djrKi7sFfOBSzvpWUsbQRGNyxaqkpvGNgiRZaYIXOorRS5vmF05hRzvRFVRloerWOpy/voNR3nyASqLaGM9ihTNFpDZE99K/SueX1q+Bf1msdKZ+Vtkx9ynojz6Xl8uxNgp/8Kti3i18d+V+kQ8eamWYjbLNKLltwPvtneLJLODFpiKMxdH9Rp4g7gJTkvMY4qXrsTbX2KhLm9gEaMxHcyr1CMarcsMO8+X8impNrq1wNTnxQuNaE6fsrecBgJnrJk/dYhlludb/nQawr0UjAGYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=35aFREQgVr4UNbqHF2MhcsyC8OUCCgltZ+ZbmIyutw4=;
 b=Y2r0beFg2Tvil5pA3a0B+f5UIeMA674KCNT7ucndO3Bm6PEO+yKFXmDU+/oMXSEVFMg5GGW8rYI5BOFgzCNYgMOuyEVe+PF0XP204LCGaDEp11t0RLLK0sw+WkzSJO67w1LeWAWoge7UMy1t+xb5r1hQbaumHQ6vLcd70QQYork=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB5938.eurprd05.prod.outlook.com (20.178.203.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Mon, 11 Nov 2019 14:58:18 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4%7]) with mapi id 15.20.2430.027; Mon, 11 Nov 2019
 14:58:18 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Jiri Pirko <jiri@resnulli.us>
CC:     Jason Gunthorpe <jgg@ziepe.ca>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        David M <david.m.ertman@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Or Gerlitz <gerlitz.or@gmail.com>,
        "Jason Wang (jasowang@redhat.com)" <jasowang@redhat.com>
Subject: RE: [PATCH net-next 00/19] Mellanox, mlx5 sub function support
Thread-Topic: [PATCH net-next 00/19] Mellanox, mlx5 sub function support
Thread-Index: AQHVlYUoVUzzBv4k4UmQHUerp08scaeAKe4AgAEGoYCAAClyAIAADgnAgAA94wCAABDWgIAABhCAgAAItYCAAAz4AIAABs2QgAAs4QCAAsNGMIABQQUAgAAKJkA=
Date:   Mon, 11 Nov 2019 14:58:18 +0000
Message-ID: <AM0PR05MB4866A5F11AED9ABA70FAE7EED1740@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20191108144054.GC10956@ziepe.ca>
 <AM0PR05MB486658D1D2A4F3999ED95D45D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191108111238.578f44f1@cakuba> <20191108201253.GE10956@ziepe.ca>
 <20191108133435.6dcc80bd@x1.home> <20191108210545.GG10956@ziepe.ca>
 <20191108145210.7ad6351c@x1.home>
 <AM0PR05MB4866444210721BC4EE775D27D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191109005708.GC31761@ziepe.ca>
 <AM0PR05MB48660E49342EC2CD6AB825F8D1750@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191111141732.GB2202@nanopsycho>
In-Reply-To: <20191111141732.GB2202@nanopsycho>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [2605:6000:ec82:1c00:dc64:8393:8e52:3370]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1a717c32-1ab0-44dc-54cc-08d766b79651
x-ms-traffictypediagnostic: AM0PR05MB5938:|AM0PR05MB5938:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB5938466A84A8071D1891AE69D1740@AM0PR05MB5938.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0218A015FA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(366004)(346002)(39860400002)(396003)(136003)(199004)(189003)(13464003)(25786009)(7416002)(476003)(11346002)(81156014)(81166006)(66446008)(66476007)(66946007)(76116006)(64756008)(2906002)(66556008)(446003)(8676002)(33656002)(478600001)(6506007)(7696005)(6916009)(256004)(52536014)(14454004)(8936002)(76176011)(486006)(102836004)(5660300002)(55016002)(186003)(74316002)(46003)(7736002)(99286004)(316002)(9686003)(54906003)(305945005)(6436002)(229853002)(71190400001)(71200400001)(4326008)(6246003)(86362001)(6116002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB5938;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: u5NFPrOYm1zAjSLJ251t6dQbIacP3kX2tJSorXeNaJ3BHrsqMet/JsRMSdq06iVrYZGC9SweoMf+2CioGhgPx4pmcT+YxTN50ZlQNcM5rArX854tAE+bvLSHZVaKsMwyedr7QcxzBx6izopUlq67wD6jdjTAo2LeIJrbRFk2dHQOKdQeb9+BucU48Zhjoonm3RXTa6m+axIG1YgoHOGxn/80Z+6zH7keCnoT/wbDwLR1woze/BnQ8zPZZj4DRz6Ts9bUt2E37HtVzRVyvlI+ffUkjzOyR+lcQhY85IXoM74RjvI5hyZFxEVsfllz1U9S163HRuFAjpwq2PO3Gk/qzJOiy3XUq+5e4GNK+0yHLGGiRACO97SZvHpTatYBwCICd9Q9moiLXqGxs38SD1Qig3RDrrIaXg0e9A3RWkPrfxVt3/DJsWAk1O18nKtgmxJ2
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a717c32-1ab0-44dc-54cc-08d766b79651
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2019 14:58:18.2305
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PjJben4datm2ZvkCusgnsWjUhZ4cWYRKk6kVyWVJPZRttQAb1mh8aJR5mUFc3hzk06Eo19qE5Y/Pu3+HJ8GXWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5938
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jiri Pirko <jiri@resnulli.us>
> Sent: Monday, November 11, 2019 8:18 AM
> Sun, Nov 10, 2019 at 08:48:31PM CET, parav@mellanox.com wrote:
> >
> >> From: Jason Gunthorpe <jgg@ziepe.ca>
> >> Sent: Friday, November 8, 2019 6:57 PM
> >> > We should be creating 3 different buses, instead of mdev bus being
> >> > de-
> >> multiplexer of that?
> >> >
> >> > Hence, depending the device flavour specified, create such device
> >> > on right
> >> bus?
> >> >
> >> > For example,
> >> > $ devlink create subdev pci/0000:05:00.0 flavour virtio name foo
> >> > subdev_id 1 $ devlink create subdev pci/0000:05:00.0 flavour mdev
> >> > <uuid> subdev_id 2 $ devlink create subdev pci/0000:05:00.0 flavour
> >> > mlx5 id 1 subdev_id 3
> >>
> >> I like the idea of specifying what kind of interface you want at sub
> >> device creation time. It fits the driver model pretty well and
> >> doesn't require abusing the vfio mdev for binding to a netdev driver.
> >>
> >> > $ devlink subdev pci/0000:05:00.0/<subdev_id> config <params> $
> >> > echo <respective_device_id> <sysfs_path>/bind
> >>
> >> Is explicit binding really needed?
> >No.
> >
> >> If you specify a vfio flavour why shouldn't the vfio driver autoload
> >> and bind to it right away? That is kind of the point of the driver
> >> model...
> >>
> >It some configuration is needed that cannot be passed at device creation
> time, explicit bind later can be used.
> >
> >> (kind of related, but I don't get while all that GUID and lifecycle
> >> stuff in mdev should apply for something like a SF)
> >>
> >GUID is just the name of the device.
> >But lets park this aside for a moment.
> >
> >> > Implement power management callbacks also on all above 3 buses?
> >> > Abstract out mlx5_bus into more generic virtual bus (vdev bus?) so
> >> > that multiple vendors can reuse?
> >>
> >> In this specific case, why does the SF in mlx5 mode even need a bus?
> >> Is it only because of devlink? That would be unfortunate
> >>
> >Devlink is one part due to identifying using bus/dev.
> >How do we refer to its devlink instance of SF without bus/device?
>=20
> Question is, why to have devlink instance for SF itself. Same as VF, you =
don't
mlx5_core has devlink instance for PF and VF for long time now.
Health report, txq/rxq dumps etc all anchored to this devlink instance even=
 for VF. (similar to PF).
And so, SF same framework should work for SF.

> need devlink instance. You only need devlink_port (or
> devlink_subdev) instance on the PF devlink parent for it.
>=20
Devlink_port or devlink_subdev are still on eswitch or mgmt side.
They are not present on the side where devlink instance exist on side where=
 txq/rxq/eq etc exist.

