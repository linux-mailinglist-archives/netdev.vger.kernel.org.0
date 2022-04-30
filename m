Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F35F515E9D
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 17:16:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379571AbiD3PTL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Apr 2022 11:19:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382882AbiD3PS4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Apr 2022 11:18:56 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2070.outbound.protection.outlook.com [40.107.20.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E6BE54FBE;
        Sat, 30 Apr 2022 08:15:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dl91/oJecwlJVuPVyD+wSny3f+3QCRaA9KDFqmCVAwuj2kKrQCYohg2YqGJ6cfeeKQyxRnfsUweg1L7HJX822Vz8kZe4UvQpn0tC0UcE9HQEDpHGmisuMvQc3ivOKd5OHidT+8DpqztasVAYyHDTS9CddqV0KLn7E71hRjd0nXaGMyLOpive/H2JrKip3pzk3YLUxUremGzV4os/7lsBndGdDWdbBLLfi3+7J0WKlfNrU7INBdsrZ/4pRkBl2EiWT6y9QpfVrUVSw60wcp70nf5dmkj2Sq4O6I0uraq6D5ORHWANJUDdrKFPAJ0RCwBZyZyp1bjnKlwF1AWZXS4ZLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sa47JZbeGZPr12bOdoW/2qVg8s+MEu7ipjqn0gYdV7I=;
 b=ZcFGQR98ctKe1pHP/bgP81CrcSJTV0PXxeogMm6mEL2So8hHDYj9ZnXVfNZ9KBAEDm2A7KqGwlsNbaoDZxkv9avdPITO01+ozyjR3SXnl0MX3lOF5HgzLLzKP1QOPZXaQwQMAPHdLHYDJ0+bObzhhy46fBzB2Z6tQSsYLrT53h838CQGDHxn2mOIMsYa1QoJFRlcx8rBT1prropUs8yugyrmmw4lr+dnJW2cmqZV6nI+meYrErK/bR71SdedyRgSt1pfigKdrK+IbLAxqPJ6v+FHoUkpjg9/xOkw8T36OBYkBHsnFHXqI9j463aig1Ie+ydTnA/RrNIQHxpVBV+2Rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sa47JZbeGZPr12bOdoW/2qVg8s+MEu7ipjqn0gYdV7I=;
 b=MMU5Hsc8eNmJJHQOZ9dMWmGc76KBH6BLs8cB5t/E1KkBP+eGMHqGwYP4/xMq5pJbXY8Qvu0NYHG1e0YnG36u7konioniUdsD2tWH4LfkTF/jlQg5oySBzElhm/dW86ao/DMDoGSzyeKJ+ybjPlelwCvox0tw9AKgn6TABVjWs1s=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB8PR04MB6668.eurprd04.prod.outlook.com (2603:10a6:10:10b::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Sat, 30 Apr
 2022 15:15:31 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::d94f:b885:c587:5cd4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::d94f:b885:c587:5cd4%6]) with mapi id 15.20.5206.014; Sat, 30 Apr 2022
 15:15:31 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        aolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [PATCH v1 net-next 1/1] net: ethernet: ocelot: remove the need
 for num_stats initializer
Thread-Topic: [PATCH v1 net-next 1/1] net: ethernet: ocelot: remove the need
 for num_stats initializer
Thread-Index: AQHYXBBpaZvHdMSucUK2oh2cKAMiLK0IkiEA
Date:   Sat, 30 Apr 2022 15:15:31 +0000
Message-ID: <20220430151530.zaf7hyagln5jqjyi@skbuf>
References: <20220429213036.3482333-1-colin.foster@in-advantage.com>
 <20220429213036.3482333-2-colin.foster@in-advantage.com>
In-Reply-To: <20220429213036.3482333-2-colin.foster@in-advantage.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 20544e23-8022-4edf-1c40-08da2abc4444
x-ms-traffictypediagnostic: DB8PR04MB6668:EE_
x-microsoft-antispam-prvs: <DB8PR04MB66685377D31503685615FA88E0FF9@DB8PR04MB6668.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HgFmz6X74pFGNeWkTapUVerykRxXOVlkFhba+9mIRoH2eDbBoYwW47LxMiG33SdLIbUiogXRWALAz3OgIP2SRs/6WF/1956g5XFVjMvHMJDzM/SWkuV6ebyO7Lri4MjQDTv9ZkfzvaNIxeDo7dRph4i3v2TrGPM3sD/bHCXtKIx+cEfdCDOkYRBS39NNzLKV1PnfbA4EZBqrOLgGL0XFRc6BrJZR0fp9yNpd6lhewongEui/tnuBvXgDyC9bJ35oNIbCJ6KM+WRPFy7N02VLALCqPfNQNfGr7OWBUr0WD9I0mwl3GAtiCV7wCYzBzne7haJUvG6nWpkqbf7hbtQ1DdsABexdyYVtMaqanMy4pym7ZH9U1+le+q2cenkc2Lkt7I69IOhCSja0EN7XokOszxGoJWw85HBwAORyYfchA1H2Hh2QWcV5AR7lrVCI9hKu+pCuYV+rd8TDCCfONIAGDcT7bKaYqvS63AuWwaHjdbuhaQErCrsfB1WeblSVFu5VyxNuhvl7pRMxA3MEHpcBWqFieEMtPQYuZAllLCHN5qYeuvUGbjFCv/Sin4793mxk938+DASL+5DA+IvdqaovVNophp8DlxDLFoQTb/kchXrjI9VOWRuJNMDaHHPO4HQUHAk939MQa0QI9wuYWxMjISSEPoZyDjo7vr1M4Tqdp1WVR7QrueUbujLoQ66BunDdkEGXZtLsfNxuTXVVvGGiVA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(83380400001)(186003)(6486002)(122000001)(66446008)(1076003)(5660300002)(8936002)(4326008)(8676002)(64756008)(44832011)(7416002)(2906002)(38070700005)(38100700002)(33716001)(9686003)(6506007)(66476007)(54906003)(6512007)(71200400001)(66946007)(66556008)(26005)(76116006)(508600001)(86362001)(6916009)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?RLqc/lbkqlyU34aQqh4Pu7B9ujpQdAGoQ01jhIFXZr3NKZEsc3+wQgEM7L74?=
 =?us-ascii?Q?kSCRO6rg2H1i1xL7pyWbXRE1RaeyVWXQKE8gOb+oUxvZ3msuqqvt/j1RIxcv?=
 =?us-ascii?Q?gTgqPQLpqiUJ5GGruRufIBAoqi9lsIsMVOvcMUotZnQPjyChiXTneDlYptwW?=
 =?us-ascii?Q?u/z0ywWn/VFsiDAdOmEMQI6ufcAgWhVkXcJ7zgfI1ge3y3Q+24zSuP7wqrhY?=
 =?us-ascii?Q?52z5cTr5eP6jnJk6LedgZRJL5AoiyRbRL3gPBwql89Z/umT7/LdSQaQQk2Kr?=
 =?us-ascii?Q?mkChFODjN+SUJJAJeZzC5WfnLjYugLBEbhow7mDrcSr6q7/atqD+Fv5oTQmn?=
 =?us-ascii?Q?xAJpSRZN7xl/ykigv9fJTylaYP43+Lz5azXTzf8UfD+zK3QsYPj5nudW1nuR?=
 =?us-ascii?Q?HAMFg3KcPwoEIe/9zmeI8ULXr5h2DdxEOtr3vSYqdGEnChocHGlXznHnrARK?=
 =?us-ascii?Q?8eDv1QHtqVsBgPr+I2SJBwP0iTX+yM3ZFN+YyVO9HMfwdaj7yQRkOwM4Oeaz?=
 =?us-ascii?Q?1MN9YpiCqy5l4AZ0cdLduaPdYSOU/ee8V6lydWrA9dmn94ssAsXTu4DeoxwN?=
 =?us-ascii?Q?SS3+WZqb7yNKs9Ryoscbu/aIaVXuUubTA5oBkUWG7appDs6p8D7tDfJgYeon?=
 =?us-ascii?Q?KXI4knR44LO35P4xGQ+XeDONdhOCXtZor1vOnCuECfaVtqeRgMK3Qpr/pr1a?=
 =?us-ascii?Q?y+r56UEI+PWksD2RT/Due1UwiPUawh66/70zPd7d6Hhv5M72VpnJjRt6j/W9?=
 =?us-ascii?Q?6UxUsDqSfLX0Afo1cC3Tp1BY7of8Kn2sT0xyLyC3xibzzhVKCzWmhQswuQBs?=
 =?us-ascii?Q?T7jPbMInL4S7i/td7KQ8ZuIitmtIZkElSBZqMFFqt12Q3yEb7MiJZ3QvVPCJ?=
 =?us-ascii?Q?4vabBT1cvBDWaRsWYC6/ATcULAz/BUvScpRGOZlW7G+edUdUkDxU+xM7sKiT?=
 =?us-ascii?Q?GsW5sl1171CPqiOaWgJQVF/V0ZbGw83L8bwq7MZK+fY2GHm0Dvl88DH3bIIa?=
 =?us-ascii?Q?62BV3w8osWBqPr4HVCJPQ/OBB8+AMmKKNgOGwu925KbmC195qFy2N9Ln9Ee6?=
 =?us-ascii?Q?dnZMvwCe7tTzesieJd1EGYWNcfkJu0crMpBngBLq8060XCzDJdhFBUBl5axR?=
 =?us-ascii?Q?EOux5nwaOBdSxUTEBXs2sZQ/cGwZBjYrUS6N7I4XfdFUuF/p9w+tBtVRKFAz?=
 =?us-ascii?Q?M9aXQ3LDhPavp79C7wtSBGjgJCZPvfpOXMk7x2YxeNS5kryCK19bMXfgL17S?=
 =?us-ascii?Q?1MWs8X9YVLq5q8K5Ab2eYBg9O/aITE9s+tXvTlXvQsTtWAhRE8Wo6XDEnI06?=
 =?us-ascii?Q?vTcBKPUn04Z0YW8GjzRRqZ7DD85fX1eOq/ZniTBXrgoXlqBlWN8OCdvA8VpL?=
 =?us-ascii?Q?MRZHd+kQZOlpZyqwyqMlbopTbbA6EhwirDBf/lSOjh1D0X/OtFHQu/+akfXb?=
 =?us-ascii?Q?l8GtDD0Boao16Gwh+TirhbPNQJyAHgbt5ampnALgLYnvwTkRwBuULF2GLcOd?=
 =?us-ascii?Q?MUaKshJdbBQGC5rx7Efx/zaIWVzcczEwTzgrItOXi17RomGcMRQcAprOEuyN?=
 =?us-ascii?Q?zxkBf1k7J1FfnrWNH1jYiU7nmaATlpEkwKKsgKaYyVRtI4s4DukmxAfy3aho?=
 =?us-ascii?Q?I48mA5FLfo8ikCmr1ii4WCq5y2M19xSRzSTfLXS5OZUYPNcTcAYzH5ywE6yq?=
 =?us-ascii?Q?7Y0YlfJBdFz4GhCqNk7CBsXX4JfPWCYsIoZY/inbQfFbMTJ505B3ZyMVWs/T?=
 =?us-ascii?Q?Hi2KjuN7On4SIHPL2R5y+MaFAYFJuQQ=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D4BF96CEFA07E64891116A0478A8B05C@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20544e23-8022-4edf-1c40-08da2abc4444
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2022 15:15:31.3410
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NjBaE+rSFqT12XJh8GWW2vk6v+L9wCenOOoSq0ueSuvTPVdBCAzT8JTMMMC9/DpuNzq3DzZ747Kx2s3i6d8x2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6668
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 29, 2022 at 02:30:36PM -0700, Colin Foster wrote:
> There is a desire to share the oclot_stats_layout struct outside of the
> current vsc7514 driver. In order to do so, the length of the array needs =
to
> be known at compile time, and defined in the struct ocelot and struct
> felix_info.
>=20
> Since the array is defined in a .c file and would be declared in the head=
er
> file via:
> extern struct ocelot_stat_layout[];
> the size of the array will not be known at compile time to outside module=
s.
>=20
> To fix this, remove the need for defining the number of stats at compile
> time and allow this number to be determined at initialization.
>=20
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---
> diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
> index 9b4e6c78d0f4..5c4f57cfa785 100644
> --- a/include/soc/mscc/ocelot.h
> +++ b/include/soc/mscc/ocelot.h
> @@ -105,6 +105,13 @@
>  #define REG_RESERVED_ADDR		0xffffffff
>  #define REG_RESERVED(reg)		REG(reg, REG_RESERVED_ADDR)
> =20
> +#define OCELOT_STAT_FLAG_END		BIT(0)
> +
> +#define for_each_stat(ocelot, stat)				\
> +	for ((stat) =3D ocelot->stats_layout;			\
> +	     !((stat)->flags & OCELOT_STAT_FLAG_END);		\
> +	     (stat)++)
> +
>  enum ocelot_target {
>  	ANA =3D 1,
>  	QS,
> @@ -535,9 +542,12 @@ enum ocelot_ptp_pins {
> =20
>  struct ocelot_stat_layout {
>  	u32 offset;
> +	u32 flags;

Was it really necessary to add an extra u32 to struct ocelot_stat_layout?
Couldn't you check for the end of stats by looking at stat->name[0] and
comparing against the null terminator, for an empty string?

>  	char name[ETH_GSTRING_LEN];
>  };
> =20
> +#define OCELOT_STAT_END { .flags =3D OCELOT_STAT_FLAG_END }
> +
>  struct ocelot_stats_region {
>  	struct list_head node;
>  	u32 offset;
> --=20
> 2.25.1
>=
