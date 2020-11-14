Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 526622B2BC3
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 07:41:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbgKNGih (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 01:38:37 -0500
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:39066 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726380AbgKNGig (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 01:38:36 -0500
Received: from pps.filterd (m0167088.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AE6UWdI001925;
        Sat, 14 Nov 2020 01:38:15 -0500
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2173.outbound.protection.outlook.com [104.47.58.173])
        by mx0a-00128a01.pphosted.com with ESMTP id 34t9yb80pq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 14 Nov 2020 01:38:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nFyGbXtqZVW7g9fOLnfvwKjUsQgsE6I53xelR6Hiij/JtZuhJ+1QsK7O2S4nB7AssDuNhh2zvl5/JZByJW+M+yj21heUpdwibDR3bfIwqmYngqD+8pmXSIdPKT3VHXlCY74EHi1p+OjT9Sn2MMthfD2gpQdP+zI1HPx45d75oUuTFzn3R3aPU6db3eWadnS8xfKN3UdGmk8GjV4tVkgyX9t5KJqLWtINki0e8nJM0ujnDnpulDWcT53uasYs84ynR1SiR459DboARrE27CmMXcER1GybyZKIY5ye5pAhr2bH832ivprAuqgnFZYVBPrwkVYcgt4S5woqEY47m3YGJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dsfpZekjhEQhTxiMIiPw5NekMthAIGkPbpRcyawLO0k=;
 b=jK34puNzMyqQH6zT6DFTzY5vxBcKTVjQ6y9v4HtrOcg2GZYvKt1asGIZhAL9ddcGpfoUDvQgz9wx29aD/nwN5vnmFHKY2fQ66r3uPsISxz3t+SGe1D3wZhaDUCJZwI8C5b9w5Q00xrvCzKoBPTgQc8bCs2vV6DHivr1wSGjsMG882uDCj9tJWhPv5RKUduGu4KoBC2EmpYMXTmFx96LkKTjz4VreS3HAzvPoHcgenkWm4TvWJa20AkDKV5BWA2GqY2sQXvNndXn7yLT00rBO4YP+joxYU1pZ0MHc0J5jmTnbfc9st2SAaYCcvsV/P/3ETVPVo5NtZYXytjjS0B+eEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=analog.com; dmarc=pass action=none header.from=analog.com;
 dkim=pass header.d=analog.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dsfpZekjhEQhTxiMIiPw5NekMthAIGkPbpRcyawLO0k=;
 b=2ZeeSk3AqG8vTfqCLJxsb4K4UEgtWda7f1EQXM9tMEi+qrtxq1RdjnZusBsbkl005wS0SBJ6ul/UorqPK4IVIOTYfW2plFWlhwSKrf9kEUKBa+s+sJAO9n0cPpFGCW+c6WVZmjKH5DOmccAdj78jT+bLm5U8lWDrPlSVvymYvOg=
Received: from DM6PR03MB4411.namprd03.prod.outlook.com (20.178.27.206) by
 DM5PR03MB2523.namprd03.prod.outlook.com (10.168.236.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.21; Sat, 14 Nov 2020 06:38:12 +0000
Received: from DM6PR03MB4411.namprd03.prod.outlook.com
 ([fe80::f8dc:93bc:313c:fc22]) by DM6PR03MB4411.namprd03.prod.outlook.com
 ([fe80::f8dc:93bc:313c:fc22%6]) with mapi id 15.20.3499.034; Sat, 14 Nov 2020
 06:38:12 +0000
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
Subject: RE: [PATCH RESEND net-next 17/18] net: phy: adin: implement generic
 .handle_interrupt() callback
Thread-Topic: [PATCH RESEND net-next 17/18] net: phy: adin: implement generic
 .handle_interrupt() callback
Thread-Index: AQHWud1/Uwiz5TV09E2lrqLBEwezb6nHLXrA
Date:   Sat, 14 Nov 2020 06:38:12 +0000
Message-ID: <DM6PR03MB4411E0161C1FF4C1904AD97DF9E50@DM6PR03MB4411.namprd03.prod.outlook.com>
References: <20201113165226.561153-1-ciorneiioana@gmail.com>
 <20201113165226.561153-18-ciorneiioana@gmail.com>
In-Reply-To: <20201113165226.561153-18-ciorneiioana@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcYWFyZGVsZWFc?=
 =?us-ascii?Q?YXBwZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZiODRi?=
 =?us-ascii?Q?YTI5ZTM1Ylxtc2dzXG1zZy1mODQ1OGY4NC0yNjQzLTExZWItYTVjMC00MTU2?=
 =?us-ascii?Q?NDUwMDAwMzBcYW1lLXRlc3RcZjg0NThmODYtMjY0My0xMWViLWE1YzAtNDE1?=
 =?us-ascii?Q?NjQ1MDAwMDMwYm9keS50eHQiIHN6PSIzMTE1IiB0PSIxMzI0OTgwOTQ5NDUy?=
 =?us-ascii?Q?MTczNTUiIGg9IlcyaE5UMlVsWmR6NHZzYU8yQUgxVHhJdlhDYz0iIGlkPSIi?=
 =?us-ascii?Q?IGJsPSIwIiBibz0iMSIgY2k9ImNBQUFBRVJIVTFSU1JVRk5DZ1VBQUVvQ0FB?=
 =?us-ascii?Q?QkxLNkM2VUxyV0FlK21FVWtROVc0bTc2WVJTUkQxYmlZREFBQUFBQUFBQUFB?=
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
x-ms-office365-filtering-correlation-id: 816351bc-dc21-45ea-4cdb-08d88867dc09
x-ms-traffictypediagnostic: DM5PR03MB2523:
x-microsoft-antispam-prvs: <DM5PR03MB25232AB5D49361836E70A015F9E50@DM5PR03MB2523.namprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Mj2kHlKaUWShFBXfzad5SgNqauDo2b5TMyWy8/3oBZ6hYmU0FQY4ap9/UZzkz8/P/O4mPwecBu317534TVIgwglabHarW/TN6wVUueeviCxtQmDCs4zij4a6hY2QlmDTXmo+9jd8YdVE1pZO1pxlb7ay1Do+lhPN/bowkAzCmLAxGYNydlJiuddrzAQpWVTUSeBog2mtftYwtvl/yfQNYHI+7B5okUza0KGRpqnCSsIZn1N0fxV5CrSoB2pZHQJnXIjMWrOYGTQejCNJVfkuRzRBxfR94nVlH1sg9aDlGX4TJEC/gzhnuiOgap2QalP/STIx+udChsPBrrhFCd3qc5h07nPyDwkRhTstn4Zi4oMIFMFT+Rt0k+TZO6x6ihsCcWOHXLKEfgFBRY863CES3Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR03MB4411.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(346002)(136003)(396003)(376002)(4326008)(55016002)(9686003)(33656002)(8676002)(66556008)(5660300002)(76116006)(66476007)(66446008)(66946007)(7696005)(52536014)(86362001)(64756008)(110136005)(8936002)(316002)(53546011)(26005)(186003)(83380400001)(2906002)(6506007)(71200400001)(478600001)(41533002)(142923001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: X+8I9/XsfPyhgCPLLlR7HDPcWXqD/uaOPmNHUPa7ufX+FBjzKtcLbomG4oHW6Cm54l67qv+/400tm5YUG6fitEbtzY9IQ9PgGDoHhWNNPO1lKGQPQrmSG8lsm8gTCCdo7XR4GC1jhZ8HJ6+GW94+BFO0zd34pODhwAz54pApONkzAvMuDIGa/krTI37nRRr6FE2JV+HZhIVtq/aTg5bBRwPZ5PtnwkoMg55abQzSylZVXf8Cq7c3Dwxn5me+v2Wfy/yvjpriArNYn4BMaMx1omju2NbigN6oEYehstBpXrekZJuVHmHmbApfB5dEqbcixHeXjzr1GLdXTcnxgyeh0M6JxRrwvJy6UysekVJ3yx53Em1FgVxsSqwJMOy67k2SUpXvfojBovySeHtNhvKLE3c7AOGPWn6p3StQhONRzmzneU8TAdrZ9mlFaNnzF6xzc5D8cT1CnLkk/2uQLmaHzF0QkE/aA9SrSGqXttW1NpuKVgyfbZJ/CnDNGy53kYRBxc6zhztt+hCf56qsjtC1b1A82me775xMQF5BcsT+fVHFzNuhgXconmtfgZA8vcS+za6kQs6uPeZG+4wglmZCHuXIcVhEKm0INzL/aQmSltB9cHMFdbUDsd2aZmhrueVzGRLWhcBFcaOgtLI1G6T0rw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR03MB4411.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 816351bc-dc21-45ea-4cdb-08d88867dc09
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Nov 2020 06:38:12.6321
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5LiSAEyXe5S3Dzh61YY2I3yfFBnzEu3dp03hwvV/TqidMwrinpaFTYQCmFCOb7/SkIJQPC2M5ea9GGVY7vMHtaM+ZXaFH3IieHFpO524HPk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR03MB2523
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-14_01:2020-11-13,2020-11-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 mlxscore=0
 priorityscore=1501 suspectscore=0 impostorscore=0 lowpriorityscore=0
 bulkscore=0 clxscore=1011 spamscore=0 adultscore=0 mlxlogscore=999
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
> Subject: [PATCH RESEND net-next 17/18] net: phy: adin: implement generic
> .handle_interrupt() callback
>=20
> [External]
>=20
> From: Ioana Ciornei <ioana.ciornei@nxp.com>
>=20
> In an attempt to actually support shared IRQs in phylib, we now move the
> responsibility of triggering the phylib state machine or just returning I=
RQ_NONE,
> based on the IRQ status register, to the PHY driver. Having
> 3 different IRQ handling callbacks (.handle_interrupt(),
> .did_interrupt() and .ack_interrupt() ) is confusing so let the PHY drive=
r
> implement directly an IRQ handler like any other device driver.
> Make this driver follow the new convention.
>=20

Acked-by: Alexandru Ardelean <alexandru.ardelean@analog.com>

> Cc: Alexandru Ardelean <alexandru.ardelean@analog.com>
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> ---
>  drivers/net/phy/adin.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
>=20
> diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c index
> 3727b38addf7..ba24434b867d 100644
> --- a/drivers/net/phy/adin.c
> +++ b/drivers/net/phy/adin.c
> @@ -479,6 +479,24 @@ static int adin_phy_config_intr(struct phy_device
> *phydev)
>  			      ADIN1300_INT_MASK_EN);
>  }
>=20
> +static irqreturn_t adin_phy_handle_interrupt(struct phy_device *phydev)
> +{
> +	int irq_status;
> +
> +	irq_status =3D phy_read(phydev, ADIN1300_INT_STATUS_REG);
> +	if (irq_status < 0) {
> +		phy_error(phydev);
> +		return IRQ_NONE;
> +	}
> +
> +	if (!(irq_status & ADIN1300_INT_LINK_STAT_CHNG_EN))
> +		return IRQ_NONE;
> +
> +	phy_trigger_machine(phydev);
> +
> +	return IRQ_HANDLED;
> +}
> +
>  static int adin_cl45_to_adin_reg(struct phy_device *phydev, int devad,
>  				 u16 cl45_regnum)
>  {
> @@ -879,6 +897,7 @@ static struct phy_driver adin_driver[] =3D {
>  		.set_tunable	=3D adin_set_tunable,
>  		.ack_interrupt	=3D adin_phy_ack_intr,
>  		.config_intr	=3D adin_phy_config_intr,
> +		.handle_interrupt =3D adin_phy_handle_interrupt,
>  		.get_sset_count	=3D adin_get_sset_count,
>  		.get_strings	=3D adin_get_strings,
>  		.get_stats	=3D adin_get_stats,
> @@ -902,6 +921,7 @@ static struct phy_driver adin_driver[] =3D {
>  		.set_tunable	=3D adin_set_tunable,
>  		.ack_interrupt	=3D adin_phy_ack_intr,
>  		.config_intr	=3D adin_phy_config_intr,
> +		.handle_interrupt =3D adin_phy_handle_interrupt,
>  		.get_sset_count	=3D adin_get_sset_count,
>  		.get_strings	=3D adin_get_strings,
>  		.get_stats	=3D adin_get_stats,
> --
> 2.28.0

