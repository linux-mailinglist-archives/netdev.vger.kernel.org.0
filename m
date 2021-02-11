Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD82F318645
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 09:24:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbhBKIX0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 03:23:26 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:22606 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229469AbhBKIXX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 03:23:23 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11B8KMwn027797;
        Thu, 11 Feb 2021 00:22:22 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=9M1wL37aHxd2JA02CtAQIJgLio3SWHrW+buXnt+Pd64=;
 b=KGQcTE9r13qia1jkoxjoCFVnwdnN1QyeBpF2slQ4OkCemOON1EEsznW4je/vKmPJDHHJ
 e2SgRyF9nTongOewFl+FwhKjLJY5bkDkEP5XFCwgLHF5kxOL1Hix4m61aKH/8PmNJJ2B
 LMwam8A339r5LSewClyUftJmegFvIsuIfD6BIh6Rs6+MHdux1wYGQSR+rr4s7aXvP5ks
 Yg70pr+D7FW7rneW9jHaxfy/pVdnVjQTS4WSl9J0cJ8bcnKyhci7lyLEwoL/z0kbGGPX
 4+Wq9tPJQgBZrDTgoSBeUNH7n7+zw0bJiCCQZfFUG5Q0VFCZ5OfPFLaEB63+vXvja/la pw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 36hsbrpfxf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 11 Feb 2021 00:22:22 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Feb
 2021 00:22:21 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by DC5-EXCH02.marvell.com (10.69.176.39) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 11 Feb 2021 00:22:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qv8/4W79jQKvJ4WNoXIb6854XCWFd6WG26P/LXQB6oqi4t01wQGFe3gCbCKaNemzeBIVSD034ZAkJUqyj2rafwyNCRgpe7DwEyR93tLqcNdKULTv0iyG6rd7vSzKeOHhrFdjTFGfz6bmdxNwkEVMUGgHJpA6D/Vwb3ICevIekKzYepuNynA3jH6e1YZZZGTgacgTiCw8dtxUvrzxmj1xSgKddzgBdLhXEwsYYwAuYikNc/QkwkXV1mbLy2Dji3N1woi0c4PS2UYekUVMq2yBoG4zEfKAfFLPwIc8teH7q3MN1fshfOQgAzD/RJ06BQVTCVrlRofJBmI6GpyWaJJfdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9M1wL37aHxd2JA02CtAQIJgLio3SWHrW+buXnt+Pd64=;
 b=Kd9giGXaS1pMUTweaNJHKxgrCgEmX8KNop9zxAlMHsWOwpqseavNr6d3dYvcaTyMHgU0bYnF+36CfL6yNoGsmJ5ED3FOW2gFQRkWF7qTeqoY3px10WlEAzEuBbuThkOGuK4dNqUb2oamS0iwRCCYpHU2JFBeI2N2XY8s96JjueieIlC8A6KUEXMj5RuFQFCi1VHuWl9keneEdfPt7DYt6d5FiUzMCnfOKYAOyRMZbaoUnL3ffmoVVV5gGcAKzTHC8y5Z51vxyqb2w8cCQ/KKZ8iHqKXxNpZpg+3XEMqtfnWq10424a9go8JGjddb9ePNgO4NmQ/Nk7IixShdVAQ1Hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9M1wL37aHxd2JA02CtAQIJgLio3SWHrW+buXnt+Pd64=;
 b=cBrj1RPDDXye/eDHGVbfFno6oc5nzzoZ24PlpPZFjhrbhwDtjg7CPSqWPtPdwOM3dvxisQJ0xvgo7M+Y8SD11IKxVZphMAW5TNqP+DKoocUUEfbhdhF5zJD1NtVix79oNGlXAf/QiS/lFQ7QkFwTlogDGBDGKONyDMjp9dfeQSA=
Received: from CO6PR18MB3873.namprd18.prod.outlook.com (2603:10b6:5:350::23)
 by CO6PR18MB3826.namprd18.prod.outlook.com (2603:10b6:5:347::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25; Thu, 11 Feb
 2021 08:22:19 +0000
Received: from CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::c041:1c61:e57:349a]) by CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::c041:1c61:e57:349a%3]) with mapi id 15.20.3846.025; Thu, 11 Feb 2021
 08:22:19 +0000
From:   Stefan Chulski <stefanc@marvell.com>
To:     David Miller <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "rmk+kernel@armlinux.org.uk" <rmk+kernel@armlinux.org.uk>,
        "atenart@kernel.org" <atenart@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "sebastian.hesselbarth@gmail.com" <sebastian.hesselbarth@gmail.com>,
        "gregory.clement@bootlin.com" <gregory.clement@bootlin.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: RE: [EXT] Re: [PATCH v12 net-next 12/15] net: mvpp2: add BM
 protection underrun feature support
Thread-Topic: [EXT] Re: [PATCH v12 net-next 12/15] net: mvpp2: add BM
 protection underrun feature support
Thread-Index: AQHW/5KjZ/qb5CtVhkWHSjiCzfBYLqpSCfwAgACUjBA=
Date:   Thu, 11 Feb 2021 08:22:19 +0000
Message-ID: <CO6PR18MB3873D8B7BE3AE28A1407C05BB08C9@CO6PR18MB3873.namprd18.prod.outlook.com>
References: <1612950500-9682-1-git-send-email-stefanc@marvell.com>
        <1612950500-9682-13-git-send-email-stefanc@marvell.com>
 <20210210.152924.767175240247395907.davem@davemloft.net>
In-Reply-To: <20210210.152924.767175240247395907.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [80.230.25.16]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 96c4c831-1ac7-4850-b968-08d8ce662603
x-ms-traffictypediagnostic: CO6PR18MB3826:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO6PR18MB38262802A4CE1BE7D8A5833AB08C9@CO6PR18MB3826.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HSxuW3rQHPX13TYM3xLCnsVC2ew+/jELgSRl4I5i1EHAlWKn/kdycu10ZaRffZH5dBMRV48xmTQiQAnZW+dK9ywey9OBcnqEoRXvi2wjnSjaDJI5LehDLvFnz5UJPsPayHKmPyYrxxFvGGf4YMru+Ixo64k2LF0I6peqNS8Uxh5t83sBL+1lR6M6Ftot6hp5F3L+ojBwV3h6QBRNVQwIm3vv6j+ptpgyJLvogdGrIUqxBwCYSB9Ak3D3uam0evxa+DgchintU5nMm0VqtolnMgwaEWC+AxXS6tcV3BNhEhEiEqT63QuZ9MZWt0uRt4y+EMZuZaSAGWF+VmqoiHjDWZpK1Oh4qP/L4QcPHKYb/lY2LG30sofK398EEu8GtYJUFuNXboFXTNMovNhKCaYStcX6qXpHZmLR6bCHr/lY/4dpXi5hQgU5pmS14ZMdWj3O2vAnfe7MLVgbGF93nxxYyz+iLAYZz/25PGs45Hj0hblvIOvwM33/Q29SqyNIQMasnHTP2e6UfKiNJoWTKhjcug==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB3873.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(366004)(376002)(136003)(39860400002)(26005)(86362001)(6506007)(4326008)(8676002)(5660300002)(54906003)(52536014)(64756008)(66446008)(66556008)(66946007)(316002)(66476007)(7416002)(76116006)(2906002)(8936002)(478600001)(55016002)(71200400001)(4744005)(7696005)(9686003)(33656002)(186003)(6916009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?hGEpLkk/upkm73Cq+JAdatcUV2tMhUTwTId8w3suAHF+y/AptHoXXayjhLgs?=
 =?us-ascii?Q?rLXpk3iWLK9cdXKXXQTVRIaRXaNSIZOJ5lSS0NXazy/BovEkE8S6/k4pFT1V?=
 =?us-ascii?Q?1d65i7ehD3+VDYYulkRXeG+fxXGOfRn61+pAnNYDg9khvfAykgetkb4NCnuu?=
 =?us-ascii?Q?TrZ5BVmck3TCqUAZ6llB5y+QWAIl2gLBhCX+6AJSEMhPYoVeZnIfni3jI5gv?=
 =?us-ascii?Q?G0gNB0TopXzUQCNS9gbX7sq8SiS2kGRxwls7YKO0eOxmM5qz5TrrquMnPu6s?=
 =?us-ascii?Q?esgPVaH5T2T9VDtnVElMPXMk/raUYgPSoIVVbINXg6G/08mEqZTaHBxLe7Zs?=
 =?us-ascii?Q?ZdErY/EqkcZREO+3CgYScPICaBkyZ1xETN6J6tUY4AqJCSwtHa9gC0JsPuE/?=
 =?us-ascii?Q?KVH8wYU4X0JrYtdKELzCQxKCZA6snvi6KZP1CfGItYnUF2RDVjxTjFYQ8OxP?=
 =?us-ascii?Q?mYpmLCIVy/LN7m+U7f1WaOBlV2FEm7296O+VVmqEBsjQsufINGMn25Iqf7Jg?=
 =?us-ascii?Q?G0IrPw+HvmDxZgdFkkGvxI479lrva5CbK37S6pCNjXhq63LAEBNozF0f5g0T?=
 =?us-ascii?Q?G85bsg4w+8NRiEyKtqT7u5ORdIohmp2xJbricRxh+ZDGZuGISLCRsNvwrNvj?=
 =?us-ascii?Q?YTtkbuanI2KjreY1zht1aJT0Bl21LCKZokFb8RPfPPecrV07WBKw4mVRyOJO?=
 =?us-ascii?Q?kfxSyxzl6SS4u0zxahDwHpu6u3Gml5G6RQ29UiHg4NZ3g3wpsinooo1NCi3J?=
 =?us-ascii?Q?ukYuh3A7E4H5AgiOkqbQaoT6go3KqwqMSsNlABpX8hb082zmFJlT0tZWWn2k?=
 =?us-ascii?Q?8KnxPAFG/pecY2T+ynShFqvgZJZyWNATFqN9oGbpQVww35NwhGOzsXnLN6eZ?=
 =?us-ascii?Q?T67qzET0CBX9xLk0zMziLG8KOQQlrknqoSaketYXolI1SYnUVlCzcIHXPTDW?=
 =?us-ascii?Q?nNBvNQD1u0szV7RUNufuqKVVqeWEPLbj4t9gAq4Y+3ejLRYYyDAABcqzWxrm?=
 =?us-ascii?Q?ZRJHPTWe5NY0RU/rdgYod/86u8Ojy3vq4qlYGiYF1t15XyJQWTgW0Ok/YPRP?=
 =?us-ascii?Q?persXP/UxF8CeJoFkxwuMI2ZripMQVvzGCarRBsDcFP+gPc3BsRkQZn7761m?=
 =?us-ascii?Q?WhuEFgjQZ7OaxucWNvdt972yjE/LM1ImeOM2EZVEOEKTVmVBYsfFRTS/D3OU?=
 =?us-ascii?Q?RmVt8/Ae4TStxe7+csd1Mz1yp0yrjD6NZyIbbLTQFGsffUp160/Wh2PRjh6s?=
 =?us-ascii?Q?urZWPKaaOCVl6hZTuP/B/95bdaHpWLgxtp8wkNuaei22adJHBeEuUhKwMqey?=
 =?us-ascii?Q?MHM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB3873.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96c4c831-1ac7-4850-b968-08d8ce662603
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Feb 2021 08:22:19.1504
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GoaTE9Nkb4UUknAspbeqEsDdtzHoo4DM9OEmsEjoBf+J/ws3W7umIGt44fzifab7mEJDRUSPmwHN3/z0yMGX3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR18MB3826
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-11_05:2021-02-10,2021-02-11 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


>=20
> ----------------------------------------------------------------------
> From: <stefanc@marvell.com>
> Date: Wed, 10 Feb 2021 11:48:17 +0200
>=20
> >
> > +static int bm_underrun_protect =3D 1;
> > +
> > +module_param(bm_underrun_protect, int, 0444);
> > +MODULE_PARM_DESC(bm_underrun_protect, "Set BM underrun protect
> > +feature (0-1), def=3D1");
>=20
> No new module parameters, please.

Ok, I would remove new module parameters.
By the way why new module parameters forbitten?

Thanks,
Stefan
