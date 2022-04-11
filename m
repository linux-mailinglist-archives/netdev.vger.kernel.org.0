Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB4754FC332
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 19:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348861AbiDKR2y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 13:28:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348854AbiDKR2x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 13:28:53 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2062.outbound.protection.outlook.com [40.107.20.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F94B25C6
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 10:26:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CB2ardR7G4ZphlVIPGqSxmQLP52lP6gGZhRjZ3so92feJuoiijbIrspIp3zwT3DONSut8JvvJ688kwOFT2uRKgxvvEBS5x34UgTp5TrYgIjZmebOvBmCJVC1DK2IbJ0nWROHjicIUwGGA/TB9c1eIATjHUOf95+BgYoFPva3yrqEEAYZBlW1A1RXSzBhRqI04QkACI2vjYycIqZhsR226D78XyZnWHvp4OphL8YCEM5Yxn9m2I5dFKp0YxGE42pEXmTJ5tdsgC/6jUFWUCZDD6lcCwiJAwK1nRhQSeVBtUg2AKBAb19QOhyq/6395uYT4okXFSGJv3pnh8Mx1Y4IKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AA8FICreZLhELcYhsUL5ZOOyD5bG02UICUV0jKEuSFI=;
 b=WMLC6sh/dzHVmsrTTtWtUGJZEMLJX2D+80y+LgMiguE7CLMFd98Rmp5brEBIoz+/hHhNEvP8ZRirh3UxTK/WpBPO/6cSTW2L1pCn8S2WXEPYmJ+8rM3hHBvCAYh2g1sAoCaSXw6NUbrmEBSB17TIiIGOvz96xT1dDDDv9TQQ346ZDyjxipNze9AtgyJ6KdhlnSKVHOkkcuCf8H+qhHNSqKn8uZGWIGmRQg1RvFy85P8g6XhRoWTVDmX+hNTk0wtDHcUdeOWdS0YP2e5VOXIZWnkJaCww+dU3u4cTKFHFQ+yauupn7lzTGFIaov9lzqM/NNC6wNsCy5pHj470257RyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AA8FICreZLhELcYhsUL5ZOOyD5bG02UICUV0jKEuSFI=;
 b=fUA5RDc0oC6R81Pz244AS1J9EQvo1OMdAja6HuIjkNe3kHacJgyQn6G4/FF7HWXvzQo2Dkw4Y8xMfl4bnEtoe7Izot81Y7uDuWzosz8Sgn9i1W6N/ttKtZivR3MoLpWNu7tiXRfipkUnz1YlxRkE5yzg6uB374eRJOqLoXxZnAU=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB7590.eurprd04.prod.outlook.com (2603:10a6:20b:23d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Mon, 11 Apr
 2022 17:26:36 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e%3]) with mapi id 15.20.5144.029; Mon, 11 Apr 2022
 17:26:36 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Joachim Wiberg <troglobit@gmail.com>
CC:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: Re: [PATCH RFC net-next 06/13] selftests: forwarding: multiple
 instances in tcpdump helper
Thread-Topic: [PATCH RFC net-next 06/13] selftests: forwarding: multiple
 instances in tcpdump helper
Thread-Index: AQHYTal/SdJiswEY6UaTvzv6IVBbfKzq90OA
Date:   Mon, 11 Apr 2022 17:26:36 +0000
Message-ID: <20220411172635.6pgeq56p7oixaz43@skbuf>
References: <20220411133837.318876-1-troglobit@gmail.com>
 <20220411133837.318876-7-troglobit@gmail.com>
In-Reply-To: <20220411133837.318876-7-troglobit@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 70c8fe04-8abe-4fc0-045b-08da1be06e30
x-ms-traffictypediagnostic: AS8PR04MB7590:EE_
x-microsoft-antispam-prvs: <AS8PR04MB75905DC575218CE0766BB290E0EA9@AS8PR04MB7590.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Jb+BsdpNHXNTfB1B6vnzH+dK8n0qye9WWEcljKseZ7tjyW/B89kU8jZo5KRUsFpqpoYA6mBKmR3lOSkCJMa48ltRUztUYyJ9CbDvd/ktlYx92xhJpoUjKv2reYaIZ2ToS5vFrfHrlThqx/o7HUlNULUhH/wnCCIFHBQsjD2JKihhTfHq5ZchI14uK+sGhvLruFDgyssPebORUwVEMm+jdszcf1xqKKUH0ivQwrlQHunxTyjoBTRxOaTV6BhtEDvr0pEGJudza8E7F6nhGxyQ+Xn15hbDUiSJwEMwYG488bHmCd6+WLq0A/0f49lVnZukKl0JvT2JWp8KkKNmAKAY1FPCezRHcn0GdFARMb6srTRmNFHy9ydS234Xubzey1d+bTIRUzoSZ0Sacu6T899w3OtJqpvEgiG3uBiDHA5yJ3npYFzyLt2BikUKYnRL8yMyLhAJDJDhvVg4cr0d91Z0FFuPrqOkm0UHgE5qjcw/i8Z2mokck88j176NafyOP2W9A0vDgNMxj4Bfwkhs6Hp1lcJFmwS50Mke2A3R1e1CxbyN5fgoCBruzkptx0snLWVugx9mLcwfO0wNlPsQSa3LPjR4zYw6hNBgXjgLKT+f+C4T+yxY/VNBj6wgeBdirSMC7iaQgNMAOhNUhnILHKp/qMwe9a6+yEl66bFQnhlGGxN+LIL43akfiV7qZui1G2EDR7rGMkgnY9MdrQfCNKBj8g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(6916009)(1076003)(86362001)(64756008)(66946007)(66446008)(66476007)(91956017)(54906003)(66556008)(8676002)(76116006)(4326008)(44832011)(316002)(508600001)(122000001)(38100700002)(6506007)(6512007)(9686003)(71200400001)(38070700005)(6486002)(8936002)(2906002)(33716001)(5660300002)(26005)(186003)(4744005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?hDUjSUU+FDx/eBAY4OKpBJtngVjvaoGw70grCpfEI1Y4l+yYI1d6robhZUjv?=
 =?us-ascii?Q?WFQ1WobMB+qYK0gnpyRge8FO6Xo5ycyMi3JKmMQXlJFHUdrJm6aHVplwZMlG?=
 =?us-ascii?Q?j6Z55DimAoMgsCSKN/+twp5Jim3RHOeoXhvIBz5BC7XvAzpSRSRW0Y3yUAJc?=
 =?us-ascii?Q?/9wJZoCV3CJxWHrLuakhWCn4FwrvNlri/He3z63gEVAASABMYKoOIe+I6n/l?=
 =?us-ascii?Q?SfL8YZVpDmIYZnCuEhfIPcuGBhRMPUqGMm1X8alj0KpZ0Rk0d7eN8GGRPbO0?=
 =?us-ascii?Q?uyokXOTchWw+/lI0EYF4Qqe2xVtXcG+kus73VLwkBSbGY2sSApa/M0w4ZjVI?=
 =?us-ascii?Q?WaMj4zJcw74lSqs6deMU8cKgWkVDRN8GYQ9cEL13sjwg6EP4DQb7nKFpA/G8?=
 =?us-ascii?Q?Mjvg4yjd3H+3bBZIpiyj8qzKkt4jOTljqoLgNO2nEzsHeiCStVGf3U5mXauv?=
 =?us-ascii?Q?CMURodiv7725XpRa+Aqr5SfCmAzpEMrm7CEyudlApUpdH4OPlmTD4i6FjBta?=
 =?us-ascii?Q?T7xrNQWsc/YdePdz4ssAmb3Y6u1niUZ5vUECM+IdmmSM3e9dlF7E41suNnBK?=
 =?us-ascii?Q?kd3ghzNrgBw2zR1SY4/RxNbOafCe0y2RezM3iUVqt3vViOA7809CVspfEbfU?=
 =?us-ascii?Q?KtYFsiWD4/6knhTy9q1cj2hCP/Dj55D5ov66NcroWCSM7wxt7T4YejyYn9Ja?=
 =?us-ascii?Q?Mjc2K+3WxckgvMFncumvcz4KY8xCja0tGyD/5la3l8xBtAixHUw/hC/QwX8J?=
 =?us-ascii?Q?V7whpgSZjXMfxICsAYdd1uw7amQgSLsV382koiStUTFDvuY7qWfleEALd0AJ?=
 =?us-ascii?Q?a3Bi+NO9Ky4+RtyaMrokmC/9lKzP8XeICIVxdZNEdcJQWrLkuyzNhGI4gjtQ?=
 =?us-ascii?Q?1TMCBhEA8U0x8D7SemhwgLboaBJZnzigKEmozIhDTGBxfyt+MH7vryX0VQ+c?=
 =?us-ascii?Q?iP/7uTUwkNQEAkWS0dVeyXQjUD7H+2sst3L2NZtNoHtzir9Ycfz4dYAuTKUE?=
 =?us-ascii?Q?ZIuCzYQNAvEGBNhqPEZH/g+wK68ddVxJWEwhyEmMHMssVFuO16hdrWgONDwN?=
 =?us-ascii?Q?VazxECCNDlK1Udxwl6VIosO7Pp3Y6YqdacOAnRMKi8/BZoZuSNZjdaVcBbUO?=
 =?us-ascii?Q?oUVtK2woe+FS7CCXjvW/afNVXbX1VEp9M0UkF+bJ+Q+8cDNBqkK/2FcsSbax?=
 =?us-ascii?Q?YLnL9yaSOYomkIO7mgF97ELH22t+Ot0vlDkXFON1zUYqb9TuYmhhUhSmvk5c?=
 =?us-ascii?Q?3LnceOyJ5KbFwkg0JbjUAteY/kpMZfwwlutkXxOK5zrAP0pPptf+0Zzzp43O?=
 =?us-ascii?Q?T02EZT4wPQp1htwlGvCif+dEatDkbKFfvibOiLQje9seD2Ph9cdgxRrEBkX3?=
 =?us-ascii?Q?ajeW8o1lUc9udsBChK39O/tVNH0yy0YeEkEbP/t9vA17xm5ye3l8AR+GRa0X?=
 =?us-ascii?Q?WSnLXepXsgfKLhXlxgz7nZT0pdV4+ddDIGLQH+mYJJ1eFeIHMk+hyEpYk+Al?=
 =?us-ascii?Q?Wsv8KBJFkbQyVdLcPpy61GC08rhn3Dn5wVbLJTXf8fbJLyjLQrmc8oHUrkG/?=
 =?us-ascii?Q?KdjdZXah0h+56GMSTh7IJ0cPiofCXusuD1So4dRhLwH+SRwN/TqVse1lPxUO?=
 =?us-ascii?Q?O7djaN4GkMgB1C7gcxW/qbTtNzf4Zrf35isXg5BdCp9FTrX4emV3ctl71qhk?=
 =?us-ascii?Q?SPEPvGrPrydKX9YTlgFzJAiqF1038CvogIMdiS6LgKYo8TrCiUaFAoSitC5/?=
 =?us-ascii?Q?O+KLPLrEfDz6j/pIvT6yqEGn5l0FdBM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4BF5A9EE8F17824A8FB5252A81A87104@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70c8fe04-8abe-4fc0-045b-08da1be06e30
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Apr 2022 17:26:36.0830
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qfDc2M0CeI4gBi4FzU4vfcj/SqOLRa6Tb0TjKUnqg4djWiLJUYjh618J9XZfioZc/LrcOR9adzUss96/+b9A3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7590
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 11, 2022 at 03:38:30PM +0200, Joachim Wiberg wrote:
> Extend tcpdump_start() & C:o to handle multiple instances.  Useful when
> observing bridge operation, e.g., unicast learning/flooding, and any
> case of multicast distribution (to these ports but not that one ...).
>=20
> This means the interface argument is now a mandatory argument to all
> tcpdump_*() functions, hence the changes to the ocelot flower test.
>=20
> Signed-off-by: Joachim Wiberg <troglobit@gmail.com>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>=
