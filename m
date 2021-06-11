Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E49E3A42EE
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 15:19:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231634AbhFKNVP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 09:21:15 -0400
Received: from mail-db8eur05on2112.outbound.protection.outlook.com ([40.107.20.112]:11105
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229633AbhFKNVO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Jun 2021 09:21:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RQMDezD8jfBPL118SMxX0Y+NxPP88wCP5uSDSAXG81iSh+pOi+iSE7o86QhmD4XKKPJxFZyxu2Tu3t2KLyHFC1ynWBooA6x5H/aZbe2qV91oFBh5s6Xh13Hvg1ptaKlcG1Tj48C1V61YQorNFCASZDGGDbfpAL17KK+TJ87w+gMLVX3DZZr+XKHkH5pMOWhjqQoYSm7uAByHBib+5R4UZ1n9CYkDzD3xgSvRsDafWF2kqV52n8Vuj1tL4fSHCPnM98hAQHc6raIGvOYbkRIDBHeevrckHG01Oh98z0fBjJ+pZQWZ59facMYydO16yVyLIWAj3Ds9ti3mCZ7fW1yOCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+/aqtADfuDmvL0/xETMc2tfUPvRqhVhO01IlJrNTAG8=;
 b=EqWFXi4k2uEbD4ITrVlgG71SaBIYRMpU4Y50I/f5yDStZjKREVkXB4q++M7pj7CcPZf2oiyQAxkZlCoX4q5pESNTSllC8jKe9JC+C4qof00a3mIQSJD2QjvHnrMkxgKu7BM+k+Ohs/E0bKRlvLt90LtEdenJZQYbRAvTj9fk7W4pW+rwZ2U8+iY5aPZdWEh0ePuhPn45FR+gYsAhaEYE1l96aNTT+iVh7EwYrdHJ1ZjB8WliTVcd+0O8wWxmAqxF7d1Rufwu90j+LmIDwpFXO6oJXNSjDwCw5QoUrY1zeKdqCrR9jBvdm8pmZiElNaayrr9+6p9kjuRQkVggawk+KA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+/aqtADfuDmvL0/xETMc2tfUPvRqhVhO01IlJrNTAG8=;
 b=jzK8ELgyfJ2jf7dKSfC13s7zF1bhUybIo1EcT55coesIOAFxLx7uhHqwpsXC9FJIqezPPYgb4vvCxiqTxyopyFUyPMuVF/BQpC8oKc9fgDy5ampKPe/UoVp4oPpiWbMGcBn9GBe6VcO0GzoDAJfQRkDsBSPddGbaSL1Sa4DzEiM=
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:19b::9)
 by AM4P190MB0065.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:62::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.22; Fri, 11 Jun
 2021 13:19:13 +0000
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::d018:6384:155:a2fe]) by AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::d018:6384:155:a2fe%9]) with mapi id 15.20.4219.024; Fri, 11 Jun 2021
 13:19:13 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "jiri@nvidia.com" <jiri@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Vadym Kochan <vadym.kochan@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
Subject: Re: [PATCH net-next 10/11] net: marvell: prestera: add storm control
 (rate limiter) implementation
Thread-Topic: [PATCH net-next 10/11] net: marvell: prestera: add storm control
 (rate limiter) implementation
Thread-Index: AQHXXUJ5aWvncExU5U+sYOd/xLExb6sNMVAAgAGcSHI=
Date:   Fri, 11 Jun 2021 13:19:13 +0000
Message-ID: <AM0P190MB0738E3909FB0EA0031A24F07E4349@AM0P190MB0738.EURP190.PROD.OUTLOOK.COM>
References: <20210609151602.29004-1-oleksandr.mazur@plvision.eu>
 <20210609151602.29004-11-oleksandr.mazur@plvision.eu>,<YMIIcgKjIH5V+Exf@lunn.ch>
In-Reply-To: <YMIIcgKjIH5V+Exf@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=plvision.eu;
x-originating-ip: [185.95.23.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 62fe266d-5abe-4c9e-738d-08d92cdb81a1
x-ms-traffictypediagnostic: AM4P190MB0065:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4P190MB0065DA7C7217DB2DB576D240E4349@AM4P190MB0065.EURP190.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZuH7l38F1tBJfP1w9WAKI2HpAfL8UTbtiXv4kHrQqjsjSUnzNGkjowwp0LOR9VKZYyhbq0agboktdqWgEGCEuZ4V+uUYq/YGhKN3xBkRkfmdh/kdXbKdOYIIPMtxX1NVNna21h3j0FJB5HCmjGs3JF3kUIm+Dx6Arz9D0OifC91G3cPZgsnu25tuZMwaySW0yQfyjHjyJT3lTmVtxHh2KnpIWEKWh9BL5CY7QuFikwvng00d52uVB0ql/QmfvCoguNSgUflWUJq6BE3n9oV4Op3BZrDXTS5TlKBnXwzVh2EPQ4odjmwafid8iDcSZW/FdcvjkqHxwUTMgtNgSOFVwAcZ4GHFTRIxMN264AVT6RAR8RRBxHLTPFK+Ur7h9lEXpsM0byzDiT/oVmZoQc+cLXwnz/H6nNuLI+ooBn61qu2HrlWn/9i9glbUNUtlLl1yO7z+GYT4ySSb/0WOnroX38UVwg2bMO5vAnTcvOCrUIcjIa6MRjv15VuiXFEuzrgq3GWqnn/Z7N1JA/ojvbmdUrjQKqltWkH+QG8VLuwH5a/7iCqK5/v015XowoLRB2MLFNKfcNQpYojZRHfYbaiOtOBUF6KU/gcvVEHf4LAtWU8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0P190MB0738.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(396003)(39830400003)(346002)(136003)(366004)(376002)(66446008)(66946007)(76116006)(66476007)(66556008)(33656002)(6916009)(83380400001)(5660300002)(44832011)(478600001)(64756008)(26005)(7696005)(2906002)(54906003)(8676002)(52536014)(86362001)(6506007)(8936002)(186003)(38100700002)(71200400001)(9686003)(55016002)(107886003)(122000001)(4326008)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?f5bcR9TBcvI4GrectuappmyMr4T5Z9Q4/jKD4c0n3w4SUd9LgNXYEMh2xP?=
 =?iso-8859-1?Q?5o8vPfJB665Jmy3LaF+PL7UM8icZvjtYyMVfneAvk+2Cul03Z+/EOfYoER?=
 =?iso-8859-1?Q?+uzj4610+lfqjddmMorIRDlb5X+kTGln+3uB17Snwj8lfhhJq9a4tDDWan?=
 =?iso-8859-1?Q?gibRoyu5WcyUl10rTTxU6Im9UWZx/OUyQJtBUf8v6Ka0r4joUJaOX+uCdM?=
 =?iso-8859-1?Q?8vufDdcdCI2/cpe6OVUM5IPGKkyCd7KMwkgxLFEnMMVoS5GTV9FlvhQ/LR?=
 =?iso-8859-1?Q?nIPuBW6pMEBg/uhnrFEuAgVAXOZMjlWlt/r11Kj1qJVs4eCgMreQJ4bfQo?=
 =?iso-8859-1?Q?AcmZMeLNKRtCwr0jjzdnv5jQ6vU9Mr1gZS3SHam83YBJZIvsSyk3DJU6EB?=
 =?iso-8859-1?Q?f7tWp9GZ9s+a45QLPxEy5BtZ5Y0mbLe1vzCIT57JoCiDklhIPkQvmAK1+S?=
 =?iso-8859-1?Q?1FTmWl1cPdw/YcTVfip9/r6Wg0P0n9GHWg+PJ+o6qbdaeSfSXZdU097P4d?=
 =?iso-8859-1?Q?KX5TnjP4kZ+8bMNnXzcuPhmDEaPEK/PUZiz5Vc23UMPfD5hHHALJmsX0uc?=
 =?iso-8859-1?Q?c+bRm5DCj/DwiynaXbhmpSsL0V0cmsOKoK2k29Yg2mVfXHVd/1M7j8Bn8K?=
 =?iso-8859-1?Q?ErGxLenJc8bhB4P+VQvzri+ToeNlF5N/M4D3Go56hodG8iEWYnWtiTmy1C?=
 =?iso-8859-1?Q?/NqwbnQmT7bQ52TgPTziVgVcDvgLU7dLjSURY9Pmmyvgovd2DqJpzndp/1?=
 =?iso-8859-1?Q?j3V4zsppWxZTbGlBA1YIpiYDJtn93gk5Jh0FDy6nEhXJk4Mxn9U4q/wXst?=
 =?iso-8859-1?Q?OFcXcVNS5jDwVLymfe4nbgNKhkQTmlM12HdIVSH0Y1maKJ6F+YFZb9bN85?=
 =?iso-8859-1?Q?9dY4ds7qeGpDIwvD/4NnvMDFXrPr/C/anDICOI6SJ2CZ9ziMgP72mgmY+5?=
 =?iso-8859-1?Q?kdRHDCG7CYvBmlkoXNQlLeLxVwWdsJkgTUCDQKsbEU2PAiuMkNHjOL3lsH?=
 =?iso-8859-1?Q?MolnrejrbivgfRgfjSr2792iswknBfxHW0gjDGsHVuXEqnSw9ASLZ8bjoX?=
 =?iso-8859-1?Q?PAk6GuNezJ/Ty1d/YrhJ1uW3A92XTqC8xMcHSV7OtA7S2JV5PXGig89Zbt?=
 =?iso-8859-1?Q?UKbDZeZ0jOVLq0YlgpnL4lKGdz6CvN63LMF1yV8xYvBiPD+GANvjSd9BjQ?=
 =?iso-8859-1?Q?C1nHT21WPVYLnaOWytKq0YC0VFHraXdzT4pKvVV8Zam3fd6vddzuV0fXg7?=
 =?iso-8859-1?Q?3d2QRX2abD2T7fm4zoCfZN4/cQDRu38GT5/0LBMIuHS3KS+ieLrACBCDIg?=
 =?iso-8859-1?Q?J+EsgYuUR+9mo1tLHsatBr8VO4jinBIjX4pPXkUJc5nK8J8=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 62fe266d-5abe-4c9e-738d-08d92cdb81a1
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jun 2021 13:19:13.2503
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UO67Q0hvHX6q71uRePR9uizYSCD7FuG+Sl7hXZBxSUc+yG0gUQ9SKuevQeB6xE+pdAU14p9/rL8QXGdjEn3wXfa2ztuRVwJtVj71yd5LwlA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4P190MB0065
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>>  On Wed, Jun 09, 2021 at 06:16:00PM +0300, Oleksandr Mazur wrote:=0A=
> Storm control (BUM) provides a mechanism to limit rate of ingress=0A=
> > port traffic (matched by type). Devlink port parameter API is used:=0A=
> > driver registers a set of per-port parameters that can be accessed to b=
oth=0A=
> > get/set per-port per-type rate limit.=0A=
> > Add new FW command - RATE_LIMIT_MODE_SET.=0A=
=0A=
> Hi Oleksandr=0A=
=0A=
> Just expanding on the two comments you already received about this.=0A=
=0A=
> We often see people miss that switchdev is about. It is not about=0A=
> writing switch drivers. It is about writing network stack=0A=
> accelerators. You take a feature of the Linux network stack and you=0A=
> accelerate it by offloading it to the hardware. So look around the=0A=
> network stack and see how you configure it to perform rate limiting of=0A=
> broadcast traffic ingress. Once you have found a suitable mechanism,=0A=
> accelerate it via offloading.=0A=
=0A=
> If you find Linux has no way to perform a feature the hardware could=0A=
> accelerate, you first need to add a pure software version of that=0A=
> feature to the network stack, and then add acceleration support for=0A=
> it.=0A=
=0A=
=0A=
Hello Andrew, Ido, Nikolay,=0A=
I appreciate your time and comments provided over this patchset, though i h=
ave a few questions to ask, if you don't mind:=0A=
=0A=
1. Does it mean that in order to support storm control in switchdev driver =
i need to implement software storm control in bridge driver,=0A=
and then using the switchdev attributes (notifiers) mechanism offload the c=
onfiguration itself to the HW?=0A=
2. Is there any chance of keeping devlink solution untill the discussed (st=
orm control implemented in the bridge driver) mechanism will be ready/imple=
mented?=0A=
=0A=
Anyway, it relies on the port param API from devlink which is already prese=
nt in the kernel API.=
