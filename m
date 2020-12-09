Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 176DB2D375F
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 01:05:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730983AbgLIAEq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 19:04:46 -0500
Received: from mail-eopbgr00073.outbound.protection.outlook.com ([40.107.0.73]:59822
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730366AbgLIAEp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 19:04:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=liK4hsIdbKA0a826+qj/Aseo6SjjYyClKqkpcCBGR2+z13uI7CZHt7nkHYoNk1PacYrw8dvpYHryrU/wHGSqSITYVsMCJGdXejLF7xmXGvrM87/1lmAGHAGGh99jgJA23ifVNEsak0cc1KDjD1h1ygfKtPFTxQWQri54h/SVITEZESQaQx1NfaqgzGA75k3ZGd8x7mPpYEcmLBolMdFbNTyBmCslRPB+g3BRTrOJFIUen5bxdsO5ce2gSxu1CObzIoe6CKT9zcYLqL8KBkPBUphUkUa7NkKyTYhP7SwcP05nidMaSJMZOHPecQvHOHkvBMjmkM1gNoqnbJ9xoiMJhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ETrFqU7gE6lJLP837MjxRoqQC5Kn3WVAaN4QOFvlNx0=;
 b=iF3XLKx4nXJ/MwGisfk0DXqsOxLmraMIG728aEFE2Ih/S1jl3vajKfohfFlDZl1edAPRKZN35Cm1N8FjEaoF6bBCJrsr8+BjekjULG/LTgpncO0iInrvH4GnXbOoIuqTVbIWPCE1yY/h1f68Z8Wv16OuR0ZfV77aJoML2BqElJzeUQAvRfTbTtHtJQeI3iMOilwBJr1+di86lsmvQt6LGqix4Nis/FnsnLkPQ0DV43vPvlTS8CTtegHx50ZxaDnM2L78qHUFhfbSYXA7H8xbKbzoJimv8hCPQygAJ+IDP8xL/dGsVCY9KiD/pww0BQf7cmAhYHtNoN2oa/nwI8MEGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ETrFqU7gE6lJLP837MjxRoqQC5Kn3WVAaN4QOFvlNx0=;
 b=rP8kX4jqdkn/kASx6mRUqLdJ5XLHUQ6mNAgvdRuIRYJ/3kzk/LYM27JsUS7uwmZB2Ima1g8aYb1SiKbYFQcVqEupvVu3u0AYercf3PkPI3K40jo8/K4V6ghsGp3DqBW0Wl8Lk1kGGwdR5md64xZ+tilfm3ApuuJmW6LGWXD4/54=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB4815.eurprd04.prod.outlook.com (2603:10a6:803:5d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.19; Wed, 9 Dec
 2020 00:03:57 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3632.021; Wed, 9 Dec 2020
 00:03:57 +0000
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
Thread-Index: AQHWzCvp+5zpZdZumUWV00Rtz8jGw6nq0GsAgAMTFACAAAG6gA==
Date:   Wed, 9 Dec 2020 00:03:56 +0000
Message-ID: <20201209000355.vv4gaj7sgi6kph27@skbuf>
References: <20201206235919.393158-1-vladimir.oltean@nxp.com>
 <20201206235919.393158-6-vladimir.oltean@nxp.com>
 <20201207010040.eriknpcidft3qul6@skbuf>
 <20201208155744.320d694b@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201208155744.320d694b@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.2.120]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 97ef0d07-ac96-4fe3-ff53-08d89bd5ec6f
x-ms-traffictypediagnostic: VI1PR04MB4815:
x-microsoft-antispam-prvs: <VI1PR04MB4815E7A5CF899E5057893446E0CC0@VI1PR04MB4815.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: R4Ylom/RvfAv+LsFQhgRSLHligXZGM/gHlHlG1e1u2lRPPfBbXneSeDcQCNXNWGai1xvUAm1MkYw2k7n6D85zgkbA5Eb2BegNcvwMwe+8tKOLR5teq+4JYtZ/fj6zNyEKN+nPiEbcAvMvlGy+uBUGfKuToWWPqxs9ogdJdRNjxkUrTYTapRRcTUvcLGhkehkrBYLFI1NksF9pAj+09tFpzELq2ZPj45w2unFPyzW05dHBG8wKarh5QMdpja4oAvdKJNtWD7U+cBJLKUjPMuQlshPdh0lCWq5yFIzSSLzZyEajXzgw2VeOMqbe9lvT3jGUT41Sqhua+GPfFtH5gfZgA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(376002)(136003)(346002)(366004)(4744005)(64756008)(6486002)(91956017)(9686003)(1076003)(71200400001)(8936002)(6512007)(186003)(66556008)(66476007)(66446008)(7416002)(66946007)(76116006)(6916009)(86362001)(2906002)(8676002)(33716001)(26005)(44832011)(508600001)(4326008)(83380400001)(5660300002)(6506007)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?gOF4GHaqxTcCmNtyQWHw1RldVay81rJUQhOy4RVqwIySA1LX4HZixbo6mS4Z?=
 =?us-ascii?Q?feQ5kiEd9P2AwwUYGhFFnnWXmJ+S3dUpoxiEJCgqTfPsgqBXUi+c0rbSCSUw?=
 =?us-ascii?Q?Lf/+GUxjRYMiDDqMeYNUNHzdMnawUTh6SC109eEJtTPTjdVMa/T5xPSAdlpp?=
 =?us-ascii?Q?7RkQPa2RR1izE0R36t3Bn4LMAxFb/84EUp3LAE8hjazTNUeL3SaQ6PdDlB5x?=
 =?us-ascii?Q?8yo8bEyABsIDODCAnAy4LKe/xhu59DBz9tVk9/SQUe1sDeM+eJCLPVAnGOL+?=
 =?us-ascii?Q?3CouZ9yFr1MkWNCjvR1zf/g5TC963mFCFN2gjtP14/ajgZK/2M+e1mE4JPFW?=
 =?us-ascii?Q?kOn58k0mOGSfayt6DFfZ0fl29sEYJEl289/vQqZMhfqbRI36kV95uwuA8rxO?=
 =?us-ascii?Q?R77dK2emlXdd1exYh0EJIvnARvvEgH3xueMnrioguvJK9SijM9ZUfRY8eqx5?=
 =?us-ascii?Q?rRj/C4bMXCQY6PSIaQ67+Dy5PgmptWc+VfH8SsWrj6iH7NzVzb8IWiZdlMMx?=
 =?us-ascii?Q?VPKhpTtQ2rjeZ3s9FvPe+BP0kyNaEQqbY9HW0nvSu0L0tVHsVXik8R+hAo95?=
 =?us-ascii?Q?x9oNwpqMwKl5h8bd6dHgx+GAnfdwradSs4bbiE2O5Mw1Vngb1UNHq6tUbziw?=
 =?us-ascii?Q?DhZ5ZBqf+UySlzKhZj/9rCMEy1apHxMDcj8haSA/vCZgJgKBUGrA34NkajFX?=
 =?us-ascii?Q?atfVsh26ls0rR4yG7Do8d/vE3uZKGx6N+zvuEdJbDDYOEkyaH4Xg9yky/GoA?=
 =?us-ascii?Q?dq2bjUK9yLjRyhs0QoIdIq3xowr+vMrriyHpap1CclT+THCZ91mNBsM5lxHd?=
 =?us-ascii?Q?yQ0PhfBhgoxKf7s2ZGBQRKSu6sQjvTSaOASJfRaqb+a0rcBfBrzZQg7OI4tw?=
 =?us-ascii?Q?G4GrZDchD5GSjwGWarEjp9gs9uhWqRORAa/ZR/tAn9H4EkZJ0w0TA8yFEdmd?=
 =?us-ascii?Q?JN8p5/ZZfdZxG9W1ccROuVfvptfnwmDZhKQooQMwGLwP45NjZHcI2DGUGatf?=
 =?us-ascii?Q?dwtt?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B3C36C224B95184384236C57B574EE6A@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97ef0d07-ac96-4fe3-ff53-08d89bd5ec6f
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2020 00:03:56.8997
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SM26J7znaIf2IjircQilTKUrEvsl4fiBdmlz5FT6aWwSE1ow2HryU6GxQy/h1QQiiPGx0sK/MFDLBuP7Q8F+TA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4815
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 08, 2020 at 03:57:44PM -0800, Jakub Kicinski wrote:
> On Mon, 7 Dec 2020 01:00:40 +0000 Vladimir Oltean wrote:
> > - ensuring through convention that user space always takes
> >   net->netdev_lists_lock when calling dev_get_stats, and documenting
> >   that, and therefore making it unnecessary to lock in bonding.
>
> This seems like the better option to me. Makes the locking rules pretty
> clear.

It is non-obvious to me that top-level callers of dev_get_stats should
hold a lock as specific as the one protecting the lists of network
interfaces. In the vast majority of implementations of dev_get_stats,
that lock would not actually protect anything, which would lead into
just one more lock that is used for more than it should be. In my tree I
had actually already switched over to mutex_lock_nested. Nonetheless, I
am still open if you want to make the case that simplicity should prevail
over specificity. But in that case, maybe we should just keep on using
the RTNL mutex.=
