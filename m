Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C286C2D4322
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 14:24:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732121AbgLINXB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 08:23:01 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:57514 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729730AbgLINXB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 08:23:01 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0B9DKN4p028382;
        Wed, 9 Dec 2020 05:22:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=cR0TNpK8c83uzuaTZOSw7eHcvHtpB+9Imyz30AishlU=;
 b=Qp89NJ99u/erSo0MtOK1jMW21tA6Sq7+GYg98iaeb1A49/kvIYLC4tt9HbXJbMFP8DFq
 e71BowZJUvO529bseOXvkM6uji3/loyMNM4eGIXbgXHLstwVBV8jueGIJNiboozGLza9
 9IAK1FGBd74A/8gwuym61ZotrARBPQ3hwENifnBY41lZrLcS6d6KSLhqw5wt+eLApw3i
 XavDe90ijtRHcFpyz5mPUbjTj0fRlelity317cPnuIIvUSS3+5NSZcpnOxjEs7eFOJK8
 UzGtdf1X+YSFaFfTNA9R8Jkc5z1pJ8gLxyv4mD+Nl7oM/ihBmHrxr942KM34lA6UFw40 sw== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 358akrbdnx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 09 Dec 2020 05:22:14 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 9 Dec
 2020 05:22:12 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Wed, 9 Dec 2020 05:22:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YhAPwwkOe8J3lYWp6S0r+yB8ss6QLAYju/mE483IuuXG4AfKao8j6Xw7srkW42cSN2LMAlL/LeabScediNNsqdvVtItkWngmVr7enQ5ozqCLSmChA0LDKP0zrn4IdI4ujD6XBWrdAC4zBnhYsZo1xEH9Zbjys8IFqZykwwI9Qpb5QT3u580rPQdhi0PCks/e+pCI+1EEecl/dfaSTiKtshAonfDy03RoDgZ6w9iET58QZUwIfd4RzFUAQVe6axlTNZ2o0eqQBedCTIynXk6zB0j8oC4eZS7htEdnHuAmRbJ10U0JLcpe5K1+sEwdN/6KODIeDC0LbjHSc6bs6xaMXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cR0TNpK8c83uzuaTZOSw7eHcvHtpB+9Imyz30AishlU=;
 b=WVuMxPkJMFj/UUUrSOWoafitrsG74AsUFZI0+1By4RVmdvn/hhmwcyiqUkHQbaZfZa2cqgHA8JaRXL6/elLxKUz9C3ST+nWLZNHMH4KJTzRlCyyHpToiybb4hfh5OJFptTlBHKXIbwQ/RqmjdcE+kanQ3q8avroVhVlb5QS3n+SH0ve+e/ZeRJ8voSZcJrd6feRHUkQOPyUXUZUOJKvvdM6JjJR7cIwn/bw9t1jWMjbfPGOCSrEvyH5j69cxo2v7jwhs+Kl7KOz7M3xiCrQH1IJdsS4x+FkrlJQ9KNE4FroSf2rx3oifeOmZR1r+hB0kA1Zqn3Pchu37TniCxekzzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cR0TNpK8c83uzuaTZOSw7eHcvHtpB+9Imyz30AishlU=;
 b=lBKJwmn8axAoIajE/sFmhQuN4tcPlPnKHlr/9BDDLv9aXDkC563a6CWbDCGKt6AcDEYjE8wgFjRad9m55DQs8lhwYzaXa76ovQjAfRaXjSoeXum4Z0hmy4TbzJkXOnxrvdgeI5FIel33ulDxAHT77Oj2W57y42EtP2qgAWjaVpw=
Received: from BN6PR18MB1587.namprd18.prod.outlook.com (2603:10b6:404:129::18)
 by BN6PR1801MB1939.namprd18.prod.outlook.com (2603:10b6:405:6c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.22; Wed, 9 Dec
 2020 13:22:09 +0000
Received: from BN6PR18MB1587.namprd18.prod.outlook.com
 ([fe80::7d88:7c97:70dc:ddc9]) by BN6PR18MB1587.namprd18.prod.outlook.com
 ([fe80::7d88:7c97:70dc:ddc9%10]) with mapi id 15.20.3632.023; Wed, 9 Dec 2020
 13:22:09 +0000
From:   Mickey Rachamim <mickeyr@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Vadym Kochan [C]" <vkochan@marvell.com>,
        "Taras Chornyi [C]" <tchornyi@marvell.com>
Subject: RE: [EXT] Re: [PATCH v2] MAINTAINERS: Add entry for Marvell Prestera
 Ethernet Switch driver
Thread-Topic: [EXT] Re: [PATCH v2] MAINTAINERS: Add entry for Marvell Prestera
 Ethernet Switch driver
Thread-Index: AQHWyyYV4P4pQ1rY10yROtXpmQsQsqnsWDCAgACYJDCAAHq2gIAAJoqAgAEdnzA=
Date:   Wed, 9 Dec 2020 13:22:09 +0000
Message-ID: <BN6PR18MB158771FD8335348CB75D4D92BACC0@BN6PR18MB1587.namprd18.prod.outlook.com>
References: <20201205164300.28581-1-mickeyr@marvell.com>
        <20201207161533.7f68fd7f@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <BN6PR18MB158772742FFF0A17D023F591BACD0@BN6PR18MB1587.namprd18.prod.outlook.com>
        <20201208083917.0db80132@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <20201208105713.6c95830b@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201208105713.6c95830b@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [109.186.111.41]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0a43d8b8-f79b-4ccb-424b-08d89c456e6c
x-ms-traffictypediagnostic: BN6PR1801MB1939:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR1801MB1939B54E75F2E7AEA995BEEEBACC0@BN6PR1801MB1939.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: x+bxlwA4J9L4mFhF/owWM0coLbSr2ZqvLKUvbNrRvbS0pu5fJQxs00q/KoA8DnBwHUN6uAtwp7aCk+rBWG5N9Tbz2o3/iMvZkZ6IgGnlUPRSUuqm0W64xISpwlRUZEQEOWjU7942AgFMGYD0oURFR/wAw5DVGcuRo4f6eqzCW1Dbb6QZNkCMFN3JADEQpeOt44LzB4DG7SIovGMZ1asTQ6VHwUlz5Mp5lh2nGNMx38vYe79u/XXsOr987zFIjKGe4R0LeiKIWYx1EkXtI/kBJwYFfc03x+rugq5Fh3qMHl0WOsNaEKmfdwVkR/a/R84LK6RHYkADRQSgsaweiuUOblYmEzsQASN45hJsBMjUkd3WUQg+TDI70iEA+AJkb0s+S4+SSZQvC7KMUzuZUw4h8w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR18MB1587.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(346002)(136003)(76116006)(33656002)(66476007)(83380400001)(66556008)(508600001)(2906002)(55016002)(4326008)(8936002)(5660300002)(26005)(64756008)(71200400001)(9686003)(6506007)(107886003)(52536014)(966005)(54906003)(6916009)(66946007)(86362001)(186003)(7696005)(66446008)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?MQWj0mnF5DkwdC1QwsNzw8epn2KCFZ9S+n5gqQ7c5P8JY6QbM9BjSJi9Q6nX?=
 =?us-ascii?Q?2nATQwkjeUP76ey2USegfRtyFVctItBnVI+39YdyFmYhsRb7wHx5lHJJKt6M?=
 =?us-ascii?Q?uX849DMeRGkaZpwK3MA1Gds3yrRGiF2pAEuzN6oOUPMvnfwgL90B4wQQBMBb?=
 =?us-ascii?Q?I4Q2PiQW5+z3Vz0Psod5re03hS9y9KTCVHIYh4k+UwezivRy2bEywx90KbC5?=
 =?us-ascii?Q?X2UAGljPiTYGXRMHr0TOR8rM4hovYSePqy7dFL8xCWlsk2DAwTBtBQQYRSnP?=
 =?us-ascii?Q?r4cFTHlsYBcmhZQBu1reTOobCl2xwWPjei8ZA80H9P8N1V7S5Br/iDB7oic1?=
 =?us-ascii?Q?PhxMhQveD7TzJy593/+pHBoPwrdqsfHhUXpjWoqEoXZTqOjwkXIvNh2YXBXx?=
 =?us-ascii?Q?BQ7PUO3HQ6va0k8ZfPgCQhpcTD4E/YnSA5LYJ+3/czj6EbJRKKJfCmWXyxvt?=
 =?us-ascii?Q?WG82Nug/rO6ULbLAxWc4p5IY2Kwewc/3jKVaOgtt8h1t+XiRItUWy0ciFXiY?=
 =?us-ascii?Q?V47Ikwrxcu2Vdl6AXgG0pK0ILQSG7/6FFMhsG0VmDR1FXWOaOT3L3MXQXBOC?=
 =?us-ascii?Q?g7dfATSswpbc1lJ8te4tPGzn9PPc5sf+Mr3lWHAR66jNXtS2ob84jvEPsNi/?=
 =?us-ascii?Q?WWIeq2siUFsHTX377kqfaoApxOuOCJ9hnEf5D+p9nG8QjNpnKMFQvrnuY6Ch?=
 =?us-ascii?Q?5MH9RZ3PS9E6XgSwFe3w+acll6JZQKS23UxHj0tm7nGux6Kg0NCArIpeFeLK?=
 =?us-ascii?Q?7mkH/BVt/DyPlXkT7W2syzY9wTmE1Ilu93V/YiTO7nZpe+mRjkwvv9MgMsBm?=
 =?us-ascii?Q?0jvBfy4QKhW7OgeBnv6kZgpSVZroNsgZfoSY2FCvyV09zs37ZAoHCP06Y3Yy?=
 =?us-ascii?Q?HLUvV0t8kX+y07BHTzF1XpgwLUJkVyUvBAT2CJbyBl+YVjq2uXbBWxNWDwBd?=
 =?us-ascii?Q?C7b0QvJYK+5qY4cmDRz7XF9AIDPdV7/z3aJ5MiG1csQ=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR18MB1587.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a43d8b8-f79b-4ccb-424b-08d89c456e6c
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2020 13:22:09.1200
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fA53CwZOKEkHK4Y1CTryrbad7fUdaHVWONXwr8lvoh/8ndE352N3e17tviEBHWFQqHEuY6IT69jjhxE3Cta+EQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1801MB1939
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-09_11:2020-12-09,2020-12-09 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Tue, 8 Dec 2020 08:39:17 -0800 Jakub Kicinski wrote:
> > On Tue, 8 Dec 2020 09:22:52 +0000 Mickey Rachamim wrote:
> > > > > +S:	Supported
> > > > > +W:	http://www.marvell.com   =20
> > > >=20
> > > > The website entry is for a project-specific website. If you have a =
link to a site with open resources about the chips/driver that'd be great, =
otherwise please drop it. Also https is expected these days ;)   =20
> > >=20
> > > Can I placed here the Github project link?
> > > https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__github.com_Mar=
vell-2Dswitching_switchdev-2Dprestera&d=3DDwICAg&c=3DnKjWec2b6R0mOyPaz7xtfQ=
&r=3DUAkJRZWLEQnvkxZocwDW_EHhLuSp0So-iW__5LY5cr0&m=3DC_hG62w12Ol2aD-_5LJD1m=
YiSoQbGu7kv6oNTq8fMNY&s=3DjTvnRmsmtay1Vvp23V8G4qO2QWjxGCOcRl8V1v78jiM&e=3D =
 =20
> >=20
> > Yes!
>=20
> Actually, what's the relationship of the code in this repo with the upstr=
eam code? Is this your queue of changes you plan to upstream?
> The lack of commit history is suspicious.

You can see that only yesterday (Dec 8th) we had the first official merge o=
n this repo - this is the reason for the lack of commits.
Marvell Switching group took strategic decision to open some aspects of the=
 Prestera family devices with the Open Source community and this is the fir=
st step.=20
As you realized - it will be used as a queue for all the features targeted =
to be upstreamed.
New features are expected to be sent to net-next very soon. (Like ACL/LAG/L=
LDP etc...)

