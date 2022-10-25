Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95B5460CE47
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 16:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232878AbiJYOEI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 10:04:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232447AbiJYODZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 10:03:25 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2045.outbound.protection.outlook.com [40.107.220.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABD2C194FA3
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 07:01:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OG/jKmqqTIRwkxqbZ096joufq2rJJi6iDq2zMKXzoFC7wDYFTLNPs2veH/5o9KTJOrpt006N5M9vWWnYfhY4sF5qUhmQGLXiNM7n3ec2JgYh8Dg5F5VW9ctqCwzgSde1g/684/ZLnQaNzLEhDr1iaKu0IWGlRah349WCCEscph0wq8DRsVeFNqY1A+xd3MmRMair3za09yN6lqFn/WN6T1Q5DKnpBYwx+FZCYwUQXUvDsk77VdI46SN5XsnI3GfEYP1ysAcZt3+Cvu+cOiFzCQ4mNnq74Qrv+mJBsNfI/M8D/ryunQ9EiA27gOBSDtkaUJhQ0HExytzlEwOc/z3ABg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=we5n+ywmb8W0OQ+PMMSsPl5D+Y/fiAa48spDNYTvvMU=;
 b=Ijwl1A+1FwMlCSetQ2Lvsch7IB+Ep2s3j6WqYM3pkTzzk9YQhZpWE4XWiMP+XoohS8LfswRcQ6hgIPItWqQBVskdRP2VSMGGavNVlcRLMH/qcEJ9oek6FfAwAL4XkGFTEklCeT8u0VJN+oimK8kXrrMEjmY2YGo8iSOruX11+PzSHl3Jb6erzKfWejE3/DvYBUSjSSmo+WoXN6SetSGk3rIiVnZzYA9ryBkAo6hYYyES6vH6OppMh2hKT8opQ5k5CF8k6RLCKja3aQIkROLLY2V4I7DAmZ42FP1uy1osrQKNccgX08rixAiDfQN4bRM0vN89fwp33qn233a0Pc8hkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=we5n+ywmb8W0OQ+PMMSsPl5D+Y/fiAa48spDNYTvvMU=;
 b=SLi9+bDnC3jzZrgIamazMhUU83YVvZyDNy3MzkcA6ScU2rnubdkG+3VbFpGahIKE+p5Ttvw7sl12lCAIbRyETxgfI5A3gZuJOEn0TAqfMemArnHXFwhlmpoo62KvqH07kCTK1P6oAqnwz8j3Z6F+NMJVCXqQKwozm5hqXlUDU5rNKfVsyKSg7HKAWvwUZvmYNwzut6ugBJyQzfj8O7f83HvhuG9tO6iTv8LSJ9ykwtuPH2NkItjJHHDoYJc9Ue6ncQlGvkDyMwEGbXthpX8aI1Bp0jkiM1Z7m8WSiol5jMTnP2I/F12KdK8rBWAngoTMMfSOshB+eQcSndiHhPTnbA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by PH7PR12MB6906.namprd12.prod.outlook.com (2603:10b6:510:1b8::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Tue, 25 Oct
 2022 14:01:04 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6713:a338:b6aa:871]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6713:a338:b6aa:871%3]) with mapi id 15.20.5746.028; Tue, 25 Oct 2022
 14:01:04 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, saeedm@nvidia.com,
        tariqt@nvidia.com, leon@kernel.org, linux-nvme@lists.infradead.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com
Cc:     smalin@nvidia.com, aaptel@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com, aurelien.aptel@gmail.com,
        malin1024@gmail.com
Subject: [PATCH v7 10/23] Documentation: add ULP DDP offload documentation
Date:   Tue, 25 Oct 2022 16:59:45 +0300
Message-Id: <20221025135958.6242-11-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221025135958.6242-1-aaptel@nvidia.com>
References: <20221025135958.6242-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0063.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4b::13) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|PH7PR12MB6906:EE_
X-MS-Office365-Filtering-Correlation-Id: ab26061e-ca03-4559-036b-08dab6915b6b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2AKrtVQkvbDtx0vIcliiKeTlmSRoaz8Bo6wLaQl3xeI1TqAbcrzGPt1RbVpJXKskNJr3fs1YnT/3Wwkrn3kYkuDltAssLP3ZxcqTrtcmLUVIc/L2wjqB5NAfJS0+wauAEfXBU0lKaXCwm6FjigUsbRfyVNpQrN6JYCOrVUGHFeBTRd2tmjeaE9+VtNS6sCn0eAM37HMB8L7xRdpG3mTRghmiuq0q9U1ZpezjGltVK3oorIQfCC5yDBvZHVaG0bC4+J71T5NI1T7ZRO6LqVuZrU3DH1zZCCH7PNmHOEgCcin1l7dKgnWlIXh5gt+CuajJL6r00CTHRDN7SboekdgGEjw2L12Gq6aMLU4qLDs52ZmEu78BMfCLKVmXyTtSObaX/+ZNEocVyP4iuuaAAuAT8q+p9E5/kGfGfyJgLAG6GV0f1VbFXZ90NG1M05sT03QWOQRgUed9gMkxhPKOegVjVCVB0s00XLPsV5zcMJM4+WsVjmB4R915dMlaZNSiVlYTshmJptZr0oLZMSMOX8WG8ePDNain8YCoEyiAdRldf+OOYMwph72hqROIqAgmrwDJPiaG1ISCq/OgamiIVSLC7OYyBdSK5Iavex4KcjXyDtecjOyIvoLiQreLg38Nbp8gnycbeKe5ye3cI7m1JLdKdK2EiFt4tqQOFJVD62q3CDr6SyXbae+c4E98qTc+3WX9W87kUH8jV8pxZYYpS/KJ21+u1kvw8YJZ142xzXLws1Cb/o4o1aGFYPHUWVmXj5bd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(376002)(396003)(346002)(136003)(451199015)(83380400001)(921005)(86362001)(7416002)(38100700002)(66556008)(30864003)(5660300002)(66476007)(66946007)(8936002)(4326008)(41300700001)(8676002)(2906002)(6666004)(6506007)(186003)(26005)(2616005)(1076003)(6512007)(6636002)(478600001)(316002)(36756003)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4JhneuN3pDTB6jTUj4gmJNJyjzwW8qUZG0hk/fSxhc/eJrolUfzt1XnBpH4p?=
 =?us-ascii?Q?o98OZLHuQt0LyZjvor3G3cih59nq8LK4tWt5hbq3SERn1b/MMnFt7nc3IJSz?=
 =?us-ascii?Q?7s1cZdaASzQc/ynLktgYASEaz4DlCS9nCrEPhB7P3yv30rPkDWeu/5fNKIG5?=
 =?us-ascii?Q?CwcEXr9udS5OJlbPVNcbTglzAx/gx9D567omZhqX771gx/egIs0n8NbIKTIB?=
 =?us-ascii?Q?TYMoD4K8+iF40empbDcLTb5WK1i+zjzkiIC4WOR22vng9PJ70WfSGj1Ue3LE?=
 =?us-ascii?Q?l0XzaiV8eD84ATPvZisjS7wDbtIXycZtB/2q33q9w3L3KU1ttzsNfIVkg0dY?=
 =?us-ascii?Q?JejaTxLdLSqFqrSgxuowYY9nlzjLuiAdyYIabW0KdFQGo6oN41Ks68Zapzki?=
 =?us-ascii?Q?2zPGqbnLJHnOckz2kUuhMXiCSncOZ/Qvvs4p5GuVYYrkTP8FkAmwRjEigxGK?=
 =?us-ascii?Q?LiAeYx67BpqYSXNFFw9TyybtDYUAj2FnluJX6ugP9KVYrZ8wYq/RjxPSYV9q?=
 =?us-ascii?Q?sSc7GFWTLp9C9t2olfvqvypmmZBrMAxcWbuz81Xl7rw32XZfT5QKwhYPp5UF?=
 =?us-ascii?Q?qEHYC3RkzizX++eNYd+nS3aitVvkYOjzXC2qJJ+RaGFUBxUZUFzM8O7CFaSB?=
 =?us-ascii?Q?uz+PM2i5ravQ4jn2cLrc+xFL2dByFSqc3xnwEsmNC04mTysigI8IXxe8plP7?=
 =?us-ascii?Q?uyx5UbsbaOwS24LJQhDPnD32BwR0NKn3NU+eFg89vR7/ovW6jYBuSSkYK7n3?=
 =?us-ascii?Q?sUMCQimsSzYH7XXO2TnzOublOf4EwDZF6ngsJPqZ4VJ6SyyUUjD10dQNha3y?=
 =?us-ascii?Q?6MGYWBe/Eo320RXj86PsEF8zmTLh0NiGLMjJGI9+1o1TFMxTFgODhkdv5EbO?=
 =?us-ascii?Q?Y7+upzRdzODfX+26D1zOqukuT0m8Br1NGWm2WKPEXo/UKkadZLwMt/DxjtzF?=
 =?us-ascii?Q?st9Go+CdglKQ6c+H/8ydlWmTl8iQlZxbgj7akF5HVkAvpziDanP5etqjXc5u?=
 =?us-ascii?Q?rJLEQOUa+wZ2p1s8nRgpEpj+wTwuVxmno3l8VH535QG6ahsGgSzqJrFZ5zhU?=
 =?us-ascii?Q?80GF78tHWXnAVEP7+XaeutmMs1S8HchPJk3fPs3y5umDW3pHlb1zfMmrnKnN?=
 =?us-ascii?Q?hXrtexMmUwfAOs03Z5fOCo+Cs42XPrYyZSAghMw5RzdAFg3L0AkymLyzgTgl?=
 =?us-ascii?Q?e/rVmdNb/U/keVm7r8n+gRkj3QvLA9vwcpQIVbmvsE/o5rYkcfTFeArqFote?=
 =?us-ascii?Q?IpwjdrzmRc82z0J30UNxK4OM1bevAZ2RVkPgvJWhsb3ah1ykfxA6cgyLoixy?=
 =?us-ascii?Q?Fq04QFdb2VWttLdek5oVbaukhTfrmQiopghOkVZWyvEXEUouos+156BloJsI?=
 =?us-ascii?Q?GRbZoUUEAuj+DU3Qzj07Hg/616qkkIWVmBBMJwHcgFJG5wZQQzMN3iG8fjVb?=
 =?us-ascii?Q?PChVD77x1XrNeH+EGgDxsPnEAt2mZ0nvzgA73vvoV1XNVbTpLCXva8GK3nBy?=
 =?us-ascii?Q?gpAJytTefqyEuaxrVAx9NchjAWpWm+CsRmsw0P2VrJxkk1DxXCdK7XH1Kidd?=
 =?us-ascii?Q?6RxLs+6Uv6MS4KU6dL9eJb+M32FJiTulagtCKzq5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab26061e-ca03-4559-036b-08dab6915b6b
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2022 14:01:04.7693
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 27PEW4v9y6BKYjmi3j1C7Hj5bdiVXRYUIAEPE5x6qjxMnthhUcA9eVWG4McGnXfBWg6nQ2u3wsW0YU+N81zztw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6906
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
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
 Documentation/networking/ulp-ddp-offload.rst | 368 +++++++++++++++++++
 2 files changed, 369 insertions(+)
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

