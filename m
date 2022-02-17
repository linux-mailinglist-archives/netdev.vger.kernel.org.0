Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F80A4BA0AB
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 14:09:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240637AbiBQNJZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 08:09:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238898AbiBQNJX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 08:09:23 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2102.outbound.protection.outlook.com [40.107.21.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 094AC2AB52A;
        Thu, 17 Feb 2022 05:09:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CQ3tlG1NsHjsiONmZ44ldBn1QUua9zR1BDROAde/Ai2r4bDm8SoqZ7k2nEg1nNvnWMFv4purf1GJbGstWa+qROLfBkovx5CK8Tcc+Uq6cGY4dyKu8l/L39lVspnAQSP+B60S9/qoZMPes/nf6v4PX3sfOr60qk+UHRXP3w62V2m+Ija57yK7eE2cW06E3RL/GDP7P81p/qZT+hA1pLtUgyEgCpkJKWfHTK+XbZb073eAx6Zjm+ZGoiNjdRMCF2ZOK9x75A0o5m+eJJData5QA8F2fmgpBxjGgyrgksed4C+Gl0cEHwuC6cOGJy9aIDvVFWZ6a0ejCtF7bFaVoZRUbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bfMj7rQei0jyM/qael8SBTVraC6SRbpJJ1yHDA9eBbM=;
 b=BRQa71v/qzMtWRUkZapoc1nAV1SanAzWjRhp0cSzRGVwgLHZC4heb+Y/pdfl4Oo+mA1sIOjP526LHrPiYsF21J4+FmHNddD4b9gUmAgRP/EcItDWV0ffoN7/N7vbdrTboMrXia9DFQv7OHsGcYVdVIPtoW5GABuXvdnvMAcjP1t9GisjXQ5spE6xpiYLEoVaD+B8uLWYVmJr46Dlx61WN7c9sxY+dPuN+Lw5mUUJ3qi4BE2eXeGtA10WRBDMWrSmbq/aw9WiMVLOz+fs4KMtaZn6pvKBrfSRhThHwbXh2zmfr0W1PcqTczac0q+2y4MXuR46ibW9uyuVWN5OHcVu/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bfMj7rQei0jyM/qael8SBTVraC6SRbpJJ1yHDA9eBbM=;
 b=UQKwAS4Qmabgx5c/c6CCWt/27afceLVjvmR4IfJAciXQsseJsSS1uemCGucbQPJUkcxCVVtJmgT7m+wAzY7Gw3zSN1MX5zzltIpYiqFLDOaiSqaI8eqaO9fxFREKh2mtB9PqZmBRCiTVsCgMB86QSZQDRgM74SSC0p2ullV5AP4=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by DB7PR03MB3963.eurprd03.prod.outlook.com (2603:10a6:5:38::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Thu, 17 Feb
 2022 13:09:03 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::6123:22f6:a2a7:5c1e]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::6123:22f6:a2a7:5c1e%5]) with mapi id 15.20.4995.016; Thu, 17 Feb 2022
 13:09:03 +0000
From:   =?windows-1254?Q?Alvin_=8Aipraga?= <ALSI@bang-olufsen.dk>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        =?windows-1254?Q?Alvin_=8Aipraga?= <alvin@pqrs.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Rasmussen <MIR@bang-olufsen.dk>,
        =?windows-1254?Q?Ar=FDn=E7_=DCNAL?= <arinc.unal@arinc9.com>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 0/2] net: dsa: realtek: fix PHY register read
 corruption
Thread-Topic: [PATCH net-next 0/2] net: dsa: realtek: fix PHY register read
 corruption
Thread-Index: AQHYI06+Oi3bmZ4n+EmyFAzgV7y6pg==
Date:   Thu, 17 Feb 2022 13:09:03 +0000
Message-ID: <877d9tr66o.fsf@bang-olufsen.dk>
References: <20220216160500.2341255-1-alvin@pqrs.dk>
        <CAJq09z6Mr7QFSyqWuM1jjm9Dis4Pa2A4yi=NJv1w4FM0WoyqtA@mail.gmail.com>
        <87k0dusmar.fsf@bang-olufsen.dk> <Yg1MfpK5PwiAbGfU@lunn.ch>
        <878ruasjd8.fsf@bang-olufsen.dk> <Yg47o5619InYrs9x@lunn.ch>
In-Reply-To: <Yg47o5619InYrs9x@lunn.ch> (Andrew Lunn's message of "Thu, 17 Feb
        2022 13:12:19 +0100")
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8513beb6-41c4-4b65-6e92-08d9f216abf1
x-ms-traffictypediagnostic: DB7PR03MB3963:EE_
x-microsoft-antispam-prvs: <DB7PR03MB39631EDB0ACFAFD2BD73078B83369@DB7PR03MB3963.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Qzgc1BBPDQyt85PfH4hYfrucsBC9IjlYsJ4AaPXZmBDr2oyfLYbfKy1khCKRDdSqgPWmVZx32swWlQUTLw4mTGWe62TqAM9d7MQjYyLbBc69Y/uFQOhfY3gMkf76NzSeSVlBrdXyX9laiTa1T+KQF5MwIpednT95j2oNXVQkaWxatr8YN7eFNveIE2qTt+m/AKkyMF02dE8qkTQUYkjWITGtlOmHAqou7uvIRCR+oDhqu7YEllw2p044rWvxnERfictaWccrnGQfbn59h5unXmDDAbHNFB9zI7S1H9UVWCL7W7Y6r35O9BIVwyHABzZvaF4aXVVXXKe6yEp2ojLIg4y+HCTqn/8J6I8fkDo6gEbISKB7hj5yUX7Jq7X43ElQF9I7dRvau1T8FfRANng/PzfybLIVkt/J9ZWGldF0gRIZ5gvfKpT5heT0H/EyskkIT4fIbRU56MMfYLl957zcyKHiUuVxmNwLXUKsBdkkTxNsY1sgEVI3C8dB/dYHmxSS2Qt2L6W1+rfCcTsHxto+UoS9YIK4kgLal8yDwXku6vd7mVcDF4ux6p9eaz+KLJIqp8bfI/1SC30+/927LtYrsnJQvqJe50GL75GoquM7tm4nc3mIUKQak+woJHglDQttTbYIf+0nQWeyC/qjW1nRdDl8V8UzDazuMxCpyo7E30yT2gloHR5eA5WXzIBGrOM1bJu9vmYcJ1t7tsikrkEZ8g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6916009)(64756008)(54906003)(316002)(8676002)(4326008)(38100700002)(2906002)(66446008)(71200400001)(6506007)(6512007)(76116006)(38070700005)(66556008)(66946007)(66476007)(91956017)(86362001)(508600001)(5660300002)(122000001)(36756003)(83380400001)(6486002)(8976002)(8936002)(2616005)(7416002)(186003)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?windows-1254?Q?tAQnyFFb09zoM8UGfaKNrs6dR9UTtsILZpbbFhQP0EQqgKTaCk58Qcer?=
 =?windows-1254?Q?HfQpelpbgGDFPlu05gamkcrismD/dwp0MrpGt1L6WiKJUBwa3UnXwPaH?=
 =?windows-1254?Q?t4rsdVbHUNEsAcIvrS5zFVcHgvE6Ar1trjt1e5gF2d6+oEfMewfTj8Mq?=
 =?windows-1254?Q?HnG1Tva1HDtbw4bTtDOWQISrG8dIA5oWJKeYu6C2GNutedu1Mez4ycAS?=
 =?windows-1254?Q?1LaKQHa9srkhuuCgD5T/5lPeu7Fq/koVHvC7jfkkmFcQ00cmDcS4fun+?=
 =?windows-1254?Q?46oxpqkogrFVmwtDCpx+wAvijyI/4MwDx/tKLyO6QG3GohgtMlpj0W1Z?=
 =?windows-1254?Q?kEGWBVFhzutCdlC37fnKP1zy/aBNgMihC29Jiwle69agXHBqrTuuQ9+4?=
 =?windows-1254?Q?MwKCxyIB2wwD43AXfZHzS96gjGLzYS6Csf8zvQSAvNODu2ND0Voqw0wt?=
 =?windows-1254?Q?LwHgsf+dDqLNFsgGMQDYKt1ClRzBnya79f7kraEN/T5N543i4EibK9r/?=
 =?windows-1254?Q?dqSREP2XMp3BQ5uFC8vqQbaSeVIO5DXR1JRc9hnAacZ0q2k13hDJzuOR?=
 =?windows-1254?Q?262+oEZ6/FYvUevwyO89DtghoKpXT54+yveA+QILatXlQekjEUPOKjcH?=
 =?windows-1254?Q?DKrkiC7BTGns2ri106vDR7T94s3vxTXzrFJXynmdQSMgVNe4s5aYMSRo?=
 =?windows-1254?Q?YHJNFCrHtftg6AhoRXGo+ZJKbR+JOYezLaBGFVjtG6e+hsn21w8zgFU3?=
 =?windows-1254?Q?ybiSbAC3lkMUUNsm+h2M12xQ78ZBxO7l3JGJkq+pO5RSfB3kgyZVu2yU?=
 =?windows-1254?Q?xxoldrmRj/+lz4MXlz0/eyoiXIvQqh0+3vkQWSueNX87DCAFPR70sMxX?=
 =?windows-1254?Q?6TzQVtOQTxNOKeSCMRYNtkR2q0bXiShYlwj6C256W+QEnloBNoNEzcBH?=
 =?windows-1254?Q?msKrVj6ptJ/31rkGPgP1gl/XqY8P13+apzF7Wy/0tS/kSAyk1elrZTKP?=
 =?windows-1254?Q?CgwfuGu/Q5OVDkSC4Ylh0F+v7gZgQUgC2rVH0LNp9ayryoDbhJ3eSFYX?=
 =?windows-1254?Q?4cWFORVSxin9koY6RTI4j2aWerfgLIWcywveyXPWkEKbOdvCkpp92MS7?=
 =?windows-1254?Q?hE4qvdlQN+nXHJDJc5F3SoqjksGKqgtOwsiiL+wtkM6ngsdhVFyobGe7?=
 =?windows-1254?Q?jJDE+54Zenv9h55qTE3Nc3d28z6bTrW92dY2QkSDaZwPsJ8NFtj+Ng1x?=
 =?windows-1254?Q?QxLnwF3hl9Ldi8CFKMg8OTT4u3C4dK5e0cV2bV9G+PLBriJgOdMNytP7?=
 =?windows-1254?Q?/WP7nBTODLZNM3WtSs8m8TmTzt+DH9wWqjAu/470KcrK1dQ2SErPyMX9?=
 =?windows-1254?Q?D2WPQbKERo1rLiT8OqcVx8vugYrhQw8r35viu7i6+GmnZ/yJ3HMZRscS?=
 =?windows-1254?Q?m+bKTafQKeRF5wgGB5m4XRVuTOzoEsv6UrOodp6KKKGtB3I7EVGz7ux6?=
 =?windows-1254?Q?Z865PxtDG86Cei5HxyKi1QbO+WYuJs75gAvgeCe7/Cy2Wl+Jaq6Fr9dY?=
 =?windows-1254?Q?xau9pMybTmo/LiHA/xSDg3CZEQcF1s4ObFgoVRyFw5OBIB+Vgi0rc+WC?=
 =?windows-1254?Q?cRkwrs7H6GUnKCepZITmTwdQejhV8ORTTyz9G2x04MHU18TkshB3FBw3?=
 =?windows-1254?Q?jigASNxswjhhAtpJaoiss9VfiOIslvBchL/d63rWS8UKRFIX58BzlkwE?=
 =?windows-1254?Q?GpiGHFtDfPB8GsjbBAc=3D?=
Content-Type: text/plain; charset="windows-1254"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8513beb6-41c4-4b65-6e92-08d9f216abf1
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Feb 2022 13:09:03.7252
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ydqhlYapS5h4B7Xx2blvJm7q1b1vLd5l6H8iEFIDsGH0kDCHP378aDX/KamJGtoJ1nC7sWJ2CfiB/y3KN3BWPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB3963
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew Lunn <andrew@lunn.ch> writes:

>> Thank you Andrew for the clear explanation.
>>=20
>> Somewhat unrelated to this series, but are you able to explain to me the
>> difference between:
>>=20
>> 	mutex_lock(&bus->mdio_lock);
>> and
>> 	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
>>=20
>> While looking at other driver examples I noticed the latter form quite a
>> few times too.
>
> This is to do with the debug code for checking for deadlocks,
> CONFIG_PROVE_LOCKING. When that feature is enables, each lock/unlock
> of a mutex is tracked, and a list is made of what other locks are also
> taken, and the order. The code can find deadlocks where one thread
> takes A then B, while another thread takes B and then A. It can also
> detect when a thread takes lock A and then tries to take lock A again.
>
> Rather than track each individual mutex, it uses classes of mutex. So
> bus->mdio_lock is a class of mutex. The code simply tracks that a
> bus->mdio_lock has been taken, not a specific bus->mdio_lock. That is
> generally sufficient, but not always. The mv88e6xxx switch is like
> many switches, accessed over MDIO. But the mv88e6xxx switch offers an
> MDIO bus, and there is an MDIO bus driver inside the mv88e6xxx
> driver. So you have nested MDIO calls. So this debug code seems the
> same class of mutex being taken twice, and thinks it is a
> deadlock. You can tell it that nested MDIO calls are actually O.K, it
> won't deadlock.

Thanks for the explanation, the missing piece of the puzzle was the fact
that some switch drivers expose an additional MDIO bus. I can understand
the CONFIG_PROVE_LOCKING rationale.

If you have the patience to answer a few more questions:

1. You mentioned in an earlier mail that the mdio_lock is used mostly by
PHY drivers to synchronize their access to the MDIO bus, for a single
read or write. You also mentioned that for switches which have a more
involved access pattern (for instance to access switch management
registers), a higher lock is required. In realtek-mdio this is the case:
we do a couple of reads and writes over the MDIO bus to access the
switch registers. Moreover, the mdio_lock is held for the duration of
these MDIO bus reads/writes. Do you mean to say that one should rather
take a higher-level lock and only lock/unlock the mdio_lock on a
per-read or per-write basis? Put another way, should this:

static int realtek_mdio_read(void *ctx, u32 reg, u32 *val)
{
	/* ... */
       =20
	mutex_lock(&bus->mdio_lock);

	bus->write(bus, priv->mdio_addr, ...);
	bus->write(bus, priv->mdio_addr, ...);
	bus->write(bus, priv->mdio_addr, ...);
	bus->read(bus, priv->mdio_addr, ...);

	/* ... */

	mutex_unlock(&bus->mdio_lock);

	return ret;
}

rather look like this?:

static int realtek_mdio_read(void *ctx, u32 reg, u32 *val)
{
	/* ... */
       =20
	mutex_lock(&my_realtek_driver_lock); /* synchronize concurrent realtek_mdi=
o_{read,write} */

	mdiobus_write(bus, priv->mdio_addr, ...); /* mdio_lock locked/unlocked her=
e */
	mdiobus_write(bus, priv->mdio_addr, ...); /* ditto */
	mdiobus_write(bus, priv->mdio_addr, ...); /* ditto */
	mdiobus_read(bus, priv->mdio_addr, ...);  /* ditto */

	/* ... */

	mutex_unlock(&my_realtek_driver_lock);

	return ret;
}


2. Is the nested locking only relevant for DSA switches which offer
another MDIO bus? Or should all switch drivers do this, on the basis
that, feasibly, one could connect my Realtek switch to the MDIO bus of a
mv88e6xxx switch? In that case, and assuming the latter form of
raeltek_mdio_read above, should one use the mdiobus_{read,write}_nested
functions instead?

Kind regards,
Alvin=
