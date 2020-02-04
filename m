Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80EE2151AF0
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 14:07:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727228AbgBDNHw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 08:07:52 -0500
Received: from mail-vi1eur05on2056.outbound.protection.outlook.com ([40.107.21.56]:35808
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727149AbgBDNHv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Feb 2020 08:07:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lCyPBUpppM2gchUIOJSXpo9ctiO66LO07CCxkLvW+OrXEW0W9x8xfbjjiGZAiQXodPA7PBAQtSuyHzBASxn4X8PDQ2itFV26mGkEt9tNPxnZiSmhRWoGTLeZV40W8LJzM0pXzB1bQXnZAkvb6YceFN+x6qLTSS0ioyA+D7mCPe0Gd95oGeTe3//ZhgBydqtlwl9r4M7G88029wkScIvXA+wcE+MUkee4FLgaWoD0Wl/oNk6H1RmDGZt/22zCn6khFOfRImMZagWFyQBmnhRB291k1ut/pg1NpUIU5dRhDgQS47MToXbrD6H9GDa/3ER0UgdhSPlOYJhQ+iT1/pH+2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=51EqVhxO7p90Z9IiGDHyymLaSHtOdWQKCPhkJVEUejk=;
 b=oLALKQ+mSGAEOalb+/6LHYkRsEc0LSenRoblrOv9Ie0fUaURiw/gNjbIWgmLKxYzdl5/WhnhOdGMA3mJuBjkr6Qlh3gBRr9Apr9Ty4kl7/m18raKAusggGl5Wc8GEFI93asZaD7hWNxiFa8+zXJoQPa7XKBqasYRV96N/8jEWQ7dinJZknA61whWYaA/rvtkLzFznEqhPRVnAYhL8y/TbAbeMHsp6Z0OkwDekSUrOxjEGHfx2qPfu9wKQkC3jbHhfn9z96ECIu3lmMQuvmSBTMszKW0lT282tJ7DcCT2dQ2nCKV0lZ39l7Eapz6Vjhof9pWkM5ebBkL4i2wfOiHwqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=51EqVhxO7p90Z9IiGDHyymLaSHtOdWQKCPhkJVEUejk=;
 b=N55e/4H+VTznsJN3awoSekfadFcNYIkNLCBQXgk1ulGpz0vTBTokmNUclY81YUhGho+1N0Eq6iJs//cu3d5sqH/mu97bZetS2dwO2YAFK+TzeMw5sTp927mxd+Yh3j/GYKAH9sxJJwho+wqmN8c51l5siWgMl8uM46y40XdKGPg=
Received: from AM0PR05MB5250.eurprd05.prod.outlook.com (20.178.18.79) by
 AM0PR05MB4580.eurprd05.prod.outlook.com (52.133.56.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2686.29; Tue, 4 Feb 2020 13:07:47 +0000
Received: from AM0PR05MB5250.eurprd05.prod.outlook.com
 ([fe80::2d7b:6cce:da16:b166]) by AM0PR05MB5250.eurprd05.prod.outlook.com
 ([fe80::2d7b:6cce:da16:b166%5]) with mapi id 15.20.2686.031; Tue, 4 Feb 2020
 13:07:47 +0000
From:   Raed Salem <raeds@mellanox.com>
To:     David Miller <davem@davemloft.net>
CC:     "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net] tls: handle NETDEV_UNREGISTER for tls device
Thread-Topic: [PATCH net] tls: handle NETDEV_UNREGISTER for tls device
Thread-Index: AQHV2bsmJ+Tm78S/C06QUcLZ5O8x56gK6ZmAgAAahEA=
Date:   Tue, 4 Feb 2020 13:07:47 +0000
Message-ID: <AM0PR05MB52507339607E5BF60372A878C4030@AM0PR05MB5250.eurprd05.prod.outlook.com>
References: <1580642572-21096-1-git-send-email-raeds@mellanox.com>
 <20200204.123041.1506575968362096923.davem@davemloft.net>
In-Reply-To: <20200204.123041.1506575968362096923.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=raeds@mellanox.com; 
x-originating-ip: [89.138.173.28]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 2084b68e-8ee3-4f31-4ad1-08d7a9733b30
x-ms-traffictypediagnostic: AM0PR05MB4580:
x-microsoft-antispam-prvs: <AM0PR05MB4580AB480B99373E58939C31C4030@AM0PR05MB4580.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:478;
x-forefront-prvs: 03030B9493
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(346002)(396003)(376002)(366004)(199004)(189003)(4326008)(9686003)(6916009)(478600001)(52536014)(8676002)(81166006)(81156014)(316002)(55016002)(54906003)(2906002)(71200400001)(76116006)(66446008)(66556008)(64756008)(66476007)(6506007)(53546011)(7696005)(5660300002)(186003)(86362001)(26005)(8936002)(66946007)(33656002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4580;H:AM0PR05MB5250.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: swcmCMB7U7mHhyA6KN2ue6xyT394waEac2OO5ih2mBSBEynNDb3VZHP22aok3SRCVVyG5L/LDrlrmSS8FtV4VD6esyHmSuLQcynU6VW2dpURFGh76HnaBDu2QK//LEDpV/zZmyN/5MhzXGS/ayiCRFPWvccxBFZVQ4eW47Ltkue2T6giP7GIWDw8alFDI72aOgu5oEGWsx6WYytp8bdPYkihPC+2VPlPSN/v3mxPvgz823NhoAa/5UpeO6WxSX67YQmGZSx1th1Tr5g/nqJBpwQg6NE0rIJn/GkO6SZvnq5g0WhpkqaBR5FiqyU7XXxdJlI80K86tIsO8p1ZuXdaoxMEchYuZZRgcZVrIRRxZKG34mqTnQU0XOy/4e7devVf2ycdIte1X47LUAz08LuNgDRYCt27+7C0B+MBHFP8lFW3tPmNiqEAgn5EIMpmsQnZ
x-ms-exchange-antispam-messagedata: x2UwemEQu4ZnU4pgp0Ah1TYGXaiSQs4ERMlkWUqxEUVlibWXEmhJGr0d39h4WoHP3ri35F2yC7MpdoYZVa47Gihp3v/feC/7KvR1rvjWIB6pAmXDJlcqdhpQO7o/2G7xYJgXuathlM/M31z3MR9UdA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2084b68e-8ee3-4f31-4ad1-08d7a9733b30
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Feb 2020 13:07:47.3849
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ia1LFJMlqE3m0MCmLh3U/+OwK5yVLs7h2q+9UCA63zjqaIbi7uK+4ZfwkHbtMlqJFm3oh0w0aJy252lmspf3Tw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4580
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks David/Jakubs for the review,

I had problems with the setup, once I have results I resubmit on need.


> -----Original Message-----
> From: David Miller [mailto:davem@davemloft.net]
> Sent: Tuesday, February 04, 2020 1:31 PM
> To: Raed Salem <raeds@mellanox.com>
> Cc: john.fastabend@gmail.com; daniel@iogearbox.net; kuba@kernel.org;
> netdev@vger.kernel.org
> Subject: Re: [PATCH net] tls: handle NETDEV_UNREGISTER for tls device
>=20
> From: Raed Salem <raeds@mellanox.com>
> Date: Sun,  2 Feb 2020 13:22:52 +0200
>=20
> > This patch to handle the asynchronous unregister device event so the
> > device tls offload resources could be cleanly released.
> >
> > Fixes: e8f69799810c ("net/tls: Add generic NIC offload
> > infrastructure")
> > Signed-off-by: Raed Salem <raeds@mellanox.com>
> > Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
> > Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
>=20
> As per Jakub's feedback, only devices which are UP can have TLS rules
> installed to them.
>=20
> Therefore we will always get the NETDEV_DOWN event first, to release the
> TLS resources.
>=20
> So I am tossing this patch.  If there is a real problem, you must describ=
e it in
> detail in the commit message.
