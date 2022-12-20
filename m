Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 166FE65273F
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 20:43:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbiLTTnf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 14:43:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbiLTTnd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 14:43:33 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC233BC3
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 11:43:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1671565411; x=1703101411;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zrxN5cmhY94mIthQoB5bhB+0ujU81DFfotZ7btEiDlc=;
  b=mR+8V3RpfcMa2Ruib/yQx16+afmtmUwBlSFaOjMdYBaO4QkgYnzicqyu
   D60ZkiJ/VOwZ2KfCv3Ft9pCGTe40BQksvThTJY2lyQJIofeiUy2PQIDmg
   ECBBkkmKdKpZXzIhFk17S3ckRLLGIxmwbOMTiI5S1FmB+jM018BKs1BbS
   MUunA0lEO9J5H1BYLC4udhK+N0jeULM9bbHVNEYDjlietBh3iadBoFBO1
   UqtGl/CQthVQQ4GfDiKN7N4gXQ/MbbVMYxOwl41v6hsgwrUuDwwj4h59b
   R1LdB551nsa+jaChPJIrVzb5JLBW0aLXSx1QzLfYC70cRM17Lg3Qw99Te
   g==;
X-IronPort-AV: E=Sophos;i="5.96,259,1665471600"; 
   d="scan'208";a="193819907"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Dec 2022 12:43:30 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 20 Dec 2022 12:43:30 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 20 Dec 2022 12:43:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ahaMrWiRzJQhqVxNHKdyLdAn87itvw8StgBJ2j1x6vD3zqJUAFDD6A3MI7ZGktdOI46+AeBsO1sSzjE0R7d2br3Pzsp1UwBfjKomjYy0DMy64DBCl3EEX1LnSC9g2GXE25oN1t2Hh85vAd4kbblYUeRnTzYoLIkt4f/eCwbdcuP9JGN65KvMpymd+s3f/K0dcSe1Au3NOKFxDg0CFZWmeq39CPyALDwH4Q32U1NUm6NdQsj7O1C5nuD22oLgDvC/zhzd5Y+XJMqkzUSDCHCkPtBcpoy6QsKWvWE4hGAyIY5kzUJqjEv5BpsK45yBZpEOijHq0nioDgJ+TNgFRVUAIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=51ri3KpZXxoAvDyevhUijcN1/tJ43/DEFkuvFPATbMw=;
 b=aUiezk9JhMZmjz2aIff7HgD+wpoMOmwOEB4jvj2h/HNV0ic2+ZCMmlGIpCW2p1IFYDeP3Hh7g37RYPeik9P9WP/iX4iEwJaX4wYyhvQoP0MrfjnvGgRboZiM3FBB1EFLYLR5S4IKwqtwYTuW0E0Nx6TcMd9VGmoi8h8C7dLFOMHXUy5LnrS+kdHJNqutBQh3/O2Z5fVzzVLCit8c92qfPjxyIo/rVRQqXFbHPvWAdpH+et1MkeM+b3ALrlThiYJMau4AT1gOjxebrbH/efWFvGnZ5zSg4IRuai+vQtGt67QG7Kd+A9HVWbKspWt3rjov6lAg2uZ/yfcuHrUaRjy44w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=51ri3KpZXxoAvDyevhUijcN1/tJ43/DEFkuvFPATbMw=;
 b=dIHmk9MNS0jQ/YmEv+6YLvb2TJCbtKhDNUBpK/RsYtqFpsHTgCM0/KhlFEC4d9oRD0SI93J8u9yEUUayLQK4XuMLbans4BFU7ZELu9SBuMCw1WY42Pro8N2irwKkS8KF0/ruO27J9b2u5U1mTJS9ut5ERKsRabLhr4cWSZFjq5I=
Received: from BL0PR11MB2913.namprd11.prod.outlook.com (2603:10b6:208:79::29)
 by MW4PR11MB6570.namprd11.prod.outlook.com (2603:10b6:303:1e3::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Tue, 20 Dec
 2022 19:43:28 +0000
Received: from BL0PR11MB2913.namprd11.prod.outlook.com
 ([fe80::f4ce:ed7:13c:d2f9]) by BL0PR11MB2913.namprd11.prod.outlook.com
 ([fe80::f4ce:ed7:13c:d2f9%3]) with mapi id 15.20.5924.016; Tue, 20 Dec 2022
 19:43:28 +0000
From:   <Woojung.Huh@microchip.com>
To:     <andrew@lunn.ch>, <enguerrand.de-ribaucourt@savoirfairelinux.com>
CC:     <hkallweit1@gmail.com>, <netdev@vger.kernel.org>,
        <pabeni@redhat.com>, <davem@davemloft.net>,
        <UNGLinuxDriver@microchip.com>, <linux@armlinux.org.uk>
Subject: RE: [PATCH v3 1/3] net: phy: add EXPORT_SYMBOL to
 phy_disable_interrupts()
Thread-Topic: [PATCH v3 1/3] net: phy: add EXPORT_SYMBOL to
 phy_disable_interrupts()
Thread-Index: AQHZFHXQ7WCloTwD2U2Ai9oe1b7btK522QaAgAAGVgCAAAStAIAACAmAgAASnACAAC5RkA==
Date:   Tue, 20 Dec 2022 19:43:28 +0000
Message-ID: <BL0PR11MB29131080A183B94D1E4F1C39E7EA9@BL0PR11MB2913.namprd11.prod.outlook.com>
References: <9235D6609DB808459E95D78E17F2E43D408987FF@CHN-SV-EXMX02.mchp-main.com>
 <20221220131921.806365-2-enguerrand.de-ribaucourt@savoirfairelinux.com>
 <7ac42bd4-3088-5bd5-dcfc-c1e74466abb5@gmail.com>
 <1721908413.470634.1671548576554.JavaMail.zimbra@savoirfairelinux.com>
 <cc720a28-9e73-7c88-86af-8814b02ee580@gmail.com>
 <1567686748.473254.1671551305632.JavaMail.zimbra@savoirfairelinux.com>
 <Y6Ho5rIlRHYPePEo@lunn.ch>
In-Reply-To: <Y6Ho5rIlRHYPePEo@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL0PR11MB2913:EE_|MW4PR11MB6570:EE_
x-ms-office365-filtering-correlation-id: eba02ef8-36bf-4faa-672f-08dae2c277d5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ipFw3CHwCCqVT6udRUXK4XbOoh1bD0f2bevWDIEzn7U9WtBY5kpmEKI4Tcv1MalCaxiwFGYIWe6IvXOYCFhPdhtFnJEuCCZa8tT2Ep0HlB1Jxfyco5/XXnSdQl6hsEgtxhie6J7BiNeLPVZJ1AjDlT3M4N32IedQLWlFJNiLYBprD4Hs5yVAip0F6bw8i4bg6UbgQF1BRkVwHctesu00W9EqJn5q9N+Z1JHRuP1R4+M98/FZKdome2hx4sd5XvALw40WCrWh9X/M7vYdciCJiLrIOzsDwXjynGJ0hzZawrwk9cGT7BH6Fm8myZ4Odv3cJKeEGkiKHwIFDdPy4KWmXrOFZaJGc8J/1+0/JYjPSt+h1bRxo2+XokcnlWlkvp3HWKl/kkPKRJUEykbhjd4OFXyu/OzKy5rDdHLaxfHMO3HE2D6atHfnDqXWUmhJdSyrEgde+138o0G0igbduQDNAosJx7hhuZ3CoBzCNmOF6XaXV5BuMKs87c4TSA3iok+7nCl4MafJzM7D4KgFLFnDxwKycfB2xBjE6kjryBxMgQZbNYSQAJJL2P5Gccg5i/Q32IFbGvsKapicReCAtS6LCe0hxw2qYor5VQt4sQgai1bGWNe6/LLDyETpnTloTx+ePPxrHdqWutAwwkvR0NX3mG/5/0RNGtKioZiCW5FScP3kcHuEN+l5OBMKS7IjyeoOsNTAfnPYXOQ/+iQwGIocCw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR11MB2913.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(136003)(376002)(366004)(39860400002)(451199015)(41300700001)(4326008)(8676002)(83380400001)(2906002)(38100700002)(38070700005)(5660300002)(122000001)(8936002)(52536014)(53546011)(7696005)(6506007)(66446008)(478600001)(33656002)(316002)(26005)(55016003)(110136005)(66556008)(54906003)(76116006)(66476007)(66946007)(71200400001)(64756008)(86362001)(186003)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?c2Ix0Ki1MCRXLbaPa41hFlMzylwDcz260C7FhMDDbStMx2t72wR+RZWS0vcg?=
 =?us-ascii?Q?zeIfUSZ4zUQhJjPjJXKro0DJEmSx17TEPpKLQVEnD29d0pttUG0ydDtznvWJ?=
 =?us-ascii?Q?ByTb0rlrTMI+kETbsDICkObKDjY/S8oMp/t/0c8uPQUdYMN8zwBVHPWlA0f+?=
 =?us-ascii?Q?BG05x0et35pGr0FWzBZZEKr/t9mxJ0VeqPTVsrAewN0TMy1D4IbzuIiDB+bA?=
 =?us-ascii?Q?RbdwtntvxfX73flcD9poffJE9np0jhZrL66rJN1w8oMkhiRkW2aR5Ij8sxW7?=
 =?us-ascii?Q?M4nDT6don/jSf8/yvz5GIqEdOzI6/UqELH8RdpgjccXt1IltFhLczZVIfU8X?=
 =?us-ascii?Q?cSoy63TonkvKzetYXYxM8NV1zRYm+G8mV+1M23H44C/sJ6fdIfiIbmC2fPgW?=
 =?us-ascii?Q?W4T7nNyAcXz60/9I/7vkDuIJMnbQg+GU7lwXo9fqY5cny7e4bjHFSfdQxtOI?=
 =?us-ascii?Q?SszKNM3aUxTvUukTxvZn8Oo116QWhuF8DerKAusGJIpWxC4wv2nNM7s5w5Fz?=
 =?us-ascii?Q?oDmLrfcHeR9PfcifV2HS/Abb48yA0D18H2ojJqgZ/nUPf9eST68R6TwJG1HQ?=
 =?us-ascii?Q?wGHQ0kGhqEoMt71/DiihwMLBulV5FxwYWyMriEI2Bnb22B3Q/yCRRhFelCZS?=
 =?us-ascii?Q?UrTuICPiZ/6D7QO5tNpIt9v2xDwza7k5n1FbxVPJyfXJpwtGR5WFlM5oQnO5?=
 =?us-ascii?Q?8lLtqBvflY+fhGO2qw8nAsSmt8Bc+wvUQye9NksiPXT41cR32y+7Lu5L5bBi?=
 =?us-ascii?Q?RcuHjmCCoqzC8D2jfW7OwRvG3Sj4YdO3x5sNww8zmmhJjBWPLrss8SCqcabk?=
 =?us-ascii?Q?GFPzAu5Z3j8yPEIwnST082oSxTEU8eKK1ibVC3xCiase12Cm4/+GzX7SrLXr?=
 =?us-ascii?Q?jSWEJMNfZBfB+4s8Yr4K/55xf69FIHi8SroFj/5Xi0/kPWv63banDXpX2/3+?=
 =?us-ascii?Q?OEVTLsrvJTELC+xsr3BDovIL35qhOzO3hUdgdCGUx8schbB7FZX5X0BEuLYQ?=
 =?us-ascii?Q?El9r+M6eaP2eHy8ywbHrKb1ODDpusGMLnXFMovYw6p2b+7s3I0/4lQkHVV4z?=
 =?us-ascii?Q?XT3ZcmcHvgMJ8KE2cTeYCcd21q/YwLhX4mGnVjHaTYA0gML+dn3Jb2upAgxz?=
 =?us-ascii?Q?ew4GG7jhwDKCR2ZMb03oP5OKjDpvBFUDYBMKLcS4OUmV4FrAC/3CV7HxgAYg?=
 =?us-ascii?Q?0y01nfS9NVimK5z2NSUEycDg3TPfHwG7I6JFou7tKud3w0Gp8ZBI+byippTA?=
 =?us-ascii?Q?brY0bYugCkTQychQEgovFiv64Hq+BCsL/ybxQLmGXBLofi1rybgRF5OjU1cY?=
 =?us-ascii?Q?aiFVwa4BsyJMrngpM0THG3+twcSwZTjdtCZi1hbdu8eVVR8pBvllDAxcyTz0?=
 =?us-ascii?Q?/dKAy+XlMdmgb9bNHGMD1z7QjerzKpIeV3cA+NYIlAWXs3gHS/v8WtP9PXmd?=
 =?us-ascii?Q?bQYGd/EAkAFqapWxT2JYQw4096ll1cdqxApoXsD3nbGXtTCgdhGtGFB3t1kq?=
 =?us-ascii?Q?jwlRDmhkZzpRSOE7qKok4ymFwADPNvpk9ZDZ+ALt7SpeYb7vfrUaqYXHXC4F?=
 =?us-ascii?Q?G7eZmTbT+I8STGRP4SIijhOJlOSY6igPe3pQrXMP?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR11MB2913.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eba02ef8-36bf-4faa-672f-08dae2c277d5
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Dec 2022 19:43:28.8041
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: X56+w31odbsZL4mj+el5czEOCswvO0SueelOFKz7hz4uU2EXHmHl1d4bsXtFoUrOEkPoGjjXWBeym+QT3ff9ELb5inRuTv4pfG3gak+9aqs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6570
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

Let me check with our team.

Best regards,
Woojung

> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Tuesday, December 20, 2022 11:55 AM
> To: Enguerrand de Ribaucourt <enguerrand.de-
> ribaucourt@savoirfairelinux.com>
> Cc: Heiner Kallweit <hkallweit1@gmail.com>; netdev
> <netdev@vger.kernel.org>; Paolo Abeni <pabeni@redhat.com>; Woojung
> Huh - C21699 <Woojung.Huh@microchip.com>; davem
> <davem@davemloft.net>; UNGLinuxDriver
> <UNGLinuxDriver@microchip.com>; Russell King - ARM Linux
> <linux@armlinux.org.uk>
> Subject: Re: [PATCH v3 1/3] net: phy: add EXPORT_SYMBOL to
> phy_disable_interrupts()
>=20
> EXTERNAL EMAIL: Do not click links or open attachments unless you know th=
e
> content is safe
>=20
> On Tue, Dec 20, 2022 at 10:48:25AM -0500, Enguerrand de Ribaucourt wrote:
> > > From: "Heiner Kallweit" <hkallweit1@gmail.com>
> > > To: "Enguerrand de Ribaucourt" <enguerrand.de-
> ribaucourt@savoirfairelinux.com>
> > > Cc: "netdev" <netdev@vger.kernel.org>, "Paolo Abeni"
> <pabeni@redhat.com>, "woojung huh" <woojung.huh@microchip.com>,
> > > "davem" <davem@davemloft.net>, "UNGLinuxDriver"
> <UNGLinuxDriver@microchip.com>, "Andrew Lunn" <andrew@lunn.ch>,
> > > "Russell King - ARM Linux" <linux@armlinux.org.uk>
> > > Sent: Tuesday, December 20, 2022 4:19:40 PM
> > > Subject: Re: [PATCH v3 1/3] net: phy: add EXPORT_SYMBOL to
> phy_disable_interrupts()
> > My proposed approach would be to copy the original workaround actions
> > within link_change_notify():
> >  1. disable interrupts
> >  2. reset speed
> >  3. enable interrupts
> >
> > However, I don't have access to the LAN8835 to test if this would work.=
 I
> also
> > don't have knowledge about which other Microchip PHYs could be
> impacted. Maybe
> > there is an active Microchip developer we could communicate with to fin=
d
> out?
>=20
> Woojung Huh added this code, and he sometimes contributes here.
>=20
> Woojung, do you still have access to the hardware?
>=20
>          Andrew
