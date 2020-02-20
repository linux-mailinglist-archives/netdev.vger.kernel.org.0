Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 436FF166A4D
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 23:24:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729096AbgBTWYJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 17:24:09 -0500
Received: from mail-eopbgr40057.outbound.protection.outlook.com ([40.107.4.57]:16261
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727656AbgBTWYJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Feb 2020 17:24:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i33dm7fGBDZvtDDhXtMTZ//HQMJxYd0GUOVmR5hJ5RXluHk9IzruygN0e9BE9vBl12JAtNmd4W9GmsvYvRXqZQt+ux9F2nF5FR8WqAqqkAd6Eo2oy+jy4zYyQjkmTh+BEpqjPkPX4d/C8pgOqRbXBmWEOp93x5Dlf7eWoaxGToughHpU5GBNSj3R+bNmCL+gAa22En+pwWOkw2I+YlxXpne47Z8loZXWrTTRq2/EED0GkZabdUT7Z7OPw5egyYqIbbNuk1GdtlE4AVdozC+++dbXriQsZqqQERCdnR2cfJ7uEXVyZfSHixdNBWyw4fPOH5WN5P8gHXNw5xXtVnPVng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bszykc3sSTaQpaXQ0+AJaLhvsDHLdTePUP16w8i1wdw=;
 b=DhtWmstRF4alZjr6EMe9WytH9uojE5KOqVg2bSZ+vfmsqfiNsHywkZ63gpuG49YnAkmlbB9OgTi2P6Vjhq78W3vvyMdEEsNfo4IoABiPUA0szKwe4swW38wEPHqg2K7Y4CfGqJtF/iZ3TNXS3kSpAJXylsOz0SM5YwJlHDlVk66K3xgCGAiDET7CoBk2papFtQi9Tv8qWYma4mecLKlYHipYWiES43ZdjS+/17MK3h5uF7x/BrB4MjMbTuEp2gfOu4/Z3lE3pqNvAeCz9GVe1gcP38PCU5yWnPUExpPRB7bGBhDo/12YpeHa/2O2EGPvL2OkmWJgGfoJC+qY3dS1Yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bszykc3sSTaQpaXQ0+AJaLhvsDHLdTePUP16w8i1wdw=;
 b=o1lLw28EKcYYPuYxZH7DTP5ucFJlzacks9gcFbf6elDtTLjLKnKll6YuDVq44ywyUg+R3zUzZDwHBFd37Yi/HDJ+kv8TNT+h9mArsrZLW85YDFOzjU31khBcWAH4wNOnkNn6g1JlDS4GM4QUdfZ5sLssF63CwCceyaBVODJF8hI=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB5281.eurprd05.prod.outlook.com (20.178.16.207) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.24; Thu, 20 Feb 2020 22:24:06 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::8c4:e45b:ecdc:e02b]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::8c4:e45b:ecdc:e02b%7]) with mapi id 15.20.2750.016; Thu, 20 Feb 2020
 22:24:06 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>
Subject: RE: [RFC PATCH v4 10/25] RDMA/irdma: Add driver framework definitions
Thread-Topic: [RFC PATCH v4 10/25] RDMA/irdma: Add driver framework
 definitions
Thread-Index: AQHV4di3RHBiR8SSKUiBqR+gfJba6qgbREEAgAYwCYCAA0AoAA==
Date:   Thu, 20 Feb 2020 22:24:05 +0000
Message-ID: <AM0PR05MB4866395BD477FAD269BCAE07D1130@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20200212191424.1715577-1-jeffrey.t.kirsher@intel.com>
 <20200212191424.1715577-11-jeffrey.t.kirsher@intel.com>
 <6f01d517-3196-1183-112e-8151b821bd72@mellanox.com>
 <9DD61F30A802C4429A01CA4200E302A7C60C94AF@fmsmsx124.amr.corp.intel.com>
In-Reply-To: <9DD61F30A802C4429A01CA4200E302A7C60C94AF@fmsmsx124.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [68.203.16.89]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ea309899-a35f-49c3-2db2-08d7b65398ea
x-ms-traffictypediagnostic: AM0PR05MB5281:
x-microsoft-antispam-prvs: <AM0PR05MB5281BF5CBFF8DEF2CB8584DCD1130@AM0PR05MB5281.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 031996B7EF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(39860400002)(396003)(136003)(366004)(346002)(189003)(199004)(66476007)(66556008)(71200400001)(6506007)(53546011)(64756008)(7416002)(52536014)(26005)(8676002)(66446008)(55016002)(110136005)(5660300002)(7696005)(86362001)(76116006)(81166006)(478600001)(54906003)(186003)(66946007)(316002)(2906002)(9686003)(4326008)(33656002)(81156014)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB5281;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TVTWAcjwuNoh7Wb41Cq+430hONdNHuyex/QPCCYv2fioMqgVqahy1W033QEAvjqJlmE1VFVVJWAE+CRYVkbFVQaHQT+ukMbm5QjKLbcN+2aSZsGQzhzKNMfCzo6jjzAFII/rBNlr5mU0CVrTgGL+8gzR054zInohS1kTaBBfcnF/Ld/foqc26xMuaQ8sYUrlNAzaG3YmOIsV8X9F1hPev7fYHrmfihX+kHy8iaBAvTBYrYgiQMsNZq4KsA1epcW9sKjz/0gK3SZZEKGhrOraZYoI7srll30r9nygwHVPHYpWoLzVXBgrW96xVb5D5mo7Ps3L838OaFb+tFWdiaBzVN2ANdA3uohF+y+F/tYGzAmsatQj6evkHLwohPqlMOmwpj3lWcvaHlDHqZgM5kcqUgN9daGsf83IgQEkKRQPIvG09WDRedQXaxxNHNlf2a0X
x-ms-exchange-antispam-messagedata: QSamZFulr7ZTuZZScgsI4McxapPHK2aQ/bcO9AmNckeD6g1hjGd/PkW7QQDRGf795JQdLBtuT5I5vXTqNqRqSz/svB75PLm6dxm+j7yhm7UK+MhcGJJlDzJid1j16sf9KUXTwfQ5DBXzzcPjgTE2dQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea309899-a35f-49c3-2db2-08d7b65398ea
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Feb 2020 22:24:05.9369
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: k0HGWN78YLmGPxcPY6paeDzY0ip4MEKdK4Dx4TlxEDkW8ZdZJLcbOWMc39rNqVfGEjZwQFD+FUxsYAUX7x/ZEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5281
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> From: Saleem, Shiraz <shiraz.saleem@intel.com>
> Sent: Tuesday, February 18, 2020 2:43 PM
> To: Parav Pandit <parav@mellanox.com>; Kirsher, Jeffrey T
> <jeffrey.t.kirsher@intel.com>; davem@davemloft.net;
> gregkh@linuxfoundation.org
> Cc: Ismail, Mustafa <mustafa.ismail@intel.com>; netdev@vger.kernel.org;
> linux-rdma@vger.kernel.org; nhorman@redhat.com; sassmann@redhat.com;
> jgg@ziepe.ca
> Subject: RE: [RFC PATCH v4 10/25] RDMA/irdma: Add driver framework
> definitions
>=20
> [..]
>=20
> > > +static int irdma_devlink_reload_up(struct devlink *devlink,
> > > +				   struct netlink_ext_ack *extack) {
> > > +	struct irdma_dl_priv *priv =3D devlink_priv(devlink);
> > > +	union devlink_param_value saved_value;
> > > +	const struct virtbus_dev_id *id =3D priv->vdev->matched_element;
> >
> > Like irdma_probe(), struct iidc_virtbus_object *vo is accesible for the=
 given
> priv.
> > Please use struct iidc_virtbus_object for any sharing between two drive=
rs.
> > matched_element modification inside the virtbus match() function and
> > accessing pointer to some driver data between two driver through this
> > matched_element is not appropriate.
>=20
> We can possibly avoid matched_element and driver data look up here.
> But fundamentally, at probe time (see irdma_gen_probe) the irdma driver
> needs to know which generation type of vdev we bound to. i.e. i40e or ice=
 ?
> since we support both.
> And based on it, extract the driver specific virtbus device object, i.e
> i40e_virtbus_device vs iidc_virtbus_object and init that device.
>=20
> Accessing driver_data off the vdev matched entry in irdma_virtbus_id_tabl=
e
> is how we know this generation info and make the decision.
>=20
If there is single irdma driver for two different virtbus device types, it =
is better to have two instances of virtbus_register_driver() with different=
 matching string/id.
So based on the probe(), it will be clear with virtbus device of interest g=
ot added.
This way, code will have clear separation between two device types.
