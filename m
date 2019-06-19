Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB5314B105
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 07:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725916AbfFSFET (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 01:04:19 -0400
Received: from mail-eopbgr80084.outbound.protection.outlook.com ([40.107.8.84]:46336
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725562AbfFSFET (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jun 2019 01:04:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NBkb/uRpr5ivCq6ZOqQ16comvkyYdQ15GxZFXXB6pks=;
 b=Xj4ncRcES547wg233vaVpfLE3ad5gn5V2KYsQe1adoGrqLVXuIwdKwQT9oDDgJ/1eKYapA44uehG5rqtCUSXuMNokvsyG1HXVxZQN5Cq6s84Z6V+g3HQvoTVvzp/+SF1aCacnfrgQxOjver0cQL9FmmlaCZZ7rdk7YNBmtjvsSk=
Received: from AM4PR05MB3137.eurprd05.prod.outlook.com (10.171.186.14) by
 AM4PR05MB3426.eurprd05.prod.outlook.com (10.171.188.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.11; Wed, 19 Jun 2019 05:04:15 +0000
Received: from AM4PR05MB3137.eurprd05.prod.outlook.com
 ([fe80::bc5a:ba8b:1a69:91b6]) by AM4PR05MB3137.eurprd05.prod.outlook.com
 ([fe80::bc5a:ba8b:1a69:91b6%6]) with mapi id 15.20.1987.014; Wed, 19 Jun 2019
 05:04:15 +0000
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
Thread-Index: AQHVJUIm1iT82BVB3kyl3BqmLAQTwaahNBoAgAE0ugCAAAWFAA==
Date:   Wed, 19 Jun 2019 05:04:15 +0000
Message-ID: <20190619050412.GC11611@mtr-leonro.mtl.com>
References: <20190617192247.25107-1-saeedm@mellanox.com>
 <20190617192247.25107-12-saeedm@mellanox.com>
 <20190618101928.GE4690@mtr-leonro.mtl.com>
 <20190619044420.GA30694@mellanox.com>
In-Reply-To: <20190619044420.GA30694@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM5PR0701CA0013.eurprd07.prod.outlook.com
 (2603:10a6:203:51::23) To AM4PR05MB3137.eurprd05.prod.outlook.com
 (2603:10a6:205:3::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=leonro@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.3.125]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a0869d27-66e1-4cc3-1aed-08d6f4739352
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR05MB3426;
x-ms-traffictypediagnostic: AM4PR05MB3426:
x-microsoft-antispam-prvs: <AM4PR05MB342679B12276AFACEB12A4E4B0E50@AM4PR05MB3426.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 0073BFEF03
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(136003)(396003)(39860400002)(346002)(376002)(199004)(189003)(3846002)(450100002)(26005)(66446008)(11346002)(8936002)(4326008)(66476007)(102836004)(8676002)(25786009)(6116002)(68736007)(54906003)(229853002)(478600001)(81156014)(6862004)(81166006)(33656002)(476003)(66066001)(486006)(186003)(446003)(6506007)(9686003)(6246003)(53936002)(386003)(256004)(14454004)(52116002)(316002)(6436002)(2906002)(76176011)(64756008)(73956011)(66946007)(71200400001)(7736002)(6512007)(99286004)(71190400001)(5660300002)(86362001)(1076003)(305945005)(107886003)(6636002)(66556008)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3426;H:AM4PR05MB3137.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: oJn6m29chKx09I/8I770BOz5ZY173BzMvLg1GlJWVB4VSEfIgZs3n8oPbAvm+CapF9RyeNoPZHHu4eLHRnHFI2VsGNT5PlRGbeGxUBvgR0PVwywdjfSDzqWjspoMNREhEug4zZvgFulrFCWDfvCDO8JqdgS/4e6h0ilBfjzGQsgxNTMPeDbohNyV5mqSurB0R6Efc/zO2g5HMVI9FaOSdwiq3p5D7fqWu8nDaQm9kdeiBXkM6bjD7+9+AsEtqx48kR9XCyM1/a506SBktCuxR8OPWJCiM1kvDQjoreLhL/VpIg/VcC4cyyVh44BVnUoLR+gfMYIPDckZ1yxqErjBfLdKufHFyYc9/QrLsAkCseapJr3GxMNhWs1x50/Zz7A6A7Z8Asj+A4w+T7Zn8kVTVlg+2bzFjQsLnQyg4VQF+kU=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2E6DD96A77ED9B44865F646136E65DA9@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0869d27-66e1-4cc3-1aed-08d6f4739352
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jun 2019 05:04:15.2929
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: leonro@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3426
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 19, 2019 at 04:44:26AM +0000, Jianbo Liu wrote:
> The 06/18/2019 18:19, Leon Romanovsky wrote:
> > On Mon, Jun 17, 2019 at 07:23:30PM +0000, Saeed Mahameed wrote:
> > > From: Jianbo Liu <jianbol@mellanox.com>
> > >
> > > If vport metadata matching is enabled in eswitch, the rule created
> > > must be changed to match on the metadata, instead of source port.
> > >
> > > Signed-off-by: Jianbo Liu <jianbol@mellanox.com>
> > > Reviewed-by: Roi Dayan <roid@mellanox.com>
> > > Reviewed-by: Mark Bloch <markb@mellanox.com>
> > > Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> > > ---
> > >  drivers/infiniband/hw/mlx5/ib_rep.c | 11 +++++++
> > >  drivers/infiniband/hw/mlx5/ib_rep.h | 16 ++++++++++
> > >  drivers/infiniband/hw/mlx5/main.c   | 45 +++++++++++++++++++++++----=
--
> > >  3 files changed, 63 insertions(+), 9 deletions(-)
> > >
> > > diff --git a/drivers/infiniband/hw/mlx5/ib_rep.c b/drivers/infiniband=
/hw/mlx5/ib_rep.c
> > > index 22e651cb5534..d4ed611de35d 100644
> > > --- a/drivers/infiniband/hw/mlx5/ib_rep.c
> > > +++ b/drivers/infiniband/hw/mlx5/ib_rep.c
> > > @@ -131,6 +131,17 @@ struct mlx5_eswitch_rep *mlx5_ib_vport_rep(struc=
t mlx5_eswitch *esw, int vport)
> > >  	return mlx5_eswitch_vport_rep(esw, vport);
> > >  }
> > >
> > > +u32 mlx5_ib_eswitch_vport_match_metadata_enabled(struct mlx5_eswitch=
 *esw)
> > > +{
> > > +	return mlx5_eswitch_vport_match_metadata_enabled(esw);
> > > +}
> > > +
> > > +u32 mlx5_ib_eswitch_get_vport_metadata_for_match(struct mlx5_eswitch=
 *esw,
> > > +						 u16 vport)
> > > +{
> > > +	return mlx5_eswitch_get_vport_metadata_for_match(esw, vport);
> > > +}
> >
> > 1. There is no need to introduce one line functions, call to that code =
directly.
>
> No. They are in IB, and we don't want them be mixed up by the original
> functions in eswitch. Please ask Mark more about it.

Please enlighten me.

>
> > 2. It should be bool and not u32.
> >
> > Thanks
>
> --
