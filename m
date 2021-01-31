Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8316309B8F
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 12:24:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231391AbhAaLK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jan 2021 06:10:28 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:41394 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230499AbhAaKNQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jan 2021 05:13:16 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10VACUDH022038;
        Sun, 31 Jan 2021 02:12:30 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pfpt0220; bh=pEFQaEzYdMAdBdDoY7cxhBVLyV179Aeer9gEut5bvrU=;
 b=drJT8VQ9WwJdsvU9S/78Ll9yo/Py0wJVjdqiW1qc7JPscN52HnpEZ+QwwRCfw/VVK0Qg
 7fsSOL6L++2rEr3J3GEvgeIB0xBfHDsCwAlZ762T42QH055WgXPOlRlMVntn5vKUlnRl
 LHwrCMOI29SSJQ3rd8ZoxsJQukH4VLs4FMDDrEWFDJUqlLi7LNdCiuL1/qwkKTx5fSB0
 YBbVk+jWHT5NoMb5jWLG6V0h0evoqB1ZWJHY26ynpjgJECIQPnkn4Ts4Vnkf5Gnrp/Ss
 vtm2IpnY3hhl9/JrPiQLQSGry1f8jGDy0lT24hJRmG92gkaGKSp3/HZT7TJuJivsHGLQ Bg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 36d7uq1ccr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 31 Jan 2021 02:12:30 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 31 Jan
 2021 02:12:29 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 31 Jan
 2021 02:12:28 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 DC5-EXCH02.marvell.com (10.69.176.39) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sun, 31 Jan 2021 02:12:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CmiCVCNufy20SR/kdIbc42KoxwDEUPrEpxdmUoWPyZRu7Hlghtm/afGgqGtHTOXV5lcW7iiIp2P3TiJhdKNmQLu1F7wnP0xITGk/vp5UB575KJxAixbOU5TRYzHTPwCH/zcK6mOfB2MiTewefCfQ9RlwNcmdFOUBwPByFY7lET7OoOo5oYnwTS9P+X1NhcE0155PynxxDAjhUpr9ooktspSsDeILo2RIiOzHhYvkYrHY2IgbaWpXT1fsZFLrTXkZfD6SW+zOs/G3oRNnosQzjTDtos3bUPi74n5F8vwofa/WaFFn3KpaS2cMkxQ9gTTGAeiNbUew+dizrN8OJKcIAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pEFQaEzYdMAdBdDoY7cxhBVLyV179Aeer9gEut5bvrU=;
 b=f+yvKLwu+23AAm3bMHGYadJG23DEJAzfSoPlvfFbzg3Y3ke+JMeq7Atj0v1M6aSUHxoZIM9x/6rwb2TtdbWUUTZhHrK0CpCkN7tVlsCXZIeDREOR0mHlgV0iJSUp1zbHFlfpaT5uEU3fi6fpoAlz81funYVRL2uq3SGamJiBcjS1j50xSl7E8//ZYi43nDT++7UnSDHCo97wkQWb9FsvgFFlnlKrbgkcz45RUJmcl39EDfvCdqWOXZuJE6ytRlTJ2SST++hP0gdaIHPzUazOZ/1k5QRD7UiCXGy8l3OX1o/VzV8TglyaCmRBRscWA4EiUCnRo/3/GEIIFrH1GNtqkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pEFQaEzYdMAdBdDoY7cxhBVLyV179Aeer9gEut5bvrU=;
 b=QjKTgIgP5F3OhsSylQ4JonUCweVLY6n0joiO9hNZFIqmmwz6vWc2SvSW/Myf+STHWNye7yofHbNx57wLvx71JNFYjTlobvjn+hVNktdJ+MTIIiT0PBw9wHkV+h0LGhx5LNabGtCCzLAVkdwNJ/rTWeQHrTLXdoGok5mUnf2kh4c=
Received: from CO6PR18MB3873.namprd18.prod.outlook.com (2603:10b6:5:350::23)
 by MWHPR1801MB1855.namprd18.prod.outlook.com (2603:10b6:301:68::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12; Sun, 31 Jan
 2021 10:12:26 +0000
Received: from CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::c041:1c61:e57:349a]) by CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::c041:1c61:e57:349a%3]) with mapi id 15.20.3805.024; Sun, 31 Jan 2021
 10:12:26 +0000
From:   Stefan Chulski <stefanc@marvell.com>
To:     Russell King <rmk+kernel@armlinux.org.uk>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "Marcin Wojtas (mw@semihalf.com)" <mw@semihalf.com>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>
Subject: Phylink flow control support on ports with  MLO_AN_FIXED auto
 negotiation
Thread-Topic: Phylink flow control support on ports with  MLO_AN_FIXED auto
 negotiation
Thread-Index: Adb3t9G4usyHCBibTMyL4NZ1O9ab5g==
Date:   Sun, 31 Jan 2021 10:12:25 +0000
Message-ID: <CO6PR18MB38732F56EF08FA2C949326F9B0B79@CO6PR18MB3873.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none
 header.from=marvell.com;
x-originating-ip: [62.67.24.210]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a3c4dd00-d49c-4597-f185-08d8c5d0b564
x-ms-traffictypediagnostic: MWHPR1801MB1855:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR1801MB185568B9ECEAC08A0F458E84B0B79@MWHPR1801MB1855.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ikyAhfwfn8jx7ViIJHf9LyYMuM4vKfvNYN8e2FUpsHbCNeH6cFouZWayneYBZdP93+JvDoP/hC4aPLed0LA8J6tgvxqx8/lFUMxxfnyg8TRfIGWHSyJmWs6VIBchy+xBGj8FWADaxJs33/+ajPr5bdsrz3begGfsR4l00Bw6tBskouu7MVoz+AgpO70zVCy5leK7bnJlyEGtwTAtaf+k5aMfs527qFKVfmR37SMd6aGMwYhWmxGy3TbBYEvbjgpT7JRCHy9wSyfZwCp0JRBSwO6vkkguS6CNzqF6riIkY4k5Yo2T2j2Mrv9pVDycfHALfLnMaDbasYrvv31ui6WgDZ84jT1G+Qm+RRZdxJLXSkOfzpC4A0LiMTiO/WoZj/3By1l+ONhhqj9BCtaWXH82pHAa6qsGEb9OEKMbI8Dt5AWvpNOhcEE31qqjTJ5z2J3poyLNSwEAX57usUHs6pKRxUS0UN9tAlkpchJWKBswHk+x7GAjOHfb96CYMrvoYNQG/xgtHKZTYV+tsiX5u41Ydg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB3873.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(39850400004)(136003)(396003)(376002)(83380400001)(2906002)(86362001)(71200400001)(7696005)(26005)(316002)(55016002)(478600001)(54906003)(5660300002)(110136005)(6506007)(186003)(66446008)(33656002)(76116006)(66476007)(4326008)(52536014)(66556008)(8676002)(107886003)(4744005)(8936002)(9686003)(64756008)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?G6CSDxQ1DrwOd5Spq9JZckma2+E8bVzvs/zjH4AcTqOEcyYVoqiTN2Ii7tcV?=
 =?us-ascii?Q?CYzJ4R8M3PXd2iDcyeDRqIFQiTWq55LPXfp2zf+w1HfZSqbdvp2ilRMjyZ0w?=
 =?us-ascii?Q?n0j9+2NCCMeqn3vY218iMb2kcyVvaMa9SHO1JqfmHGlgeJs1+KTdOoxTmQgF?=
 =?us-ascii?Q?6apl2gmaA+35hCz/YDgu7hK+I+zORk0tNMDjqzzYzRLYGR3PM8LdwrOzB3dV?=
 =?us-ascii?Q?btP9HfSgw/urk8HuvBRnpTjaeX42rVbbGsKa2fHVDxunUinZw6GwaGa6EDaW?=
 =?us-ascii?Q?OWuj5VxqnCC2MsG0yisiuzvvcU0EocH4NapCFQpIYLK+4ABgHxXsKFuHOenv?=
 =?us-ascii?Q?zEXSkp6bZIfpH9n4gOUg+eFNmlyZpIGa63ZvVqVL2tEIXmjCMdtB0Hf2LNLw?=
 =?us-ascii?Q?sdH7U5I131q3XpFACMvWWKLQq5q6XIRuo4ptLHbTKsx9U85+/i00pJCypTpj?=
 =?us-ascii?Q?bJw7IqTu5R85DMucMS/xwpGiaGzuu34xVgmkb9AmZhmuLZmXoi7Pyot8EELA?=
 =?us-ascii?Q?/1UETmE3R2a80eFYDBXToZSo2a4HO5bid7d9YlOmK07SeWMkRy+BYWunLmI0?=
 =?us-ascii?Q?X9fL/9XjVNB0gb2FVzjyL3WSUa8+W7LWeE5OT3kofKJ95h5zUH3RNlx6AOB1?=
 =?us-ascii?Q?efeqfPtSPLP+nTmVgXrqnimr8+aPj8Gkmc+MM0VNaTtJzb1451hVG8aMc60E?=
 =?us-ascii?Q?F3pqhW/c0CUMgUZ1QqsprwNDHCw0Y73hicMSOvbmThJXysLPQ7D/oavyH+bB?=
 =?us-ascii?Q?ZXY1nYo2lXlrssHquiaSLBe3AdzXaTi+D00hEPwt6ZRzuVgQHX8oNjE2gRdz?=
 =?us-ascii?Q?D1RxBlC21ZYKUMlFVg3NpvYhgIu5oviSmrfpEzm4L5y4t3EYTxJpvAUW6y1w?=
 =?us-ascii?Q?cNTKCn+3JMPqbKc1oVvHomMSveQVPqWoNYdAqK43PjHf55YRDbJySERB7qEi?=
 =?us-ascii?Q?ZgY9xrsAKorI6p9DV0xnm7IRON1Q32BGQRt/oZ+wPH/S0Vqfld99dn3/A473?=
 =?us-ascii?Q?2kSB/uHNzZiMDLN9iRtoKN8fqq9FO3NMtTgULCAGckqlQRthJTInRUc0sfLv?=
 =?us-ascii?Q?qWj38Qx7?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB3873.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3c4dd00-d49c-4597-f185-08d8c5d0b564
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2021 10:12:25.9448
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Xa2AC8MaSTcRu6yUqGACH2oCTWfVdLQS9Q39MnTdcscVH3WjDdzjrq0isrf1fIKBLlNUkZ+HfPqOSwi1mIdR9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1801MB1855
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-01-31_03:2021-01-29,2021-01-31 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Armada has options for 1G/10G ports without PHY's(for example community boa=
rd Macchiato single shot).
This port doesn't have PHY's and cannot negotiate Flow Control support, but=
 we can for example connect two ports without PHY's and manually(by ethtool=
) configure FC.
Current phylink return error if I do this on ports with MLO_AN_FIXED(callba=
ck phylink_ethtool_set_pauseparam):
if (pl->cur_link_an_mode =3D=3D MLO_AN_FIXED)
                return -EOPNOTSUPP;

How can we enable FC configurations for these ports? Do you have any sugges=
tions or should I post my proposal as an RFC patch?

Thanks,
Stefan.

