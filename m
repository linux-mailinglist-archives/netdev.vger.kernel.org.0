Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A93231AFD4
	for <lists+netdev@lfdr.de>; Sun, 14 Feb 2021 10:22:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbhBNJVw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Feb 2021 04:21:52 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:20142 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229528AbhBNJVq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Feb 2021 04:21:46 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11E9Grir032054;
        Sun, 14 Feb 2021 01:20:46 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=tRmAjHb5Mb5gN+msBFpNKJln6/xsEXGcPtHSl28PPfg=;
 b=lSz9UEktxdKeJqvuQ5Epm3dhry6JIWqJvo7vErcQB1Q3Gc67Tqt/fDsL0OwK6fOcEDQr
 QCbhGagNwYqD+NH6SY+KHCVmoB7E1/kso0Go5fiWIaVfapPBJsd+tjxHGKldiYK8Gb2U
 RlouwWpTtjurgiJgntUPc9+jB03AqTjCBugf6lGYbBVbnBEVnEAW9Xpi4LSq8Ax01Us3
 64E8Tvfe4WzgWdzUmmeRB+eyFP3bnVCE4c8G8skbCo/I9H1VCSJkrr1Pa4cegXrve9UM
 BCb4C4L5O4IxfB99+/L2F5ND9M0aNFUG34xWoE9rXdujLOBn7s4FDu9UR9cL8xYF0y11 NQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 36pd0vhm0c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 14 Feb 2021 01:20:46 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 14 Feb
 2021 01:20:44 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 14 Feb
 2021 01:20:44 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by DC5-EXCH02.marvell.com (10.69.176.39) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sun, 14 Feb 2021 01:20:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NLsneREWNsKW/P6nUXDdrJcOLFvoeywPLDNDo4NdZqfV7aJndrOXjv+M5BFrRWCNBvuwsdrXNEOX4TqLsML0s0JfyH9wmxuF5lYPbnBZPNGAuNvnNhAWHl44ljjEA89Fls4UgvVA4+kdae9qMRhXE8t0A5NM104mQZt0+9bok2k0+xYKXv9Bq0D2b5IFiz147U0PQ5g0e+r96djQ6Tqquwfz4C8GwrEOMbLOb0Hq011A/c/KF+BBI6kSDELeVL1dkbhkn+/Wr76OQocTLNDncda98U/zffR5B9NnvpyfkzS40ed7MRXMrUl9hxD6DuZj13Pgee484wGuv1ut26r81g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tRmAjHb5Mb5gN+msBFpNKJln6/xsEXGcPtHSl28PPfg=;
 b=alaovPVI4d1DlbFq97hEHy5CVP9cmQJxqXwrqD28eL6d4kQxviQAaakcc9OMVfQxOJBrDLWPVt6SievhPw7Q0SFkHo+uUsiQXBiNDOStick3sxtKoDzZV7qoLQeRCHonYpWIKUsoTxkUThAqzYaysbMTNUQ5WIY2pK15/g/MibfPcqx+ZaAFUzMd5R2yLYu5fC7NAh+qNqzKcox1Gd2M7y5ipbQL7OIwonbceomQNgIDcqKE5Kp9Sm+sjYvpYkIvfErJnyqK1K+KnTdsfyeF7+KTQ7u3Z9+hLQ0ETDG3DTbBBTONMv1awxsF0aqABFoQWhQdZtFC3DGRm+dntrmtvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tRmAjHb5Mb5gN+msBFpNKJln6/xsEXGcPtHSl28PPfg=;
 b=ZlxhoiS3rRO9pUb6rAMMiS5awrrvz7RgXdM5pzT0mQ6JnWSDTtZeZwis1YJswGFyNfakKPCR4cGQ6RKjR2RM2x036zI+uo4ulMuEnDbpvn5J1yn6eZkcDShzQci/BQ4HJfGyG5k6e7hO8mhart2iguBmkpRuS2Ualhw7PrdKwAs=
Received: from CO6PR18MB3873.namprd18.prod.outlook.com (2603:10b6:5:350::23)
 by MW3PR18MB3596.namprd18.prod.outlook.com (2603:10b6:303:5a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25; Sun, 14 Feb
 2021 09:20:43 +0000
Received: from CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::c041:1c61:e57:349a]) by CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::c041:1c61:e57:349a%3]) with mapi id 15.20.3846.038; Sun, 14 Feb 2021
 09:20:43 +0000
From:   Stefan Chulski <stefanc@marvell.com>
To:     Andrew Lunn <andrew@lunn.ch>, Marcin Wojtas <mw@semihalf.com>
CC:     David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        Nadav Haklai <nadavh@marvell.com>,
        "Yan Markman" <ymarkman@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
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
Thread-Index: AQHW/5KjZ/qb5CtVhkWHSjiCzfBYLqpSCfwAgACUjBCAAGQcgIAAUiYAgAE4xwCAAtBfYA==
Date:   Sun, 14 Feb 2021 09:20:43 +0000
Message-ID: <CO6PR18MB3873E319FA08ADBC3B682828B0899@CO6PR18MB3873.namprd18.prod.outlook.com>
References: <1612950500-9682-1-git-send-email-stefanc@marvell.com>
 <1612950500-9682-13-git-send-email-stefanc@marvell.com>
 <20210210.152924.767175240247395907.davem@davemloft.net>
 <CO6PR18MB3873D8B7BE3AE28A1407C05BB08C9@CO6PR18MB3873.namprd18.prod.outlook.com>
 <YCU864+AH6UioNwQ@lunn.ch>
 <CAPv3WKd48fiZmdnP+NN_FRCT1h6xmu9zO4BWAz_pgTXW2fQt9w@mail.gmail.com>
 <YCaINEHqrz2QDGJb@lunn.ch>
In-Reply-To: <YCaINEHqrz2QDGJb@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [80.230.25.16]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a0d9738f-73e1-4b21-421d-08d8d0c9cdfd
x-ms-traffictypediagnostic: MW3PR18MB3596:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR18MB3596BC21EABAD448D99C89CCB0899@MW3PR18MB3596.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Y0PkylKMDZVFnPHJXrmP5ZKKL8srjn4y4ISXzjyXGB7Bql/vLvr+9pb6UH3uGgi8lp4cCjHgHF9vLIkgkrINx2zaR32L8zrGDCnW6kDpzYXLCwf5tbZ+pfmFA3MWzSBj7R0Cfq7bbrRCI15ksghVaPL4rO8r2jERYlFFAeSb5pnuoRMITWbzD0CiNNPST9ZSAwyTfmDkoXGUd+exj71UtfV5MUDH7h3QKkK9TlewxrNFYoFZ3WBXNu21vQxybfcrogi5WsZZ/Af5sqb7uuRiwGV9WSY2WN9s+IFxzSGUUny9azYzGIZXAkNR0Yv/3PresCDX+rItNS9tsL9yCCcHTsW+0DLVUzTplooZQWoohntyQ+oWa4ntPrZpY5gb1NcdYKNgEj/2u+y90IxZ+Gt4SZ63Eaa69uuv4IsHRfOihJ6xppjP4XQApCxmovK0yKzDxOnP7T1rqnvpKbv9kvhsMtR86isyq9Rb7fCS+9s8CoIaAvL80CAr036Vfzob4BZx0+Mid7It1NDkQtoHSkChNg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB3873.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(136003)(396003)(366004)(346002)(376002)(4326008)(478600001)(66946007)(2906002)(66556008)(66446008)(8676002)(7696005)(83380400001)(66476007)(76116006)(64756008)(71200400001)(26005)(54906003)(7416002)(186003)(55016002)(52536014)(8936002)(33656002)(5660300002)(110136005)(9686003)(316002)(6506007)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?o5yKqGKoAoxYJfSwIzSnanQStAoA3THW1pGlk0CqPHVbS/8AcAcroNJFCC?=
 =?iso-8859-1?Q?5stxiNXwu2DWngcSXrTbWYM2SAojFvMJYMM3SM16XVp+goNeclahUFLTIm?=
 =?iso-8859-1?Q?jS4hSgE0BXsm7J1YiSBQuXoLAwFbUnS7DR2Z0WLX+2KfC1bQCTq7tCI7YZ?=
 =?iso-8859-1?Q?AEwSZ7N2R7DE7JR3BhkeGPXiO3n9B/Ttrf3yUQynuY//qoFA/EKcAr3dVr?=
 =?iso-8859-1?Q?NC6CvkHHet4WzBp2Q5bfnY5aAs+qe2I0kuRyBzJ48WP/bIcMGNUtWJZUrK?=
 =?iso-8859-1?Q?urZGS/TTGjugpTgm2nkTK1qd5EIsW/eZFU+Vf95RuCQhjqwyaQG/MMYM7F?=
 =?iso-8859-1?Q?6pPsVbAowo5XavkjPt/+CVXmB/bxjaGUTmU5MpnEC32hGv3mzPW6kEdUW9?=
 =?iso-8859-1?Q?Gw4rudxL7DMxOveBGRoyPhB0I+iB7gvNNXluNJMwshSX8O2W+DXmduq665?=
 =?iso-8859-1?Q?rRi49FS004k7P9WLajvBDNRuEPu7CNBY1nJsmbnJyKwY5IVQFHI7ydnOJu?=
 =?iso-8859-1?Q?a0EhbfhOMKJiNtoc8iO5+PomjlzwQEvySylBUlJ8LBd6BgdE6A+3rSGZ2I?=
 =?iso-8859-1?Q?trzjVMsbJaCruRWi4K+PNUFoQr9OBKCjsUjeuSAtjVMCSwklhTD1bUYZJ0?=
 =?iso-8859-1?Q?BLQ5a1ZkPf+yj5wnR09xXuR8d++vMqIVqwhxEUfwzFMED5XlxPEu1vkaX1?=
 =?iso-8859-1?Q?eTGyHqcDiiP292Lq11hpdDymbPtN3E4EFiXy477TPsAruD7UAPj6WOTy64?=
 =?iso-8859-1?Q?oxPyvveWzftp5GMZATm1H8pBVmh5eqeNjAiPNdBNigxxsmHY09soYmwuLD?=
 =?iso-8859-1?Q?yjBNEkwiL4Nr9hedKoejT+G9th+aW1V3nCV412eVPeKT0t5fR54PeV+UaH?=
 =?iso-8859-1?Q?vzmstJN3ybJ13kHbhQC95uyrZK2/yK7RFLrKMg7t+dSazLDkjRNp1A1RT0?=
 =?iso-8859-1?Q?6xEaHkYxdO8/IpEp0OOnnkZfIrQFdmoWpobz1sDoAPraH5Af99EgpkfkGh?=
 =?iso-8859-1?Q?TvnhYHMVZ5e3ObJ99ROnQks99jtXF6z5gHd709DNL0a0Xdm4l+qd8+NA75?=
 =?iso-8859-1?Q?6AsmrRN+ELULxp5eB/mjZKitVWBuMwlVJzT8i+8P7ih02suAPyQ/zc9/Bp?=
 =?iso-8859-1?Q?8KdIblTs+CjVEhtH9KIi/YZLvhl+mRnait1U+F79Kobkx7zxCBTfKXAFob?=
 =?iso-8859-1?Q?FOYQBIVsYj7dT+bVWhX4FQ8xw8yANTZM2ed1GPZmp4EB+jjxrMxCcnM2N/?=
 =?iso-8859-1?Q?JAtmjG74waqNVWPjYIwgcLjbbjuCEatpF6Kxs0SE0MEOlW0x9zQTzrODFY?=
 =?iso-8859-1?Q?pXt/19But2WVn40VwkTh/LIzjHe0jyFbAKkHVY20cGTZhRY=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB3873.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0d9738f-73e1-4b21-421d-08d8d0c9cdfd
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2021 09:20:43.4860
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4FPXm834ExiUr0EUP56f3PSfJkuAeNIgtUyT6aRPkRiE9WVShaluCogRSOxw1c58L7+HdaCZQ+zoe4F4YF4rIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR18MB3596
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-13_02:2021-02-12,2021-02-13 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> > > Or we have also found out, that pushing back on parameters like
> > > this, the developers goes back and looks at the code, and sometimes
> > > figures out a way to automatically do the right thing, removing the
> > > configuration knob, and just making it all simpler for the user to
> > > use.
> >
> > I think of 2 alternatives:
> > * `ethtool --set-priv-flags` - in such case there is a question if
> > switching this particular feature in runtime is a good idea.
> > * New DT/ACPI property - it is a hardware feature after all, so maybe
> > let the user decide whether to enable it on the platform description
> > level.
>=20
> Does this even need to be configurable? What is the cost of turning it on=
?
> How does having less pools affect the system? Does average latency go up?
> When would i consider an underrun actually a good thing?
>=20
> Maybe it should just be hard coded on? Or we should try to detect when
> underruns are happening a lot, and dynamically turn it on for a while?
>=20
> 	  Andrew

The cost of this change is that=A0the number of pools reduced from 16 to 8.
The current driver uses only 4pools, but some future features like QoS can =
use over 4 pools.=A0

Regards,
Stefan.=A0
