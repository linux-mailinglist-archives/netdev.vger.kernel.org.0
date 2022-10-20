Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDACC605C1F
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 12:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229449AbiJTKV1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 06:21:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbiJTKUj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 06:20:39 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2086.outbound.protection.outlook.com [40.107.220.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28DB7BEAC9
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 03:20:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bbs8OCvIPvSL/seMSLFVE0NGjTYpC1C4NI1POQcqenBIrdLGa9dyPujUhwbEJUVjibXLWxmoNCD5apcnBd5m1Z3aJ5BPtxgL6SQ/r9zZk/iP/emtyl11qaa94BqrvnH5H6FnWXjoB5uY+34cQGeXQWoQeYt9MHud9WC2tyqlE17ekItUq5XxyOMSFsR6PpWfa0DuHy3XBZR8cYqigtq2AH5K5Aw8tf9HNJlkOUZkcmxxKTWed8MctpBH7fhGD4SAhtZCHi4BogPsuU3DwcMTq1mvoM7UqbzL2+EOD7Ndw2FyBMylkpeghU/4Z2Z4dIFBgRUi4KXVQTzCnvArikiIog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/Equ8x7V/OQ2by6vN8Gdmx4MOjhROFgNHSjKGdRcQ/k=;
 b=heFYzMqdmfw+7+cCdwge2YKvT4pQkiV5CMUN5K9npsPHXvVQeYrBU9vowdxBBIxpwe2B9pc9GZz2vENcc0/TDU8io52A7uxwSh6Lg089RrE7SRejXWl0CwsZxMMzCdO7Yj92IVTmHcg/3Ps1v8baj9oEMpRNfVsZu0AeRu25hwW5tIYOQmvUESKj7IxjBNkoaSR6KYxzn9uddvvZVRlWmGSB6j0abgSCAI060BxsJXm9SJ/3h07w9/5XZ6vvOqjb12r5A+xyXZqYlmbO6PQwJyHQCz/mkZy6+ssTsqtdfKdZxeqGHVe62uKJq3hhrg4rC14ksU8IfRxOUESW4AYSQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/Equ8x7V/OQ2by6vN8Gdmx4MOjhROFgNHSjKGdRcQ/k=;
 b=HUOj/5299h7uAs4g8lQxZ3pe98CDtw2a4oUIue6j6pDVItCbUqZv6FxYm42ZKEL32vXVTP0z4ArzZBFyq5jJo5ScG2OAVURs1P0zgP1P7xDNFRhAOZkFx+yQtuyJNIFb973zGuPsvlGzQsNB9+DlYMzl5ooNtBDITBcBlXTWtMz1s/dsl0Ax5/9M4sfzN9K2EktWSJms9nAV0k3TITsxaq+tBc/5yUHJP9LKXN6hEwqzIe++z5EmsvqFjBtXpBmj2gXbc2yMwZB36r7Z4lH8H53ZX4yayDhwTVrYqHUZSNSoRRryw4Ra7omIUx39s+bt/7PCFUmhrPNeF31Aum5ZbA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by DM4PR12MB5133.namprd12.prod.outlook.com (2603:10b6:5:390::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.33; Thu, 20 Oct
 2022 10:19:43 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::b8be:60e9:7ad8:c088]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::b8be:60e9:7ad8:c088%3]) with mapi id 15.20.5723.033; Thu, 20 Oct 2022
 10:19:43 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, saeedm@nvidia.com,
        tariqt@nvidia.com, linux-nvme@lists.infradead.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com
Cc:     smalin@nvidia.com, aaptel@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com, aurelien.aptel@gmail.com,
        malin1024@gmail.com
Subject: [PATCH v6 10/23] Documentation: add ULP DDP offload documentation
Date:   Thu, 20 Oct 2022 13:18:25 +0300
Message-Id: <20221020101838.2712846-11-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221020101838.2712846-1-aaptel@nvidia.com>
References: <20221020101838.2712846-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0473.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a8::10) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|DM4PR12MB5133:EE_
X-MS-Office365-Filtering-Correlation-Id: e2f09091-a5a0-4b4b-aaea-08dab2849b46
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KYqUT55GJyeGFafxBhbP7VenIbRCSlmwSju4A2QLzMZFoa89FPsXqnirQZ8OVvFT05lo1QADciA50sVaqwGjBQ2kYnDO958xcf1AWJGs8lAiop3+MfSG9mpxDqYwq9nsFRooTA57jcis8ldJTwtEyMeIzQ5ThxyhLPFsZYTEPMnmCZesjamDQQFb/hfdAnUODjhXlTQVNJg5jNiJdbMGRWrxVOcRAdnwuP6jykWcNP+UMy9WfPCvDx56NnSDr/mliHUqC2lRR6rV3x4C5MMJAogC/pBri6f1+5FaFPPmSDACXk2JnEcqnd1EF8UExS56+JNfzduTxSqoFCduuCQCDbamXFX3/MXsj2QPprv2/Q1PNEN9eUggMbUBQwE+nkGhX3otiFCwfmvsF87yoHq2dudDa05+lRvt/bUCmvfF/D5QlXTeyVtTm5WxbLq5zLjhFuthwc08KJF67EDsL175dHzKnS1mSj+FEIgygDskcAsJSKilkAG1KzcV0mMcZDw31kzllxbvSJ5DrDpmhR2N/yCKC+EqsXuXK8hfX5Qz4ncJWkoiA9NP67lyyTfWVGNWO49+bMZLoU6vVKlQjsO0B+lbaW/vXN4igftfHRg8iVWwXPVqdNdZXpl9U7tsSYLPpohhIKneEeKlflCvn/sftcLVh6qbDcAuoikMEdtamotX6Aqg8Y7iwoYBl4m4jdjdqlK4VdvZKUtVtjKFEGGGrkzIeAzNs2Dxdt3B7PZAWh3rBVNtxcL9EsxJuTvMQFwE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(346002)(136003)(366004)(39860400002)(451199015)(6506007)(6512007)(26005)(4326008)(86362001)(2906002)(921005)(8936002)(7416002)(30864003)(5660300002)(36756003)(41300700001)(66476007)(8676002)(66556008)(38100700002)(83380400001)(66946007)(316002)(6486002)(6636002)(186003)(2616005)(1076003)(6666004)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wc5sbcfVTqnwW27QwgD7bICVM7o5NR4PFcI+uKcuLU52vlth9MwLEt8yPr4L?=
 =?us-ascii?Q?3ed5TnTQQMlJbM9sG8OW03pKMBgbcsEy79FJaZZW4E+txFaMlZwOoEMMePKL?=
 =?us-ascii?Q?hQUb1GtnrzIFR3/dzrMEu1iw7MlNOHsJDF2GvkmZWX5hCwA0fntaWYFuOP0f?=
 =?us-ascii?Q?dmZMLvCCMIDhK3h+6qbr30939X3ARoXAkDWXnjgsW9BNwWg/mEz064bgsPWQ?=
 =?us-ascii?Q?2Xjav68Hml7MpBaHTjJDRP/AMO20yoQe1fQ3iScE3vGkGz/qFS/vxQI0NtGh?=
 =?us-ascii?Q?BcDrKhqx1/7IzhGssT4ntFG38sEW94LNwxq2hOERGWboKclxNaBAftXisOZ0?=
 =?us-ascii?Q?It6npmwTB/uUXvGzEIDSW5I2U4+230Mv3DuWOlP/P5p5LybPlT0JP7VBD1sY?=
 =?us-ascii?Q?Pi4n+AJGhRW0ieNRwSDMgQ011RUdm5ONn/NKtkTwB2BHO6Gy6M/zTA3eTLUz?=
 =?us-ascii?Q?fczedp9qP/6hxIoGl6LFKrBZpAjUoAEr3TxCod2e38plLchsmVozhpEdAiwm?=
 =?us-ascii?Q?y6wALG5Xq9ZQHl+V7O6roa+QNExU/c9SF7BM7yEKZTzhgXShND5yWIFKGt9f?=
 =?us-ascii?Q?FIKcsc/aIeO6iRnYnQSnl1WdRBVZ0BwosCBTrbVxujEKnWLPZQDok9RJVbJG?=
 =?us-ascii?Q?JYGoNR8HgYm8Uo1oZmSiWZRzbpKm/hn819jyvbsTvx1uzMpL4NPQ39GykKHW?=
 =?us-ascii?Q?6Sa71yuxAI82NSJWmOpCm0YJyFT5cMuhD7kUXdrRMe/dC5WEL9k0pGX35aFK?=
 =?us-ascii?Q?KGTMKgu5A7J7qVjZYzTdIKKYvOv4PcAGo0/H23dkjoFtOUGZIZUtCOTD+SPu?=
 =?us-ascii?Q?DijhmYG0ZMkrkHV8eN/e93We7JDnsayLVTYDHA86syT43bMUQXnBYOFRGdkc?=
 =?us-ascii?Q?QXAnAywHHfmTYF3rnnmTLub/0oAX7E30UNo/wrgJQK/qyjNkzDaUh6NCmXYo?=
 =?us-ascii?Q?Xw/RyG7WGcZaUMJMNnwAIlXKShBf9NWbPnd9qUxxeMPwQQcJlZY0JPJAXv4+?=
 =?us-ascii?Q?qNoGJcnVk1qV1GDF/Y1DNA2ryYkUX5qNP3A8un9A2TCpBfu/FtlSdm+w7OHX?=
 =?us-ascii?Q?Y96A8nuzuJyaykGh1VwMXZhdWiv2F7kroUqS8AibZMM+XsY55FD1/XM8sLgz?=
 =?us-ascii?Q?XoD9gqF/vCYp9wNi9XXkX+Mmxb/jhHDwBN8UAumkqDVYxkMhhAXSAt+UwsZE?=
 =?us-ascii?Q?hWNknzHyR1OSTwqhZmXdBw8OMW+kEcplrML9wfcZFusx/kBKY2japuWfx68o?=
 =?us-ascii?Q?CcRmNP3/5xKXbrqhnetnAVvC1ualjI5JFh1DET8oiQDUrlUrblqgTGAPTQH7?=
 =?us-ascii?Q?O9S5Wi4FCVTtWo7f1IaEb7NQQdh6WHRsA8x3713sUsA3S1SaXIEv34N7Z7Fa?=
 =?us-ascii?Q?rSdHzkCbyQutKOFD98dL2XsBfeb/FHvKN7lvpWxn0cNHpMgbm3f9Hr1Vfsyw?=
 =?us-ascii?Q?zK60GhdovDVDMNRoaiRt8HOldtJ4AskGhkKwwkMPYQEHQsUkBlhfBYBu0W5T?=
 =?us-ascii?Q?Dxn0D/FaVtiwHMxYZ0Z1ub8c3JB5U7GFqYR4fAGsMpOzdF9X5BxRKbUtwfTN?=
 =?us-ascii?Q?D0BMDNFCP7UPkN/M5rU8GQ2c1JNucPIcFoPANBEA?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2f09091-a5a0-4b4b-aaea-08dab2849b46
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2022 10:19:43.7654
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MCF9UgJZPREsXph5Xv974oHRAPAciti9KCxfl72F1uoqSTfIoo506/wPtY6NTlYU83WtYVG7UtP+Kcfq/e9Cqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5133
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yoray Zack <yorayz@nvidia.com>

Signed-off-by: Boris Pismenny <borisp@nvidia.com>
Signed-off-by: Ben Ben-Ishay <benishay@nvidia.com>
Signed-off-by: Or Gerlitz <ogerlitz@nvidia.com>
Signed-off-by: Yoray Zack <yorayz@nvidia.com>
Signed-off-by: Shai Malin <smalin@nvidia.com>
Signed-off-by: Aurelien Aptel <aaptel@nvidia.com>
---
 Documentation/networking/index.rst           |   1 +
 Documentation/networking/ulp-ddp-offload.rst | 368 +++++++++++++++++++
 2 files changed, 369 insertions(+)
 create mode 100644 Documentation/networking/ulp-ddp-offload.rst

diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 16a153bcc5fe..75b370750d98 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -105,6 +105,7 @@ Contents:
    sysfs-tagging
    tc-actions-env-rules
    tcp-thin
+   ulp-ddp-offload
    team
    timestamping
    tipc
diff --git a/Documentation/networking/ulp-ddp-offload.rst b/Documentation/networking/ulp-ddp-offload.rst
new file mode 100644
index 000000000000..3927066938fb
--- /dev/null
+++ b/Documentation/networking/ulp-ddp-offload.rst
@@ -0,0 +1,368 @@
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
+to RX TLS offload (see documentation at
+:ref:`Documentation/networking/tls-offload.rst <tls_offload>`).  NIC hardware
+will parse PDU headers, extract fields such as operation type, length, tag
+identifier, etc. and only offload segments that correspond to tags registered
+with the NIC, see the :ref:`buf_reg` section.
+
+Device configuration
+====================
+
+During driver initialization the device sets the ``NETIF_F_HW_ULP_DDP`` feature
+and installs its
+:c:type:`struct ulp_ddp_ops <ulp_ddp_ops>`
+pointer in the :c:member:`ulp_ddp_ops` member of the
+:c:type:`struct net_device <net_device>`.
+
+Later, after the L5P completes its handshake, the L5P queries the
+device driver for its ULP capabilities (:c:type:`enum ulp_ddp_offload_capabilities`)
+and runtime limitations via the :c:member:`ulp_ddp_limits` callback:
+
+.. code-block:: c
+
+ int (*ulp_ddp_limits)(struct net_device *netdev,
+		      struct ulp_ddp_limits *limits);
+
+The current list of capabilities is:
+
+.. code-block:: c
+
+ enum ulp_ddp_offload_capabilities {
+	ULP_DDP_C_NVME_TCP = 1,
+	ULP_DDP_C_NVME_TCP_DDGST_RX = 2,
+ };
+
+All L5P share a common set of limits and parameters (:c:type:`struct ulp_ddp_limits`):
+
+.. code-block:: c
+
+ /**
+  * struct ulp_ddp_limits - Generic ulp ddp limits: tcp ddp
+  * protocol limits.
+  * Protocol implementations must use this as the first member.
+  * Add new instances of ulp_ddp_limits below (nvme-tcp, etc.).
+  *
+  * @max_ddp_sgl_len:	maximum sgl size supported (zero means no limit)
+  * @io_threshold:	minimum payload size required to offload
+  */
+ struct ulp_ddp_limits {
+	enum ulp_ddp_type	type;
+	u64			offload_capabilities;
+	int			max_ddp_sgl_len;
+	int			io_threshold;
+	unsigned char		buf[];
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
+	struct ulp_ddp_limits	lmt;
+
+	bool			full_ccid_range;
+ };
+
+Once the L5P has made sure the device is supported the offload
+operations are installed on the socket.
+
+If offload installation fails, then the connection is handled by software as if
+offload was not attempted.
+
+To request offload for a socket `sk`, the L5P calls :c:member:`ulp_ddp_sk_add`:
+
+.. code-block:: c
+
+ int (*ulp_ddp_sk_add)(struct net_device *netdev,
+		      struct sock *sk,
+		      struct ulp_ddp_config *config);
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
+	struct ulp_ddp_config   cfg;
+
+	u16			pfv;
+	u8			cpda;
+	u8			dgst;
+	int			queue_size;
+	int			queue_id;
+	int			io_cpu;
+ };
+
+When offload is not needed anymore, e.g. when the socket is being released, the L5P
+calls :c:member:`ulp_ddp_sk_del` to release device contexts:
+
+.. code-block:: c
+
+ void (*ulp_ddp_sk_del)(struct net_device *netdev,
+		        struct sock *sk);
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
+`sk`, the L5P calls :c:member:`ulp_ddp_setup` of :c:type:`struct ulp_ddp_ops
+<ulp_ddp_ops>`:
+
+.. code-block:: c
+
+ int (*ulp_ddp_setup)(struct net_device *netdev,
+		     struct sock *sk,
+		     struct ulp_ddp_io *io);
+
+
+The `io` provides the buffer via scatter-gather list (`sg_table`) and
+corresponding tag (`command_id`):
+
+.. code-block:: c
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
+buffers the L5P calls :c:member:`ulp_ddp_teardown` of :c:type:`struct
+ulp_ddp_ops <ulp_ddp_ops>`:
+
+.. code-block:: c
+
+ int (*ulp_ddp_teardown)(struct net_device *netdev,
+			struct sock *sk,
+			struct ulp_ddp_io *io,
+			void *ddp_ctx);
+
+`ulp_ddp_teardown` receives the same `io` context and an additional opaque
+`ddp_ctx` that is used for asynchronous teardown, see the :ref:`async_release`
+section.
+
+.. _async_release:
+
+Asynchronous teardown
+---------------------
+
+To teardown the association between tags and buffers and allow tag reuse NIC HW
+is called by the NIC driver during `ulp_ddp_teardown`. This operation may be
+performed either synchronously or asynchronously. In asynchronous teardown,
+`ulp_ddp_teardown` returns immediately without unmapping NIC HW buffers. Later,
+when the unmapping completes by NIC HW, the NIC driver will call up to L5P
+using :c:member:`ddp_teardown_done` of :c:type:`struct ulp_ddp_ulp_ops`:
+
+.. code-block:: c
+
+ void (*ddp_teardown_done)(void *ddp_ctx);
+
+The `ddp_ctx` parameter passed in `ddp_teardown_done` is the same on provided
+in `ulp_ddp_teardown` and it is used to carry some context about the buffers
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
+takes place, and packets are passed as-is to software. (resync is very similar
+to TLS offload (see documentation at
+:ref:`Documentation/networking/tls-offload.rst <tls_offload>`)
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
+software calls the NIC driver using the :c:member:`ulp_ddp_resync` function of
+the :c:type:`struct ulp_ddp_ops <ulp_ddp_ops>` inside the :c:type:`struct
+net_device <net_device>` while passing the same `seq` to confirm it is a PDU
+header.
+
+.. code-block:: c
+
+ void (*ulp_ddp_resync)(struct net_device *netdev,
+		       struct sock *sk, u32 seq);
+
+Statistics
+==========
+
+Per L5P protocol, the following NIC driver must report statistics for the above
+netdevice operations and packets processed by offload. For example, NVMe-TCP
+offload reports:
+
+ * ``rx_nvmeotcp_sk_add`` - number of NVMe-TCP Rx offload contexts created.
+ * ``rx_nvmeotcp_sk_add_fail`` - number of NVMe-TCP Rx offload context creation
+   failures.
+ * ``rx_nvmeotcp_sk_del`` - number of NVMe-TCP Rx offload contexts destroyed.
+ * ``rx_nvmeotcp_ddp_setup`` - number of DDP buffers mapped.
+ * ``rx_nvmeotcp_ddp_setup_fail`` - number of DDP buffers mapping that failed.
+ * ``rx_nvmeoulp_ddp_teardown`` - number of DDP buffers unmapped.
+ * ``rx_nvmeotcp_drop`` - number of packets dropped in the driver due to fatal
+   errors.
+ * ``rx_nvmeotcp_resync`` - number of packets with resync requests.
+ * ``rx_nvmeotcp_offload_packets`` - number of packets that used offload.
+ * ``rx_nvmeotcp_offload_bytes`` - number of bytes placed in DDP buffers.
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

