Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2FC239F98
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 08:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727922AbgHCGVR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 02:21:17 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:18830 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726279AbgHCGVQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 02:21:16 -0400
Received: from pps.filterd (m0167091.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0736G3JZ019404;
        Mon, 3 Aug 2020 02:21:02 -0400
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by mx0b-00128a01.pphosted.com with ESMTP id 32n6y9mrpp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Aug 2020 02:21:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WYCMJgXd+jO2a1qIP0hl8Tz9AqMMUN5DNLPLvtZPB6QCJr4oyoJ6dIkYkxmetBEzGglLDvKmMtfb1gihJjeJnV36/iV64n1D9pKTzv7NA8nNsI1FyQkx9ukUlKUf224SvLPNUUurD9b4cSROqIVI4+GSauxc2tRrE4C0YFU6d4C2zBJZmNyYjT3ht2UW7LLYyeyPaCJ0ACcfMQWMMhD/JZXJpZSRUPSf/jnTsIWqBwxPS0rRvvRkNNfYEIIAD/CFG9s7MXvTTFx8CrSKN7XKfDJuSZcbH5QLCPVN3pasYC5abCEc4OQ4+0ZoJFKFzuabNDFD1/Z6A253k0a04oTAtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JVSSZ/RsrjvvWi5ePii7JKkPY+lhVDFz1fSAI0cJKOI=;
 b=QP5ymzYvAidNJ02+cyxJm+abxcxFc04a5F/11FsjNKDmMWtU0AnaXLoDuXYAU4byjBsULz4ycBSEUw6RJ13j1BLviQuTJv7B7s0Z4R8/9tZbR15meyIVGr/fuqQM7YdO8f1xr81MBxfy5dRIK1yJkkMf2HiNS3/y1KUgaNEZVzDuOqP98sdEejzYLy5mMtW3/QdWgDNaqefVV06VJHoZwJUa3HbdfX8gBGTXsJRZ4EEQD+94fQI9JWlqlSYGvILc2TqbWa9tKHKHPFy9BB9/BsVtJPQC8w2tLqpcMrCzkzOyUPGD7WSNNcmaUZTVmcNxC9YFE+do+Ao2qLZBjxlHPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=analog.com; dmarc=pass action=none header.from=analog.com;
 dkim=pass header.d=analog.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JVSSZ/RsrjvvWi5ePii7JKkPY+lhVDFz1fSAI0cJKOI=;
 b=IXREQKa5/3KB3EXY3m44etaz53GGWrQ+8Urrw5FQP/iUSfL7LPmao6kyS35GMetAXPFs2+u9wedvD/U24efVKsZ/Y/gaHJbmsL3kpsfDZtr55CIaANZTf5R1/ZOSVquIbAFxBy5MATiuk/urSQnodxRa4sQr/8QgXV1PYp/aAtY=
Received: from BN6PR03MB2596.namprd03.prod.outlook.com (2603:10b6:404:56::13)
 by BN6PR03MB2530.namprd03.prod.outlook.com (2603:10b6:404:19::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16; Mon, 3 Aug
 2020 06:20:58 +0000
Received: from BN6PR03MB2596.namprd03.prod.outlook.com
 ([fe80::7ddb:b5e3:4dd0:dcc9]) by BN6PR03MB2596.namprd03.prod.outlook.com
 ([fe80::7ddb:b5e3:4dd0:dcc9%8]) with mapi id 15.20.3239.021; Mon, 3 Aug 2020
 06:20:58 +0000
From:   "Hennerich, Michael" <Michael.Hennerich@analog.com>
To:     "trix@redhat.com" <trix@redhat.com>,
        "alex.aring@gmail.com" <alex.aring@gmail.com>,
        "stefan@datenfreihafen.org" <stefan@datenfreihafen.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "marcel@holtmann.org" <marcel@holtmann.org>
CC:     "linux-wpan@vger.kernel.org" <linux-wpan@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] ieee802154/adf7242: check status of adf7242_read_reg
Thread-Topic: [PATCH] ieee802154/adf7242: check status of adf7242_read_reg
Thread-Index: AQHWaNiPlSyywotpzkO5mKQpKWz1qakl6r2g
Date:   Mon, 3 Aug 2020 06:20:58 +0000
Message-ID: <BN6PR03MB25967591266E409D1DA920D68E4D0@BN6PR03MB2596.namprd03.prod.outlook.com>
References: <20200802142339.21091-1-trix@redhat.com>
In-Reply-To: <20200802142339.21091-1-trix@redhat.com>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcbWhlbm5lcmlc?=
 =?us-ascii?Q?YXBwZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZiODRi?=
 =?us-ascii?Q?YTI5ZTM1Ylxtc2dzXG1zZy03ZDA2MDkxYS1kNTUxLTExZWEtOTA0MS00ODg5?=
 =?us-ascii?Q?ZTc3Y2RkZWNcYW1lLXRlc3RcN2QwNjA5MWMtZDU1MS0xMWVhLTkwNDEtNDg4?=
 =?us-ascii?Q?OWU3N2NkZGVjYm9keS50eHQiIHN6PSIxNzM0IiB0PSIxMzI0MDkwOTI1NjQ5?=
 =?us-ascii?Q?NzU4NzEiIGg9Im4zeld3RG9RQU9MUVFkTW5aR21VQWFsdFE2az0iIGlkPSIi?=
 =?us-ascii?Q?IGJsPSIwIiBibz0iMSIgY2k9ImNBQUFBRVJIVTFSU1JVRk5DZ1VBQUVvQ0FB?=
 =?us-ascii?Q?RC9BRjQvWG1uV0FRTC9xOTUvYzdRQkF2K3Izbjl6dEFFREFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFIQUFBQURhQVFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFFQUFRQUJBQUFBOHpRWGF3QUFBQUFBQUFBQUFBQUFBSjRBQUFCaEFHUUFh?=
 =?us-ascii?Q?UUJmQUhNQVpRQmpBSFVBY2dCbEFGOEFjQUJ5QUc4QWFnQmxBR01BZEFCekFG?=
 =?us-ascii?Q?OEFaZ0JoQUd3QWN3QmxBRjhBWmdCdkFITUFhUUIwQUdrQWRnQmxBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFBR0VBWkFCcEFGOEFjd0JsQUdNQWRR?=
 =?us-ascii?Q?QnlBR1VBWHdCd0FISUFid0JxQUdVQVl3QjBBSE1BWHdCMEFHa0FaUUJ5QURF?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFBQ0FB?=
 =?us-ascii?Q?QUFBQUNlQUFBQVlRQmtBR2tBWHdCekFHVUFZd0IxQUhJQVpRQmZBSEFBY2dC?=
 =?us-ascii?Q?dkFHb0FaUUJqQUhRQWN3QmZBSFFBYVFCbEFISUFNZ0FBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFCQUFBQUFBQUFBQUlBQUFBQUFBPT0iLz48L21l?=
 =?us-ascii?Q?dGE+?=
x-dg-rorf: true
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=analog.com;
x-originating-ip: [137.71.226.54]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 95b3cff6-95fa-4942-4925-08d8377562da
x-ms-traffictypediagnostic: BN6PR03MB2530:
x-microsoft-antispam-prvs: <BN6PR03MB253031469231F6D31294199E8E4D0@BN6PR03MB2530.namprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2733;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: G7K2lZuFLknTAKbKAGWRdZJqg3086KL9l5IdPm3U7vDEm6WnwPWgSIpClBeCAxOgBUmu+GvJiWCreYimAsr1GsCDDDz6xf7FrCmLFrIDusSGrT5nmb5enRlJw8+Lp0hdtxvsdMgtZLpAHbxmuRuyE+PB+oBkCwWpoqubH1yAY+sSrrxuvJWsmQqunJEEWZLTLgtBWc1GNm0XskJDYjgVwraqKjsAb0M2tzpPEP/pYVnL9YXd5XdobcY9g8ts/ELGu4n2Rx0iCJshOQolhviglvfi/T1lkdz9Q3vKA8fLUtrfcKGX456GY5mi2pXvoFH4Xg60K8KLv9DdF45keECA4w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR03MB2596.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(396003)(39860400002)(366004)(136003)(55016002)(9686003)(53546011)(478600001)(2906002)(26005)(186003)(6506007)(52536014)(71200400001)(83380400001)(110136005)(8676002)(66556008)(8936002)(66476007)(76116006)(4326008)(316002)(33656002)(66946007)(7696005)(5660300002)(66446008)(64756008)(86362001)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: lHaGkoxO+j239rS6GpJxQ/OqL737+zgec5M0lMlQGbc95sXumYcbmuZ+7fPk4T3LpYrT++D9kgJMm5nIXrQQbc5VsvHmrNECFmMP+ZOgUz743j7RmRHdIJc8pbqAxf/OAcVG9eIaEGMB/7xQQQwq3rFZwglPDm1BqlnlwVKOs/j8tOC7jItz0K8JEeyKuVJyf5awrikdBJ5WTy/eF2yMoeB8AXnnlFaNdXLg5+hjU+WlI8ThQqP3mLmeFx3Mm3AhVEsC3Z+6vWSDHF/zikE1z/AT2gMJbwpNJ5iUi3vvS9RzbRZGfWJZj3Ka3P6ofZoXbBQ7yfa/+mYUdcPVCxvGQZBhg+GhzHEp6gukVclKvNHeN2BsJbSPbzx6Qk13VyDCE0Ak5vpF8yEq9GCehSTqVrOOESIPZmYRl4D8M+wTda1A4sSPPyST0KJkPeZA5NGB5Ap5K2TmNnDDA3OzBuDFz630LrQcFuiM3qW7fGbzqUR0CvIMo5GFqVTx2BUHTEpyezdvh7WU6Qq8/EZ8W/XQ6LZcnHu8ummfRc4iZaXdFIXhH9AGz64kJMQuoX9NNkPETqa+h9Rj9NCRDJ92ILsjnIzfjgp8f76irYzB0HLaT+OhXVTCw9ndVbg+/h2Ap0uoI2Ipp2fdbOGWQ5umsbuygA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR03MB2596.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95b3cff6-95fa-4942-4925-08d8377562da
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Aug 2020 06:20:58.1109
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Me1cQ4xZOuZhnnR3WFeyS8sIQ0WZoh+eMWHJ3bRKqDrPYBO21QOraMRy5IsDx+wl5DAFx8Y7kWgsMdDmnxKJIwfl5Y0r1kD8PKyqAtI8+yQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR03MB2530
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-03_04:2020-07-31,2020-08-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 clxscore=1011 suspectscore=0 priorityscore=1501 lowpriorityscore=0
 adultscore=0 spamscore=0 impostorscore=0 mlxscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008030045
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: trix@redhat.com <trix@redhat.com>
> Sent: Sonntag, 2. August 2020 16:24
> To: Hennerich, Michael <Michael.Hennerich@analog.com>;
> alex.aring@gmail.com; stefan@datenfreihafen.org; davem@davemloft.net;
> kuba@kernel.org; marcel@holtmann.org
> Cc: linux-wpan@vger.kernel.org; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; Tom Rix <trix@redhat.com>
> Subject: [PATCH] ieee802154/adf7242: check status of adf7242_read_reg
>=20
>=20
> From: Tom Rix <trix@redhat.com>
>=20
> Clang static analysis reports this error
>=20
> adf7242.c:887:6: warning: Assigned value is garbage or undefined
>         len =3D len_u8;
>             ^ ~~~~~~
>=20
> len_u8 is set in
>        adf7242_read_reg(lp, 0, &len_u8);
>=20
> When this call fails, len_u8 is not set.
>=20
> So check the return code.
>=20
> Fixes: 7302b9d90117 ("ieee802154/adf7242: Driver for ADF7242 MAC
> IEEE802154")
>=20
> Signed-off-by: Tom Rix <trix@redhat.com>

Acked-by: Michael Hennerich <michael.hennerich@analog.com>

> ---
>  drivers/net/ieee802154/adf7242.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ieee802154/adf7242.c
> b/drivers/net/ieee802154/adf7242.c
> index c11f32f644db..7db9cbd0f5de 100644
> --- a/drivers/net/ieee802154/adf7242.c
> +++ b/drivers/net/ieee802154/adf7242.c
> @@ -882,7 +882,9 @@ static int adf7242_rx(struct adf7242_local *lp)
>  	int ret;
>  	u8 lqi, len_u8, *data;
>=20
> -	adf7242_read_reg(lp, 0, &len_u8);
> +	ret =3D adf7242_read_reg(lp, 0, &len_u8);
> +	if (ret)
> +		return ret;
>=20
>  	len =3D len_u8;
>=20
> --
> 2.18.1

