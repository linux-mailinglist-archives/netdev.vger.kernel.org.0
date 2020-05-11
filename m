Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9030D1CE480
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 21:32:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731423AbgEKTcK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 15:32:10 -0400
Received: from mail-eopbgr70059.outbound.protection.outlook.com ([40.107.7.59]:32386
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731199AbgEKTcJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 May 2020 15:32:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PkmsPt6s026EoCOvPFvmBUFyJQujJ8f5HRFxCa3uFbHbgh6ubE/RUZcz4ZBD3VHvwj20vXFMeFppjyjJ/qTpeYRqkz6iaJOCGDw9EON5A1FxrR5DDmlzsQ81g0SXM+dm3iyRcZVPIC82y7QLA4PbABxP/08WPS7PGL9synFmQ9oNQG7+RunLCKaXXWFtsUcBVGSsGm6cu4PsEumng4mqgwEah4H/q8bkUq705oUe6jgdJX9XL2p2y2FmJUuykCdaJD9043d2j5TTRg/yWMTSmBe72YVCvXl34MfMPjRYrnXXCeDDZBo3FICLJ86NYMzpQNqbvfyIh10T6QQ5GJECJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fK+qszBePQZd22vqz068pkGQUQypGtBzdjrE1sBA1TI=;
 b=jIae/1aS4asdo4RMBnHAtrk4Uc8aMbH/abeGZtLN3RgoHbY6n8fm++chtUPwK0HC+En7EwvL9LwSnZb9V8rFhK8FMl5UNTalco8nDENs7MBZvU6Rq/KlnWSFeY+IaaLyWICxel52fcs0wyQgk6cyvFjBR7cPjrxA6Etwjf1Nvhs2eG16uZuS1dvLRy/HeGU2io798FfX6hLAO7MpAf21YJjs/fWPFXg/Rey39XS0hDO7ImVFPFqqvDWXG41U92yQVVcG42M4Fctp2vKOYIjrvt+ZlkghNdGNs7H5vjtE6ecdLfyJaSYZJMQm2DSuKDlKrDnmEhnSSi8TCIfj50eI+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fK+qszBePQZd22vqz068pkGQUQypGtBzdjrE1sBA1TI=;
 b=Wykyy4kNlZei1F9RTiQtpP+46xC5j1321h8GkdCyBAHMbGPZi9kbuFIVMblumPBGDCuaJTipYhGUnRBi4OGXez+CMvilK0lgQ/RWwet/D0faEd7+AsA5CoMO4u8gTGeVUJIM6wN9cFEHqc2A5+C43nrlYDr+gPkjLrJ+mmTfcG0=
Received: from AM0PR04MB7041.eurprd04.prod.outlook.com (2603:10a6:208:19a::13)
 by AM0PR04MB6356.eurprd04.prod.outlook.com (2603:10a6:208:17a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.28; Mon, 11 May
 2020 19:32:05 +0000
Received: from AM0PR04MB7041.eurprd04.prod.outlook.com
 ([fe80::1cab:2a78:51cb:2a00]) by AM0PR04MB7041.eurprd04.prod.outlook.com
 ([fe80::1cab:2a78:51cb:2a00%9]) with mapi id 15.20.2979.033; Mon, 11 May 2020
 19:32:05 +0000
From:   Christian Herber <christian.herber@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Oleksij Rempel <o.rempel@pengutronix.de>
CC:     "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        David Jander <david@protonic.nl>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        Marek Vasut <marex@denx.de>
Subject: RE: Re: signal quality and cable diagnostic
Thread-Topic: Re: signal quality and cable diagnostic
Thread-Index: AdYnygHjlwz8mecvTV6Sgw0PGhSTqA==
Date:   Mon, 11 May 2020 19:32:05 +0000
Message-ID: <AM0PR04MB70410EA61C984E45615CCF8B86A10@AM0PR04MB7041.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [88.130.52.30]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 15c89018-82df-4792-9e90-08d7f5e1fd01
x-ms-traffictypediagnostic: AM0PR04MB6356:
x-microsoft-antispam-prvs: <AM0PR04MB635616DF7B6229D66743456A86A10@AM0PR04MB6356.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 04004D94E2
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iyUqZLywB896OmabTy21MBiXg4ry8AoQtFtxC5ed9NDrxlLrYiGcyx+kSA+Me2c5XtwkChzPVNKXg9PeACoumABFryR8KFtizZ1yVSsSTh7s/KStsuEi8lJmmKQ2yW9cG1Czep9NK1h29TOzmjAqg1h8Nftk6aoAUHsR6+YjZ19ldCHLoN2yNjdyVu3LoyLauBvyjJbrjv3no155JUi7JHNQ0abUbe3c4NS5D3iWXJXNUCf19wdA06F/nfkvbW8oG86Xf9cmZoPKJ2d7KgxCJlpnn4ZwrUC4+sUlvUbGxSoVNk2wodotozkyadefda0yYPvrj4tvMoMaaKNC4JK2Faqn7ijXXBOkOE/Lyj47akrbV32Bjs7FEQaEgee9mIzUE8E2GUCX+3P/UO0ZkwtJ32CQvM2itBEUtQfJTJcik33JfZNp5+Gr8vL49j7eQ7MdJKEwYuV3CD+ANWMUJEYkXl8Gx5Y23RPDflSFkxEWMpwNPCzqAdj500Snqu5wEWtcqB3I4VOT8J9PkgJmlm2ifTFv17LDtjOiPksVQ97vUO2TMtZC3F9Ut7c2oHFwK5HxaM4KeW+as73l5MtjnjLyICJVwUqRoerfPxBuARPO7yk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB7041.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(136003)(39860400002)(376002)(346002)(33430700001)(4326008)(7696005)(9686003)(55016002)(44832011)(66946007)(86362001)(2906002)(66556008)(64756008)(76116006)(66476007)(66446008)(52536014)(33656002)(966005)(6506007)(4744005)(8676002)(8936002)(186003)(478600001)(33440700001)(71200400001)(26005)(7416002)(110136005)(54906003)(5660300002)(53546011)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: RHuqAUQnHJBeZwgku2VB+7u2HgVvn4RqqZ9y11Op4Vf/QFEcQF7wJYRS/nAZhQzgRVqyzIYSmAw8WIK+F01cOyUsghDIpjGIThKzFPqM4YHILB1wcDPopXYr2nN1XnT0PAwiJTjLDrJWTtN0UJDe0lzsPgm5N9Y8T9PiNPty2fgpKX9kUlz/KFzU/+FDX24+fHeHIAU51TZAgUhh7my+y9m/ww9uW6GQfgrsJZRzxaHR1x2gwsNeUJTHjDBNRYgAPPag2sxs/KGKu2OjteeqPeRE3cWDkXAp+TNW70x91KJs3Kh1MeGbwKxvtK2L/DJb01CESicz/qoMjhAc9el4l6ng8LAqUhqYZ2jTc2MEr835y3KWiEyO09PwEMnQ4vDAQZdGroXQH4OUPCm20mST7fJ8iJaEwIln/Zx9YqeJer6pNU9svkT5fgp3+FAhxr3McPCBg9RuaBg6cFWb5AdqKBCXGd37dHI4d99o4yLf44I=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15c89018-82df-4792-9e90-08d7f5e1fd01
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 May 2020 19:32:05.5889
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FVHfoMTt10plXaAlkDO4mfBt25Szp3jvtyax0QxmFBUacRWn+Wqjhu0WfFXcSsj4hxNKFvY1lGUhXEfgByaOcjVzlBsBm2V0Kp5UMLCOGfs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6356
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On May 11, 2020 4:33:53 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> Are the classes part of the Open Alliance specification? Ideally we
> want to report something standardized, not something proprietary to
> NXP.
>
>        Andrew

Hi Andrew,

Such mechanisms are standardized and supported by pretty much all devices i=
n the market. The Open Alliance specification is publicly available here: h=
ttp://www.opensig.org/download/document/218/Advanced_PHY_features_for_autom=
otive_Ethernet_V1.0.pdf

As the specification is newer than the 100BASE-T1 spec, do not expect first=
 generation devices to follow the register definitions as per Open Alliance=
. But for future devices, also registers should be same across different ve=
ndors.

Christian
