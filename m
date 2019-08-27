Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B55AC9E692
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 13:12:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728702AbfH0LMe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 07:12:34 -0400
Received: from mail-eopbgr60041.outbound.protection.outlook.com ([40.107.6.41]:16709
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725793AbfH0LMd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 07:12:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NWnj+2W2sqyWoZxGh3cpOaYYqHyZJciy4ZBywBTkm8QQkoH5JnhWx3ba/jcP4hbFzU32TG2mf23CDEen5tdx9j8ptewha0Mkns4xdyWHwKTCB0Y09EJPRItepLCTQ7IJxr3rFVnbMMMl+jkhlyyLWuvc+WO4+ijSyMvOO6B970kFO2X3oOIY/d1rFd5oTIgukBx5UlcYO4LkmMkDpan/xpY9xm9nLOX38TYCvmmJTl/tRrcKcDS9S4fjyVNrxsiVWkXXPufYdoQvNhxSa0cq6X+uugVYxQ4H4Pc6LKD1BSIHGyNp1h8dMCV8t+vlkn/10/BFvUglwmc8PsTojo11cQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M2rSwjzY/WF+8jdRKCDHTRRcOoZQDEZLdt6wW0Lr18Q=;
 b=VcwfnEQ+bPKylTeVE6JlUCdJ6CmAjPmWOPgqrJXizTcIb2NHbC8QEyJb1xGc0ZA07rjmh0+bmXQhtje7Q5MtEY1qFV6cfslAzM01zVd/QvFr36ogRVoPSy45CRNl00qAx0aWePZa9LZj54O+O3H6wWiH61yHreBFdHHjmjj4QA2xMRtjp/IArn3+q1elyzBkIs8RgaUV2Jh0ny2D7eiZWTdW+4mYMkYNKIDH6aW4xips/YouCyAq259ERsvICySDZyA528yY2qw+JTYKKZeev1L9vRa+jBkZ5oppawoWfmZu7ZYVC54/9CCGWL/MhRHjh/E4du25lUQ9hQbrKnRzlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M2rSwjzY/WF+8jdRKCDHTRRcOoZQDEZLdt6wW0Lr18Q=;
 b=rVWzDhLAKsosHB2bdB9HVui+ljYwebO8qINzXpU4aSfbAQPdAGKDRby8zFq2ACQZyNcbA5rklCDB8Mjd0vLy8FSgVTTPOsDUmUx1kzpsH3jX1qMJXamRBxGk0mwJ4Y5++gHtm2y7OErckAabRiQpHcLor0R3ls31JNLcV2h7mPw=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB4500.eurprd05.prod.outlook.com (52.134.124.153) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.21; Tue, 27 Aug 2019 11:12:23 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea%6]) with mapi id 15.20.2199.020; Tue, 27 Aug 2019
 11:12:23 +0000
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
Thread-Index: AQHVXE6sjQlIhIUUgkClKEYpCVnoRKcOypkAgAAMheA=
Date:   Tue, 27 Aug 2019 11:12:23 +0000
Message-ID: <AM0PR05MB4866B68C9E60E42359BE1F4DD1A00@AM0PR05MB4866.eurprd05.prod.outlook.com>
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
x-ms-office365-filtering-correlation-id: 10b1fbd8-b46f-482b-b20e-08d72adf6fe6
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB4500;
x-ms-traffictypediagnostic: AM0PR05MB4500:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB4500D1A85B0BAEC382840330D1A00@AM0PR05MB4500.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0142F22657
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(136003)(346002)(376002)(39860400002)(199004)(13464003)(189003)(446003)(11346002)(476003)(102836004)(76176011)(6116002)(7696005)(86362001)(53546011)(6506007)(55236004)(9686003)(8936002)(305945005)(9456002)(3846002)(316002)(25786009)(81156014)(74316002)(4326008)(54906003)(6246003)(229853002)(55016002)(99286004)(8676002)(7736002)(81166006)(33656002)(186003)(71190400001)(71200400001)(5660300002)(256004)(14444005)(478600001)(14454004)(53936002)(26005)(6436002)(6916009)(66946007)(76116006)(66446008)(64756008)(66556008)(66476007)(2906002)(486006)(66066001)(52536014);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4500;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: nWep01gU5RPeTvIwA6DzOjUOxCDMIJEEKYPoQ7dEyvHUkmydTlmrmEOACIb52ekbtyzLfXx2YUH3tjC1f4iRfGtwuJFKE9ySXLdymbVslE+AF0SQNlw3Mym5u346riAO6AcF6bYZMKL9IDaX81P1Slj/46kayVTBxf03N8XBsmPbwM9zAgrRrNaS/H+flvXDJAeUAtdQesH1iVsbhoZjMhhhTC88bZd3ntGurqCh+gwKKVNdvudqUpCtpnB+cnk69UDSh7waCrwkMArPiAyZ8LULZTCiJBmSMx5INwpcdpDa1sDmqXEHL9TE/UKuUw0z5J+rIfFzGI6NIE/dBQcNySMd+cXsMCyymaYmINmfysbgVt/sIGii1BMUSCJzu5CZujkE1vhwdSdmHac2AFcLJrthResxNTbLB/YGmIueN5c=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10b1fbd8-b46f-482b-b20e-08d72adf6fe6
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Aug 2019 11:12:23.8308
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7NggeKzpBQ6Pk7SlnT3P7co1BaUhN/aO1yuwL5uaPdv1+y0Xink7UwkVRtYodMnIvViwRyPKSKmOcdjEZyrcDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4500
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
>=20
> > Whenever a parent requests to generate mdev alias, generate a mdev
> > alias.
> > It is an optional attribute that parent can request to generate for
> > each of its child mdev.
> > mdev alias is generated using sha1 from the mdev name.
>=20
> Maybe add some motivation here as well?
>=20
> "Some vendor drivers want an identifier for an mdev device that is shorte=
r than
> the uuid, due to length restrictions in the consumers of that identifier.
>=20
> Add a callback that allows a vendor driver to request an alias of a speci=
fied
> length to be generated (via sha1) for an mdev device. If generated, that =
alias is
> checked for collisions."
>=20
I did described the motivation in the cover letter with example and this de=
sign discussion thread.
I will include above summary in v1.
=20
> What about:
>=20
> * @get_alias_length: optional callback to specify length of the alias to =
create
> *                    Returns unsigned integer: length of the alias to be =
created,
> *                                              0 to not create an alias
>=20
Ack.

> I also think it might be beneficial to add a device parameter here now (r=
ather
> than later); that seems to be something that makes sense.
>=20
Without showing the use, it shouldn't be added.

> >   * Parent device that support mediated device should be registered wit=
h
> mdev
> >   * module with mdev_parent_ops structure.
> >   **/
> > @@ -92,6 +95,7 @@ struct mdev_parent_ops {
> >  	long	(*ioctl)(struct mdev_device *mdev, unsigned int cmd,
> >  			 unsigned long arg);
> >  	int	(*mmap)(struct mdev_device *mdev, struct vm_area_struct
> *vma);
> > +	unsigned int (*get_alias_length)(void);
> >  };
> >
> >  /* interface for exporting mdev supported type attributes */

