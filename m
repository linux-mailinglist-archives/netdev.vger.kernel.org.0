Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A349A2C0E95
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 16:19:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389326AbgKWPP5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 10:15:57 -0500
Received: from mail-eopbgr140044.outbound.protection.outlook.com ([40.107.14.44]:28814
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1733292AbgKWPP4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 10:15:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F91YqaTFN0c5IEh+6grDO+YGOtRIR4S/xLBTnh6bEQDl6Bg7DeuW3276uaC2bcTncgq1eYPu85TgQ+Zd7QKU7qcctE/cRPjr5MKBdEoD1ChzMbpnagGbPLagJ4Xcg3n79ykmZrkDiQzbS2c1g+szmrdB/rFPBtmngEi8+0UepPRwJeedNY+FKWH3qpnyMmVARW+5XYIpkYP67nk8+g1g4gkP+Q+WB9kyYXJtlamg7ecuf+COfnZEfZPG0pikW4l/zlZ1QkeBFF1w+o7KaL67UtP61XoX5RMqDVy72ybqo0dgWM99YoArfl8olAMggkmCqgw3g+lx++iHwAgzj0WPYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PRfoM7KoTi477nInzv8/sGluRU/eJAWBSsy08FZqpG8=;
 b=Bv+BX1Vy9djPCS6lrU24ewMwYVLOPum8amNfwpmzRHjfTuS8DadY+jRNPvmmYWA8/lvmzR78Wv2JqtfFl1iSIMT9E9G751+rICb4r5bUyHaPykBCPZVkvXV5yGm4HWlIdanj1fMZNm9Ng7IHyxy9D3Za9ab6RVJRkrBRL08AWw7APEJgfxX1kDP1lnDOgeupbqvPIJ7vBWSicuVZdUMpQM/sVdFn2Y0wb1IDiA/DzUNxNnP7G/oJocts68FPXEnYffTTf6mLRbkZeLb325wQWafWbIL/xdpngF+9mmSbuNbkyHbclD/vE53Y5bu4jAd5CUv5T2FKmrt3l7LNAmUYAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PRfoM7KoTi477nInzv8/sGluRU/eJAWBSsy08FZqpG8=;
 b=QvZeUy7TuGEt8C0JCXBhjU9U7+ryfB3ehs+JuRW7hgMp/0uDi47bKFxe6z80kgrcTlNrZdBUhsu1e5SnkgTY52t63liGaG81bQdOa1AV/mkdvH/ycSY2g8kas0AQjcofMKjpyUe5as0WMSil0DrAo9ZRCKLSRjxcfagGxv9S63g=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VI1PR0401MB2415.eurprd04.prod.outlook.com
 (2603:10a6:800:2b::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.21; Mon, 23 Nov
 2020 15:15:52 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::607d:cbc4:9191:b324]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::607d:cbc4:9191:b324%5]) with mapi id 15.20.3589.028; Mon, 23 Nov 2020
 15:15:52 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Ezequiel Garcia <ezequiel@collabora.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>,
        "kernel@collabora.com" <kernel@collabora.com>
Subject: Re: [PATCH] dpaa2-eth: Fix compile error due to missing devlink
 support
Thread-Topic: [PATCH] dpaa2-eth: Fix compile error due to missing devlink
 support
Thread-Index: AQHWwGYkrPZWLBjkiECa2U/nsQMfUKnVeEYAgABbTACAAAKwgA==
Date:   Mon, 23 Nov 2020 15:15:52 +0000
Message-ID: <20201123151551.7h3ivyj4hujx72uv@skbuf>
References: <20201122002336.79912-1-ezequiel@collabora.com>
 <20201123093928.pfvlpcdssjaxa37d@skbuf>
 <c0e98111cafbdbb5d4d29e5e87ae779144370cf6.camel@collabora.com>
In-Reply-To: <c0e98111cafbdbb5d4d29e5e87ae779144370cf6.camel@collabora.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: collabora.com; dkim=none (message not signed)
 header.d=none;collabora.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.2.177]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5dfdb5cb-9c33-479c-5f5e-08d88fc2aae0
x-ms-traffictypediagnostic: VI1PR0401MB2415:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0401MB24151FF8B03BE7C294964E17E0FC0@VI1PR0401MB2415.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jo8X5rU03YURvocnpwnLUhz6rLAHVbx1Q+qcNsVMaYekr8bC5F/ZfJeCL+kxDSfzDB5Y/BgSKj1zmyYymSL61rAZNuVqDFxSUaezCzE3/Cir+Ub0rbNskyhc2MElqOp7alAy7TBZB8wwhrd2WwyBuxvHFmh3Ji6Gwr5OIIlPV0Uy83c5yWSFgaZUe8uGB+H49ExdQJuCI7Iy8Bqa8VvjbTJYVtCQLSo+Pr+7ntRTYX0Ap99nPCIxagVJw+FjF0CnlfX/QQPoBZBzzA+J91ZZrESd2eeUL/66ZSIyLNb53MdttkBFseXP1qMXuWUl3lxD
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(39860400002)(376002)(366004)(346002)(396003)(136003)(83380400001)(91956017)(76116006)(186003)(33716001)(44832011)(6506007)(5660300002)(26005)(66946007)(64756008)(66446008)(66476007)(4001150100001)(66556008)(6486002)(2906002)(71200400001)(9686003)(8936002)(86362001)(6916009)(4326008)(8676002)(6512007)(478600001)(1076003)(316002)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: mBqv9y3MDi5oLBBFVB4haLJU4naoXQZ2gh54erAirtUVUj6tRSVDxWE1ueGUcGd0LlLrqqVwH1TnT9H5IsKrJkN+B/L52RvUlgy5Ek5/O0YUSigGPLdncG8YhjLF/WiB6M/YuAbGI60GAhs46Pi90wRKcznIvHyWcTMNIH3NOJLq7qA0PuMW4zWH0KbBTpbGj0Ex4s3gEcnYtYqfj1ltVsCr+B4wiO+phKCvPq9O5ZNhi/Go6mym21e70/nSXLroEScc9dqG21pa1pmvzVvP1/uRSgjZHOMeyx6TK5NMkdhfy7OxS/pPlvKjOVbUTwv3uSo6xMB8luUYL+drWQt11rnI5H1ahEaWNdLd5xzNm76RwPjGCNbZjpZ65oqwfMGpJExdpW/h/JzqCGnNg+4OPHemQs2TVLsYbb9PIS1f9H8u/GYfMY/AmFK+AfDiSMLLreL3gErbVX5IFanyaT9//FQgIa9lMDSrzPrHbaPxPwwJrCsPlCrZoEUnx4Cz+HrtPAeUwIhZm8YQTOyiI/KcwaLDxMP56HYB+Mk40I4Ipe/4tjgAVeizKzfvwp3RL7yxBUhdgbS2YuQnsHWFbXG3hgUfXzkI9o0nBcwchoGsXAkSqPyAT7oKqMa+BDKC1Saue//NgTio0Mfgx3s1OBcgLKsxq8AIauntCMzRBnIQ9gT4nfr5FEloy4mixjz9Ng3r+4b+CE6ijzBpQ3jLJvN4I+Xza/J/cbGNnhrW5YtL8PSpRHG/bR5tzKUSVKlTcFUaSCGM6BAmwQyeQozGEokHVa/Ou1CNIvPPnXiGTBy/ZY6c7rAUcxGZr2xhBkOFatklEeWjEce3khXLExkhuaPFQy8WZuEzuVU2tWr0/stdF0fxPXVys6/uIFhz/vGC0+dqgs7FlPxnAFjs84ucLmAotA==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E39DB993C209A042ACC23926264C0773@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3871.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5dfdb5cb-9c33-479c-5f5e-08d88fc2aae0
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2020 15:15:52.4654
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rJcfbfOdKkzFDt8py9AhQLcVyVjNlj5ob3e3KLBHp1o1wYk4mUjN3f7m+xNbz6u22KG4A/HQp8nPRQevsjO1zg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2415
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 23, 2020 at 12:06:14PM -0300, Ezequiel Garcia wrote:
> Hi Ioana,
>=20
> On Mon, 2020-11-23 at 09:39 +0000, Ioana Ciornei wrote:
> > Hi Ezequiel,
> >=20
> > Thanks a lot for the fix, I overlooked this when adding devlink support=
.
> >=20
>=20
> No worries :)
>=20
> > On Sat, Nov 21, 2020 at 09:23:36PM -0300, Ezequiel Garcia wrote:
> > > The dpaa2 driver depends on devlink, so it should select
> > > NET_DEVLINK in order to fix compile errors, such as:
> > >=20
> > > drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.o: in function `dpaa2_=
eth_rx_err':
> > > dpaa2-eth.c:(.text+0x3cec): undefined reference to `devlink_trap_repo=
rt'
> > > drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-devlink.o: in function=
 `dpaa2_eth_dl_info_get':
> > > dpaa2-eth-devlink.c:(.text+0x160): undefined reference to `devlink_in=
fo_driver_name_put'
> > >=20
> >=20
> > What tree is this intended for?
> >=20
>=20
> Oops, I forgot about netdev rules. I guess I haven't sent
> a net patch in a long time.
>=20
> This patch is a fix, so I guess it's for the 'net' tree.
> =20
> > Maybe add a fixes tag and send this towards the net tree?
> >=20
>=20
> Would you mind too much taking care of this, putting the
> Fixes you think matches best?
>=20
> That would be really appreciated!
>=20

Sure, I'll respin this.

Ioana=
