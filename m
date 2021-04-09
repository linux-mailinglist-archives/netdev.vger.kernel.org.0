Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FE4E359F65
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 14:56:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233700AbhDIM4N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 08:56:13 -0400
Received: from mail-vi1eur05on2067.outbound.protection.outlook.com ([40.107.21.67]:25664
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233529AbhDIM4L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 08:56:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jy+b17DhyeoUeqZsuQO9Hza/GugaEfYVHK4CsfC20Hitpdrk8FPapl8NR+S9Gx5kM0PGiDlbTv8wdflC99mCp17YG4qjIKucm7HR1apO6P5B4ULG/roRVOKD20IHWtjREFc4eCmmM00kWqnEQdXp6KDXUidgvKNQPef4nnVeHpldtogGPofbs2U9BQ0ALSAuwRK+vdqXdvpMITyrYGav7ORNvC5AKtDIcyPGNJZmBd4XeKwZA2XHovvj1K/NErK2ik8yAeYXgfqGcBjLYpX6s3eKNIYhhgswEAbWt5xEcFo53pHtIPXmLu3GzplZp1x8O9qWH+rHPlFcw/qRz9IbJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8AjZAQvmJWndFgx9gh2V/ujtolqd2dBV1W0Bmt2K8aM=;
 b=NTgs8sonIAvXRCe4dHK2A4h2q7ZkgA15SmyCaNP4kFJW7pVIi+S4Z0ujXm/S15R61o8/R3hBVq7KgBTfOAmBp4nVr1vfKnQolw0ASDJRqL+yUZcW11QXcmJ9I/p4CWKhKwBNGg/gEtdbMGe+m/KjKDqocJB4CY4xUcES3wai5n1jVMwKLPv1m4mpIrCMCKwCqBd3gbMcj9iQZ0XkHukb9lX7+ihB6+n1lVm/1ZvimAPDk8zgxXS/BcsuJAPvvhZOkNL03qxnr8z+26if3tcvWvCPxHSZ0nP1PZLjhAu7wIFziU2K3lLAT6xe0ucq32dwp3LjCxLxXYjejH5EnO2Yig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8AjZAQvmJWndFgx9gh2V/ujtolqd2dBV1W0Bmt2K8aM=;
 b=TUlvFA6D2T5mi7B6e1dZuar4BeQsgR/zTraGgWN5F8iqHmmRS4DOZFdAqaOLHpBAVlbdH+ioLNGdig0AUNAcQCxbKYhfGdyat3EUkG2zVKkTABi+CXuWkBXNJCYWBqycuJU1S2AUlVLUX/obpgnuBG8eEsIUjG26TYIsVYcZH1A=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2512.eurprd04.prod.outlook.com (2603:10a6:800:4e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.29; Fri, 9 Apr
 2021 12:55:56 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::f0c0:cb99:d153:e39b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::f0c0:cb99:d153:e39b%7]) with mapi id 15.20.3999.035; Fri, 9 Apr 2021
 12:55:56 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
CC:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH net-next] net: enetc: fix array underflow in error
 handling code
Thread-Topic: [PATCH net-next] net: enetc: fix array underflow in error
 handling code
Thread-Index: AQHXLTtXmPeOqt98/E+iT6tZsxw7w6qsJOMA
Date:   Fri, 9 Apr 2021 12:55:55 +0000
Message-ID: <20210409125554.vevm473y4oq2rjjq@skbuf>
References: <YHBHfCY/yv3EnM9z@mwanda>
In-Reply-To: <YHBHfCY/yv3EnM9z@mwanda>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [5.12.16.165]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b977c6c0-21a0-4f8d-5896-08d8fb56d11b
x-ms-traffictypediagnostic: VI1PR0401MB2512:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0401MB25128129AA2A0DE8CF891091E0739@VI1PR0401MB2512.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hZ7NssJduSCIDtlx+bPR7H/rXP/0IVMgDZ8H6zGXzXTGtaVInTs3pDmec2a7wx5ocKnWTIUyBvsCl0tjRNwfMZbPvAy4etpmyuyaIH5bS2kgobrqWKILPZ9O8+bCqF65E1CtWa5Bloa5ticjnab/kJwnLCNXtwB0+qlEudzzHXBFxSqvrOogMJxXF0ZymcH1uB7ZVegsICw9PVtb9OshK7dEUJ38TJw0IdLyugyR9ei89gDosKiEcrEsh3dezt7tOBdr8Xq5LmUlBUjz57LDLZwCi6AH8TmVmgz4DKssNE6fsnwZ7KkxatPshEoMYsYh58RJnHGRt9+KPBnVGXFcQBJxT0M6OAV8t7w6L18FiRrGHpNbbly2Kv5jeT8+yyjKY47oZLgwxQZhPX9xDxAa0XAPWQ+3A+TzOo68mH5k9HVoRvtf1tjMY3GvaImHSLToAWVznNQulWWcmyKHKi42u/m0/NzGOPLYx2Z5L/ao6ikZ+0Rj3qeJe+4SrSmhuv4EqhAobmIp+SY2wqLya+a1sQizky+8e9WFYzbfj+a6EdAJMynS18NP2UTDS1y/FJHoS68Zt1ZQuMffZe1GsQmPwqqZdg33vmPFRy2CB84DWwPxKfOznCVl4VQ6imm0DwWQ9oz8Ci/wwdsv1e94jwAH/iMcJwPuv0vh+RnmoQfmCUs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(39860400002)(136003)(366004)(396003)(376002)(346002)(6506007)(86362001)(91956017)(6486002)(9686003)(76116006)(1076003)(478600001)(66446008)(66556008)(66946007)(64756008)(66476007)(54906003)(83380400001)(186003)(8936002)(4326008)(26005)(316002)(33716001)(38100700001)(44832011)(6512007)(71200400001)(8676002)(2906002)(5660300002)(6916009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?AZMug0nuAmSc/s/BQLdC5ferxzZqxklTx9dcppR5xmy1NyNc6U/DeW0C0BCs?=
 =?us-ascii?Q?zELhNrjLh7sKRCRNEWJW6JfjA7m+xM7iDgXJ8cR6qSvpu7DoZbpuVUO6+WwZ?=
 =?us-ascii?Q?MYlEn9fVZhBOJ7olKwM/va2C2VxoJfVHbZzkdi8we8uettSkwDKYswYih0Wh?=
 =?us-ascii?Q?5+uzl0rrW1WyTfx+CfERyLNEV9jU0qu6lMzFNq7qKbGVjRM28dSGHEi7Dboc?=
 =?us-ascii?Q?AeMMlHkk240ga/zny1cenVmnT/c0k54yaO+tXP3nWidTAEgQjN920E8yp9yX?=
 =?us-ascii?Q?jusk9N3qNrMiQoHfqLDp3ikn5IsBcv9CFMrQYdTtt/APgayS7xdr+wPxyCp6?=
 =?us-ascii?Q?lURuv5W6YMgSXI3boHeE2uBY3hrPOhXML5GawUqt5kGcH1mCiOzntuftNspL?=
 =?us-ascii?Q?26Vc9+E99M2RAR0k+mq4X63/e/tCvzlCMkfhr2eO47tvc9qb/7NZ/xxUcWxc?=
 =?us-ascii?Q?DpvRXbrC7/lXJB8Ji4cbhY909hzjy5Qd47pbX9Ll7zX4/ZlkhDqTM2dzNcTi?=
 =?us-ascii?Q?/W6NcTXNc3NUHTNd8RYeNWr9KvIboZoPgNg/ZJNI1qLz8OCXzK7VjoZiugB3?=
 =?us-ascii?Q?cO8lpRQAHL5VFhoH4J9aldheAmvlGtdG4XwDpLDCgfJarPG7cxvYd9QvKD1L?=
 =?us-ascii?Q?b+tiFNI8NjSdC9WmAGo9CrfNS0W9yLRkLhFpnvK5H0z9QIMQ1Nl9BLParqxT?=
 =?us-ascii?Q?uVkzn6/C7EBv+E0oSe0esmo0niYwRy3EMpJsrU39ZSPptSz295HbhtQh0h1Y?=
 =?us-ascii?Q?OOeAfTau2tvvjIuleHaWbLp/6oAt9T+3ktCcutqAOc4VKlcG+czaSTG18jL3?=
 =?us-ascii?Q?tSFAlldqCiPNdoh6Bb/k5COTRYY0DUShRNcOkdqBZO3gdRGphKjS9sd+6oV0?=
 =?us-ascii?Q?NgisBbIBBdu3wga7B4f3KUETFmbAEGzUZJxS6vhTxCTjGp/DtOHQgJjHTwFl?=
 =?us-ascii?Q?Ga4/oToRITJn6LVn7G18zBclDJ2U9brskA/Q5oXf/yr73B0U2ms8Dj8Q/G9+?=
 =?us-ascii?Q?a8AfhKImE859cv8EZGfHNmLM1LjEmFFJlBDRSHlt13xGK/JtsDhnQIkSz37Z?=
 =?us-ascii?Q?CSHWea6uFl3SZO/5mF/6oAfntvwjPsKeZxWZtXy7fNJukLPOMuupzfxo/dnK?=
 =?us-ascii?Q?jfepg5FPDpd77QRT+qp9098/uwCV9XcE9vNwyg/+EMNcDnlTkoJfhycVdNSk?=
 =?us-ascii?Q?WhgnZZ1Dhp1Uq2Ss6haMVYkR0hlGJCnWtk8a5/Av7sK/B02QH423BFSYLuiw?=
 =?us-ascii?Q?Cw7oVIpVo/UgzMlcPmoMAvGTtIFLtqsC+BHZvBWUB+6IyzSAdRFSGbFOzXgm?=
 =?us-ascii?Q?hCmKNrgQ/yZz3iSbGt/qQVa7?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3B4386B500C535468CA8A92EC6603789@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b977c6c0-21a0-4f8d-5896-08d8fb56d11b
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2021 12:55:56.2257
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9cgSal0X+GKmHAc7ATmljg7ykDHHk8dRi867i/yMj+02liWrV+zsfwD0/Le2/5HfBJ7VjM4pzaW7vkVk8HFAvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2512
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 09, 2021 at 03:24:28PM +0300, Dan Carpenter wrote:
> This loop will try to unmap enetc_unmap_tx_buff[-1] and crash.
>=20
> Fixes: 9d2b68cc108d ("net: enetc: add support for XDP_REDIRECT")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/net/ethernet/freescale/enetc/enetc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/e=
thernet/freescale/enetc/enetc.c
> index 57049ae97201..d86395775ed0 100644
> --- a/drivers/net/ethernet/freescale/enetc/enetc.c
> +++ b/drivers/net/ethernet/freescale/enetc/enetc.c
> @@ -895,7 +895,7 @@ static int enetc_xdp_frame_to_xdp_tx_swbd(struct enet=
c_bdr *tx_ring,
>  		dma =3D dma_map_single(tx_ring->dev, data, len, DMA_TO_DEVICE);
>  		if (unlikely(dma_mapping_error(tx_ring->dev, dma))) {
>  			/* Undo the DMA mapping for all fragments */
> -			while (n-- >=3D 0)
> +			while (--n >=3D 0)
>  				enetc_unmap_tx_buff(tx_ring, &xdp_tx_arr[n]);
> =20
>  			netdev_err(tx_ring->ndev, "DMA map error\n");
> --=20
> 2.30.2
>=20

I have no idea what went wrong. I distinctly remember "testing" this by
writing up a small program:

#include <stdio.h>

int main(void)
{
	int n =3D 5;

	while (n-- >=3D 0)
		printf("%d\n", n);

	return 0;
}

I find myself doing that most of the time when there is a need for an
unrolling loop. I do see that this goes down to -1, I wonder how I
missed it.

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>=
