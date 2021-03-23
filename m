Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35287346852
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 20:00:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232827AbhCWTAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 15:00:20 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:4608 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232406AbhCWS7v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 14:59:51 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12NInO5g011896;
        Tue, 23 Mar 2021 11:59:41 -0700
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by mx0b-0016f401.pphosted.com with ESMTP id 37dgjp22gh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Mar 2021 11:59:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=npTbpfud9VT5D0h1mEnq6GVJLdMELE5T8Ffytyxu5vOVKTvJk6m+ZVjCfEvv2IHVAU2Jz0tjMH3arRO7recxh0gMLC0f12VNjrPkEHYY0VhjHl7i/MZH05NKaEqKedU3cZ/NkQM+f73EQJlUvTvGbh5H2WurdH0Je1FJ2R+gowoY6A1tv8Lnt2JrZygp7uHPskUZOy3yFivKSqSZnvwsbbF87RQ5lCFwRlc4x1Sp7MSXffyYCWVGGYIixyKD3qc8DSJ6/xlEqjf/z0wcH7gSzrom/R0BsuHs9xPe9Ph4QQ122eC/VMwZtXupPcPE8VtH9/ROn+4JlUE7/Q6wwcquig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TvH+HoilfUUg4eRNii+KPELvvzfjFB5SIduHk3j2xRc=;
 b=BbUg7PX2lhLeRF6N6PXyhs3mon2gPKMqaoakCXxfyw3jE6tgxjdAIuIDDx79RQ934WG5j4dAXh1OxKTlZGUv9wtaD1UplpCdAxrwGBe5CjXOYAqAUgpepaJEWohUlTzzE5jyGYG4d7LWfmMPmjVdFXRNB8ujO71xdYH7tEy2mCXt1iAzgnMCXBUPMZosT78QAWzLnPf2vCktlGljHojMTSS9NGC0jovSgBGutZQtAK/SmqbQgErhkUtMoV9NZ+Csb+n4Ri6FDelvilfIGRPlElx4ljT11wXOEKT+8+UL2yn5NxMD5H/QrH3QIELx5YOoPBxA4LwsTQ1QFf11vfZ2Gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TvH+HoilfUUg4eRNii+KPELvvzfjFB5SIduHk3j2xRc=;
 b=ZfNk4i4DpfVzxZx+jWro8s/TIS2Y2/6axOg+De2JJrr9wR/1hbv9p3K6H90RGa/1UHDJq2jlQ86afFCmHtKH1pCJcQYpiYxIhWv+iuUiSpl3OXBY0VK+3tjEfmCjfUE9yuRiTZ4VD0Mu5DjH2ivHYu0OXubveIS5L5u5tsJXx4o=
Received: from MWHPR18MB1421.namprd18.prod.outlook.com (2603:10b6:320:2a::23)
 by MW3PR18MB3673.namprd18.prod.outlook.com (2603:10b6:303:57::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Tue, 23 Mar
 2021 18:59:39 +0000
Received: from MWHPR18MB1421.namprd18.prod.outlook.com
 ([fe80::c00:81ae:5662:e601]) by MWHPR18MB1421.namprd18.prod.outlook.com
 ([fe80::c00:81ae:5662:e601%8]) with mapi id 15.20.3955.027; Tue, 23 Mar 2021
 18:59:39 +0000
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>
Subject: Re: [net-next PATCH 2/8] octeontx2-pf: Add ethtool priv flag to
 control PAM4 on/off
Thread-Topic: [net-next PATCH 2/8] octeontx2-pf: Add ethtool priv flag to
 control PAM4 on/off
Thread-Index: AdcgEF1FcfWijR+8S5qGD0z4+6AE5Q==
Date:   Tue, 23 Mar 2021 18:59:39 +0000
Message-ID: <MWHPR18MB14214BF3FE4059554CDA2A16DE649@MWHPR18MB1421.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [106.217.192.77]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7ac7bf0b-072c-4e5f-4b51-08d8ee2dcf96
x-ms-traffictypediagnostic: MW3PR18MB3673:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR18MB3673C8F5E091296FA1F489FBDE649@MW3PR18MB3673.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JjS398sqhXHArWrt8EYxtz48jlJiP5ubI3d6J1332r7I3WhA1ZJ0Y4uZJGrjULkRJJ6xAAxeDCNfmeOrJhlQ9G19oHfmmotp3oHGp0YMo2F09WvGnM2qlGAjAVjkSzwe4kosxRcmQAln5sF+0kDC//8ECX23Ji2nUlELa/cd0f0oCDcZg2KtDys8zYOPsNfqTH0O2j8HGpDzvOXyDNPC0o9NlXgEID/S41oDePKknUgVTW0pV7qlbuoGQ20QbpyH2z57eOLiAU8cRVO007ia3h4TCZEUjv7WvpIptl4QwwT3SLCI4PDzqc95l1LBlFx/fIFagRAqXjm9iPd+xICpuF6wgvYF590oA0yqckr7gQYJpVTXnUsED9OTX6ieaF5Y0kA4JuVFXvYi+lgH0sskuRzbqdui0w457QnbI6P5UTPnoc5XbKUK0l8fcjUO/nCqdxWU+WffWT9x+OopX+IpC6Hxv8qL5fM9zfj3ROGhfW/OiiKA5KBsD23xSpgaEOvXE+1hg8gJFPe9yXzJvHpuQtmXEYJKXxOz5mjg0IbEkJkDmlcavPF2qdopwME7C2n+4o8rQbfFMCqfbiIem87DZF3mtftzb/YjC610XivVDlByn+4r+mWBeQXNXp/YtsYZMrng8U9brHI/jKKeZaXgBG+6hIOZXOlFjOVHWReSPSI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR18MB1421.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(396003)(346002)(366004)(39850400004)(66476007)(2906002)(66446008)(5660300002)(55016002)(4326008)(66556008)(83380400001)(8936002)(52536014)(186003)(86362001)(53546011)(316002)(26005)(38100700001)(6506007)(64756008)(71200400001)(8676002)(7696005)(478600001)(33656002)(9686003)(54906003)(76116006)(6916009)(66946007)(107886003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?iEp1pZuJif4/4oKQwuEJ/a4SDKeLL5XvwZLrowZUDMCekSDvUByfQ+EajgI3?=
 =?us-ascii?Q?pLjgTybaDZRhm9FzDbAlS/uQR5gy/9yXtfSj8cjD+oIWSUGPfV4hjhGdRLZN?=
 =?us-ascii?Q?kQjCCVg0fMV6AnSnrugW3pqSq4fgzIpJUR6vsNe+dJqwWiJapzoAL11JuQXw?=
 =?us-ascii?Q?RfSILIN3QRwnxYJX9eN/Lwn0VDJzo8h9MW75FzT99qnzlUMaPROY2IMeGjm2?=
 =?us-ascii?Q?Yo0LvfqDt/gXJsJIUHjRFu79+uh0Vf8wTtnfLy9cij3vVrZf+I0yrjIMLNFV?=
 =?us-ascii?Q?ooFDU58iAb2Z6Bbph+oX96nNn4TMl2NOewLB7+9SaT6GAoeGhLPHlzSVRxQr?=
 =?us-ascii?Q?HtG78OCQqPZwIE3sw9pmpFQTPnFB9WOjB6wEGUvkSUnZI697SiMuesmonRBB?=
 =?us-ascii?Q?DZCCMJ5KmzihbWc+bRjauuZUDGVtwMEQlILkgbrvBeoz5iG8yxkP0rvj4AOj?=
 =?us-ascii?Q?WDk1zACCdQ6qHUDMpf7oO5JEA2eGTpgcml+GD22fvjFSTz/TK0TU6ICA0c6b?=
 =?us-ascii?Q?UFGhFNyqETDZWeDME4JrP3V2gGeYkxEqvLBgWq+aYU2Qo2TXX3SYxLBdG77W?=
 =?us-ascii?Q?2NVyJyqImDybKZPHLpcqkocY4E4gCOANjbEZMnvsn0zcpx0C6E2N8+kNX7ll?=
 =?us-ascii?Q?mtxD8KzF1gzTtLaGWpbj3TrDah0mT26VAAbw/1RbM2/Hm9YV6PLdn0bUpAhe?=
 =?us-ascii?Q?RymZ5I1PZeeTT+tTb/Ub/qFtR+7PjoZJWkTWg1Brbgdw3nBN7lfpU8xQmOB7?=
 =?us-ascii?Q?FhpiMqPzekDK3e+8yT3xlKQ2E3OqyeeAv/NHhXuOTkqFixASisneZhN+cpVZ?=
 =?us-ascii?Q?c1V41QLCzvAIuikEkiaXd7S9u2dlLNjmVFYSiuZA4pavx0VlwcwbJHzTt+kj?=
 =?us-ascii?Q?6UeZoHVC81q7lbySI9TRALT8niKGg1t/GpU+fADF7rd8TUX7by0XfrXpdX7p?=
 =?us-ascii?Q?UPAKUrLAb5aCo1zBNBCWlf/0Upf/YjC73lXs7emUNwH5ukyND4d9nZ1H6HyL?=
 =?us-ascii?Q?3mVkrR1A93qkNqADkM6T5jjcJr6+rO54Fah6IIQM7deJPAol6w5olafg34oy?=
 =?us-ascii?Q?wKmy+tWzxFWjC8E6ojhqIJ7PsXk59uVVAM/W9D1uGe2suePuhPrdiNb6Lr+v?=
 =?us-ascii?Q?/xWnlrVV3BTQn4eA5Cxr/KIcH6v3YVivEDmbmm2SyU97UnOfCAK7UBZ25tLL?=
 =?us-ascii?Q?W1X/2fLO56Upzj0JEc9YghCOLobypL4ugBDErwqCF+Cy2WlLdQ/OosTSYaDM?=
 =?us-ascii?Q?Hg7LY+6TFLBF0FWAenWWZ3U99je16At6eLasMAScD92vQ/qTKu4MKAm/5sRR?=
 =?us-ascii?Q?NlGEM4H2/0eI6Oq/r/fXt2pz?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR18MB1421.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ac7bf0b-072c-4e5f-4b51-08d8ee2dcf96
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Mar 2021 18:59:39.4658
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JtAewUvZcmxdq/YjZwv4nkfFm1Op+lOJCb3fJnzblOCKY9q9AcT4AZ1z0YieQBCHO3iZMoXzDCNw3DD1X+k9Aw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR18MB3673
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-23_09:2021-03-23,2021-03-23 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

Please see inline,

> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Sunday, March 21, 2021 7:58 PM
> To: Hariprasad Kelam <hkelam@marvell.com>
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; kuba@kernel.org=
;
> davem@davemloft.net; Sunil Kovvuri Goutham <sgoutham@marvell.com>;
> Linu Cherian <lcherian@marvell.com>; Geethasowjanya Akula
> <gakula@marvell.com>; Jerin Jacob Kollanukkaran <jerinj@marvell.com>;
> Subbaraya Sundeep Bhatta <sbhatta@marvell.com>
> Subject:  Re: [net-next PATCH 2/8] octeontx2-pf: Add ethtool priv flag to
> control PAM4 on/off
>=20
> On Sun, Mar 21, 2021 at 05:39:52PM +0530, Hariprasad Kelam wrote:
> > From: Felix Manlunas <fmanlunas@marvell.com>
> >
> > For PHYs that support changing modulation type (NRZ or PAM4), enable
> > these
> > commands:
> >
> >         ethtool --set-priv-flags  ethX pam4 on
> >         ethtool --set-priv-flags  ethX pam4 off    # means NRZ modulati=
on
> >         ethtool --show-priv-flags ethX
>=20
> Why is this not derived from the link mode? How do other Vendors support
> this in their high speed MAC/PHY combinations.
>=20
> Please stop using priv flags like this. This is not a Marvell specific pr=
oblem.
> Any high speed MAC/PHY combination is going to need some way to
> configure this. So please think about the best generic solution.
>=20
> This combined with your DSA changes give me a bad feeling. It seems like =
you
> are just trying to dump your SDK features into the kernel, without proper=
ly
> integrating the features in a vendor neutral way.
>=20

Thanks for your suggestion .  Will try to evaluate this can be achieved thr=
ough link mode or any generic solution.
Will try to submit his feature as a separate patch.

Thanks,
Hariprasad k
> 	Andrew
