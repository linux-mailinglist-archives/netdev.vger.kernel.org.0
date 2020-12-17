Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA42F2DCE95
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 10:43:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727404AbgLQJl5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 04:41:57 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:37936 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726155AbgLQJlz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 04:41:55 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BH9ZsUD008463;
        Thu, 17 Dec 2020 01:38:53 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=3gPc6wDrO+0GthwNv7BWaKJFwqa1dWNAlvurewo5oAQ=;
 b=e/NDaBIozGy/MrybNu2v+kk6ls1GO+1HPZ1qZBci18SqazVMyd+Wl88lEmghVUAPbRiD
 ZCPg2ZZgBi9VaEHSeDbkUAGktPtGclNnVz0Tx2xL18tve2WKAGVWCIy2qs2Pm/615bRX
 ulIUPRPq4wShgnV3cs7Ysn2UOjxK9Q9lWdzLlj2cHmYrOzDKGq8ardpbjXne/NN1rssJ
 QbSWRxy8u3TMQbJWrMNtGfZZarBwxGnzojH6s6xByKGLgeZdNVxuheBEaL7OnViEW+KN
 QwoCRr1WiVooUYhI8QlRt3+XnimMAXjoP+viubcPLdMxukAUpSZ3ZFLM89ya6vw2JVfl BA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 35g4rp012t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 17 Dec 2020 01:38:53 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 17 Dec
 2020 01:38:52 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 17 Dec
 2020 01:38:51 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.107)
 by SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 17 Dec 2020 01:38:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cXXzTDM+xenJL4YddfIxIARRuhMYLCuYNbWhsKtZD+PkMOnVvfcbTnRt2avBjeJHd19ZTeYuZifYZVUGShg4euAEpvWQk29jzoi/lRzYjaUw+pB6nYJWiNX5Y6Tnj5LAj59k8EqJEBnilxm84YISn+7knEyEOowxrAJJBfR08/GqyzJwaS2Opb5VXHqGRNRaR1RN0hr4fAJsB6JYcoHUCjebu6obcPAFjSHyOzTkUzZtVE2TXMRgKfFgedBq3nt91pqC1iv/M+kAmBHbzOhoCFuX33gNyLZK15no+F17BZ51vRf8sJIoFz+ABKDmt0WDmtUYfVHEOi+0DeBaZ/gnRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3gPc6wDrO+0GthwNv7BWaKJFwqa1dWNAlvurewo5oAQ=;
 b=nNgfYCHdZbrkxY09FEcU9D2jHjcBFCA31Xra3k/4xYdmm6meswTtqQvkKSEC4d/ptft2Ku0M157omdm5FDfVFLacTwWK0kmi1w9dN3W28dmQhA1qp/GawMdClClK0ZiLSHIcFsebX4CpRApxni9CZBN+fo8Rh2fl05DIAEFOGqVPpIqnhSxZJXbMAK9nER3G5FzvXGLBstUd2XekyRh8Bw8LSG5zyk154beD3efEoeCoFxL+QKducrV4/uRN/QqGFquVi3OakPWOxkA0D6sH/fwX6nQSXyJVNkMMepykCA2bgzYQ0VdFJEktY8bZnG4CY7QUcNskpsJaa2fZxfELuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3gPc6wDrO+0GthwNv7BWaKJFwqa1dWNAlvurewo5oAQ=;
 b=CjBP78XnCtqegma0OcEUcj9QUhagVQwKqOZhZ2qXv10SQUV166Ch6aXCEuttNgNTKeiC7pStDcLMQAVwTgCVSzk3yIgfdkfooW37Lh7AAR0OzrcMhiDkrcPHIAJsCA2mQZjefy74eB6a1BL0X7lWGWJ9f/RhWPS6FlCnNWL3vIs=
Received: from CO6PR18MB3873.namprd18.prod.outlook.com (2603:10b6:5:350::23)
 by CO6PR18MB3860.namprd18.prod.outlook.com (2603:10b6:5:34d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.13; Thu, 17 Dec
 2020 09:38:50 +0000
Received: from CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::ed55:e9b3:f86c:3e5b]) by CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::ed55:e9b3:f86c:3e5b%7]) with mapi id 15.20.3676.025; Thu, 17 Dec 2020
 09:38:50 +0000
From:   Stefan Chulski <stefanc@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "rmk+kernel@armlinux.org.uk" <rmk+kernel@armlinux.org.uk>
Subject: RE: [EXT] Re: [PATCH net 1/2] net: mvpp2: Fix GoP port 3 Networking
 Complex Control configurations
Thread-Topic: [EXT] Re: [PATCH net 1/2] net: mvpp2: Fix GoP port 3 Networking
 Complex Control configurations
Thread-Index: AQHW0ubBS3DkwhP9JEKwsigKGIsDqKn6dSYAgACVu1A=
Date:   Thu, 17 Dec 2020 09:38:50 +0000
Message-ID: <CO6PR18MB38737D87B39D6BBEE82B83B3B0C40@CO6PR18MB3873.namprd18.prod.outlook.com>
References: <1608039133-16345-1-git-send-email-stefanc@marvell.com>
 <20201216164220.71e5fd1a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201216164220.71e5fd1a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [80.230.78.138]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d47e2c4c-6bc9-49e6-da57-08d8a26f8f69
x-ms-traffictypediagnostic: CO6PR18MB3860:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO6PR18MB3860E657E93E8A0A79E8FEE4B0C40@CO6PR18MB3860.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:568;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6dhPMLR+/G+4S75DSCYRSAgl2bkFX6gjA7r4DewNH7b+umI22/QAcu3cdIV6LdlxCzebHF+bA5kJIMbdEwHeST+s3MCOSo1Q9FBQ31vgIQpwcDyXy+jFS+s1v/2QngDKlXMRaWwMXXL2xjVvDkqrrihyWRO1lMvaUMlXgojy+L9H8b9CDFy5OZyCFqdF4s8I/XO39M2goGdmIMOIKC9p9puFN5XEIaCISJkod65zVe/S0Rw09Afi/Xzn0/TgeGrAS9DeWIp+6bEPbdD5LUpCSvlsTk9U3Nvkxy+9tC7H1jll1iYE0HVB9maaM8GXBgHmUNbgdUeU7xPFXp24xuw02A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB3873.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(136003)(346002)(376002)(39860400002)(6916009)(71200400001)(2906002)(66946007)(66446008)(64756008)(55016002)(66556008)(26005)(186003)(9686003)(5660300002)(54906003)(4744005)(478600001)(66476007)(52536014)(33656002)(6506007)(83380400001)(53546011)(8936002)(4326008)(8676002)(316002)(86362001)(7696005)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?yElDzdbEzzbu7NDhKwST6nwcyq+dzxu75xxnq6348KGSa9k4lBDyLb2/DX61?=
 =?us-ascii?Q?bD7WUBzNsuDGDd6Gf9u71aqkNufGuw7EITCWlrC5wchBG2+xsJlhi6SLF6SP?=
 =?us-ascii?Q?qd1vRWzlovbmb07MCPvexZZB74xPdkap6zSKRvdKgjSNDtvNh8HgcF8i3dHt?=
 =?us-ascii?Q?p6SD/F3Q8BcdmNCsw4k4NLSwZ0FacCPkM63myvKTsZUi1kOWzeK4lYIO/Sih?=
 =?us-ascii?Q?eyo30Q07751w+4jMJgK99rBWCzo/T08lKFd1QEgBmCnbf6hIDOjLRgAfBz6O?=
 =?us-ascii?Q?P171UzcIT0NDfrCmgM3eXseluTwVkUHX9AkaZEyoFCeNfgqNji3o7Bw9Q8vx?=
 =?us-ascii?Q?zBdENcxknl/GJr1oLelw530CF/wfHEcztaoqFbtfAh5AxDoPw6d4F755Q1bi?=
 =?us-ascii?Q?jzGbMlvw23jc9nI6Y9dcUSXYVvwg0nOwsvrLUQywfPemw2KEC6nkHIk3aeUc?=
 =?us-ascii?Q?Kq/pNbeFEkGDg0nhOmf6VbutqO1QNp2XPOp8kc8VRGkyIc9/88KSu2G+Lt29?=
 =?us-ascii?Q?GyQxzz5Srw6XZ87QhXyi2qWyFrIvMst4QPuRJ5/kCpvsioPOk/OquO8G39or?=
 =?us-ascii?Q?PhRtFtGiwPjqJwMEWEwPUy0S4bUDb3xKZhRvxiLc1fZah20i3e0Qrsivhwpq?=
 =?us-ascii?Q?ZHa8R0qUCB+duiczxsHYMi/saVCB3dSw0XQ/Pg6VdQBFO1GcvYRmdbY5rQae?=
 =?us-ascii?Q?3oeHM6k1Ng8zTceh+R7UfNyW53Qv397yMufiSOHDSvgn67hQOJ0bWAp0ed9X?=
 =?us-ascii?Q?qIXHmYiklcsWkwfA0gSpMnicHPqK26oHTx57lLfYK38Lk4RaZdXONrLcvNhW?=
 =?us-ascii?Q?gCerp6XU/S4ul8akPhBksTEKUnvd31I8RHjpw6Np0X559V7+zz82raM8hbJR?=
 =?us-ascii?Q?p1QvrgToF9hG243x8UjV90J2BvVj1BAMZ4tS8Pp1R8CsHxrk+pNjKOZLjep1?=
 =?us-ascii?Q?QgDK7OAJKMpFBvSI6TdEZoYIBoq8vVCvEIs6Wbah/jo=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB3873.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d47e2c4c-6bc9-49e6-da57-08d8a26f8f69
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2020 09:38:50.2271
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3lgydBs2ZThhspnYgLemipg/IwsXkX3hPfvJjrxH7ZTu4DBNiQfTay24hiM/xDQR9vUMptB7sWu0fa2Kr9wpSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR18MB3860
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-17_07:2020-12-15,2020-12-17 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Thursday, December 17, 2020 2:42 AM
> To: Stefan Chulski <stefanc@marvell.com>
> Cc: netdev@vger.kernel.org; thomas.petazzoni@bootlin.com;
> davem@davemloft.net; Nadav Haklai <nadavh@marvell.com>; Yan Markman
> <ymarkman@marvell.com>; linux-kernel@vger.kernel.org;
> linux@armlinux.org.uk; mw@semihalf.com; andrew@lunn.ch;
> rmk+kernel@armlinux.org.uk
> Subject: [EXT] Re: [PATCH net 1/2] net: mvpp2: Fix GoP port 3 Networking
> Complex Control configurations
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> On Tue, 15 Dec 2020 15:32:12 +0200 stefanc@marvell.com wrote:
> > From: Stefan Chulski <stefanc@marvell.com>
> >
> > During GoP port 2 Networking Complex Control mode of operation
> > configurations, also GoP port 3 mode of operation was wrongly set mode.
> > Patch removes these configurations.
> > GENCONF_CTRL0_PORTX naming also fixed.
>=20
> Can we get a Fixes tag?

Reposting with Fixes tag.

Stefan.
