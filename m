Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C9CC596D52
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 13:08:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230402AbiHQLGx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 07:06:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235425AbiHQLGu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 07:06:50 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2087.outbound.protection.outlook.com [40.107.20.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A24C97FFBA
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 04:06:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d7HgKJAJQJHZn/vHjNCTwBp1NaK46HYgWSrVw1kDTDceeazR9uYzlBnZf24oQNSZU+cYKOZY3zXzPgPgnFaSnFXL2KpAyKTNh3TSjFn5NMOZNYXF8ZRxEj8r/M9YBNWpbJ0tjAkSzpf8NQNwfAPsYLtsCeWw/UYZcCoy56VAtNcy3DMHgbsfyZnyN4Z5AmrzdQq9/JisBXaneNthJGAX7Mo3ATy7b3j8XHSNDTuxLiYr4JCFiqMkscAZ48mYnjGzMiIHIpGrYwXJ5oLcdi/6pjN4RzctoaZNRMhGf945FxmEC/NNPLnIqTXvceyiUxpHHS8qi/5WF4qQPF3EhTgIzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cT/DLGn7sZeg5E0vXFDhrpTbj+N+tSZl8mPolsWNHII=;
 b=C5ndeeRmTofAsmGisoI4oQAtHWw5Pn3GXvJ3YP7hptZuXsl6jhMx7OZbWG8VkDnLO35EgLyUxevm76bxD13ov/G8jsaffCzVdhr0fg9LyH4KbHuLoRNrVX5kJXzFMBHN1E7uMAzrlgd92Iq4moylDDao8EHlFZVLXhplS1rfE/gYjJ7uhJjA0BT7LzR1cTeloqQ86h7nKhOJX9BCjgzktgISEOpEXVj8IDfOP2rs8Qmfme4ZW818Hb1ekRt0tPXY4Xh5fXbnjVTI5g33OSib5c4yHMKqCwLQDGppJ8JZC6xZdPr0a1YAOGo1w0aLnuJesHIYIDenhdyUuNYB5Yh4jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cT/DLGn7sZeg5E0vXFDhrpTbj+N+tSZl8mPolsWNHII=;
 b=Ut3JdWOLAf9Zbxlehjoq4xR2PQqMHhnSCFIIT4h6pz3p32Uj45oiR1psV7OAd3Ep+mBwXTltYMI3yVQKpQE/0gAbfnkhi5cEJHJLzNSEYwZd68BGVx0UssrSR0p/RWf00sKQVC+P4L71jA3Bvx2YXuyvrCw0ENRFnx9G1Ow8AO8=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DBBPR04MB6139.eurprd04.prod.outlook.com (2603:10a6:10:ca::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.19; Wed, 17 Aug
 2022 11:06:45 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5525.011; Wed, 17 Aug 2022
 11:06:45 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxim Kochetkov <fido_max@inbox.ru>
Subject: Re: [PATCH net 6/8] net: mscc: ocelot: make struct ocelot_stat_layout
 array indexable
Thread-Topic: [PATCH net 6/8] net: mscc: ocelot: make struct
 ocelot_stat_layout array indexable
Thread-Index: AQHYsXet4txs5KEUy0mU0hPxnOpCE62yp00AgABIogA=
Date:   Wed, 17 Aug 2022 11:06:45 +0000
Message-ID: <20220817110644.bhvzl7fslq2l6g23@skbuf>
References: <20220816135352.1431497-1-vladimir.oltean@nxp.com>
 <20220816135352.1431497-7-vladimir.oltean@nxp.com> <YvyO1kjPKPQM0Zw8@euler>
In-Reply-To: <YvyO1kjPKPQM0Zw8@euler>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e2628880-2c98-4a51-eac7-08da804092d9
x-ms-traffictypediagnostic: DBBPR04MB6139:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1SN1827w7oS2o9zLwO7WFTApTeBSx6YUswLXjHVQLX27VeMVYuuyMkAwiaqraO4lQyj00MKTUJRBxngB1wI+j+AMh53exH18TgjA0tCWG4DN1zsnEXbTbgSmRS5cgiMg+reVkUHhTEHD4TPUp5olW6LhvPs0dmo6RivwHZdwxKz6usXwPYMpROpYvH7qwt0IvLinzmwl9g6/p1N7TpDTJ9vaLGkEgR9UWmBum6xBcoXVEo73qd5xbkSQMigdrgBtL6dAHzXKcrTvAYbe5KegHg+X/hmWBpR0coYW90Feay58qnpwP52s7wX5h7yRK9k2VjlIQNIx2xtKasiPDptxd85CGD89muTPEimAJa/vifLYO/cszKtGcM74JKvjcsOcfuJc9k5ASpKlnjlb5tCJBima/TBFi5mqICY1zTvcQONMOliVBL9HorJhxATDl7VWAt+90clYqvImfAx/tVpBdk/DbrllkdttrYsBdZFNfZFmBamxQGN19X5XXkfwzsID8h67uq0I2/KQPtVwNSxsnvyxUxLfHsSnqOOQiBhvLmqIKO8+OZVMsxePkI16cbzT221T9g38x96tZHspvEfC486C2FHn6mc6DqFEeyx89eC1SBNfvzA6xqxLyGivzauOhS5Et8B0VSPjGYN+54u4w50GmX1/g9wQjj625ke704sZgWAvpVRyYDlQyBrrDc7LW7swr4ND7jcCxoELcWbK+OMVpzucNm3suaXYFrlglEZcZg4T6qnvoVs4Q4pJY+Qu+9OxD2/OxCru8jgBNWisoiyoHKt1PsAm5QYvgJ5QSRo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(346002)(376002)(396003)(136003)(39860400002)(366004)(5660300002)(478600001)(44832011)(71200400001)(7416002)(316002)(6916009)(54906003)(41300700001)(66946007)(6486002)(66556008)(2906002)(64756008)(76116006)(8936002)(66476007)(66446008)(4326008)(8676002)(1076003)(186003)(38070700005)(9686003)(6512007)(6506007)(86362001)(26005)(122000001)(83380400001)(33716001)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?NFy1BtL2OYa/PvMrmqddnKtNJtkwIbFA08oROwgFYCx9ZWhQcp0jI9dRVS9S?=
 =?us-ascii?Q?d3HcoFRZPm1D8VLFGQSZMv4z9UB73VEfFTwIbe/y3i/2lswu/DW5oEvrIKsn?=
 =?us-ascii?Q?RI7GUHzORLXYRxPKzHpI+ocGl4K826w4as06tGPLpPx4tJM5lKgm2aAtZON/?=
 =?us-ascii?Q?eJYLJquGDyEeHNBVn3mNA4DIVJW7VAjWy4rWY2yWFvAY9eYlDOsnpagoXe7b?=
 =?us-ascii?Q?v0FyRxICCFcEogeUZnMPiaIg1Hk3+/6gI5MbRP98u1ST+BB5W83IMOxR8A26?=
 =?us-ascii?Q?+SVXBdaDn5CWSrHEVA/rSV5f4i18VDKEFZFXhLIqXD6acqIJ0rnkNbnho5gn?=
 =?us-ascii?Q?6qW1SkSJ662xLjiuQ0Qi5rrbraZS0EmfEPTP9fBdFjg6Ke8QIstfzN0emtfo?=
 =?us-ascii?Q?+Sr0s98QXtsJTHDgwQPsA7kkf9fVeEJMWKRH+B5SBHtvEoHJ54/JdGIk2v1a?=
 =?us-ascii?Q?LTLkPkYALCauP0yAYo5+B0CnmnU0nZBVSXtnNEVUhrlMTN49zmmzwRpWeXiK?=
 =?us-ascii?Q?RPqZhxcjHrLvMJdXovVP+hcMU3i0dmwq5qKhZa/jr706a+0bNJjCV2oAk5JV?=
 =?us-ascii?Q?1vPeNf96NVF2KYWmO0uBgRfPE2yO565Ol0/8fMBeqY8rO898mxScmX2C4oFG?=
 =?us-ascii?Q?T0xiLtmPCM9KUc+rBWpwiqP9TnZfB9OV51SBikv33E8KngaUw7G7KsKL/8NV?=
 =?us-ascii?Q?6iaOFiB5jl+5j87odpppBb6dmQsvWpXHKBK4NMRuULcR0zXRHE2DPPbisrug?=
 =?us-ascii?Q?AZeHsm4YfV4EzzjYyFqTTgCj3GNvokCIIVpPO4udPPR4i1MlosD1Ky60G8mA?=
 =?us-ascii?Q?ER5ZShvgA5wmFxIY74SbdzLNicUMZD2wdz3DCc25s+I2mEQNWuW2wH3kcEsv?=
 =?us-ascii?Q?VHv2IQkSRrVcpm82BWuEYHoelsG5NPtXefXbAjM8l3F4JuzoRyUbd0wCV3RY?=
 =?us-ascii?Q?lPHKJ7SCUW4AkGJksc2KkgkFzw0kOdj8guiNk9ymF68UYGxAmY0T7ngEHTSy?=
 =?us-ascii?Q?3jD1oClcQOVMHD63l22x3ycCXAQ5ivdPDYtyfKcj/WnFftRwhXSRiZIfQBgw?=
 =?us-ascii?Q?9PZwf3Q4BQEr2OgRtqqiTs/QVr+tN1hZq0bYY6ILhe4kfhCuwiZrvLMaUBsC?=
 =?us-ascii?Q?Xt79KeSsClQ0iakvOKvGzteI4obuaUMVDW/rE8XGx1hzVPoSgoYiT5EIDLOh?=
 =?us-ascii?Q?8EIlCmCH4csDgesc2QQ48eP/Qxid+QTnsCGnqWC4pH95yPdxonnJIZyzk840?=
 =?us-ascii?Q?keAyV33v5iIgDaBOvm6TFrtogpNFtEiA4M2Dv1wbArHx0ZG7R4CBuAzq4a7b?=
 =?us-ascii?Q?iJL0vsn/+L/82my78d2XQycCXeKisCwZyTyz8/lf3H4GNoCOB+2zXqmu/zxj?=
 =?us-ascii?Q?R3eiwcmwP7kZpNnDVOET9zzpy1shpXaUZ4tjiL+soUvvR9UuX90LUb8Yqx7A?=
 =?us-ascii?Q?RNgX1YGbdL3q/iD/dYg99C1tFwGDrDbs+g8zJAIHWqfctUhuVs/CtembMtJV?=
 =?us-ascii?Q?6MQEJ+LnRFfvB1EG372qs783PZL3xqhb8FC1eWhsGTVJ6Zl3+VhioG29rVYV?=
 =?us-ascii?Q?aRLgYGPxWE3i31Cll+cfwEqrnAgjB/dTmT/yKHSIaEkp9ERtGhkT5nJyJoTM?=
 =?us-ascii?Q?2Q=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D28B6A7FA0A7B247BC1E2F19019B10EE@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2628880-2c98-4a51-eac7-08da804092d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Aug 2022 11:06:45.5895
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: anKk9UI+Ji7s1Jb4/hGYevVWjviyOYL3rgEAVdw+T+2MS5FBS6KnA/+VI67IQLyvQlWaqCz5XFlHaJGGT1sniA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB6139
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 16, 2022 at 11:46:46PM -0700, Colin Foster wrote:
> Hi Vladimir,
>=20
> I'm not sure if this is an issue here, and I'm not sure it will ever
> be... ocelot_stat_layout as you know relies on consecutive register
> addresses to be most efficient. This was indirectly enforced by
> *_stats_layout[] always being laid out in ascending order.
>=20
> If the order of ocelot_stat doesn't match each device's register
> offset order, there'll be unnecessary overhead. I tried to test
> this just now, but I'll have to deal with a few conflicts that I won't
> be able to get to immediately.
>=20
> Do you see this as a potential issue in the future? Or do you expect all
> hardware is simliar enough that they'll all be ordered the same?
>=20
> Or, because I'm the lucky one running on a slow SPI bus, this will be my
> problem to monitor and fix if need be :)

No, you're right and the bulk reads complicate things; in fact I'm not
sure that this patch even works by anything other than pure chance.

In some future changes I'm making the first N elements of the
struct ocelot_stat_layout array be common across all drivers. Only Felix
VSC9959 has some extra TSN-related counters which the others don't have.
It would look like this:

/* 32-bit counter checked for wraparound by ocelot_port_update_stats()
 * and copied to ocelot->stats.
 */
#define OCELOT_STAT(kind) \
	[OCELOT_STAT_ ## kind] =3D { .reg =3D SYS_COUNT_ ## kind }
/* Same as above, except also exported to ethtool -S. Standard counters sho=
uld
 * only be exposed to more specific interfaces rather than by their string =
name.
 */
#define OCELOT_STAT_ETHTOOL(kind, ethtool_name) \
	[OCELOT_STAT_ ## kind] =3D { .reg =3D SYS_COUNT_ ## kind, .name =3D ethtoo=
l_name }

#define OCELOT_COMMON_STATS \
	OCELOT_STAT_ETHTOOL(RX_OCTETS, "rx_octets"), \
	OCELOT_STAT_ETHTOOL(RX_UNICAST, "rx_unicast"), \
	OCELOT_STAT_ETHTOOL(RX_MULTICAST, "rx_multicast"), \
	OCELOT_STAT_ETHTOOL(RX_BROADCAST, "rx_broadcast"), \
	OCELOT_STAT_ETHTOOL(RX_SHORTS, "rx_shorts"), \
	OCELOT_STAT_ETHTOOL(RX_FRAGMENTS, "rx_fragments"), \
	OCELOT_STAT_ETHTOOL(RX_JABBERS, "rx_jabbers"), \
	OCELOT_STAT_ETHTOOL(RX_CRC_ALIGN_ERRS, "rx_crc_align_errs"), \
	OCELOT_STAT_ETHTOOL(RX_SYM_ERRS, "rx_sym_errs"), \
	OCELOT_STAT_ETHTOOL(RX_64, "rx_frames_below_65_octets"), \
	OCELOT_STAT_ETHTOOL(RX_65_127, "rx_frames_65_to_127_octets"), \
	OCELOT_STAT_ETHTOOL(RX_128_255, "rx_frames_128_to_255_octets"), \
	OCELOT_STAT_ETHTOOL(RX_256_511, "rx_frames_256_to_511_octets"), \
	OCELOT_STAT_ETHTOOL(RX_512_1023, "rx_frames_512_to_1023_octets"), \
	OCELOT_STAT_ETHTOOL(RX_1024_1526, "rx_frames_1024_to_1526_octets"), \
	OCELOT_STAT_ETHTOOL(RX_1527_MAX, "rx_frames_over_1526_octets"), \
	OCELOT_STAT_ETHTOOL(RX_PAUSE, "rx_pause"), \
	OCELOT_STAT_ETHTOOL(RX_CONTROL, "rx_control"), \
	OCELOT_STAT_ETHTOOL(RX_LONGS, "rx_longs"), \
	OCELOT_STAT_ETHTOOL(RX_CLASSIFIED_DROPS, "rx_classified_drops"), \
	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_0, "rx_red_prio_0"), \
	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_1, "rx_red_prio_1"), \
	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_2, "rx_red_prio_2"), \
	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_3, "rx_red_prio_3"), \
	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_4, "rx_red_prio_4"), \
	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_5, "rx_red_prio_5"), \
	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_6, "rx_red_prio_6"), \
	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_7, "rx_red_prio_7"), \
	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_0, "rx_yellow_prio_0"), \
	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_1, "rx_yellow_prio_1"), \
	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_2, "rx_yellow_prio_2"), \
	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_3, "rx_yellow_prio_3"), \
	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_4, "rx_yellow_prio_4"), \
	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_5, "rx_yellow_prio_5"), \
	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_6, "rx_yellow_prio_6"), \
	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_7, "rx_yellow_prio_7"), \
	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_0, "rx_green_prio_0"), \
	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_1, "rx_green_prio_1"), \
	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_2, "rx_green_prio_2"), \
	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_3, "rx_green_prio_3"), \
	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_4, "rx_green_prio_4"), \
	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_5, "rx_green_prio_5"), \
	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_6, "rx_green_prio_6"), \
	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_7, "rx_green_prio_7"), \
	OCELOT_STAT_ETHTOOL(TX_OCTETS, "tx_octets"), \
	OCELOT_STAT_ETHTOOL(TX_UNICAST, "tx_unicast"), \
	OCELOT_STAT_ETHTOOL(TX_MULTICAST, "tx_multicast"), \
	OCELOT_STAT_ETHTOOL(TX_BROADCAST, "tx_broadcast"), \
	OCELOT_STAT_ETHTOOL(TX_COLLISION, "tx_collision"), \
	OCELOT_STAT_ETHTOOL(TX_DROPS, "tx_drops"), \
	OCELOT_STAT_ETHTOOL(TX_PAUSE, "tx_pause"), \
	OCELOT_STAT_ETHTOOL(TX_64, "tx_frames_below_65_octets"), \
	OCELOT_STAT_ETHTOOL(TX_65_127, "tx_frames_65_to_127_octets"), \
	OCELOT_STAT_ETHTOOL(TX_128_255, "tx_frames_128_255_octets"), \
	OCELOT_STAT_ETHTOOL(TX_256_511, "tx_frames_256_511_octets"), \
	OCELOT_STAT_ETHTOOL(TX_512_1023, "tx_frames_512_1023_octets"), \
	OCELOT_STAT_ETHTOOL(TX_1024_1526, "tx_frames_1024_1526_octets"), \
	OCELOT_STAT_ETHTOOL(TX_1527_MAX, "tx_frames_over_1526_octets"), \
	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_0, "tx_yellow_prio_0"), \
	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_1, "tx_yellow_prio_1"), \
	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_2, "tx_yellow_prio_2"), \
	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_3, "tx_yellow_prio_3"), \
	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_4, "tx_yellow_prio_4"), \
	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_5, "tx_yellow_prio_5"), \
	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_6, "tx_yellow_prio_6"), \
	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_7, "tx_yellow_prio_7"), \
	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_0, "tx_green_prio_0"), \
	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_1, "tx_green_prio_1"), \
	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_2, "tx_green_prio_2"), \
	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_3, "tx_green_prio_3"), \
	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_4, "tx_green_prio_4"), \
	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_5, "tx_green_prio_5"), \
	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_6, "tx_green_prio_6"), \
	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_7, "tx_green_prio_7"), \
	OCELOT_STAT_ETHTOOL(TX_AGED, "tx_aged"), \
	OCELOT_STAT_ETHTOOL(DROP_LOCAL, "drop_local"), \
	OCELOT_STAT_ETHTOOL(DROP_TAIL, "drop_tail"), \
	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_0, "drop_yellow_prio_0"), \
	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_1, "drop_yellow_prio_1"), \
	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_2, "drop_yellow_prio_2"), \
	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_3, "drop_yellow_prio_3"), \
	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_4, "drop_yellow_prio_4"), \
	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_5, "drop_yellow_prio_5"), \
	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_6, "drop_yellow_prio_6"), \
	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_7, "drop_yellow_prio_7"), \
	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_0, "drop_green_prio_0"), \
	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_1, "drop_green_prio_1"), \
	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_2, "drop_green_prio_2"), \
	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_3, "drop_green_prio_3"), \
	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_4, "drop_green_prio_4"), \
	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_5, "drop_green_prio_5"), \
	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_6, "drop_green_prio_6"), \
	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_7, "drop_green_prio_7")

static const struct ocelot_stat_layout ocelot_stats_layout[OCELOT_NUM_STATS=
] =3D {
	OCELOT_COMMON_STATS,
};

static const struct ocelot_stat_layout vsc9953_stats_layout[OCELOT_NUM_STAT=
S] =3D {
	OCELOT_COMMON_STATS,
};

static const struct ocelot_stat_layout vsc9959_stats_layout[OCELOT_NUM_STAT=
S] =3D {
	OCELOT_COMMON_STATS,
	OCELOT_STAT(RX_ASSEMBLY_ERRS),
	OCELOT_STAT(RX_SMD_ERRS),
	OCELOT_STAT(RX_ASSEMBLY_OK),
	OCELOT_STAT(RX_MERGE_FRAGMENTS),
	OCELOT_STAT(TX_MERGE_FRAGMENTS),
	OCELOT_STAT(RX_PMAC_OCTETS),
	OCELOT_STAT(RX_PMAC_UNICAST),
	OCELOT_STAT(RX_PMAC_MULTICAST),
	OCELOT_STAT(RX_PMAC_BROADCAST),
	OCELOT_STAT(RX_PMAC_SHORTS),
	OCELOT_STAT(RX_PMAC_FRAGMENTS),
	OCELOT_STAT(RX_PMAC_JABBERS),
	OCELOT_STAT(RX_PMAC_CRC_ALIGN_ERRS),
	OCELOT_STAT(RX_PMAC_SYM_ERRS),
	OCELOT_STAT(RX_PMAC_64),
	OCELOT_STAT(RX_PMAC_65_127),
	OCELOT_STAT(RX_PMAC_128_255),
	OCELOT_STAT(RX_PMAC_256_511),
	OCELOT_STAT(RX_PMAC_512_1023),
	OCELOT_STAT(RX_PMAC_1024_1526),
	OCELOT_STAT(RX_PMAC_1527_MAX),
	OCELOT_STAT(RX_PMAC_PAUSE),
	OCELOT_STAT(RX_PMAC_CONTROL),
	OCELOT_STAT(RX_PMAC_LONGS),
	OCELOT_STAT(TX_PMAC_OCTETS),
	OCELOT_STAT(TX_PMAC_UNICAST),
	OCELOT_STAT(TX_PMAC_MULTICAST),
	OCELOT_STAT(TX_PMAC_BROADCAST),
	OCELOT_STAT(TX_PMAC_PAUSE),
	OCELOT_STAT(TX_PMAC_64),
	OCELOT_STAT(TX_PMAC_65_127),
	OCELOT_STAT(TX_PMAC_128_255),
	OCELOT_STAT(TX_PMAC_256_511),
	OCELOT_STAT(TX_PMAC_512_1023),
	OCELOT_STAT(TX_PMAC_1024_1526),
	OCELOT_STAT(TX_PMAC_1527_MAX),
};

I would like to keep the flexibility of defining the counters in this
way without too much regard for:
- the order in which they are listed in enum ocelot_stat
- the order in which they are listed in the struct ocelot_stat_layout array
- the value of the SYS_COUNT_* of their underlying register address

However I'd still like to have a way in which I can index ocelot->stats
when I know specifically what I am looking for.

I think in practice this means that ocelot_prepare_stats_regions() would
need to be modified to first sort the ocelot_stat_layout array by "reg"
value (to keep bulking efficient), and then, I think I'd have to keep to
introduce another array of u32 *ocelot->stat_indices (to keep specific
indexing possible). Then I'd have to go through one extra layer of
indirection; RX_OCTETS would be available at

ocelot->stats[port * OCELOT_NUM_STATS + ocelot->stat_indices[OCELOT_STAT_RX=
_OCTETS]].

(I can wrap this behind a helper, of course)

This is a bit complicated, but I'm not aware of something simpler that
would do what you want and what I want. What are your thoughts?=
