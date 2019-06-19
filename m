Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 254964B265
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 08:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731062AbfFSGvc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 02:51:32 -0400
Received: from mail-eopbgr30074.outbound.protection.outlook.com ([40.107.3.74]:13191
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725980AbfFSGvc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jun 2019 02:51:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D5NAJOQMc3XJ8wSknk3Sln2PeMt2j4DGHpfzT1Gy8wA=;
 b=CoJ0utbkDl//rAhP/T8QYHmcHd1QQohw5nXYFWDhB8GE5Cwh9XMo01tjbWs7g5u2Lw36ZpY0umqACd5i5T08w8kCMdJdiBoPfWfm1Odai2JYQsGb6oCD761aijofs/mDdeltEe4Gesz5CU+VwiT2Bjf8mtbZVKa+B+/kaRJF7Bw=
Received: from AM4PR05MB3137.eurprd05.prod.outlook.com (10.171.186.14) by
 AM4PR05MB3459.eurprd05.prod.outlook.com (10.171.187.152) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.10; Wed, 19 Jun 2019 06:51:28 +0000
Received: from AM4PR05MB3137.eurprd05.prod.outlook.com
 ([fe80::bc5a:ba8b:1a69:91b6]) by AM4PR05MB3137.eurprd05.prod.outlook.com
 ([fe80::bc5a:ba8b:1a69:91b6%6]) with mapi id 15.20.1987.014; Wed, 19 Jun 2019
 06:51:28 +0000
From:   Leon Romanovsky <leonro@mellanox.com>
To:     Jianbo Liu <jianbol@mellanox.com>
CC:     Saeed Mahameed <saeedm@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Roi Dayan <roid@mellanox.com>, Mark Bloch <markb@mellanox.com>
Subject: Re: [PATCH mlx5-next 11/15] RDMA/mlx5: Add vport metadata matching
 for IB representors
Thread-Topic: [PATCH mlx5-next 11/15] RDMA/mlx5: Add vport metadata matching
 for IB representors
Thread-Index: AQHVJUIm1iT82BVB3kyl3BqmLAQTwaahNBoAgAE0ugCAAAWFAIAAGtgAgAADHYA=
Date:   Wed, 19 Jun 2019 06:51:28 +0000
Message-ID: <20190619065125.GF11611@mtr-leonro.mtl.com>
References: <20190617192247.25107-1-saeedm@mellanox.com>
 <20190617192247.25107-12-saeedm@mellanox.com>
 <20190618101928.GE4690@mtr-leonro.mtl.com>
 <20190619044420.GA30694@mellanox.com>
 <20190619050412.GC11611@mtr-leonro.mtl.com>
 <20190619063941.GA5176@mellanox.com>
In-Reply-To: <20190619063941.GA5176@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM7PR02CA0003.eurprd02.prod.outlook.com
 (2603:10a6:20b:100::13) To AM4PR05MB3137.eurprd05.prod.outlook.com
 (2603:10a6:205:3::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=leonro@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.3.125]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f92bebc8-9d82-47d0-79e1-08d6f4828d9b
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR05MB3459;
x-ms-traffictypediagnostic: AM4PR05MB3459:
x-microsoft-antispam-prvs: <AM4PR05MB3459EE2A35D500E58925EF7CB0E50@AM4PR05MB3459.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0073BFEF03
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(136003)(366004)(396003)(39860400002)(199004)(189003)(6116002)(3846002)(478600001)(229853002)(7736002)(256004)(446003)(9686003)(6486002)(476003)(11346002)(71190400001)(305945005)(33656002)(71200400001)(8936002)(8676002)(25786009)(6512007)(81166006)(81156014)(316002)(6636002)(486006)(4326008)(6436002)(66556008)(450100002)(86362001)(53936002)(64756008)(54906003)(186003)(6862004)(66946007)(2906002)(52116002)(73956011)(102836004)(6506007)(14454004)(6246003)(76176011)(26005)(1076003)(107886003)(386003)(5660300002)(66446008)(66066001)(66476007)(99286004)(68736007);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3459;H:AM4PR05MB3137.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: auKJbsYgUOakZ4C2AYw83eJ2fJWhZ/VoGhXvpNMdmoW6yX4qUtxcg/qssNM5SMGIt1Yi0DKYXMATHpXd23VU0Up34yFkGGQE6JaNbeO5h8mboufWUQpkwpsltL1GXJYuQe5eWPsAulN2NjnH4HDZfiX4bECmkUvPiOkh0hYmTYQN509VIPMwXpDaaaqQHI8hX5/OD3x8COhMdOssNB9gXM+AnIXxkYcAKyCTY3MtwL4KC6UajAyq8rye607GHckvzRiE61Oksn+FvPUXGU1z2f3bbFTBEmKEiDFjIb2Q/wpygZIRuTTDKwSMBNlEhNiEMxWf10GBwcsaCTP+FKUVYpvPWHS2byF6aosyuw4Bd70p57+cnx44BcVBGiJfpVWYcFlXyKFG4wBQTRALGVKWIobxakFNCenJ+hXYoCYJJKk=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <70D3FC83AAAA164B970C3964AEF7EEDF@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f92bebc8-9d82-47d0-79e1-08d6f4828d9b
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jun 2019 06:51:28.0984
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: leonro@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3459
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 19, 2019 at 06:40:16AM +0000, Jianbo Liu wrote:
> The 06/19/2019 13:04, Leon Romanovsky wrote:
> > On Wed, Jun 19, 2019 at 04:44:26AM +0000, Jianbo Liu wrote:
> > > The 06/18/2019 18:19, Leon Romanovsky wrote:
> > > > On Mon, Jun 17, 2019 at 07:23:30PM +0000, Saeed Mahameed wrote:
> > > > > From: Jianbo Liu <jianbol@mellanox.com>
> > > > >
> > > > > If vport metadata matching is enabled in eswitch, the rule create=
d
> > > > > must be changed to match on the metadata, instead of source port.
> > > > >
> > > > > Signed-off-by: Jianbo Liu <jianbol@mellanox.com>
> > > > > Reviewed-by: Roi Dayan <roid@mellanox.com>
> > > > > Reviewed-by: Mark Bloch <markb@mellanox.com>
> > > > > Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> > > > > ---
> > > > >  drivers/infiniband/hw/mlx5/ib_rep.c | 11 +++++++
> > > > >  drivers/infiniband/hw/mlx5/ib_rep.h | 16 ++++++++++
> > > > >  drivers/infiniband/hw/mlx5/main.c   | 45 +++++++++++++++++++++++=
------
> > > > >  3 files changed, 63 insertions(+), 9 deletions(-)
> > > > >
> > > > > diff --git a/drivers/infiniband/hw/mlx5/ib_rep.c b/drivers/infini=
band/hw/mlx5/ib_rep.c
> > > > > index 22e651cb5534..d4ed611de35d 100644
> > > > > --- a/drivers/infiniband/hw/mlx5/ib_rep.c
> > > > > +++ b/drivers/infiniband/hw/mlx5/ib_rep.c
> > > > > @@ -131,6 +131,17 @@ struct mlx5_eswitch_rep *mlx5_ib_vport_rep(s=
truct mlx5_eswitch *esw, int vport)
> > > > >  	return mlx5_eswitch_vport_rep(esw, vport);
> > > > >  }
> > > > >
> > > > > +u32 mlx5_ib_eswitch_vport_match_metadata_enabled(struct mlx5_esw=
itch *esw)
> > > > > +{
> > > > > +	return mlx5_eswitch_vport_match_metadata_enabled(esw);
> > > > > +}
> > > > > +
> > > > > +u32 mlx5_ib_eswitch_get_vport_metadata_for_match(struct mlx5_esw=
itch *esw,
> > > > > +						 u16 vport)
> > > > > +{
> > > > > +	return mlx5_eswitch_get_vport_metadata_for_match(esw, vport);
> > > > > +}
> > > >
> > > > 1. There is no need to introduce one line functions, call to that c=
ode directly.
> > >
> > > No. They are in IB, and we don't want them be mixed up by the origina=
l
> > > functions in eswitch. Please ask Mark more about it.
> >
> > Please enlighten me.
>
> It was suggested by Mark in prevouis review.
> I think it's because there are in different modules, and better to with
> different names, so introduce there extra one line functions.
> Please correct me if I'm wrong, Mark...

mlx5_ib is full of direct function calls to mlx5_core and it is done on
purpose for at least two reasons. First is to control in one place
all compilation options and expose proper API interface with and without
specific kernel config is on. Second is to emphasize that this is core
function and save us time in refactoring and reviewing.

>
> >
> > >
> > > > 2. It should be bool and not u32.
> > > >
> > > > Thanks
> > >
> > > --
>
> --
