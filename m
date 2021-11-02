Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2BEE443097
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 15:38:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230502AbhKBOky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 10:40:54 -0400
Received: from mail-eopbgr130047.outbound.protection.outlook.com ([40.107.13.47]:61230
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229557AbhKBOkx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Nov 2021 10:40:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SNyAUKEGgUzLwzo9Ej0ZnNupdoVvJ8G4yE1zPflP0pPkULZ3BCKj82A5cb8fC2EF380XQrZzm3jlaLrDsl2Ih/FRuQ1Ms4on17izmoN+7mPIgmRc+CLe00Kpl0hkmjvJdddRlnSIMm+1Ug2pOzKhnDJWjv737fFa26G6bpnVMVuJBntheNlw0OfoEWKUsW5xa4odtJH28OKqhQNF0IiMwp53IFMYZG490sE1jHAJg2N9JeRHJ+etWoxJCJxfd3onwTzS1QMVDnuEI7n20M3usxHDZlvQ2ZZVIVgqzUVXtF+LdxFiA6ljUbdnOIIneIrFjn8qrSyc42LyFNZ5KoPqEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HUvEEJoYi/KtW63l4yA57nLw+DAfrVaJzjFto+0EUI0=;
 b=WMfd/mBRQDaZfZeRjug2DFZ7kG4qtZGFtaKpnk7WunOGWYB3k/o0P71idPk2VGkSdF5AAFJLeKupSOF41i/r+kEYpTomKPR1ON//objGSqoXqEkgLENIVXTfEPgbJbIwvjs7acfuPvpRCuGzpZoC1egDbU2kjgaMeANpOpRpOaqDCkj67AekspS5mlIqWNsc5ypM3VmqSu/6chZIFzsyzSA5wpMW7+Zy2FphrHkhBNRrkAXmLevWOZAFcIZjJi/k9LqvZtGLBSWZPuzuJsNL2up7d7aoe6s+0sPY33ZG2YdaqZCRxQvRX1mJ6phH7ys3wDb2QNTlMBvxdOm+ctNglw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HUvEEJoYi/KtW63l4yA57nLw+DAfrVaJzjFto+0EUI0=;
 b=ZoFixQi+ND4p3410FAGjx/yW68T1dMwaPKrUH0CZa/Jyduk6tGcIRrpCC6q5RWSzS9f/JyGav2LtBRmPd3KleMX4oODY2gBi436J7o0Us+K+fJRGh4juGgdlpS67F3T0QCAY+U3b1kqT7S2lGdgJ0zpXlzAkMrxDOfS9pJVugcY=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6272.eurprd04.prod.outlook.com (2603:10a6:803:fe::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Tue, 2 Nov
 2021 14:38:16 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4649.020; Tue, 2 Nov 2021
 14:38:16 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next v2 0/3] net: ethernet: ti: cpsw: enable bc/mc
 storm prevention support
Thread-Topic: [PATCH net-next v2 0/3] net: ethernet: ti: cpsw: enable bc/mc
 storm prevention support
Thread-Index: AQHXz0ImQ0nq8SciiUuj95wNlQzg0KvvWM+AgADVTgCAACHogA==
Date:   Tue, 2 Nov 2021 14:38:15 +0000
Message-ID: <20211102143815.d4vqu6udha5hw6ix@skbuf>
References: <20211101170122.19160-1-grygorii.strashko@ti.com>
 <20211101235327.63ggtuhvplsgpmya@skbuf>
 <3fb0e416-ef36-e76f-2ba5-624928f71929@ti.com>
In-Reply-To: <3fb0e416-ef36-e76f-2ba5-624928f71929@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bf119cde-c7a6-4840-e2fb-08d99e0e680a
x-ms-traffictypediagnostic: VI1PR04MB6272:
x-microsoft-antispam-prvs: <VI1PR04MB6272AF603A4B61E77FBCE6CEE08B9@VI1PR04MB6272.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WK+GzMQIZnFvwvEqhG0lhj7RkFxFjDozbdf1PLPYvOxBBp6DMr714FZIepXSbmowkyIUNRFloIpymXoVoPuOWa+qLT97DEaNkMZB+hVSebEabTTCbRu6hOUavddwC4AozlGDx7JjNH+SJCM4TCZF1sIi3SiWjEWtIcP4TR68/uNK7onqrZNrxdXiaGbcZPlaOpMsZxHU9ILwGgBbIQiZCWU+zVR4YeTUm+0jkyht7x/jBIbXn73zh7qkWr4Vxm05LiQJ9ErEr6T2JoojA420dVBdEPR6NXW74YM+Arags7cLNjiOmV4IeMbx/mM1c9yw13KqDHBwdQYjV7L+LWGrWx6SmDsqqc2vOa/rzfXMcdLb7WqyOG13GLvQPE9lO3dd2TgKKP0H4JjfBwgu8Y6+HOOBdCyuN6Lw24/jol6zgtdaBIWn2Fx6zKzAB2Xpn08w5gj4AugpppPRFKVtCSIihE6ECfnHoeP2OiJhtEnnF25gq7hNkIKa0otHqbRsVFWL7neI3qunwB7j1uVYfWUCuwckKNc5wk359RDpxtMoJpypFaVnBIidjMZoZbGz642tGnuoQqsULt9wN51kCkfFNkGe97n2uOEZpiWL61oLsj81iCaOO4jOZ2qBE8L3g6LpXMrrX7Z9M2ct63AjM8jwBq64xJh/cDX52wdDxVNhpfImOia09hb8Q5pVH9el2b+Y6aQ5UILZOma9MGM6MSI4TR8nEb9a4qIsz5S9cUA1Py9W9rRMJV+o6cwCM4jhz2aLF8nQ9b7Mfqj25v5MlhPCvM0c6S/x3yMHr+LiLOltDb3I+cdI8pSxGUj7kskiaA32g7poBPjzPYUG/P3XY2RSOA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(5660300002)(186003)(7416002)(4326008)(86362001)(38100700002)(8936002)(44832011)(83380400001)(6506007)(26005)(53546011)(6512007)(9686003)(2906002)(122000001)(1076003)(316002)(66476007)(66946007)(54906003)(76116006)(6916009)(64756008)(71200400001)(66556008)(66446008)(508600001)(966005)(8676002)(33716001)(38070700005)(91956017)(6486002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Me/AWq4C8Ao8mgYT6xnCrzHQpqwj0Kp7+hcbrMpTulYxCeekbtzHIiKeQUzQ?=
 =?us-ascii?Q?MO720PfJUeY5KTL+CXloCxZi6sSsnixbOedwhgio1Y+1t9UPI0LdJ2R/PisE?=
 =?us-ascii?Q?LRGyeDVaFaMFzGLk1iJGLIUzpDmQY/PmCqn0aknbdCcOepWF3Bj0c7nvExVm?=
 =?us-ascii?Q?l274asjfqvH0+iPB1GwSsxYlWZA145kB/tZoWWnIE44TInTbGWq5G6xnJf+Q?=
 =?us-ascii?Q?wJViJ08E8XafIirmu143Mo/CEk1rVTNMccZ2XH7z3QS/sC5fyrjQP5F41d2x?=
 =?us-ascii?Q?LJIsTBcfVxkditIqXr8zneGOiDTKD09XSP1nCQJBXKKiw8YTmYEwKrDTVh/C?=
 =?us-ascii?Q?Ix0y2mYYBI2Zo5BRtWDO066dli9bSOmipgvv0LwSBBxDWV06OdZvekIXyCIq?=
 =?us-ascii?Q?9PaJup7/BKgAabO72NyeBzTpyLayKyUwWpP8IH0bLcXa1/i/nZ2SBoWg/l0C?=
 =?us-ascii?Q?xHON+B2/CO2SLnKpH6NY0u2t6LgjR8IWI6hwASRiVrZeDxzGS0pUAAp3ZJUC?=
 =?us-ascii?Q?Gu3gWHOx+uNTdxVMHTzmYAW/bZmfS8+5e+z9rVMZAoL4QH9BYIkprvxCL3oQ?=
 =?us-ascii?Q?ApPnfSSJtv7vxgKacugLxECr+sL+ArxwA5Mm5q0GGAyKp/HLReBWxPBkswiI?=
 =?us-ascii?Q?GtsDM+NMUDcE+ZlmJujcohWmGXy891qLl2Q0lxJ/TcfqiQd8XgTfTdbgKctW?=
 =?us-ascii?Q?KBSx60AX8jSPXwL3GXOATKscV7H+x/3ho3oCmWGbWs/KQB+B7cC4m0L2Kdb7?=
 =?us-ascii?Q?0/lEfx0lV2+qoxL7eJX3Hbz/4ruIo7Se0QCrljTavCeBs37NWqVyfTs2YeBS?=
 =?us-ascii?Q?vP58gDFSwcP7NWVDxkwiA3wgbtupjPAFMcXCYC8SVuLraCLSU5GSia6aGvdP?=
 =?us-ascii?Q?dkcKTljMer12YszJ+8v6MhKnyFncTJ0DrQMAPYx5moDE2D/T43ACw3iDr3vQ?=
 =?us-ascii?Q?PgrSSYzst5lwlFIFMm+/meMren2nwlBKS1GOCj3bbsp74/pbWwNB37pqKxFn?=
 =?us-ascii?Q?EnP8BTBFpUnbeIW+VWSjA8ZinflyBQ7Q6nyi0KJ41zgA/+G0t1aUBXNoehYp?=
 =?us-ascii?Q?OWEV2B+B+s8vc5YuWStkXIJP+SR/M+F5mG96pjYObesd03O+fzblPi9IlLC+?=
 =?us-ascii?Q?meXtdB7HH2y/p2fWW2P2J+jVf7W3b2XcYzhx3qq9KV9ifRAA590R7ya0UXvR?=
 =?us-ascii?Q?nbtSZgf6yQmuyAtCrXBzD8WkcPaTCatax1nMd/AUahdWkcLAbrzRvKAE7j+V?=
 =?us-ascii?Q?T6BoYAh65g3lRIjgQk8rhBW97IA6ZKFb5CFQHDQUm3ga6S4WZoXy2vyjYVTO?=
 =?us-ascii?Q?o2S54RqfuWOuQzjoCSXWjNJSFFA5a/oYHOyUn063sX4ovoZCZh6WAlye/ORq?=
 =?us-ascii?Q?euvyoRce7MX6U/+2AZqK5Md0i2/jcGlYDOhSaEnGJ8LxRPM7rAEZ/GHroXDo?=
 =?us-ascii?Q?h12UXV4Q1kDccgB/+2yjYB8fH06p6bJmEph/6WCDQZwNR0Tt4BQUCQSvXzzE?=
 =?us-ascii?Q?ZW7hmkxEY57ZwUhJTJ6uu6NSKcehZpdinsrkefXzzyQX8716vl26LrmBhv0H?=
 =?us-ascii?Q?sfZpabPEvMCA2VPQYxIT5KlhcpdZRbfPAAJq+HlSEoDiReZ0x1KVLMZC9ltV?=
 =?us-ascii?Q?Ax7uxICq66Paxcy+gEtW3pc=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <719237C2B4E1724A80981461ACE6192C@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf119cde-c7a6-4840-e2fb-08d99e0e680a
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Nov 2021 14:38:16.0551
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wRxbeAjXxa/lAbu7ZARaxcFaN8FsAvlGXDzobN3egBevapQoEigqAwuXWY8FSSjo0cMGZRINgy/2qMxHoAhwUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6272
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 02, 2021 at 02:36:54PM +0200, Grygorii Strashko wrote:
> On 02/11/2021 01:53, Vladimir Oltean wrote:
> > On Mon, Nov 01, 2021 at 07:01:19PM +0200, Grygorii Strashko wrote:
> > > Hi
> > >=20
> > > This series first adds supports for the ALE feature to rate limit num=
ber ingress
> > > broadcast(BC)/multicast(MC) packets per/sec which main purpose is BC/=
MC storm
> > > prevention.
> > >=20
> > > And then enables corresponding support for ingress broadcast(BC)/mult=
icast(MC)
> > > packets rate limiting for TI CPSW switchdev and AM65x/J221E CPSW_NUSS=
 drivers by
> > > implementing HW offload for simple tc-flower with policer action with=
 matches
> > > on dst_mac:
> > >   - ff:ff:ff:ff:ff:ff has to be used for BC packets rate limiting
> > >   - 01:00:00:00:00:00 fixed value has to be used for MC packets rate =
limiting
> > >=20
> > > Examples:
> > > - BC rate limit to 1000pps:
> > >    tc qdisc add dev eth0 clsact
> > >    tc filter add dev eth0 ingress flower skip_sw dst_mac ff:ff:ff:ff:=
ff:ff \
> > >    action police pkts_rate 1000 pkts_burst 1
> > >=20
> > > - MC rate limit to 20000pps:
> > >    tc qdisc add dev eth0 clsact
> > >    tc filter add dev eth0 ingress flower skip_sw dst_mac 01:00:00:00:=
00:00 \
> > >    action police pkts_rate 10000 pkts_burst 1
> > >=20
> > >    pkts_burst - not used.
> > >=20
> > > The solution inspired patch from Vladimir Oltean [1].
> > >=20
> > > Changes in v2:
> > >   - switch to packet-per-second policing introduced by
> > >     commit 2ffe0395288a ("net/sched: act_police: add support for pack=
et-per-second policing") [2]
> > >=20
> > > v1: https://patchwork.kernel.org/project/netdevbpf/cover/202011140356=
54.32658-1-grygorii.strashko@ti.com/
> > >=20
> > > [1] https://lore.kernel.org/patchwork/patch/1217254/
> > > [2] https://patchwork.kernel.org/project/netdevbpf/cover/202103121408=
31.23346-1-simon.horman@netronome.com/
> > >=20
> > > Grygorii Strashko (3):
> > >    drivers: net: cpsw: ale: add broadcast/multicast rate limit suppor=
t
> > >    net: ethernet: ti: am65-cpsw: enable bc/mc storm prevention suppor=
t
> > >    net: ethernet: ti: cpsw_new: enable bc/mc storm prevention support
> > >=20
> > >   drivers/net/ethernet/ti/am65-cpsw-qos.c | 145 ++++++++++++++++++++
> > >   drivers/net/ethernet/ti/am65-cpsw-qos.h |   8 ++
> > >   drivers/net/ethernet/ti/cpsw_ale.c      |  66 +++++++++
> > >   drivers/net/ethernet/ti/cpsw_ale.h      |   2 +
> > >   drivers/net/ethernet/ti/cpsw_new.c      |   4 +-
> > >   drivers/net/ethernet/ti/cpsw_priv.c     | 170 +++++++++++++++++++++=
+++
> > >   drivers/net/ethernet/ti/cpsw_priv.h     |   8 ++
> > >   7 files changed, 402 insertions(+), 1 deletion(-)
> > >=20
> > > --=20
> > > 2.17.1
> > >=20
> >=20
> > I don't think I've asked this for v1, but when you say multicast storm
> > control, does the hardware police just unknown multicast frames, or all
> > multicast frames?
> >=20
>=20
>  packets per/sec rate limiting is affects all MC or BC packets once enabl=
ed.

Ok, good.=
