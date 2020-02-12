Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8D9F15A0F7
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 06:58:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728148AbgBLF6o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 00:58:44 -0500
Received: from mail-eopbgr70054.outbound.protection.outlook.com ([40.107.7.54]:6212
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727163AbgBLF6o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Feb 2020 00:58:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Or2McDkYT63vg5hk8av8inF/TVICxheE0G3vohVCXZnckBUOQcRuqO++iwdtgYz1ONIVMxTihKc8hehP5uHegvFNzGUYaQ2sU+oRVD0s+Kbtu+TG+EVlIDkBoYT2kR7Wgjw0FKjXqUWXBVLmz6kfbCZ+UC5bsCiZsu3ndeeTJ5ssOf06MDc4NyIUGJxTf1eDpGAAglRn2Zgu0MgPD6A2fmX9Uotq4T4iO+sgKSXBFMjoKBbYOZqnyK3hMvZF7ix+HgLGTn8ONQGb+3Q4efrK4PMrvzvm/VXZyjurs82qMCuJ3ER2kvjnSthK21TLXV62bkoiY7AcE7b479GTY6ijSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aZn7Xum9kDJbRRBJ8kx0YOayqB+tCSpQnIKvMdNJOaQ=;
 b=nW1QTlct5i/PSszhk5ucYvpZfWwzlUBqzZsAOIcN+kvvuaZofbUOjFUasYKmxYXwXYbfcSLa6tUn9bLNvnXdn6sl7NY91cUsAwdVbxSgtxbOMp7HC1y60kYDvsJNtGymvzs0s2ho42N18C1VaBvI206WUCxM4s7zKW5UywY3GPXfsmPcJR1Q+XfvUEzZ7qjR1nP4IWW+sWa7oPbaIpWR4r0Cy43t6NK+EYUcHDmOKapxfpSYOE8P1qvWXyDPbjOaZdwC4ueYlvWw3PveIoSxjbYRxTC0ZPyeg7KnU5bDDp7jQFLpY5AeLhi5llaNqSiFx5wWTaXQaEDd6QAysG++iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aZn7Xum9kDJbRRBJ8kx0YOayqB+tCSpQnIKvMdNJOaQ=;
 b=geZJEGHZRjpduHYzRFhA6d1RpTB75w+IDJiL/BesS2G+M7zwlZAmj5VbMGlLMq4PPFCoDN1KrpRfTfzDbd12j5TUFTU+T5t5BnQbjm4pL7k+PkWLWDsF0zY1WgAeaPiuHUargMLC3AUfTmvJFTwZR9vDBDCAm/MglzPXAfgpnUY=
Received: from AM0PR05MB5250.eurprd05.prod.outlook.com (20.178.18.79) by
 AM0PR05MB4660.eurprd05.prod.outlook.com (52.133.55.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.25; Wed, 12 Feb 2020 05:58:40 +0000
Received: from AM0PR05MB5250.eurprd05.prod.outlook.com
 ([fe80::2d7b:6cce:da16:b166]) by AM0PR05MB5250.eurprd05.prod.outlook.com
 ([fe80::2d7b:6cce:da16:b166%5]) with mapi id 15.20.2707.030; Wed, 12 Feb 2020
 05:58:39 +0000
From:   Raed Salem <raeds@mellanox.com>
To:     David Miller <davem@davemloft.net>
CC:     "steffen.klassert@secunet.com" <steffen.klassert@secunet.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuznet@ms2.inr.ac.ru" <kuznet@ms2.inr.ac.ru>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>
Subject: RE: [PATCH net-next] ESP: Export esp_output_fill_trailer function
Thread-Topic: [PATCH net-next] ESP: Export esp_output_fill_trailer function
Thread-Index: AQHV4LQeAv17UzFDwUWM81MDwC2yNagWwCWAgABRVIA=
Date:   Wed, 12 Feb 2020 05:58:39 +0000
Message-ID: <AM0PR05MB52508390E49CDF2FE039AD32C41B0@AM0PR05MB5250.eurprd05.prod.outlook.com>
References: <1581409202-23654-1-git-send-email-raeds@mellanox.com>
 <20200211.170721.1119133630862180946.davem@davemloft.net>
In-Reply-To: <20200211.170721.1119133630862180946.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=raeds@mellanox.com; 
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 18916a0f-21f1-4b88-0f5f-08d7af809bb6
x-ms-traffictypediagnostic: AM0PR05MB4660:
x-microsoft-antispam-prvs: <AM0PR05MB4660B9DC74B9877E697AE97DC41B0@AM0PR05MB4660.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 0311124FA9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39860400002)(346002)(376002)(136003)(396003)(189003)(199004)(52536014)(2906002)(4744005)(6506007)(53546011)(54906003)(33656002)(4326008)(9686003)(6916009)(71200400001)(316002)(8676002)(81166006)(86362001)(55016002)(8936002)(81156014)(66946007)(5660300002)(7696005)(478600001)(66446008)(64756008)(76116006)(66476007)(66556008)(186003)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4660;H:AM0PR05MB5250.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZJncjLOffXrYEgwOKtzXpIbu/NJIA8QxVxN7OYns5lkFceR8E0guz7QZHRBf4lejSnX2pu63wvQizoUN6Mbf5AaghoClW5EHGCAH7uDBr8kefLA6f32+v5pMtUuKCiSMIw5D0VkxrjpVXq5lx3UuOOdrnSZkXm/18ZNhKjMqCX8Asdiq5tU++6LG9PyOq43YYqbmE1bpY3TeQjl3pAYEELv3JHsvtemdzueFklG9l3AxPb98m5q2kG7F34ePTtmCKakWcs9CIHX4urg0SQDzTSfNSyI5WHUKmxFb4CU2DyOo8r0z3q0IYlEsxxiVPipTXNZYw69zU6vB4+efvJulKaPjNMHkfm+RepxaFBYenUhXDIJeVL/+XGonXQgb7xZqxCtx6C8ceItY52b994Ep0x8tk1UfW74e+r8+dul1mFNJC6iDraJ8/2f5qMtBhIQv
x-ms-exchange-antispam-messagedata: oVRfJ/ZxY2OrBpM/cKuU4KfqpjjxD7DUprHruJfwOOLNgbutZezQ+ZdCo1bavU/iZiWAh0NR2S+1hF3p3bEkraq37JsNvJavxOOqRNvNhqTaxh/33e1I8xowHW+vpP+Vd0CtqHPi9BgL9NH/ENQV1g==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18916a0f-21f1-4b88-0f5f-08d7af809bb6
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Feb 2020 05:58:39.7610
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Zjx/vGgzGfMz5TF+OwjOs0QjbL33LIY7S1Puw82NSDcfi4yhbvU3Q64OEIHUD4bdHousCzeN5qJVS/fng/QS/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4660
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks, will do

-----Original Message-----
From: David Miller [mailto:davem@davemloft.net]=20
Sent: Wednesday, February 12, 2020 3:07 AM
To: Raed Salem <raeds@mellanox.com>
Cc: steffen.klassert@secunet.com; herbert@gondor.apana.org.au; netdev@vger.=
kernel.org; kuznet@ms2.inr.ac.ru; yoshfuji@linux-ipv6.org
Subject: Re: [PATCH net-next] ESP: Export esp_output_fill_trailer function

From: Raed Salem <raeds@mellanox.com>
Date: Tue, 11 Feb 2020 10:20:02 +0200

> The esp fill trailer method is identical for both
> IPv6 and IPv4.
>=20
> Share the implementation for esp6 and esp to avoid code duplication in=20
> addition it could be also used at various drivers code.
>=20
> Change-Id: Iebb4325fe12ef655a5cd6cb896cf9eed68033979
> Signed-off-by: Raed Salem <raeds@mellanox.com>
> Reviewed-by: Boris Pismenny <borisp@mellanox.com>
> Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>

net-next is closed, please resubmit this when it opens back up
