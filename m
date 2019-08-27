Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9205F9E69C
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 13:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727910AbfH0LQ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 07:16:26 -0400
Received: from mail-eopbgr150053.outbound.protection.outlook.com ([40.107.15.53]:36312
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725860AbfH0LQZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 07:16:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HRBmNRqwkYASsxzzosx/pZ/baDSqDIbwWSANL3TqUnisPlAGiZS7GHGBtdSegPA3V4qSjg7GvmUmhn6iyU+R8Z0dWZROt6rPNTMP61Cfz16/SQXXGDTbRHja0WbT61vxoaodi0o5iDhw3j5BtiQIitSCi54ClGTiiEEaZddp/JxnpeJKhTO/7KfcHwjLa5Wf6g/+OSNy1ddE0VxRjNNr73+wlEKB/cZdVqOS243AnPJMYEKNd7FFteMnuNITIK2+T5wN1/n64Ix2O5Wr6qrx8Za1E+yq8Hp7pQVOxPq8iUe6W+xIRbGaiGvhJEnvZvmxyCfw38zJzJBZc+V7qdiaYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=msXxQjljoYnswd+1XdnZ+ev8v2tQcLbPdXFu9EZwS7o=;
 b=Kv4tyyJ+5cTkgy17TytVFfHPJQ0uA8WvSDEp2z8CxWDKh+IgttQ9yqoUPGX1Ma4j/C3VGzm5+OadQA6tHlL1PtKp+P6ywQQZAKj3dYl2sTypDN5ab3LK5YBCZQBdB4vnE6WJr+2EPGIC7IPDu86FZHTsvHB5Gvn77Dh2+Aoriu3w/sua8OfijzW46Lc77tWF+MTKU++k3JgE9u/8E3d+oFWf5Fik1l7eMe5xdD0BmrdmeR0SN97XhDvjoSUkRmVoLUzonCveUwXRAPwJfdJ3Mrkyemsj7ZEACEl+w4yCZCwot2IzMePsC3v7YCthXLCSsw9D0EkhDqCUqXx2QChGfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=msXxQjljoYnswd+1XdnZ+ev8v2tQcLbPdXFu9EZwS7o=;
 b=NlvrRfhLHlwjI6UgM2pBP/YCIHz26YxYCaS1EJ47ydiP87e7Y9YemfVjqGdhnUg/wwWSk4CIkOkqjFGnKoHtpctl1pzrAsxr8MG5WT7sU+J56eCIsq0QqOU8/0nbUXHHtXRd4owQ0VCsQrXT33L2xlOpxUppWoxcxFqDeJLSKkg=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB6084.eurprd05.prod.outlook.com (20.178.203.92) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.21; Tue, 27 Aug 2019 11:16:21 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea%6]) with mapi id 15.20.2199.020; Tue, 27 Aug 2019
 11:16:21 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Cornelia Huck <cohuck@redhat.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH 1/4] mdev: Introduce sha1 based mdev alias
Thread-Topic: [PATCH 1/4] mdev: Introduce sha1 based mdev alias
Thread-Index: AQHVXE6sjQlIhIUUgkClKEYpCVnoRKcOypkAgAAONqA=
Date:   Tue, 27 Aug 2019 11:16:21 +0000
Message-ID: <AM0PR05MB48668D8E4B414D015ED4C826D1A00@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190826204119.54386-1-parav@mellanox.com>
        <20190826204119.54386-2-parav@mellanox.com>
 <20190827122428.37442fe1.cohuck@redhat.com>
In-Reply-To: <20190827122428.37442fe1.cohuck@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [106.51.18.188]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 119c719d-67fe-45fd-edd8-08d72adffd65
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB6084;
x-ms-traffictypediagnostic: AM0PR05MB6084:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB60848A8988F5AD6D5BD2CA48D1A00@AM0PR05MB6084.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2399;
x-forefront-prvs: 0142F22657
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(346002)(376002)(136003)(366004)(199004)(189003)(13464003)(6116002)(71200400001)(71190400001)(8936002)(9456002)(6246003)(81156014)(81166006)(25786009)(26005)(14454004)(86362001)(256004)(305945005)(74316002)(7736002)(8676002)(478600001)(4326008)(99286004)(186003)(102836004)(7696005)(55236004)(53546011)(6506007)(76176011)(54906003)(316002)(229853002)(53936002)(9686003)(55016002)(6436002)(33656002)(2906002)(446003)(486006)(11346002)(476003)(6916009)(66476007)(66946007)(3846002)(5660300002)(52536014)(66446008)(64756008)(76116006)(66066001)(66556008)(4744005);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB6084;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: jW0/2D2wetcs77MNu47e3uay3WUnkZcquy7+s7aB4KpmacT70RFNpCSerZR7eiMVvlxhMgs1NYkbUBSOt+4Zta3Vfl2GlIsLm/PO0imDjWCu/N/8az4SiN6hDAxIOXBDo5Sue2vEgcBU1SVsB28jVAZZASkZidl9+Ao2kGq1kL+QOcPlO4oTglOtXdRnbI2nL4E7ePkifUxPYyVivCgMtSKU+9vbckoFTJcGsAB+7cVk/MeehTDrBFqo23XBC2vIQpBuyfcqc6ekvz1/tXL6JqDB7nopjfxj/G6aTdXBM0CYWfsQCqF61S+0OvlGUeExmL6TSDIDxM0JCZNdXBrE+1gz9RRoM3hRLYqEzrnUqEDeU2qjg9Kbkqva48AZI9m6flOU6/BmIMBFRnqJ/NterGW/SMbyTRMeaHRIDMSdaO8=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 119c719d-67fe-45fd-edd8-08d72adffd65
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Aug 2019 11:16:21.2224
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JOnRB+6Al0ZmpTqlQkL5vbhhLDK6LtycQMj5J7PCLIwNQFxu5dE/9FR4lP8/unSc9CT9YWBZZGQoIqumQ6SQnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6084
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Cornelia Huck <cohuck@redhat.com>
> Sent: Tuesday, August 27, 2019 3:54 PM
> To: Parav Pandit <parav@mellanox.com>
> Cc: alex.williamson@redhat.com; Jiri Pirko <jiri@mellanox.com>;
> kwankhede@nvidia.com; davem@davemloft.net; kvm@vger.kernel.org; linux-
> kernel@vger.kernel.org; netdev@vger.kernel.org
> Subject: Re: [PATCH 1/4] mdev: Introduce sha1 based mdev alias
>=20
> On Mon, 26 Aug 2019 15:41:16 -0500
> Parav Pandit <parav@mellanox.com> wrote:
> >
> >  static int __init mdev_init(void)
> >  {
> > +	alias_hash =3D crypto_alloc_shash("sha1", 0, 0);
> > +	if (!alias_hash)
> > +		return -ENOMEM;
> > +
> >  	return mdev_bus_register();
>=20
> Don't you need to call crypto_free_shash() if mdev_bus_register() fails?
>=20
Missed to answer this in previous reply.
Yes, took care of it in v1.
Mark Bloch also pointed it to me.
