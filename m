Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7340456C084
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 20:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238919AbiGHRnp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 13:43:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238571AbiGHRno (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 13:43:44 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130135.outbound.protection.outlook.com [40.107.13.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D817F5B6;
        Fri,  8 Jul 2022 10:43:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lvff5trU9O3gA2tEn1PvwKjTC3KyuAYzFZgucS6rTT6cWeruinzKIY4qCbobHcYCa3f2ffEd5mAPrGtRWuajQ26JA9mcqb28C3OGCLoJsgsU6ymI3rZX8Va3vE+qdUmnoEXxuspVnN+D2VG0MJaMsU8uy7kEC2lRqOnxAwxqvxF065yt+VIvi9vBr9TDBfaKmCOaBYST4bE1DHxp6SPSD35CEcGIG6aQPG+IDI+qN0vmYdTHHOSotzG7yyZgHuv3iCP/pi6uLVT/zTLvSb8OuNSLNnC63uVX12ARnkQKvkvk458cZWY0rOYSooReHGiFIvCK2+yGYyovM7VazOL6+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m1IPa4OA1O1CVJxjulxz5JUfQtL1dn5X27GHvv7Cuaw=;
 b=gLFM1sm7wfqcpDaLXmKEolX057p/clg9nv4dZG4sn0j94ZECRc0WtigZPpifryMWu6jCOIqG4cGspZX0QphhchQ7P29tlxbVnNtBwmJM29d2vYG7UCEXL5b+BikOPRWX5jgY7QJGh1Y+gIc7zcX2FQUluncRO0WbAzugYuzpt0XImNb08ZKQb2Kf2YiSkJfsb+Y/4PyZjlM4hXf/7oY6rdlUiyHkM/nD+hLnsjD2DCzyOo6kZOtVVHS/XmklKX6tjcJngv6ql0Cs40L7xRoutzD0w5BhRWbvIrndb3Rj79lNy8ohfh3m8OV5zOveiuXSzkf2n7f+lrRaAc2Hm3oFEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m1IPa4OA1O1CVJxjulxz5JUfQtL1dn5X27GHvv7Cuaw=;
 b=Hd7aizJIjwf4IO1SAi5psvl71KSxM6nI63y4HkmJCrcwyAVuyDgaQstGDHhfzx8LBCjSFCvc0CApV/K/lWFlOuHRgy8lPvdofnUzTcp/lgYPSNtFc27WmnFv7hXMxIvi+pyPJxqTuPLooijS1uPh36Y+rOxw/Yg5s87qQGXp77A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM (2603:10a6:150:5b::20)
 by AS8P190MB1414.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:3f1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.15; Fri, 8 Jul
 2022 17:43:37 +0000
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::25a3:3edc:9320:f35e]) by GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::25a3:3edc:9320:f35e%3]) with mapi id 15.20.5417.016; Fri, 8 Jul 2022
 17:43:37 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, oleksandr.mazur@plvision.eu,
        tchornyi@marvell.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lkp@intel.com,
        Yevhen Orlov <yevhen.orlov@plvision.eu>
Subject: [PATCH V4 net-next 0/4] net: marvell: prestera: add MDB offloading support
Date:   Fri,  8 Jul 2022 20:43:20 +0300
Message-Id: <20220708174324.18862-1-oleksandr.mazur@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: GV3P280CA0045.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:9::18) To GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:150:5b::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 67a9b3d3-632a-40c4-2ad8-08da61096344
X-MS-TrafficTypeDiagnostic: AS8P190MB1414:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +cg1VHrIJ9/YfW25ki+mw/jwvCpvn10rf1hpTMTTtg9bhT1Gbk9+YY8OCC20J5XabsabRq4AcApWceroA749TPcqB1VULWowWhJozIg4QacTbCCc+ORvuMRq0pnEoGJ3edLtKvOJ2WmASNU/7wtC6y+vaHgIs9zghLRZCwgyIZGDrdbWpO3frbEmJMjp25CSdjpPcCHhbxe+2ec3If4WFbLjqcFxDPBzINeA+nAHHmnUtcTWhNdFW6CtteqPglLI6fbnVRk/qEMy/Z4NluvBxSOubsLWGHdxWAABlNV0mhMVIKRF1X6f9GhqaY2iE2URbQ4htY1MVwbftN5HPonbFOv4kjNfRVpfcdJCzKmxkiojVAKJIKgWGw4uFWXbppFHnKWk7jZA4VnKTKFMhMf9jmwNITNFBVhPpxA+tEmLF/Z1R/mjtXf/BmMOeR73SzxGOh6ZFqDKLOsh/HayOP7kDoCLGRfEN2fICHx/NtdX7zi1KLMfIq/Hc2RhjHgp9ncVSdPXin/fDqu826pivE7e2HwzjeNdoyc9472fi7+ndpvOd+ZxsNueSdrCIHA9kVLyGcM0ZQE2gtCZM/Tvg2z1Xabul85aNXUMKE/9JCZPX6ogbfpW45Yu7GDcgC4AKgR3Ih0LOHfDz3wivDBpoERtAOT2LuLIAU9bCCWdK4nOX4SJbgP3niHn2YWAHz6oclUcQmBaOkA34YBG2dGUT2goNyZdEcXfbhH2cTJZNZc96UP0zxsbYg6NvFU7uKhA39bZ5lF/irsrukMvqY3reOG3y27dj3DFJau7wFY+VA2F5zTMxNn/mfniBP1UySvB00mn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1P190MB2019.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(366004)(346002)(39830400003)(376002)(136003)(4326008)(66556008)(2906002)(52116002)(478600001)(316002)(6666004)(86362001)(6916009)(36756003)(6486002)(41300700001)(6512007)(6506007)(66946007)(26005)(8676002)(66476007)(66574015)(1076003)(83380400001)(38350700002)(38100700002)(2616005)(44832011)(5660300002)(8936002)(186003)(107886003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?U84/xYJmoEg/E4EHpbyCatFv4AzKV1v1fPXdGb465/4S0LiOsQpP65G7KEwu?=
 =?us-ascii?Q?TZAJv2ilx4BzBVW3sZrysNtQ5GcvzNNgR7UDUaB7Hpn2EM7LR9v3Br4S606g?=
 =?us-ascii?Q?Rvv7WwOhGaKVl5Ij2gSawtEFZzxSoUpGabruj5ggKKoRczGHcvt1U4qdM0rg?=
 =?us-ascii?Q?PlFd5RoORj46uSQfwXbyuYFRm74nIJbon4d+EwUeCACSrgUYF6KNoA1bEwZN?=
 =?us-ascii?Q?E4ms+NvdgbesZ66XnAbGlpcIcXwfZOELF+mrRrpY+4nQN40fliwlVa2gm2s0?=
 =?us-ascii?Q?Jp/n7gQ/M2CyTaMr1deHwftGEbHrQzdRR4+NSRqYqG5BpFsFfHkQSwZCbTKD?=
 =?us-ascii?Q?4wgge+DfxGTjS2u6I+YEoPZArTzW3xstihmDeC8uoP/dHCzCpfl/q/2E1onr?=
 =?us-ascii?Q?1481PIpe1h59KmrLsr7Pv7zUsUTpgf+6AbEpWds7vTFPbW3of0ZdlBMYciru?=
 =?us-ascii?Q?3AN2GLx0XPY/dUS/QfqRdWWVfe61CG7v7VbtiVrNg0Lrv81jDFOQUDTWBmYT?=
 =?us-ascii?Q?xo+YoBxJebSXQGaA+3nD14KKQXOVM02iY9Ed/ZDfY+VCwpoYeabTvwyk/QG1?=
 =?us-ascii?Q?S1NSMdlLZvgPLU6fkPhvlBX8LQSr5rTKm3Utrp0iI/l2EMYcUa8VCjTlXp1S?=
 =?us-ascii?Q?ppxVFR6/DMPnMH93cZspSX8ds2HkrfM4e3g+tveYvpmZ/wJpMKNZFGo4bSyU?=
 =?us-ascii?Q?cM6oK4zuts2rbkz9fKTiwW88R7Tge9ofIZI5i4GgO1cycYNpxfp/2mz9lGzP?=
 =?us-ascii?Q?laTK4RhqkAkDmjBCHM9o1e3boxt/cMvtMfRbaOrhLM279YaO/BgCpAnbRFoJ?=
 =?us-ascii?Q?zrcf/Orb69GTzr8zn7sf9zHlsLo368CnoIw6pm44A/AmucnH72mYgQ8kgVIm?=
 =?us-ascii?Q?r86SJGqS62vStycv8Pk4+nGhMDWRATDhaoAIu4yFZGtSVtTTeDGgXNpjCIKZ?=
 =?us-ascii?Q?hkjUtkeKGUx1juIrYzC237sd0kWywzt9qkZFtDjzuVAemCTr9rCpmsVml0Tk?=
 =?us-ascii?Q?OhjEEjEID+c5QV4kosDCYsomhKa813QIcUXx24WhKTwHsyb0qpW3o6GIXnlu?=
 =?us-ascii?Q?AkX9iz1Pe0X1x6Xt02j5FJbDOrFi7gEjVW34wEsGjQdgO2Uik2GzoA5E+DYB?=
 =?us-ascii?Q?Ue9wd3F8zdrRCBJpZ9d49Sg7ngnCyr94PXr+k2QjjinhxJWLCx1DX4pm0ID1?=
 =?us-ascii?Q?JWCjvrF9b9wMp5uiKCwZ09wM40t4VgBRO6xEjkmD+jxLOV35fdesAutjRvp9?=
 =?us-ascii?Q?ySpvBmeiMvA46XuLdAYlipQXR8sPYWSJPdlbCT5qFejdi0F0WNPK+yfbkS//?=
 =?us-ascii?Q?ae1Oc0KNElNPuWthZuHfK/VJlHMuuaveH2LsiSpFyemsLF3q1/5wHrZ4N4pi?=
 =?us-ascii?Q?yKOAXIpwc8c0WUIcc6oq4QCSXiNONfsnmDPRnHRaoCxU1ukgeLBlLZhPOZL6?=
 =?us-ascii?Q?ukXgr/+6ISEvO1ordukX3ok2m8elQlvHP6xZuUtxEi55V0feLwBMUsjuXafN?=
 =?us-ascii?Q?ARKgA5sFuZctHnoLncbsDMZJX2THYwJEKHiRZdgSVdZk5NaM6NhcKuGC6CeD?=
 =?us-ascii?Q?f0U78mzP0j5XtNuvVWvhh/aGo9Li0lxnTVa6dkShZ9QPU/vez0NVeIGJN2uy?=
 =?us-ascii?Q?IQ=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 67a9b3d3-632a-40c4-2ad8-08da61096344
X-MS-Exchange-CrossTenant-AuthSource: GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2022 17:43:37.5764
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sFjE5Z7g1eH2gZfwq8DhPfTZi4TqyuoNvgcB20riGPBUXDrdjz7vYEAowj0HJyCStJggDZJ4jEsvCMiDIoNoF6RGuEJNQ/Uz6Q0/N1IUoCE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8P190MB1414
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series adds support for the MDB handling for the marvell
Prestera Driver. It's used to propagate IGMP groups registered within
the Kernel to the underlying HW (offload registered groups).

Features:
 - define (and implement) main internal MDB-related objects;
 - define (and implement) main HW APIs for MDB handling;
 - add MDB handling support for both regular ports as well as Bond
   interfaces;
 - Mirrored behavior of Bridge driver upon multicast router appearance
   (all traffic flooded when there's no mcast router; mcast router
    receives all mcast traffic, and only group-specific registered mcast
    traffic is being received by ports who've explicitly joined any group
    when there's a registered mcast router);
 - Reworked prestera driver bridge flags (especially multicast)
   setting - thus making it possible to react over mcast disabled messages
   properly by offloading this state to the underlying HW
   (disabling multicast flooding);

Limitations:
 - Not full (partial) IGMPv3 support (due to limited switchdev
   notification capabilities:
     MDB events are being propagated only with a single MAC entry,
     while IGMPv3 has Group-Specific requests and responses);
 - It's possible that multiple IP groups would receive traffic from
   other groups, as MDB events are being propagated with a single MAC
   entry, which makes it possible to map a few IPs over same MAC;

Co-developed-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>

PATCH V4:
 - fix clang warning - var uninitialized when used.
PATCH V3:
 - add missing function implementations to 2/4 (HW API implementation),
   only definitions were added int V1, V2, and implementation waas missed
   by mistake.

Reported-by: kernel test robot <lkp@intel.com>
 - fix compiletime warning (unused variable)

PATCH V2:
 - include all the patches of patch series (V1's been sent to
   closed net-next, also had not all patches included);

Oleksandr Mazur (4):
  net: marvell: prestera: rework bridge flags setting
  net: marvell: prestera: define MDB/flood domain entries and HW API to
    offload them to the HW
  net: marvell: prestera: define and implement MDB / flood domain API
    for entires creation and deletion
  net: marvell: prestera: implement software MDB entries allocation

 .../net/ethernet/marvell/prestera/prestera.h  |  47 ++
 .../ethernet/marvell/prestera/prestera_hw.c   | 126 +--
 .../ethernet/marvell/prestera/prestera_hw.h   |  15 +-
 .../ethernet/marvell/prestera/prestera_main.c | 191 +++++
 .../marvell/prestera/prestera_switchdev.c     | 730 +++++++++++++++++-
 5 files changed, 1018 insertions(+), 91 deletions(-)

-- 
2.17.1

