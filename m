Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 615B23B24D9
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 04:19:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbhFXCWM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 22:22:12 -0400
Received: from mail-eopbgr60081.outbound.protection.outlook.com ([40.107.6.81]:49725
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229759AbhFXCWL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Jun 2021 22:22:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oT+92rYMacgHSnkEGPmHcp8b7Wbhj8t/a8iL80YxDYgJH7UuU/q7OFSzlcM+ZTj+2//KRLZYLJV+HRZdCeJN9OcO1f+vidKtEV99nKU7Q2MYEiN6hmXjmkf+JQCt5GTrCNRMd4D/DkfMFxKtwQYIfbRxzFjQS9CXAgU6II3SwraCzSMuFnYpcFgJQ6Ct2HjQOwzin0/5ixrg33F+VhK1PpRBDZGzHhB2LtJtopSwaIGk0m2yV/v0B52jxt/eqLLeZfavqIKs3NmA+bRVkyVqRE1OgdUAy8VkyMjVwAWUwwf8BSbp9jNSaQ0h5/l8q6IivbMbdFEHDHizZUjQzpO4/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JNkvtLumL2wvyRNCP5MPqiFHUnWp0gpWOfSBn8rZmGg=;
 b=HoPL6n9yJbE8krzmybYfINVkttWr0sMARXwhv1pT9Q/Kv7tD6w+4s9vQ0RDP6OtROqKGuwH3+sP7o7schm1snAgDg3j3myMvHCHaKSKH+vEfRDGlz5Rf+hDojUw6FRtkUxlxcre+laayQO/kTpILgo0C8GeEIouizcrISW+BTnyRg86Ef9H7+JXQeO1AkSGDuK3MzL1wgAIQCJVlIu7D9N9+EB8U15c/hMgJNp/ht8Nr0Nem1TE8Q5DARJm24UHhQWNyg8/ZM12jH4/77PTFzbfAbu/ykIXYLQILxpw6xTaetPKRNb9tUbKdUBnDN/E2tOuVAgo1Hdd8xCzkS1tfTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JNkvtLumL2wvyRNCP5MPqiFHUnWp0gpWOfSBn8rZmGg=;
 b=o9gX8efL8kypzYQGw84cCXY/y8F50k95D6NKa/Lao85YgwknN5CspQeGygkbgVUG7rY5Q5jP8CxKHHD1/FAyeRY0K1FT9S1o+XSxSbpsuB6A7Og+o6qlGJT31QmH3FICJ2KJkd+XKN1+/yddGUW/paMppOfOUVqcdKsZGtFHdng=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB5787.eurprd04.prod.outlook.com (2603:10a6:10:ac::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.21; Thu, 24 Jun
 2021 02:19:49 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::f5e8:4886:3923:e92e]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::f5e8:4886:3923:e92e%8]) with mapi id 15.20.4264.019; Thu, 24 Jun 2021
 02:19:49 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Lukasz Majewski <lukma@denx.de>, Andrew Lunn <andrew@lunn.ch>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Mark Einon <mark.einon@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC 1/3] ARM: dts: imx28: Add description for L2 switch on XEA
 board
Thread-Topic: [RFC 1/3] ARM: dts: imx28: Add description for L2 switch on XEA
 board
Thread-Index: AQHXZ3S0rjpj2HsO7kKyP5U2LAA3HasgG6aAgABmNgCAARNlgIAAJB6AgACZzYCAABfeIA==
Date:   Thu, 24 Jun 2021 02:19:49 +0000
Message-ID: <DB8PR04MB679567B66A45FBD1C23E7371E6079@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210622144111.19647-1-lukma@denx.de>
 <20210622144111.19647-2-lukma@denx.de> <YNH3mb9fyBjLf0fj@lunn.ch>
 <20210622225134.4811b88f@ktm> <YNM0Wz1wb4dnCg5/@lunn.ch>
 <20210623172631.0b547fcd@ktm>
 <76159e5c-6986-3877-c0a1-47b5a17bf0f1@gmail.com>
In-Reply-To: <76159e5c-6986-3877-c0a1-47b5a17bf0f1@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d8cacdc7-f5aa-469b-1458-08d936b68b0b
x-ms-traffictypediagnostic: DB8PR04MB5787:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB8PR04MB57873A567297DB23F8C38522E6079@DB8PR04MB5787.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LyQFRA/+wN1Z0ZhV6bRlAD/hIPnooihChZmgLo0EAMKO/YYYEc1RYCN1k1opdmIaMBmkOIGkZzUaV2uITralcPvBBJ2gXOh4GepBvLyYjv1T5DE9aMNVhuFF8YLns3lCNw84yviPM1hio2rK/FglHAhl2u9+gR74BgnFZ9Jw2RLe6XDHc28+Nocyp4JBA5ftf2sBw8OibDG3EXYJo5fx94tY4TEWDulj+y2zABhhSl66gyQYuIv7PaxDbzxRhamOrQGIcEkDG4tHV+nWBe/f8Xptng7vdRlSReoMbBfK0vPf74KLFI6f8DQN1TaBu+9479uYeEqo8MpQ90Y1vZUdipupYu6p7hzqmEiKG1WP1Q83za5javNX9u6apkIKk8i00J1ujsFzVSvs1EEgBwP9dIe7Bc8DAoC0OvPyoR/GrIA2iTqEAHU2yxxBmzrtMupkcm66JMNR+eyF3Ln0zvhHunWIb6Jz/oDdIFayJV03X+THTjY5iUm2Z7Ypr2dxg5CDntCD9Bd86Bd6o7qlvTG75JcRhLiALgz3085RG6Xf7fYVzmgfTlrvd+WVjnojpGOX44/RS5wX3/vfAg/K9//8Q92/khTcVVwnrNSUE7N8jc4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(346002)(376002)(396003)(39860400002)(6506007)(478600001)(66476007)(66556008)(122000001)(8936002)(55016002)(64756008)(66446008)(54906003)(110136005)(7696005)(86362001)(33656002)(9686003)(7416002)(316002)(5660300002)(38100700002)(52536014)(2906002)(66946007)(4744005)(71200400001)(26005)(8676002)(186003)(4326008)(76116006)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?rIY5Y/28s0jOKGahy7DNyPHALfdI4VWpcJf2sHnPu6BcxT0VoZNvrWu3FpGL?=
 =?us-ascii?Q?GSLLOHDSMbzr9uTBR1FjYtCkYWMx2oPiWP5bE/1m3rl/yK7+Gi/QvyhrzXF6?=
 =?us-ascii?Q?tTeUybSLYRuGg052wvJ2nxGaVwsU+69RBZgXY+vtoVJx4SMhaBVQPdvGodMs?=
 =?us-ascii?Q?/Y0rZtdw4+cp7drc9RptNhPe0irWGTe5PIfgCLk4OosOzjZYOKM+eZDmTFdJ?=
 =?us-ascii?Q?g5vfCu6uRLMyLk2X+MqYa8gf6bRWZybDjLHWmad4ohNU98Wau1PlqBMVLgTP?=
 =?us-ascii?Q?yKcDF0zpkRTt6hT3M4dZ4OCmZWfmdl/Jt4BYDSICgR7UoXc5h5UTCLcf1L7R?=
 =?us-ascii?Q?PRvNDz/5QwZu8ZQMJlucOkNh1+Wr3DS88NMijfK8cwtEOgjPeIVQ9tyqlZqC?=
 =?us-ascii?Q?Qx233ZmeGULz+ZSnCiwkO5kFmsu8O4yzMwuVCN+gW8pHpbJcxHipPo+kX8qs?=
 =?us-ascii?Q?J/0bSy2iOkndtaAAzN5SwQKdah7gXBIltGBBM+Rax28xlhn4HzM2jwlAOfZ5?=
 =?us-ascii?Q?6N6sO7v+bTzCJM8K+TcLCJZtI5DrmWDv+75jPAHFNJRf2cZWqxBKG2eIeWIn?=
 =?us-ascii?Q?TbgHuEZG8+Hm/pIqhjUas67EpbuqzUiA6eA/1ID5aQ/7IRCMEHvj6hj0vY8L?=
 =?us-ascii?Q?Nx+adhD40ZYfTIDylhUC5Ymj2DIDQtcWgdhJ4pbPO5RIFa7epBN1yH6tt3RQ?=
 =?us-ascii?Q?NCpjogFOisOywRSsjMi5ByWn2N4uZEI3owL6ANI25STJTDDQusbXEY681VEr?=
 =?us-ascii?Q?Ua4/Pts0vaPuAQA3PQwEARwENUq0NIAb0SR6K2qvgeSaEfwxC7OUV85WzJof?=
 =?us-ascii?Q?F7lXHU5TzNSi3zHGB0fVa73EnYE1uo7QhINrI6ajnX4DsQSznMZnd9YHMneN?=
 =?us-ascii?Q?WyHD6kTLQuiHG961g8MYUYteHifXlFRNJvJQIMobEoLALXoQjIDK2unSbiZn?=
 =?us-ascii?Q?Gt5WqdX6dJxNDdiJ8pTRKNR4+dS4Ow6XPLpZiZW6XwoU72hDJHzq8E3FSZ99?=
 =?us-ascii?Q?x6LX5Kj35qTchoCEatl8GcAcdYsuyd3MiMn1cnE3ac4Sm+RVEincptce5T6G?=
 =?us-ascii?Q?mvSYHmrsrOfsqPkWybqqRr9eKzag1mentTKBrJOtev/a8CkiXWN74rlktYVE?=
 =?us-ascii?Q?UIcf+JofTkAD4PamCA7Gm9IGl/XE1TbSomphjDvAbvnCKTuPI+Yj7SM5AdS3?=
 =?us-ascii?Q?x18M7xnBB1q3yGJoWBmDVtVV3ODZ6AElH8ipar9+Xo5vmHqVxepjblV3LoL8?=
 =?us-ascii?Q?4MCciYdgWC0//8tQlIkuVOyKYdTMjrDejv3IJkijySV+62n8LqlP5V+bQzLN?=
 =?us-ascii?Q?OIk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8cacdc7-f5aa-469b-1458-08d936b68b0b
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2021 02:19:49.2978
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wiMdCtKEtbSJGoH5HdzaFZ7VcYv9WwU4ikgnZ8/SmFH29DsXCjAuod3kFfXHEN+oaul/CZTDU+6/SPPsX4hGhg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB5787
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Lukasz, Florian, Andrew,

> > Maybe somebody from NXP can provide input to this discussion - for
> > example to sched some light on FEC driver (near) future.
>=20
> Seems like some folks at NXP are focusing on the STMMAC controller these
> days (dwmac from Synopsys), so maybe they have given up on having their o=
wn
> Ethernet MAC for lower end products.

I am very happy to take participate into this topic, but now I have no expe=
rience to DSA and i.MX28 MAC,
so I may need some time to increase these knowledge, limited insight could =
be put to now.

Florian, Andrew could comment more and I also can learn from it :-), they a=
re all very experienced expert.

We also want to maintain FEC driver since many SoCs implemented this IP, an=
d as I know we would also
use it for future SoCs.
 =20
Best Regards,
Joakim Zhang
