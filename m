Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 996634B3D0C
	for <lists+netdev@lfdr.de>; Sun, 13 Feb 2022 20:13:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237921AbiBMTNP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Feb 2022 14:13:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235146AbiBMTNO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Feb 2022 14:13:14 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2133.outbound.protection.outlook.com [40.107.236.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00E64593BC;
        Sun, 13 Feb 2022 11:13:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ILgNmcDXUURbki+RtWN2Xj0QkGbJgKIB+QAkfU18ENvEBj48EWyQ+oohTaQOl1GwK6UZBOqqFhPRET1zAAwSXsDiDnqHeFR6pGV0h5S3kc7e1KrL7esLZT37toWxrYVH0Mube2FxuHmZ/LoeoOFxbmdP3T9oGbn41b7siaZPbuZ38kqafceqdTWR7lukthmrKjXenOhk9fUkWzPdbtnAY+Y47wCAYJnzamq8SScgfpa6IjF4Izxjbl4YnKlGYDhaqneYyAuCSTQhQnelSpddBIDq6Eys2G2hKLLb944bEzkNinMKptvHb0vEHs3uwPxxgIhDLVHCLV6/iK7omAxSTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=44NPnjMz11N5O0z5oAnIkDpLdCjcsB3vIaHXJHKIFaA=;
 b=EJcYObmeXv5bZR0gj4vkrm+DhP2d00EjWCIC3LjtDexGseOlCVcXQ0CrcDj4pIr0LjJNdvSQJkSZjMyx9n+88EYAg7Ci0supatAca42wium1eZFUuoYOBS0rskAvrOwP2mOqywJOgIdMryE4MwQxMmM1jfPhMsMPeKKy6nOzwzPyN2QKZVBX3dE+LLOS3DeWX+tDFWbVswro1W2K+eT0cbCqiFLq22UVGicIZsx8Kj7arlev9f8T3R/rqwiyHk/oBWhltV/ftCJ4scv0gwlDyXv+NREVwfqNhA68CnV0Tntjn2aIgkN/c1Y+n08I1AN/FsGhGImE4LSfY97FuLsiYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=44NPnjMz11N5O0z5oAnIkDpLdCjcsB3vIaHXJHKIFaA=;
 b=Ijco4c1Rwr0hr/z+mFzEHa9UpOwmxhDW7BM+YUok5ffSQrTzhJpQ0Crvq8ErrTWhAYToCgKU2MDDi5YHip6lD6udvVFbUfKLoOi0MoGQekhic4PK939gjRRgcfV4fDSWa5Ye6zvTKs4fgSgU+raqExzpyi1jQPfSxpwpl2HXQTg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BN8PR10MB3315.namprd10.prod.outlook.com
 (2603:10b6:408:c8::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Sun, 13 Feb
 2022 19:13:04 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7c:dc80:7f24:67c5]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7c:dc80:7f24:67c5%6]) with mapi id 15.20.4975.012; Sun, 13 Feb 2022
 19:13:04 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v7 net-next 0/4] use bulk reads for ocelot statistics
Date:   Sun, 13 Feb 2022 11:12:50 -0800
Message-Id: <20220213191254.1480765-1-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0346.namprd04.prod.outlook.com
 (2603:10b6:303:8a::21) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 85cb9e80-981b-4702-0323-08d9ef24dc0a
X-MS-TrafficTypeDiagnostic: BN8PR10MB3315:EE_
X-Microsoft-Antispam-PRVS: <BN8PR10MB3315695F59CA31C0562D1FF7A4329@BN8PR10MB3315.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:346;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1WQgHSBYxxb/aw8owtn9lSedEA7UVcWHaQ9uwMIP9a9atwRgY35BCpuQK96v2eGhpCUCT/4nRfmiuEPHV8++ZLIv9NCM4T5oVxptsL1V1qdgYdxymiOXk4z27HIzD2/nZ4DBUs3U9TH3D0QTCCEUZUsVVxVdnBqylg5wICI6v+XlryXNpouV8aztalEIuBKzLraUHcKn3ML2OBoZap8v94fmeWtCwBfbtMiGcLT03Cm1UIct59zG174irBUubndot3ftcOaPqdGZWUbejvk4pfK7HpZZEbUcNeGe+3bATYem8kyQOC/yVp8KPDVASTMRCzapGv0xo7VhrNB6HxxoIg25T265tVGpsu78czIFy2zzqD2joQpKCw4jVX5H0EGpo/vqB3rm2hWZOk0UKvdYkw1+xeijSAQ/He6Y8UA/liwwqC/XSccfObnLv/+rEyyaJ5ymlhCUaer7SkiD6cK1yNHdWvLlbpcBjOHqbsnfY7Qt53VAdBlF8g7Q4eNz3HuzkRKfO++kzzOXVh1vE4ZR0KcwwyM6rJAVojIhcAHrOVTQEI1cdDQW++K94bYI8I0EOMAn+zZyDZr+2jFJoY1xqBbBxRBiQl/utr7Dc762JzWki3dqnxvqsUjnzO/6xDylv9c+5GMzffqSI2xv9NUcyfS9puK9ImsJAIoXWrnXVHhA9N7P53UYrUzh02reSKpjl+IelFGZeASwrB0Z8TgOwg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(136003)(42606007)(366004)(376002)(39830400003)(346002)(396003)(26005)(186003)(2616005)(508600001)(6486002)(6512007)(66556008)(66476007)(38100700002)(4326008)(66946007)(44832011)(1076003)(38350700002)(5660300002)(8676002)(36756003)(83380400001)(52116002)(6506007)(86362001)(6666004)(8936002)(2906002)(54906003)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?n3dmN+aVL6OBJKjTiseggWtEdCJdopTLAW3Kvh/txqvOG9fDQo2Y0aJLUCIA?=
 =?us-ascii?Q?Gd4RDvA6Vg0TwIpxg5beRsSsbI/UsSV5Za/B1SZQgTzERreVnncNLgwARcy7?=
 =?us-ascii?Q?yqyQdUHtxby5rz/nKzn30gEUdl1DduiqYy57dEUHVGS+qpHjucV/ZoL7wxJ6?=
 =?us-ascii?Q?fpWlBaxnfEp6gagbqMnOOU8Pcr75MVzhi5B1Xq19m/NVcC49HoWNGCzTgsGW?=
 =?us-ascii?Q?u/lzBJZfnseD4kiwbUyRrM27hyBN+BaX7+eAmQDhdXa22rgNl/G69FeuweIO?=
 =?us-ascii?Q?7X2uXtEQMpP5hYRoaSJu/42iUMXX+OR+ddv/tgPDhqslP1+D1qapAfKzbmbE?=
 =?us-ascii?Q?+LtLRj1e8YQg2xElG/n29bTqwNVh9ql1IO5x54duQpt2X+EL1FWD7ViF1pfF?=
 =?us-ascii?Q?+35hq6ttihhcDu1/GzmMQu1Q09p7OURVMyI5aLp9FvefW5ldOXxY7JpzXrwR?=
 =?us-ascii?Q?Qu4ZPCKknAbjW6r+xZScGJqS44PXibVnTfhVSf5EGh7eYsYWf4Bj/vHqKzyQ?=
 =?us-ascii?Q?fs6yOO6UKWtUGlZa5wzV6i+4dBDj3a9+6+1DFVbeXk+qt3yEsfuh4k+vYF2L?=
 =?us-ascii?Q?/lqBg70MwSwfGszDuIrgSiZtaXt5muHFfrB66Z6v13JiQJ46QeoP0Gb67nio?=
 =?us-ascii?Q?5e6Owat1dQzSJUEfeQRW7SFtGijzpxZMxZSerdWOvZ1Vd/ymXypbjQuEjCor?=
 =?us-ascii?Q?WqXGRM3TpzfGtU8fWra3wC2aYfGcSq6qPUW8k284Gg5tJyDYvTiwknCdJZd9?=
 =?us-ascii?Q?Uy12wOLDG9Ftl9Y1TU2NAWqfsQK+8Q84rhMFJMh8XageCIXwa2iYUxlbFAOJ?=
 =?us-ascii?Q?bombIEpMIPvnzdrmAaNINwHRDbdB9tA8o4RXk1O+LLqoLvYlM6Rp71q2jpCr?=
 =?us-ascii?Q?mrUNYnpGPwZGM7T8QOhIhyNtxdXEyn8vc0ZxE6qlMnRvh6j4V+waN8ZX8eF2?=
 =?us-ascii?Q?xYUQY/3WSTXvWnQ9KQpxC7pGiRnK/tS//uEs4lFTc2slGDG3qjAng02bwFDq?=
 =?us-ascii?Q?EAYhlO3Y1QXnTA07XHi4DEEEtpCTRYLXbbM2oWISPNW37I2vvKlvbMOlvTuM?=
 =?us-ascii?Q?0HEy/271VLSAfCOtKlkKEoomd72B9dZAmEmaPY/IUIaIvVQvr/PqeeL8JLTR?=
 =?us-ascii?Q?+QoPJyGiDiklMVCKeZ8nXgeVRBJ6KqBe1peXSLrI+5QXaLNa56wMQqVqzoYI?=
 =?us-ascii?Q?LdHbaJjRMYwhP+7b3DIXNCisIwrez3HvdCuxefLpqcqCshBQ+SeLqXU+rd+K?=
 =?us-ascii?Q?LZQJ0sHIEAcCwwgIApIiwUzqtOFFPGRxLJ4L3cfpQm/UFgVSYS3oyxCBpKZq?=
 =?us-ascii?Q?CUz/VpVZjK9xvO/CaiGAjFAzYMI5R81gu2mTW1yP8upM9K/FNLbQ+4CcFp3W?=
 =?us-ascii?Q?2Cn40u2qwgAn2Bs6E1iRQV+WTssu42aPLZliBfdgxzah/YG2Y2A1c4gd6S23?=
 =?us-ascii?Q?Z/aVW+qK9EXXyltUrd42kBq2FZfd2D10xJgcc3AMygHdjR4591cILXwMdxci?=
 =?us-ascii?Q?dvhnxPt0JsQQwQCCTkCn6Vvz+98GDDf6ti8zYghEPV18Rg4e5oUvggiADTML?=
 =?us-ascii?Q?lCFgYiEjpwZ0G/jM+pTBJIFqXLGIXmUaoGXpyy2aVHKSi+6/Op7LS5QOMUG3?=
 =?us-ascii?Q?govxM1PeOhQokmKNvN1NTH0HiYlzenSLFBCN77LxpP+l/j4FBRNQ/5aQGgAa?=
 =?us-ascii?Q?oxzVtw=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85cb9e80-981b-4702-0323-08d9ef24dc0a
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2022 19:13:04.1171
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N75LMbB/wzHO5atln4ETC1FgLUuEDb8z6BNNE+Q+Rrz3tV+AlFUaiYhPTmIpcurlgQw4jwiM3UPPNBe2sAC6awwwHpeWMGDoZLU/O+GqzeI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3315
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ocelot loops over memory regions to gather stats on different ports.
These regions are mostly continuous, and are ordered. This patch set
uses that information to break the stats reads into regions that can get
read in bulk.

The motiviation is for general cleanup, but also for SPI. Performing two
back-to-back reads on a SPI bus require toggling the CS line, holding,
re-toggling the CS line, sending 3 address bytes, sending N padding
bytes, then actually performing the read. Bulk reads could reduce almost
all of that overhead, but require that the reads are performed via
regmap_bulk_read.

Verified with eth0 hooked up to the CPU port:
# ethtool -S eth0 | grep -v ": 0"
NIC statistics:
     Good Rx Frames: 905
     Rx Octets: 78848
     Good Tx Frames: 691
     Tx Octets: 52516
     Rx + Tx 65-127 Octet Frames: 1574
     Rx + Tx 128-255 Octet Frames: 22
     Net Octets: 131364
     Rx DMA chan 0: head_enqueue: 1
     Rx DMA chan 0: tail_enqueue: 1032
     Rx DMA chan 0: busy_dequeue: 628
     Rx DMA chan 0: good_dequeue: 905
     Tx DMA chan 0: head_enqueue: 346
     Tx DMA chan 0: tail_enqueue: 345
     Tx DMA chan 0: misqueued: 345
     Tx DMA chan 0: empty_dequeue: 346
     Tx DMA chan 0: good_dequeue: 691
     p00_rx_octets: 52516
     p00_rx_unicast: 691
     p00_rx_frames_65_to_127_octets: 691
     p00_tx_octets: 78848
     p00_tx_unicast: 905
     p00_tx_frames_65_to_127_octets: 883
     p00_tx_frames_128_255_octets: 22
     p00_tx_green_prio_0: 905

And with swp2 connected to swp3 with STP enabled:
# ethtool -S swp2 | grep -v ": 0"
NIC statistics:
     tx_packets: 379
     tx_bytes: 19708
     rx_packets: 1
     rx_bytes: 46
     rx_octets: 64
     rx_multicast: 1
     rx_frames_below_65_octets: 1
     rx_classified_drops: 1
     tx_octets: 44630
     tx_multicast: 387
     tx_broadcast: 290
     tx_frames_below_65_octets: 379
     tx_frames_65_to_127_octets: 294
     tx_frames_128_255_octets: 4
     tx_green_prio_0: 298
     tx_green_prio_7: 379
# ethtool -S swp3 | grep -v ": 0"
NIC statistics:
     tx_packets: 1
     tx_bytes: 52
     rx_packets: 713
     rx_bytes: 34148
     rx_octets: 46982
     rx_multicast: 407
     rx_broadcast: 306
     rx_frames_below_65_octets: 399
     rx_frames_65_to_127_octets: 310
     rx_frames_128_to_255_octets: 4
     rx_classified_drops: 399
     rx_green_prio_0: 314
     tx_octets: 64
     tx_multicast: 1
     tx_frames_below_65_octets: 1
     tx_green_prio_7: 1


v1 > v2: reword commit messages
v2 > v3: correctly mark this for net-next when sending
v3 > v4: calloc array instead of zalloc per review
v4 > v5:
    Apply CR suggestions for whitespace
    Fix calloc / zalloc mixup
    Properly destroy workqueues
    Add third commit to split long macros
v5 > v6:
    Fix functionality - v5 was improperly tested
    Add bugfix for ethtool mutex lock
    Remove unnecessary ethtool stats reads
v6 > v7:
    Remove mutex bug patch that was applied via net
    Rename function based on CR
    Add missed error check



Colin Foster (4):
  net: mscc: ocelot: remove unnecessary stat reading from ethtool
  net: ocelot: align macros for consistency
  net: mscc: ocelot: add ability to perform bulk reads
  net: mscc: ocelot: use bulk reads for stats

 drivers/net/ethernet/mscc/ocelot.c    | 95 ++++++++++++++++++++++-----
 drivers/net/ethernet/mscc/ocelot_io.c | 13 ++++
 include/soc/mscc/ocelot.h             | 57 +++++++++++-----
 3 files changed, 133 insertions(+), 32 deletions(-)

-- 
2.25.1

