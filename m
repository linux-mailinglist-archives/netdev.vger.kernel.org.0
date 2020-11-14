Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 394662B2BC5
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 07:41:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726525AbgKNGip (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 01:38:45 -0500
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:44212 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726380AbgKNGip (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 01:38:45 -0500
Received: from pps.filterd (m0167088.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AE6Uf7K002705;
        Sat, 14 Nov 2020 01:38:36 -0500
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2174.outbound.protection.outlook.com [104.47.58.174])
        by mx0a-00128a01.pphosted.com with ESMTP id 34t9yb80qv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 14 Nov 2020 01:38:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EzVOmZHlWH+w+jlzu62r19MLUgNon9gcsonHZPDKoE2XPOIM+5gR4zcL5cCBXB9ehKk2O6Nnjgrmtsv4FRvj/Mv4xo0W0dAeTnCsEvZruy2RuWzhXVlTYZ136ogeKMkJIqhO76sh1LI6keiemtv1ku/bCLPZK/+0jc9CJEDJ1C02DmKS2LLBn0sBLwNZAz/T1QJzjVHFbRJ0zsmGw4CqHS3QgPZOhyOZvecB+Jp5SDXWOflCUSdX7w98/iAjnYT397oUc503Ur2oDZf55x8EontTQi7MTIylFkdM5mod4eerGU9pD4pkrpbEhnd+QtjpaA1GDuPGj8AcSLk8tt0ilg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h73Lhswbs7g7sYT2TFTQf6YCJXl5lKiz/XAFkz4TPGg=;
 b=U1eMTuSP0PYo748P4bRWvF/ynHMAqk36yIv4IC2Ej2Z3A/pQohY/R5K5dRtK/nAmp2w7EBVTNUcJiCvnKLVuWk84scAdFxCGpIIqDzjj3Cvai0xt2+n3bOQOzCOYmavMNKMY4U9oxRp82xXn0lqHs4dCzIDFvuDUcERsCgWEWx61GSh76LjGag4RQ4i09EeHIFp15bZpEgXwXifk7/5UNbBFjEfxM8e9akB1HqiRPwxk5WGeotVW9fTZMYdHMcKYo4/2FssGlyfQToNXHMSv3mssl5xdqygC0Y7M8L3hxXm5sWKmsN6dcqchRYCW2IcNJl72klGo5gtxPHHc4gVFKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=analog.com; dmarc=pass action=none header.from=analog.com;
 dkim=pass header.d=analog.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h73Lhswbs7g7sYT2TFTQf6YCJXl5lKiz/XAFkz4TPGg=;
 b=x16Aytw1YTTYSMefnD7GQkSOaclj3jlGCaQEkYhcbRZ21NFCCaYNp4JKurawcAKFiayJpfQ3jcQuA9NMmSxxcmtiBMgzlUuxAP4VdqePjE+ct0/mYD5mXvFmH+qb+wquNm4GFcYO3DK8Phj0sfeollmGhrROuOaIVblnGoYII1g=
Received: from DM6PR03MB4411.namprd03.prod.outlook.com (20.178.27.206) by
 DM5PR03MB2523.namprd03.prod.outlook.com (10.168.236.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.21; Sat, 14 Nov 2020 06:38:34 +0000
Received: from DM6PR03MB4411.namprd03.prod.outlook.com
 ([fe80::f8dc:93bc:313c:fc22]) by DM6PR03MB4411.namprd03.prod.outlook.com
 ([fe80::f8dc:93bc:313c:fc22%6]) with mapi id 15.20.3499.034; Sat, 14 Nov 2020
 06:38:34 +0000
From:   "Ardelean, Alexandru" <alexandru.Ardelean@analog.com>
To:     Ioana Ciornei <ciorneiioana@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: RE: [PATCH RESEND net-next 18/18] net: phy: adin: remove the use of
 the .ack_interrupt()
Thread-Topic: [PATCH RESEND net-next 18/18] net: phy: adin: remove the use of
 the .ack_interrupt()
Thread-Index: AQHWud19di6aQp9XSkuIxRZWvSjDaqnHLcFA
Date:   Sat, 14 Nov 2020 06:38:34 +0000
Message-ID: <DM6PR03MB4411FA9CAF9B17710C2AC054F9E50@DM6PR03MB4411.namprd03.prod.outlook.com>
References: <20201113165226.561153-1-ciorneiioana@gmail.com>
 <20201113165226.561153-19-ciorneiioana@gmail.com>
In-Reply-To: <20201113165226.561153-19-ciorneiioana@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcYWFyZGVsZWFc?=
 =?us-ascii?Q?YXBwZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZiODRi?=
 =?us-ascii?Q?YTI5ZTM1Ylxtc2dzXG1zZy0wNWM1Y2MwNi0yNjQ0LTExZWItYTVjMC00MTU2?=
 =?us-ascii?Q?NDUwMDAwMzBcYW1lLXRlc3RcMDVjNWNjMDgtMjY0NC0xMWViLWE1YzAtNDE1?=
 =?us-ascii?Q?NjQ1MDAwMDMwYm9keS50eHQiIHN6PSIzMzk5IiB0PSIxMzI0OTgwOTUxNzE3?=
 =?us-ascii?Q?NjgzOTUiIGg9InpWNlBWSUhIQVVNOWNsc0NxR0E5N2tjdER4UT0iIGlkPSIi?=
 =?us-ascii?Q?IGJsPSIwIiBibz0iMSIgY2k9ImNBQUFBRVJIVTFSU1JVRk5DZ1VBQUVvQ0FB?=
 =?us-ascii?Q?QkxFQ0hJVUxyV0FhdFlBZlQ0aW5hQ3ExZ0I5UGlLZG9JREFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFIQUFBQURhQVFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFFQUFRQUJBQUFBS1ZJV2JnQUFBQUFBQUFBQUFBQUFBSjRBQUFCaEFHUUFh?=
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
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=analog.com;
x-originating-ip: [188.27.128.26]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 426da51a-92f1-4c72-1108-08d88867e903
x-ms-traffictypediagnostic: DM5PR03MB2523:
x-microsoft-antispam-prvs: <DM5PR03MB2523B2CCD50E5DBF8B6ABEAFF9E50@DM5PR03MB2523.namprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3173;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8SbMsR98JCp47Wm/QlxtgvrkYoid668SeVBjec1qQqrd9RuBiHftBhkjITKifi7MQk01h9MJ4Mhcdfv78m91Dr8arrzfeP7hyMF1vUo/BuvsDWrDP21s+hAanGJdbhmaIX6EWrDC1xXHnqpixhGyU7j7Zv2iSEFB4F2HaX/jAwKMOQRDBofZgiVDbLXy7PI5fuYpPssjVlRv1PM26s5n7509kVVPGjlqmoeUOfnUVkbcktUS38VXGX9CRa993WFg9fRYZnbJRaDcDcvbJSuG1U44KjWb2IdPswbCy1awCDV3HqmsNB8B8byTP58KnbKXedeugPMDtTQwF2lu5SwlVMzTpO5Bt/yTJsjDFOC/KoIstdgsVZV9Qi4eUm3sGYc7
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR03MB4411.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(346002)(136003)(396003)(376002)(4326008)(55016002)(9686003)(33656002)(8676002)(66556008)(5660300002)(76116006)(66476007)(66446008)(66946007)(7696005)(52536014)(86362001)(64756008)(110136005)(8936002)(316002)(53546011)(26005)(186003)(83380400001)(2906002)(6506007)(71200400001)(478600001)(142923001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 1TlKzgNVXsKiFM41lwbi5FMQqeTeMvcxZvOoI73JrBPXqMt/bcNIWzzNjTpyZsJBa3PY7752lDyNojFMmHN1k+1t9acCSTXlGIFJnOdEc0RN2R/aJS/YSbc/Y+xzzqJNa47ObZwUesxaLrCqxzIVzZor78I7Y74X3YtcVfY29/cmsr3esuQWeJ5ueRAOxuTXmdvZh9aR4I6yue0XUCXnDDjFeZjpfz8zOkJPW8gNMDVvFQ38djSONWuyMOMo16Dv+ExP+ecMR1I3Qh8eCHl2WLJlDgktNJSs5ck2as3f5Ab0F58LoZmyvi6r5ol1MKhC2jc7ztn7AW/Gj9Fk9vNiJUFDNPKAwP1OYU1njNBlD3oDaF2K2yyO7QeHdVpqJ8KJemdGAvyxGZLNUXwji4AQQA3GhuoVokFt+dPBIKfJHbzv1bW2dLRipNaVgrI6LKbes9CVtZY6xRu2xOc7G6Z0e+vd0iRWzMOYMSWwUPGk1gHL59h5HqGlXGiNhU7aJ7+TQ8plxIBrsf6Ybz6f5LoiQ8S8ZXiFYhUCFDzzkTbJNISMXmoIcbffOyCFTzZZL+g2xKTZURQXm9pKjGEjsALog0dJ6ZNNOW3bxKwrmKBp22ogMjwQXLtLwxaMsQN2I2PVyYCKU5K28A/4ZZXtkwxrKg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR03MB4411.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 426da51a-92f1-4c72-1108-08d88867e903
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Nov 2020 06:38:34.3697
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SMEN962COI7BdFz5wcsf7OtRBn9DbuJDzDAwTE/yQBKFXaOdDJE1Cl7MqO7WlEyc6Cb0hSHyVK0ensQXH+yyw9ubOk2B9kz9R6b25Vv/eJY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR03MB2523
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-14_01:2020-11-13,2020-11-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 mlxscore=0
 priorityscore=1501 suspectscore=0 impostorscore=0 lowpriorityscore=0
 bulkscore=0 clxscore=1015 spamscore=0 adultscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011140040
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Ioana Ciornei <ciorneiioana@gmail.com>
> Sent: Friday, November 13, 2020 6:52 PM
> To: Andrew Lunn <andrew@lunn.ch>; Heiner Kallweit <hkallweit1@gmail.com>;
> Russell King <linux@armlinux.org.uk>; Florian Fainelli <f.fainelli@gmail.=
com>;
> Jakub Kicinski <kuba@kernel.org>; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Cc: Ioana Ciornei <ioana.ciornei@nxp.com>; Ardelean, Alexandru
> <alexandru.Ardelean@analog.com>
> Subject: [PATCH RESEND net-next 18/18] net: phy: adin: remove the use of =
the
> .ack_interrupt()
>=20
> [External]
>=20
> From: Ioana Ciornei <ioana.ciornei@nxp.com>
>=20
> In preparation of removing the .ack_interrupt() callback, we must replace=
 its
> occurrences (aka phy_clear_interrupt), from the 2 places where it is call=
ed from
> (phy_enable_interrupts and phy_disable_interrupts), with equivalent
> functionality.
>=20
> This means that clearing interrupts now becomes something that the PHY dr=
iver
> is responsible of doing, before enabling interrupts and after clearing th=
em. Make
> this driver follow the new contract.
>=20

Acked-by: Alexandru Ardelean <alexandru.ardelean@analog.com>

> Cc: Alexandru Ardelean <alexandru.ardelean@analog.com>
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> ---
>  drivers/net/phy/adin.c | 25 ++++++++++++++++++-------
>  1 file changed, 18 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c index
> ba24434b867d..55a0b91816e2 100644
> --- a/drivers/net/phy/adin.c
> +++ b/drivers/net/phy/adin.c
> @@ -471,12 +471,25 @@ static int adin_phy_ack_intr(struct phy_device
> *phydev)
>=20
>  static int adin_phy_config_intr(struct phy_device *phydev)  {
> -	if (phydev->interrupts =3D=3D PHY_INTERRUPT_ENABLED)
> -		return phy_set_bits(phydev, ADIN1300_INT_MASK_REG,
> -				    ADIN1300_INT_MASK_EN);
> +	int err;
> +
> +	if (phydev->interrupts =3D=3D PHY_INTERRUPT_ENABLED) {
> +		err =3D adin_phy_ack_intr(phydev);
> +		if (err)
> +			return err;
> +
> +		err =3D phy_set_bits(phydev, ADIN1300_INT_MASK_REG,
> +				   ADIN1300_INT_MASK_EN);
> +	} else {
> +		err =3D phy_clear_bits(phydev, ADIN1300_INT_MASK_REG,
> +				     ADIN1300_INT_MASK_EN);
> +		if (err)
> +			return err;
> +
> +		err =3D adin_phy_ack_intr(phydev);
> +	}
>=20
> -	return phy_clear_bits(phydev, ADIN1300_INT_MASK_REG,
> -			      ADIN1300_INT_MASK_EN);
> +	return err;
>  }
>=20
>  static irqreturn_t adin_phy_handle_interrupt(struct phy_device *phydev) =
@@ -
> 895,7 +908,6 @@ static struct phy_driver adin_driver[] =3D {
>  		.read_status	=3D adin_read_status,
>  		.get_tunable	=3D adin_get_tunable,
>  		.set_tunable	=3D adin_set_tunable,
> -		.ack_interrupt	=3D adin_phy_ack_intr,
>  		.config_intr	=3D adin_phy_config_intr,
>  		.handle_interrupt =3D adin_phy_handle_interrupt,
>  		.get_sset_count	=3D adin_get_sset_count,
> @@ -919,7 +931,6 @@ static struct phy_driver adin_driver[] =3D {
>  		.read_status	=3D adin_read_status,
>  		.get_tunable	=3D adin_get_tunable,
>  		.set_tunable	=3D adin_set_tunable,
> -		.ack_interrupt	=3D adin_phy_ack_intr,
>  		.config_intr	=3D adin_phy_config_intr,
>  		.handle_interrupt =3D adin_phy_handle_interrupt,
>  		.get_sset_count	=3D adin_get_sset_count,
> --
> 2.28.0

