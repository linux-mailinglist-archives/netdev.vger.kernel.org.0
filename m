Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09CD3459B6A
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 06:15:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232170AbhKWFSb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 00:18:31 -0500
Received: from mail-mw2nam10on2061.outbound.protection.outlook.com ([40.107.94.61]:5696
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231292AbhKWFSa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 00:18:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JawHSeughG+qTAq8809dIAUk36qj59SQsDat0+9nDgEevytP4BTBRuJPRepp6haMh2NamCaxRH/X/Z3El4blNlEXjEDai4mA3/iR/arAHcNMbEcCIwqT9oqM/8geHecPyMcgvUbyH1/OUdCV/mfN44BWcRLP+FLE2yF0QljrIceh8LB+151szB0ekorvmsDGHA/Z+kA8xqtaNkaMDcH6VXwVdHb+ZmNxzGXgr+Jn+Wi/7mx8njUnMVd2gEHts8JOdZO3Wum9gpyJ2GPlxdXvKDP9o3dgJUBOsClAshz9Ym5cGvtdNuGrSbD5SyjVgUaYtB6+WJRrnChVJ78JM/gCtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sf7Tltnl0cCn+RkqHY1VyybKhLAqWrI2ScHpdixfoII=;
 b=DlQkYNkYAgF7HkrG3YXpyEizof4LBsBX8rQaNbzIS0ZODr+9WoVZRiRMAx3HBKzpyBNNl+lzMhfGFr4bu6h2SShoi+8+fdXt3+QZs9R8JcPtzUUs537E1Xdg0fdxZS34kRWPSQnA1MBEwnOI9y0cR0CvQJ3L5RLlVYgUpOqj5ImbV1PJnoJX5vwXiG+Z7qxWmPe9dVwoZthpjscjKAgsnH35j0eYOYvdw7dw21pZUN44BG08y7oc9JtYHlz7cnELxnQk1ldwz89AcBSUdMnT+0auixegQd4MBvfjL7+eW2S1MC1DUytI1gRzXe3mJvhGFK8QPvFaDKNJFw8BfZWxdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sf7Tltnl0cCn+RkqHY1VyybKhLAqWrI2ScHpdixfoII=;
 b=Lk/yrJ/DqMkQydP23p9pLYz60Sh/xklDu/NHMcHjNcJdpydNFKXi2k3kePB7F6BabpsGdaTDzXNBsNVDslLS4mvXPn8uOKM4jey/Bd3dz5WrbRIQlRy4BkOFDquZO8bDV+R0vCebzuQiThg6pJplK03Y7cb7lQkPg1n5gW7diI906661yRhY86ucZuYlns4ZMGt8Og4VW1JOxNba3ZxaLYeDu01YsvlzyoDFlaMWeE9yNm0nvPEsQFZ5MGPu7BsUp8dzf3cOzcbHT1bSPrm30b+fMh51gxy44sOhPjKzmJcbskOnttjhHD9p3uGtxlgNXp4fy8Pi5q7YFqV87dtbSQ==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by PH0PR12MB5468.namprd12.prod.outlook.com (2603:10b6:510:ea::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Tue, 23 Nov
 2021 05:15:22 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::5515:f45e:56f5:b35a]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::5515:f45e:56f5:b35a%3]) with mapi id 15.20.4713.022; Tue, 23 Nov 2021
 05:15:21 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     Shiraz Saleem <shiraz.saleem@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "mustafa.ismail@intel.com" <mustafa.ismail@intel.com>,
        "jacob.e.keller@intel.com" <jacob.e.keller@intel.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Leszek Kaliszczuk <leszek.kaliszczuk@intel.com>
Subject: RE: [PATCH net-next 2/3] net/ice: Add support for enable_iwarp and
 enable_roce devlink param
Thread-Topic: [PATCH net-next 2/3] net/ice: Add support for enable_iwarp and
 enable_roce devlink param
Thread-Index: AQHX3+WwpM2cBkHpH0m4XULVQ1XC+6wQj0xw
Date:   Tue, 23 Nov 2021 05:15:21 +0000
Message-ID: <PH0PR12MB5481DD2B7212720BB387C3DEDC609@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20211122211119.279885-1-anthony.l.nguyen@intel.com>
 <20211122211119.279885-3-anthony.l.nguyen@intel.com>
In-Reply-To: <20211122211119.279885-3-anthony.l.nguyen@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 24a5ca06-b520-42eb-0ce7-08d9ae403fb9
x-ms-traffictypediagnostic: PH0PR12MB5468:
x-microsoft-antispam-prvs: <PH0PR12MB54688F8F6A61CD5C71134C93DC609@PH0PR12MB5468.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: immp9JWWXfZ7+QVtEOXcMcusVuRSUA0FkVFzWCkoJuGE2Xxu4JOsuf9xMV//9TEBSQJv2u4XBb0mKpJYThKTyFRhAH2ZGmkmLDR8Bw+tB1xuQp7Fnw6AXB/mxuIxQ4ofXdXhPigi7KXbpUCZ2MD7wJYvwBUT6YNJuF7yc7fOHXEs60FCIQVrHtEYGbU/f3ZI/5W4Nu1XKYaVBj86Zw9NW2FCn1Kb/Q5UlfItfKnpOmBysdCvJmiA8qIwtys/eYYqktjxGyK+sD/aviBuVjYRm8DN5+pte8yrwPsbIPP4c5ul6SOpkAbuGULO9k4a9hSQMNjTIdZTNdIDUTNHBq7B/z36idffSt59TkgeG0RbZZNuS+F5I86ZacZeEJxUQ5rUM9SiUWUJejhLcxXLspR8dtoZeFbueTWxOpap/g1yqvTu1K+wI0Xdvb8fqrQNl0E8FpmEbVN8mRiObYmeNyd/2m4aYx8/hkA18plgEcGN8d2iIO1jMc2qujKW8SBs4UglxWPst4J2KF3koRlaBSVwRzJ1Bc8rGXzILwJ+Q/eXOeInpSNClRaEc/M9Ck3NqpyE1nBrvDkv19xFJkav3FSvOoe1MTvkKry6GDBLWBmj6qvHRgFdh7wD7GmQEGqE/LbH/htFzoGpKGv+GI+3GoghEp59t6AZaIb/iVhOBoHJ+78RkaoSLVxryi3Alf8mZkt0ZDL7uschwzUXdjeEtw5kSw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(54906003)(508600001)(122000001)(8936002)(76116006)(55016003)(7696005)(9686003)(38070700005)(66556008)(4326008)(6506007)(52536014)(66446008)(26005)(2906002)(86362001)(66476007)(5660300002)(64756008)(186003)(33656002)(55236004)(8676002)(71200400001)(38100700002)(110136005)(66946007)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?szieRlvI3pb5gmg7aEYlsvLkNHxAIKf5m1vUqu85vmG+RMXZxSHjFxM8LMYH?=
 =?us-ascii?Q?E4VFOCX7IyHZP+5+G8do1Ldc2aVXLFINQbA7LueYE/fkN/Q+Y6iDz+XTLvNI?=
 =?us-ascii?Q?nUj/my1FrSUPhqZif8bpbQdxbXnds0H8hTJDji15sspCGNWlIs6cWLgLbzk0?=
 =?us-ascii?Q?cGJ/v3fOAuigRr6hIMuK+XYIVasLhTug5X/vFN4tn92tMXBB7EC1QujWSF4D?=
 =?us-ascii?Q?uyRLUNHZ8+eHIV/c9zJvIi9SDiaWWNgQVCM7TJTARnBwhZIaIEKn2jKWe1Gx?=
 =?us-ascii?Q?DlIFGv/qvATXOYcQ8LKTA2kJO7LCvf4CMLX79+10b2XdtjiNaIKFSUGCAkjT?=
 =?us-ascii?Q?De2iM3+BamPM74kjcoSeKybTB1dxZjWe57dCIYDJqD2CIVALF3PEYca2eurB?=
 =?us-ascii?Q?+rAFepR4inTqWFDY1CdXgb7hFvQYF9nHvO7JWkoLHZn98IfigbjTfEuv7EFt?=
 =?us-ascii?Q?GHBjsnhatOCNBh6XJxFhWnRP+g83s47ho3kptO/pp4txPw4GFlKweseEsZq1?=
 =?us-ascii?Q?zGnAF4Lp3DzBf21wHCeCEFmsNJW0Jme68stp+/SoWxY0ay7+ZIGJll1gq8r0?=
 =?us-ascii?Q?nRvju1cat7AOdRe4lbWcmU0ziLjFxtPpV32496v1PFPPD8/hAUV0drliI8y2?=
 =?us-ascii?Q?9N0bPBrNlxW8HKWoIwA4/VoV/6nm35S+Br+rNC5uLCZPlSxZF4knmMjYaHyF?=
 =?us-ascii?Q?V92OcJ2Y3c00z6Tm2fWlHsdtNxBgfMiWFmKG1I+NS5emMP2oOIsP0agCQ/D2?=
 =?us-ascii?Q?uka/nI8Ru3l8Nc0WDefwzynAfxwJXhNFbbAUFwFXPqJ2Sl13Vizx3u+SNZVI?=
 =?us-ascii?Q?h1+VG/hwRlXVjMNiJCPkllLrLas0qXotstaatGhjyteQ6VL1QyjblbjBOWXT?=
 =?us-ascii?Q?1XGqVTN73UM33xnVOsgeL9bMBOKU5zc5+bSq1s1qFBiQ+1W+1+RZ/Z3GXpB5?=
 =?us-ascii?Q?32uPAEfUkll0FlRWQku9rrC7pZUM9817h5Cd6jl0pkb88t66QCkPRkSweRi+?=
 =?us-ascii?Q?QkVvGkyqvVO29Hi4CtDq613MD7doZ6DuAWj1YCpz5M6FGo+KYgkO/j+ppPJA?=
 =?us-ascii?Q?HF0F18Cm5cW9u09uuQIdrnTdcHZGmjIGLKZZnoVf/VUvUy3e3lAjWvM1S/Kh?=
 =?us-ascii?Q?ZtD/etwxrDO5LIL1a/R79D+GeDH5IL0E846SAqxCPx4siufSCEtUJnI+4oHj?=
 =?us-ascii?Q?3GHXNBG959qtyFMb+Jvq4upwg8UOqATH31KKGUICKa93n54PWnPioMmgMelP?=
 =?us-ascii?Q?t9Y4Sjfimuai6PJQaStdnebGslpasPDziVOMUhnE9lTgFBXtnsS5+QaqYPrJ?=
 =?us-ascii?Q?Qy4SeIqXXhHrQ5OXOteI3aRFoNv4ThojV26Q7OtqZRc3NGCvAhFPRq1jlftp?=
 =?us-ascii?Q?nNKTBlhrOOFIw88eyM7Zd8thbyyQ7W1mrfsPWSdKw3gL+oUYkshltiu45+2T?=
 =?us-ascii?Q?1NdtAtJURXu8NxWo2XgzXU2CrQ6Y1ZyChXHDvd1280DIymmYgPCI2/w9C1S5?=
 =?us-ascii?Q?G8pV+qrgGU6EEyH5EmYvXEP8dodY3WmCzXqlsvuhsHX3l3FrgOH6Yp8aD/FP?=
 =?us-ascii?Q?IQK5PBagiELhe9EehYzkx/FnDWhJcbNM/FHXhyVt6WNMPemqHKwO5vBfB8P6?=
 =?us-ascii?Q?39CXBal697wZ3hzFTPj30U4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24a5ca06-b520-42eb-0ce7-08d9ae403fb9
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2021 05:15:21.8264
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IpNYKIgLO/4k97eEjpDcav1JhQUF4i76a5JdADQ/0OjXCyDWxl7Xuo14aqW2xLGBQbjeBd23R4fi1qNIdbguCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5468
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Tony,

> From: Tony Nguyen <anthony.l.nguyen@intel.com>
> Sent: Tuesday, November 23, 2021 2:41 AM
>=20
> From: Shiraz Saleem <shiraz.saleem@intel.com>
>=20
> Allow support for 'enable_iwarp' and 'enable_roce' devlink params to turn
> on/off iWARP or RoCE protocol support for E800 devices.
>=20
> For example, a user can turn on iWARP functionality with,
>=20
> devlink dev param set pci/0000:07:00.0 name enable_iwarp value true cmode
> runtime
>=20
> This add an iWARP auxiliary rdma device, ice.iwarp.<>, under this PF.
>=20
> A user request to enable both iWARP and RoCE under the same PF is rejecte=
d
> since this device does not support both protocols simultaneously on the s=
ame
> port.
>=20
> Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> Tested-by: Leszek Kaliszczuk <leszek.kaliszczuk@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice.h         |   1 +
>  drivers/net/ethernet/intel/ice/ice_devlink.c | 144 +++++++++++++++++++
>  drivers/net/ethernet/intel/ice/ice_devlink.h |   6 +
>  drivers/net/ethernet/intel/ice/ice_idc.c     |   4 +-
>  drivers/net/ethernet/intel/ice/ice_main.c    |   9 +-
>  include/linux/net/intel/iidc.h               |   7 +-
>  6 files changed, 166 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/intel/ice/ice.h
> b/drivers/net/ethernet/intel/ice/ice.h
> index b2db39ee5f85..b67ad51cbcc9 100644
> --- a/drivers/net/ethernet/intel/ice/ice.h
> +++ b/drivers/net/ethernet/intel/ice/ice.h
> @@ -576,6 +576,7 @@ struct ice_pf {
>  	struct ice_hw_port_stats stats_prev;
>  	struct ice_hw hw;
>  	u8 stat_prev_loaded:1; /* has previous stats been loaded */
> +	u8 rdma_mode;
This can be u8 rdma_mode: 1;
See below.

>  	u16 dcbx_cap;
>  	u32 tx_timeout_count;
>  	unsigned long tx_timeout_last_recovery; diff --git
> a/drivers/net/ethernet/intel/ice/ice_devlink.c
> b/drivers/net/ethernet/intel/ice/ice_devlink.c
> index b9bd9f9472f6..478412b28a76 100644
> --- a/drivers/net/ethernet/intel/ice/ice_devlink.c
> +++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
> @@ -430,6 +430,120 @@ static const struct devlink_ops ice_devlink_ops =3D=
 {
>  	.flash_update =3D ice_devlink_flash_update,  };
>=20
> +static int
> +ice_devlink_enable_roce_get(struct devlink *devlink, u32 id,
> +			    struct devlink_param_gset_ctx *ctx) {
> +	struct ice_pf *pf =3D devlink_priv(devlink);
> +
> +	ctx->val.vbool =3D pf->rdma_mode & IIDC_RDMA_PROTOCOL_ROCEV2;
> +
This is logical operation, and vbool will be still zero when rdma mode is r=
ocev2, because it is not bit 0.
Please see below. This error can be avoided by having rdma mode as Boolean.

> +	return 0;
> +}
> +
> +static int
> +ice_devlink_enable_roce_set(struct devlink *devlink, u32 id,
> +			    struct devlink_param_gset_ctx *ctx) {
> +	struct ice_pf *pf =3D devlink_priv(devlink);
> +	bool roce_ena =3D ctx->val.vbool;
> +	int ret;
> +
> +	if (!roce_ena) {
> +		ice_unplug_aux_dev(pf);
> +		pf->rdma_mode &=3D ~IIDC_RDMA_PROTOCOL_ROCEV2;
> +		return 0;
> +	}
> +
> +	pf->rdma_mode |=3D IIDC_RDMA_PROTOCOL_ROCEV2;
> +	ret =3D ice_plug_aux_dev(pf);
> +	if (ret)
> +		pf->rdma_mode &=3D ~IIDC_RDMA_PROTOCOL_ROCEV2;
> +
> +	return ret;
> +}
> +
> +static int
> +ice_devlink_enable_roce_validate(struct devlink *devlink, u32 id,
> +				 union devlink_param_value val,
> +				 struct netlink_ext_ack *extack)
> +{
> +	struct ice_pf *pf =3D devlink_priv(devlink);
> +
> +	if (!test_bit(ICE_FLAG_RDMA_ENA, pf->flags))
> +		return -EOPNOTSUPP;
> +
> +	if (pf->rdma_mode & IIDC_RDMA_PROTOCOL_IWARP) {
> +		NL_SET_ERR_MSG_MOD(extack, "iWARP is currently enabled.
> This device cannot enable iWARP and RoCEv2 simultaneously");
Since ice driver has this mutually exclusive and whether RDMA is supported =
or not is already checked by above flag ICE_FLAG_RDMA_ENA,
rdma_mode can be done as Boolean.

> +		return -EOPNOTSUPP;
> +	}
> +
> +	return 0;
> +}
> +
> +static int
> +ice_devlink_enable_iw_get(struct devlink *devlink, u32 id,
> +			  struct devlink_param_gset_ctx *ctx) {
> +	struct ice_pf *pf =3D devlink_priv(devlink);
> +
> +	ctx->val.vbool =3D pf->rdma_mode & IIDC_RDMA_PROTOCOL_IWARP;
> +
This works fine as this is bit 0, but not for roce. So lets just do boolean=
 rdma_mode.

> +	return 0;
> +}
> +
> +static int
> +ice_devlink_enable_iw_set(struct devlink *devlink, u32 id,
> +			  struct devlink_param_gset_ctx *ctx) {
> +	struct ice_pf *pf =3D devlink_priv(devlink);
> +	bool iw_ena =3D ctx->val.vbool;
> +	int ret;
> +
> +	if (!iw_ena) {
> +		ice_unplug_aux_dev(pf);
> +		pf->rdma_mode &=3D ~IIDC_RDMA_PROTOCOL_IWARP;
> +		return 0;
> +	}
> +
> +	pf->rdma_mode |=3D IIDC_RDMA_PROTOCOL_IWARP;
> +	ret =3D ice_plug_aux_dev(pf);
> +	if (ret)
> +		pf->rdma_mode &=3D ~IIDC_RDMA_PROTOCOL_IWARP;
> +
> +	return ret;
> +}
> +
> +static int
> +ice_devlink_enable_iw_validate(struct devlink *devlink, u32 id,
> +			       union devlink_param_value val,
> +			       struct netlink_ext_ack *extack) {
> +	struct ice_pf *pf =3D devlink_priv(devlink);
> +
> +	if (!test_bit(ICE_FLAG_RDMA_ENA, pf->flags))
> +		return -EOPNOTSUPP;
> +
> +	if (pf->rdma_mode & IIDC_RDMA_PROTOCOL_ROCEV2) {
> +		NL_SET_ERR_MSG_MOD(extack, "RoCEv2 is currently enabled.
> This device cannot enable iWARP and RoCEv2 simultaneously");
> +		return -EOPNOTSUPP;
> +	}
> +
> +	return 0;
> +}
> +
> +static const struct devlink_param ice_devlink_params[] =3D {
> +	DEVLINK_PARAM_GENERIC(ENABLE_ROCE,
> BIT(DEVLINK_PARAM_CMODE_RUNTIME),
> +			      ice_devlink_enable_roce_get,
> +			      ice_devlink_enable_roce_set,
> +			      ice_devlink_enable_roce_validate),
> +	DEVLINK_PARAM_GENERIC(ENABLE_IWARP,
> BIT(DEVLINK_PARAM_CMODE_RUNTIME),
> +			      ice_devlink_enable_iw_get,
> +			      ice_devlink_enable_iw_set,
> +			      ice_devlink_enable_iw_validate),
> +
> +};
> +
>  static void ice_devlink_free(void *devlink_ptr)  {
>  	devlink_free((struct devlink *)devlink_ptr); @@ -484,6 +598,36 @@
> void ice_devlink_unregister(struct ice_pf *pf)
>  	devlink_unregister(priv_to_devlink(pf));
>  }
>=20
> +int ice_devlink_register_params(struct ice_pf *pf) {
> +	struct devlink *devlink =3D priv_to_devlink(pf);
> +	union devlink_param_value value;
> +	int err;
> +
> +	err =3D devlink_params_register(devlink, ice_devlink_params,
> +				      ARRAY_SIZE(ice_devlink_params));
> +	if (err)
> +		return err;
> +
> +	value.vbool =3D false;
> +	devlink_param_driverinit_value_set(devlink,
> +
> DEVLINK_PARAM_GENERIC_ID_ENABLE_IWARP,
> +					   value);
> +
> +	value.vbool =3D test_bit(ICE_FLAG_RDMA_ENA, pf->flags) ? true : false;
> +	devlink_param_driverinit_value_set(devlink,
> +
> DEVLINK_PARAM_GENERIC_ID_ENABLE_ROCE,
> +					   value);
> +
> +	return 0;
> +}
> +
> +void ice_devlink_unregister_params(struct ice_pf *pf) {
> +	devlink_params_unregister(priv_to_devlink(pf), ice_devlink_params,
> +				  ARRAY_SIZE(ice_devlink_params));
> +}
> +
>  /**
>   * ice_devlink_create_pf_port - Create a devlink port for this PF
>   * @pf: the PF to create a devlink port for diff --git
> a/drivers/net/ethernet/intel/ice/ice_devlink.h
> b/drivers/net/ethernet/intel/ice/ice_devlink.h
> index b7f9551e4fc4..faea757fcf5d 100644
> --- a/drivers/net/ethernet/intel/ice/ice_devlink.h
> +++ b/drivers/net/ethernet/intel/ice/ice_devlink.h
> @@ -4,10 +4,16 @@
>  #ifndef _ICE_DEVLINK_H_
>  #define _ICE_DEVLINK_H_
>=20
> +enum ice_devlink_param_id {
> +	ICE_DEVLINK_PARAM_ID_BASE =3D DEVLINK_PARAM_GENERIC_ID_MAX,
> };
> +
This is unused in the patch. Please remove.
