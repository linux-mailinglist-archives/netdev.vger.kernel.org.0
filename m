Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 903E7271FB7
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 12:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbgIUKJR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 06:09:17 -0400
Received: from mail-eopbgr70078.outbound.protection.outlook.com ([40.107.7.78]:27205
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726333AbgIUKJR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 06:09:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fmg3i836SbF6OIVYXlskFwdZVZUA8w+ZlaDLLBhkQbjokX6xTFhI5edSmcHYZZlsdt8dJSUyihcZ9/+p2Q+5tQWQD6AZdxI5DwmnwFMW72m7XTJcz1iGYwYofZZ4bRgcT992JA3pnTfYBXJZmiQMST0x1udX3VlJUcpMsE4Av4eF7IQ4FrGs+3c2GOtDKqn1EkcZz9O37Snw/QEAm3epHxiHUU1TGguKfW8mPwe4J18s5bIQmR1h+iTApqq4oZvSLjnr0xt9cuIdxcqR3jQGpWzWi6H4pWptJmpDXPy5XCogE+QXZT8WLmo3V56Pe4G/mwPxvXaFJHt6NqqZ/Mqg5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4ooHrU3wcLUZo3959c+fuRyhOPEAjoiy6idNWmBBj60=;
 b=Ddw8XxFkyZvxmrAshm8R91j83d3iGzA0Kki4G8uOivpr0tszvPAECcEmg8VFQQvY0gZCllcmsm7z9vUJ1aqAU2WIv66oTNT5Be6xTT0G1aRj8J1MynspilEpAcfa7SaiXLWY51puNjHysVmqRtVs0+RGo7Lug6EMVhwsZ67xcj/HGhLyvESEbR0PRl988m4jT6SL820mYvkj60Tp5PVo0gqRCsL8Bp9Nhq/ZknYMtDVapwueMCIHscMz3l5z6EDKupozhuxOs0OGMEepuicJ9/e0wryAb3/T44zd4KZa057PWz22jQMMKeDD/wxy9XM3SBbqdJE31kTrRIpZOPOKKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4ooHrU3wcLUZo3959c+fuRyhOPEAjoiy6idNWmBBj60=;
 b=ed+cPYCJxHhtnMWouOWk+K6l4mzCj5Upkt2qTZajYK+49TS7T5GUHnrjOQXBC3YT8nTaVuL/qCpu8i/6WQuvZ5X8/U5OkSGZFgx+KgNoIrfu8yG/3QKrCBCz+Xow4QZBFz7jvC8oEakHJACypvdmMeoQ+VRCAsXSHwlTrMdgX24=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB7327.eurprd04.prod.outlook.com (2603:10a6:800:1ac::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.13; Mon, 21 Sep
 2020 10:09:13 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3391.025; Mon, 21 Sep 2020
 10:09:13 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        Chris Healy <cphealy@gmail.com>
Subject: Re: [PATCH net-next RFC v1 1/4] net: devlink: Add support for port
 regions
Thread-Topic: [PATCH net-next RFC v1 1/4] net: devlink: Add support for port
 regions
Thread-Index: AQHWjpNTDn/QEBX8Hk+qVrvSi0xeHqlyMyOAgAAKg4CAACxogIAAd0wA
Date:   Mon, 21 Sep 2020 10:09:13 +0000
Message-ID: <20200921100912.atgn5ly557vihbrt@skbuf>
References: <20200919144332.3665538-1-andrew@lunn.ch>
 <20200919144332.3665538-2-andrew@lunn.ch>
 <20200920234539.ayzonwdptqp27zgl@skbuf>
 <20200921002317.ltl4b4oqow6o6tba@skbuf> <20200921030213.GC3702050@lunn.ch>
In-Reply-To: <20200921030213.GC3702050@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.217.212]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8a067dfb-9bd0-41f5-5288-08d85e166426
x-ms-traffictypediagnostic: VE1PR04MB7327:
x-microsoft-antispam-prvs: <VE1PR04MB732733F92AA7002825460426E03A0@VE1PR04MB7327.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kyQRNp4vsOUeyN9UqBGyvPrrCFMMgtriAkg6+891G61g8GIpgW9GrjLfQkYxNGIPs2YIUrf5IlCZJdHY64zEHFUJPAvc5nXkjk7Sz0CNHEUu2xR1yOiwUy4/JxdV4jnTuGyQysIu+UYudElz76wSEg6iEnxjNxj/MIVaLw4k/Jp4vtKUjgEbhLVlpZ1EYItgor1opuu64rrkAnMHYLRi2kglIZn/Ol8ifhI65aLWRKfTyPmMZMH6Tg7Or73HeVf//EJetGvahuBtXTix2AkdS5lSEyn9n9TghPnOYG6x+qs6gZSjjMO00rlGC0QqMP5sJDaLOandUdw/t5aEIW5QIQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(396003)(346002)(39860400002)(376002)(136003)(366004)(64756008)(66446008)(54906003)(66556008)(66946007)(66476007)(76116006)(8676002)(6486002)(2906002)(8936002)(5660300002)(6506007)(478600001)(4326008)(71200400001)(9686003)(186003)(6512007)(44832011)(86362001)(1076003)(26005)(6916009)(316002)(33716001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: hkTX0nOUFaLxp2xo93RVYjPIYTJgxL5ZBajy8/Ju0/UnFAzVdiECW6nhAmO2WvqmMhRNOhdWzhPpPkXenPS+Pf/8CcInnJQAFNpC8nx5Urm5w9kXiaGSONxSwM4Xtvjdiu2b7ozg/28NjtVP6JEbLwVIdk/uyUXMfWMbKfA/R3AoMRH+p1Ebd2/wFYqBnr2fZWLRjmqaaD21fkaKi/ZwV1nOy17dLlsyibzCaFoIWxB2EHXj7FbcqXzZ3+YdyHMtSRln20Ggh7BTHw6/KWSya9jLbucorMvjQ3D3zWoGCDYpo5xZccV0ptH4wlOvW/c1sMTIq18fnZQPILMthSD9P9lXyUK9fXyc44jyceLZBx7YzVCgd8PfUsSL0g1v740LaN52udQb3Jx+t1pSShudxw2zzf1jO9iVVxGbFf2LDzmrkTRcU4ve5kmTt5S5i2VQV4+Eq6sPJg0/C4MUp1psQFooo9ED0h84K13NXiLOUc8Fdil4/DZAxJ1zKVnpdzIvTBqWJVjTgdga/g/l0IKm+w8Wlz3WhVL3Lp1WJJ3T9JAxNeHuHgOtJnUpMJS6RPd6OnC1oFvoJ71v1C0euL2ewWvvYygF6aCuuE3VU6LirFrKF+1O3ULZ3zUT64oUb096j71DMlOUdqEqDeFPg7I9DA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C825382B581756479C5C788F06A4E90F@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a067dfb-9bd0-41f5-5288-08d85e166426
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Sep 2020 10:09:13.3940
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bcyYySwXpQX0JcK/c+zP6DfsL8FviYLGsmbaS7SkyJlcEKXp0puHGVPRNIn1T49bCqF8+K0PKCE6AtYk1CJllg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7327
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 21, 2020 at 05:02:13AM +0200, Andrew Lunn wrote:
> On Mon, Sep 21, 2020 at 12:23:18AM +0000, Vladimir Oltean wrote:
> > On Mon, Sep 21, 2020 at 02:45:39AM +0300, Vladimir Oltean wrote:
> > > This looks like a simple enough solution, but am I right that old
> > > kernels, which ignore this new DEVLINK_ATTR_PORT_INDEX netlink
> > > attribute, will consequently interpret any devlink command for a port=
 as
> > > being for a global region? Sure, in the end, that kernel will probabl=
y
> > > fail anyway, due to the region name mismatch. And at the moment there
> > > isn't any driver that registers a global and a port region with the s=
ame
> > > name. But when that will happen, the user space tools of the future w=
ill
> > > trigger incorrect behavior into the kernel of today, instead of it
> > > reporting an unsupported operation as it should. Or am I
> > > misunderstanding?
> >
> > Thinking about this more, I believe that the only conditions that need
> > to be avoided are:
> > - mlx4 should never create a port region called "cr-space" or "fw-healt=
h"
> > - ice should never create a port region called "nvm-flash" or
> >   "device-caps"
> > - netdevsim should never create a port region called "dummy"
> > - mv88e6xxx should never create a port region called "global1",
> >   "global2" or "atu"
> >
> > Because these are the only region names supported by kernels that don't
> > parse DEVLINK_ATTR_PORT_INDEX, I think we don't need to complicate the
> > solution, and go with DEVLINK_ATTR_PORT_INDEX.
>
> It would be easy to check when adding a per port region if a global
> region of the same name already exists. Checking when adding a global
> region to see if there is a port region with the same name is a bit
> more work, but doable.

See, I don't think that the check would be useful. By the time the new
kernel understands DEVLINK_ATTR_PORT_INDEX, the global and port regions
are already properly namespaced. So future drivers can have a port and
a global region of the same name. The problem is only with kernels that
don't understand DEVLINK_ATTR_PORT_INDEX. These only support global
regions. The concern is that future port regions for these specific 4
drivers might confuse them.

-Vladimir=
