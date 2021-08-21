Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4D283F3CB0
	for <lists+netdev@lfdr.de>; Sun, 22 Aug 2021 01:08:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231481AbhHUXG3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Aug 2021 19:06:29 -0400
Received: from mail-eopbgr140053.outbound.protection.outlook.com ([40.107.14.53]:31556
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231314AbhHUXGY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Aug 2021 19:06:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VJZNMTZoZgqPmhmAmC/M9PT5pGN95HDaJtqOK1riEM5BGQwNlFO6rJKiRb6J3jX82K1+YNjdc1YYKnOIOYLBDLB1FxrvfREfYDJ3xOazXGvZwK08+kd7XO7pDq2+UE8eCSTYkpawRxhfdNMQjGTuQCtnIic2oHuZDq5M1SwqtHBfmyCEqhHNU++eXK4Yv8P/AxZGNilrTIqxCkLrTuTr5w6XzBqkLV02ixlddKl+GtTMQjyBdxizItZmSt9J8eo76JiTxp0PvUVkxShMeBxu/unMxHwxU33AO/6KWqgl+c0ihlc61Vuj0/hj4cDJx6xrPxQ9cU9JmHDXnfGjgM+4AA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b6PTMTxvGQQuOiHFRbqbjdinXJtGTBS3VqJ1laN9eTQ=;
 b=IgwgroGRyDZERwdwoVaAm7hU2uCJd5JvWo/qknPvDuN7UAv3ehd7s0htMsIHuShCVVL04PePvxYxlA4jG6Ci+kMSLruMmOpPxVWPvt3KMhfz4as7g3uWnYx+Td+wQmrJqJtr0CAMdzWoR6PipMqmMRTe+TmAltvB95d/pg0IWghSeMZOrENoetN/qX0gCodu75Apnxtqje5DBuOco6Pfyu4xKv9mllvdcDiLFQ+Jp+yC0XG5o1goynHLBSXwlYbhMsSzk0kIf9bUZLCqY2imlTf8zrLk4+3CD4DiLfL7gAhlGcJLaVYe0/P0ZDCL1S+VnrnasQ/wUqx9/z0cSDQoMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b6PTMTxvGQQuOiHFRbqbjdinXJtGTBS3VqJ1laN9eTQ=;
 b=j+HlThJLvttKg01Br/K1/QL9ncWwUILZozBzleye4Y8xSIG/MquRyG8IZz39gYAq61/+YQ914dJA2HI2L/9+zdj9uG0UwluofL1CjFOcgIxXE/zxhhPNP98dotvpgxjbDnLwD+Llqq++1UTAWfitQex5QSUkwefGyl129TZtcyY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5133.eurprd04.prod.outlook.com (2603:10a6:803:5a::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.22; Sat, 21 Aug
 2021 23:05:39 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4436.022; Sat, 21 Aug 2021
 23:05:39 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Subject: [PATCH net-next 4/4] docs: net: dsa: document the new methods for bridge TX forwarding offload
Date:   Sun, 22 Aug 2021 02:04:41 +0300
Message-Id: <20210821230441.1371168-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210821230441.1371168-1-vladimir.oltean@nxp.com>
References: <20210821230441.1371168-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0501CA0047.eurprd05.prod.outlook.com
 (2603:10a6:200:68::15) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM4PR0501CA0047.eurprd05.prod.outlook.com (2603:10a6:200:68::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Sat, 21 Aug 2021 23:05:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a0679cca-03f1-432e-8d3e-08d964f83189
X-MS-TrafficTypeDiagnostic: VI1PR04MB5133:
X-Microsoft-Antispam-PRVS: <VI1PR04MB513335C91D36A08FC38FDBF0E0C29@VI1PR04MB5133.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WOUMulVu0LWjIhzJhKqqETsD1GTKFFy+yPDUPnLIax+/2LSwDX1T+8MBSFcrL1mZRYGs/SEUJ320DD0hDdmkDlZH9mzBSSvsAn0D9pV10wJnEnopVbCFd5xxpig56u0z0ELYuddBvp80vFdhwwzbPW4prtVwivQDrYP3We00+6ODRBuum/QpXElwmZFxD+ciCeu6utL2biZcsYkoLf1XXA34oQ9BFEBCtRzhRWBkgye/BnAmR+e57Z43u+82seH2Pin7no1FjmQg54buMJ5rhwWxQPujnFHinOb5wAYc5uJ8coHlt0380BSgW4iIT+vzn1DK5nRIlnMqZsj71MJNnYWcHn8IoficgZiAXeNw0n7pAAW4PJJu0+d8D8f9nTr4Uq8+vxlSM1hpdKItIT3oKteaZ20t91pjAyG4jPpbKiMO/LE6b1r0w7iw80EvS5a5hBrXonvTjXg+WFRgaPp49OYzA7Znf/V64b+l9wqACsfAOQnXquQucZCoq7vRRmxsxNcqkWXsBFTJXfrQqWVX4jPzNmXQyRpWY/ScJdDu/lsJahxGsbPpjMRJAlH09VALJXA2a8cs7/s/efkb9o+NJG41vDig3nMC2XmqBRMQInER/6jpY7njCOmRSYzpMUae3TYcv2x//bSZeQfqLanfyZlkH31PnF6Djze3wHIfVbvsNwr34YDJatSqB/FyfRRObADVoJ2OzE4JyJhlxYH0ew==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(366004)(39850400004)(346002)(396003)(66556008)(66476007)(86362001)(66946007)(2616005)(956004)(44832011)(38100700002)(38350700002)(316002)(6486002)(1076003)(6512007)(478600001)(83380400001)(36756003)(6666004)(6506007)(52116002)(6916009)(26005)(186003)(8676002)(8936002)(2906002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ouhOAUl92JVR1vYA3usce6bzLo5OenEuCDcT3tkqQQYVe3kDJIWHSxIbqLIf?=
 =?us-ascii?Q?ARVIFdwIZWc/SinHaLaATzUgT+osyI86pCW8qNSM9lXEn+RC5YMS2rIbPnzk?=
 =?us-ascii?Q?DBYHMcpHY/uNsI0vbhmzPXc+LWuqmcM7NjX5HN+9l0jLFE0Ia0uKHShQBnl5?=
 =?us-ascii?Q?LqUGBULpWra5/8F9b9TE8dvdfDTPJryXIvhWgsNO6GYs4oSqlmBDulxawQYn?=
 =?us-ascii?Q?/mtXj88++bKXudaCS00/aJkwbX9dqFqbfgushIKvvV1y8Nbjv1s10mucDGeN?=
 =?us-ascii?Q?HueaKNNXaYiaxi6mCkrBOK+R1G6chRUwieQRahG9TSJOpnfhHv5YYFgtUtsk?=
 =?us-ascii?Q?i+N2uJIgCqSObM3YygjrUwSx6ut6Bgqn8mzFTO+Nsr0oOcN1GQza4A4rY3hO?=
 =?us-ascii?Q?ZNeR1xh67jyWJfqDXhub6bUtqwSXb0UE0VCDyFHJEd0YRzhUESgd8JBq8NSg?=
 =?us-ascii?Q?tuQdkS6vOV8GII202YtSAAXeV3g0nQGpQTtDNEnCHx7NfM7WdV08c0pvBve6?=
 =?us-ascii?Q?lF/d5gG+L1gteV/CErwnnilQ84b5rWKM6zoRCdFvKKYmONld7zZkAC/EpdPc?=
 =?us-ascii?Q?LZCcvEnws12iwNBCOkXOi8toPMdb3vZKENqz+uN3DRDc4HM1FOzwmpLJAwqo?=
 =?us-ascii?Q?jWrbym4lVZtJo3MsdRh1yBuPRiLBH6NuPbHLF8nP6NvSGrWv79FUmjvZfaEr?=
 =?us-ascii?Q?laXMhRiDPfL2zhPshOjl4LyTh6BoAtrH/rkg6C1UV/mF9m97S2glDBE9qcPK?=
 =?us-ascii?Q?IEHr1aVaX3BDxqRyMT3P5u3y1Wrr83GsvpTnfIDZU4nFXvlGmEDY1WNiycNR?=
 =?us-ascii?Q?TM7DEjCTtuTABR73Yh1hsrwKUZMON/mN3SKnxpxnt9JU0Z8ewuLC4+AoORYm?=
 =?us-ascii?Q?Cu8ptaMkJo4Ox0udHvqQ5DyRuOjfF1zXZxtGZFXe+xSLHptFUYhSkoECjpIH?=
 =?us-ascii?Q?DThT6eWOQ7CKglBdz5cmxNx2V72Y7oS5PvDAX3rCRdBhjTZ4RimsuJWayjAN?=
 =?us-ascii?Q?wV3TR8aYvEIEWjmAG5KMo2w20A/0TfdbdIgDt7yF0OrvKwG/bQXY3De0KeIp?=
 =?us-ascii?Q?OP2wHenUTBrxY4emucjEirrnckErhLhFoglmhqXBQ+ZE/7xtCPIJ1ykEH+YQ?=
 =?us-ascii?Q?f96QFiw9j/cIJjKp6f4rH+898g2zsoAJTMQdwNJ2DO81ag+ZoHjYWXsOjKd6?=
 =?us-ascii?Q?zQNVjy66ejAqwNxDCLSr0aqHhqZayVQ3l1DwvC2BQWKu9xiKfZZG4nr8fTHt?=
 =?us-ascii?Q?QHdQIYBLJmt2i2wdvF3F+tMdGdrZaNuzn/JV0+0y+8HjL9W+EwWAMu7bh1FP?=
 =?us-ascii?Q?T8ALZsRkbvgdJD+SL1g2CMNp?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0679cca-03f1-432e-8d3e-08d964f83189
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2021 23:05:39.6800
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nfa2dXQuEQHj+qLPXWBaxeEsPCXrIk5eyq23nqVonJcPpm3FHgJopzLqqmLo8n25VBJ3FkV0JYrS5xHzpXfNZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5133
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Two new methods have been introduced, add some verbiage about what they do.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 Documentation/networking/dsa/dsa.rst | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/Documentation/networking/dsa/dsa.rst b/Documentation/networking/dsa/dsa.rst
index b64cb4068c13..89bb4fa4c362 100644
--- a/Documentation/networking/dsa/dsa.rst
+++ b/Documentation/networking/dsa/dsa.rst
@@ -650,6 +650,22 @@ Bridge layer
   CPU port, and flooding towards the CPU port should also be enabled, due to a
   lack of an explicit address filtering mechanism in the DSA core.
 
+- ``port_bridge_tx_fwd_offload``: bridge layer function invoked after
+  ``port_bridge_join`` when a driver sets ``ds->num_fwd_offloading_bridges`` to
+  a non-zero value. Returning success in this function activates the TX
+  forwarding offload bridge feature for this port, which enables the tagging
+  protocol driver to inject data plane packets towards the bridging domain that
+  the port is a part of. Data plane packets are subject to FDB lookup, hardware
+  learning on the CPU port, and do not override the port STP state.
+  Additionally, replication of data plane packets (multicast, flooding) is
+  handled in hardware and the bridge driver will transmit a single skb for each
+  packet that needs replication. The method is provided as a configuration
+  point for drivers that need to configure the hardware for enabling this
+  feature.
+
+- ``port_bridge_tx_fwd_unoffload``: bridge layer function invoken when a driver
+  leaves a bridge port which had the TX forwarding offload feature enabled.
+
 Bridge VLAN filtering
 ---------------------
 
-- 
2.25.1

