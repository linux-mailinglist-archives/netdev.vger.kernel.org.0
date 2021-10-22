Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A49B043801F
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 00:11:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231820AbhJVWNQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 18:13:16 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:8306 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231363AbhJVWNQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 18:13:16 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19MK5qSv011085;
        Fri, 22 Oct 2021 15:10:55 -0700
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by mx0a-0016f401.pphosted.com with ESMTP id 3buu23tkj0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Oct 2021 15:10:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QLv6D1qkoIHGpAKZFxyfIx2g08Va6BzEz0/qtSe8KC6ofOeoIoK/H4s9BmDxl4SJYmw9R4u/JOtWJsZwe1GOFc9zo/dUJpRO96jQ5qfiWbVGkeKW0KbJ8s3h3R3PJmEMR4tcy0xG3Af4NwgDHFFWxGG4aocp7BiQUqF2Ev0rbnkOPC+IHiPwmkChVuNKmFAlyqyLBQuk+Cq1H86Lox1Sm1sawPoQr0+bEj5T/RVNTLprkVXf8q8lIEqKbGmIi9dvTnagh71mOKIcf/sm4EHIuAa4Za92UWyE9m8ZtcDJOcJOm8s90bJTrwCJ9jZWqYHSL1M8a+130A3Qoq03w60RIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qeWsEUFFNZ+smycJDuS33wqP6rCwVD7xBn1jXUJsJoE=;
 b=GTVKYDCQ2nfwnutKuhMOxRg69liDpMUDywQ3K+KgemdJ5Y5OPPeIVne2wmTuEzSI49pMjVOCVGtUWyCKtszxTNfy9UFcHTHPodhEhqSOIh14JKBMQn0dzQOapYKRK8CAVHI1cbq25SrJu6dib+wRoeS6BOCqOq9SD/7xc7/IdeXqStLMEeEPtd0Yaynp3cyjmLjfv3584mP62RZoUXDLqG9/uJwIxQD36NkNdtE9qJAWRCaPiR1MUnoMP5D8ipzHlKQzrYI5qVJFa4ioJwcYnvVM/uleAS2I1xReIvfzRkLmNn7aoCFEdych0Cwd3P94gysRFrBtYRO7vbhvN5MdJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qeWsEUFFNZ+smycJDuS33wqP6rCwVD7xBn1jXUJsJoE=;
 b=CwDFGsn9ppXglXd48OshI0YT8F3v2MnrI7SP8y8lRMpnVED9/yXgTiXKCLwprOqC7T1tf0fCziLY1q23fRqGVzTj85ZlKU1hyG80Kkxi9iCnhKdi9IeuaeoGhtguwbTezBDU6daNf1w+N2ZidkfKkEKCLCvft2ZtAWum6XyC8FM=
Received: from SJ0PR18MB4009.namprd18.prod.outlook.com (2603:10b6:a03:2eb::24)
 by BYAPR18MB2839.namprd18.prod.outlook.com (2603:10b6:a03:10f::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Fri, 22 Oct
 2021 22:10:53 +0000
Received: from SJ0PR18MB4009.namprd18.prod.outlook.com
 ([fe80::919c:1891:e266:2502]) by SJ0PR18MB4009.namprd18.prod.outlook.com
 ([fe80::919c:1891:e266:2502%8]) with mapi id 15.20.4628.018; Fri, 22 Oct 2021
 22:10:53 +0000
From:   "Volodymyr Mytnyk [C]" <vmytnyk@marvell.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
CC:     "kuba@kernel.org" <kuba@kernel.org>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        "Vadym Kochan [C]" <vkochan@marvell.com>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        "Taras Chornyi [C]" <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v3] net: marvell: prestera: add firmware v4.0
 support
Thread-Topic: [PATCH net-next v3] net: marvell: prestera: add firmware v4.0
 support
Thread-Index: AQHXx5Gtrc2y4KycUkKptGnFsuPHoQ==
Date:   Fri, 22 Oct 2021 22:10:52 +0000
Message-ID: <SJ0PR18MB4009C605F1A3B6AD13F3ADBDB2809@SJ0PR18MB4009.namprd18.prod.outlook.com>
References: <1634722349-23693-1-git-send-email-volodymyr.mytnyk@plvision.eu>
 <YXKuOSDraUsaN75U@lunn.ch> <YXKzxvyZwsFmRaMf@lunn.ch>
In-Reply-To: <YXKzxvyZwsFmRaMf@lunn.ch>
Accept-Language: en-GB, uk-UA, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: c40e02d2-3a69-c89b-49f7-5f5fc6b87a8e
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9945138e-cd07-4d1e-b76c-08d995a8d066
x-ms-traffictypediagnostic: BYAPR18MB2839:
x-ld-processed: 70e1fb47-1155-421d-87fc-2e58f638b6e0,ExtAddr
x-microsoft-antispam-prvs: <BYAPR18MB283974E92E2870D3C6709B73B2809@BYAPR18MB2839.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xkH8G0SjURV+AiBEfu9LHZ7BwB+kygE/gv/5OpFEA37nZ0Ky9jd5n+/Q5wfDguDr3cGDuoalP7ufzhw9cCqYWMQURGhFfkjiqeu2zrpDsEbwTWYEOOtK5cBP5iaEVYdLdcy7IQaufkvQkSMRYc81cmruqoTUB4v7yi+GjSrAPe+6fbyhdr7n9MjY2FKVwZjvhWJI741tnVDj1a4VOuu2eoAhlPRidjCntTKG3Gr+OHkGajnvmRVs69HejkGOHVQx8vUqGJmPIUzjCrLQiEOMUWmYOAFO0v6UsxRryf8jvzjO4gh/Fb8xt1W32znTfSTp6jkpXAWpqPoBZckvNJCK+D/jMrVQq51nTYjTthNas00jIQkNdFPbaRTzyJeyipKG6Fk1C4Pzv2nw5tXH0u8+F94a7zsftHZOIjGtHLWF91jV+pd0LHXrxYUR6BgdUnFEn1Vu5QIQoPWsu7qI4sUUnN9qVC0Ex4velHsKX1oLbfxk8ZU8IW4jZydznqTwoxZN8IdpQVi1DAC/TGDQ3xfJsCPgynyYuOCYdRb/+S0qodiG3+gvVK4XbWfbiiM9I39+YAiBQ9xgAc3KtziYTV4E3iSIpSrfGKC+cdoXmcN//vUimOMnWl8tNdnUdr5APmjZbwWM4NlT49qh6xkaL7bFCkm4Iin8ufyvgzcrMv+ZrbtWl0j5D+a0rG47eaxGVzg4YbV2bW0iDyv83Ft8McaZBA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR18MB4009.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7696005)(33656002)(66556008)(38100700002)(86362001)(316002)(66446008)(2906002)(122000001)(64756008)(5660300002)(6506007)(26005)(508600001)(4326008)(83380400001)(52536014)(71200400001)(38070700005)(8936002)(186003)(66476007)(8676002)(54906003)(66946007)(9686003)(55016002)(76116006)(110136005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?ZsUm8th7tmliKw4wLzTYvVFqjCVKjToNi4iIJRM0II8YYWd4TFQf19HmvQ?=
 =?iso-8859-1?Q?dkJXRoO/6a7BnmeE3SPROwKL8jhFDRkR/jveOWve5p2sWfojviTd5aDncG?=
 =?iso-8859-1?Q?2RkC2rcd8L2SFHPAFBZ51zy5gJ4RtDWcv2jFDqHJ6mY5/PnE72eNqeEpfc?=
 =?iso-8859-1?Q?6+9JdvGgO0cMmPLCMp+q+baQ60equqtUcfv8Zkn0u+wCUHQjQyGD5u2Uwo?=
 =?iso-8859-1?Q?+GswqSKBng4oVacGq5QOi4vhiueweyyCVTmA1Luei1mpyXL/d2JaoPzTJ6?=
 =?iso-8859-1?Q?CHtjtuq6tChbVNCpMMzS7JvEZGoaIv/O9tI9WKhzFyZUZcR9EOvMVfkvHe?=
 =?iso-8859-1?Q?m5yy0+DDj3ABYAj5aGsIFsN2rQ9Jn2qMH1T4AA5EkPUGEziXPkaabAejal?=
 =?iso-8859-1?Q?g1WI5wVsbOhiGFlv8TRYV9w/70SvH9eVbImVXC2uvzX+tK/RkywX9At96p?=
 =?iso-8859-1?Q?zW8evoghPTJu1cwczaTrV/QTxkONdboYDH3/WeV68vpyj9qCTjT4qFsLvG?=
 =?iso-8859-1?Q?lEKsSKzIMRHngI9XYYGnaxMHXLoFopJFWxzxAeNWDn8Fhw3zIkdC4mlR7i?=
 =?iso-8859-1?Q?MQthZUZfN48Jo50MJmKhOblIltpS3nwNxVshoF7hyw4QyCj4VeB4F2YBMt?=
 =?iso-8859-1?Q?xgPoXzS88OCcUK+qJCMhKUF1IPPuErE/VOEta4vLnz0gRj3mdsJO4pnXFh?=
 =?iso-8859-1?Q?ZMP2P8oJd2Sp3E2hdk0CZ17fXspL/WYBo/e4MdBrkXrf2j0bnbGbsjoKRh?=
 =?iso-8859-1?Q?TFsTd5xJq/WIRioyPOn/26zTIxoMN2GUEniwGnRosLpfuMw9R7aSgz+65/?=
 =?iso-8859-1?Q?GWdXOobYzwnmfaLi7fLWdCZCXisiy2NplK14SF8eARoJRtrsMSzKUfFz2t?=
 =?iso-8859-1?Q?UFffmVv79/Ik/4Ti0sVu+iRia4Ztd+iFgVrZTYw3Z2Vn+WD3IsOMJcW6Ml?=
 =?iso-8859-1?Q?jsdw7evCEP651uWvSEWp2E3PqqTmHlr5x8ThkHeRBgRPK7S3pJmJfuTwWZ?=
 =?iso-8859-1?Q?loEmIC6S5cZx2xJqVp+WLXogmU6bp1LDOvfSdWiaGsuF6OPhhlDHGhg6rb?=
 =?iso-8859-1?Q?TqkhZwZzuK06tyBUmd1IGmuYiARptIY6s/B37I3EDjhmec4hGPuFErpF6F?=
 =?iso-8859-1?Q?oF1zFJZIR7TfB8JUXECuT6KXxrBO0120RxVxJ5Ha7LLNLh5zasE61kPydm?=
 =?iso-8859-1?Q?J9snKGGWWhQrn2/rKRu1mgpHmo4eRyv/O7yUWUxpqVD2ros8Wo9Tgb+y+T?=
 =?iso-8859-1?Q?epBf9WqQyKqCzX1MU6VoI/HI8Y3ULXU0iNQUX0XzC+8pXP0dkF8DUdsgQu?=
 =?iso-8859-1?Q?7C7l9mICVqoUyq7Sk4Dn2gqGkkHge9S/+F//amCXG4a5ETM7zeV+koJNaA?=
 =?iso-8859-1?Q?B2YOxUpt2/748+lPOltTSS6loLWp//byPJWmYyeFhbweo1ihV1PP5rL7qv?=
 =?iso-8859-1?Q?wHTGO2uU89ADCDwxABRxvrPGqXftiLClyVGw16TyyqnlZU+yADDn0TFh+L?=
 =?iso-8859-1?Q?A=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR18MB4009.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9945138e-cd07-4d1e-b76c-08d995a8d066
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2021 22:10:53.0414
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vmytnyk@marvell.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2839
X-Proofpoint-GUID: zEb-m3fVVPHYYtov9G4EuRhmiihWslKm
X-Proofpoint-ORIG-GUID: zEb-m3fVVPHYYtov9G4EuRhmiihWslKm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-22_05,2021-10-22_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Fri, Oct 22, 2021 at 02:27:37PM +0200, Andrew Lunn wrote:=0A=
> > On Wed, Oct 20, 2021 at 12:32:28PM +0300, Volodymyr Mytnyk wrote:=0A=
> > > From: Volodymyr Mytnyk <vmytnyk@marvell.com>=0A=
> > > =0A=
> > > Add firmware (FW) version 4.0 support for Marvell Prestera=0A=
> > > driver.=0A=
> > > =0A=
> > > Major changes have been made to new v4.0 FW ABI to add support=0A=
> > > of new features, introduce the stability of the FW ABI and ensure=0A=
> > > better forward compatibility for the future driver vesrions.=0A=
> > > =0A=
> > > Current v4.0 FW feature set support does not expect any changes=0A=
> > > to ABI, as it was defined and tested through long period of time.=0A=
> > > The ABI may be extended in case of new features, but it will not=0A=
> > > break the backward compatibility.=0A=
> > > =0A=
> > > ABI major changes done in v4.0:=0A=
> > > - L1 ABI, where MAC and PHY API configuration are split.=0A=
> > > - ACL has been split to low-level TCAM and Counters ABI=0A=
> > >=A0=A0 to provide more HW ACL capabilities for future driver=0A=
> > >=A0=A0 versions.=0A=
> > > =0A=
> > > To support backward support, the addition compatibility layer is=0A=
> > > required in the driver which will have two different codebase under=
=0A=
> > > "if FW-VER elif FW-VER else" conditions that will be removed=0A=
> > > in the future anyway, So, the idea was to break backward support=0A=
> > > and focus on more stable FW instead of supporting old version=0A=
> > > with very minimal and limited set of features/capabilities.=0A=
> >=A0 =0A=
> > > +/* TODO: add another parameters here: modes, etc... */=0A=
> > > +struct prestera_port_phy_config {=0A=
> > > +=A0=A0 bool admin;=0A=
> > > +=A0=A0 u32 mode;=0A=
> > > +=A0=A0 u8 mdix;=0A=
> > > +};=0A=
> > =0A=
> > > @@ -242,10 +246,44 @@ union prestera_msg_port_param {=0A=
> > >=A0=A0=A0=A0=A0 u8=A0 duplex;=0A=
> > >=A0=A0=A0=A0=A0 u8=A0 fec;=0A=
> > >=A0=A0=A0=A0=A0 u8=A0 fc;=0A=
> > > -=A0=A0 struct prestera_msg_port_mdix_param mdix;=0A=
> > > -=A0=A0 struct prestera_msg_port_autoneg_param autoneg;=0A=
> > > +=0A=
> > > +=A0=A0 union {=0A=
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 struct {=0A=
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* TODO: merg=
e it with "mode" */=0A=
> > =0A=
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 struct {=0A=
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* TODO: merg=
e it with "mode" */=0A=
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 u8 admin:1;=
=0A=
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 u8 adv_enable=
;=0A=
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 u64 modes;=0A=
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* TODO: merg=
e it with modes */=0A=
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 u32 mode;=0A=
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 u8 mdix;=0A=
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 } phy;=0A=
> =0A=
> Please can you also make use of __le64, __le32, __le16 in messages=0A=
> to/from the firmware, so sparse etc can help you catch were you are=0A=
> missing htonl(), htons() etc.=0A=
> =0A=
>=A0=A0=A0 Andrew=0A=
>=0A=
=0A=
Makes sense, will fix in next patch set.=0A=
=0A=
  Volodymyr=
