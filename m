Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02410140C29
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 15:12:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727029AbgAQOMl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 09:12:41 -0500
Received: from mail-eopbgr130084.outbound.protection.outlook.com ([40.107.13.84]:3056
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726587AbgAQOMl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Jan 2020 09:12:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ICx4vOUtHhz6uHT6wCqn4J0MssNiHfvJKWJ/d2mn8bDene7LQ5CoZMQaUgBtfFEoRAFYw00L8YnC+A4/Wt1AJPEpUlOO+ePg9OcV4QJp/EYGBjGFXT3AU4ReKRCHFNtQ9CCHD17VeeZsbBppZzGpc/79VrR9BwE/UFUxKuMDksCaM9qgpwL9aSy1Lw8I83am5vXF3bRGkEtJraBcA2GUVx4Mn9jXtj1OexV+V/+v5UcWar6ZV5OdKigEBsJCq8GI3qdlup4ng2XhzcQXbj6zhhep0RUvUA93aDp0TMLvmNEsO78SpR2CX+26g2Lf+4/PAFDCv4KTIO4U3a8d9+pi0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ecJpKM6ZOBTomW7zOQOag7Vn747Fuvk4qAGIeDeK+6Q=;
 b=NRskaMuRO6ueagOqjmC/jk51xyeTo4u2pRl8+xVly5u9S/79ETnUlnp3cmKQ99EmbCu7p3h9e3HMVJEZzodpj75OCajNIjL4n7ZpHFqqGsqut5xyDenQm6cbqcWSBPr7LZz3vHeVHp0ehMBwgftGR+uCpgnhk8Zx9zd2WbqBPJjGgZm9ihCcmBai95wNqJHMsp7xqk14oxXKRVu8bcTeyWQfFIbKtdYC5Z3t1usBLTPoDNdy5fAoxBv0LWlKJucMU4iqysCwbkIuVRj03ZA/WFuSNXIS5XTHzvY1V8wzYLJ98LtRo+EuwTF4S90PMb/zYrLSeCTQ93GQ49rx+MFpWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ecJpKM6ZOBTomW7zOQOag7Vn747Fuvk4qAGIeDeK+6Q=;
 b=GhoOZhY6WGB9yBKjhfif6bbz/xNsXCy2uxtJ1YPObwJVPuK9QGrFcY2aW0EFjDtSr91QXneTJVIcci7VCKQVUYTUQWDAkcyRxN8m2VEULZ91AQPx0UWKDS+3turtWtdTMcPI+r4NNrKwtJm5zBXIW21grzh0I1VUCxyrTomJMiE=
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (52.133.14.15) by
 VI1PR05MB4671.eurprd05.prod.outlook.com (20.176.3.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.22; Fri, 17 Jan 2020 14:12:35 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::1c00:7925:d5c6:d60d]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::1c00:7925:d5c6:d60d%7]) with mapi id 15.20.2644.015; Fri, 17 Jan 2020
 14:12:35 +0000
Received: from mlx.ziepe.ca (142.68.57.212) by MN2PR10CA0023.namprd10.prod.outlook.com (2603:10b6:208:120::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.20 via Frontend Transport; Fri, 17 Jan 2020 14:12:35 +0000
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)     (envelope-from <jgg@mellanox.com>)      id 1isSMS-0008Nn-5n; Fri, 17 Jan 2020 10:12:32 -0400
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     "santosh.shilimkar@oracle.com" <santosh.shilimkar@oracle.com>,
        "David S . Miller" <davem@davemloft.net>
CC:     Leon Romanovsky <leonro@mellanox.com>,
        Doug Ledford <dledford@redhat.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Hans Westgaard Ry <hans.westgaard.ry@oracle.com>,
        Moni Shoua <monis@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH mlx5-next 00/10] Use ODP MRs for kernel ULPs
Thread-Topic: [PATCH mlx5-next 00/10] Use ODP MRs for kernel ULPs
Thread-Index: AQHVy6FvxnMGsXYFhEqsZB6HjluKCafs3buAgAB0qICAAF49AIABOG4A
Date:   Fri, 17 Jan 2020 14:12:35 +0000
Message-ID: <20200117141232.GX20978@mellanox.com>
References: <20200115124340.79108-1-leon@kernel.org>
 <20200116065926.GD76932@unreal> <20200116135701.GG20978@mellanox.com>
 <6ef540ae-233f-50cd-d096-3eeae31410cc@oracle.com>
In-Reply-To: <6ef540ae-233f-50cd-d096-3eeae31410cc@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MN2PR10CA0023.namprd10.prod.outlook.com
 (2603:10b6:208:120::36) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [142.68.57.212]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 2afb99ab-a28d-4259-bc36-08d79b574d16
x-ms-traffictypediagnostic: VI1PR05MB4671:|VI1PR05MB4671:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB46710F2DD77E6D31D858C3B5CF310@VI1PR05MB4671.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0285201563
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(39860400002)(396003)(366004)(346002)(189003)(199004)(8676002)(86362001)(66556008)(64756008)(66446008)(66946007)(508600001)(81156014)(8936002)(2906002)(26005)(81166006)(33656002)(4326008)(53546011)(66476007)(5660300002)(71200400001)(316002)(1076003)(9746002)(9786002)(52116002)(36756003)(2616005)(186003)(54906003)(110136005)(24400500001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4671;H:VI1PR05MB4141.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RMRThBATWlU6fQ8b9sZ12+ans0JW5ewi6gttuPU51nvjOBDGBLgM2us0QP+eHlkd8+klTIQYUFg2rUGFn8YlYW9UJC0KEPoI8Y9WM8tpwnddMMqZ2rpWop4EZjNN6duqL09RIHeAvvxg0cPV46R0YYvdC00cXbgS7mkDdrEDVZWmSHlkDxkTkBCxCf4JyToQ8KVZO/f5xRJItdVU51lwQDfTk83DLsZ3HlIlwzhlGredVqoRBpEcr6bkF8yDB1vRmiJIXupqZfbWJdOLyoplG1VCQpQibr2HLPdF0B5ejs1W2nvDsqd8ClVuYrmp9w3agOR9E+EfztKzIjVnqObOc4fID0nuhquTkskqPROrdRH6lIqYEnmFBx3I4gNzr13IwJBmMbugvGCVQGXklEZsN6wZlA6N004yLEKq1e8lDB7jLnz/zKgIrSk+jzY8ggGcoydIVQByGhdgQgg2c8HSV2oJE7s/DnGnx4JsQ/T5AG+ckHKVvBCH4FPX2ZSN54dX
Content-Type: text/plain; charset="us-ascii"
Content-ID: <566ED0466275DB4FABE2EA49719274FB@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2afb99ab-a28d-4259-bc36-08d79b574d16
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2020 14:12:35.6568
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iZ6XDP0cqUB4mq3j1BzeUHBCEDG34lZf3/Hz0tOpYxqCvNdkICp7F3cSdW/bfwDqMs/5MRuxlcSNjtoNVgdL7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4671
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 16, 2020 at 11:34:18AM -0800, santosh.shilimkar@oracle.com wrot=
e:
> On 1/16/20 5:57 AM, Jason Gunthorpe wrote:
> > On Thu, Jan 16, 2020 at 06:59:29AM +0000, Leon Romanovsky wrote:
> > > >   45 files changed, 559 insertions(+), 256 deletions(-)
> > >=20
> > > Thanks Santosh for your review.
> > >=20
> > > David,
> > > Is it ok to route those patches through RDMA tree given the fact that
> > > we are touching a lot of files in drivers/infiniband/* ?
> > >=20
> > > There is no conflict between netdev and RDMA versions of RDS, but to =
be
> > > on safe side, I'll put all this code to mlx5-next tree.
> >=20
> > Er, lets not contaminate the mlx5-next with this..
> >=20
> > It looks like it applies clean to -rc6 so if it has to be in both
> > trees a clean PR against -rc5/6 is the way to do it.
> >=20
> > Santos, do you anticipate more RDS patches this cycle?
> >=20
>=20
> Not for upcoming merge window afaik.

In this case DaveM, will you ack and we can take it through RDMA?

The RDMA pieces look OK to me, like Santos I have reviewed many
versions of this already..

Thanks,
Jason
