Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 771D845A958
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 17:55:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230510AbhKWQ65 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 11:58:57 -0500
Received: from mail-bn8nam11on2050.outbound.protection.outlook.com ([40.107.236.50]:33228
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233536AbhKWQ64 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 11:58:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mdN3qYowm8TUJ4HK8ec/mwel0e8ReZbfhH1qF7Kmk7oZsxvYKAIFf4PwhEVLYpvxDlbQva3zSQwfqkuaWs3lUjKPjD5nAiJ5nREgivABSgtKjIWdVdKad3oaah2/1rI9Cwyy+K4dYiDOwo2CMmoQuZXmZ/H0KIMdg3/xkcfaSNdIVbdMxFcXhU5AAOO+ltDC+xX4M2vEBRU53DGqrruOMechjmA29KtLKedHgo//MuQZHdQVbK1+Tm0PW9ztrAyhek2+BUsbzv8QSTqMbXP5tEkUoF0FvejiLYPak1hsj1j3MwQrfGX7S9NAb1j6KuYC6EpdV940gQ+kVg7lJ05F3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VvOYa1bXFWH2NLCXzpSC10A+yUgM/qUObv03Z3565Zg=;
 b=ka5VhquBtwJNpVzKKRX/lv2IcUwfyzJ+XJv/qFk1MSooF+2QmnaA+45b2vAVha91wgwTLWesd6bpWAS6G4MOA/yu/9gKitk8l9ZJnibFan89Qa4YsLTzE6mvJ4pZklOAdOJJHib+31aqxTV+v8SX3SfKRov4ESTStowWHrAiPf328QnUc9n2b/ZdMmA+j2LqQxI0uR57RuY3HidfGPlur1A2wzaGtrKPfiITirs+jDcD3YHo6DQrZ9g7GjaGVRN3OVBjGnQFE33nFx6VTWgsnPzpM8ZbBOuQh/ifTX6oiiK2Q6izKCHFQWvZ3w5S7FTd60TXqryHLeIVJzOgcLKZ9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VvOYa1bXFWH2NLCXzpSC10A+yUgM/qUObv03Z3565Zg=;
 b=pwtzrF/O4FVlyyV9JDjUJDS935dNyh2/1UIq5qQv687yS+Q0h7qQ8ZF6OUqj4CGOQTScQ2EY8TdQycpB3TYmtS09tlb4P5BfNaGZzdb+a1RiPQrYiG3xRTGYJHefS66IL5/TuSot6aMiiMRfLT+VKSLH0eORK+Jya6NWF11U0mQTqWFAi9ZRamD7oEH5g62rXPz7mhCU4gRvfHfaj+J8ZVAFWzzdYXqYzcq5haAFExJUwmjhjiZEvenzE+KNlF63ZyLUojlHRemWllHn5ZV65CmNdOh9e2RHhBDGjAUGz9pgCYhraldA6RUaqI3vEiUc/Fz07sM/ZFLf2Qh+5OMOAw==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by PH0PR12MB5500.namprd12.prod.outlook.com (2603:10b6:510:ef::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22; Tue, 23 Nov
 2021 16:55:45 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::5515:f45e:56f5:b35a]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::5515:f45e:56f5:b35a%3]) with mapi id 15.20.4713.022; Tue, 23 Nov 2021
 16:55:45 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "Keller, Jacob E" <jacob.e.keller@intel.com>,
        Jiri Pirko <jiri@nvidia.com>,
        "Kaliszczuk, Leszek" <leszek.kaliszczuk@intel.com>
Subject: RE: [PATCH net-next 2/3] net/ice: Add support for enable_iwarp and
 enable_roce devlink param
Thread-Topic: [PATCH net-next 2/3] net/ice: Add support for enable_iwarp and
 enable_roce devlink param
Thread-Index: AQHX3+WwpM2cBkHpH0m4XULVQ1XC+6wQj0xwgACjGQCAACFyEA==
Date:   Tue, 23 Nov 2021 16:55:44 +0000
Message-ID: <PH0PR12MB54817F492455B2E32E00A932DC609@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20211122211119.279885-1-anthony.l.nguyen@intel.com>
 <20211122211119.279885-3-anthony.l.nguyen@intel.com>
 <PH0PR12MB5481DD2B7212720BB387C3DEDC609@PH0PR12MB5481.namprd12.prod.outlook.com>
 <b7cc7b5aeb7d4c7e98641195822e2019@intel.com>
In-Reply-To: <b7cc7b5aeb7d4c7e98641195822e2019@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e3ce5bd5-85fc-4520-0075-08d9aea2176b
x-ms-traffictypediagnostic: PH0PR12MB5500:
x-microsoft-antispam-prvs: <PH0PR12MB5500FB3FFAA597C6C6F73DE3DC609@PH0PR12MB5500.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: usuzSg0waRBGSfHbzi8VrQ/Oi5amkMi+WXRNjzeub4IC/fyPeAsdFhg9tKprAVVpYNvWa+YVuuMGh+OkweQtNMwkKlzVkUnmsjTbIklK10MK5/iJUJ7K1OGuO0d5bXMT9AarP/9Gxp+fdSdxDl9IZzoLuU8y1wNYkW6c3wUN0YvAk4GSYVKJ+SH3uSkz/IjABCSSZBP44ulVf1Ac4HCqHcgz6nbuKlwFuPloOXhxsjRQYUeeWT2S6P2Ao7m+cYhkguknvZ0n2LRyX/oKL/YxMw6EL3VIepcovoxtyAq67iqo/siiauN9eisSXN6pIZ0NZ4Psd1xfRuqefthYkK4ZD1X/QFBye5DGdwGzH3y/PGHTs6NDMLUAgCauC5odiKgHuiBRV4LtkbG0jk8pHa+t7VtVeh9TNgApTyF4QOFMZaE552atZ8UdpoPmpId1pjo9sPZKK0bOwzz8JW/idI36nDr6giIdPPQRNl0SydtLIlaKbey+1o4uMqovfcxIfWvkSFU3pejIVXgDDsNS260pmR7ikkam+qOQ7BgAj/KWHG5Abfgsb8aNbCl/Pd0zqVVKgcf+oj/DS43gvF6etTDwJ8clN1PLXHxhtinFfTJKw38eqVOl0VXNUte4bT5aCUP3ZfLG+btq2dFgdKuzT4EhLZLmf+5K5S7R28UPAuhhN4CUayK2bvqOSBY8M3B25FzDgwQMF4HhNhgUWfpLOUDpcA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(76116006)(66946007)(4326008)(55236004)(66476007)(71200400001)(26005)(38070700005)(9686003)(66556008)(86362001)(186003)(83380400001)(52536014)(66446008)(64756008)(122000001)(2906002)(508600001)(38100700002)(54906003)(8676002)(5660300002)(7696005)(110136005)(8936002)(55016003)(316002)(33656002)(6506007)(53546011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?0qw+r3zPEguTJolyL2o8PbFeC5lYjPURWQX2Nj+jzwtdPaQREDMM7vUD2Tci?=
 =?us-ascii?Q?NAg7Dh7OHc4WA0O7XVCmO/rwTi3QX7Qp0DDsjrenJkYS7bWfDkNLgYyRnIL1?=
 =?us-ascii?Q?97xK1hNqSi/EnmBZ6sX8olckwi0JAsU0AXExoBzVSy/CLfCzdq8mrHnt2gbd?=
 =?us-ascii?Q?DSSvRew2ChY8soDGgeCobIxXKxTI3VXh8cg5ghq8ACuTx2/TOK5Ttxd/r7D3?=
 =?us-ascii?Q?Mv7DAAHZwZPvd0hsRa/3POzVfpZtvgn6beE76kIOpkVRPrKNdkh9JtSCJ/Q+?=
 =?us-ascii?Q?0WdkzV/4tnnOepNZ9QnmGzyydE99DjyYCI/vrm2KzJrVALU8Gi2+7o3IrW+f?=
 =?us-ascii?Q?lCiVA4/rcPIljCL440v4eEWywUqLGvKrHzEV2kE0sSABWTMvjQRfb4H25XrU?=
 =?us-ascii?Q?YKmAv3NFejlibJDoXKfJxTc/GkwrcdTM426UtYoGcl+eCvQBLnEMieUBhnSV?=
 =?us-ascii?Q?NZG7p9uxVl2otcCmdXK6JZiNZTid2BL3gXK0PWGhGPqzCeYqYTd2Jm1TdvYZ?=
 =?us-ascii?Q?UGmSqLAqb3ItkQInwKxgWqM+qBPtSh/QrHBQPCCVKuR1fvaV6K3V+NL9VMfD?=
 =?us-ascii?Q?sRj16kOM5IwT4wqUX6eMNtjhUJBQhBzB43FzQUG7HtTYWXTx+He6g3riDFyh?=
 =?us-ascii?Q?af9/YgPBcP13Op1Ygp4G2og6ZDeb97e1IBK9cTjaJtgJ5bT/GcKRute00T8c?=
 =?us-ascii?Q?dNadTwFy1StVWkNyeAZ8SK81k2GxstHkLonMXn9uhqVpunFs0X8/8bHY25Ru?=
 =?us-ascii?Q?y4kOTXHD3JwCnQbO81blHYcOOao1QSXd67EVZWxrxMcZd15ZF+cfz2C8b7eH?=
 =?us-ascii?Q?Si55Plxyci6WY8yfUmdFYxYOdvEB6MjDFfW4godeqd6YkCNLyeVvwD2eXMNS?=
 =?us-ascii?Q?PfDAhT7Qc+x8eaTan0Lyru+G0m59BwezRYZ3lYlkiGkRp4gznZ3XMVcMf4xV?=
 =?us-ascii?Q?mi/9Ny3GPA61KSp36x8plM5B4wyhqBghtF3XYDNvF4VhkOh4YSxFH7+YPx1o?=
 =?us-ascii?Q?dK92MdnlP5s01Xo30PzazvrYFfERqKp2qdwjLwkX5hxr1NCUnCpmnP4EXW/A?=
 =?us-ascii?Q?o3Pb2GiyWLBdEwDlkOGiron0/SGvaaV7eoDMgYr7tmYSA6KvS/h8eKtcU6mg?=
 =?us-ascii?Q?r7cCGKBHa4aZAswiUxgGKc0cRY7W8er+4TWqAPkrmXiatBHakEghaJeZ2QD3?=
 =?us-ascii?Q?UtOWeOaSDCKsrzOCYUXq3yW6aVwvEFsSIiBn1i1OAXx3qpvPq8UKuEtt3LEh?=
 =?us-ascii?Q?G4ILXFqnjYGizm9GX7pMScoXzB7gdEXfq5MDN4LjSAUCEYvR+ZEa6PAXXFYj?=
 =?us-ascii?Q?maP3kY14EqoGk7+MbuOt0kqFz87LwAU526aQNJzd6HPBs18f/fe8yJKjMgNP?=
 =?us-ascii?Q?+t3TFw7XhL1z7LNJVohdPmUwG/gU2NROTfN+eMxOHR2i8Y65ghr0DPXVsmma?=
 =?us-ascii?Q?OBlpHbUGUE4ImO9KoikDqyD6OFIWFc7tJxshjYzlNcj83n5dSpcbHLwqKGlY?=
 =?us-ascii?Q?ePGxZUYg38sR15wIxSRJf0KAPQCGk0Uf9bGSmOvROnNRxSeOyRPg/qbyfDq5?=
 =?us-ascii?Q?0iThRrs9teE/iPKkF5Z/sGFhvRz13APmrHqFsfu+iybLpE/y3LH6rsKOLDFp?=
 =?us-ascii?Q?Hbyaxw2pQks21dchwpNrh84=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3ce5bd5-85fc-4520-0075-08d9aea2176b
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2021 16:55:44.9075
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Q7CrmKXDT38tybn5UfmH7cAwwBLiqBM4n9SySxQ2D/WHIG+ADnvPHQ/CS1L4lEacticw5sWLs0BFoIqhkQU8VQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5500
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> From: Saleem, Shiraz <shiraz.saleem@intel.com>
> Sent: Tuesday, November 23, 2021 8:18 PM
>=20
> > Subject: RE: [PATCH net-next 2/3] net/ice: Add support for
> > enable_iwarp and enable_roce devlink param
> >
> > Hi Tony,
> >
> > > From: Tony Nguyen <anthony.l.nguyen@intel.com>
> > > Sent: Tuesday, November 23, 2021 2:41 AM
> > >
> > > From: Shiraz Saleem <shiraz.saleem@intel.com>
> > >
> > > Allow support for 'enable_iwarp' and 'enable_roce' devlink params to
> > > turn on/off iWARP or RoCE protocol support for E800 devices.
> > >
> > > For example, a user can turn on iWARP functionality with,
> > >
> > > devlink dev param set pci/0000:07:00.0 name enable_iwarp value true
> > > cmode runtime
> > >
> > > This add an iWARP auxiliary rdma device, ice.iwarp.<>, under this PF.
> > >
> > > A user request to enable both iWARP and RoCE under the same PF is
> > > rejected since this device does not support both protocols
> > > simultaneously on the same port.
> > >
> > > Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> > > Tested-by: Leszek Kaliszczuk <leszek.kaliszczuk@intel.com>
> > > Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> > > ---
> > >  drivers/net/ethernet/intel/ice/ice.h         |   1 +
> > >  drivers/net/ethernet/intel/ice/ice_devlink.c | 144 +++++++++++++++++=
++
> > >  drivers/net/ethernet/intel/ice/ice_devlink.h |   6 +
> > >  drivers/net/ethernet/intel/ice/ice_idc.c     |   4 +-
> > >  drivers/net/ethernet/intel/ice/ice_main.c    |   9 +-
> > >  include/linux/net/intel/iidc.h               |   7 +-
> > >  6 files changed, 166 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/drivers/net/ethernet/intel/ice/ice.h
> > > b/drivers/net/ethernet/intel/ice/ice.h
> > > index b2db39ee5f85..b67ad51cbcc9 100644
> > > --- a/drivers/net/ethernet/intel/ice/ice.h
> > > +++ b/drivers/net/ethernet/intel/ice/ice.h
> > > @@ -576,6 +576,7 @@ struct ice_pf {
> > >  	struct ice_hw_port_stats stats_prev;
> > >  	struct ice_hw hw;
> > >  	u8 stat_prev_loaded:1; /* has previous stats been loaded */
> > > +	u8 rdma_mode;
> > This can be u8 rdma_mode: 1;
> > See below.
> >
> > >  	u16 dcbx_cap;
> > >  	u32 tx_timeout_count;
> > >  	unsigned long tx_timeout_last_recovery; diff --git
> > > a/drivers/net/ethernet/intel/ice/ice_devlink.c
> > > b/drivers/net/ethernet/intel/ice/ice_devlink.c
> > > index b9bd9f9472f6..478412b28a76 100644
> > > --- a/drivers/net/ethernet/intel/ice/ice_devlink.c
> > > +++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
> > > @@ -430,6 +430,120 @@ static const struct devlink_ops ice_devlink_ops=
 =3D
> {
> > >  	.flash_update =3D ice_devlink_flash_update,  };
> > >
> > > +static int
> > > +ice_devlink_enable_roce_get(struct devlink *devlink, u32 id,
> > > +			    struct devlink_param_gset_ctx *ctx) {
> > > +	struct ice_pf *pf =3D devlink_priv(devlink);
> > > +
> > > +	ctx->val.vbool =3D pf->rdma_mode & IIDC_RDMA_PROTOCOL_ROCEV2;
> > > +
> > This is logical operation, and vbool will be still zero when rdma mode
> > is rocev2, because it is not bit 0.
> > Please see below. This error can be avoided by having rdma mode as
> Boolean.
>=20
> Hi Parav -
>=20
> rdma_mode is used as a bit-mask.
> 0 =3D disabled, i.e. enable_iwarp and enable_roce set to false by user.
> 1 =3D IIDC_RDMA_PROTOCOL_IWARP
> 2 =3D IIDC_RDMA_PROTOCOL_ROCEV2
>
Yes, I got it. bit mask is ok.
But this line,
ctx->val.vbool =3D pf->rdma_mode & IIDC_RDMA_PROTOCOL_ROCEV2;
should be
ctx->val.vbool =3D !!(pf->rdma_mode & IIDC_RDMA_PROTOCOL_ROCEV2);
 or
ctx->val.vbool =3D pf->rdma_mode & IIDC_RDMA_PROTOCOL_ROCEV2 ? true : false=
;

because & IIDC_RDMA_PROTOCOL_ROCEV2 is BIT(1) =3D 0x2.

> Setting rocev2 involves,
> pf->rdma_mode |=3D IIDC_RDMA_PROTOCOL_ROCEV2;
>=20
> So this operation here should reflect correct value in vbool. I don't thi=
nk this is
> a bug.
>
vbool assignment is incorrect, rest is fine.
=20
> > > +static int
> > > +ice_devlink_enable_iw_get(struct devlink *devlink, u32 id,
> > > +			  struct devlink_param_gset_ctx *ctx) {
> > > +	struct ice_pf *pf =3D devlink_priv(devlink);
> > > +
> > > +	ctx->val.vbool =3D pf->rdma_mode & IIDC_RDMA_PROTOCOL_IWARP;
> > > +
> > This works fine as this is bit 0, but not for roce. So lets just do
> > boolean rdma_mode.
>=20
> Boolean doesn't cut it as it doesn't reflect the disabled state mentioned=
 above.
>=20
Yes, you need bit fields with above fix.

> > > --- a/drivers/net/ethernet/intel/ice/ice_devlink.h
> > > +++ b/drivers/net/ethernet/intel/ice/ice_devlink.h
> > > @@ -4,10 +4,16 @@
> > >  #ifndef _ICE_DEVLINK_H_
> > >  #define _ICE_DEVLINK_H_
> > >
> > > +enum ice_devlink_param_id {
> > > +	ICE_DEVLINK_PARAM_ID_BASE =3D
> > DEVLINK_PARAM_GENERIC_ID_MAX,
> > > };
> > > +
> > This is unused in the patch. Please remove.
>=20
> Sure.
>=20
> Between, Thanks for the review!
>=20
> Shiraz
>=20
>=20

