Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 222055B6109
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 20:35:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbiILSe4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 14:34:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbiILSd3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 14:33:29 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20042.outbound.protection.outlook.com [40.107.2.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 080FE17A9C
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 11:30:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ATUXOCzISiJclRqP9KeXW0LADfqdGkAlEby5Uhp32FSSaWoV5n1X3bPmkhee7J4BAtOqtz4DPDcOy4LFmKC1ggYc1j+sMYrhvKr0yQR3KvJx74pFF4kheHlD1JDDFSWKuCFWt/gOcnaultiLSyoMkXBPQRcm1NqUJaNUxUVSiNN9xOxZ2ucO5BWjnp95FUV0nWu28dEZFC6/04bIx2LiJX97+4kLsn46nwqdoQ0JwTdEb/IS94Z/pjMiWelKDdtuit6J3miz36EhhJ1VqXegbE6aTzJKBfiWraoqD4xvoP42L92KiXIx9fZWJNWwBneeWlvHTQNhbeXkII/6l2UhHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+W4kPV7/nBCdAUoJnhh4j2Oy1d8ncRZREkqlBqr7tIU=;
 b=GRCC+M5r3SqmeRMVC/tzrFbpCJXS2ChVSBi2iDb3H/WsJExX4phL8BxZQTqdy9mz4Z927RrHoV8il1SWLkdpPSbtT0WEFNbZm3dgiXLUUHjargnRhU+Bz92R5iko/HunEaIbVCkUwjKzqwIIapThW7b9wh2I0ZZ6Td3NBhy0zXoQLfQtCs4335ISuWsEAdZoN8SAUyPIzfKNv1kDg9iwEwFjeQwCbBBiiEv72HzvQhQ5KGZ8welj1x1LAuP8YXwnld25LK3zv7ltVG+lviv43rVMamXcIAD9ZHwcgyD4VZ5UZWJJQj3QPl+iq1QzAHiZ7KXl4dicxoHv56DOe6Igtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+W4kPV7/nBCdAUoJnhh4j2Oy1d8ncRZREkqlBqr7tIU=;
 b=DDVNOKQmLqj+5BZ+NHlzaQ0w2M9zdYHeab0iB1GquPFxwAYnu8RnSt4Ysg/twyjj9N4UvBRr+dcRvPatJDheV4cfnMsf3XWLdcht1K8eMHDMw8P1vwTG8Dd4Iykqvg/BB80Snu5ALPBILofDJbUZS22NEMt/buZW9xU+vwMmg1U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com (2603:10a6:150:1e::22)
 by AS8PR04MB8023.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Mon, 12 Sep
 2022 18:28:51 +0000
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::d06:e64e:5f94:eb90]) by GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::d06:e64e:5f94:eb90%4]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 18:28:50 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 00/12] net: dpaa2-eth: AF_XDP zero-copy support
Date:   Mon, 12 Sep 2022 21:28:17 +0300
Message-Id: <20220912182829.160715-1-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.33.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P190CA0009.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5de::16) To GV1PR04MB9055.eurprd04.prod.outlook.com
 (2603:10a6:150:1e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV1PR04MB9055:EE_|AS8PR04MB8023:EE_
X-MS-Office365-Filtering-Correlation-Id: d5f7f0d2-d4b4-4185-de21-08da94eca394
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TgLj1W1dRybAjy0zLZ9DUQ9vdB/qZOT4YlUXb1ZF/eEhf9tiQr7Ug69eOm56AIKtLUYwXILRGNqIGSv82HmKHuwJv/DHKDPQxVbL0Ptwxz68nOBNiMjCCo/yPKEFQKCP6CFgOaGoozd36CC5uvYGVJe7cPbo4kRmUN0e3V2bcTfINNCej7T2J414Gq9hPYmqymWA7vcWZCoymZVlJd5T/xcMin+JF1VQS3JGngn/H/iTP5WCXl+CF8aqL2DizgJXuevKCEMSOmb/XxYSswqQ4393KDLqpRn0fidm9rX3+2msSX2XADGOoB19CDGoVwb0NBtw8hXI06l+i6PK04aJE+3Dj4gtAubB+EtzgHuv2ddQsZIsK9LsNUuQOSzpzg12W+SsVYaXxyswzdSfen1gWUyGwR3oIYx74oPKkHf2XDZ7WdKaQkGm0F/+8ogsaQA+JVH2c0TdOOftXo+TjLLAMVDwompyyCmGS1O6XR0U8IMFG7wxh7rn1BgkyBzaCWRTQS7/PzU2ZPLCus1OAmLafdgxTg9lcLf2lQw8d8RqNOMF6E61MGPMAxm9NPqkLTXPX5Yo1F43Q8o8dBIW/xk8ilPIo3dK1XUhil2JpgLD3Nf58WPjDVWHc0+dATSBlT4++GAFuJkYIMP7OwALFhVX1NOJAR56M1QgZQG3TG3YFuR09cZu/1KYa2rKry2MljKdmDO8/xN4WFQuDGcSM/KK/K9NmGBHXzbA4o4j/q0vMKALQHSNd8zkY3PXlD5nbLg7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9055.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(136003)(376002)(396003)(346002)(451199015)(4326008)(5660300002)(8936002)(2616005)(6486002)(1076003)(2906002)(8676002)(6666004)(316002)(36756003)(41300700001)(86362001)(38350700002)(38100700002)(66476007)(44832011)(6506007)(6512007)(66556008)(186003)(66946007)(52116002)(478600001)(83380400001)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xcRnme5GoRwb00FqroRKfBx2fIkG+Wcc01wEfp9PnVWDekNPOzPYgs1qvqms?=
 =?us-ascii?Q?B7txf+gY0aWIw6GeVK0o0TW8Duw0vHjd6NCqUHGGYyQoXRs8p/9/rUAkNYMi?=
 =?us-ascii?Q?s2zDw6IiAbi2Ro+/dhvwZLnxnSqurorwWFmM8SGYIrggg+K1WAczybCw9UDO?=
 =?us-ascii?Q?ePZBNn95KsrxB79aweOH7loL17Kr5Mf1TEh8idpEuOQPhNwmiyQUDB0FAjqT?=
 =?us-ascii?Q?oeA/7pb2dj3JkNnW6AYUvF7C3T5btM7LTdGt+R8yDpHxt8jMo+lFtEG3HDZL?=
 =?us-ascii?Q?eXZ1OloECuJ15yPRwuZXBDCNQN1P0fUnJHipNMNJAT6+lFRnkOL3oWgKohIT?=
 =?us-ascii?Q?IhbQqj7l7bwLA81ZCSoyZ3SPpQ5L7TCawyYDWFkA8aULIEecFd6AUSr4LuUm?=
 =?us-ascii?Q?ll2gGJaIErbU4hJO+dnOOomE/4EsZi84T1+lWfW7KT4i9eugBC1mq6e1zvve?=
 =?us-ascii?Q?sfV8bICTIItH3ZsWSz1t1ktEmr9eylsmxiVa05/sJxdUtKn+9zcdPFoyXSJR?=
 =?us-ascii?Q?wDqrVaefsv6tE6EW+G8i1Jz3fpP8L7wrYN3Bqzw3EgnqQxCU/VLRDTbT5KP1?=
 =?us-ascii?Q?AWD2T5R+lHhAuWE/ymwW7Sy8KmzacHv8KA8grXjh0YvkMaiKZpQOJLMnKZgU?=
 =?us-ascii?Q?t+VXYQam0s3mjGJlBh2lKl69dFj+Tgd/KPsS0PszK4D89lGtjKf1fAtH0f7i?=
 =?us-ascii?Q?40zCi7c0zsuQeKiyTzRgbIQxO0N3yrlaUCJ3wEWZTafTG7V6B7m5W4MKCj07?=
 =?us-ascii?Q?gfDLnpaFjlaXODwDU2lBEv2Z2tGgdHv8XfUtu80yYn5wM6jFgfp3xQSqPISo?=
 =?us-ascii?Q?HxjukzEgiwX3IFKPCH7lVhSd9sMoR0Z61dcZiH2liAlBFyU/rLETR9v8DVS1?=
 =?us-ascii?Q?FUEtsZST+L/UeUSxP9g7H1/jUXjOdTQwbDAs0xMqNejsGdwpYijyfyBn7JFz?=
 =?us-ascii?Q?pzsCaq2z9jw8Sx0oJi4A2FhjrV5LV5OYB+pBSjW8av7akzkpxOwdjt+W4yiq?=
 =?us-ascii?Q?sqzG/nSObqajF60Enu8D3P1KULvFgHA6jwLKNjEd6qAfkXeFCZRiwV3lrhv0?=
 =?us-ascii?Q?nX8l1NBIORSbmW4MxRh9v3IJJWI+sf8Zl/VIjEh2Y5m4noFtL37AJGT/Qorj?=
 =?us-ascii?Q?7HSmv8PXQZJp/CtFBgtzcQRx6fure9OM/zpy4XXf0z0Z7Apchla4kXkX+zHk?=
 =?us-ascii?Q?u2vnlPEOatHmjA/3tgYuOWcPDMCTpx8UrO0kt8Q0jezTkOS3d1p7b4cxmFXt?=
 =?us-ascii?Q?lUDP2zeAtmcGS8F/bMFs9h/EVgvA3bpiTONH5mv1jgpu4z3X/qRec/1Ckyjv?=
 =?us-ascii?Q?3DSAvY9uhQ3JYZmRAuHnqzl/h9E4dQhkt+3jIo6imxcqzZmUXmR/nOyOGsFo?=
 =?us-ascii?Q?2TNLxH0BGXkCwZvhFtUyaqGmlgHiyBZH05AuJLWLToM0fAWLC8vfxaoKssth?=
 =?us-ascii?Q?qSBFOivREzB84PbO+Noq6YIySvmlMlZHkXxLKy+i7cd5rA0tMoFqp0YMhxDg?=
 =?us-ascii?Q?om38RkucgGRVmXi8eCQKcJ4xY2gfBce4/y2BUlKN7p6Sdd/o5Bo5I43Y8nM3?=
 =?us-ascii?Q?ox0o25VPrY1cb5mQFoS4k/tXmV325gn89G0H6ix5?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5f7f0d2-d4b4-4185-de21-08da94eca394
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9055.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2022 18:28:50.6793
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TZzzrRcMsssp5ufqLOKSS1Lmzc9zKiFrO81sx8W9h5syvxahdwa7ad6M6PfatTLaH5aevC/GeoISZWetD3m7og==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8023
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set adds support for AF_XDP zero-copy in the dpaa2-eth
driver. The support is available on the LX2160A SoC and its variants and
only on interfaces (DPNIs) with a maximum of 8 queues (HW limitations
are the root cause).

We are first implementing the .get_channels() callback since this a
dependency for further work.

Patches 2-3 are working on making the necessary changes for multiple
buffer pools on a single interface. By default, without an AF_XDP socket
attached, only a single buffer pool will be used and shared between all
the queues. The changes in the functions are made in this patch, but the
actual allocation and setup of a new BP is done in patch#10.

Patches 4-5 are improving the information exposed in debugfs. We are
exposing a new file to show which buffer pool is used by what channels
and how many buffers it currently has.

The 6th patch updates the dpni_set_pools() firmware API so that we are
capable of setting up a different buffer per queue in later patches.

In the 7th patch the generic dev_open/close APIs are used instead of the
dpaa2-eth internal ones.

Patches 8-9 are rearranging the existing code in dpaa2-eth.c in order to
create new functions which will be used in the XSK implementation in
dpaa2-xsk.c

Finally, the last 3 patches are adding the actual support for both the
Rx and Tx path of AF_XDP zero-copy and some associated tracepoints.
Details on the implementation can be found in the actual patch.

Ioana Ciornei (4):
  net: dpaa2-eth: rearrange variable in dpaa2_eth_get_ethtool_stats
  net: dpaa2-eth: export the CH#<index> in the 'ch_stats' debug file
  net: dpaa2-eth: export buffer pool info into a new debugfs file
  net: dpaa2-eth: use dev_close/open instead of the internal functions

Robert-Ionut Alexa (8):
  net: dpaa2-eth: add support to query the number of queues through
    ethtool
  net: dpaa2-eth: add support for multiple buffer pools per DPNI
  net: dpaa2-eth: update the dpni_set_pools() API to support per QDBIN
    pools
  net: dpaa2-eth: create and export the dpaa2_eth_alloc_skb function
  net: dpaa2-eth: create and export the dpaa2_eth_receive_skb() function
  net: dpaa2-eth: AF_XDP RX zero copy support
  net: dpaa2-eth: AF_XDP TX zero copy support
  net: dpaa2-eth: add trace points on XSK events

 MAINTAINERS                                   |   1 +
 drivers/net/ethernet/freescale/dpaa2/Makefile |   2 +-
 .../freescale/dpaa2/dpaa2-eth-debugfs.c       |  57 ++-
 .../freescale/dpaa2/dpaa2-eth-trace.h         | 142 ++++--
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 479 ++++++++++++------
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.h  |  98 +++-
 .../ethernet/freescale/dpaa2/dpaa2-ethtool.c  |  58 ++-
 .../net/ethernet/freescale/dpaa2/dpaa2-xsk.c  | 452 +++++++++++++++++
 .../net/ethernet/freescale/dpaa2/dpni-cmd.h   |  19 +-
 drivers/net/ethernet/freescale/dpaa2/dpni.c   |   6 +-
 drivers/net/ethernet/freescale/dpaa2/dpni.h   |   9 +
 11 files changed, 1081 insertions(+), 242 deletions(-)
 create mode 100644 drivers/net/ethernet/freescale/dpaa2/dpaa2-xsk.c

-- 
2.33.1

