Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C3782D8E29
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 16:12:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727289AbgLMPJj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Dec 2020 10:09:39 -0500
Received: from mail-eopbgr150053.outbound.protection.outlook.com ([40.107.15.53]:50310
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727064AbgLMPJb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 13 Dec 2020 10:09:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sxqpm3nsoSHJitp4zFA54BsOHrme+CaxfDUgpHmohIZWsfVHIymcQ6Jt0lh15xV84y9MfdKl3aBc6LFMN3jkuyxQlnPTmkzVZqBarQWlSyQN3NhSYTNGsTxK48mQo1jtTzU4Kz88tKlqc26c9V77iTSPyXWBXOLfsUwunQnqgGetSqvAuerBg8YAUJIL/kFQm7AJJGBKwXEUpRZWCBbPEgTOZZ8fhkLYbPKp66V0x4ovQnYaq695ULmF/YN0JuH5QaaSwjkSRUFVteKRIpzeUBnG4meQp3hxzUwL8uyzX8PHn70hywSmehOGl+S3t+5iGGL9A3GD/8BjS4SEuD21VA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=glUNLV58+8I+VGyntUpvxg8EqGk4oNpIuhBgucx9tSc=;
 b=XFm53RR1LVmYLQ7Nx0UA7r8o/VbN5dB3HPVTzpUFsDs4xqgRx7dwq0R+q7NQCJh/F2nl9oJ0nYYk0XIocEc8Boep0y18YI0yUTLTFxxN7S9YFqHl9CSkRqv1CoP/smbZJ9y8A6bdZNDkZcLM49q0iHxOrYO3b0RkeGR/cNCDB1p0lj44el/CoXNibEV6J5RgOYtzp5YRtdzYPkpYN7Xl9vW4LNjtiQyPvVT7HWwcnj4gkb3NT8S7Fq5ILlZRH4qCAecJmnKowditEFuFL9MwNyDRqD2t/wmcu5invB0NkxoLpWUmQ0To2NQg8qCByLFWSncYdMfD6kbWROTRLyCpZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=glUNLV58+8I+VGyntUpvxg8EqGk4oNpIuhBgucx9tSc=;
 b=afsJ1YYd6wftxP03OKI2rfGKavXWuuCimBmIRXDykby6jW2Z/lJxdSpgB2XQD3MbLrTrFtC6Ap29FJFEysTdwYPppFhnaW7xoUqwESpF3tkDpns16OXxbFYXATNkPeyJyqeD8HaxeoK7QNeMFZ77k/oeqh/utWFFtSXzIVhqgRc=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5695.eurprd04.prod.outlook.com (2603:10a6:803:e9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.17; Sun, 13 Dec
 2020 15:08:42 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3654.020; Sun, 13 Dec 2020
 15:08:42 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Ido Schimmel <idosch@idosch.org>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Marek Behun <marek.behun@nic.cz>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH v3 net-next 1/7] net: bridge: notify switchdev of
 disappearance of old FDB entry upon migration
Thread-Topic: [PATCH v3 net-next 1/7] net: bridge: notify switchdev of
 disappearance of old FDB entry upon migration
Thread-Index: AQHW0VlPMeocR3LBl0GZDisbPfFCdan1HVyAgAADoIA=
Date:   Sun, 13 Dec 2020 15:08:42 +0000
Message-ID: <20201213150841.ctp2njznfqvikj7x@skbuf>
References: <20201213140710.1198050-1-vladimir.oltean@nxp.com>
 <20201213140710.1198050-2-vladimir.oltean@nxp.com>
 <20201213145543.GA2539586@shredder.lan>
In-Reply-To: <20201213145543.GA2539586@shredder.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: idosch.org; dkim=none (message not signed)
 header.d=none;idosch.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.2.120]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: fcfcd307-e6e9-4773-c247-08d89f78fa94
x-ms-traffictypediagnostic: VI1PR04MB5695:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB569518F952BE13FBDA39E873E0C80@VI1PR04MB5695.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uD24Ia6LXLwEPEQuNJ+fzKE+P79hKCdcnhS3ZTdkTA1W712w4eePxaq+/J8X7hvcvJ5hTUe2YXTFFqBbR3nrXKZ0GHYKsQsZ+cgTr+Hvn8Tf+hSaLdMIwXIiPU4i2he1Ilru32JcAW4ctK1HcBSGqa2uJlxt1zQQHd64vpKkXO6OsUnPViNRTMVyct588vIBvzjI2zVrghgrHGZoPpfXQ+Hg+j6leVBZAMOaRa0ukpsJQsPTrCpWPx69PfWVMyCu2xUwQ9acqkHwQ6tcgSwIemjIsoWFSD0fxebZjb2+mNIgn0Xg3NSl3fmdYQg24Um4d7ACOk82S6r+814isxaKoA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(136003)(376002)(366004)(396003)(346002)(39850400004)(6916009)(66476007)(66946007)(8936002)(6506007)(66556008)(83380400001)(64756008)(8676002)(66446008)(5660300002)(478600001)(4326008)(71200400001)(7416002)(44832011)(76116006)(9686003)(6512007)(54906003)(316002)(1076003)(2906002)(33716001)(86362001)(186003)(26005)(6486002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?98DBou6enkOG2PqOI9dOFYP0OhiKaMOkMh4o8JM7oQEMzKPCHm+xKz/bOG+v?=
 =?us-ascii?Q?+SCi/xM94prIDoriBkjuVg5SXlDN9GTePKcQVvalyqBvAKVCMdg6r/yhS2WI?=
 =?us-ascii?Q?aM7cyyGY2D4XTe83+3ehvIZZkcT4KELt1QYd+r4q7aMcl0ILQw8chCRJhzrD?=
 =?us-ascii?Q?YxkPKldo7gdrlw9c2QFgzVmXoj4AoDrlYX0WJhhZdyOr6rIUKMk7cJZA4Trh?=
 =?us-ascii?Q?EQ8dxMeVS/TnWRzlZr8vICGlAy2oeMrp+ZjRBf1i1roGbdjPNKW1u6xpyLlB?=
 =?us-ascii?Q?SsIGetH4Ixw70/k7MAKKzTFLzdZpR+8Z+JBPWUbvDaXNwx1y9D+bQszi0qXo?=
 =?us-ascii?Q?8zSLotnsTa+ds5IIzkRbNxu4o6NBRPjsOlJudZkwUJfSq1A54s0Nq3B5gR/o?=
 =?us-ascii?Q?BPmE3ZQ1CbQXNGExqxZkgESUxKBY0LIaLzfmZEiRYwV+mgt2lZ37HlomOaU7?=
 =?us-ascii?Q?H2GWgZg1y7pZdbOPXAX57jORZqot89hKrRSfw+9+zeFU1T3r2D9TxFp2e+pH?=
 =?us-ascii?Q?7PiAAQixBrDOXJ/VJDPm0PfF5oe8AswC6QQ/dOAjnzD6vzjgPKKSUMPZ1Z54?=
 =?us-ascii?Q?PYsMtS8QYuQpfPzo2Ga4skuQX4xtB19kq2UJUQ2/Srolx4RNmoXe1C6kYfBS?=
 =?us-ascii?Q?7GasPFtC9h6oiupvO28U2d9HqtmsTB2NeUjzCR8KYHgtg8virS1lrSvdvHUX?=
 =?us-ascii?Q?eFOzmRLAYtZuC/D6zVIzlRdynVJVb5gOmBzlfAZIHNPuNcEk3SBwu0rkvMzR?=
 =?us-ascii?Q?JLaq+Pj8n7a/+AVF9ZriSWYP3XEeBW2q2xnK63VUfPyH2f30LsAH5CZNLJWy?=
 =?us-ascii?Q?c4jEs3WIPBCJc8Pdz5MkWcacuYfKxCLzenq5udTn+VM6EbJxKB7rOpDfu24Q?=
 =?us-ascii?Q?q4iMp7UkMMFy/jxPQASV5cVcISajxFfEP574K+JWYTvUYQa95uQZmtJbP1cK?=
 =?us-ascii?Q?wUbYjA17JTFWR72+nZwCj2oo8gaA0nAwftEbg3gDFefwbQlZLS9q2GdXkjDi?=
 =?us-ascii?Q?94jB?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7C8AF35377E370438D117AF298DF8512@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fcfcd307-e6e9-4773-c247-08d89f78fa94
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2020 15:08:42.0640
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LLkos3T/WZK+HCCwpds91veXoED6OVg4MneCuanBVbZmzROpiPpVrgzlzGzqgslpe9NDnWKLZicN6dUehgcwAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5695
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ido,

On Sun, Dec 13, 2020 at 04:55:43PM +0200, Ido Schimmel wrote:
> > As far as the switchdev driver is concerned, all that it needs to ensur=
e
> > is that traffic between Station A and Station B is not forever broken.
> > If it does nothing, then the stale rule to send frames for Station B
> > towards the control interface remains in place. But Station B is no
> > longer reachable via the control interface, but via a port that can
> > offload the bridge port learning attribute. It's just that the port is
> > prevented from learning this address, since the rule overrides FDB
> > updates. So the rule needs to go. The question is via what mechanism.
>=20
> Can you please clarify why the FDB replacement notification is not
> enough?

I didn't say it is not enough. I said it is a whole lot harder to track
from the listener side.

> Is it because the hardware you are working with manages MACs to
> CPU in a separate table from its FDB table? I assume that's why you
> refer to it as a "rule" instead of FDB entry? How common is this with
> DSA switches?

With DSA switches it's just more generic to use a static FDB entry as
the address trapping rule. But since FDB entries are global across the
switch and not really per source port, understandably other mechanisms
such as an ACL entry could be used just as well. And an ACL is what
other drivers (like drivers/staging/fsl-dpaa2/ethsw/) would use for this
purpose (of course, the code is not there yet; it's still in staging,
there are other issues to resolve first).

The mechanism does really not matter though, as long as it's "strong"
and not "weak" (i.e. the entry cannot be overridden by hardware address
learning on the front panel ports). So when the bridge gets any clue
that the L2 routing information is no longer up to date, the very least
we must do is we must delete this trapping rule to give the hardware a
chance to learn again. Where the address is migrated to is really not as
important as the fact that it migrated in the first place. [ ok, then
there's the case where it migrates from a foreign interface to another
foreign interface. For that scenario, we would delete the trapping rule
and then reinstall it, which is not ideal but also not incorrect. ]

> Reviewed-by: Ido Schimmel <idosch@nvidia.com>

Thanks.=
