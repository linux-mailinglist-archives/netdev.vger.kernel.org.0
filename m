Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C132D4409F0
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 17:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231950AbhJ3PdP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Oct 2021 11:33:15 -0400
Received: from mail-cusazon11021025.outbound.protection.outlook.com ([52.101.62.25]:18748
        "EHLO na01-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230086AbhJ3PdO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 Oct 2021 11:33:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dJm16fdgKNtrClBB/BhRjg/2GtNXHAZIrUdNWUC+suJWOTI+g0yqmoB9KE1WbKAgIddRIYsXVVNcoKCj9UXF86YbPfPNwF66qfyNNCFlVNwU9qJMFgstb4KwKuw5If2f2B08TApa+jXDSsVpHazeKa8WCoGaONFSwrh9Yi9CCnbxuBu0yHEJJS97ZzZWCKw9Gd1HhVsitYf4a8SKoGPsvx51MeBzJ3tcDSAROJcf4SlhZL9kVlv+uz1JNcnjHSnweWnO3sA4G0H46Xq1XaJilfE+5ok0Ms58gQqt06SK7LzQqZal5/9UlCEPhWPJHy49zz+t47rdC+rHSuqbRJLx8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sl+2++Qwr1E8eWVcgSPVM2oKPhTAKWIj9SVbwWSQwcI=;
 b=cS/dh61pAR/4FqOKLVJHyrw0EUY3CZm9UWoB4ffojl80MRUQeBXoJ5S9quIkiOz3itxkdmGNxLEUUvt9WI9yXFMJBAzEjRu7e54NiPdOUFsAsQ5clCGnYqp5zLQpKTxqYLfSKL9h7hf/wmtN+UHIlPkth8/a3VuPYykgLa10DHiC0TWmrX558kJwopKym8zMT5TrsWlzT2dQDxq6lDIDurViMLajIwCDGKZj7eRP2W9YrWsOrbwukvzcZnHG++/WZZcpAwaR/OYxxHBVwzh50Ets4dcIDbPegXkvL46ZoBeL5Frd8ade1p89VlZfDhJ90hTFCaj0d8bvDLr/SYapAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sl+2++Qwr1E8eWVcgSPVM2oKPhTAKWIj9SVbwWSQwcI=;
 b=ZdkZWqCiqABGuymQ9OfZ4A2gDbf7cAhwWLp9/M1SyJ9KZSTgcgr2WIzP3NJx1V8SrFQhzPo66tRG2lubRdXGP64LFYMxSOKt4RUjuctDGTHztDeyzRcgHQyr3y59ek9/HF0Pm6V/PheBJYu3DVYu1lUZ28jfTa8elgVW5rgECQA=
Received: from BN8PR21MB1284.namprd21.prod.outlook.com (2603:10b6:408:a2::22)
 by BN8PR21MB1234.namprd21.prod.outlook.com (2603:10b6:408:77::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.0; Sat, 30 Oct
 2021 15:30:40 +0000
Received: from BN8PR21MB1284.namprd21.prod.outlook.com
 ([fe80::5962:fbb9:f607:8018]) by BN8PR21MB1284.namprd21.prod.outlook.com
 ([fe80::5962:fbb9:f607:8018%7]) with mapi id 15.20.4669.004; Sat, 30 Oct 2021
 15:30:40 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Dexuan Cui <decui@microsoft.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "gustavoars@kernel.org" <gustavoars@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     KY Srinivasan <kys@microsoft.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        Shachar Raindel <shacharr@microsoft.com>,
        Paul Rosswurm <paulros@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>, vkuznets <vkuznets@redhat.com>
Subject: RE: [PATCH net-next 1/4] net: mana: Fix the netdev_err()'s vPort
 argument in mana_init_port()
Thread-Topic: [PATCH net-next 1/4] net: mana: Fix the netdev_err()'s vPort
 argument in mana_init_port()
Thread-Index: AQHXzSi4LzXo/haLVkOIULr1f0GnJKvrq8cQ
Date:   Sat, 30 Oct 2021 15:30:40 +0000
Message-ID: <BN8PR21MB1284DB6301CB6D73260103CACA889@BN8PR21MB1284.namprd21.prod.outlook.com>
References: <20211030005408.13932-1-decui@microsoft.com>
 <20211030005408.13932-2-decui@microsoft.com>
In-Reply-To: <20211030005408.13932-2-decui@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=935e2c5d-858f-4269-8b3c-08a760c9af2d;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-10-30T15:30:20Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: aab484fd-f154-488f-c8b7-08d99bba3ae8
x-ms-traffictypediagnostic: BN8PR21MB1234:
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <BN8PR21MB12344E92251BBCED8B8CCCBFCA889@BN8PR21MB1234.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ItB/j711t4j2CWEDYYqUUnmwlWjd19VFGEZ+n9j2ZuftvVjM44fVPKv2240Hz7keV0ISghvKs0PVZqG66wRELgwtbkfZb474DGn2VEWlN0U8sNCn2JnKHQGuRYQLVHHxdgTM38WEmI4A+M+WyJ/kjO5QdWJpzI47WOvJSWlQCqGePVGCRPyCaSG36qLtmzed6oDYZuglgRqhpvuNz+zxw7a6kVJEjIPCbAJ2A94Y8liKWBYXRJkE9hd9gZFWA/KlU6QMPBxAMYLG3t66PbIe/a9YMLVLmxQEs8Jzhl84GZKK/DVS2PcE4ctjoJO/5IThMd5ZPKOb7g1UNqqzwtBCovyVqLGB1rVX+XUnxdPVfmz9Mco96Q+vgz1X82dsPyi3jWus20OA9E8iB3Txi81vNERJ1rbGFkhkgjx+IUrlK6WcTbKoNJSJKNhr3G3VgLFsQRi2FZxHl5E/ZWsh+2L6J3DIPo9FcUQdPGU8/3dJHsZ4ZMlk65Nij1ht5soBPppRJwAao+mXz9bX67A/GE2cGW6UQkPz7nqrELI9atXgqyMi5ZZvm2zfZ+xlfl1ivSFS3URb1sjc2INrf3Wa5lMhBU4LoGqye8VQL2Uhl8uHjnCeY8Y3+dWI3OjhOxDf4gkSCYzNfmJZPI7hx8M95HsEIHi2lvGiFiEl4ASOEmoW8lP55DuS3SFiUNrTpm/NMP7wRTkcX4L7m9QPDyar85C55w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR21MB1284.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38070700005)(55016002)(71200400001)(8990500004)(2906002)(82960400001)(54906003)(8936002)(186003)(66946007)(66556008)(66476007)(66446008)(64756008)(26005)(9686003)(110136005)(8676002)(76116006)(86362001)(82950400001)(52536014)(508600001)(6506007)(10290500003)(38100700002)(316002)(122000001)(4326008)(7416002)(7696005)(5660300002)(83380400001)(53546011)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?rKR/HQfr0lr0rmQxF05GVVyLtyrLeazePzrOBx9GYgwwp7wwfHtJlvFVinkI?=
 =?us-ascii?Q?ahCP4aXKgLJkxQj0y+mPIayt6zQ0CdWbIBgcSl6TMgN8BhDJz/tuoRIuQQJs?=
 =?us-ascii?Q?vjv5+OLhO5GJIVSPxTTa28UVtHkVye2UGFqNieivYg98rmf83AK2lbwwreKg?=
 =?us-ascii?Q?GP/9Vn0QhqD0Gk2TCELRHooLkoGetDl7zEg7M/xV4sJXLlSatGYwteLpgetl?=
 =?us-ascii?Q?sCJp7FG8gTRhprYftIT80jV0Ntd1MRGiLFjBkAQMWdgji24RT7gbfY2tLuJk?=
 =?us-ascii?Q?tcfVd74zqk3X6qb4Liy0RkXKppXMrcr3qSa+DFpG+h59P5MZiTQhBrLIvxAz?=
 =?us-ascii?Q?Y3g4GX2RECoJ2V0yymqqQTKJH5xt/ZCRGiMUV5R8MTwJjD1uztxEHcXV5M1h?=
 =?us-ascii?Q?LHGkVXO2KCRrIYvprbOYpVuRkQyRZW5oXPRjRU2ioREZqJRpxKbwNDIqgmve?=
 =?us-ascii?Q?C2m0qsMQ/I13/5g0Jd55itiTTIYi/5tkgCMoKreNSF10nqIJI6uIG9QdfYst?=
 =?us-ascii?Q?i8uaHN2ubK/aytl+5A79nq15IwTxIE4/DMW5hYgmwbOcCej61TNpmpUbwNGk?=
 =?us-ascii?Q?5WTkAVrchKDOLWff+4PvMHSjsJn0wLX+bn1SbpFf5sSG2VZJXLjACousSgkB?=
 =?us-ascii?Q?CwbU3bDFhyGQb923rBCi3y54Uqq6cH2DDF6HZY91Wwv9UCZnvLoICWLc0f6u?=
 =?us-ascii?Q?tbtdLVMJNmLYgeVwvzxD4MLCqTLAJmHk4dIjlPPYdvOBRLthqRIoPiAj69um?=
 =?us-ascii?Q?Y0pj4JB85lo43raSuzG7H6d/u4N2DZJW67M6Br6ejqKGUw2VSI/EG3hgJtku?=
 =?us-ascii?Q?uWsVVm9hoiRC6Bo2B/C0Ufks9I1yOVqbWLxH/Hjj/HVaV4lQ5INjfh1+pRND?=
 =?us-ascii?Q?Q2HQpIN3hI9He2fpGx2O52dd9y76bRftujZ6T9EfIy+s9TsLx68UnKlfqeW7?=
 =?us-ascii?Q?tbxRR3oOXnU9iwLo+iieHLIuGGJJzeOxwjXyPIdNm1+8jZ/18r0ycuIS840j?=
 =?us-ascii?Q?spSTjpPD2sIdG71w0tvlbbhKvz9EOWj8ys1/lkUz6fSk2Hyt1j5S9kLeTxmz?=
 =?us-ascii?Q?vvP8CWHiNDgD7eW4QtN+scWmWTBnDPmSDvHhanqeeE5yW5PUTKEC0Ih86xiU?=
 =?us-ascii?Q?fNGba6LwZwN3xuRt0CFAo2yRR+hj5ASWw7EQDx181QQng6rnQcPf2jRgHx09?=
 =?us-ascii?Q?JGu8D0M7BTOlDF9Z3Uyu5mCUEIzhjGJmmUhz7eb/ybwPzuYUARnAMg4CjAUN?=
 =?us-ascii?Q?qfulu/lvtL9hWqiw2xoPe5fL1yNExiiBmQsrDOW/iPdtYDwhIbV+OULki9zV?=
 =?us-ascii?Q?M1OPalx/mHDqIlxfoGn6jKdA+fY0ivD/Bs1dVKMGq0v2j8hxH/z4r5Gv0Wbn?=
 =?us-ascii?Q?8dGqapSWcWUylY0iYJctAQ11xuAe8XxMjidUXxglyVr/aCqsN1vvyiwzcIZ0?=
 =?us-ascii?Q?ioCkkwGKsjWIfZqyb2c3gXYx9dUSFw05mMT1JUPdsbdb+DCRyhvaI2pRp8zc?=
 =?us-ascii?Q?1Ol42+/1sC35+027eTJyJnKXv9lyePC5jiGuJKPsEUXkpxnXPEfUzJu7H6hr?=
 =?us-ascii?Q?miAHWFisCL5RRVlSs4/OCvL8TJ1PJ2z1iKsMu0QYtUdX9Z84aM9044Yfe2EF?=
 =?us-ascii?Q?gQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN8PR21MB1284.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aab484fd-f154-488f-c8b7-08d99bba3ae8
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2021 15:30:40.2183
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Glae5ABfnUeW2/3jh6M4Leu9OegmoIHAvCiYMgLqF7Ck9fy5z5aQYEQoBlVxUKyOAe1WAq3vQ4mPJt92S4rL2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR21MB1234
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Dexuan Cui <decui@microsoft.com>
> Sent: Friday, October 29, 2021 8:54 PM
> To: davem@davemloft.net; kuba@kernel.org; gustavoars@kernel.org; Haiyang
> Zhang <haiyangz@microsoft.com>; netdev@vger.kernel.org
> Cc: KY Srinivasan <kys@microsoft.com>; stephen@networkplumber.org;
> wei.liu@kernel.org; linux-kernel@vger.kernel.org; linux-
> hyperv@vger.kernel.org; Shachar Raindel <shacharr@microsoft.com>; Paul
> Rosswurm <paulros@microsoft.com>; olaf@aepfle.de; vkuznets
> <vkuznets@redhat.com>; Dexuan Cui <decui@microsoft.com>
> Subject: [PATCH net-next 1/4] net: mana: Fix the netdev_err()'s vPort
> argument in mana_init_port()
>=20
> Use the correct port index rather than 0.
>=20
> Signed-off-by: Dexuan Cui <decui@microsoft.com>
> ---
>  drivers/net/ethernet/microsoft/mana/mana_en.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c
> b/drivers/net/ethernet/microsoft/mana/mana_en.c
> index 1417d1e72b7b..4ff5a1fc506f 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
> @@ -1599,7 +1599,8 @@ static int mana_init_port(struct net_device *ndev)
>  	err =3D mana_query_vport_cfg(apc, port_idx, &max_txq, &max_rxq,
>  				   &num_indirect_entries);
>  	if (err) {
> -		netdev_err(ndev, "Failed to query info for vPort 0\n");
> +		netdev_err(ndev, "Failed to query info for vPort %d\n",
> +			   port_idx);

Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>

