Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E18AA66D926
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 10:03:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235963AbjAQJDZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 04:03:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235986AbjAQJB2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 04:01:28 -0500
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2081.outbound.protection.outlook.com [40.107.247.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01933301A5;
        Tue, 17 Jan 2023 01:00:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cLaOqZIWGHpEwn5uuowZTdvj9tUP/twnZo7kjtMawGurw7BiO+ozk1UUUdbG+1n97YV+FBitG1V/h4QO0OBx5PULe4pCGr1I24hoDH+jG9fvEXEKNj/H6efEdmHJGVqoWpvv9Vd65huqzSMLsMAN6MIws+gIGDwOUdzLwANvrLk5a7ZOcZyNE/0dXTyUoO5+GmWFa8aZhTDqCWEv9Ksq6zcSG52JsTLYhh8zlIzrFzwliMiXiKo23sWyQbJB2iTlpb72fA9eNlF0ZCNNDdHcBMFx4RuF4nn3Ypvf4j3kXIwJGrnWZU0Yv9wM+sfqlnGmaVZVYtvd1HsdSKsKOA4wKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CHxLwuUqBuXH013xgu0M6un9FR7oCkd6yEnY9NF5pc4=;
 b=nXeeZ7UeQawDbHiR+wvn2Y4iV0Sqtuyv36bleFuhsbZF6C/C41YuywwP7NT/iK4X9zNn9SK3cZBtAS3O3uAtkHJQPdauDgBuHIGy9c9ytWwVR61PHFISaqf4ROQ98mqwaY0rt73q9TCZWCi7wDH761Qp8jq9HaHFz6ebwS3bJ9CSdC3dVJ7spIzcUr1JC00GVoSO2KDHmER/2ZY2HxfbaLm/7mXeCjH316cCMjnlqJ/cROjJB+twBXk00BDt70Kgt5gd01SLfIoOsMihVzShwPodNLODiWC6ujptdniozgyRvR8Ale+dOl5ok+iCFnikAQzOG/OPMSdykZYyw28ZuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CHxLwuUqBuXH013xgu0M6un9FR7oCkd6yEnY9NF5pc4=;
 b=RCEDQGSr2hPR4GXoY8AKqZb2Qr4jXVSa+yKLnlU5qR1CJ2uMsIHPt4dK5pv7B5jTR7ey4hGboaHGBSLP4c9rJn/TgbcoqvVBQoe1sKtDZEOGccRsapJcODrQ/vwYf8U7jU0utQpcE7SWSzHmAG3LXJkUDPAKgmjHaaTUthd/OcA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB9304.eurprd04.prod.outlook.com (2603:10a6:102:2b6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Tue, 17 Jan
 2023 09:00:03 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.5986.023; Tue, 17 Jan 2023
 09:00:03 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Rui Sousa <rui.sousa@nxp.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH v3 net-next 03/12] docs: ethtool-netlink: document interface for MAC Merge layer
Date:   Tue, 17 Jan 2023 10:59:38 +0200
Message-Id: <20230117085947.2176464-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230117085947.2176464-1-vladimir.oltean@nxp.com>
References: <20230117085947.2176464-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0115.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7b::9) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB9304:EE_
X-MS-Office365-Filtering-Correlation-Id: a1449309-91b6-46df-a042-08daf86938ca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q8RQXJ+Ai8/5u9t8ZY+6A7O4fIPKdWSk+ItiZ53tx69w9+kMzaSoBzHVanj5A6c5nE4aDQVQI1yRysfcWr6T/rNXuDt36Tq/r80roEYquhSDu4iGOe9IWGJlUl+xZcp/aEHELGS1vmXR8XEBEn6+8FLK6ONOLNY5hpd8vydyeBtmqafTUwOzMW6wO9RkH8j4aWXtHkpUt6lzXwmKdsSpnhl5Pa7F/7Lr9qkiEmxF2VcS7n1xYrNVEokzCtbQA4ff0rC67KVX3GI2R8CZbXYLxyLNxkNOVt5hBtiSosKFD9OoamQxCKK8pfIBPA/ufeEjcSZjkHBYf9Wf0adbH/KNKEhjhD9oqQ2OvRWISR5f+KFoE5xCiIB5Vq/fZ3aRDBVvZ+Qi8EJ/1DMGcZsT9FrjV+gDtTxb25+uVSJE92zXcs5TcpT7e96p5pjRMj9L+Y1SZycxnwbSDjR68sBn4hfor3r1tEXDnjflydydfwA0HSiBKg9LFAFBPzT3uUf/fQwI9M6pu++BRfLJ3cWJLMLNEfwMC80/cFwJSryrTB5pdgXqRwDtLlrdCZCQHYDyXCC36uoUTVPVgCX1QWW4PEVOC+IiN7UyfXKlwahGJ8NzQ1NJLUPdBTNDz3SAQgQyIy//YRTM5KwGm1rwCZZ7VgYvLGlRbJmKDiqfM9A1FkGSWEwv3kbmNvzdlQKyQDecbkOPJtKQfWGw+W8L+IQE0I+5pQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(376002)(136003)(366004)(39860400002)(451199015)(6486002)(6512007)(478600001)(186003)(26005)(6666004)(52116002)(6506007)(66556008)(2616005)(66946007)(66476007)(316002)(54906003)(8676002)(6916009)(4326008)(36756003)(83380400001)(41300700001)(8936002)(44832011)(1076003)(2906002)(7416002)(38350700002)(38100700002)(5660300002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?N7uJp7BLOBh6+vnocTh7Ig15MKDoLdjLJHWMYJoKgadbHXH600owiRCmlX4a?=
 =?us-ascii?Q?tQTlIxNbnJJCAhS2uH1g01EqIBPukyP7wQGe2NCL3nFeFJLHrCndvj9MRLoo?=
 =?us-ascii?Q?lEqQdMoAS+zwRxGM770ouh0iZo+Dr/WOQaRVc3grgthf/2FfUmwdQ5h8hYuy?=
 =?us-ascii?Q?JGF68kghrXulV9vIY/2Y/Fp/dlTQe8DsLq+G+EbrRWCZl2reDdkmioQcXtvv?=
 =?us-ascii?Q?BQocfLujtBoeJ6EnAbgavdwnKH00PyR0VdQDldHxs+ADSLJ6r4q/6RWZq0gD?=
 =?us-ascii?Q?kR6x2pvt53EPqmp+rFNpNek+FIecvFBpxLOZoj0D1ee4dnFUz8bz1xcZhSzH?=
 =?us-ascii?Q?2W9OOaX4Yn87OywqtUy5co9lele7gLUU1MP9G+Yt9GZOJqiL11xNmYFkt2RF?=
 =?us-ascii?Q?tvFvq5XWrFQy71hKKrJydeIkyUKrRyF8H8jupTTb5iHstwV2cPMeY72AeXc0?=
 =?us-ascii?Q?+xABrqsUafPDLmTLmRIceX8QTohejy/eze51nvBA3LjCwfyejUfEQdsK08v2?=
 =?us-ascii?Q?eu3L4u7Xd6Ok6pDh2BEjdhxNjXB5uMEfHjp0owP53Fwmc36dOA4ZpbFPUxNO?=
 =?us-ascii?Q?l6pELmh6ERkV98S4IfzI5GmDpFPZeKOh8HAhM5aDCLKP0CLtyG5XbFMsE1eC?=
 =?us-ascii?Q?xLGAtj9LgTiyHjzgTkdJrPvuolLVWoilDAHwSaVDPkipdPkiMj7gjGL4IpiR?=
 =?us-ascii?Q?ITfY7MdVJaX+UWiRX/FBnlJsiXT2nRQ1o4hN4SDOZb6NL9mRKuOWLg3dQfqM?=
 =?us-ascii?Q?VWupCGfTixL/gN1LHSlOouqcSVYim4+mnl+6pVi9rGo5bGJhx4ABajeYYu5E?=
 =?us-ascii?Q?cbjvI6T9ODG77gdvtObm1rJE/camAVFTvuLuU9HBaXVwr/teBYOd7YcL8vW3?=
 =?us-ascii?Q?GqwQMXx8QMj22vKZvqJVqyJoz6fhH/NRdI0+zGt2Ryf6F0hqzuR8pMxpl1/T?=
 =?us-ascii?Q?ujK6t/nrc8jtn6aX21aEZ9/XIvGgh6t2TaQDp69yayKpXjn02aSP4Aum09BX?=
 =?us-ascii?Q?MpFfoYI3okwJU+x4VoVWIdPgerIMl3w+X6HudXzdBsIEaGdEbJteGsXLhW3A?=
 =?us-ascii?Q?B4m+k870z+EyYz79EC8aJNqz76/tvLkv1nk5vJrAFN3mTi9zaHvOpdiWmNCM?=
 =?us-ascii?Q?p5V/uwU3Ioj/Nd8hFEmXJ0Ipa+mjZg0/TLJ7bl1OFz/8yEIISBSaSWPIK4bq?=
 =?us-ascii?Q?Vc9Rjd5ugqcT32uAFKA5g5Tjg0aB6ZSxgVkf/ZbZQLst3LUuv6Lgim0+6MXG?=
 =?us-ascii?Q?SypSDyz/XozIx9sS3HwY1bkqxBRHC+CLC4r/MhlqBxjxC1hSQWB/zK2jxp1c?=
 =?us-ascii?Q?TnOxdlIDCdZzh/GXvClnDxMs1/DCCZDlisg9UfJWMZ0qR2IUlGi/OeW+D34B?=
 =?us-ascii?Q?bgGdnYK3NvzquaEetdRsNMHEE0XL5QV0UoTPAxXlyf7uC8fQHePKQFR1c1Xb?=
 =?us-ascii?Q?LHkud7i7/FxFPrdSmLf1YyyHFsgI7Dw4Wai2CGLx0QVUCdpJoLf9fuQpHqSV?=
 =?us-ascii?Q?i7xHwmOHwalRGjaOLuTZ7Z5r1FCC/0knWFRxzBGgJnCaS7lso9XKS1voiotz?=
 =?us-ascii?Q?gbmauXWrbQK8AsrTmv3I7fym8gZerI+4qrJ4mZN9mO9o1g7JoLvIT6GQ3sOY?=
 =?us-ascii?Q?YQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1449309-91b6-46df-a042-08daf86938ca
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 09:00:03.6748
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jq3A3KFPygPuuh7/J56VcG0pSLvYXHjAT02WnOJju3gmXeG/xmep7QePaXh6+MNghAPSAx08sr/R9RmuC0TH4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9304
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Show details about the structures passed back and forth related to MAC
Merge layer configuration, state and statistics. The rendered htmldocs
will be much more verbose due to the kerneldoc references.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2->v3:
- reformat tables
- delete obsolete netlink attributes and document new ones
v1->v2: patch is new

 Documentation/networking/ethtool-netlink.rst | 89 ++++++++++++++++++++
 Documentation/networking/statistics.rst      |  1 +
 2 files changed, 90 insertions(+)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index d345f5df248e..31413535dce5 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -223,6 +223,8 @@ Userspace to kernel:
   ``ETHTOOL_MSG_PSE_SET``               set PSE parameters
   ``ETHTOOL_MSG_PSE_GET``               get PSE parameters
   ``ETHTOOL_MSG_RSS_GET``               get RSS settings
+  ``ETHTOOL_MSG_MM_GET``                get MAC merge layer state
+  ``ETHTOOL_MSG_MM_SET``                set MAC merge layer parameters
   ===================================== =================================
 
 Kernel to userspace:
@@ -265,6 +267,7 @@ Kernel to userspace:
   ``ETHTOOL_MSG_MODULE_GET_REPLY``         transceiver module parameters
   ``ETHTOOL_MSG_PSE_GET_REPLY``            PSE parameters
   ``ETHTOOL_MSG_RSS_GET_REPLY``            RSS settings
+  ``ETHTOOL_MSG_MM_GET_REPLY``             MAC merge layer status
   ======================================== =================================
 
 ``GET`` requests are sent by userspace applications to retrieve device
@@ -1868,6 +1871,90 @@ When set, the ``ETHTOOL_A_PLCA_STATUS`` attribute indicates whether the node is
 detecting the presence of the BEACON on the network. This flag is
 corresponding to ``IEEE 802.3cg-2019`` 30.16.1.1.2 aPLCAStatus.
 
+MM_GET
+======
+
+Retrieve 802.3 MAC Merge parameters.
+
+Request contents:
+
+  ====================================  ======  ==========================
+  ``ETHTOOL_A_MM_HEADER``               nested  request header
+  ====================================  ======  ==========================
+
+Kernel response contents:
+
+  =================================  ======  ===================================
+  ``ETHTOOL_A_MM_HEADER``            nested  request header
+  ``ETHTOOL_A_MM_PMAC_ENABLED``      bool    set if RX of preemptible and SMD-V
+                                             frames is enabled
+  ``ETHTOOL_A_MM_TX_ENABLED``        bool    set if TX of preemptible frames is
+                                             administratively enabled (might be
+                                             inactive if verification failed)
+  ``ETHTOOL_A_MM_TX_ACTIVE``         bool    set if TX of preemptible frames is
+                                             operationally enabled
+  ``ETHTOOL_A_MM_TX_MIN_FRAG_SIZE``  u32     minimum size of transmitted
+                                             non-final fragments, in octets
+  ``ETHTOOL_A_MM_RX_MIN_FRAG_SIZE``  u32     minimum size of received non-final
+                                             fragments, in octets
+  ``ETHTOOL_A_MM_VERIFY_ENABLED``    bool    set if TX of SMD-V frames is
+                                             administratively enabled
+  ``ETHTOOL_A_MM_VERIFY_STATUS``     u8      state of the verification function
+  ``ETHTOOL_A_MM_VERIFY_TIME``       u32     delay between verification attempts
+  ``ETHTOOL_A_MM_MAX_VERIFY_TIME```  u32     maximum verification interval
+                                             supported by device
+  ``ETHTOOL_A_MM_STATS``             nested  IEEE 802.3-2018 subclause 30.14.1
+                                             oMACMergeEntity statistics counters
+  =================================  ======  ===================================
+
+The attributes are populated by the device driver through the following
+structure:
+
+.. kernel-doc:: include/linux/ethtool.h
+    :identifiers: ethtool_mm_state
+
+The ``ETHTOOL_A_MM_VERIFY_STATUS`` will report one of the values from
+
+.. kernel-doc:: include/uapi/linux/ethtool.h
+    :identifiers: ethtool_mm_verify_status
+
+If ``ETHTOOL_A_MM_VERIFY_ENABLED`` was passed as false in the ``MM_SET``
+command, ``ETHTOOL_A_MM_VERIFY_STATUS`` will report either
+``ETHTOOL_MM_VERIFY_STATUS_INITIAL`` or ``ETHTOOL_MM_VERIFY_STATUS_DISABLED``,
+otherwise it should report one of the other states.
+
+It is recommended that drivers start with the pMAC disabled, and enable it upon
+user space request. It is also recommended that user space does not depend upon
+the default values from ``ETHTOOL_MSG_MM_GET`` requests.
+
+``ETHTOOL_A_MM_STATS`` are reported if ``ETHTOOL_FLAG_STATS`` was set in
+``ETHTOOL_A_HEADER_FLAGS``. The attribute will be empty if driver did not
+report any statistics. Drivers fill in the statistics in the following
+structure:
+
+.. kernel-doc:: include/linux/ethtool.h
+    :identifiers: ethtool_mm_stats
+
+MM_SET
+======
+
+Modifies the configuration of the 802.3 MAC Merge layer.
+
+Request contents:
+
+  =================================  ======  ==========================
+  ``ETHTOOL_A_MM_VERIFY_TIME``       u32     see MM_GET description
+  ``ETHTOOL_A_MM_VERIFY_ENABLED``    bool    see MM_GET description
+  ``ETHTOOL_A_MM_TX_ENABLED``        bool    see MM_GET description
+  ``ETHTOOL_A_MM_PMAC_ENABLED``      bool    see MM_GET description
+  ``ETHTOOL_A_MM_TX_MIN_FRAG_SIZE``  u32     see MM_GET description
+  =================================  ======  ==========================
+
+The attributes are propagated to the driver through the following structure:
+
+.. kernel-doc:: include/linux/ethtool.h
+    :identifiers: ethtool_mm_cfg
+
 Request translation
 ===================
 
@@ -1972,4 +2059,6 @@ are netlink only.
   n/a                                 ``ETHTOOL_MSG_PLCA_GET_CFG``
   n/a                                 ``ETHTOOL_MSG_PLCA_SET_CFG``
   n/a                                 ``ETHTOOL_MSG_PLCA_GET_STATUS``
+  n/a                                 ``ETHTOOL_MSG_MM_GET``
+  n/a                                 ``ETHTOOL_MSG_MM_SET``
   =================================== =====================================
diff --git a/Documentation/networking/statistics.rst b/Documentation/networking/statistics.rst
index c9aeb70dafa2..551b3cc29a41 100644
--- a/Documentation/networking/statistics.rst
+++ b/Documentation/networking/statistics.rst
@@ -171,6 +171,7 @@ statistics are supported in the following commands:
 
   - `ETHTOOL_MSG_PAUSE_GET`
   - `ETHTOOL_MSG_FEC_GET`
+  - `ETHTOOL_MSG_MM_GET`
 
 debugfs
 -------
-- 
2.34.1

