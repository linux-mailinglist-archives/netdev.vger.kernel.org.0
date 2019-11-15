Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99F8DFE8C5
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 00:43:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727364AbfKOXnC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 18:43:02 -0500
Received: from mail-eopbgr130071.outbound.protection.outlook.com ([40.107.13.71]:32593
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727083AbfKOXnB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Nov 2019 18:43:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SElBJY5f2ynm5fdxoUxLIsDOmgjHHGXBQGYHqV5ABDC2D6GypnOTFlEFxGLZFfbXVsX3OeDCx+IEMNJyR9b9x5rAWk/PhfRfCVG+x2l+eNhOCs2tfziu+3khv3X5Xwq5fUVmz64a5mEIlBD1V98hlxweoSuz6MNWawti62R3GBjT7ZW6Q1auK6jeFdUy37/vu5D7ps4RIMfn9UBBNq22W6V5ZxkYFjPvfp3gX/2NscRhB9IiIUweQd9TLswod2DXOAaYxXBjGgmgZPIxwR2FFOaSvmmLAfnkE91+4KE4B3076oTK0/ub6uOXID9c4lX5axT4S+kCUQQfKCLCvXCBGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wU8893HmXxvz41SLXuJxi1ofMV3oTplkK6lgBMmCQrs=;
 b=OLZE87n2hk33JXHTWX02W4QTHqLocHzxviwBX5WkcvDwqYH/8As3UTDoDmyB3fQbm9qWJy3Xdd8Hl2+nLJlYKMCr/EVCIJ4/yRm4VRBQYCy7nD1HYuwh5YwJ8ccXf1Hj0BP7X4H8Yij2q7nlWK4eXvC3V6Ij0RLRra1qGoHdb9mANbVC73SMWOvW8aALaMXEo2nBRjJjftgmYazHsqrYabYDOVpD0pCFMnogDoE0HXYmXfifSJ1YRLPg3vbEubDHytwMzbb4dSzJmPEQfavXXLLhvYEvzMYu+Hgvo5R2tOM9X5C5sz49KcrgP/KRdAaYfVXzUdB3RLSnAMJq7voYJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wU8893HmXxvz41SLXuJxi1ofMV3oTplkK6lgBMmCQrs=;
 b=PQRndBwhirbVCn/cafzKQ/UJlILqwfb0+9J8GFmWW8xblZ9LVdMj5ZWNMZdu86JyNBdpP2S0jUKAkqcIVdH+59Z6CJySQFcAN9TxODlqovhTwxyQhhuvM1pVZ92WcZaEFsCahcaElUnqxorcv7ZuiQFgwqJpq/tjJByQSKNxb1M=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB5361.eurprd05.prod.outlook.com (20.178.18.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.26; Fri, 15 Nov 2019 23:42:56 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4%7]) with mapi id 15.20.2451.029; Fri, 15 Nov 2019
 23:42:56 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     Dave Ertman <david.m.ertman@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>, Kiran Patil <kiran.patil@intel.com>
Subject: RE: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
Thread-Topic: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
Thread-Index: AQHVnATItanP+SK9PEuJkGaYy2/dTKeM40mA
Date:   Fri, 15 Nov 2019 23:42:56 +0000
Message-ID: <AM0PR05MB4866D8B7B86C4EF04DAD82BED1700@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20191115223355.1277139-1-jeffrey.t.kirsher@intel.com>
In-Reply-To: <20191115223355.1277139-1-jeffrey.t.kirsher@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [208.176.44.194]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 903fe64e-1976-4591-6d8c-08d76a258a82
x-ms-traffictypediagnostic: AM0PR05MB5361:
x-microsoft-antispam-prvs: <AM0PR05MB53618D3F45C6343F48D34EF8D1700@AM0PR05MB5361.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 02229A4115
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(376002)(396003)(39860400002)(136003)(346002)(199004)(189003)(52536014)(86362001)(8936002)(6436002)(7736002)(11346002)(81156014)(81166006)(2201001)(66066001)(25786009)(446003)(53546011)(6506007)(102836004)(478600001)(76176011)(2501003)(7696005)(186003)(6246003)(26005)(14454004)(55016002)(305945005)(9686003)(74316002)(4326008)(8676002)(7416002)(33656002)(256004)(71200400001)(5660300002)(71190400001)(3846002)(99286004)(316002)(54906003)(110136005)(6116002)(76116006)(66556008)(64756008)(66446008)(66946007)(66476007)(476003)(229853002)(2906002)(486006);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB5361;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rgCluvGPG9TabyoOOV0DXkAV8LoC81m9XBCc2c044+R/wWsahNOhXFdElB7X/ngI56lHvN+6sbvPTMdZiTzyLOl652snyJevm5Dz9ULEp+DeeKFvdOEG2R4Qkso2XhGq1bAD1bGbl1+cbTJuUBbG9j1eiu6gZf+MjV0R29S/gG+gSnTXv+ss8uD97pSZ9Nj1p+n4JlS0/WGGJgsdV3VBzEubmk20dYyQ0FbFxV12O64warGRUQf+w4yUlcZ6u4GVTvl/4dTbhahYaiMtqlwo53+VwUiRmlCBjxO8Uw5rttGz41JxlwZHNUJaVFHsRJ9Qx6+uNh5Lf6NSgKIfEhqkaZKvh0x2ybEWxlQebNifaaT3MQZ7ZV4YDsN97TJHDsekalnstQ8kYvv7udPK+onBZJid3D+6d+gqKAAxwwQMjCj2VSTA6sEcxyzE/6EDCl41
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 903fe64e-1976-4591-6d8c-08d76a258a82
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Nov 2019 23:42:56.5023
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +fThq1Y7ds2M5vYuG7w8KfHTcdYxh6zTRhU/kdCyBbVReVdWNYMg2fVbIWZaXsDCaKCYfqaUiHoNYK66YkFZGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5361
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> Sent: Friday, November 15, 2019 4:34 PM
> Subject: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
>=20
> From: Dave Ertman <david.m.ertman@intel.com>
>=20
> This is the initial implementation of the Virtual Bus, virtbus_device and
> virtbus_driver.  The virtual bus is a software based bus intended to supp=
ort
> lightweight devices and drivers and provide matching between them and

When you wrote ' lightweight devices', you probably intent to say,
'multiple class of devices such as rdma, netdev etc for a single underlying=
 parent device'.

'struct class' has clear meaning in kernel with above two examples and more=
.
Though it's not limited to these two classes, an example is always better. =
:-)

If so, please word that say, that avoids the confusion and it will be align=
ed to below primary purpose description.

> probing of the registered drivers.
>=20
> The primary purpose of the virual bus is to provide matching services and=
 to
> pass the data pointer contained in the virtbus_device to the virtbus_driv=
er
> during its probe call.  This will allow two separate kernel objects to ma=
tch up
> and start communication.
