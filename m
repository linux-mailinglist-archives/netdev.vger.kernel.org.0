Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 906335163E1
	for <lists+netdev@lfdr.de>; Sun,  1 May 2022 12:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344945AbiEAKzq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 May 2022 06:55:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345077AbiEAKzn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 May 2022 06:55:43 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10088.outbound.protection.outlook.com [40.107.1.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78C1C3BA49;
        Sun,  1 May 2022 03:52:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ErMrmFExFgq7KQwzBkALhEDHbBpgeVIXX1jIDgr4L89KkFOOiXwvLgbF59HIZGKYR2lzmGmky2k/f2AUxNhu9+8VvFPc+pfx2h8UOzvA52tsnDgaupTYiDeRlUAyFex8umSYx9MjkJNdq18GSKKH9+pPAzJXpGuyFfHRXoEF00ZsFxxYnfFoSbrd/xaMAHmSbKD1CHnz/dc0JSJ9LL9iegI0sGmT/4kOCxP6VzdbPMYgrMu2q7XtaiG8QoLQUDxYCb4jydX2/LK2Yk4m6aEIYoNxaMkp9eAMeoIHwM7wQKUnHmoc6+fUhJgilDucvHHlqvgsd2WkGxWiGnaup4HpAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CoLEfCYjoAILtO4Zi99NukczUUX2t5v0myQOQO/ik7M=;
 b=WdECXXpjKVIC4Pd1Zwx7KBVm1BSsTQ+MjMoftpoZ2tt9X9FZxkj43dTegI0H9CLxFcDP9tNH2MBCg03GjPqCgrWKtOkmJQjN2AKheV7EbKPmi5hozu39vRUNwLI9EF5JR9DXM6VPj1EWp2SdCFq59/ArpHhDofDfMrQnj3W7YomZ3PeseDYMB+mbkpTKI55/6JuxfMdv//AB4YLQCmOnbcpgzHa6D4R+I4+3ul30mtxgpyNxpzVxT6nQXXPH7YUP6+XbsHIKlB3RIY/yEXkmZVQw2ssjdXHSqLsifv6rETyOJ58prYLmpS52mQb8k3G8v+aJoRuW1mr6eh5HOWgJEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CoLEfCYjoAILtO4Zi99NukczUUX2t5v0myQOQO/ik7M=;
 b=b22AeJapGrHVrm/Dzg9VPb3QLvBhYXU4Yko+BbcytpdwOmyRrgdDfRqH2aBC409DF0MIsrgytNfGUEXxRmL5wHPPl3k4dKyFxFwK5JNOb+6rv6wTOykfuB4VNen4zzBZhaKY5UBrnS3HcxaE21aT/pIjg4PGXhGnoXnDle2xE+M=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB8PR04MB6523.eurprd04.prod.outlook.com (2603:10a6:10:10f::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.28; Sun, 1 May
 2022 10:52:09 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::d94f:b885:c587:5cd4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::d94f:b885:c587:5cd4%6]) with mapi id 15.20.5206.014; Sun, 1 May 2022
 10:52:09 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [PATCH v1 net 0/2] fix shared vcap_props reference
Thread-Topic: [PATCH v1 net 0/2] fix shared vcap_props reference
Thread-Index: AQHYXCEz7GhE7xCbLkaFhySWk3ydjK0J2r4A
Date:   Sun, 1 May 2022 10:52:09 +0000
Message-ID: <20220501105208.ynlxqqt6g4oml5fz@skbuf>
References: <20220429233049.3726791-1-colin.foster@in-advantage.com>
In-Reply-To: <20220429233049.3726791-1-colin.foster@in-advantage.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b87c7df4-a52e-4de2-f8f6-08da2b60a406
x-ms-traffictypediagnostic: DB8PR04MB6523:EE_
x-microsoft-antispam-prvs: <DB8PR04MB652318B88A44091266355294E0FE9@DB8PR04MB6523.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3YbgTq859gUp1BYckK7YXIYRWzLt3av1MxKSB+OSNZhGsxtbipDsjxMCczJYOH/LTUHLB7J9KFYLBpCjexa2AA8G9tSPKKGZ8uiO7CpqAp2PZ4fOehi2P21bpg5r8rmZe0jcr0ZT/vfiqWoj92aaBkYQxs29kVAgVmZ6jMr2jftneJypvOprls+z/PooePBBBBt1IkppH7j6msGO52B6BULE4wdFa0f9vkR7ZTr1V0Grddzs+xdd5GeCbb805ssxGc2Kp6l5+9y7ts9WwEAJzcd1aocZRg+9AE2SdcHcCa9lFtrhyBFHaUHJmH1c5YZR3gSUZlV+a6IdTQciuUuVOrmzKi6avYDJFGweATbK7NZLuON5bTtVgHGDYEYOV12ppQCtdZ1MdicEH8h6cF8YEd2ehBKIcrgbeMQUeWAR++dlNqC4mzDIeqlpbU+nIDd12hsuftHNQTzUPKGL6xUkyGViuOv7xgrJSNi/d4Bdi8lQKPssLv8G08T76+deEg0jw/LkYcMw7QJvM3Rg/HzfCWgDWzrwcbc5bFePSCQW9zuhGPYOqPk/bsnh64lGKSjtFwbIYsSLcpEwd7865EYWEgwTKMe7t2YIeX4IByDp8ZGId/36z2dVd9c3XzUjSOxs6j7AXfxIwgWoYBOarfW1IlVcJZuXEqDjkz1UBrW6xYbr6k9O51MUoDwYVmoAJVuWrJ2vL6QRoHOE2xOWr5lKXw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(8676002)(26005)(33716001)(2906002)(1076003)(186003)(4326008)(54906003)(71200400001)(8936002)(6506007)(7416002)(558084003)(38100700002)(38070700005)(9686003)(44832011)(6512007)(5660300002)(86362001)(6916009)(122000001)(6486002)(316002)(66556008)(66476007)(76116006)(91956017)(66946007)(66446008)(508600001)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?IHwy8xBgsqWz0YCpuiweq294dSqGQSSXbNNAFEo/QCjlZjzTqc/Nx9QpOl/c?=
 =?us-ascii?Q?YHbR1joSO4zuCJs/U89uPnNNCTeT4n38r1mdAHDIKRUPQ4ljztfE5hRntxb1?=
 =?us-ascii?Q?l5W7w7B/6Z3R2ycBvIDfTS5iQMXHZuFRVsObnWA/7h75o4plxqqkjTUGdEDd?=
 =?us-ascii?Q?79z1HKB1+wxD7qFBWVDs+XxcGuBKpB4hxUYSnlyai/3WSeyPVo4k3+G04E8r?=
 =?us-ascii?Q?K1Q6BQcmu8xsUHfVcuwZPUGEBfLH510emSNJw8NQ0S+t4HDFW2jDYD4gvyEs?=
 =?us-ascii?Q?Cbb6R0S8xgG3NVqg691Bvg+ybCD60TyIvOrXOIeg067iaGrtXxflgDodS/wP?=
 =?us-ascii?Q?6V927VjTSNrVyGmSnE28jd8YFOGrCt+/BsK2V+mcewJOPpAY4Hon6FVSYQXf?=
 =?us-ascii?Q?gzLlr50ZkooMZtYdz8brq6HE+b59kMApqo4nqEgodkDNQwZApp2udHqH1iLJ?=
 =?us-ascii?Q?dBmiUnxrpUlMNRhRi53Ity41EFDI1ZPuy7vtIfl8Qe9pephwoklNkYl/D20h?=
 =?us-ascii?Q?Jv7v7AlXApneEUvx/I6iCMAtnl2R1Pcha/5hvZPU20oMUS3P84ZF6T5gfdhd?=
 =?us-ascii?Q?6A5ZJLgfmgSX4spW+B2a/ou2t7QbXmGUc17+s6LJuTr2wr+MrlSuQe0xmMBw?=
 =?us-ascii?Q?frSflBviYat4wkSF5yLtFgMJNxTjWmbml0+L7HGkk3uUWiP3g3d+C5aDKynf?=
 =?us-ascii?Q?4CQ4jxhlW28HsT0yRxdfxMa4L8uImIO9ZObyI5hPdU9dyyV4k8oJwO6A64z0?=
 =?us-ascii?Q?31w5kxk37uokZB6EnqfWrrW/JvxxBg5720BgobfXLwTzfNMtkhjjuwx0J59k?=
 =?us-ascii?Q?5WQv3OlnwLK9Pcqldd/7L7GOCbRlco3VvSDP4Es0xQOSosUI2JGFoAdhs1hF?=
 =?us-ascii?Q?1KpvqamV0GiY2A3ED9J6K6RI5nop7eC2NkfVc6EXfVcDe5qefP1yEpQBcvji?=
 =?us-ascii?Q?JyacBn/5gxMCyrQVzIuCC/K5lo5D/TQJsGOI+mVOvimI4RZ4ShmOxkNwUu5e?=
 =?us-ascii?Q?bdo3w7vD1eKxv44eTp/SjGjlTRtpopWnFaqY+0HNeXcBIrKg/7rMB/EXocxg?=
 =?us-ascii?Q?gfbXKH/Rre9hmQtUQfMFtZR/14v01CxVNSuZQIEYH9BzFo/s2YAEjI+skZN/?=
 =?us-ascii?Q?xRDiwKsAB21Nea/cWMQdJRVfVaWS4m9BbqpxuBs6FHXd7GTF/Z7DL1H78wiQ?=
 =?us-ascii?Q?0xDNWSMYTY7gqhI7i0g7apDR5Z5GIklIrP/FxnIP+IBFbMqyy9n7MqLxpJSP?=
 =?us-ascii?Q?q4p6p1A7vQSnTuX2jSS51qVWAW9CW+Y42yPv9PSfFyOX0HHKlrqNM8FMTxrr?=
 =?us-ascii?Q?E+buskAnORcuxd80X02Y4HOkqAhv/kRJ7Po3GAaK7rSn/0Mds2QvU5TB1fl0?=
 =?us-ascii?Q?qpiwhKTZH7d0k7OIq3ZRG+2AoNiFDYDcS+FTUO9FijmtfD3gTVAzGhkOAAnh?=
 =?us-ascii?Q?oKiNw1K6G1Q17EWJCwyOJDVspCTV5u/hYpJLvJYMjhX5DBm9gxQxzLsgmnHN?=
 =?us-ascii?Q?reakUoNRkwUa6NW7+7rKB2CjtYVjyajie4ZqeBbgldgZTCEYSaFcxtaKNUvA?=
 =?us-ascii?Q?zRaVQdKbtdq7cuHCtu2MM586RzAgWYv5a2jfOnekpDRQXdx1/gd+R8QLKoUm?=
 =?us-ascii?Q?/lYuHkJKcTbSeF4++rPQuZPLKYFHBABHGhn582aW1V27UWX6XVyAHKCo+zYz?=
 =?us-ascii?Q?y+W+8Tt8tUTTQbOhqYadRPe82YQDhS7T7bZMU8C5v5l3lVdYqjzf4ShxCINE?=
 =?us-ascii?Q?ZFFO9Pl9WUKdgzx3RJjIMmNCYAEHKA4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <EF22B4CF02CF1D4DBA9414179F39852B@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b87c7df4-a52e-4de2-f8f6-08da2b60a406
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 May 2022 10:52:09.4496
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AnkZEUbTzYv9F8wJud1FOty2qeHGALKSjU2bbEOUmXZpQ5s+QiJCi+KeUOTEsEsMyYtVhk1zPj9VJbJ0xHgXPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6523
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 29, 2022 at 04:30:47PM -0700, Colin Foster wrote:
> I don't have any hardware to confidently test the vcap portions of
> Ocelot / Felix, so any testers would be appreciated.

You know about tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.=
sh,
right?=
