Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85EAC6899BC
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 14:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbjBCN34 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 08:29:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232740AbjBCN3x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 08:29:53 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2052.outbound.protection.outlook.com [40.107.94.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6272F9EE00
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 05:29:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JDVPtPQqhm6Mf+iOZhSJvh70xc2JdaLflO29lG0coG2fHgF+sdTkxTLqXQlopheIsgNEg0JGtbreIyVlv7kFk2ceLbkceCSJYI0H0SjNDuwAC9qX1ydkxLi2NA1/kCjAlI3qdOeRIM5YVcGD8iszWBg3hgBpK91QILMTpC3zGkLLLlcJdHAFAr98hxkJhhJXEx4982R90/DJ3VrIAT06yGuR+tncirkrs+GCOkltRvfNMa22o7sPXjUlHbFSzDIx6RRCNNqtpl6EnJHDTw7XlMALuFZocFlXiZgkszEPCsFQ6Hb3LzkS3vtCwXRNNEzLNl3fo1BJ1DuMOpCsfELPdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=teW2JbBgJXrz4HucoJDEr5lmCWcj2nsyjuySIXnXxMU=;
 b=R4LdB0SCWSvcpbX5d+p3b/a86r8PT54nXbHKeON6on+3o4qYttOx/tI85SwnutGucMjgFqr7IgKZoV3qPRELEptY0Pn1szcsPkhH2fIZuuh3DwLQtfaWW1uvm4h4EkV/I/DW/6kguZvW2SYI2qm3jA4mTqANBcSEymmtu9XtMC2sYh0A1VfJTmw9zK4mHYSLKgpfgVY6N/OeXffQTsBAz2ZE6SRLJZ/hmLNHXompQt8SUodBmw5RXASo89tVKxDsGq8q6EW18TtU5duCg6HQNkHB698+gZdhr9KC7TyDWbg7qQlI6vZCR8ikQWPJWTgWbL1tMljUKbPOSiuscAzxAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=teW2JbBgJXrz4HucoJDEr5lmCWcj2nsyjuySIXnXxMU=;
 b=ct0RybluXqcUF3TKv/oN6+e1zbFBOCEILSa56UKaX95XtFfiO6xD/wNr8oXWQ4BBSKgoWM+Sr71zwmPjXueVFNcmGiMOiUD6h1Q+tNGU8NJoeDSWuCiWdNYjvrBEqNcWt/ZsBTroDludeo3DDsNWQ19XSTe4JqjI9pqeCQTVMbQJosT59QeBRy3Wr54Eca/0eYRf/nK+lGAkcXwuT9fL6MjLo8EdgINIA4ElWPsjEuGtvFi6zQVahm0Iq4sW1IQuysvb36M8/UR2PKsLgTIdLIz44CKRd+nfUk3UoZ5+etL2Qu9SXR8/O/bEx+lt5EuenRyw3IRPIgkyuy8o6G5VbA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by MW3PR12MB4476.namprd12.prod.outlook.com (2603:10b6:303:2d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27; Fri, 3 Feb
 2023 13:28:40 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::9fd9:dadc:4d8a:2d84]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::9fd9:dadc:4d8a:2d84%4]) with mapi id 15.20.6064.027; Fri, 3 Feb 2023
 13:28:40 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     Aurelien Aptel <aaptel@nvidia.com>, aurelien.aptel@gmail.com,
        smalin@nvidia.com, malin1024@gmail.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com
Subject: [PATCH v11 12/25] Documentation: add ULP DDP offload documentation
Date:   Fri,  3 Feb 2023 15:26:52 +0200
Message-Id: <20230203132705.627232-13-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230203132705.627232-1-aaptel@nvidia.com>
References: <20230203132705.627232-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0116.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:192::13) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|MW3PR12MB4476:EE_
X-MS-Office365-Filtering-Correlation-Id: 20fe1bc8-6188-4909-2002-08db05ea9025
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NSStg48HwCm/HhaPtWZ/F5Ud/IsII4d7bkbX2h4eT44/rVF3dVpsufG/uAVbfb4+0BeptTMa+xBaxybeywEwDYWoxeHzRI2VS0RUOj0kXoeeBQGjSg1nkeYNrGQ/xeEKQEIQH4Bx214pbxM/V0+rUa63N5jfjpztWgbkf530ZEePZKeFLy1wXHSTwJNqk5ba13EDmoWrZVbFAGzhJeW4qzaN2tiDKuTs80DmukIHtrltEZZ4sX+9HXHPyk4snMZSs90jXiLA2t+Lip6jNFrgnpQvqO2fY38LNQbCj1OjObtrhz/n+TLTFJIgge/l+siZUmW5QGl8/ECojnRihe15jbxaMrWAFukNcQU2+y+YXfbooADtPonmgpX+pBJT1ovY7Gifw36SGtQlEMBr42Cj2vDuWVwhmWoR6lFbVT1DWGpHFOrWHfVx0hR9O/UbDS0vJa4VurHf4ZtH7mGUhTx40WgEtINXSGwMgi6oetyWkLLrAKQfq5VCZxGM2LMePdfH8v2w/DiMxoK7PdNPbqMdPj/RSZFwFLIvUreRdUrB3yjrl1r9n0aYtbaYXFZmefQGKpDxvx6iKu7/ovGNfZn62sSrasfV/SjxSXQZuWRsSL/KD9JjYiqq6a/xnKNkw5r1G6v1hoOihYZVb9MqrYwlGw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(39860400002)(346002)(396003)(136003)(366004)(451199018)(186003)(6512007)(38100700002)(1076003)(6506007)(83380400001)(36756003)(30864003)(2906002)(26005)(7416002)(478600001)(6666004)(6486002)(107886003)(86362001)(41300700001)(66476007)(66556008)(8676002)(2616005)(316002)(4326008)(66946007)(5660300002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5Sdy1WhwKhTq75fPLmrtnuB9oM1uGVwP/i4D3WIBM/ZDJlwp1t1AaFqieuan?=
 =?us-ascii?Q?9vY6IY76xQTvOy/fwfTwPh6dJDgCbz4AUbgMN+IOrh9RYEWSWKecv4qBcNZq?=
 =?us-ascii?Q?RFB1qrE0PwSt/Je3Gb78/ERewWoj4v1LM7mjdnLo4D+FgCpCytVnfokjhs5f?=
 =?us-ascii?Q?UoR2JGADeyin9oMzZom+ETYocGBt0udY/zl7pC8ZWS5A7PdQ+/LF9qfzZKkb?=
 =?us-ascii?Q?QUf5xiRKT24YDiFpuBrqcY6IrHjJywxwLUbuU80+oduibbBNJxl+n1x3wNzF?=
 =?us-ascii?Q?d7tuw39iBw028yFlQi/kOjENOOypQJh9f8r/eHz9vrAxSGvUuAxLZdVBB/pt?=
 =?us-ascii?Q?RbGtXXm/+LX+0O7IeACY9YW8RB2kRukaFDp/+tLTO/vv7SORUJHmrFy2cMHo?=
 =?us-ascii?Q?HKXTu9ed0aTcfiJlCvc9KZ0oD8+G7PyZqnvIXQdALE60/1QNRoFbcAq1DNAQ?=
 =?us-ascii?Q?OxPE3iWIqu79k0X9bzmLpzf7vJixRx95yWnygzfoPbfJZSklv39wvJsKIHFQ?=
 =?us-ascii?Q?edUgL/+oZ3AieI6mhsU8crep6DJ+POyaPZpc72SbbIxUkf3QNd+6j+GQCU74?=
 =?us-ascii?Q?w4G6u/OIBm0ql3GYys7W19VffZJ/gm7dfGxFbOkkm2+ZViphKWXNKvTr4MtJ?=
 =?us-ascii?Q?alw5ic/hgB4+wpc/Jfy9/wU709MYD3U94Pqs99N/ZmlChLb1r16WcWP07Uji?=
 =?us-ascii?Q?luzjd8n/0OPt8UNHJXjnePn0yUVWnmXkpyDfpc/6YO7H2Lm9Bt/wTmH1oEAi?=
 =?us-ascii?Q?HDxhlxBd+dk5Qu/VEx/lREh6cCXuJMmToWM0QJ+lUmLMhXIzDdYZD1oaMDo3?=
 =?us-ascii?Q?XEJ/OUpaUR1jRHj1Tp2sXr5IOcW31imruNf4Wcz9G9ycokhvvjs79V9F1fHK?=
 =?us-ascii?Q?wKfZ69lb5fwOSe8g3/DBeo11RjgLD09MX1s5fJlRcr42a2VX6w90uZSTszCd?=
 =?us-ascii?Q?JeLaO6rM5YmyrT48oiYr2Wi+2wWTeHc248/RfnnGL1S6oHcG53orohWVx8iy?=
 =?us-ascii?Q?u1SATFpyFmVNn37691Otn/2jSGnodZG99Jrk2HifZ1AUayf7b3/P10sotG9w?=
 =?us-ascii?Q?lDCsBNsJoKt1+AKi1RliRXSA4MyRjm/cC9tXG0ffLnUYv8R2AyNCUAFbTlbf?=
 =?us-ascii?Q?mK7DbqZHnbnMr6fv62W9bC8RkLrKQ3wrDYaBJiJKJmJLcIFtFw8Eg787Cldi?=
 =?us-ascii?Q?DydZLCDF21ih6EVuGyTiHPXN+FFc31zWGzn1RfKPw9QMQblsqjo5tvJEoDpt?=
 =?us-ascii?Q?CSEP0JKeeVX8Vb/ZsVzFIhHhY5SlzyOyQNEeL6nMjachjRtpMea9ykTLR/tA?=
 =?us-ascii?Q?jMju8jaZXgy42CQebKs0lOLZvXe+Z8DQDkKWXb3TZPl4u+gqB+hgt2Jb0OTD?=
 =?us-ascii?Q?9pF20RPlr5j8GdD8ClgZ03BbYPESZqAO99JuEqNQP0YeUVMXEN0SO3a521kM?=
 =?us-ascii?Q?Gemvu//YrkLJof1SVxaHMdE2J+qEvDmqxEvND4WUufEhjoQ229VecNuy+kkR?=
 =?us-ascii?Q?zFlNS8pL+q8ODaMtYnU47CvgVhvVVbMJpeegQM4d1zHy8txbillPDESVWWUM?=
 =?us-ascii?Q?Ok8reP35AmybT+5DfoydrhVnF5cVZ9mFfW/NKD/o?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20fe1bc8-6188-4909-2002-08db05ea9025
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2023 13:28:40.3457
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8r6dbDixVsnmG8Bs8GjTZ00YF4EI45K7IDELHgHsuRMWy0mVudylbBiShwC5vU3dKx0gWgqAzxHx94iWDM2btA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4476
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yoray Zack <yorayz@nvidia.com>

Document the new ULP DDP API and add it under "networking".
Use NVMe-TCP implementation as an example.

Signed-off-by: Boris Pismenny <borisp@nvidia.com>
Signed-off-by: Ben Ben-Ishay <benishay@nvidia.com>
Signed-off-by: Or Gerlitz <ogerlitz@nvidia.com>
Signed-off-by: Yoray Zack <yorayz@nvidia.com>
Signed-off-by: Shai Malin <smalin@nvidia.com>
Signed-off-by: Aurelien Aptel <aaptel@nvidia.com>
---
 Documentation/netlink/specs/ethtool.yaml     |   6 +-
 Documentation/networking/index.rst           |   1 +
 Documentation/networking/ulp-ddp-offload.rst | 376 +++++++++++++++++++
 3 files changed, 380 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/networking/ulp-ddp-offload.rst

diff --git a/Documentation/netlink/specs/ethtool.yaml b/Documentation/netlink/specs/ethtool.yaml
index 8932cf310f1a..6c3b32572028 100644
--- a/Documentation/netlink/specs/ethtool.yaml
+++ b/Documentation/netlink/specs/ethtool.yaml
@@ -453,7 +453,7 @@ operations:
       notify: mm-get
     -
       name: ulp-ddp-get
-      doc: Get ULP DDP capabilities and stats
+      doc: Get ULP DDP capabilities and stats.
 
       attribute-set: ulp-ddp
 
@@ -472,7 +472,7 @@ operations:
       dump: *ulp-ddp-get-op
     -
       name: ulp-ddp-set
-      doc: Set ULP DDP capabilities
+      doc: Set ULP DDP capabilities.
 
       attribute-set: ulp-ddp
 
@@ -490,5 +490,5 @@ operations:
             - active
     -
       name: ulp-ddp-ntf
-      doc: Notification for change in ULP DDP capabilities
+      doc: Notification for change in ULP DDP capabilities.
       notify: ulp-ddp-get
diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 4ddcae33c336..bfb57df4b583 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -106,6 +106,7 @@ Contents:
    tc-actions-env-rules
    tc-queue-filters
    tcp-thin
+   ulp-ddp-offload
    team
    timestamping
    tipc
diff --git a/Documentation/networking/ulp-ddp-offload.rst b/Documentation/networking/ulp-ddp-offload.rst
new file mode 100644
index 000000000000..285c9ad5bb8b
--- /dev/null
+++ b/Documentation/networking/ulp-ddp-offload.rst
@@ -0,0 +1,376 @@
+.. SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+
+=================================
+ULP direct data placement offload
+=================================
+
+Overview
+========
+
+The Linux kernel ULP direct data placement (DDP) offload infrastructure
+provides tagged request-response protocols, such as NVMe-TCP, the ability to
+place response data directly in pre-registered buffers according to header
+tags. DDP is particularly useful for data-intensive pipelined protocols whose
+responses may be reordered.
+
+For example, in NVMe-TCP numerous read requests are sent together and each
+request is tagged using the PDU header CID field. Receiving servers process
+requests as fast as possible and sometimes responses for smaller requests
+bypasses responses to larger requests, e.g., 4KB reads bypass 1GB reads.
+Thereafter, clients correlate responses to requests using PDU header CID tags.
+The processing of each response requires copying data from SKBs to read
+request destination buffers; The offload avoids this copy. The offload is
+oblivious to destination buffers which can reside either in userspace
+(O_DIRECT) or in kernel pagecache.
+
+Request TCP byte-stream:
+
+.. parsed-literal::
+
+ +---------------+-------+---------------+-------+---------------+-------+
+ | PDU hdr CID=1 | Req 1 | PDU hdr CID=2 | Req 2 | PDU hdr CID=3 | Req 3 |
+ +---------------+-------+---------------+-------+---------------+-------+
+
+Response TCP byte-stream:
+
+.. parsed-literal::
+
+ +---------------+--------+---------------+--------+---------------+--------+
+ | PDU hdr CID=2 | Resp 2 | PDU hdr CID=3 | Resp 3 | PDU hdr CID=1 | Resp 1 |
+ +---------------+--------+---------------+--------+---------------+--------+
+
+The driver builds SKB page fragments that point to destination buffers.
+Consequently, SKBs represent the original data on the wire, which enables
+*transparent* inter-operation with the network stack. To avoid copies between
+SKBs and destination buffers, the layer-5 protocol (L5P) will check
+``if (src == dst)`` for SKB page fragments, success indicates that data is
+already placed there by NIC hardware and copy should be skipped.
+
+In addition, L5P might have DDGST which ensures data integrity over
+the network.  If not offloaded, ULP DDP might not be efficient as L5P
+will need to go over the data and calculate it by itself, cancelling
+out the benefits of the DDP copy skip.  ULP DDP has support for Rx/Tx
+DDGST offload. On the received side the NIC will verify DDGST for
+received PDUs and update SKB->ulp_ddp and SKB->ulp_crc bits.  If all the SKBs
+making up a L5P PDU have crc on, L5P will skip on calculating and
+verifying the DDGST for the corresponding PDU. On the Tx side, the NIC
+will be responsible for calculating and filling the DDGST fields in
+the sent PDUs.
+
+Offloading does require NIC hardware to track L5P protocol framing, similarly
+to RX TLS offload (see Documentation/networking/tls-offload.rst).  NIC hardware
+will parse PDU headers, extract fields such as operation type, length, tag
+identifier, etc. and only offload segments that correspond to tags registered
+with the NIC, see the :ref:`buf_reg` section.
+
+Device configuration
+====================
+
+During driver initialization the driver sets the following
+:c:type:`struct net_device <net_device>` properties:
+
+* The ULP DDP capabilities it supports
+  in :c:type:`struct ulp_ddp_netdev_caps <ulp_ddp_caps>`
+* The ULP DDP operations pointer in :c:type:`struct ulp_ddp_dev_ops`.
+
+The current list of capabilities is represented as a bitset:
+
+.. code-block:: c
+
+  enum {
+	ULP_DDP_C_NVME_TCP_BIT,
+	ULP_DDP_C_NVME_TCP_DDGST_RX_BIT,
+	/* add capabilities above */
+	ULP_DDP_C_COUNT,
+  };
+
+The enablement of capabilities can be controlled from userspace via
+netlink. See Documentation/networking/ethtool-netlink.rst for more
+details.
+
+Later, after the L5P completes its handshake, the L5P queries the
+driver for its runtime limitations via the :c:member:`limits` operation:
+
+.. code-block:: c
+
+ int (*limits)(struct net_device *netdev,
+	       struct ulp_ddp_limits *lim);
+
+
+All L5P share a common set of limits and parameters (:c:type:`struct ulp_ddp_limits`):
+
+.. code-block:: c
+
+ /**
+  * struct ulp_ddp_limits - Generic ulp ddp limits: tcp ddp
+  * protocol limits.
+  * Add new instances of ulp_ddp_limits in the union below (nvme-tcp, etc.).
+  *
+  * @type:		type of this limits struct
+  * @max_ddp_sgl_len:	maximum sgl size supported (zero means no limit)
+  * @io_threshold:	minimum payload size required to offload
+  * @nvmeotcp:		NVMe-TCP specific limits
+  */
+ struct ulp_ddp_limits {
+	enum ulp_ddp_type	type;
+	int			max_ddp_sgl_len;
+	int			io_threshold;
+	union {
+		/* ... protocol-specific limits ... */
+		struct nvme_tcp_ddp_limits nvmeotcp;
+	};
+ };
+
+But each L5P can also add protocol-specific limits e.g.:
+
+.. code-block:: c
+
+ /**
+  * struct nvme_tcp_ddp_limits - nvme tcp driver limitations
+  *
+  * @full_ccid_range:	true if the driver supports the full CID range
+  */
+ struct nvme_tcp_ddp_limits {
+	bool			full_ccid_range;
+ };
+
+Once the L5P has made sure the device is supported the offload
+operations are installed on the socket.
+
+If offload installation fails, then the connection is handled by software as if
+offload was not attempted.
+
+To request offload for a socket `sk`, the L5P calls :c:member:`sk_add`:
+
+.. code-block:: c
+
+ int (*sk_add)(struct net_device *netdev,
+	       struct sock *sk,
+	       struct ulp_ddp_config *config);
+
+The function return 0 for success. In case of failure, L5P software should
+fallback to normal non-offloaded operations.  The `config` parameter indicates
+the L5P type and any metadata relevant for that protocol. For example, in
+NVMe-TCP the following config is used:
+
+.. code-block:: c
+
+ /**
+  * struct nvme_tcp_ddp_config - nvme tcp ddp configuration for an IO queue
+  *
+  * @pfv:        pdu version (e.g., NVME_TCP_PFV_1_0)
+  * @cpda:       controller pdu data alignment (dwords, 0's based)
+  * @dgst:       digest types enabled.
+  *              The netdev will offload crc if L5P data digest is supported.
+  * @queue_size: number of nvme-tcp IO queue elements
+  * @queue_id:   queue identifier
+  * @cpu_io:     cpu core running the IO thread for this queue
+  */
+ struct nvme_tcp_ddp_config {
+	u16			pfv;
+	u8			cpda;
+	u8			dgst;
+	int			queue_size;
+	int			queue_id;
+	int			io_cpu;
+ };
+
+When offload is not needed anymore, e.g. when the socket is being released, the L5P
+calls :c:member:`sk_del` to release device contexts:
+
+.. code-block:: c
+
+ void (*sk_del)(struct net_device *netdev,
+	        struct sock *sk);
+
+Normal operation
+================
+
+At the very least, the device maintains the following state for each connection:
+
+ * 5-tuple
+ * expected TCP sequence number
+ * mapping between tags and corresponding buffers
+ * current offset within PDU, PDU length, current PDU tag
+
+NICs should not assume any correlation between PDUs and TCP packets.
+If TCP packets arrive in-order, offload will place PDU payloads
+directly inside corresponding registered buffers. NIC offload should
+not delay packets. If offload is not possible, than the packet is
+passed as-is to software. To perform offload on incoming packets
+without buffering packets in the NIC, the NIC stores some inter-packet
+state, such as partial PDU headers.
+
+RX data-path
+------------
+
+After the device validates TCP checksums, it can perform DDP offload.  The
+packet is steered to the DDP offload context according to the 5-tuple.
+Thereafter, the expected TCP sequence number is checked against the packet
+TCP sequence number. If there is a match, offload is performed: the PDU payload
+is DMA written to the corresponding destination buffer according to the PDU header
+tag.  The data should be DMAed only once, and the NIC receive ring will only
+store the remaining TCP and PDU headers.
+
+We remark that a single TCP packet may have numerous PDUs embedded inside. NICs
+can choose to offload one or more of these PDUs according to various
+trade-offs. Possibly, offloading such small PDUs is of little value, and it is
+better to leave it to software.
+
+Upon receiving a DDP offloaded packet, the driver reconstructs the original SKB
+using page frags, while pointing to the destination buffers whenever possible.
+This method enables seamless integration with the network stack, which can
+inspect and modify packet fields transparently to the offload.
+
+.. _buf_reg:
+
+Destination buffer registration
+-------------------------------
+
+To register the mapping between tags and destination buffers for a socket
+`sk`, the L5P calls :c:member:`setup` of :c:type:`struct ulp_ddp_ops
+<ulp_ddp_ops>`:
+
+.. code-block:: c
+
+ int (*setup)(struct net_device *netdev,
+	      struct sock *sk,
+	      struct ulp_ddp_io *io);
+
+
+The `io` provides the buffer via scatter-gather list (`sg_table`) and
+corresponding tag (`command_id`):
+
+.. code-block:: c
+
+ /**
+  * struct ulp_ddp_io - tcp ddp configuration for an IO request.
+  *
+  * @command_id:  identifier on the wire associated with these buffers
+  * @nents:       number of entries in the sg_table
+  * @sg_table:    describing the buffers for this IO request
+  * @first_sgl:   first SGL in sg_table
+  */
+ struct ulp_ddp_io {
+	u32			command_id;
+	int			nents;
+	struct sg_table		sg_table;
+	struct scatterlist	first_sgl[SG_CHUNK_SIZE];
+ };
+
+After the buffers have been consumed by the L5P, to release the NIC mapping of
+buffers the L5P calls :c:member:`teardown` of :c:type:`struct
+ulp_ddp_ops <ulp_ddp_ops>`:
+
+.. code-block:: c
+
+ void (*teardown)(struct net_device *netdev,
+		  struct sock *sk,
+		  struct ulp_ddp_io *io,
+		  void *ddp_ctx);
+
+`teardown` receives the same `io` context and an additional opaque
+`ddp_ctx` that is used for asynchronous teardown, see the :ref:`async_release`
+section.
+
+.. _async_release:
+
+Asynchronous teardown
+---------------------
+
+To teardown the association between tags and buffers and allow tag reuse NIC HW
+is called by the NIC driver during `teardown`. This operation may be
+performed either synchronously or asynchronously. In asynchronous teardown,
+`teardown` returns immediately without unmapping NIC HW buffers. Later,
+when the unmapping completes by NIC HW, the NIC driver will call up to L5P
+using :c:member:`ddp_teardown_done` of :c:type:`struct ulp_ddp_ulp_ops`:
+
+.. code-block:: c
+
+ void (*ddp_teardown_done)(void *ddp_ctx);
+
+The `ddp_ctx` parameter passed in `ddp_teardown_done` is the same on provided
+in `teardown` and it is used to carry some context about the buffers
+and tags that are released.
+
+Resync handling
+===============
+
+RX
+--
+In presence of packet drops or network packet reordering, the device may lose
+synchronization between the TCP stream and the L5P framing, and require a
+resync with the kernel's TCP stack. When the device is out of sync, no offload
+takes place, and packets are passed as-is to software. Resync is very similar
+to TLS offload (see documentation at Documentation/networking/tls-offload.rst)
+
+If only packets with L5P data are lost or reordered, then resynchronization may
+be avoided by NIC HW that keeps tracking PDU headers. If, however, PDU headers
+are reordered, then resynchronization is necessary.
+
+To resynchronize hardware during traffic, we use a handshake between hardware
+and software. The NIC HW searches for a sequence of bytes that identifies L5P
+headers (i.e., magic pattern).  For example, in NVMe-TCP, the PDU operation
+type can be used for this purpose.  Using the PDU header length field, the NIC
+HW will continue to find and match magic patterns in subsequent PDU headers. If
+the pattern is missing in an expected position, then searching for the pattern
+starts anew.
+
+The NIC will not resume offload when the magic pattern is first identified.
+Instead, it will request L5P software to confirm that indeed this is a PDU
+header. To request confirmation the NIC driver calls up to L5P using
+:c:member:`*resync_request` of :c:type:`struct ulp_ddp_ulp_ops`:
+
+.. code-block:: c
+
+  bool (*resync_request)(struct sock *sk, u32 seq, u32 flags);
+
+The `seq` parameter contains the TCP sequence of the last byte in the PDU header.
+The `flags` parameter contains a flag (`ULP_DDP_RESYNC_PENDING`) indicating whether
+a request is pending or not.
+L5P software will respond to this request after observing the packet containing
+TCP sequence `seq` in-order. If the PDU header is indeed there, then L5P
+software calls the NIC driver using the :c:member:`resync` function of
+the :c:type:`struct ulp_ddp_dev_ops <ulp_ddp_ops>` inside the :c:type:`struct
+net_device <net_device>` while passing the same `seq` to confirm it is a PDU
+header.
+
+.. code-block:: c
+
+ void (*resync)(struct net_device *netdev,
+		struct sock *sk, u32 seq);
+
+Statistics
+==========
+
+Per L5P protocol, the NIC driver must report statistics for the above
+netdevice operations and packets processed by offload.
+These statistics are per-device and can be retrieved from userspace
+via netlink (see Documentation/networking/ethtool-netlink.rst).
+
+For example, NVMe-TCP offload reports:
+
+ * ``rx_nvmeotcp_sk_add`` - number of NVMe-TCP Rx offload contexts created.
+ * ``rx_nvmeotcp_sk_add_fail`` - number of NVMe-TCP Rx offload context creation
+   failures.
+ * ``rx_nvmeotcp_sk_del`` - number of NVMe-TCP Rx offload contexts destroyed.
+ * ``rx_nvmeotcp_ddp_setup`` - number of DDP buffers mapped.
+ * ``rx_nvmeotcp_ddp_setup_fail`` - number of DDP buffers mapping that failed.
+ * ``rx_nvmeotcp_ddp_teardown`` - number of DDP buffers unmapped.
+ * ``rx_nvmeotcp_drop`` - number of packets dropped in the driver due to fatal
+   errors.
+ * ``rx_nvmeotcp_resync`` - number of packets with resync requests.
+ * ``rx_nvmeotcp_packets`` - number of packets that used offload.
+ * ``rx_nvmeotcp_bytes`` - number of bytes placed in DDP buffers.
+
+NIC requirements
+================
+
+NIC hardware should meet the following requirements to provide this offload:
+
+ * Offload must never buffer TCP packets.
+ * Offload must never modify TCP packet headers.
+ * Offload must never reorder TCP packets within a flow.
+ * Offload must never drop TCP packets.
+ * Offload must not depend on any TCP fields beyond the
+   5-tuple and TCP sequence number.
-- 
2.31.1

