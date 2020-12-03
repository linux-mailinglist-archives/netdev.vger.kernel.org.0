Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 328652CD943
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 15:37:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389047AbgLCOeo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 09:34:44 -0500
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:24322 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726956AbgLCOen (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 09:34:43 -0500
Received: from pps.filterd (m0167088.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0B3EOmaH030874;
        Thu, 3 Dec 2020 09:33:49 -0500
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2106.outbound.protection.outlook.com [104.47.55.106])
        by mx0a-00128a01.pphosted.com with ESMTP id 355vj5nwvf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Dec 2020 09:33:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=egh4DsFC5LuB1XgNPkDcqFKteLp5EM6+/1rk0GJ+OsWK1X4UAg0y/kZFoIdzmlcBw4zD3IvnaUCDo87rdG4i5V4tahjUzuXVqPPdg5xW08kVo7Y8P85MOtyYiEjwVUlEaOKX8c93B56wk6aXJCTBACi+PHPjPQ6fupo2Y3LkrTz6PVVqI093ire+hW3rKCecRJsOOK4Rve12xx+JMcu0WEFwI6yya5sLz4FHwA5XmJVf1zMdi/KPZ27t0PJrCsVP7hCMKEzkSbzYuu99E1mJ2/UKyUdKtrpv9hVPkPb0j48QBoQXoQMj1Afzux3vNCOFGx1OKs1IMN/QlAdhjwfAqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+HjNSTmcTAAsfhauqErgVxCnF2vHrbSaLRAUM0wAS5U=;
 b=NNNrAYNRZg1zHLX4FB5gymczaWVChR1RyXr43A6NY8hJnrmcrT0J+cawWTS+9sds66kQZsQzxMkEVmNbo5OrUn06snp3yX237oUPa1gKwrJuJ7s4xftk2JjnExwWupJ/u11PyWsL69Ni1mtdeX8YSuxUCM2/+V38t8DKcywlTIPna/+hlXe17nKehbzWYgz9NyraVMBWvkr6xaQg6fx2ZLFKd7z3ampQNkSr0q4shRPA7CDR+93w9WtPqjVgQFbCxGfhAJNnsSyrlH3r3BdfCD2GXNnvkhdMvwNJRPRSQuk/erpWwdmVLvjzl//UZJtOAFvDnqWTPzb2bDs9crLP1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=analog.com; dmarc=pass action=none header.from=analog.com;
 dkim=pass header.d=analog.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+HjNSTmcTAAsfhauqErgVxCnF2vHrbSaLRAUM0wAS5U=;
 b=TDko3b8wFODXN4dq7XZ+UlJFW4YlJCZcsfCUr9ndAc4XNSmZWWSJMtB68UBcofQLxy6Ne3J69WaKZL78RgEdEFw6HSxSu9nf1zKuWHWk1J8bBMtdFJPXCuMIBak1pqZP8DobduuuWdeBlYlNzc2Wr86d+0SevyZ45LjkVr/BlQA=
Received: from CY4PR03MB2966.namprd03.prod.outlook.com (2603:10b6:903:13c::14)
 by CY4PR03MB3079.namprd03.prod.outlook.com (2603:10b6:910:53::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Thu, 3 Dec
 2020 14:33:46 +0000
Received: from CY4PR03MB2966.namprd03.prod.outlook.com
 ([fe80::a45b:c565:97bb:f8ea]) by CY4PR03MB2966.namprd03.prod.outlook.com
 ([fe80::a45b:c565:97bb:f8ea%4]) with mapi id 15.20.3611.025; Thu, 3 Dec 2020
 14:33:46 +0000
From:   "Ardelean, Alexandru" <alexandru.Ardelean@analog.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Redmond, Catherine" <Catherine.Redmond@analog.com>,
        "Murray, Brian" <Brian.Murray@analog.com>,
        "Baylov, Danail" <Danail.Baylov@analog.com>,
        "OBrien, Maurice" <Maurice.OBrien@analog.com>
Subject: RE: [PATCH] net: phy: adin: add signal mean square error registers to
 phy-stats
Thread-Topic: [PATCH] net: phy: adin: add signal mean square error registers
 to phy-stats
Thread-Index: AQHWyUteHtBwK6NMVUGNf2tL6yDeXKnlayUAgAADDNA=
Date:   Thu, 3 Dec 2020 14:33:45 +0000
Message-ID: <CY4PR03MB2966A933B982841E1250EBE0F9F20@CY4PR03MB2966.namprd03.prod.outlook.com>
References: <20201203080719.30040-1-alexandru.ardelean@analog.com>
 <20201203141618.GD2333853@lunn.ch>
In-Reply-To: <20201203141618.GD2333853@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcYWFyZGVsZWFc?=
 =?us-ascii?Q?YXBwZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZiODRi?=
 =?us-ascii?Q?YTI5ZTM1Ylxtc2dzXG1zZy04YWYzMGUwMi0zNTc0LTExZWItYTVkOS00MTU2?=
 =?us-ascii?Q?NDUwMDAwMzBcYW1lLXRlc3RcOGFmMzBlMDQtMzU3NC0xMWViLWE1ZDktNDE1?=
 =?us-ascii?Q?NjQ1MDAwMDMwYm9keS50eHQiIHN6PSIyMTc5IiB0PSIxMzI1MTQ3OTYyMzg3?=
 =?us-ascii?Q?NTE0NDUiIGg9ImpjN3RkTklZeCtyaTZoZ01NNnJCTCs5ampjQT0iIGlkPSIi?=
 =?us-ascii?Q?IGJsPSIwIiBibz0iMSIgY2k9ImNBQUFBRVJIVTFSU1JVRk5DZ1VBQUVvQ0FB?=
 =?us-ascii?Q?RFZSa3ROZ2NuV0FTT0w5NmdpSVlHZEk0djNxQ0loZ1owREFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFIQUFBQURhQVFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFFQUFRQUJBQUFBZ3NWMDRRQUFBQUFBQUFBQUFBQUFBSjRBQUFCaEFHUUFh?=
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
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=analog.com;
x-originating-ip: [188.27.131.171]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: bf00dbfd-4865-4b7d-3369-08d897987121
x-ms-traffictypediagnostic: CY4PR03MB3079:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR03MB307976277261210E8C8F6B1FF9F20@CY4PR03MB3079.namprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1751;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: a6kJxZWBSDCaUkOV5ZhGRx1tnrh38/3THQ5p8i3xwvFg33JthacWpLSSItLiiO7VF+D+k+Sv9vlACsfvE1GeZ1tRpgHuujdZDaB+Avl1X+3EnxwO2EFmpNUQKD0h92bP7+xIQLu9r+v6Sibt2Qe49xLfIKX2l+myarGwWef73JjR9mlbqssCZlA62TubsRUwZM7/6/WHrOUiZ8P/BMo5nJGun7duE3TW3EyMBGMJaPqyNYSXHnHF+1wqjBvOmmXcqMpKLAmQreHg5CT6UiuzT0+LEyL1MUtCjPK+UIHsnfVPQ2orOYO9gfvPouWyI4gb
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR03MB2966.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(346002)(376002)(39860400002)(396003)(66476007)(64756008)(66946007)(66446008)(76116006)(66556008)(478600001)(5660300002)(54906003)(8676002)(33656002)(86362001)(52536014)(8936002)(316002)(83380400001)(53546011)(71200400001)(7696005)(26005)(6506007)(2906002)(107886003)(186003)(9686003)(6916009)(55016002)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?HXN09Ig8qz6OQeL4sSQ/kGioL6DOuRJWHlD5lK4Jr7AqmDWLv94BCkOGK1l5?=
 =?us-ascii?Q?3pRtlbed+wHqO1wyjHsxIXrfWVrMbNqS0qF+F1AB0+8Xx3PiAzfDjT19fn6R?=
 =?us-ascii?Q?gZlG5Wgjp1x85Gb0galgyyDHVdtOOBM9kJSdCMF+vgXdioNl0RceuEodN4D+?=
 =?us-ascii?Q?FILYbHcLQ2W3avCe9IOrvTASNKuWHauqvJZ9c+a1W75JxUJn212aQSMRPjrE?=
 =?us-ascii?Q?Aq+/ZerHCixlhpe8+7UNlaLK14OWHjAU0Z7SYXJZ10p/M9OBabmi6mjwc2Ja?=
 =?us-ascii?Q?5vkG3hhU8cTu6elfHFuvW/TzgAEqQDKhMDCdjwlpXQ1SNJAubWt19bdQ8SEk?=
 =?us-ascii?Q?Xn0qCilQmLL0DNigV5H2ugLyurh5LokBXf9RXz4jBbjSXn6EC7CV+Wzag756?=
 =?us-ascii?Q?tTKoyR2iG7e3TXxXeSn8Zvj4B/dePOKYcku3YQ+WonNqkrvHzacnGFRV7Vvx?=
 =?us-ascii?Q?u1K8MHF+7aBuvBsrPTeJKVDZYmqa7d2NAtv+t9t9b4F7Cz/68ZSySDyv6PUB?=
 =?us-ascii?Q?dh/HymnIY9oeGzWjwhLIT8pGrl/P+NZRKx7mGEY5y91/IKUB27ZGKL301ZuV?=
 =?us-ascii?Q?yjGpBIhvPnUmFN1rBt2fUNySoHML+aLLUv30O+JvEUF5Kvvotujn/ITsbL/f?=
 =?us-ascii?Q?Zjs37EamHvs7XqjbUWkmT+o3OUZPd4Vb49Gu8l6lt+svMEoZGx72Z4lqe6/f?=
 =?us-ascii?Q?PcEjTOdd085sP3fJkW4bpqGDTC6yVmBVwt2ULukGhmmKK2DYt6mfbl7ZLI7U?=
 =?us-ascii?Q?gfOhGLts4QqE9ej+NWLl0f1iqeaG54Uiuh6gvdoREgtOvvO0qTEv8pqAY7Xp?=
 =?us-ascii?Q?hVKGP49B+Kgrkj07spjYFkdDGOAAGcL1iWocu75mK/KlAElYKMLZFXrfIjvw?=
 =?us-ascii?Q?7JP8BpbyHSA5TlQzP/LJxBPTMR0Pi7nt8OnpLm7q6DB9XcDRwLL0MMLo2hl2?=
 =?us-ascii?Q?7tGL5g7bI3yUisvY8851XSW9dJEQJBbuAy1l1PqD8i8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR03MB2966.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf00dbfd-4865-4b7d-3369-08d897987121
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Dec 2020 14:33:46.0170
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fV11ZR5f0hpLP0gE3n58RchcQUvJMHF7gK/7YA5b3+2UlMSvd0XcoCchd/kIk5O3z+2bSbcKgCNYEeFdw50SDT2Yz9uSMVfmqysW5XPXjwM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR03MB3079
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-03_07:2020-12-03,2020-12-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 clxscore=1015 malwarescore=0 suspectscore=0 mlxscore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 adultscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012030088
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Thursday, December 3, 2020 4:16 PM
> To: Ardelean, Alexandru <alexandru.Ardelean@analog.com>
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> hkallweit1@gmail.com; linux@armlinux.org.uk; davem@davemloft.net;
> kuba@kernel.org; Redmond, Catherine <Catherine.Redmond@analog.com>;
> Murray, Brian <Brian.Murray@analog.com>; Baylov, Danail
> <Danail.Baylov@analog.com>; OBrien, Maurice
> <Maurice.OBrien@analog.com>
> Subject: Re: [PATCH] net: phy: adin: add signal mean square error registe=
rs to
> phy-stats
>=20
> On Thu, Dec 03, 2020 at 10:07:19AM +0200, Alexandru Ardelean wrote:
> > When the link is up on the ADIN1300/ADIN1200, the signal quality on
> > each pair is indicated in the mean square error register for each pair
> > (MSE_A, MSE_B, MSE_C, and MSE_D registers, Address 0x8402 to Address
> > 0x8405, Bits[7:0]).
> >
> > These values can be useful for some industrial applications.
> >
> > This change implements support for these registers using the PHY
> > statistics mechanism.
>=20
> There was a discussion about values like these before. If i remember corr=
ectly, it
> was for a BroadReach PHY. I thought we decided to add them to the link st=
ate
> information?
>=20

Oh, this is new.
I've had this MSE patch lying around in a branch since last year sometime.
Wasn't sure whether to put it in the phy-stats.

> Ah, found it.
>=20
> commit 68ff5e14759e7ac1aac7bc75ac5b935e390fa2b3
> Author: Oleksij Rempel <linux@rempel-privat.de>
> Date:   Wed May 20 08:29:15 2020 +0200
>=20
>     net: phy: tja11xx: add SQI support
>=20
> and
>=20
> ommit 8066021915924f58ed338bf38208215f5a7355f6
> Author: Oleksij Rempel <linux@rempel-privat.de>
> Date:   Wed May 20 08:29:14 2020 +0200
>=20
>     ethtool: provide UAPI for PHY Signal Quality Index (SQI)
>=20
> Can you convert your MSE into SQI?

I'll take a look and try to understand the SQI spec.
It's neat that there's a common place where to put this.

Thanks
Alex

>=20
>     Andrew
