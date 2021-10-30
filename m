Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D329F4409FD
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 17:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231986AbhJ3PiH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Oct 2021 11:38:07 -0400
Received: from mail-cusazon11021020.outbound.protection.outlook.com ([52.101.62.20]:41886
        "EHLO na01-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230086AbhJ3PiG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 Oct 2021 11:38:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FLn8eWxt86fWWyWUQNAMl49sKlxhxQu/DcJT6sspJ2IxpVto0pGufolY5lLy+hDhSbZgmtvtbTpewrkdfxaJMK7teNmGJQ/brD0T74R7eq/+7evlIcZXZGdlOBc9GUvL/+3jbP8V8TeRCiu1UUwu5HvQhH2J1Pr0sS4L9L1tzUsgtDtTe1b4GlKu/KejHGZ+/XYU6vjf0XmMJ7ukYEOcoq97jDzLldk2U53lnYPpvqcGIl/K69Tz8Jhp0A19CMKr0ubNDSlFq2Pk6hjhyWvR07Py44GuWXAUIVwZxSj4Mrzy0uhlDECWKoYbnoYNEJLtfiaP5tQT2gSVpXHcDEVFWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zMtYmqZZ5x3EsJ5P/sm2fbCbpBm0kcyTz+z2Ds2pGkE=;
 b=aKDiZRDeNekAVNtI4+GbvshUUxTUSP+NVaSEGYU2b/nYbCitkd9TGrp2C/5NzqHoVvqrKREDUYv7obIhnlrhv14lJxB37RsH2KYfppF7R9bsRK7nf/pQkSr6fOunI0ue9Pn82zAEqLapBUOm4qRMibjekFS1kZPvy4lAG2SxswAFok4wscmOemHwzj6Dfvs05FqSDd5t3DqNpKdhduZQqrBigTZHfTCi/Zs3qUP0UAztrhX/dYkT4HmsXTBJ6Foklirfy52avuCgWJemg0bSyOH8VbHVL74BVMCLDkdQxeGzVvU5Ymo7jEJx+gG99Bif/2guBRTjuaCEjZTCRp64kA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zMtYmqZZ5x3EsJ5P/sm2fbCbpBm0kcyTz+z2Ds2pGkE=;
 b=jwYDSANmvxg7h68/scCVTEamOBYtLP/jUY0mi4cCBU72cGtBwkBD2SGBSmLtBh94OiXkmz/MhiAG5hVnt+004FChq7ZFG0bXQ0H+8I6Pr/oqGaYy8SZlKeDyLCEJk3TUQhvu+DPYNbDiqkXduXbYnOuGrRIFB0mhIihylaEQ6Bc=
Received: from BN8PR21MB1284.namprd21.prod.outlook.com (2603:10b6:408:a2::22)
 by BN8PR21MB1204.namprd21.prod.outlook.com (2603:10b6:408:76::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.2; Sat, 30 Oct
 2021 15:35:32 +0000
Received: from BN8PR21MB1284.namprd21.prod.outlook.com
 ([fe80::5962:fbb9:f607:8018]) by BN8PR21MB1284.namprd21.prod.outlook.com
 ([fe80::5962:fbb9:f607:8018%7]) with mapi id 15.20.4669.004; Sat, 30 Oct 2021
 15:35:32 +0000
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
Subject: RE: [PATCH net-next 2/4] net: mana: Report OS info to the PF driver
Thread-Topic: [PATCH net-next 2/4] net: mana: Report OS info to the PF driver
Thread-Index: AQHXzSi7j12SBr54K0+FgVaU2HF9LKvrq/Ww
Date:   Sat, 30 Oct 2021 15:35:32 +0000
Message-ID: <BN8PR21MB128404C264B2E9081C97CF19CA889@BN8PR21MB1284.namprd21.prod.outlook.com>
References: <20211030005408.13932-1-decui@microsoft.com>
 <20211030005408.13932-3-decui@microsoft.com>
In-Reply-To: <20211030005408.13932-3-decui@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=92854149-9044-49ec-a825-aa3732946519;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-10-30T15:30:59Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8f3d5c41-d6c5-44f0-a306-08d99bbae90b
x-ms-traffictypediagnostic: BN8PR21MB1204:
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <BN8PR21MB1204B8225CFFA0F6C0892F04CA889@BN8PR21MB1204.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gYKU+VhWSdGhRsI89caw67ygWFYowKTsTLroQ1iiIFOPiDB4VVe2tAzr5SurRF4x0nZP4eSRpz0q2JjTfMJVkCH39X2xxQ0lTRf+F+SEVWfOykYVZAHhyq/q/0oVc6/zYpRVM18VL8Z2sXF3ENic+bVdSkGt6weACddnUCXwljwHUTp5ReYCldVE1UzCg3x8KK3Hn0ULp9sBJIKGExe1F68PX0hAo3p43rrDoHmU7hnIBhwOs7Wao7CVH894nI5sTvXkd2qI5oKMUeme4tqoSnmmGCyyEr+mVPC/GtVxbCLCnc8tqXZ4TygW2NSvM2Zxr/0NiVEoNVvnrFz39xbVc4X/TVSGTq4Q7N2Lq4w/ZPfBtTLDfz3bD1UwZcBIvwviqeZBBgGhevC6cYGH5CtoAqGjsWk//tUkICplzdQ3MAVz/I+tJ3ZkbwZMV0upU0rGl6fJQM3k9kn5L87R+Iu6DQA+b3lI2zYgzPFizG1nXxZriBJoRB2aluqJU9FFMr5GQ5GHx9vv6lkjOm9h3KoWa1HZ4bbQ+4xuIU0/sp2eVElheQHJddBRCfv1cCv6fTkarxn23ss0Ik/MPoF+2GGddqxPYbIGDhp3+NMS9HU2E6zaGHNBRejen7EKwb647Pcl/QZ1TLSm/plWmcYML2h7LZmvTFq+UJF3luZgPd6rITKQY+HG8UsMPgqWzjIFbUiHihwVTQawtP9MNOvX0bik6g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR21MB1284.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66556008)(8676002)(86362001)(64756008)(66946007)(52536014)(110136005)(9686003)(26005)(83380400001)(66476007)(186003)(55016002)(38070700005)(71200400001)(38100700002)(82950400001)(82960400001)(8936002)(66446008)(508600001)(76116006)(7696005)(8990500004)(5660300002)(33656002)(53546011)(6506007)(7416002)(316002)(2906002)(4326008)(122000001)(54906003)(10290500003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?aRDszrBO/Gkeg12XDObKRQuxKZPakEMnjXKp2BoPyQmnUWT/zDECdI78nGTK?=
 =?us-ascii?Q?40dLx0X8mu4Oi8SRLjDAA7XiEUtCXcdc64mDZPVEwbk2dAKxUqat6hKVfR5z?=
 =?us-ascii?Q?KyUXCQTMJJV6iE5qcpUU4FK9U1qCibE90P3vh1s7X8BzNEaaaOWjvd+HBtcP?=
 =?us-ascii?Q?zMh2uiTU+V/2qDO4vdi4uFrmzr0Ngaan1sRBwIWDOLo2+rO8Bat2akoyMOpw?=
 =?us-ascii?Q?Z8Dsy2qGKh1Ud4F2V6bLy33CSO+fvnwytDidwhk6ly6yjSKaW25ekhXr8iZm?=
 =?us-ascii?Q?G8rhYKGyt/4cuuOhoNhs4fJNWdJSXaaHyvSEpkDtgAnJhUBIwMPtqtWlqkMy?=
 =?us-ascii?Q?T/9GAkRp2uPR9zHU3JgseUoZgg41v40/H3Mpsjg0X++yby5Lw2y2z/Qs7BTL?=
 =?us-ascii?Q?40NTuCohYERibZqgsPLS97OmnOJiol8R6STmPZutVzd74aY/V01qsEZ1Lf+0?=
 =?us-ascii?Q?W1yJDukYsfvV4ZQ+2WmeUj6Gz2ZyBq/uF8Vw+Js7S8TllJbpSrUmjJtQFOO+?=
 =?us-ascii?Q?czbu/JjP6lEQ67cS+FSuDu3fO5bFhoJz9oZ+1nXB2npwN6nyduwJ6g/xJyAi?=
 =?us-ascii?Q?7of5fS2Cyda4/1t0LbnFqwRdOI1D0Efb5Xleo3r4qV99gyWI4DblRYQ23uA1?=
 =?us-ascii?Q?xlaUMW2Z8MRk6h2GD56GUmavqFwrpZ96qf9hZoK9H1yFgm3fRsHzJrfB/z1S?=
 =?us-ascii?Q?BtDFpdVwmNMahANkA1UOqnuAKtOPrV/LaH8bXL4Ew9D8RYLyZfXwEExqEUGc?=
 =?us-ascii?Q?0BGu8y0l2uppUJg1EidDWU3snAVEPa0SDyKblFLAaSGcvmLjKWyqNnsNdv3m?=
 =?us-ascii?Q?o3ITDMo5aLYfuYh697Ttrqft//uf332QXgVrPWRVFJQ3LN2Z+svfvJGcQTOt?=
 =?us-ascii?Q?3A53MEiBmv5IevP626ZhL4ZdmJOPxXGJs29RqowXuqxP2FysK1vFUqf6NBW9?=
 =?us-ascii?Q?0Agf8nuWsbkzghpgayob+R7DE0NhXD8UEBn1nImhSBiHIGwx4BRKI3W3tQDq?=
 =?us-ascii?Q?86b3dN9hgkaKfx6dHZSqjMv3zgUzCEJJMbOCrhq1RYtKlwDzF7TqOdxQHQyZ?=
 =?us-ascii?Q?qGzKzceyjm0wyb746JfuWzvRLvVUxwwebH+5igosNIdKGlHSuJtM0TxX1tqv?=
 =?us-ascii?Q?CHmE2Ys4QZrjJ/idLbacVUqV8glIKL31mu/iR9/Jt8MRvw23nBMrokyopIv7?=
 =?us-ascii?Q?YKQq25HT8pE8OvtKylO1n3THLYCQV9s56H9cMSOaB4jp2LkHnwdCs1HawVWY?=
 =?us-ascii?Q?HEOMNYF32aIYUZ+ZWC05IQ6LG0kww6HEY1h3Jb5RBR7KbCNeTzqqW7enzJag?=
 =?us-ascii?Q?ailjqSaSGswFv3Ap7S7LgG10XXNhzbEgFu8u7Rrr82lY0Pp+5hMrNC90mB1I?=
 =?us-ascii?Q?QYk54uojPDX9qen81mVQHwQXgwP7pKTxTa7I8SbTdD3cR8iYSCzr2P/HI818?=
 =?us-ascii?Q?FkUHfN+2f3wh+nCpK+Rni1mF60C3s2mDdSautOu+5ZONx1Dev54VHQeJJv1B?=
 =?us-ascii?Q?g9tSBJmbF2w7uhE57S+jD0GARzGQfkmBrRvLMitVjDe9sWDg5jsugFo+nk5p?=
 =?us-ascii?Q?uQCNTVH1JygPIS74dO3LBh5kXL/nF3JvsD+fcTnEj14it/JV/LL2jY6ej4dD?=
 =?us-ascii?Q?pA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN8PR21MB1284.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f3d5c41-d6c5-44f0-a306-08d99bbae90b
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2021 15:35:32.3953
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2xqNJddcl3pKem2vf8uDxCGLecvpfEr3ScIy35QOFDhPiwvIb2SuTeKyoaoi1RPg+J4gPTq+6fDQMKHAdBb6yw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR21MB1204
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
> Subject: [PATCH net-next 2/4] net: mana: Report OS info to the PF driver
>=20
> The PF driver might use the OS info for statistical purposes.
>=20
> Signed-off-by: Dexuan Cui <decui@microsoft.com>
> ---
>  drivers/net/ethernet/microsoft/mana/gdma_main.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>=20
> diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c
> b/drivers/net/ethernet/microsoft/mana/gdma_main.c
> index cee75b561f59..8a9ee2885f8c 100644
> --- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
> +++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
> @@ -3,6 +3,8 @@
>=20
>  #include <linux/module.h>
>  #include <linux/pci.h>
> +#include <linux/utsname.h>
> +#include <linux/version.h>
>=20
>  #include "mana.h"
>=20
> @@ -848,6 +850,15 @@ int mana_gd_verify_vf_version(struct pci_dev *pdev)
>  	req.gd_drv_cap_flags3 =3D GDMA_DRV_CAP_FLAGS3;
>  	req.gd_drv_cap_flags4 =3D GDMA_DRV_CAP_FLAGS4;
>=20
> +	req.drv_ver =3D 0;	/* Unused*/
> +	req.os_type =3D 0x10;	/* Linux */

Instead of a magic number, could you define it as a macro?

Other parts look fine.

Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>

> +	req.os_ver_major =3D LINUX_VERSION_MAJOR;
> +	req.os_ver_minor =3D LINUX_VERSION_PATCHLEVEL;
> +	req.os_ver_build =3D LINUX_VERSION_SUBLEVEL;
> +	strscpy(req.os_ver_str1, utsname()->sysname,
> sizeof(req.os_ver_str1));
> +	strscpy(req.os_ver_str2, utsname()->release,
> sizeof(req.os_ver_str2));
> +	strscpy(req.os_ver_str3, utsname()->version,
> sizeof(req.os_ver_str3));
> +
>  	err =3D mana_gd_send_request(gc, sizeof(req), &req, sizeof(resp),
> &resp);
>  	if (err || resp.hdr.status) {
>  		dev_err(gc->dev, "VfVerifyVersionOutput: %d, status=3D0x%x\n",
> --
> 2.17.1

