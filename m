Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93D2E5A1A36
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 22:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242983AbiHYUYc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 16:24:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232230AbiHYUYb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 16:24:31 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2111.outbound.protection.outlook.com [40.107.20.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19F6EC04C5;
        Thu, 25 Aug 2022 13:24:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V2chxXynfn2MaEDeecwclhvYp75h0+gL/DHz3p3qm1Mk95WGszXg9V+aDa+RoVK0cU1pAQAShWDVW+yHhUYOzqPWBLudVj1AV9RH1iVj64WIa8+buWkoJlMfbtnbw1uyiQe1k4H94mesaX9KQRCSnhstPO0vZd6zJSg7GdWC6yYZQPTE9ugyyNZfOzd6BWBky3y6ErUYc/2v3KDVQZMB94b7CdoldXGHlhOFCwkTH81kM82OqRdYT/MFO3u3e6l7RbhyWbbRhkAKYc7qNRbKWuK3hOx0D68ywCeKSCPxegvGljX8W9e5ZqUpT3bBPNIHCVh0bLKLIVuqno0xU2TItw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=15qDAEiPxO+V1l7c9pm91THKJcYzNNVVCGl2ZhNIS+4=;
 b=CvToCcYOhdO20CiHFAKRbNOAkT/MUEQsvPPQw5brAF6M5dyfB/9Vpzbxh4E5DGBl+Bjjq9Ym+QZmxoqENVuqhFz9gcR93tdFtWpBFEu7i/ZFIsojp2WBxUKJHOl+ptboIYmpEQmsxTmUJ3B30DAXmmOLv7zwwVd8WJFRn+XCGDo9r2U1y4uCTBwKIH31fIbuwxAjSgdl/Ss72d0yZqHWaVjG+IOt34X7Q+3ZDeW8D8fOSr2UHccaOP1v+58+fxbPyaYK+niwhrbf58dC+9hpSLNjQjfWdzznv9f8yYgs+3tbUkWfwFbqf29/N1bETveGfXgRH9CVU2soH2Lm9WTvyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=15qDAEiPxO+V1l7c9pm91THKJcYzNNVVCGl2ZhNIS+4=;
 b=sinP/D++wcg1tO2oBONGuINp4ngE2IhLcwPkez1vbvS/Isdpf6pavsZ6MfR0XkJPFztFIOB/wItPgcs6LhWezD4kUH7NeExjX8flthYxgBSO1roLg+5sCquFlNflSgNjyzOtCQ03jvMj8n60HiB/uKxb7ehBz/ojAG9ZoPxSvPk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:283::6)
 by AS8P190MB1621.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:3f9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.19; Thu, 25 Aug
 2022 20:24:27 +0000
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::6557:8bc5:e347:55d5]) by PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::6557:8bc5:e347:55d5%4]) with mapi id 15.20.5566.015; Thu, 25 Aug 2022
 20:24:27 +0000
From:   Yevhen Orlov <yevhen.orlov@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-kernel@vger.kernel.org,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Subject: [PATCH net-next v4 0/9] net: marvell: prestera: add nexthop routes offloading
Date:   Thu, 25 Aug 2022 23:24:06 +0300
Message-Id: <20220825202415.16312-1-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0092.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a9::13) To PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:102:283::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 93bc94a5-fd74-41ec-aed9-08da86d7cedf
X-MS-TrafficTypeDiagnostic: AS8P190MB1621:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oeuNrvlBbk2BXNoAZueo7dFTOPTtLrwe3aSrK2akk05oWwjVEA096l975h+IGCrVK+iLndKNuXfE+p4GS1CIJslC6SC2XPd6rp23+NmuXGhQk33LJmey5PYSkD1Efo+kYjeo/BiaNvIWQwVxWHXrvsl8hdoItDFLc4qhDxaUt5FegKOQ+xwT6/79nIzWCVo4wX7TVHVHCBSIP4S8m/OGGRTW6AJWYNUcV+KoksSWBQhAAihi3X8yGyGxgWY49buAGG5u02LE9QrdlXmxk4QkhsQX9nk9LrnAHGrxfYHv07VlrC0ReNNjkGZFXyEVL9TeBVj9tEblg+VQe/jrO8C3M4pESl19lOIsXeTi9QDCKq1wF3qepVem13KHvpejj8ImxVcoiewVU/+stYkw/w4HSxad91k/YTNSeOJxhrF/6DzMIj4yrQ0bRetJcuSQyYSr5IpFI6bVXnm4Lis3SHRNlgBnbH0HTwm3Tn/XpByrGKwN1Z0Wh6m8qm+VEllTFcnqBevoCRrM45TxdJjRxDRKoMYtCaiRSmx2yJHM2QxjPtHAi/1AMt30dA2gwCAagQ4erVJ5yW3Ybl6zqinehZw8wArRtQUqbRS2wDow0mZuMBRLKqbNtu2gIMS45HqGq9n+vgwSVC7I3TnEUiBREqCIEyOU+a/+eaU/DqJE/idl/AhG3vaTxigB3Yk0dYoVj20dJ/ZEbQlROqeyOdWFavzWcsZEDtjOh8zOHMOQmiimOya9s4gf09W1pL6+acnkm3LZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXP190MB1789.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39830400003)(376002)(34036004)(346002)(366004)(396003)(136003)(6916009)(41300700001)(26005)(4326008)(66556008)(8676002)(86362001)(508600001)(54906003)(2616005)(2906002)(8936002)(52116002)(6666004)(5660300002)(44832011)(36756003)(1076003)(6486002)(6512007)(186003)(66574015)(107886003)(7416002)(41320700001)(6506007)(83380400001)(316002)(66946007)(38100700002)(66476007)(38350700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?35EfF7RCYrc6zsPJO+sS/CLjORSPRTI+wVExXz5qVaPoYMbti8LpFTbPjkJ5?=
 =?us-ascii?Q?hsuAYuQHt+M4XndHdAZ0kJOJzDkzEcsdzczFfW+zGtOyhzKWv95VOYOSXMvu?=
 =?us-ascii?Q?ZU14eYs7y2a6g+1Vx87Sx/zUV32bRfxUQmbeJpaNzaU1qaRpoX15BAcAm3Up?=
 =?us-ascii?Q?3nkr58p1SsQPq8mNBDCHJ9PPgKqMVl/eQ+dESAQulbnSPx6M9JgJT0oz+ITW?=
 =?us-ascii?Q?wo96Ox3dcDcCoiK6FsR/1WPfwLw4GKKzJ2o7wn3/WAZwMWfMV1NQ87c6OIKA?=
 =?us-ascii?Q?DCwg+6fvxhF7HbvJ+KOvRIi4o7IWfi3JCE9Mpph3/uLo4VPrW7uZC2ug5IEE?=
 =?us-ascii?Q?aDGMMOj1xrhmYM+hREhf/8kvEFnnZIfOkNS/ql5QgDaiuC6faTAiLcyi3j04?=
 =?us-ascii?Q?5pW8nwktGVwJXoGvX+lFniyjBZaScTIsL2ZJyJb3WL2kQVCHtzGamzKjFs8w?=
 =?us-ascii?Q?/WbagmBEGWZuGqE3MeOaZNyZOLl8hTiAdYoc47pKqGPluXlMvqFaXVk13Kgy?=
 =?us-ascii?Q?QkvQ0Hy+eGwLciibyHTnnGOu9CrOAjN3AH6eoiN2iJ9B6oX4BRvJor1lP6RR?=
 =?us-ascii?Q?wT9GkTT5GE36YS7dZzvxhETttqlB+F0eBW/3Bge4xsaDICJUFD5nk21rt6SW?=
 =?us-ascii?Q?3M4UxPgU2vbpUDmWRp9rP9mP1lMNAO4CAcpqh2GwpJyMBm8mtzNeiLh3fg8o?=
 =?us-ascii?Q?7+eO8NnVZ5aALOGLZbJcwSnbAaqIWyh5ze/Of1rw/ybRyNItGTINNznXDC8+?=
 =?us-ascii?Q?NHBKCV8DCYt4Sg0UlLvuW59HjjecV5S5LnN6x1JliyxciK4xmvYzVCaEiae2?=
 =?us-ascii?Q?Yaia5TkERx8BtUhzcBO+R7nk6m03ICEqZj2Thh/bi8qAwkFX+Vgacqx+YMj4?=
 =?us-ascii?Q?vFbP6S8aY5IM8/2ix9L/nCOskDOx7rX7HNVfXg9Rc20ayalVEMYGK6U/sWuH?=
 =?us-ascii?Q?C6OLegyg1IRzw7qVqDqcoTw6qDkI8LF8OLaHjqoyJRV1gC+m+DRswyY8HqWg?=
 =?us-ascii?Q?sHPShaX3Oz7cG8xHKMClbe/KFTQ7hE1znZ7WKAQQgsKTyww8Hr72m6hkONWb?=
 =?us-ascii?Q?dcX5LaUxYmOEe9XxZLxiNtOQ9n+/Cap30N2MW/DFkfAuFioW2kAEha3ETqy2?=
 =?us-ascii?Q?jBblO0m+9Dv6HFpICZobBLqy9cjnFTgcCT8DUNGq0vZaRsELFxKEHjFZSsJv?=
 =?us-ascii?Q?Sh0dZBdH7imyna18QBJBvSJxxztL/5r6r1M1TfZwlcysSAJT00ttPTAfZLW7?=
 =?us-ascii?Q?cINWTU0GxB340cGuRCA/LCO93dMAKqdJgfjKGi/xm4xDiLgbNCUg50yXxhiD?=
 =?us-ascii?Q?uzXg+RSqdklnsFQfZeCh+C7Z72J3vp21fexJF1msP5wuhHWeiBKI8IzEah7z?=
 =?us-ascii?Q?A6Aw8n3EsAcdMnsnI/4CUPvV2dtWsvJzvAN1S/LWeqM7WmqGrzCgx3y2Gmag?=
 =?us-ascii?Q?x5VevG881DInVTiFKlLmJpJ51KKRJ7r6WfGO8oMEgPlPnSDUQYWl1tbmd17k?=
 =?us-ascii?Q?1gNm+7mFQ7UHlO6fiVVNhvN73JnECzpWRWYKkojDEJD8UQeKufefAKLy/Y/R?=
 =?us-ascii?Q?mP+eXmSdrnIGRsV4V3oLShThqkT6SftUG+qLpyv7lrIWeSqm29rtyrcFZHgJ?=
 =?us-ascii?Q?aw=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 93bc94a5-fd74-41ec-aed9-08da86d7cedf
X-MS-Exchange-CrossTenant-AuthSource: PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2022 20:24:27.4452
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WP97jdQvP+rgLqLHh3tOqGCefgiU9/OWrVhwkZUSSaVoOhDmEyd3q3ziK8VzbXWmQ3vW56YTXvAVDovlTHpCESiygClrmQOZUWzZs2ZnhPo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8P190MB1621
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for nexthop routes for Marvell Prestera driver.
Subscribe on NEIGH_UPDATE events.

Add features:
 - Support connected route adding
   e.g.: "ip address add 1.1.1.1/24 dev sw1p1"
   e.g.: "ip route add 6.6.6/24 dev sw1p1"
 - Support nexthop route adding
   e.g.: "ip route add 5.5.5/24 via 1.1.1.2"
 - Support ECMP route adding
   e.g.: "ip route add 5.5.5/24 nexthop via 1.1.1.2 nexthop via 1.1.1.3"
 - Support "offload" and "trap" flags per each nexthop
 - Support "offload" flag for neighbours

Limitations:
 - Only "local" and "main" tables supported
 - Only generic interfaces supported for router (no bridges or vlans)

Flags meaning:
  ip route add 5.5.5/24 nexthop via 2.2.2.2 nexthop via 2.2.2.3
  ip route show
  ...
  5.5.5.0/24 rt_offload
        nexthop via 2.2.2.2 dev sw1p31 weight 1 trap
        nexthop via 2.2.2.3 dev sw1p31 weight 1 trap
  ...
  # When you just add route - lpm entry became occupied
  # in HW ("rt_offload" flag), but related to nexthops neighbours
  # still not resolved ("trap" flag).
  #
  # After some time...
  ip route show
  ...
  5.5.5.0/24 rt_offload
        nexthop via 2.2.2.2 dev sw1p31 weight 1 offload
        nexthop via 2.2.2.3 dev sw1p31 weight 1 offload
  ...
  # You will see, that appropriate neighbours was resolved and nexthop
  # entries occupied in HW too ("offload" flag)

Co-developed-by: Taras Chornyi <tchornyi@marvell.com>
Signed-off-by: Taras Chornyi <tchornyi@marvell.com>
Co-developed-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>

Changes for v2:
* Add more reviewers in CC
* Check if route nexthop or direct with fib_nh_gw_family instead of fib_nh_scope
  This is needed after,
  747c14307214 ("ip: fix dflt addr selection for connected nexthop"),
  because direct route is now with the same scope as nexthop (RT_SCOPE_LINK)

Changes for v3:
* Resolve "unused functions" warnings, after
  patch ("net: marvell: prestera: Add heplers to interact ... "), and before
  patch ("net: marvell: prestera: Add neighbour cache accounting")

Changes for v4:
* Rebase to the latest master to resolve patch applying issues

Yevhen Orlov (9):
  net: marvell: prestera: Add router nexthops ABI
  net: marvell: prestera: Add cleanup of allocated fib_nodes
  net: marvell: prestera: Add strict cleanup of fib arbiter
  net: marvell: prestera: add delayed wq and flush wq on deinit
  net: marvell: prestera: Add length macros for prestera_ip_addr
  net: marvell: prestera: Add heplers to interact with fib_notifier_info
  net: marvell: prestera: add stub handler neighbour events
  net: marvell: prestera: Add neighbour cache accounting
  net: marvell: prestera: Propogate nh state from hw to kernel

 .../net/ethernet/marvell/prestera/prestera.h  |   12 +
 .../ethernet/marvell/prestera/prestera_hw.c   |  130 ++
 .../ethernet/marvell/prestera/prestera_hw.h   |   11 +
 .../ethernet/marvell/prestera/prestera_main.c |   11 +
 .../marvell/prestera/prestera_router.c        | 1140 ++++++++++++++++-
 .../marvell/prestera/prestera_router_hw.c     |  379 +++++-
 .../marvell/prestera/prestera_router_hw.h     |   76 +-
 7 files changed, 1717 insertions(+), 42 deletions(-)

-- 
2.17.1

