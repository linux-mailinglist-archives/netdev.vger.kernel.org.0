Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CF7CFAA5C
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 07:44:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbfKMGoz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 01:44:55 -0500
Received: from mail-eopbgr70059.outbound.protection.outlook.com ([40.107.7.59]:46494
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725866AbfKMGoz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Nov 2019 01:44:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b/7U4MrGn1/Ag3oqaG/erBlifyIo+TrYXEFOAbTfpMMizGsP2v9PEBhs2OsNl/WGLXv4kiArBR86f2jxZHPYPHUfNqjI1XLqz+sW7gm7k5HSiVlp+TyH+wP+g3AlXC1lIuSd/DhyPHCmWP3w1NaxdzCo23pgiRKO+VV7cuE5Y15Vc8VDym0nhPcq4eJ8OQz58+8stdSoX30kmeT7hRRrirBYGUnM6ngvD0edAr1/U+bc3S3kLQDUZSLF8suG3m88xhByKqnPhYFXTTNoeDRA7s8KuFr+9SVCpqsV31HlSzwxS1pgi1bTSrvYIMWhA9TCp2nH6nHTlBOyiJkqXBgYIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QAN6VDvGNoZJe+Mk0g24tiXa0BjlzVW5DRAiF0HvKHw=;
 b=WrkUQjtB5TjO62UR4iHH9MwmXY3eAaZHLGDneceGV5MYgQNS82pz+0gdNJxmJCuh4O5OQ1c1dK1Eqy2C8L05CzMdDBAmpYx2qj+b4IUc5E0Bx0xxcle2sCu8xQg/zjhfqDbWAbO65hdJEvamqMC6BJop+MZ7hBidOHaZkea96SufVkKDJ7PPSCtu1jWtsgQcJGvRxAwPdgOo/NorBSSSjfpjGMn8q2583WRUIsQnzkHpOa93zOi5yttSjzB7fZTYzti7b1ElNHYQZo3sBZYbWvak8vqjAHxnLilpzySqmjrLdptG+xPaKhZZ+DLm0IPanWySMZAs065dFHJl3vklXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QAN6VDvGNoZJe+Mk0g24tiXa0BjlzVW5DRAiF0HvKHw=;
 b=dHlRlLKRxunraFh2Xxrp/yDt15bMlR4LSC2vBogTVbp1VCD1YhGfy2595WZJM4u+0Z3YJJ6leYKQV3jUNnJWurSMiMq9rhUkQNCvt1poXgPuFPkt0IfeCOoZBBrAfk/rVwix/GMpMM5F0Nptlmiaggxr3n2mlXm9iHgooGjovFI=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB5041.eurprd05.prod.outlook.com (20.177.42.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Wed, 13 Nov 2019 06:44:49 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4%7]) with mapi id 15.20.2430.027; Wed, 13 Nov 2019
 06:44:49 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
CC:     Greg KH <gregkh@linuxfoundation.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Dave Ertman <david.m.ertman@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        Kiran Patil <kiran.patil@intel.com>
Subject: RE: [net-next 1/1] virtual-bus: Implementation of Virtual Bus
Thread-Topic: [net-next 1/1] virtual-bus: Implementation of Virtual Bus
Thread-Index: AQHVmMVkwGO915shK0y7Ue5RV91ix6eIDrEAgAAsrICAAA5rUIAAAv4AgABc5sA=
Date:   Wed, 13 Nov 2019 06:44:49 +0000
Message-ID: <AM0PR05MB48665001B54D3F29A9D4127FD1760@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20191111192219.30259-1-jeffrey.t.kirsher@intel.com>
 <20191112212826.GA1837470@kroah.com> <20191113000819.GB19615@ziepe.ca>
 <AM0PR05MB48662DEDDE4750D399B8181ED1760@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191113011038.GC19615@ziepe.ca>
In-Reply-To: <20191113011038.GC19615@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [2605:6000:ec82:1c00:64c2:47ad:dfe6:e0d9]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 799655a4-9902-414d-42c5-08d76804fb18
x-ms-traffictypediagnostic: AM0PR05MB5041:
x-microsoft-antispam-prvs: <AM0PR05MB50412F3515FDE6E605510845D1760@AM0PR05MB5041.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0220D4B98D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39860400002)(396003)(346002)(136003)(376002)(199004)(189003)(25786009)(6916009)(54906003)(4326008)(6246003)(99286004)(256004)(229853002)(76116006)(9686003)(6436002)(71200400001)(71190400001)(55016002)(7416002)(52536014)(476003)(8936002)(102836004)(186003)(11346002)(446003)(478600001)(4744005)(33656002)(7696005)(5660300002)(7736002)(74316002)(76176011)(486006)(6506007)(305945005)(86362001)(81166006)(81156014)(2906002)(14454004)(8676002)(316002)(6116002)(64756008)(46003)(66446008)(66476007)(66556008)(66946007);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB5041;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qx1gi/JVDYo7SJiXD/MJ07Z+DOnTe9Q4F5nmqK8it7ul65ifggvLuy62vc4ohJz4dEkSCcwdw5EhCGVcQ74fXav3psocjLfo+dWzw4jTEoU71TVvOdN8MnRpGIhjmoHaLIg1RXitgBYH9C36TNvShqbUj9E/GZ6cGBveXSR1/K6dbbnpo+oE3QszT/zL5BC438dvbv/4LnW0XVNb1TgxcqBPdYPK1JopQvy385oznv2JCM6b7Fcp2aJayU68K4hXtzz53qKykokD5bZZnx7lg2jnAGUsGLCn3Zq2tWHKSVcx8cTObDfDNevAyowgtwdRcqIp8iNJN4g+yv1Rqz0Od5ERPq2EYk5qlQEcON6gLzxwgMTrvSlsEMn596dQhOAZzfjOhJV0MqZ0uSHQk7ohf2El1VyG6viUU35e3sRkOVB5eX2EDIFWjs58xbBId+Tt
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 799655a4-9902-414d-42c5-08d76804fb18
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2019 06:44:49.6284
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: s4y4qfIQtdAw/f9JBfdiY3OTK1rRAoojHmlU/CuNQrOc7VAzcIu1C95IkjpLbBILMcZIHvaCjp5SaaZj4Q2GpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5041
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> From: Jason Gunthorpe <jgg@ziepe.ca>
> Sent: Tuesday, November 12, 2019 7:11 PM
>=20
> > A small improvement below, because get_drvdata() and set_drvdata()
>=20
> Here it was called 'devdata' not the existing drvdata - so something diff=
erent, I
> was confused for a bit too..
>=20
Oh ok. but looks buggy in the patch as virtbus_dev doesn't have devdata fie=
ld.
Anyways, container_of() is better type checked anyway as below.

+#define virtbus_get_devdata(dev)	((dev)->devdata)

> > is supposed to be called by the bus driver, not its creator.  And
> > below data structure achieve strong type checks, no void* casts, and
> > exactly achieves the foo_device example.  Isn't it better?
>=20
> > mlx5_virtbus_device {
> > 	struct virtbus_device dev;
> > 	struct mlx5_core_dev *dev;
> > };
>=20
> This does seem a bit cleaner than using the void * trick (more, OOPy at l=
east)
>=20
Ok. thanks.
