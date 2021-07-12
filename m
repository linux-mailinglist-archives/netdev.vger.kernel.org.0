Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5EA33C6152
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 19:01:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234179AbhGLREM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 13:04:12 -0400
Received: from mail-eopbgr60057.outbound.protection.outlook.com ([40.107.6.57]:31973
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234300AbhGLREM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Jul 2021 13:04:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SYOpUUJuTm+VtXW5b3Rv/enmVNOSMazVDINBxJLOQjYzIrk1IccXfWp+yttFab+hLTZQIZcigMvmJ3eR52dCXf7rM3oy2MT2Tse7cDQOlO+1pL+THRG9KmQVkioBVhdHmi7TddanxMNmbKwuX3W3ywNkOookAXNUxI4vm9dhIAUNZk1/izky4hy8kKWbHadpybp+NSBNmqO3oUfs6QmJkdFpbXR8/SQh0zR293aUH/8WDxeVHRU0WlWbkQmcrOA3bHqeZkNSA32O8eaLJPDK4xy0L8v2mStJZu1mn7jwL2n4Lw6s7aockowRcRNoW74TIGkkzBaTqzLy7qCy4k4kzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hi68UCk//tATx9kRXqunHnkORQeNS2cTaOQVCItiVL0=;
 b=mcayi9s7DHeFd4eSWE2IXUtEproCyoWj+8krDLub/9Wq9LqpLBmiSlfOZ2OSvU3kg0CwmjZakUDnxR83CcZn66Gcq7VEcX7xm4bFqkBkbF53iuuf9J/baowEft0GbiVQRVep6JWSuMOwXr7E9yE6Wzke4rTHgeO3q9f6niZEyEGuOt5bZMl0OLrmxA7IIAim3LSvK7Hq6P04gKFMpxOLho1ZUDbDWLVI5GiEizXgVtIwE7THw8+YZr75R9TH5H2pvn2PfcXDDLtH6j8/eqzAqesQyv2k2tS/+hf8VcwJC/oK/DByfXdWmY2Ab5DbbKs4wjjssuY6ZYxm4zONNs/+Jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hi68UCk//tATx9kRXqunHnkORQeNS2cTaOQVCItiVL0=;
 b=JVU6pbgfh98WL+a6sDjIVeYAN+kGKzWq5ka+ro8km3PMdrJjBJNAzW5/YZKmxsNioYd2BjiHWjnUN1SFduasXVbyKawUQzlpVqn0brOR8r0jhwf6m2KZpXTVp7E9n3mjAXqkiPHOjrinFfAl5pRpxFI6nAzGnLnooYH8ThaR+M8=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2511.eurprd04.prod.outlook.com (2603:10a6:800:50::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.23; Mon, 12 Jul
 2021 17:01:21 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab%7]) with mapi id 15.20.4308.026; Mon, 12 Jul 2021
 17:01:21 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Marek Behun <kabel@blackhole.sk>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: Re: [RFC PATCH v3 net-next 00/24] Allow forwarding for the software
 bridge data path to be offloaded to capable devices
Thread-Topic: [RFC PATCH v3 net-next 00/24] Allow forwarding for the software
 bridge data path to be offloaded to capable devices
Thread-Index: AQHXdzGsaUZwcS7NYkCNFax/7xm0CKs/ejyAgAAWcwA=
Date:   Mon, 12 Jul 2021 17:01:21 +0000
Message-ID: <20210712170120.xo34ztomimq5oqdg@skbuf>
References: <20210712152142.800651-1-vladimir.oltean@nxp.com>
 <20210712174059.7916c0da@thinkpad>
In-Reply-To: <20210712174059.7916c0da@thinkpad>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: blackhole.sk; dkim=none (message not signed)
 header.d=none;blackhole.sk; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9b3dca97-3086-4460-9ff7-08d94556aca0
x-ms-traffictypediagnostic: VI1PR0401MB2511:
x-microsoft-antispam-prvs: <VI1PR0401MB25111CFB1BB8DE13546D44C5E0159@VI1PR0401MB2511.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: D6sP8x4JPgAeSnzuRIwDvjDGk8rl7vXMcbNoM5TPA0LJGaXeXjEQ55spXsOzCMKB9zCxUVDvrv7jxo6+u0oPo+Z04VIGUw2srjTntsZt8hcEka/xRrX4NLtLRd/zmfbK56X6iGTxVPhcW1ewd7PdHfQi0ctsO3nFklo1hjp9K0ZSS3xLQ1Y5+vYbh63qW19LlrSUuu4qwKe5zIbj4ffV5bl6PNW0i5BVnwfy1cQCMcmFXJte+/cqIONVNf44H4y0cJSK6ul8r3Zs7lgQV4cwzZOrK02+q7co1ZWKBvV2DDR9FxRTw1Ez02CrG18uohRWULw64ov0R5j9i6xGzQcQiDJ/BRCHUgQ9F5qMcr5JJM7RNz5MF10ch9b057wOfF8ldrn1xyjLBgGDYsfp1keHCZdJ2IP4ypSGsUrmotl0wmhPbW0sRbQTgD5Qz7ZLXilLgxPXHO1pHUXMvQIIqumaRyRwHyM6DrbAvcZSpPfHLJZQm2xtC4cgDBK+WUP6mTrtyoLz1+xpv8c2X5XwRp4m/oegFkO7414Yff3U+WjGpESVcDWzW2aqXdfVSLacH9+aMk76AenFcFZLhAOGPheiJl+G6RX8JjmYWjPcfYqXqwcCdEfFLqtAGDG0f6qFFsG1/gYHVy9EuKWarfG9uzU5Eg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(346002)(39860400002)(136003)(376002)(366004)(396003)(66946007)(66476007)(66446008)(86362001)(8676002)(2906002)(91956017)(9686003)(71200400001)(6916009)(316002)(44832011)(33716001)(7416002)(64756008)(66556008)(6512007)(478600001)(122000001)(76116006)(4326008)(6486002)(6506007)(83380400001)(26005)(5660300002)(38100700002)(8936002)(1076003)(54906003)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?F+cJ3W3e0GwfeWars+8fhcNoO1akYrBHh7waDFZ0k6hW8Aelv90MJYhpzD13?=
 =?us-ascii?Q?IZTdZmn9tb4KA3KAUrM+TMM7XAsdUIWWtvjemyfHUFKXVp2VUEVbwETJdT+S?=
 =?us-ascii?Q?IHBNF1ryuWe08tzsp7xyzFEOp0WRTvYyjOiqng4stOjOx/Dm7v5M5GWBn2eM?=
 =?us-ascii?Q?Y6zmsr73pPLmQ1pUxCgPSyo0JAAO2JO4dPMH3wAv8xGTCXGbf1fCgCt1CRih?=
 =?us-ascii?Q?tuT3+u8svRY3vSpOb/upxN4FXH0cihKayLJqW01JQbQ/xTEXQzJBEFOFPQwC?=
 =?us-ascii?Q?REjAn5sFvY0guijgt6y+dZH7zkVQPzQLAs6KO93Hjr/uZB4SkRrP2h+cdRmi?=
 =?us-ascii?Q?oaFxZtF+yGgA6V5TFKhQy8KvEz1ZokZyDXCniQO5GTzeD5mKZFptRKiMEK/3?=
 =?us-ascii?Q?P8Ic9WhzNe/fR+M/ERyXWSFweDH0R+E5RyGoZMRdI01ZZszxMzYbFaUAAj5w?=
 =?us-ascii?Q?a/8JA7lRxwTTJ71hX4/x1hb/pQjBMZnzLrQUuQ7hhKbFIzsJZrGSrG5EKWA8?=
 =?us-ascii?Q?VCO9zXKx/6YX/tUI6zNmWQxt4pjF77qq1w/Nxvi0TZeGYa8w2QxyI+oI+uvl?=
 =?us-ascii?Q?8eC5Y/hacVE/T/1TrKvw43IlF6laEHhUWAPSXWccOg+i/dOZrXscAs+KMz3t?=
 =?us-ascii?Q?sgHRxjEtYkWTtS+yxiIZ99gqbiNT4aHLkbdOa9CTDQXLaDi4us1+wxN1UDBA?=
 =?us-ascii?Q?FLg/5yJ5yiyXPMWsW0YZIV8hnVbya6lh7v3hTzfP2r9NXaSwLS1dp1cg+794?=
 =?us-ascii?Q?oF7i+zIfLP5QhUS5FnHPnNLdOCv/r7npE4Qjh7dECCfvHPb2yu8oDHMETJ2i?=
 =?us-ascii?Q?/DfxlE0b5K6Ye5U9z1tcPxtgCYeDlZzcuP43CX4wodX76gUd+eClSQSQlEmR?=
 =?us-ascii?Q?RaaSvX0FjMpygrBtXqOizIGphpGJNXNeSUvCERrzoi6IS44z3oEfQDCB01NI?=
 =?us-ascii?Q?dWMQcSTkZDIrOwuyl4vdPzm2RE2F6hxn/5zrZoV+eWGP3k+VreLkqCubzfwH?=
 =?us-ascii?Q?NOerKedBnFFiX6ik7scz3B5NBiDc95ZiAEEWatJsPT2qf2erdQHNV26+nROM?=
 =?us-ascii?Q?2Tx6Jw3+jm5ZbriLU/h5Zi6Y8coVSRltgJcrkItka9rr4/AKceIYFwbgo57G?=
 =?us-ascii?Q?s5gaHukzkXPL9+JQk1i8NPWOpCcGF4Vln6jUwk0UDQZx7FXHA7vEWa1RH5A5?=
 =?us-ascii?Q?Y2MXcdrfVGZZMYCeNR7W6OHnE+9SsBzPXLismQoHwiUlYfvVVGbjRw/Wnhqm?=
 =?us-ascii?Q?GYPpSTAAKq2ZuM6a+kLkBELffholafypnSs2EMEncUdiIrMYID5kF87FzoY8?=
 =?us-ascii?Q?mO6LLhIo4RFqBwD0S/mHjVk0?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1BB5E62C3DFF8548A3F571CCC8C557B5@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b3dca97-3086-4460-9ff7-08d94556aca0
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jul 2021 17:01:21.4408
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5Gie8jcC4dCZBZC/FUH2pNvEy/xc4Bm+zRNZNDFzhGWYwBnTwQi7ikKWajEAhtBCbw8gFzghGUY7VWLJsTMSNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2511
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marek,

On Mon, Jul 12, 2021 at 05:40:59PM +0200, Marek Behun wrote:
> Vladimir, on what mv88e6xxx devices are you developing this stuff?
> Do you use Turris MOX for this?

I didn't develop the Marvell stuff nor did I come up with the idea
there, Tobias did. I also am not particularly interested in supporting
this for Marvell beyond making sure that the patches look simple and
okay, and pave the way for other drivers to do the same thing.

I did my testing using a different DSA driver and extra patches which
I did not post here yet. I just reposted/adapted Tobias' work because
mv88e6xxx needs less work to support the TX data plane offload, and this
framework does need a first user to get accepted, so why delay it any
further if mv88e6xxx needs 2 patches whereas other drivers need 30.

I did use the MOX for some minimal testing however, at least as far as
I could - there is this COMPHY SERDES bug in the bootloader which makes
the board fail to boot, and now the device tree workaround you gave me
does not appear to bypass the issue any longer or I didn't reaply it
properly. The point is that it isn't as easy as I would have liked to
use the MOX for testing. I was able to validate the "net: dsa: track the
number of switches in a tree" patch on MOX, though, since DSA probes
earlier than xhci, and even though the boot hung, I did put some prints
and got the expected results.=
