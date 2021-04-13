Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 559EE35DB57
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 11:35:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231156AbhDMJf0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 05:35:26 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:10724 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229899AbhDMJfX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 05:35:23 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13D9PCDl031841;
        Tue, 13 Apr 2021 02:34:55 -0700
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2174.outbound.protection.outlook.com [104.47.58.174])
        by mx0a-0016f401.pphosted.com with ESMTP id 37w6vugd9g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Apr 2021 02:34:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K45pEQBIMIoSfSOrntJW+Iy60DzXK62JPUvUtVyJ3wNVV749tpzikN9523wOh1NRM46ZCk9PnNOqAdAPNkWrXvQue5OZcGiWhs1hPylpJBFiWuHZr18cW7VS1JEKAOaQbgPM/BmQXMQgHNJouEIG4hHa12rOrsNuA0rlOoV478/y7StAngqwkdqmT1ICBDCQT5Xn+sUcF/EC4scl4dFLJe960uiIZHSCTHevH3/7jOcYROf+jYkPUD35zc65YE1q2mg7QIPbEeKqz6Uvdir96e/RzKmfzLs9R8a8MK3OBPs2bwUOwUNrLnROjeBm/xugAj0K89c3VHYnfw65ET6pCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z//fugbOZ6HSRsHNTQWhKV/fRUSLkc/zHPoF1vuhR90=;
 b=FA/8Il934ok6pZJ2RVFjNNo3DhR/p9tIf0huBy/6uay+E2XqFJjpbfHYWSYFrMM6PE9kLi98Z2uu+pmouhDBASVOC/jWQtURGJPjGSxKjryn8FtFJlAIQMQHvHdwTcqlX4D1zIWgiAdEL5Kz60kCsIADjBep3PlS3nXac26ukbxEpU2Ny5wT4RxodzF58C7kcqRofHRqQVKe3WYN9FvPeu/S0y/ZyHcfNu3Ml2mhDu4RPyVvhVIijMP+DsH3025Pm2M51cmFaMZE/2uSedOF5YDxJuDOEmT3SMibw+ExI7PvPy0OLx3G+TX3KT4ot3AY8SVKZulHzm/hGnMH8A2jwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z//fugbOZ6HSRsHNTQWhKV/fRUSLkc/zHPoF1vuhR90=;
 b=AhIkwul/XyKCM91kJuP1kS2Tlnv1Ts0j4ZBIWKxC7LZtU5kI+tswSphridOagNYBV4KOTT5AX1/On2uXgPV0ZNfBUz7eIP1f8Azbwt5a53jJpa0s+JuMtQzsrBQCCGK0NoDh/kY9HCJMLth2BDXxV2OAZ4bCDc8JvA76goyX/3Q=
Received: from CO6PR18MB3873.namprd18.prod.outlook.com (2603:10b6:5:350::23)
 by MWHPR1801MB1917.namprd18.prod.outlook.com (2603:10b6:301:63::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.22; Tue, 13 Apr
 2021 09:34:52 +0000
Received: from CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::ddee:3de3:f688:ee3e]) by CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::ddee:3de3:f688:ee3e%7]) with mapi id 15.20.4020.022; Tue, 13 Apr 2021
 09:34:51 +0000
From:   Stefan Chulski <stefanc@marvell.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "atenart@kernel.org" <atenart@kernel.org>,
        Liron Himi <lironh@marvell.com>, Dana Vardi <danat@marvell.com>
Subject: RE: [EXT] Re: [PATCH net-next] net: mvpp2: Add parsing support for
 different IPv4 IHL values
Thread-Topic: [EXT] Re: [PATCH net-next] net: mvpp2: Add parsing support for
 different IPv4 IHL values
Thread-Index: AQHXMEFo10wdEFvjykKGBHXbluX/IaqyKzMAgAADlZA=
Date:   Tue, 13 Apr 2021 09:34:51 +0000
Message-ID: <CO6PR18MB38732288887550115ACCCF75B04F9@CO6PR18MB3873.namprd18.prod.outlook.com>
References: <1618303531-16050-1-git-send-email-stefanc@marvell.com>
 <20210413091741.GL1463@shell.armlinux.org.uk>
In-Reply-To: <20210413091741.GL1463@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none
 header.from=marvell.com;
x-originating-ip: [62.67.24.210]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a8a86679-363e-4a0f-9323-08d8fe5f639d
x-ms-traffictypediagnostic: MWHPR1801MB1917:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR1801MB19178759A701A550FEC88915B04F9@MWHPR1801MB1917.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1002;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MCnVY7SPdwvO21FJs1FHJoQTVZrItK5C76JcpabTctZA0v8mJbpQfxlbxfpS5prFBBqeYnk+cRCXTqDF/RZlIZ+2B3WCFC2EDwA2+odv2ZuZNmkxzPnztg1WxntNYPDGepfrrYA4pI2PBite5Zdeopm9dFT/5VZXkr6IjKR0KXdai4qwsjm7rYkxqy5RTst/2X0v5ozxPI/+4wRRJC2Sebp4XJ1K8XwJ3OBu0vrZMFf+kS6yR2OY9izDqhJou5qxoGM2M97zD8IuiTGFto/VH85agxUmCMPMigeIfkZKa8tugk9xjJiPIFxFmgpqT5+UgY1nSZca6iEJaxI3Jo5XIebB3eaPFp03ak4m4kAHOCiATLe1c9lTeqSBrPcmhNyRKgwjaNoqztvmJkypkG33g258kpeCOZQPU6KwxnrUr8s7XGDW3JppV4euvtbZaNdesouTTOetMQrUUwPjKskVI3Uwv8qfVIe3s+i+lfQqfYpWWT3zUUwUbNAlrUKNcd2Nl+noLq/+MIEAe0c2LmuMLEGvQBo/CkJO+jbzRkjVzl8NfP0/AHPt9SQXiGhcBD1mJTd1pKcGMNTjwmr5qe92jKAK035425pIkIuKgJMSTUI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB3873.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(366004)(136003)(376002)(39860400002)(66476007)(107886003)(38100700002)(53546011)(64756008)(4326008)(86362001)(9686003)(122000001)(54906003)(316002)(186003)(2906002)(33656002)(8676002)(66946007)(478600001)(83380400001)(6916009)(8936002)(5660300002)(52536014)(71200400001)(66446008)(76116006)(7696005)(6506007)(26005)(66556008)(55016002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?2p6EfbyJ5cFkIU08JGuhnn9hEMh6FcJAHnLhExiZsEkGtNX4hQXxZd+OZdCJ?=
 =?us-ascii?Q?V/F0utlMkulLfzKUdIXBb27PHfhCwrTOEGGnPznb+M46WvTnbe5qF03ojR8b?=
 =?us-ascii?Q?8iMVdrCyN90SSn4MQOlKPyNvKpQJdAe08Ood7aXaAKO4XWWCQmhFB0n3u0D4?=
 =?us-ascii?Q?11mb9b7OopHVNALmJktBD9KvkKEXW9YLc+2ItGssz1dqY+mwCmieznfJanVv?=
 =?us-ascii?Q?NK9WYeqeJdMLz0VpkDJ2W3yUPN3NlyLdFOHE5w/Vc/tgFGhyUVHKnMgpp8fX?=
 =?us-ascii?Q?RbdL3gW4xOeR3S8GJjzF+I8t6Md7D9uHQOTnnREoeKA/u4UFeB5tiqdsiK1E?=
 =?us-ascii?Q?wbn5qhpW5PhY9C4R4R39PNH3feOGXvuZ3p1PdR5+IUkJcwQMToSNLyysifD2?=
 =?us-ascii?Q?5jIwR7tcvMRntDm2rUnaB9qck5MmOA6Z+WWLkeRXXp2wFd9MMMf6LBCliyB6?=
 =?us-ascii?Q?ITcTmAgLvanL4QHvQ2cmFyILOfWF4VmarM+CX1O0Y39wd/YnH2hIrOnV9G+L?=
 =?us-ascii?Q?hy/RsOEXr1dMIWkvgV76OJwY9/7mpMjvK/wg1mB9ZPbpzRZza0XSEYV57doh?=
 =?us-ascii?Q?HG/OCCa0GJRlMKpl1MZ1RbV7HaiCmQLpeGSPFvI/RspAKtSx1NVmc0kegiJQ?=
 =?us-ascii?Q?cJOpV5VgkYlRx3C9bABu+YwVtBd45w+auXkqjdpzt2bb3aATjlUXofQvKUF4?=
 =?us-ascii?Q?q/7+vz2Df6vWFnxNWNce3COzDRVUXjqTIz0PP+o8jf8b/6UQtEWVX713j8pz?=
 =?us-ascii?Q?XQmzeNIRpCe+v3erhpJpgLCN5BPONvw8zKYkFboVSAL2QjfxDiBYDu0So3Yg?=
 =?us-ascii?Q?Kf3vFZWCC1iXfJ5oSbaxZ2wavJQ5/dJ0a9DA4NMtiPx2JMw1WLrewI8cfz9q?=
 =?us-ascii?Q?snyXalNIHGqrM6ZeTPLg5M6hQmcpYT9zAhuV7UwioLcelKulSxI/81URWuzC?=
 =?us-ascii?Q?ujfuhhDYCsbc8jKIf4KP6JIqGct+ju6aBTg8+LMbd0WfnZsT//zFkBX/zBeo?=
 =?us-ascii?Q?Nd1PyCWpzQsvhaU8TVnHcci2BvzWx6kgndZmGG5ni3PzoMzuxWr1UlVTUtYD?=
 =?us-ascii?Q?ovnC+h9lvhtUFFyWWsigp0YCFL/2KfinbhrXqd2JJ8PJ1e/53dl8AaaxiP5w?=
 =?us-ascii?Q?9qsogg/ErHzVwOjcXnjxl3xHTE5k7/qC+WBbnpFfF+COXyiFhRMIN970hvOQ?=
 =?us-ascii?Q?fDBFpTvMNqP7jtaNIQVqh2eahiK+GmcbCJw4UNkaptRkggKKdEHQJ0tDNV79?=
 =?us-ascii?Q?MxKXisCrc/ERy1zotuJYMO8LQ7wcTkjIWZTk+pOLUKCcfUFTiOGfXn5DWngQ?=
 =?us-ascii?Q?qWAj73Jx6nrLuhnNIVzVMgM7?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB3873.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8a86679-363e-4a0f-9323-08d8fe5f639d
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2021 09:34:51.8100
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dT9yclBmeq9yMmBIwrj1OwrYAFDgGHseDMcsnQTQJ7GRgUX4DBvXZAb0ziN3RpNMyI62oZBxqa5lg8uubYWE8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1801MB1917
X-Proofpoint-GUID: FlrGLBqkVcfY7gzydu5MmXHxbgfv-dfg
X-Proofpoint-ORIG-GUID: FlrGLBqkVcfY7gzydu5MmXHxbgfv-dfg
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-13_04:2021-04-13,2021-04-13 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> Sent: Tuesday, April 13, 2021 12:18 PM
> To: Stefan Chulski <stefanc@marvell.com>
> Cc: netdev@vger.kernel.org; thomas.petazzoni@bootlin.com;
> davem@davemloft.net; Nadav Haklai <nadavh@marvell.com>; Yan
> Markman <ymarkman@marvell.com>; linux-kernel@vger.kernel.org;
> kuba@kernel.org; mw@semihalf.com; andrew@lunn.ch;
> atenart@kernel.org; Liron Himi <lironh@marvell.com>; Dana Vardi
> <danat@marvell.com>
> Subject: [EXT] Re: [PATCH net-next] net: mvpp2: Add parsing support for
> different IPv4 IHL values
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> On Tue, Apr 13, 2021 at 11:45:31AM +0300, stefanc@marvell.com wrote:
> > From: Stefan Chulski <stefanc@marvell.com>
> >
> > Add parser entries for different IPv4 IHL values.
> > Each entry will set the L4 header offset according to the IPv4 IHL fiel=
d.
> > L3 header offset will set during the parsing of the IPv4 protocol.
>=20
> What is the impact of this commit? Is something broken at the moment, if =
so
> what? Does this need to be backported to stable kernels?
>=20
> These are key questions, of which the former two should be covered in
> every commit message so that the reason for the change can be known.
> It's no good just describing what is being changed in the commit without =
also
> describing why the change is being made.
>=20
> Thanks.

Due to missed parser support for IP header length > 20, RX IPv4 checksum of=
fload fail.

Regards.=20
