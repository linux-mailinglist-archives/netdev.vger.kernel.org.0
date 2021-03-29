Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B40E34D4F2
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 18:25:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231453AbhC2QYg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 12:24:36 -0400
Received: from mail-eopbgr80041.outbound.protection.outlook.com ([40.107.8.41]:4536
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231384AbhC2QYY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 12:24:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vft9IGAIpkOWGLN94e3FUqjr5h/2diDiciz4TFx3inef54cUaUm0bFHIx+ulWjaQDlzMv8WoeXRIqOtVtnAkiV6H1JEpIAc9ncCjrrZ1ps3AwxCFijKu+2YweHAzNNen++QMxeVAuAGLfjuZA4+vcSVncOESrE3qFJpH/nQI/j3Qjxk7e+UWrN8NTHCQ0HTlfELEv+X4wFYPsrcTgZJy7yE+Mx6zqMYcFl2PKIi69Dv8/bIdEm6e7c7CRBioMW1RQCIS1e5c2Kvsvwmb7N7c6g6/Qr64Vpz4uNZicJwaiyda0rS+FwZidrMxoFEcCe1c4C30bsiuPssV5m+XOYxqCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JkMr2/4M2jT0VxpNbBoKxAqwEC7nAxLTcWmQl5mMs6A=;
 b=hnxObEhwGUzM8WUrw/J7Ng3YPEuZgOBnqoL2UEXTzdJUSwCl7xX8AGNC8sJp3G/NI2qOl5xAko0FRaT3CBj4unCkb5r7sM7YylQ75jfEDELlp0dnnrE+SsU6ga+Mm3knjRKQPHc/FIbmZbb4JvK0drg5IAFxX8jaUWn1dedn0rhvIsn+HOErAWw/XBtDh+6N6Tqmb/aDK/ovUoETFiHfMWDvrKyD1UbH0dMjHaZc2dV7LSzAG2jfCOB25mbSmvILbTYnS4WB5EZqHAu5rSFOZWDO5R2nK9ei72lrxjNuAm5hfT5dtRuQ9wD9bviK5TnL5bwCPDInNoeaUNGZYicUwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JkMr2/4M2jT0VxpNbBoKxAqwEC7nAxLTcWmQl5mMs6A=;
 b=TBjLHsCqr0iNWXXbtrGulkP18oWM6f6fFwiXvcyEXqRw3I4iZ2WCjsQjfC7PGECsX01cizwXEaapBLT1TThw0ES6TP9W6dg6wrPxvKuNcc2kw4BkHLd+uPjrFVJOLUqkA3RYXEzeiHGXEfDzvrYUi4SNDMUsVXzTxkAzH3j0UVU=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6942.eurprd04.prod.outlook.com (2603:10a6:803:136::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.33; Mon, 29 Mar
 2021 16:24:22 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::f0c0:cb99:d153:e39b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::f0c0:cb99:d153:e39b%7]) with mapi id 15.20.3977.033; Mon, 29 Mar 2021
 16:24:22 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net v2] enetc: Avoid implicit sign extension
Thread-Topic: [PATCH net v2] enetc: Avoid implicit sign extension
Thread-Index: AQHXJKXlZqB1plpeA0OcVM38+bWT0qqbJqaA
Date:   Mon, 29 Mar 2021 16:24:22 +0000
Message-ID: <20210329162421.k5ltz2tkufsueyds@skbuf>
References: <20210329141443.23245-1-claudiu.manoil@nxp.com>
In-Reply-To: <20210329141443.23245-1-claudiu.manoil@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [5.12.16.165]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8c2e520f-f3d9-4524-194f-08d8f2cf1ca9
x-ms-traffictypediagnostic: VI1PR04MB6942:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB69423BCCF41BDEDDA74B31A7E07E9@VI1PR04MB6942.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tzh6d5ln+G2XpLxsEEBIcvaEJUTtR4b6sGmKTvSChGFhFKWxQnpLTTTLm1gj1VdnMLbxSBmNpUj0MeqrOMts1LGva5hhCK6Wo4T96+F45n9Al8mo7rZiiDuwqJ1rPN2vkGsz/ipHllS262YaJdIM8rwewilR4e/HLAoxf960EyccAKWRjsk53RwUYczU0BNum1oYVmhLG+F0kA7X5EkpXSfkau84xPqCRAc8xaZHUp/MoCIJVH6PIvzkHAt/zhxH9qG/ckt32FqMPHTjM7BSndMDQDACB9IJK7KLZLw2tZPJRsyeWyhrXNPWhmsZnIZK2IwHxWIdljuXMYPdBi3R3p/aYXq1SWyLOCLK8E1FcfSTE18tdG3QavxHiwwJHMR7CAxaPZF/Ert9LwzUHh8gCgCvSml0AZhpuKGFhK/EU2QwuIWFcpKHcAWlbCvIreYXY1nJGVPxY6xgf4sjrJVs/q51dpoSlO0bbJBthB27eEB+peqO3MmgUFgRRz2fBofzpDShSplQRIFQF/ooMjoBmjWPHDIzwaa3UxRNKQAY2A9h763CQYCXDda5AYSUMgiqs2bOihndLuT1I4KxWMow3oqr8vDqsrGs4de9knmFVlJqNh5sSlRcAs5m4I9gsb0nguiVUlHglEuvh739nDET8GbQnzFllHlYWsTTL8Z3pxc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(39860400002)(366004)(136003)(376002)(396003)(346002)(66946007)(66476007)(66556008)(1076003)(6486002)(66446008)(83380400001)(64756008)(316002)(6862004)(38100700001)(44832011)(54906003)(6512007)(8676002)(9686003)(76116006)(86362001)(33716001)(8936002)(71200400001)(4326008)(6636002)(91956017)(26005)(2906002)(186003)(478600001)(6506007)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?XfX6qJ8XQPntNA+pi1g5XgcVshJtti6AUDKCf0vX2Kvzpj2PqBUjDHjmklmc?=
 =?us-ascii?Q?ex7zTIusO/pDKLcCgQWnoZuP/DwSYJAhGH+XWb2lrdOttG1AFqQ1iE4gsos1?=
 =?us-ascii?Q?5FLgjeOMvO/OhsuJkAenYg9pEa1GU2Wwfea0kWrlu+bOTlKUFVBzQpXzGCbo?=
 =?us-ascii?Q?S698R1Axgbswzflpr1aRrbrTicC4g1a0JCGZHt1MBr0XRbTU3p9Psket7CPM?=
 =?us-ascii?Q?abpAYBA5o5pzekGjubxlQgDiSwx9OWhylrqZq59N6qYhf7OB4enLBG7aEbp+?=
 =?us-ascii?Q?oVePMa5p4r4zf0Q81eH4kgEWUCwXkuvt0yMUmppoZcIbuxDhTLvwIVZtI5Ie?=
 =?us-ascii?Q?NT3g4uTaBO//KAsXYiJuyrVBcjmwIFeS1xUvapkZMWnOy24YOtaRehC7aOwI?=
 =?us-ascii?Q?26j4mrReaIKbpkQASPJdHn0LgBU9sZNJcYRITF3hW35d0tMV4fBalZyjM20U?=
 =?us-ascii?Q?U3hi/Vf/dWiyNR4rqI/MHifEDmd4vAPrl9xr7ihvTioAlh6Z0+DAcVJaiGc9?=
 =?us-ascii?Q?VI/8S0AHOlPVQTw18nBtS4Cfvo03m+XqSwuTQpgvxuUoKXb8Q82SNBo+dfgJ?=
 =?us-ascii?Q?j2l2MYuv6d0YwR7Mrq9KQEJQ5K1o4RzNbVBclCWASK9U+7eAb3Lb5l6dMqsu?=
 =?us-ascii?Q?WdVLai0/y8qjNy2N3RYmJEvaOLN545q6Du/pPuP1cAIjW/20HjmkU+PAV4lK?=
 =?us-ascii?Q?SU02o9mgbM1tKeD349RigSxYWiGDhB4QNgHNnx+SodWQ32n0cRQl7VlEr+6z?=
 =?us-ascii?Q?RHfs/20wJYebVJ5UzLTJrBcpo5Ggo2CE7Qsl06QgpkFb+hvUIK5VW5HKXLW4?=
 =?us-ascii?Q?dBdjME5aumN6+voot+XSdSCx8k+ceeZ+k/0BGxOdKXXmK79SvoNcBOrcMTwc?=
 =?us-ascii?Q?bndfG4etbbmLsvzb/NBEDRkmY7nyrU0W3Muec+auwq32QQsp+dFtnvaFDkdx?=
 =?us-ascii?Q?uBA6X4osi0/iJKEysqKeyoPljMSCe5haElMy9Bcr7D0mD7FxR2ZTsgItZMaL?=
 =?us-ascii?Q?onuQokJFae0hXD0tz9lS9E7KQ3cDYN2fFPuAjYPyqOoyVOQVNHRoy5qJDjZr?=
 =?us-ascii?Q?ZsICGWz+Ail+2g/GJuyvfyoMT7jpXFjRy/iTBjZkPDoATwcmTTSjHWKlrvQn?=
 =?us-ascii?Q?Ptz0Y/Uexo//iFEDAJKtPGsuhA4VbAYdj9jAdEPN75r/y+r2DGGlP66bf4vW?=
 =?us-ascii?Q?kG/nwAOLGalIlCK1y7hgXBS6JCUmH9NUl8uVIgkQunmD7Yr+Q+61MQmIT+xQ?=
 =?us-ascii?Q?T0OAObiooo/VxI2QcwizrFYLoRKg5kgUgMAI+M7awkJ8gp99Ber8EAJ0KO/k?=
 =?us-ascii?Q?QhZV1rVO99U+pDq+qFfJz+I8?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F911B4F29FE0F14DBBB6E052B3FB8E8E@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c2e520f-f3d9-4524-194f-08d8f2cf1ca9
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Mar 2021 16:24:22.4941
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sbbQ0HPIOySOJ4nKuhM+rEgJ6H1/15BsJar6bfPLKm9nWuPTQjwLbKBBfVyv7DiOCVE/XOnD5ea6RjEOHZXfGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6942
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 29, 2021 at 05:14:43PM +0300, Claudiu Manoil wrote:
> Static analysis tool reports:
> "Suspicious implicit sign extension - 'flags' with type u8 (8 bit,
> unsigned) is promoted in 'flags' << 24 to type int (32 bits, signed),
> then sign-extended to type unsigned long long (64 bits, unsigned).
> If flags << 24 is greater than 0x7FFFFFFF, the upper bits of the result

This is a backwards way of saying 'if flags & BIT(7) is set', no? But
BIT(7) is ENETC_TXBD_FLAGS_F (the 'final BD' bit), and I've been testing
SO_TXTIME with single BD frames, and haven't seen this problem.

> will all be 1."
>=20
> Use lower_32_bits() to avoid this scenario.
>=20
> Fixes: 82728b91f124 ("enetc: Remove Tx checksumming offload code")
>=20
> Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
> ---
> v2 - added 'fixes' tag
>=20
>  drivers/net/ethernet/freescale/enetc/enetc_hw.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/freescale/enetc/enetc_hw.h b/drivers/ne=
t/ethernet/freescale/enetc/enetc_hw.h
> index 00938f7960a4..07e03df8af94 100644
> --- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
> +++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
> @@ -535,8 +535,8 @@ static inline __le32 enetc_txbd_set_tx_start(u64 tx_s=
tart, u8 flags)
>  {
>  	u32 temp;
> =20
> -	temp =3D (tx_start >> 5 & ENETC_TXBD_TXSTART_MASK) |
> -	       (flags << ENETC_TXBD_FLAGS_OFFSET);
> +	temp =3D lower_32_bits(tx_start >> 5 & ENETC_TXBD_TXSTART_MASK) |
> +	       (u32)(flags << ENETC_TXBD_FLAGS_OFFSET);

I don't actually understand why lower_32_bits called on the TX time
helps, considering that the value is masked already. The static analysis
tool says that the right hand side of the "|" operator is what is
sign-extended:

	       (flags << ENETC_TXBD_FLAGS_OFFSET);

Isn't it sufficient that you replace "u8 flags" in the function
prototype with "u32 flags"?

> =20
>  	return cpu_to_le32(temp);
>  }
> --=20
> 2.25.1
> =
