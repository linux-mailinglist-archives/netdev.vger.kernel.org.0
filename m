Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A21813D227B
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 13:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231789AbhGVKZV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 06:25:21 -0400
Received: from mail-dm6nam10on2053.outbound.protection.outlook.com ([40.107.93.53]:13281
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231635AbhGVKZS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 06:25:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TcFEkcgFx1iuI6jCJv2stPejo+wNVaATGhANHDeYxeh6SpkqZVMaF4Q/58rifi+Vd8tcv2HF16hJDZ2pZdLIQF9D7pbaDCXt+aQiHIl7xfDt1qL3vFFZzAmejw86V4QNj3DoQvCQqoT21mOjp5MTmQInX4cZBI/qaLt4cJ7Sr+6In3C8uT0Eu85CBqnWZI1nsqGpq3Ui1EV3M3x36AjqxS7/UCNEYWbetU60Q5aRJnzAuMZNnmDzAoriMx5qo+IdVDo9HOHBmvfYvEI98K9cOjQrqFViBVytV2W96fKszHf0pEY9sIh2qQvv+gEVz+VVu9PU8MDY6iKx9MKM0MHfEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f9zgKlqMeNwmq8uZAGyRhF73sJg5UEMwSoT/sBqATis=;
 b=h8S//K6SSJtdEgDfVk+b3Tw7LaAU37yOn/YazepWKoTcGNiS1r2o0aW9ImpYJqTbIdVf5de90ndgR6ZRfx8HHGr2Ae7A+/+3FRkT0G74HE9/GQB0+IjxkztHSc/RveTpQzPv1UJhvAzIPIATMv3Yh8NDkTaoYNYGzG5seYwN6hb2MB10RTw/TC4zxkjbhj9udAfwk437m0sl3NXZo3V/pz/vryrUSnLEiuvniqiQpVudF7yu0izU2ggs28DXglNeQNp+rQsFBn4y1m3Zk0g4q/IcOmyS5yqWyYy3eHGpFsdju82rCfUb+/G+gBjEoGPHOH8s9FtuBzhG8FpdUFFomA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f9zgKlqMeNwmq8uZAGyRhF73sJg5UEMwSoT/sBqATis=;
 b=fMlheNTUERBZfiduXBq9CAbBkHEpdegts6qPzEsXPny4uUyGLKpewHRPQWZ2Gn4CL24o8VYkNeKAnB3FsI6wbs3izsnSDaY9H2aQQ3hfTuilya23WGwggspdMpaFvk+8BdEHEi5guNPpoBM0iUQPeJbIuXDqPSTQV8wvKEI/Nfylk8XAt9ui5dySH3jBQP7Ht3zM/rSdSeXQlleTr3x0ncmB5BHVpxss1s5gzIL/xQboriir8rG/D8VlXoN8GI4beHf+HythWbWU6LK6Cn52gjCoQP7+ZiAsonKO1fvAArYgDi3dGDJ7LTtTTX9+zEmpnxs/rxkX6PK5RGZLddLpig==
Received: from BN6PR1201CA0014.namprd12.prod.outlook.com
 (2603:10b6:405:4c::24) by BN8PR12MB3251.namprd12.prod.outlook.com
 (2603:10b6:408:9b::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25; Thu, 22 Jul
 2021 11:05:51 +0000
Received: from BN8NAM11FT065.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:4c:cafe::3e) by BN6PR1201CA0014.outlook.office365.com
 (2603:10b6:405:4c::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.24 via Frontend
 Transport; Thu, 22 Jul 2021 11:05:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT065.mail.protection.outlook.com (10.13.177.63) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4352.24 via Frontend Transport; Thu, 22 Jul 2021 11:05:51 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 22 Jul
 2021 11:05:50 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 22 Jul
 2021 11:05:50 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 22 Jul 2021 11:05:45 +0000
From:   Boris Pismenny <borisp@nvidia.com>
To:     <dsahern@gmail.com>, <kuba@kernel.org>, <davem@davemloft.net>,
        <saeedm@nvidia.com>, <hch@lst.de>, <sagi@grimberg.me>,
        <axboe@fb.com>, <kbusch@kernel.org>, <viro@zeniv.linux.org.uk>,
        <edumazet@google.com>, <smalin@marvell.com>
CC:     <boris.pismenny@gmail.com>, <linux-nvme@lists.infradead.org>,
        <netdev@vger.kernel.org>, <benishay@nvidia.com>,
        <ogerlitz@nvidia.com>, <yorayz@nvidia.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Ben Ben-Ishay <benishay@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yoray Zack <yorayz@mellanox.com>
Subject: [PATCH v5 net-next 20/36] Documentation: add ULP DDP offload documentation
Date:   Thu, 22 Jul 2021 14:03:09 +0300
Message-ID: <20210722110325.371-21-borisp@nvidia.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210722110325.371-1-borisp@nvidia.com>
References: <20210722110325.371-1-borisp@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cd700ee0-36d1-4f36-f8f1-08d94d00ab29
X-MS-TrafficTypeDiagnostic: BN8PR12MB3251:
X-Microsoft-Antispam-PRVS: <BN8PR12MB325151BCA15C7D4CB4A8E8A2BDE49@BN8PR12MB3251.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xj6GLDDfQ0rcpXJwvdONXcZdnAKg/IHggwCzJtzQzY2KTfiKCEaU2kUpSqvDO0WE5qytMs5ymiFJbplsKgXD2kseP4NCuO5BYCXdONy6BH/vuiZtSk8oeUcCmt9QhQqzu8YFD+sRoJrziU8gz3ar3iDQ4w/fu/WbDggdfxTtMByampn6tYALanDoGh1pl0IBsIfLAgMUwX97+pIplwotugou+O0CGWQX4XkDlHe4a5UGNIkA8Fwlku+EUWWavu2kpZ+OgXuNgaEUNOQw6ZyB9rB6rv1ZIF4NDlzcIhk/TIouLq2NVYMF/uE4WRol6nTw11giZQuiTVlcvt6ZHul2VNESyK09FLfMd5lgvs93W70OJ2qG1o58cTbmyJm8AyQL43ghW/REV+zpWrq9ozDQxlfZW+JnLJDmdZSnZTqTfijWtAHsygLfQHhlx5q+CYtv0IUwgCm+DSOAoVWvddRcCJTuu/aQunSJ5f+2kZeGDjZqK2XYdS51mjcxsx7Cs3aP24KbQTQxzI4WJvsVGdOIJ0LlOGzZfdJCUnZc9KNholfqhOGAo9hMAwHaFoFosyx0h86Ul2ih6V6JiS24Xqb4489fyzhhhv3oZOo+RV8FRMyLKBoAyM/T9RgZYftajnJtvNDWuZqqdy/JmmiRakIa5Tlxm5ANvM7FG882vPYXOMqhVKTnET1ISKgkUXUGwU/fjqD82uKSFB6WHZEtm7EbqG/PEoheO0j64GWn7BBXCEQ=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(39860400002)(346002)(376002)(396003)(36840700001)(46966006)(83380400001)(1076003)(5660300002)(82740400003)(107886003)(186003)(316002)(7636003)(356005)(8936002)(26005)(82310400003)(6666004)(426003)(921005)(30864003)(7416002)(336012)(2906002)(47076005)(70586007)(86362001)(36860700001)(8676002)(70206006)(478600001)(7696005)(2616005)(110136005)(36756003)(4326008)(54906003)(36906005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 11:05:51.4420
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cd700ee0-36d1-4f36-f8f1-08d94d00ab29
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT065.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3251
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Boris Pismenny <borisp@mellanox.com>

Signed-off-by: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: Ben Ben-Ishay <benishay@mellanox.com>
Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Yoray Zack <yorayz@mellanox.com>
---
 Documentation/networking/index.rst           |   1 +
 Documentation/networking/ulp-ddp-offload.rst | 415 +++++++++++++++++++
 2 files changed, 416 insertions(+)
 create mode 100644 Documentation/networking/ulp-ddp-offload.rst

diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index e9ce55992aa9..87c08683e006 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -100,6 +100,7 @@ Contents:
    sysfs-tagging
    tc-actions-env-rules
    tcp-thin
+   ulp-ddp-offload
    team
    timestamping
    tipc
diff --git a/Documentation/networking/ulp-ddp-offload.rst b/Documentation/networking/ulp-ddp-offload.rst
new file mode 100644
index 000000000000..a7f1584defa2
--- /dev/null
+++ b/Documentation/networking/ulp-ddp-offload.rst
@@ -0,0 +1,415 @@
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
+bypasses responses to larger requests, i.e., read 4KB bypasses read 1GB.
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
+The driver builds SKB page fragments that point destination buffers.
+Consequently, SKBs represent the original data on the wire, which enables
+*transparent* inter-operation with the network stack.To avoid copies between 
+SKBs and destination buffers,the layer-5 protocol (L5P) will check 
+``if (src == dst)`` for SKB page fragments,success indicates that data is 
+already placed there by NIC hardware and copy should be skipped.
+
+In addition, L5P might have DDGST that responsible for ensure no-error over the
+network. If not offloded, ULP DDP might be not efiant as L5P will need to go 
+over the data and calculate it by himself, redundet DDP copy skip.
+ULP DDP have support for Rx/Tx DDGST offload. On the recived side the NIC will 
+verify DDGST for recived pdus and update SKB->ddp_crc bit if so. 
+If all SKB constructing L5P pdu have ddp_crc on, L5P will skip on calculating 
+and verify the DDGST for the correspond pdu. On the Tx side, the NIC will be 
+responsible for calculating and fill the DDGST fields in the sent pdus.
+
+Offloading does require NIC hardware to track L5P protocol framing, similarly
+to RX TLS offload (see documentation at
+:ref:`Documentation/networking/tls-offload.rst <tls_offload>`).  NIC hardware
+will parse PDU headers extract fields such as operation type, length, ,tag
+identifier, etc. and offload only segments that correspond to tags registered
+with the NIC, see the :ref:`buf_reg` section.
+
+Device configuration
+====================
+
+During driver initialization the device sets the ``NETIF_F_HW_ULP_DDP`` and
+feature and installs its
+:c:type:`struct ulp_ddp_ops <ulp_ddp_ops>`
+pointer in the :c:member:`ulp_ddp_ops` member of the
+:c:type:`struct net_device <net_device>`.
+
+Later, after the L5P completes its handshake offload is installed on the socket.
+If offload installation fails, then the connection is handled by software as if
+offload was not attempted. Offload installation should configure
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
+fallback to normal non-offloaded operation.  The `config` parameter indicates
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
+  *              The netdev will offload crc if ddp_crc is supported.
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
+When offload is not needed anymore, e.g., the socket is being released, the L5P
+calls :c:member:`ulp_ddp_sk_del` to release device contexts:
+
+.. code-block:: c
+
+ void (*ulp_ddp_sk_del)(struct net_device *netdev,
+		        struct sock *sk);
+
+TX
+--
+
+To request Tx offload for a socket `sk`, the L5P calls
+:c:member:`ulp_ddp_int_tx_offload`:
+.. code-block:: c
+    int ulp_ddp_init_tx_offload(struct sock *sk);
+
+When Tx offload is not needed anymore, e.g., the socket is being released, 
+the L5P calls :c:member:`ulp_ddp_release_tx_offload` to release device 
+contexts:
+
+.. code-block:: c
+    void ulp_ddp_release_tx_offload(struct sock *sk);
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
+NICs should not assume any correlation between PDUs and TCP packets.  Assuming
+that TCP packets arrive in-order, offload will place PDU payload directly
+inside corresponding registered buffers. No packets are to be delayed by NIC
+offload. If offload is not possible, than the packet is to be passed as-is to
+software. To perform offload on incoming packets without buffering packets in
+the NIC, the NIC stores some inter-packet state, such as partial PDU headers.
+
+RX data-path
+------------
+
+After the device validates TCP checksums, it can perform DDP offload.  The
+packet is steered to the DDP offload context according to the 5-tuple.
+Thereafter, the expected TCP sequence number is checked against the packet's
+TCP sequence number. If there's a match, then offload is performed: PDU payload
+is DMA written to corresponding destination buffer according to the PDU header
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
+TX data-path
+------------
+
+In DDGST Tx offload the DDGST calculation isn't performed in the ULP (L5P).
+Instead packets reach a device driver, the driver will mark the packets                                                                                                                                            
+for DDGST offload based on the socket the packet is attached to,                                                                                                                                                  
+and send them to the device for DDGST calculation and transmission.
+
+Both the device and the driver maintain expected TCP sequence numbers
+due to the possibility of retransmissions and the lack of software fallback
+once the packet reaches the device.
+For segments passed in order, the driver marks the packets with
+a connection identifier and hands them to the device. 
+The device identifies the packet as requiring DDGST offload handling and 
+confirms the sequence number matches its expectation. The device performs
+DDGST calculation of the pdu data. 
+It replaces the PDU DDGST and TCP checksum with correct values.
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
+The `seq` field contains the TCP sequence of the last byte in the PDU header.
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
+
+TX
+--
+
+Segments transmitted from an offloaded socket can get out of sync
+in similar ways to the receive side-retransmissions - local drops
+are possible, though network reorders are not. There is currently
+one mechanism for dealing with out of order segments.
+
+Offload state rebuilding
+~~~~~~~~~~~~~~~~~~~~~~~
+
+Whenever an out of order segment is transmitted the driver provides
+the device with enough information to perform DDGST offload.
+This means most likely that the part of the pdu preceding the current
+segment has to be passed to the device as part of the packet context,
+together with its TCP sequence number. The device can then initialize its 
+offload state, process and discard the preceding data (to be able to insert 
+the DDGST value) and move onto handling the actual packet.
+For doing so, L5P should map PDU and TCP sequnce number using  
+
+Depending on the implementation the driver can either ask for a continuation 
+with the offload state and the new sequence number (next expected segment is 
+the one after the out of order one), or continue with the previous stream 
+state - assuming that the out of order segment was just a retransmission.
+The former is simpler, and does not require retransmission detection therefore 
+it is the recommended method until such time it is proven inefficient.
+
+For doing so, L5P should map PDU and TCP sequnce number using:
+
+.. code-block:: c
+    int ulp_ddp_map_pdu_info(struct sock *sk, u32 start_seq, void *hdr,
+			 u32 hdr_len, u32 data_len, struct request *req);
+    void ulp_ddp_close_pdu_info(struct sock *sk);
+
+While the driver can recived pdu information from ulp by calling:
+.. code-block:: c    
+    struct ulp_ddp_pdu_info *ulp_ddp_get_pdu_info(struct sock *sk, u32 seq);
+    
+Statistics
+==========
+
+Per L5P protocol, the following NIC driver must report statistics for the above
+netdevice operations and packets processed by offload. For example, NVMe-TCP
+offload reports:
+
+ * ``rx_nvmeotcp_queue_init`` - number of NVMe-TCP Rx offload contexts created.
+ * ``rx_nvmeotcp_queue_teardown`` - number of NVMe-TCP Rx offload contexts
+   destroyed.
+ * ``rx_nvmeotcp_ddp_setup`` - number of DDP buffers mapped.
+ * ``rx_nvmeotcp_ddp_setup_fail`` - number of DDP buffers mapping that failed.
+ * ``rx_nvmeoulp_ddp_teardown`` - number of DDP buffers unmapped.
+ * ``rx_nvmeotcp_drop`` - number of packets dropped in the driver due to fatal
+   errors.
+ * ``rx_nvmeotcp_resync`` - number of packets with resync requests.
+ * ``rx_nvmeotcp_offload_packets`` - number of packets that used offload.
+ * ``rx_nvmeotcp_offload_bytes`` - number of bytes placed in DDP buffers.
+ * ``tx_nvmeotcp_offload_packets`` - number of Tx packets that used 
+   DDGST offload.
+ * ``tx_nvmeotcp_offload_bytes`` - number of Tx bytes that used                                                                                                                                                
+      DDGST offload. 
+ * ``tx_nvmeotcp_ooo`` - number of TX Out of order packets.
+ * ``tx_nvmeotcp_dump_packets`` - number of Dump packets sent to the NIC for
+   sync on OOO context.
+ * ``tx_nvmeotcp_dump_bytes`` - number of Dump bytes sent to the NIC for                                                                                                                                       
+      sync on OOO context.
+ * ``tx_nvmeotcp_resync`` - number of resync opertion due to out of order 
+   packets                                                                                                                                        
+ *  ``tx_nvmeotcp_ctx`` - number of NVMe-TCP Tx offload contexts created.
+ *  ``tx_nvmeotcp_resync_fail``: number of resync opertion that failed.
+ *  ``tx_nvmeotcp_no_need_offload`` - number of OOO packet that not needed
+   offlaod 
+ *  ``tx_nvmeotcp_no_pdu_info`` - number of OOO packet that dontt have 
+   pdu-info.                                                                                                                                        
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
+
+Error handling
+==============
+
+TX
+--
+
+Packets may be redirected or rerouted by the stack to a different
+device than the selected ULP DDP offload device. The stack will handle
+such condition using the :c:func:`sk_validate_xmit_skb` helper
+(ULP DDP code installs :c:func:`ulp_ddp_validate_xmit_skb` at this hook).
+Offload maintains information about all pdu until the data is fully 
+acknowledged, so if skbs reach the wrong device they can be handled 
+by software fallback.
+
+Any ULP DDP device handling error on the transmission side must result
+in the packet being dropped. For example if a packet got out of order
+due to a bug in the stack or the device, reached the device and can't
+be DDGST ofloaded, such packet must be dropped.
+
-- 
2.24.1

