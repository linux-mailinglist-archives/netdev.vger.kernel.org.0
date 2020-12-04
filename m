Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 001262CF343
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 18:43:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731374AbgLDRlu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 12:41:50 -0500
Received: from mail-vi1eur05on2088.outbound.protection.outlook.com ([40.107.21.88]:52673
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728463AbgLDRlt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 12:41:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RgoY5QMn898fQOaE50ZDd6bffWuAO+Sc9wuw9g6A2jO/pvGCPuFQ5NrCMUOyiW7ANNXh+6+W1Ed6HaIzmd/I0mMZyXP163dms7IWvTt53m5H/w8BCdO9VAffHdpDq+pebzwz7KV24ZOWT6KqrjpAoHJZHQgUk9H8YTwNdo2D+Iud9C8+vDfDpHeP/g4dE1UDPM1S2cutH3WtuVP3qyfVRubAhftgcYVUxMJz8ia5ugZs1kQnlN4Qn85Eqym/TqPiuCsXvhnSeTXpt8mkeuiHByStzP7ep5JdOl/CzMcA9MvFMedq5vhMdtuvV133ue+spildpnllrP4Qa0G6xvsQxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JdM0IDi6RG60YS/NTFcdHQhefgcV8riNe6w9JjCF6Gs=;
 b=kG5Hpq+SXo8iporp9H5xYsKWSnmdOQwfWNGidApJs7qMArq7BAtPXxV3pUleO9w2KBGyyDOnqCaHXngypN4AEjjkm1/YYWzbPpGEAK4neMtvMoFPf8PI+JE4dh6D0bGL3Si2ppe0nRXxhgU3qr236J5oSPdgLMNVd5WZpaVs8/aRO92o2h22C2eeNIw6NnDeHYotaH+vMj0R3OTMHgIv+gnz86b1EJjISuSo5zMlg0GSFpC7yZQ574gdIx6C6Br12kaNWyus7GJnQSpQRYRjGCe/I+Fl0hYQONjMZbyEwtw+NiCEPzXDUhxt5EneQoSeCQiL0N6ehUvAAJwm3ahQ6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JdM0IDi6RG60YS/NTFcdHQhefgcV8riNe6w9JjCF6Gs=;
 b=CwcHkiAuWpRH9Pexh4rFO9heB5seQWZaibaU0MKPP0qALcZsv+PXAAG4ZeTr/ob4UdjbOGtHE8eYWPXsw/T8STDKZ8k9yRXEBc8ATj9Idgd6Sk7kyGBT4CToScI8XOJdOtycBmE6AjZ/utDUm5LKHz3r9xcvX+ovEjJGdvpoPPE=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB6125.eurprd04.prod.outlook.com (2603:10a6:803:f9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Fri, 4 Dec
 2020 17:41:00 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3632.021; Fri, 4 Dec 2020
 17:41:00 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        "Allan W . Nielsen" <allan.nielsen@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Steen Hegelund <steen.hegelund@microchip.com>
Subject: Re: [PATCH net] net: mscc: ocelot: install MAC addresses in
 .ndo_set_rx_mode from process context
Thread-Topic: [PATCH net] net: mscc: ocelot: install MAC addresses in
 .ndo_set_rx_mode from process context
Thread-Index: AQHWymBKCWFfxZoe6kelBVEM+6uKWqnnMs0AgAABs4A=
Date:   Fri, 4 Dec 2020 17:40:59 +0000
Message-ID: <20201204174059.fnnkthxfjgw47z65@skbuf>
References: <20201204170938.1415582-1-vladimir.oltean@nxp.com>
 <ae82dc10-11af-e48a-a317-fc60cda3b993@gmail.com>
In-Reply-To: <ae82dc10-11af-e48a-a317-fc60cda3b993@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.2.120]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6ceb8123-acc1-44e1-2b62-08d8987bc37c
x-ms-traffictypediagnostic: VI1PR04MB6125:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB6125CBC78BF41EA7C5706D0DE0F10@VI1PR04MB6125.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1051;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AmIYnrXAFDGFC/H8i5rgIPLzJHQoa4mPbl0aiCNXcQiZvHrQb051Be96Z0Ue1JqN96MR8gYwhO96A/czg9LCa3VY6lblxdXLRBMR6BdLGPH2lUYngVtPMLJn6nSs/IfthKyPtbEZL+CZ22cV9QQ9WLUXzqsVYVlL03ywwMsDWr8TFjPo1VjhgLLDouA0mOL8JB2fRuQkPztw0L53+ZB2OS739Hjylax26ASfd/iL17q709oG7bdJzPIJh0P0U2quo4I1agOs1OLD9d/F4vOE/24HLwFtRwXHxwFgEZsCqjdRKnVWlew/v20m8R9MwGjjnzyYQKnavx1QF72MsyjfMBBF4mFUXyk5oLmztMbr8UXUR2gVRnVHTy+1j/2KOOce
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(39860400002)(376002)(396003)(346002)(366004)(136003)(83380400001)(4326008)(66556008)(66476007)(64756008)(66446008)(91956017)(76116006)(6512007)(54906003)(9686003)(478600001)(316002)(8936002)(44832011)(33716001)(5660300002)(71200400001)(8676002)(6916009)(186003)(66946007)(1076003)(53546011)(6486002)(6506007)(26005)(7416002)(86362001)(2906002)(142923001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?6qw0IAG+Ve5ph6g3IDvNk3KnQxtzVsD52/XN+BMRJanrwtgF44HgXcGMiq9Z?=
 =?us-ascii?Q?HcKuxz4rnx8QkhvAgm0lox8jtX2swLkt2QZsBZ21BXMOiDHCIPHQbIA6wAkT?=
 =?us-ascii?Q?rlIGhhX+YTIhkHb26XoUGAJuPTHTNqESv4vO6uUiHmt5XA7ArUE4a7uazpar?=
 =?us-ascii?Q?LsFZS0KabT9Qrw1pUcC79yr4+XptdGoompKRwrycXrpZyo5miymSyZKoJnJf?=
 =?us-ascii?Q?1HTiOguG/Fo8mwpiFXOmAvghodjPoA1pABtNCBwX6SA4tcFmIDB1vVdkS4A7?=
 =?us-ascii?Q?KEcTpgIq+GkSbSst5CyM2dWk5Ef6j9CLvGZfOug8TpniKpq2r+Tte0usbzkl?=
 =?us-ascii?Q?bLunUNxpqW0LwYpsrdPsh8w+Ed0oYCERYLMO+w4+FrRvKJQe/Dx3AXtrEb2g?=
 =?us-ascii?Q?ZRlfCOg8qakmZSBMuT3WMjUTsFS3uSd3PrIwyc1kJCfLvu3W1aQ/HRbP6jHb?=
 =?us-ascii?Q?JwXmaLZ/ZyDjtaXmoaaqtlYaBSljBT6d8wg+Qe9/2pYbEbV/Z3Rv5FWspIlb?=
 =?us-ascii?Q?ItQ/YGgx2asdb4B4ZQlAJHjq1PFfSkLaLOXWgfMpmeJWH1+9/rKXmJoplEjW?=
 =?us-ascii?Q?AXxxA0tv2keUABSaZLGgoTdM1/+CBB+fiV2ML95olqgxtG4nfy82kHV+AnHL?=
 =?us-ascii?Q?HT/iAAYLuPWal49SUiMpkH1F37LpXfFw8f0jHWC1N8UzypJqBPN2q/apnxDM?=
 =?us-ascii?Q?Xpq8p5klSR3domjCAA2pdSam3AKlXoiAGhoyWVEZhgrBbP18UsQm4vZtH86i?=
 =?us-ascii?Q?CgclVIA+oc2lTksyAaEJ/GfeRT2s4dyLq8QdrloHS10WdbLsMBNAj4uCPT3J?=
 =?us-ascii?Q?qlhFs0UTWdM18ePSehKmC5xLJCVPxmCn5MSfjnk/jVNzVHE+6qdYxOOMoYnM?=
 =?us-ascii?Q?YD5p944UPj9LyCCuzNFN6aGO3x84eV+TEEo97uXUf+agLLf5KO/NG7lTiDmY?=
 =?us-ascii?Q?r2UCTi5vVt9hgeQH5J/jL65zFfyHsR4k5AyFVsjHiElZPgnnuyo95bItvK69?=
 =?us-ascii?Q?Rtt5?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E4A9EBC3DAA16F41909108894E45938E@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ceb8123-acc1-44e1-2b62-08d8987bc37c
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2020 17:40:59.9699
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IhMq/fJyZedqQXl/46Ubu0HSkNXOMolt8lFkjl/MCpzkoXCPblQEAFk4sJGdTLKISI/I/ZcPhOBmupKV8XkuTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6125
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 04, 2020 at 09:34:54AM -0800, Florian Fainelli wrote:
> On 12/4/2020 9:09 AM, Vladimir Oltean wrote:
> > Currently ocelot_set_rx_mode calls ocelot_mact_learn directly, which ha=
s
> > a very nice ocelot_mact_wait_for_completion at the end. Introduced in
> > commit 639c1b2625af ("net: mscc: ocelot: Register poll timeout should b=
e
> > wall time not attempts"), this function uses readx_poll_timeout which
> > triggers a lot of lockdep warnings and is also dangerous to use from
> > atomic context, leading to lockups and panics.
> >=20
> > Steen Hegelund added a poll timeout of 100 ms for checking the MAC
> > table, a duration which is clearly absurd to poll in atomic context.
> > So we need to defer the MAC table access to process context, which we d=
o
> > via a dynamically allocated workqueue which contains all there is to
> > know about the MAC table operation it has to do.
> >=20
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>=20
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
>=20
> Did you want to have a Fixes tag to help identify how far back this
> needs to be back ported?

I was on the fence about whether I should even target "net", considering
that it's not a small patch. But the lockdep warnings are super annoying,
I cannot do anything further on the ocelot switchdev driver with them.

There's also a small concern I have that I should have taken a reference
count on ocelot->dev using get_device, to avoid racing with the unbind.
I think I'll send a v2 with this and a Fixes: tag.=
