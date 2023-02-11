Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBD37693419
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 22:52:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbjBKVwj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Feb 2023 16:52:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjBKVwi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Feb 2023 16:52:38 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2061.outbound.protection.outlook.com [40.107.21.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8885476B6;
        Sat, 11 Feb 2023 13:52:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ev6E+xzTjoxX0fAOB8p3mMZDlvTXzsMzZFesrFIm453KVZlYL0nDs49StikmlKvlkpsQAdEv9TeS2UOaaZlxMBhOLS+GKRAafQ64hgSaTKSljLIbwNCbdwLP+bwVVTzwQH/4jgRu84Gv4w8SK5xrhgZwceUnO/MVbTlTXP+TOfuI8M3tcx8aJJYUdFY881d5zFcJrIFKaH29HmiEovF6UnmPAoxga2jG3/taqnw+QHVF2Kk2iWw5kdwD70QTNPQ4t8E3rJlQ7kOAsKDpCDM5d44fwVedaOsSDVHKyexWEDCnJ04k7v1naVQHM10kWT3g2Zje7NCsXT3383bepw+9Tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=axhT8NP1qdodm7u3Pdxrxhv7uf3m6ui7K34J1Sc95Ac=;
 b=WDbLXqEvLjzTbywbjGJCSgLhDhz3zSIYWV8fo6nwNgZk7B9V2KS14lk+GlNH85g9uWmKNMdSH0DLmHffxcT2Rv8AMT+O0c+MJ5hUP+PfesBj8YzPoDFZEN0ascEHgRhl8DfHkuWDTyBvMp2UgrhpwjJbrwZFeQwxFoLyeQxiJsel75mbQJoJF8ohEo68ZY07KE8ClKkpNRKHeaqNt+isoYA0cZi93iVINsu9pYabayrv1V0zwlrNq9nabh8BavJCKMQi+KiNKAvvBSH0anx64crs2sqMBua2NBL/eq6YnSONQSDoUaZWJ9MYFwZIlDrth9hf3hJZLKD4dauTlp0klA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=axhT8NP1qdodm7u3Pdxrxhv7uf3m6ui7K34J1Sc95Ac=;
 b=YhgXFlQIiTkSlhQTwEMR30hPY91yhIwwoQ4N+CVzVBMqi0ZGz216McJGkID03ELKjQblAXBc0fd1ajLj/Syk7OZ52mM6c827MKjcjGXHOrLKdcu0gdJTAdapdnnJPp5WKrcuJZVRdXxYd3LmW3b1qc6haSAcXzA1uMd5nBnMbjA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PA4PR04MB7743.eurprd04.prod.outlook.com (2603:10a6:102:b8::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.22; Sat, 11 Feb
 2023 21:52:33 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.6086.022; Sat, 11 Feb 2023
 21:52:33 +0000
Date:   Sat, 11 Feb 2023 23:52:29 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: [PATCH net-next] net: pcs: tse: port to pcs-lynx
Message-ID: <20230211215229.ra43h35rbuibpj2p@skbuf>
References: <20230210190949.1115836-1-maxime.chevallier@bootlin.com>
 <20230210190949.1115836-1-maxime.chevallier@bootlin.com>
 <20230210193159.qmbtvwtx6kqagvxy@skbuf>
 <Y+ai3zHMUCDcxqxP@lunn.ch>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+ai3zHMUCDcxqxP@lunn.ch>
X-ClientProxiedBy: BE0P281CA0030.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:14::17) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PA4PR04MB7743:EE_
X-MS-Office365-Filtering-Correlation-Id: 52f57704-0dc9-4f0f-68f3-08db0c7a47b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mRDPsR3okO1dwzXx2NvGBVc4JF+TuvqlL3XIvqiy/wrCSEMrLRaaxI0eeiuGf4VIoSu+B15Jz+2HX1yQG3OLgR3+1eFnAyHdscKELEusKd8V2BCfH0bjYRPX8ATDKQDVC3D91UnZF05IMJWeMcUZx6RaOlKnpKdocqf7Tqzh5ar5tfh0KXdQcjZ7q5lt8Iw2WYWSYMucwtgHejByE6qn7dV+EDFEu3Y1W1sywRDZbDsimaDW1vLDTvt1OOIIWL8ZW7U77WqPkOlHowIyTC4aKGTHlVgzVudLZp5TqVKDsh7tLknV0c6MTNMTv9W+r0975nmGPMsWH7i9ZDWEZPbLzFpeN9zPJcSsWVLsfBeXQMyxx397kUoAYNx8iXPVgioFZfQueMwq+xdD0+dNr2dnxxCX/M3VG+2EQSNtJmxQDeBJF6b0lZiGPUWhvV51qJt0hoUdA53vFG0dsq9OeDSzElPFvPpO+1i4zAxbDmVevwgeoXwFQnUX5wMV5X860Ydg5/1xlr5pdxzDwBPze/RaNMX06ApuUGI4FhmYaCc9Gf2Dg+SNQb9G4PcXDL0AriGcoFAB7OdcDaxkYTdqZyREo03p5CmVmIwrA0sIjMEeEXY+2d6yLo8nV+IGFn0w84cSQT6/RleA8VDjIn7xBmqYTw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(4636009)(136003)(39860400002)(366004)(396003)(376002)(346002)(451199018)(41300700001)(316002)(66946007)(54906003)(66556008)(33716001)(8676002)(6916009)(4326008)(8936002)(5660300002)(7416002)(86362001)(38100700002)(6506007)(1076003)(9686003)(186003)(26005)(6666004)(6512007)(66476007)(44832011)(4744005)(2906002)(478600001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Mkoe3Mx2gZiClQdKJ5xfZ4aRFOkgs03SzjnpolAjmfs8XTRTW/STAL1NvY1b?=
 =?us-ascii?Q?k1sVvftmirJT/UQ8pe3Zq/OkMnkzuAIMMgjAtS9StZvkEr17ziOzEhy8PjCh?=
 =?us-ascii?Q?tk+FnN2q1qBHuwx/LZpaIzlx74I17aX1+ImzOs7e48OCdhfqoJt/HcWU2AUV?=
 =?us-ascii?Q?Eui8zw7vwT+KKbnPBpRpXb4p3QBF1cuHk6HBSriP99OUHpGzSY9sSwvFYjvf?=
 =?us-ascii?Q?dJ7PyMf+VotXtNPS5IRjNEU/aCv/YrHPv4VvQONjbmfFMe4556OCZIMoVpLX?=
 =?us-ascii?Q?qUY8clBYgmrLI0jTyO7N5dJwRSns/kLzk5+Iq2Dq0Q3GUuPJCPCyXlx97XEq?=
 =?us-ascii?Q?A4mkowlxwKRezrzRZWflpSpZKIiltGgH+GFjXdTrRS1GdbdP9d72aKD7KT1M?=
 =?us-ascii?Q?ZQVcWG0JCvkJB78TB0xMAlCfa2KPR15xBsR5fiIOkL5BB+pniCW4u4Fn4fkA?=
 =?us-ascii?Q?HgXo9tL/nDtA+DzJJSP5YQX/kVejxVAwl2ZBCHpnoNdHjj4c+1Uq2hfSHkKp?=
 =?us-ascii?Q?SFrechvrM16NiQHgXrq5wkTaeDiwRlVlRUaSgbMoI8dC2Bm1HyXx9yPUw5la?=
 =?us-ascii?Q?dm36BO3FjSObkEzjYXmRJdghNhOmpR54weoOzw364X+O1pzvcmFBNP/BIu3+?=
 =?us-ascii?Q?Sp6yjUym6mXJTwnBs+D46pyaAD7DLEqxvxCbAK5GGMnNM2Aqp6tkNtc1KlSo?=
 =?us-ascii?Q?aDy6RLoccyMvQzzIWQnbbaC4nB32eMV8/2MSBDuXyPyQTizVgvvNTrFPgLZP?=
 =?us-ascii?Q?jAMTUOWCAodMKKtOtfN+/7AmbM9MaNabnxj55HGdhF/YWlUX2QGSTIsm5+c+?=
 =?us-ascii?Q?YqKmpdZ+xfyH4S90OFMXtvC00x8tyScU65edjwubDnzDKn3k7F/KFXX5NoaN?=
 =?us-ascii?Q?th+6EDQifC7gPLosqQ8XBktd50MokAtAeV+5ZS4QYTZxoVfox3gDeDYlI+hJ?=
 =?us-ascii?Q?RDTQ2p2d6CyIVnbLM8gBFyyiIGrU/1V+ZNUdxk1AJSXfBEywfJx2A5gXUSHZ?=
 =?us-ascii?Q?NcMk1W71Ee0IVchBBpw2VBm2iLbGZVjsM0WlxXKAH3pl8Udou2yLZ6l/N2Wk?=
 =?us-ascii?Q?qi7agi+3VXizVHm5Tz7+PCiyeIjDac9tZkXwQaMXlU2HGsvbWizXMTrKPCre?=
 =?us-ascii?Q?14ZScRHwRp61eOVijxwHhSMLHbBKt3Km9iX2Ipbu7uDSrCe4GF2ECUsFZO7d?=
 =?us-ascii?Q?3DILgR2Rumd7TlYMGuVHLu4l5rLGmXCH4/vrNd1e1rc84ul6VI5EUyRfksP8?=
 =?us-ascii?Q?az5mFKguOw55B4EpWe9jYgVqdSuScFDVP3jOoSwvIqDg8Dja4DPb+jeO7Vf7?=
 =?us-ascii?Q?5T89TB27VloZzxYLF1q6bymNz4lNaRQKN09M1+8w7n81X1kQn3EzkcMzVKZU?=
 =?us-ascii?Q?wyfqeNbqKmGVLlZiHkj/lh/AuC/Nd83tCL5znQR6P/eoGIPoB5/j8Zz1+I38?=
 =?us-ascii?Q?fZExqJ3b2gbxITubURbvGjzUazTlhTVY5yqTJTVmpl3bTX9uEzM5Ql0MgwOw?=
 =?us-ascii?Q?+8ntTwV1jXGaaBsGOyVhyfDMZJqYdaareM8Pt7iBeGbEc+Mn3yie7GPlKCC0?=
 =?us-ascii?Q?BPKzANEnkXA4nTxoXGET49q9b971ASrkWtLBIkRgzdEpLU0h05oxTu+997U/?=
 =?us-ascii?Q?gA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52f57704-0dc9-4f0f-68f3-08db0c7a47b6
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2023 21:52:33.3768
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QbPrOi2uSH73uh9TlyN/grmjZaKULPrRGXg2ThS0nnumgNhtglENFa4i1VneJkeuSsVdVm11aneJ7VUExT8geQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7743
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 10, 2023 at 09:02:39PM +0100, Andrew Lunn wrote:
> I was wondering if the glue could actually be made generic. The kernel
> has a number of reasonably generic MMIO device drivers, which are just
> given an address range and assume a logical mapping.
> 
> Could this be made into a generic MDIO MMIO bus driver, which just
> gets configured with a base address, and maybe a stride between
> registers?

This sounds interesting to me because I also have at least one other
potential use for it. The "nxp,sja1110-base-tx-mdio" driver does basically
just that, except it's SPI instead of MMIO. So if the generic driver was a
platform device driver and it was aware of dev_get_regmap(), it could
get reused.

What I'm not sure of is the spacing between MDIO registers. For the
SJA1110 CBTX PHY, the registers are 32-bit wide (but contain 16-bit
values). So MII_BMCR is at offset 0x0, MII_BMSR at 0x4 etc. I'd imagine
that other MDIO buses might have MII_BMSR at 0x2.
