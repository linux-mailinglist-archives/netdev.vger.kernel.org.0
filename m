Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B54D4B34A
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 09:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731135AbfFSHo0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 03:44:26 -0400
Received: from mail-eopbgr30057.outbound.protection.outlook.com ([40.107.3.57]:9424
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731143AbfFSHo0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jun 2019 03:44:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eMf/AgEcdFoO2BOXlXMUK7aMENG+/+Mle8K6BDcEegE=;
 b=R+6maAUp+Iusn4I8jQUd36cCbaQqaY5VIWsImLluSDePqNs25xZtprW7vMOE9YQRmYyZwvJPfqyMJ/s583jGiHZaOsL/WVv4lS/e4+ylmd95Ktcu63QSBT3jYvxkc7Yc3229ImwEIofNH//L40WmuqxnUvMLsaBGuNgzDj6IGYE=
Received: from AM4PR05MB3137.eurprd05.prod.outlook.com (10.171.186.14) by
 AM4PR05MB3155.eurprd05.prod.outlook.com (10.170.126.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.13; Wed, 19 Jun 2019 07:43:42 +0000
Received: from AM4PR05MB3137.eurprd05.prod.outlook.com
 ([fe80::bc5a:ba8b:1a69:91b6]) by AM4PR05MB3137.eurprd05.prod.outlook.com
 ([fe80::bc5a:ba8b:1a69:91b6%6]) with mapi id 15.20.1987.014; Wed, 19 Jun 2019
 07:43:42 +0000
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
Thread-Index: AQHVJUIm1iT82BVB3kyl3BqmLAQTwaahNBoAgAE0ugCAAAWFAIAAGtgAgAADHYCAAAnqAIAABK0A
Date:   Wed, 19 Jun 2019 07:43:41 +0000
Message-ID: <20190619074338.GG11611@mtr-leonro.mtl.com>
References: <20190617192247.25107-1-saeedm@mellanox.com>
 <20190617192247.25107-12-saeedm@mellanox.com>
 <20190618101928.GE4690@mtr-leonro.mtl.com>
 <20190619044420.GA30694@mellanox.com>
 <20190619050412.GC11611@mtr-leonro.mtl.com>
 <20190619063941.GA5176@mellanox.com>
 <20190619065125.GF11611@mtr-leonro.mtl.com>
 <4e01d326-db6c-f746-acd6-06f65f311f5b@mellanox.com>
In-Reply-To: <4e01d326-db6c-f746-acd6-06f65f311f5b@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0167.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1b::35) To AM4PR05MB3137.eurprd05.prod.outlook.com
 (2603:10a6:205:3::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=leonro@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.3.125]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 948d5982-6566-42ba-4408-08d6f489d96c
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR05MB3155;
x-ms-traffictypediagnostic: AM4PR05MB3155:
x-microsoft-antispam-prvs: <AM4PR05MB3155719F392B04B8028BDD6EB0E50@AM4PR05MB3155.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0073BFEF03
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(136003)(346002)(366004)(39860400002)(376002)(199004)(189003)(102836004)(73956011)(6436002)(99286004)(52116002)(7736002)(71200400001)(1076003)(8676002)(2906002)(81156014)(71190400001)(305945005)(81166006)(54906003)(450100002)(316002)(478600001)(8936002)(3846002)(6512007)(486006)(68736007)(14454004)(33656002)(66066001)(26005)(4326008)(11346002)(6636002)(229853002)(5660300002)(476003)(25786009)(386003)(66476007)(66556008)(64756008)(86362001)(66446008)(66946007)(6486002)(53936002)(6862004)(446003)(107886003)(9686003)(14444005)(186003)(256004)(6116002)(76176011)(6506007)(6246003)(53546011);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3155;H:AM4PR05MB3137.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: fgqi6ZDHmlQKRBwgDzu6Jf0p8plrVmPSatmn/9tXcssse5cD5tcjJMTiY97WwRzk6kWsFv1S8ICv1UCnRWECm7Qu7c0cEYtda58/FEhqvzOprticmgGXY0FCVW21ucTIiLxBwjzUf4128kuFKb6VLB7jYQoK3KzC1r9u2lz5smIYXVEHuATs7EAzoaN8c91DGy/Y2Nn30N6Fu6t9qB6HHnBq4IaOVo7qXbN9tvdijLA+Th5KuQCq3j9IcCOU0pujRpONLxhm4L6jMoZt5WX8V26FxonRLA3NismfC6MFXi/wBch4TlFb1xjsT0y9ZpvBuzvucmnDY1RxwmgKl3hwKSaABYhOfRj7phEN4HLTXicP+u3dLJEM5+Z4JxXV4z2Rabfs6fsVkBo8N4cPDG3FwBv+kFay+zmiYT+tcTvlC6M=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <81D23662DA27334C93CDE54F93CA921C@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 948d5982-6566-42ba-4408-08d6f489d96c
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jun 2019 07:43:41.8999
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: leonro@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3155
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 19, 2019 at 07:26:54AM +0000, Mark Bloch wrote:
>
>
> On 6/18/2019 23:51, Leon Romanovsky wrote:
> > On Wed, Jun 19, 2019 at 06:40:16AM +0000, Jianbo Liu wrote:
> >> The 06/19/2019 13:04, Leon Romanovsky wrote:
> >>> On Wed, Jun 19, 2019 at 04:44:26AM +0000, Jianbo Liu wrote:
> >>>> The 06/18/2019 18:19, Leon Romanovsky wrote:
> >>>>> On Mon, Jun 17, 2019 at 07:23:30PM +0000, Saeed Mahameed wrote:
> >>>>>> From: Jianbo Liu <jianbol@mellanox.com>
> >>>>>>
> >>>>>> If vport metadata matching is enabled in eswitch, the rule created
> >>>>>> must be changed to match on the metadata, instead of source port.
> >>>>>>
> >>>>>> Signed-off-by: Jianbo Liu <jianbol@mellanox.com>
> >>>>>> Reviewed-by: Roi Dayan <roid@mellanox.com>
> >>>>>> Reviewed-by: Mark Bloch <markb@mellanox.com>
> >>>>>> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> >>>>>> ---
> >>>>>>  drivers/infiniband/hw/mlx5/ib_rep.c | 11 +++++++
> >>>>>>  drivers/infiniband/hw/mlx5/ib_rep.h | 16 ++++++++++
> >>>>>>  drivers/infiniband/hw/mlx5/main.c   | 45 +++++++++++++++++++++++-=
-----
> >>>>>>  3 files changed, 63 insertions(+), 9 deletions(-)
> >>>>>>
> >>>>>> diff --git a/drivers/infiniband/hw/mlx5/ib_rep.c b/drivers/infinib=
and/hw/mlx5/ib_rep.c
> >>>>>> index 22e651cb5534..d4ed611de35d 100644
> >>>>>> --- a/drivers/infiniband/hw/mlx5/ib_rep.c
> >>>>>> +++ b/drivers/infiniband/hw/mlx5/ib_rep.c
> >>>>>> @@ -131,6 +131,17 @@ struct mlx5_eswitch_rep *mlx5_ib_vport_rep(st=
ruct mlx5_eswitch *esw, int vport)
> >>>>>>  	return mlx5_eswitch_vport_rep(esw, vport);
> >>>>>>  }
> >>>>>>
> >>>>>> +u32 mlx5_ib_eswitch_vport_match_metadata_enabled(struct mlx5_eswi=
tch *esw)
> >>>>>> +{
> >>>>>> +	return mlx5_eswitch_vport_match_metadata_enabled(esw);
> >>>>>> +}
> >>>>>> +
> >>>>>> +u32 mlx5_ib_eswitch_get_vport_metadata_for_match(struct mlx5_eswi=
tch *esw,
> >>>>>> +						 u16 vport)
> >>>>>> +{
> >>>>>> +	return mlx5_eswitch_get_vport_metadata_for_match(esw, vport);
> >>>>>> +}
> >>>>>
> >>>>> 1. There is no need to introduce one line functions, call to that c=
ode directly.
> >>>>
> >>>> No. They are in IB, and we don't want them be mixed up by the origin=
al
> >>>> functions in eswitch. Please ask Mark more about it.
> >>>
> >>> Please enlighten me.
> >>
> >> It was suggested by Mark in prevouis review.
> >> I think it's because there are in different modules, and better to wit=
h
> >> different names, so introduce there extra one line functions.
> >> Please correct me if I'm wrong, Mark...
> >
> > mlx5_ib is full of direct function calls to mlx5_core and it is done on
> > purpose for at least two reasons. First is to control in one place
> > all compilation options and expose proper API interface with and withou=
t
> > specific kernel config is on. Second is to emphasize that this is core
> > function and save us time in refactoring and reviewing.
>
> This was done in order to avoid #ifdef CONFIG_MLX5_ESWITCH,
> I want to hide (as much as possible) the interactions with the eswitch le=
vel in ib_rep.c/ib_rep.h
> so ib_rep.h will provide the stubs needed in case CONFIG_MLX5_ESWITCH isn=
't defined.
> (Today include/linux/mlx5/eswitch.h) doesn't provide any stubs, mlx5_eswi=
tch_get_encap_mode()
> should have probably done the same.

This is exactly the problem, eswitch.h should provide stubs for all
exported functions, so other clients of eswitch won't need to deal with
various unrelated config options.

>
> As my long term goal is to break drivers/infiniband/hw/mlx5/main.c (that =
file is already 7000 LOC)
> I want to group together stuff in separate files.

Yes, it is right thing to do.

>
> If you prefer direct calls that's okay as well.

Yes, please.

>
> Mark
>
> >
> >>
> >>>
> >>>>
> >>>>> 2. It should be bool and not u32.
> >>>>>
> >>>>> Thanks
> >>>>
> >>>> --
> >>
> >> --
