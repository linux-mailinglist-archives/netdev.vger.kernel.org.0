Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AACE459B7F
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 06:17:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233089AbhKWFVD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 00:21:03 -0500
Received: from mail-sn1anam02on2084.outbound.protection.outlook.com ([40.107.96.84]:2240
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233040AbhKWFUi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 00:20:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TnSuIEQN2hMm9TxyGHJFwshQX2/1dIP4wcjKsW4vagc43inEIm0iSUHOZdtUrukByyqRs2rWI7AZHKv0dG8mNZHrhLpFCUEJUcHTnSwD+ODRKAwYpRIiJbGFe3yjmHxppU59RorWwv7doJSpl0pld7+SvfNcy3lOv7CPIGpj/XBC/COcCbHI5SAIBOtVA49bnbhDgQiaX7kel456Na2myL2fYIafWVxXhDKxKAsCOlx+seqmT9G3c64Cgynja2fu1u+6rX1KQYB7SgcAQgT9DuDu3PCUgwB+BlbItJB7TyGu4PtoDWYMX5vB4RAVFAdTF9Mx0jJvgDw7TySAFoyTdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zxL/rKf66QFB797PZdr/emzHotG+FFGA+7OGMFxHR9E=;
 b=M5dsv+viHYfvMudH8+PbM2vNq1WITKqc8mcHX8LcZAhdwgq3fxuB3d7euJDNTYn+61BiIqqVUiJ2pVApQm8Wi1j0yD9qfoeKu8b6ivTFq+3ORyM6OTvmpjAEvIGwrN8289gwKgCUPwWrlgmFSbuF/Xzi+TleWXvqQw/oceI1eq6RNTfABTyRapCpvqwtE7xO7eqzQQDEI/g7ug5WG9inRWBAb4dQCY3ZJWuDJq6qrHQPm8EkrYoNwolgdZqj/VS2RN6g6BMxCPmH8ibYzKUGQxGnaM2DLMkvH7SLLXUN9vh1vDIvsErtg0YFYIt5LnApxXBW5ky1eG6h5Mhjbr/lDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zxL/rKf66QFB797PZdr/emzHotG+FFGA+7OGMFxHR9E=;
 b=WBEei1sQ22l3sdTg73RIYNsegpzZvp7arlyZ2zUZQ382mcPrT4R8vbddkJXsD0YceyN95abFMq65sFQTkieko8MYRsC2YqNMLLFE0J0XtQpLHhXtCFj8x88+/UnfX8HXnRBSNqyitEmgL6F0TwaAlpgjX93fxP7rRC+NBguSgp5mzWLNOAIuGKMPZAvfJAIUxa1ddiyPQEmXyjv0RGDGBjkr5Q6Atyx+cJba0x1PiHcb6zLi1wDosLkd7AsVTdzrOCUf5ix79CmFU9tXIoHoO8uQw3nDRcVo4nrdoqnd5m2Dwh3z9DmZAjTko4azyfne9AZXesBLM55DEr11hxSvcw==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by PH0PR12MB5500.namprd12.prod.outlook.com (2603:10b6:510:ef::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22; Tue, 23 Nov
 2021 05:17:26 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::5515:f45e:56f5:b35a]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::5515:f45e:56f5:b35a%3]) with mapi id 15.20.4713.022; Tue, 23 Nov 2021
 05:17:26 +0000
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
Subject: RE: [PATCH net-next 1/3] devlink: Add 'enable_iwarp' generic device
 param
Thread-Topic: [PATCH net-next 1/3] devlink: Add 'enable_iwarp' generic device
 param
Thread-Index: AQHX3+Ww/FVXD0M7hU60SMgaGXxgMKwQkujw
Date:   Tue, 23 Nov 2021 05:17:26 +0000
Message-ID: <PH0PR12MB5481668180201E8ED641C779DC609@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20211122211119.279885-1-anthony.l.nguyen@intel.com>
 <20211122211119.279885-2-anthony.l.nguyen@intel.com>
In-Reply-To: <20211122211119.279885-2-anthony.l.nguyen@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b32d2762-d760-4223-de1d-08d9ae4089fb
x-ms-traffictypediagnostic: PH0PR12MB5500:
x-microsoft-antispam-prvs: <PH0PR12MB5500A13CED56D7D0640CF0D0DC609@PH0PR12MB5500.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1751;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rr5iewVYxfS8Kxz1JYXYYnLs2f9GLnXSrxXKWmUjq6btbWBTAt0UR1JOM9g239ZnnYcqh75t/ntGY0rBEfl1Kb3Y1PPWf8DU0msvOeGfwbVsGfNVk1rDgC0ypnQQJNb9ozKwaMLxbAEITLKMQHP21rWYCjA4xQZ6lNyaYJWsjlw/UqzU5qPOyX6XCewB+1ZHitkR/xxnslxGaULTAFEeq2ZgaeTNgu6Xz+oNWJEoy1B/5f1UR7XTo63ejdyDiJnc+lJ58fspIVqD6BKaDSsjMOJClPUM7P65dZv4MQdpRyT0n5nvnxbeCZXR2QTab0UDZYdzNjoNJocceXL7FrkRXTD9unjKAEde3lNBTOfRDAhR2m9+VSBlb8VfK/MDIHpO/F8ZMRtuP8J1Wd+Zm5Ge959F36MipmvJeaapAHNRbpUqLaNHSEdMZaMucp2J7B+0fTDyc8yL6kiNNtvSJtr24wTtNOT2noZ2LsMIrja7uz69Eydkwq96JlM44sDWo4TZCEkW+Ayxmh524lxcCRayE2sZAujAQfTJXyFHMjKg9190eqrIEeMeXo1pkDt2L/KlE9RLeYyDpGM6T6krxjQ5OZ6H2R3tfy/cCAWP7FwHV2YCkEBmWin3QIFOG73F8s+A3lML4Y2S6lxFXy2ieWM8FljYG3be+FIx+Iv536dP2+jrEWbhAY9N5B16mOsRsHRhxyMami6nma3KKkqt8o/8UUUuVu7ZIsx0+qFgrNrgPl0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(66446008)(64756008)(2906002)(38070700005)(66556008)(508600001)(7696005)(66476007)(52536014)(76116006)(33656002)(9686003)(4326008)(55016003)(8936002)(55236004)(83380400001)(5660300002)(54906003)(26005)(71200400001)(110136005)(6506007)(8676002)(186003)(66946007)(122000001)(38100700002)(316002)(41533002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?x1qOiuA2JkHHbf5wTYRDP1aNgdOSP+6bjHT99GGJPbEZZlkCU6CbSrRfwbTC?=
 =?us-ascii?Q?23VNuaCSPgMJAixbh0M1AVhRUHFhsUSlesx4qVhIaIwWY5jGhmwkXQek8llU?=
 =?us-ascii?Q?i2J6dCBnmGWC2Ljy+4lOKCSd8mFotNfvrx4JX8lLRh82E2y8zQO0Fyxcmqej?=
 =?us-ascii?Q?rVPkUy7+jMgF01mk7jxiBgh4FVMDM0lXpZl8knPCiKPGuWwq4QfQwKzAAv4X?=
 =?us-ascii?Q?h9xWCfQ+7/1RPJ7RAd6K29nrghNuvldv9q/V8aRKf1mM8ML0puffT86iDYUN?=
 =?us-ascii?Q?zCxkrk6C0CI2VPKomg5Vq7vMFPR9624l9g0B7sJ/0QgzrUweBcKd79y8ENW+?=
 =?us-ascii?Q?vBt0jHr53YYyaF9RpSvamqpUb+NQrCRQot8Gx1oXoON6SgeCCUzFU3NKmLWr?=
 =?us-ascii?Q?0OlhVmpN/oPRAfDJnINf3qX1KQfXjgvas+OghpwUT5Dm7DFPgOOkw9m4CZQ7?=
 =?us-ascii?Q?xzcU/5lPlO8wUBgN1lBrTLobUq6VHJ4ePdQlKrCIHSCkaeofQY9/pD3ELwjI?=
 =?us-ascii?Q?KgE9Plz3WM45tSThZLHpVLDuyTrHnQxwTTPHzzCXzJunIuMSkCkQdttRdAYt?=
 =?us-ascii?Q?aMIZtxPLofBPhttE3uyfw0ZgwWdTtNNgeYTIcclW7eP/LGTf2VA8kTV+L1pg?=
 =?us-ascii?Q?3MsA5OigES6rF18KBsu1YaOA90cCJVITrfwfMCB5+7IAPz5ROqHqFKgMBtm6?=
 =?us-ascii?Q?mOJcIRC1G4h7/oSwjFqzfA/K4puPR4TIycB/gfzJ4KksDdX4TXrFHwL3TTie?=
 =?us-ascii?Q?7k1zoigH4+obBhR7BH3xFp8OWRca6VGAREouz3bMdOLcRHnsz6ptOlemS+0z?=
 =?us-ascii?Q?lAqkqdgmecrVtMsJUvRX0Nnawwe7XRLint6FZpTHrRFyexk5SFgkAYxTceDo?=
 =?us-ascii?Q?HIMVa3BcvbQvvEDfUcQ0ePGvrx3N3mpbrqDVlbuyVHsWGiBPeSKrVhYrRL7s?=
 =?us-ascii?Q?2CgL1WTqHzBCyRSWDH9X3wo5iRajXa/xWO3jDxQ/rv3UVSNzmzlU+WsdBRVh?=
 =?us-ascii?Q?OiEanelgY5iSAGZ60GapMzD7UIo6UHXnSaRRNdxosvi/JCqP+Hk/pg88PunE?=
 =?us-ascii?Q?TTr4DkiXwMkaX8PlU8BNFZGYu9xp9CkHWReXQP2pGfpoMZGD71DIkJJNMYvZ?=
 =?us-ascii?Q?6fnbGITaJJmUQk8HwdptUF/r/rfmyXI91NU+/V25kpYuSopOKG4nTJwCOv4X?=
 =?us-ascii?Q?e+8+lbrUkyh5MuCC4H4IkscFrHeHhgtTxBvU8g6MfxzJzQ44JLZGuYgyArzg?=
 =?us-ascii?Q?9z0o9E7/cJCKOanqHjZCHG3tKTrcfxdJCFufTmv9CPTPuzRiVV5sKwM65sln?=
 =?us-ascii?Q?3ahGTTpXZqR06bbdwLi8LTh9pesQtxQI/5KEistI+oKt22TYX88ksOTkfHv5?=
 =?us-ascii?Q?sT0ThMz+Pj4g4tKst7CdqWsl0RXi+XHQzRqq8ORdUuJfmp+nqnzq7AwrRFQa?=
 =?us-ascii?Q?NULgZkUGneZFmldmnQMFrQ6El15kvYUJZ2JTs4NbEaf3fhmSTjnDtvbphBrA?=
 =?us-ascii?Q?8y/roJUxb8bvTUGmYIt5aszMlIR0J7YJiwHsfFRCDeRYGNgkX/pymFt8EXl3?=
 =?us-ascii?Q?byloH+sRUQcw1ptEeZKaF2cJ4N0l1a3+jgiiTzUtCicbgf/knurUZopRnxj6?=
 =?us-ascii?Q?FPP2K1uVAZOerZciJLiwGkc=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b32d2762-d760-4223-de1d-08d9ae4089fb
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2021 05:17:26.4337
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UbSiE3ml8D2jJTl0DgnJZP/qCyYbZVFEwJsNSwxKHoZ8SvcVSRXFKj6DtiGRuLtgxUyC/2tMLNPgUdMDLQ28VA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5500
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> From: Tony Nguyen <anthony.l.nguyen@intel.com>
> Sent: Tuesday, November 23, 2021 2:41 AM
>=20
> From: Shiraz Saleem <shiraz.saleem@intel.com>
>=20
> Add a new device generic parameter to enable and disable iWARP functional=
ity
> on a multi-protocol RDMA device.
>=20
> Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> Tested-by: Leszek Kaliszczuk <leszek.kaliszczuk@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>  Documentation/networking/devlink/devlink-params.rst | 3 +++
>  include/net/devlink.h                               | 4 ++++
>  net/core/devlink.c                                  | 5 +++++
>  3 files changed, 12 insertions(+)
>=20
> diff --git a/Documentation/networking/devlink/devlink-params.rst
> b/Documentation/networking/devlink/devlink-params.rst
> index 4878907e9232..b7dfe693a332 100644
> --- a/Documentation/networking/devlink/devlink-params.rst
> +++ b/Documentation/networking/devlink/devlink-params.rst
> @@ -109,6 +109,9 @@ own name.
>       - Boolean
>       - When enabled, the device driver will instantiate VDPA networking
>         specific auxiliary device of the devlink device.
> +   * - ``enable_iwarp``
> +     - Boolean
> +     - Enable handling of iWARP traffic in the device.
>     * - ``internal_err_reset``
>       - Boolean
>       - When enabled, the device driver will reset the device on internal=
 diff --git
> a/include/net/devlink.h b/include/net/devlink.h index
> aab3d007c577..e3c88fabd700 100644
> --- a/include/net/devlink.h
> +++ b/include/net/devlink.h
> @@ -485,6 +485,7 @@ enum devlink_param_generic_id {
>  	DEVLINK_PARAM_GENERIC_ID_ENABLE_ETH,
>  	DEVLINK_PARAM_GENERIC_ID_ENABLE_RDMA,
>  	DEVLINK_PARAM_GENERIC_ID_ENABLE_VNET,
> +	DEVLINK_PARAM_GENERIC_ID_ENABLE_IWARP,
>=20
>  	/* add new param generic ids above here*/
>  	__DEVLINK_PARAM_GENERIC_ID_MAX,
> @@ -534,6 +535,9 @@ enum devlink_param_generic_id {  #define
> DEVLINK_PARAM_GENERIC_ENABLE_VNET_NAME "enable_vnet"
>  #define DEVLINK_PARAM_GENERIC_ENABLE_VNET_TYPE
> DEVLINK_PARAM_TYPE_BOOL
>=20
> +#define DEVLINK_PARAM_GENERIC_ENABLE_IWARP_NAME "enable_iwarp"
> +#define DEVLINK_PARAM_GENERIC_ENABLE_IWARP_TYPE
> DEVLINK_PARAM_TYPE_BOOL
> +
>  #define DEVLINK_PARAM_GENERIC(_id, _cmodes, _get, _set, _validate)	\
>  {									\
>  	.id =3D DEVLINK_PARAM_GENERIC_ID_##_id,
> 	\
> diff --git a/net/core/devlink.c b/net/core/devlink.c index
> 5ad72dbfcd07..d144a62cbf73 100644
> --- a/net/core/devlink.c
> +++ b/net/core/devlink.c
> @@ -4432,6 +4432,11 @@ static const struct devlink_param
> devlink_param_generic[] =3D {
>  		.name =3D DEVLINK_PARAM_GENERIC_ENABLE_VNET_NAME,
>  		.type =3D DEVLINK_PARAM_GENERIC_ENABLE_VNET_TYPE,
>  	},
> +	{
> +		.id =3D DEVLINK_PARAM_GENERIC_ID_ENABLE_IWARP,
> +		.name =3D DEVLINK_PARAM_GENERIC_ENABLE_IWARP_NAME,
> +		.type =3D DEVLINK_PARAM_GENERIC_ENABLE_IWARP_TYPE,
> +	},
>  };
>=20
>  static int devlink_param_generic_verify(const struct devlink_param *para=
m)
> --
> 2.31.1
Reviewed-by: Parav Pandit <parav@nvidia.com>

