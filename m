Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02F2862833F
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 15:53:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236721AbiKNOxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 09:53:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236713AbiKNOxE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 09:53:04 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70087.outbound.protection.outlook.com [40.107.7.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C809F2CC81;
        Mon, 14 Nov 2022 06:53:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eynnxxMTxy5OeTN4ypHexWyyJsatT70FyaM07ugFf5Ugm1WF9Ei3/9wE4zBdvKBIbnMHJpPSZLRUbQrCCE31sbaUAI1uyAD4/rKyfZXv+Nt9EFO+7+VwXsyx+wo6vnn+fx8UONO/2ftGgW7r84+QOSHm8J7LgOXmTCMyYXZp6yzOfzQv5VkF2rpDnICVDQpwgQNZtWaVxC0W+7Ejdqt1gYfaqvStsSd/iBZAh9vD/A9fvDU/I1jo7l0qEGrkMQjjYqf3pRYJu4yUeHovXnxQqfGswXhUcgzKTPlr+5AotViRJCR1yVxLsl4KVr/tHwoz/DuaLWDmp3l+mtcM7cCDyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l/dcdHJVyZsOzngtQVqshEOIXkRoKra+MvA56R53YKI=;
 b=V1mj1iQs9zR5P97e0hRKLS7/sk64CuC+1NenwraW6ZKH6PLKOVS5cz3DO5/GMqLsdFr/4IMcjofsyB1FBoRlQqapWOAHuqAJvzFpWAkGNeNZLf+fpe9td6HN9RXTQdMD+/rM8Q/igDu7fP82TqTNnr+e2EAC7hFXpYlMjRIrm26PVS2HxUWucT3/O2G8UAGMcg5ry+6bVAviyFphZDu1Qq+05slH788/ToIb12YO55PbrqrdormqHrvcY5/8Yv0mNAAEJ9Avtu3LQaJZ/67PlmpRxJC/TeVKN1NTqBqKkoq0aNU1JoFazR323K5oXh5XcUFclLVpp3I4pKvzedMJFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l/dcdHJVyZsOzngtQVqshEOIXkRoKra+MvA56R53YKI=;
 b=MMb3TJvneRh+/f33gDJDsdXmX8T/34FIJeVxPz8xWII1Ey9DAPZJrJXpXxeWSQunckaEvngVDFAb0yj8kjTSSUuyKp2VcIQDHWbHmOK1UEnfrIE2Inrddz7iLGTsasUyKejleF+Fp15MhoD/AV7ACVz/rfXHlW9OdSOxJShhW6Q=
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by AM9PR04MB8289.eurprd04.prod.outlook.com (2603:10a6:20b:3e8::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.16; Mon, 14 Nov
 2022 14:53:00 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::6b44:4677:ad1d:b33a]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::6b44:4677:ad1d:b33a%6]) with mapi id 15.20.5813.017; Mon, 14 Nov 2022
 14:53:00 +0000
From:   Shenwei Wang <shenwei.wang@nxp.com>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Wei Fang <wei.fang@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "imx@lists.linux.dev" <imx@lists.linux.dev>,
        kernel test robot <lkp@intel.com>
Subject: RE: [EXT] Re: [PATCH v3 1/1] net: fec: add xdp and page pool
 statistics
Thread-Topic: [EXT] Re: [PATCH v3 1/1] net: fec: add xdp and page pool
 statistics
Thread-Index: AQHY9eM2DcCGX+tMv0uN92sufUZdVq4+cwAAgAAQvXA=
Date:   Mon, 14 Nov 2022 14:53:00 +0000
Message-ID: <PAXPR04MB918591AA3C3A41AE794DB41489059@PAXPR04MB9185.eurprd04.prod.outlook.com>
References: <20221111153505.434398-1-shenwei.wang@nxp.com>
 <20221114134542.697174-1-alexandr.lobakin@intel.com>
In-Reply-To: <20221114134542.697174-1-alexandr.lobakin@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PAXPR04MB9185:EE_|AM9PR04MB8289:EE_
x-ms-office365-filtering-correlation-id: cac951c2-133b-4864-59cc-08dac64fecb2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /Q60AwqFIEfIpaVWq8meF1OQC/EIvS26PxW/M8g6dkLUQUuj/OaZYNVq5XUJ1WGzxlIHGaIz9s1NHHxZYORJRvoXewB6F5fY79+QxO14k3XWVEafDnF+jwf9eUL5CHs/OnTwA3i1Jwsptw21+nYKev7bB6DdPQArdVBDlAJWmv70BzpWFsg4k2V4A8AoUUn4B3jR/FaFoMkTBdTIt7/w/Ugqlyym03MeWCBUGX6wtE0TIAxp3ZcjfGmWdJn/8Z8qBuNhfWmmP4n1lLZb65so0NVLTHlXcxcF57BbOvrq+P63l66LPI5XIAa50hDQYs83ockpcPihU6WZ5+7bkRex8HMPOe4aSddZjp+30ATZlGTLmXzLeCDbUqnzNFspjOmzYfVHE0l/zLYHunzDp8+p0LwUEIZ17a8gsi72tGogx+SZdWAUWkemUSAaDj12MyoExQojK948McGltKLP7vXqy0RmHGpM4hz0TSOnvo1uYTdN7yuqvhdanyiicY4VlSAzBW+d+mJnLLJT7XiwOSujzIr55jV8BuWMD0UvVg4Mw8aMr6ST1QHPao4kJ4O82nvZSJ90gb3pM4ixrx6J5Q2qHZNiawjSnYIYc0wOlKhaEf9WJTFpU8FO+jUqMGLjnV5ZbIDs2unEJJ6JuR9CqHeKdcBaIb61QxO+0YO13uoRpMRLj7ffQ1jhgyp4/uqruXjl0mTCIj2I8TPC+m8R+ucSKLid+jBI/SvQmwyhlnmM+8mKkIanDLPtQPkfSJ5VyEc7+D4n7OJh8or6e6tff044/g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(136003)(346002)(376002)(396003)(451199015)(64756008)(8676002)(38100700002)(66946007)(41300700001)(4326008)(83380400001)(66446008)(66476007)(66556008)(966005)(6916009)(186003)(316002)(76116006)(45080400002)(54906003)(52536014)(5660300002)(33656002)(8936002)(7416002)(44832011)(2906002)(122000001)(86362001)(38070700005)(55016003)(26005)(7696005)(55236004)(53546011)(9686003)(6506007)(71200400001)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?+psbWoD0rDZTBMbjgeCMtxmR8nNibE8qoD6vy0zzyC8pxEkt3swKp9wY08IE?=
 =?us-ascii?Q?7pxqKShN4yqL4CFKPveo24gOGbRW4lQylJs9PE0BI97uSri7y1D3Spk/zMcZ?=
 =?us-ascii?Q?PHA7VbnvUo0who+jvq+uRJ8Q4es5f4Mg+X7+DRMw23ot31W/l4zuT7+ddGOb?=
 =?us-ascii?Q?j19IUujkMGo9LHI0FHz4d0T4d9PHZsaDZ7kNcW4eQQfC3fydzNtbp4F74W1a?=
 =?us-ascii?Q?tYfhFoqVhYNpLBJcmd54/OgSZDsiwqjMcKrKOFFIUxKpjaNTs6dFLKQX2+XZ?=
 =?us-ascii?Q?8ZnmfoClPZlvAVcrSk6B+iEP4UOXeuf6aO1RrTZZdIk1yzk3LcHK4bf43AU+?=
 =?us-ascii?Q?pWliM42NpcP1jLPydsti/w0PEmom5ZjpxGzHVfdMS/RiahPetYNbrgKrlg6A?=
 =?us-ascii?Q?nLFLIVPwdjX8P6whNx0mWDvMWCp2GkGI6ADBdszG+pf1dyRhoVUVJ17Ci9Bg?=
 =?us-ascii?Q?9ONN8IVXpQIFbqSljzXuRaMAJvw+GpYuSd57NW5jUG6krE/Wby5okAP7pstL?=
 =?us-ascii?Q?2DSa2nPLM1iw6lYwBBQExAeISO8/BKmTsf2GEmV5BunQGEEmH/WvwfuaR3bj?=
 =?us-ascii?Q?0Iwq60YE0YcQBXcDdrnWc5vTCuEmP7Hd3qmMDj5cKtE2LXvT8IZBo8pTXJ8T?=
 =?us-ascii?Q?1YhJJR1WRdfJILcR//8q6vtowsStXH4wbxo9oB5zPyuvsIbafrfIU+eL5Tnm?=
 =?us-ascii?Q?PrPeYLzLpFMk4lAvGH7AowE2YBEz41xa7kh78YDJnDhUr1pikF6BeePrCaF3?=
 =?us-ascii?Q?AOoi5zQXKClECqOk/P8pw7Wu7UwPwioT1B6y9wmpSk9TCeTf+1lucGsbN5J9?=
 =?us-ascii?Q?wdY7mGq0N2Vu60Krirg5V1l4PRyxCYlMAHCfkEB84GKQTFZXeEkBghUCTKUU?=
 =?us-ascii?Q?BH/2fcSNQFGU0kDn/Jn0ZCoJOlPsMtiVoYQQAmiPU+EsXFhKQYniAYhlNwPU?=
 =?us-ascii?Q?J4lgLGK0t6zhLVEaPFWslriYOR/YPTCyHruE30k+EjT6CQqXd+k77WzbrShf?=
 =?us-ascii?Q?qKzJ1dIV2DqyLGPVxDX9u/5ZiY0XKQt5TEYMqnHDr748Gxpmcn23K2xWKB6a?=
 =?us-ascii?Q?/+VEMApzi2yw5iZQXIZvYitO3bLrN+JZeiLt6HQg2PISVuhjV09HW73N5pMQ?=
 =?us-ascii?Q?GgCnyUzz7OpU7bqyUuThmhYGuWD1rOSGiTcJRMAgM9Z904MWvsgJVQGak+Ak?=
 =?us-ascii?Q?wvr0qcHxyLTFIFm2oIPe2ezaNObpCsHPYVnjEEBda5xSRY7FXqAfB2Km5Tf/?=
 =?us-ascii?Q?pfbUh8nyEWCdfWzVjm3tu0wx60zYv5tn7dtUWALnUiy88YRSSM6LGRMFKpSh?=
 =?us-ascii?Q?1wZLie1gMGlMxl6uX9eXQo5VFfy8MCpIe3ZUN8TtneDVJLr9UwY+OTJDzGNY?=
 =?us-ascii?Q?ddU3o96IRSnTnoLah1aRg8alNmJc+853L3Zlxdbt89wnpb9GdQzlH8igsmGu?=
 =?us-ascii?Q?9odHFhh0yrsd5jzgG3QSe9Ez0JhR13yUhhBAAVOhrM9SJ4QW4Gms7Tv+1BbQ?=
 =?us-ascii?Q?WUXct3om1OHZZGLTjJD5i5dUsx/4IuInH9icbH2VUSmv7KiK3pVe53Zwh8Du?=
 =?us-ascii?Q?pAWtnmEME972f8BUudZEw/ibI9AoGZjgAdCTHPD9?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cac951c2-133b-4864-59cc-08dac64fecb2
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Nov 2022 14:53:00.2017
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h5zdD0sq1Mi9BLOKjDlJj4WX249ed9yu0SFZSFbZ7H6nZfA+licWFM2OID3vaHISP9zOOrpIR2/PooZYblwgQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8289
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Alexander Lobakin <alexandr.lobakin@intel.com>
> Sent: Monday, November 14, 2022 7:46 AM
> To: Shenwei Wang <shenwei.wang@nxp.com>
> Cc: Alexander Lobakin <alexandr.lobakin@intel.com>; David S. Miller
> <davem@davemloft.net>; Eric Dumazet <edumazet@google.com>; Jakub
> Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>; Alexei
> Starovoitov <ast@kernel.org>; Daniel Borkmann <daniel@iogearbox.net>;
> > @@ -29,6 +29,7 @@ config FEC
> >       select CRC32
> >       select PHYLIB
> >       select PAGE_POOL
> > +     select PAGE_POOL_STATS
>=20
> Drivers should never select PAGE_POOL_STATS. This Kconfig option was made=
 to
> allow user to choose whether he wants stats or better performance on slow=
er
> systems. It's pure user choice, if something doesn't build or link, it mu=
st be
> guarded with IS_ENABLED(CONFIG_PAGE_POOL_STATS).

As the PAGE_POOL_STATS is becoming the infrastructure codes for many driver=
s, it is
redundant for every driver to implement the stub function in case it is not=
 selected. These
stub functions should be provided by PAGE_POOL_STATS itself if the option i=
s not selected.

>=20
> >       imply NET_SELFTESTS
> >       help
> >         Say Y here if you want to use the built-in 10/100 Fast
> > ethernet diff --git a/drivers/net/ethernet/freescale/fec.h
> > b/drivers/net/ethernet/freescale/fec.h
> > index 61e847b18343..5ba1e0d71c68 100644
> > --- a/drivers/net/ethernet/freescale/fec.h
> > +++ b/drivers/net/ethernet/freescale/fec.h
> > @@ -526,6 +526,19 @@ struct fec_enet_priv_txrx_info {
> >       struct  sk_buff *skb;
> >  };
> >
> > +enum {
> > +     RX_XDP_REDIRECT =3D 0,
> > +     RX_XDP_PASS,
> > +     RX_XDP_DROP,
> > +     RX_XDP_TX,
> > +     RX_XDP_TX_ERRORS,
> > +     TX_XDP_XMIT,
> > +     TX_XDP_XMIT_ERRORS,
> > +
> > +     /* The following must be the last one */
> > +     XDP_STATS_TOTAL,
> > +};
> > +
> >  struct fec_enet_priv_tx_q {
> >       struct bufdesc_prop bd;
> >       unsigned char *tx_bounce[TX_RING_SIZE]; @@ -546,6 +559,7 @@
> > struct fec_enet_priv_rx_q {
> >       /* page_pool */
> >       struct page_pool *page_pool;
> >       struct xdp_rxq_info xdp_rxq;
> > +     u32 stats[XDP_STATS_TOTAL];
>=20
> Still not convinced it is okay to deliberately provoke overflows here, ma=
ybe we
> need some more reviewers to help us agree on what is better?
>=20
> >
> >       /* rx queue number, in the range 0-7 */
> >       u8 id;
>=20
> [...]
>=20
> >       case ETH_SS_STATS:
> > -             for (i =3D 0; i < ARRAY_SIZE(fec_stats); i++)
> > -                     memcpy(data + i * ETH_GSTRING_LEN,
> > -                             fec_stats[i].name, ETH_GSTRING_LEN);
> > +             for (i =3D 0; i < ARRAY_SIZE(fec_stats); i++) {
> > +                     memcpy(data, fec_stats[i].name, ETH_GSTRING_LEN);
> > +                     data +=3D ETH_GSTRING_LEN;
> > +             }
> > +             for (i =3D 0; i < ARRAY_SIZE(fec_xdp_stat_strs); i++) {
> > +                     strncpy(data, fec_xdp_stat_strs[i],
> > + ETH_GSTRING_LEN);
>=20
> strncpy() is deprecated in favor of strscpy(), there were tons of commits=
 which
> replace the former with the latter across the whole tree.
>=20

Got it.=20

Thanks.
Shenwei

> > +                     data +=3D ETH_GSTRING_LEN;
> > +             }
> > +             page_pool_ethtool_stats_get_strings(data);
> > +
> >               break;
> >       case ETH_SS_TEST:
> >               net_selftest_get_strings(data);
>=20
> [...]
>=20
> > +     for (i =3D fep->num_rx_queues - 1; i >=3D 0; i--) {
> > +             rxq =3D fep->rx_queue[i];
> > +             for (j =3D 0; j < XDP_STATS_TOTAL; j++)
> > +                     rxq->stats[j] =3D 0;
>=20
> (not critical) Just memset(&rxq->stats)?
>=20
> > +     }
> > +
> >       /* Don't disable MIB statistics counters */
> >       writel(0, fep->hwp + FEC_MIB_CTRLSTAT);  } @@ -3084,6 +3156,9 @@
> > static void fec_enet_free_buffers(struct net_device *ndev)
> >               for (i =3D 0; i < rxq->bd.ring_size; i++)
> >                       page_pool_release_page(rxq->page_pool,
> > rxq->rx_skb_info[i].page);
> >
> > +             for (i =3D 0; i < XDP_STATS_TOTAL; i++)
> > +                     rxq->stats[i] =3D 0;
> > +
> >               if (xdp_rxq_info_is_reg(&rxq->xdp_rxq))
> >                       xdp_rxq_info_unreg(&rxq->xdp_rxq);
> >               page_pool_destroy(rxq->page_pool);
> > --
> > 2.34.1
>=20
> Could you please send a follow-up maybe, fixing at least that
> PAGE_POOL_STATS select and strncpy()?
>=20
> [0]
> https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fgit.k=
ernel
> .org%2Fpub%2Fscm%2Flinux%2Fkernel%2Fgit%2Fnetdev%2Fnet-
> next.git%2Fcommit%2F%3Fh%3Dmain%26id%3D6970ef27ff7fd1ce3455b2c6960
> 81503d0c0f8ac&amp;data=3D05%7C01%7Cshenwei.wang%40nxp.com%7C0f6bfc
> 73c869426e59fc08dac64692d2%7C686ea1d3bc2b4c6fa92cd99c5c301635%7C0
> %7C0%7C638040303661645473%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4
> wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C
> %7C%7C&amp;sdata=3D8NbrJmoDnsbyb8WXU85OIq6BOYCOrXLBm1mjbTi%2Fam
> Q%3D&amp;reserved=3D0
>=20
> Thanks,
> Olek
