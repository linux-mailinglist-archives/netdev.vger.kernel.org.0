Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D85331BA7CA
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 17:20:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727976AbgD0PUA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 11:20:00 -0400
Received: from mail-eopbgr70075.outbound.protection.outlook.com ([40.107.7.75]:27590
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727006AbgD0PUA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 11:20:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ifqyFPMIxDI5mfen5GYcxyNeGuKoWygOHthmCzWAcbPSr4wR64T/RVemOWHo5mbNYlJ5h4YZQNQABNzUbCdM/KtlYdUlIrF6ftA4BZtKRjWODJKhm5JIh0miXyeN7rrc8sHxX6NiCarc3LtVQ94jmwd+oujHGSHLPR1cCawACrGOnoNH9n73QHYRX8d5VXxtAAmB2DFk1kYUbRMPV7p2BNekX9bKg8Ni9my57FJA66ZhdTXprbBOcVcDr+lnlVHehrAdW2A6grwW7aR9fJ+/vib8+/zFNGjAhcHdBDUEqIIPNbIVV/GB/YDURGmfM+ZXqFCimZnnZdAyTQBXz8bZYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Q9ptLj2pq57rZftl2U4NUg1tAD6/m7On7eT1DbFvc0=;
 b=OHr8EEBFq6esopHwJriacGvIjFUFOw/DGRp7+vnHRdemfrkClYrCZIacvrlQlYJsfKuzVXEaNBE4FRZc5zwDuGY3k8/r8bipnfjruqWsgqGUasWiirnMZvaynqMHDCc1uONqmtN8XKfGRICvx/vyeKUMbO7Q6BpiV++6TT+GeLwnZsg7vaQ8AzeiiIgtWUBbGT2yq0Gz4S+Cc4qzzEmi+4CFTOMJ0rwjqsAgQEtbzpnvaf2XzBlD958C1NuWkVBSjcmFDOA75U82eZgnE5uJr1kEan4IWNhPt4JgiXerRIj6+IF7+raDK4ag+GugDt6ovyikm3/efc71bhKQwvQcHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Q9ptLj2pq57rZftl2U4NUg1tAD6/m7On7eT1DbFvc0=;
 b=TGWxBrE4ELbV6pkiiqXYjw1Fq3YLoFoptFQH/kXcqsujxluJf70OK3I90/LWrsPdRFMgwSllPRYba8l4nMKzVLI834UveEeVvidD5hO0hHuLLjFMYx2Ic4m9mn6gw52kVGYinCEWjFHf5zTpTqrjkicsp4KkNHKCFmgxVt6KLZQ=
Received: from VI1PR04MB6941.eurprd04.prod.outlook.com (2603:10a6:803:12e::23)
 by VI1PR04MB6271.eurprd04.prod.outlook.com (2603:10a6:803:f7::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Mon, 27 Apr
 2020 15:19:54 +0000
Received: from VI1PR04MB6941.eurprd04.prod.outlook.com
 ([fe80::8de5:8c61:6e4d:9fe9]) by VI1PR04MB6941.eurprd04.prod.outlook.com
 ([fe80::8de5:8c61:6e4d:9fe9%9]) with mapi id 15.20.2937.020; Mon, 27 Apr 2020
 15:19:54 +0000
From:   Leonard Crestez <leonard.crestez@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>, Andy Duan <fugang.duan@nxp.com>
CC:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Chris Healy <Chris.Healy@zii.aero>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH] net: ethernet: fec: Replace interrupt driven MDIO with
 polled IO
Thread-Topic: [PATCH] net: ethernet: fec: Replace interrupt driven MDIO with
 polled IO
Thread-Index: AQHWHKdNoF5XViOCcUynDB14nwI/WQ==
Date:   Mon, 27 Apr 2020 15:19:54 +0000
Message-ID: <VI1PR04MB6941D611F6EF67BB42826D4EEEAF0@VI1PR04MB6941.eurprd04.prod.outlook.com>
References: <20200414004551.607503-1-andrew@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=leonard.crestez@nxp.com; 
x-originating-ip: [95.76.3.222]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 15f17326-1699-404c-cec0-08d7eabe7040
x-ms-traffictypediagnostic: VI1PR04MB6271:|VI1PR04MB6271:|VI1PR04MB6271:
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB62715E8566EDDDF481929BB5EEAF0@VI1PR04MB6271.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1201;
x-forefront-prvs: 0386B406AA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB6941.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(346002)(366004)(39860400002)(376002)(136003)(66556008)(44832011)(186003)(6636002)(66476007)(110136005)(478600001)(2906002)(9686003)(54906003)(26005)(66946007)(66446008)(316002)(64756008)(55016002)(8676002)(76116006)(33656002)(81156014)(8936002)(71200400001)(4744005)(52536014)(5660300002)(86362001)(7696005)(4326008)(91956017)(6506007);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RzpPqY9YuiaFvnhY9SrMin76hwM5Ak/jIb+9bXBxAwrGpENpqxauSE2bWIJndYe7CuDMqHaGAwiBGoJ+OnOE/EgK5SHXs2P+XiLtosuUugQlZuOEgru6eGH4xGWZC+ORNw2UjS8zsGmLYLzzwXk92Xwdn72cFkwu/xSpKJl1awTJ9mXjJBNOxo8RxBZ7tiL50bXlAVCltI/xGsYNSHus58kK4ti0gw+iAvRmWBu1i1hP2h42sQbs3QeB12rJ6MiyLSnyd3YzwF9ytu6sAlUeG6OW6xY25F9nU0Ky2wj78FL9LXhFZ54RmZjgThnCb+OKl4IrPIti51EGBAJZ54nE6pAHmm9x09IVL9+kDN/WWMgpsLQWDpi9Im6ZxIOT0/vIOES0HtBIFczFYFtTInKBjSX3CaAff9maWJIUU6tyV8Pf6azNiGYb59ZNosIfEukA
x-ms-exchange-antispam-messagedata: Jr4NAnGnDZIKouUPGqTkG3JCFw88vt+D6BNj3YmeMDKjmjeeRGu5JZHtCOgBiavogFQGDeoI/FEQZco1WkUr9frzTkJV2ga4PByVpzQDFXHD+iG16uL0ef0Ku+fwRei/tQfkbNvxRteRZ0BR3yis1ts4AhrHCFTg3RJ9JPrn3uR1TsMNQ+nvNLuZUcIlMN45+Y4w6SgRzXJ5/76tnyNVWsFmVgqEAJlc8h02yRVpZP/CBdRjjY1yQ9rzgS2ubhuy0oTdIrv74FUA+7qIev1JEtszQMrXh4Sp+AlrkZf484IuRrPBO7yGZtzXYDgKoTRz8Rk3GoqxHABVJON5qhCHazYnxaBfFowLNZcSr7OjdoInjc+mRRVIpJcs6Src4hO2JAoSAnEAtkIJvItJvnO28WEsarir70PQh390n8B1KsIHaeSnVAU8SMT1dEHb0VZlIm7Z+P5dzwbxxp01cg1h8muMKbQ9gd17dnvZID7hQdpUE8tc14HGMl9yJjzjNCgSD+jYJGXEz8dp0c81qlCB1eWUXVr9uATeIFjR/Xpnb7hcgjhEMJnCvGzx7O5wZ1biWK01epJwbMTn1jkiYZiD+RaYhzN6xE78rJ/WDCgcVPQD25BlPDVnrF9WXTWRT+TOHFA5JZk6z7kDuzn3Vv9os3/IMvv3QVwHh1tmS6bnEUuywVLbzlyzBogJoRvHl0kf1Rf9zJR9nRIUkbEdN4rwT4ySVwIEsALCiw8DGkn2uLUQYRn+vOiT5GnuC7POyMp15GVcTEH+7vEcMakfuTJjstQw3p81jzofTs9UXOr/Ylw=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15f17326-1699-404c-cec0-08d7eabe7040
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Apr 2020 15:19:54.3269
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HxeYYDDdUtoEaoUcXPIkd20fTWw3Sd57BH2a2r7HOozkJjci9mhqFz37XCe9PFv5FicvbSasgbElSAtdQFv+1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6271
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,=0A=
=0A=
This patch breaks network boot on at least imx8mm-evk. Boot works if I =0A=
revert just commit 29ae6bd1b0d8 ("net: ethernet: fec: Replace interrupt =0A=
driven MDIO with polled IO") on top of next-20200424.=0A=
=0A=
Running with tp_printk trace_event=3Dmdio:* shows the phy identifier is =0A=
not read correctly:=0A=
=0A=
BAD:=0A=
[    9.058457] mdio_access: 30be0000.ethernet-1 read  phy:0x00 reg:0x02 =0A=
val:0x0000=0A=
[    9.065857] mdio_access: 30be0000.ethernet-1 read  phy:0x00 reg:0x03 =0A=
val:0x0000=0A=
=0A=
GOOD:=0A=
[    9.100485] mdio_access: 30be0000.ethernet-1 read  phy:0x00 reg:0x02 =0A=
val:0x004d=0A=
[    9.108271] mdio_access: 30be0000.ethernet-1 read  phy:0x00 reg:0x03 =0A=
val:0xd074=0A=
=0A=
I don't have the original patch in my inbox, hope the manual In-Reply-To =
=0A=
header is OK.=0A=
=0A=
--=0A=
Regards,=0A=
Leonard=0A=
