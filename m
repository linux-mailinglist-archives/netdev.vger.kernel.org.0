Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06758310DD5
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 17:25:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232803AbhBEOqP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 09:46:15 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:21688 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232774AbhBEOiW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 09:38:22 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 115EAtAT018767;
        Fri, 5 Feb 2021 06:15:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pfpt0220; bh=tCTQ1kdwnCtXNIclK9q0lTR3sM/q5AQJ7Jb/XBbUuEI=;
 b=TBwDS+sIuajYJqIICbkATtIfIos2Ab4bS9tKjG/ocR94xTN8AOAhu2pt5H2ySfSkeyZZ
 AloaLe+yokxdOgA5dPFsQWJY4Rp9AAraY/ZgujCmQB+xRv88WRJuYIxhRz5nxWPnBNyT
 VNoj0VNIW9pf0jW24kfWMGiyxvmp7mFaa2JCmT8yZu+9BJIp31zFVtG8n0dwVb+lAWcp
 hgFKULfhRttl8RLuDCMBThqh6Nm0DPM0a1tmIIO4qvcWESao7CyQEZLVo6S0WjlF4akk
 cKKRIsYjtwci7CiwsN5ERV6tWJ6EJR/wPJ3qsvZFJc2Auio+YrV5xZwpwEKkiSWfhLoE ow== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 36fnr698dv-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 05 Feb 2021 06:15:06 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 5 Feb
 2021 06:15:05 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 5 Feb
 2021 06:15:04 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.45) by
 DC5-EXCH02.marvell.com (10.69.176.39) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Fri, 5 Feb 2021 06:15:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AItO+ppOLK38VpW0YVwEC2UBv9o/fVFhxdzdyitR+1/eix/2CMNrYuGkQaMUNKdJIpiasTSomiNn426e/oAt4D148PhIlwPP5MGY09jzdW7kAoai/dnrsnssT+o3ZlBZobr9QR5GKnTTE2cHFs2Gc3E16jtouLSdCG6wqbj5EQksDU1pn5mCBjZi5RnGfoP+u6pIu2+d3SL69hix9+0eQQt32b2Bp/GLvFWeo6T/vEVL2zYFZnfmA31tlN5/HBEUdFv6BXA8JW+49hbeCrlKsv896gr5xYZByCAKreZlJaaj/wUmBouAeM8lUod6w7nX6t+olYQmECDypR9TPJ8WwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tCTQ1kdwnCtXNIclK9q0lTR3sM/q5AQJ7Jb/XBbUuEI=;
 b=jDNzJqYzXypl89vzhirEffu4dG5YECom9bhrfIU9CGTxQAqP9eZ3BAfsGtssF7X8SGBxuKucTlg4DU4m1cwyY6vdbGLJp3fWFmtqGUec3PtlpNYCnc0S3HZtoAYLo6c6tMYikbJO2IJ0DKJ5qxLiNOlqegh8ye+5sXEPFyHfYDJ5LW/nVMcmZhhMe44YoUXH6qTXOA7ZI1o3H6izmAdQwgmII3hVhbMLNncw362ASkNPvcNUhbg5m9G4YnKp61V0JfQdk3NhFNcvGwHwhjOVRbNk5ARYByag5x20vEIs7p64vAiJzzopRFwCAPEEbAdYp4LUCbWB5BsMgP0PjQB8sQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tCTQ1kdwnCtXNIclK9q0lTR3sM/q5AQJ7Jb/XBbUuEI=;
 b=TwnQXbc3vF1gU6aw0pkyIs0BZiTY9jz+rTzYuCVqMwikuwcO1VEoREWxgrAClTXtXNV2CDqTJJ2t/j8Tp1+bfWLgraFhosKhYs/4lEE5dJO0A75xhFOy9lWe0vqZdf4J4PvwDPXQ1Vrx4pwbRXlYNpt7BZe9ugvT9a5Cn5pJ5Vg=
Received: from CY4PR18MB1414.namprd18.prod.outlook.com (2603:10b6:903:111::9)
 by CY4PR18MB1319.namprd18.prod.outlook.com (2603:10b6:903:144::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.23; Fri, 5 Feb
 2021 14:15:02 +0000
Received: from CY4PR18MB1414.namprd18.prod.outlook.com
 ([fe80::c871:580d:981c:15d1]) by CY4PR18MB1414.namprd18.prod.outlook.com
 ([fe80::c871:580d:981c:15d1%7]) with mapi id 15.20.3805.028; Fri, 5 Feb 2021
 14:15:01 +0000
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "willemdebruijn.kernel@gmail.com" <willemdebruijn.kernel@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        "Geethasowjanya Akula" <gakula@marvell.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>
Subject: Re: [Patch v3 net-next 7/7] octeontx2-pf: ethtool physical link
 configuration
Thread-Topic: [Patch v3 net-next 7/7] octeontx2-pf: ethtool physical link
 configuration
Thread-Index: Adb7x1zT+BakY51QT4axliWbVlq2Cw==
Date:   Fri, 5 Feb 2021 14:15:01 +0000
Message-ID: <CY4PR18MB1414EF4948CEF69C49E06F85DEB29@CY4PR18MB1414.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [117.207.115.225]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: eb783016-5b04-4685-5286-08d8c9e06d7f
x-ms-traffictypediagnostic: CY4PR18MB1319:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR18MB131940AAFEE58E0C90B02DAEDEB29@CY4PR18MB1319.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: li2DWvwAUXSJ1HofPjjpvdQbYlWLTpQDgNWF7ziS8qr3W6PEc2OZo8PHEtZPNSn5Hx2XHfJublamSNhOjmPFnd2bYz7kiIdpaRffToVoN4Gv1nqDqEm7ZiqoJb6bHa4s48Em0T7N7c4kTCAvnTG6Z/pBhp635eWXljd0U5pX+I6sR/jws2sBvK9X/g4p+F0Y+hBnZM1fLqzAkM90Tz3mS0NUMDd0ts7AQJbqe53yHmrqQHbKdEiEsYD/PyeUlbHIB+XTVCZwi3/XuhhJfny0XHw/dRkf0Ig5bgpc3H4MX/JJXBIjmHtinrixy8II7YTGjdx/MQEwMBh7ZQmTwSrTwm3Ys5Lnv/z+mIs/awNV2i7MveIHe2GPaTF3BsofbKOe2qRD/MiaOjCHvO7RYOpgFUDSeLW4vW1FTWC2sUieh0MHLGaMCycKf68TSPrVk9OgQU+tmGPAS7WUqa+bV7jMi4W/10VSf4us8ihtZWFuf5FNwxU8lCTREBFQ8msrAsDerqaICkXgs2w6w9sZLqlUJQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR18MB1414.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(346002)(39860400002)(136003)(396003)(6916009)(9686003)(83380400001)(8936002)(4326008)(107886003)(33656002)(26005)(6506007)(53546011)(55016002)(2906002)(186003)(54906003)(66446008)(64756008)(86362001)(71200400001)(478600001)(52536014)(316002)(66476007)(5660300002)(66556008)(7696005)(8676002)(66946007)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?zz2vDQxnUcGDdtUeIWfvBf8dETbODcAiTQWrFWrp3KfCTKwynnP0EX0DeFU6?=
 =?us-ascii?Q?YDNzXssNafSMob9han8eWSrzl69N3yI7meZSrWQlDGwY3RGrgwL7KeB259yD?=
 =?us-ascii?Q?cAXC+n/LD29mk0mZEnvdOghPLWLEYtexnSXgbiHiPUOsPp81d5IWkmZIOOig?=
 =?us-ascii?Q?zhyuJzJriTuZPTgNZ13didpwNbtY01qO1d512ZZ4WlJpT6IKqnpciNRjVegy?=
 =?us-ascii?Q?JpsVxewKk9O0/WeNoFhANWz+eBGMxms6k7rC9d/CSPnW1iO4vGvjvdMgT4k0?=
 =?us-ascii?Q?2pQMi5FH+ncZ0KFiaiMWcT5MwkYkZoL+rU9ESsySF6+5yjChAhyeRKu9i6A+?=
 =?us-ascii?Q?wykhITL4xy8fxldAepF0KA7a980GunzbxsdR178qZuq24cmIAldgFam/z7WW?=
 =?us-ascii?Q?gkb61hzwe2TbeVkZzWMdYp+w+W6hlmKaR5NkPATdHT2kYWO2Oxi29YPDKul9?=
 =?us-ascii?Q?GM20bifTm/LVZYa+vxajKN2IRNbwFBOCO93PKmmGcVsogfCHb2pfYDYGybq4?=
 =?us-ascii?Q?oP59Na5NG+JnE2u5xDXJxbHna77rUnIRkMnwGjeVdruy/4QrrAa0Z+NPeMd0?=
 =?us-ascii?Q?L0IHlyXZ/RGHftK7XWHmZqIiC3tjq0ma0d0Ms8PVYSiqlZXzIaeoJKDFoEc8?=
 =?us-ascii?Q?Iw1G/YKdeM3pxETNf/0/tI32tkRHiXxOFhl35VWwwNfJb8OMk2A8GG6qbLPV?=
 =?us-ascii?Q?26tKJIIh2wd+ArIQWDBzAwodimv6ptUTvpFqkVDS6+wZewk8TrCDjS/YLbpi?=
 =?us-ascii?Q?rsO4h6n5Q4Vi+rjmila/tcAESZ08eRVuWnHJLJJY2ua6r6R6x9pkGBCRq8a+?=
 =?us-ascii?Q?mzWm0Owjp4LAquwQve2L0xSgmrdZ0Jl0wRmNl9ywhAubX0ZBDuPLUaOtXa78?=
 =?us-ascii?Q?Uzip/wV3jAoswZzTVsquzWF5aUVZt7SIBcN+kt8l3uSrB2epc/+pK0Z/GNqD?=
 =?us-ascii?Q?qp8ugAqLX4dCIKzN7gJkXsi8zPbiXyTwC6kvK2ODEl3zXuoHblKcvei80RM4?=
 =?us-ascii?Q?tOkOVyoV4/R0rjS+RDJgHQvsdeaVbeOIKsaQ2wL0Zvele+SVw9K+x0jHeHD0?=
 =?us-ascii?Q?WuFCsvCtwtg1AWHTgZx3UaI2zFcKyFgKzkifak8Sj+FKKm8X4Imc1Lehaa3h?=
 =?us-ascii?Q?t+RjkScnFsXhSP4GR104Sj3wqG4Gk/42Fc3OIVXE1658G+nUWVdm3i1+fr+g?=
 =?us-ascii?Q?gl6U6US27DDoXoaKKbVNeR54wDpNrS399ad2Ejee3jaoLh6BVxxkzb/qszGh?=
 =?us-ascii?Q?MexdOvqT/cEHeGkxYBRnllH/nVXGALIPniguGkWEzulbnAYpnPcRmvYZ+rvG?=
 =?us-ascii?Q?KR46b4XIaCbt5+TDABGJDPGk?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR18MB1414.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb783016-5b04-4685-5286-08d8c9e06d7f
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Feb 2021 14:15:01.8024
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Gty6qSSgLV0Tmtc397pj0cGi5F9woZY80LywoXLC14/LPpKFZzhOfbbx0F17e3mESZIfBsjFIjnwXaS7zektjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR18MB1319
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-05_07:2021-02-05,2021-02-05 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Friday, February 5, 2021 12:21 AM
> To: Hariprasad Kelam <hkelam@marvell.com>
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> davem@davemloft.net; willemdebruijn.kernel@gmail.com;
> andrew@lunn.ch; Sunil Kovvuri Goutham <sgoutham@marvell.com>; Linu
> Cherian <lcherian@marvell.com>; Geethasowjanya Akula
> <gakula@marvell.com>; Jerin Jacob Kollanukkaran <jerinj@marvell.com>;
> Subbaraya Sundeep Bhatta <sbhatta@marvell.com>
> Subject: [EXT] Re: [Patch v3 net-next 7/7] octeontx2-pf: ethtool physical=
 link
> configuration
>=20
> On Thu, 4 Feb 2021 17:37:41 +0000 Hariprasad Kelam wrote:
> > > > +	req->args.speed =3D req_ks.base.speed;
> > > > +	/* firmware expects 1 for half duplex and 0 for full duplex
> > > > +	 * hence inverting
> > > > +	 */
> > > > +	req->args.duplex =3D req_ks.base.duplex ^ 0x1;
> > > > +	req->args.an =3D req_ks.base.autoneg;
> > > > +	otx2_get_advertised_mode(&req_ks, &req->args.mode);
> > >
> > > But that only returns the first bit set. What does the device
> > > actually do? What if the user cleared a middle bit?
> > >
> > This is initial patch series to support advertised modes. Current
> > firmware design is such that It can handle only one advertised mode.
> > Due to this limitation we are always checking The first set bit in adve=
rtised
> modes and passing it to firmware.
> > Will add multi advertised mode support in near future.
>=20
> Looking at patch 6 it seems like the get side already supports multiple m=
odes,
> although the example output only lists supported no advertised.
>=20
> Is the device actually doing IEEE autoneg or just configures the speed, l=
anes
> etc. according to the link mode selected?

Device supports IEEE autoneg mode. Agreed get_link_ksetting returns multipl=
e modes . =20
But set side  firmware code designed in such way that  it handles  single m=
ode. Upon
Successful configuration firmware updates advertised modes to shared memory
 such that kernel will read and updates to ethtool.

Thanks,
Hariprasad k

