Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 701FD3D0C34
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 12:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236899AbhGUJUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 05:20:20 -0400
Received: from mail-eopbgr70084.outbound.protection.outlook.com ([40.107.7.84]:1453
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238070AbhGUJBe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Jul 2021 05:01:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SypW5ChK4gv00UMYVulqvxHZgIt70IblvmyMJIAr8YqMM3wJu30JZ8YxhES37SGJ58Jtw6i7koFb1YKueGq0UL9k7jFD7zLTslORUz/nQPA1BlwngOtPCNa46xWgT01Lj6MaAU5mISsEHt6vKBhEsgDHHUmTWOgJ3nKBMsXRBHaPnXNKedggJm7s5xBemwhFQe+T5d2Is3+sRZT+NzUI5Bxq1xK8l7czPoqYxNoIBMyiH51SUyPouDJhj6Vgg6zlQGE0kzIrFBIt+0dFP0uOHu7RXajnt/GAEStsO9uaZilFw//3lzOPXSAHRL0VfEdFaFgjnDzBDa4p2zusOZnRTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MaB7qF584rj4VY8YGDAG5NfsdkhlBJw1qa+XwmWEg7g=;
 b=MepAb8+iL1HCsKW0BUGyrNPSIiheXaDbRupCzFb4u6YVg7ZPukzQ4soG2XPrQ/uZFftswNMU7Z2SLb13ejw1WApBhEo2On1C4mIoPIIiqulMPlMM8hJpFTvLE4W9NaJ2tQ4BYxgTQPt5G0a3gmrbhc3EWNn16oC2Dz3wA/5Dxv2mjJTP06+PHPKa9QmnwLCsv8pxCvpSaBUby/96w91112J/C+tnX72eOxVAOd6c8F+y2LAEhbJe0vJHZtboNqT7eSAYgpHV9LUQj08P2YVUp8RTypuKvA2Isb/h8c947HyqEf1N/g2HwueIbQESLdXF96gTrWvMhNZJY4VLGoX+Dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MaB7qF584rj4VY8YGDAG5NfsdkhlBJw1qa+XwmWEg7g=;
 b=kL5jNXbj6v610w9f2Bgy9xnLXs4HFOC20LsCW8f10lDagncJ2LpAvYMRm7qCfgWl31JmnK8yDgaQpAR4gcC37htY3OKEDMhLBWEzVduyoj+WKNyp84wn+r8YHu9yjvRE4E1kvUZtIb1z2/E2A8sFO3eQH5aQ8GPKftfmxg3tBv0=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2800.eurprd04.prod.outlook.com (2603:10a6:800:b8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.26; Wed, 21 Jul
 2021 09:41:56 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4331.034; Wed, 21 Jul 2021
 09:41:56 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net-next 10/11] net: dsa: tag_8021q: manage RX VLANs
 dynamically at bridge join/leave time
Thread-Topic: [PATCH net-next 10/11] net: dsa: tag_8021q: manage RX VLANs
 dynamically at bridge join/leave time
Thread-Index: AQHXfMHG6yUru9dHV02aS5CCtlwt1qtNJgEAgAAJw4A=
Date:   Wed, 21 Jul 2021 09:41:56 +0000
Message-ID: <20210721094155.aoikj4ghf2d3a4ap@skbuf>
References: <20210719171452.463775-1-vladimir.oltean@nxp.com>
 <20210719171452.463775-11-vladimir.oltean@nxp.com> <87lf60vxvx.fsf@kurt>
In-Reply-To: <87lf60vxvx.fsf@kurt>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linutronix.de; dkim=none (message not signed)
 header.d=none;linutronix.de; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b667f4c5-b407-425a-ba78-08d94c2bc761
x-ms-traffictypediagnostic: VI1PR0402MB2800:
x-microsoft-antispam-prvs: <VI1PR0402MB28005121521753630CAD646BE0E39@VI1PR0402MB2800.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /R4JN7XZWXc1MYbED+kiQ/nvauVtdKZKUpVtJhxKQLSxWNyOd2h6COcgFRzeXGu4mP3j2bupvx9xIl7IxJbuQJSmsjYpJfZE1K2HW2LQkK5k2X6WokdbdguvX50uHbpYoB/V6yjns3VPsyY2ffD49FcA4F6IJuaFuNLRuGYh3cMqJVsPqHUAebjJxjas4iIy6RqOfMiwUhWO3R81qwlIpqM5Avpi/RKr1zsDOkY+QIEuLYOUahAz2sTI3Ksq4zQqwKttyZFdj/jrtwmRW5FRLZ1d3AW6BIbKqHbUX9uMFCOCrfYLQk8RyiLAxk5WXrhL9LmWWyLyGIrFLTuj4ZcOaXc5Z5cH6FySiDtqV0MgX278bXxiZpCApNppVjyWHVEhfEoK3GdVHEsEhtEnZ6JbUPlYf31dBfGXlQ+1efYbuKdsPrYfN0kRlwCn2No/uUhqCuecFeiMqcJ08L9HsuK9Yy07cpR11yEseqP0b0ltEIc7iKHqY4wmc49SeFXDuY0u2/ZX0v79J9X5kIl3qCo+zJnSxnwEtnuy6SQCSjlhfyU2LExdUaqXEewpSw6FE8aTNIyirsZcH00N9h1MBSzgG+0s5GBbr3hhfEpDZmDluOr8ogBzLtjHQ5NGgqHZHjpgp31BYkhH0EUHtDYFWXmha9ncYm+1Ixp5VL0nQI5yd3PvebpHUs6QPrPEnvvNDqragcL9aj0uw668XZGajpS/AA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(39860400002)(346002)(136003)(396003)(366004)(376002)(64756008)(5660300002)(76116006)(66446008)(6916009)(66556008)(9686003)(122000001)(33716001)(6486002)(6512007)(66946007)(2906002)(91956017)(66476007)(186003)(8676002)(71200400001)(54906003)(4326008)(38100700002)(316002)(6506007)(478600001)(8936002)(44832011)(26005)(1076003)(86362001)(38070700004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?PVAO2EoFovY1uz+Is9r1wA2eX7JXUrhk+Fi0IuJeUrF4GPpj9emjFAX/yXBJ?=
 =?us-ascii?Q?RUvp66OteJicDi/jdiHkjzfp0zaSNgFfgIak3k62i3sG+IRKtU3hI8s9AnDp?=
 =?us-ascii?Q?YLmd5aLkw17v9WubiAO5L6+4/vaMUB+itW8Y30zXClwM1tRc7crR0T5oYPfw?=
 =?us-ascii?Q?WQpcbZJ0tMAKOFaWB545nENo+I0Kt04O9N5P8Ev+t2CIvrU6cOOfrgxcfBjx?=
 =?us-ascii?Q?uOEzqJUYa0bUphFBjcu0L3or24G+e3rXpuHW8Vtdgq3ns44qg2YplHj1HePL?=
 =?us-ascii?Q?1iQKSFc1wop410i2K11+c9Zu+CaTwTD57qklwJhpPykaEscPBJmNIVl9fKGx?=
 =?us-ascii?Q?Rp9xK2EkP130wXZq5HkWzhFe/nFnMYS0yzITobsTZDh96PioM1rDpXKDRzHp?=
 =?us-ascii?Q?TUV0hUZZcR86emEZTM4mn40nlF77kTFyGVqWaAVVfEn3AqL6LrD4ZW7Ixiva?=
 =?us-ascii?Q?jIRZYNyH52HrepcA33yppbGVOM2rI+a9oTrTzvwY9fCYb8fdJIQlpE6qHTVV?=
 =?us-ascii?Q?q7Cl7Z+04IG/mVi1h8mMC6fzjEOXDvXpRU8DXx7O3pXD5GmuMQelANdVMU6q?=
 =?us-ascii?Q?bZFctMeMNANG+UBhn44RKzrHC/z/d4/sKgo224hNS82brBUEFRbBDEN9xy9q?=
 =?us-ascii?Q?wC9lBT2vj+L5TMYZmdib4aSm1OwreOeysW1oI5LPnHsOlYuo3dGB39whnM64?=
 =?us-ascii?Q?tGncDsi/7x5A6bRMF7hu2vcNqGWO8bora3dDBnKq7S5Ljq5RW2u2QFB8lu9L?=
 =?us-ascii?Q?STvqYaWaERifDlYqwWJxf/wMEqcFCtiQ2M4KMw/l1QAvDm5Fws6uYUDyWFVI?=
 =?us-ascii?Q?/WVVpmZJ90vHUba6+UHNOO/YYAw6ZBejOxDR6udyo30EdND/jxhNDbd0aJXn?=
 =?us-ascii?Q?4l9a53N+nLBSPHaTAgslE2qHRc3eDrjmIkR9y8HMqnixRq/xofLxd52XqAvN?=
 =?us-ascii?Q?3qbbKXIsS5YS3FLegvJIe6pjNwMQkLB0Kl8afs26rUNzac0Kbs0H0l/hTzVn?=
 =?us-ascii?Q?aAzZbv9nAHDB/Lg4fo7sz3CJMoRUGOCN/mhOQD4XIicCVw4tO818SJ+jW8R5?=
 =?us-ascii?Q?6vSg+htT9rz08RH9BU/iOnm5eVqoP0XwR/xLE1LFLrwnuS32EiDgj6Vx5te4?=
 =?us-ascii?Q?+fUbU6zxESq/NtooEw6BTLEM4LfHZUWjZRPNJF5Wm6iGHlq128d4INGCKFMO?=
 =?us-ascii?Q?D2J2/0cHu+xDcvGZkClO+3DonUHVGmAOwfww+jWx47n8dLOQ0PUTDRHZSMBD?=
 =?us-ascii?Q?TQyyqfQwyYu4IbSnZeves+zDP9g+MeuBJn2vcSBlQOlx8XBIE0rVkUF+HMCF?=
 =?us-ascii?Q?V6Irf4d+82iBFmZBgpMfi0U2?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7B7CAAB4C8BC0C47A80C5FB462D52A06@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b667f4c5-b407-425a-ba78-08d94c2bc761
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2021 09:41:56.1141
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ECxlQbrxfZgy971g418HjNE9uqMKAwCbF2TufjTwwFJ5r6oPYPmh1C/GT8PmMFlF0x07Gvr2HaIzU5b9nCLojw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2800
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kurt,

On Wed, Jul 21, 2021 at 11:06:58AM +0200, Kurt Kanzenbach wrote:
> Hi Vladimir,
>=20
> On Mon Jul 19 2021, Vladimir Oltean wrote:
> > This is not to say that the reason for the change in this patch is to
> > satisfy the hellcreek and similar use cases, that is merely a nice side
> > effect.
>=20
> Is it possible to use tag_8021q for port separation use cases now? I'd
> be interested in it if that results in a simplified hellcreek
> implementation :).

Yes, but I still don't think it is worth it.

At the moment, if I'm not mistaken, hellcreek reserves 3 VLANs or so,
from 4093 to 4095. Whereas tag_8021q will reserve the entire range from
1024 to 3071. The VLAN IDs used by tag_8021q have a bitwise meaning of
their own, so that range cannot be simply shifted (at least not easily).

If you only want to use tag_8021q for port separation in standalone
mode, and not really as a tagging protocol (tag_hellcreek.c will not see
the tag_8021q VLANs), I suppose that restriction can be lifted somewhat:
(a) tag_8021q can only reserve RX VLANs but not TX VLANs (that would
    reduce the reserved range from 1024-3071 to 1024-2047)
(b) tag_8021q can only reserve RX VLANs for the actual ds->num_ports and
    ds->index values in use (which would further reduce the range to
    1024-1026 in your case)

In terms of driver implementation, not a lot would go away. The current
places where you handle events, like hellcreek_setup_vlan_membership(),
will still remain the way they are, but they will just set up a VLAN
provided by tag_8021q instead of one provided by hellcreek_private_vid().

Six of one, half a dozen of the other.=
