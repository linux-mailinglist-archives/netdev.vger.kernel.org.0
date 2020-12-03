Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40D942CDF01
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 20:33:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbgLCTcp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 14:32:45 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:15052 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725903AbgLCTco (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 14:32:44 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0B3JP6ts027449;
        Thu, 3 Dec 2020 11:31:59 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=JAuegpktyeB0S96idor9CS3v7ZqbhMfkKfKDrwINuNs=;
 b=XIXoCFQQ+a9qAWQreD6PYnkEzXG+m+hN6ZAqY/USIPiUlrjpmRiO3H0hUZr+HqQvxdJF
 Mm2rwwTncoewo1HAp3TvXJf1fsZ0HySCDkZ0NQVDJbAqCZpTzQKoJEPVi4Ap4k9+IjjB
 +R1WG43dFtojFrQVaQFZGAfkmZlTZgx2N6h11E1CmSJjTcNqTG1AYJrIuD/joAu4kf/o
 AhGK+CosscvLwWEhEZtSzqUPC7l7XsfzOdyLggOFhnp341ecQ5YTowcZwKo3yZODT9Rg
 H5Uu53PVTvPJah9pqPqnVzSOrSwObeIiSIN0Zyxc5Kt8mHmEwauBTGJ8UDhawaARiqY7 0Q== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 355w50f14r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 03 Dec 2020 11:31:59 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 3 Dec
 2020 11:31:57 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.105)
 by SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 3 Dec 2020 11:31:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NA+W0/l+wAj+5Hjtc23Z/MjLODXmjArmEM0FAoTm8WgHOlhQjzPS8lh7WCP6wIXzH3JgPC+VIyLZnfspcS527DpLr1aJpm/9I/p1j4W6XSOV2Niq0n/ZgPSXSTWczxE8OAbhk4YuO0Su4m9oymxumNO6piy2TYYdw85K/p1X5On6u5PpS+A3mDB7jgPczzsF1235dkVqLI/1ZN9zix4TihRxADw37KVhrVcZ9iXhfJ0gjcLd6kzplTj5sLrn83M8tHnKnpRw+HIAqipxt+uYHne98OZVvsBI6GTubpP96ZwPWNVRkOn+ljWDYxH1A71l+NzsV23YadDkBpQtIW0Hhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JAuegpktyeB0S96idor9CS3v7ZqbhMfkKfKDrwINuNs=;
 b=Cxix6j7Rht84MiSNAQ1i4kuZ55Rs6hzqfM29MPdv1y2TOsSIUGFEr2OENqi5GaBRXNShSL/+jpytaNTXFdNrVC+rfbVrB3XV3qRusOli8/x3QMiakO653uIu0DX/kG05hKUFofGMofQkyeEsdwQXwOfavSGDGsZrx7DNT4bhaVnpiWd9WdxqYoFECrfd9NXqDfUKZESQKpA14Hr7VC5jfazqB67hChOKiEVkfNIXDrqBbcshLodOyNuXYK7y6RdVLLe7EeNUHiuOl/FhZJcmboUi5+sQIyokFIQJoyClYj1+m5T0DmOwqsyIzBIjCuBX13cD9SQwejOIgTLjW4Bdrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JAuegpktyeB0S96idor9CS3v7ZqbhMfkKfKDrwINuNs=;
 b=LT6VqEQbiDvXb3gfNE+O1mHxFKvigWJPwBneUVcZ/j3iU/dZv4HBI9eRZNzE1gNgzsm9ajbQcoS9us8r9gzzQKDTUjRGP7ADL+Ayl8RqImGsXZqh0G9GmrEBCfBDhRxeyVGjzaGXpicU8OX7X45+fIn8UHRMVwxihuXlFeEnmGQ=
Received: from MWHPR18MB1598.namprd18.prod.outlook.com (2603:10b6:300:ce::21)
 by MWHPR1801MB1837.namprd18.prod.outlook.com (2603:10b6:301:65::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.25; Thu, 3 Dec
 2020 19:31:55 +0000
Received: from MWHPR18MB1598.namprd18.prod.outlook.com
 ([fe80::102b:6c9e:1bb4:7295]) by MWHPR18MB1598.namprd18.prod.outlook.com
 ([fe80::102b:6c9e:1bb4:7295%11]) with mapi id 15.20.3611.025; Thu, 3 Dec 2020
 19:31:55 +0000
From:   Mickey Rachamim <mickeyr@marvell.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Vadym Kochan [C]" <vkochan@marvell.com>,
        "Taras Chornyi [C]" <tchornyi@marvell.com>
Subject: RE: [EXT] Re: [PATCH] MAINTAINERS: Add entry for Marvell Prestera
 Ethernet Switch driver
Thread-Topic: [EXT] Re: [PATCH] MAINTAINERS: Add entry for Marvell Prestera
 Ethernet Switch driver
Thread-Index: AQHWyVwX9p+TCf2pwEWbloXbKFzXAKnlcGAAgAAPsCCAAATWgIAAG4GA
Date:   Thu, 3 Dec 2020 19:31:55 +0000
Message-ID: <MWHPR18MB159813827E98CA7862820E0DBAF20@MWHPR18MB1598.namprd18.prod.outlook.com>
References: <20201203100436.25630-1-mickeyr@marvell.com>
 <20201203143530.GH2333853@lunn.ch>
 <MWHPR18MB15980930483CA2F0BB657E95BAF20@MWHPR18MB1598.namprd18.prod.outlook.com>
 <20201203154857.GQ2324545@lunn.ch>
In-Reply-To: <20201203154857.GQ2324545@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [93.173.69.161]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 318dfeaa-6d3a-4806-a1d2-08d897c217e0
x-ms-traffictypediagnostic: MWHPR1801MB1837:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR1801MB1837E2997497839175202B90BAF20@MWHPR1801MB1837.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sNdFuib4QFdHzaXXxD4hF6TfTvSelydLoSEzWrAxqVCAApTH/x7pP/KZdre3kQHsDvMvqh2HIzV9yQY3JUL6nXmUgWKKkENh5A+L/A136dijnonxMbTJbfRGOVDb1F106QqUlSRqDeq9YUTWbJqItTHwVxAY1hRgfu+hMwKQoL5yJJ3Vj5yHRAv1l2lhVm9VECdvRmeEBtgf6J8nhFD+wKqkuRC+fvsSA1O/MPV9MqTNFtpkmooyCAfNZpNRZafKTpVb/rPLhtd7k5b7LnR3SGsONfuTBrvyzli2hdGDhn+Q0qn0hlYencug0QTOkQ069DN1N+u7KscxuPf7Hl81rw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR18MB1598.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(366004)(376002)(136003)(346002)(66556008)(7696005)(8676002)(186003)(4744005)(6506007)(54906003)(26005)(9686003)(86362001)(316002)(55016002)(6916009)(4326008)(66476007)(107886003)(64756008)(5660300002)(478600001)(76116006)(52536014)(66446008)(71200400001)(2906002)(66946007)(8936002)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?zt5QJ9IYwy+2NrRipX5R47mX3/S5gbTpc86j56Enn4R9kMz1YvZ84PIm5UCE?=
 =?us-ascii?Q?ztHP+YQQR8yeK2j2PhnRj2ozBe74Bc+2ea56V4bQbWzrYPAHoUq4iOb7XU2w?=
 =?us-ascii?Q?a3+Ep3Bh6JmehpCchx79ufS0gj9dig6LDKA1T+BvrABESX3Y0gbfK5WMxiEE?=
 =?us-ascii?Q?O1fX0iLRzWzRz0vV7S+FoEcgsTbbMKnmUUcRCHLTWktEpufiuepXgsedg9ad?=
 =?us-ascii?Q?aYcPa/PACtpEk43c394xZr6IwZBah/wAxbevPjocEDChEz7ZL+jgzTjkVj4z?=
 =?us-ascii?Q?Xb2rGML+CZUkA2GnLC5ytgPxMChle56JTJgkcUU34RFD1GkL+GqyfKvnFjAH?=
 =?us-ascii?Q?K+nh5KNMB40Vxjel2AVmrtGltTQJh8EK8bb5nG5/foSnAqQzL2AVfdD8BvDW?=
 =?us-ascii?Q?DQXuCxzMW4dbcrY+a0Upjzi5nVm1Y2rtUBEC0wfea1yzPqnXef3D2kSWFRHm?=
 =?us-ascii?Q?GMCu22RopI+VMrDdEvXTfvpdFAZQIIhe8ndVx7T0wJ39AhpcLg+r/OCfXprM?=
 =?us-ascii?Q?HugO65t6jOna5d3Mw4MBvjYKdCrdMT/Y3F3tVsIQ4XqrUkdON1zRX1XehIyv?=
 =?us-ascii?Q?WZoI6MKRxyzPFfpLNItYEV5o6FF1/fKqlYeftw4jSSOJor7XLyp+WwyNgukf?=
 =?us-ascii?Q?/DiCuo5HLPnoeJb/pllPsL3K7lsO/kChPMCtErMZSA12KVbWlzBy8GFHdc24?=
 =?us-ascii?Q?v6IcXXWMI36/H7lo1k0rB3IKDKUx8mmoZve0S6hN19/BZWBrKfqsFAAGlvq+?=
 =?us-ascii?Q?aqgGIIcNOoHTWqbW4ALng57tZeR9mA/srjftCgQ95L6Xls/D0w/PqwJdFZw1?=
 =?us-ascii?Q?jcSJ4oi4NP5rRxNhKYnaED2B64gKmaGgMDLmlVxeDdpeAEjrXULf1d/qsMhS?=
 =?us-ascii?Q?uTWyxUc6FY35rM+WmpoIxc0cwK7Ur+Rq4ZPbk9wM8+hu6R/QX7KNdVvPNU8X?=
 =?us-ascii?Q?cde7p0CPlxUbOOlzb4WClj5yW/XL6PxkHRKBRtaZRS0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR18MB1598.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 318dfeaa-6d3a-4806-a1d2-08d897c217e0
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Dec 2020 19:31:55.1602
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Kux2Gz1jIP72Ykb1UhMKC/J0UBkJpx8h7cTIVZ1Tvp9zjMX46eSsaFle0cfKhXC/CuWBHRymDSnHdUMdN86zrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1801MB1837
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-03_11:2020-12-03,2020-12-03 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >=20
> > > Hi Mickey
> > >=20
> > > All the commits came from
> > >=20
> > > Vadym Kochan <vadym.kochan@plvision.eu>
> > >=20
> > > Has Marvell purchased PL Vision?
> > >=20
> > >     Andrew
> >=20
> > Hi Andrew,
> >=20
> > No, Marvell didn't purchase PLVision and I can understand the reason fo=
r thinking it.
> > PLVision and Marvell teams are keep working together as partners on sup=
porting this program.
> > Vadym Kochan is and will remain an important contributor on this progra=
m.
>=20
> So Vadym Kochan is still at PLVision? Please use PLVision email addresses=
 for people at PLVision, and Marvell email addresses for people at Marvell.=
 We don't want Marketing in the MAINTAINER file.
>=20
>       Andrew

Hi Andrew,
PLVision team is working under signed contract with Marvell hence they will=
 use Marvell emails.
Regards, Mickey

