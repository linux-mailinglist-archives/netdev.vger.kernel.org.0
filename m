Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7246C5ABA6C
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 23:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbiIBV6a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 17:58:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231156AbiIBV6R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 17:58:17 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150043.outbound.protection.outlook.com [40.107.15.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4369FB0CF;
        Fri,  2 Sep 2022 14:57:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EeY/6bYQwFp4EAS0a44xfxE5nLcAKRdiK7hiXUIP7gtgG3V4NVqPzIdUhlA02XGESU8Xhh7f0hJB4Pmf8pVxCfoNH9fH2UYqQ5HzWpwZEa7y495SoatFlLHq0Is+cLyI6H4eZNIm5XVzvzQwzgyZQ4dLBc0pRUrpSPHOFT+jTro40WuEaJH67sKi9GfhhkKms5drko3UlFFfQdLpUjj/JKWNoT9grqUam3ccdMSZM6/DZLjFsOppDS6vZshZ/bdaP4mxUcJqb9DZ/qbYCDHM7o4EnnhJKuxot9Br/rOfJb+UKFQt5T8dpibMoLnd3tccQmt1xdarZ4MaTOFfzYb+4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PggrfboskKj9kTUDvcULHvNTFGvjPzad6JWuIZ+Bx7Q=;
 b=NI8GoYkdowCzZPOBIDnN+mT5/8GLLFGGBSIEVUSpYCxgAO73KyqJ+glPE9JP+gftMNYl0oUBUAVOPxFxSP4FK1X3IhOpmNYBw0w9zJdsLyQlqU0gjq1h3kjgLLoxnc3pimC0c5403NGMav4DVrKwM6eF033K1ynWzC9JC1a4pXF1ren+4P1hSrI28kbf4SVb3vwjmpufoeuib/packPDHGdDIYePqxJQCAYf3LjBERj3/3HfQ/GNs+isAjRuyqz7G1LwEO1uoNlyUhHvAxZUYwesz/Q1g9bEXHIL3RLXyau4atQh+TNiZYa9HtcxOZx8zUklGzjqqoiWEDlyBw09zQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PggrfboskKj9kTUDvcULHvNTFGvjPzad6JWuIZ+Bx7Q=;
 b=kN/kLpvfk7VxFquSwFMnsCmvpWgdVc3oONIoQWQufPEZllRdRaDh+7K+eqcqLOgxEWaX+gAsfPSaoA6VIleAhaOvFr60EIeCgkN/LzUhz6gr8mH5/tfUbDiCwhpBi8Y3MmQXVkV9MU2sRiSoWgasEWcT88fzUjKorkPnIQgzDlXZL/K39FVJstUOoK0GBWojM2VAcoMy4dKTCclmzTcOZ8URtV73VNjEBcW7r7wqEvTNnqvmY5cjF4nr7891P/+LhSrvnPRX46zP1+eDwCIaNOstYmb20rVhI+po60JAeUTFHcCzKNWhDf5CY4c9YHCWDFZCg7IhunXbM3kBKWEKRg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AM6PR03MB4085.eurprd03.prod.outlook.com (2603:10a6:20b:1b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.14; Fri, 2 Sep
 2022 21:57:48 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5566.019; Fri, 2 Sep 2022
 21:57:48 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Camelia Groza <camelia.groza@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org,
        Sean Anderson <sean.anderson@seco.com>,
        Li Yang <leoyang.li@nxp.com>
Subject: [PATCH net-next v5 00/14] net: dpaa: Cleanups in preparation for phylink conversion (part 2)
Date:   Fri,  2 Sep 2022 17:57:22 -0400
Message-Id: <20220902215737.981341-1-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0315.namprd03.prod.outlook.com
 (2603:10b6:610:118::15) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a43a75d7-19e0-45fd-dcc1-08da8d2e2c33
X-MS-TrafficTypeDiagnostic: AM6PR03MB4085:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aaDJNF3XZjhn9tfgVBubXAtVv0sNrR6fC0mMOzn4eIyTybSS4dAZb5XJhiGU1zGSW4llOOpD+1ALBMr/MSTpRjyKNVvsiwrCqRTO9tl0US2UYobo1ti3nXDI2SI4b4Bm+lVoGCk6zhl5vZFCYjtNzZCpdAAyjCgHCojwOi5i59u+g5+f9+SkEoQawsT/ofkKvp/8HHRbAkKJLcU+0IeaW95HAjN4Z8jRn1oKD7J6hP4qCv6zi1BrbMPq7st8h5QdT2HIbFfdWZcf9mpx/ESeA34baQtIy6SAjsGpMB5rr/3Fz25vsLvW+XNijs5jreJx7JfA1gYZpdBLZdfasXYtyX8YpeR6z5KMbZ3yg2ScMh34VGeoHWm7tp+RG2bY36GmSqmhBKbTtKtRExAWvTQRT8i96Y/p5k/C5yWsVUEWfcSpLOTWUc0SiPTz1TaHySlHLNnuLoQYqrI6PWUAL2XQJgh+Rfpj9idfBZMM63F31Vi2JdPM5/unSzZmh5XvOMpFNiQ0t2nby3v3yOn76wL3e2U7fFkOhqqs5rAIpqt4Ypgp8o0+jV3ZTKvphTWPFRmFs1xULjRfPM+8m10aiKDNp+4C49sl/cR+kSMyJZub0eh8KH9Tq0ZsQIViE62CBAKY8V3q/G6xJQNaL+xIHlDBLwI9MCqzfjbzhuT6GrgNLGqQ1AwRRY5DVdFfGzT6c22VtyAeJiFD24JygfBWQet5TCDaI/sXk2Jc3zsyYxhwk3PnHu7gzBgdWxUfYuudqsRXqt6HNvbEgWc5zKiLninIF2bRAJYmLe1zFSLw7SycfqQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39850400004)(136003)(346002)(376002)(396003)(366004)(6506007)(6512007)(26005)(2616005)(186003)(1076003)(7416002)(44832011)(52116002)(8936002)(5660300002)(86362001)(6486002)(966005)(41300700001)(6666004)(478600001)(83380400001)(36756003)(2906002)(4326008)(8676002)(110136005)(316002)(38350700002)(38100700002)(66476007)(54906003)(66946007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4ty5odRh8eThGK8MmTbj2H683NEcWGz2v3B1JmSddCQaNnIwL8pN9A4Hx37d?=
 =?us-ascii?Q?SO9HaoY7c0jOwC7+idctsq5pGLY90JOnpC24qVNF/o5r7NwZpxjGP0TLxx25?=
 =?us-ascii?Q?1D15GFhlZrQKGUdKZc0/Cylb2Fs2MBxwNYUHhwZdbdecoQUL5qMOloTccQwc?=
 =?us-ascii?Q?lskDhDsNnl1lwKbvS1plvAdB78VSFUO6XPdohjNBHdUS0JSH7O5NmM0gfrk1?=
 =?us-ascii?Q?S+nB2rGEA/rXmLcqF8JmLbHFMvrnECwNarvBm6HfrH0OrFS/39u7/Xfzk7Vo?=
 =?us-ascii?Q?0LsVyGz3HyoSHGAgl/Sau8dmfPRbLXqIUOBT8tttrjjzIGFU21Lp3Y1HO27A?=
 =?us-ascii?Q?ZlJcgwuxe0oRpaajxdR8Q1xQkrItDd4FvKMqxxoSJyEvTdvtyvUZoXmj7700?=
 =?us-ascii?Q?3HKeJYJEvggwRGBVQLD4Fq9WJJBV0RMaigq2UuKwEzRJ1MfkKXohuk7WKpk9?=
 =?us-ascii?Q?ZXZei67d8rt9oKqxQIMMjoKWX1rtoTe6dxmsCIulBfCEw5jsg9HAb9EjunsQ?=
 =?us-ascii?Q?S4GpFOscFBWQQXkWaw7yJ/Dhl1ZoD4/6gFgLUu0NZgQ3SEh2pGk26QtbvS1U?=
 =?us-ascii?Q?faN+jw7kul749v1gL9T2wlzjwPRMoAK+fsARMjOOS+2a7+m9lhZHNTvVxtE5?=
 =?us-ascii?Q?6MNVOxd/rguyo3RGWhV7mdx8N4E+rjIiGF1XQCW4MRIJqxfU2fZdz3dJFKpD?=
 =?us-ascii?Q?k3qgwmcO6ucOgOdIqyYlxhAP3/nXK/xqb4Z/qw9z5zXVCk9YBsvHkK/xJ7yu?=
 =?us-ascii?Q?j+da15KwlD6z9vCOFVUVuaI7YRFFRIP4eWP7K/AQ4A8CWK8b22mlqn3MlCRO?=
 =?us-ascii?Q?/UkIE8O6rHboVGFbRFUE6sgWxWXcjRjm8PBhrP1O3q9RyRjOio547RmUqAig?=
 =?us-ascii?Q?2DkD3lx8DthTXYwlQuBDcear9uzAXPB+29NfBsUq1pwnx+0otxYFAR7LiEeT?=
 =?us-ascii?Q?Ql3WlbUdGaN5G3lLnRquqDPwz3oOWa652KjpENFDiC3RRIPnL6pYwo6+Rh3I?=
 =?us-ascii?Q?7kZ/WmO2KEBpqgsKH2TmvQniYEQ7GsOf+xKaEWQEZGXGTpFCffIX4cvS2sZn?=
 =?us-ascii?Q?/FWT9lf/ZBQTyHiZByPx3qe5UOdzQ+3qcjladVVYM1zNySVhqHcMBcgH9/ln?=
 =?us-ascii?Q?iZokI4l30l/+EODP7JbHIM3POiwyn+rVjInKZM6oT2pEmYrBq68VXyVWM6cG?=
 =?us-ascii?Q?5vZNynaB9sLzPvYTvDQ93LQTCCYfuT5IPjoDxiy7mKNcODzJvCTDXNLX3BIA?=
 =?us-ascii?Q?DqjQIZ4MH7isTeaK68D3pilNJcmMyUUyJgKKwdn4gL9JzKUak2yzw2yQ3eVP?=
 =?us-ascii?Q?fGwaBL43hqNoEo3hdPG2T4/g0aGyFW7zdVy4c3HhqlbPvh0vKIOBpMpPV8fb?=
 =?us-ascii?Q?NdWWpKEnJGZazsYcq5CACNmTerejs7Aw6g2Jfefh+b926O+rxMy5fVilYQRL?=
 =?us-ascii?Q?Rl7QAMukFpeZE5lFm/TAA5lmH6hpsqhFdMWqxp9XgGKBS7QwUjsiXDOyJF4+?=
 =?us-ascii?Q?29pZPkuu4SHB5/NOI56MBYgczNpy04ldZ3UxpGUeImmDistH1qCpnJx3iugD?=
 =?us-ascii?Q?Szw8N90SaDgXQtzEBNl1BX2XY4/fNoli+21jgWiyxRwRh+VEf2R4ilrgH/Hx?=
 =?us-ascii?Q?KQ=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a43a75d7-19e0-45fd-dcc1-08da8d2e2c33
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2022 21:57:47.9392
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OkpRE0cTguKH7F1qM6LBW8UyhO/ZK9t71PmnrdCwfVGxJSgW7CE3k1o3bDjS3dFQVkPhVn7DVp5k6M5o6jgyGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR03MB4085
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains several cleanup patches for dpaa/fman. While they
are intended to prepare for a phylink conversion, they stand on their
own. This series was originally submitted as part of [1].

[1] https://lore.kernel.org/netdev/20220715215954.1449214-1-sean.anderson@seco.com

Changes in v5:
- Reduce line length of tgec_config
- Reduce line length of qman_update_cgr_safe
- Rebase onto net-next/master

Changes in v4:
- weer -> were
- tricy -> tricky
- Use mac_dev for calling change_addr
- qman_cgr_create -> qman_create_cgr

Changes in v2:
- Fix prototype for dtsec_initialization
- Fix warning if sizeof(void *) != sizeof(resource_size_t)
- Specify type of mac_dev for exception_cb
- Add helper for sanity checking cgr ops
- Add CGR update function
- Adjust queue depth on rate change

Sean Anderson (14):
  net: fman: Move initialization to mac-specific files
  net: fman: Mark mac methods static
  net: fman: Inline several functions into initialization
  net: fman: Remove internal_phy_node from params
  net: fman: Map the base address once
  net: fman: Pass params directly to mac init
  net: fman: Use mac_dev for some params
  net: fman: Specify type of mac_dev for exception_cb
  net: fman: Clean up error handling
  net: fman: Change return type of disable to void
  net: dpaa: Use mac_dev variable in dpaa_netdev_init
  soc: fsl: qbman: Add helper for sanity checking cgr ops
  soc: fsl: qbman: Add CGR update function
  net: dpaa: Adjust queue depth on rate change

 .../net/ethernet/freescale/dpaa/dpaa_eth.c    |  52 ++-
 .../ethernet/freescale/dpaa/dpaa_eth_sysfs.c  |   2 +-
 .../net/ethernet/freescale/fman/fman_dtsec.c  | 188 +++++----
 .../net/ethernet/freescale/fman/fman_dtsec.h  |  27 +-
 .../net/ethernet/freescale/fman/fman_mac.h    |  14 +-
 .../net/ethernet/freescale/fman/fman_memac.c  | 199 ++++++---
 .../net/ethernet/freescale/fman/fman_memac.h  |  26 +-
 .../net/ethernet/freescale/fman/fman_tgec.c   | 123 ++++--
 .../net/ethernet/freescale/fman/fman_tgec.h   |  23 +-
 drivers/net/ethernet/freescale/fman/mac.c     | 378 ++----------------
 drivers/net/ethernet/freescale/fman/mac.h     |  10 +-
 drivers/soc/fsl/qbman/qman.c                  |  77 +++-
 include/soc/fsl/qman.h                        |   9 +
 13 files changed, 511 insertions(+), 617 deletions(-)

-- 
2.35.1.1320.gc452695387.dirty

