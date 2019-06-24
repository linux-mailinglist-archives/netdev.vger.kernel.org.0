Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA8A051A43
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 20:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732744AbfFXSGe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 14:06:34 -0400
Received: from mail-eopbgr70047.outbound.protection.outlook.com ([40.107.7.47]:64100
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727763AbfFXSGe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jun 2019 14:06:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2biWmX6ZcjLjqPD6CMQr1M54CANFqtTod/77DEvjjME=;
 b=kvOpKrY7LdYpceEr7v66E+z4UpwUUG4zZNL4Rf7uY0HKl8Cf6KNTY0EpoRh/Brut1p5jnX3qyt2LmaF3qp7a5x4WX8FNjBDL3z5mYBRMHsCrJiAAN48Bz2n59RVBGqJsOGpUQ8z3nuk/fIv8l3o9XCZmtrCjgALVAABoiKYHVrc=
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (10.171.182.144) by
 VI1PR05MB4109.eurprd05.prod.outlook.com (10.171.182.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Mon, 24 Jun 2019 18:06:30 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::f5d8:df9:731:682e]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::f5d8:df9:731:682e%5]) with mapi id 15.20.2008.014; Mon, 24 Jun 2019
 18:06:30 +0000
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Yishai Hadas <yishaih@dev.mellanox.co.il>
CC:     Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Yishai Hadas <yishaih@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH rdma-next v1 12/12] IB/mlx5: Add DEVX support for CQ
 events
Thread-Topic: [PATCH rdma-next v1 12/12] IB/mlx5: Add DEVX support for CQ
 events
Thread-Index: AQHVJfmQvavTw2y7SkG9YQoAEAS33KaqvfAAgABTgICAABGwAA==
Date:   Mon, 24 Jun 2019 18:06:29 +0000
Message-ID: <20190624180626.GM7418@mellanox.com>
References: <20190618171540.11729-1-leon@kernel.org>
 <20190618171540.11729-13-leon@kernel.org>
 <20190624120416.GE5479@mellanox.com>
 <a076a050-871b-c468-f62e-95bb4f0ac2c2@dev.mellanox.co.il>
In-Reply-To: <a076a050-871b-c468-f62e-95bb4f0ac2c2@dev.mellanox.co.il>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0199.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1f::19) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:4d::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [66.187.232.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8b9fd080-832a-4a31-9761-08d6f8ceaea5
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR05MB4109;
x-ms-traffictypediagnostic: VI1PR05MB4109:
x-microsoft-antispam-prvs: <VI1PR05MB41098F02D46C1AB4EBFD0AA3CFE00@VI1PR05MB4109.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 007814487B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(376002)(136003)(366004)(39860400002)(396003)(199004)(189003)(66066001)(6246003)(6512007)(81156014)(8676002)(81166006)(7736002)(68736007)(71190400001)(25786009)(478600001)(305945005)(316002)(54906003)(6862004)(4326008)(3846002)(6116002)(33656002)(229853002)(53936002)(14454004)(36756003)(52116002)(8936002)(53546011)(99286004)(26005)(6486002)(186003)(6436002)(386003)(102836004)(6506007)(76176011)(66556008)(446003)(14444005)(256004)(476003)(5660300002)(66476007)(1076003)(486006)(11346002)(66946007)(71200400001)(66446008)(64756008)(86362001)(2906002)(73956011)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4109;H:VI1PR05MB4141.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: RwW/5BU8g5R6R55GLTU4wiMXFz0JVRGVoiQIPRXJjAJG9UvRyboJiWFQr4WRYPRCjS0spu5y3brp03IzLbuAeOKZjQsgLdz9AfOdrp2bkwQ0pdjb4857qs8C8ehpIH0fPC7TVXmXDn9L/JiBIcnZeEJDtWn4zsGdPP5cd5onf9SGc+NVBPOTg7K5kYulSa0RVq/pPhh//9iXcrqfa2P3snJYtPY1Zz2l0fBV/zrWIBNjvtalhs7BCMqjVV2IuardSf+PTDH6/FE//OCXRfeWxGH6C6ZYkstWC4YZVmnBjXbewbsaBjKQ5I/ae1ZZFi42Uo5Je6mK2nsnxKZDWXg1ZSwCvyauK7AqpEYAOJqe6ng8xoElchgFWv1NUnp2Wo89YilQdDlAqMO+CLjjXdDbrj7NqIgcA++vXUikrFMep1w=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5BDBA9AF588FF647BFDD2A999E521D68@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b9fd080-832a-4a31-9761-08d6f8ceaea5
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2019 18:06:30.0001
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jgg@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4109
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 24, 2019 at 08:03:07PM +0300, Yishai Hadas wrote:
> On 6/24/2019 3:04 PM, Jason Gunthorpe wrote:
> > On Tue, Jun 18, 2019 at 08:15:40PM +0300, Leon Romanovsky wrote:
> > > From: Yishai Hadas <yishaih@mellanox.com>
> > >=20
> > > Add DEVX support for CQ events by creating and destroying the CQ via
> > > mlx5_core and set an handler to manage its completions.
> > >=20
> > > Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
> > > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> > >   drivers/infiniband/hw/mlx5/devx.c | 40 ++++++++++++++++++++++++++++=
+++
> > >   1 file changed, 40 insertions(+)
> > >=20
> > > diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/h=
w/mlx5/devx.c
> > > index 49fdce95d6d9..91ccd58ebc05 100644
> > > +++ b/drivers/infiniband/hw/mlx5/devx.c
> > > @@ -19,9 +19,12 @@
> > >   #define UVERBS_MODULE_NAME mlx5_ib
> > >   #include <rdma/uverbs_named_ioctl.h>
> > > +static void dispatch_event_fd(struct list_head *fd_list, const void =
*data);
> > > +
> > >   enum devx_obj_flags {
> > >   	DEVX_OBJ_FLAGS_INDIRECT_MKEY =3D 1 << 0,
> > >   	DEVX_OBJ_FLAGS_DCT =3D 1 << 1,
> > > +	DEVX_OBJ_FLAGS_CQ =3D 1 << 2,
> > >   };
> > >   struct devx_async_data {
> > > @@ -94,6 +97,7 @@ struct devx_async_event_file {
> > >   #define MLX5_MAX_DESTROY_INBOX_SIZE_DW MLX5_ST_SZ_DW(delete_fte_in)
> > >   struct devx_obj {
> > >   	struct mlx5_core_dev	*mdev;
> > > +	struct mlx5_ib_dev	*ib_dev;
> >=20
> > This seems strange, why would we need to store the core_dev and the ib_=
dev
> > in a struct when ibdev->mdev =3D=3D core_dev?
> >=20
>=20
> We need to add the ib_dev as we can't access it from the core_dev.
> Most of this patch we can probably go and drop the mdev and access it fro=
m
> ib_dev, I preferred to not handle that in this patch.

Should add a patch to revise it then

Jason
