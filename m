Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E4FE66E26B
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 16:39:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231883AbjAQPjI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 10:39:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233850AbjAQPhx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 10:37:53 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2063.outbound.protection.outlook.com [40.107.93.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B62842BEA
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 07:37:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FXIWal+6iMlQRIPvOls5hF24ZwgYUJ4vCP2rrcaAjTPv2FsoFDk+aWRyHXBHtg3qFX1BFnNFttfHY4IkHOLx81JvrHnpQ94j14Yyn31Av76aCBx6ticVv3juxDJuPsHlTr4dcr0ODKaIpJxTjVpY7Xjn+8/KL8y+itXnIueCGR58LGm3PRC77Ruh9MRQv2j+Dzx5kWwcqRvU+9JXXPEPRPaw0G7nPFzz/CFTAFgxAhmHX5bjJDuu4MJXFaJXcaByK3/RFsLyZ3QYZ7m0a0CULULKy8uiZ0KlJJbWxiO/GEchRREwOTE+IAk1EL4wsMSY4rVC+CMe0PYh175x73Clag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ii+kBI0PDwK5sNzfpEXxYeoSfutmMd9kJ0mkOLSYp1w=;
 b=CAN/V8FGSLnycFzshIeruR5RgLd73SL5xkBrKFN+RMK3ZjvYTp3Z/Yt1qS3q/hJ9tKXIj1C+1hlMfSl9RI/QzWnCmMtvKAQDDwKrwtOOGBui60lGXwJFm3APZttCJ6mvyHSHuy23xEq4FCYDYGb+5VM3thO6HSS8RY4a12rs/qVS8HQlgLSmxeZFkyv3mXQ9WVtCf9fLGWVKbS1fZEU/9mBhBAKllwSiLM6DXSK/vZA3+/+C6Xzc9D6y4WvNA0THHGVgjeu9hQ9+evh8hk+YlutXpqtGNUMvW2vMZZ7kyK/A0PkGLi1Hq/SzfaXqyO1LuHowbWOK6HrWDbBYF6ng3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ii+kBI0PDwK5sNzfpEXxYeoSfutmMd9kJ0mkOLSYp1w=;
 b=nORaHm02/lmVAxKjmSl0qbBC250q6MfaM5gdkr+cPSnDEsPtGOOZ/a1/1UHw0fotLqVBN9R253ds0kNszqW02DVDO10NMvBx2thciKoG6DJ3tqfS+ReI7TLP4dIJvNVDzYvLNmgEq8cU8CDj1jespZHWWgXQKapGbEovPCtdquvCPNQYLFhRR/tvsXEvxcVj2+3umqQzmuUTodKSHqLXbWWHvKSja6QoUyqTNmXvdcL59fiEa1iDNStL5O+kq8KyPW/XfxPfN2bN+D2ZXOBg9kgyKZ9UdJir02HjMV5aooy9wAu4/tRdikmZZ9Cq7oRbGEuC4HciH/Y0L92v69XEdQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by PH8PR12MB6889.namprd12.prod.outlook.com (2603:10b6:510:1c9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Tue, 17 Jan
 2023 15:37:17 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70%8]) with mapi id 15.20.6002.013; Tue, 17 Jan 2023
 15:37:17 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     Yoray Zack <yorayz@nvidia.com>, Aurelien Aptel <aaptel@nvidia.com>,
        aurelien.aptel@gmail.com, smalin@nvidia.com, malin1024@gmail.com,
        ogerlitz@nvidia.com, borisp@nvidia.com
Subject: [PATCH v9 12/25] Documentation: add ULP DDP offload documentation
Date:   Tue, 17 Jan 2023 17:35:22 +0200
Message-Id: <20230117153535.1945554-13-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230117153535.1945554-1-aaptel@nvidia.com>
References: <20230117153535.1945554-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0104.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a1::20) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|PH8PR12MB6889:EE_
X-MS-Office365-Filtering-Correlation-Id: 797db2b7-5594-4968-8a2f-08daf8a0b6f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4qC23mBq+5PC7txVE5PcumJ8DEl9isxDo0kCfTzEw6o8X/vo1FRMalqFWbWdwM1DRWOn1AszWlBPQcpIyN6zvP4ZYgk0rqDy/LZvRuBAgdqaxYVPQJKII0NPTR1jJoR8rlSd4Ugk/eJuD8MdlsiyTtyTWdb6ypfJYJr2nMHm26kXYWOcxOmcSMXpzMa4u70HOun20+lg9NqK1y8xRmtk6Ag+m2gMi3mLfmqOKhzuqlhFR2lvrnb23toBlm4ANZsFhldYM7OBCp+KZS7si1mFi81mHxxjMBl1nUzLTKkDZs+yQfTkIuCqakpEXFCSMxpns05d3YWlEf5Q2omNF8OU9Z/ii1Ul0GxIZ3IplFJlJiv6EQPKdD8xGcSVje8vF9UeBeiwKqasemAwZ3XNuRYOnPHInvlzjIhCelGABu/eMIrwtnVUKWuYA/zKq33Sheof+GtzGdiWyBnhNKI9OKO+km8ZH2S2TqkP+ldAL5Oxj7xqprLwOH8oPSFuMJahdMcP5JnFk1+/I2au8RwekXIgatjT1/KSVA62UFIBdfT2Lxxea0SyQTpgx5IY5znpZHDmZEqsbfdS+457boQ9XPka/xtmosmG6PeMy39ZTQm8T3pGVlsFMSS7bClVKW32lfQLrsnF9UKN9r1aLC/pqW/8hg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(366004)(376002)(396003)(39860400002)(136003)(451199015)(2906002)(66946007)(26005)(4326008)(36756003)(8676002)(66476007)(66556008)(41300700001)(186003)(6512007)(1076003)(6666004)(107886003)(6506007)(2616005)(83380400001)(86362001)(316002)(54906003)(38100700002)(6486002)(478600001)(8936002)(30864003)(5660300002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3c8TrTqp0g5xlIFWGkjsU+PgNvg9UE6KL92Opr2VUuYSQMv+o7epLfqFQ9vx?=
 =?us-ascii?Q?XjDsSU6Z9Nv/loBcKF7oOtFa7sNyGuW8va893/BFVpn3UtQ6Hr8yQCjfCu6w?=
 =?us-ascii?Q?hTH1G3f8bS+3oXAGKLiyiv5sffQWPbm08qv31K5245RcWRDQEdtk9tep4Cn8?=
 =?us-ascii?Q?lXoQVvpA1kV36UG2bhb9/KK7mXx9FnXqdynMisKIcteOLh0ysB+H6ytD5qWK?=
 =?us-ascii?Q?9+zFsh30iLvtaE1pvJ6oUcv1WwYpe0jXcchI9a06iicCZOV3EQFbOkchPiLt?=
 =?us-ascii?Q?OYZxsYvNc/TvEjCz3uQvI03E8IMZBp7TNnxR2lasWuFCge54YSQ0xKzbqnxF?=
 =?us-ascii?Q?07ttij7Lf+yu5O+16USRzAp5lonBl9+t3qbubW0Ets10AxS/SKOLtSfOMQ9c?=
 =?us-ascii?Q?LbA9X2/ch6KFtv9YkfNySeCrkQAYdr0zrV+v+FxDMSSwWyQZktOjV+ukx06k?=
 =?us-ascii?Q?HDeWgplgfjOGM2uYT8ma8SXJYK1DiAj/oYbFhQT/ZMp5PTSC6qCOpwYn2ghk?=
 =?us-ascii?Q?sHc3oG/TWpLdia1e4leE3BuZZi8HOrTQ62zQF48mwyBa5rf9POSvapC2XCat?=
 =?us-ascii?Q?sa8EvdYkxTEbFcUovYpTwp8qCAMwVOkmlZqfJbkT93wCfQTtzVNOB5c0hmJ9?=
 =?us-ascii?Q?+S1ftgVVoxeQ+q/Exwwp9LT06agcf8QZKW3XDqj3JK+smqOPBrEaSik9r+cA?=
 =?us-ascii?Q?jb/CufhmGWcLfosf5gXxvSkhVDQT/HL086jcZzoSaStrE0OhTJ57Wc7Ia2PQ?=
 =?us-ascii?Q?MFR4GvEjihPeUYyC+gMUixjIm2RuXoggePC1tU4axdqcl15hxXE4IerN41Kq?=
 =?us-ascii?Q?4jNfwcOeNPVLeXa5zpyM6HD1nT8mO/d9oJhE4KTqD0R+4T4FFIFJg7XVTUr9?=
 =?us-ascii?Q?+Mad5N+evAVmOCnIaRCYDA08MeXSGJXzy0VOirygbWu7ltGDnK6Em1JlPX4M?=
 =?us-ascii?Q?L3EQI6XUe+bKhxBuCQiuQNrzgNEapS3lz/2xfP7RhL5WVXpMkQObzEsUGezf?=
 =?us-ascii?Q?Z4AXjJhyL1sF/GGEv9xHWIrMOa4HvVeq6cDjmVmNu1+ujxEPm0EBXbQ/cjPX?=
 =?us-ascii?Q?4cCT/+LKFOSBZbJgPdjgBQDa9yUblIbT3+SA/8qd2fXAE2JqK2BlntYlPa3T?=
 =?us-ascii?Q?n3/d6ZMUmCsnFx7L6ZueP+TkRx//ynqXh6Jf84uZ15k8HztWNN0ObC3fJRKh?=
 =?us-ascii?Q?MtaaR8WGDcrdDXA7ZopPnHcTXELHPhWyKWYp73FXa+1oIXXgMIgLzZgVX/LX?=
 =?us-ascii?Q?R7//LZNBMnuo0me7ljnQ7zT60q/xCwIt6sNchfI0RSkPOIjmwwgIJj+XnTj/?=
 =?us-ascii?Q?B0fOi8B7iWsDp88v3++t8sxivcbNtavqdSQv+01NPV88FbIEnP2W2XtgTA8B?=
 =?us-ascii?Q?djaLnBqKH5WCfoR2kgz8cOrXzKkCtOODGF/yLSvLTeKg7DZO733buaH2JhdS?=
 =?us-ascii?Q?JcziZ9K+Qh5hHq/VCj+DTUfghoFQiqCAJRHykGZgkWCf9mYAhfj0ZAGcwkdg?=
 =?us-ascii?Q?LW2K/IHqBlFQoihZBB3PFCR215b5c+UyB6ygAXn4ZslfmDvUzp1faty59SiB?=
 =?us-ascii?Q?Od7nEFeC75dcjhMms3h44AH40G67FAPW+Qetp6Wb?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 797db2b7-5594-4968-8a2f-08daf8a0b6f6
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 15:37:17.6131
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9vgJhQlBEUPudHXEIoMcP/xbNcVLEMBJaXHoKhuMbpYWgPNVezmog1w/MRfQsCSz6OwEMVDZCrWsCHYUCUYV0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6889
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
index 000000000000..01ba4ecb2216
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
+the :c:type:`struct ulp_ddp_ops <ulp_ddp_ops>` inside the :c:type:`struct
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

