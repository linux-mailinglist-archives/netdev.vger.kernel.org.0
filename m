Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33E2F4498AE
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 16:44:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241073AbhKHPrE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 10:47:04 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:2942 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241068AbhKHPrD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 10:47:03 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1A8CWhal014057;
        Mon, 8 Nov 2021 07:44:12 -0800
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3c6uwa2t4b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Nov 2021 07:44:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GTnjRUsohZsE+rEzCZ8ttjxUOOdsojxHmHp9IVXvGZPc8A3V/Iw1VgvJllVHcr2E3GoPWkkl+LFo1qip0HfAUDAdM/UoAkx0DKDlSZDATluZnFchwj62iG6b60sEH4PB3HoN57H5iY3LWPEwjvDE1DXJzHTuHpgNst6hbxVP5M/GKBmYtIkCg7KsHTO3bHmsS5EKFf2KCQfOmPNQvs3zzvlCW2HE5rz7jUPSb6Ti9dZuYnXC6s38CZmm4mQ0YqNBMjolMhElrq+M9JZ6gfL3ii1bcMnthIeYsUwv8VHSta9DaZldhevCEZQodvCiwxUobi00FbxE2GrD5kmQr6rrfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QJ/J+I7jSbGObhuHOQ5zcACN93NR39JbudzbI3XTKoo=;
 b=Cd9ed0VcMNUgUdYliOg3zdD83WVMPKD7LOwy+CjNUeet9CkoTnBO6MvGwvJR/hperbFyoHPKHFb7b2ozqcffTnCt9gV0/bVVJ9EO7hn02IOGZClZE1tzF/OsYSpmeXJBZ4T89Gxvs0q/yJ3+R9cENtTBOecBpsLs0dWbg24TCieM2wuMj3ULxWS3PY0FGsltcpES2GrT20Ru+qqVLaTrgRMWkXSQuuMV8Doa7DRPwu9EfD4NnuNIwvxst0EdMytS95gmakPNBsEddVeujlZqwsVDNKPdf/A4dXBw4qcspoOMxm+N/zhpqaCJFbsChuhFlJ0iIzREQKwdruRCokSYzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QJ/J+I7jSbGObhuHOQ5zcACN93NR39JbudzbI3XTKoo=;
 b=lXE/KeUxPzSUugJVUFneLTdth77fUwthB36cwc7MwAq/NRArHfWm3X9yU1uu7ElvafML39ddvkc3pn3XSsci7R0XE21gNt4BUr7AEayci4vcRsub4+zaul1Kf9YeaOMHtT/mZxvZaoQbUQ0+rhSlSE2I/DPlcgclg6kKzdYu6zs=
Received: from PH0PR18MB4655.namprd18.prod.outlook.com (2603:10b6:510:c6::17)
 by PH0PR18MB4720.namprd18.prod.outlook.com (2603:10b6:510:ce::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10; Mon, 8 Nov
 2021 15:44:08 +0000
Received: from PH0PR18MB4655.namprd18.prod.outlook.com
 ([fe80::a021:da79:3858:8aae]) by PH0PR18MB4655.namprd18.prod.outlook.com
 ([fe80::a021:da79:3858:8aae%7]) with mapi id 15.20.4669.016; Mon, 8 Nov 2021
 15:44:08 +0000
From:   Ariel Elior <aelior@marvell.com>
To:     Andrew Lunn <andrew@lunn.ch>, Manish Chopra <manishc@marvell.com>
CC:     Jakub Kicinski <kuba@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Sudarsana Reddy Kalluru <skalluru@marvell.com>,
        "malin1024@gmail.com" <malin1024@gmail.com>,
        Shai Malin <smalin@marvell.com>,
        Omkar Kulkarni <okulkarni@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "GR-everest-linux-l2@marvell.com" <GR-everest-linux-l2@marvell.com>
Subject: RE: [EXT] Re: [PATCH net-next 1/2] bnx2x: Utilize firmware 7.13.20.0
Thread-Topic: [EXT] Re: [PATCH net-next 1/2] bnx2x: Utilize firmware 7.13.20.0
Thread-Index: AQHXyqEA7jl+kkKwVE2k6p2laLQP2KvlxdmAgACEIOCAAJepgIABL3BQgBF54ICAAC1VAIAAFQsw
Date:   Mon, 8 Nov 2021 15:44:07 +0000
Message-ID: <PH0PR18MB465524FFA9F75FE858918CE8C4919@PH0PR18MB4655.namprd18.prod.outlook.com>
References: <20211026193717.2657-1-manishc@marvell.com>
 <20211026140759.77dd8818@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <PH0PR18MB465598CDD29377C300C3184CC4859@PH0PR18MB4655.namprd18.prod.outlook.com>
 <20211027070341.159b15fa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <PH0PR18MB4655F97255C0E8AEF5E3FDCDC4869@PH0PR18MB4655.namprd18.prod.outlook.com>
 <BY3PR18MB4612A7CB285470543A6A3C3CAB919@BY3PR18MB4612.namprd18.prod.outlook.com>
 <YYkpxML6243IkbeK@lunn.ch>
In-Reply-To: <YYkpxML6243IkbeK@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ad18c277-d333-4422-97f4-08d9a2ce9a00
x-ms-traffictypediagnostic: PH0PR18MB4720:
x-microsoft-antispam-prvs: <PH0PR18MB47209FDED7B638C1A157E3D6C4919@PH0PR18MB4720.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VA8bLdyfrRN9syqY9Nql/Irw+7TfYuWNyYJ6KMEqNZRO0K3a1w3guacJLX6/Ob5YCjddfHEYtkvnGmm6ozaTP2HTqnypuAtWn3RX0fnSvfKqWRUeODkQVFmu23CEJsRQ8zfhKPud0zzSpRsff2GzQrmUWTkFt0XBzOQfSe3reyjBxVhh3tgUmi4ykc24Q2QqrXJmyFXNwcEDPR2TRT4sJFhJhdoIFhxXz6nWFHqsRPb3Yn6Y5YkLUUzy5ANT5a/e7Gr8R9Y0ZZKSR1vre5FrAS6EsIvHQsQWujbKi73I2UuBXs8KgyQuiH8skSaDsAdUSX+iKQIsr4kAxLwOcN8+QM/YIe2HuXDTnxfQxneeGloMjn0wVsbYSOmzPCRB+f3xA1lP3fls0bt2fq8DxiIwSPZTcpMwiDf2e7D/jf1NoBLI3Me7F7c9xVCEKKcv75zEXSxTQ8wxmFfBA+/QGnlAJDq55jBox898bzAezvBAZAYlRTfiwD3Xzn3zIPOywKD3O7g2FfNHiFWBnvQBf2kmv64vyjlg5cfNSgf6ZAmwRUIpmVwISu9G+JFKRsJ2Lbi7FXL9ss3zxnghXon0wMXsKck39nqPonRWC/wYGTzQSIzwnGq1A1+g4K05wa61guxJ+6TRoyK+ezvHhT14U2MTqqKGhdVggubSKosdB2hYdLoLOyhgKRrsq1a/8LoW7KrjiSSYqdDhriPHul51aCFZ3g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR18MB4655.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(64756008)(66556008)(66446008)(66476007)(38070700005)(6636002)(6506007)(8936002)(33656002)(5660300002)(7696005)(2906002)(186003)(53546011)(76116006)(66946007)(107886003)(8676002)(316002)(4326008)(52536014)(508600001)(9686003)(110136005)(122000001)(38100700002)(54906003)(55016002)(71200400001)(86362001)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?X/6cBJNtVKLnTl/K3xG2rC+niQrQA2UTN3ntiITNSv4D3RmhwwxY/HBaNjNw?=
 =?us-ascii?Q?Qeeqv0WLR3X5LEH7pWsD+7Yht7XtIofrfak4Mg6zBdMuFhTPxYbM8qJIywVT?=
 =?us-ascii?Q?BoCw0PFZoAPuCC9VXknvoRe0IK1/PUAfKL8Z+zJZ4InEci17o1nwYLkmo5r7?=
 =?us-ascii?Q?XLQe6KKesMN1hUqNsWDfCa8UGfC1NzgbN+Il9hxVDa3tkA7M+khWkb0iUxKL?=
 =?us-ascii?Q?DueHvfrmQ1I/J2pHi8wOn251T4RzAuJN4YxrMr8FdpSMrG9OFbCz/8AYkQEe?=
 =?us-ascii?Q?32UP0jue+iSVfBOZv0IhWEhgDrPcxZqLZQru9d5UtMpXgE7XScld2p58010l?=
 =?us-ascii?Q?nNAzVKlWbUl2+tauHBg5t36b6tIG//QKO5//Lr9ve6UwCK2snNnFSC5yezR4?=
 =?us-ascii?Q?YW31TAW+OFhPAvNpeDV030dQDdfnhUlsr/9AGlZJ/VSi5ujgxlvY1GR5SIsT?=
 =?us-ascii?Q?B2SDz/ssw0H+uiq+WjNjhQGWhMmmb9IfnZUNhiTz48Hhw97SqgQs28Ro907+?=
 =?us-ascii?Q?1h39dN9uIeg1kZ1R5vmEbpnbd0l91ndbs4wiOJV3FquKI7uNDzbC658uAV/R?=
 =?us-ascii?Q?LobaSVAd08pLIeKssPFdUibnx37/O8gT6rMumhvh05iGvu5sjVkU0rq6ZH7Y?=
 =?us-ascii?Q?c9HM7NNX8/BqdH03aRgAxoxC8HNAfvEny8snLh1FXY1A1KecsOljhapfF+21?=
 =?us-ascii?Q?WLGtUG9R7Y3CukCmdBDjVMEuvoEGJbI6vzM5GQK6DfH16gKdjpdf6iK6J8o8?=
 =?us-ascii?Q?dIz5QKBmyoQopI8PD2+aL979ZLYsVfCGPrPeGYJWiaALDigHTx+loLILHwcv?=
 =?us-ascii?Q?dgAp81jVQhF9VnTlZQ2NWFZNQxvyBqSOmUn1EJAPyTPJiUMZe5UFZaMO5aW1?=
 =?us-ascii?Q?Kujm80l3BWXWID0vtyIGxIZcIBbE6ra9RGuh3Gf9SbEdmHwHU1eaVsrLAt7e?=
 =?us-ascii?Q?Hsc2l1LY4RP+2dDQeR2f2ONZtjpV7/7x5XWpXNg2Ds687KKlv2Cp2U1nUmDN?=
 =?us-ascii?Q?wyMrVNfmdCdstKLdAHfbjavKzylUCDoe4IdCxhCJNnTK2dQpztfi8WcuyTbK?=
 =?us-ascii?Q?mL6T7fFlgcBNMCApdZ5jejRblK1Ffjd/zEFd+EjfFnjN3GdlY/xUQQVdc+jw?=
 =?us-ascii?Q?JWb2Mqiwly/exWcBcW94hRV+mp6B9NANgOcEd30+8tfgA5sfRka3lp+01+mF?=
 =?us-ascii?Q?L8YkqEkFwDCXnClppxJIEgp7m/6XOZnxYsh1QzBJ8JsvYZ8dLAPsiAo3v8xU?=
 =?us-ascii?Q?y+a9ij3Dr+2qvcceyUFCeGNJ2iM3a+5qsH2gFJAlxfJgw9J+ReMT0WmZTPoo?=
 =?us-ascii?Q?aFzj0QVL5NyX+Z0FKpuFfHHcEXyAOZ5pvdhwz0Pvodtt+G7Jz3JzIIYgLQm7?=
 =?us-ascii?Q?D4l/ayiSnGz1Xnl6RCQo1uE95/TkjY2bFdPnqNyC6UY9CoMclKCQWRdLHbDo?=
 =?us-ascii?Q?zL/fZ+w5SbFPvn3rih3fOz9vxObcFXVcyEsux1lY4yQ6aqU06buM0gTgsXqW?=
 =?us-ascii?Q?527XHn4DmQwSuT4M4V9HfowYelySThmazQ+kDpY9i/6HDNO++8glBML/6Q0Z?=
 =?us-ascii?Q?d6tDhjw3q07vDxp1mydTu2X3p1B5WcyQnj6Dvr4ezTqm5HbmoOkvCVL+LAx0?=
 =?us-ascii?Q?DKJcLK9GpfUYux/yWug1K1s=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR18MB4655.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad18c277-d333-4422-97f4-08d9a2ce9a00
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2021 15:44:07.8377
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BrEHQlUfZ49DdOk2W4mq8B7FFK/p/Gd/dP1ukuVFVabPQO546OsVMU5f4uPD9jh+LvSF0N9e4beUlJsewCBkwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR18MB4720
X-Proofpoint-ORIG-GUID: PPAeaLcU7hvwpBTOG5YQX7RURhYNWSwo
X-Proofpoint-GUID: PPAeaLcU7hvwpBTOG5YQX7RURhYNWSwo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-08_05,2021-11-08_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Monday, November 8, 2021 3:45 PM
> To: Manish Chopra <manishc@marvell.com>
> Cc: Ariel Elior <aelior@marvell.com>; Jakub Kicinski <kuba@kernel.org>; G=
reg
> KH <gregkh@linuxfoundation.org>; netdev@vger.kernel.org;
> stable@vger.kernel.org; Sudarsana Reddy Kalluru <skalluru@marvell.com>;
> malin1024@gmail.com; Shai Malin <smalin@marvell.com>; Omkar Kulkarni
> <okulkarni@marvell.com>; Nilesh Javali <njavali@marvell.com>; GR-everest-
> linux-l2@marvell.com
> Subject: Re: [EXT] Re: [PATCH net-next 1/2] bnx2x: Utilize firmware 7.13.=
20.0
>=20
> I'm i right in says, the bad firmware was introduced with:
Correct.

> commit 0a6890b9b4df89a83678eba0bee3541bcca8753c
> Author: Sudarsana Reddy Kalluru <skalluru@marvell.com>
> Date:   Mon Nov 4 21:51:09 2019 -0800
>=20
>     bnx2x: Utilize FW 7.13.15.0.
>=20
>     Commit 97a27d6d6e8d "bnx2x: Add FW 7.13.15.0" added said .bin FW to
>     linux-firmware tree. This FW addresses few important issues in the ea=
rlier
>     FW release.
>     This patch incorporates FW 7.13.15.0 in the bnx2x driver.
>=20
> And that means v5.5 through to at least 5.16 will be broken? It has
> been broken for a little under 2 years? And both 5.10 and 5.15 are
> LTS. And you don't care.You will leave them broken, even knowing that
> distribution kernels are going to use these LTS kernel?
Not Correct. We would like to solve the problem here too. But what we plan
is to push these fixes upstream and to any other distro which will take the=
m.
We did not face difficulties in the past to have the distros include the ne=
wer
FW files which the driver required.

>=20
> And you could of avoided this by not breaking the firmware ABI. Which
> you now say is actually possible. And after being broken for 2 years
> it is now time critical?
It is not correct that this would have been avoided by not Breaking the ABI=
.
The breakage was a bug introduced in the FW for SR-IOV. Having
backwards/forwards compatible ABI would not change the fact that the bug
would be there. The bug is only exposed with old VM running on new
Hypervisor, so it is not correct to say "bug was there for 2 years".
Although problem was introduced 2 years ago, it was exposed now, and now
we want to fix it. Whether the fix is done in a manner by which driver
can work with old FW file on disk or not is not related to the problem itse=
lf.

I stand by that *generally* this HW architecture is not designed for
backward/forward compatibility with regard to this FW. But it is true that =
in
this case it can be done. Numerous FW versions of this device which were al=
ready
accepted and all were non backwards compatible and all had this same issue
(updating driver mandates syncing up to latest FW tree, otherwise driver lo=
ad
gracefully fails). Since this is the last FW we are pushing for this EOLing
device it seems a bit meticulous to insist on this for this (hopefully) las=
t
version of the device FW. If community insists, we will provide it in backw=
ards
compatible manner (since it so happens that in this version it is possible)=
, but
it may take us some time to prepare that. That may increase the exposure of=
 the
SR-IOV bug to further distros which may pick up the older FW/Driver combina=
tion
in that time.
>=20
>=20
>     Andrew
