Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81C1726D14B
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 04:38:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726199AbgIQCiJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 22:38:09 -0400
Received: from mail-eopbgr40081.outbound.protection.outlook.com ([40.107.4.81]:2405
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726134AbgIQCiF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Sep 2020 22:38:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HNtrTa5P78zS/1PUa+uTgKaf67gjfaPCe0OZNKJZ5BJLBINXVmTaTNzTBZ4l2d/vBSry0v+olY8LmCukdampYE0MQZbNYXPfMHrmVJi+lQwXl2upf6BOPdjcIukPoCGtKUGPM2L2pNER4V7/Q8yxwyz+uWAerTqOsUN4mpvPd7WKd9SBrI7TaAbOdO5e/RPTshfPdmCZVfrKViPlru2dp/MZQyLfWlPC412xsyrenyuU3fC0og+jtlY5DClQnfculo8HvfTh/SxG+saTl6Fp2eN7RCRM5cQ9Zn1TRwuVuIY7wEEoSfkCwc5SwmICh+WukfbsM516WI3eaKMbtGSB3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AfGitc2p+z3oJ3azflLvEB7XiwwjkFU9Y2vOCN6YLBI=;
 b=LmIzShVWvnR16HZ5udEmCzbC5Uc0bfeV1mtfuiivI+UNTv/qwLLUoBapFTqC0EL5zhAmewrn3Ae7JAuAMtI4dlRb3caIW139cayDmnscEVVmysUmfaVC04Fz9LGRK9Lezim5b3C5UKJOGZcESJNtIQW9rE+0dmqeiB0HzhUhwJ21Ye0v4h6HP1OAtfD9Nja/DHNikJ2mMatqTz/JeSo4C9Ovoccyn8YUbK1Xh6h6aNnzmm6TG7daEQ1gWnB/BWfMw0w8w5FhO3nC+DzfUWrp/P223BNLlic7vdZzRUaqmmn4m/ClW3CuRx7Fg40X0Z2N+n1yaW7VF0JOUja43ilG/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AfGitc2p+z3oJ3azflLvEB7XiwwjkFU9Y2vOCN6YLBI=;
 b=g1zTUxC58IX0LnirRhebddMsvt9LGRU+bco+ULg3not0pmgJXBm4vl0rxCZDVzpPZwuMvwJDeDv9KgJkl8bmWLBwmkvCm+6aw3gcyB9Z4VjRlirBVxQAguA8XP9rEaOpoDddlsz5ELf02k33WZepKRRLekaZCuH3OMVBbNU1AAc=
Received: from VI1PR04MB5677.eurprd04.prod.outlook.com (2603:10a6:803:ed::22)
 by VI1PR04MB4832.eurprd04.prod.outlook.com (2603:10a6:803:54::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.13; Thu, 17 Sep
 2020 02:37:59 +0000
Received: from VI1PR04MB5677.eurprd04.prod.outlook.com
 ([fe80::c99:9749:3211:2e1f]) by VI1PR04MB5677.eurprd04.prod.outlook.com
 ([fe80::c99:9749:3211:2e1f%5]) with mapi id 15.20.3370.019; Thu, 17 Sep 2020
 02:37:59 +0000
From:   Hongbo Wang <hongbo.wang@nxp.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>, Po Liu <po.liu@nxp.com>,
        Mingkai Hu <mingkai.hu@nxp.com>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Leo Li <leoyang.li@nxp.com>, "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "idosch@idosch.org" <idosch@idosch.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "nikolay@cumulusnetworks.com" <nikolay@cumulusnetworks.com>,
        "roopa@cumulusnetworks.com" <roopa@cumulusnetworks.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "horatiu.vultur@microchip.com" <horatiu.vultur@microchip.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "ivecera@redhat.com" <ivecera@redhat.com>
Subject: RE: [EXT] Re: [PATCH v6 3/3] net: dsa: ocelot: Add support for QinQ
 Operation
Thread-Topic: [EXT] Re: [PATCH v6 3/3] net: dsa: ocelot: Add support for QinQ
 Operation
Thread-Index: AQHWjA46YADFMZ9LUEuuxHMi/AxAAKlrCEcAgAAAYCCAAAxFgIABBM0Q
Date:   Thu, 17 Sep 2020 02:37:59 +0000
Message-ID: <VI1PR04MB567793A76FE2EBECFC6D8E76E13E0@VI1PR04MB5677.eurprd04.prod.outlook.com>
References: <20200916094845.10782-1-hongbo.wang@nxp.com>
 <20200916094845.10782-4-hongbo.wang@nxp.com>
 <20200916100024.lqlrqeuefudvgkxt@skbuf>
 <VI1PR04MB56775FD490351CCA04DAF3D7E1210@VI1PR04MB5677.eurprd04.prod.outlook.com>
 <20200916104539.4bmimpmnrcsicamg@skbuf>
In-Reply-To: <20200916104539.4bmimpmnrcsicamg@skbuf>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: fd79134e-7432-4a1a-fa7e-08d85ab2b113
x-ms-traffictypediagnostic: VI1PR04MB4832:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB48328A521405E4449EE695B7E13E0@VI1PR04MB4832.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QTlOoxgcUn/ElLelT5apnHN5MXx++z9LUjvpJi6CHnLwPGHdomfmc2795C0z2ohMjMeGQ7VMJEkTNll4yw25wbRQa+g61Juw5kzOaSZEmo4BZ6VFlJDaVzBkubGqHWeNBOF8SQDzJxSfkF45hYzPPFzfCCTm490R2JC/CT+3PQYw7jhrgBBuXhDPqYx9y5oTljPV5a5MtjkRjCyy9qhG7qgyQ9bf4YaqWUbsXDPjyPsHZcdeekVhxoCnsmV2eeLsWU0aMqh/xu1Ljsbmp8ZaSFmUdN3ukiFpp2lIdmgRUX9fLYsa4aYBZXrAIIETatVW5fOH0+jC9FzLPiNzgY8rT71NJLGgYIP3h9PE6hEuq/EHAjAM2wLjMz93ExOCD4ne
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5677.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(346002)(376002)(366004)(396003)(2906002)(7416002)(8936002)(55016002)(316002)(7696005)(6506007)(33656002)(478600001)(26005)(54906003)(4326008)(186003)(44832011)(83380400001)(71200400001)(52536014)(5660300002)(6916009)(86362001)(8676002)(66446008)(66556008)(66946007)(76116006)(66476007)(64756008)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: xXdmx7z5PaIGxoGUre/u+gr9eHM+k0B9MdVy+hvS7eksFJxx4k29A8yneWAmuO/iUbNSGfxTuyBNSEhcDRZXSkBtq5LP0D+GW96b5Wz2GSVK8ZLQFzTGrRq3AUVGlVfGek4XvilYN0IwYPj4+PiDSLngLpBY83Jz1KRaFOimQg34bpQ8DQjH8j3FO9JSFucVjlippwGkzotd8SmQeRD3RhB9DH73i+gRIGcvvqlgdatgpTF90K0qzNbhQEvgrB0d+1Je0LlULwtfXDHWN0PRKv9xrPpCRvECd461WN4WWdLV1e+6dki3VYefU6v66EoBsY+b4CqFFdFK11y37copJRbbZNrsGGD3bzx4AJBwW4eB0z10Q5JT4BB3Z2HEk7Pr5o1DXw8T5bD13tkSec5zn1YHw2QaWCpih8rE/KGODNgGBPrUdoYzIO0n2s0GtKnrrJ9jsvBC8kaUXvb7gW1irW4FMX9zNs+byLaypJNeXqnIjP4QkKEmNHPwI+nfaZe74P3MxsWn2SnrfjxpNI9VSPBXKeJeuyUxOG3r64rfglO/eH8viRAvTM+hX09mGotUxRdPbCqGDZ1cMJnuL7+w0p/9cWTxG13N20XmLVfI0aE8phAdBMAqYsqcyHu8x/PpANNgACElQOord7Eet8/TEw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5677.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd79134e-7432-4a1a-fa7e-08d85ab2b113
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Sep 2020 02:37:59.2161
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KSKlq6bOJHsY9AJ3788yYeB0LgN17gKs88jc5bRZPa1CJ9JD68fGKG3T9xC+B1RJM6f/MTLMhL7tUtsEu8Kz5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4832
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Wed, Sep 16, 2020 at 10:28:38AM +0000, Hongbo Wang wrote:
> > Hi Vladimir,
> >
> > if swp0 connects with customer, and swp1 connects with ISP, According
> > to the VSC99599_1_00_TS.pdf, swp0 and swp1 will have different
> > VLAN_POP_CNT && VLAN_AWARE_ENA,
> >
> > swp0 should set VLAN_CFG.VLAN_POP_CNT=3D0 &&
> VLAN_CFG.VLAN_AWARE_ENA=3D0
> > swp1 should set VLAN_CFG.VLAN_POP_CNT=3D1 &&
> VLAN_CFG.VLAN_AWARE_ENA=3D1
> >
> > but when set vlan_filter=3D1, current code will set same value for both
> > swp0 and swp1, for compatibility with existing code(802.1Q mode), so
> > add devlink to set swp0 and swp1 into different modes.
>=20
> But if you make VLAN_CFG.VLAN_AWARE_ENA=3D0, does that mean the switch
> will accept any 802.1ad VLAN, not only those configured in the VLAN datab=
ase
> of the bridge? Otherwise said, after running the commands above, and I se=
nd a
> packet to swp0 having tpid:88A8 vid:101, then the bridge should not accep=
t it.
>=20
> I might be wrong, but I thought that an 802.1ad bridge with
> vlan_filtering=3D1 behaves the same as an 802.1q bridge, except that it s=
hould
> filter VLANs using a different TPID (0x88a8 instead of 0x8100).
> I don't think the driver, in the way you're configuring it, does that, do=
es it?

hi Vladimir,
you can refer to "4.3.3.0.1 MAN Access Switch Example" in VSC99599_1_00_TS.=
pdf,
By testing the case, if don't set VLAN_AWARE_ENA=3D0 for customer's port sw=
p0,
the Q-in-Q feature can't work well.

In order to distinguish the port for customer and for ISP, I add devlink co=
mmand,
Actually, I can modify the driver config directly, not using devlink, but i=
t will be not compatible with current=20
code and user guide.=20

Thanks,
hongbo
