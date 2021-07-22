Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E8543D2266
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 13:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231566AbhGVKXm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 06:23:42 -0400
Received: from mail-co1nam11on2075.outbound.protection.outlook.com ([40.107.220.75]:6177
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231286AbhGVKXl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 06:23:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IEequTDt5ZLayfj6KBR2jNzX+FNsdFtTh2HDEcs+JuFTz2h2FJLm4BHmWTLDFnNWob2wA5ytO9jgE5H0bEUAaC9WJSRKBagbgg5a2QREK7HeHc9PD5igml43Vo5wwnaMbN0H4FJbc1mn50i45ojzofLX1HPTSBkHAeiRJBEowTPE7F7RQu0O9XbxGGIuIJWVlEM0Tgw8LAAHMyBPVTuJC9LDAggNu2OOVI+vp8XDAOZ244oGxGTpJ5mjr0hI4ZOMIcThb8fe58rmqLwz8VaytddgJBKxomUR09Zzs2EpwTj0VB3vamOO0By810I5ynVdHGW5Iv+faEyot9urbg8fTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qn8s5gaeKtsA02R+skdxLGrm9rIf8+33MKgMa9cb7bY=;
 b=j7UK6YQk6fCKqa0aKNnDRumhCiDm4q95onrLH8dprnrutUEGjwOsyu49evfKFgRpXxYi7m3bFHoc8WoA0GXX3DuFw3/OOlgY9o8/qiiYGxm//+VjjrW0o+U+1ZXfFDtKXRQO8woCnJkzWehEeFjErPWY8cYKs2rVCMdV12hRNZOicyYAFvl6ljCkSB2mTfCmSVwgHp8PH4h0mnhplru3+tUvQjQWzUhHVXjYfdE1G65QBjT6nK8ZungyTwbD7vAuN4SgMoXIjlDxgxN3oYztQvQ+xdiRMk0OYTC/mUYxEtyTQxu6xuwgojnyi/TtrEY/OeRlzS9T69Zavdpo5DGafA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=marvell.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qn8s5gaeKtsA02R+skdxLGrm9rIf8+33MKgMa9cb7bY=;
 b=oT9umydybrzqcByg55c9cJJeVeeHhPpR34/ViYEJlUaRKyQHRWmmNI0QLeDuEmUUrLa5nyUdfKZB4+RhBh4zrwNcP84ztq3dM5fT3orI1k5VWdHHkMjjT3ktEU0DlKXga0t0crvHWZtjHZDXJqAbYtbUXfu++Ui5ZaurCpxrJs6kluu+dMmzE9rGJFYrKF5ZXhq9r14jRiKhQvH8fbm5EIiCVkhJpydze3v3PgoUNPlTij4kD15GC2PH5uIKo9Fck5BunlkTHjVuM0kJqPAUJy/nWtt/roDxiOCHRJt5BXynnWUn90RSSKIg6hUHcLv06p9nJ9ku6Xj6td7DyLYTCg==
Received: from DM5PR19CA0041.namprd19.prod.outlook.com (2603:10b6:3:9a::27) by
 MW3PR12MB4396.namprd12.prod.outlook.com (2603:10b6:303:59::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4352.25; Thu, 22 Jul 2021 11:04:14 +0000
Received: from DM6NAM11FT032.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:9a:cafe::e5) by DM5PR19CA0041.outlook.office365.com
 (2603:10b6:3:9a::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25 via Frontend
 Transport; Thu, 22 Jul 2021 11:04:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 DM6NAM11FT032.mail.protection.outlook.com (10.13.173.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4352.24 via Frontend Transport; Thu, 22 Jul 2021 11:04:13 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 22 Jul
 2021 04:04:13 -0700
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 22 Jul 2021 11:04:08 +0000
From:   Boris Pismenny <borisp@nvidia.com>
To:     <dsahern@gmail.com>, <kuba@kernel.org>, <davem@davemloft.net>,
        <saeedm@nvidia.com>, <hch@lst.de>, <sagi@grimberg.me>,
        <axboe@fb.com>, <kbusch@kernel.org>, <viro@zeniv.linux.org.uk>,
        <edumazet@google.com>, <smalin@marvell.com>
CC:     <boris.pismenny@gmail.com>, <linux-nvme@lists.infradead.org>,
        <netdev@vger.kernel.org>, <benishay@nvidia.com>,
        <ogerlitz@nvidia.com>, <yorayz@nvidia.com>,
        Boris Pismenny <borisp@mellanox.com>
Subject: [PATCH v5 net-next 00/36] nvme-tcp receive and tarnsmit offloads
Date:   Thu, 22 Jul 2021 14:02:49 +0300
Message-ID: <20210722110325.371-1-borisp@nvidia.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 54ab7a6b-a0ea-44ac-7905-08d94d0070ed
X-MS-TrafficTypeDiagnostic: MW3PR12MB4396:
X-Microsoft-Antispam-PRVS: <MW3PR12MB43961A9B7802FF6F3DBAAB4CBDE49@MW3PR12MB4396.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ialqMjMyo2RBH9b9xW6CE0zVMzjAVh0YAe0woKEzMjwGZdoPW9kQxXuwsAhYHIOqGiNwWR8H9hx3ErKzdbfYvY93VqGuWk0vbr9Q8u86l0PAx2F+tj589AxXVPzHDAuOUlabuB6W+ojcNeln02PQOG/ToW2UmpkALKin4qdCa3bVKFr2ektsU4UOvqXhKdCYqy37lW+89vmH6TfRn4IP0EzXMEXd68KacHYTIVN1yyhp8ZKCS1lOruBQ4QMGu7TVSuOOYXewxYWrJBAcUld1qZXCr4tc0IlQ5+oOU9U9ujMMmA9y3vei2EpA+NSZO9rQhY2gGjCXhZpdy+T1p88RKMBPelM7dPWWmGf5xrW28S6lmVJNBVi6IJn9QlgsrtdReYors4UKwmP8wtYXDK0npJwjkVljDGFP+f+bY+S/0G6uUfCOU/wdwdJCY+5jQMpn1SKBreqWXmgMP6MJErANZvPX5PsWbhI2FS7IQFI+1vty9IKUUHCZ/NWLee0LjovMnlLlLaX5jVnrY/5Veh5I+p2Pnq73IWlgbndtuXcijYaF069/hNKJbZzdfzcJiOPJZgJDEvzC5Vrt2e6BcZ4ZKfQtADFNsb9MPM/T3lG8UEYkXMH0grstfdDVs20mG0qhnehLBerMgqw9ut3qmjd+CfY8UVSyLxZBtuTo0Nfqhz6303GBwZmPGjppTboPt5W+hullthScf1JYVBN02jCrKNvSRNdZ2nJV978y9a3pGzHr+Z/mFgpuXpdTvct7TIXna/alKN+4sh0MN0InTgfVfm2FitjDOQLL54EhI56e9Be/a0XnE/jlt5Gifb5S2wvj
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(136003)(346002)(376002)(39860400002)(46966006)(36840700001)(47076005)(107886003)(336012)(7696005)(2906002)(186003)(8676002)(82310400003)(82740400003)(7636003)(5660300002)(26005)(30864003)(921005)(4326008)(83380400001)(36756003)(1076003)(478600001)(966005)(70206006)(36860700001)(2616005)(86362001)(426003)(110136005)(316002)(8936002)(7416002)(54906003)(6666004)(356005)(70586007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 11:04:13.8386
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 54ab7a6b-a0ea-44ac-7905-08d94d0070ed
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT032.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4396
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Boris Pismenny <borisp@mellanox.com>

Changes since v4:
=========================================
* Add transmit offload patches
* Use one feature bit for both receive and transmit offload

Changes since v3:
=========================================
* Use DDP_TCP ifdefs in iov_iter and skb iterators to minimize impact
when compiled out (Christoph)
* Simplify netdev references and reduce the use of
get_netdev_for_sock (Sagi)
* Avoid "static" in it's own line, move it one line down (Christoph)
* Pass (queue, skb, *offset) and retrieve the pdu_seq in
nvme_tcp_resync_response (Sagi)
* Add missing assignment of offloading_netdev to null in offload_limits
error case (Sagi)
* Set req->offloaded = false once -- the lifetime rules are:
set to false on cmd_setup / set to true when ddp setup succeeds (Sagi)
* Replace pr_info_ratelimited with dev_info_ratelimited (Sagi)
* Add nvme_tcp_complete_request and invoke it from two similar call
sites (Sagi)
* Introduce nvme_tcp_req_map_sg earlier in the series (Sagi)
* Add nvme_tcp_consume_skb and put into it a hunk from
nvme_tcp_recv_data to handle copy with and without offload

Changes since v2:
=========================================
* Use skb->ddp_crc for copy offload to avoid skb_condense
* Default mellanox driver support to no (experimental feature)
* In iov_iter use non-ddp functions for kvec and iovec
* Remove typecasting in nvme-tcp

Changes since v1:
=========================================
* Rework iov_iter copy skip if src==dst to be less intrusive (David Ahern)
* Add tcp-ddp documentation (David Ahern)
* Refactor mellanox driver patches into more patches (Saeed Mahameed)
* Avoid pointer casting (David Ahern)
* Rename nvme-tcp offload flags (Shai Malin)
* Update cover-letter according to the above

Changes since RFC v1:
=========================================
* Split mlx5 driver patches to several commits
* Fix nvme-tcp handling of recovery flows. In particular, move queue offlaod
  init/teardown to the start/stop functions.

# Overview
=========================================
This series adds support for nvme-tcp receive and transmit offloads
which do not mandate the offload of the network stack to the device.
Instead, these work together with TCP to offload:
1. copy from SKB to the block layer buffers
2. CRC calculation and verification for received PDU

The series implements these as a generic offload infrastructure for storage
protocols, which we call TCP Direct Data Placement (TCP_DDP) and TCP DDP CRC,
respectively. We use this infrastructure to implement NVMe-TCP offload for copy
and CRC. Future implementations can reuse the same infrastructure for other
protcols such as iSCSI.

Note:
These offloads are similar in nature to the packet-based NIC TLS offloads,
which are already upstream (see net/tls/tls_device.c).
You can read more about TLS offload here:
https://www.kernel.org/doc/html/latest/networking/tls-offload.html

# Initialization and teardown:
=========================================
The offload for IO queues is initialized after the handshake of the
NVMe-TCP protocol is finished by calling `nvme_tcp_offload_socket`
with the tcp socket of the nvme_tcp_queue:
This operation sets all relevant hardware contexts in
hardware. If it fails, then the IO queue proceeds as usually with no offload.
If it succeeds then `nvme_tcp_setup_ddp` and `nvme_tcp_teardown_ddp` may be
called to perform copy offload, and crc offload will be used.
This initialization does not change the normal operation of nvme-tcp in any
way besides adding the option to call the above mentioned NDO operations.

For the admin queue, nvme-tcp does not initialize the offload.
Instead, nvme-tcp calls the driver to configure limits for the controller,
such as max_hw_sectors and max_segments; these must be limited to accomodate
potential HW resource limits, and to improve performance.

If some error occured, and the IO queue must be closed or reconnected, then
offload is teardown and initialized again. Additionally, we handle netdev
down events via the existing error recovery flow.

# Copy offload works as follows:
=========================================
The nvme-tcp layer calls the NIC drive to map block layer buffers to ccid using
`nvme_tcp_setup_ddp` before sending the read request. When the repsonse is
received, then the NIC HW will write the PDU payload directly into the
designated buffer, and build an SKB such that it points into the destination
buffer; this SKB represents the entire packet received on the wire, but it
points to the block layer buffers. Once nvme-tcp attempts to copy data from
this SKB to the block layer buffer it can skip the copy by checking in the
copying function (memcpy_to_page):
if (src == dst) -> skip copy
Finally, when the PDU has been processed to completion, the nvme-tcp layer
releases the NIC HW context be calling `nvme_tcp_teardown_ddp` which
asynchronously unmaps the buffers from NIC HW.

As the copy skip change is in a sensative function, we are careful to avoid
changing it. To that end, we create alternative skb copy and hash iterators
that skip copy/hash if (src == dst). Nvme-tcp is the first user for these.

# Asynchronous completion:
=========================================
The NIC must release its mapping between command IDs and the target buffers.
This mapping is released when NVMe-TCP calls the NIC
driver (`nvme_tcp_offload_socket`).
As completing IOs is performance criticial, we introduce asynchronous
completions for NVMe-TCP, i.e. NVMe-TCP calls the NIC, which will later
call NVMe-TCP to complete the IO (`nvme_tcp_ddp_teardown_done`).

An alternative approach is to move all the functions related to coping from
SKBs to the block layer buffers inside the nvme-tcp code - about 200 LOC.

# CRC receive offload works as follows:
=========================================
After offload is initialized, we use the SKB's ddp_crc bit to indicate that:
"there was no problem with the verification of all CRC fields in this packet's
payload". The bit is set to zero if there was an error, or if HW skipped
offload for some reason. If *any* SKB in a PDU has (ddp_crc != 1), then software
must compute the CRC, and check it. We perform this check, and
accompanying software fallback at the end of the processing of a received PDU.

# CRC transmit offload works as follows:
=========================================
The sending layer (e.g., nvme-tcp) sets the MSG_DDP_CRC when sending messages
down to TCP. Thereafter TCP will mark corresponding SKBs with the ddp_crc bit.
This ensures that CRC offload takes place for this packets, similarly to how
skb->decrtypted is used for TLS.

Additionally, nvme-tcp maintains a mapping between TCP sequence numbers
and PDU data which allows the driver to handle reordered/retransmitted
packet offload by resynchronizing the device's CRC state.

# SKB changes:
=========================================
The CRC offload requires an additional bit in the SKB, which is useful for
preventing the coalescing of SKB with different crc offload values. This bit
is similar in concept to the "decrypted" bit. 

# Performance:
=========================================
The expected performance gain from this offload varies with the block size.
We perform a CPU cycles breakdown of the copy/CRC operations in nvme-tcp
fio random read workloads:
For 4K blocks we see up to 11% improvement for a 100% read fio workload,
while for 128K blocks we see upto 52%. If we run nvme-tcp, and skip these
operations, then we observe a gain of about 1.1x and 2x respectively.

# Resynchronization:
=========================================
The resynchronization flow is performed to reset the hardware tracking of
NVMe-TCP PDUs within the TCP stream. The flow consists of a request from
the driver, regarding a possible location of a PDU header. Followed by
a response from the nvme-tcp driver.

This flow is rare, and it should happen only after packet loss or
reordering events that involve nvme-tcp PDU headers.

# The patches are organized as follows:
=========================================
Patches 1,3     the infrastructure for all TCP DDP.
                and TCP DDP CRC offloads, respectively.
Patch 2         the iov_iter change to skip copy if (src == dst).
Patch 4         exposes the get_netdev_for_sock function from TLS.
Patch 5         NVMe-TCP changes to call NIC driver on queue init/teardown.
Patches 6       NVMe-TCP changes to call NIC driver on IO operation.
                setup/teardown, and support async completions.
Patches 7       NVMe-TCP changes to support CRC offload on receive.
                Also, this patch moves CRC calculation to the end of PDU
                in case offload requires software fallback.
Patches 8       NVMe-TCP handling of netdev events: stop the offload if
                netdev is going down.
Patches 9-19    implement support for NVMe-TCP copy and CRC offload in
                the mlx5 NIC driver as the first user.
Patches 20      Document TCP DDP offload.
Patches 21-24   Net core support for transmit offload
Patches 25-26   NVMe-TCP transmit offload support 
Patches 27-36   Mellanox NVMe-TCP transmit offload support

Testing:
=========================================
This series was tested using fio with various configurations of IO sizes,
depths, MTUs, and with both the SPDK and kernel NVMe-TCP targets.
Also, we have used QEMU and gate-level simulation to verify these patches.

Future work:
=========================================
A follow-up series will introduce support for TLS in NVMe-TCP and combining the
two offloads.

Ben Ben-Ishay (8):
  net/mlx5e: NVMEoTCP offload initialization
  net/mlx5e: KLM UMR helper macros
  net/mlx5e: NVMEoTCP use KLM UMRs
  net/mlx5e: NVMEoTCP queue init/teardown
  net/mlx5e: NVMEoTCP async ddp invalidation
  net/mlx5e: NVMEoTCP ddp setup and resync
  net/mlx5e: NVMEoTCP, data-path for DDP+DDGST offload
  net/mlx5e: NVMEoTCP statistics

Ben Ben-ishay (2):
  net/mlx5: Header file changes for nvme-tcp offload
  net/mlx5: Add 128B CQE for NVMEoTCP offload

Boris Pismenny (8):
  net: Introduce direct data placement tcp offload
  iov_iter: DDP copy to iter/pages
  net: skb copy(+hash) iterators for DDP offloads
  net/tls: expose get_netdev_for_sock
  nvme-tcp: Add DDP offload control path
  nvme-tcp: Add DDP data-path
  net/mlx5e: TCP flow steering for nvme-tcp
  Documentation: add ULP DDP offload documentation

Or Gerlitz (1):
  nvme-tcp: Deal with netdevice DOWN events

Yoray Zack (17):
  nvme-tcp: RX DDGST offload
  net: drop ULP DDP HW offload feature if no CSUM offload feature
  net: Add ulp_ddp_pdu_info struct
  net: Add to ulp_ddp support for fallback flow
  net: Add MSG_DDP_CRC flag
  nvme-tcp: TX DDGST offload
  nvme-tcp: Mapping between Tx NVMEoTCP pdu and TCP sequence
  mlx5e: make preparation in TLS code for NVMEoTCP CRC Tx offload
  mlx5: Add sq state test bit for nvmeotcp
  mlx5: Add support to NETIF_F_HW_TCP_DDP_CRC_TX feature
  net/mlx5e: NVMEoTCP DDGST TX offload TIS
  net/mlx5e: NVMEoTCP DDGST Tx offload queue init/teardown
  net/mlx5e: NVMEoTCP DDGST TX BSF and PSV
  net/mlx5e: NVMEoTCP DDGST TX Data path
  net/mlx5e: NVMEoTCP DDGST TX handle OOO packets
  net/mlx5e: NVMEoTCP DDGST TX offload optimization
  net/mlx5e: NVMEoTCP DDGST TX statistics

 Documentation/networking/index.rst            |    1 +
 Documentation/networking/ulp-ddp-offload.rst  |  415 +++++
 .../net/ethernet/mellanox/mlx5/core/Kconfig   |   10 +
 .../net/ethernet/mellanox/mlx5/core/Makefile  |    2 +
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |   36 +-
 .../net/ethernet/mellanox/mlx5/core/en/fs.h   |    4 +-
 .../ethernet/mellanox/mlx5/core/en/params.c   |   11 +-
 .../ethernet/mellanox/mlx5/core/en/params.h   |    3 +
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h |   20 +-
 .../ethernet/mellanox/mlx5/core/en/xsk/rx.c   |    1 +
 .../ethernet/mellanox/mlx5/core/en/xsk/rx.h   |    1 +
 .../mellanox/mlx5/core/en_accel/en_accel.h    |   22 +-
 .../mellanox/mlx5/core/en_accel/fs_tcp.c      |   10 +
 .../mellanox/mlx5/core/en_accel/fs_tcp.h      |    2 +-
 .../mellanox/mlx5/core/en_accel/ktls_tx.c     |   16 +-
 .../mellanox/mlx5/core/en_accel/nvmeotcp.c    | 1555 +++++++++++++++++
 .../mellanox/mlx5/core/en_accel/nvmeotcp.h    |  138 ++
 .../mlx5/core/en_accel/nvmeotcp_rxtx.c        |  264 +++
 .../mlx5/core/en_accel/nvmeotcp_rxtx.h        |   43 +
 .../mlx5/core/en_accel/nvmeotcp_utils.h       |   80 +
 .../net/ethernet/mellanox/mlx5/core/en_main.c |   30 +-
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |   66 +-
 .../ethernet/mellanox/mlx5/core/en_stats.c    |   74 +
 .../ethernet/mellanox/mlx5/core/en_stats.h    |   47 +
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   |   11 +
 .../net/ethernet/mellanox/mlx5/core/en_txrx.c |   17 +
 drivers/net/ethernet/mellanox/mlx5/core/fw.c  |    6 +
 drivers/nvme/host/tcp.c                       |  567 +++++-
 include/linux/mlx5/device.h                   |   44 +-
 include/linux/mlx5/mlx5_ifc.h                 |  104 +-
 include/linux/mlx5/qp.h                       |    1 +
 include/linux/netdev_features.h               |    3 +-
 include/linux/netdevice.h                     |    5 +
 include/linux/skbuff.h                        |   13 +
 include/linux/socket.h                        |    1 +
 include/linux/uio.h                           |   17 +
 include/net/inet_connection_sock.h            |    4 +
 include/net/sock.h                            |   23 +
 include/net/ulp_ddp.h                         |  192 ++
 lib/iov_iter.c                                |   55 +
 net/Kconfig                                   |   10 +
 net/core/Makefile                             |    1 +
 net/core/datagram.c                           |   48 +
 net/core/dev.c                                |    2 +
 net/core/skbuff.c                             |    8 +-
 net/core/sock.c                               |    7 +
 net/core/ulp_ddp.c                            |  235 +++
 net/ethtool/common.c                          |    1 +
 net/ipv4/tcp.c                                |    6 +
 net/ipv4/tcp_input.c                          |    8 +
 net/ipv4/tcp_ipv4.c                           |    3 +
 net/ipv4/tcp_offload.c                        |    3 +
 net/tls/tls_device.c                          |   20 +-
 53 files changed, 4192 insertions(+), 74 deletions(-)
 create mode 100644 Documentation/networking/ulp-ddp-offload.rst
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_rxtx.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_rxtx.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_utils.h
 create mode 100644 include/net/ulp_ddp.h
 create mode 100644 net/core/ulp_ddp.c

-- 
2.24.1

