Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B8029E679
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 13:09:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729370AbfH0LJF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 07:09:05 -0400
Received: from mail-eopbgr30057.outbound.protection.outlook.com ([40.107.3.57]:31236
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725912AbfH0LJF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 07:09:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WCO79oRXggdLtXx6li6RTqu7QDGBtlB2L7oegMRU1Wp2ZWiGfVKgZytVv0mXbFiOM21lcXC6QbLoafZ9xQ8SaSsabtHa/CrhfZcxP5pf1JDJURfd58T/iQQ4y2mXtNXETVlsUsSsUcytFWazDBn0MC+7+ySXwn6znmcQYy6z9nSHMHk7EStOneAhjaSUK9TnswojFKVt1xwzIfPJ126sc+0be7yjvH+Tmpie/eIuDyEWecHOk/FVy/1hRo1FAWuMdLzKJn0GUrcFV3Uv3r4LnFeq9vGzAmH7i0AfKggmHOytppSRgvTg1OBCPRiLkiFRO75FzeZx7JyXxxMxpH89nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Gz20VflWbpO8MToyd1ah/SOCTMl1npVpMUielPSOcQ=;
 b=ns9IOMYL8EZ9IHHj4WrRVBLdrH8dNSnQgUxRdZH5EGtx74T9n3wQvuZWW9oESgqI8FGWj3/X4u+1eD/gzrLwrugKa66QGJ16ByCn4y141CXVNdH6Rb6gdPgRUWcxvcZ555FK36xEGphW6UNV6HvDlKJ6NaV0QtWwcnEUvWo9s72vpYUDjcQrAhD0McVvK6HNDcx2Y5YYrA6Y2JQqGpPp5XyVnVgwPanP+v/649QXxxtfvNc3MuIblSXsene6Ov21n399dMx2TPtAXM8vT6iGUok8lPmqAGmxR0x1Ko72Te6ygeKww6MWj//a8YU2DV40pasvHvQaAJfzYLbomswivQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Gz20VflWbpO8MToyd1ah/SOCTMl1npVpMUielPSOcQ=;
 b=B0QbXxlSmtv+OHT9FDmYLfa7c3ZPc6/WhdENKyeosJK0ViBUktgGpC/gIjsWgF4GfJPX2mrxCLrkulXldmJ8me+bDHToxVlKvBPozAEmmLrHdlKLmYTLaUuEUelhGj7ACqOd8Ef3fhtp6pQMdu2+Nv4D4j/97mMoUArlt80fT00=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB4161.eurprd05.prod.outlook.com (52.134.91.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.21; Tue, 27 Aug 2019 11:08:59 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea%6]) with mapi id 15.20.2199.020; Tue, 27 Aug 2019
 11:08:59 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Cornelia Huck <cohuck@redhat.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH 2/4] mdev: Make mdev alias unique among all mdevs
Thread-Topic: [PATCH 2/4] mdev: Make mdev alias unique among all mdevs
Thread-Index: AQHVXE627FcLaFBgXUa8jSc95m92WKcOy/4AgAAKv2A=
Date:   Tue, 27 Aug 2019 11:08:59 +0000
Message-ID: <AM0PR05MB486621458EC71973378CD5A0D1A00@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190826204119.54386-1-parav@mellanox.com>
        <20190826204119.54386-3-parav@mellanox.com>
 <20190827122928.752e763b.cohuck@redhat.com>
In-Reply-To: <20190827122928.752e763b.cohuck@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [106.51.18.188]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9dd4c7a2-a163-4cb7-b73e-08d72adef634
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB4161;
x-ms-traffictypediagnostic: AM0PR05MB4161:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB4161C64D893B49EED198CD12D1A00@AM0PR05MB4161.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0142F22657
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(396003)(136003)(376002)(39860400002)(13464003)(199004)(189003)(486006)(305945005)(446003)(11346002)(52536014)(66476007)(66556008)(64756008)(66446008)(66946007)(476003)(53546011)(71200400001)(76116006)(6506007)(71190400001)(26005)(66066001)(55016002)(9686003)(76176011)(86362001)(7736002)(6436002)(7696005)(74316002)(5660300002)(99286004)(478600001)(33656002)(256004)(14444005)(102836004)(14454004)(55236004)(54906003)(6116002)(6916009)(4326008)(186003)(53936002)(6246003)(8936002)(81156014)(8676002)(81166006)(9456002)(229853002)(2906002)(316002)(25786009)(3846002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4161;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: L2OkaaWLRUkC71M7cfHeHFLvO9v66wPyXHfs2dapECrxos6ypTMVRPDVJ+MtZvbgstdvD2+pnNfMXoRv4yQRHUbj70Thr9MYnPhfbg8+NdhcUv2fNTsR/ltKoIFNkuzLxetiVXss1xyqKDsODYzaevAJHjN/vbyEtmMTGeGLv9JCkF4+w07vxtMgiGuRBM1V+g8eHE11uMOKDON5EIMcrRp5rajoCKV6wE40aLUA1LkcCVthD+vAe0ff43mC2LFLGpEtE4lpG9v5RlZJfV07Wj904sTZQK1O/xAndSEADp3Cw9D5pVIpxBiRfs5gXyBkRTVmIL0NwTefTkUf5jN2jh1EDUKkj9tjG6gmOMzIHfgIgnM+Zuoq5GwqSGoxXKCRzDQPyRxoowdUuDu4AwWnosv+Ht1tVaDIUwu4xd2razE=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9dd4c7a2-a163-4cb7-b73e-08d72adef634
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Aug 2019 11:08:59.7131
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 76VvySNtlx7/jEgxpAnRpdeFSUdDKooj9zaAYD5zIbH5AQwMoMwAAEO54ACWAPYOBXxdg5f8IOYTIJx/QctqpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4161
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Cornelia Huck <cohuck@redhat.com>
> Sent: Tuesday, August 27, 2019 3:59 PM
> To: Parav Pandit <parav@mellanox.com>
> Cc: alex.williamson@redhat.com; Jiri Pirko <jiri@mellanox.com>;
> kwankhede@nvidia.com; davem@davemloft.net; kvm@vger.kernel.org; linux-
> kernel@vger.kernel.org; netdev@vger.kernel.org
> Subject: Re: [PATCH 2/4] mdev: Make mdev alias unique among all mdevs
>=20
> On Mon, 26 Aug 2019 15:41:17 -0500
> Parav Pandit <parav@mellanox.com> wrote:
>=20
> > Mdev alias should be unique among all the mdevs, so that when such
> > alias is used by the mdev users to derive other objects, there is no
> > collision in a given system.
> >
> > Signed-off-by: Parav Pandit <parav@mellanox.com>
> > ---
> >  drivers/vfio/mdev/mdev_core.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> >
> > diff --git a/drivers/vfio/mdev/mdev_core.c
> > b/drivers/vfio/mdev/mdev_core.c index e825ff38b037..6eb37f0c6369
> > 100644
> > --- a/drivers/vfio/mdev/mdev_core.c
> > +++ b/drivers/vfio/mdev/mdev_core.c
> > @@ -375,6 +375,11 @@ int mdev_device_create(struct kobject *kobj, struc=
t
> device *dev,
> >  			ret =3D -EEXIST;
> >  			goto mdev_fail;
> >  		}
> > +		if (tmp->alias && strcmp(tmp->alias, alias) =3D=3D 0) {
>=20
> Any way we can relay to the caller that the uuid was fine, but that we ha=
d a
> hash collision? Duplicate uuids are much more obvious than a collision he=
re.
>=20
How do you want to relay this rare event?
Netlink interface has way to return the error message back, but sysfs is li=
mited due to its error code based interface.

> > +			mutex_unlock(&mdev_list_lock);
> > +			ret =3D -EEXIST;
> > +			goto mdev_fail;
> > +		}
> >  	}
> >
> >  	mdev =3D kzalloc(sizeof(*mdev), GFP_KERNEL);

