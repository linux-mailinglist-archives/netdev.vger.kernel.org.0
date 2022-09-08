Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B57A45B23DA
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 18:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231232AbiIHQss (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 12:48:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiIHQsf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 12:48:35 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2082.outbound.protection.outlook.com [40.107.21.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA57A84EEF;
        Thu,  8 Sep 2022 09:48:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WN59k7o5s4uzK47dQ0qs12PAmnae6vzGnEqelklkN4WnY/U97x2LeXEHoEP68EderLg1dR2lzgdobMph+S7aLa9VS2hJYjK+wT9i/A4I9TqpuLA8OEBYmYDtowqVHEGs77SDOrpgPR7l6/ZDjBb4iGru/7zb3588y9mGOyBMqGjoeCca72jhKdDx2VwPGXeNoU7cJLQidyUaOG7Jed3p20D9n7/HjPjLGi0VMqHxt4IUDRjSvyE3B6k8yFPpQndP9i2mSqcBtuqsMP7fL4Dpz9VhQN1hopLzYH6VyQyb48skmvqHa0nUDw0t4T+XwEEI4GRsZ9BJSWcsi3wP7JoDHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+LFjIj+vE4lug3+njW+Tsf4gMSUVkVBUArQv5wuOkvU=;
 b=RcjIB1VluMDzl98tFIXbmcqsOyq7voWpWSd98DXEpuxdW6zbiuuq9u3VtNxL0n6hob6f0YgMc2gBBcr6Nxti92di6QAuENfHCiUaZSk89K4iqY8fPS1KaCwNORQrM1xeQX3+yddgnCCUKJTY3hwZFnoTBcWf4oGVrV3x833J9eyCt61av4M/rcAi+J8obsqQLpgGQO82wvDWCRnBf2S0Gq5f6cea3oDALnA9y5gVyCO7xZa4gWTC7VKJ2eVeHf7HiyVr0JJS8gx+93j/ThSEDOa0He+df+hERpG4fOrqN2vhyEmZaPoFb/TrdKaHyeUlHeBgJzWSKBadzEWfYiqLCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+LFjIj+vE4lug3+njW+Tsf4gMSUVkVBUArQv5wuOkvU=;
 b=EFXTnm+6LjcPPRdTAx7Xxub6O6glZbAH0ebUIptr5Ud6mnvf4gkqh44/UuGTBCZRVDXRD1iuZv7B9zlKHQr/JQ46kLBtg75Zn9tiPpASrXAP98ph+FQF8+VhDbiLjXh+WNxE41yj1GKLP7eL1VrF2Sy2Q99k31s/1MLkpY6/kD4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB5154.eurprd04.prod.outlook.com (2603:10a6:208:c4::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.17; Thu, 8 Sep
 2022 16:48:27 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3%5]) with mapi id 15.20.5588.017; Thu, 8 Sep 2022
 16:48:26 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 00/14] Standardized ethtool counters for Felix DSA driver
Date:   Thu,  8 Sep 2022 19:48:02 +0300
Message-Id: <20220908164816.3576795-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BEXP281CA0009.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10::19)
 To VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0c1a5e20-0161-466e-ad67-08da91b9f36d
X-MS-TrafficTypeDiagnostic: AM0PR04MB5154:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PWGnrIZabog1+uKzMuhFdVuwzu8EWPB2WBS/eGWm8C/3nonh4assC89UZL9XWoE5Nbp0fdrDdpNjikUhJLCbTvF2nypaE3S2tr/TrC01sdTzbh/Aqd0NiImJ2Q1MsxuLEEX2kWlBXhPAhVgKzf21qJ6d/wGAJul+2IDXMESebeQbUTxRtGaMMw2o+zkJKquGfJogxWnWCgitxdie11h5g+wSAkUbhInTd1gsIrUxcgUBbdNHKA8eNMWfrkPFhcuUwyFA6sFZx6KGWBlED16MvNieTSevXtOpXKyTWr04BgX9ITAGajDc53klC4Wyf8JWGBgvAxvTO3TeixY1fT6Ag4kYoJMzUZEb6gj6ESWc5SQj/dATsuyjo8fa6wZ9vVxdP5rI1+we3w8AZvBLWVmyYGA6nyZyf98nWRDTOT1vPQ1Ba2h9EBJaogw9LdBXMq5GMr814MEpS4jOybHhEH8/JpkkgmZrQvtNwogP6Qb3ArPwex5T9LSS/hvJ7iN9VJ0PtfL6p+sRCv8ZMo+cv75QmHJcsK1g+EqJdxb09QUPGeI33afiEzSDHjOY5Wxa9wwjNGGoeeGpUN9zA5XlAtwH9POGZJX9/r2WA+6ZwCKHKMDHHEPunavvbZlq0RFPnuwp9bZ/BXNw14BFmNDnm/CNaHSnGYJl3aOvNFyoZoppd1I3gm8LdPclCnbwVJWtS2vpZLoA9t0zoWGDWN3aCjo9yFaBCU6uiW6carL2mC7fo7qcjkewOY0nNeiusqSnkCVQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(136003)(396003)(39860400002)(366004)(186003)(6506007)(41300700001)(1076003)(6512007)(6666004)(478600001)(6486002)(2616005)(26005)(52116002)(38100700002)(86362001)(38350700002)(5660300002)(83380400001)(54906003)(316002)(44832011)(4326008)(8676002)(2906002)(8936002)(66476007)(66556008)(66946007)(6916009)(7416002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/feswYaEbskAFBEmoKGMHK90wo0DluVQNDbJttD4ccUHfGs63eqWWMG+a6Np?=
 =?us-ascii?Q?fSngqlGbTb2ae0rsbTT2vwt4S7V6E6WUvLXJuks0FS0pwyJW/XLl/xuf65J+?=
 =?us-ascii?Q?NirfcOljWc2smQ7n9mTSBxfuViQTU7DuU19TDbZZKCgc9J5l/4UFRzPzC9du?=
 =?us-ascii?Q?WhkaVgbpGVWeiNLTbXoIuf46u6cz1Wp/8sR4lGPfQtffmOaFZcYw4zYQp/NU?=
 =?us-ascii?Q?F19o/fDplmbZfmkoadnsLUvSV51y+gDU/vLN5D1V7LU4cREzJfWngOIbzDPl?=
 =?us-ascii?Q?dFIqV59qFe1KjeY0uK/Ejss322pUXjsNUcfDrUMJtKYitGDZeYI/UVMKDOd4?=
 =?us-ascii?Q?GMJY2xFztS8QtCyU4O2AREmisyuzWaOuMKxIggJLGVw71FrcQnNSG3hXhmLd?=
 =?us-ascii?Q?HzLAgWk204R48lHlLs58e2LxiZ6PHSnDsobK91ZBc6i96GWKqyvg8HaTtGmO?=
 =?us-ascii?Q?xBU0ms7Synq9FOHAK61ckDHU+etJjxHeu5t/J84yPayudu4Rjr0gNvhDVgJ6?=
 =?us-ascii?Q?htUoCsBwzTTX4/trCMWr1rjyRdrVv4IQQb/0JeplXXx5wf2+Z/+2HB6MKQhh?=
 =?us-ascii?Q?nOMHb6wZswVDejeJluooHramgOeRWe9rETsVM+88MD0emxsVNOjBCOTGbFuQ?=
 =?us-ascii?Q?20XBIpnfhNMtOFRLQ8MfONSLZHf4sInAmXcio8d5sz5QhthzqopLahDRq8S/?=
 =?us-ascii?Q?9ujnKrqLQjjMYv73yq63LUWicgiPstzkKphs6UmlksSBor2Ctsfy83t4eFpy?=
 =?us-ascii?Q?qSLq2qdwVcDGdIPP3w/zOESUazJeKXGevYQYQ98ZggPZlY31/9rHrZgbF+YA?=
 =?us-ascii?Q?XlePxlX2Gas/WP10d+vBX/yeKSap+uaChKDkVyZCwgRwoFsVAe5M9W9y3h/o?=
 =?us-ascii?Q?c3kn3r/mikTjatHvXwnUXweTPDPKzIY8CNH7a5ItuKd5D5WsX3sTiQk9a6n5?=
 =?us-ascii?Q?m1pTecR1mXbOg1I0xEk4b9xKHFnyHuGhD4zTLMbEloqBqSxp0d0Yw4dxWl8I?=
 =?us-ascii?Q?px0Sb/NDuYqGDJYoe2MfP7hgfEqpUKLfa23rKWgRxtWQIwQsqQoxvKbriPcC?=
 =?us-ascii?Q?S+HJDjPB68A5Q3xYjyVeO0WEpan79NGwARS42HChZdawZqwbDcMEdFapFUhJ?=
 =?us-ascii?Q?Y0Cg9bFDGtJG5xpqD3+FiSxgj097uc0kHLfuHQOgwDjPPgmi7d70U+f0gOQN?=
 =?us-ascii?Q?Q26/99WQfOzQ/NcgJKdZAidtxNu2VA5zBJh6atHr8Nzr/Szho7Fci6jBxu1w?=
 =?us-ascii?Q?JuP9cHxewq5Cq+pBFIAdhLqZlWHl++D/UkghpkSiUSuEkvtLxib2iK+yfmDC?=
 =?us-ascii?Q?jnqDSvG7jpcI6vEXqa/mTflfu8HnliCYWV7HwEozVFf28qLhZe0sVgvzzY9D?=
 =?us-ascii?Q?TuBwDj9z+sAG+dfSlK12uOFze4SEMiQ2IN2AGDYBuvXV45sqDFYJ6bUTNa+K?=
 =?us-ascii?Q?D5lCCBnnDPPgBPIOGNxGRoJue00dOZHWe/IFsFQMkUGyBuI6aYjg/x/Q8axp?=
 =?us-ascii?Q?nuMpcYmG9d3oeqPHZrTWjfiBtVBXVMSf2cqvrzuYWFIa6cWSTAAMV8X/icv0?=
 =?us-ascii?Q?ypwzgslE6umZh8kwfTtaO/HEEe52xXdfqV9yxmOV3X9OvecYRYXms9sydceQ?=
 =?us-ascii?Q?PQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c1a5e20-0161-466e-ad67-08da91b9f36d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2022 16:48:26.7249
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kNzWMkUzq2dzk5KlA9YzVEu0tY1ooBQ6LZHHVFee93nja4vNHUXY88kgsQnWcooBP/dK/qFn2U9YzXLUY+AGmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5154
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The main purpose of this change set is to add reporting of structured
ethtool statistics counters to the felix DSA driver (see patch 11/14 for
details), as a prerequisite for extending these counters to the
eMAC/pMAC defined by the IEEE MAC Merge layer.

Along the way, the main purpose has diverged into multiple sub-purposes
which are also tackled:

- A bug fix patch submitted to "net" has made ocelot->stats_lock a spin
  lock, which is not an issue currently (all Ocelot switches are MMIO),
  but will be an issue for Colin Foster who is working on a SPI
  controlled Ocelot switch. We restore the hardware access to port stats
  to be sleepable.

- PSFP (tc-gate, tc-police) tc-flower stats on Felix use a non-converged
  procedure to access the hardware counters, although the interface is
  very similar to what is used for the port counters. Benefit from the
  logic used for the port counters, which gains us 64-bit tc-flower
  stats that are resistant to overflows.

- Also export the ndo_get_stats64 method used by the ocelot switchdev
  driver to Felix, so that ifconfig sees something hardware-based as
  well (but not 100% up to date).

- Create a new ocelot_stats.c file which groups everything stats-related
  together. Along with this, also move some other topic-specific code,
  like FDB and PTP, out of the main ocelot.c.

- Minimize the lines of code for the stats layout definitions. These
  changes alone cause the patch set to have an overall reduction of
  lines of code in the driver, even though we are adding new
  functionality as well.

Tested the port counters with lockdep and friends, with some
garden-variety traffic (ping, iperf3) and the PSFP counters with
tools/testing/selftests/drivers/net/ocelot/psfp.sh.

Vladimir Oltean (14):
  net: dsa: felix: add definitions for the stream filter counters
  net: mscc: ocelot: make access to STAT_VIEW sleepable again
  net: dsa: felix: check the 32-bit PSFP stats against overflow
  net: mscc: ocelot: report FIFO drop counters through stats->rx_dropped
  net: mscc: ocelot: sort Makefile files alphabetically
  net: mscc: ocelot: move stats code to ocelot_stats.c
  net: mscc: ocelot: unexport ocelot_port_fdb_do_dump from the common
    lib
  net: mscc: ocelot: move more PTP code from the lib to ocelot_ptp.c
  net: dsa: felix: use ocelot's ndo_get_stats64 method
  net: mscc: ocelot: exclude stats from bulk regions based on reg, not
    name
  net: mscc: ocelot: add support for all sorts of standardized counters
    present in DSA
  net: mscc: ocelot: harmonize names of SYS_COUNT_TX_AGING and
    OCELOT_STAT_TX_AGED
  net: mscc: ocelot: minimize definitions for stats
  net: mscc: ocelot: share the common stat definitions between all
    drivers

 drivers/net/dsa/ocelot/felix.c             |  55 ++
 drivers/net/dsa/ocelot/felix_vsc9959.c     | 509 +++------------
 drivers/net/dsa/ocelot/seville_vsc9953.c   | 376 +----------
 drivers/net/ethernet/mscc/Makefile         |  11 +-
 drivers/net/ethernet/mscc/ocelot.c         | 707 +--------------------
 drivers/net/ethernet/mscc/ocelot.h         |  12 +-
 drivers/net/ethernet/mscc/ocelot_net.c     |  88 +--
 drivers/net/ethernet/mscc/ocelot_ptp.c     | 481 ++++++++++++++
 drivers/net/ethernet/mscc/ocelot_stats.c   | 458 +++++++++++++
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 373 +----------
 drivers/net/ethernet/mscc/vsc7514_regs.c   |   3 +-
 include/soc/mscc/ocelot.h                  | 138 +++-
 12 files changed, 1293 insertions(+), 1918 deletions(-)
 create mode 100644 drivers/net/ethernet/mscc/ocelot_stats.c

-- 
2.34.1

