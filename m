Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB38B50BBF
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 15:19:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729744AbfFXNTv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 09:19:51 -0400
Received: from mail-eopbgr40050.outbound.protection.outlook.com ([40.107.4.50]:34370
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729644AbfFXNTu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jun 2019 09:19:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lFsvI8ijTFPVdOpfae92BD7Qw0QKxAI+Vpna3tnIXb4=;
 b=HfXzJ4/LBQE+0igLhZRJD+FtWrMTUZmvvcn4E7aPyI0lF5glLtKtRDXMfx1EEa03DfFlvJ7cB0yVdAKzI9DNoyGAEnwhgk3TcNFXkVcebjVQpV4DAm18LC0SV2ZS9Ptx+ROtbpa+nB20SA4ypVX7zS0hjSBN2Pi3nrWy194T4NY=
Received: from VI1PR04MB4880.eurprd04.prod.outlook.com (20.177.49.153) by
 VI1PR04MB5024.eurprd04.prod.outlook.com (20.177.50.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Mon, 24 Jun 2019 13:19:47 +0000
Received: from VI1PR04MB4880.eurprd04.prod.outlook.com
 ([fe80::cdda:87e3:ea91:f78b]) by VI1PR04MB4880.eurprd04.prod.outlook.com
 ([fe80::cdda:87e3:ea91:f78b%7]) with mapi id 15.20.2008.014; Mon, 24 Jun 2019
 13:19:47 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "David S . Miller" <davem@davemloft.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Allan Nielsen <Allan.Nielsen@microsemi.com>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Horghidan <catalin.horghidan@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH net-next 6/6] net/mssc/ocelot: Add basic Felix switch
 driver
Thread-Topic: [PATCH net-next 6/6] net/mssc/ocelot: Add basic Felix switch
 driver
Thread-Index: AQHVKEd6jTeDFHw8BU+7bFHdMW5OX6aoKZsAgAKMyXA=
Date:   Mon, 24 Jun 2019 13:19:46 +0000
Message-ID: <VI1PR04MB48805E585FF56E111E84430896E00@VI1PR04MB4880.eurprd04.prod.outlook.com>
References: <1561131532-14860-1-git-send-email-claudiu.manoil@nxp.com>
 <1561131532-14860-7-git-send-email-claudiu.manoil@nxp.com>
 <20190622205720.GK8497@lunn.ch>
In-Reply-To: <20190622205720.GK8497@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=claudiu.manoil@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 05064e1b-4cb0-4ed8-eca4-08d6f8a6a113
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR04MB5024;
x-ms-traffictypediagnostic: VI1PR04MB5024:
x-microsoft-antispam-prvs: <VI1PR04MB5024273FB4EDE5C8F4268AD496E00@VI1PR04MB5024.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 007814487B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(39860400002)(346002)(396003)(366004)(136003)(13464003)(199004)(189003)(2906002)(33656002)(76176011)(53936002)(478600001)(99286004)(11346002)(446003)(7696005)(6436002)(316002)(14454004)(6246003)(74316002)(9686003)(6916009)(55016002)(3846002)(6116002)(68736007)(66066001)(25786009)(7416002)(76116006)(86362001)(44832011)(476003)(486006)(8936002)(256004)(81156014)(73956011)(26005)(81166006)(54906003)(5660300002)(66476007)(186003)(66946007)(305945005)(71200400001)(7736002)(229853002)(6506007)(8676002)(4326008)(52536014)(66446008)(64756008)(71190400001)(66556008)(102836004)(4744005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB5024;H:VI1PR04MB4880.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: jNva/uQogUbjyI5tRBVNLIRO0zL3rkaTcmPvPraAmNCZQmAfdfuXCiXj0PfCgUJIl/B0XeTbhyExtjnYTqOlhc+7dlEsad/7rWmdwFXy4tL+r+A9wUEys1jt+avwgovImIqlk7VChqXsjZ1R5DBmcYsKKawNdOC/IEo7D1BOdqxmCS/dTQDkBD/uakG0jd1xD/vGpbUwz78vYINSJRAM7+E5r+l7QGcI7k9dQ5vHhTnU38jUmhgpzq21xD8gPiDSE+WxaTjZ30NKk4QXKPtYKwoHdpzVarqqoqj6SgehMM3gNE4kmQOs1KX1W99gKd9c0RBLgfYT66M/MXP/kH7YWUtUfwRVQtWlngtcMubSir+GX+mAgbPR10Vpx40405wILsdMVwD308/smngP9ZrSq5qE8ABfbmgOwPNQfTzdcww=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05064e1b-4cb0-4ed8-eca4-08d6f8a6a113
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2019 13:19:46.8901
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: claudiu.manoil@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5024
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>-----Original Message-----
>From: Andrew Lunn <andrew@lunn.ch>
>Sent: Saturday, June 22, 2019 11:57 PM
>To: Claudiu Manoil <claudiu.manoil@nxp.com>

[...]

Ok for all, I can work more on refactoring if we agree on the basics.=20
For instance I can change the driver to use reg-names, same as=20
mscc-ocelot, and factor out the common code.
So far my intention was to change the ocelot part as little as possible,=20
only where necessary.

Thanks,
Claudiu
