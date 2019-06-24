Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C76B150E12
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 16:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727406AbfFXOa6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 10:30:58 -0400
Received: from mail-eopbgr10046.outbound.protection.outlook.com ([40.107.1.46]:10158
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726376AbfFXOa5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jun 2019 10:30:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=toXb0uLVrlzaKw47HGpiiZEZ+J9mj/8cPfrwj9NuwLI=;
 b=b6lHAwh9iRq5Q5u2cMSdC7aCNysMLuKQWG7T06pyrzWTX/0+vlE9xf/HvwqWkOtjzsjr/Is9JpGLhHhgYwbZ+F7n4x/HpX8t7OK8KR2Rn9vQLgHZs85B4asRvQTMKwpW1Fzb/17UPrU541730L1ySYh0R7W7iRoEeefZCE9cquw=
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (10.171.182.144) by
 VI1PR05MB3279.eurprd05.prod.outlook.com (10.170.238.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Mon, 24 Jun 2019 14:30:51 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::f5d8:df9:731:682e]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::f5d8:df9:731:682e%5]) with mapi id 15.20.2008.014; Mon, 24 Jun 2019
 14:30:51 +0000
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Yishai Hadas <yishaih@dev.mellanox.co.il>
CC:     Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Yishai Hadas <yishaih@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH rdma-next v1 09/12] IB/mlx5: Register DEVX with mlx5_core
 to get async events
Thread-Topic: [PATCH rdma-next v1 09/12] IB/mlx5: Register DEVX with mlx5_core
 to get async events
Thread-Index: AQHVJfmSu0XgQnFVQEaPQvnXI+7VUqaquooAgAAdPACAAA8agA==
Date:   Mon, 24 Jun 2019 14:30:51 +0000
Message-ID: <20190624143047.GD7418@mellanox.com>
References: <20190618171540.11729-1-leon@kernel.org>
 <20190618171540.11729-10-leon@kernel.org>
 <20190624115206.GB5479@mellanox.com>
 <3bc6780f-5c3e-b121-e4ea-f7b8f00cbd13@dev.mellanox.co.il>
In-Reply-To: <3bc6780f-5c3e-b121-e4ea-f7b8f00cbd13@dev.mellanox.co.il>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0118.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:19::34) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:4d::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [66.187.232.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f34c146f-010f-457b-902b-08d6f8b08e93
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR05MB3279;
x-ms-traffictypediagnostic: VI1PR05MB3279:
x-microsoft-antispam-prvs: <VI1PR05MB32790762C80296165337F66FCFE00@VI1PR05MB3279.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 007814487B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(346002)(396003)(376002)(366004)(39860400002)(189003)(199004)(6246003)(6862004)(14454004)(5660300002)(71200400001)(52116002)(71190400001)(66946007)(53936002)(186003)(446003)(316002)(7736002)(486006)(476003)(229853002)(66476007)(8936002)(6436002)(66446008)(53546011)(25786009)(76176011)(66556008)(86362001)(64756008)(73956011)(81156014)(1076003)(8676002)(6512007)(81166006)(6506007)(99286004)(386003)(14444005)(6486002)(305945005)(26005)(102836004)(66066001)(3846002)(6116002)(2616005)(54906003)(11346002)(33656002)(36756003)(2906002)(478600001)(68736007)(4326008)(256004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB3279;H:VI1PR05MB4141.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 3SimkgAaltii4pQy7jozAKXsOSXFsYLIbbWQHColAwdv7Nqlwy9j5on+Wg9hXwbhwmdV4yebZ/bxlqvxTZNa+8tjoM4FSsvXpg/qlhEVOOGZMTYtrBGzy47yGT63plWBJklSq9hLCo4voPIFJSi4NqaCBl4iIxP3oQAl4fBPAjkuosme9bJE8HMSP8/zYJ8lkXtwBiawuzLssP550d13TYO0XFQb6td+oFmV/ya4rFAry7WRp6SypiepICDPaa5yGC0WkYSTvjn4BxzhyYSmmEW5n733DNs3rD8ZCQY3Nu6ru4INvaH94gmKHOSO0Yu04UjNsO5rMeHMJNL33IFIXu/D8x5YE4OChdx9i8ezpkebJZAtvNxhtP/KOiNYS2O7+GB/G8KbY/0UeLjXJPJSb5KH7MiNgRci80ezqUSVsiQ=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C68FF18D75BE184DAA10F58247D6D7A2@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f34c146f-010f-457b-902b-08d6f8b08e93
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2019 14:30:51.2310
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jgg@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3279
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 24, 2019 at 04:36:44PM +0300, Yishai Hadas wrote:
> On 6/24/2019 2:52 PM, Jason Gunthorpe wrote:
> > On Tue, Jun 18, 2019 at 08:15:37PM +0300, Leon Romanovsky wrote:
> > >   void __mlx5_ib_remove(struct mlx5_ib_dev *dev,
> > > diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniban=
d/hw/mlx5/mlx5_ib.h
> > > index 9cf23ae6324e..556af34b788b 100644
> > > +++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
> > > @@ -944,6 +944,13 @@ struct mlx5_ib_pf_eq {
> > >   	mempool_t *pool;
> > >   };
> > > +struct mlx5_devx_event_table {
> > > +	struct mlx5_nb devx_nb;
> > > +	/* serialize updating the event_xa */
> > > +	struct mutex event_xa_lock;
> > > +	struct xarray event_xa;
> > > +};
> > > +
> > >   struct mlx5_ib_dev {
> > >   	struct ib_device		ib_dev;
> > >   	struct mlx5_core_dev		*mdev;
> > > @@ -994,6 +1001,7 @@ struct mlx5_ib_dev {
> > >   	struct mlx5_srq_table   srq_table;
> > >   	struct mlx5_async_ctx   async_ctx;
> > >   	int			free_port;
> > > +	struct mlx5_devx_event_table devx_event_table;
> >=20
> > I really question if adding all these structs really does anything for
> > readability..
> >=20
>=20
> I would prefer this option to add only one structure (i.e.
> mlx5_devx_event_table) on ib_dev, it will hold internally the other relat=
ed
> stuff.

It seems confounding but generally is the style in this struct :\

Jason
