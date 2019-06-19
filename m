Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E5564B3B7
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 10:13:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731293AbfFSIMf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 04:12:35 -0400
Received: from mail-eopbgr40069.outbound.protection.outlook.com ([40.107.4.69]:37879
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726142AbfFSIMe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jun 2019 04:12:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kGRC6tBmusRt7S1uf+Fa96D6c9xQ3OWRloQWzO64AB4=;
 b=ndR8MQ8Wc3z0R+fOzhelilpbC+I1c5Tws86BwRPttbdALMVlrOK3jHdDA47tx75KzQ1W+qcrdTAGKwk8i2Grc/KXzvKXCc1BAfCIeTW0l/5Xj3AD+jL0tYCO6HMFKJ0ykb/0U6Mde4+yosWUkJde9JcyBoVOhjxL5RF59jDvcko=
Received: from AM4PR05MB3137.eurprd05.prod.outlook.com (10.171.186.14) by
 AM4PR05MB3410.eurprd05.prod.outlook.com (10.171.187.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.13; Wed, 19 Jun 2019 08:12:29 +0000
Received: from AM4PR05MB3137.eurprd05.prod.outlook.com
 ([fe80::bc5a:ba8b:1a69:91b6]) by AM4PR05MB3137.eurprd05.prod.outlook.com
 ([fe80::bc5a:ba8b:1a69:91b6%6]) with mapi id 15.20.1987.014; Wed, 19 Jun 2019
 08:12:29 +0000
From:   Leon Romanovsky <leonro@mellanox.com>
To:     Mark Bloch <markb@mellanox.com>
CC:     Jianbo Liu <jianbol@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Roi Dayan <roid@mellanox.com>
Subject: Re: [PATCH mlx5-next 11/15] RDMA/mlx5: Add vport metadata matching
 for IB representors
Thread-Topic: [PATCH mlx5-next 11/15] RDMA/mlx5: Add vport metadata matching
 for IB representors
Thread-Index: AQHVJUIm1iT82BVB3kyl3BqmLAQTwaahNBoAgAE0ugCAAAWFAIAAGtgAgAADHYCAAAnqAIAABK0AgAAEQICAAAPNgA==
Date:   Wed, 19 Jun 2019 08:12:29 +0000
Message-ID: <20190619081226.GI11611@mtr-leonro.mtl.com>
References: <20190617192247.25107-1-saeedm@mellanox.com>
 <20190617192247.25107-12-saeedm@mellanox.com>
 <20190618101928.GE4690@mtr-leonro.mtl.com>
 <20190619044420.GA30694@mellanox.com>
 <20190619050412.GC11611@mtr-leonro.mtl.com>
 <20190619063941.GA5176@mellanox.com>
 <20190619065125.GF11611@mtr-leonro.mtl.com>
 <4e01d326-db6c-f746-acd6-06f65f311f5b@mellanox.com>
 <20190619074338.GG11611@mtr-leonro.mtl.com>
 <ac23c3ea-3ea7-2a5b-5fc6-aece0aed0b54@mellanox.com>
In-Reply-To: <ac23c3ea-3ea7-2a5b-5fc6-aece0aed0b54@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6P191CA0105.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:209:8a::46) To AM4PR05MB3137.eurprd05.prod.outlook.com
 (2603:10a6:205:3::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=leonro@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.3.125]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a7a6de36-2448-4611-40dd-08d6f48ddf29
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR05MB3410;
x-ms-traffictypediagnostic: AM4PR05MB3410:
x-microsoft-antispam-prvs: <AM4PR05MB3410E9BC504DD1BC9E397F72B0E50@AM4PR05MB3410.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0073BFEF03
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(346002)(136003)(39860400002)(376002)(189003)(199004)(256004)(305945005)(107886003)(52116002)(64756008)(66556008)(66446008)(68736007)(66476007)(6636002)(478600001)(99286004)(6246003)(73956011)(4326008)(3846002)(53936002)(7736002)(486006)(14454004)(71200400001)(25786009)(476003)(6116002)(71190400001)(9686003)(33656002)(11346002)(6512007)(5660300002)(102836004)(186003)(316002)(2906002)(450100002)(66946007)(86362001)(14444005)(76176011)(386003)(81166006)(54906003)(229853002)(53546011)(446003)(6506007)(8936002)(26005)(6436002)(6862004)(8676002)(6486002)(81156014)(66066001)(1076003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3410;H:AM4PR05MB3137.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: PLnVpdZfjn+BTdRf7Km6Hdz5r038+WCJX5C0U1dgc/crXG4pUQdDLtYjw01f7ig1wWkxvwxTs9O5UWLGef8z7NqZnyoh836+CVDdDJ+m0UCENRh0rdeFRjynMC4Ft2SeGq7/pSjySfs2QGh9uq9ebJmVAD+qCRS0lvatc7qsCuYS6hbicFLeEYxnS9kjBw8NlgxXo8F9WMdMdLX0m+o7DTq59HAkzdOhUKyh5w62Few8IXixPpivTQyImg+iUTVVXV8tofp8le1TGtooTGlT3+XVMWCxiI3xN5pfa7H9eSA0aTERSxzihFe+9r505eOeXsEdpKo60Ea9XHQWBZiK+gJYbMFaeEnbmJzgbB6CrsHO0qFgJh9dVgtM5VSU5BvlfDManUOXiVyg7rzCTf7L2XC4uBft7UaUUXE/+yICQtY=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <EFF0DA22E8C65A4B91AAE2B9CC8899D4@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7a6de36-2448-4611-40dd-08d6f48ddf29
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jun 2019 08:12:29.5520
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: leonro@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3410
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 19, 2019 at 07:58:51AM +0000, Mark Bloch wrote:
>
>
> On 6/19/2019 00:43, Leon Romanovsky wrote:
> > On Wed, Jun 19, 2019 at 07:26:54AM +0000, Mark Bloch wrote:
> >>
> >>
> >> On 6/18/2019 23:51, Leon Romanovsky wrote:
> >>> On Wed, Jun 19, 2019 at 06:40:16AM +0000, Jianbo Liu wrote:
> >>>> The 06/19/2019 13:04, Leon Romanovsky wrote:
> >>>>> On Wed, Jun 19, 2019 at 04:44:26AM +0000, Jianbo Liu wrote:
> >>>>>> The 06/18/2019 18:19, Leon Romanovsky wrote:
> >>>>>>> On Mon, Jun 17, 2019 at 07:23:30PM +0000, Saeed Mahameed wrote:
> >>>>>>>> From: Jianbo Liu <jianbol@mellanox.com>
> >>>>>>>>
> >>>>>>>> If vport metadata matching is enabled in eswitch, the rule creat=
ed
> >>>>>>>> must be changed to match on the metadata, instead of source port=
.
> >>>>>>>>
> >>>>>>>> Signed-off-by: Jianbo Liu <jianbol@mellanox.com>
> >>>>>>>> Reviewed-by: Roi Dayan <roid@mellanox.com>
> >>>>>>>> Reviewed-by: Mark Bloch <markb@mellanox.com>
> >>>>>>>> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> >>>>>>>> ---
> >>>>>>>>  drivers/infiniband/hw/mlx5/ib_rep.c | 11 +++++++
> >>>>>>>>  drivers/infiniband/hw/mlx5/ib_rep.h | 16 ++++++++++
> >>>>>>>>  drivers/infiniband/hw/mlx5/main.c   | 45 ++++++++++++++++++++++=
+------
> >>>>>>>>  3 files changed, 63 insertions(+), 9 deletions(-)
> >>>>>>>>
> >>>>>>>> diff --git a/drivers/infiniband/hw/mlx5/ib_rep.c b/drivers/infin=
iband/hw/mlx5/ib_rep.c
> >>>>>>>> index 22e651cb5534..d4ed611de35d 100644
> >>>>>>>> --- a/drivers/infiniband/hw/mlx5/ib_rep.c
> >>>>>>>> +++ b/drivers/infiniband/hw/mlx5/ib_rep.c
> >>>>>>>> @@ -131,6 +131,17 @@ struct mlx5_eswitch_rep *mlx5_ib_vport_rep(=
struct mlx5_eswitch *esw, int vport)
> >>>>>>>>  	return mlx5_eswitch_vport_rep(esw, vport);
> >>>>>>>>  }
> >>>>>>>>
> >>>>>>>> +u32 mlx5_ib_eswitch_vport_match_metadata_enabled(struct mlx5_es=
witch *esw)
> >>>>>>>> +{
> >>>>>>>> +	return mlx5_eswitch_vport_match_metadata_enabled(esw);
> >>>>>>>> +}
> >>>>>>>> +
> >>>>>>>> +u32 mlx5_ib_eswitch_get_vport_metadata_for_match(struct mlx5_es=
witch *esw,
> >>>>>>>> +						 u16 vport)
> >>>>>>>> +{
> >>>>>>>> +	return mlx5_eswitch_get_vport_metadata_for_match(esw, vport);
> >>>>>>>> +}
> >>>>>>>
> >>>>>>> 1. There is no need to introduce one line functions, call to that=
 code directly.
> >>>>>>
> >>>>>> No. They are in IB, and we don't want them be mixed up by the orig=
inal
> >>>>>> functions in eswitch. Please ask Mark more about it.
> >>>>>
> >>>>> Please enlighten me.
> >>>>
> >>>> It was suggested by Mark in prevouis review.
> >>>> I think it's because there are in different modules, and better to w=
ith
> >>>> different names, so introduce there extra one line functions.
> >>>> Please correct me if I'm wrong, Mark...
> >>>
> >>> mlx5_ib is full of direct function calls to mlx5_core and it is done =
on
> >>> purpose for at least two reasons. First is to control in one place
> >>> all compilation options and expose proper API interface with and with=
out
> >>> specific kernel config is on. Second is to emphasize that this is cor=
e
> >>> function and save us time in refactoring and reviewing.
> >>
> >> This was done in order to avoid #ifdef CONFIG_MLX5_ESWITCH,
> >> I want to hide (as much as possible) the interactions with the eswitch=
 level in ib_rep.c/ib_rep.h
> >> so ib_rep.h will provide the stubs needed in case CONFIG_MLX5_ESWITCH =
isn't defined.
> >> (Today include/linux/mlx5/eswitch.h) doesn't provide any stubs, mlx5_e=
switch_get_encap_mode()
> >> should have probably done the same.
> >
> > This is exactly the problem, eswitch.h should provide stubs for all
> > exported functions, so other clients of eswitch won't need to deal with
> > various unrelated config options.
>
> The way it works today, code in drivers/infiniband/hw/mlx5/main.c doesn't=
 call eswitch layer directly
> but the functions in ib_rep.{c,h} as most often there is additional logic=
 we must do before calling
> the eswitch layer.
>
> If you look at drivers/infiniband/hw/mlx5/Makefile you will see ib_rep is=
 complied only when
> CONFIG_MLX5_ESWITCH id defined.

This simple patch + cleanup of ib_rep.h will do the trick.

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5=
/main.c
index 67b9e7ac569a..b917ba28659e 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -59,7 +59,9 @@
 #include <linux/in.h>
 #include <linux/etherdevice.h>
 #include "mlx5_ib.h"
+#if defined(CONFIG_MLX5_ESWITCH)
 #include "ib_rep.h"
+#endif
 #include "cmd.h"
 #include "srq.h"
 #include <linux/mlx5/fs_helpers.h>
@@ -6765,6 +6767,7 @@ static const struct mlx5_ib_profile  pf_profile =3D {
                        mlx5_ib_stage_delay_drop_cleanup),
	     };

+#if defined(CONFIG_MLX5_ESWITCH)
 const struct mlx5_ib_profile uplink_rep_profile =3D {
	STAGE_CREATE(MLX5_IB_STAGE_INIT,
		     mlx5_ib_stage_init_init,
@@ -6812,6 +6815,7 @@
 const struct mlx5_ib_profile uplink_rep_profile =3D {
		               mlx5_ib_stage_post_ib_reg_umr_init,
		               NULL),
		};

>
> so instead of having to deal with two places that contain stubs, we need =
to deal with only one (ib_rep.h).
> For me it makes it easier to follow, but I can adept if you don't like it=
.
>
> Mark
>
> >
> >>
> >> As my long term goal is to break drivers/infiniband/hw/mlx5/main.c (th=
at file is already 7000 LOC)
> >> I want to group together stuff in separate files.
> >
> > Yes, it is right thing to do.
> >
> >>
> >> If you prefer direct calls that's okay as well.
> >
> > Yes, please.
> >
> >>
> >> Mark
> >>
> >>>
> >>>>
> >>>>>
> >>>>>>
> >>>>>>> 2. It should be bool and not u32.
> >>>>>>>
> >>>>>>> Thanks
> >>>>>>
> >>>>>> --
> >>>>
> >>>> --
