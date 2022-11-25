Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 709A1638319
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 05:14:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbiKYEOx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 23:14:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbiKYEOw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 23:14:52 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2082.outbound.protection.outlook.com [40.107.101.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B9F61A3A6;
        Thu, 24 Nov 2022 20:14:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dsiO1TCfD6iOv7vmpbeh8e89W01Yv49fNnCwMYihWLB0VLwXVWA/IRuKGwQfQRBssDgo9E9oUXX7zFc3yCoJ0NViCYRwWtxW4RnjpYhKipQfjQOvGzjwyPXrtle22R6uB1aWeOlW9F81ZpPu9skteoeydNT8zcILv+rin7+gxFdP+35ByoF4o/JH1wBvimW5ASOQ3osFkNzJ5TKrYBmASZQyPLiDQ7eeY2UK5CX58TO7NT1axYUvWjwQNd/rs6DF3k2DxYqFnBoKtgYMHMVtExGDsY8ZGnyWSGuJYkpSQ5ERf6eVWPuWYkQL/rGzRpLYk0o4WlbuaMpJO3nPoLK4HQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O4C4ugKSKUBcCzqSA+piLdZ8GepCk7IoRfsV9HNnjJk=;
 b=fAlVVDZpqd7zG8zL0vFXpmhXoomUSh+HTYd8CcGnk4yc6nQjp3QY7GIzRZoJ68NwQUGvrJleFs5wKLDBTQQcEcfdq56J2AdRB/qwGuCZeJlnCrQd974SFxujqs7fStSCDtSP2TU7uBsfiz36y3MzGSwwcnFmk7PL/Yqsz0nrpIn5ljDXUlrdCAAw1aHHgFGl+2Ah+2gxnf3AV8TqyMitkJHs3yUugRoBfPXCDOGD1nGmWH9kLZ2XC97SfKAREyhoGI3Gm6RfaeoBD2DYkn65XL0++lfoqSLzWw1TJ51N1THCO4tWM1jUmJPM17Pl+C1f0+FC+5uf4I/LHztIdpVo0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O4C4ugKSKUBcCzqSA+piLdZ8GepCk7IoRfsV9HNnjJk=;
 b=baeQTcUnSf+3eS4XUIsNnqIQ06AjjcUEXH1He2G0LkXI2G00i5RR7O2HVFmlkzNujjNV06dPpgJaUaRCcqG4gjMkLvQSYXnZolcZM2cEnwyZbv+Q741Iy8JTzfaOghEJfrn9xgYuYpvEzfa5mT560vShqZiOeh1XE/KEtgbenGOQ+rnYApmH2pVrS6UAnOl/EqUIHa8BDrbN3KKE4t4eQ469miz6eWIwaZkOW8UgOEv6q0FbwQI2Sp/zfJyr2G5UKwyO6zgefgjOZ7RgVW9SsFlZNybm02KTJDWO3IBKUT4bmKXUkBgznWeVw9sR+33Yle1O+R1lZUczNeYyAf76pg==
Received: from LV2PR12MB5727.namprd12.prod.outlook.com (2603:10b6:408:17d::7)
 by MW4PR12MB6780.namprd12.prod.outlook.com (2603:10b6:303:20e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Fri, 25 Nov
 2022 04:14:48 +0000
Received: from LV2PR12MB5727.namprd12.prod.outlook.com
 ([fe80::649e:8cf:b4f9:f97e]) by LV2PR12MB5727.namprd12.prod.outlook.com
 ([fe80::649e:8cf:b4f9:f97e%6]) with mapi id 15.20.5857.020; Fri, 25 Nov 2022
 04:14:48 +0000
From:   Bhadram Varka <vbhadram@nvidia.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     Florian Fainelli <f.fainelli@gmail.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Revanth Kumar Uppala <ruppala@nvidia.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next v4 RESEND] stmmac: tegra: Add MGBE support
Thread-Topic: [PATCH net-next v4 RESEND] stmmac: tegra: Add MGBE support
Thread-Index: AQHYz0KK0TEm2qmBmU241dJjBKAgHa3zjSuAgBbAn3CAOq+oAIAF482ggABsSQCABBuAUA==
Date:   Fri, 25 Nov 2022 04:14:48 +0000
Message-ID: <LV2PR12MB572726C995F61E42182D03F7AF0E9@LV2PR12MB5727.namprd12.prod.outlook.com>
References: <20220923114922.864552-1-thierry.reding@gmail.com>
 <1b50703c-9de0-3331-0517-2691b7005489@gmail.com>
 <LV2PR12MB5727354F4A1EDE7B08FBC5A5AF229@LV2PR12MB5727.namprd12.prod.outlook.com>
 <20221118130216.hxes7yucdl6hn2kl@skbuf>
 <LV2PR12MB57272349F55FC1E971DA64EEAF0D9@LV2PR12MB5727.namprd12.prod.outlook.com>
 <20221122132628.y2mprca4o6hnvtq4@skbuf>
In-Reply-To: <20221122132628.y2mprca4o6hnvtq4@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV2PR12MB5727:EE_|MW4PR12MB6780:EE_
x-ms-office365-filtering-correlation-id: 52a13649-eedc-4aaf-8a69-08dace9b97d0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TagoktRQyKdPvfDBn6vUg7hbAl4SOvX+4jA/AHadSegEOgdknKGwHYDKD3ri+MEdEledwzaHTIJlikFoK29cCfO2ThuK0rEFo1cfbQL205M6GhGHLLqAuiprzy1iMbUYbgoEdLOYISm2QhTEBGwl1YYDZ3IFUg9DkrN4iWznUKgqPfYxwl3joloEWKzpUKQrhHR5yItU958XrcyreAU9NLsnM58YaTHVnMmgtQTavdjBQX9JC0qjEsmCZf0V8QVMoklECAhB9IkvxZJ+lnKa1hivZD5ttQEUH48YlotTzO5Kh8kSe1HS5IMg58LAnXuZyw21Fz5NOB1yQZxESz4JZr0RZ9U+v/S/mcZnVHL9Wj5c9bhic4DMzwQstcZ1kJbzprMiZ6Js7U1b77dGY+i3ZWCx7E1j1CnrUOJU4wmLKgv5Lq7g7xZvd9IvEa4JIzQEmk9tWDQy60bQcajBlYHqflG3Bcnlt/lDi13ow4CvVacNe4pNKgmMt4UOW/UfakrRsbythgewsY73lxVC5XUEKi4C+fr7c5986m0hAbmYbSDq+rxCvfQ5QEdxrrwUVXGiZJIx+gRu2SeIYkPLwU88t3/euRXX/qHnMkp7IDdU0a14s6g6DMRwfhIRzh5U6zfqQ7TPK1dk80Bc4K0EbfuWXaZ7iS/xmLkRZC8Nawi3m83bBVadw6eGym23vEcc4NGbP7yKuNETpcfll1UxX+SPZVGDtdsGKvOFNIrjdXtB0uqSTeWWNsALewwiAJUQduxVA6KKquoxcoD4BWmZM+oaUVdnHRybrTJ9wXHTQz3wULg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5727.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(396003)(376002)(136003)(346002)(451199015)(33656002)(316002)(55016003)(186003)(86362001)(83380400001)(41300700001)(8936002)(38100700002)(7416002)(52536014)(2906002)(66946007)(38070700005)(64756008)(76116006)(66556008)(122000001)(8676002)(66476007)(4326008)(54906003)(5660300002)(66446008)(6916009)(478600001)(6506007)(7696005)(71200400001)(53546011)(9686003)(966005)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?9U87hrg8PzuxA9iO0fiv9neptel+DW9Ee7bpi+eoZR/DM9RpOki6hUNgsJDU?=
 =?us-ascii?Q?bbitte8nckCH4MDUl7zFBoqVdLsFpReMa5j315h8wK30bhvFdOKg0CLx33HN?=
 =?us-ascii?Q?YMpZ5xfqmxrZT3yyK/uJCVN+0Bf546xgC1FteHvPZGUOX/9BwBCtgE6uYnQB?=
 =?us-ascii?Q?yueXPvnFN4shcGymcrjYp/dMwJOuc/JcGgPBTXqs4YLw/FUh1rba+LnNTfPL?=
 =?us-ascii?Q?Abx+Tt317ULjcgOfXATpY2MPlEPaWWdpAnvEHEJPrNMjDR9Qiqq938AkxseC?=
 =?us-ascii?Q?5fvu/c3qA0rFQc9JxnZPSPOifi9xNSzBc+fLVXi2axEdk3g7NvxmwAcRtFZ1?=
 =?us-ascii?Q?cDYmLdoH/yAivAZceqtt+3t0t6u3uv6G6nq8RMwY+mDr1EVvRUZ3Vnm3BiCu?=
 =?us-ascii?Q?trEBVuj+0lmjaS6jg3O6hYnzqAX6UjxgTv0BVRSzFJ5tHj733DsN1m1HZQcY?=
 =?us-ascii?Q?ATM5iG6HEG2YQJKnLcszcMNb9+KvPfWO2LGyuLD/n4jmRiDPvKxTrFlvn4OA?=
 =?us-ascii?Q?pcdGt8tGOhPVeo6VpbJH748a3GPo3ayeV+klIPhOZOpE3yYoqmZupsTfN4gW?=
 =?us-ascii?Q?oQ2MK0t2zYTi4DGzRWjPRjwCDpoEps7+VNUqi45EWqiMc50L9XDtLuHQe22J?=
 =?us-ascii?Q?Z62x8sPdBhmuORQgk8ccvwtwcizG0JUoV2ilUPQiguWmDl0XcvUPVZqVwZfR?=
 =?us-ascii?Q?Wsn+4mHwelfkgPnKZxKWg1ba/i/0DHwVKp5fP3iLOVsBzaFLQAwqDY3Sanqr?=
 =?us-ascii?Q?HaRryOPLaQTrGHqKxC5QHLVbecdX3FfXEBtPgzOnDjL0r6B5ueIzbzAJpJoa?=
 =?us-ascii?Q?sGn1YRWU/QsOo8ZgKiXOIeQnQPix19LiqZK69XBxrP03Aa5I0CtVxMGrixl0?=
 =?us-ascii?Q?bN2cznHw6i4aoHxbt/aLNLB9nBf35OrRiss2Ysv8qokqTmEiXQPGPE2NIfOu?=
 =?us-ascii?Q?GYeTsIWILwMXYpYSiwALoZCF/tYdP0MATgjBjqlaJF1EhGpN8zm4MuLnS+cN?=
 =?us-ascii?Q?yAzMPHMTWPElxCsaZDBzWZdEepEBCD3O5CHIsX0qb8NDLZKhVZakz4AtVdOq?=
 =?us-ascii?Q?fiReipIRhZ/FdzcAeVu16XPzbXmggHqAfiGlin2Jyn6nD05Jc/hhRdNtJrlM?=
 =?us-ascii?Q?xUDdycsXTP+qwExHiXQLJ5VuK2/TSxVqBlluBBvF3mBTbnAYJ4E0rKlwhxfL?=
 =?us-ascii?Q?7SWQE7vx9MWLrh6wWv8ZSQn+c0bzqrXY2Toneld/+lgZZCKpa4BoFWSFMQ5P?=
 =?us-ascii?Q?uwweTVq/2erpmbBPtwc5VOR0FXJOQdU1IV2cJAS27E8sp8BmOTC+TX3QEMi8?=
 =?us-ascii?Q?iMFtqNZiq5rWQ+pkURhSYhQ+ksCU1Nj+hoQdU3sN0JEIk/tdv5NnZ/lXxwZf?=
 =?us-ascii?Q?DO/RfjlXA40bwIBZBOIfCRpvHfTvC7roX6YIuOG8dRj5rKq/wGOo82FKrGSn?=
 =?us-ascii?Q?AGF29GiC1zHekupntJFmoNf+ovv17w0S8M70V6MOTWXe/CR+/ObyFULl8DiJ?=
 =?us-ascii?Q?/9t4p2nwGgQNeSPWZqafW2p9goSYPfz6sm0DZ746RuM+PX++mRGIYwlyQvVf?=
 =?us-ascii?Q?91A9T5mQiZ0Kc7Dt+v0ooXqvuNDodArM5D4FNMVP?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5727.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52a13649-eedc-4aaf-8a69-08dace9b97d0
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2022 04:14:48.8156
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PJVPdwHYE0sRDkYHWyVpn1JeDJjbm8wPbT0cGUjau3VxD3ddl6QtBxHoOBIHeg8kZMswL4mStQR2FfIs9qzTfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6780
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

> -----Original Message-----
> From: Vladimir Oltean <olteanv@gmail.com>
> Sent: 22 November 2022 06:56 PM
> To: Bhadram Varka <vbhadram@nvidia.com>
> Cc: Florian Fainelli <f.fainelli@gmail.com>; Thierry Reding
> <thierry.reding@gmail.com>; David S . Miller <davem@davemloft.net>; Eric
> Dumazet <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>; Paolo
> Abeni <pabeni@redhat.com>; Russell King <linux@armlinux.org.uk>; Andrew
> Lunn <andrew@lunn.ch>; Revanth Kumar Uppala <ruppala@nvidia.com>;
> Jonathan Hunter <jonathanh@nvidia.com>; linux-tegra@vger.kernel.org;
> netdev@vger.kernel.org
> Subject: Re: [PATCH net-next v4 RESEND] stmmac: tegra: Add MGBE support
>=20
> External email: Use caution opening links or attachments
>=20
>=20
> On Tue, Nov 22, 2022 at 07:05:22AM +0000, Bhadram Varka wrote:
> > Reset values of XPCS IP take care of configuring the IP in 10G mode.
> > No need for extra register programming is required from the driver
> > side. The only status that the driver expects from XPCS IP is RLU to
> > be up which will be done by serdes_up in recent posted changes. Please
> > let me know if any other queries on recent changes [0]
> >
> > Thank You!
> >
> > [0]:
> > https://patchwork.ozlabs.org/project/linux-tegra/patch/20221118075744.
> > 49442-2-ruppala@nvidia.com/
>=20
> What about link status reporting, if the XPCS is connected to an SFP cage=
?
>=20
> What I'm trying to get at is that maybe it would be useful to consider th=
e pcs-
> xpcs.c phylink pcs driver, even if your XPCS IP is memory mapped, that is=
 not a
> problem. Using mdiobus_register(), you can create your own "MDIO"
> controller with custom bus read() and write() operations which translate =
C45
> accesses as seen by the xpcs driver into proper MMIO accesses at the righ=
t
> address.
>=20
Except UPHY lane bring up through XPCS IP wrapper, nothing extra done from =
driver.
I think serdes_up/down function pointers gave the feasibility to do the sam=
e.

> If I understand the hardware model right, the XPCS MDIO bus could be
> exported by a common, top-level SERDES driver. In addition to the XPCS MD=
IO
> bus, it would also model the lanes as generic PHY devices, on which you c=
ould
> call phy_set_mode_ext(serdes, PHY_MODE_ETHERNET, phy_mode), and
> phy_power_on()/phy_power_off().

There is no MDIO bus in XPCS IP.

> Can your SERDES lanes also operate in PCIe mode? If yes, how is the selec=
tion
> between PCIe and Ethernet/XPCS done?
No. It only operates in XFI.

Please let me know if there are any comments.

Thanks!
