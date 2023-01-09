Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ECB4662727
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 14:34:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236362AbjAINdo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 08:33:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237011AbjAINcx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 08:32:53 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2043.outbound.protection.outlook.com [40.107.94.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86A151EEFD
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 05:32:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hu8whkleXke5GCC82FWn9Hs04SWy66pzNbH1vu7ePaVjcr/fRIAQbTY1MMQ1g9mDY2dcEQX6eOZZT/WgCfVt6PnFjvimcfEgZGr25q62jxEZ0TpRhtIvst4fHAQhpNRMMSc1P3rkqSvL9MPTLv7DCZf0JfAGOxShCkxL3WCf3q9h3O9ix2FfnJZPss2nIrPnHVplWVTEaqAR0MoLaVmlT7KAO+SbwckaMWaIqxPhS/fcNOlBYc2J8WtmreDYiSYmHwuQDxzPK7wrUtp8W8cGNfEBqEgWAPZWK/SDk1TFSZxoV9/9P2MxheNlewt2U23Kin8IsmJzwAcO9kjXzhVyaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HuMfodZNYR0aFM7mfM2xv1MuXnLz/wv5Dfr9Yrcq7ds=;
 b=BEE9LjSG94KtaW4PLnu+5irzBgcuhHyKdre35pLlZhx8MhcGOh4PLkeQXgy6hqfxCI7ZmwD1bTxTLsFDZOVzI4OX5iWxTwVYd5q+pb3s/HHhB8Z7OEbDEnpK+L/mIEEWXA79b2fEHOyoHaIrEs4+XGDC1ZbUt9bEx1/lgcOpCElnxULE+nJtM/0nfC33tgrCweFH/W8LLhKTgAdRnveewk2/o5MrY/ydnap+Z4nit3lWCtVuHaVe5VhPB26OzbI2/f7x9SRavuKCWxRwjRCaU9DC9hNLhTAcvlDSPdgPNfcUqsrRPY2XzapBz8EE0X+cL1uzBslMFeDPkBibd+/unQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HuMfodZNYR0aFM7mfM2xv1MuXnLz/wv5Dfr9Yrcq7ds=;
 b=XnN7BTP1HsKZImYoX6BayM1LFS+7Xxe1T5A/Gkv2cdBTGkhTjkw5nKCCI4hXYIirF1TFv4WHeFHQ5Z8C6y4OJOMmlaWPrzFzPvNTjpaXR76YryGTRIeWUFFnDNCDx6z3c4k4w2VVgxRs9sfVkPwOZIGt5Hl0Q14KTcaH74zzlNIlDMlMnTVjTEZ1gqyqEbSmzRehaYHBcqTFEXO2nWM1sDQiKqOh52xXYNJrGkov7GBAy8nfSkJGWpYjC8d4tBIU32Iilv0R+cNn8ZR3l2JmI0zKl192JV7zeAYcLhkPqMf2mYQVuoVV7tw6p4PdIdPXxO8+KyWCxehZhoGVBPnzsg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by DM4PR12MB5056.namprd12.prod.outlook.com (2603:10b6:5:38b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Mon, 9 Jan
 2023 13:32:42 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70%6]) with mapi id 15.20.5986.018; Mon, 9 Jan 2023
 13:32:42 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     Yoray Zack <yorayz@nvidia.com>, Aurelien Aptel <aaptel@nvidia.com>,
        aurelien.aptel@gmail.com, smalin@nvidia.com, malin1024@gmail.com,
        ogerlitz@nvidia.com, borisp@nvidia.com
Subject: [PATCH v8 12/25] Documentation: add ULP DDP offload documentation
Date:   Mon,  9 Jan 2023 15:31:03 +0200
Message-Id: <20230109133116.20801-13-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230109133116.20801-1-aaptel@nvidia.com>
References: <20230109133116.20801-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0573.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:276::6) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|DM4PR12MB5056:EE_
X-MS-Office365-Filtering-Correlation-Id: 84fb0502-7c97-4499-a6a9-08daf245fc6a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pQ/2g9m6Jqt2kCXTzwiY1nbmlmJAQkki42r5s+4rJVY0k5UgZ+QudwJsB5ml/feUfQy26p8tpqYiGfcs+DNgSm3ucBZuUI/kRCPK0JaSYPaT1zXZRX13loP7AnUBypRBEnZTDzW8KhXHKFe9O99CNhDq6vxAaSe5dNGCZwLTyPPIzifS3fmWvykKIQFue1JXllpTH7AhExvNrzhb8IjznJV4YOraHvjlojd8TpIyHJdTgbzOchL9J8s/C2zxwmq7vOmLCdlxxj0iOs/zLq8Kfv02hRArvRiczhESEQ2LB3FoL8jRQbuRHrkwqbp6yJNpUVLgDnu8ww58puSaa5x0l3IjgYOAq6rh30+Q/fHodvq1IiITwi/p5pqHOV0s//4LIU2/67Xbqj4CN0lcmK6YzFGe1K64sYnjvj7mTorcOSSY5KH75dML+MMc4a/RtJK/jzDOcgfVLCPGajGvMALGz4QXV1W5QzfijDPM+3Hrlu1UM+u+gmi0KQuN2PUZtwRpnwkOfyQWppLFwNjGV31PtS4LJy/Mhu87TC/2niOMT632JHYriKkisUuCHFhdXG5yCcC5BdSDb0TgILVnbi8OHAmlqRM52BSw2VZD024jXWMpXCX/hcJX8WuxBbbiND/097Q4CFcCeSc/d6P3N+0jmg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(39860400002)(136003)(346002)(366004)(451199015)(2906002)(83380400001)(54906003)(1076003)(2616005)(66476007)(7416002)(66556008)(5660300002)(66946007)(6666004)(107886003)(26005)(186003)(36756003)(8936002)(30864003)(6506007)(6512007)(478600001)(38100700002)(8676002)(41300700001)(6486002)(86362001)(4326008)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Huh++CNC3KTsdXjk6qYG5eS0bREAQHQLEyN71eMDonPTZkQfJytejCRkXUdT?=
 =?us-ascii?Q?2PnSdoG1RCjMO43cyfdITIf0dXhDsWRC9GEm0C1Zyu0olZmONZwuTJzfFNWJ?=
 =?us-ascii?Q?g7dzdBaaOUYBhzNrtxeANsbDv+NsXS7T6TaDzFPDb0n0O34Medsriur3CzN9?=
 =?us-ascii?Q?MOJdh8qhpsG2W0YrSrj1d38y+1KgM0qQBVOVLBK8t+LPzM/Dl2zCXrJtGA73?=
 =?us-ascii?Q?+pd3MnTXYAQUMqbq9ApE/c5UncKeBPykIuEGjhuJGqN6WZlCZScj+Ez8jK8X?=
 =?us-ascii?Q?qaIhXjO9EeWaSqoxnNGMNJRn/Vj5vbPcAst6e9ozxpzc3cCjRtCuHqqGXp0a?=
 =?us-ascii?Q?JeGnKukFFQnbQWHh0vbfYeXqlDURv9LxewPjtpBI0kBde7a/Pk7lyTrryWaM?=
 =?us-ascii?Q?R1i9Z+p6rNi0x+H8YWrFn3VFaPpJSijbpKf+Ow74XasoMyXGdR5+JHBpF1RT?=
 =?us-ascii?Q?l6F4hCQMPaAVOR73ox3EeABbe3s0QxkTlgkYy6hs/2mIyBKqaXhksoe/tl2G?=
 =?us-ascii?Q?LMsP9oCfoB+k86MD4EMhN5z736vkz2j/JCNgIzw6nlK/tPC5YSP5BeNXST3n?=
 =?us-ascii?Q?PevCZklwynd0w1F/55fD0eeV6svWUDqXLrFrCnf76KdV1pT06BmXAUDDgIWU?=
 =?us-ascii?Q?g02VMF/uhmtx7esq/uWh458w6H833yrbAQ4oBSi/ToJDc42Iqa4aJlO3Evyf?=
 =?us-ascii?Q?/r8NdkuPeFn0nGXIfd1JQJST4SKlLW0bbXwNMC44Lka/jHvIFz4j+Hg1hRxE?=
 =?us-ascii?Q?4sKL0d3ippjOW3+4Xb3uxNrMGb56y1NZtEFo0MhM194FYwm/KwOY1zoFOhwb?=
 =?us-ascii?Q?4Qx+UZytcPSHpaUXb7wW9BNWz/nGlZYrqBFT00hDuUKu/NPxZ83Q1Q0ZHZ7j?=
 =?us-ascii?Q?O3+SfxiAV+zJGIUN8fyPa50zqx08+RfLYvtIh4LTpuRmNxhfWWgkYZKAoax1?=
 =?us-ascii?Q?/6G1REqdCDJ7BOWgXIFSmwY/b1H1NMgFezsMi/3FiqQO00Tan4lH6AUMls3W?=
 =?us-ascii?Q?J+cuTXZxoOHTrHAU9WJj0sgEqmnJ2rMTOMiyH8UvK1X7e7Sm73UHD9GgJ3kG?=
 =?us-ascii?Q?9PZmrsfWE/Bf41D9skoMNRV0TVbRA3MNHbE45Ntx8DuxyzeTxFH7g99CKuyX?=
 =?us-ascii?Q?G7DDdfoQM5FldXG6y6MoRTlJ/OXDzok5edqtxuX7KDdgaiHsI6IrM4KuVC6Q?=
 =?us-ascii?Q?FMx6WZ+Zw79t9BlKwhKKlH4t33caFXPK6LmsimniFYb5Y+sz6FRmqVxefibj?=
 =?us-ascii?Q?MQS0wLlbS6mM/1a5FTatAtdBqFvV4KfUhp+b0qBVqtBd89RlVpMdG8CS5Nuo?=
 =?us-ascii?Q?q9+bnMB3ipvaBm2qCi7eEslwEdkL1qbJSC9RaeHy7QgdgDeRg4KinL1F/lXo?=
 =?us-ascii?Q?5/O7jMKioJGWqgvBE6UoAiydp55lRiCvslpfs03xG1Eun73maMfGWs2j5m8d?=
 =?us-ascii?Q?3mMACcU2ZL7QYlWLJOrxqgracTefymeQUZ3rm6BKWadfgcsgpoXk97LPm3MT?=
 =?us-ascii?Q?r7MbcGfQy4pLoSsgSyBBM9zAuRVHNITuC5f1M68PqQjggzNB/50Y1Zl8RbN0?=
 =?us-ascii?Q?Irx4zeNFwjQdjZSQG1CRUzDYDZNtc3Q/TlC6eLVQ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84fb0502-7c97-4499-a6a9-08daf245fc6a
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2023 13:32:42.8484
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /8wH6Gfi4Ls3IalVfvXNOFZRTYKvqMPzYpnTmNO9OfOHg2lH+z+kxpVQYdI5n6Tih4AVnbDyBbkfGE3mMQUffA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5056
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
 Documentation/networking/index.rst           |   1 +
 Documentation/networking/ulp-ddp-offload.rst | 374 +++++++++++++++++++
 2 files changed, 375 insertions(+)
 create mode 100644 Documentation/networking/ulp-ddp-offload.rst

diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 4f2d1f682a18..10dbbb6694dc 100644
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
index 000000000000..55a16662938b
--- /dev/null
+++ b/Documentation/networking/ulp-ddp-offload.rst
@@ -0,0 +1,374 @@
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
+The current list of capabilities is:
+
+.. code-block:: c
+
+ enum ulp_ddp_offload_capabilities {
+	ULP_DDP_C_NVME_TCP = 1,
+	ULP_DDP_C_NVME_TCP_DDGST_RX = 2,
+ };
+
+The enablement of capabilities can be controlled from userspace via
+netlink. See Documentation/networking/ethtool-netlink.rst for more
+details.
+
+Later, after the L5P completes its handshake, the L5P queries the
+driver for its runtime limitations via the :c:member:`ulp_ddp_limits` operation:
+
+.. code-block:: c
+
+ int (*ulp_ddp_limits)(struct net_device *netdev,
+		      struct ulp_ddp_limits *limits);
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
+buffers the L5P calls :c:member:`ulp_ddp_teardown` of :c:type:`struct
+ulp_ddp_ops <ulp_ddp_ops>`:
+
+.. code-block:: c
+
+ void (*ulp_ddp_teardown)(struct net_device *netdev,
+			  struct sock *sk,
+			  struct ulp_ddp_io *io,
+			  void *ddp_ctx);
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

