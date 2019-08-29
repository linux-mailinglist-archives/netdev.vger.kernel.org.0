Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAD89A1459
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 11:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727099AbfH2JHQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 05:07:16 -0400
Received: from mail-eopbgr10056.outbound.protection.outlook.com ([40.107.1.56]:46983
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726038AbfH2JHP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 05:07:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gPyAYcdK1S0pYHlkGd1yTKYd1lSyOeqr2xB9QsPxFEhSfTDcByl+Hmd0AuWikRp5xh5HQOWD9W00mArJO8b4HrTWZt3ROhZtOg+UcuHQWvjPdT1BbEDUFEmEwa3H7tLhurHfpFLwmLEhYNAlhIT5SqmJ8gYhyVjZk9UJG04Ra7PKkKyGOwJRLGOnAU4TX9g5lbrVJrpSrRyudTLlBTVR92hHhbon3R7iL5mqoryOn3xvZCBRA5pjM96g/jCzPsc7Nv7/pBNppcTmcDq/WCtl8+etVhGYb8K8WZlvnrqxerp0vcm5qo6yGUnBRhYtlhMPk6r1MhnGQAzQGxPhglM5gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zfc5gMaRMQgpUvSt8M/zbgx6bd2J6ZllItjttuEJVFw=;
 b=B+8DABJA6tQb4OTmz01ss/plQW8hHJD2wHIckptCOzRcBAZbW1g992j5t1oIJheMaWbgA8SzTeuhgHxJmMAnt+K323FRWo1mAy5zCJ8aImRg13zmW5TjeLJiagdMt4bWjv5ZmtJJmSDRrfjQ7uC0BWbZUMZ76Juler9crCMYQI0xJqa26jsft1ry3TKn698E7uJKqt4M8hMJnVZyDQWn0asHfV0OmalYlWbtlETKkrfz3PIYA9br/OyTBrxOwsOKvax+wWxlhpJKm1rhemAfwJLYsLk0ZjjD9flaOtp74Mx5l/h4fraFBcsfTVNoXnktCpytfh+HHTO38Zj9I6FSLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zfc5gMaRMQgpUvSt8M/zbgx6bd2J6ZllItjttuEJVFw=;
 b=obmy/NzRqvl2KAHhBCWy8NM0vC5wWeyBeZpeeh9ZXoOPNbP9l0Q3JCdH82WNSlbzgzoi9q5mq7BaQaVSKko4CYnWZoG5H3XWQj2wMnBEysdulISdlj0bE9J+q9YM7hFIMhJBMmDaQFLTBAoY9dcFHN1s+e/SBXwdCMS8ItOEtuw=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB5937.eurprd05.prod.outlook.com (20.178.119.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.20; Thu, 29 Aug 2019 09:07:11 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea%6]) with mapi id 15.20.2199.021; Thu, 29 Aug 2019
 09:07:11 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Jiri Pirko <jiri@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v1 1/5] mdev: Introduce sha1 based mdev alias
Thread-Topic: [PATCH v1 1/5] mdev: Introduce sha1 based mdev alias
Thread-Index: AQHVXQwKr3hzuM9h9k6/weilGIZr2acRFDQAgAACdICAAMF/wA==
Date:   Thu, 29 Aug 2019 09:07:11 +0000
Message-ID: <AM0PR05MB48661932BA288F609E2A5E49D1A20@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190826204119.54386-1-parav@mellanox.com>
        <20190827191654.41161-1-parav@mellanox.com>
        <20190827191654.41161-2-parav@mellanox.com>     <20190828152544.16ba2617@x1.home>
 <20190828153431.36c37232@x1.home>
In-Reply-To: <20190828153431.36c37232@x1.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [106.51.18.188]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bac0e5cb-1def-4392-caa0-08d72c6046dd
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB5937;
x-ms-traffictypediagnostic: AM0PR05MB5937:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB59371F1D9544D8A556DC8526D1A20@AM0PR05MB5937.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2803;
x-forefront-prvs: 0144B30E41
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(396003)(346002)(136003)(376002)(13464003)(189003)(199004)(186003)(4744005)(4326008)(81166006)(66476007)(66446008)(66556008)(316002)(64756008)(7736002)(5660300002)(256004)(11346002)(66946007)(33656002)(86362001)(446003)(9686003)(478600001)(3846002)(54906003)(14454004)(6916009)(476003)(52536014)(6246003)(66066001)(81156014)(6506007)(53546011)(6116002)(486006)(53936002)(229853002)(55016002)(2906002)(55236004)(9456002)(71190400001)(74316002)(25786009)(6436002)(76176011)(8676002)(99286004)(7696005)(71200400001)(305945005)(76116006)(8936002)(102836004)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB5937;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: VIrthO0jrH8ZioEiVFcZbU4Ec6ja51IpayQKzdPy0kY+riLEco1qsfXoelo6QDFSG4sGHcsYD0bjFzdhGD5Ak2yUeEsoruKL4dsfP+1Bgb1gjkiFNC0oCEGZTUogd/iZdlb/s830LW9g+VDUSUSche+yzx+hAlqK6MaLZHRvT/Zdzy79GwqsJo26fWyhaH+NLeE3LRwib3A7P1WwFk1HsvKnWncv/AZxEReFvqjrmYhzPwYyjBsfFOzCcQQvpBb2nNdP6rBDNGqY1vvgfMewyW6SAG1/FUQ3aCeAFip/Lkj85C9c0Ttdm2gVaWQNgZYyz3V3WAzJSm3d+8cpTrK5F5zkQKgsefij5DZ6kIuyBARYwouSYJG84ITM5ZKzrYasgrSOxH5DahslF3J5foR4gFhl36/BB1gWzV4catyro0k=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bac0e5cb-1def-4392-caa0-08d72c6046dd
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2019 09:07:11.2678
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VDelrZ/v48aQ8miKEJkZT/5cpNn9gjOgQ2clfFL9rcw9Y4CxVq5K9xLKnZ3WhgM4T57KM1I+b6DcrNJOE4Mz+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5937
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Thursday, August 29, 2019 3:05 AM
> To: Parav Pandit <parav@mellanox.com>
> Cc: Jiri Pirko <jiri@mellanox.com>; kwankhede@nvidia.com;
> cohuck@redhat.com; davem@davemloft.net; kvm@vger.kernel.org; linux-
> kernel@vger.kernel.org; netdev@vger.kernel.org
> Subject: Re: [PATCH v1 1/5] mdev: Introduce sha1 based mdev alias
>=20
> On Wed, 28 Aug 2019 15:25:44 -0600
> Alex Williamson <alex.williamson@redhat.com> wrote:
>=20
> > On Tue, 27 Aug 2019 14:16:50 -0500
> > Parav Pandit <parav@mellanox.com> wrote:
> > >  module_init(mdev_init)
> > > diff --git a/drivers/vfio/mdev/mdev_private.h
> b/drivers/vfio/mdev/mdev_private.h
> > > index 7d922950caaf..cf1c0d9842c6 100644
> > > --- a/drivers/vfio/mdev/mdev_private.h
> > > +++ b/drivers/vfio/mdev/mdev_private.h
> > > @@ -33,6 +33,7 @@ struct mdev_device {
> > >  	struct kobject *type_kobj;
> > >  	struct device *iommu_device;
> > >  	bool active;
> > > +	const char *alias;
>=20
> Nit, put this above active to avoid creating a hole in the structure.
> Thanks,
>=20
Ack.

> Alex
