Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 035632D3846
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 02:29:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725820AbgLIB3A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 20:29:00 -0500
Received: from mail-eopbgr30046.outbound.protection.outlook.com ([40.107.3.46]:24842
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725768AbgLIB27 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 20:28:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XvpNPKSbwSuZHf9HPg6Hk0qOTH68xcV159i1z7ddrpJDeCyeES/Ir+P8ZFuBm7IY7vdGVwTTJWnJBeY0GmXg1/SA8DTVZE+d7Oj/qeZuDf+4LuWDp+ytbjRFTFOPBqczz6thc9evE6sBqq1gH6EvmQTwv7t5p31LA75oMLDxlddbwyhT/1DT4nPAR43RHPxfWyg9ZgccOjEj3xvSFE/T/70iwuXJka2AfdI5dn/0BQl8Xw3c1GeSgLOqr10O4FsqTIcAsJwqzoQZOUsDo085dVVg391DsDghINmKFkn+kjcBYl5Sji1LnBwpT/B34Cv3YOyTRem91lS3kXsvab7dww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kEhmstVjXj2f2psu5QKqq44luC2hHSLFneB6nX8vbRU=;
 b=UYRWjV/uXSYp8qp9twEYoLu9vPOgRvP8P0Uf1xTkAPHdVhGhYUjO0WA2FG0aVBQ1EKoc+O3zwdNxQEa48jMpFuu8Y08XZ3hh+bQp/BZRMoogGYgNg7GDrDA+Gt0kYt16tPoIE82jUPyhsv8Id5UXT9ypsaX6jlxD2mx1NUONvn/707lT7fKBT9/dstGHc7U5xrcr/0CMtdtFRI2xaCD/kd2JagkepRhTuXehWaR7GEzwpVemm7GpwFvJx9WyvBlWZ/sAURub3XvWJKi/BlriN/g0mLOybqpNcHrU5TrNrykBXFVgWS+9+aJmsTT3rQOETJRZvstT6XoimTJIhYpe/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kEhmstVjXj2f2psu5QKqq44luC2hHSLFneB6nX8vbRU=;
 b=KI9Noo4KSGWTkM8KHCc4kHB/1dGLLeA1Lb537mul8jsV8G0/0mlw1tv3Xb5HvZyJ/45jykRP8yHmA512gB8KLrfPMjgQevpWMqJXUJmKoyK67+43LY8gLrr83W8GoaMRJ3Cf7maJXxSs/6VY8p4rXwQaZlNIxdYVOuN8Q8geMNk=
Received: from AM6PR04MB5685.eurprd04.prod.outlook.com (2603:10a6:20b:a4::30)
 by AM6PR0402MB3830.eurprd04.prod.outlook.com (2603:10a6:209:1d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Wed, 9 Dec
 2020 01:28:10 +0000
Received: from AM6PR04MB5685.eurprd04.prod.outlook.com
 ([fe80::5a9:9a3e:fa04:8f66]) by AM6PR04MB5685.eurprd04.prod.outlook.com
 ([fe80::5a9:9a3e:fa04:8f66%3]) with mapi id 15.20.3654.013; Wed, 9 Dec 2020
 01:28:10 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jiri Benc <jbenc@redhat.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Eric Dumazet <edumazet@google.com>,
        George McCollister <george.mccollister@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>
Subject: Re: [RFC PATCH net-next 05/13] net: bonding: hold the netdev lists
 lock when retrieving device statistics
Thread-Topic: [RFC PATCH net-next 05/13] net: bonding: hold the netdev lists
 lock when retrieving device statistics
Thread-Index: AQHWzCvp+5zpZdZumUWV00Rtz8jGw6nq0GsAgAMTFACAAAG6gIAAA9SAgAAPxgCAAAPuAA==
Date:   Wed, 9 Dec 2020 01:28:09 +0000
Message-ID: <20201209012808.2qwt3bjog2avorms@skbuf>
References: <20201206235919.393158-1-vladimir.oltean@nxp.com>
 <20201206235919.393158-6-vladimir.oltean@nxp.com>
 <20201207010040.eriknpcidft3qul6@skbuf>
 <20201208155744.320d694b@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <20201209000355.vv4gaj7sgi6kph27@skbuf>
 <20201208161737.0dff3139@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <20201209011404.lkglsvtq3k45fxp2@skbuf>
In-Reply-To: <20201209011404.lkglsvtq3k45fxp2@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.2.120]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 13209c4f-2702-4842-a410-08d89be1b04c
x-ms-traffictypediagnostic: AM6PR0402MB3830:
x-microsoft-antispam-prvs: <AM6PR0402MB3830CB5132F3AD34615B65D7E0CC0@AM6PR0402MB3830.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: H1v+R8uoMxb6Ucs6/bOiNOiX0tD+/vUcqNYX8kOtBpaeBZEMkgTV8/WpD6yjnvLlJVtv+5V8F+V1s8R6X2retCAhxer6mmbrpEc2RcNlEjn9yJdWFGIikOtDDi0qAOMyupu0CTGI3x9UgkNNzLqEablzr6Zx9FX0d/Qq9egd2u1j2S8gjTc3gmogHNwHgP4XqcDtIV0006AZmNVWNqIo122O5BT+FZzN7YNTSp8+7WU94QqLuGVeyqHuB+dVcTyYh5o3V8JV66oVUxRp+oacmCshoSqOKeYhLIp/6LqUls7KeieCM0h3lE1TDPNc23c/mP2TQocmpolh4jf/CHkTdQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB5685.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(136003)(366004)(346002)(376002)(4326008)(6486002)(1076003)(54906003)(186003)(33716001)(5660300002)(7416002)(44832011)(2906002)(508600001)(6916009)(66476007)(64756008)(71200400001)(66446008)(66556008)(86362001)(91956017)(76116006)(8936002)(66946007)(9686003)(8676002)(6512007)(26005)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?FS7pPggqH8uA3shl3tdfxiwRL0mx4TvzKTZROWCxXdL3BuZ6+lGetxqj4gP+?=
 =?us-ascii?Q?mwc8DTCSS2rfZnmhn70Xzr6f9qJ+WFb+iHAAvimcZ9HC1gQlfeYCUiTyNqZy?=
 =?us-ascii?Q?7ePM8tuLTnn0vi19JvK2BXrzd6D4cm0AtlI0iJwaRPO/kvAyj0yOdWA77KcX?=
 =?us-ascii?Q?Wf3Oe+0NxQeDICxWxfYnmV59IGNy5v9epDEHMVQpvf7i2pCnwtTC8kPlHMjh?=
 =?us-ascii?Q?Wkne5TKDxMLISrfjDWVxiTtdTA+bGIugc9Hqgu0DHpS1H61sI6RhsbYK8BX9?=
 =?us-ascii?Q?qYNXJt4ShqNYzFJBRgJ/NtI0nmYIoap0utKwSBqnqG+mUu3x5RHXIg7tG3LD?=
 =?us-ascii?Q?kUVzg6cv0E+Kej/C9okEPZXKji8GnTOfjIuKuy+HhtD+IRd22LAgJHJL1tI5?=
 =?us-ascii?Q?ULra2M0Ii2+9jmEnsyTAEF6Bd6NgizDs/AFobhU7OirYD9fRfTp6Ytzz5j21?=
 =?us-ascii?Q?ZadnppSdKsFAVuENhyegobcUT/Fyzc4A/cxPC21Zn997iyWvS3NHneCLVH4H?=
 =?us-ascii?Q?Ew/fftM6lSiHpW4ZR4bn32C0mtDeeH+gajSMRXvxUqHLZDKK/YHMJKpUVQz/?=
 =?us-ascii?Q?Ph8RsEJnHXg4hFDcbJ5Zqpd087w6Whp1VvUCMgoGAaSkzR9CGo1LMpxpHhhX?=
 =?us-ascii?Q?rRjs6eCRSIXomDjKsCttMOOAbPmBdBwDFFF8ufNfKKkAt9tqXtfCryoJwHdA?=
 =?us-ascii?Q?IcOL/xgnlKiwQCC3sSTPZKeBR7QkCeSg7SsTXmiEpoAMI7/OWlewrvoG3cKn?=
 =?us-ascii?Q?Yx64borEDzdbVVt6UZEp+VJmCDWY093Fyji7SohHWzxfvU4TU486jrsrEZ7x?=
 =?us-ascii?Q?0gXEdv6x5hkVx5bNzBZlDR7CJw3utlFx2mlhA08UWlhMS1tC1kEeLX+8n+Qp?=
 =?us-ascii?Q?wAMflI1zdOwhBcdDJMviqDA1UUWFmF6rOdpneDFhsB/AFJM8ROcvbmTON7KI?=
 =?us-ascii?Q?7UtFAokO4T9lkFmVczpiSK1Lj6etEYb3iGSevXKfMR3vCnKuGZeB0jsYpu23?=
 =?us-ascii?Q?SYVN?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0AF110962DE8A3498B0A94AAFAE99186@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB5685.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13209c4f-2702-4842-a410-08d89be1b04c
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2020 01:28:10.0065
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Pmkn5FAufASKwpC446Q+Op2wh3ga/LwMCRuGmuMmmIJAGFftMwosQK7J0iKnVX1Tu1BBkzODjN0S3Eg+1dlJ6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3830
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 09, 2020 at 03:14:04AM +0200, Vladimir Oltean wrote:
> net_failover and bonding are the only drivers that are creating this
> recursivity requirement in dev_get_stats. Other one-over-many stackable
> interfaces, like the bridge, just use dev_get_tstats64. I'm almost
> thinking that it would be cleaner to convert these two to dev_get_tstats6=
4
> too, that would simplify things enormously. Even team uses something
> that is based on software counters, something reminiscent of
> dev_get_tstats64, definitely not counters retrieved from the underlying
> device. Of course, the disadvantage with doing that is going to be that
> virtual interfaces cannot retrieve statistics recursively from their
> lower interface. I'm trying to think how much of a real disadvantage
> that will be. For offloaded interfaces they will be completely off,
> that's for sure. And this is one of the reasons that mandated the DSA
> rework to expose MAC-based counters in dev_get_stats in the first place.
> But thinking in the larger sense. An offloading interface that supports
> IP forwarding, with 50 VLAN uppers. How could the statistics counters of
> those VLAN uppers ever be correct. It's not realistic to expect of the
> underlying hardware to keep separate statistics for each upper, that the
> upper could then go ahead and just query. Sure, in the cases where a
> lower can have only one upper at a time (bridge, bonding) what I said is
> not applicable, but the general goal of having accurate counters for
> offloading interfaces everywhere seems to not be really achievable.

Ok, putting some more thought into it after sending the email, maybe it
isn't unreasonable for devices with IP fwd offload to keep statistics
for each upper. They need to be aware of those uppers for a plethora of
other reasons, after all.

So, here's another idea for eliminating the recursion. Maybe we just add
a new netdevice feature, NETIF_F_FOLDING_STATS, or something like that,
which bonding and failover will use. Then dev_get_stats sees that flag,
and instead of calling ->ndo_get_stats64 for it, it just iterates
through its bottom-most level of lower interfaces and aggregates the
stats by itself.=
