Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B93361BD1CA
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 03:39:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726450AbgD2BjT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 21:39:19 -0400
Received: from mail-am6eur05on2074.outbound.protection.outlook.com ([40.107.22.74]:6244
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726363AbgD2BjT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Apr 2020 21:39:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z6lIBKNbviF107tz7pu6dbl3mTad4j4hfx55XmK35FbKqSz84KCsN+vC4J719a75rEN7gclNhZLUMWljM+7+ojWUxP9hSgguioerSQcVCFipjTPzyUqxYEZA/kf0Kt+zlkA7xk8DJJ7vhutEwiHt8cXmIiQECKQcmDLuOMCjc9PG5GIEcua2Sj031asNfi5gZStOrr45jKMApkuagKt1TxTX40JvuRE00TeAMjDrEzYivR08N3bQR5zYACEhlfAm6DWQvqugfM6Wbj5WuPRPaMqycLgMRNEKwan6vZFXwmZlFmyWyn9TXH4GD1d41A34qf3EX2srPu0DDAbuPWZWeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BE/fs1Sf95dvBPza1yoJpjDiUj+AIKBN6AMIw3RBGks=;
 b=W8cQ32JY2LTys9LfHkDnEXRjQY4bLBbUkQ8iVTD0cF56dZDnQN9+UstzzPT4YyHu5LxuHeP55BShm67RtQAZMATgRGu9d4BGv23XS9wN3GquXHZYcSWrR2PvGzBWLWT+4cKuM3VPkYQ5fizsonUcf/PggjKc6DX6iAXg7617+9M4pQD4BLqbuChvA9IP2nh4NDISQ6wgtvi6XJNNSy9YwOZcb/IAiYD4tzTGuItokwY/Qfq5MnrauqvFq4rBbAgG1JbJ7a0HRYJsgljIl62AbrqYMAAoKq3bzZ+X0IsDOJET+fsrq4pMOJqxzn0YiVLUlv3XzekSNVgoDuQXR5Krxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BE/fs1Sf95dvBPza1yoJpjDiUj+AIKBN6AMIw3RBGks=;
 b=nmD6ppTybK6rD0t3b/FmLTLj+8P6SWnd83gHnIaOpMUsAWvOwjaZtyBOTHbvaJOvNocQa6tA2jyhs1mCstqxCCq+Z1kSLYXeJFtBNghLayNBfpNpJ+OfL5QuhOW7Nx++X54dGncezwcPp1vsc7qWvXTKvlmef9ZSnM2j+fTKZ2s=
Received: from HE1PR0402MB2745.eurprd04.prod.outlook.com (2603:10a6:3:d7::12)
 by HE1PR0402MB2844.eurprd04.prod.outlook.com (2603:10a6:3:d5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19; Wed, 29 Apr
 2020 01:39:16 +0000
Received: from HE1PR0402MB2745.eurprd04.prod.outlook.com
 ([fe80::e802:dffa:63bb:2e3d]) by HE1PR0402MB2745.eurprd04.prod.outlook.com
 ([fe80::e802:dffa:63bb:2e3d%10]) with mapi id 15.20.2937.023; Wed, 29 Apr
 2020 01:39:16 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     netdev <netdev@vger.kernel.org>, Chris Healy <cphealy@gmail.com>,
        Leonard Crestez <leonard.crestez@nxp.com>
Subject: RE: [EXT] Re: [PATCH net-next] net: ethernet: fec: Prevent MII event
 after MII_SPEED write
Thread-Topic: [EXT] Re: [PATCH net-next] net: ethernet: fec: Prevent MII event
 after MII_SPEED write
Thread-Index: AQHWHYcVlLrqMjQakkWrVXiKqyb/oaiPUrUQ
Date:   Wed, 29 Apr 2020 01:39:15 +0000
Message-ID: <HE1PR0402MB2745095AA448E122B8099156FFAD0@HE1PR0402MB2745.eurprd04.prod.outlook.com>
References: <20200428175833.30517-1-andrew@lunn.ch>
 <20200428180144.GA30612@lunn.ch>
In-Reply-To: <20200428180144.GA30612@lunn.ch>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [101.86.0.144]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b096eaf7-6d39-4570-d54e-08d7ebde20c9
x-ms-traffictypediagnostic: HE1PR0402MB2844:|HE1PR0402MB2844:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <HE1PR0402MB284444CCBDD68BDE877CC61EFFAD0@HE1PR0402MB2844.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 03883BD916
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LSIhIhDqgPuGOAvUvfw3UGLkIFTadVvaekz/ILzgZOKPz7sRiujXaF+cD9rPlbCiX9kcNqjFpMdIzbIxORRmxs23dQdM6Qhu06d9SzP69o+/E+XHqUVq/52S2SqRIHKMhTVcoM2mtEMJLenANLqM3/p9J91bFAPsFoZm341+dGEJ5ZcbKG+DudtOsAYaAGe3g7RRAAlhH9ZiuSb8cVkAw7z9NxfbU1QI66WKim4lvdg3RqpBTCsR0reHhxbAOQXWWD5qR3FJChlk81jdX9Yj187GEy7BMFBhN/ab6VcXy4XGbXwEWzi+vcTADNzgRdLskd73abvNnJa4xh3ab3bJ8JXrb8KSUwVUmL+J03TKNDIquHh2uD9Wbj5c8GRG7eneH1yHXyaw0J9ZLoWQEDs62x3OrzP2VO5qwO3amxz/++Wu8PCfUNFlRQOF20t4lSWa
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0402MB2745.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(376002)(39860400002)(136003)(396003)(346002)(52536014)(76116006)(66946007)(66476007)(66446008)(5660300002)(316002)(66556008)(54906003)(64756008)(4744005)(8936002)(6506007)(7696005)(33656002)(8676002)(186003)(26005)(2906002)(6916009)(4326008)(71200400001)(9686003)(86362001)(55016002)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 7Dq3OH3s8lwg/NIVAAnozBnAzcQiV7/P2FnZB52Jq/2+e4F0GQmLAIk0l6LOvP/OgsVqY+UadtrehCIVD5QMmFqrfgI6+Yv7kaDct8zqfv1kmvun8u/5g4AubVrR+trN9hVOsamsL+sT4AFLeolCdoW37UMBvBuPRTDh56QTU90iSfb4EoSlqO0RDw/rZkBS8VoORyaf0X2gd2pfyfecQS1Ui1m3iXafJyPKrG//ymTDHvTNuEXGTfBvgVTdXUydsRQXLvbNE2qiN6iSZjwPaGpcz16laz2sOhpU8aCfp6iVwr5HJBZiXC36Tm758VgSSsdcKdh7gA4acta/fJea8BT/n1bptqhyLo8c6v/6wuLb5Ox4Mz2PuKGnq2r3vjNOeYei4aiaBm2Rg1Gdy6jjSblTFPweuTHWxfEmv+e1SfKNutRRgIid+x4JIrZ//kHivWtSWPjUnhg+BoU7iMwGGQ0QJFZwqwdXpprHk6fTCUxS+7dJ8XQSnGxm0jUGaM8JYZouhUcUyNLasfuCOhF/o5Rt9d8HPqZY3g/1K1kZgOHv673U+aFzjugVTprdzBXSzdQmmKspA9hv7eF9dkVwiCcOIKLj4kXxRasQpUcjFIH2KWJ5EY3GnZiILCfp5VAU5ZtjCiXXFJwEeYeAIeLtHNppKZM1ssgc3PRtD9BG1BqVhwcLiQROyAG9jata1nfJbj7wYr4UzLs2OhyN9jIMvNvFUzEGV8fVAMrOd9JQ3ffHAptgc1iey5mcrhDPCdkE90AumYEPFaUDd5VQQBGU3rNGFi36pzZ3fbnYeqnsJSU=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b096eaf7-6d39-4570-d54e-08d7ebde20c9
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2020 01:39:15.9900
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IE+Vaitb+uT0D18WEji9tsqwh6RQzXGz9IN75+UyliRIvqNw19DNvGY3DO6ZaoFFBGlygk+yZ9YMuIc8pQN3AA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0402MB2844
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch> Sent: Wednesday, April 29, 2020 2:02 AM
> On Tue, Apr 28, 2020 at 07:58:33PM +0200, Andrew Lunn wrote:
> > The change to polled IO for MDIO completion assumes that MII events
> > are only generated for MDIO transactions. However on some SoCs writing
> > to the MII_SPEED register can also trigger an MII event. As a result,
> > the next MDIO read has a pending MII event, and immediately reads the
> > data registers before it contains useful data. When the read does
> > complete, another MII event is posted, which results in the next read
> > also going wrong, and the cycle continues.
> >
> > By writing 0 to the MII_DATA register before writing to the speed
> > register, this MII event for the MII_SPEED is suppressed, and polled
> > IO works as expected.
>=20
> Hi Andy
>=20
> Could you get your LAVA instances to test this? Or do we need to wait for=
 it to
> make its way into net-next?
>=20
> Thanks
>         Andrew

Yes, we need to wait for linux next.

Andy
