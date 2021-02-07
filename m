Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9045F31253F
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 16:27:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230228AbhBGPZb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 10:25:31 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:45546 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230372AbhBGPXN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Feb 2021 10:23:13 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 117FFx1m004289;
        Sun, 7 Feb 2021 07:22:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pfpt0220; bh=iEJ2ESN0IDzLh2QKXeAyfL1PqvLQQSVxWqyYk02Munw=;
 b=GkGuEVUVZyvEDgPocOTKWzQCLfW5WYOeIH3cV5JvYAFEqKVGvdI6MQ2ZdIrv73oCkveF
 FRKtOmfty9ipLuxmtC5HYoc/1PPTsvRKN01kYgc4bNy9jh0qSeo1XTKE6mSutJqgdMEP
 wxsrKfBWgtxYjOdmz4SlswQBC3fGuEK6lZiV6rJO+c9HFUhoMFdrVEnep4tMX++OZl5L
 66LLFLI8nxvWo0El/1IFoI3ceOF4jg0CABmMZwhxDpCkJdfffRacqn818JvjsoQQ2wQ1
 s8Ka3sDAGwL1vOAtZLT5p3M7ttZoi+/pzLhHZRMQWW3tWabuyUBHfAj/ZIq8v9dWXRP2 6g== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 36hugq25rd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 07 Feb 2021 07:22:26 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 7 Feb
 2021 07:22:24 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sun, 7 Feb 2021 07:22:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e+VbB0JYKZXZ83yz17JzW3zog8UFyDMuJofpbm4yMb2VEBuPK4z2Xh+PTyzEdAcY4GuDE3o5PDdCBrpV+UVzEAv5SiHDyxf+26nSmhjMMrc24ZjYLgf4AE/M8XWJz28bJxYsPNPkWMWD/Ze6yzLjBLB2m9aU9DBVzgbaFuDOqH7KdG1d2v675GWuFGo23Yf9zLe6Tu2Vy9cAzyHpePvDZ7uGZzsk9eq4m5I+s8sXI8tZlU3A9z6fKYq4geCe7tAjfZd/S2Nf3TP7pYeJMCMYGAhxGAQVDRpqCRl5D6aC7+0rZvrohNtHbywiLww3TIRsUloLs87fJdOqVVv+5tyOlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iEJ2ESN0IDzLh2QKXeAyfL1PqvLQQSVxWqyYk02Munw=;
 b=BYnonzanpKIQxtQznJt71iPHIf8YWGBW2lJr+M+3BWB9qe3ok8+yt1TV4KwqEmIWGmZTro4wNghxAyViqVVZVjT/9soali75b3qobeN+skTK+vcbY1gpgyFROVQljjYrCiPDfk2Y+vabNTawRxCPwY4w5qfCQvHrJCQYXx+Iys3KLYY6rmVvYY5CcChElape011NqrPuNc/eoje3XZ6PYkngKvmgqUsL7sHVnG5TY15KCBxNcPEO4y1/x5GCUrF2uoseQe8NaoivUJgB3OdL5vOXWNwzN0iFeCQwt7UbwC/wvO5nOpimASuOzozInTrYsetLS6o/YMZklXH1t42+4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iEJ2ESN0IDzLh2QKXeAyfL1PqvLQQSVxWqyYk02Munw=;
 b=iTUvnJsXyYtMbghpJZElZD+BZ9XGzrnDSvppHKpoJRqGnrcFiVYv1I9r64jRi67JHq7rSME+4SAGmDHBQ95AECV0t6rQI4A6mjid8xhD+ryYHLv1PTTM7WvnP+/OQWQgH3XzCMUyzE/zzLqLcb2VjeRGI8HV6AdDVezk92WR1xg=
Received: from MWHPR18MB1421.namprd18.prod.outlook.com (2603:10b6:320:2a::23)
 by MW3PR18MB3691.namprd18.prod.outlook.com (2603:10b6:303:5a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.27; Sun, 7 Feb
 2021 15:22:24 +0000
Received: from MWHPR18MB1421.namprd18.prod.outlook.com
 ([fe80::25eb:fce2:fba7:327d]) by MWHPR18MB1421.namprd18.prod.outlook.com
 ([fe80::25eb:fce2:fba7:327d%4]) with mapi id 15.20.3825.030; Sun, 7 Feb 2021
 15:22:24 +0000
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
Thread-Index: Adb9XdvVHdYITZIbTM6ovKwCtI7DnA==
Date:   Sun, 7 Feb 2021 15:22:23 +0000
Message-ID: <MWHPR18MB1421C5D4CA279B980DC8CFEFDEB09@MWHPR18MB1421.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [117.207.113.225]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f4c1bb23-0bac-43fe-6e5d-08d8cb7c2b8f
x-ms-traffictypediagnostic: MW3PR18MB3691:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR18MB3691F345641A49EA2335BB77DEB09@MW3PR18MB3691.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2U7SvZuEAqnwWdNXCOD14tMU4ux9K1yBvjAeL+mwNTdj3UITDNN7aDY2CMnARjzTSISf1tQNB5XYtaoFicorHLpPfYVHTzshFJvxoC74bljhYt6+LQUvc+LEKtUagyuET3RBXt3RxQp0XBzYnDwsEV8+WPMcswcceUGTpDVG+L0iRLRvJ+GQXdBiXKqOCkr/uuaQMMwGOmyHnvmt9PvOQBMmDXnVrFnPACsXg51IjbABvIYwfu9Il9OPZu8I2wYJ2PWTYyjCZTU+RqXdQsiYEbqcZCZ65kucGla7NShPLxHKIuPRuG6Eagb/Q+dtJkun73bKRC1XXCYK40QMt7yXQp3uPJSFe5NbHjb02mZ6lPWU+oePt90Y27PLLeIcwQCJ4d1FHCNXMhSPSdGoP+rVzTdWksyNOzgmqaagv3NJbyB9zQa4zXehmhHVJ4QaBju4riyvzl8r0KchrS6ont90d1sshV2BupqLi8hlhwM6XWYdu62RTHZxOU51s7E+B/x4zC3OLBhXFNwqJ7USuQYmow==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR18MB1421.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(39850400004)(366004)(136003)(346002)(6506007)(54906003)(8676002)(83380400001)(107886003)(26005)(53546011)(186003)(66446008)(8936002)(66946007)(4326008)(64756008)(66556008)(66476007)(86362001)(478600001)(316002)(76116006)(7696005)(9686003)(55016002)(33656002)(71200400001)(52536014)(6916009)(2906002)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?bL6HPtIhFICRL21eyebc+iOV1rNLGhV2OgwFQD4zMJi60KhiqJBlAF3Gse/U?=
 =?us-ascii?Q?1RjHyGeb0/C3OuGHdSF9OSVMrity9A56KQp9lQtKk0flz9QvT4/klcZR93F2?=
 =?us-ascii?Q?Z1pbNaEdtYtomU9lO3YnU0hHd+N1aPtxwKcKAOWRM4aThkPXVJwMJTqxEgx9?=
 =?us-ascii?Q?F70cNfXP+B8DeCQE95WZuAV0FltMQMA+YxgNNb4gAWGulzUl2ZOStaqcp44d?=
 =?us-ascii?Q?PFf0VR9GtBC8IE0/vDYIGWx1UDtLV6ZAkB3YIUV2MmLnRF3Cekx6kVF/VSWK?=
 =?us-ascii?Q?KYtQQPPtt2uB1vFq291BB8jIBsSghmvbcwvRmhgM3p7+zFYRByT4NOhxQnEP?=
 =?us-ascii?Q?gpT/8+Tg1gWq0ZRRA80KCqPiQ6RjiBk5ohjbCU0UdH5RiUbkT89rLdVGyzeM?=
 =?us-ascii?Q?vKiVIN+cpLfJ4tqiEF2l+XRoApLrFDD6hY1Sim7JcmMFLnksMGulMCyqFGA7?=
 =?us-ascii?Q?L5rqMrfD+1tgYbCkBwjJflcx73yQH66TWBmHtwRJinE2vKCYDZDPzewgVLI1?=
 =?us-ascii?Q?xhEqHIJ/dMWw8ACNgXIqvelM98GjrAguT/oUS1Mv80a3LiyGF2ehWYFtgDnT?=
 =?us-ascii?Q?PyRT53SqUrDhquk+SpWmPSPJbOVhqGSzlWfb69BiE4B3oY+hTSXxQoJE4PI0?=
 =?us-ascii?Q?pDoO7NxAeCqajZZl+ngyRBYb3Gl1Wsb+JdLVTmkPv+ENTvykpwadzwu0UtZ4?=
 =?us-ascii?Q?btvkv3b4dPyQsWj/WVSBKIgBO506ZDGLNZ3sBT1+SkHznTCWyxmnr9Myy1n0?=
 =?us-ascii?Q?tmVGN44uHD7qG2Ib8cd7/ogxvYMA6m5XohMlt9DgMYcjkzFMKkBm6H64mvj5?=
 =?us-ascii?Q?+uLeFkozLSGhCMO3zVKqyCiSyMRJLLfKqcH9Dvoye+AMC0htnhqdxLTKq7UB?=
 =?us-ascii?Q?7IuF7c1jLzT4EK77rlZwH6PyE2KXxquW8jr0eg9gitEEl7Op+F3MvdOpgMvk?=
 =?us-ascii?Q?1hYC0EbAOj5ZF5eC0O63io9VBVXtF1/y7cc4KwGQngLIroli6yYx2nm9Ny5K?=
 =?us-ascii?Q?Wbpzz/DEmMUZzkF0GGFX6UJB2FpJGSRfmIPsFY1gDywGqxYVD4bp0PkjIIcn?=
 =?us-ascii?Q?YajNPp2Gdqghwj6RYRwtxGQL9TWjIxJlhUAm0DFuapicVB0l2yLpR+cO/3GQ?=
 =?us-ascii?Q?VeHGRWnQ8DUuOTl5f/8oZ77CVFerCddkCTagPnPE2c/xeTAP+CZNWhO7KUfq?=
 =?us-ascii?Q?kfcnxyvrMu8gA1CkDEdUA9GTP3G8AnLY3z80EpRktqFw4lnXGNkDJTTDDhEC?=
 =?us-ascii?Q?F7fBK1UlCeDaCRTUfxny7o9QZ9r94k725RZhFaMRb80O6G46y2IHU1vElNrf?=
 =?us-ascii?Q?/7jpbVb9OWxxuUjco4chfc6s?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR18MB1421.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4c1bb23-0bac-43fe-6e5d-08d8cb7c2b8f
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2021 15:22:23.7889
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IWCvVCYlkxBOvFJOYUrVbvLdNyizcPVjKbKX5/ifLCpleOJr3TtdGkGvqCii+f+L7wekNGW3b5TfqABIZM5/xQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR18MB3691
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-07_07:2021-02-05,2021-02-07 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Saturday, February 6, 2021 12:56 AM
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
> On Fri, 5 Feb 2021 14:15:01 +0000 Hariprasad Kelam wrote:
> > > > Will add multi advertised mode support in near future.
> > >
> > > Looking at patch 6 it seems like the get side already supports
> > > multiple modes, although the example output only lists supported no
> advertised.
> > >
> > > Is the device actually doing IEEE autoneg or just configures the
> > > speed, lanes etc. according to the link mode selected?
> >
> > Device supports IEEE autoneg mode. Agreed get_link_ksetting returns
> multiple modes .
> > But set side  firmware code designed in such way that  it handles
> > single mode. Upon Successful configuration firmware updates advertised
> > modes to shared memory  such that kernel will read and updates to
> ethtool.
>=20
> It needs to be symmetric, get needs to reflect what set specified.

Agreed.  Even though set supports single mode still it is displayed with ge=
t link settings.

Thanks,
Hariprasad k
